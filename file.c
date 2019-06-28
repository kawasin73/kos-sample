/* ファイル関係 */

#include "bootpack.h"

/* ディスクイメージ内の FAT の圧縮をとく */
void file_readfat(int *fat, unsigned char *img) {
    int i, j = 0;
    for (i = 0; i < 2880; i+=2) {
        fat[i+0] = (img[j+0]      | img[j+1] << 8) & 0xfff;
        fat[i+1] = (img[j+1] >> 4 | img[j+2] << 4) & 0xfff;
        j += 3;
    }
    return;
}

void file_loadfile(int clustno, int size, char *buf, int *fat, char *img) {
    int i;
    for (;;) {
        if (size <= 512) {
            for (i = 0; i < size; i++) {
                buf[i] = img[clustno * 512 + i];
            }
            break;
        }
        for (i = 0; i < 512; i++) {
            buf[i] = img[clustno * 512 + 1];
        }
        size -= 512;
        buf += 512;
        clustno = fat[clustno];
    }
    return;
}
