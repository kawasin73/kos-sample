
ipl.bin: ipl.nas Makefile
	./z_tools/nask ipl.nas ipl.bin ipl.lst

helloos.img: ipl.bin Makefile
	./z_tools/edimg imgin:./z_tools/fdimg0at.tek wbinimg src:ipl.bin len:512 from:0 to:0 imgout:helloos.img

.PHONY: img asm run clean src_only
img:
	make -r helloos.img

asm:
	make -r ipl.bin

run: img
	qemu-system-i386 -L . -m 32 -rtc base=localtime -vga std -drive file=helloos.img,index=0,if=floppy,format=raw

clean:
	rm -f ipl.bin ipl.lst

src_only:
	make -r clean
	rm -f helloos.img
