
_BMS_Init:

;BMS.c,27 :: 		void BMS_Init(void) {
;BMS.c,29 :: 		UART1_Init(9600);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;BMS.c,30 :: 		Delay_ms(100);
	MOV	#3, W8
	MOV	#2261, W7
L_BMS_Init0:
	DEC	W7
	BRA NZ	L_BMS_Init0
	DEC	W8
	BRA NZ	L_BMS_Init0
;BMS.c,34 :: 		IEC0bits.U1RXIE = 1;
	BSET	IEC0bits, #11
;BMS.c,35 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;BMS.c,38 :: 		memset(_txBuffer, 0, sizeof(_txBuffer));
	MOV	#90, W12
	CLR	W11
	MOV	#lo_addr(__txBuffer), W10
	CALL	_memset
;BMS.c,39 :: 		memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));
	MOV	#130, W12
	CLR	W11
	MOV	#lo_addr(__rxFrameBuffer), W10
	CALL	_memset
;BMS.c,42 :: 		_currentFrameIndex = 0;
	MOV	#lo_addr(BMS__currentFrameIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,43 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,44 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,45 :: 		_framesReceived = 0;
	MOV	#lo_addr(BMS__framesReceived), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,48 :: 		BMS_ClearData();
	CALL	_BMS_ClearData
;BMS.c,51 :: 		requestCounter = 0;
	MOV	#lo_addr(BMS_requestCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,52 :: 		errorCounter = 0;
	MOV	#lo_addr(BMS_errorCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,53 :: 		}
L_end_BMS_Init:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _BMS_Init

_BMS_ClearData:

;BMS.c,55 :: 		void BMS_ClearData(void) {
;BMS.c,56 :: 		memset(&_bmsData, 0, sizeof(BMSData));
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#244, W12
	CLR	W11
	MOV	#lo_addr(__bmsData), W10
	CALL	_memset
;BMS.c,57 :: 		strcpy(_bmsData._manufacturer, "DALY");
	MOV	#lo_addr(?lstr1_BMS), W11
	MOV	#lo_addr(__bmsData+200), W10
	CALL	_strcpy
;BMS.c,58 :: 		strcpy(_bmsData._chargeDischargeStatus, "offline");
	MOV	#lo_addr(?lstr2_BMS), W11
	MOV	#lo_addr(__bmsData+220), W10
	CALL	_strcpy
;BMS.c,59 :: 		_bmsData._errorCount = 0;
	CLR	W0
	MOV	W0, __bmsData+196
;BMS.c,60 :: 		}
L_end_BMS_ClearData:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _BMS_ClearData

_BMS_SendCommand:
	LNK	#14

;BMS.c,62 :: 		uint8_t BMS_SendCommand(BMS_Command cmdID, uint8_t *payload) {
;BMS.c,68 :: 		while (UART1_Data_Ready()) {
	PUSH	W12
L_BMS_SendCommand2:
	CALL	_UART1_Data_Ready
	CP0	W0
	BRA NZ	L__BMS_SendCommand129
	GOTO	L_BMS_SendCommand3
L__BMS_SendCommand129:
;BMS.c,69 :: 		UART1_Read();
	CALL	_UART1_Read
;BMS.c,70 :: 		}
	GOTO	L_BMS_SendCommand2
L_BMS_SendCommand3:
;BMS.c,73 :: 		_currentFrameIndex = 0;
	MOV	#lo_addr(BMS__currentFrameIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,74 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,75 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,76 :: 		_framesReceived = 0;
	MOV	#lo_addr(BMS__framesReceived), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,77 :: 		memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));
	PUSH.D	W10
	MOV	#130, W12
	CLR	W11
	MOV	#lo_addr(__rxFrameBuffer), W10
	CALL	_memset
	POP.D	W10
;BMS.c,80 :: 		packet[0] = START_BYTE;
	ADD	W14, #0, W2
	MOV.B	#165, W0
	MOV.B	W0, [W2]
;BMS.c,81 :: 		packet[1] = HOST_ADDRESS;
	ADD	W2, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,82 :: 		packet[2] = cmdID;
	ADD	W2, #2, W0
	MOV.B	W10, [W0]
;BMS.c,83 :: 		packet[3] = 0x08;
	ADD	W2, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,86 :: 		if (payload != ((void *)0)) {
	CP	W11, #0
	BRA NZ	L__BMS_SendCommand130
	GOTO	L_BMS_SendCommand4
L__BMS_SendCommand130:
;BMS.c,87 :: 		for (i = 0; i < 8; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_SendCommand5:
; i start address is: 4 (W2)
	CP.B	W2, #8
	BRA LTU	L__BMS_SendCommand131
	GOTO	L_BMS_SendCommand6
L__BMS_SendCommand131:
;BMS.c,88 :: 		packet[4 + i] = payload[i];
	ZE	W2, W0
	ADD	W0, #4, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W1
	ZE	W2, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W1]
;BMS.c,87 :: 		for (i = 0; i < 8; i++) {
	INC.B	W2
;BMS.c,89 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand5
L_BMS_SendCommand6:
;BMS.c,90 :: 		} else {
	GOTO	L_BMS_SendCommand8
L_BMS_SendCommand4:
;BMS.c,91 :: 		for (i = 0; i < 8; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_SendCommand9:
; i start address is: 4 (W2)
	CP.B	W2, #8
	BRA LTU	L__BMS_SendCommand132
	GOTO	L_BMS_SendCommand10
L__BMS_SendCommand132:
;BMS.c,92 :: 		packet[4 + i] = 0x00;
	ZE	W2, W0
	ADD	W0, #4, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,91 :: 		for (i = 0; i < 8; i++) {
	INC.B	W2
;BMS.c,93 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand9
L_BMS_SendCommand10:
;BMS.c,94 :: 		}
L_BMS_SendCommand8:
;BMS.c,97 :: 		checksum = 0;
; checksum start address is: 6 (W3)
	CLR	W3
;BMS.c,98 :: 		for (i = 0; i < 12; i++) {
; i start address is: 4 (W2)
	CLR	W2
; checksum end address is: 6 (W3)
; i end address is: 4 (W2)
L_BMS_SendCommand12:
; i start address is: 4 (W2)
; checksum start address is: 6 (W3)
	CP.B	W2, #12
	BRA LTU	L__BMS_SendCommand133
	GOTO	L_BMS_SendCommand13
L__BMS_SendCommand133:
;BMS.c,99 :: 		checksum += packet[i];
	ADD	W14, #0, W1
	ZE	W2, W0
	ADD	W1, W0, W0
; checksum start address is: 0 (W0)
	ADD.B	W3, [W0], W0
; checksum end address is: 6 (W3)
;BMS.c,98 :: 		for (i = 0; i < 12; i++) {
	INC.B	W2
;BMS.c,100 :: 		}
	MOV.B	W0, W3
; checksum end address is: 0 (W0)
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand12
L_BMS_SendCommand13:
;BMS.c,101 :: 		packet[12] = checksum;
; checksum start address is: 6 (W3)
	ADD	W14, #0, W0
	ADD	W0, #12, W0
	MOV.B	W3, [W0]
; checksum end address is: 6 (W3)
;BMS.c,104 :: 		for (i = 0; i < _SEND_PACKET_SIZE; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_SendCommand15:
; i start address is: 4 (W2)
	CP.B	W2, #13
	BRA LTU	L__BMS_SendCommand134
	GOTO	L_BMS_SendCommand16
L__BMS_SendCommand134:
;BMS.c,105 :: 		UART1_Write(packet[i]);
	ADD	W14, #0, W1
	ZE	W2, W0
	ADD	W1, W0, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;BMS.c,104 :: 		for (i = 0; i < _SEND_PACKET_SIZE; i++) {
	INC.B	W2
;BMS.c,106 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_SendCommand15
L_BMS_SendCommand16:
;BMS.c,109 :: 		while (!UART1_Tx_Idle()) {
L_BMS_SendCommand18:
	CALL	_UART1_Tx_Idle
	CP0	W0
	BRA Z	L__BMS_SendCommand135
	GOTO	L_BMS_SendCommand19
L__BMS_SendCommand135:
;BMS.c,110 :: 		}
	GOTO	L_BMS_SendCommand18
L_BMS_SendCommand19:
;BMS.c,112 :: 		return 1;
	MOV.B	#1, W0
;BMS.c,113 :: 		}
;BMS.c,112 :: 		return 1;
;BMS.c,113 :: 		}
L_end_BMS_SendCommand:
	POP	W12
	ULNK
	RETURN
; end of _BMS_SendCommand

_BMS_ReceiveData:

;BMS.c,115 :: 		uint8_t BMS_ReceiveData(uint8_t expectedFrames) {
;BMS.c,119 :: 		startTime = GetMillis();
	PUSH	W10
	CALL	_GetMillis
	POP	W10
; startTime start address is: 8 (W4)
; startTime start address is: 8 (W4)
	MOV.D	W0, W4
; startTime end address is: 8 (W4)
;BMS.c,120 :: 		while (_framesReceived < expectedFrames && (GetMillis() - startTime < 150)) {
L_BMS_ReceiveData20:
; startTime start address is: 8 (W4)
; startTime end address is: 8 (W4)
	MOV	#lo_addr(BMS__framesReceived), W0
	CP.B	W10, [W0]
	BRA GTU	L__BMS_ReceiveData137
	GOTO	L__BMS_ReceiveData110
L__BMS_ReceiveData137:
; startTime end address is: 8 (W4)
; startTime start address is: 8 (W4)
	PUSH.D	W4
	PUSH	W10
	CALL	_GetMillis
	POP	W10
	POP.D	W4
	SUB	W0, W4, W2
	SUBB	W1, W5, W3
	MOV	#150, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA LTU	L__BMS_ReceiveData138
	GOTO	L__BMS_ReceiveData109
L__BMS_ReceiveData138:
L__BMS_ReceiveData108:
;BMS.c,122 :: 		}
; startTime end address is: 8 (W4)
	GOTO	L_BMS_ReceiveData20
;BMS.c,120 :: 		while (_framesReceived < expectedFrames && (GetMillis() - startTime < 150)) {
L__BMS_ReceiveData110:
L__BMS_ReceiveData109:
;BMS.c,124 :: 		framesReceived = _framesReceived;
	MOV	#lo_addr(BMS__framesReceived), W0
; framesReceived start address is: 4 (W2)
	MOV.B	[W0], W2
;BMS.c,127 :: 		_currentFrameIndex = 0;
	MOV	#lo_addr(BMS__currentFrameIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,128 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,129 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,130 :: 		_framesReceived = 0;
	MOV	#lo_addr(BMS__framesReceived), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,132 :: 		if (framesReceived < expectedFrames) {
	CP.B	W2, W10
	BRA LTU	L__BMS_ReceiveData139
	GOTO	L_BMS_ReceiveData24
L__BMS_ReceiveData139:
;BMS.c,133 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,134 :: 		_bmsData._errorCode = 6;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#6, W0
	MOV.B	W0, [W1]
;BMS.c,135 :: 		}
L_BMS_ReceiveData24:
;BMS.c,137 :: 		return framesReceived;
	MOV.B	W2, W0
; framesReceived end address is: 4 (W2)
;BMS.c,138 :: 		}
L_end_BMS_ReceiveData:
	RETURN
; end of _BMS_ReceiveData

_BMS_ValidateChecksum:

;BMS.c,140 :: 		uint8_t BMS_ValidateChecksum(uint8_t frameIndex) {
;BMS.c,144 :: 		if (frameIndex >= _RX_FRAME_COUNT) {
	CP.B	W10, #10
	BRA GEU	L__BMS_ValidateChecksum141
	GOTO	L_BMS_ValidateChecksum25
L__BMS_ValidateChecksum141:
;BMS.c,145 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,146 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,147 :: 		}
L_BMS_ValidateChecksum25:
;BMS.c,149 :: 		if (_rxFrameBuffer[frameIndex][0] != START_BYTE) {
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_ValidateChecksum142
	GOTO	L_BMS_ValidateChecksum26
L__BMS_ValidateChecksum142:
;BMS.c,150 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,151 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,152 :: 		}
L_BMS_ValidateChecksum26:
;BMS.c,154 :: 		if (_rxFrameBuffer[frameIndex][1] != 0x01) {
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	INC	W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__BMS_ValidateChecksum143
	GOTO	L_BMS_ValidateChecksum27
L__BMS_ValidateChecksum143:
;BMS.c,155 :: 		if (_rxFrameBuffer[frameIndex][1] >= 0x20) {
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	INC	W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA GEU	L__BMS_ValidateChecksum144
	GOTO	L_BMS_ValidateChecksum28
L__BMS_ValidateChecksum144:
;BMS.c,156 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,157 :: 		_bmsData._errorCode = 1;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,158 :: 		}
L_BMS_ValidateChecksum28:
;BMS.c,159 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,160 :: 		}
L_BMS_ValidateChecksum27:
;BMS.c,162 :: 		checksum = 0;
; checksum start address is: 10 (W5)
	CLR	W5
;BMS.c,163 :: 		for (i = 0; i < _RX_FRAME_SIZE - 1; i++) {
; i start address is: 8 (W4)
	CLR	W4
; checksum end address is: 10 (W5)
; i end address is: 8 (W4)
L_BMS_ValidateChecksum29:
; i start address is: 8 (W4)
; checksum start address is: 10 (W5)
	ZE	W4, W0
	CP	W0, #12
	BRA LT	L__BMS_ValidateChecksum145
	GOTO	L_BMS_ValidateChecksum30
L__BMS_ValidateChecksum145:
;BMS.c,164 :: 		checksum += _rxFrameBuffer[frameIndex][i];
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
;BMS.c,163 :: 		for (i = 0; i < _RX_FRAME_SIZE - 1; i++) {
	INC.B	W4
;BMS.c,165 :: 		}
	MOV.B	W0, W5
; checksum end address is: 0 (W0)
; i end address is: 8 (W4)
	GOTO	L_BMS_ValidateChecksum29
L_BMS_ValidateChecksum30:
;BMS.c,167 :: 		if (checksum != _rxFrameBuffer[frameIndex][_RX_FRAME_SIZE - 1]) {
; checksum start address is: 10 (W5)
	ZE	W10, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	ADD	W0, #12, W0
	CP.B	W5, [W0]
	BRA NZ	L__BMS_ValidateChecksum146
	GOTO	L_BMS_ValidateChecksum32
L__BMS_ValidateChecksum146:
; checksum end address is: 10 (W5)
;BMS.c,168 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,169 :: 		_bmsData._errorCode = 2;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;BMS.c,170 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,171 :: 		}
L_BMS_ValidateChecksum32:
;BMS.c,173 :: 		if (checksum == 0) {
; checksum start address is: 10 (W5)
	CP.B	W5, #0
	BRA Z	L__BMS_ValidateChecksum147
	GOTO	L_BMS_ValidateChecksum33
L__BMS_ValidateChecksum147:
; checksum end address is: 10 (W5)
;BMS.c,174 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,175 :: 		_bmsData._errorCode = 3;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;BMS.c,176 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_ValidateChecksum
;BMS.c,177 :: 		}
L_BMS_ValidateChecksum33:
;BMS.c,179 :: 		return 1;
	MOV.B	#1, W0
;BMS.c,180 :: 		}
L_end_BMS_ValidateChecksum:
	RETURN
; end of _BMS_ValidateChecksum

_BMS_ProcessData:
	LNK	#4

;BMS.c,182 :: 		void BMS_ProcessData(BMS_Command cmdID, uint8_t frameIndex) {
;BMS.c,186 :: 		if (frameIndex >= _RX_FRAME_COUNT) {
	PUSH	W10
	CP.B	W11, #10
	BRA GEU	L__BMS_ProcessData149
	GOTO	L_BMS_ProcessData34
L__BMS_ProcessData149:
;BMS.c,187 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,188 :: 		_bmsData._errorCode = 4;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#4, W0
	MOV.B	W0, [W1]
;BMS.c,189 :: 		return;
	GOTO	L_end_BMS_ProcessData
;BMS.c,190 :: 		}
L_BMS_ProcessData34:
;BMS.c,192 :: 		switch (cmdID) {
	GOTO	L_BMS_ProcessData35
;BMS.c,193 :: 		case VOUT_IOUT_SOC:
L_BMS_ProcessData37:
;BMS.c,194 :: 		tempValue = (_rxFrameBuffer[frameIndex][4] << 8) | _rxFrameBuffer[frameIndex][5];
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
;BMS.c,195 :: 		_bmsData._sumVoltage = (float)tempValue / 10.0;
	PUSH	W11
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	POP	W11
	MOV	W0, __bmsData
	MOV	W1, __bmsData+2
;BMS.c,197 :: 		tempValue = (_rxFrameBuffer[frameIndex][8] << 8) | _rxFrameBuffer[frameIndex][9];
	MOV	[W14+2], W2
	ADD	W2, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV	W0, [W14+0]
;BMS.c,198 :: 		if (tempValue == 0) break;
	CP	W0, #0
	BRA Z	L__BMS_ProcessData150
	GOTO	L_BMS_ProcessData38
L__BMS_ProcessData150:
	GOTO	L_BMS_ProcessData36
L_BMS_ProcessData38:
;BMS.c,199 :: 		_bmsData._sumCurrent = ((float)(tempValue - 30000)) / 10.0;
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
;BMS.c,201 :: 		tempValue = (_rxFrameBuffer[frameIndex][10] << 8) | _rxFrameBuffer[frameIndex][11];
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
;BMS.c,202 :: 		if (tempValue > 1000) break;
	MOV	#1000, W0
	CP	W1, W0
	BRA GTU	L__BMS_ProcessData151
	GOTO	L_BMS_ProcessData39
L__BMS_ProcessData151:
	GOTO	L_BMS_ProcessData36
L_BMS_ProcessData39:
;BMS.c,203 :: 		_bmsData._sumSOC = (float)tempValue / 10.0;
	MOV	[W14+0], W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+8
	MOV	W1, __bmsData+10
;BMS.c,204 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,206 :: 		case MIN_MAX_CELL_VOLTAGE:
L_BMS_ProcessData40:
;BMS.c,207 :: 		tempValue = (_rxFrameBuffer[frameIndex][4] << 8) | _rxFrameBuffer[frameIndex][5];
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
;BMS.c,208 :: 		_bmsData._maxCellVoltage = (float)tempValue / 1000.0;
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+12
	MOV	W1, __bmsData+14
;BMS.c,210 :: 		tempValue = (_rxFrameBuffer[frameIndex][7] << 8) | _rxFrameBuffer[frameIndex][8];
	MOV	[W14+2], W2
	ADD	W2, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #8, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	MOV	W0, [W14+0]
;BMS.c,211 :: 		_bmsData._minCellVoltage = (float)tempValue / 1000.0;
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+16
	MOV	W1, __bmsData+18
;BMS.c,212 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,214 :: 		case MIN_MAX_TEMPERATURE:
L_BMS_ProcessData41:
;BMS.c,215 :: 		_bmsData._temperature = ((float)(_rxFrameBuffer[frameIndex][4] + _rxFrameBuffer[frameIndex][6]) - 80.0) / 2.0;
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
;BMS.c,216 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,218 :: 		case DISCHARGE_CHARGE_MOS_STATUS:
L_BMS_ProcessData42:
;BMS.c,219 :: 		switch (_rxFrameBuffer[frameIndex][4]) {
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	ADD	W0, #4, W0
	MOV	W0, [W14+2]
	GOTO	L_BMS_ProcessData43
;BMS.c,220 :: 		case 0:
L_BMS_ProcessData45:
;BMS.c,221 :: 		strcpy(_bmsData._chargeDischargeStatus, "Stationary");
	PUSH	W11
	MOV	#lo_addr(?lstr3_BMS), W11
	MOV	#lo_addr(__bmsData+220), W10
	CALL	_strcpy
	POP	W11
;BMS.c,222 :: 		break;
	GOTO	L_BMS_ProcessData44
;BMS.c,223 :: 		case 1:
L_BMS_ProcessData46:
;BMS.c,224 :: 		strcpy(_bmsData._chargeDischargeStatus, "Charge");
	PUSH	W11
	MOV	#lo_addr(?lstr4_BMS), W11
	MOV	#lo_addr(__bmsData+220), W10
	CALL	_strcpy
	POP	W11
;BMS.c,225 :: 		break;
	GOTO	L_BMS_ProcessData44
;BMS.c,226 :: 		case 2:
L_BMS_ProcessData47:
;BMS.c,227 :: 		strcpy(_bmsData._chargeDischargeStatus, "Discharge");
	PUSH	W11
	MOV	#lo_addr(?lstr5_BMS), W11
	MOV	#lo_addr(__bmsData+220), W10
	CALL	_strcpy
	POP	W11
;BMS.c,228 :: 		break;
	GOTO	L_BMS_ProcessData44
;BMS.c,229 :: 		default:
L_BMS_ProcessData48:
;BMS.c,230 :: 		strcpy(_bmsData._chargeDischargeStatus, "Unknown");
	PUSH	W11
	MOV	#lo_addr(?lstr6_BMS), W11
	MOV	#lo_addr(__bmsData+220), W10
	CALL	_strcpy
	POP	W11
;BMS.c,231 :: 		break;
	GOTO	L_BMS_ProcessData44
;BMS.c,232 :: 		}
L_BMS_ProcessData43:
	MOV	[W14+2], W1
	MOV.B	[W1], W0
	CP.B	W0, #0
	BRA NZ	L__BMS_ProcessData152
	GOTO	L_BMS_ProcessData45
L__BMS_ProcessData152:
	MOV.B	[W1], W0
	CP.B	W0, #1
	BRA NZ	L__BMS_ProcessData153
	GOTO	L_BMS_ProcessData46
L__BMS_ProcessData153:
	MOV.B	[W1], W0
	CP.B	W0, #2
	BRA NZ	L__BMS_ProcessData154
	GOTO	L_BMS_ProcessData47
L__BMS_ProcessData154:
	GOTO	L_BMS_ProcessData48
L_BMS_ProcessData44:
;BMS.c,234 :: 		_bmsData._chargeMOS = _rxFrameBuffer[frameIndex][5];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W6
	ADD	W6, #5, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+190), W0
	MOV.B	W1, [W0]
;BMS.c,235 :: 		_bmsData._dischargeMOS = _rxFrameBuffer[frameIndex][6];
	ADD	W6, #6, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+191), W0
	MOV.B	W1, [W0]
;BMS.c,237 :: 		_bmsData._remainingCapacity = (float)((((uint32_t)_rxFrameBuffer[frameIndex][8] << 24) |
	ADD	W6, #8, W0
	ZE	[W0], W0
	CLR	W1
	SL	W0, #8, W3
	CLR	W2
;BMS.c,238 :: 		((uint32_t)_rxFrameBuffer[frameIndex][9] << 16) |
	ADD	W6, #9, W0
	ZE	[W0], W0
	CLR	W1
	MOV	W0, W1
	CLR	W0
	IOR	W2, W0, W4
	IOR	W3, W1, W5
;BMS.c,239 :: 		((uint32_t)_rxFrameBuffer[frameIndex][10] << 8) |
	ADD	W6, #10, W0
	ZE	[W0], W2
	CLR	W3
	SL	W3, #8, W1
	LSR	W2, #8, W0
	IOR	W0, W1, W1
	SL	W2, #8, W0
	IOR	W4, W0, W2
	IOR	W5, W1, W3
;BMS.c,240 :: 		_rxFrameBuffer[frameIndex][11])) / 1000.0;
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
;BMS.c,241 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,243 :: 		case STATUS_INFO:
L_BMS_ProcessData49:
;BMS.c,244 :: 		_bmsData._cellCount = _rxFrameBuffer[frameIndex][4];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W3
	ADD	W3, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+192
;BMS.c,245 :: 		_bmsData._ntcCount = _rxFrameBuffer[frameIndex][5];
	ADD	W3, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+108
;BMS.c,246 :: 		_bmsData._chargeState = _rxFrameBuffer[frameIndex][6];
	ADD	W3, #6, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+242), W0
	MOV.B	W1, [W0]
;BMS.c,247 :: 		_bmsData._loadState = _rxFrameBuffer[frameIndex][7];
	ADD	W3, #7, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+243), W0
	MOV.B	W1, [W0]
;BMS.c,248 :: 		_bmsData._cycleCount = (_rxFrameBuffer[frameIndex][9] << 8) | _rxFrameBuffer[frameIndex][10];
	ADD	W3, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W2
	ADD	W3, #10, W0
	ZE	[W0], W1
	MOV	#lo_addr(__bmsData+88), W0
	IOR	W2, W1, [W0]
;BMS.c,249 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,251 :: 		case CELL_VOLTAGES:
L_BMS_ProcessData50:
;BMS.c,252 :: 		for (i = 0; i < 3; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L_BMS_ProcessData51:
; i start address is: 8 (W4)
	CP.B	W4, #3
	BRA LTU	L__BMS_ProcessData155
	GOTO	L_BMS_ProcessData52
L__BMS_ProcessData155:
;BMS.c,254 :: 		cellIndex = frameIndex * 3 + i;
	ZE	W11, W1
	MOV	#3, W0
	MUL.UU	W1, W0, W2
	ZE	W4, W0
	ADD	W2, W0, W1
; cellIndex start address is: 10 (W5)
	MOV.B	W1, W5
;BMS.c,255 :: 		if (cellIndex < _bmsData._cellCount && cellIndex < MAX_CELL_COUNT) {
	MOV	#lo_addr(__bmsData+192), W0
	CP	W1, [W0]
	BRA LT	L__BMS_ProcessData156
	GOTO	L__BMS_ProcessData115
L__BMS_ProcessData156:
	CP.B	W5, #16
	BRA LTU	L__BMS_ProcessData157
	GOTO	L__BMS_ProcessData114
L__BMS_ProcessData157:
L__BMS_ProcessData113:
;BMS.c,256 :: 		tempValue = (_rxFrameBuffer[frameIndex][5 + i * 2] << 8) | _rxFrameBuffer[frameIndex][6 + i * 2];
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
;BMS.c,257 :: 		_bmsData._cellVoltages[cellIndex] = (float)tempValue / 1000.0;
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
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	POP.D	W10
	POP	W4
	MOV	[W14+2], W2
	MOV.D	W0, [W2]
;BMS.c,255 :: 		if (cellIndex < _bmsData._cellCount && cellIndex < MAX_CELL_COUNT) {
L__BMS_ProcessData115:
L__BMS_ProcessData114:
;BMS.c,252 :: 		for (i = 0; i < 3; i++) {
	INC.B	W4
;BMS.c,259 :: 		}
; i end address is: 8 (W4)
	GOTO	L_BMS_ProcessData51
L_BMS_ProcessData52:
;BMS.c,260 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,262 :: 		case CELL_TEMPERATURE:
L_BMS_ProcessData57:
;BMS.c,263 :: 		for (i = 0; i < 7; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
L_BMS_ProcessData58:
; i start address is: 8 (W4)
	CP.B	W4, #7
	BRA LTU	L__BMS_ProcessData158
	GOTO	L_BMS_ProcessData59
L__BMS_ProcessData158:
;BMS.c,265 :: 		sensorIndex = frameIndex * 7 + i;
	ZE	W11, W1
	MOV	#7, W0
	MUL.UU	W1, W0, W2
	ZE	W4, W0
	ADD	W2, W0, W1
; sensorIndex start address is: 4 (W2)
	MOV.B	W1, W2
;BMS.c,266 :: 		if (sensorIndex < _bmsData._ntcCount && sensorIndex < MAX_CELL_COUNT) {
	MOV	#lo_addr(__bmsData+108), W0
	CP	W1, [W0]
	BRA LT	L__BMS_ProcessData159
	GOTO	L__BMS_ProcessData117
L__BMS_ProcessData159:
	CP.B	W2, #16
	BRA LTU	L__BMS_ProcessData160
	GOTO	L__BMS_ProcessData116
L__BMS_ProcessData160:
L__BMS_ProcessData112:
;BMS.c,267 :: 		_bmsData._ntcTemperatures[sensorIndex] = (float)(_rxFrameBuffer[frameIndex][5 + i] - 40);
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
;BMS.c,266 :: 		if (sensorIndex < _bmsData._ntcCount && sensorIndex < MAX_CELL_COUNT) {
L__BMS_ProcessData117:
L__BMS_ProcessData116:
;BMS.c,263 :: 		for (i = 0; i < 7; i++) {
	INC.B	W4
;BMS.c,269 :: 		}
; i end address is: 8 (W4)
	GOTO	L_BMS_ProcessData58
L_BMS_ProcessData59:
;BMS.c,270 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,272 :: 		case CELL_BALANCE_STATE:
L_BMS_ProcessData64:
;BMS.c,273 :: 		for (i = 0; i < 6; i++) {
; i start address is: 14 (W7)
	CLR	W7
; i end address is: 14 (W7)
L_BMS_ProcessData65:
; i start address is: 14 (W7)
	CP.B	W7, #6
	BRA LTU	L__BMS_ProcessData161
	GOTO	L_BMS_ProcessData66
L__BMS_ProcessData161:
;BMS.c,276 :: 		cellIndex = i * 8;
	ZE	W7, W0
	SL	W0, #3, W0
; cellIndex start address is: 10 (W5)
	MOV.B	W0, W5
;BMS.c,277 :: 		for (j = 0; j < 8; j++) {
; j start address is: 12 (W6)
	CLR	W6
; j end address is: 12 (W6)
; i end address is: 14 (W7)
L_BMS_ProcessData68:
; j start address is: 12 (W6)
; cellIndex start address is: 10 (W5)
; cellIndex end address is: 10 (W5)
; i start address is: 14 (W7)
	CP.B	W6, #8
	BRA LTU	L__BMS_ProcessData162
	GOTO	L_BMS_ProcessData69
L__BMS_ProcessData162:
; cellIndex end address is: 10 (W5)
;BMS.c,278 :: 		if (cellIndex + j < _bmsData._cellCount && cellIndex + j < MAX_CELL_COUNT) {
; cellIndex start address is: 10 (W5)
	ZE	W5, W1
	ZE	W6, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(__bmsData+192), W0
	CP	W1, [W0]
	BRA LTU	L__BMS_ProcessData163
	GOTO	L__BMS_ProcessData119
L__BMS_ProcessData163:
	ZE	W5, W1
	ZE	W6, W0
	ADD	W1, W0, W0
	CP	W0, #16
	BRA LTU	L__BMS_ProcessData164
	GOTO	L__BMS_ProcessData118
L__BMS_ProcessData164:
L__BMS_ProcessData111:
;BMS.c,279 :: 		_bmsData._balanceStatus[cellIndex + j] = (_rxFrameBuffer[frameIndex][4 + i] >> j) & 0x01;
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
;BMS.c,278 :: 		if (cellIndex + j < _bmsData._cellCount && cellIndex + j < MAX_CELL_COUNT) {
L__BMS_ProcessData119:
L__BMS_ProcessData118:
;BMS.c,277 :: 		for (j = 0; j < 8; j++) {
	INC.B	W6
;BMS.c,281 :: 		}
; cellIndex end address is: 10 (W5)
; j end address is: 12 (W6)
	GOTO	L_BMS_ProcessData68
L_BMS_ProcessData69:
;BMS.c,273 :: 		for (i = 0; i < 6; i++) {
	INC.B	W7
;BMS.c,282 :: 		}
; i end address is: 14 (W7)
	GOTO	L_BMS_ProcessData65
L_BMS_ProcessData66:
;BMS.c,283 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,285 :: 		case FAILURE_CODES:
L_BMS_ProcessData74:
;BMS.c,286 :: 		_bmsData._errorCode = _rxFrameBuffer[frameIndex][4];
	ZE	W11, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__rxFrameBuffer), W0
	ADD	W0, W2, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+194), W0
	MOV.B	W1, [W0]
;BMS.c,287 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,289 :: 		default:
L_BMS_ProcessData75:
;BMS.c,290 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,291 :: 		_bmsData._errorCode = 5;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;BMS.c,292 :: 		break;
	GOTO	L_BMS_ProcessData36
;BMS.c,293 :: 		}
L_BMS_ProcessData35:
	MOV.B	#144, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData165
	GOTO	L_BMS_ProcessData37
L__BMS_ProcessData165:
	MOV.B	#145, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData166
	GOTO	L_BMS_ProcessData40
L__BMS_ProcessData166:
	MOV.B	#146, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData167
	GOTO	L_BMS_ProcessData41
L__BMS_ProcessData167:
	MOV.B	#147, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData168
	GOTO	L_BMS_ProcessData42
L__BMS_ProcessData168:
	MOV.B	#148, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData169
	GOTO	L_BMS_ProcessData49
L__BMS_ProcessData169:
	MOV.B	#149, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData170
	GOTO	L_BMS_ProcessData50
L__BMS_ProcessData170:
	MOV.B	#150, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData171
	GOTO	L_BMS_ProcessData57
L__BMS_ProcessData171:
	MOV.B	#151, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData172
	GOTO	L_BMS_ProcessData64
L__BMS_ProcessData172:
	MOV.B	#152, W0
	CP.B	W10, W0
	BRA NZ	L__BMS_ProcessData173
	GOTO	L_BMS_ProcessData74
L__BMS_ProcessData173:
	GOTO	L_BMS_ProcessData75
L_BMS_ProcessData36:
;BMS.c,294 :: 		}
L_end_BMS_ProcessData:
	POP	W10
	ULNK
	RETURN
; end of _BMS_ProcessData

_BMS_Update:
	LNK	#14

;BMS.c,296 :: 		uint8_t BMS_Update(void) {
;BMS.c,316 :: 		success = 0;
	PUSH	W10
	PUSH	W11
	CLR	W0
	MOV.B	W0, [W14+9]
;BMS.c,317 :: 		for (i = 0; i < 8; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_Update76:
; i start address is: 4 (W2)
	CP.B	W2, #8
	BRA LTU	L__BMS_Update175
	GOTO	L_BMS_Update77
L__BMS_Update175:
;BMS.c,318 :: 		payload[i] = 0;
	ADD	W14, #0, W1
	ZE	W2, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,317 :: 		for (i = 0; i < 8; i++) {
; i start address is: 0 (W0)
	ADD.B	W2, #1, W0
; i end address is: 4 (W2)
;BMS.c,319 :: 		}
	MOV.B	W0, W2
; i end address is: 0 (W0)
	GOTO	L_BMS_Update76
L_BMS_Update77:
;BMS.c,322 :: 		switch (commands[requestCounter]) {
	MOV	#lo_addr(BMS_requestCounter), W0
	ZE	[W0], W1
	MOV	#lo_addr(BMS_Update_commands_L0), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+12]
	GOTO	L_BMS_Update79
;BMS.c,323 :: 		case CELL_VOLTAGES:
L_BMS_Update81:
;BMS.c,324 :: 		framesExpected = (_bmsData._cellCount + 2) / 3;
	MOV	__bmsData+192, W0
	INC2	W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
; framesExpected start address is: 8 (W4)
	MOV.B	W0, W4
;BMS.c,325 :: 		break;
; framesExpected end address is: 8 (W4)
	GOTO	L_BMS_Update80
;BMS.c,326 :: 		case CELL_TEMPERATURE:
L_BMS_Update82:
;BMS.c,327 :: 		framesExpected = (_bmsData._ntcCount + 6) / 7;
	MOV	__bmsData+108, W0
	ADD	W0, #6, W0
	MOV	#7, W2
	REPEAT	#17
	DIV.S	W0, W2
; framesExpected start address is: 8 (W4)
	MOV.B	W0, W4
;BMS.c,328 :: 		break;
; framesExpected end address is: 8 (W4)
	GOTO	L_BMS_Update80
;BMS.c,329 :: 		case CELL_BALANCE_STATE:
L_BMS_Update83:
;BMS.c,330 :: 		framesExpected = (_bmsData._cellCount + 47) / 48;
	MOV	#47, W1
	MOV	#lo_addr(__bmsData+192), W0
	ADD	W1, [W0], W0
	MOV	#48, W2
	REPEAT	#17
	DIV.S	W0, W2
; framesExpected start address is: 8 (W4)
	MOV.B	W0, W4
;BMS.c,331 :: 		break;
; framesExpected end address is: 8 (W4)
	GOTO	L_BMS_Update80
;BMS.c,332 :: 		default:
L_BMS_Update84:
;BMS.c,333 :: 		framesExpected = 1;
; framesExpected start address is: 8 (W4)
	MOV.B	#1, W4
;BMS.c,334 :: 		break;
; framesExpected end address is: 8 (W4)
	GOTO	L_BMS_Update80
;BMS.c,335 :: 		}
L_BMS_Update79:
	MOV	[W14+12], W2
	MOV.B	[W2], W1
	MOV.B	#149, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_Update176
	GOTO	L_BMS_Update81
L__BMS_Update176:
	MOV.B	[W2], W1
	MOV.B	#150, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_Update177
	GOTO	L_BMS_Update82
L__BMS_Update177:
	MOV.B	[W2], W1
	MOV.B	#151, W0
	CP.B	W1, W0
	BRA NZ	L__BMS_Update178
	GOTO	L_BMS_Update83
L__BMS_Update178:
	GOTO	L_BMS_Update84
L_BMS_Update80:
;BMS.c,338 :: 		if (BMS_SendCommand(commands[requestCounter], payload)) {
; framesExpected start address is: 8 (W4)
	ADD	W14, #0, W2
	MOV	#lo_addr(BMS_requestCounter), W0
	ZE	[W0], W1
	MOV	#lo_addr(BMS_Update_commands_L0), W0
	ADD	W0, W1, W0
	MOV	W2, W11
	MOV.B	[W0], W10
	CALL	_BMS_SendCommand
	CP0.B	W0
	BRA NZ	L__BMS_Update179
	GOTO	L_BMS_Update85
L__BMS_Update179:
;BMS.c,340 :: 		framesReceived = BMS_ReceiveData(framesExpected);
	MOV.B	W4, W10
; framesExpected end address is: 8 (W4)
	CALL	_BMS_ReceiveData
	MOV.B	W0, [W14+8]
;BMS.c,343 :: 		if (framesReceived > 0) {
	CP.B	W0, #0
	BRA GTU	L__BMS_Update180
	GOTO	L_BMS_Update86
L__BMS_Update180:
;BMS.c,344 :: 		success = 1;
	MOV.B	#1, W0
	MOV.B	W0, [W14+9]
;BMS.c,345 :: 		for (i = 0; i < framesReceived; i++) {
; i start address is: 8 (W4)
	CLR	W4
; i end address is: 8 (W4)
	MOV.B	W4, W2
L_BMS_Update87:
; i start address is: 4 (W2)
	ADD	W14, #8, W0
	CP.B	W2, [W0]
	BRA LTU	L__BMS_Update181
	GOTO	L_BMS_Update88
L__BMS_Update181:
;BMS.c,346 :: 		if (BMS_ValidateChecksum(i)) {
	PUSH	W2
	MOV.B	W2, W10
	CALL	_BMS_ValidateChecksum
	POP	W2
	CP0.B	W0
	BRA NZ	L__BMS_Update182
	GOTO	L_BMS_Update90
L__BMS_Update182:
;BMS.c,347 :: 		BMS_ProcessData(commands[requestCounter], i);
	MOV	#lo_addr(BMS_requestCounter), W0
	ZE	[W0], W1
	MOV	#lo_addr(BMS_Update_commands_L0), W0
	ADD	W0, W1, W0
	PUSH	W2
	MOV.B	W2, W11
	MOV.B	[W0], W10
	CALL	_BMS_ProcessData
	POP	W2
;BMS.c,348 :: 		} else {
	GOTO	L_BMS_Update91
; i end address is: 4 (W2)
L_BMS_Update90:
;BMS.c,349 :: 		success = 0;
	CLR	W0
	MOV.B	W0, [W14+9]
;BMS.c,350 :: 		break;
	GOTO	L_BMS_Update88
;BMS.c,351 :: 		}
L_BMS_Update91:
;BMS.c,345 :: 		for (i = 0; i < framesReceived; i++) {
; i start address is: 8 (W4)
; i start address is: 4 (W2)
	ADD.B	W2, #1, W4
; i end address is: 4 (W2)
;BMS.c,352 :: 		}
	MOV.B	W4, W2
; i end address is: 8 (W4)
	GOTO	L_BMS_Update87
L_BMS_Update88:
;BMS.c,353 :: 		}
L_BMS_Update86:
;BMS.c,354 :: 		}
L_BMS_Update85:
;BMS.c,357 :: 		if (!success) {
	ADD	W14, #9, W0
	CP0.B	[W0]
	BRA Z	L__BMS_Update183
	GOTO	L_BMS_Update92
L__BMS_Update183:
;BMS.c,358 :: 		errorCounter++;
	MOV.B	#1, W1
	MOV	#lo_addr(BMS_errorCounter), W0
	ADD.B	W1, [W0], [W0]
;BMS.c,359 :: 		if (errorCounter >= 10) {
	MOV	#lo_addr(BMS_errorCounter), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA GEU	L__BMS_Update184
	GOTO	L_BMS_Update93
L__BMS_Update184:
;BMS.c,360 :: 		BMS_ClearData();
	CALL	_BMS_ClearData
;BMS.c,361 :: 		requestCounter = 0;
	MOV	#lo_addr(BMS_requestCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,362 :: 		errorCounter = 0;
	MOV	#lo_addr(BMS_errorCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,363 :: 		strcpy(_bmsData._chargeDischargeStatus, "offline");
	MOV	#lo_addr(?lstr7_BMS), W11
	MOV	#lo_addr(__bmsData+220), W10
	CALL	_strcpy
;BMS.c,364 :: 		return 0;
	CLR	W0
	GOTO	L_end_BMS_Update
;BMS.c,365 :: 		}
L_BMS_Update93:
;BMS.c,366 :: 		} else {
	GOTO	L_BMS_Update94
L_BMS_Update92:
;BMS.c,367 :: 		errorCounter = 0;
	MOV	#lo_addr(BMS_errorCounter), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,368 :: 		strcpy(_bmsData._chargeDischargeStatus, "online");
	MOV	#lo_addr(?lstr8_BMS), W11
	MOV	#lo_addr(__bmsData+220), W10
	CALL	_strcpy
;BMS.c,369 :: 		}
L_BMS_Update94:
;BMS.c,372 :: 		requestCounter = (requestCounter + 1) % commandCount;
	MOV	#lo_addr(BMS_requestCounter), W0
	ZE	[W0], W0
	INC	W0
	MOV	#9, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(BMS_requestCounter), W0
	MOV.B	W1, [W0]
;BMS.c,374 :: 		return success;
	MOV.B	[W14+9], W0
;BMS.c,375 :: 		}
;BMS.c,374 :: 		return success;
;BMS.c,375 :: 		}
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

;BMS.c,377 :: 		void _UART1_Interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
;BMS.c,380 :: 		while (UART1_Data_Ready()) {
L__UART1_Interrupt95:
	CALL	_UART1_Data_Ready
	CP0	W0
	BRA NZ	L___UART1_Interrupt186
	GOTO	L__UART1_Interrupt96
L___UART1_Interrupt186:
;BMS.c,381 :: 		byte = UART1_Read();
	CALL	_UART1_Read
; byte start address is: 8 (W4)
	MOV.B	W0, W4
;BMS.c,383 :: 		if (!_frameStarted && byte == START_BYTE) {
	MOV	#lo_addr(BMS__frameStarted), W0
	CP0.B	[W0]
	BRA Z	L___UART1_Interrupt187
	GOTO	L___UART1_Interrupt123
L___UART1_Interrupt187:
	MOV.B	#165, W0
	CP.B	W4, W0
	BRA Z	L___UART1_Interrupt188
	GOTO	L___UART1_Interrupt122
L___UART1_Interrupt188:
L___UART1_Interrupt121:
;BMS.c,384 :: 		_frameStarted = 1;
	MOV	#lo_addr(BMS__frameStarted), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,385 :: 		_currentByteIndex = 0;
	MOV	#lo_addr(BMS__currentByteIndex), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,386 :: 		if (_currentFrameIndex < _RX_FRAME_COUNT) {
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA LTU	L___UART1_Interrupt189
	GOTO	L__UART1_Interrupt100
L___UART1_Interrupt189:
;BMS.c,387 :: 		_rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
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
;BMS.c,388 :: 		_currentByteIndex++;
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	W1, [W0]
;BMS.c,389 :: 		}
L__UART1_Interrupt100:
;BMS.c,390 :: 		} else if (_frameStarted) {
	GOTO	L__UART1_Interrupt101
;BMS.c,383 :: 		if (!_frameStarted && byte == START_BYTE) {
L___UART1_Interrupt123:
; byte start address is: 8 (W4)
L___UART1_Interrupt122:
;BMS.c,390 :: 		} else if (_frameStarted) {
	MOV	#lo_addr(BMS__frameStarted), W0
	CP0.B	[W0]
	BRA NZ	L___UART1_Interrupt190
	GOTO	L__UART1_Interrupt102
L___UART1_Interrupt190:
;BMS.c,391 :: 		if (_currentFrameIndex < _RX_FRAME_COUNT && _currentByteIndex < _RX_FRAME_SIZE) {
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA LTU	L___UART1_Interrupt191
	GOTO	L___UART1_Interrupt125
L___UART1_Interrupt191:
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA LTU	L___UART1_Interrupt192
	GOTO	L___UART1_Interrupt124
L___UART1_Interrupt192:
L___UART1_Interrupt120:
;BMS.c,392 :: 		_rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
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
;BMS.c,393 :: 		_currentByteIndex++;
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	W1, [W0]
;BMS.c,395 :: 		if (_currentByteIndex >= _RX_FRAME_SIZE) {
	MOV	#lo_addr(BMS__currentByteIndex), W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA GEU	L___UART1_Interrupt193
	GOTO	L__UART1_Interrupt106
L___UART1_Interrupt193:
;BMS.c,396 :: 		_framesReceived++;
	MOV	#lo_addr(BMS__framesReceived), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__framesReceived), W0
	MOV.B	W1, [W0]
;BMS.c,397 :: 		_currentFrameIndex++;
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	[W0], W0
	ADD.B	W0, #1, W1
	MOV	#lo_addr(BMS__currentFrameIndex), W0
	MOV.B	W1, [W0]
;BMS.c,398 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,399 :: 		}
L__UART1_Interrupt106:
;BMS.c,400 :: 		} else {
	GOTO	L__UART1_Interrupt107
;BMS.c,391 :: 		if (_currentFrameIndex < _RX_FRAME_COUNT && _currentByteIndex < _RX_FRAME_SIZE) {
L___UART1_Interrupt125:
L___UART1_Interrupt124:
;BMS.c,401 :: 		_frameStarted = 0;
	MOV	#lo_addr(BMS__frameStarted), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,402 :: 		_bmsData._errorCount++;
	MOV	__bmsData+196, W0
	INC	W0
	MOV	W0, __bmsData+196
;BMS.c,403 :: 		_bmsData._errorCode = 7;
	MOV	#lo_addr(__bmsData+194), W1
	MOV.B	#7, W0
	MOV.B	W0, [W1]
;BMS.c,404 :: 		}
L__UART1_Interrupt107:
;BMS.c,405 :: 		}
L__UART1_Interrupt102:
L__UART1_Interrupt101:
;BMS.c,406 :: 		}
	GOTO	L__UART1_Interrupt95
L__UART1_Interrupt96:
;BMS.c,408 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;BMS.c,409 :: 		}
L_end__UART1_Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of __UART1_Interrupt
