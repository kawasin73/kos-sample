.PHONY: run
run:
	./z_tools/nask helloos.nas helloos.img
	qemu-system-i386 -L . -m 32 -rtc base=localtime -vga std -drive file=helloos.img,index=0,if=floppy,format=raw
