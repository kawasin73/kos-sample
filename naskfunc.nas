; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード
[INSTRSET "i486p"]				; 486 の命令まで使いたいという記述
[BITS 32]						; 32ビットモード用の機械語を作らせる

; オブジェクトファイルのための情報

[FILE "naskfunc.nas"]			; ソースファイル名情報

		GLOBAL		_io_hlt		; このプログラムに含まれる関数名

; 以下は実際の関数

[SECTION .text]	; オブジェクトファイルではこれを書いてからプログラムを書く

_io_hlt:	; void io_hlt(void);
		HLT
		RET
