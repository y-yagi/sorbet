#ifndef FILE_PARSING_H
#define FILE_PARSING_H
#include <file_reading.h>
#include <hashmap.h>

typedef struct {
    char *json;
    size_t json_size;
    char *name;
    size_t name_len;

    ID multiprocess_mode;
    ID type;
    VALUE pid;

    double value;
} entry_t;

void hashmap_setup(struct hashmap *map);

int process_buffer(file_t *file_info, buffer_t *source, struct hashmap *map);
int sort_map_entries(const struct hashmap *map, entry_t ***sorted_entries);

int is_pid_significant(const entry_t *e);

#endif