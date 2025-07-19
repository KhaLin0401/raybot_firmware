
_init_distance_sensors:

;robot_system.c,25 :: 		void init_distance_sensors() {
;robot_system.c,26 :: 		DistanceSensor_Init(&sensor_front, SENS3, SENSOR_GP2Y0A21YK0F);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CLR	W12
	CLR	W11
	MOV	#lo_addr(_sensor_front), W10
	CALL	_DistanceSensor_Init
;robot_system.c,27 :: 		DistanceSensor_Init(&sensor_rear, SENS4, SENSOR_GP2Y0A21YK0F);
	CLR	W12
	MOV.B	#2, W11
	MOV	#lo_addr(_sensor_rear), W10
	CALL	_DistanceSensor_Init
;robot_system.c,28 :: 		DistanceSensor_Init(&sensor_lifter, SENS5, SENSOR_GP2Y0A02YK0F);
	MOV.B	#1, W12
	MOV.B	#6, W11
	MOV	#lo_addr(_sensor_lifter), W10
	CALL	_DistanceSensor_Init
;robot_system.c,29 :: 		DistanceSensor_Init(&sensor_box, SENS6, SENSOR_GP2Y0A21YK0F);
	CLR	W12
	MOV.B	#7, W11
	MOV	#lo_addr(_sensor_box), W10
	CALL	_DistanceSensor_Init
;robot_system.c,31 :: 		}
L_end_init_distance_sensors:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _init_distance_sensors

_update_all_sensors:

;robot_system.c,36 :: 		void update_all_sensors() {
;robot_system.c,38 :: 		DistanceSensor_Update(&sensor_front);
	PUSH	W10
	MOV	#lo_addr(_sensor_front), W10
	CALL	_DistanceSensor_Update
;robot_system.c,39 :: 		DistanceSensor_Update(&sensor_rear);
	MOV	#lo_addr(_sensor_rear), W10
	CALL	_DistanceSensor_Update
;robot_system.c,40 :: 		DistanceSensor_Update(&sensor_lifter);
	MOV	#lo_addr(_sensor_lifter), W10
	CALL	_DistanceSensor_Update
;robot_system.c,41 :: 		DistanceSensor_Update(&sensor_box);
	MOV	#lo_addr(_sensor_box), W10
	CALL	_DistanceSensor_Update
;robot_system.c,54 :: 		}
L_end_update_all_sensors:
	POP	W10
	RETURN
; end of _update_all_sensors

_DebugUART_Init:

;robot_system.c,62 :: 		void DebugUART_Init() {
;robot_system.c,63 :: 		Soft_UART_Init(&PORTA, 1, 0, 9600, 0); // TX: RC7, RX: RC6, Baud 9600
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	CLR	W12
	MOV	#1, W11
	MOV	#lo_addr(PORTA), W10
	MOV	#9600, W0
	MOV	#0, W1
	PUSH.D	W0
	CALL	_Soft_UART_Init
	SUB	#4, W15
;robot_system.c,64 :: 		}
L_end_DebugUART_Init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _DebugUART_Init

_DebugUART_Send_Text:

;robot_system.c,70 :: 		void DebugUART_Send_Text(const char *text) {
;robot_system.c,72 :: 		for (i = 0; i < 150 && text[i] != '\0'; i++) {
; i start address is: 12 (W6)
	CLR	W6
; i end address is: 12 (W6)
L_DebugUART_Send_Text0:
; i start address is: 12 (W6)
	MOV	#150, W0
	CP	W6, W0
	BRA LT	L__DebugUART_Send_Text12
	GOTO	L__DebugUART_Send_Text7
L__DebugUART_Send_Text12:
	ADD	W10, W6, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W1], W0
	CP.B	W0, #0
	BRA NZ	L__DebugUART_Send_Text13
	GOTO	L__DebugUART_Send_Text6
L__DebugUART_Send_Text13:
L__DebugUART_Send_Text5:
;robot_system.c,73 :: 		Soft_UART_Write(text[i]);
	ADD	W10, W6, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	PUSH	W10
	MOV.B	[W1], W10
	CALL	_Soft_UART_Write
	POP	W10
;robot_system.c,72 :: 		for (i = 0; i < 150 && text[i] != '\0'; i++) {
	INC	W6
;robot_system.c,74 :: 		}
; i end address is: 12 (W6)
	GOTO	L_DebugUART_Send_Text0
;robot_system.c,72 :: 		for (i = 0; i < 150 && text[i] != '\0'; i++) {
L__DebugUART_Send_Text7:
L__DebugUART_Send_Text6:
;robot_system.c,75 :: 		}
L_end_DebugUART_Send_Text:
	RETURN
; end of _DebugUART_Send_Text
