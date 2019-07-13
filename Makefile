TOOLPATH = ./z_tools/
INCPATH  = ./z_tools/haribote/

MAKE     = make -r
EDIMG    = $(TOOLPATH)edimg
DEL      = rm -f

# デフォルト動作

default:
	$(MAKE) haribote.img

# ファイル生成規則

haribote.img: haribote/ipl20.bin haribote/haribote.sys nihongo/nihongo.fnt Makefile \
		a/a.hrb hello3/hello3.hrb hello4/hello4.hrb hello5/hello5.hrb \
		winhelo/winhelo.hrb winhelo2/winhelo2.hrb winhelo3/winhelo3.hrb \
		star1/star1.hrb stars/stars.hrb star2/star2.hrb \
		lines/lines.hrb walk/walk.hrb noodle/noodle.hrb \
		beepdown/beepdown.hrb color/color.hrb color2/color2.hrb \
		sosu/sosu.hrb sosu2/sosu2.hrb sosu3/sosu3.hrb \
		typeipl/typeipl.hrb type/type.hrb iroha/iroha.hrb chklang/chklang.hrb \
		notrec/notrec.hrb bball/bball.hrb invader/invader.hrb calc/calc.hrb \
		tview/tview.hrb
	$(EDIMG) imgin:./z_tools/fdimg0at.tek \
		wbinimg src:haribote/ipl20.bin len:512 from:0 to:0 \
		copy from:haribote/haribote.sys to:@: \
		copy from:haribote/ipl20.nas to:@: \
		copy from:a/a.hrb to:@: \
		copy from:hello3/hello3.hrb to:@: \
		copy from:hello4/hello4.hrb to:@: \
		copy from:hello5/hello5.hrb to:@: \
		copy from:winhelo/winhelo.hrb to:@: \
		copy from:winhelo2/winhelo2.hrb to:@: \
		copy from:winhelo3/winhelo3.hrb to:@: \
		copy from:star1/star1.hrb to:@: \
		copy from:stars/stars.hrb to:@: \
		copy from:star2/star2.hrb to:@: \
		copy from:lines/lines.hrb to:@: \
		copy from:walk/walk.hrb to:@: \
		copy from:noodle/noodle.hrb to:@: \
		copy from:beepdown/beepdown.hrb to:@: \
		copy from:color/color.hrb to:@: \
		copy from:color2/color2.hrb to:@: \
		copy from:sosu/sosu.hrb to:@: \
		copy from:sosu2/sosu2.hrb to:@: \
		copy from:sosu3/sosu3.hrb to:@: \
		copy from:typeipl/typeipl.hrb to:@: \
		copy from:type/type.hrb to:@: \
		copy from:iroha/iroha.hrb to:@: \
		copy from:chklang/chklang.hrb to:@: \
		copy from:shiftjis.txt to:@: \
		copy from:euc.txt to:@: \
		copy from:notrec/notrec.hrb to:@: \
		copy from:bball/bball.hrb to:@: \
		copy from:invader/invader.hrb to:@: \
		copy from:calc/calc.hrb to:@: \
		copy from:tview/tview.hrb to:@: \
		copy from:nihongo/nihongo.fnt to:@: \
		imgout:haribote.img

# コマンド

.PHONY: run full run_full run_os clean src_only clean_full src_only_full refresh

run: haribote.img
	qemu-system-i386 -L . -m 32 -rtc base=localtime -vga std -drive file=haribote.img,index=0,if=floppy,format=raw

full:
	$(MAKE) -C haribote
	$(MAKE) -C apilib
	$(MAKE) -C nihongo
	$(MAKE) -C a
	$(MAKE) -C hello3
	$(MAKE) -C hello4
	$(MAKE) -C hello5
	$(MAKE) -C winhelo
	$(MAKE) -C winhelo2
	$(MAKE) -C winhelo3
	$(MAKE) -C star1
	$(MAKE) -C stars
	$(MAKE) -C star2
	$(MAKE) -C lines
	$(MAKE) -C walk
	$(MAKE) -C noodle
	$(MAKE) -C beepdown
	$(MAKE) -C color
	$(MAKE) -C color2
	$(MAKE) -C sosu
	$(MAKE) -C sosu2
	$(MAKE) -C sosu3
	$(MAKE) -C typeipl
	$(MAKE) -C type
	$(MAKE) -C iroha
	$(MAKE) -C chklang
	$(MAKE) -C notrec
	$(MAKE) -C bball
	$(MAKE) -C invader
	$(MAKE) -C calc
	$(MAKE) -C tview
	$(MAKE) haribote.img

run_full:
	$(MAKE) full
	$(MAKE) run

run_os:
	$(MAKE) -C haribote
	$(MAKE) run

clean:
	# do nothing

src_only:
	$(MAKE) clean
	-$(DEL) haribote.img

clean_full:
	$(MAKE) -C haribote	clean
	$(MAKE) -C apilib	clean
	$(MAKE) -C nihongo	clean
	$(MAKE) -C a		clean
	$(MAKE) -C hello3	clean
	$(MAKE) -C hello4	clean
	$(MAKE) -C hello5	clean
	$(MAKE) -C winhelo	clean
	$(MAKE) -C winhelo2	clean
	$(MAKE) -C winhelo3	clean
	$(MAKE) -C star1	clean
	$(MAKE) -C stars	clean
	$(MAKE) -C star2	clean
	$(MAKE) -C lines	clean
	$(MAKE) -C walk		clean
	$(MAKE) -C noodle	clean
	$(MAKE) -C beepdown	clean
	$(MAKE) -C color	clean
	$(MAKE) -C color2	clean
	$(MAKE) -C sosu		clean
	$(MAKE) -C sosu2	clean
	$(MAKE) -C sosu3	clean
	$(MAKE) -C typeipl	clean
	$(MAKE) -C type		clean
	$(MAKE) -C iroha	clean
	$(MAKE) -C chklang	clean
	$(MAKE) -C notrec	clean
	$(MAKE) -C bball	clean
	$(MAKE) -C invader	clean
	$(MAKE) -C calc		clean
	$(MAKE) -C tview	clean

src_only_full:
	$(MAKE) -C haribote	src_only
	$(MAKE) -C apilib	src_only
	$(MAKE) -C nihongo	src_only
	$(MAKE) -C a		src_only
	$(MAKE) -C hello3	src_only
	$(MAKE) -C hello4	src_only
	$(MAKE) -C hello5	src_only
	$(MAKE) -C winhelo	src_only
	$(MAKE) -C winhelo2	src_only
	$(MAKE) -C winhelo3	src_only
	$(MAKE) -C star1	src_only
	$(MAKE) -C stars	src_only
	$(MAKE) -C star2	src_only
	$(MAKE) -C lines	src_only
	$(MAKE) -C walk		src_only
	$(MAKE) -C noodle	src_only
	$(MAKE) -C beepdown	src_only
	$(MAKE) -C color	src_only
	$(MAKE) -C color2	src_only
	$(MAKE) -C sosu		src_only
	$(MAKE) -C sosu2	src_only
	$(MAKE) -C sosu3	src_only
	$(MAKE) -C typeipl	src_only
	$(MAKE) -C type		src_only
	$(MAKE) -C iroha	src_only
	$(MAKE) -C chklang	src_only
	$(MAKE) -C notrec	src_only
	$(MAKE) -C bball	src_only
	$(MAKE) -C invader	src_only
	$(MAKE) -C calc		src_only
	$(MAKE) -C tview	src_only
	-$(DEL) haribote.img

refresh:
	$(MAKE) full
	$(MAKE) clean_full
	-$(DEL) haribote.img
