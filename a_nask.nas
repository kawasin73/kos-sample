[FORMAT "WCOFF"]						; オブジェクトファイルを作るモード
[INSTRSET "i486p"]						; 486 の命令まで使いたいという記述
[BITS 32]								; 32 ビットモード用の機械語を作らせる
[FILE "a_nask.nas"]						; ソースファイル情報

		GLOBAL	_api_putchar
		GLOBAL	_api_putstr0
		GLOBAL	_api_end

[SECTION .text]

_api_putchar:			; void api_putchar(int c);
		MOV		EDX,1
		MOV		AL,[ESP+4]				; c
		INT		0x40
		RET

_api_putstr0:			; void api_putstr0(char *s);
		PUSH	EBX
		MOV		EDX,2
		MOV		EBX,[ESP+8]				; s
		INT		0x40
		POP		EBX
		RET

_api_end:				; void api_end(void);
		MOV		EDX,4
		INT		0x40
