MAIN PROC

	;INITIALIZE DATA SEGMENT
	MOV AX, @DATA
	MOV DS, AX

	PUSH BP
	MOV BP , SP

	SUB SP , 2

	MOV AX, 2
	NEG AX
	MOV T1, AX

	MOV AX, T1
	MOV [BP - 4], AX

	MOV AX, [BP - 4]
	MOV [BP - 4], AX

	MOV AX, [BP - 4]
	MOV [BP - 2], AX
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID
	MOV AX, [BP - 4]
	INC AX
	MOV [BP - 4], AX

	MOV AX, 
	MOV [BP - 4], AX

	MOV AX, [BP - 6]
	MOV [BP - 2], AX
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID

	MOV AX, [BP - 4]
	MOV [BP - 2], AX
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID

	MOV AX, [BP - 2]
	ADD AX, 0
	MOV T2, AX

	MOV AX, T2
	MOV [BP - 2], AX

	MOV AX, [BP - 2]
	SUB AX, 0
	MOV T3, AX

	MOV AX, T3
	MOV [BP - 2], AX

	MOV AX, [BP - 2]
	MOV BX, 1
	MUL BX
	MOV T4, AX

	MOV AX, T4
	MOV [BP - 2], AX
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID

	MOV AX, [BP - 2]
	CMP AX, 0
	JG Label1

	MOV T5, 0
	JMP Label2

	Label1:
	MOV T5, 1

	Label2:

	MOV AX, [BP - 2]
	CMP AX, 10
	JL Label3

	MOV T6, 0
	JMP Label4

	Label3:
	MOV T6, 1

	Label4:

	MOV AX, T5
	MOV BX, T6
	CMP AX, 1
	JNE Label5
	CMP BX, 1
	JNE Label5
	MOV AX, 1
	MOV T7, AX
	JMP Label6

	Label5:
	MOV AX, 0
	MOV T7, AX

	Label6:

	MOV AX, [BP - 2]
	CMP AX, 0
	JL Label7

	MOV T8, 0
	JMP Label8

	Label7:
	MOV T8, 1

	Label8:

	MOV AX, 10
	NEG AX
	MOV T9, AX

	MOV AX, [BP - 2]
	CMP AX, T9
	JG Label9

	MOV T10, 0
	JMP Label10

	Label9:
	MOV T10, 1

	Label10:

	MOV AX, T8
	MOV BX, T10
	CMP AX, 1
	JNE Label11
	CMP BX, 1
	JNE Label11
	MOV AX, 1
	MOV T11, AX
	JMP Label12

	Label11:
	MOV AX, 0
	MOV T11, AX

	Label12:

	MOV AX, T7
	MOV BX, T11
	CMP AX, 1
	JE Label13
	CMP BX, 1
	JE Label13
	MOV AX, 0
	MOV T12, AX
	JMP Label14

	Label13:
	MOV AX, 1
	MOV T12, AX

	Label14:

	MOV AX, 100
	MOV [BP - 2], AX

	MOV AX, 200
	MOV [BP - 2], AX
;--------if else block---------
	MOV AX, T12
	CMP AX, 0
	JE Label15
	JMP Label16
	Label15:

	Label16:
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID
	ADD SP, 22
	POP BP


	MOV AX, 4CH
	INT 21H
MAIN ENDP

END MAIN

.MODEL SMALL
.STACK 100H
.DATA
	T1 DW ?
	T2 DW ?
	T3 DW ?
	T4 DW ?
	T5 DW ?
	T6 DW ?
	T7 DW ?
	T8 DW ?
	T9 DW ?
	T10 DW ?
	T11 DW ?
	T12 DW ?
.CODE
;------printing procedure----
PRINT_ID PROC

	;SAVE IN STACK
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX

	;CHECK IF NEGATIVE
	OR AX, AX
	JGE PRINT_NUMBER

	;PRINT MINUS SIGN
	PUSH AX
	MOV AH, 2
	MOV DL, '-'
	INT 21H
	POP AX

	NEG AX

	PRINT_NUMBER:
	XOR CX, CX
	MOV BX, 10D

	REPEAT_CALC:

		;AX:DX- QUOTIENT:REMAINDER
		XOR DX, DX
		DIV BX  ;DIVIDE BY 10
		PUSH DX ;PUSH THE REMAINDER IN STACK

		INC CX

		OR AX, AX
		JNZ REPEAT_CALC

	MOV AH, 2

	PRINT_LOOP:
		POP DX
		ADD DL, 30H
		INT 21H
		LOOP PRINT_LOOP

	;NEWLINE
	MOV AH, 2
	MOV DL, 0AH
	INT 21H
	MOV DL, 0DH
	INT 21H

	POP DX
	POP CX
	POP BX
	POP AX

	RET
PRINT_ID ENDP

