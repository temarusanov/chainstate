#ifndef __VARINT_HH__
#define __VARINT_HH__

#include <stdint.h>

uint64_t get_next_varint(std::string&);
uint64_t get_varint(std::string);
std::string replace_all(
    const std::string &str,    
    const std::string &find,   
    const std::string &replace
);
uint64_t compress_amount(uint64_t);
uint64_t decompress_amount(uint64_t);

#endif