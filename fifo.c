/* FIFO ライブラリ */

#include "bootpack.h"

#define FLAGS_OVERRUN       0x0001

/* FIFO バッファの初期化 */
void fifo32_init(struct FIFO32 *fifo, int size, int *buf, struct TASK *task) {
    fifo->size = size;
    fifo->buf = buf;
    fifo->free = size; /* 空き */
    fifo->flags = 0;
    fifo->p = 0; /* 書き込み位置 */
    fifo->q = 0; /* 読み込み位置 */
    fifo->task = task; /* データが入った時に起こすタスク */
    return;
}

/* FIFO へデータを送り込んで蓄える */
int fifo32_put(struct FIFO32 *fifo, int data) {
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

    if (fifo->task != 0) {
        if (fifo->task->flags != 2) { /* タスクが寝ていたら */
            task_run(fifo->task);
        }
    }
    return 0;
}

/* FIFO からデータを取ってくる */
int fifo32_get(struct FIFO32 *fifo) {
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
int fifo32_status(struct FIFO32 *fifo) {
    return fifo->size - fifo->free;
}
