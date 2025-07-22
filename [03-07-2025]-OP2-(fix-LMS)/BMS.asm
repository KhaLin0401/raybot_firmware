
_BMS_Init:

;BMS.c,457 :: 		void BMS_Init(void) {
;BMS.c,460 :: 		IEC0bits.U1RXIE = 1;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BSET	IEC0bits, #11
;BMS.c,461 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;BMS.c,464 :: 		memset(_txBuffer, 0, sizeof(_txBuffer));
	MOV	#90, W12
	CLR	W11
	MOV	#lo_addr(__txBuffer), W10
	CALL	_memset
;BMS.c,465 :: 		memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));
	MOV	#130, W12
	CLR	W11
	MOV	#lo_addr(__rxFrameBuffer), W10
	CALL	_memset
;BMS.c,468 :: 		_currentFrameIndex = 0;
	MOV	#lo_addr(BMS__currentFrameIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,469 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,470 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,471 :: 		_framesReceived = 0;
	MOV	#lo_addr(BMS__framesReceived), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,474 :: 		_bmsState = BMS_STATE_IDLE;
	MOV	#lo_addr(BMS__bmsState), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,475 :: 		_currentCommandIndex = 0;
	MOV	#lo_addr(BMS__currentCommandIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,476 :: 		_expectedFrames = 1;
	MOV	#lo_addr(BMS__expectedFrames), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,477 :: 		_errorCounter = 0;
	MOV	#lo_addr(BMS__errorCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,478 :: 		_startTime = 0;
	CLR	W0
	CLR	W1
	MOV	W0, BMS__startTime
	MOV	W1, BMS__startTime+2
;BMS.c,481 :: 		BMS_ClearData();
	CALL	_BMS_ClearData
;BMS.c,482 :: 		}
L_end_BMS_Init:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _BMS_Init

_BMS_ClearData:

;BMS.c,484 :: 		void BMS_ClearData(void) {
;BMS.c,485 :: 		memset(&_bmsData, 0, sizeof(BMSData));
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#244, W12
	CLR	W11
	MOV	#lo_addr(__bmsData), W10
	CALL	_memset
;BMS.c,486 :: 		strcpy(_bmsData._manufacturer, "DALY");
	MOV	#lo_addr(?lstr1_BMS), W11
	MOV	#lo_addr(__bmsData+200), W10
	CALL	_strcpy
;BMS.c,487 :: 		strcpy(_bmsData._chargeDischargeStatus, "offline");
	MOV	#lo_addr(?lstr2_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
;BMS.c,488 :: 		_bmsData._errorCount = 0;
	CLR	W0
	MOV	W0, __bmsData+196
;BMS.c,489 :: 		_bmsData._chargeState = 0;
	MOV	#lo_addr(__bmsData+242), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,490 :: 		_bmsData._loadState = 0;
	MOV	#lo_addr(__bmsData+243), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,491 :: 		}
L_end_BMS_ClearData:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _BMS_ClearData

_BMS_SendCommand:
	LNK	#14

;BMS.c,493 :: 		uint8_t BMS_SendCommand(BMS_Command cmdID, uint8_t *payload) {
;BMS.c,499 :: 		while (UART1_Data_Ready()) {
	PUSH	W12
L_BMS_SendCommand0:
	CALL	_UART1_Data_Ready
	CP0	W0
	BRA NZ	L__BMS_SendCommand131
	GOTO	L_BMS_SendCommand1
L__BMS_SendCommand131:
;BMS.c,500 :: 		UART1_Read();
	CALL	_UART1_Read
;BMS.c,501 :: 		}
	GOTO	L_BMS_SendCommand0
L_BMS_SendCommand1:
;BMS.c,504 :: 		_currentFrameIndex = 0;
	MOV	#lo_addr(BMS__currentFrameIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,505 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,506 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,507 :: 		_framesReceived = 0;
	MOV	#lo_addr(BMS__framesReceived), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,508 :: 		memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));
	PUSH.D	W10
	MOV	#130, W12
	CLR	W11
	MOV	#lo_addr(__rxFrameBuffer), W10
	CALL	_memset
	POP.D	W10
;BMS.c,511 :: 		packet[0] = START_BYTE;
	ADD	W14, #0, W2
	MOV.B	#165, W0
	MOV.B	W0, [W2]
;BMS.c,512 :: 		packet[1] = HOST_ADDRESS;
	ADD	W2, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,513 :: 		packet[2] = cmdID;
	ADD	W2, #2, W0
	MOV.B	W10, [W0]
;BMS.c,514 :: 		packet[3] = 0x08;
	ADD	W2, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,517 :: 		if (payload != ((void *)0)) {
	CP	W11, #0
	BRA NZ	L__BMS_SendCommand132
	GOTO	L_BMS_SendCommand2
L__BMS_SendCommand132:
;BMS.c,518 :: 		for (i = 0; i < 8; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_SendCommand3:
; i start address is: 4 (W2)
	CP.B	W2, #8
	BRA LTU	L__BMS_SendCommand133
	GOTO	L_BMS_SendCommand4
L__BMS_SendCommand133:
;BMS.c,519 :: 		packet[4 + i] = payload[i];
	ZE	W2, W0
	ADD	W0, #4, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W1
	ZE	W2, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W1]
;BMS.c,518 :: 		for (i = 0; i < 8; i++) {
	INC.B	W2
;BMS.c,520 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand3
L_BMS_SendCommand4:
;BMS.c,521 :: 		} else {
	GOTO	L_BMS_SendCommand6
L_BMS_SendCommand2:
;BMS.c,522 :: 		for (i = 0; i < 8; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_SendCommand7:
; i start address is: 4 (W2)
	CP.B	W2, #8
	BRA LTU	L__BMS_SendCommand134
	GOTO	L_BMS_SendCommand8
L__BMS_SendCommand134:
;BMS.c,523 :: 		packet[4 + i] = 0x00;
	ZE	W2, W0
	ADD	W0, #4, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,522 :: 		for (i = 0; i < 8; i++) {
	INC.B	W2
;BMS.c,524 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand7
L_BMS_SendCommand8:
;BMS.c,525 :: 		}
L_BMS_SendCommand6:
;BMS.c,528 :: 		checksum = 0;
; checksum start address is: 6 (W3)
	CLR	W3
;BMS.c,529 :: 		for (i = 0; i < 12; i++) {
; i start address is: 4 (W2)
	CLR	W2
; checksum end address is: 6 (W3)
; i end address is: 4 (W2)
L_BMS_SendCommand10:
; i start address is: 4 (W2)
; checksum start address is: 6 (W3)
	CP.B	W2, #12
	BRA LTU	L__BMS_SendCommand135
	GOTO	L_BMS_SendCommand11
L__BMS_SendCommand135:
;BMS.c,530 :: 		checksum += packet[i];
	ADD	W14, #0, W1
	ZE	W2, W0
	ADD	W1, W0, W0
; checksum start address is: 0 (W0)
	ADD.B	W3, [W0], W0
; checksum end address is: 6 (W3)
;BMS.c,529 :: 		for (i = 0; i < 12; i++) {
	INC.B	W2
;BMS.c,531 :: 		}
	MOV.B	W0, W3
; checksum end address is: 0 (W0)
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand10
L_BMS_SendCommand11:
;BMS.c,532 :: 		packet[12] = checksum;
; checksum start address is: 6 (W3)
	ADD	W14, #0, W0
	ADD	W0, #12, W0
	MOV.B	W3, [W0]
; checksum end address is: 6 (W3)
;BMS.c,535 :: 		for (i = 0; i < _SEND_PACKET_SIZE; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_SendCommand13:
; i start address is: 4 (W2)
	CP.B	W2, #13
	BRA LTU	L__BMS_SendCommand136
	GOTO	L_BMS_SendCommand14
L__BMS_SendCommand136:
;BMS.c,536 :: 		UART1_Write(packet[i]);
	ADD	W14, #0, W1
	ZE	W2, W0
	ADD	W1, W0, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;BMS.c,535 :: 		for (i = 0; i < _SEND_PACKET_SIZE; i++) {
	INC.B	W2
;BMS.c,537 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand13
L_BMS_SendCommand14:
;BMS.c,539 :: 		return 1;
	MOV.B	#1, W0
;BMS.c,540 :: 		}
;BMS.c,539 :: 		return 1;
;BMS.c,540 :: 		}
L_end_BMS_SendCommand:
	POP	W12
	ULNK
	RETURN
; end of _BMS_SendCommand

_BMS_ValidateChecksum:

;BMS.c,542 :: 		uint8_t BMS_ValidateChecksum(uint8_t frameIndex) {
;BMS.c,546 :: 		if (frameIndex >= _RX_FRAME_COUNT) {
	CP.B	W10, #10
	BRA GEU	L__BMS_ValidateChecksum138
	GOTO	L_BMS_ValidateChecksum16
L__BMS_ValidateChecksum138:
;BMS.c,547 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,548 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,549 :: 		}
L_BMS_ValidateChecksum16:
;BMS.c,551 :: 		if (_rxFrameBuffer[frameIndex][0] != START_BYTE) {
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_ValidateChecksum139
	GOTO	L_BMS_ValidateChecksum17
L__BMS_ValidateChecksum139:
;BMS.c,552 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,553 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,554 :: 		}
L_BMS_ValidateChecksum17:
;BMS.c,556 :: 		if (_rxFrameBuffer[frameIndex][1] != 0x01) {
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	INC	W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__BMS_ValidateChecksum140
	GOTO	L_BMS_ValidateChecksum18
L__BMS_ValidateChecksum140:
;BMS.c,557 :: 		if (_rxFrameBuffer[frameIndex][1] >= 0x20) {
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	INC	W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA GEU	L__BMS_ValidateChecksum141
	GOTO	L_BMS_ValidateChecksum19
L__BMS_ValidateChecksum141:
;BMS.c,558 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,559 :: 		_bmsData._errorCode = 1;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,560 :: 		}
L_BMS_ValidateChecksum19:
;BMS.c,561 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,562 :: 		}
L_BMS_ValidateChecksum18:
;BMS.c,564 :: 		checksum = 0;
; checksum start address is: 10 (W5)
	CLR	W5
;BMS.c,565 :: 		for (i = 0; i < _RX_FRAME_SIZE - 1; i++) {
; i start address is: 8 (W4)
	CLR	W4
; checksum end address is: 10 (W5)
; i end address is: 8 (W4)
L_BMS_ValidateChecksum20:
; i start address is: 8 (W4)
; checksum start address is: 10 (W5)
	ZE	W4, W0
	CP	W0, #12
	BRA LT	L__BMS_ValidateChecksum142
	GOTO	L_BMS_ValidateChecksum21
L__BMS_ValidateChecksum142:
;BMS.c,566 :: 		checksum += _rxFrameBuffer[frameIndex][i];
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W1
	ZE	W4, W0
	ADD	W1, W0, W0
; checksum start address is: 0 (W0)
	ADD.B	W5, [W0], W0
; checksum end address is: 10 (W5)
;BMS.c,565 :: 		for (i = 0; i < _RX_FRAME_SIZE - 1; i++) {
	INC.B	W4
;BMS.c,567 :: 		}
	MOV.B	W0, W5
; checksum end address is: 0 (W0)
; i end address is: 8 (W4)
	GOTO	L_BMS_ValidateChecksum20
L_BMS_ValidateChecksum21:
;BMS.c,569 :: 		if (checksum != _rxFrameBuffer[frameIndex][_RX_FRAME_SIZE - 1]) {
; checksum start address is: 10 (W5)
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	ADD	W0, #12, W0
	CP.B	W5, [W0]
	BRA NZ	L__BMS_ValidateChecksum143
	GOTO	L_BMS_ValidateChecksum23
L__BMS_ValidateChecksum143:
; checksum end address is: 10 (W5)
;BMS.c,570 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,571 :: 		_bmsData._errorCode = 2;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;BMS.c,572 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,573 :: 		}
L_BMS_ValidateChecksum23:
;BMS.c,575 :: 		if (checksum == 0) {
; checksum start address is: 10 (W5)
	CP.B	W5, #0
	BRA Z	L__BMS_ValidateChecksum144
	GOTO	L_BMS_ValidateChecksum24
L__BMS_ValidateChecksum144:
; checksum end address is: 10 (W5)
;BMS.c,576 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,577 :: 		_bmsData._errorCode = 3;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;BMS.c,578 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,579 :: 		}
L_BMS_ValidateChecksum24:
;BMS.c,581 :: 		return 1;
	MOV.B	#1, W0
;BMS.c,582 :: 		}
L_end_BMS_ValidateChecksum:
	RETURN
; end of _BMS_ValidateChecksum

_BMS_ProcessData:
	LNK	#4

;BMS.c,584 :: 		void BMS_ProcessData(BMS_Command cmdID, uint8_t frameIndex) {
;BMS.c,588 :: 		if (frameIndex >= _RX_FRAME_COUNT) {
	PUSH	W10
	CP.B	W11, #10
	BRA GEU	L__BMS_ProcessData146
	GOTO	L_BMS_ProcessData25
L__BMS_ProcessData146:
;BMS.c,589 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,590 :: 		_bmsData._errorCode = 4;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;BMS.c,591 :: 		return;
	GOTO	L_end_BMS_ProcessData
;BMS.c,592 :: 		}
L_BMS_ProcessData25:
;BMS.c,594 :: 		switch (cmdID) {
	GOTO	L_BMS_ProcessData26
;BMS.c,595 :: 		case VOUT_IOUT_SOC:
L_BMS_ProcessData28:
;BMS.c,596 :: 		tempValue = (_rxFrameBuffer[frameIndex][4] << 8) | _rxFrameBuffer[frameIndex][5];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W2
	MOV	W2, [W14+2]
	ADD	W2, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV	W0, [W14+0]
;BMS.c,597 :: 		_bmsData._sumVoltage = (float)tempValue * 100.0;
	PUSH	W11
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Mul_FP
	POP	W11
	MOV	W0, __bmsData
	MOV	W1, __bmsData+2
;BMS.c,599 :: 		tempValue = (_rxFrameBuffer[frameIndex][8] << 8) | _rxFrameBuffer[frameIndex][9];
	MOV	[W14+2], W2
	ADD	W2, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV	W0, [W14+0]
;BMS.c,600 :: 		if (tempValue == 0) break;
	CP	W0, #0
	BRA Z	L__BMS_ProcessData147
	GOTO	L_BMS_ProcessData29
L__BMS_ProcessData147:
	GOTO	L_BMS_ProcessData27
L_BMS_ProcessData29:
;BMS.c,601 :: 		_bmsData._sumCurrent = ((float)(tempValue - 30000)) / 10.0;
	MOV	[W14+0], W1
	MOV	#30000, W0
	SUB	W1, W0, W0
	PUSH	W11
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	POP	W11
	MOV	W0, __bmsData+4
	MOV	W1, __bmsData+6
;BMS.c,603 :: 		tempValue = (_rxFrameBuffer[frameIndex][10] << 8) | _rxFrameBuffer[frameIndex][11];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W2
	ADD	W2, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #11, W0
	ZE	[W0], W0
	IOR	W1, W0, W1
	MOV	W1, [W14+0]
;BMS.c,604 :: 		if (tempValue > 1000) break;
	MOV	#1000, W0
	CP	W1, W0
	BRA GTU	L__BMS_ProcessData148
	GOTO	L_BMS_ProcessData30
L__BMS_ProcessData148:
	GOTO	L_BMS_ProcessData27
L_BMS_ProcessData30:
;BMS.c,605 :: 		_bmsData._sumSOC = (float)tempValue / 10.0;
	MOV	[W14+0], W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+8
	MOV	W1, __bmsData+10
;BMS.c,606 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,608 :: 		case MIN_MAX_CELL_VOLTAGE:
L_BMS_ProcessData31:
;BMS.c,609 :: 		tempValue = (_rxFrameBuffer[frameIndex][4] << 8) | _rxFrameBuffer[frameIndex][5];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W2
	MOV	W2, [W14+2]
	ADD	W2, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV	W0, [W14+0]
;BMS.c,610 :: 		_bmsData._maxCellVoltage = (float)tempValue / 1000.0;
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+12
	MOV	W1, __bmsData+14
;BMS.c,612 :: 		tempValue = (_rxFrameBuffer[frameIndex][7] << 8) | _rxFrameBuffer[frameIndex][8];
	MOV	[W14+2], W2
	ADD	W2, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #8, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV	W0, [W14+0]
;BMS.c,613 :: 		_bmsData._minCellVoltage = (float)tempValue / 1000.0;
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+16
	MOV	W1, __bmsData+18
;BMS.c,614 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,616 :: 		case MIN_MAX_TEMPERATURE:
L_BMS_ProcessData32:
;BMS.c,617 :: 		_bmsData._temperature = ((float)(_rxFrameBuffer[frameIndex][4] + _rxFrameBuffer[frameIndex][6]) - 80.0) / 2.0;
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	ADD	W0, #4, W1
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	[W1], W1
	ZE	W0, W0
	ADD	W1, W0, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17056, W3
	CALL	__Sub_FP
	MOV	#0, W2
	MOV	#16384, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+84
	MOV	W1, __bmsData+86
;BMS.c,618 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,620 :: 		case DISCHARGE_CHARGE_MOS_STATUS:
L_BMS_ProcessData33:
;BMS.c,621 :: 		switch (_rxFrameBuffer[frameIndex][4]) {
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	ADD	W0, #4, W0
	MOV	W0, [W14+2]
	GOTO	L_BMS_ProcessData34
;BMS.c,622 :: 		case 0:
L_BMS_ProcessData36:
;BMS.c,623 :: 		strcpy(_bmsData._chargeDischargeStatus, "Stationary");
	PUSH	W11
	MOV	#lo_addr(?lstr3_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
	POP	W11
;BMS.c,624 :: 		break;
	GOTO	L_BMS_ProcessData35
;BMS.c,625 :: 		case 1:
L_BMS_ProcessData37:
;BMS.c,626 :: 		strcpy(_bmsData._chargeDischargeStatus, "Charge");
	PUSH	W11
	MOV	#lo_addr(?lstr4_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
	POP	W11
;BMS.c,627 :: 		break;
	GOTO	L_BMS_ProcessData35
;BMS.c,628 :: 		case 2:
L_BMS_ProcessData38:
;BMS.c,629 :: 		strcpy(_bmsData._chargeDischargeStatus, "Discharge");
	PUSH	W11
	MOV	#lo_addr(?lstr5_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
	POP	W11
;BMS.c,630 :: 		break;
	GOTO	L_BMS_ProcessData35
;BMS.c,631 :: 		default:
L_BMS_ProcessData39:
;BMS.c,632 :: 		strcpy(_bmsData._chargeDischargeStatus, "Unknown");
	PUSH	W11
	MOV	#lo_addr(?lstr6_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
	POP	W11
;BMS.c,633 :: 		break;
	GOTO	L_BMS_ProcessData35
;BMS.c,634 :: 		}
L_BMS_ProcessData34:
	MOV	[W14+2], W1
	MOV.B	[W1], W0
	CP.B	W0, #0
	BRA NZ	L__BMS_ProcessData149
	GOTO	L_BMS_ProcessData36
L__BMS_ProcessData149:
	MOV.B	[W1], W0
	CP.B	W0, #1
	BRA NZ	L__BMS_ProcessData150
	GOTO	L_BMS_ProcessData37
L__BMS_ProcessData150:
	MOV.B	[W1], W0
	CP.B	W0, #2
	BRA NZ	L__BMS_ProcessData151
	GOTO	L_BMS_ProcessData38
L__BMS_ProcessData151:
	GOTO	L_BMS_ProcessData39
L_BMS_ProcessData35:
;BMS.c,636 :: 		_bmsData._chargeMOS = _rxFrameBuffer[frameIndex][5];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W6
	ADD	W6, #5, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+190), W0
	MOV.B	W1, [W0]
;BMS.c,637 :: 		_bmsData._dischargeMOS = _rxFrameBuffer[frameIndex][6];
	ADD	W6, #6, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+191), W0
	MOV.B	W1, [W0]
;BMS.c,639 :: 		_bmsData._remainingCapacity = (float)((((uint32_t)_rxFrameBuffer[frameIndex][8] << 24) |
	ADD	W6, #8, W0
	ZE	[W0], W0
	CLR	W1
	SL	W0, #8, W3
	CLR	W2
;BMS.c,640 :: 		((uint32_t)_rxFrameBuffer[frameIndex][9] << 16) |
	ADD	W6, #9, W0
	ZE	[W0], W0
	CLR	W1
	MOV	W0, W1
	CLR	W0
	IOR	W2, W0, W4
	IOR	W3, W1, W5
;BMS.c,641 :: 		((uint32_t)_rxFrameBuffer[frameIndex][10] << 8) |
	ADD	W6, #10, W0
	ZE	[W0], W2
	CLR	W3
	SL	W3, #8, W1
	LSR	W2, #8, W0
	IOR	W0, W1, W1
	SL	W2, #8, W0
	IOR	W4, W0, W2
	IOR	W5, W1, W3
;BMS.c,642 :: 		_rxFrameBuffer[frameIndex][11])) / 1000.0;
	ADD	W6, #11, W0
	ZE	[W0], W0
	CLR	W1
	IOR	W2, W0, W0
	IOR	W3, W1, W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+92
	MOV	W1, __bmsData+94
;BMS.c,643 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,645 :: 		case STATUS_INFO:
L_BMS_ProcessData40:
;BMS.c,646 :: 		_bmsData._cellCount = _rxFrameBuffer[frameIndex][4];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W3
	ADD	W3, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+192
;BMS.c,647 :: 		_bmsData._ntcCount = _rxFrameBuffer[frameIndex][5];
	ADD	W3, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+108
;BMS.c,648 :: 		_bmsData._chargeState = _rxFrameBuffer[frameIndex][6];
	ADD	W3, #6, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+242), W0
	MOV.B	W1, [W0]
;BMS.c,649 :: 		_bmsData._loadState = _rxFrameBuffer[frameIndex][7];
	ADD	W3, #7, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+243), W0
	MOV.B	W1, [W0]
;BMS.c,650 :: 		_bmsData._cycleCount = (_rxFrameBuffer[frameIndex][9] << 8) | _rxFrameBuffer[frameIndex][10];
	ADD	W3, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W2
	ADD	W3, #10, W0
	ZE	[W0], W1
	MOV	#lo_addr(__bmsData+88), W0
	IOR	W2, W1, [W0]
;BMS.c,651 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,653 :: 		case CELL_VOLTAGES:
L_BMS_ProcessData41:
;BMS.c,654 :: 		for (i = 0; i < 3; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L_BMS_ProcessData42:
; i start address is: 8 (W4)
	CP.B	W4, #3
	BRA LTU	L__BMS_ProcessData152
	GOTO	L_BMS_ProcessData43
L__BMS_ProcessData152:
;BMS.c,656 :: 		cellIndex = frameIndex * 3 + i;
	ZE	W11, W1
	MOV	#3, W0
	MUL.UU	W1, W0, W2
	ZE	W4, W0
	ADD	W2, W0, W1
; cellIndex start address is: 10 (W5)
	MOV.B	W1, W5
;BMS.c,657 :: 		if (cellIndex < _bmsData._cellCount && cellIndex < MAX_CELL_COUNT) {
	MOV	#lo_addr(__bmsData+192), W0
	CP	W1, [W0]
	BRA LT	L__BMS_ProcessData153
	GOTO	L__BMS_ProcessData116
L__BMS_ProcessData153:
	CP.B	W5, #16
	BRA LTU	L__BMS_ProcessData154
	GOTO	L__BMS_ProcessData115
L__BMS_ProcessData154:
L__BMS_ProcessData114:
;BMS.c,658 :: 		tempValue = (_rxFrameBuffer[frameIndex][5 + i * 2] << 8) | _rxFrameBuffer[frameIndex][6 + i * 2];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W3
	ZE	W4, W0
	SL	W0, #1, W2
	ADD	W2, #5, W0
	ADD	W3, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #6, W0
	ADD	W3, W0, W0
	ZE	[W0], W0
	IOR	W1, W0, W2
	MOV	W2, [W14+0]
;BMS.c,659 :: 		_bmsData._cellVoltages[cellIndex] = (float)tempValue ;
	ZE	W5, W0
; cellIndex end address is: 10 (W5)
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+20), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+2]
	PUSH	W4
	PUSH.D	W10
	MOV	W2, W0
	CLR	W1
	CALL	__Long2Float
	POP.D	W10
	POP	W4
	MOV	[W14+2], W2
	MOV.D	W0, [W2]
;BMS.c,657 :: 		if (cellIndex < _bmsData._cellCount && cellIndex < MAX_CELL_COUNT) {
L__BMS_ProcessData116:
L__BMS_ProcessData115:
;BMS.c,654 :: 		for (i = 0; i < 3; i++) {
	INC.B	W4
;BMS.c,661 :: 		}
; i end address is: 8 (W4)
	GOTO	L_BMS_ProcessData42
L_BMS_ProcessData43:
;BMS.c,662 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,664 :: 		case CELL_TEMPERATURE:
L_BMS_ProcessData48:
;BMS.c,665 :: 		for (i = 0; i < 7; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L_BMS_ProcessData49:
; i start address is: 8 (W4)
	CP.B	W4, #7
	BRA LTU	L__BMS_ProcessData155
	GOTO	L_BMS_ProcessData50
L__BMS_ProcessData155:
;BMS.c,667 :: 		sensorIndex = frameIndex * 7 + i;
	ZE	W11, W1
	MOV	#7, W0
	MUL.UU	W1, W0, W2
	ZE	W4, W0
	ADD	W2, W0, W1
; sensorIndex start address is: 4 (W2)
	MOV.B	W1, W2
;BMS.c,668 :: 		if (sensorIndex < _bmsData._ntcCount && sensorIndex < MAX_CELL_COUNT) {
	MOV	#lo_addr(__bmsData+108), W0
	CP	W1, [W0]
	BRA LT	L__BMS_ProcessData156
	GOTO	L__BMS_ProcessData118
L__BMS_ProcessData156:
	CP.B	W2, #16
	BRA LTU	L__BMS_ProcessData157
	GOTO	L__BMS_ProcessData117
L__BMS_ProcessData157:
L__BMS_ProcessData113:
;BMS.c,669 :: 		_bmsData._ntcTemperatures[sensorIndex] = (float)(_rxFrameBuffer[frameIndex][5 + i] - 40);
	ZE	W2, W0
; sensorIndex end address is: 4 (W2)
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+110), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+2]
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W1
	ZE	W4, W0
	ADD	W0, #5, W0
	ADD	W1, W0, W0
	ZE	[W0], W1
	MOV	#40, W0
	SUB	W1, W0, W0
	PUSH	W4
	PUSH.D	W10
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	POP.D	W10
	POP	W4
	MOV	[W14+2], W2
	MOV.D	W0, [W2]
;BMS.c,668 :: 		if (sensorIndex < _bmsData._ntcCount && sensorIndex < MAX_CELL_COUNT) {
L__BMS_ProcessData118:
L__BMS_ProcessData117:
;BMS.c,665 :: 		for (i = 0; i < 7; i++) {
	INC.B	W4
;BMS.c,671 :: 		}
; i end address is: 8 (W4)
	GOTO	L_BMS_ProcessData49
L_BMS_ProcessData50:
;BMS.c,672 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,674 :: 		case CELL_BALANCE_STATE:
L_BMS_ProcessData55:
;BMS.c,675 :: 		for (i = 0; i < 6; i++) {
; i start address is: 14 (W7)
	CLR	W7
; i end address is: 14 (W7)
L_BMS_ProcessData56:
; i start address is: 14 (W7)
	CP.B	W7, #6
	BRA LTU	L__BMS_ProcessData158
	GOTO	L_BMS_ProcessData57
L__BMS_ProcessData158:
;BMS.c,678 :: 		cellIndex = i * 8;
	ZE	W7, W0
	SL	W0, #3, W0
; cellIndex start address is: 10 (W5)
	MOV.B	W0, W5
;BMS.c,679 :: 		for (j = 0; j < 8; j++) {
; j start address is: 12 (W6)
	CLR	W6
; j end address is: 12 (W6)
; i end address is: 14 (W7)
L_BMS_ProcessData59:
; j start address is: 12 (W6)
; cellIndex start address is: 10 (W5)
; cellIndex end address is: 10 (W5)
; i start address is: 14 (W7)
	CP.B	W6, #8
	BRA LTU	L__BMS_ProcessData159
	GOTO	L_BMS_ProcessData60
L__BMS_ProcessData159:
; cellIndex end address is: 10 (W5)
;BMS.c,680 :: 		if (cellIndex + j < _bmsData._cellCount && cellIndex + j < MAX_CELL_COUNT) {
; cellIndex start address is: 10 (W5)
	ZE	W5, W1
	ZE	W6, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(__bmsData+192), W0
	CP	W1, [W0]
	BRA LTU	L__BMS_ProcessData160
	GOTO	L__BMS_ProcessData120
L__BMS_ProcessData160:
	ZE	W5, W1
	ZE	W6, W0
	ADD	W1, W0, W0
	CP	W0, #16
	BRA LTU	L__BMS_ProcessData161
	GOTO	L__BMS_ProcessData119
L__BMS_ProcessData161:
L__BMS_ProcessData112:
;BMS.c,681 :: 		_bmsData._balanceStatus[cellIndex + j] = (_rxFrameBuffer[frameIndex][4 + i] >> j) & 0x01;
	ZE	W5, W1
	ZE	W6, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(__bmsData+174), W0
	ADD	W0, W1, W4
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W1
	ZE	W7, W0
	ADD	W0, #4, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	ZE	W6, W2
	LSR	W0, W2, W0
	ZE	W0, W0
	AND	W0, #1, W0
	MOV.B	W0, [W4]
;BMS.c,680 :: 		if (cellIndex + j < _bmsData._cellCount && cellIndex + j < MAX_CELL_COUNT) {
L__BMS_ProcessData120:
L__BMS_ProcessData119:
;BMS.c,679 :: 		for (j = 0; j < 8; j++) {
	INC.B	W6
;BMS.c,683 :: 		}
; cellIndex end address is: 10 (W5)
; j end address is: 12 (W6)
	GOTO	L_BMS_ProcessData59
L_BMS_ProcessData60:
;BMS.c,675 :: 		for (i = 0; i < 6; i++) {
	INC.B	W7
;BMS.c,684 :: 		}
; i end address is: 14 (W7)
	GOTO	L_BMS_ProcessData56
L_BMS_ProcessData57:
;BMS.c,685 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,687 :: 		case FAILURE_CODES:
L_BMS_ProcessData65:
;BMS.c,688 :: 		_bmsData._errorCode = _rxFrameBuffer[frameIndex][4];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+194), W0
	MOV.B	W1, [W0]
;BMS.c,689 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,691 :: 		default:
L_BMS_ProcessData66:
;BMS.c,692 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,693 :: 		_bmsData._errorCode = 5;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;BMS.c,694 :: 		break;
	GOTO	L_BMS_ProcessData27
;BMS.c,695 :: 		}
L_BMS_ProcessData26:
	MOV.B	#144, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData162
	GOTO	L_BMS_ProcessData28
L__BMS_ProcessData162:
	MOV.B	#145, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData163
	GOTO	L_BMS_ProcessData31
L__BMS_ProcessData163:
	MOV.B	#146, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData164
	GOTO	L_BMS_ProcessData32
L__BMS_ProcessData164:
	MOV.B	#147, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData165
	GOTO	L_BMS_ProcessData33
L__BMS_ProcessData165:
	MOV.B	#148, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData166
	GOTO	L_BMS_ProcessData40
L__BMS_ProcessData166:
	MOV.B	#149, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData167
	GOTO	L_BMS_ProcessData41
L__BMS_ProcessData167:
	MOV.B	#150, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData168
	GOTO	L_BMS_ProcessData48
L__BMS_ProcessData168:
	MOV.B	#151, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData169
	GOTO	L_BMS_ProcessData55
L__BMS_ProcessData169:
	MOV.B	#152, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData170
	GOTO	L_BMS_ProcessData65
L__BMS_ProcessData170:
	GOTO	L_BMS_ProcessData66
L_BMS_ProcessData27:
;BMS.c,696 :: 		}
L_end_BMS_ProcessData:
	POP	W10
	ULNK
	RETURN
; end of _BMS_ProcessData

_BMS_Update:
	LNK	#10

;BMS.c,698 :: 		uint8_t BMS_Update(void) {
;BMS.c,705 :: 		for (i = 0; i < 8; i++) {
	PUSH	W10
	PUSH	W11
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_Update67:
; i start address is: 4 (W2)
	CP.B	W2, #8
	BRA LTU	L__BMS_Update172
	GOTO	L_BMS_Update68
L__BMS_Update172:
;BMS.c,706 :: 		payload[i] = 0;
	ADD	W14, #0, W1
	ZE	W2, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,705 :: 		for (i = 0; i < 8; i++) {
	INC.B	W2
;BMS.c,707 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_Update67
L_BMS_Update68:
;BMS.c,709 :: 		switch (_bmsState) {
	GOTO	L_BMS_Update70
;BMS.c,710 :: 		case BMS_STATE_IDLE:
L_BMS_Update72:
;BMS.c,712 :: 		switch (commands[_currentCommandIndex]) {
	MOV	#lo_addr(BMS__currentCommandIndex), W0
	ZE	[W0], W1
	MOV	#lo_addr(BMS_commands), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+8]
	GOTO	L_BMS_Update73
;BMS.c,713 :: 		case CELL_VOLTAGES:
L_BMS_Update75:
;BMS.c,714 :: 		_expectedFrames = (_bmsData._cellCount + 2) / 3;
	MOV	__bmsData+192, W0
	INC2	W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(BMS__expectedFrames), W0
	MOV.B	W1, [W0]
;BMS.c,715 :: 		break;
	GOTO	L_BMS_Update74
;BMS.c,716 :: 		case CELL_TEMPERATURE:
L_BMS_Update76:
;BMS.c,717 :: 		_expectedFrames = (_bmsData._ntcCount + 6) / 7;
	MOV	__bmsData+108, W0
	ADD	W0, #6, W0
	MOV	#7, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(BMS__expectedFrames), W0
	MOV.B	W1, [W0]
;BMS.c,718 :: 		break;
	GOTO	L_BMS_Update74
;BMS.c,719 :: 		case CELL_BALANCE_STATE:
L_BMS_Update77:
;BMS.c,720 :: 		_expectedFrames = (_bmsData._cellCount + 47) / 48;
	MOV	#47, W1
	MOV	#lo_addr(__bmsData+192), W0
	ADD	W1, [W0], W0
	MOV	#48, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(BMS__expectedFrames), W0
	MOV.B	W1, [W0]
;BMS.c,721 :: 		break;
	GOTO	L_BMS_Update74
;BMS.c,722 :: 		default:
L_BMS_Update78:
;BMS.c,723 :: 		_expectedFrames = 1;
	MOV	#lo_addr(BMS__expectedFrames), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,724 :: 		break;
	GOTO	L_BMS_Update74
;BMS.c,725 :: 		}
L_BMS_Update73:
	MOV	[W14+8], W2
	MOV.B	[W2], W1
	MOV.B	#149, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_Update173
	GOTO	L_BMS_Update75
L__BMS_Update173:
	MOV.B	[W2], W1
	MOV.B	#150, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_Update174
	GOTO	L_BMS_Update76
L__BMS_Update174:
	MOV.B	[W2], W1
	MOV.B	#151, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_Update175
	GOTO	L_BMS_Update77
L__BMS_Update175:
	GOTO	L_BMS_Update78
L_BMS_Update74:
;BMS.c,726 :: 		_bmsState = BMS_STATE_SEND_COMMAND;
	MOV	#lo_addr(BMS__bmsState), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,727 :: 		return 0; /* Chưa hoàn thành, tiếp tục gọi */
	CLR	W0
	GOTO	L_end_BMS_Update
;BMS.c,729 :: 		case BMS_STATE_SEND_COMMAND:
L_BMS_Update79:
;BMS.c,731 :: 		if (BMS_SendCommand(commands[_currentCommandIndex], payload)) {
	ADD	W14, #0, W2
	MOV	#lo_addr(BMS__currentCommandIndex), W0
	ZE	[W0], W1
	MOV	#lo_addr(BMS_commands), W0
	ADD	W0, W1, W0
	MOV	W2, W11
	MOV.B	[W0], W10
	CALL	_BMS_SendCommand
	CP0.B	W0
	BRA NZ	L__BMS_Update176
	GOTO	L_BMS_Update80
L__BMS_Update176:
;BMS.c,732 :: 		_startTime = GetMillis();
	CALL	_GetMillis
	MOV	W0, BMS__startTime
	MOV	W1, BMS__startTime+2
;BMS.c,733 :: 		_bmsState = BMS_STATE_WAIT_RESPONSE;
	MOV	#lo_addr(BMS__bmsState), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;BMS.c,734 :: 		} else {
	GOTO	L_BMS_Update81
L_BMS_Update80:
;BMS.c,735 :: 		_bmsState = BMS_STATE_ERROR;
	MOV	#lo_addr(BMS__bmsState), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;BMS.c,736 :: 		}
L_BMS_Update81:
;BMS.c,737 :: 		return 0; /* Chưa hoàn thành, tiếp tục gọi */
	CLR	W0
	GOTO	L_end_BMS_Update
;BMS.c,739 :: 		case BMS_STATE_WAIT_RESPONSE:
L_BMS_Update82:
;BMS.c,741 :: 		if (GetMillis() - _startTime >= 150) {
	CALL	_GetMillis
	MOV	#lo_addr(BMS__startTime), W4
	SUB	W0, [W4++], W2
	SUBB	W1, [W4--], W3
	MOV	#150, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA GEU	L__BMS_Update177
	GOTO	L_BMS_Update83
L__BMS_Update177:
;BMS.c,742 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,743 :: 		_bmsData._errorCode = 6;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#6, W0
	MOV.B	W0, [W1]
;BMS.c,744 :: 		_bmsState = BMS_STATE_ERROR;
	MOV	#lo_addr(BMS__bmsState), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;BMS.c,745 :: 		} else if (_framesReceived >= _expectedFrames) {
	GOTO	L_BMS_Update84
L_BMS_Update83:
	MOV	#lo_addr(BMS__framesReceived), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(BMS__expectedFrames), W0
	CP.B	W1, [W0]
	BRA GEU	L__BMS_Update178
	GOTO	L_BMS_Update85
L__BMS_Update178:
;BMS.c,746 :: 		_bmsState = BMS_STATE_PROCESS_DATA;
	MOV	#lo_addr(BMS__bmsState), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;BMS.c,747 :: 		}
L_BMS_Update85:
L_BMS_Update84:
;BMS.c,748 :: 		return 0; /* Chưa hoàn thành, tiếp tục gọi */
	CLR	W0
	GOTO	L_end_BMS_Update
;BMS.c,750 :: 		case BMS_STATE_PROCESS_DATA:
L_BMS_Update86:
;BMS.c,752 :: 		if (_framesReceived > 0) {
	MOV	#lo_addr(BMS__framesReceived), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA GTU	L__BMS_Update179
	GOTO	L_BMS_Update87
L__BMS_Update179:
;BMS.c,753 :: 		success = 1;
; success start address is: 4 (W2)
	MOV.B	#1, W2
;BMS.c,754 :: 		for (i = 0; i < _framesReceived; i++) {
; i start address is: 6 (W3)
	CLR	W3
; success end address is: 4 (W2)
; i end address is: 6 (W3)
L_BMS_Update88:
; i start address is: 6 (W3)
; success start address is: 4 (W2)
	MOV	#lo_addr(BMS__framesReceived), W0
	CP.B	W3, [W0]
	BRA LTU	L__BMS_Update180
	GOTO	L__BMS_Update121
L__BMS_Update180:
;BMS.c,755 :: 		if (BMS_ValidateChecksum(i)) {
	PUSH.D	W2
	MOV.B	W3, W10
	CALL	_BMS_ValidateChecksum
	POP.D	W2
	CP0.B	W0
	BRA NZ	L__BMS_Update181
	GOTO	L_BMS_Update91
L__BMS_Update181:
;BMS.c,756 :: 		BMS_ProcessData(commands[_currentCommandIndex], i);
	MOV	#lo_addr(BMS__currentCommandIndex), W0
	ZE	[W0], W1
	MOV	#lo_addr(BMS_commands), W0
	ADD	W0, W1, W0
	PUSH.D	W2
	MOV.B	W3, W11
	MOV.B	[W0], W10
	CALL	_BMS_ProcessData
	POP.D	W2
;BMS.c,757 :: 		} else {
	GOTO	L_BMS_Update92
; success end address is: 4 (W2)
; i end address is: 6 (W3)
L_BMS_Update91:
;BMS.c,758 :: 		success = 0;
; success start address is: 0 (W0)
	CLR	W0
;BMS.c,759 :: 		break;
	MOV.B	W0, W4
; success end address is: 0 (W0)
	GOTO	L_BMS_Update89
;BMS.c,760 :: 		}
L_BMS_Update92:
;BMS.c,754 :: 		for (i = 0; i < _framesReceived; i++) {
; i start address is: 6 (W3)
; success start address is: 4 (W2)
	INC.B	W3
;BMS.c,761 :: 		}
; success end address is: 4 (W2)
; i end address is: 6 (W3)
	GOTO	L_BMS_Update88
L__BMS_Update121:
;BMS.c,754 :: 		for (i = 0; i < _framesReceived; i++) {
	MOV.B	W2, W4
;BMS.c,761 :: 		}
L_BMS_Update89:
;BMS.c,762 :: 		} else {
; success start address is: 8 (W4)
; success end address is: 8 (W4)
	GOTO	L_BMS_Update93
L_BMS_Update87:
;BMS.c,763 :: 		success = 0;
; success start address is: 8 (W4)
	CLR	W4
; success end address is: 8 (W4)
;BMS.c,764 :: 		}
L_BMS_Update93:
;BMS.c,767 :: 		_currentFrameIndex = 0;
; success start address is: 8 (W4)
	MOV	#lo_addr(BMS__currentFrameIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,768 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,769 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,770 :: 		_framesReceived = 0;
	MOV	#lo_addr(BMS__framesReceived), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,773 :: 		if (!success) {
	CP0.B	W4
	BRA Z	L__BMS_Update182
	GOTO	L_BMS_Update94
L__BMS_Update182:
;BMS.c,774 :: 		_errorCounter++;
	MOV.B	#1, W1
	MOV	#lo_addr(BMS__errorCounter), W0
	ADD.B	W1, [W0], [W0]
;BMS.c,775 :: 		if (_errorCounter >= 10) {
	MOV	#lo_addr(BMS__errorCounter), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA GEU	L__BMS_Update183
	GOTO	L_BMS_Update95
L__BMS_Update183:
; success end address is: 8 (W4)
;BMS.c,776 :: 		BMS_ClearData();
	CALL	_BMS_ClearData
;BMS.c,777 :: 		_currentCommandIndex = 0;
	MOV	#lo_addr(BMS__currentCommandIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,778 :: 		_errorCounter = 0;
	MOV	#lo_addr(BMS__errorCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,779 :: 		strcpy(_bmsData._chargeDischargeStatus, "offline");
	MOV	#lo_addr(?lstr7_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
;BMS.c,780 :: 		_bmsState = BMS_STATE_IDLE;
	MOV	#lo_addr(BMS__bmsState), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,781 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_Update
;BMS.c,782 :: 		}
L_BMS_Update95:
;BMS.c,783 :: 		} else {
; success start address is: 8 (W4)
	GOTO	L_BMS_Update96
L_BMS_Update94:
;BMS.c,784 :: 		_errorCounter = 0;
	MOV	#lo_addr(BMS__errorCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,785 :: 		strcpy(_bmsData._chargeDischargeStatus, "online");
	MOV	#lo_addr(?lstr8_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
;BMS.c,786 :: 		}
L_BMS_Update96:
;BMS.c,789 :: 		_currentCommandIndex = (_currentCommandIndex + 1) % commandCount;
	MOV	#lo_addr(BMS__currentCommandIndex), W0
	ZE	[W0], W0
	INC	W0
	MOV	#9, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(BMS__currentCommandIndex), W0
	MOV.B	W1, [W0]
;BMS.c,790 :: 		_bmsState = BMS_STATE_IDLE;
	MOV	#lo_addr(BMS__bmsState), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,791 :: 		return success; /* Hoàn thành lệnh hiện tại */
	MOV.B	W4, W0
; success end address is: 8 (W4)
	GOTO	L_end_BMS_Update
;BMS.c,793 :: 		case BMS_STATE_ERROR:
L_BMS_Update97:
;BMS.c,794 :: 		_errorCounter++;
	MOV.B	#1, W1
	MOV	#lo_addr(BMS__errorCounter), W0
	ADD.B	W1, [W0], [W0]
;BMS.c,795 :: 		if (_errorCounter >= 10) {
	MOV	#lo_addr(BMS__errorCounter), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA GEU	L__BMS_Update184
	GOTO	L_BMS_Update98
L__BMS_Update184:
;BMS.c,796 :: 		BMS_ClearData();
	CALL	_BMS_ClearData
;BMS.c,797 :: 		_currentCommandIndex = 0;
	MOV	#lo_addr(BMS__currentCommandIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,798 :: 		_errorCounter = 0;
	MOV	#lo_addr(BMS__errorCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,799 :: 		strcpy(_bmsData._chargeDischargeStatus, "offline");
	MOV	#lo_addr(?lstr9_BMS), W11
	MOV	#lo_addr(__bmsData+222), W10
	CALL	_strcpy
;BMS.c,800 :: 		}
L_BMS_Update98:
;BMS.c,801 :: 		_bmsState = BMS_STATE_IDLE;
	MOV	#lo_addr(BMS__bmsState), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,802 :: 		return 0; /* Lỗi, tiếp tục gọi */
	CLR	W0
	GOTO	L_end_BMS_Update
;BMS.c,803 :: 		}
L_BMS_Update70:
	MOV	#lo_addr(BMS__bmsState), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__BMS_Update185
	GOTO	L_BMS_Update72
L__BMS_Update185:
	MOV	#lo_addr(BMS__bmsState), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__BMS_Update186
	GOTO	L_BMS_Update79
L__BMS_Update186:
	MOV	#lo_addr(BMS__bmsState), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__BMS_Update187
	GOTO	L_BMS_Update82
L__BMS_Update187:
	MOV	#lo_addr(BMS__bmsState), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__BMS_Update188
	GOTO	L_BMS_Update86
L__BMS_Update188:
	MOV	#lo_addr(BMS__bmsState), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA NZ	L__BMS_Update189
	GOTO	L_BMS_Update97
L__BMS_Update189:
;BMS.c,805 :: 		return 0; /* Mặc định: chưa hoàn thành */
	CLR	W0
;BMS.c,806 :: 		}
;BMS.c,805 :: 		return 0; /* Mặc định: chưa hoàn thành */
;BMS.c,806 :: 		}
L_end_BMS_Update:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _BMS_Update

__UART1_Interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;BMS.c,808 :: 		void _UART1_Interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
;BMS.c,811 :: 		while (UART1_Data_Ready()) {
L__UART1_Interrupt99:
	CALL	_UART1_Data_Ready
	CP0	W0
	BRA NZ	L___UART1_Interrupt191
	GOTO	L__UART1_Interrupt100
L___UART1_Interrupt191:
;BMS.c,812 :: 		byte = UART1_Read();
	CALL	_UART1_Read
; byte start address is: 8 (W4)
	MOV.B	W0, W4
;BMS.c,814 :: 		if (!_frameStarted && byte == START_BYTE) {
	MOV	#lo_addr(BMS__frameStarted), W0
	CP0.B	[W0]
	BRA Z	L___UART1_Interrupt192
	GOTO	L___UART1_Interrupt125
L___UART1_Interrupt192:
	MOV.B	#165, W0
	CP.B	W4, W0
	BRA Z	L___UART1_Interrupt193
	GOTO	L___UART1_Interrupt124
L___UART1_Interrupt193:
L___UART1_Interrupt123:
;BMS.c,815 :: 		_frameStarted = 1;
	MOV	#lo_addr(BMS__frameStarted), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,816 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,817 :: 		if (_currentFrameIndex < _RX_FRAME_COUNT) {
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA LTU	L___UART1_Interrupt194
	GOTO	L__UART1_Interrupt104
L___UART1_Interrupt194:
;BMS.c,818 :: 		_rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W1
	MOV	#lo_addr(BMS__currentByteIndex), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV.B	W4, [W0]
; byte end address is: 8 (W4)
;BMS.c,819 :: 		_currentByteIndex++;
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	W1, [W0]
;BMS.c,820 :: 		}
L__UART1_Interrupt104:
;BMS.c,821 :: 		} else if (_frameStarted) {
	GOTO	L__UART1_Interrupt105
;BMS.c,814 :: 		if (!_frameStarted && byte == START_BYTE) {
L___UART1_Interrupt125:
; byte start address is: 8 (W4)
L___UART1_Interrupt124:
;BMS.c,821 :: 		} else if (_frameStarted) {
	MOV	#lo_addr(BMS__frameStarted), W0
	CP0.B	[W0]
	BRA NZ	L___UART1_Interrupt195
	GOTO	L__UART1_Interrupt106
L___UART1_Interrupt195:
;BMS.c,822 :: 		if (_currentFrameIndex < _RX_FRAME_COUNT && _currentByteIndex < _RX_FRAME_SIZE) {
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA LTU	L___UART1_Interrupt196
	GOTO	L___UART1_Interrupt127
L___UART1_Interrupt196:
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA LTU	L___UART1_Interrupt197
	GOTO	L___UART1_Interrupt126
L___UART1_Interrupt197:
L___UART1_Interrupt122:
;BMS.c,823 :: 		_rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	ZE	[W0], W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W1
	MOV	#lo_addr(BMS__currentByteIndex), W0
	ZE	[W0], W0
	ADD	W1, W0, W0
	MOV.B	W4, [W0]
; byte end address is: 8 (W4)
;BMS.c,824 :: 		_currentByteIndex++;
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	W1, [W0]
;BMS.c,826 :: 		if (_currentByteIndex >= _RX_FRAME_SIZE) {
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA GEU	L___UART1_Interrupt198
	GOTO	L__UART1_Interrupt110
L___UART1_Interrupt198:
;BMS.c,827 :: 		_framesReceived++;
	MOV	#lo_addr(BMS__framesReceived), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__framesReceived), W0
	MOV.B	W1, [W0]
;BMS.c,828 :: 		_currentFrameIndex++;
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	W1, [W0]
;BMS.c,829 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,830 :: 		}
L__UART1_Interrupt110:
;BMS.c,831 :: 		} else {
	GOTO	L__UART1_Interrupt111
;BMS.c,822 :: 		if (_currentFrameIndex < _RX_FRAME_COUNT && _currentByteIndex < _RX_FRAME_SIZE) {
L___UART1_Interrupt127:
L___UART1_Interrupt126:
;BMS.c,832 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,833 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,834 :: 		_bmsData._errorCode = 7;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#7, W0
	MOV.B	W0, [W1]
;BMS.c,835 :: 		}
L__UART1_Interrupt111:
;BMS.c,836 :: 		}
L__UART1_Interrupt106:
L__UART1_Interrupt105:
;BMS.c,837 :: 		}
	GOTO	L__UART1_Interrupt99
L__UART1_Interrupt100:
;BMS.c,839 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;BMS.c,840 :: 		}
L_end__UART1_Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of __UART1_Interrupt
