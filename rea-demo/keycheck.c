// Demo target for learning REA. The "answer key" is in this file;
// the analysis only uses the compiled, stripped binary.
#include <stdio.h>
#include <string.h>

static const unsigned char hidden[] = {0x0e, 0x08, 0x0f, 0x09, 0x0e, 0x16, 0x1b, 0x14};

static int check_key(const char *key) {
    if (strlen(key) != sizeof(hidden))
        return 0;
    for (size_t i = 0; i < sizeof(hidden); i++)
        if ((unsigned char)(key[i] ^ 0x5A) != hidden[i])
            return 0;
    return 1;
}

int main(int argc, char **argv) {
    if (argc < 2) {
        puts("usage: keycheck <license-key>");
        return 2;
    }
    if (check_key(argv[1])) {
        puts("License OK. Welcome!");
        return 0;
    }
    puts("Invalid license key.");
    return 1;
}
