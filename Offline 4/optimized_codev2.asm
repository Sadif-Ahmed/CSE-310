.MODEL SMALL
.STACK 100H
.DATA
	T1 DW ?
	T2 DW ?
	T3 DW ?
	T4 DW ?
	T5 DW ?
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

	MOV AX, 3
	MOV [BP - 2], AX

	MOV AX, 8
	MOV [BP - 4], AX

	MOV AX, 6
	MOV [BP - 6], AX

	MOV AX, [BP - 2]
	CMP AX, 3
	JE Label1

	MOV T1, 0
	JMP Label2

	Label1:
	MOV T1, 1

	Label2:
;--------print function called---------

	MOV AX, [BP - 4]
	CALL PRINT_ID
;--------if block---------
	MOV AX, T1
	CMP AX, 0
	JE Label3
	Label3:

	MOV AX, [BP - 4]
	CMP AX, 8
	JL Label4

	MOV T2, 0
	JMP Label5

	Label4:
	MOV T2, 1

	Label5:
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID
;--------print function called---------

	MOV AX, [BP - 6]
	CALL PRINT_ID
;--------if else block---------
	MOV AX, T2
	CMP AX, 0
	JE Label6
	JMP Label7
	Label6:

	Label7:

	MOV AX, [BP - 6]
	CMP AX, 6
	JNE Label8

	MOV T3, 0
	JMP Label9

	Label8:
	MOV T3, 1

	Label9:
;--------print function called---------

	MOV AX, [BP - 6]
	CALL PRINT_ID

	MOV AX, [BP - 4]
	CMP AX, 8
	JG Label10

	MOV T4, 0
	JMP Label11

	Label10:
	MOV T4, 1

	Label11:
;--------print function called---------

	MOV AX, [BP - 4]
	CALL PRINT_ID

	MOV AX, [BP - 2]
	CMP AX, 5
	JL Label12

	MOV T5, 0
	JMP Label13

	Label12:
	MOV T5, 1

	Label13:
;--------print function called---------

	MOV AX, [BP - 2]
	CALL PRINT_ID

	MOV AX, 0
	MOV [BP - 6], AX
;--------print function called---------

	MOV AX, [BP - 6]
	CALL PRINT_ID
;--------if else block---------
	MOV AX, T5
	CMP AX, 0
	JE Label14
	JMP Label15
	Label14:

	Label15:
;--------if else block---------
	MOV AX, T4
	CMP AX, 0
	JE Label16
	JMP Label17
	Label16:

	Label17:
;--------if else block---------
	MOV AX, T3
	CMP AX, 0
	JE Label18
	JMP Label19
	Label18:

	Label19:
	ADD SP, 6
	POP BP


	MOV AX, 4CH
	INT 21H
MAIN ENDP

END MAIN

