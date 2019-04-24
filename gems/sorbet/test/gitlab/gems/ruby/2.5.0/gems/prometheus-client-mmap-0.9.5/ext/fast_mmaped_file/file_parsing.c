#include <hashmap.h>
#include <jsmn.h>
#include <ruby.h>

#include "file_format.h"
#include "file_parsing.h"
#include "globals.h"
#include "utils.h"

HASHMAP_FUNCS_CREATE(entry, const entry_t, entry_t)

typedef int (*compare_fn)(const void *a, const void *b);

static size_t hashmap_hash_entry(const entry_t *entry) { return hashmap_hash_string(entry->json); }

static int hashmap_compare_entry(const entry_t *a, const entry_t *b) {
    if (a->json_size != b->json_size) {
        return -1;
    }

    if (is_pid_significant(a) && (rb_str_equal(a->pid, b->pid) == Qfalse)) {
        return -1;
    }

    return strncmp(a->json, b->json, a->json_size);
}

static void entry_free(entry_t *entry) {
    free(entry->json);
    free(entry);
}

static inline double min(double a, double b) { return a < b ? a : b; }

static inline double max(double a, double b) { return a > b ? a : b; }

static void merge_entry(entry_t *found, const entry_t *entry) {
    if (entry->type == sym_gauge) {
        if (entry->multiprocess_mode == sym_min) {
            found->value = min(found->value, entry->value);
        } else if (entry->multiprocess_mode == sym_max) {
            found->value = max(found->value, entry->value);
        } else if (entry->multiprocess_mode == sym_livesum) {
            found->value += entry->value;
        } else {
            found->value = entry->value;
        }
    } else {
        found->value += entry->value;
    }
}

void merge_or_store(struct hashmap *map, entry_t *entry) {
    entry_t *found = entry_hashmap_get(map, entry);
    if (found) {
        merge_entry(found, entry);
        entry_free(entry);
    } else {
        entry_hashmap_put(map, entry, entry);  // use the hashmap like hashset actually
    }
}

entry_t *entry_new(buffer_t *source, uint32_t pos, uint32_t encoded_len, file_t *file_info) {
    entry_t *entry = calloc(1, sizeof(entry_t));
    if (entry == NULL) {
        return NULL;
    }

    entry->json = malloc(encoded_len + 1);
    if (entry->json == NULL) {
        free(entry);
        return NULL;
    }

    memcpy(entry->json, source->buffer + pos, encoded_len);
    entry->json[encoded_len] = '\0';
    entry->json_size = encoded_len;

    entry->pid = file_info->pid;
    entry->multiprocess_mode = file_info->multiprocess_mode;
    entry->type = file_info->type;

    char *value_ptr = source->buffer + pos + encoded_len + padding_length(encoded_len);
    memcpy(&(entry->value), value_ptr, sizeof(double));

    return entry;
}

static int add_parsed_name(entry_t *entry) {
    jsmn_parser parser;
    jsmn_init(&parser);

    jsmntok_t tokens[2];
    memset(&tokens, 0, sizeof(tokens));

    jsmn_parse(&parser, entry->json, entry->json_size, tokens, 2);
    jsmntok_t *name_token = &tokens[1];

    if (name_token->start < name_token->end && name_token->start > 0) {
        entry->name = entry->json + name_token->start;
        entry->name_len = name_token->end - name_token->start;
        return 1;
    }
    return 0;
}

static int entry_lexical_comparator(const entry_t **a, const entry_t **b) {
    size_t size_a = (*a)->json_size;
    size_t size_b = (*b)->json_size;
    size_t min_length = size_a < size_b ? size_a : size_b;

    return strncmp((*a)->json, (*b)->json, min_length);
}

void hashmap_setup(struct hashmap *map) {
    hashmap_init(map, (size_t(*)(const void *))hashmap_hash_entry,
                 (int (*)(const void *, const void *))hashmap_compare_entry, 1000);
    hashmap_set_key_alloc_funcs(map, NULL, (void (*)(void *))entry_free);
}

int process_buffer(file_t *file_info, buffer_t *source, struct hashmap *map) {
    if (source->size < START_POSITION) {
        // nothing to read
        return 1;
    }
    uint32_t used;
    memcpy(&used, source->buffer, sizeof(uint32_t));

    if (used > source->size) {
        save_exception(prom_eParsingError, "source file %s corrupted, used %u > file size %u", file_info->path, used,
                       source->size);
        return 0;
    }

    uint32_t pos = START_POSITION;
    while (pos + sizeof(uint32_t) < used) {
        uint32_t encoded_len;
        memcpy(&encoded_len, source->buffer + pos, sizeof(uint32_t));
        pos += sizeof(uint32_t);

        uint32_t value_offset = encoded_len + padding_length(encoded_len);

        if (pos + value_offset + sizeof(double) > used) {
            save_exception(prom_eParsingError, "source file %s corrupted, used %u < stored data length %u",
                           file_info->path, used, pos + value_offset + sizeof(double));
            return 0;
        }

        entry_t *entry = entry_new(source, pos, encoded_len, file_info);
        if (entry == NULL) {
            save_exception(rb_eNoMemError, "Failed creating metrics entry");
            return 0;
        }

        merge_or_store(map, entry);

        pos += value_offset + sizeof(double);
    }
    return 1;
}

int sort_map_entries(const struct hashmap *map, entry_t ***sorted_entries) {
    size_t num = hashmap_size(map);

    entry_t **list = calloc(num, sizeof(entry_t *));

    if (list == NULL) {
        save_exception(rb_eNoMemError, "Couldn't allocate for %zu memory", num * sizeof(entry_t *));
        return 0;
    }

    size_t cnt = 0;
    struct hashmap_iter *iter;
    for (iter = hashmap_iter(map); iter; iter = hashmap_iter_next(map, iter)) {
        entry_t *entry = (entry_t *)entry_hashmap_iter_get_key(iter);
        if (add_parsed_name(entry)) {
            list[cnt] = entry;
            cnt++;
        }
    }
    if (cnt != num) {
        save_exception(rb_eRuntimeError, "Processed entries %zu != map entries %zu", cnt, num);
        free(list);
        return 0;
    }

    qsort(list, cnt, sizeof(entry_t *), (compare_fn)&entry_lexical_comparator);
    *sorted_entries = list;
    return 1;
}

int is_pid_significant(const entry_t *e) {
    ID mp = e->multiprocess_mode;
    return e->type == sym_gauge && !(mp == sym_min || mp == sym_max || mp == sym_livesum);
}
