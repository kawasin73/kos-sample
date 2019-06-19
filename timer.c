/* タイマ関連 */

#include "bootpack.h"

#define PIT_CTRL        0x0043
#define PIT_CNT0        0x0040

struct TIMERCTL timerctl;

#define TIMER_FLAGS_ALLOC       1 /* 確保した状態 */
#define TIMER_FLAGS_USING       2 /* タイマ作動中 */

void init_pit(void) {
    int i;
    io_out8(PIT_CTRL, 0x34);
    io_out8(PIT_CNT0, 0x9c);
    io_out8(PIT_CNT0, 0x2e);
    timerctl.count = 0;
    timerctl.next = 0xffffffff;
    timerctl.using = 0;
    for (i = 0; i < MAX_TIMER; i++) {
        timerctl.timers0[i].flags = 0; /* 未使用 */
    }
    return;
}

struct TIMER *timer_alloc(void) {
    int i;
    for (i = 0; i < MAX_TIMER; i++) {
        if (timerctl.timers0[i].flags == 0) {
            timerctl.timers0[i].flags = TIMER_FLAGS_ALLOC;
            return &timerctl.timers0[i];
        }
    }
    return 0;
}

void timer_free(struct TIMER *timer) {
    timer->flags = 0;
    return;
}

void timer_init(struct TIMER *timer, struct FIFO32 *fifo, int data) {
    timer->fifo = fifo;
    timer->data = data;
    return;
}

void timer_settime(struct TIMER *timer, unsigned int timeout) {
    int e;
    struct TIMER *t, *s;
    timer->timeout = timeout + timerctl.count;
    timer->flags = TIMER_FLAGS_USING;

    /* 割り込みを禁止して順序操作する */
    e = io_load_eflags();
    io_cli();

    timerctl.using++;
    if (timerctl.using == 1) {
        /* 動作中のタイマはこれ１つになる場合 */
        timerctl.t0 = timer;
        timer->next = 0;
        timerctl.next = timer->timeout;
        io_store_eflags(e);
        return;
    }

    t = timerctl.t0;
    if (timer->timeout <= t->timeout) {
        /* 先頭に入れる場合 */
        timerctl.t0 = timer;
        timer->next = t;
        timerctl.next = timer->timeout;
        io_store_eflags(e);
        return;
    }

    /* どこに入れればいいかを探す */
    for (;;) {
        s = t;
        t = t->next;
        if (t == 0) {
            break; /* 一番後ろになった */
        }
        if (timer->timeout <= t->timeout) {
            /* s と t の間に入れる場合 */
            s->next = timer;
            timer->next = t;
            io_store_eflags(e);
            return;
        }
    }

    /* 一番後ろに入れる場合 */
    s->next = timer;
    timer->next = 0;
    io_store_eflags(e);
    return;
}

void inthandler20(int *esp) {
    int i, j;
    struct TIMER *timer;
    io_out8(PIC0_OCW2, 0x60); /* IRQ-00 受付官僚を PIC に通知 */
    timerctl.count++;
    if (timerctl.next > timerctl.count) {
        return; /* まだ次の時刻なっていないので */
    }

    timer = timerctl.t0;
    for (i = 0; i < timerctl.using; i++) {
        /* timers のタイマは全て動作中のものなので確認しない */
        if (timer->timeout > timerctl.count) {
            break;
        }
        /* タイムアウト */
        timer->flags = TIMER_FLAGS_ALLOC;
        fifo32_put(timer->fifo, timer->data);
        timer = timer->next;
    }

    /* ちょうど i 個のタイマがタイムアウトした。残りをずらす */
    timerctl.using -= i;
    timerctl.t0 = timer;
    if (timerctl.using > 0) {
        timerctl.next = timerctl.t0->timeout;
    } else {
        timerctl.next = 0xffffffff;
    }
    return;
}
