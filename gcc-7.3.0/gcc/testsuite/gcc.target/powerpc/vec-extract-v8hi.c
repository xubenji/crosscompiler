/* { dg-do run { target { powerpc*-*-linux* } } } */
/* { dg-require-effective-target vsx_hw } */
/* { dg-options "-O2 -mvsx" } */

#define TYPE short
#define ELEMENTS 8
#define INITIAL { 10, -20, 30, -40, 50, -60, 70, 80 }

#include "vec-extract.h"
