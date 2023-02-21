.MODEL SMALL
.STACK 100H
.DATA
	i1 DW ?
	j1 DW ?
	k2 DW ?
	ll2 DW ?
	m2 DW ?
	n2 DW ?
	o2 DW ?
	p2 DW ?
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

 
	MOV AX, 1
	MOV i2, AX
 	MOV AX, i2
	INC AX
	MOV i2, AX
 ;--------print function called---------

	MOV AX, i2
	CALL PRINT_ID
 
	MOV AX, 5
	ADD AX, 8
	MOV T1, AX

	MOV AX, T1
	MOV j2, AX
 ;--------print function called---------

	MOV AX, j2
	CALL PRINT_ID
 
	MOV AX, 2
	MOV BX, j2
	MUL BX
	MOV T2, AX

	MOV AX, i2
	ADD AX, T2
	MOV T3, AX

	MOV AX, T3
	MOV k2, AX
 ;--------print function called---------

	MOV AX, k2
	CALL PRINT_ID
 
	MOV AX, k2
	MOV BX, 9
	XOR DX, DX
	DIV BX
	MOV T4 , DX

	MOV AX, T4
	MOV m2, AX
 ;--------print function called---------

	MOV AX, m2
	CALL PRINT_ID
 
	MOV AX, m2
	CMP AX, ll2
	JLE Label1

	MOV T5, 0
	JMP Label2

	Label1:
	MOV T5, 1

	Label2:

	MOV AX, T5
	MOV n2, AX
 ;--------print function called---------

	MOV AX, n2
	CALL PRINT_ID
 
	MOV AX, i2
	CMP AX, j2
	JNE Label3

	MOV T6, 0
	JMP Label4

	Label3:
	MOV T6, 1

	Label4:

	MOV AX, T6
	MOV o2, AX
 ;--------print function called---------

	MOV AX, o2
	CALL PRINT_ID
 
	MOV AX, n2
	MOV BX, o2
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
	MOV p2, AX
 ;--------print function called---------

	MOV AX, p2
	CALL PRINT_ID
 
	MOV AX, n2
	MOV BX, o2
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
	MOV p2, AX
 ;--------print function called---------

	MOV AX, p2
	CALL PRINT_ID
 	MOV AX, p2
	INC AX
	MOV p2, AX
 ;--------print function called---------

	MOV AX, p2
	CALL PRINT_ID
 
	MOV AX, p2
	NEG AX
	MOV T9, AX

	MOV AX, T9
	MOV k2, AX
 ;--------print function called---------

	MOV AX, k2
	CALL PRINT_ID
 
	MOV AX, 4CH
	INT 21H
MAIN ENDP

END MAIN

