[INSTRSET "i486p"]
[BITS 32]
		MOV		EAX,1*8				; OS 用のセグメント番号
		MOV		DS,AX				; これを DS に入れる
		MOV		BYTE [0x102600],0
		RETF
