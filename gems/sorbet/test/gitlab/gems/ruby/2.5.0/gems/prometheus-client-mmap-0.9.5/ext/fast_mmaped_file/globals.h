#ifndef GLOBALS_H
#define GLOBALS_H
#include <ruby.h>

extern ID sym_min;
extern ID sym_max;
extern ID sym_livesum;
extern ID sym_gauge;
extern ID sym_pid;
extern ID sym_samples;

extern VALUE prom_eParsingError;

#endif