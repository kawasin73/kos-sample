#include "../apilib.h"

void HariMain(void) {
    char buf[150 * 50];
    int win;
    win = api_openwin(buf, 150, 50, -1, "hello");
    for (;;) {
        if (api_getkey(1) == 0x0a) {
            break; /* Enter なら break */
        }
    }
    api_end();
}
