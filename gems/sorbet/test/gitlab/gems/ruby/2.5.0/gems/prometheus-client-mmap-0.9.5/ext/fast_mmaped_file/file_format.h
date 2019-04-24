#ifndef FILE_FORMAT_H
#define FILE_FORMAT_H

#include <stdint.h>

#define START_POSITION 8
#define INITIAL_SIZE (2 * sizeof(int32_t))

uint32_t padding_length(uint32_t key_length);

#endif