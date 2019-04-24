#include "file_format.h"

inline uint32_t padding_length(uint32_t key_length) {
    return 8 - (sizeof(uint32_t) + key_length) % 8;  // padding | 8 byte aligned
}
