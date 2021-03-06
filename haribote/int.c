/* 割り込み関係 */

#include "bootpack.h"
#include <stdio.h>

/* PIC の初期化 */
void init_pic(void) {
    io_out8(PIC0_IMR, 0xff  ); /* 全ての割り込みを受け付けない */
    io_out8(PIC1_IMR, 0xff  ); /* 全ての割り込みを受け付けない */

    io_out8(PIC0_ICW1, 0x11  ); /* エッジトリガモード */
    io_out8(PIC0_ICW2, 0x20  ); /* IRQ0-7 は、INT20-27 で受ける */
    io_out8(PIC0_ICW3, 1 << 2); /* PIC1 は IRQ2 にて接続 */
    io_out8(PIC0_ICW4, 0x01  ); /* ノンバッファモード */

    io_out8(PIC1_ICW1, 0x11  ); /* エッジトリガモード */
    io_out8(PIC1_ICW2, 0x28  ); /* IRQ8-15 は、INT28-2f で受ける */
    io_out8(PIC1_ICW3, 2     ); /* PIC1 は IRQ2 にて接続 */
    io_out8(PIC1_ICW4, 0x01  ); /* ノンバッファモード */

    io_out8(PIC0_IMR, 0xfb  ); /* 11111011 PIC1 以外は全て禁止 */
    io_out8(PIC1_IMR, 0xff  ); /* 11111111 全ての割り込みを受け付けない */

    return;
}

/* PIC0 からの不完全割り込み対策 */
/* Athlon64X2 機などではチップセットの都合により PIC の初期化時にこの割り込みが一度だけ起こる */
/* この割り込み処理関数はその割り込みに対して何もしないでやり過ごす */
/* この割り込みは PIC 初期化時の電気的なノイズによって発生したものなので真面目に処理する必要がない */
void inthandler27(int *esp) {
    io_out8(PIC0_OCW2, 0x67); /* IRQ-07 受付完了を PIC に通知 */
    return;
}
