
_Lms_Init:

;Lms.c,8 :: 		void Lms_Init(void){
;Lms.c,9 :: 		_lms.status = Button(&PORTA, 9, 20, 1);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#1, W13
	MOV	#20, W12
	MOV	#9, W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Button
	MOV	#lo_addr(__lms), W1
	MOV.B	W0, [W1]
;Lms.c,10 :: 		_lms.buzzer = 0;
	MOV	#lo_addr(__lms+1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Lms.c,11 :: 		}
L_end_Lms_Init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Lms_Init

_Lms_isPressed:

;Lms.c,13 :: 		uint8_t Lms_isPressed(void){
;Lms.c,14 :: 		_lms.status = Button(&PORTA, 9, 20, 1);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#1, W13
	MOV	#20, W12
	MOV	#9, W11
	MOV	#lo_addr(PORTA), W10
	CALL	_Button
	MOV	#lo_addr(__lms), W1
	MOV.B	W0, [W1]
;Lms.c,15 :: 		if (_lms.status == 255)
	MOV.B	#255, W1
	CP.B	W0, W1
	BRA Z	L__Lms_isPressed4
	GOTO	L_Lms_isPressed0
L__Lms_isPressed4:
;Lms.c,16 :: 		return 1;
	MOV.B	#1, W0
	GOTO	L_end_Lms_isPressed
L_Lms_isPressed0:
;Lms.c,17 :: 		else return 0;
	CLR	W0
;Lms.c,18 :: 		}
;Lms.c,17 :: 		else return 0;
;Lms.c,18 :: 		}
L_end_Lms_isPressed:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Lms_isPressed

_Lms_Task:

;Lms.c,20 :: 		void Lms_Task(void){
;Lms.c,22 :: 		}
L_end_Lms_Task:
	RETURN
; end of _Lms_Task
