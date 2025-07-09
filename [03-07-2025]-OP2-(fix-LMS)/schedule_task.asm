
__F_timer1_init:

;schedule_task.c,21 :: 		void _F_timer1_init(void) {
;schedule_task.c,25 :: 		T1CON = 0x8030;
	MOV	#32816, W0
	MOV	WREG, T1CON
;schedule_task.c,26 :: 		PR1 = 6200;
	MOV	#6200, W0
	MOV	WREG, PR1
;schedule_task.c,27 :: 		TMR1 = 0;
	CLR	TMR1
;schedule_task.c,30 :: 		IPC0bits.T1IP = 5;
	MOV	#20480, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;schedule_task.c,31 :: 		IFS0bits.T1IF = 0;  // X�a c? ng?t Timer1
	BCLR.B	IFS0bits, #3
;schedule_task.c,32 :: 		IEC0bits.T1IE = 1;  // Cho ph�p ng?t Timer1
	BSET.B	IEC0bits, #3
;schedule_task.c,33 :: 		}
L_end__F_timer1_init:
	RETURN
; end of __F_timer1_init

___attribute__:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;schedule_task.c,38 :: 		void __attribute__() iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO {
;schedule_task.c,39 :: 		task_scheduler_clock();
	CALL	_task_scheduler_clock
;schedule_task.c,40 :: 		IFS0bits.T1IF = 0;
	BCLR.B	IFS0bits, #3
;schedule_task.c,41 :: 		}
L_end___attribute__:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of ___attribute__

__F_process_uart_command:
	LNK	#180

;schedule_task.c,48 :: 		void _F_process_uart_command(void) {
;schedule_task.c,53 :: 		if(_UART2_Rx_GetCommand(_command)) {
	PUSH	W10
	PUSH	W11
	PUSH	W12
	ADD	W14, #0, W0
	MOV	W0, W10
	CALL	__UART2_Rx_GetCommand
	CP0.B	W0
	BRA NZ	L___F_process_uart_command44
	GOTO	L__F_process_uart_command0
L___F_process_uart_command44:
;schedule_task.c,56 :: 		if (strcmp(_command, "GET_STATUS") == 0) {
	ADD	W14, #0, W0
	MOV	#lo_addr(?lstr1_schedule_task), W11
	MOV	W0, W10
	CALL	_strcmp
	CP	W0, #0
	BRA Z	L___F_process_uart_command45
	GOTO	L__F_process_uart_command1
L___F_process_uart_command45:
;schedule_task.c,59 :: 		}
	GOTO	L__F_process_uart_command2
L__F_process_uart_command1:
;schedule_task.c,60 :: 		else if (strcmp(_command, "RESET") == 0) {
	ADD	W14, #0, W0
	MOV	#lo_addr(?lstr2_schedule_task), W11
	MOV	W0, W10
	CALL	_strcmp
	CP	W0, #0
	BRA Z	L___F_process_uart_command46
	GOTO	L__F_process_uart_command3
L___F_process_uart_command46:
;schedule_task.c,64 :: 		}
	GOTO	L__F_process_uart_command4
L__F_process_uart_command3:
;schedule_task.c,65 :: 		else if (strncmp(_command, "SET_", 4) == 0) {
	ADD	W14, #0, W0
	MOV.B	#4, W12
	MOV	#lo_addr(?lstr3_schedule_task), W11
	MOV	W0, W10
	CALL	_strncmp
	CP	W0, #0
	BRA Z	L___F_process_uart_command47
	GOTO	L__F_process_uart_command5
L___F_process_uart_command47:
;schedule_task.c,68 :: 		CommandHandler_Execute(&cmdHandler,_command);
	ADD	W14, #0, W0
	MOV	W0, W11
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Execute
;schedule_task.c,70 :: 		}
	GOTO	L__F_process_uart_command6
L__F_process_uart_command5:
;schedule_task.c,71 :: 		else if (strncmp(_command, "GET_", 4) == 0) {
	ADD	W14, #0, W0
	MOV.B	#4, W12
	MOV	#lo_addr(?lstr4_schedule_task), W11
	MOV	W0, W10
	CALL	_strncmp
	CP	W0, #0
	BRA Z	L___F_process_uart_command48
	GOTO	L__F_process_uart_command7
L___F_process_uart_command48:
;schedule_task.c,74 :: 		CommandHandler_Execute(&cmdHandler,_command);
	ADD	W14, #0, W0
	MOV	W0, W11
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Execute
;schedule_task.c,76 :: 		}
	GOTO	L__F_process_uart_command8
L__F_process_uart_command7:
;schedule_task.c,77 :: 		else if (_command[0] == '>') {
	ADD	W14, #0, W0
	MOV.B	[W0], W1
	MOV.B	#62, W0
	CP.B	W1, W0
	BRA Z	L___F_process_uart_command49
	GOTO	L__F_process_uart_command9
L___F_process_uart_command49:
;schedule_task.c,80 :: 		CommandHandler_Execute(&cmdHandler,_command);
	ADD	W14, #0, W0
	MOV	W0, W11
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Execute
;schedule_task.c,82 :: 		}
	GOTO	L__F_process_uart_command10
L__F_process_uart_command9:
;schedule_task.c,85 :: 		DebugUART_Send_Text("[Lenh khong hop le]\n");
	MOV	#lo_addr(?lstr_5_schedule_task), W10
	CALL	_DebugUART_Send_Text
;schedule_task.c,86 :: 		}
L__F_process_uart_command10:
L__F_process_uart_command8:
L__F_process_uart_command6:
L__F_process_uart_command4:
L__F_process_uart_command2:
;schedule_task.c,90 :: 		}
L__F_process_uart_command0:
;schedule_task.c,91 :: 		_UART2_SendProcess();
	CALL	__UART2_SendProcess
;schedule_task.c,94 :: 		BMS_Update();
	CALL	_BMS_Update
;schedule_task.c,96 :: 		}
L_end__F_process_uart_command:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of __F_process_uart_command

__F_update_system_status:

;schedule_task.c,102 :: 		void _F_update_system_status(void) {
;schedule_task.c,105 :: 		update_all_sensors();
	PUSH	W10
	CALL	_update_all_sensors
;schedule_task.c,106 :: 		Box_UpdateStatus(&Box_t);
	MOV	#lo_addr(_Box_t), W10
	CALL	_Box_UpdateStatus
;schedule_task.c,109 :: 		}
L_end__F_update_system_status:
	POP	W10
	RETURN
; end of __F_update_system_status

__SC_update_motor:

;schedule_task.c,114 :: 		void _SC_update_motor(void) {
;schedule_task.c,116 :: 		if(motorDC._direction == 0) // Chay THUAN
	PUSH	W10
	MOV	_motorDC+56, W0
	CP	W0, #0
	BRA Z	L___SC_update_motor52
	GOTO	L__SC_update_motor11
L___SC_update_motor52:
;schedule_task.c,117 :: 		motorDC._distanceSensorValue = sensor_front.distance_cm;
	MOV	_sensor_front+22, W0
	MOV	_sensor_front+24, W1
	MOV	W0, _motorDC+36
	MOV	W1, _motorDC+38
	GOTO	L__SC_update_motor12
L__SC_update_motor11:
;schedule_task.c,118 :: 		else if(motorDC._direction == 1)
	MOV	_motorDC+56, W0
	CP	W0, #1
	BRA Z	L___SC_update_motor53
	GOTO	L__SC_update_motor13
L___SC_update_motor53:
;schedule_task.c,119 :: 		motorDC._distanceSensorValue = sensor_rear.distance_cm;
	MOV	_sensor_rear+22, W0
	MOV	_sensor_rear+24, W1
	MOV	W0, _motorDC+36
	MOV	W1, _motorDC+38
	GOTO	L__SC_update_motor14
L__SC_update_motor13:
;schedule_task.c,121 :: 		motorDC._distanceSensorValue = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _motorDC+36
	MOV	W1, _motorDC+38
L__SC_update_motor14:
L__SC_update_motor12:
;schedule_task.c,122 :: 		lifter._currentPosition = sensor_lifter.distance_cm;
	MOV	_sensor_lifter+22, W0
	MOV	_sensor_lifter+24, W1
	MOV	W0, _lifter+16
	MOV	W1, _lifter+18
;schedule_task.c,126 :: 		_Lifter_Get_Run_Mode(&lifter);
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Get_Run_Mode
;schedule_task.c,127 :: 		if (Lms_isPressed() && lifter.run_mode == LIFTER_RUN_UP){
	CALL	_Lms_isPressed
	CP0.B	W0
	BRA NZ	L___SC_update_motor54
	GOTO	L___SC_update_motor38
L___SC_update_motor54:
	MOV	_lifter+60, W0
	CP	W0, #1
	BRA Z	L___SC_update_motor55
	GOTO	L___SC_update_motor37
L___SC_update_motor55:
L___SC_update_motor36:
;schedule_task.c,128 :: 		_Lifter_Disable(&lifter);         // D?ng motor n�ng h?       // C?p nh?t motor ph?
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Disable
;schedule_task.c,129 :: 		LATA4_bit = 1;                    // Buzzer k�u c?nh b�o
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;schedule_task.c,130 :: 		}
	GOTO	L__SC_update_motor18
;schedule_task.c,127 :: 		if (Lms_isPressed() && lifter.run_mode == LIFTER_RUN_UP){
L___SC_update_motor38:
L___SC_update_motor37:
;schedule_task.c,134 :: 		_Lifter_Update(&lifter);             // C?p nh?t PID cho lifter
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Update
;schedule_task.c,141 :: 		}
L__SC_update_motor18:
;schedule_task.c,143 :: 		if (lifter._currentPosition <= 25 || Lms_isPressed()){
	MOV	#0, W2
	MOV	#16840, W3
	MOV	_lifter+16, W0
	MOV	_lifter+18, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GT	L___SC_update_motor56
	INC.B	W0
L___SC_update_motor56:
	CP0.B	W0
	BRA Z	L___SC_update_motor57
	GOTO	L___SC_update_motor40
L___SC_update_motor57:
	CALL	_Lms_isPressed
	CP0.B	W0
	BRA Z	L___SC_update_motor58
	GOTO	L___SC_update_motor39
L___SC_update_motor58:
	GOTO	L__SC_update_motor21
L___SC_update_motor40:
L___SC_update_motor39:
;schedule_task.c,144 :: 		_MotorDC_UpdatePID(&motorDC);
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_UpdatePID
;schedule_task.c,145 :: 		}
L__SC_update_motor21:
;schedule_task.c,146 :: 		if (motorDC._output <= 0){
	CLR	W2
	CLR	W3
	MOV	_motorDC+32, W0
	MOV	_motorDC+34, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GT	L___SC_update_motor59
	INC.B	W0
L___SC_update_motor59:
	CP0.B	W0
	BRA NZ	L___SC_update_motor60
	GOTO	L__SC_update_motor22
L___SC_update_motor60:
;schedule_task.c,147 :: 		LATB4_bit = 1;
	BSET	LATB4_bit, BitPos(LATB4_bit+0)
;schedule_task.c,148 :: 		LATA8_bit = 1;
	BSET	LATA8_bit, BitPos(LATA8_bit+0)
;schedule_task.c,149 :: 		}
	GOTO	L__SC_update_motor23
L__SC_update_motor22:
;schedule_task.c,151 :: 		LATB4_bit = 0;
	BCLR	LATB4_bit, BitPos(LATB4_bit+0)
;schedule_task.c,152 :: 		LATA8_bit = 0;
	BCLR	LATA8_bit, BitPos(LATA8_bit+0)
;schedule_task.c,153 :: 		}
L__SC_update_motor23:
;schedule_task.c,160 :: 		}
L_end__SC_update_motor:
	POP	W10
	RETURN
; end of __SC_update_motor

__F_update_to_server:

;schedule_task.c,163 :: 		void _F_update_to_server(void){
;schedule_task.c,165 :: 		switch(send_index){
	PUSH	W10
	GOTO	L__F_update_to_server24
;schedule_task.c,166 :: 		case 0:
L__F_update_to_server26:
;schedule_task.c,167 :: 		handle_get_bat_info(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_handle_get_bat_info
;schedule_task.c,168 :: 		CommandHandler_Respond(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Respond
;schedule_task.c,169 :: 		send_index = 1;
	MOV	#1, W0
	MOV	W0, _send_index
;schedule_task.c,170 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,171 :: 		case 1:
L__F_update_to_server27:
;schedule_task.c,172 :: 		handle_get_chg_info(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_handle_get_chg_info
;schedule_task.c,173 :: 		CommandHandler_Respond(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Respond
;schedule_task.c,174 :: 		send_index = 2;
	MOV	#2, W0
	MOV	W0, _send_index
;schedule_task.c,175 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,176 :: 		case 2:
L__F_update_to_server28:
;schedule_task.c,177 :: 		handle_get_dis_info(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_handle_get_dis_info
;schedule_task.c,178 :: 		CommandHandler_Respond(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Respond
;schedule_task.c,179 :: 		send_index = 3;
	MOV	#3, W0
	MOV	W0, _send_index
;schedule_task.c,180 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,181 :: 		case 3:
L__F_update_to_server29:
;schedule_task.c,182 :: 		handle_get_dist_info(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_handle_get_dist_info
;schedule_task.c,183 :: 		CommandHandler_Respond(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Respond
;schedule_task.c,184 :: 		send_index = 4;
	MOV	#4, W0
	MOV	W0, _send_index
;schedule_task.c,185 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,186 :: 		case 4:
L__F_update_to_server30:
;schedule_task.c,187 :: 		handle_get_lifter_info(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_handle_get_lifter_info
;schedule_task.c,188 :: 		CommandHandler_Respond(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Respond
;schedule_task.c,189 :: 		send_index = 5;
	MOV	#5, W0
	MOV	W0, _send_index
;schedule_task.c,190 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,191 :: 		case 5:
L__F_update_to_server31:
;schedule_task.c,192 :: 		handle_get_motor_info(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_handle_get_motor_info
;schedule_task.c,193 :: 		CommandHandler_Respond(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Respond
;schedule_task.c,194 :: 		send_index = 7;
	MOV	#7, W0
	MOV	W0, _send_index
;schedule_task.c,195 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,196 :: 		case 6:
L__F_update_to_server32:
;schedule_task.c,197 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,198 :: 		case 7:
L__F_update_to_server33:
;schedule_task.c,199 :: 		handle_get_box_status(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_handle_get_box_status
;schedule_task.c,200 :: 		CommandHandler_Respond(&cmdHandler);
	MOV	#lo_addr(_cmdHandler), W10
	CALL	_CommandHandler_Respond
;schedule_task.c,201 :: 		send_index = 0;
	CLR	W0
	MOV	W0, _send_index
;schedule_task.c,202 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,203 :: 		default:
L__F_update_to_server34:
;schedule_task.c,204 :: 		send_index = 0;
	CLR	W0
	MOV	W0, _send_index
;schedule_task.c,205 :: 		break;
	GOTO	L__F_update_to_server25
;schedule_task.c,206 :: 		}
L__F_update_to_server24:
	MOV	_send_index, W0
	CP	W0, #0
	BRA NZ	L___F_update_to_server62
	GOTO	L__F_update_to_server26
L___F_update_to_server62:
	MOV	_send_index, W0
	CP	W0, #1
	BRA NZ	L___F_update_to_server63
	GOTO	L__F_update_to_server27
L___F_update_to_server63:
	MOV	_send_index, W0
	CP	W0, #2
	BRA NZ	L___F_update_to_server64
	GOTO	L__F_update_to_server28
L___F_update_to_server64:
	MOV	_send_index, W0
	CP	W0, #3
	BRA NZ	L___F_update_to_server65
	GOTO	L__F_update_to_server29
L___F_update_to_server65:
	MOV	_send_index, W0
	CP	W0, #4
	BRA NZ	L___F_update_to_server66
	GOTO	L__F_update_to_server30
L___F_update_to_server66:
	MOV	_send_index, W0
	CP	W0, #5
	BRA NZ	L___F_update_to_server67
	GOTO	L__F_update_to_server31
L___F_update_to_server67:
	MOV	_send_index, W0
	CP	W0, #6
	BRA NZ	L___F_update_to_server68
	GOTO	L__F_update_to_server32
L___F_update_to_server68:
	MOV	_send_index, W0
	CP	W0, #7
	BRA NZ	L___F_update_to_server69
	GOTO	L__F_update_to_server33
L___F_update_to_server69:
	GOTO	L__F_update_to_server34
L__F_update_to_server25:
;schedule_task.c,208 :: 		}
L_end__F_update_to_server:
	POP	W10
	RETURN
; end of __F_update_to_server

__F_schedule_init:

;schedule_task.c,215 :: 		void _F_schedule_init(void) {
;schedule_task.c,216 :: 		DebugUART_Send_Text("Initializing Task Scheduler...\n");
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(?lstr_6_schedule_task), W10
	CALL	_DebugUART_Send_Text
;schedule_task.c,219 :: 		_F_timer1_init();
	CALL	__F_timer1_init
;schedule_task.c,221 :: 		task_scheduler_init(1000);
	MOV	#1000, W10
	CALL	_task_scheduler_init
;schedule_task.c,224 :: 		_task_uart = task_add(_F_process_uart_command, 50);
	MOV	#50, W11
	MOV	#0, W12
	MOV	#lo_addr(__F_process_uart_command), W10
	CALL	_task_add
	MOV	#lo_addr(__task_uart), W1
	MOV.B	W0, [W1]
;schedule_task.c,225 :: 		_task_update_to_server = task_add(_F_update_to_server, 950);
	MOV	#950, W11
	MOV	#0, W12
	MOV	#lo_addr(__F_update_to_server), W10
	CALL	_task_add
	MOV	#lo_addr(__task_update_to_server), W1
	MOV.B	W0, [W1]
;schedule_task.c,226 :: 		_task_update_motor = task_add(_SC_update_motor, 100);
	MOV	#100, W11
	MOV	#0, W12
	MOV	#lo_addr(__SC_update_motor), W10
	CALL	_task_add
	MOV	#lo_addr(__task_update_motor), W1
	MOV.B	W0, [W1]
;schedule_task.c,227 :: 		_task_update_BMS = task_add(BMS_Update, 850);
	MOV	#850, W11
	MOV	#0, W12
	MOV	#lo_addr(_BMS_Update), W10
	CALL	_task_add
	MOV	#lo_addr(__task_update_BMS), W1
	MOV.B	W0, [W1]
;schedule_task.c,228 :: 		_task_update_system = task_add(_F_update_system_status, 75);
	MOV	#75, W11
	MOV	#0, W12
	MOV	#lo_addr(__F_update_system_status), W10
	CALL	_task_add
	MOV	#lo_addr(__task_update_system), W1
	MOV.B	W0, [W1]
;schedule_task.c,229 :: 		task_scheduler_start();
	CALL	_task_scheduler_start
;schedule_task.c,230 :: 		DebugUART_Send_Text("Task Scheduler initialization complete!\n");
	MOV	#lo_addr(?lstr_7_schedule_task), W10
	CALL	_DebugUART_Send_Text
;schedule_task.c,232 :: 		}
L_end__F_schedule_init:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of __F_schedule_init
