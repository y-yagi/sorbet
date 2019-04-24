#include <float.h>
#include <jsmn.h>

#include "file_parsing.h"
#include "globals.h"
#include "rendering.h"
#include "utils.h"

#ifndef DBL_DECIMAL_DIG
#define DBL_DECIMAL_DIG 17
#endif

#define LABELS_START_OFFSET 4

static inline int is_valid(const jsmntok_t *token) { return token->start < token->end && token->start >= 0; }
static inline int valid_not_null(const entry_t *entry, const jsmntok_t *token) {
    static const char null_s[] = "null";

    if (!is_valid(token)) {
        return 0;
    }

    if (token->type != JSMN_PRIMITIVE) {
        return 1;
    }

    size_t token_len = token->end - token->start;

    if (token_len < sizeof(null_s) - 1) {
        return 1;
    }

    return strncmp(null_s, entry->json + token->start, sizeof(null_s) - 1) != 0;
}

static inline int append_token(VALUE string, const entry_t *entry, const jsmntok_t *token) {
    if (!is_valid(token)) {
        save_exception(prom_eParsingError, "parsing failed: %s", entry->json);
        return 0;
    }

    rb_str_cat(string, entry->json + token->start, token->end - token->start);
    return 1;
}

static int append_labels(VALUE string, const entry_t *entry, const int label_count, const jsmntok_t *tokens) {
    if (label_count <= 0) {
        return 1;
    }

    rb_str_cat(string, "{", 1);

    for (int i = 0; i < label_count; i++) {
        int key = LABELS_START_OFFSET + i;
        int val = LABELS_START_OFFSET + label_count + 1 + i;

        if (!append_token(string, entry, &tokens[key])) {
            return 0;
        }
        rb_str_cat(string, "=", 1);

        rb_str_cat(string, "\"", 1);
        if (valid_not_null(entry, &tokens[val])) {
            append_token(string, entry, &tokens[val]);
        }
        rb_str_cat(string, "\"", 1);

        if (i < label_count - 1) {
            rb_str_cat(string, ",", 1);
        }
    }

    if (is_pid_significant(entry)) {
        rb_str_cat(string, ",pid=\"", 6);
        rb_str_append(string, entry->pid);
        rb_str_cat(string, "\"", 1);
    }

    rb_str_cat(string, "}", 1);
    return 1;
}

static int validate_token_count(const int token_count, const entry_t *entry) {
    if (token_count < 0) {
        save_exception(prom_eParsingError, "too many labels or malformed json: %s", entry->json);
        return 0;
    }

    if (token_count < LABELS_START_OFFSET) {
        save_exception(prom_eParsingError, "malformed json: %s", entry->json);
        return 0;
    }

    if ((token_count - (LABELS_START_OFFSET + 1)) % 2 != 0) {
        save_exception(prom_eParsingError, "mismatched number of labels: %s", entry->json);
        return 0;
    }

    return 1;
}

static int append_entry(VALUE string, const entry_t *entry) {
    jsmn_parser parser;
    jsmn_init(&parser);

    jsmntok_t tokens[200];
    jsmntok_t *name_token = &tokens[2];

    int token_count = jsmn_parse(&parser, entry->json, entry->json_size, tokens, sizeof(tokens) / sizeof(tokens[0]));
    int label_count = (token_count - (LABELS_START_OFFSET + 1)) / 2;

    //
    // Example JSON "['metric', 'name',['label_a','label_b'],['value_a', 'value_b']]"
    // will be  parsed into following token list:
    //
    // [ "'metric', 'name',['label_a','label_b'],['value_a', 'value_b']",
    // "metric", "name",
    // "['label_a','label_b']", "label_a", "label_b",
    // "['value_a', 'value_b']", "value_a", "value_b" ]
    //
    // where 'metric' is the name of the metric, while 'name'
    // is in summaries and histograms to store names of "submetrics" like:
    // histogram_name_bucket or histogram_name_sum

    if (!validate_token_count(token_count, entry)) {
        return 0;
    }

    if (!append_token(string, entry, name_token)) {
        return 0;
    }

    if (!append_labels(string, entry, label_count, tokens)) {
        return 0;
    }

    char value[255];

    // print value with highest possible precision so that we do not lose any data
    int written = snprintf(value, sizeof(value), " %.*g\n", DBL_DECIMAL_DIG, entry->value);
    rb_str_cat(string, value, written);

    return 1;
}

static void append_entry_head(VALUE string, const entry_t *entry) {
    static const char help_beg[] = "# HELP ";
    static const char help_fin[] = " Multiprocess metric\n";

    rb_str_cat(string, help_beg, sizeof(help_beg) - 1);
    rb_str_cat(string, entry->name, entry->name_len);
    rb_str_cat(string, help_fin, sizeof(help_fin) - 1);

    static const char type_beg[] = "# TYPE ";

    rb_str_cat(string, type_beg, sizeof(type_beg) - 1);
    rb_str_cat(string, entry->name, entry->name_len);
    rb_str_cat(string, " ", 1);
    rb_str_cat2(string, rb_id2name(entry->type));
    rb_str_cat(string, "\n", 1);
}

static inline int entry_name_equal(const entry_t *a, const entry_t *b) {
    if (a == NULL || b == NULL) {
        return a == b;
    }

    if (a->name_len != b->name_len) {
        return 0;
    }

    return strncmp(a->name, b->name, a->name_len) == 0;
}

int entries_to_string(VALUE string, entry_t **sorted_entries, size_t entries_count) {
    entry_t *previous = NULL;

    for (size_t i = 0; i < entries_count; i++) {
        entry_t *entry = sorted_entries[i];

        // when entry->name changes write metric header
        if (!entry_name_equal(previous, entry)) {
            previous = entry;
            append_entry_head(string, entry);
        }

        if (!append_entry(string, entry)) {
            return 0;
        }
    }

    return 1;
}
