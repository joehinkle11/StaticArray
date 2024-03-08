// A macro to generate the static array of X bytes
#define STATIC_ARRAY(X) \
    typedef struct { \
        unsigned char data[X]; \
    } StaticArray##X##Bytes;

// Generate some static arrays of different sizes for Swift to use
STATIC_ARRAY(64)
STATIC_ARRAY(512)
STATIC_ARRAY(4096)
STATIC_ARRAY(32768)