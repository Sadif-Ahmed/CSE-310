.MODEL SMALL
.STACK 100H
.DATA
	i1 DW ?
	j1 DW ?
	T1 DW ?
	T2 DW ?
	T3 DW ?
	T4 DW ?
	T5 DW ?
	T6 DW ?
	T7 DW ?
	T8 DW ?
	T9 DW ?
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

MAIN PROC

	;INITIALIZE DATA SEGMENT
	MOV AX, @DATA
	MOV DS, AX

	PUSH BP
	MOV BP , SP

	SUB SP , 2
	SUB SP , 2
	SUB SP , 2
	SUB SP , 2
	SUB SP , 2
	SUB SP , 2

	MOV AX, 1
	MOV i1, AX
	INC AX
	MOV i1, AX
;--------print function called---------

	CALL PRINT_ID

	MOV AX, 5
	ADD AX, 8
	MOV T1, AX

	MOV j1, AX
;--------print function called---------

	CALL PRINT_ID

	MOV AX, 2
	MOV BX, j1
	MUL BX
	MOV T2, AX

	MOV AX, i1
	ADD AX, T2
	MOV T3, AX

	MOV [BP - 2], AX
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID

	MOV AX, [BP - 2]
	MOV BX, 9
	XOR DX, DX
	DIV BX
	MOV T4 , DX

	MOV AX, T4
	MOV [BP - 6], AX
;--------print function called---------

	MOV AX, [BP - 6]
	CALL PRINT_ID

	MOV AX, [BP - 6]
	CMP AX, [BP - 4]
	JLE Label1

	MOV T5, 0
	JMP Label2

	Label1:
	MOV T5, 1

	Label2:

	MOV AX, T5
	MOV [BP - 8], AX
;--------print function called---------

	MOV AX, [BP - 8]
	CALL PRINT_ID

	MOV AX, i1
	CMP AX, j1
	JNE Label3

	MOV T6, 0
	JMP Label4

	Label3:
	MOV T6, 1

	Label4:

	MOV AX, T6
	MOV [BP - 10], AX
;--------print function called---------

	MOV AX, [BP - 10]
	CALL PRINT_ID

	MOV AX, [BP - 8]
	MOV BX, [BP - 10]
	CMP AX, 1
	JE Label5
	CMP BX, 1
	JE Label5
	MOV AX, 0
	MOV T7, AX
	JMP Label6

	Label5:
	MOV AX, 1
	MOV T7, AX

	Label6:

	MOV AX, T7
	MOV [BP - 12], AX
;--------print function called---------

	MOV AX, [BP - 12]
	CALL PRINT_ID

	MOV AX, [BP - 8]
	MOV BX, [BP - 10]
	CMP AX, 1
	JNE Label7
	CMP BX, 1
	JNE Label7
	MOV AX, 1
	MOV T8, AX
	JMP Label8

	Label7:
	MOV AX, 0
	MOV T8, AX

	Label8:

	MOV AX, T8
	MOV [BP - 12], AX
;--------print function called---------

	MOV AX, [BP - 12]
	CALL PRINT_ID
	MOV AX, [BP - 12]
	INC AX
	MOV [BP - 12], AX
;--------print function called---------

	MOV AX, [BP - 12]
	CALL PRINT_ID

	MOV AX, [BP - 12]
	NEG AX
	MOV T9, AX

	MOV [BP - 2], AX
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID
	ADD SP, 12
	POP BP


	MOV AX, 4CH
	INT 21H
MAIN ENDP

END MAIN

