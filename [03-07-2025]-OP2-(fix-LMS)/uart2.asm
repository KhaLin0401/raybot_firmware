
__UART2_Init:

;uart2.c,12 :: 		void _UART2_Init(void) {
;uart2.c,14 :: 		_uart2._rx_head = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(__uart2+2700), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,15 :: 		_uart2._rx_tail = 0;
	MOV	#lo_addr(__uart2+2701), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,16 :: 		_uart2._tx_head = 0;
	MOV	#lo_addr(__uart2+4502), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,17 :: 		_uart2._tx_tail = 0;
	MOV	#lo_addr(__uart2+4503), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,18 :: 		_uart2._temp_index = 0;
	MOV	#lo_addr(__uart2+4684), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,19 :: 		memset(_uart2._temp_rx_buffer, 0, _UART2_CMD_BUFFER_SIZE);
	MOV	#180, W12
	CLR	W11
	MOV	#lo_addr(__uart2+4504), W10
	CALL	_memset
;uart2.c,20 :: 		for(i = 0; i < _UART2_RX_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART2_Init0:
; i start address is: 8 (W4)
	CP	W4, #15
	BRA LT	L___UART2_Init47
	GOTO	L__UART2_Init1
L___UART2_Init47:
;uart2.c,21 :: 		_uart2._rx_stack[i][0] = '\0';
	MOV	#180, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart2), W0
	ADD	W0, W2, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,20 :: 		for(i = 0; i < _UART2_RX_STACK_SIZE; i++) {
	INC	W4
;uart2.c,22 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART2_Init0
L__UART2_Init1:
;uart2.c,23 :: 		for(i = 0; i < _UART2_TX_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART2_Init3:
; i start address is: 8 (W4)
	CP	W4, #10
	BRA LT	L___UART2_Init48
	GOTO	L__UART2_Init4
L___UART2_Init48:
;uart2.c,24 :: 		_uart2._tx_stack[i][0] = '\0';
	MOV	#180, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart2+2702), W0
	ADD	W0, W2, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,23 :: 		for(i = 0; i < _UART2_TX_STACK_SIZE; i++) {
	INC	W4
;uart2.c,25 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART2_Init3
L__UART2_Init4:
;uart2.c,26 :: 		IEC1bits.U2RXIE = 1;
	BSET	IEC1bits, #14
;uart2.c,27 :: 		IFS1bits.U2RXIF = 0;
	BCLR	IFS1bits, #14
;uart2.c,28 :: 		}
L_end__UART2_Init:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of __UART2_Init

__UART2_SendBlocking:

;uart2.c,32 :: 		int _UART2_SendBlocking(const char *text) {
;uart2.c,34 :: 		int result = 1;
; result start address is: 2 (W1)
	MOV	#1, W1
; result end address is: 2 (W1)
;uart2.c,35 :: 		while(*text) {
L__UART2_SendBlocking6:
; result start address is: 2 (W1)
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W10], W0
	CP0.B	W0
	BRA NZ	L___UART2_SendBlocking50
	GOTO	L___UART2_SendBlocking37
L___UART2_SendBlocking50:
;uart2.c,36 :: 		timeout = 1000;
; timeout start address is: 0 (W0)
	MOV	#1000, W0
; timeout end address is: 0 (W0)
; result end address is: 2 (W1)
;uart2.c,37 :: 		while(U2STAbits.UTXBF && timeout > 0) {
L__UART2_SendBlocking8:
; timeout start address is: 0 (W0)
; result start address is: 2 (W1)
	BTSS	U2STAbits, #9
	GOTO	L___UART2_SendBlocking36
	CP	W0, #0
	BRA GT	L___UART2_SendBlocking51
	GOTO	L___UART2_SendBlocking35
L___UART2_SendBlocking51:
L___UART2_SendBlocking34:
;uart2.c,38 :: 		timeout--;
	DEC	W0
;uart2.c,39 :: 		}
	GOTO	L__UART2_SendBlocking8
;uart2.c,37 :: 		while(U2STAbits.UTXBF && timeout > 0) {
L___UART2_SendBlocking36:
L___UART2_SendBlocking35:
;uart2.c,40 :: 		if(timeout == 0) {
	CP	W0, #0
	BRA Z	L___UART2_SendBlocking52
	GOTO	L__UART2_SendBlocking12
L___UART2_SendBlocking52:
; timeout end address is: 0 (W0)
; result end address is: 2 (W1)
;uart2.c,41 :: 		DebugUART_Send_Text("UART2 TX: Timeout waiting for TX buffer\n");
	PUSH	W10
	MOV	#lo_addr(?lstr_1_uart2), W10
	CALL	_DebugUART_Send_Text
	POP	W10
;uart2.c,42 :: 		result = 0;
; result start address is: 2 (W1)
	CLR	W1
;uart2.c,43 :: 		break;
	GOTO	L__UART2_SendBlocking7
;uart2.c,44 :: 		}
L__UART2_SendBlocking12:
;uart2.c,45 :: 		UART2_Write(*text++);
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	PUSH	W10
	ZE	[W10], W10
	CALL	_UART2_Write
	POP	W10
	ADD	W10, #1, W0
	MOV	W0, W10
;uart2.c,46 :: 		}
; result end address is: 2 (W1)
	GOTO	L__UART2_SendBlocking6
L___UART2_SendBlocking37:
;uart2.c,35 :: 		while(*text) {
;uart2.c,46 :: 		}
L__UART2_SendBlocking7:
;uart2.c,47 :: 		return result;
; result start address is: 2 (W1)
	MOV	W1, W0
; result end address is: 2 (W1)
;uart2.c,48 :: 		}
L_end__UART2_SendBlocking:
	RETURN
; end of __UART2_SendBlocking

__UART2_SendPush:

;uart2.c,53 :: 		void _UART2_SendPush(const char *text) {
;uart2.c,55 :: 		next_head = (_uart2._tx_head + 1) % _UART2_TX_STACK_SIZE;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(__uart2+4502), W0
	ZE	[W0], W0
	INC	W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
; next_head start address is: 8 (W4)
	MOV.B	W1, W4
;uart2.c,56 :: 		if(next_head == _uart2._tx_tail) {
	MOV	#lo_addr(__uart2+4503), W0
	CP.B	W1, [W0]
	BRA Z	L___UART2_SendPush54
	GOTO	L__UART2_SendPush13
L___UART2_SendPush54:
; next_head end address is: 8 (W4)
;uart2.c,57 :: 		DebugUART_Send_Text("UART2 TX Stack Full. Dropping command.\n");
	MOV	#lo_addr(?lstr_2_uart2), W10
	CALL	_DebugUART_Send_Text
;uart2.c,58 :: 		return;
	GOTO	L_end__UART2_SendPush
;uart2.c,59 :: 		}
L__UART2_SendPush13:
;uart2.c,60 :: 		strncpy(_uart2._tx_stack[_uart2._tx_head], text, _UART2_CMD_BUFFER_SIZE - 1);
; next_head start address is: 8 (W4)
	MOV	#180, W1
	MOV	#lo_addr(__uart2+4502), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2+2702), W0
	ADD	W0, W2, W0
	MOV	#179, W12
	MOV	W10, W11
	MOV	W0, W10
	CALL	_strncpy
;uart2.c,61 :: 		_uart2._tx_stack[_uart2._tx_head][_UART2_CMD_BUFFER_SIZE - 1] = '\0';
	MOV	#180, W1
	MOV	#lo_addr(__uart2+4502), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2+2702), W0
	ADD	W0, W2, W1
	MOV	#179, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,62 :: 		_uart2._tx_head = next_head;
	MOV	#lo_addr(__uart2+4502), W0
	MOV.B	W4, [W0]
; next_head end address is: 8 (W4)
;uart2.c,63 :: 		}
L_end__UART2_SendPush:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of __UART2_SendPush

__UART2_SendProcess:
	LNK	#2

;uart2.c,68 :: 		uint8_t _UART2_SendProcess(void) {
;uart2.c,69 :: 		uint8_t ret = 0;char *cmd;
	PUSH	W10
	MOV	#0, W0
	MOV.B	W0, [W14+0]
;uart2.c,70 :: 		if(_uart2._tx_tail != _uart2._tx_head) {
	MOV	#lo_addr(__uart2+4503), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__uart2+4502), W0
	CP.B	W1, [W0]
	BRA NZ	L___UART2_SendProcess56
	GOTO	L__UART2_SendProcess14
L___UART2_SendProcess56:
;uart2.c,72 :: 		cmd = _uart2._tx_stack[_uart2._tx_tail];
	MOV	#180, W1
	MOV	#lo_addr(__uart2+4503), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2+2702), W0
	ADD	W0, W2, W0
;uart2.c,73 :: 		if(_UART2_SendBlocking(cmd)) {
	MOV	W0, W10
	CALL	__UART2_SendBlocking
	CP0	W0
	BRA NZ	L___UART2_SendProcess57
	GOTO	L__UART2_SendProcess15
L___UART2_SendProcess57:
;uart2.c,74 :: 		_uart2._tx_stack[_uart2._tx_tail][0] = '\0';
	MOV	#180, W1
	MOV	#lo_addr(__uart2+4503), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2+2702), W0
	ADD	W0, W2, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,75 :: 		_uart2._tx_tail = (_uart2._tx_tail + 1) % _UART2_TX_STACK_SIZE;
	MOV	#lo_addr(__uart2+4503), W0
	ZE	[W0], W0
	INC	W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(__uart2+4503), W0
	MOV.B	W1, [W0]
;uart2.c,76 :: 		ret = 1;
	MOV.B	#1, W0
	MOV.B	W0, [W14+0]
;uart2.c,77 :: 		} else {
	GOTO	L__UART2_SendProcess16
L__UART2_SendProcess15:
;uart2.c,78 :: 		DebugUART_Send_Text("UART2 TX: Failed to send command.\n");
	MOV	#lo_addr(?lstr_3_uart2), W10
	CALL	_DebugUART_Send_Text
;uart2.c,79 :: 		}
L__UART2_SendProcess16:
;uart2.c,80 :: 		}
L__UART2_SendProcess14:
;uart2.c,81 :: 		return ret;
	MOV.B	[W14+0], W0
;uart2.c,82 :: 		}
;uart2.c,81 :: 		return ret;
;uart2.c,82 :: 		}
L_end__UART2_SendProcess:
	POP	W10
	ULNK
	RETURN
; end of __UART2_SendProcess

__UART2_Rx_GetCommand:

;uart2.c,87 :: 		uint8_t _UART2_Rx_GetCommand(char *out_cmd) {
;uart2.c,88 :: 		uint8_t ret = 0;
	PUSH	W11
	PUSH	W12
; ret start address is: 4 (W2)
	CLR	W2
;uart2.c,89 :: 		if(_uart2._rx_tail != _uart2._rx_head) {
	MOV	#lo_addr(__uart2+2701), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__uart2+2700), W0
	CP.B	W1, [W0]
	BRA NZ	L___UART2_Rx_GetCommand59
	GOTO	L___UART2_Rx_GetCommand38
L___UART2_Rx_GetCommand59:
; ret end address is: 4 (W2)
;uart2.c,90 :: 		strncpy(out_cmd, _uart2._rx_stack[_uart2._rx_tail], _UART2_CMD_BUFFER_SIZE - 1);
	MOV	#180, W1
	MOV	#lo_addr(__uart2+2701), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2), W0
	ADD	W0, W2, W0
	MOV	#179, W12
	MOV	W0, W11
	CALL	_strncpy
;uart2.c,91 :: 		out_cmd[_UART2_CMD_BUFFER_SIZE - 1] = '\0';
	MOV	#179, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,92 :: 		_uart2._rx_stack[_uart2._rx_tail][0] = '\0';
	MOV	#180, W1
	MOV	#lo_addr(__uart2+2701), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2), W0
	ADD	W0, W2, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,93 :: 		_uart2._rx_tail = (_uart2._rx_tail + 1) % _UART2_RX_STACK_SIZE;
	MOV	#lo_addr(__uart2+2701), W0
	ZE	[W0], W0
	INC	W0
	MOV	#15, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(__uart2+2701), W0
	MOV.B	W1, [W0]
;uart2.c,94 :: 		ret = 1;
; ret start address is: 2 (W1)
	MOV.B	#1, W1
; ret end address is: 2 (W1)
;uart2.c,95 :: 		}
	GOTO	L__UART2_Rx_GetCommand17
L___UART2_Rx_GetCommand38:
;uart2.c,89 :: 		if(_uart2._rx_tail != _uart2._rx_head) {
	MOV.B	W2, W1
;uart2.c,95 :: 		}
L__UART2_Rx_GetCommand17:
;uart2.c,96 :: 		return ret;
; ret start address is: 2 (W1)
	MOV.B	W1, W0
; ret end address is: 2 (W1)
;uart2.c,97 :: 		}
;uart2.c,96 :: 		return ret;
;uart2.c,97 :: 		}
L_end__UART2_Rx_GetCommand:
	POP	W12
	POP	W11
	RETURN
; end of __UART2_Rx_GetCommand

__UART2_Rx_Receive_ISR:

;uart2.c,106 :: 		void _UART2_Rx_Receive_ISR() {
;uart2.c,109 :: 		c = UART2_Read();
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CALL	_UART2_Read
; c start address is: 4 (W2)
	MOV.B	W0, W2
;uart2.c,111 :: 		if(_uart2._temp_index == 0) {
	MOV	#lo_addr(__uart2+4684), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L___UART2_Rx_Receive_ISR61
	GOTO	L__UART2_Rx_Receive_ISR18
L___UART2_Rx_Receive_ISR61:
;uart2.c,112 :: 		if(c != '>' && c != 'G' && c != 'S') {
	MOV.B	#62, W0
	CP.B	W2, W0
	BRA NZ	L___UART2_Rx_Receive_ISR62
	GOTO	L___UART2_Rx_Receive_ISR43
L___UART2_Rx_Receive_ISR62:
	MOV.B	#71, W0
	CP.B	W2, W0
	BRA NZ	L___UART2_Rx_Receive_ISR63
	GOTO	L___UART2_Rx_Receive_ISR42
L___UART2_Rx_Receive_ISR63:
	MOV.B	#83, W0
	CP.B	W2, W0
	BRA NZ	L___UART2_Rx_Receive_ISR64
	GOTO	L___UART2_Rx_Receive_ISR41
L___UART2_Rx_Receive_ISR64:
; c end address is: 4 (W2)
L___UART2_Rx_Receive_ISR40:
;uart2.c,113 :: 		IFS1bits.U2RXIF = 0;
	BCLR	IFS1bits, #14
;uart2.c,114 :: 		return;
	GOTO	L_end__UART2_Rx_Receive_ISR
;uart2.c,112 :: 		if(c != '>' && c != 'G' && c != 'S') {
L___UART2_Rx_Receive_ISR43:
; c start address is: 4 (W2)
L___UART2_Rx_Receive_ISR42:
L___UART2_Rx_Receive_ISR41:
;uart2.c,116 :: 		}
L__UART2_Rx_Receive_ISR18:
;uart2.c,118 :: 		if(c != '\n' && c != '\r') {
	CP.B	W2, #10
	BRA NZ	L___UART2_Rx_Receive_ISR65
	GOTO	L___UART2_Rx_Receive_ISR45
L___UART2_Rx_Receive_ISR65:
	CP.B	W2, #13
	BRA NZ	L___UART2_Rx_Receive_ISR66
	GOTO	L___UART2_Rx_Receive_ISR44
L___UART2_Rx_Receive_ISR66:
L___UART2_Rx_Receive_ISR39:
;uart2.c,119 :: 		if(_uart2._temp_index < (_UART2_CMD_BUFFER_SIZE - 1)) {
	MOV	#lo_addr(__uart2+4684), W0
	ZE	[W0], W1
	MOV	#179, W0
	CP	W1, W0
	BRA LT	L___UART2_Rx_Receive_ISR67
	GOTO	L__UART2_Rx_Receive_ISR25
L___UART2_Rx_Receive_ISR67:
;uart2.c,120 :: 		_uart2._temp_rx_buffer[_uart2._temp_index] = c;
	MOV	#lo_addr(__uart2+4684), W0
	ZE	[W0], W1
	MOV	#lo_addr(__uart2+4504), W0
	ADD	W0, W1, W0
	MOV.B	W2, [W0]
; c end address is: 4 (W2)
;uart2.c,121 :: 		_uart2._temp_index++;
	MOV	#lo_addr(__uart2+4684), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(__uart2+4684), W0
	MOV.B	W1, [W0]
;uart2.c,122 :: 		} else {
	GOTO	L__UART2_Rx_Receive_ISR26
L__UART2_Rx_Receive_ISR25:
;uart2.c,123 :: 		DebugUART_Send_Text("UART2 RX: Command too long. Discarding.\n");
	MOV	#lo_addr(?lstr_4_uart2), W10
	CALL	_DebugUART_Send_Text
;uart2.c,124 :: 		_uart2._temp_index = 0;
	MOV	#lo_addr(__uart2+4684), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,125 :: 		}
L__UART2_Rx_Receive_ISR26:
;uart2.c,126 :: 		} else {
	GOTO	L__UART2_Rx_Receive_ISR27
;uart2.c,118 :: 		if(c != '\n' && c != '\r') {
L___UART2_Rx_Receive_ISR45:
L___UART2_Rx_Receive_ISR44:
;uart2.c,127 :: 		_uart2._temp_rx_buffer[_uart2._temp_index] = '\0';
	MOV	#lo_addr(__uart2+4684), W0
	ZE	[W0], W1
	MOV	#lo_addr(__uart2+4504), W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,129 :: 		(strncmp(_uart2._temp_rx_buffer, "GET", 3) == 0) ||
	MOV	#lo_addr(__uart2+4504), W0
	MOV.B	[W0], W1
	MOV.B	#62, W0
	CP.B	W1, W0
	BRA NZ	L___UART2_Rx_Receive_ISR68
	GOTO	L__UART2_Rx_Receive_ISR29
L___UART2_Rx_Receive_ISR68:
	MOV.B	#3, W12
	MOV	#lo_addr(?lstr5_uart2), W11
	MOV	#lo_addr(__uart2+4504), W10
	CALL	_strncmp
	CP	W0, #0
	BRA NZ	L___UART2_Rx_Receive_ISR69
	GOTO	L__UART2_Rx_Receive_ISR29
L___UART2_Rx_Receive_ISR69:
;uart2.c,130 :: 		(strncmp(_uart2._temp_rx_buffer, "SET", 3) == 0))) {
	MOV.B	#3, W12
	MOV	#lo_addr(?lstr6_uart2), W11
	MOV	#lo_addr(__uart2+4504), W10
	CALL	_strncmp
	CP	W0, #0
	BRA NZ	L___UART2_Rx_Receive_ISR70
	GOTO	L__UART2_Rx_Receive_ISR29
L___UART2_Rx_Receive_ISR70:
	CLR	W1
	GOTO	L__UART2_Rx_Receive_ISR28
L__UART2_Rx_Receive_ISR29:
	MOV.B	#1, W0
	MOV.B	W0, W1
L__UART2_Rx_Receive_ISR28:
	CP0.B	W1
	BRA Z	L___UART2_Rx_Receive_ISR71
	GOTO	L__UART2_Rx_Receive_ISR30
L___UART2_Rx_Receive_ISR71:
;uart2.c,131 :: 		DebugUART_Send_Text("UART2 RX: Invalid command. Discarding.\n");
	MOV	#lo_addr(?lstr_7_uart2), W10
	CALL	_DebugUART_Send_Text
;uart2.c,132 :: 		} else {
	GOTO	L__UART2_Rx_Receive_ISR31
L__UART2_Rx_Receive_ISR30:
;uart2.c,133 :: 		next_head = (_uart2._rx_head + 1) % _UART2_RX_STACK_SIZE;
	MOV	#lo_addr(__uart2+2700), W0
	ZE	[W0], W0
	INC	W0
	MOV	#15, W2
	REPEAT	#17
	DIV.S	W0, W2
; next_head start address is: 8 (W4)
	MOV.B	W1, W4
;uart2.c,134 :: 		if(next_head == _uart2._rx_tail) {
	MOV	#lo_addr(__uart2+2701), W0
	CP.B	W1, [W0]
	BRA Z	L___UART2_Rx_Receive_ISR72
	GOTO	L__UART2_Rx_Receive_ISR32
L___UART2_Rx_Receive_ISR72:
; next_head end address is: 8 (W4)
;uart2.c,135 :: 		DebugUART_Send_Text("UART2 RX Stack Full. Dropping command.\n");
	MOV	#lo_addr(?lstr_8_uart2), W10
	CALL	_DebugUART_Send_Text
;uart2.c,136 :: 		} else {
	GOTO	L__UART2_Rx_Receive_ISR33
L__UART2_Rx_Receive_ISR32:
;uart2.c,137 :: 		strncpy(_uart2._rx_stack[_uart2._rx_head], _uart2._temp_rx_buffer, _UART2_CMD_BUFFER_SIZE - 1);
; next_head start address is: 8 (W4)
	MOV	#180, W1
	MOV	#lo_addr(__uart2+2700), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2), W0
	ADD	W0, W2, W0
	MOV	#179, W12
	MOV	#lo_addr(__uart2+4504), W11
	MOV	W0, W10
	CALL	_strncpy
;uart2.c,138 :: 		_uart2._rx_stack[_uart2._rx_head][_UART2_CMD_BUFFER_SIZE - 1] = '\0';
	MOV	#180, W1
	MOV	#lo_addr(__uart2+2700), W0
	ZE	[W0], W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(__uart2), W0
	ADD	W0, W2, W1
	MOV	#179, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,139 :: 		_uart2._rx_head = next_head;
	MOV	#lo_addr(__uart2+2700), W0
	MOV.B	W4, [W0]
; next_head end address is: 8 (W4)
;uart2.c,140 :: 		}
L__UART2_Rx_Receive_ISR33:
;uart2.c,141 :: 		}
L__UART2_Rx_Receive_ISR31:
;uart2.c,142 :: 		_uart2._temp_index = 0;
	MOV	#lo_addr(__uart2+4684), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart2.c,143 :: 		}
L__UART2_Rx_Receive_ISR27:
;uart2.c,144 :: 		IFS1bits.U2RXIF = 0;
	BCLR	IFS1bits, #14
;uart2.c,145 :: 		}
L_end__UART2_Rx_Receive_ISR:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of __UART2_Rx_Receive_ISR

_UART2Interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;uart2.c,146 :: 		void UART2Interrupt() iv IVT_ADDR_U2RXINTERRUPT ics ICS_AUTO {
;uart2.c,147 :: 		_UART2_Rx_Receive_ISR();
	CALL	__UART2_Rx_Receive_ISR
;uart2.c,148 :: 		}
L_end_UART2Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _UART2Interrupt
