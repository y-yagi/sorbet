#include <ruby.h>
#include <ruby/intern.h>

#include <errno.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>

#include "file_format.h"
#include "mmap.h"
#include "value_access.h"

#include "utils.h"

static void close_file(mm_ipc *i_mm) {
    close(i_mm->t->fd);
    i_mm->t->fd = -1;
}

static int open_and_extend_file(mm_ipc *i_mm, size_t len) {
    if (i_mm->t->fd < 0) {
        int fd;

        if ((fd = open(i_mm->t->path, i_mm->t->smode)) == -1) {
            return with_exception_errno(rb_eArgError, "%s: Can't open %s", __FILE__, i_mm->t->path);
        }
        i_mm->t->fd = fd;
    }

    if (lseek(i_mm->t->fd, len - 1, SEEK_SET) == -1) {
        close_file(i_mm);
        return with_exception_errno(rb_eIOError, "Can't lseek %zu", len - 1);
    }

    if (write(i_mm->t->fd, "\000", 1) != 1) {
        close_file(i_mm);
        return with_exception_errno(rb_eIOError, "Can't extend %s", i_mm->t->path);
    }
    i_mm->t->len = len;

    return SUCCESS;
}

static int perform_munmap(mm_ipc *i_mm) {
    if (i_mm->t->addr != NULL && munmap(i_mm->t->addr, i_mm->t->len)) {
        i_mm->t->addr = NULL;
        return with_exception_errno(rb_eArgError, "munmap failed");
    }

    i_mm->t->addr = NULL;
    i_mm->t->len = 0;
    i_mm->t->real = 0;

    return SUCCESS;
}

static int perform_mmap(mm_ipc *i_mm, size_t len) {
    MMAP_RETTYPE addr = mmap(0, len, i_mm->t->pmode, i_mm->t->vscope, i_mm->t->fd, i_mm->t->offset);

    if (addr == MAP_FAILED) {
        return with_exception_errno(rb_eArgError, "mmap failed");
    }

    i_mm->t->addr = addr;
    i_mm->t->len = len;
    i_mm->t->real = len;

    return SUCCESS;
}

static int expand(mm_ipc *i_mm, size_t len) {
    if (len < i_mm->t->len) {
        return with_exception(rb_eArgError, "Can't reduce the size of mmap");
    }

    if (!perform_munmap(i_mm)) {
        return FAILURE;
    }

    if (!open_and_extend_file(i_mm, len)) {
        return FAILURE;
    }

    if (!perform_mmap(i_mm, len)) {
        close_file(i_mm);
        return FAILURE;
    }

    if ((i_mm->t->flag & MM_LOCK) && mlock(i_mm->t->addr, len) == -1) {
        return with_exception_errno(rb_eArgError, "mlock(%d)", errno);
    }

    return SUCCESS;
}

static void save_entry(mm_ipc *i_mm, size_t offset, VALUE key, VALUE value) {
    uint32_t key_length = (uint32_t)RSTRING_LEN(key);

    char *pos = (char *)i_mm->t->addr + offset;

    memcpy(pos, &key_length, sizeof(uint32_t));
    pos += sizeof(uint32_t);

    memmove(pos, StringValuePtr(key), key_length);
    pos += key_length;

    memset(pos, ' ', padding_length(key_length));  // TODO: considder padding with /0
    pos += padding_length(key_length);

    double val = NUM2DBL(value);
    memcpy(pos, &val, sizeof(double));
}

static void save_value(mm_ipc *i_mm, VALUE _offset, VALUE value) {
    Check_Type(_offset, T_FIXNUM);
    size_t offset = NUM2UINT(_offset);
    if ((i_mm->t->real + sizeof(double)) <= offset) {
        rb_raise(rb_eIndexError, "offset %zu out of string", offset);
    }

    if (i_mm->t->flag & MM_FROZEN) {
        rb_error_frozen("mmap");
    }

    char *pos = (char *)i_mm->t->addr + offset;

    double val = NUM2DBL(value);
    memcpy(pos, &val, sizeof(double));
}

static VALUE load_value(mm_ipc *i_mm, VALUE _offset) {
    Check_Type(_offset, T_FIXNUM);
    size_t offset = NUM2UINT(_offset);
    if ((i_mm->t->real + sizeof(double)) <= offset) {
        rb_raise(rb_eIndexError, "offset %zu out of string", offset);
    }

    char *pos = (char *)i_mm->t->addr + offset;

    double value;
    memcpy(&value, pos, sizeof(double));
    return DBL2NUM(value);
}

uint32_t load_used(mm_ipc *i_mm) {
    uint32_t used = *((uint32_t *)i_mm->t->addr);

    if (used == 0) {
        used = START_POSITION;
    }
    return used;
}

void save_used(mm_ipc *i_mm, uint32_t used) { *((uint32_t *)i_mm->t->addr) = used; }

static VALUE initialize_entry(mm_ipc *i_mm, VALUE positions, VALUE key, VALUE value) {
    if (i_mm->t->flag & MM_FROZEN) {
        rb_error_frozen("mmap");
    }

    if (RSTRING_LEN(key) > INT32_MAX) {
        rb_raise(rb_eArgError, "string length gt %d", INT32_MAX);
    }

    uint32_t key_length = (uint32_t)RSTRING_LEN(key);
    uint32_t value_offset = sizeof(uint32_t) + key_length + padding_length(key_length);
    uint32_t entry_length = value_offset + sizeof(double);

    uint32_t used = load_used(i_mm);
    while (i_mm->t->len < (used + entry_length)) {
        if (!expand(i_mm, i_mm->t->len * 2)) {
            raise_last_exception();
        }
    }
    save_entry(i_mm, used, key, value);
    save_used(i_mm, used + entry_length);

    return rb_hash_aset(positions, key, INT2NUM(used + value_offset));
}

VALUE method_fetch_entry(VALUE self, VALUE positions, VALUE key, VALUE default_value) {
    Check_Type(positions, T_HASH);
    Check_Type(key, T_STRING);

    mm_ipc *i_mm;
    GET_MMAP(self, i_mm, MM_MODIFY);

    VALUE position = rb_hash_lookup(positions, key);

    if (position != Qnil) {
        return load_value(i_mm, position);
    }

    position = initialize_entry(i_mm, positions, key, default_value);
    return load_value(i_mm, position);
}

VALUE method_upsert_entry(VALUE self, VALUE positions, VALUE key, VALUE value) {
    Check_Type(positions, T_HASH);
    Check_Type(key, T_STRING);

    mm_ipc *i_mm;
    GET_MMAP(self, i_mm, MM_MODIFY);

    VALUE position = rb_hash_lookup(positions, key);

    if (position != Qnil) {
        save_value(i_mm, position, value);
        return load_value(i_mm, position);
    }

    position = initialize_entry(i_mm, positions, key, value);
    return load_value(i_mm, position);
}

VALUE method_load_used(VALUE self) {
    mm_ipc *i_mm;

    GET_MMAP(self, i_mm, MM_MODIFY);
    return UINT2NUM(load_used(i_mm));
}

VALUE method_save_used(VALUE self, VALUE value) {
    Check_Type(value, T_FIXNUM);
    mm_ipc *i_mm;

    GET_MMAP(self, i_mm, MM_MODIFY);

    if (i_mm->t->flag & MM_FROZEN) {
        rb_error_frozen("mmap");
    }

    if (i_mm->t->len < INITIAL_SIZE) {
        if (!expand(i_mm, INITIAL_SIZE)) {
            raise_last_exception();
        }
    }

    save_used(i_mm, NUM2UINT(value));
    return value;
}
