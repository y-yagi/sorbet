#include <errno.h>
#include <fcntl.h>
#include <ruby.h>

#include "file_reading.h"
#include "utils.h"

static int file_open(file_t *source, const char *filepath) {
    source->file = fopen(filepath, "r");
    size_t filepath_len = strlen(filepath) + sizeof(char);
    source->path = malloc(filepath_len);
    memcpy(source->path, filepath, filepath_len);

    if (source->file == NULL) {
        save_exception(rb_eArgError, "Can't open %s, errno: %d", filepath, errno);

        return 0;
    }

    struct stat sb;
    if (fstat(fileno(source->file), &sb) != 0) {
        fclose(source->file);
        save_exception(rb_eIOError, "Can't stat file, errno: %d", errno);

        return 0;
    }
    source->length = sb.st_size;

    // go to start
    if (fseek(source->file, 0L, SEEK_SET) != 0) {
        fclose(source->file);
        save_exception(rb_eIOError, "Can't fseek %zu, errno: %d", 0, errno);

        return 0;
    }

    return 1;
}

int file_close(file_t *source) {
    free(source->path);
    if (fclose(source->file) != 0) {
        save_exception(rb_eIOError, "Can't fclose file, errno: %d", 0, errno);
        return 0;
    }
    source->file = 0;

    return 1;
}

int file_open_from_params(file_t *source, VALUE params) {
    if (RARRAY_LEN(params) != 4) {
        save_exception(rb_eArgError, "wrong number of arguments %lu instead of 4", RARRAY_LEN(params));
        return 0;
    }

    VALUE filepath = rb_ary_entry(params, 0);

    source->multiprocess_mode = rb_sym2id(rb_ary_entry(params, 1));
    source->type = rb_sym2id(rb_ary_entry(params, 2));
    source->pid = rb_ary_entry(params, 3);

    return file_open(source, StringValueCStr(filepath));
}

int read_from_file(const file_t *source, buffer_t *data) {
    data->size = 0;
    if (data->buffer == NULL) {
        data->buffer = malloc(source->length);
        if (data->buffer == NULL) {
            save_exception(rb_eIOError, "Can't malloc %zu, errno: %d", source->length, errno);
            return 0;
        }

        data->capacity = source->length;
    } else if (data->capacity < source->length) {
        data->buffer = realloc(data->buffer, source->length);
        if (data->buffer == NULL) {
            save_exception(rb_eIOError, "Can't realloc %zu, errno: %d", source->length, errno);
            return 0;
        }

        data->capacity = source->length;
    }

    data->size = fread(data->buffer, sizeof(char), source->length, source->file);
    if (data->size != source->length) {
        save_exception(rb_eIOError, "Couldn't read whole file, read %zu, instead of %zu", data->size, source->length);
        return 0;
    }

    return 1;
}

void buffer_dispose(buffer_t *buffer) {
    if (buffer->buffer) {
        free(buffer->buffer);
    }
    buffer->buffer = NULL;
    buffer->size = 0;
    buffer->capacity = 0;
}
