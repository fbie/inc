#include <stdio.h>
#include "scheme_entry.h"

#define fixnum_mask 3
#define fixnum_tag 0
#define fixnum_shift 2

#define char_shift 8
#define char_mask ((1 << 8) - 1)
#define char_tag  15

#define empty_list 23

#define true_rep 63
#define false_rep (true_rep >> 1)

int main(int argc, char** argv) {
  const int val = scheme_entry();
  if ((val & fixnum_mask) == fixnum_tag) {
    printf("%d\n", val >> fixnum_shift);
  } else if ((val & char_mask) == char_tag) {
    printf("%c\n", val >> char_shift);
  } else if (val == empty_list) {
    printf("'()\n");
  } else if (val == true_rep) {
    printf("#t\n");
  } else if (val == false_rep) {
    printf("#f\n");
  }
  return 0;
}
