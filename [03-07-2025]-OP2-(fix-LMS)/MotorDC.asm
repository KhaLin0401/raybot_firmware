
__MotorDC_Init:
	LNK	#130

;MotorDC.c,16 :: 		void _MotorDC_Init(_MotorDC *motor, float kp, float ki, float kd, float targetSpeed) {
	PUSH	W11
	PUSH	W12
	PUSH	W13
; ki start address is: 2 (W1)
	MOV	[W14-10], W1
	MOV	[W14-8], W2
; kd start address is: 6 (W3)
	MOV	[W14-14], W3
	MOV	[W14-12], W4
; targetSpeed start address is: 10 (W5)
	MOV	[W14-18], W5
	MOV	[W14-16], W6
;MotorDC.c,26 :: 		motor->_kp = kp;
	MOV	W11, [W10++]
	MOV	W12, [W10--]
;MotorDC.c,27 :: 		motor->_ki = ki;
	ADD	W10, #4, W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
; ki end address is: 2 (W1)
;MotorDC.c,28 :: 		motor->_kd = kd;
	ADD	W10, #8, W0
	MOV	W3, [W0++]
	MOV	W4, [W0--]
; kd end address is: 6 (W3)
;MotorDC.c,33 :: 		motor->_targetSpeed = targetSpeed;  // Luu du?i d?ng ph?n tram
	ADD	W10, #12, W0
	MOV	W5, [W0++]
	MOV	W6, [W0--]
; targetSpeed end address is: 10 (W5)
;MotorDC.c,34 :: 		motor->_currentSpeed = 0;           // Ban d?u là 0, s? c?p nh?t sau
	ADD	W10, #16, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,39 :: 		motor->_error = 0;
	ADD	W10, #20, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,40 :: 		motor->_lastError = 0;
	ADD	W10, #24, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,41 :: 		motor->_integral = 0;
	ADD	W10, #28, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,42 :: 		motor->_output = 0;
	MOV	#32, W0
	ADD	W10, W0, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,46 :: 		motor->_accelerationLimit = 2;  // M?c d?nh: 50%/chu k? (có th? di?u ch?nh)
	MOV	#40, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#16384, W1
	MOV.D	W0, [W2]
;MotorDC.c,47 :: 		motor->_decelerationLimit = 3;  // M?c d?nh: 100%/chu k? (có th? di?u ch?nh)
	MOV	#44, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#16448, W1
	MOV.D	W0, [W2]
;MotorDC.c,48 :: 		sprintf(debugBuffer, "AccelerationLimit=%d, DecelerationLimit=%d\r\n", motor->_accelerationLimit, motor->_decelerationLimit);
	MOV	#44, W0
	ADD	W10, W0, W2
	MOV	#40, W0
	ADD	W10, W0, W0
	ADD	W14, #0, W1
	PUSH	W10
	PUSH	[W2++]
	PUSH	[W2--]
	PUSH	[W0++]
	PUSH	[W0--]
	MOV	#lo_addr(?lstr_1_MotorDC), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#12, W15
	POP	W10
;MotorDC.c,52 :: 		motor->_safeDistance = 40;      // Ðon v? cm
	MOV	#48, W0
	ADD	W10, W0, W2
	MOV	#0, W0
	MOV	#16928, W1
	MOV.D	W0, [W2]
;MotorDC.c,57 :: 		maxDutyM1 = PWM_Init(5000, PWM_CHANNEL_M1, 1, 2); // S? d?ng h?ng s? dã d?nh nghia cho kênh M1
	PUSH	W10
	MOV	#1, W13
	MOV	#1, W12
	MOV	#5000, W10
	MOV	#0, W11
	MOV	#2, W0
	PUSH	W0
	CALL	_PWM_Init
	SUB	#2, W15
;MotorDC.c,60 :: 		maxDutyM1 = maxDutyM1 * 0.92;
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#34079, W2
	MOV	#16235, W3
	CALL	__Mul_FP
	CALL	__Float2Longint
	POP	W10
; maxDutyM1 start address is: 4 (W2)
	MOV	W0, W2
;MotorDC.c,62 :: 		maxDutyM2 = PWM_Init(5000, PWM_CHANNEL_M2, 1, 2); // S? d?ng h?ng s? dã d?nh nghia cho kênh M2
	PUSH	W2
	PUSH	W10
	MOV	#1, W13
	MOV	#2, W12
	MOV	#5000, W10
	MOV	#0, W11
	MOV	#2, W0
	PUSH	W0
	CALL	_PWM_Init
	SUB	#2, W15
	POP	W10
	POP	W2
;MotorDC.c,67 :: 		motor->_maxDuty = maxDutyM1;
	MOV	#52, W0
	ADD	W10, W0, W0
	MOV	W0, [W14+128]
	PUSH	W10
; maxDutyM1 end address is: 4 (W2)
	MOV	W2, W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	[W14+128], W2
	MOV.D	W0, [W2]
;MotorDC.c,70 :: 		PWM_Start(PWM_CHANNEL_M1);
	MOV.B	#1, W10
	CALL	_PWM_Start
;MotorDC.c,71 :: 		PWM_Start(PWM_CHANNEL_M2);
	MOV.B	#2, W10
	CALL	_PWM_Start
	POP	W10
;MotorDC.c,75 :: 		motor->_direction = 0;  // Hu?ng m?c d?nh (ví d?: 0 có th? là FORWARD)
	MOV	#56, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;MotorDC.c,76 :: 		motor->_status = 0;     // Tr?ng thái ban d?u: t?t (disabled)
	MOV	#58, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;MotorDC.c,77 :: 		sprintf(debugBuffer, "Direction set to %d, Status set to %d\r\n", motor->_direction, motor->_status);
	MOV	#58, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#56, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	ADD	W14, #0, W1
	PUSH	W10
	PUSH	W2
	PUSH	W0
	MOV	#lo_addr(?lstr_2_MotorDC), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#8, W15
	POP	W10
;MotorDC.c,81 :: 		motor->Update = _MotorDC_Update;
	MOV	#60, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(__MotorDC_Update), W0
	MOV	W0, [W1]
;MotorDC.c,86 :: 		}
L_end__MotorDC_Init:
	POP	W13
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of __MotorDC_Init

__MotorDC_SetTargetSpeed:

;MotorDC.c,90 :: 		void _MotorDC_SetTargetSpeed(_MotorDC *motor, float targetSpeed) {
;MotorDC.c,91 :: 		if(targetSpeed < 0)
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CLR	W2
	CLR	W3
	MOV	W11, W0
	MOV	W12, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___MotorDC_SetTargetSpeed19
	INC.B	W0
L___MotorDC_SetTargetSpeed19:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L___MotorDC_SetTargetSpeed20
	GOTO	L__MotorDC_SetTargetSpeed0
L___MotorDC_SetTargetSpeed20:
;MotorDC.c,92 :: 		targetSpeed = 0;
	CLR	W11
	CLR	W12
	GOTO	L__MotorDC_SetTargetSpeed1
L__MotorDC_SetTargetSpeed0:
;MotorDC.c,93 :: 		else if(targetSpeed > 90)
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#0, W2
	MOV	#17076, W3
	MOV	W11, W0
	MOV	W12, W1
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___MotorDC_SetTargetSpeed21
	INC.B	W0
L___MotorDC_SetTargetSpeed21:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L___MotorDC_SetTargetSpeed22
	GOTO	L__MotorDC_SetTargetSpeed2
L___MotorDC_SetTargetSpeed22:
;MotorDC.c,94 :: 		targetSpeed = 90;
	MOV	#0, W11
	MOV	#17076, W12
L__MotorDC_SetTargetSpeed2:
L__MotorDC_SetTargetSpeed1:
;MotorDC.c,95 :: 		motor->_targetSpeed = targetSpeed;
	ADD	W10, #12, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;MotorDC.c,97 :: 		motor->_integral = 0;
	ADD	W10, #28, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,98 :: 		motor->_lastError = 0;
	ADD	W10, #24, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,99 :: 		}
L_end__MotorDC_SetTargetSpeed:
	RETURN
; end of __MotorDC_SetTargetSpeed

__MotorDC_SetDirection:

;MotorDC.c,102 :: 		void _MotorDC_SetDirection(_MotorDC *motor, MotorDirection direction) {
;MotorDC.c,103 :: 		motor->_direction = direction;
	MOV	#56, W0
	ADD	W10, W0, W1
	ZE	W11, W0
	MOV	W0, [W1]
;MotorDC.c,104 :: 		if(direction == MOTOR_DIRECTION_FORWARD) {
	CP.B	W11, #0
	BRA Z	L___MotorDC_SetDirection24
	GOTO	L__MotorDC_SetDirection3
L___MotorDC_SetDirection24:
;MotorDC.c,105 :: 		MOTOR1_DIR_LAT = 1;
	BSET	LATC8_bit, BitPos(LATC8_bit+0)
;MotorDC.c,106 :: 		MOTOR2_DIR_LAT = 0;
	BCLR	LATC7_bit, BitPos(LATC7_bit+0)
;MotorDC.c,107 :: 		} else {
	GOTO	L__MotorDC_SetDirection4
L__MotorDC_SetDirection3:
;MotorDC.c,108 :: 		MOTOR1_DIR_LAT = 0;
	BCLR	LATC8_bit, BitPos(LATC8_bit+0)
;MotorDC.c,109 :: 		MOTOR2_DIR_LAT = 1;
	BSET	LATC7_bit, BitPos(LATC7_bit+0)
;MotorDC.c,110 :: 		}
L__MotorDC_SetDirection4:
;MotorDC.c,111 :: 		}
L_end__MotorDC_SetDirection:
	RETURN
; end of __MotorDC_SetDirection

__MotorDC_Enable:

;MotorDC.c,115 :: 		void _MotorDC_Enable(_MotorDC *motor) {
;MotorDC.c,117 :: 		motor->_status = 1;
	MOV	#58, W0
	ADD	W10, W0, W1
	MOV	#1, W0
	MOV	W0, [W1]
;MotorDC.c,120 :: 		MOTOR_ENABLE_LAT = 1;
	BSET	LATB12_bit, BitPos(LATB12_bit+0)
;MotorDC.c,121 :: 		}
L_end__MotorDC_Enable:
	RETURN
; end of __MotorDC_Enable

__MotorDC_Disable:

;MotorDC.c,124 :: 		void _MotorDC_Disable(_MotorDC *motor) {
;MotorDC.c,125 :: 		motor->_status = 0;
	PUSH	W10
	PUSH	W11
	MOV	#58, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;MotorDC.c,126 :: 		motor->_targetSpeed = 0;
	ADD	W10, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,127 :: 		MOTOR_ENABLE_LAT = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;MotorDC.c,128 :: 		PWM_Set_Duty(motor->_maxDuty,PWM_CHANNEL_M1);
	MOV	#52, W0
	ADD	W10, W0, W1
	MOV.D	[W1], W0
	CALL	__Float2Longint
	MOV	#1, W11
	MOV	W0, W10
	CALL	_PWM_Set_Duty
;MotorDC.c,129 :: 		}
L_end__MotorDC_Disable:
	POP	W11
	POP	W10
	RETURN
; end of __MotorDC_Disable

__MotorDC_Set_Idle:

;MotorDC.c,131 :: 		void _MotorDC_Set_Idle(_MotorDC *motor){
;MotorDC.c,132 :: 		motor->_targetSpeed = 0;
	PUSH	W10
	PUSH	W11
	ADD	W10, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;MotorDC.c,133 :: 		PWM_Set_Duty(10,PWM_CHANNEL_M1);
	MOV	#1, W11
	MOV	#10, W10
	CALL	_PWM_Set_Duty
;MotorDC.c,134 :: 		}
L_end__MotorDC_Set_Idle:
	POP	W11
	POP	W10
	RETURN
; end of __MotorDC_Set_Idle

__MotorDC_Disable_Emergency:

;MotorDC.c,136 :: 		void _MotorDC_Disable_Emergency(_MotorDC *motor){
;MotorDC.c,138 :: 		}
L_end__MotorDC_Disable_Emergency:
	RETURN
; end of __MotorDC_Disable_Emergency

__MotorDC_GetStatus:

;MotorDC.c,141 :: 		MotorStatus _MotorDC_GetStatus(_MotorDC *motor) {
;MotorDC.c,142 :: 		return motor->_status;
	MOV	#58, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W0
;MotorDC.c,143 :: 		}
L_end__MotorDC_GetStatus:
	RETURN
; end of __MotorDC_GetStatus

__MotorDC_SetAccelerationLimit:

;MotorDC.c,146 :: 		void _MotorDC_SetAccelerationLimit(_MotorDC *motor, float accLimit) {
;MotorDC.c,147 :: 		motor->_accelerationLimit = accLimit;
	MOV	#40, W0
	ADD	W10, W0, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;MotorDC.c,148 :: 		}
L_end__MotorDC_SetAccelerationLimit:
	RETURN
; end of __MotorDC_SetAccelerationLimit

__MotorDC_SetDecelerationLimit:

;MotorDC.c,150 :: 		void _MotorDC_SetDecelerationLimit(_MotorDC *motor, float decLimit) {
;MotorDC.c,151 :: 		motor->_decelerationLimit = decLimit;
	MOV	#44, W0
	ADD	W10, W0, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;MotorDC.c,152 :: 		}
L_end__MotorDC_SetDecelerationLimit:
	RETURN
; end of __MotorDC_SetDecelerationLimit

__MotorDC_SetSafeDistance:

;MotorDC.c,155 :: 		void _MotorDC_SetSafeDistance(_MotorDC *motor, float safeDistance) {
;MotorDC.c,156 :: 		motor->_safeDistance = safeDistance;
	MOV	#48, W0
	ADD	W10, W0, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;MotorDC.c,157 :: 		}
L_end__MotorDC_SetSafeDistance:
	RETURN
; end of __MotorDC_SetSafeDistance

__MotorDC_SetMaxDuty:
	LNK	#2

;MotorDC.c,160 :: 		void _MotorDC_SetMaxDuty(_MotorDC *motor, unsigned int maxDuty) {
;MotorDC.c,161 :: 		motor->_maxDuty = maxDuty;
	MOV	#52, W0
	ADD	W10, W0, W0
	MOV	W0, [W14+0]
	MOV	W11, W0
	CLR	W1
	CALL	__Long2Float
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;MotorDC.c,162 :: 		}
L_end__MotorDC_SetMaxDuty:
	ULNK
	RETURN
; end of __MotorDC_SetMaxDuty

__MotorDC_UpdatePID:
	LNK	#38

;MotorDC.c,172 :: 		void _MotorDC_UpdatePID(_MotorDC *motor) {
;MotorDC.c,181 :: 		targetPercent = motor->_targetSpeed;
	PUSH	W10
	PUSH	W11
	ADD	W10, #12, W0
	MOV	[W0++], W5
	MOV	[W0--], W6
;MotorDC.c,182 :: 		currentPercent = motor->_currentSpeed; // Nguoi dung co the cap nhat _currentSpeed theo phan hoi (0-100%)
	ADD	W10, #16, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
;MotorDC.c,183 :: 		distance = motor->_distanceSensorValue;  // (cm)
	MOV	#36, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	MOV	W0, [W14+12]
	MOV	W1, [W14+14]
;MotorDC.c,186 :: 		motor->_error = targetPercent - currentPercent;
	ADD	W10, #20, W0
	MOV	W0, [W14+28]
	PUSH	W10
	MOV	W5, W0
	MOV	W6, W1
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Sub_FP
	POP	W10
	MOV	[W14+28], W2
	MOV.D	W0, [W2]
;MotorDC.c,187 :: 		motor->_integral += motor->_error;
	ADD	W10, #28, W4
	MOV	W4, [W14+28]
	ADD	W10, #20, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__AddSub_FP
	POP	W10
	MOV	[W14+28], W2
	MOV.D	W0, [W2]
;MotorDC.c,188 :: 		if(motor->_integral > MAX_INTEGRAL)
	ADD	W10, #28, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___MotorDC_UpdatePID35
	INC.B	W0
L___MotorDC_UpdatePID35:
	POP	W10
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID36
	GOTO	L__MotorDC_UpdatePID5
L___MotorDC_UpdatePID36:
;MotorDC.c,189 :: 		motor->_integral = MAX_INTEGRAL;
	ADD	W10, #28, W2
	MOV	#0, W0
	MOV	#17096, W1
	MOV.D	W0, [W2]
	GOTO	L__MotorDC_UpdatePID6
L__MotorDC_UpdatePID5:
;MotorDC.c,190 :: 		else if(motor->_integral < -MAX_INTEGRAL)
	ADD	W10, #28, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	#0, W2
	MOV	#49864, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___MotorDC_UpdatePID37
	INC.B	W0
L___MotorDC_UpdatePID37:
	POP	W10
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID38
	GOTO	L__MotorDC_UpdatePID7
L___MotorDC_UpdatePID38:
;MotorDC.c,191 :: 		motor->_integral = -MAX_INTEGRAL;
	ADD	W10, #28, W2
	MOV	#0, W0
	MOV	#49864, W1
	MOV.D	W0, [W2]
L__MotorDC_UpdatePID7:
L__MotorDC_UpdatePID6:
;MotorDC.c,192 :: 		derivative = motor->_error - motor->_lastError;
	ADD	W10, #20, W0
	MOV.D	[W0], W4
	MOV	W4, [W14+34]
	MOV	W5, [W14+36]
	ADD	W10, #24, W0
	MOV	W0, [W14+32]
	MOV.D	[W0], W2
	PUSH	W10
	MOV.D	W4, W0
	CALL	__Sub_FP
	POP	W10
	MOV	W0, [W14+8]
	MOV	W1, [W14+10]
;MotorDC.c,193 :: 		pidOutput = motor->_kp * motor->_error + motor->_ki * motor->_integral + motor->_kd * derivative;
	MOV.D	[W10], W2
	MOV	[W14+34], W0
	MOV	[W14+36], W1
	PUSH	W10
	CALL	__Mul_FP
	POP	W10
	MOV	W0, [W14+28]
	MOV	W1, [W14+30]
	ADD	W10, #4, W4
	ADD	W10, #28, W0
	MOV.D	[W0], W2
	MOV.D	[W4], W0
	PUSH	W10
	CALL	__Mul_FP
	MOV	[W14+28], W2
	MOV	[W14+30], W3
	CALL	__AddSub_FP
	POP	W10
	MOV	W0, [W14+28]
	MOV	W1, [W14+30]
	ADD	W10, #8, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	[W14+8], W2
	MOV	[W14+10], W3
	CALL	__Mul_FP
	MOV	[W14+28], W2
	MOV	[W14+30], W3
	CALL	__AddSub_FP
	POP	W10
; pidOutput start address is: 6 (W3)
	MOV	W0, W3
	MOV	W1, W4
;MotorDC.c,194 :: 		motor->_lastError = motor->_error;
	MOV	[W14+34], W1
	MOV	[W14+36], W2
	MOV	[W14+32], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;MotorDC.c,197 :: 		if (distance >= motor->_safeDistance) {
	MOV	#48, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W3
	PUSH	W4
	PUSH	W10
	MOV.D	W0, W2
	MOV	[W14+12], W0
	MOV	[W14+14], W1
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LT	L___MotorDC_UpdatePID39
	INC.B	W0
L___MotorDC_UpdatePID39:
	POP	W10
	POP	W4
	POP	W3
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID40
	GOTO	L__MotorDC_UpdatePID8
L___MotorDC_UpdatePID40:
;MotorDC.c,199 :: 		delta = pidOutput;
	MOV	W3, [W14+0]
	MOV	W4, [W14+2]
;MotorDC.c,200 :: 		if (delta > motor->_accelerationLimit)
	MOV	#40, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	PUSH	W10
; pidOutput end address is: 6 (W3)
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___MotorDC_UpdatePID41
	INC.B	W0
L___MotorDC_UpdatePID41:
	POP	W10
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID42
	GOTO	L__MotorDC_UpdatePID9
L___MotorDC_UpdatePID42:
;MotorDC.c,201 :: 		delta = motor->_accelerationLimit;
	MOV	#40, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	GOTO	L__MotorDC_UpdatePID10
L__MotorDC_UpdatePID9:
;MotorDC.c,202 :: 		else if (delta < -motor->_decelerationLimit)
	MOV	#44, W0
	ADD	W10, W0, W0
	MOV.D	[W0], W2
	MOV	#0, W0
	MOV	#32768, W1
	XOR	W2, W0, W0
	XOR	W3, W1, W1
	PUSH	W10
	MOV.D	W0, W2
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___MotorDC_UpdatePID43
	INC.B	W0
L___MotorDC_UpdatePID43:
	POP	W10
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID44
	GOTO	L__MotorDC_UpdatePID11
L___MotorDC_UpdatePID44:
;MotorDC.c,203 :: 		delta = -motor->_decelerationLimit;
	MOV	#44, W0
	ADD	W10, W0, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	MOV	#0, W1
	MOV	#32768, W2
	ADD	W14, #0, W0
	XOR	W3, W1, [W0++]
	XOR	W4, W2, [W0--]
L__MotorDC_UpdatePID11:
L__MotorDC_UpdatePID10:
;MotorDC.c,204 :: 		newOutput = motor->_output + delta;
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV.D	[W0], W2
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	PUSH	W10
	CALL	__AddSub_FP
	POP	W10
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;MotorDC.c,205 :: 		} else {
	GOTO	L__MotorDC_UpdatePID12
L__MotorDC_UpdatePID8:
;MotorDC.c,207 :: 		newOutput = motor->_output - motor->_decelerationLimit;
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV.D	[W0], W4
	MOV	#44, W0
	ADD	W10, W0, W0
	MOV.D	[W0], W2
	PUSH	W10
	MOV.D	W4, W0
	CALL	__Sub_FP
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;MotorDC.c,208 :: 		if(newOutput < 0)
	CLR	W2
	CLR	W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___MotorDC_UpdatePID45
	INC.B	W0
L___MotorDC_UpdatePID45:
	POP	W10
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID46
	GOTO	L__MotorDC_UpdatePID13
L___MotorDC_UpdatePID46:
;MotorDC.c,209 :: 		newOutput = 0;
	CLR	W0
	CLR	W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
L__MotorDC_UpdatePID13:
;MotorDC.c,210 :: 		}
L__MotorDC_UpdatePID12:
;MotorDC.c,212 :: 		if(newOutput > 90)
	PUSH	W10
	MOV	#0, W2
	MOV	#17076, W3
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L___MotorDC_UpdatePID47
	INC.B	W0
L___MotorDC_UpdatePID47:
	POP	W10
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID48
	GOTO	L__MotorDC_UpdatePID14
L___MotorDC_UpdatePID48:
;MotorDC.c,213 :: 		newOutput = 90;
	MOV	#0, W0
	MOV	#17076, W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	GOTO	L__MotorDC_UpdatePID15
L__MotorDC_UpdatePID14:
;MotorDC.c,214 :: 		else if(newOutput < 0)
	PUSH	W10
	CLR	W2
	CLR	W3
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L___MotorDC_UpdatePID49
	INC.B	W0
L___MotorDC_UpdatePID49:
	POP	W10
	CP0.B	W0
	BRA NZ	L___MotorDC_UpdatePID50
	GOTO	L__MotorDC_UpdatePID16
L___MotorDC_UpdatePID50:
;MotorDC.c,215 :: 		newOutput = 0;
	CLR	W0
	CLR	W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
L__MotorDC_UpdatePID16:
L__MotorDC_UpdatePID15:
;MotorDC.c,216 :: 		motor->_output = newOutput;
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	MOV.D	W0, [W2]
;MotorDC.c,220 :: 		motor->_currentSpeed = motor->_output;
	ADD	W10, #16, W1
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0++], [W1++]
	MOV	[W0--], [W1--]
;MotorDC.c,223 :: 		temp = (motor->_output * motor->_maxDuty) / 100.0;  // Tính giá tr? theo ki?u float
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0++], W3
	MOV	[W0--], W4
	MOV	#52, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
	MOV	W0, [W14+28]
	MOV	W1, [W14+30]
	MOV	W3, W2
	MOV	W4, W3
	CALL	__Mul_FP
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Div_FP
	CALL	__Float2Longint
;MotorDC.c,226 :: 		pwmDuty = motor->_maxDuty - temp;
	MOV	[W14+28], W1
	MOV	[W14+30], W2
	MOV	W1, [W14+28]
	MOV	W2, [W14+30]
	CLR	W1
	CALL	__Long2Float
	MOV	W0, [W14+16]
	MOV	W1, [W14+18]
	MOV	[W14+16], W2
	MOV	[W14+18], W3
	MOV	[W14+28], W0
	MOV	[W14+30], W1
	CALL	__Sub_FP
	CALL	__Float2Longint
;MotorDC.c,227 :: 		PWM_Set_Duty(pwmDuty,PWM_CHANNEL_M1);
	MOV	#1, W11
	MOV	W0, W10
	CALL	_PWM_Set_Duty
;MotorDC.c,229 :: 		}
L_end__MotorDC_UpdatePID:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of __MotorDC_UpdatePID

__MotorDC_Update:

;MotorDC.c,232 :: 		void _MotorDC_Update(_MotorDC *motor) {
;MotorDC.c,240 :: 		_MotorDC_UpdatePID(motor);
	CALL	__MotorDC_UpdatePID
;MotorDC.c,241 :: 		}
L_end__MotorDC_Update:
	RETURN
; end of __MotorDC_Update

__MotorDC_GetTargetSpeed:

;MotorDC.c,246 :: 		float _MotorDC_GetTargetSpeed(_MotorDC *motor) {
;MotorDC.c,247 :: 		return motor->_targetSpeed;
	ADD	W10, #12, W2
	MOV.D	[W2], W0
;MotorDC.c,248 :: 		}
L_end__MotorDC_GetTargetSpeed:
	RETURN
; end of __MotorDC_GetTargetSpeed

__MotorDC_GetCurrentSpeed:

;MotorDC.c,250 :: 		float _MotorDC_GetCurrentSpeed(_MotorDC *motor) {
;MotorDC.c,251 :: 		return motor->_currentSpeed;
	ADD	W10, #16, W2
	MOV.D	[W2], W0
;MotorDC.c,252 :: 		}
L_end__MotorDC_GetCurrentSpeed:
	RETURN
; end of __MotorDC_GetCurrentSpeed

__MotorDC_GetAccelerationLimit:

;MotorDC.c,254 :: 		float _MotorDC_GetAccelerationLimit(_MotorDC *motor) {
;MotorDC.c,255 :: 		return motor->_accelerationLimit;
	MOV	#40, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
;MotorDC.c,256 :: 		}
L_end__MotorDC_GetAccelerationLimit:
	RETURN
; end of __MotorDC_GetAccelerationLimit

__MotorDC_GetDecelerationLimit:

;MotorDC.c,258 :: 		float _MotorDC_GetDecelerationLimit(_MotorDC *motor) {
;MotorDC.c,259 :: 		return motor->_decelerationLimit;
	MOV	#44, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
;MotorDC.c,260 :: 		}
L_end__MotorDC_GetDecelerationLimit:
	RETURN
; end of __MotorDC_GetDecelerationLimit

__MotorDC_GetSafeDistance:

;MotorDC.c,262 :: 		float _MotorDC_GetSafeDistance(_MotorDC *motor) {
;MotorDC.c,263 :: 		return motor->_safeDistance;
	MOV	#48, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
;MotorDC.c,264 :: 		}
L_end__MotorDC_GetSafeDistance:
	RETURN
; end of __MotorDC_GetSafeDistance

__MotorDC_GetMaxDuty:

;MotorDC.c,266 :: 		unsigned int _MotorDC_GetMaxDuty(_MotorDC *motor) {
;MotorDC.c,267 :: 		return (unsigned int)motor->_maxDuty;
	MOV	#52, W0
	ADD	W10, W0, W1
	MOV.D	[W1], W0
	CALL	__Float2Longint
;MotorDC.c,268 :: 		}
L_end__MotorDC_GetMaxDuty:
	RETURN
; end of __MotorDC_GetMaxDuty

__MotorDC_GetDirection:

;MotorDC.c,270 :: 		MotorDirection _MotorDC_GetDirection(_MotorDC *motor) {
;MotorDC.c,271 :: 		return motor->_direction;
	MOV	#56, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W0
;MotorDC.c,272 :: 		}
L_end__MotorDC_GetDirection:
	RETURN
; end of __MotorDC_GetDirection

__MotorDC_GetOutput:

;MotorDC.c,274 :: 		float _MotorDC_GetOutput(_MotorDC *motor) {
;MotorDC.c,275 :: 		return motor->_output;
	MOV	#32, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
;MotorDC.c,276 :: 		}
L_end__MotorDC_GetOutput:
	RETURN
; end of __MotorDC_GetOutput

__MotorDC_GetDistanceSensorValue:

;MotorDC.c,278 :: 		float _MotorDC_GetDistanceSensorValue(_MotorDC *motor) {
;MotorDC.c,279 :: 		return motor->_distanceSensorValue;
	MOV	#36, W0
	ADD	W10, W0, W2
	MOV.D	[W2], W0
;MotorDC.c,280 :: 		}
L_end__MotorDC_GetDistanceSensorValue:
	RETURN
; end of __MotorDC_GetDistanceSensorValue

__MotorDC_GetInfo:
	LNK	#8

;MotorDC.c,283 :: 		char* _MotorDC_GetInfo(_MotorDC *motor) {
;MotorDC.c,296 :: 		motor->_distanceSensorValue
	MOV	#36, W0
	ADD	W10, W0, W0
	MOV	W0, [W14+6]
;MotorDC.c,295 :: 		motor->_output,
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	W0, [W14+4]
;MotorDC.c,294 :: 		motor->_status,
	MOV	#58, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	MOV	W0, [W14+2]
;MotorDC.c,293 :: 		motor->_direction,
	MOV	#56, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	MOV	W0, [W14+0]
;MotorDC.c,292 :: 		(unsigned int)motor->_maxDuty,
	MOV	#52, W0
	ADD	W10, W0, W1
	PUSH	W10
	MOV.D	[W1], W0
	CALL	__Float2Longint
	POP	W10
;MotorDC.c,291 :: 		motor->_safeDistance,
	MOV	#48, W1
	ADD	W10, W1, W9
;MotorDC.c,290 :: 		motor->_decelerationLimit,
	MOV	#44, W1
	ADD	W10, W1, W8
;MotorDC.c,289 :: 		motor->_accelerationLimit,
	MOV	#40, W1
	ADD	W10, W1, W7
;MotorDC.c,288 :: 		motor->_currentSpeed,
	ADD	W10, #16, W6
;MotorDC.c,287 :: 		motor->_targetSpeed,
	ADD	W10, #12, W5
;MotorDC.c,296 :: 		motor->_distanceSensorValue
	MOV	[W14+6], W4
	MOV	[W14+4], W3
	MOV	[W14+2], W2
	MOV	[W14+0], W1
	PUSH	[W4++]
	PUSH	[W4--]
;MotorDC.c,295 :: 		motor->_output,
	PUSH	[W3++]
	PUSH	[W3--]
;MotorDC.c,294 :: 		motor->_status,
	PUSH	W2
;MotorDC.c,293 :: 		motor->_direction,
	PUSH	W1
;MotorDC.c,292 :: 		(unsigned int)motor->_maxDuty,
	PUSH	W0
;MotorDC.c,291 :: 		motor->_safeDistance,
	PUSH	[W9++]
	PUSH	[W9--]
;MotorDC.c,290 :: 		motor->_decelerationLimit,
	PUSH	[W8++]
	PUSH	[W8--]
;MotorDC.c,289 :: 		motor->_accelerationLimit,
	PUSH	[W7++]
	PUSH	[W7--]
;MotorDC.c,288 :: 		motor->_currentSpeed,
	PUSH	[W6++]
	PUSH	[W6--]
;MotorDC.c,287 :: 		motor->_targetSpeed,
	PUSH	[W5++]
	PUSH	[W5--]
;MotorDC.c,286 :: 		"{\"targetSpeed\":%.2f,\"currentSpeed\":%.2f,\"accelerationLimit\":%.2f,\"decelerationLimit\":%.2f,\"safeDistance\":%.2f,\"maxDuty\":%u,\"direction\":%d,\"status\":%d,\"output\":%.2f,\"distanceSensorValue\":%.2f}",
	MOV	#lo_addr(?lstr_3_MotorDC), W0
	PUSH	W0
;MotorDC.c,285 :: 		sprintf(_jsonStr,
	MOV	#lo_addr(_MotorDC_GetInfo__jsonStr_L0), W0
	PUSH	W0
;MotorDC.c,296 :: 		motor->_distanceSensorValue
	CALL	_sprintf
	SUB	#38, W15
;MotorDC.c,298 :: 		return _jsonStr;
	MOV	#lo_addr(_MotorDC_GetInfo__jsonStr_L0), W0
;MotorDC.c,299 :: 		}
L_end__MotorDC_GetInfo:
	ULNK
	RETURN
; end of __MotorDC_GetInfo
