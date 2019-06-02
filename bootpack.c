#include "bootpack.h"
#include <stdio.h>

extern struct KEYBUF keybuf;

void HariMain(void)
{
    struct BOOTINFO *binfo = (struct BOOTINFO *) ADR_BOOTINFO;
    char s[40], mcursor[256];
    int mx, my, i;

    init_gdtidt();
    init_pic();
    io_sti(); /* IDT/PIC の初期化が終わったので CPU の割り込み禁止を解除 */

    init_palette();
    init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
    init_mouse_cursor8(mcursor, COL8_008484);

    /* 画面中央になるように計算 */
    mx = (binfo->scrnx - 16) / 2;
    my = (binfo->scrny - 28 - 16) / 2;

    putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mcursor, 16);

    sprintf(s, "(%d, %d)", mx, my);
    putfonts8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);

    io_out8(PIC0_IMR, 0xf9); /* PIC1 とキーボードを許可 (11111001) */
    io_out8(PIC1_IMR, 0xef); /* マウスを許可 (11101111) */

    for (;;) {
        io_cli();
        if (keybuf.flag == 0) {
            io_stihlt();
        } else {
            i = keybuf.data;
            keybuf.flag = 0;
            io_sti();
            sprintf(s, "%02X", i);
            boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 16, 15, 31);
            putfonts8_asc(binfo->vram, binfo->scrnx, 0, 16, COL8_FFFFFF, s);
        }
    }
}
