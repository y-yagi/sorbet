#include <errno.h>
#include <fcntl.h>
#include <ruby.h>
#include <ruby/util.h>
#include <sys/mman.h>

#include "file_format.h"
#include "mmap.h"
#include "utils.h"

#if 0
#include <stdio.h>
#define DEBUGF(format, ...) printf("%d: " format "\n", __LINE__, __VA_ARGS__)
#else
#define DEBUGF(format, ...)
#endif

typedef struct {
    VALUE obj, *argv;
    ID id;
    int flag, argc;
} mm_bang;

static VALUE mm_protect_bang(VALUE *t) { return rb_funcall2(t[0], (ID)t[1], (int)t[2], (VALUE *)t[3]); }

static VALUE mm_recycle(VALUE str) {
    rb_gc_force_recycle(str);
    return str;
}

static VALUE mm_vunlock(VALUE obj) {
    mm_ipc *i_mm;

    GET_MMAP(obj, i_mm, 0);
    return Qnil;
}

static VALUE mm_str(VALUE obj, int modify) {
    mm_ipc *i_mm;
    VALUE ret = Qnil;

    GET_MMAP(obj, i_mm, modify & ~MM_ORIGIN);
    if (modify & MM_MODIFY) {
        if (i_mm->t->flag & MM_FROZEN) rb_error_frozen("mmap");
        if (!OBJ_TAINTED(ret) && rb_safe_level() >= 4) rb_raise(rb_eSecurityError, "Insecure: can't modify mmap");
    }
    ret = rb_obj_alloc(rb_cString);
    if (rb_obj_tainted(obj)) {
        OBJ_TAINT(ret);
    }
    RSTRING(ret)->as.heap.ptr = i_mm->t->addr;
    RSTRING(ret)->as.heap.aux.capa = i_mm->t->len;
    RSTRING(ret)->as.heap.len = i_mm->t->real;

    DEBUGF("RString capa: %d, len: %d", RSTRING(ret)->as.heap.aux.capa, RSTRING(ret)->as.heap.len);

    if (modify & MM_ORIGIN) {
#if HAVE_RB_DEFINE_ALLOC_FUNC
        RSTRING(ret)->as.heap.aux.shared = obj;
        FL_SET(ret, RSTRING_NOEMBED);
        FL_SET(ret, FL_USER18);
#else
        RSTRING(ret)->orig = ret;
#endif
    }
    if (i_mm->t->flag & MM_FROZEN) {
        ret = rb_obj_freeze(ret);
    }
    return ret;
}

static VALUE mm_i_bang(bang_st) mm_bang *bang_st;
{
    VALUE str, res;
    mm_ipc *i_mm;

    str = mm_str(bang_st->obj, bang_st->flag);
    if (bang_st->flag & MM_PROTECT) {
        VALUE tmp[4];
        tmp[0] = str;
        tmp[1] = (VALUE)bang_st->id;
        tmp[2] = (VALUE)bang_st->argc;
        tmp[3] = (VALUE)bang_st->argv;
        res = rb_ensure(mm_protect_bang, (VALUE)tmp, mm_recycle, str);
    } else {
        res = rb_funcall2(str, bang_st->id, bang_st->argc, bang_st->argv);
        RB_GC_GUARD(res);
    }
    if (res != Qnil) {
        GET_MMAP(bang_st->obj, i_mm, 0);
        i_mm->t->real = RSTRING_LEN(str);
    }
    return res;
}

static VALUE mm_bang_i(VALUE obj, int flag, ID id, int argc, VALUE *argv) {
    VALUE res;
    mm_ipc *i_mm;
    mm_bang bang_st;

    GET_MMAP(obj, i_mm, 0);
    if ((flag & MM_CHANGE) && (i_mm->t->flag & MM_FIXED)) {
        rb_raise(rb_eTypeError, "try to change the size of a fixed map");
    }
    bang_st.obj = obj;
    bang_st.flag = flag;
    bang_st.id = id;
    bang_st.argc = argc;
    bang_st.argv = argv;
    if (i_mm->t->flag & MM_IPC) {
        res = rb_ensure(mm_i_bang, (VALUE)&bang_st, mm_vunlock, obj);
    } else {
        res = mm_i_bang(&bang_st);
    }
    if (res == Qnil) return res;
    return (flag & MM_ORIGIN) ? res : obj;
}

static void mm_free(mm_ipc *i_mm) {
    if (i_mm->t->path) {
        if (munmap(i_mm->t->addr, i_mm->t->len) != 0) {
            if (i_mm->t->path != (char *)-1 && i_mm->t->path != NULL) {
                free(i_mm->t->path);
            }
            free(i_mm);

            rb_raise(rb_eRuntimeError, "munmap failed at %s:%d with errno: %d", __FILE__, __LINE__, errno);
        }

        if (i_mm->t->path != (char *)-1) {
            if (i_mm->t->real < i_mm->t->len && i_mm->t->vscope != MAP_PRIVATE &&
                truncate(i_mm->t->path, i_mm->t->real) == -1) {
                free(i_mm->t->path);
                free(i_mm);
                rb_raise(rb_eTypeError, "truncate");
            }
            free(i_mm->t->path);
        }
    }
    free(i_mm);
}

/*
 * call-seq:
 *  new(file)
 *
 * create a new Mmap object
 *
 * * <em>file</em>
 *
 *
 *     Creates a mapping that's shared with all other processes
 *     mapping the same areas of the file.
 *
 */
VALUE mm_s_new(int argc, VALUE *argv, VALUE obj) {
    VALUE res = rb_funcall2(obj, rb_intern("allocate"), 0, 0);
    rb_obj_call_init(res, argc, argv);
    return res;
}

VALUE mm_s_alloc(VALUE obj) {
    VALUE res;
    mm_ipc *i_mm;

    res = Data_Make_Struct(obj, mm_ipc, 0, mm_free, i_mm);
    i_mm->t = ALLOC_N(mm_mmap, 1);
    MEMZERO(i_mm->t, mm_mmap, 1);
    i_mm->t->fd = -1;
    return res;
}

VALUE mm_init(VALUE obj, VALUE fname) {
    struct stat st;
    int fd, smode = 0, pmode = 0, vscope, perm, init;
    MMAP_RETTYPE addr;
    mm_ipc *i_mm;
    char *path;
    size_t size = 0;
    off_t offset;

    vscope = 0;
    path = 0;
    fd = -1;

    fname = rb_str_to_str(fname);
    SafeStringValue(fname);
    path = StringValuePtr(fname);

    {
        if (rb_safe_level() > 0 && OBJ_TAINTED(fname)) {
            rb_raise(rb_eSecurityError, "Insecure operation");
        }
        rb_secure(1);
    }

    vscope = MAP_SHARED;
    size = 0;
    perm = 0666;

    smode = O_RDWR;
    pmode = PROT_READ | PROT_WRITE;

    if ((fd = open(path, smode, perm)) == -1) {
        rb_raise(rb_eArgError, "Can't open %s", path);
    }

    if (fstat(fd, &st) == -1) {
        rb_raise(rb_eArgError, "Can't stat %s", path);
    }
    size = st.st_size;

    Data_Get_Struct(obj, mm_ipc, i_mm);

    offset = 0;
    init = 0;

    if (size == 0 && (smode & O_RDWR)) {
        if (lseek(fd, INITIAL_SIZE - 1, SEEK_END) == -1) {
            rb_raise(rb_eIOError, "Can't lseek %zu", INITIAL_SIZE - 1);
        }
        if (write(fd, "\000", 1) != 1) {
            rb_raise(rb_eIOError, "Can't extend %s", path);
        }
        init = 1;
        size = INITIAL_SIZE;
    }

    addr = mmap(0, size, pmode, vscope, fd, offset);

    if (addr == MAP_FAILED || !addr) {
        close(fd);
        rb_raise(rb_eArgError, "mmap failed (%d)", errno);
    }
    i_mm->t->fd = fd;
    i_mm->t->addr = addr;
    i_mm->t->len = size;
    if (!init) {
        i_mm->t->real = size;
    }
    i_mm->t->pmode = pmode;
    i_mm->t->vscope = vscope;
    i_mm->t->smode = smode & ~O_TRUNC;
    i_mm->t->path = (path) ? ruby_strdup(path) : (char *)-1;

    if (smode == O_WRONLY) {
        i_mm->t->flag |= MM_FIXED;
    }
    OBJ_TAINT(obj);
    return obj;
}

/*
 * Document-method: []
 * Document-method: slice
 *
 * call-seq: [](args)
 *
 * Element reference - with the following syntax:
 *
 *   self[nth]
 *
 * retrieve the <em>nth</em> character
 *
 *   self[start..last]
 *
 * return a substring from <em>start</em> to <em>last</em>
 *
 *   self[start, length]
 *
 * return a substring of <em>lenght</em> characters from <em>start</em>
 */
VALUE mm_aref_m(int argc, VALUE *argv, VALUE obj) { return mm_bang_i(obj, MM_ORIGIN, rb_intern("[]"), argc, argv); }

/*
 * Document-method: msync
 * Document-method: sync
 * Document-method: flush
 *
 * call-seq: msync
 *
 * flush the file
 */
VALUE mm_msync(int argc, VALUE *argv, VALUE obj) {
    mm_ipc *i_mm;
    GET_MMAP(obj, i_mm, MM_MODIFY);

    VALUE oflag;
    int ret;
    int flag = MS_SYNC;

    if (argc) {
        rb_scan_args(argc, argv, "01", &oflag);
        flag = NUM2INT(oflag);
    }
    if ((ret = msync(i_mm->t->addr, i_mm->t->len, flag)) != 0) {
        rb_raise(rb_eArgError, "msync(%d)", ret);
    }

    return obj;
}

/*
 * Document-method: munmap
 * Document-method: unmap
 *
 * call-seq: munmap
 *
 * terminate the association
 */
VALUE mm_unmap(VALUE obj) {
    mm_ipc *i_mm;

    GET_MMAP(obj, i_mm, 0);
    if (i_mm->t->path) {
        if (munmap(i_mm->t->addr, i_mm->t->len) != 0) {
            if (i_mm->t->path != (char *)-1 && i_mm->t->path != NULL) {
                free(i_mm->t->path);
                i_mm->t->path = NULL;
            }

            rb_raise(rb_eRuntimeError, "munmap failed at %s:%d with errno: %d", __FILE__, __LINE__, errno);
        }

        if (i_mm->t->path != (char *)-1) {
            if (i_mm->t->real < i_mm->t->len && i_mm->t->vscope != MAP_PRIVATE &&
                truncate(i_mm->t->path, i_mm->t->real) == -1) {
                rb_raise(rb_eTypeError, "truncate");
            }
            free(i_mm->t->path);
        }
        i_mm->t->path = NULL;
    }
    return Qnil;
}
