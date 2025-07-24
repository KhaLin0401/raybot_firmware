
_init_hardware:

;Main.c,9 :: 		void init_hardware() {
;Main.c,11 :: 		TRISAbits.TRISA0 = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BSET.B	TRISAbits, #0
;Main.c,12 :: 		TRISAbits.TRISA1 = 1;
	BSET.B	TRISAbits, #1
;Main.c,13 :: 		TRISBbits.TRISB2 = 1;
	BSET.B	TRISBbits, #2
;Main.c,14 :: 		TRISBbits.TRISB3 = 1;
	BSET.B	TRISBbits, #3
;Main.c,15 :: 		TRISCbits.TRISC0 = 1;
	BSET.B	TRISCbits, #0
;Main.c,16 :: 		TRISCbits.TRISC1 = 1;
	BSET.B	TRISCbits, #1
;Main.c,19 :: 		ADC1_Init();
	CALL	_ADC1_Init
;Main.c,22 :: 		TRISAbits.TRISA9 = 1;
	BSET	TRISAbits, #9
;Main.c,23 :: 		AD1PCFGbits.PCFG9 = 1;
	BSET	AD1PCFGbits, #9
;Main.c,24 :: 		TRISCbits.TRISC4 = 1;
	BSET.B	TRISCbits, #4
;Main.c,25 :: 		AD1PCFGbits.PCFG4 = 1;
	BSET.B	AD1PCFGbits, #4
;Main.c,28 :: 		TRISAbits.TRISA4 = 1;
	BSET.B	TRISAbits, #4
;Main.c,29 :: 		LATA4_bit = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;Main.c,30 :: 		TRISB4_bit = 1; // RB4: output
	BSET	TRISB4_bit, BitPos(TRISB4_bit+0)
;Main.c,31 :: 		LATB4_bit = 1;
	BSET	LATB4_bit, BitPos(LATB4_bit+0)
;Main.c,32 :: 		TRISA8_bit = 0; // RA8: output
	BCLR	TRISA8_bit, BitPos(TRISA8_bit+0)
;Main.c,33 :: 		LATA8_bit = 1;
	BSET	LATA8_bit, BitPos(LATA8_bit+0)
;Main.c,36 :: 		TRISC7_bit = 0; // RC7: output
	BCLR	TRISC7_bit, BitPos(TRISC7_bit+0)
;Main.c,37 :: 		LATC7_bit = 1;
	BSET	LATC7_bit, BitPos(LATC7_bit+0)
;Main.c,38 :: 		TRISC6_bit = 0; // RB6: output
	BCLR	TRISC6_bit, BitPos(TRISC6_bit+0)
;Main.c,39 :: 		LATC6_bit = 0;
	BCLR	LATC6_bit, BitPos(LATC6_bit+0)
;Main.c,40 :: 		TRISC8_bit = 0; // RC8: output
	BCLR	TRISC8_bit, BitPos(TRISC8_bit+0)
;Main.c,41 :: 		LATC8_bit = 1;
	BSET	LATC8_bit, BitPos(LATC8_bit+0)
;Main.c,44 :: 		TRISB12_bit = 0; // EN_M1/M2
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;Main.c,45 :: 		LATB12_bit = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Main.c,46 :: 		TRISB5_bit = 0; // EN_lifter
	BCLR	TRISB5_bit, BitPos(TRISB5_bit+0)
;Main.c,47 :: 		LATB5_bit = 0;
	BCLR	LATB5_bit, BitPos(LATB5_bit+0)
;Main.c,50 :: 		Unlock_IOLOCK();
	CALL	_Unlock_IOLOCK
;Main.c,51 :: 		PPS_Mapping_NoLock(RX1, _INPUT, _U1RX);   // RP8 -> U1RX (BMS)
	MOV.B	#13, W12
	MOV.B	#1, W11
	MOV.B	#9, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,52 :: 		PPS_Mapping_NoLock(TX1, _OUTPUT, _U1TX);  // RP9 -> U1TX (BMS)
	MOV.B	#3, W12
	CLR	W11
	MOV.B	#8, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,53 :: 		PPS_Mapping_NoLock(RX2, _INPUT, _U2RX);   // RP3 -> U2RX (Communication)
	MOV.B	#15, W12
	MOV.B	#1, W11
	MOV.B	#11, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,54 :: 		PPS_Mapping_NoLock(TX2, _OUTPUT, _U2TX);  // RP2 -> U2TX (Communication)
	MOV.B	#5, W12
	CLR	W11
	MOV.B	#10, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,55 :: 		PPS_Mapping_NoLock(25, _OUTPUT, _OC1);    // RP25 -> PWM1
	MOV.B	#18, W12
	CLR	W11
	MOV.B	#25, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,56 :: 		PPS_Mapping_NoLock(22, _OUTPUT, _OC2);    // RP22 -> PWM2
	MOV.B	#19, W12
	CLR	W11
	MOV.B	#22, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,57 :: 		PPS_Mapping_NoLock(7, _OUTPUT, _OC3);     // RP7 -> lifter (PWM3)
	MOV.B	#20, W12
	CLR	W11
	MOV.B	#7, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,58 :: 		PPS_Mapping_NoLock(6, _OUTPUT, _OC4);     // RP6 -> lifter (PWM4)
	MOV.B	#21, W12
	CLR	W11
	MOV.B	#6, W10
	CALL	_PPS_Mapping_NoLock
;Main.c,59 :: 		Lock_IOLOCK();
	CALL	_Lock_IOLOCK
;Main.c,60 :: 		}
L_end_init_hardware:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _init_hardware

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;Main.c,63 :: 		void main() {
;Main.c,64 :: 		init_hardware();
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CALL	_init_hardware
;Main.c,67 :: 		UART1_Init(9600);  // BMS sử dụng UART1
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Main.c,68 :: 		UART2_Init(9600);  // Communication sử dụng UART2
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART2_Init
;Main.c,69 :: 		_UART2_Init();     // Khởi tạo UART2 custom
	CALL	__UART2_Init
;Main.c,71 :: 		DebugUART_Init();
	CALL	_DebugUART_Init
;Main.c,72 :: 		_MotorDC_Init(&motorDC, 2.0, 0.5, 1.0, 0);
	MOV	#0, W11
	MOV	#16384, W12
	MOV	#lo_addr(_motorDC), W10
	CLR	W0
	CLR	W1
	PUSH.D	W0
	MOV	#0, W0
	MOV	#16256, W1
	PUSH.D	W0
	MOV	#0, W0
	MOV	#16128, W1
	PUSH.D	W0
	CALL	__MotorDC_Init
	SUB	#12, W15
;Main.c,73 :: 		_MotorDC_SetSafeDistance(&motorDC, 40);
	MOV	#0, W11
	MOV	#16928, W12
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_SetSafeDistance
;Main.c,74 :: 		_Lifter_Init(&lifter, 1.0, 0.5, 0.1, 30);
	MOV	#0, W11
	MOV	#16256, W12
	MOV	#lo_addr(_lifter), W10
	MOV	#0, W0
	MOV	#16880, W1
	PUSH.D	W0
	MOV	#52429, W0
	MOV	#15820, W1
	PUSH.D	W0
	MOV	#0, W0
	MOV	#16128, W1
	PUSH.D	W0
	CALL	__Lifter_Init
	SUB	#12, W15
;Main.c,75 :: 		BMS_Init();        // BMS_Init() sẽ khởi tạo UART1
	CALL	_BMS_Init
;Main.c,76 :: 		Lms_Init();
	CALL	_Lms_Init
;Main.c,77 :: 		init_distance_sensors();
	CALL	_init_distance_sensors
;Main.c,78 :: 		CommandHandler_Init(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Init
;Main.c,80 :: 		_F_schedule_init();
	CALL	__F_schedule_init
;Main.c,82 :: 		while (1) {
L_main0:
;Main.c,83 :: 		task_dispatch(); // Gọi Scheduler của MikroE
	CALL	_task_dispatch
;Main.c,84 :: 		}
	GOTO	L_main0
;Main.c,85 :: 		}
L_end_main:
	POP	W12
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
