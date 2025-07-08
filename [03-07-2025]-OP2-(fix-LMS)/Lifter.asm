
__Lifter_Init:
	LNK	#2

;Lifter.c,10 :: 		void _Lifter_Init(_Lifter *pLifter, float kp, float ki, float kd, float targetPosition) {
	PUSH	W11
	PUSH	W12
	PUSH	W13
; ki start address is: 2 (W1)
	MOV	[W14-10], W1
	MOV	[W14-8], W2
; kd start address is: 6 (W3)
	MOV	[W14-14], W3
	MOV	[W14-12], W4
; targetPosition start address is: 10 (W5)
	MOV	[W14-18], W5
	MOV	[W14-16], W6
;Lifter.c,14 :: 		LIFTER_ENABLE_TRIS = 0; // Output
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
;Lifter.c,15 :: 		LIFTER_ENABLE_LAT = 1;  // T?t m?c d?nh
	BSET	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,17 :: 		pLifter->_kp = kp;
	MOV	W11, [W10++]
	MOV	W12, [W10--]
;Lifter.c,18 :: 		pLifter->_ki = ki;
	ADD	W10, #4, W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
; ki end address is: 2 (W1)
;Lifter.c,19 :: 		pLifter->_kd = kd;
	ADD	W10, #8, W0
	MOV	W3, [W0++]
	MOV	W4, [W0--]
; kd end address is: 6 (W3)
;Lifter.c,20 :: 		pLifter->_targetPosition = targetPosition;
	ADD	W10, #12, W0
	MOV	W5, [W0++]
	MOV	W6, [W0--]
; targetPosition end address is: 10 (W5)
;Lifter.c,21 :: 		pLifter->_currentPosition = 0;
	ADD	W10, #16, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,22 :: 		pLifter->_error = 0;
	ADD	W10, #20, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,23 :: 		pLifter->_lastError = 0;
	ADD	W10, #24, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,24 :: 		pLifter->_integral = 0;
	ADD	W10, #28, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,25 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,26 :: 		pLifter->_maxOutput = 100;
	MOV	#36, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#17096, W1
	MOV.D	W0, [W2]
;Lifter.c,29 :: 		pLifter->_accelerationLimit = 5.0;
	MOV	#40, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#16544, W1
	MOV.D	W0, [W2]
;Lifter.c,30 :: 		pLifter->_decelerationLimit = 7.0;
	MOV	#44, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#16608, W1
	MOV.D	W0, [W2]
;Lifter.c,33 :: 		pLifter->_minPosition = 25;
	MOV	#50, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#16840, W1
	MOV.D	W0, [W2]
;Lifter.c,34 :: 		pLifter->_maxPosition = 235;
	MOV	#54, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#17259, W1
	MOV.D	W0, [W2]
;Lifter.c,37 :: 		pLifter->_maxDuty = PWM_Init(5000, PWM_CHANNEL_ALI, 1, 3);
	MOV	#48, W0
	ADD	W10, W0, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV	#1, W13
	MOV	#3, W12
	MOV	#5000, W10
	MOV	#0, W11
	MOV	#3, W0
	PUSH	W0
	CALL	_PWM_Init
	SUB	#2, W15
	MOV	[W14+0], W1
	MOV	W0, [W1]
;Lifter.c,38 :: 		PWM_Init(5000, PWM_CHANNEL_BLI, 1, 3); // Kh?i t?o PWM4 (RP6)
	MOV	#1, W13
	MOV	#4, W12
	MOV	#5000, W10
	MOV	#0, W11
	MOV	#3, W0
	PUSH	W0
	CALL	_PWM_Init
	SUB	#2, W15
;Lifter.c,39 :: 		PWM_Start(PWM_CHANNEL_ALI);
	MOV.B	#3, W10
	CALL	_PWM_Start
;Lifter.c,40 :: 		PWM_Start(PWM_CHANNEL_BLI);
	MOV.B	#4, W10
	CALL	_PWM_Start
	POP	W10
;Lifter.c,43 :: 		pLifter->_status = LIFTER_STATUS_DISABLED;
	MOV	#58, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;Lifter.c,46 :: 		pLifter->Update = _Lifter_Update;
	MOV	#62, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(__Lifter_Update), W0
	MOV	W0, [W1]
;Lifter.c,47 :: 		}
L_end__Lifter_Init:
	POP	W13
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of __Lifter_Init

__Lifter_SetPositionLimits:
	LNK	#0

;Lifter.c,50 :: 		void _Lifter_SetPositionLimits(_Lifter *pLifter, float minPosition, float maxPosition) {
; maxPosition start address is: 2 (W1)
	MOV	[W14-10], W1
	MOV	[W14-8], W2
;Lifter.c,51 :: 		pLifter->_minPosition = minPosition;
	MOV	#50, W0
	ADD	W10, W0, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;Lifter.c,52 :: 		pLifter->_maxPosition = maxPosition;
	MOV	#54, W0
	ADD	W10, W0, W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
; maxPosition end address is: 2 (W1)
;Lifter.c,53 :: 		}
L_end__Lifter_SetPositionLimits:
	ULNK
	RETURN
; end of __Lifter_SetPositionLimits

__Lifter_SetTargetPosition:

;Lifter.c,56 :: 		void _Lifter_SetTargetPosition(_Lifter *pLifter, float targetPosition) {
;Lifter.c,57 :: 		if (targetPosition < pLifter->_minPosition) {
	MOV	#50, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV.D	W0, W2
	MOV	W11, W0
	MOV	W12, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_SetTargetPosition65
	INC.B	W0
L___Lifter_SetTargetPosition65:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L___Lifter_SetTargetPosition66
	GOTO	L__Lifter_SetTargetPosition0
L___Lifter_SetTargetPosition66:
;Lifter.c,58 :: 		targetPosition = pLifter->_minPosition;
	MOV	#50, W0
	ADD	W10, W0, W0
	MOV	[W0++], W11
	MOV	[W0--], W12
;Lifter.c,59 :: 		} else if (targetPosition > pLifter->_maxPosition) {
	GOTO	L__Lifter_SetTargetPosition1
L__Lifter_SetTargetPosition0:
	MOV	#54, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV.D	W0, W2
	MOV	W11, W0
	MOV	W12, W1
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___Lifter_SetTargetPosition67
	INC.B	W0
L___Lifter_SetTargetPosition67:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L___Lifter_SetTargetPosition68
	GOTO	L__Lifter_SetTargetPosition2
L___Lifter_SetTargetPosition68:
;Lifter.c,60 :: 		targetPosition = pLifter->_maxPosition;
	MOV	#54, W0
	ADD	W10, W0, W0
	MOV	[W0++], W11
	MOV	[W0--], W12
;Lifter.c,61 :: 		}
L__Lifter_SetTargetPosition2:
L__Lifter_SetTargetPosition1:
;Lifter.c,62 :: 		pLifter->_targetPosition = targetPosition;
	ADD	W10, #12, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;Lifter.c,63 :: 		pLifter->_integral = 0;
	ADD	W10, #28, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,64 :: 		pLifter->_lastError = 0;
	ADD	W10, #24, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,65 :: 		}
L_end__Lifter_SetTargetPosition:
	RETURN
; end of __Lifter_SetTargetPosition

__Lifter_Enable:

;Lifter.c,68 :: 		void _Lifter_Enable(_Lifter *pLifter) {
;Lifter.c,69 :: 		pLifter->_status = LIFTER_STATUS_ENABLED;
	MOV	#58, W0
	ADD	W10, W0, W1
	MOV	#1, W0
	MOV	W0, [W1]
;Lifter.c,70 :: 		LIFTER_ENABLE_LAT = 0; // B?t c?u H
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,71 :: 		}
L_end__Lifter_Enable:
	RETURN
; end of __Lifter_Enable

__Lifter_Disable:

;Lifter.c,74 :: 		void _Lifter_Disable(_Lifter *pLifter) {
;Lifter.c,75 :: 		pLifter->_status = LIFTER_STATUS_DISABLED;
	PUSH	W11
	MOV	#58, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;Lifter.c,76 :: 		PWM_Set_Duty(0, PWM_CHANNEL_ALI);
	PUSH	W10
	MOV	#3, W11
	CLR	W10
	CALL	_PWM_Set_Duty
;Lifter.c,77 :: 		PWM_Set_Duty(0, PWM_CHANNEL_BLI);
	MOV	#4, W11
	CLR	W10
	CALL	_PWM_Set_Duty
	POP	W10
;Lifter.c,78 :: 		LIFTER_ENABLE_LAT = 1; // T?t c?u H
	BSET	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,79 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,80 :: 		}
L_end__Lifter_Disable:
	POP	W11
	RETURN
; end of __Lifter_Disable

__Lifter_Set_maxOutput:

;Lifter.c,82 :: 		void _Lifter_Set_maxOutput(_Lifter *pLifter, float maxOutput){
;Lifter.c,83 :: 		pLifter->_maxOutput = maxOutput;
	MOV	#36, W0
	ADD	W10, W0, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;Lifter.c,84 :: 		}
L_end__Lifter_Set_maxOutput:
	RETURN
; end of __Lifter_Set_maxOutput

__Lifter_SetAccelerationLimit:

;Lifter.c,86 :: 		void _Lifter_SetAccelerationLimit(_Lifter *pLifter, float accLimit) {
;Lifter.c,87 :: 		pLifter->_accelerationLimit = accLimit;
	MOV	#40, W0
	ADD	W10, W0, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;Lifter.c,88 :: 		}
L_end__Lifter_SetAccelerationLimit:
	RETURN
; end of __Lifter_SetAccelerationLimit

__Lifter_SetDecelerationLimit:

;Lifter.c,91 :: 		void _Lifter_SetDecelerationLimit(_Lifter *pLifter, float decLimit) {
;Lifter.c,92 :: 		pLifter->_decelerationLimit = decLimit;
	MOV	#44, W0
	ADD	W10, W0, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;Lifter.c,93 :: 		}
L_end__Lifter_SetDecelerationLimit:
	RETURN
; end of __Lifter_SetDecelerationLimit

__Lifter_Get_Run_Mode:

;Lifter.c,95 :: 		void _Lifter_Get_Run_Mode(_Lifter *pLifter){
;Lifter.c,96 :: 		if (pLifter->_targetPosition > pLifter->_currentPosition && pLifter->_output == 0)
	ADD	W10, #12, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	ADD	W10, #16, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Get_Run_Mode75
	INC.B	W0
L___Lifter_Get_Run_Mode75:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Get_Run_Mode76
	GOTO	L___Lifter_Get_Run_Mode45
L___Lifter_Get_Run_Mode76:
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	CLR	W2
	CLR	W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA NZ	L___Lifter_Get_Run_Mode77
	INC.B	W0
L___Lifter_Get_Run_Mode77:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Get_Run_Mode78
	GOTO	L___Lifter_Get_Run_Mode44
L___Lifter_Get_Run_Mode78:
L___Lifter_Get_Run_Mode43:
;Lifter.c,97 :: 		pLifter->run_mode = LIFTER_RUN_DOWN;
	MOV	#60, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
	GOTO	L__Lifter_Get_Run_Mode6
;Lifter.c,96 :: 		if (pLifter->_targetPosition > pLifter->_currentPosition && pLifter->_output == 0)
L___Lifter_Get_Run_Mode45:
L___Lifter_Get_Run_Mode44:
;Lifter.c,98 :: 		else if (pLifter->_targetPosition < pLifter->_currentPosition && pLifter->_output == 0)
	ADD	W10, #12, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	ADD	W10, #16, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___Lifter_Get_Run_Mode79
	INC.B	W0
L___Lifter_Get_Run_Mode79:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Get_Run_Mode80
	GOTO	L___Lifter_Get_Run_Mode47
L___Lifter_Get_Run_Mode80:
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	CLR	W2
	CLR	W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA NZ	L___Lifter_Get_Run_Mode81
	INC.B	W0
L___Lifter_Get_Run_Mode81:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Get_Run_Mode82
	GOTO	L___Lifter_Get_Run_Mode46
L___Lifter_Get_Run_Mode82:
L___Lifter_Get_Run_Mode42:
;Lifter.c,99 :: 		pLifter->run_mode = LIFTER_RUN_UP;
	MOV	#60, W0
	ADD	W10, W0, W1
	MOV	#1, W0
	MOV	W0, [W1]
;Lifter.c,98 :: 		else if (pLifter->_targetPosition < pLifter->_currentPosition && pLifter->_output == 0)
L___Lifter_Get_Run_Mode47:
L___Lifter_Get_Run_Mode46:
;Lifter.c,99 :: 		pLifter->run_mode = LIFTER_RUN_UP;
L__Lifter_Get_Run_Mode6:
;Lifter.c,100 :: 		}
L_end__Lifter_Get_Run_Mode:
	RETURN
; end of __Lifter_Get_Run_Mode

__Lifter_Update:
	LNK	#8

;Lifter.c,103 :: 		void _Lifter_Update(_Lifter *pLifter) {
;Lifter.c,107 :: 		if (pLifter->_status != LIFTER_STATUS_ENABLED) {
	PUSH	W10
	PUSH	W11
	MOV	#58, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA NZ	L___Lifter_Update84
	GOTO	L__Lifter_Update10
L___Lifter_Update84:
;Lifter.c,108 :: 		PWM_Set_Duty(0, PWM_CHANNEL_ALI);
	PUSH	W10
	MOV	#3, W11
	CLR	W10
	CALL	_PWM_Set_Duty
;Lifter.c,109 :: 		PWM_Set_Duty(0, PWM_CHANNEL_BLI);
	MOV	#4, W11
	CLR	W10
	CALL	_PWM_Set_Duty
	POP	W10
;Lifter.c,110 :: 		LIFTER_ENABLE_LAT = 1; // T?t c?u H
	BSET	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,111 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,112 :: 		return;
	GOTO	L_end__Lifter_Update
;Lifter.c,113 :: 		}
L__Lifter_Update10:
;Lifter.c,116 :: 		LIFTER_ENABLE_LAT = 0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,119 :: 		if (pLifter->_targetPosition > pLifter->_currentPosition && pLifter->_output == 0)
	ADD	W10, #12, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	ADD	W10, #16, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Update85
	INC.B	W0
L___Lifter_Update85:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update86
	GOTO	L___Lifter_Update53
L___Lifter_Update86:
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	CLR	W2
	CLR	W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA NZ	L___Lifter_Update87
	INC.B	W0
L___Lifter_Update87:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update88
	GOTO	L___Lifter_Update52
L___Lifter_Update88:
L___Lifter_Update51:
;Lifter.c,120 :: 		pLifter->run_mode = LIFTER_RUN_DOWN;
	MOV	#60, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
	GOTO	L__Lifter_Update14
;Lifter.c,119 :: 		if (pLifter->_targetPosition > pLifter->_currentPosition && pLifter->_output == 0)
L___Lifter_Update53:
L___Lifter_Update52:
;Lifter.c,121 :: 		else if (pLifter->_targetPosition < pLifter->_currentPosition && pLifter->_output == 0)
	ADD	W10, #12, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	ADD	W10, #16, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___Lifter_Update89
	INC.B	W0
L___Lifter_Update89:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update90
	GOTO	L___Lifter_Update55
L___Lifter_Update90:
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	CLR	W2
	CLR	W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA NZ	L___Lifter_Update91
	INC.B	W0
L___Lifter_Update91:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update92
	GOTO	L___Lifter_Update54
L___Lifter_Update92:
L___Lifter_Update50:
;Lifter.c,122 :: 		pLifter->run_mode = LIFTER_RUN_UP;
	MOV	#60, W0
	ADD	W10, W0, W1
	MOV	#1, W0
	MOV	W0, [W1]
;Lifter.c,121 :: 		else if (pLifter->_targetPosition < pLifter->_currentPosition && pLifter->_output == 0)
L___Lifter_Update55:
L___Lifter_Update54:
;Lifter.c,122 :: 		pLifter->run_mode = LIFTER_RUN_UP;
L__Lifter_Update14:
;Lifter.c,124 :: 		if (pLifter->run_mode == LIFTER_RUN_DOWN) {
	MOV	#60, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA Z	L___Lifter_Update93
	GOTO	L__Lifter_Update18
L___Lifter_Update93:
;Lifter.c,126 :: 		PWM_Set_Duty(0, PWM_CHANNEL_BLI);
	PUSH	W10
	MOV	#4, W11
	CLR	W10
	CALL	_PWM_Set_Duty
	POP	W10
;Lifter.c,127 :: 		pLifter->_error = pLifter->_targetPosition - pLifter->_currentPosition;
	ADD	W10, #20, W0
	MOV	W0, [W14+0]
	ADD	W10, #12, W0
	MOV.D	[W0], W4
	ADD	W10, #16, W0
	MOV.D	[W0], W2
	PUSH	W10
	MOV.D	W4, W0
	CALL	__Sub_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Lifter.c,129 :: 		if (pLifter->_currentPosition >= pLifter->_targetPosition ||
	ADD	W10, #16, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	ADD	W10, #12, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GT	L___Lifter_Update94
	INC.B	W0
L___Lifter_Update94:
	POP	W10
;Lifter.c,130 :: 		pLifter->_currentPosition >= pLifter->_maxPosition) {
	CP0.B	W0
	BRA Z	L___Lifter_Update95
	GOTO	L___Lifter_Update57
L___Lifter_Update95:
	ADD	W10, #16, W4
	MOV	#54, W0
	ADD	W10, W0, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LT	L___Lifter_Update96
	INC.B	W0
L___Lifter_Update96:
	POP	W10
	CP0.B	W0
	BRA Z	L___Lifter_Update97
	GOTO	L___Lifter_Update56
L___Lifter_Update97:
	GOTO	L__Lifter_Update21
L___Lifter_Update57:
L___Lifter_Update56:
;Lifter.c,131 :: 		PWM_Set_Duty(0, PWM_CHANNEL_ALI);
	PUSH	W10
	MOV	#3, W11
	CLR	W10
	CALL	_PWM_Set_Duty
;Lifter.c,132 :: 		PWM_Set_Duty(0, PWM_CHANNEL_BLI);
	MOV	#4, W11
	CLR	W10
	CALL	_PWM_Set_Duty
	POP	W10
;Lifter.c,133 :: 		LIFTER_ENABLE_LAT = 1;
	BSET	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,134 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,135 :: 		pLifter->_status = LIFTER_STATUS_DISABLED;
	MOV	#58, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;Lifter.c,136 :: 		return;
	GOTO	L_end__Lifter_Update
;Lifter.c,137 :: 		}
L__Lifter_Update21:
;Lifter.c,139 :: 		pLifter->_integral += pLifter->_error;
	ADD	W10, #28, W4
	MOV	W4, [W14+0]
	ADD	W10, #20, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__AddSub_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Lifter.c,140 :: 		if (pLifter->_integral > 1000) pLifter->_integral = 1000;
	ADD	W10, #28, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___Lifter_Update98
	INC.B	W0
L___Lifter_Update98:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update99
	GOTO	L__Lifter_Update22
L___Lifter_Update99:
	ADD	W10, #28, W2
	MOV	#0, W0
	MOV	#17530, W1
	MOV.D	W0, [W2]
	GOTO	L__Lifter_Update23
L__Lifter_Update22:
;Lifter.c,141 :: 		else if (pLifter->_integral < -1000) pLifter->_integral = -1000;
	ADD	W10, #28, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#50298, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Update100
	INC.B	W0
L___Lifter_Update100:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update101
	GOTO	L__Lifter_Update24
L___Lifter_Update101:
	ADD	W10, #28, W2
	MOV	#0, W0
	MOV	#50298, W1
	MOV.D	W0, [W2]
L__Lifter_Update24:
L__Lifter_Update23:
;Lifter.c,143 :: 		derivative = pLifter->_error - pLifter->_lastError;
	ADD	W10, #20, W0
	MOV.D	[W0], W4
	MOV	W4, [W14+4]
	MOV	W5, [W14+6]
	ADD	W10, #24, W0
	MOV	W0, [W14+0]
	MOV.D	[W0], W2
	PUSH	W10
	MOV.D	W4, W0
	CALL	__Sub_FP
	POP	W10
; derivative start address is: 10 (W5)
	MOV	W0, W5
	MOV	W1, W6
;Lifter.c,144 :: 		pLifter->_lastError = pLifter->_error;
	MOV	[W14+4], W1
	MOV	[W14+6], W2
	MOV	[W14+0], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;Lifter.c,145 :: 		pidOutput = pLifter->_kp * pLifter->_error +
	MOV	[W10++], W3
	MOV	[W10--], W4
	ADD	W10, #20, W2
	MOV.D	[W2], W0
	PUSH	W5
	PUSH	W6
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Mul_FP
	POP	W10
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;Lifter.c,146 :: 		pLifter->_ki * pLifter->_integral +
	ADD	W10, #4, W4
	ADD	W10, #28, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__Mul_FP
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__AddSub_FP
	POP	W10
	POP	W6
	POP	W5
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;Lifter.c,147 :: 		pLifter->_kd * derivative;
	ADD	W10, #8, W2
	MOV.D	[W2], W0
	PUSH	W10
; derivative end address is: 10 (W5)
	MOV	W5, W2
	MOV	W6, W3
	CALL	__Mul_FP
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__AddSub_FP
	POP	W10
;Lifter.c,149 :: 		delta = pidOutput;
; delta start address is: 10 (W5)
	MOV	W0, W5
	MOV	W1, W6
;Lifter.c,150 :: 		if (delta > pLifter->_accelerationLimit)
	MOV	#40, W2
	ADD	W10, W2, W4
	MOV.D	[W4], W2
	PUSH	W5
	PUSH	W6
	PUSH	W10
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___Lifter_Update102
	INC.B	W0
L___Lifter_Update102:
	POP	W10
	POP	W6
	POP	W5
	CP0.B	W0
	BRA NZ	L___Lifter_Update103
	GOTO	L___Lifter_Update60
L___Lifter_Update103:
; delta end address is: 10 (W5)
;Lifter.c,151 :: 		delta = pLifter->_accelerationLimit;
	MOV	#40, W0
	ADD	W10, W0, W0
; delta start address is: 6 (W3)
	MOV	[W0++], W3
	MOV	[W0--], W4
; delta end address is: 6 (W3)
	GOTO	L__Lifter_Update25
L___Lifter_Update60:
;Lifter.c,150 :: 		if (delta > pLifter->_accelerationLimit)
	MOV	W5, W3
	MOV	W6, W4
;Lifter.c,151 :: 		delta = pLifter->_accelerationLimit;
L__Lifter_Update25:
;Lifter.c,153 :: 		pLifter->_output += delta;
; delta start address is: 6 (W3)
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV	W2, [W14+0]
	MOV.D	[W2], W0
	PUSH	W10
; delta end address is: 6 (W3)
	MOV	W3, W2
	MOV	W4, W3
	CALL	__AddSub_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Lifter.c,154 :: 		if (pLifter->_output > pLifter->_maxOutput)
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	MOV	#36, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Update104
	INC.B	W0
L___Lifter_Update104:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update105
	GOTO	L__Lifter_Update26
L___Lifter_Update105:
;Lifter.c,155 :: 		pLifter->_output = pLifter->_maxOutput;
	MOV	#32, W0
	ADD	W10, W0, W1
	MOV	#36, W0
	ADD	W10, W0, W0
	MOV	[W0++], [W1++]
	MOV	[W0--], [W1--]
	GOTO	L__Lifter_Update27
L__Lifter_Update26:
;Lifter.c,156 :: 		else if (pLifter->_output < 0)
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	CLR	W2
	CLR	W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Update106
	INC.B	W0
L___Lifter_Update106:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update107
	GOTO	L__Lifter_Update28
L___Lifter_Update107:
;Lifter.c,157 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
L__Lifter_Update28:
L__Lifter_Update27:
;Lifter.c,159 :: 		pwmDuty = (unsigned int)((pLifter->_output / 100.0) * pLifter->_maxDuty);
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Div_FP
	POP	W10
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	#48, W0
	ADD	W10, W0, W2
	MOV	[W2], W0
	CLR	W1
	CALL	__Long2Float
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Mul_FP
	CALL	__Float2Longint
; pwmDuty start address is: 6 (W3)
	MOV	W0, W3
;Lifter.c,160 :: 		PWM_Set_Duty(0, PWM_CHANNEL_BLI);
	MOV	#4, W11
	CLR	W10
	CALL	_PWM_Set_Duty
;Lifter.c,161 :: 		PWM_Set_Duty(pwmDuty, PWM_CHANNEL_ALI);
	MOV	#3, W11
	MOV	W3, W10
; pwmDuty end address is: 6 (W3)
	CALL	_PWM_Set_Duty
;Lifter.c,162 :: 		}
	GOTO	L__Lifter_Update29
L__Lifter_Update18:
;Lifter.c,163 :: 		else if (pLifter->run_mode == LIFTER_RUN_UP) {
	MOV	#60, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA Z	L___Lifter_Update108
	GOTO	L__Lifter_Update30
L___Lifter_Update108:
;Lifter.c,165 :: 		PWM_Set_Duty(0, PWM_CHANNEL_ALI);
	PUSH	W10
	MOV	#3, W11
	CLR	W10
	CALL	_PWM_Set_Duty
	POP	W10
;Lifter.c,166 :: 		pLifter->_error = pLifter->_currentPosition - pLifter->_targetPosition;
	ADD	W10, #20, W0
	MOV	W0, [W14+0]
	ADD	W10, #16, W0
	MOV.D	[W0], W4
	ADD	W10, #12, W0
	MOV.D	[W0], W2
	PUSH	W10
	MOV.D	W4, W0
	CALL	__Sub_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Lifter.c,168 :: 		if (pLifter->_currentPosition <= pLifter->_targetPosition ||
	ADD	W10, #16, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	ADD	W10, #12, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LT	L___Lifter_Update109
	INC.B	W0
L___Lifter_Update109:
	POP	W10
;Lifter.c,169 :: 		pLifter->_currentPosition <= pLifter->_minPosition) {
	CP0.B	W0
	BRA Z	L___Lifter_Update110
	GOTO	L___Lifter_Update59
L___Lifter_Update110:
	ADD	W10, #16, W4
	MOV	#50, W0
	ADD	W10, W0, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GT	L___Lifter_Update111
	INC.B	W0
L___Lifter_Update111:
	POP	W10
	CP0.B	W0
	BRA Z	L___Lifter_Update112
	GOTO	L___Lifter_Update58
L___Lifter_Update112:
	GOTO	L__Lifter_Update33
L___Lifter_Update59:
L___Lifter_Update58:
;Lifter.c,170 :: 		PWM_Set_Duty(0, PWM_CHANNEL_ALI);
	PUSH	W10
	MOV	#3, W11
	CLR	W10
	CALL	_PWM_Set_Duty
;Lifter.c,171 :: 		PWM_Set_Duty(0, PWM_CHANNEL_BLI);
	MOV	#4, W11
	CLR	W10
	CALL	_PWM_Set_Duty
	POP	W10
;Lifter.c,172 :: 		LIFTER_ENABLE_LAT = 1;
	BSET	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,173 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,174 :: 		pLifter->_status = LIFTER_STATUS_DISABLED;
	MOV	#58, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;Lifter.c,175 :: 		return;
	GOTO	L_end__Lifter_Update
;Lifter.c,176 :: 		}
L__Lifter_Update33:
;Lifter.c,178 :: 		pLifter->_integral += pLifter->_error;
	ADD	W10, #28, W4
	MOV	W4, [W14+0]
	ADD	W10, #20, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__AddSub_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Lifter.c,179 :: 		if (pLifter->_integral > 1000) pLifter->_integral = 1000;
	ADD	W10, #28, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___Lifter_Update113
	INC.B	W0
L___Lifter_Update113:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update114
	GOTO	L__Lifter_Update34
L___Lifter_Update114:
	ADD	W10, #28, W2
	MOV	#0, W0
	MOV	#17530, W1
	MOV.D	W0, [W2]
	GOTO	L__Lifter_Update35
L__Lifter_Update34:
;Lifter.c,180 :: 		else if (pLifter->_integral < -1000) pLifter->_integral = -1000;
	ADD	W10, #28, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#50298, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Update115
	INC.B	W0
L___Lifter_Update115:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update116
	GOTO	L__Lifter_Update36
L___Lifter_Update116:
	ADD	W10, #28, W2
	MOV	#0, W0
	MOV	#50298, W1
	MOV.D	W0, [W2]
L__Lifter_Update36:
L__Lifter_Update35:
;Lifter.c,182 :: 		derivative = pLifter->_error - pLifter->_lastError;
	ADD	W10, #20, W0
	MOV.D	[W0], W4
	MOV	W4, [W14+4]
	MOV	W5, [W14+6]
	ADD	W10, #24, W0
	MOV	W0, [W14+0]
	MOV.D	[W0], W2
	PUSH	W10
	MOV.D	W4, W0
	CALL	__Sub_FP
	POP	W10
; derivative start address is: 10 (W5)
	MOV	W0, W5
	MOV	W1, W6
;Lifter.c,183 :: 		pLifter->_lastError = pLifter->_error;
	MOV	[W14+4], W1
	MOV	[W14+6], W2
	MOV	[W14+0], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;Lifter.c,184 :: 		pidOutput = pLifter->_kp * pLifter->_error +
	MOV	[W10++], W3
	MOV	[W10--], W4
	ADD	W10, #20, W2
	MOV.D	[W2], W0
	PUSH	W5
	PUSH	W6
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Mul_FP
	POP	W10
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;Lifter.c,185 :: 		pLifter->_ki * pLifter->_integral +
	ADD	W10, #4, W4
	ADD	W10, #28, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__Mul_FP
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__AddSub_FP
	POP	W10
	POP	W6
	POP	W5
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;Lifter.c,186 :: 		pLifter->_kd * derivative;
	ADD	W10, #8, W2
	MOV.D	[W2], W0
	PUSH	W10
; derivative end address is: 10 (W5)
	MOV	W5, W2
	MOV	W6, W3
	CALL	__Mul_FP
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__AddSub_FP
	POP	W10
;Lifter.c,188 :: 		delta = pidOutput;
; delta start address is: 10 (W5)
	MOV	W0, W5
	MOV	W1, W6
;Lifter.c,189 :: 		if (delta > pLifter->_accelerationLimit)
	MOV	#40, W2
	ADD	W10, W2, W4
	MOV.D	[W4], W2
	PUSH	W5
	PUSH	W6
	PUSH	W10
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___Lifter_Update117
	INC.B	W0
L___Lifter_Update117:
	POP	W10
	POP	W6
	POP	W5
	CP0.B	W0
	BRA NZ	L___Lifter_Update118
	GOTO	L___Lifter_Update61
L___Lifter_Update118:
; delta end address is: 10 (W5)
;Lifter.c,190 :: 		delta = pLifter->_accelerationLimit;
	MOV	#40, W0
	ADD	W10, W0, W0
; delta start address is: 6 (W3)
	MOV	[W0++], W3
	MOV	[W0--], W4
; delta end address is: 6 (W3)
	GOTO	L__Lifter_Update37
L___Lifter_Update61:
;Lifter.c,189 :: 		if (delta > pLifter->_accelerationLimit)
	MOV	W5, W3
	MOV	W6, W4
;Lifter.c,190 :: 		delta = pLifter->_accelerationLimit;
L__Lifter_Update37:
;Lifter.c,192 :: 		pLifter->_output += delta;
; delta start address is: 6 (W3)
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV	W2, [W14+0]
	MOV.D	[W2], W0
	PUSH	W10
; delta end address is: 6 (W3)
	MOV	W3, W2
	MOV	W4, W3
	CALL	__AddSub_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Lifter.c,193 :: 		if (pLifter->_output > pLifter->_maxOutput)
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	MOV	#36, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Update119
	INC.B	W0
L___Lifter_Update119:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update120
	GOTO	L__Lifter_Update38
L___Lifter_Update120:
;Lifter.c,194 :: 		pLifter->_output = pLifter->_maxOutput;
	MOV	#32, W0
	ADD	W10, W0, W1
	MOV	#36, W0
	ADD	W10, W0, W0
	MOV	[W0++], [W1++]
	MOV	[W0--], [W1--]
	GOTO	L__Lifter_Update39
L__Lifter_Update38:
;Lifter.c,195 :: 		else if (pLifter->_output < 0)
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	CLR	W2
	CLR	W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___Lifter_Update121
	INC.B	W0
L___Lifter_Update121:
	POP	W10
	CP0.B	W0
	BRA NZ	L___Lifter_Update122
	GOTO	L__Lifter_Update40
L___Lifter_Update122:
;Lifter.c,196 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
L__Lifter_Update40:
L__Lifter_Update39:
;Lifter.c,198 :: 		pwmDuty = (unsigned int)((pLifter->_output / 100.0) * pLifter->_maxDuty);
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Div_FP
	POP	W10
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	#48, W0
	ADD	W10, W0, W2
	MOV	[W2], W0
	CLR	W1
	CALL	__Long2Float
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Mul_FP
	CALL	__Float2Longint
; pwmDuty start address is: 6 (W3)
	MOV	W0, W3
;Lifter.c,199 :: 		PWM_Set_Duty(0, PWM_CHANNEL_ALI);
	MOV	#3, W11
	CLR	W10
	CALL	_PWM_Set_Duty
;Lifter.c,200 :: 		PWM_Set_Duty(pwmDuty, PWM_CHANNEL_BLI);
	MOV	#4, W11
	MOV	W3, W10
; pwmDuty end address is: 6 (W3)
	CALL	_PWM_Set_Duty
;Lifter.c,201 :: 		}
	GOTO	L__Lifter_Update41
L__Lifter_Update30:
;Lifter.c,203 :: 		PWM_Set_Duty(0, PWM_CHANNEL_ALI);
	PUSH	W10
	MOV	#3, W11
	CLR	W10
	CALL	_PWM_Set_Duty
;Lifter.c,204 :: 		PWM_Set_Duty(0, PWM_CHANNEL_BLI);
	MOV	#4, W11
	CLR	W10
	CALL	_PWM_Set_Duty
	POP	W10
;Lifter.c,205 :: 		LIFTER_ENABLE_LAT = 1;
	BSET	LATB5_bit, BitPos(LATB5_bit+0)
;Lifter.c,206 :: 		pLifter->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Lifter.c,207 :: 		pLifter->_status = LIFTER_STATUS_DISABLED;
	MOV	#58, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;Lifter.c,208 :: 		return;
	GOTO	L_end__Lifter_Update
;Lifter.c,209 :: 		}
L__Lifter_Update41:
L__Lifter_Update29:
;Lifter.c,210 :: 		}
L_end__Lifter_Update:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of __Lifter_Update
