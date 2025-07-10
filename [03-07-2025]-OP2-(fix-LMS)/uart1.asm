
__UART1_Init:

;uart1.c,12 :: 		void _UART1_Init(void) {
;uart1.c,17 :: 		_uart1._rx_head = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(__uart1+65), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,18 :: 		_uart1._rx_tail = 0;
	MOV	#lo_addr(__uart1+66), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,19 :: 		_uart1._tx_head = 0;
	MOV	#lo_addr(__uart1+106), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,20 :: 		_uart1._tx_tail = 0;
	MOV	#lo_addr(__uart1+107), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,21 :: 		_uart1._temp_index = 0;
	MOV	#lo_addr(__uart1+121), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,22 :: 		_uart1._frame_count = 0;
	MOV	#lo_addr(__uart1+122), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,23 :: 		_uart1._multi_frame_count = 0;
	MOV	#lo_addr(__uart1+279), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,24 :: 		_uart1._is_receiving = 0;
	MOV	#lo_addr(__uart1+280), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,25 :: 		_uart1._timeout_counter = 0;
	MOV	#lo_addr(__uart1+281), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,28 :: 		memset(_uart1._temp_rx_buffer, 0, _UART1_BMS_BUFFER_SIZE);
	MOV	#13, W12
	CLR	W11
	MOV	#lo_addr(__uart1+108), W10
	CALL	_memset
;uart1.c,30 :: 		for(i = 0; i < _UART1_RX_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_Init0:
; i start address is: 8 (W4)
	CP	W4, #5
	BRA LT	L___UART1_Init91
	GOTO	L__UART1_Init1
L___UART1_Init91:
;uart1.c,31 :: 		memset(_uart1._rx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
	MOV	#13, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart1), W0
	ADD	W0, W2, W0
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
;uart1.c,30 :: 		for(i = 0; i < _UART1_RX_STACK_SIZE; i++) {
	INC	W4
;uart1.c,32 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART1_Init0
L__UART1_Init1:
;uart1.c,34 :: 		for(i = 0; i < _UART1_TX_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_Init3:
; i start address is: 8 (W4)
	CP	W4, #3
	BRA LT	L___UART1_Init92
	GOTO	L__UART1_Init4
L___UART1_Init92:
;uart1.c,35 :: 		memset(_uart1._tx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
	MOV	#13, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart1+67), W0
	ADD	W0, W2, W0
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
;uart1.c,34 :: 		for(i = 0; i < _UART1_TX_STACK_SIZE; i++) {
	INC	W4
;uart1.c,36 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART1_Init3
L__UART1_Init4:
;uart1.c,38 :: 		for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_Init6:
; i start address is: 8 (W4)
	CP	W4, #12
	BRA LT	L___UART1_Init93
	GOTO	L__UART1_Init7
L___UART1_Init93:
;uart1.c,39 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
; j start address is: 10 (W5)
	CLR	W5
; j end address is: 10 (W5)
; i end address is: 8 (W4)
L__UART1_Init9:
; j start address is: 10 (W5)
; i start address is: 8 (W4)
	CP	W5, #13
	BRA LT	L___UART1_Init94
	GOTO	L__UART1_Init10
L___UART1_Init94:
;uart1.c,40 :: 		_uart1._multi_frame_buffer[i][j] = 0;
	MOV	#13, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart1+123), W0
	ADD	W0, W2, W0
	ADD	W0, W5, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,39 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
	INC	W5
;uart1.c,41 :: 		}
; j end address is: 10 (W5)
	GOTO	L__UART1_Init9
L__UART1_Init10:
;uart1.c,38 :: 		for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
	INC	W4
;uart1.c,42 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART1_Init6
L__UART1_Init7:
;uart1.c,45 :: 		IEC0bits.U1RXIE = 1;
	BSET	IEC0bits, #11
;uart1.c,46 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;uart1.c,47 :: 		}
L_end__UART1_Init:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of __UART1_Init

__UART1_SendBlocking:

;uart1.c,51 :: 		int _UART1_SendBlocking(const uint8_t *frame) {
;uart1.c,56 :: 		result = 1;
; result start address is: 4 (W2)
	MOV	#1, W2
;uart1.c,57 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
; i start address is: 0 (W0)
	CLR	W0
; i end address is: 0 (W0)
; result end address is: 4 (W2)
	MOV	W0, W3
L__UART1_SendBlocking12:
; i start address is: 6 (W3)
; result start address is: 4 (W2)
	CP	W3, #13
	BRA LT	L___UART1_SendBlocking96
	GOTO	L___UART1_SendBlocking87
L___UART1_SendBlocking96:
;uart1.c,58 :: 		timeout = 1000;
; timeout start address is: 0 (W0)
	MOV	#1000, W0
; result end address is: 4 (W2)
; timeout end address is: 0 (W0)
; i end address is: 6 (W3)
;uart1.c,59 :: 		while(U1STAbits.UTXBF && timeout > 0) {
L__UART1_SendBlocking15:
; timeout start address is: 0 (W0)
; result start address is: 4 (W2)
; i start address is: 6 (W3)
	BTSS	U1STAbits, #9
	GOTO	L___UART1_SendBlocking86
	CP	W0, #0
	BRA GT	L___UART1_SendBlocking97
	GOTO	L___UART1_SendBlocking85
L___UART1_SendBlocking97:
L___UART1_SendBlocking84:
;uart1.c,60 :: 		timeout--;
	DEC	W0
;uart1.c,61 :: 		}
	GOTO	L__UART1_SendBlocking15
;uart1.c,59 :: 		while(U1STAbits.UTXBF && timeout > 0) {
L___UART1_SendBlocking86:
L___UART1_SendBlocking85:
;uart1.c,62 :: 		if(timeout == 0) {
	CP	W0, #0
	BRA Z	L___UART1_SendBlocking98
	GOTO	L__UART1_SendBlocking19
L___UART1_SendBlocking98:
; result end address is: 4 (W2)
; timeout end address is: 0 (W0)
; i end address is: 6 (W3)
;uart1.c,63 :: 		DebugUART_Send_Text("UART1 TX: Timeout waiting for TX buffer\n");
	PUSH	W10
	MOV	#lo_addr(?lstr_1_uart1), W10
	CALL	_DebugUART_Send_Text
	POP	W10
;uart1.c,64 :: 		result = 0;
; result start address is: 2 (W1)
	CLR	W1
;uart1.c,65 :: 		break;
; result end address is: 2 (W1)
	GOTO	L__UART1_SendBlocking13
;uart1.c,66 :: 		}
L__UART1_SendBlocking19:
;uart1.c,67 :: 		UART1_Write(frame[i]);
; i start address is: 6 (W3)
; result start address is: 4 (W2)
	ADD	W10, W3, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	PUSH	W10
	ZE	[W1], W10
	CALL	_UART1_Write
	POP	W10
;uart1.c,57 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
	INC	W3
;uart1.c,68 :: 		}
; result end address is: 4 (W2)
; i end address is: 6 (W3)
	GOTO	L__UART1_SendBlocking12
L___UART1_SendBlocking87:
;uart1.c,57 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
	MOV	W2, W1
;uart1.c,68 :: 		}
L__UART1_SendBlocking13:
;uart1.c,69 :: 		return result;
; result start address is: 2 (W1)
	MOV	W1, W0
; result end address is: 2 (W1)
;uart1.c,70 :: 		}
L_end__UART1_SendBlocking:
	RETURN
; end of __UART1_SendBlocking

__UART1_SendPush:

;uart1.c,75 :: 		void _UART1_SendPush(const uint8_t *frame) {
;uart1.c,79 :: 		next_head = (_uart1._tx_head + 1) % _UART1_TX_STACK_SIZE;
	PUSH	W10
	MOV	#lo_addr(__uart1+106), W0
	ZE	[W0], W0
	INC	W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
; next_head start address is: 8 (W4)
	MOV.B	W1, W4
;uart1.c,80 :: 		if(next_head == _uart1._tx_tail) {
	MOV	#lo_addr(__uart1+107), W0
	CP.B	W1, [W0]
	BRA Z	L___UART1_SendPush100
	GOTO	L__UART1_SendPush20
L___UART1_SendPush100:
; next_head end address is: 8 (W4)
;uart1.c,81 :: 		DebugUART_Send_Text("UART1 TX Stack Full. Dropping frame.\n");
	MOV	#lo_addr(?lstr_2_uart1), W10
	CALL	_DebugUART_Send_Text
;uart1.c,82 :: 		return;
	GOTO	L_end__UART1_SendPush
;uart1.c,83 :: 		}
L__UART1_SendPush20:
;uart1.c,86 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
; i start address is: 10 (W5)
; next_head start address is: 8 (W4)
	CLR	W5
; next_head end address is: 8 (W4)
; i end address is: 10 (W5)
L__UART1_SendPush21:
; i start address is: 10 (W5)
; next_head start address is: 8 (W4)
	CP	W5, #13
	BRA LT	L___UART1_SendPush101
	GOTO	L__UART1_SendPush22
L___UART1_SendPush101:
;uart1.c,87 :: 		_uart1._tx_frame_stack[_uart1._tx_head][i] = frame[i];
	MOV	#lo_addr(__uart1+106), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__uart1+67), W0
	ADD	W0, W2, W0
	ADD	W0, W5, W2
	ADD	W10, W5, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W1], W0
	MOV.B	W0, [W2]
;uart1.c,86 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
	INC	W5
;uart1.c,88 :: 		}
; i end address is: 10 (W5)
	GOTO	L__UART1_SendPush21
L__UART1_SendPush22:
;uart1.c,89 :: 		_uart1._tx_head = next_head;
	MOV	#lo_addr(__uart1+106), W0
	MOV.B	W4, [W0]
; next_head end address is: 8 (W4)
;uart1.c,90 :: 		}
L_end__UART1_SendPush:
	POP	W10
	RETURN
; end of __UART1_SendPush

__UART1_SendProcess:
	LNK	#2

;uart1.c,95 :: 		uint8_t _UART1_SendProcess(void) {
;uart1.c,96 :: 		uint8_t ret = 0;
	PUSH	W10
	MOV	#0, W0
	MOV.B	W0, [W14+0]
;uart1.c,100 :: 		if(_uart1._tx_tail != _uart1._tx_head) {
	MOV	#lo_addr(__uart1+107), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__uart1+106), W0
	CP.B	W1, [W0]
	BRA NZ	L___UART1_SendProcess103
	GOTO	L__UART1_SendProcess24
L___UART1_SendProcess103:
;uart1.c,101 :: 		frame = _uart1._tx_frame_stack[_uart1._tx_tail];
	MOV	#lo_addr(__uart1+107), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__uart1+67), W0
	ADD	W0, W2, W0
;uart1.c,102 :: 		if(_UART1_SendBlocking(frame)) {
	MOV	W0, W10
	CALL	__UART1_SendBlocking
	CP0	W0
	BRA NZ	L___UART1_SendProcess104
	GOTO	L__UART1_SendProcess25
L___UART1_SendProcess104:
;uart1.c,104 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_SendProcess26:
; i start address is: 8 (W4)
	CP	W4, #13
	BRA LT	L___UART1_SendProcess105
	GOTO	L__UART1_SendProcess27
L___UART1_SendProcess105:
;uart1.c,105 :: 		_uart1._tx_frame_stack[_uart1._tx_tail][i] = 0;
	MOV	#lo_addr(__uart1+107), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__uart1+67), W0
	ADD	W0, W2, W0
	ADD	W0, W4, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,104 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
; i start address is: 0 (W0)
	ADD	W4, #1, W0
; i end address is: 8 (W4)
;uart1.c,106 :: 		}
	MOV	W0, W4
; i end address is: 0 (W0)
	GOTO	L__UART1_SendProcess26
L__UART1_SendProcess27:
;uart1.c,107 :: 		_uart1._tx_tail = (_uart1._tx_tail + 1) % _UART1_TX_STACK_SIZE;
	MOV	#lo_addr(__uart1+107), W0
	ZE	[W0], W0
	INC	W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(__uart1+107), W0
	MOV.B	W1, [W0]
;uart1.c,108 :: 		ret = 1;
	MOV.B	#1, W0
	MOV.B	W0, [W14+0]
;uart1.c,109 :: 		} else {
	GOTO	L__UART1_SendProcess29
L__UART1_SendProcess25:
;uart1.c,110 :: 		DebugUART_Send_Text("UART1 TX: Failed to send frame.\n");
	MOV	#lo_addr(?lstr_3_uart1), W10
	CALL	_DebugUART_Send_Text
;uart1.c,111 :: 		}
L__UART1_SendProcess29:
;uart1.c,112 :: 		}
L__UART1_SendProcess24:
;uart1.c,113 :: 		return ret;
	MOV.B	[W14+0], W0
;uart1.c,114 :: 		}
;uart1.c,113 :: 		return ret;
;uart1.c,114 :: 		}
L_end__UART1_SendProcess:
	POP	W10
	ULNK
	RETURN
; end of __UART1_SendProcess

__UART1_Rx_GetFrame:

;uart1.c,119 :: 		uint8_t _UART1_Rx_GetFrame(uint8_t *out_frame) {
;uart1.c,120 :: 		uint8_t ret = 0;
; ret start address is: 4 (W2)
	CLR	W2
;uart1.c,123 :: 		if(_uart1._rx_tail != _uart1._rx_head) {
	MOV	#lo_addr(__uart1+66), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__uart1+65), W0
	CP.B	W1, [W0]
	BRA NZ	L___UART1_Rx_GetFrame107
	GOTO	L___UART1_Rx_GetFrame88
L___UART1_Rx_GetFrame107:
; ret end address is: 4 (W2)
;uart1.c,125 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
; i start address is: 10 (W5)
	CLR	W5
; i end address is: 10 (W5)
L__UART1_Rx_GetFrame31:
; i start address is: 10 (W5)
	CP	W5, #13
	BRA LT	L___UART1_Rx_GetFrame108
	GOTO	L__UART1_Rx_GetFrame32
L___UART1_Rx_GetFrame108:
;uart1.c,126 :: 		out_frame[i] = _uart1._rx_frame_stack[_uart1._rx_tail][i];
	ADD	W10, W5, W4
	MOV	#lo_addr(__uart1+66), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__uart1), W0
	ADD	W0, W2, W0
	ADD	W0, W5, W0
	MOV.B	[W0], [W4]
;uart1.c,125 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
	INC	W5
;uart1.c,127 :: 		}
; i end address is: 10 (W5)
	GOTO	L__UART1_Rx_GetFrame31
L__UART1_Rx_GetFrame32:
;uart1.c,130 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_Rx_GetFrame34:
; i start address is: 8 (W4)
	CP	W4, #13
	BRA LT	L___UART1_Rx_GetFrame109
	GOTO	L__UART1_Rx_GetFrame35
L___UART1_Rx_GetFrame109:
;uart1.c,131 :: 		_uart1._rx_frame_stack[_uart1._rx_tail][i] = 0;
	MOV	#lo_addr(__uart1+66), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__uart1), W0
	ADD	W0, W2, W0
	ADD	W0, W4, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,130 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
	INC	W4
;uart1.c,132 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART1_Rx_GetFrame34
L__UART1_Rx_GetFrame35:
;uart1.c,133 :: 		_uart1._rx_tail = (_uart1._rx_tail + 1) % _UART1_RX_STACK_SIZE;
	MOV	#lo_addr(__uart1+66), W0
	ZE	[W0], W0
	INC	W0
	MOV	#5, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(__uart1+66), W0
	MOV.B	W1, [W0]
;uart1.c,134 :: 		ret = 1;
; ret start address is: 2 (W1)
	MOV.B	#1, W1
; ret end address is: 2 (W1)
;uart1.c,135 :: 		}
	GOTO	L__UART1_Rx_GetFrame30
L___UART1_Rx_GetFrame88:
;uart1.c,123 :: 		if(_uart1._rx_tail != _uart1._rx_head) {
	MOV.B	W2, W1
;uart1.c,135 :: 		}
L__UART1_Rx_GetFrame30:
;uart1.c,136 :: 		return ret;
; ret start address is: 2 (W1)
	MOV.B	W1, W0
; ret end address is: 2 (W1)
;uart1.c,137 :: 		}
L_end__UART1_Rx_GetFrame:
	RETURN
; end of __UART1_Rx_GetFrame

__UART1_Rx_GetMultiFrames:

;uart1.c,140 :: 		uint8_t _UART1_Rx_GetMultiFrames(uint8_t *out_frames, uint8_t max_frames) {
;uart1.c,145 :: 		frame_count = 0;
; frame_count start address is: 2 (W1)
	CLR	W1
;uart1.c,146 :: 		if(_uart1._multi_frame_count > 0) {
	MOV	#lo_addr(__uart1+279), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GTU	L___UART1_Rx_GetMultiFrames111
	GOTO	L___UART1_Rx_GetMultiFrames89
L___UART1_Rx_GetMultiFrames111:
; frame_count end address is: 2 (W1)
;uart1.c,147 :: 		frame_count = (_uart1._multi_frame_count > max_frames) ? max_frames : _uart1._multi_frame_count;
	MOV	#lo_addr(__uart1+279), W0
	CP.B	W11, [W0]
	BRA LTU	L___UART1_Rx_GetMultiFrames112
	GOTO	L__UART1_Rx_GetMultiFrames38
L___UART1_Rx_GetMultiFrames112:
; ?FLOC____UART1_Rx_GetMultiFrames?T93 start address is: 0 (W0)
	MOV.B	W11, W0
; ?FLOC____UART1_Rx_GetMultiFrames?T93 end address is: 0 (W0)
	GOTO	L__UART1_Rx_GetMultiFrames39
L__UART1_Rx_GetMultiFrames38:
	MOV	#lo_addr(__uart1+279), W0
; ?FLOC____UART1_Rx_GetMultiFrames?T93 start address is: 2 (W1)
	MOV.B	[W0], W1
; ?FLOC____UART1_Rx_GetMultiFrames?T93 end address is: 2 (W1)
	MOV.B	W1, W0
L__UART1_Rx_GetMultiFrames39:
; ?FLOC____UART1_Rx_GetMultiFrames?T93 start address is: 0 (W0)
; frame_count start address is: 8 (W4)
	MOV.B	W0, W4
; ?FLOC____UART1_Rx_GetMultiFrames?T93 end address is: 0 (W0)
;uart1.c,149 :: 		for(i = 0; i < frame_count; i++) {
; i start address is: 10 (W5)
	CLR	W5
; frame_count end address is: 8 (W4)
; i end address is: 10 (W5)
L__UART1_Rx_GetMultiFrames40:
; i start address is: 10 (W5)
; frame_count start address is: 8 (W4)
	ZE	W4, W0
	CP	W5, W0
	BRA LT	L___UART1_Rx_GetMultiFrames113
	GOTO	L__UART1_Rx_GetMultiFrames41
L___UART1_Rx_GetMultiFrames113:
;uart1.c,150 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
; j start address is: 12 (W6)
	CLR	W6
; frame_count end address is: 8 (W4)
; j end address is: 12 (W6)
; i end address is: 10 (W5)
L__UART1_Rx_GetMultiFrames43:
; j start address is: 12 (W6)
; frame_count start address is: 8 (W4)
; i start address is: 10 (W5)
	CP	W6, #13
	BRA LT	L___UART1_Rx_GetMultiFrames114
	GOTO	L__UART1_Rx_GetMultiFrames44
L___UART1_Rx_GetMultiFrames114:
;uart1.c,151 :: 		out_frames[i * _UART1_BMS_BUFFER_SIZE + j] = _uart1._multi_frame_buffer[i][j];
	MOV	#13, W0
	MUL.SS	W5, W0, W2
	ADD	W2, W6, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(__uart1+123), W0
	ADD	W0, W2, W0
	ADD	W0, W6, W0
	MOV.B	[W0], [W1]
;uart1.c,150 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
	INC	W6
;uart1.c,152 :: 		}
; j end address is: 12 (W6)
	GOTO	L__UART1_Rx_GetMultiFrames43
L__UART1_Rx_GetMultiFrames44:
;uart1.c,149 :: 		for(i = 0; i < frame_count; i++) {
	INC	W5
;uart1.c,153 :: 		}
; i end address is: 10 (W5)
	GOTO	L__UART1_Rx_GetMultiFrames40
L__UART1_Rx_GetMultiFrames41:
;uart1.c,156 :: 		for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
; i start address is: 10 (W5)
	CLR	W5
; frame_count end address is: 8 (W4)
; i end address is: 10 (W5)
L__UART1_Rx_GetMultiFrames46:
; i start address is: 10 (W5)
; frame_count start address is: 8 (W4)
	CP	W5, #12
	BRA LT	L___UART1_Rx_GetMultiFrames115
	GOTO	L__UART1_Rx_GetMultiFrames47
L___UART1_Rx_GetMultiFrames115:
;uart1.c,157 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
; j start address is: 12 (W6)
	CLR	W6
; frame_count end address is: 8 (W4)
; j end address is: 12 (W6)
; i end address is: 10 (W5)
L__UART1_Rx_GetMultiFrames49:
; j start address is: 12 (W6)
; frame_count start address is: 8 (W4)
; i start address is: 10 (W5)
	CP	W6, #13
	BRA LT	L___UART1_Rx_GetMultiFrames116
	GOTO	L__UART1_Rx_GetMultiFrames50
L___UART1_Rx_GetMultiFrames116:
;uart1.c,158 :: 		_uart1._multi_frame_buffer[i][j] = 0;
	MOV	#13, W0
	MUL.UU	W0, W5, W2
	MOV	#lo_addr(__uart1+123), W0
	ADD	W0, W2, W0
	ADD	W0, W6, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,157 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
	INC	W6
;uart1.c,159 :: 		}
; j end address is: 12 (W6)
	GOTO	L__UART1_Rx_GetMultiFrames49
L__UART1_Rx_GetMultiFrames50:
;uart1.c,156 :: 		for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
	INC	W5
;uart1.c,160 :: 		}
; i end address is: 10 (W5)
	GOTO	L__UART1_Rx_GetMultiFrames46
L__UART1_Rx_GetMultiFrames47:
;uart1.c,161 :: 		_uart1._multi_frame_count = 0;
	MOV	#lo_addr(__uart1+279), W1
	CLR	W0
	MOV.B	W0, [W1]
; frame_count end address is: 8 (W4)
	MOV.B	W4, W1
;uart1.c,162 :: 		}
	GOTO	L__UART1_Rx_GetMultiFrames37
L___UART1_Rx_GetMultiFrames89:
;uart1.c,146 :: 		if(_uart1._multi_frame_count > 0) {
;uart1.c,162 :: 		}
L__UART1_Rx_GetMultiFrames37:
;uart1.c,164 :: 		return frame_count;
; frame_count start address is: 2 (W1)
	MOV.B	W1, W0
; frame_count end address is: 2 (W1)
;uart1.c,165 :: 		}
L_end__UART1_Rx_GetMultiFrames:
	RETURN
; end of __UART1_Rx_GetMultiFrames

__UART1_Rx_Receive_ISR:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;uart1.c,175 :: 		void _UART1_Rx_Receive_ISR(void) iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
;uart1.c,181 :: 		c = UART1_Read();
	PUSH	W10
	CALL	_UART1_Read
; c start address is: 4 (W2)
	MOV.B	W0, W2
;uart1.c,184 :: 		if(_uart1._temp_index == 0) {
	MOV	#lo_addr(__uart1+121), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L___UART1_Rx_Receive_ISR118
	GOTO	L__UART1_Rx_Receive_ISR52
L___UART1_Rx_Receive_ISR118:
;uart1.c,185 :: 		if(c != 0xA5) {
	MOV.B	#165, W0
	CP.B	W2, W0
	BRA NZ	L___UART1_Rx_Receive_ISR119
	GOTO	L__UART1_Rx_Receive_ISR53
L___UART1_Rx_Receive_ISR119:
; c end address is: 4 (W2)
;uart1.c,186 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;uart1.c,187 :: 		return;
	GOTO	L_end__UART1_Rx_Receive_ISR
;uart1.c,188 :: 		}
L__UART1_Rx_Receive_ISR53:
;uart1.c,189 :: 		}
; c start address is: 4 (W2)
L__UART1_Rx_Receive_ISR52:
;uart1.c,192 :: 		if(_uart1._temp_index < _UART1_BMS_BUFFER_SIZE) {
	MOV	#lo_addr(__uart1+121), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA LTU	L___UART1_Rx_Receive_ISR120
	GOTO	L__UART1_Rx_Receive_ISR54
L___UART1_Rx_Receive_ISR120:
;uart1.c,193 :: 		_uart1._temp_rx_buffer[_uart1._temp_index] = c;
	MOV	#lo_addr(__uart1+121), W0
	ZE	[W0], W1
	MOV	#lo_addr(__uart1+108), W0
	ADD	W0, W1, W0
	MOV.B	W2, [W0]
; c end address is: 4 (W2)
;uart1.c,194 :: 		_uart1._temp_index++;
	MOV	#lo_addr(__uart1+121), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(__uart1+121), W0
	MOV.B	W1, [W0]
;uart1.c,195 :: 		} else {
	GOTO	L__UART1_Rx_Receive_ISR55
L__UART1_Rx_Receive_ISR54:
;uart1.c,196 :: 		DebugUART_Send_Text("UART1 RX: Frame too long. Discarding.\n");
	MOV	#lo_addr(?lstr_4_uart1), W10
	CALL	_DebugUART_Send_Text
;uart1.c,197 :: 		_uart1._temp_index = 0;
	MOV	#lo_addr(__uart1+121), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,198 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;uart1.c,199 :: 		return;
	GOTO	L_end__UART1_Rx_Receive_ISR
;uart1.c,200 :: 		}
L__UART1_Rx_Receive_ISR55:
;uart1.c,203 :: 		if(_uart1._temp_index >= _UART1_BMS_BUFFER_SIZE) {
	MOV	#lo_addr(__uart1+121), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA GEU	L___UART1_Rx_Receive_ISR121
	GOTO	L__UART1_Rx_Receive_ISR56
L___UART1_Rx_Receive_ISR121:
;uart1.c,205 :: 		if(_UART1_ValidateChecksum(_uart1._temp_rx_buffer)) {
	MOV	#lo_addr(__uart1+108), W10
	CALL	__UART1_ValidateChecksum
	CP0.B	W0
	BRA NZ	L___UART1_Rx_Receive_ISR122
	GOTO	L__UART1_Rx_Receive_ISR57
L___UART1_Rx_Receive_ISR122:
;uart1.c,207 :: 		next_head = (_uart1._rx_head + 1) % _UART1_RX_STACK_SIZE;
	MOV	#lo_addr(__uart1+65), W0
	ZE	[W0], W0
	INC	W0
	MOV	#5, W2
	REPEAT	#17
	DIV.S	W0, W2
; next_head start address is: 8 (W4)
	MOV.B	W1, W4
;uart1.c,208 :: 		if(next_head == _uart1._rx_tail) {
	MOV	#lo_addr(__uart1+66), W0
	CP.B	W1, [W0]
	BRA Z	L___UART1_Rx_Receive_ISR123
	GOTO	L__UART1_Rx_Receive_ISR58
L___UART1_Rx_Receive_ISR123:
; next_head end address is: 8 (W4)
;uart1.c,209 :: 		DebugUART_Send_Text("UART1 RX Stack Full. Dropping frame.\n");
	MOV	#lo_addr(?lstr_5_uart1), W10
	CALL	_DebugUART_Send_Text
;uart1.c,210 :: 		} else {
	GOTO	L__UART1_Rx_Receive_ISR59
L__UART1_Rx_Receive_ISR58:
;uart1.c,212 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
; i start address is: 10 (W5)
; next_head start address is: 8 (W4)
	CLR	W5
; next_head end address is: 8 (W4)
; i end address is: 10 (W5)
L__UART1_Rx_Receive_ISR60:
; i start address is: 10 (W5)
; next_head start address is: 8 (W4)
	CP	W5, #13
	BRA LT	L___UART1_Rx_Receive_ISR124
	GOTO	L__UART1_Rx_Receive_ISR61
L___UART1_Rx_Receive_ISR124:
;uart1.c,213 :: 		_uart1._rx_frame_stack[_uart1._rx_head][i] = _uart1._temp_rx_buffer[i];
	MOV	#lo_addr(__uart1+65), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__uart1), W0
	ADD	W0, W2, W0
	ADD	W0, W5, W1
	MOV	#lo_addr(__uart1+108), W0
	ADD	W0, W5, W0
	MOV.B	[W0], [W1]
;uart1.c,212 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
	INC	W5
;uart1.c,214 :: 		}
; i end address is: 10 (W5)
	GOTO	L__UART1_Rx_Receive_ISR60
L__UART1_Rx_Receive_ISR61:
;uart1.c,215 :: 		_uart1._rx_head = next_head;
	MOV	#lo_addr(__uart1+65), W0
	MOV.B	W4, [W0]
; next_head end address is: 8 (W4)
;uart1.c,216 :: 		}
L__UART1_Rx_Receive_ISR59:
;uart1.c,217 :: 		} else {
	GOTO	L__UART1_Rx_Receive_ISR63
L__UART1_Rx_Receive_ISR57:
;uart1.c,218 :: 		DebugUART_Send_Text("UART1 RX: Invalid checksum. Discarding frame.\n");
	MOV	#lo_addr(?lstr_6_uart1), W10
	CALL	_DebugUART_Send_Text
;uart1.c,219 :: 		}
L__UART1_Rx_Receive_ISR63:
;uart1.c,220 :: 		_uart1._temp_index = 0; // Reset buffer tạm
	MOV	#lo_addr(__uart1+121), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,221 :: 		}
L__UART1_Rx_Receive_ISR56:
;uart1.c,223 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;uart1.c,224 :: 		}
L_end__UART1_Rx_Receive_ISR:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of __UART1_Rx_Receive_ISR

__UART1_ValidateChecksum:

;uart1.c,227 :: 		uint8_t _UART1_ValidateChecksum(const uint8_t *frame) {
;uart1.c,231 :: 		calculated_checksum = 0;
; calculated_checksum start address is: 6 (W3)
	CLR	W3
;uart1.c,233 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE - 1; i++) {
; i start address is: 4 (W2)
	CLR	W2
; calculated_checksum end address is: 6 (W3)
; i end address is: 4 (W2)
L__UART1_ValidateChecksum64:
; i start address is: 4 (W2)
; calculated_checksum start address is: 6 (W3)
	CP	W2, #12
	BRA LT	L___UART1_ValidateChecksum126
	GOTO	L__UART1_ValidateChecksum65
L___UART1_ValidateChecksum126:
;uart1.c,234 :: 		calculated_checksum += frame[i];
	ADD	W10, W2, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W1], W0
; calculated_checksum start address is: 0 (W0)
	ADD.B	W3, W0, W0
; calculated_checksum end address is: 6 (W3)
;uart1.c,233 :: 		for(i = 0; i < _UART1_BMS_BUFFER_SIZE - 1; i++) {
	INC	W2
;uart1.c,235 :: 		}
	MOV.B	W0, W3
; calculated_checksum end address is: 0 (W0)
; i end address is: 4 (W2)
	GOTO	L__UART1_ValidateChecksum64
L__UART1_ValidateChecksum65:
;uart1.c,238 :: 		return (calculated_checksum == frame[_UART1_BMS_BUFFER_SIZE - 1]);
; calculated_checksum start address is: 6 (W3)
	ADD	W10, #12, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W1], W0
	CP.B	W3, W0
	CLR.B	W0
	BRA NZ	L___UART1_ValidateChecksum127
	INC.B	W0
L___UART1_ValidateChecksum127:
; calculated_checksum end address is: 6 (W3)
;uart1.c,239 :: 		}
L_end__UART1_ValidateChecksum:
	RETURN
; end of __UART1_ValidateChecksum

__UART1_CalculateChecksum:

;uart1.c,242 :: 		uint8_t _UART1_CalculateChecksum(const uint8_t *frame, uint8_t length) {
;uart1.c,246 :: 		checksum = 0;
; checksum start address is: 6 (W3)
	CLR	W3
;uart1.c,247 :: 		for(i = 0; i < length; i++) {
; i start address is: 4 (W2)
	CLR	W2
; checksum end address is: 6 (W3)
; i end address is: 4 (W2)
L__UART1_CalculateChecksum67:
; i start address is: 4 (W2)
; checksum start address is: 6 (W3)
	ZE	W11, W0
	CP	W2, W0
	BRA LT	L___UART1_CalculateChecksum129
	GOTO	L__UART1_CalculateChecksum68
L___UART1_CalculateChecksum129:
;uart1.c,248 :: 		checksum += frame[i];
	ADD	W10, W2, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W1], W0
; checksum start address is: 0 (W0)
	ADD.B	W3, W0, W0
; checksum end address is: 6 (W3)
;uart1.c,247 :: 		for(i = 0; i < length; i++) {
	INC	W2
;uart1.c,249 :: 		}
	MOV.B	W0, W3
; checksum end address is: 0 (W0)
; i end address is: 4 (W2)
	GOTO	L__UART1_CalculateChecksum67
L__UART1_CalculateChecksum68:
;uart1.c,251 :: 		return checksum;
; checksum start address is: 6 (W3)
	MOV.B	W3, W0
; checksum end address is: 6 (W3)
;uart1.c,252 :: 		}
L_end__UART1_CalculateChecksum:
	RETURN
; end of __UART1_CalculateChecksum

__UART1_ClearBuffers:

;uart1.c,255 :: 		void _UART1_ClearBuffers(void) {
;uart1.c,259 :: 		_uart1._rx_head = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(__uart1+65), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,260 :: 		_uart1._rx_tail = 0;
	MOV	#lo_addr(__uart1+66), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,261 :: 		_uart1._tx_head = 0;
	MOV	#lo_addr(__uart1+106), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,262 :: 		_uart1._tx_tail = 0;
	MOV	#lo_addr(__uart1+107), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,263 :: 		_uart1._temp_index = 0;
	MOV	#lo_addr(__uart1+121), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,264 :: 		_uart1._frame_count = 0;
	MOV	#lo_addr(__uart1+122), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,265 :: 		_uart1._multi_frame_count = 0;
	MOV	#lo_addr(__uart1+279), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,266 :: 		_uart1._is_receiving = 0;
	MOV	#lo_addr(__uart1+280), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,267 :: 		_uart1._timeout_counter = 0;
	MOV	#lo_addr(__uart1+281), W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,270 :: 		memset(_uart1._temp_rx_buffer, 0, _UART1_BMS_BUFFER_SIZE);
	MOV	#13, W12
	CLR	W11
	MOV	#lo_addr(__uart1+108), W10
	CALL	_memset
;uart1.c,272 :: 		for(i = 0; i < _UART1_RX_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_ClearBuffers70:
; i start address is: 8 (W4)
	CP	W4, #5
	BRA LT	L___UART1_ClearBuffers131
	GOTO	L__UART1_ClearBuffers71
L___UART1_ClearBuffers131:
;uart1.c,273 :: 		memset(_uart1._rx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
	MOV	#13, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart1), W0
	ADD	W0, W2, W0
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
;uart1.c,272 :: 		for(i = 0; i < _UART1_RX_STACK_SIZE; i++) {
	INC	W4
;uart1.c,274 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART1_ClearBuffers70
L__UART1_ClearBuffers71:
;uart1.c,276 :: 		for(i = 0; i < _UART1_TX_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_ClearBuffers73:
; i start address is: 8 (W4)
	CP	W4, #3
	BRA LT	L___UART1_ClearBuffers132
	GOTO	L__UART1_ClearBuffers74
L___UART1_ClearBuffers132:
;uart1.c,277 :: 		memset(_uart1._tx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
	MOV	#13, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart1+67), W0
	ADD	W0, W2, W0
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
;uart1.c,276 :: 		for(i = 0; i < _UART1_TX_STACK_SIZE; i++) {
	INC	W4
;uart1.c,278 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART1_ClearBuffers73
L__UART1_ClearBuffers74:
;uart1.c,280 :: 		for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L__UART1_ClearBuffers76:
; i start address is: 8 (W4)
	CP	W4, #12
	BRA LT	L___UART1_ClearBuffers133
	GOTO	L__UART1_ClearBuffers77
L___UART1_ClearBuffers133:
;uart1.c,281 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
; j start address is: 10 (W5)
	CLR	W5
; j end address is: 10 (W5)
; i end address is: 8 (W4)
L__UART1_ClearBuffers79:
; j start address is: 10 (W5)
; i start address is: 8 (W4)
	CP	W5, #13
	BRA LT	L___UART1_ClearBuffers134
	GOTO	L__UART1_ClearBuffers80
L___UART1_ClearBuffers134:
;uart1.c,282 :: 		_uart1._multi_frame_buffer[i][j] = 0;
	MOV	#13, W0
	MUL.UU	W0, W4, W2
	MOV	#lo_addr(__uart1+123), W0
	ADD	W0, W2, W0
	ADD	W0, W5, W1
	CLR	W0
	MOV.B	W0, [W1]
;uart1.c,281 :: 		for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
	INC	W5
;uart1.c,283 :: 		}
; j end address is: 10 (W5)
	GOTO	L__UART1_ClearBuffers79
L__UART1_ClearBuffers80:
;uart1.c,280 :: 		for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
	INC	W4
;uart1.c,284 :: 		}
; i end address is: 8 (W4)
	GOTO	L__UART1_ClearBuffers76
L__UART1_ClearBuffers77:
;uart1.c,285 :: 		}
L_end__UART1_ClearBuffers:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of __UART1_ClearBuffers

__UART1_IsConnected:

;uart1.c,288 :: 		uint8_t _UART1_IsConnected(void) {
;uart1.c,290 :: 		return ((_uart1._rx_tail != _uart1._rx_head) || (_uart1._temp_index > 0));
	MOV	#lo_addr(__uart1+66), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__uart1+65), W0
	CP.B	W1, [W0]
	BRA Z	L___UART1_IsConnected136
	GOTO	L__UART1_IsConnected83
L___UART1_IsConnected136:
	MOV	#lo_addr(__uart1+121), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA LEU	L___UART1_IsConnected137
	GOTO	L__UART1_IsConnected83
L___UART1_IsConnected137:
	CLR	W1
	GOTO	L__UART1_IsConnected82
L__UART1_IsConnected83:
	MOV.B	#1, W0
	MOV.B	W0, W1
L__UART1_IsConnected82:
	MOV.B	W1, W0
;uart1.c,291 :: 		}
L_end__UART1_IsConnected:
	RETURN
; end of __UART1_IsConnected
