/* FIFO ライブラリ */

#include "bootpack.h"

#define FLAGS_OVERRUN       0x0001

/* FIFO バッファの初期化 */
void fifo8_init(struct FIFO8 *fifo, int size, unsigned char *buf) {
    fifo->size = size;
    fifo->buf = buf;
    fifo->free = size; /* 空き */
    fifo->flags = 0;
    fifo->p = 0; /* 書き込み位置 */
    fifo->q = 0; /* 読み込み位置 */
    return;
}

/* FIFO へデータを送り込んで蓄える */
int fifo8_put(struct FIFO8 *fifo, unsigned char data) {
    if (fifo->free == 0) {
        /* 空きがなくて溢れた */
        fifo->flags |= FLAGS_OVERRUN;
        return -1;
    }
    fifo->buf[fifo->p] = data;
    fifo->p++;
    if (fifo->p == fifo->size) {
        fifo->p = 0;
    }
    fifo->free--;
    return 0;
}

/* FIFO からデータを取ってくる */
int fifo8_get(struct FIFO8 *fifo) {
    int data;
    if (fifo->free == fifo->size) {
        /* バッファが空の場合は -1 が返される */
        return -1;
    }
    data = fifo->buf[fifo->q];
    fifo->q++;
    if (fifo->q == fifo->size) {
        fifo->q = 0;
    }
    fifo->free++;
    return data;
}

/* どのくらいデータが溜まっているかを報告する */
int fifo8_status(struct FIFO8 *fifo) {
    return fifo->size - fifo->free;
}
