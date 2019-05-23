/* 他のファイルで作った関数がありますとCコンパイラに教える*/

void io_hlt(void);

void HariMain(void)
{
fin:
    io_hlt();
    goto fin;
}
