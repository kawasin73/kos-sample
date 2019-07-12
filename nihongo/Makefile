TOOLPATH = ../z_tools/
INCPATH  = ../z_tools/haribote/

MAKE     = make -r
BIM2BIN  = $(TOOLPATH)bim2bin
DEL      = rm -f

# デフォルト動作

default:
	$(MAKE) nihongo.fnt

# ファイル生成規則

nihongo.fnt: nihongo.org Makefile
	$(BIM2BIN) -osacmp in:nihongo.org out:nihongo.fnt -tek2

# 一般規則

# コマンド

.PHONY: clean src_only

clean:
	-$(DEL) nihongo.fnt

src_only:
	$(MAKE) clean
