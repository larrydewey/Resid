/* The C side of tests/labels/cabi/layouts.resid. */
#include <stddef.h>
#include <stdint.h>
struct pad1 { uint8_t a; uint32_t b; uint16_t c; };
struct pad2 { uint64_t a; uint8_t b; };
struct inner { uint16_t x; uint8_t y; };
struct outer { uint8_t a; struct inner mid; uint64_t z; uint8_t tail; };
struct flex { uint32_t n; uint16_t k; uint8_t data[]; };
struct fixed { uint8_t id[5]; uint32_t v; int16_t s; };
#define L(name, ...) long name[] = { __VA_ARGS__ };
L(Pad1, sizeof(struct pad1), offsetof(struct pad1, a), offsetof(struct pad1, b), offsetof(struct pad1, c))
L(Pad2, sizeof(struct pad2), offsetof(struct pad2, a), offsetof(struct pad2, b))
L(Outer, sizeof(struct outer), offsetof(struct outer, a), offsetof(struct outer, mid), offsetof(struct outer, z), offsetof(struct outer, tail))
L(Flex, sizeof(struct flex), offsetof(struct flex, n), offsetof(struct flex, k), offsetof(struct flex, data))
L(Fixed, sizeof(struct fixed), offsetof(struct fixed, id), offsetof(struct fixed, v), offsetof(struct fixed, s))
