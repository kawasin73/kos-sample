#include "../apilib.h"

int rand(void); /* 0 ~ 32797 の範囲で乱数を発生 */

void HariMain(void) {
    char *buf;
    int win, i, x, y;
    api_initmalloc();
    buf = api_malloc(150*100);
    win = api_openwin(buf, 150, 100, -1, "stars");
    api_boxfilwin(win, 6, 26, 143, 93, 0 /* 黑 */);
    for (i = 0; i < 50; i++) {
        x = (rand() % 137) + 6;
        y = (rand() % 67) + 26;
        api_point(win, x, y, 3 /* 青 */);
    }
    for (;;) {
        if (api_getkey(1) == 0x0a) {
            break; /* Enter なら break */
        }
    }
    api_end();
}
