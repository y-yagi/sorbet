#ifndef VALUE_ACCESS_H
#define VALUE_ACCESS_H

VALUE method_load_used(VALUE self);

VALUE method_save_used(VALUE self, VALUE value);

VALUE method_get_double(VALUE self, VALUE index);

VALUE method_fetch_entry(VALUE self, VALUE positions, VALUE key, VALUE default_value);

VALUE method_upsert_entry(VALUE self, VALUE positions, VALUE key, VALUE value);

#endif