#ifndef MMAP_H
#define MMAP_H

#include <ruby.h>
#include <unistd.h>

#define MM_MODIFY 1
#define MM_ORIGIN 2
#define MM_CHANGE (MM_MODIFY | 4)
#define MM_PROTECT 8

#define MM_FROZEN (1 << 0)
#define MM_FIXED (1 << 1)
#define MM_ANON (1 << 2)
#define MM_LOCK (1 << 3)
#define MM_IPC (1 << 4)
#define MM_TMP (1 << 5)

#ifndef MMAP_RETTYPE
#define MMAP_RETTYPE void *
#endif

typedef struct {
    MMAP_RETTYPE addr;
    int smode, pmode, vscope;
    int advice, flag;
    VALUE key;
    size_t len, real;
    off_t offset;
    int fd;
    char *path;
} mm_mmap;

typedef struct {
    int count;
    mm_mmap *t;
} mm_ipc;

#define GET_MMAP(obj, i_mm, t_modify)                                                                \
    Data_Get_Struct(obj, mm_ipc, i_mm);                                                              \
    if (!i_mm->t->path || i_mm->t->fd < 0 || i_mm->t->addr == NULL || i_mm->t->addr == MAP_FAILED) { \
        rb_raise(rb_eIOError, "unmapped file");                                                      \
    }                                                                                                \
    if ((t_modify & MM_MODIFY) && (i_mm->t->flag & MM_FROZEN)) {                                     \
        rb_error_frozen("mmap");                                                                     \
    }

VALUE mm_s_alloc(VALUE obj);
VALUE mm_s_new(int argc, VALUE *argv, VALUE obj);
VALUE mm_init(VALUE obj, VALUE fname);
VALUE mm_aref_m(int argc, VALUE *argv, VALUE obj);
VALUE mm_msync(int argc, VALUE *argv, VALUE obj);
VALUE mm_unmap(VALUE obj);

#endif
