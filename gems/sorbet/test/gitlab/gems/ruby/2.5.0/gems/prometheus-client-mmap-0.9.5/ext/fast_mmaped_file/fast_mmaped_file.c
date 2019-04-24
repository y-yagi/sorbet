#include <errno.h>
#include <ruby.h>
#include <ruby/intern.h>

#include <sys/mman.h>

#include <hashmap.h>
#include <jsmn.h>

#include "globals.h"
#include "utils.h"
#include "value_access.h"

#include "file_parsing.h"
#include "file_reading.h"
#include "mmap.h"
#include "rendering.h"

VALUE MMAPED_FILE = Qnil;

ID sym_min;
ID sym_max;
ID sym_livesum;
ID sym_gauge;
ID sym_pid;
ID sym_samples;

VALUE prom_eParsingError;

int aggregate_files(struct hashmap *map, VALUE list_of_files) {
    buffer_t reading_buffer;
    memset(&reading_buffer, 0, sizeof(buffer_t));

    for (int i = 0; i < RARRAY_LEN(list_of_files); i++) {
        VALUE params = RARRAY_PTR(list_of_files)[i];
        file_t file;

        if (!file_open_from_params(&file, params)) {
            buffer_dispose(&reading_buffer);
            return 0;
        }

        if (!read_from_file(&file, &reading_buffer)) {
            buffer_dispose(&reading_buffer);
            file_close(&file);
            return 0;
        }

        if (!process_buffer(&file, &reading_buffer, map)) {
            buffer_dispose(&reading_buffer);
            file_close(&file);
            return 0;
        }

        if (!file_close(&file)) {
            buffer_dispose(&reading_buffer);
            return 0;
        }
    }

    buffer_dispose(&reading_buffer);
    return 1;
}

VALUE method_to_metrics(VALUE UNUSED(self), VALUE file_list) {
    struct hashmap map;
    hashmap_setup(&map);

    if (!aggregate_files(&map, file_list)) {  // all entries in map are now copies that need to be disposed
        hashmap_destroy(&map);
        raise_last_exception();
        return Qnil;
    }

    entry_t **sorted_entries;

    if (!sort_map_entries(&map, &sorted_entries)) {
        hashmap_destroy(&map);

        raise_last_exception();
        return Qnil;
    }

    VALUE rv = rb_str_new("", 0);
    if (!entries_to_string(rv, sorted_entries, hashmap_size(&map))) {
        free(sorted_entries);
        hashmap_destroy(&map);

        raise_last_exception();
        return Qnil;
    }

    RB_GC_GUARD(file_list);  // ensure file list is not GCed before this point
    free(sorted_entries);
    hashmap_destroy(&map);
    return rv;
}

void Init_fast_mmaped_file() {
    sym_gauge = rb_intern("gauge");
    sym_min = rb_intern("min");
    sym_max = rb_intern("max");
    sym_livesum = rb_intern("livesum");
    sym_pid = rb_intern("pid");
    sym_samples = rb_intern("samples");

    prom_eParsingError = rb_define_class("PrometheusParsingError", rb_eRuntimeError);

    MMAPED_FILE = rb_define_class("FastMmapedFile", rb_cObject);
    rb_define_const(MMAPED_FILE, "MAP_SHARED", INT2FIX(MAP_SHARED));

    rb_define_singleton_method(MMAPED_FILE, "to_metrics", method_to_metrics, 1);

    rb_define_alloc_func(MMAPED_FILE, mm_s_alloc);
    rb_define_singleton_method(MMAPED_FILE, "new", mm_s_new, -1);
    rb_define_method(MMAPED_FILE, "initialize", mm_init, 1);
    rb_define_method(MMAPED_FILE, "slice", mm_aref_m, -1);
    rb_define_method(MMAPED_FILE, "sync", mm_msync, -1);
    rb_define_method(MMAPED_FILE, "munmap", mm_unmap, 0);

    rb_define_method(MMAPED_FILE, "used", method_load_used, 0);
    rb_define_method(MMAPED_FILE, "used=", method_save_used, 1);
    rb_define_method(MMAPED_FILE, "fetch_entry", method_fetch_entry, 3);
    rb_define_method(MMAPED_FILE, "upsert_entry", method_upsert_entry, 3);
}
