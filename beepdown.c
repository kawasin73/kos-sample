void api_putstr0(char *s);
int api_openwin(char *buf, int xsiz, int ysiz, int col_inv, char *title);
void api_putstrwin(int win, int x, int y, int col, int len, char *str);
void api_boxfilwin(int win, int x0, int y0, int x1, int y1, int col);
void api_initmalloc(void);
char *api_malloc(int size);
void api_linewin(int win, int x0, int y0, int x1, int y1, int col);
void api_refreshwin(int win, int x0, int y0, int x1, int y1);
void api_closewin(int win);
int api_getkey(int mode);
int api_alloctimer(void);
void api_inittimer(int timer, int data);
void api_settimer(int timer, int time);
void api_freetimer(int timer);
void api_beep(int tone);
void api_end(void);

void HariMain(void) {
    int i, timer;

    timer = api_alloctimer();
    api_inittimer(timer, 128);
    for (i = 20000000; i >= 20000; i -= i / 100) {
        /* 20KHz ~ 20Hz : 人間に聞こえる音の範囲 */
        /* i は 1% ずつ減らされていく */
        api_beep(i);
        api_settimer(timer, 1); /* 0.01 秒 */
        if (api_getkey(1) != 128) {
            break;
        }
    }
    api_beep(0);
    api_end();
}
