#ifndef FILE_READING_H
#define FILE_READING_H
#include <ruby.h>

typedef struct {
    FILE *file;
    size_t length;
    char *path;

    // Information processed from file path
    ID multiprocess_mode;
    ID type;
    VALUE pid;
} file_t;

typedef struct {
    char *buffer;
    size_t size;
    size_t capacity;
} buffer_t;

int file_close(file_t *file);

int file_open_from_params(file_t *file, VALUE params);

int read_from_file(const file_t *source, buffer_t *data);

void buffer_dispose(buffer_t *buffer);

#endif
