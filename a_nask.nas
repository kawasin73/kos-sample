[FORMAT "WCOFF"]						; オブジェクトファイルを作るモード
[INSTRSET "i486p"]						; 486 の命令まで使いたいという記述
[BITS 32]								; 32 ビットモード用の機械語を作らせる
[FILE "a_nask.nas"]						; ソースファイル情報

		GLOBAL	_api_putchar

[SECTION .text]

_api_putchar:
		MOV		EDX,1
		MOV		AL,[ESP+4]				; c
		INT		0x40
		RET
