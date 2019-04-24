#ifndef RENDERING_H
#define RENDERING_H
#include <file_parsing.h>
#include <ruby.h>

int entries_to_string(VALUE string, entry_t **sorted_entries, size_t entries_count);

#endif
