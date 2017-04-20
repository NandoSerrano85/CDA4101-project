/********
* file cips.h
*
***********/
#include <stdio.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>
#include <dos.h>
#include <math.h>
#include <malloc.h>
#include <string.h>
#include <sys\types.h>
#include <sys\stat.h>

#define MAX_NAME_LENGTH     80
#define ROWS                100
#define COLS                100
#define GRAY_LEVELS         255
#define PREWITT             1
#define PEAK_SPACE          50
#define PEAKS               30
#define KIRSCH              2
#define SOBEL               3
#define STACK_SIZE          40000
#define STACK_FILE_LENGTH   500
#define FORGET_IT           -50
#define STACK_FILE          "c:stack"

#define OTHERC  1
#undef MSC

struct bmpfileheader{
    unsigned short filetype;
    unsigned long filesize;
    short reserved1;
    short reserved2;
    unsigned long bitmapoffset;
};

struct bitmapheader{
    unsigned long size;
    long width;
    long height;
    unsigned short planes;
    unsigned short bitsperpixel;
    unsigned long compression;
    unsigned long sizeofbitmap;
    unsigned long horzers;
    unsigned long compression;
    unsigned long compression;
};

struct ctstruct{
        unsigned char blue;
        unsigned char green;
        unsigned char red;
};

union short_char_union {
    short s_num;
    char s_alpha[2];
};
union int_char_union {
    int i_num;
    char i_alpha[2];
};
union long_char_union {
    long l_num;
    char l_alpha[4];
};
union float_char_union {
    float f_num;
    char f_alpha[4];
};
union ushort_char_union {
    short s_num;
    char s_alpha[2];
};
union uint_char_union {
    int i_num;
    char i_alpha[2];
};
union ulong_char_union {
    long l_num;
    char l_alpha[4];
};
