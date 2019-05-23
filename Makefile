TOOLPATH = ./z_tools/
MAKE     = make -r
NASK     = $(TOOLPATH)nask
EDIMG    = $(TOOLPATH)edimg
DEL      = rm -f

ipl10.bin: ipl10.nas Makefile
	$(NASK) ipl10.nas ipl10.bin ipl10.lst

haribote.sys: haribote.nas Makefile
	$(NASK) haribote.nas haribote.sys haribote.lst

haribote.img: ipl10.bin haribote.sys Makefile
	$(EDIMG) imgin:./z_tools/fdimg0at.tek \
		wbinimg src:ipl10.bin len:512 from:0 to:0 \
		copy from:haribote.sys to:@: \
		imgout:haribote.img

.PHONY: img asm run clean src_only
img:
	$(MAKE) haribote.img

run: img
	qemu-system-i386 -L . -m 32 -rtc base=localtime -vga std -drive file=haribote.img,index=0,if=floppy,format=raw

clean:
	$(DEL) ipl10.bin ipl10.lst haribote.sys haribote.lst

src_only:
	$(MAKE) clean
	$(DEL) haribote.img
