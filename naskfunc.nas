; naskfunc
; TAB=4

[FORMAT "WCOFF"]				; オブジェクトファイルを作るモード
[INSTRSET "i486p"]				; 486 の命令まで使いたいという記述
[BITS 32]						; 32ビットモード用の機械語を作らせる

; オブジェクトファイルのための情報

[FILE "naskfunc.nas"]			; ソースファイル名情報

		GLOBAL	_io_hlt, _io_cli, _io_sti, _io_stihlt
		GLOBAL	_io_in8, _io_in16, _io_in32
		GLOBAL	_io_out8, _io_out16, _io_out32
		GLOBAL	_io_load_eflags, _io_store_eflags
		GLOBAL	_load_gdtr, _load_idtr
		GLOBAL	_load_cr0, _store_cr0
		GLOBAL	_load_tr
		GLOBAL	_asm_inthandler20, _asm_inthandler21
		GLOBAL	_asm_inthandler27, _asm_inthandler2c
		GLOBAL	_memtest_sub
		GLOBAL	_farjmp, _farcall
		GLOBAL	_asm_hrb_api, _start_app
		EXTERN	_inthandler20, _inthandler21
		EXTERN	_inthandler27, _inthandler2c
		EXTERN	_hrb_api

; 以下は実際の関数

[SECTION .text]	; オブジェクトファイルではこれを書いてからプログラムを書く

_io_hlt:	; void io_hlt(void);
		HLT
		RET

_io_cli:	; void io_cli(void);
		CLI
		RET

_io_sti:	; void io_sti(void);
		STI
		RET

_io_stihlt:	; void io_stihlt(void);
		STI
		HLT
		RET

_io_in8:	; int io_in8(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AL,DX
		RET

_io_in16:	; int io_in16(int port);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,0
		IN		AX,DX
		RET

_io_in32:	; int io_in32(int port);
		MOV		EDX,[ESP+4]		; port
		IN		EAX,DX
		RET

_io_out8:	; void io_out8(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		AL,[ESP+8]		; data
		OUT		DX,AL
		RET

_io_out16:	; void io_out16(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,AX
		RET

_io_out32:	; void io_out32(int port, int data);
		MOV		EDX,[ESP+4]		; port
		MOV		EAX,[ESP+8]		; data
		OUT		DX,EAX
		RET

_io_load_eflags:	; int io_load_eflags(void);
		PUSHFD					; PUSH EFLAGS という意味
		POP		EAX
		RET

_io_store_eflags:	; void io_store_eflags(int eflags);
		MOV		EAX,[ESP+4]
		PUSH	EAX
		POPFD					; POP EFLAGS という意味
		RET

_load_gdtr:			; void _load_gdtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LGDT	[ESP+6]
		RET

_load_idtr:			; void _load_idtr(int limit, int addr);
		MOV		AX,[ESP+4]		; limit
		MOV		[ESP+6],AX
		LIDT	[ESP+6]
		RET

_load_cr0:			; int load_cr0(void);
		MOV		EAX,CR0
		RET

_store_cr0:			; void store_cr0(int cr0);
		MOV		EAX,[ESP+4]
		MOV		CR0,EAX
		RET

_load_tr:			; void load_tr(int tr)
		LTR		[ESP+4]
		RET

_asm_inthandler20:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
; OS が動いている時に割り込まれたのでほぼ今まで通り
		MOV		EAX,ESP
		PUSH	SS						; 割り込まれた時の SS  を保存
		PUSH	EAX						; 割り込まれた時の EAX を保存
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler20
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
; アプリが動いている時に割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX					; とりあえず DS だけ OS 用にする
		MOV		ECX,[0xfe4]				; OS の ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS				; 割り込まれた時の SS  を保存
		MOV		[ECX],ESP				; 割り込まれた時の ESP を保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler20
		POP		ECX
		POP		EAX
		MOV		SS,AX					; SS をアプリ用に戻す
		MOV		ESP,ECX					; ESP もアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler21:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
; OS が動いている時に割り込まれたのでほぼ今まで通り
		MOV		EAX,ESP
		PUSH	SS						; 割り込まれた時の SS  を保存
		PUSH	EAX						; 割り込まれた時の EAX を保存
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler21
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
; アプリが動いている時に割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX					; とりあえず DS だけ OS 用にする
		MOV		ECX,[0xfe4]				; OS の ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS				; 割り込まれた時の SS  を保存
		MOV		[ECX],ESP				; 割り込まれた時の ESP を保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler21
		POP		ECX
		POP		EAX
		MOV		SS,AX					; SS をアプリ用に戻す
		MOV		ESP,ECX					; ESP もアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler27:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
; OS が動いている時に割り込まれたのでほぼ今まで通り
		MOV		EAX,ESP
		PUSH	SS						; 割り込まれた時の SS  を保存
		PUSH	EAX						; 割り込まれた時の EAX を保存
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler27
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
; アプリが動いている時に割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX					; とりあえず DS だけ OS 用にする
		MOV		ECX,[0xfe4]				; OS の ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS				; 割り込まれた時の SS  を保存
		MOV		[ECX],ESP				; 割り込まれた時の ESP を保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler27
		POP		ECX
		POP		EAX
		MOV		SS,AX					; SS をアプリ用に戻す
		MOV		ESP,ECX					; ESP もアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
		IRETD

_asm_inthandler2c:
		PUSH	ES
		PUSH	DS
		PUSHAD
		MOV		AX,SS
		CMP		AX,1*8
		JNE		.from_app
; OS が動いている時に割り込まれたのでほぼ今まで通り
		MOV		EAX,ESP
		PUSH	SS						; 割り込まれた時の SS  を保存
		PUSH	EAX						; 割り込まれた時の EAX を保存
		MOV		AX,SS
		MOV		DS,AX
		MOV		ES,AX
		CALL	_inthandler2c
		ADD		ESP,8
		POPAD
		POP		DS
		POP		ES
		IRETD
.from_app:
; アプリが動いている時に割り込まれた
		MOV		EAX,1*8
		MOV		DS,AX					; とりあえず DS だけ OS 用にする
		MOV		ECX,[0xfe4]				; OS の ESP
		ADD		ECX,-8
		MOV		[ECX+4],SS				; 割り込まれた時の SS  を保存
		MOV		[ECX],ESP				; 割り込まれた時の ESP を保存
		MOV		SS,AX
		MOV		ES,AX
		MOV		ESP,ECX
		CALL	_inthandler2c
		POP		ECX
		POP		EAX
		MOV		SS,AX					; SS をアプリ用に戻す
		MOV		ESP,ECX					; ESP もアプリ用に戻す
		POPAD
		POP		DS
		POP		ES
		IRETD

_memtest_sub:		; unsigned int memtest(unsigned int start, unsigned int end);
		PUSH	EDI						; (EBX, ESI, EDI も使いたいので)
		PUSH	ESI
		PUSH	EBX
		MOV		ESI,0xaa55aa55			; pat0 = 0xaa55aa55;
		MOV		EDI,0x55aa55aa			; pat1 = 0x55aa55aa;
		MOV		EAX,[ESP+12+4]			; i = start;
mts_loop:
		MOV		EBX,EAX
		ADD		EBX,0xffc				; p = i + 0xffc;
		MOV		EDX,[EBX]				; old = *p;
		MOV		[EBX],ESI				; *p = pat0;
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		EDI,[EBX]				; if (*p != pat1) goto fin;
		JNE		mts_fin
		XOR		DWORD [EBX],0xffffffff	; *p ^= 0xffffffff;
		CMP		ESI,[EBX]				; if (*p != pat0) goto fin;
		JNE		mts_fin
		MOV		[EBX],EDX				; *p = old;
		ADD		EAX,0x1000				; i += 0x1000;
		CMP		EAX,[ESP+12+8]			; if (i <= end) goto mts_loop;
		JBE		mts_loop
		POP		EBX
		POP		ESI
		POP		EDI
		RET
mts_fin:
		MOV		[EBX],EDX				; *p = old;
		POP		EBX
		POP		ESI
		POP		EDI
		RET

_farjmp:		; void farjmp(int eip, int cs);
		JMP		FAR [ESP+4]
		RET

_farcall:		; void farcall(int eip, int cs);
		CALL	FAR [ESP+4]
		RET

_asm_hrb_api:
		; 最初から割り込み禁止になっている
		PUSH	DS
		PUSH	ES
		PUSHAD							; 保存のためのPUSH
		MOV		EAX,1*8
		MOV		DS,AX					; とりあえず DS だけ OS 用にする
		MOV		ECX,[0xfe4]				; OS の ESP
		ADD		ECX,-40
		MOV		[ECX+32],ESP			; アプリの ESP を保存
		MOV		[ECX+36],SS				; アプリの SS  を保存

; PUSHAD した値をシステムのスタックにコピーする
		MOV		EDX,[ESP]
		MOV		EBX,[ESP+4]
		MOV		[ECX],EDX				; hrb_api に渡すためコピー
		MOV		[ECX+4],EBX				; hrb_api に渡すためコピー
		MOV		EDX,[ESP+8]
		MOV		EBX,[ESP+12]
		MOV		[ECX+8],EDX				; hrb_api に渡すためコピー
		MOV		[ECX+12],EBX			; hrb_api に渡すためコピー
		MOV		EDX,[ESP+16]
		MOV		EBX,[ESP+20]
		MOV		[ECX+16],EDX			; hrb_api に渡すためコピー
		MOV		[ECX+20],EBX			; hrb_api に渡すためコピー
		MOV		EDX,[ESP+24]
		MOV		EBX,[ESP+28]
		MOV		[ECX+24],EDX			; hrb_api に渡すためコピー
		MOV		[ECX+28],EBX			; hrb_api に渡すためコピー

		MOV		ES,AX					; 残りのセグメントレジスタも OS 用にする
		MOV		SS,AX
		MOV		ESP,ECX
		STI								; 割り込み許可

		CALL	_hrb_api

		MOV		ECX,[ESP+32]			; アプリの ESP を思い出す
		MOV		EAX,[ESP+36]			; アプリの SS  を思い出す
		CLI
		MOV		SS,AX
		MOV		ESP,ECX
		POPAD
		POP		ES
		POP		DS
		IRETD							; この命令が自動で STI してくれる

_start_app:			; void start_app(int eip, int cs, int esp, int ds);
		PUSHAD							; 32 ビットレジスタを全部保存しておく
		MOV		EAX,[ESP+36]			; アプリ用の EIP
		MOV		ECX,[ESP+40]			; アプリ用の CS
		MOV		EDX,[ESP+44]			; アプリ用の ESP
		MOV		EBX,[ESP+48]			; アプリ用の DS/SS
		MOV		[0xfe4],ESP				; OS 用の ESP
		CLI								; 切り替え中に割り込みが起きないように禁止
		MOV		ES,BX
		MOV		SS,BX
		MOV		DS,BX
		MOV		FS,BX
		MOV		GS,BX
		MOV		ESP,EDX
		STI								; 切り替え完了
		PUSH	ECX						; far-CALL のために PUSH (cs)
		PUSH	EAX						; far-CALL のために PUSH (eip)
		CALL	FAR [ESP]				; アプリを呼び出す

;	アプリが終了するとここに帰ってくる

		MOV		EAX,1*8					; OS 用の DS/SS
		CLI								; 切り替えるので割り込み禁止
		MOV		ES,AX
		MOV		SS,AX
		MOV		DS,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		ESP,[0xfe4]
		STI								; 切り替え完了
		POPAD							; 保存しておいたレジスタを回復
		RET
