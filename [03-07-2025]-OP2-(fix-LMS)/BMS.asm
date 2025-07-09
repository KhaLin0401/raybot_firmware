
_TX_PushCommand:

;BMS.c,17 :: 		void TX_PushCommand(uint8_t _commandID, uint8_t * _payload) {
;BMS.c,18 :: 		int _next = (_txBufferHead + 1) % _TX_BUFFER_SIZE;
	PUSH	W10
	PUSH	W12
	MOV	#lo_addr(__txBufferHead), W0
	ZE	[W0], W0
	INC	W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
; _next start address is: 8 (W4)
	MOV	W1, W4
;BMS.c,19 :: 		if (_next != _txBufferTail) {  // N?u kh?ng d?y
	MOV	#lo_addr(__txBufferTail), W0
	ZE	[W0], W0
	CP	W1, W0
	BRA NZ	L__TX_PushCommand123
	GOTO	L_TX_PushCommand0
L__TX_PushCommand123:
;BMS.c,20 :: 		_txBuffer[_txBufferHead]._commandID = _commandID;
	MOV	#lo_addr(__txBufferHead), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__txBuffer), W0
	ADD	W0, W2, W0
	MOV.B	W10, [W0]
;BMS.c,21 :: 		memcpy(_txBuffer[_txBufferHead]._payload, _payload, 8);
	MOV	#lo_addr(__txBufferHead), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__txBuffer), W0
	ADD	W0, W2, W0
	INC	W0
	MOV	#8, W12
	MOV	W0, W10
	CALL	_memcpy
;BMS.c,22 :: 		_txBufferHead = _next;
	MOV	#lo_addr(__txBufferHead), W0
	MOV.B	W4, [W0]
; _next end address is: 8 (W4)
;BMS.c,23 :: 		}
L_TX_PushCommand0:
;BMS.c,24 :: 		}
L_end_TX_PushCommand:
	POP	W12
	POP	W10
	RETURN
; end of _TX_PushCommand

_TX_IsEmpty:

;BMS.c,26 :: 		uint8_t TX_IsEmpty(void) {
;BMS.c,27 :: 		return (_txBufferHead == _txBufferTail);
	MOV	#lo_addr(__txBufferHead), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__txBufferTail), W0
	CP.B	W1, [W0]
	CLR.B	W0
	BRA NZ	L__TX_IsEmpty125
	INC.B	W0
L__TX_IsEmpty125:
;BMS.c,28 :: 		}
L_end_TX_IsEmpty:
	RETURN
; end of _TX_IsEmpty

_TX_PopCommand:
	LNK	#12

;BMS.c,30 :: 		TXCommand TX_PopCommand(void) {
;BMS.c,32 :: 		memset(&_cmd, 0, sizeof(TXCommand));
	PUSH	W10
	PUSH	W11
	PUSH	W12
	ADD	W14, #2, W0
	MOV	#9, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
;BMS.c,33 :: 		if (_txBufferHead != _txBufferTail) {
	MOV	#lo_addr(__txBufferHead), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__txBufferTail), W0
	CP.B	W1, [W0]
	BRA NZ	L__TX_PopCommand127
	GOTO	L_TX_PopCommand1
L__TX_PopCommand127:
;BMS.c,34 :: 		memcpy(&_cmd, &_txBuffer[_txBufferTail], sizeof(TXCommand));
	MOV	#lo_addr(__txBufferTail), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__txBuffer), W0
	ADD	W0, W2, W1
	ADD	W14, #2, W0
	MOV	#9, W12
	MOV	W1, W11
	MOV	W0, W10
	CALL	_memcpy
;BMS.c,35 :: 		_txBufferTail = (_txBufferTail + 1) % _TX_BUFFER_SIZE;
	MOV	#lo_addr(__txBufferTail), W0
	ZE	[W0], W0
	INC	W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(__txBufferTail), W0
	MOV.B	W1, [W0]
;BMS.c,36 :: 		}
L_TX_PopCommand1:
;BMS.c,37 :: 		return _cmd;
	ADD	W14, #2, W1
	MOV	[W14+0], W0
	REPEAT	#8
	MOV.B	[W1++], [W0++]
;BMS.c,38 :: 		}
;BMS.c,37 :: 		return _cmd;
;BMS.c,38 :: 		}
L_end_TX_PopCommand:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _TX_PopCommand

_Immediate_PushCommand:

;BMS.c,47 :: 		void Immediate_PushCommand(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
;BMS.c,54 :: 		int _next = (_immediateQueueHead + 1) % _IMMEDIATE_QUEUE_SIZE;
	PUSH	W10
	MOV	#lo_addr(__immediateQueueHead), W0
	ZE	[W0], W0
	INC	W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
; _next start address is: 8 (W4)
	MOV	W1, W4
;BMS.c,56 :: 		if (_next != _immediateQueueTail) {
	MOV	#lo_addr(__immediateQueueTail), W0
	ZE	[W0], W0
	CP	W1, W0
	BRA NZ	L__Immediate_PushCommand129
	GOTO	L_Immediate_PushCommand2
L__Immediate_PushCommand129:
;BMS.c,57 :: 		_immediateQueue[_immediateQueueHead]._commandID = _commandID;
	MOV	#lo_addr(__immediateQueueHead), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__immediateQueue), W0
	ADD	W0, W2, W0
	MOV.B	W10, [W0]
;BMS.c,58 :: 		memcpy(_immediateQueue[_immediateQueueHead]._payload, _payload, 7);
	MOV	#lo_addr(__immediateQueueHead), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__immediateQueue), W0
	ADD	W0, W2, W0
	INC	W0
	PUSH	W12
	MOV	#7, W12
	MOV	W0, W10
	CALL	_memcpy
	POP	W12
;BMS.c,59 :: 		_immediateQueue[_immediateQueueHead]._value = _value;
	MOV	#lo_addr(__immediateQueueHead), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__immediateQueue), W0
	ADD	W0, W2, W0
	ADD	W0, #8, W0
	MOV.B	W12, [W0]
;BMS.c,60 :: 		_immediateQueueHead = _next;
	MOV	#lo_addr(__immediateQueueHead), W0
	MOV.B	W4, [W0]
; _next end address is: 8 (W4)
;BMS.c,61 :: 		} else {
	GOTO	L_Immediate_PushCommand3
L_Immediate_PushCommand2:
;BMS.c,63 :: 		DebugUART_Send_Text("Immediate Queue Full!\r\n");
	MOV	#lo_addr(?lstr_1_BMS), W10
	CALL	_DebugUART_Send_Text
;BMS.c,64 :: 		}
L_Immediate_PushCommand3:
;BMS.c,65 :: 		}
L_end_Immediate_PushCommand:
	POP	W10
	RETURN
; end of _Immediate_PushCommand

_Immediate_IsEmpty:

;BMS.c,67 :: 		uint8_t Immediate_IsEmpty(void) {
;BMS.c,68 :: 		return (_immediateQueueHead == _immediateQueueTail);
	MOV	#lo_addr(__immediateQueueHead), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__immediateQueueTail), W0
	CP.B	W1, [W0]
	CLR.B	W0
	BRA NZ	L__Immediate_IsEmpty131
	INC.B	W0
L__Immediate_IsEmpty131:
;BMS.c,69 :: 		}
L_end_Immediate_IsEmpty:
	RETURN
; end of _Immediate_IsEmpty

_Immediate_PopCommand:
	LNK	#42

;BMS.c,71 :: 		ImmediateCommand Immediate_PopCommand(void) {
;BMS.c,81 :: 		memset(&_cmd, 0, sizeof(ImmediateCommand));
	PUSH	W10
	PUSH	W11
	PUSH	W12
	ADD	W14, #2, W0
	MOV	#9, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
;BMS.c,84 :: 		if (_immediateQueueHead != _immediateQueueTail) {
	MOV	#lo_addr(__immediateQueueHead), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__immediateQueueTail), W0
	CP.B	W1, [W0]
	BRA NZ	L__Immediate_PopCommand133
	GOTO	L_Immediate_PopCommand4
L__Immediate_PopCommand133:
;BMS.c,85 :: 		memcpy(&_cmd, &_immediateQueue[_immediateQueueTail], sizeof(ImmediateCommand));
	MOV	#lo_addr(__immediateQueueTail), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.UU	W0, W1, W2
	MOV	#lo_addr(__immediateQueue), W0
	ADD	W0, W2, W1
	ADD	W14, #2, W0
	MOV	#9, W12
	MOV	W1, W11
	MOV	W0, W10
	CALL	_memcpy
;BMS.c,86 :: 		_immediateQueueTail = (_immediateQueueTail + 1) % _IMMEDIATE_QUEUE_SIZE;
	MOV	#lo_addr(__immediateQueueTail), W0
	ZE	[W0], W0
	INC	W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(__immediateQueueTail), W0
	MOV.B	W1, [W0]
;BMS.c,87 :: 		}
L_Immediate_PopCommand4:
;BMS.c,88 :: 		DebugUART_Send_Text("chdebug da nhay vao day \n");
	MOV	#lo_addr(?lstr_2_BMS), W10
	CALL	_DebugUART_Send_Text
;BMS.c,89 :: 		sprintf(debug_cmd, "CMDID: %d, CMDVL: %d", _cmd._commandID, _cmd._value);
	ADD	W14, #11, W1
	ADD	W14, #10, W0
	ZE	[W0], W0
	PUSH	W0
	ADD	W14, #2, W0
	ZE	[W0], W0
	PUSH	W0
	MOV	#lo_addr(?lstr_3_BMS), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#8, W15
;BMS.c,90 :: 		DebugUART_Send_Text("\n");
	MOV	#lo_addr(?lstr_4_BMS), W10
	CALL	_DebugUART_Send_Text
;BMS.c,91 :: 		return _cmd;
	ADD	W14, #2, W1
	MOV	[W14+0], W0
	REPEAT	#8
	MOV.B	[W1++], [W0++]
;BMS.c,92 :: 		}
;BMS.c,91 :: 		return _cmd;
;BMS.c,92 :: 		}
L_end_Immediate_PopCommand:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _Immediate_PopCommand

_RX_PushByte:

;BMS.c,101 :: 		void RX_PushByte(uint8_t _data) {
;BMS.c,102 :: 		int _next = (_rxBufferHead + 1) % _RX_BUFFER_SIZE;
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W0
	INC	W0
	MOV	#50, W2
	REPEAT	#17
	DIV.S	W0, W2
; _next start address is: 6 (W3)
	MOV	W1, W3
;BMS.c,103 :: 		if (_next != _rxBufferTail) {
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W0
	CP	W1, W0
	BRA NZ	L__RX_PushByte135
	GOTO	L_RX_PushByte5
L__RX_PushByte135:
;BMS.c,104 :: 		_rxBuffer[_rxBufferHead] = _data;
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W1
	MOV	#lo_addr(__rxBuffer), W0
	ADD	W0, W1, W0
	MOV.B	W10, [W0]
;BMS.c,105 :: 		_rxBufferHead = _next;
	MOV	#lo_addr(__rxBufferHead), W0
	MOV.B	W3, [W0]
; _next end address is: 6 (W3)
;BMS.c,106 :: 		}
L_RX_PushByte5:
;BMS.c,107 :: 		}
L_end_RX_PushByte:
	RETURN
; end of _RX_PushByte

_RX_PopBytes:

;BMS.c,109 :: 		int RX_PopBytes(uint8_t * _buffer, uint16_t _length) {
;BMS.c,111 :: 		if (_rxBufferHead >= _rxBufferTail)
	MOV	#lo_addr(__rxBufferHead), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__rxBufferTail), W0
	CP.B	W1, [W0]
	BRA GEU	L__RX_PopBytes137
	GOTO	L_RX_PopBytes6
L__RX_PopBytes137:
;BMS.c,112 :: 		_available = _rxBufferHead - _rxBufferTail;
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W1
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W0
; _available start address is: 0 (W0)
	SUB	W1, W0, W0
; _available end address is: 0 (W0)
	GOTO	L_RX_PopBytes7
L_RX_PopBytes6:
;BMS.c,114 :: 		_available = _RX_BUFFER_SIZE - _rxBufferTail + _rxBufferHead;
	MOV	#50, W1
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W0
	SUB	W1, W0, W1
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W0
; _available start address is: 0 (W0)
	ADD	W1, W0, W0
; _available end address is: 0 (W0)
L_RX_PopBytes7:
;BMS.c,115 :: 		if (_available < _length)
; _available start address is: 0 (W0)
	CP	W0, W11
	BRA LTU	L__RX_PopBytes138
	GOTO	L_RX_PopBytes8
L__RX_PopBytes138:
; _available end address is: 0 (W0)
;BMS.c,116 :: 		return 0;  // Kh?ng d? d? li?u
	CLR	W0
	GOTO	L_end_RX_PopBytes
L_RX_PopBytes8:
;BMS.c,119 :: 		for (_i = 0; _i < _length; _i++) {
; _i start address is: 6 (W3)
	CLR	W3
; _i end address is: 6 (W3)
L_RX_PopBytes9:
; _i start address is: 6 (W3)
	CP	W3, W11
	BRA LTU	L__RX_PopBytes139
	GOTO	L_RX_PopBytes10
L__RX_PopBytes139:
;BMS.c,120 :: 		_buffer[_i] = _rxBuffer[_rxBufferTail];
	ADD	W10, W3, W2
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W1
	MOV	#lo_addr(__rxBuffer), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;BMS.c,121 :: 		_rxBufferTail = (_rxBufferTail + 1) % _RX_BUFFER_SIZE;
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W0
	INC	W0
	MOV	#50, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	#lo_addr(__rxBufferTail), W0
	MOV.B	W1, [W0]
;BMS.c,119 :: 		for (_i = 0; _i < _length; _i++) {
	INC	W3
;BMS.c,122 :: 		}
; _i end address is: 6 (W3)
	GOTO	L_RX_PopBytes9
L_RX_PopBytes10:
;BMS.c,124 :: 		return _length;
	MOV	W11, W0
;BMS.c,125 :: 		}
L_end_RX_PopBytes:
	RETURN
; end of _RX_PopBytes

_RX_PeekBytes:

;BMS.c,127 :: 		int RX_PeekBytes(uint8_t * _buffer, uint16_t _length) {
;BMS.c,129 :: 		if (_rxBufferHead >= _rxBufferTail)
	MOV	#lo_addr(__rxBufferHead), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__rxBufferTail), W0
	CP.B	W1, [W0]
	BRA GEU	L__RX_PeekBytes141
	GOTO	L_RX_PeekBytes12
L__RX_PeekBytes141:
;BMS.c,130 :: 		_available = _rxBufferHead - _rxBufferTail;
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W1
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W0
; _available start address is: 0 (W0)
	SUB	W1, W0, W0
; _available end address is: 0 (W0)
	GOTO	L_RX_PeekBytes13
L_RX_PeekBytes12:
;BMS.c,132 :: 		_available = _RX_BUFFER_SIZE - _rxBufferTail + _rxBufferHead;
	MOV	#50, W1
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W0
	SUB	W1, W0, W1
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W0
; _available start address is: 0 (W0)
	ADD	W1, W0, W0
; _available end address is: 0 (W0)
L_RX_PeekBytes13:
;BMS.c,133 :: 		if (_available < _length)
; _available start address is: 0 (W0)
	CP	W0, W11
	BRA LTU	L__RX_PeekBytes142
	GOTO	L_RX_PeekBytes14
L__RX_PeekBytes142:
; _available end address is: 0 (W0)
;BMS.c,134 :: 		return 0;
	CLR	W0
	GOTO	L_end_RX_PeekBytes
L_RX_PeekBytes14:
;BMS.c,137 :: 		uint8_t _idx = _rxBufferTail;
	MOV	#lo_addr(__rxBufferTail), W0
; _idx start address is: 8 (W4)
	MOV.B	[W0], W4
;BMS.c,138 :: 		for (_i = 0; _i < _length; _i++) {
; _i start address is: 6 (W3)
	CLR	W3
; _idx end address is: 8 (W4)
; _i end address is: 6 (W3)
L_RX_PeekBytes15:
; _i start address is: 6 (W3)
; _idx start address is: 8 (W4)
	CP	W3, W11
	BRA LTU	L__RX_PeekBytes143
	GOTO	L_RX_PeekBytes16
L__RX_PeekBytes143:
;BMS.c,139 :: 		_buffer[_i] = _rxBuffer[_idx];
	ADD	W10, W3, W2
	ZE	W4, W1
	MOV	#lo_addr(__rxBuffer), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;BMS.c,140 :: 		_idx = (_idx + 1) % _RX_BUFFER_SIZE;
	ZE	W4, W0
; _idx end address is: 8 (W4)
	INC	W0
	MOV	#50, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W1, W0
; _idx start address is: 8 (W4)
	MOV.B	W0, W4
;BMS.c,138 :: 		for (_i = 0; _i < _length; _i++) {
	INC	W3
;BMS.c,141 :: 		}
; _idx end address is: 8 (W4)
; _i end address is: 6 (W3)
	GOTO	L_RX_PeekBytes15
L_RX_PeekBytes16:
;BMS.c,143 :: 		return _length;
	MOV	W11, W0
;BMS.c,144 :: 		}
L_end_RX_PeekBytes:
	RETURN
; end of _RX_PeekBytes

BMS__getEndMarker:

;BMS.c,156 :: 		static uint8_t _getEndMarker(uint8_t _commandID) {
;BMS.c,157 :: 		if (_commandID >= 0x90 && _commandID <= 0x99)
	MOV.B	#144, W0
	CP.B	W10, W0
	BRA GEU	L_BMS__getEndMarker145
	GOTO	L_BMS__getEndMarker116
L_BMS__getEndMarker145:
	MOV.B	#153, W0
	CP.B	W10, W0
	BRA LEU	L_BMS__getEndMarker146
	GOTO	L_BMS__getEndMarker115
L_BMS__getEndMarker146:
L_BMS__getEndMarker114:
;BMS.c,158 :: 		return 0x7D + (_commandID - 0x90);
	ZE	W10, W1
	MOV	#144, W0
	SUB	W1, W0, W1
	MOV	#125, W0
	ADD	W0, W1, W0
	GOTO	L_end__getEndMarker
;BMS.c,157 :: 		if (_commandID >= 0x90 && _commandID <= 0x99)
L_BMS__getEndMarker116:
L_BMS__getEndMarker115:
;BMS.c,159 :: 		else if (_commandID == 0xD8)
	MOV.B	#216, W0
	CP.B	W10, W0
	BRA Z	L_BMS__getEndMarker147
	GOTO	L_BMS__getEndMarker22
L_BMS__getEndMarker147:
;BMS.c,160 :: 		return 0xC5;
	MOV.B	#197, W0
	GOTO	L_end__getEndMarker
L_BMS__getEndMarker22:
;BMS.c,161 :: 		else if (_commandID == 0xE3)
	MOV.B	#227, W0
	CP.B	W10, W0
	BRA Z	L_BMS__getEndMarker148
	GOTO	L_BMS__getEndMarker24
L_BMS__getEndMarker148:
;BMS.c,162 :: 		return 0x58;
	MOV.B	#88, W0
	GOTO	L_end__getEndMarker
L_BMS__getEndMarker24:
;BMS.c,164 :: 		return 0x7D;
	MOV.B	#125, W0
;BMS.c,165 :: 		}
L_end__getEndMarker:
	RETURN
; end of BMS__getEndMarker

BMS__sendCommandPacket:
	LNK	#126

;BMS.c,171 :: 		static void _sendCommandPacket(uint8_t _commandID, uint8_t * _payload) {
;BMS.c,174 :: 		char _dbgStr[100] = ""; // Buffer debug d? ch?a chu?i hex
	PUSH	W12
	ADD	W14, #23, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, 52
	MOV	#lo_addr(?ICSBMS__sendCommandPacket__dbgStr_L0), W0
	REPEAT	#99
	MOV.B	[W0++], [W1++]
;BMS.c,177 :: 		_packet[0] = 0xA5;                      // Start Marker
	ADD	W14, #10, W2
	MOV.B	#165, W0
	MOV.B	W0, [W2]
;BMS.c,178 :: 		_packet[1] = 0x40;                      // Command Code khi g?i (m?c d?nh 0x40)
	ADD	W2, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,179 :: 		_packet[2] = _commandID;                // Parameter Identifier
	ADD	W2, #2, W0
	MOV.B	W10, [W0]
;BMS.c,180 :: 		_packet[3] = 0x08;                      // Data Length = 8 byte
	ADD	W2, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,181 :: 		memcpy(&_packet[4], _payload, 8);        // Copy payload (8 byte)
	ADD	W2, #4, W0
	PUSH	W10
	MOV	#8, W12
	MOV	W0, W10
	CALL	_memcpy
	POP	W10
;BMS.c,182 :: 		_packet[12] = _getEndMarker(_commandID); // End Marker du?c t?nh theo CommandID
	ADD	W14, #10, W0
	ADD	W0, #12, W0
	MOV	W0, [W14+124]
	CALL	BMS__getEndMarker
	MOV	[W14+124], W1
	MOV.B	W0, [W1]
;BMS.c,185 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
; _i start address is: 4 (W2)
	CLR	W2
; _i end address is: 4 (W2)
L_BMS__sendCommandPacket26:
; _i start address is: 4 (W2)
	CP.B	W2, #13
	BRA LTU	L_BMS__sendCommandPacket150
	GOTO	L_BMS__sendCommandPacket27
L_BMS__sendCommandPacket150:
;BMS.c,186 :: 		UART1_Write(_packet[_i]);
	ADD	W14, #10, W1
	ZE	W2, W0
	ADD	W1, W0, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;BMS.c,185 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
	INC.B	W2
;BMS.c,187 :: 		}
; _i end address is: 4 (W2)
	GOTO	L_BMS__sendCommandPacket26
L_BMS__sendCommandPacket27:
;BMS.c,190 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
; _i start address is: 4 (W2)
	CLR	W2
; _i end address is: 4 (W2)
L_BMS__sendCommandPacket29:
; _i start address is: 4 (W2)
	CP.B	W2, #13
	BRA LTU	L_BMS__sendCommandPacket151
	GOTO	L_BMS__sendCommandPacket30
L_BMS__sendCommandPacket151:
;BMS.c,192 :: 		sprintf(temp, "0x%02X ", _packet[_i]);
	ADD	W14, #10, W1
	ZE	W2, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ADD	W14, #0, W1
	ZE	W0, W0
	PUSH	W2
	PUSH.D	W10
	PUSH	W0
	MOV	#lo_addr(?lstr_5_BMS), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;BMS.c,193 :: 		strcat(_dbgStr, temp);
	ADD	W14, #0, W1
	ADD	W14, #23, W0
	MOV	W1, W11
	MOV	W0, W10
	CALL	_strcat
	POP.D	W10
	POP	W2
;BMS.c,190 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
	INC.B	W2
;BMS.c,194 :: 		}
; _i end address is: 4 (W2)
	GOTO	L_BMS__sendCommandPacket29
L_BMS__sendCommandPacket30:
;BMS.c,195 :: 		strcat(_dbgStr, "\r\n");
	ADD	W14, #23, W0
	PUSH.D	W10
	MOV	#lo_addr(?lstr6_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP.D	W10
;BMS.c,197 :: 		}
L_end__sendCommandPacket:
	POP	W12
	ULNK
	RETURN
; end of BMS__sendCommandPacket

BMS__sendSetCommandPacket:
	LNK	#126

;BMS.c,198 :: 		static void _sendSetCommandPacket(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
;BMS.c,201 :: 		char _dbgStr[100] = ""; // Buffer debug d? ch?a chu?i hex
	ADD	W14, #23, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, 52
	MOV	#lo_addr(?ICSBMS__sendSetCommandPacket__dbgStr_L0), W0
	REPEAT	#99
	MOV.B	[W0++], [W1++]
;BMS.c,204 :: 		_packet[0] = 0xA5;                      // Start Marker
	ADD	W14, #10, W2
	MOV.B	#165, W0
	MOV.B	W0, [W2]
;BMS.c,205 :: 		_packet[1] = 0x40;                      // Command Code khi g?i (m?c d?nh 0x40)
	ADD	W2, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,206 :: 		_packet[2] = _commandID;                // Parameter Identifier
	ADD	W2, #2, W0
	MOV.B	W10, [W0]
;BMS.c,207 :: 		_packet[3] = 0x08;
	ADD	W2, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,208 :: 		_packet[4] = _value;                      // Data Length = 8 byte
	ADD	W2, #4, W0
	MOV.B	W12, [W0]
;BMS.c,209 :: 		memcpy(&_packet[5], _payload, 7);        // Copy payload (8 byte)
	ADD	W2, #5, W0
	PUSH	W12
	PUSH	W10
	MOV	#7, W12
	MOV	W0, W10
	CALL	_memcpy
	POP	W10
	POP	W12
;BMS.c,210 :: 		if(_commandID == 0xD9){
	MOV.B	#217, W0
	CP.B	W10, W0
	BRA Z	L_BMS__sendSetCommandPacket153
	GOTO	L_BMS__sendSetCommandPacket32
L_BMS__sendSetCommandPacket153:
;BMS.c,211 :: 		if(_value == 0x00)
	CP.B	W12, #0
	BRA Z	L_BMS__sendSetCommandPacket154
	GOTO	L_BMS__sendSetCommandPacket33
L_BMS__sendSetCommandPacket154:
;BMS.c,212 :: 		_packet[12] = 0xC6;
	ADD	W14, #10, W0
	ADD	W0, #12, W1
	MOV.B	#198, W0
	MOV.B	W0, [W1]
	GOTO	L_BMS__sendSetCommandPacket34
L_BMS__sendSetCommandPacket33:
;BMS.c,213 :: 		else if (_value == 0x01)
	CP.B	W12, #1
	BRA Z	L_BMS__sendSetCommandPacket155
	GOTO	L_BMS__sendSetCommandPacket35
L_BMS__sendSetCommandPacket155:
;BMS.c,214 :: 		_packet[12] = 0xC7;
	ADD	W14, #10, W0
	ADD	W0, #12, W1
	MOV.B	#199, W0
	MOV.B	W0, [W1]
	GOTO	L_BMS__sendSetCommandPacket36
L_BMS__sendSetCommandPacket35:
;BMS.c,215 :: 		else return;
	GOTO	L_end__sendSetCommandPacket
L_BMS__sendSetCommandPacket36:
L_BMS__sendSetCommandPacket34:
;BMS.c,216 :: 		}
	GOTO	L_BMS__sendSetCommandPacket37
L_BMS__sendSetCommandPacket32:
;BMS.c,217 :: 		else if(_commandID == 0xDA){
	MOV.B	#218, W0
	CP.B	W10, W0
	BRA Z	L_BMS__sendSetCommandPacket156
	GOTO	L_BMS__sendSetCommandPacket38
L_BMS__sendSetCommandPacket156:
;BMS.c,218 :: 		if(_value == 0x00)
	CP.B	W12, #0
	BRA Z	L_BMS__sendSetCommandPacket157
	GOTO	L_BMS__sendSetCommandPacket39
L_BMS__sendSetCommandPacket157:
;BMS.c,219 :: 		_packet[12] = 0xC7;
	ADD	W14, #10, W0
	ADD	W0, #12, W1
	MOV.B	#199, W0
	MOV.B	W0, [W1]
	GOTO	L_BMS__sendSetCommandPacket40
L_BMS__sendSetCommandPacket39:
;BMS.c,220 :: 		else if(_value == 0x01)
	CP.B	W12, #1
	BRA Z	L_BMS__sendSetCommandPacket158
	GOTO	L_BMS__sendSetCommandPacket41
L_BMS__sendSetCommandPacket158:
;BMS.c,221 :: 		_packet[12] = 0xC8;
	ADD	W14, #10, W0
	ADD	W0, #12, W1
	MOV.B	#200, W0
	MOV.B	W0, [W1]
	GOTO	L_BMS__sendSetCommandPacket42
L_BMS__sendSetCommandPacket41:
;BMS.c,222 :: 		else return;
	GOTO	L_end__sendSetCommandPacket
L_BMS__sendSetCommandPacket42:
L_BMS__sendSetCommandPacket40:
;BMS.c,223 :: 		}
	GOTO	L_BMS__sendSetCommandPacket43
L_BMS__sendSetCommandPacket38:
;BMS.c,225 :: 		_packet[12] = _getEndMarker(_commandID);
	ADD	W14, #10, W0
	ADD	W0, #12, W0
	MOV	W0, [W14+124]
	CALL	BMS__getEndMarker
	MOV	[W14+124], W1
	MOV.B	W0, [W1]
;BMS.c,226 :: 		}
L_BMS__sendSetCommandPacket43:
L_BMS__sendSetCommandPacket37:
;BMS.c,228 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
; _i start address is: 4 (W2)
	CLR	W2
; _i end address is: 4 (W2)
L_BMS__sendSetCommandPacket44:
; _i start address is: 4 (W2)
	CP.B	W2, #13
	BRA LTU	L_BMS__sendSetCommandPacket159
	GOTO	L_BMS__sendSetCommandPacket45
L_BMS__sendSetCommandPacket159:
;BMS.c,229 :: 		UART1_Write(_packet[_i]);
	ADD	W14, #10, W1
	ZE	W2, W0
	ADD	W1, W0, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;BMS.c,228 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
	INC.B	W2
;BMS.c,230 :: 		}
; _i end address is: 4 (W2)
	GOTO	L_BMS__sendSetCommandPacket44
L_BMS__sendSetCommandPacket45:
;BMS.c,233 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
; _i start address is: 4 (W2)
	CLR	W2
; _i end address is: 4 (W2)
L_BMS__sendSetCommandPacket47:
; _i start address is: 4 (W2)
	CP.B	W2, #13
	BRA LTU	L_BMS__sendSetCommandPacket160
	GOTO	L_BMS__sendSetCommandPacket48
L_BMS__sendSetCommandPacket160:
;BMS.c,235 :: 		sprintf(temp, "0x%02X ", _packet[_i]);
	ADD	W14, #10, W1
	ZE	W2, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ADD	W14, #0, W1
	ZE	W0, W0
	PUSH	W2
	PUSH	W12
	PUSH.D	W10
	PUSH	W0
	MOV	#lo_addr(?lstr_7_BMS), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
	POP.D	W10
	POP	W12
;BMS.c,236 :: 		strcat(_dbgStr, temp);
	ADD	W14, #0, W1
	ADD	W14, #23, W0
	PUSH.D	W10
	MOV	W1, W11
	MOV	W0, W10
	CALL	_strcat
	POP.D	W10
	POP	W2
;BMS.c,233 :: 		for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
	INC.B	W2
;BMS.c,237 :: 		}
; _i end address is: 4 (W2)
	GOTO	L_BMS__sendSetCommandPacket47
L_BMS__sendSetCommandPacket48:
;BMS.c,238 :: 		strcat(_dbgStr, "\r\n");
	ADD	W14, #23, W0
	PUSH.D	W10
	MOV	#lo_addr(?lstr8_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP.D	W10
;BMS.c,239 :: 		DebugUART_Send_Text(_dbgStr);
	ADD	W14, #23, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP	W12
;BMS.c,240 :: 		}
L_end__sendSetCommandPacket:
	ULNK
	RETURN
; end of BMS__sendSetCommandPacket

BMS__processReceivedResponsePacket:
	LNK	#178

;BMS.c,246 :: 		static void _processReceivedResponsePacket(void) {
;BMS.c,251 :: 		uint8_t i,j = 0;
	PUSH	W10
	PUSH	W11
;BMS.c,252 :: 		uint16_t raw_value = 0;
;BMS.c,253 :: 		int16_t raw_signed = 0;
;BMS.c,254 :: 		uint8_t checksum = 0;
; checksum start address is: 10 (W5)
	CLR	W5
;BMS.c,255 :: 		char failCodeArr[] = "";
;BMS.c,258 :: 		if (RX_PeekBytes(_temp, _EXPECTED_PACKET_SIZE) == _EXPECTED_PACKET_SIZE) {
	ADD	W14, #10, W0
	MOV	#13, W11
	MOV	W0, W10
	CALL	_RX_PeekBytes
	CP	W0, #13
	BRA Z	L_BMS__processReceivedResponsePacket162
	GOTO	L_BMS__processReceivedResponsePacket50
L_BMS__processReceivedResponsePacket162:
;BMS.c,260 :: 		strcpy(_dbgStr, "Peeked Packet: ");
	ADD	W14, #23, W0
	MOV	#lo_addr(?lstr9_BMS), W11
	MOV	W0, W10
	CALL	_strcpy
;BMS.c,261 :: 		for (i = 0; i < _EXPECTED_PACKET_SIZE; i++) {
; i start address is: 6 (W3)
	CLR	W3
; checksum end address is: 10 (W5)
; i end address is: 6 (W3)
	MOV.B	W5, W2
L_BMS__processReceivedResponsePacket51:
; i start address is: 6 (W3)
; checksum start address is: 4 (W2)
	CP.B	W3, #13
	BRA LTU	L_BMS__processReceivedResponsePacket163
	GOTO	L_BMS__processReceivedResponsePacket52
L_BMS__processReceivedResponsePacket163:
;BMS.c,263 :: 		sprintf(_byteStr, "0x%02X ", _temp[i]);
	ADD	W14, #10, W1
	ZE	W3, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ADD	W14, #0, W1
	ZE	W0, W0
	PUSH.D	W2
	PUSH	W0
	MOV	#lo_addr(?lstr_10_BMS), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;BMS.c,264 :: 		strcat(_dbgStr, _byteStr);
	ADD	W14, #0, W1
	ADD	W14, #23, W0
	MOV	W1, W11
	MOV	W0, W10
	CALL	_strcat
	POP.D	W2
;BMS.c,261 :: 		for (i = 0; i < _EXPECTED_PACKET_SIZE; i++) {
	INC.B	W3
;BMS.c,265 :: 		}
; i end address is: 6 (W3)
	GOTO	L_BMS__processReceivedResponsePacket51
L_BMS__processReceivedResponsePacket52:
;BMS.c,266 :: 		strcat(_dbgStr, "\r\n");
	ADD	W14, #23, W0
	PUSH	W2
	MOV	#lo_addr(?lstr11_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W2
;BMS.c,270 :: 		if ((_temp[0] == 0xA5) && (_temp[1] == 0x01) &&
	ADD	W14, #10, W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA Z	L_BMS__processReceivedResponsePacket164
	GOTO	L_BMS__processReceivedResponsePacket121
L_BMS__processReceivedResponsePacket164:
	ADD	W14, #10, W0
	INC	W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L_BMS__processReceivedResponsePacket165
	GOTO	L_BMS__processReceivedResponsePacket120
L_BMS__processReceivedResponsePacket165:
;BMS.c,271 :: 		(_temp[3] == 0x08) && (((_temp[2]) & 0xF0) == 0x90)) {
	ADD	W14, #10, W0
	ADD	W0, #3, W0
	MOV.B	[W0], W0
	CP.B	W0, #8
	BRA Z	L_BMS__processReceivedResponsePacket166
	GOTO	L_BMS__processReceivedResponsePacket119
L_BMS__processReceivedResponsePacket166:
	ADD	W14, #10, W0
	INC2	W0
	ZE	[W0], W1
	MOV	#240, W0
	AND	W1, W0, W1
	MOV	#144, W0
	CP	W1, W0
	BRA Z	L_BMS__processReceivedResponsePacket167
	GOTO	L_BMS__processReceivedResponsePacket118
L_BMS__processReceivedResponsePacket167:
L_BMS__processReceivedResponsePacket117:
;BMS.c,276 :: 		RX_PopBytes(_temp, _EXPECTED_PACKET_SIZE);
	ADD	W14, #10, W0
	PUSH	W2
	MOV	#13, W11
	MOV	W0, W10
	CALL	_RX_PopBytes
	POP	W2
;BMS.c,280 :: 		for (i = 0; i < _EXPECTED_PACKET_SIZE - 1; i++) {
; i start address is: 0 (W0)
	CLR	W0
; checksum end address is: 4 (W2)
; i end address is: 0 (W0)
	MOV.B	W2, W3
	MOV.B	W0, W2
L_BMS__processReceivedResponsePacket57:
; i start address is: 4 (W2)
; checksum start address is: 6 (W3)
	ZE	W2, W0
	CP	W0, #12
	BRA LT	L_BMS__processReceivedResponsePacket168
	GOTO	L_BMS__processReceivedResponsePacket58
L_BMS__processReceivedResponsePacket168:
;BMS.c,281 :: 		checksum += _temp[i];
	ADD	W14, #10, W1
	ZE	W2, W0
	ADD	W1, W0, W0
; checksum start address is: 0 (W0)
	ADD.B	W3, [W0], W0
; checksum end address is: 6 (W3)
;BMS.c,280 :: 		for (i = 0; i < _EXPECTED_PACKET_SIZE - 1; i++) {
	INC.B	W2
;BMS.c,282 :: 		}
	MOV.B	W0, W3
; checksum end address is: 0 (W0)
; i end address is: 4 (W2)
	GOTO	L_BMS__processReceivedResponsePacket57
L_BMS__processReceivedResponsePacket58:
;BMS.c,284 :: 		if (checksum == _temp[_EXPECTED_PACKET_SIZE - 1]) {
; checksum start address is: 6 (W3)
	ADD	W14, #10, W0
	ADD	W0, #12, W0
	CP.B	W3, [W0]
	BRA Z	L_BMS__processReceivedResponsePacket169
	GOTO	L_BMS__processReceivedResponsePacket60
L_BMS__processReceivedResponsePacket169:
; checksum end address is: 6 (W3)
;BMS.c,286 :: 		switch (_temp[2]) {
	ADD	W14, #10, W0
	INC2	W0
	MOV	W0, [W14+176]
	GOTO	L_BMS__processReceivedResponsePacket61
;BMS.c,287 :: 		case 0x90: {
L_BMS__processReceivedResponsePacket63:
;BMS.c,293 :: 		raw_value = (((uint16_t)_temp[4]) << 8) | _temp[5];
	ADD	W14, #10, W2
	MOV	W2, [W14+174]
	ADD	W2, #4, W0
	ZE	[W0], W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
;BMS.c,294 :: 		_bmsData._sumVoltage = raw_value / 10.0;
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	W0, __bmsData
	MOV	W1, __bmsData+2
;BMS.c,296 :: 		raw_signed = ((((uint16_t)(_temp[8]) << 8) | (uint16_t)_temp[9]) - 30000) / 10.0;
	MOV	[W14+174], W2
	ADD	W2, #8, W0
	ZE	[W0], W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W1
	MOV	#30000, W0
	SUB	W1, W0, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	CALL	__Float2Longint
;BMS.c,297 :: 		_bmsData._sumCurrent = raw_signed;
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, __bmsData+4
	MOV	W1, __bmsData+6
;BMS.c,300 :: 		_bmsData._cellCount = 4;
	MOV	#4, W0
	MOV	W0, __bmsData+52
;BMS.c,302 :: 		raw_value =(uint16_t)(_temp[10] << 8 | _temp[11]);
	MOV	[W14+174], W2
	ADD	W2, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #11, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
;BMS.c,303 :: 		_bmsData._sumSOC = (raw_value / 10.0f);
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+8
	MOV	W1, __bmsData+10
;BMS.c,308 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,310 :: 		case 0x91: {
L_BMS__processReceivedResponsePacket64:
;BMS.c,315 :: 		raw_value = (((uint16_t)_temp[4]) << 8) | _temp[5];
	ADD	W14, #10, W2
	MOV	W2, [W14+174]
	ADD	W2, #4, W0
	ZE	[W0], W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
;BMS.c,316 :: 		_bmsData._remainingCapacity = raw_value / 100.0; // Convert to Ah
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+54
	MOV	W1, __bmsData+56
;BMS.c,318 :: 		raw_value = (((uint16_t)_temp[6]) << 8) | _temp[7];
	MOV	[W14+174], W2
	ADD	W2, #6, W0
	ZE	[W0], W0
	SL	W0, #8, W1
	ADD	W2, #7, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
;BMS.c,319 :: 		_bmsData._totalCapacity = raw_value / 100.0; // Convert to Ah
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+58
	MOV	W1, __bmsData+60
;BMS.c,321 :: 		raw_value = (((uint16_t)_temp[8]) << 8) | _temp[9];
	MOV	[W14+174], W2
	ADD	W2, #8, W0
	ZE	[W0], W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
;BMS.c,322 :: 		_bmsData._cycleCount = raw_value;
	MOV	W0, __bmsData+40
;BMS.c,324 :: 		sprintf(_dbgStr, "Remaining Capacity: %.2f Ah, Total Capacity: %.2f Ah, Cycles: %d\r\n",
	ADD	W14, #23, W1
;BMS.c,325 :: 		_bmsData._remainingCapacity, _bmsData._totalCapacity, _bmsData._cycleCount);
	PUSH	W0
	PUSH	__bmsData+58
	PUSH	__bmsData+60
	PUSH	__bmsData+54
	PUSH	__bmsData+56
;BMS.c,324 :: 		sprintf(_dbgStr, "Remaining Capacity: %.2f Ah, Total Capacity: %.2f Ah, Cycles: %d\r\n",
	MOV	#lo_addr(?lstr_12_BMS), W0
	PUSH	W0
	PUSH	W1
;BMS.c,325 :: 		_bmsData._remainingCapacity, _bmsData._totalCapacity, _bmsData._cycleCount);
	CALL	_sprintf
	SUB	#14, W15
;BMS.c,327 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,329 :: 		case 0x92: {
L_BMS__processReceivedResponsePacket65:
;BMS.c,341 :: 		raw_value =  (uint16_t) ((((_temp[4]) - 40) + (( _temp[6]) - 40)) /2);
	ADD	W14, #10, W3
	ADD	W3, #4, W0
	ZE	[W0], W1
	MOV	#40, W0
	SUB	W1, W0, W2
	ADD	W3, #6, W0
	ZE	[W0], W1
	MOV	#40, W0
	SUB	W1, W0, W0
	ADD	W2, W0, W0
	MOV	#2, W2
	REPEAT	#17
	DIV.S	W0, W2
;BMS.c,342 :: 		_bmsData._temperature = raw_value;
	CLR	W1
	CALL	__Long2Float
	MOV	W0, __bmsData+36
	MOV	W1, __bmsData+38
;BMS.c,344 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,346 :: 		case 0x93: {
L_BMS__processReceivedResponsePacket66:
;BMS.c,363 :: 		_bmsData._chargeMOS = _temp[6];
	ADD	W14, #10, W2
	ADD	W2, #6, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+77), W0
	MOV.B	W1, [W0]
;BMS.c,364 :: 		_bmsData._dischargeMOS = _temp[7];
	ADD	W2, #7, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+78), W0
	MOV.B	W1, [W0]
;BMS.c,368 :: 		_bmsData._dischargeMOS ? "ON" : "OFF");
	CP0.B	W1
	BRA NZ	L_BMS__processReceivedResponsePacket170
	GOTO	L_BMS__processReceivedResponsePacket69
L_BMS__processReceivedResponsePacket170:
; ?FLOC__BMS__processReceivedResponsePacket?T366 start address is: 4 (W2)
	MOV	#lo_addr(?lstr_16_BMS), W2
; ?FLOC__BMS__processReceivedResponsePacket?T366 end address is: 4 (W2)
	GOTO	L_BMS__processReceivedResponsePacket70
L_BMS__processReceivedResponsePacket69:
; ?FLOC__BMS__processReceivedResponsePacket?T366 start address is: 4 (W2)
	MOV	#lo_addr(?lstr_17_BMS), W2
; ?FLOC__BMS__processReceivedResponsePacket?T366 end address is: 4 (W2)
L_BMS__processReceivedResponsePacket70:
;BMS.c,367 :: 		_bmsData._chargeMOS ? "ON" : "OFF",
; ?FLOC__BMS__processReceivedResponsePacket?T366 start address is: 4 (W2)
	MOV	#lo_addr(__bmsData+77), W0
	CP0.B	[W0]
	BRA NZ	L_BMS__processReceivedResponsePacket171
	GOTO	L_BMS__processReceivedResponsePacket67
L_BMS__processReceivedResponsePacket171:
; ?FLOC__BMS__processReceivedResponsePacket?T363 start address is: 0 (W0)
	MOV	#lo_addr(?lstr_14_BMS), W0
; ?FLOC__BMS__processReceivedResponsePacket?T363 end address is: 0 (W0)
	GOTO	L_BMS__processReceivedResponsePacket68
L_BMS__processReceivedResponsePacket67:
; ?FLOC__BMS__processReceivedResponsePacket?T363 start address is: 0 (W0)
	MOV	#lo_addr(?lstr_15_BMS), W0
; ?FLOC__BMS__processReceivedResponsePacket?T363 end address is: 0 (W0)
L_BMS__processReceivedResponsePacket68:
;BMS.c,366 :: 		sprintf(_dbgStr, "Charge MOS: %s, Discharge MOS: %s\r\n",
; ?FLOC__BMS__processReceivedResponsePacket?T363 start address is: 0 (W0)
	ADD	W14, #23, W1
;BMS.c,368 :: 		_bmsData._dischargeMOS ? "ON" : "OFF");
	PUSH	W2
; ?FLOC__BMS__processReceivedResponsePacket?T366 end address is: 4 (W2)
;BMS.c,367 :: 		_bmsData._chargeMOS ? "ON" : "OFF",
	PUSH	W0
; ?FLOC__BMS__processReceivedResponsePacket?T363 end address is: 0 (W0)
;BMS.c,366 :: 		sprintf(_dbgStr, "Charge MOS: %s, Discharge MOS: %s\r\n",
	MOV	#lo_addr(?lstr_13_BMS), W0
	PUSH	W0
	PUSH	W1
;BMS.c,368 :: 		_bmsData._dischargeMOS ? "ON" : "OFF");
	CALL	_sprintf
	SUB	#8, W15
;BMS.c,369 :: 		DebugUART_Send_Text(_dbgStr);
	ADD	W14, #23, W0
	MOV	W0, W10
	CALL	_DebugUART_Send_Text
;BMS.c,370 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,372 :: 		case 0x94: {
L_BMS__processReceivedResponsePacket71:
;BMS.c,376 :: 		_bmsData._cellCount = _temp[4];
	ADD	W14, #10, W1
	ADD	W1, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+52
;BMS.c,377 :: 		_bmsData._ntcCount = _temp[5];
	ADD	W1, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+70
;BMS.c,379 :: 		sprintf(_dbgStr, "Cell Count: %d, NTC Count: %d\r\n",
	ADD	W14, #23, W1
;BMS.c,380 :: 		_bmsData._cellCount, _bmsData._ntcCount);
	PUSH	__bmsData+70
	PUSH	__bmsData+52
;BMS.c,379 :: 		sprintf(_dbgStr, "Cell Count: %d, NTC Count: %d\r\n",
	MOV	#lo_addr(?lstr_18_BMS), W0
	PUSH	W0
	PUSH	W1
;BMS.c,380 :: 		_bmsData._cellCount, _bmsData._ntcCount);
	CALL	_sprintf
	SUB	#8, W15
;BMS.c,382 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,384 :: 		case 0x95: {
L_BMS__processReceivedResponsePacket72:
;BMS.c,392 :: 		for (j = 0; j < 3; j++){
; j start address is: 8 (W4)
	CLR	W4
; j end address is: 8 (W4)
L_BMS__processReceivedResponsePacket73:
; j start address is: 8 (W4)
	CP.B	W4, #3
	BRA LTU	L_BMS__processReceivedResponsePacket172
	GOTO	L_BMS__processReceivedResponsePacket74
L_BMS__processReceivedResponsePacket172:
;BMS.c,393 :: 		_bmsData._cellVoltages[j] = (_temp[5 + j + j] << 8) | _temp[6 + j + j];
	ZE	W4, W0
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+16), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+174]
	ZE	W4, W0
	ADD	W0, #5, W1
	ZE	W4, W0
	ADD	W1, W0, W0
	ADD	W14, #10, W3
	ADD	W3, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W2
	ZE	W4, W0
	ADD	W0, #6, W1
	ZE	W4, W0
	ADD	W1, W0, W0
	ADD	W3, W0, W0
	ZE	[W0], W0
	IOR	W2, W0, W0
	PUSH	W4
	CLR	W1
	CALL	__Long2Float
	POP	W4
	MOV	[W14+174], W2
	MOV.D	W0, [W2]
;BMS.c,392 :: 		for (j = 0; j < 3; j++){
	INC.B	W4
;BMS.c,394 :: 		}
; j end address is: 8 (W4)
	GOTO	L_BMS__processReceivedResponsePacket73
L_BMS__processReceivedResponsePacket74:
;BMS.c,397 :: 		+ _bmsData._cellVoltages[1] + _bmsData._cellVoltages[2]) / 3;
	MOV	__bmsData+16, W2
	MOV	__bmsData+18, W3
	MOV	__bmsData+20, W0
	MOV	__bmsData+22, W1
	CALL	__AddSub_FP
	MOV	__bmsData+24, W2
	MOV	__bmsData+26, W3
	CALL	__AddSub_FP
	MOV	#0, W2
	MOV	#16448, W3
	CALL	__Div_FP
	MOV	W0, __bmsData+28
	MOV	W1, __bmsData+30
;BMS.c,404 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,406 :: 		case 0x96: {
L_BMS__processReceivedResponsePacket76:
;BMS.c,410 :: 		uint8_t cellIndex = _temp[4] - 1;
	ADD	W14, #10, W0
	ADD	W0, #4, W0
	ZE	[W0], W0
	DEC	W0
; cellIndex start address is: 6 (W3)
	MOV.B	W0, W3
;BMS.c,411 :: 		if (cellIndex < MAX_CELL_COUNT) {
	CP.B	W0, #16
	BRA LTU	L_BMS__processReceivedResponsePacket173
	GOTO	L_BMS__processReceivedResponsePacket77
L_BMS__processReceivedResponsePacket173:
;BMS.c,412 :: 		raw_value = (((uint16_t)_temp[5]) << 8) | _temp[6];
	ADD	W14, #10, W2
	ADD	W2, #5, W0
	ZE	[W0], W0
	SL	W0, #8, W1
	ADD	W2, #6, W0
	ZE	[W0], W0
	IOR	W1, W0, W2
;BMS.c,413 :: 		_bmsData._cellVoltages[cellIndex] = raw_value / 1000.0;
	ZE	W3, W0
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+16), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+174]
	PUSH	W3
	MOV	W2, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#17530, W3
	CALL	__Div_FP
	POP	W3
	MOV	[W14+174], W2
	MOV.D	W0, [W2]
;BMS.c,416 :: 		cellIndex + 1, _bmsData._cellVoltages[cellIndex]);
	ZE	W3, W0
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+16), W0
	ADD	W0, W1, W2
	ZE	W3, W0
	INC	W0
;BMS.c,415 :: 		sprintf(_dbgStr, "Cell %d Voltage: %.3f V\r\n",
	ADD	W14, #23, W1
;BMS.c,416 :: 		cellIndex + 1, _bmsData._cellVoltages[cellIndex]);
	PUSH	W3
	PUSH	[W2++]
	PUSH	[W2--]
	PUSH	W0
;BMS.c,415 :: 		sprintf(_dbgStr, "Cell %d Voltage: %.3f V\r\n",
	MOV	#lo_addr(?lstr_19_BMS), W0
	PUSH	W0
	PUSH	W1
;BMS.c,416 :: 		cellIndex + 1, _bmsData._cellVoltages[cellIndex]);
	CALL	_sprintf
	SUB	#10, W15
	POP	W3
;BMS.c,420 :: 		if (cellIndex == _bmsData._cellCount - 1) {
	MOV	__bmsData+52, W0
	SUB	W0, #1, W1
	ZE	W3, W0
; cellIndex end address is: 6 (W3)
	CP	W0, W1
	BRA Z	L_BMS__processReceivedResponsePacket174
	GOTO	L_BMS__processReceivedResponsePacket78
L_BMS__processReceivedResponsePacket174:
;BMS.c,422 :: 		}
L_BMS__processReceivedResponsePacket78:
;BMS.c,423 :: 		}
L_BMS__processReceivedResponsePacket77:
;BMS.c,424 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,426 :: 		case 0x97: {
L_BMS__processReceivedResponsePacket79:
;BMS.c,429 :: 		_bmsData._balanceStatus = _temp[4];
	ADD	W14, #10, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+80
;BMS.c,431 :: 		sprintf(_dbgStr, "Balance Status: 0x%02X\r\n", _bmsData._balanceStatus);
	ADD	W14, #23, W1
	PUSH	__bmsData+80
	MOV	#lo_addr(?lstr_20_BMS), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;BMS.c,433 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,435 :: 		case 0x98: {
L_BMS__processReceivedResponsePacket80:
;BMS.c,438 :: 		_bmsData._errorCount = _temp[4];
	ADD	W14, #10, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	W0, __bmsData+82
;BMS.c,440 :: 		sprintf(_dbgStr, "Error Count: %d\r\n", _bmsData._errorCount);
	ADD	W14, #23, W1
	PUSH	__bmsData+82
	MOV	#lo_addr(?lstr_21_BMS), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;BMS.c,442 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,444 :: 		case 0x99: {
L_BMS__processReceivedResponsePacket81:
;BMS.c,449 :: 		_bmsData._hardwareVersion = (((uint16_t)_temp[4]) << 8) | _temp[5];
	ADD	W14, #10, W2
	ADD	W2, #5, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+84), W0
	MOV.B	W1, [W0]
;BMS.c,450 :: 		_bmsData._softwareVersion = (((uint16_t)_temp[6]) << 8) | _temp[7];
	ADD	W2, #7, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(__bmsData+85), W0
	MOV.B	W1, [W0]
;BMS.c,453 :: 		_bmsData._manufacturer[0] = _temp[10];
	ADD	W2, #10, W1
	MOV	__bmsData+86, W0
	MOV.B	[W1], [W0]
;BMS.c,454 :: 		_bmsData._manufacturer[1] = _temp[11];
	MOV	__bmsData+86, W0
	ADD	W0, #1, W1
	ADD	W2, #11, W0
	MOV.B	[W0], [W1]
;BMS.c,455 :: 		_bmsData._manufacturer[2] = '\0';
	MOV	__bmsData+86, W0
	ADD	W0, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,457 :: 		sprintf(_dbgStr, "HW Version: 0x%04X, SW Version: 0x%04X, Manufacturer: %s\r\n",
	ADD	W14, #23, W1
;BMS.c,458 :: 		_bmsData._hardwareVersion, _bmsData._softwareVersion, _bmsData._manufacturer);
	PUSH	__bmsData+86
	MOV	#lo_addr(__bmsData+85), W0
	ZE	[W0], W0
	PUSH	W0
	MOV	#lo_addr(__bmsData+84), W0
	ZE	[W0], W0
	PUSH	W0
;BMS.c,457 :: 		sprintf(_dbgStr, "HW Version: 0x%04X, SW Version: 0x%04X, Manufacturer: %s\r\n",
	MOV	#lo_addr(?lstr_22_BMS), W0
	PUSH	W0
	PUSH	W1
;BMS.c,458 :: 		_bmsData._hardwareVersion, _bmsData._softwareVersion, _bmsData._manufacturer);
	CALL	_sprintf
	SUB	#10, W15
;BMS.c,460 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,462 :: 		default:
L_BMS__processReceivedResponsePacket82:
;BMS.c,464 :: 		break;
	GOTO	L_BMS__processReceivedResponsePacket62
;BMS.c,465 :: 		}
L_BMS__processReceivedResponsePacket61:
	MOV	[W14+176], W2
	MOV.B	[W2], W1
	MOV.B	#144, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket175
	GOTO	L_BMS__processReceivedResponsePacket63
L_BMS__processReceivedResponsePacket175:
	MOV.B	[W2], W1
	MOV.B	#145, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket176
	GOTO	L_BMS__processReceivedResponsePacket64
L_BMS__processReceivedResponsePacket176:
	MOV.B	[W2], W1
	MOV.B	#146, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket177
	GOTO	L_BMS__processReceivedResponsePacket65
L_BMS__processReceivedResponsePacket177:
	MOV.B	[W2], W1
	MOV.B	#147, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket178
	GOTO	L_BMS__processReceivedResponsePacket66
L_BMS__processReceivedResponsePacket178:
	MOV.B	[W2], W1
	MOV.B	#148, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket179
	GOTO	L_BMS__processReceivedResponsePacket71
L_BMS__processReceivedResponsePacket179:
	MOV.B	[W2], W1
	MOV.B	#149, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket180
	GOTO	L_BMS__processReceivedResponsePacket72
L_BMS__processReceivedResponsePacket180:
	MOV.B	[W2], W1
	MOV.B	#150, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket181
	GOTO	L_BMS__processReceivedResponsePacket76
L_BMS__processReceivedResponsePacket181:
	MOV.B	[W2], W1
	MOV.B	#151, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket182
	GOTO	L_BMS__processReceivedResponsePacket79
L_BMS__processReceivedResponsePacket182:
	MOV.B	[W2], W1
	MOV.B	#152, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket183
	GOTO	L_BMS__processReceivedResponsePacket80
L_BMS__processReceivedResponsePacket183:
	MOV.B	[W2], W1
	MOV.B	#153, W0
	CP.B	W1, W0
	BRA NZ	L_BMS__processReceivedResponsePacket184
	GOTO	L_BMS__processReceivedResponsePacket81
L_BMS__processReceivedResponsePacket184:
	GOTO	L_BMS__processReceivedResponsePacket82
L_BMS__processReceivedResponsePacket62:
;BMS.c,466 :: 		} else {
	GOTO	L_BMS__processReceivedResponsePacket83
L_BMS__processReceivedResponsePacket60:
;BMS.c,468 :: 		checksum, _temp[_EXPECTED_PACKET_SIZE - 1]);
; checksum start address is: 6 (W3)
	ADD	W14, #10, W0
	ADD	W0, #12, W0
	MOV.B	[W0], W0
;BMS.c,467 :: 		sprintf(_dbgStr, "Checksum Error! Calculated: 0x%02X, Received: 0x%02X\r\n",
	ADD	W14, #23, W1
;BMS.c,468 :: 		checksum, _temp[_EXPECTED_PACKET_SIZE - 1]);
	ZE	W0, W0
	PUSH	W0
	ZE	W3, W0
; checksum end address is: 6 (W3)
	PUSH	W0
;BMS.c,467 :: 		sprintf(_dbgStr, "Checksum Error! Calculated: 0x%02X, Received: 0x%02X\r\n",
	MOV	#lo_addr(?lstr_23_BMS), W0
	PUSH	W0
	PUSH	W1
;BMS.c,468 :: 		checksum, _temp[_EXPECTED_PACKET_SIZE - 1]);
	CALL	_sprintf
	SUB	#8, W15
;BMS.c,470 :: 		}
L_BMS__processReceivedResponsePacket83:
;BMS.c,471 :: 		} else {
	GOTO	L_BMS__processReceivedResponsePacket84
;BMS.c,270 :: 		if ((_temp[0] == 0xA5) && (_temp[1] == 0x01) &&
L_BMS__processReceivedResponsePacket121:
L_BMS__processReceivedResponsePacket120:
;BMS.c,271 :: 		(_temp[3] == 0x08) && (((_temp[2]) & 0xF0) == 0x90)) {
L_BMS__processReceivedResponsePacket119:
L_BMS__processReceivedResponsePacket118:
;BMS.c,474 :: 		_temp[0], _temp[1], _temp[2], _temp[3]);
	ADD	W14, #10, W1
	ADD	W1, #3, W0
	MOV.B	[W0], W5
	ADD	W1, #2, W0
	MOV.B	[W0], W4
	ADD	W1, #1, W0
	MOV.B	[W0], W3
	MOV.B	[W1], W2
;BMS.c,473 :: 		sprintf(_dbgStr, "Invalid Packet Header: 0x%02X 0x%02X 0x%02X 0x%02X\r\n",
	ADD	W14, #23, W1
;BMS.c,474 :: 		_temp[0], _temp[1], _temp[2], _temp[3]);
	ZE	W5, W0
	PUSH	W0
	ZE	W4, W0
	PUSH	W0
	ZE	W3, W0
	PUSH	W0
	ZE	W2, W0
	PUSH	W0
;BMS.c,473 :: 		sprintf(_dbgStr, "Invalid Packet Header: 0x%02X 0x%02X 0x%02X 0x%02X\r\n",
	MOV	#lo_addr(?lstr_24_BMS), W0
	PUSH	W0
	PUSH	W1
;BMS.c,474 :: 		_temp[0], _temp[1], _temp[2], _temp[3]);
	CALL	_sprintf
	SUB	#12, W15
;BMS.c,476 :: 		RX_PopBytes(&_discard, 1);
	MOV	#173, W0
	ADD	W14, W0, W0
	MOV	#1, W11
	MOV	W0, W10
	CALL	_RX_PopBytes
;BMS.c,477 :: 		}
L_BMS__processReceivedResponsePacket84:
;BMS.c,478 :: 		}
L_BMS__processReceivedResponsePacket50:
;BMS.c,479 :: 		}
L_end__processReceivedResponsePacket:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of BMS__processReceivedResponsePacket

BMS__updateMinMaxCellVoltage:

;BMS.c,482 :: 		static void _updateMinMaxCellVoltage(void) {
;BMS.c,486 :: 		_bmsData._minCellVoltage = _bmsData._cellVoltages[0];
	MOV	__bmsData+16, W0
	MOV	__bmsData+18, W1
	MOV	W0, __bmsData+32
	MOV	W1, __bmsData+34
;BMS.c,487 :: 		_bmsData._maxCellVoltage = _bmsData._cellVoltages[0];
	MOV	__bmsData+16, W0
	MOV	__bmsData+18, W1
	MOV	W0, __bmsData+12
	MOV	W1, __bmsData+14
;BMS.c,492 :: 		for (i = 1; i < _bmsData._cellCount; i++) {
; i start address is: 6 (W3)
	MOV.B	#1, W3
; i end address is: 6 (W3)
L_BMS__updateMinMaxCellVoltage85:
; i start address is: 6 (W3)
	ZE	W3, W1
	MOV	#lo_addr(__bmsData+52), W0
	CP	W1, [W0]
	BRA LT	L_BMS__updateMinMaxCellVoltage186
	GOTO	L_BMS__updateMinMaxCellVoltage86
L_BMS__updateMinMaxCellVoltage186:
;BMS.c,493 :: 		if (_bmsData._cellVoltages[i] < _bmsData._minCellVoltage) {
	ZE	W3, W0
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+16), W0
	ADD	W0, W1, W2
	MOV.D	[W2], W0
	PUSH	W3
	MOV	__bmsData+32, W2
	MOV	__bmsData+34, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L_BMS__updateMinMaxCellVoltage187
	INC.B	W0
L_BMS__updateMinMaxCellVoltage187:
	POP	W3
	CP0.B	W0
	BRA NZ	L_BMS__updateMinMaxCellVoltage188
	GOTO	L_BMS__updateMinMaxCellVoltage88
L_BMS__updateMinMaxCellVoltage188:
;BMS.c,494 :: 		_bmsData._minCellVoltage = _bmsData._cellVoltages[i];
	ZE	W3, W0
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+16), W0
	ADD	W0, W1, W2
	MOV.D	[W2], W0
	MOV	W0, __bmsData+32
	MOV	W1, __bmsData+34
;BMS.c,496 :: 		}
L_BMS__updateMinMaxCellVoltage88:
;BMS.c,497 :: 		if (_bmsData._cellVoltages[i] > _bmsData._maxCellVoltage) {
	ZE	W3, W0
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+16), W0
	ADD	W0, W1, W2
	MOV.D	[W2], W0
	PUSH	W3
	MOV	__bmsData+12, W2
	MOV	__bmsData+14, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L_BMS__updateMinMaxCellVoltage189
	INC.B	W0
L_BMS__updateMinMaxCellVoltage189:
	POP	W3
	CP0.B	W0
	BRA NZ	L_BMS__updateMinMaxCellVoltage190
	GOTO	L_BMS__updateMinMaxCellVoltage89
L_BMS__updateMinMaxCellVoltage190:
;BMS.c,498 :: 		_bmsData._maxCellVoltage = _bmsData._cellVoltages[i];
	ZE	W3, W0
	SL	W0, #2, W1
	MOV	#lo_addr(__bmsData+16), W0
	ADD	W0, W1, W2
	MOV.D	[W2], W0
	MOV	W0, __bmsData+12
	MOV	W1, __bmsData+14
;BMS.c,500 :: 		}
L_BMS__updateMinMaxCellVoltage89:
;BMS.c,492 :: 		for (i = 1; i < _bmsData._cellCount; i++) {
	INC.B	W3
;BMS.c,501 :: 		}
; i end address is: 6 (W3)
	GOTO	L_BMS__updateMinMaxCellVoltage85
L_BMS__updateMinMaxCellVoltage86:
;BMS.c,502 :: 		}
L_end__updateMinMaxCellVoltage:
	RETURN
; end of BMS__updateMinMaxCellVoltage

_BMS_SendCommandImmediate:
	LNK	#20

;BMS.c,509 :: 		void BMS_SendCommandImmediate(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
;BMS.c,524 :: 		Immediate_PushCommand(_commandID, _payload, _value);
	CALL	_Immediate_PushCommand
;BMS.c,526 :: 		if (!_txBusy) {
	MOV	#lo_addr(__txBusy), W0
	CP0.B	[W0]
	BRA Z	L__BMS_SendCommandImmediate192
	GOTO	L_BMS_SendCommandImmediate90
L__BMS_SendCommandImmediate192:
;BMS.c,527 :: 		_txBusy = 1;
	MOV	#lo_addr(__txBusy), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,528 :: 		while (!Immediate_IsEmpty()) {
L_BMS_SendCommandImmediate91:
	CALL	_Immediate_IsEmpty
	CP0.B	W0
	BRA Z	L__BMS_SendCommandImmediate193
	GOTO	L_BMS_SendCommandImmediate92
L__BMS_SendCommandImmediate193:
;BMS.c,529 :: 		_imCmd = Immediate_PopCommand();
	ADD	W14, #10, W0
	MOV	W0, [W15+6]
	PUSH	W12
	PUSH.D	W10
	CALL	_Immediate_PopCommand
	ADD	W14, #0, W1
	ADD	W14, #10, W0
	REPEAT	#8
	MOV.B	[W0++], [W1++]
;BMS.c,530 :: 		_sendSetCommandPacket(_imCmd._commandID, _imCmd._payload, _imCmd._value);
	ADD	W14, #1, W0
	MOV.B	[W14+8], W12
	MOV	W0, W11
	MOV.B	[W14+0], W10
	CALL	BMS__sendSetCommandPacket
	POP.D	W10
	POP	W12
;BMS.c,531 :: 		}
	GOTO	L_BMS_SendCommandImmediate91
L_BMS_SendCommandImmediate92:
;BMS.c,533 :: 		_txBusy = 0;
	MOV	#lo_addr(__txBusy), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,534 :: 		}
L_BMS_SendCommandImmediate90:
;BMS.c,535 :: 		}
L_end_BMS_SendCommandImmediate:
	ULNK
	RETURN
; end of _BMS_SendCommandImmediate

_BMS_PushCommand:

;BMS.c,540 :: 		void BMS_PushCommand(uint8_t _commandID, uint8_t * _payload) {
;BMS.c,541 :: 		TX_PushCommand(_commandID, _payload);
	CALL	_TX_PushCommand
;BMS.c,542 :: 		}
L_end_BMS_PushCommand:
	RETURN
; end of _BMS_PushCommand

_BMS_Update:
	LNK	#36

;BMS.c,548 :: 		void BMS_Update(void) {
;BMS.c,554 :: 		_processReceivedResponsePacket();
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CALL	BMS__processReceivedResponsePacket
;BMS.c,556 :: 		if (!Immediate_IsEmpty()) {
	CALL	_Immediate_IsEmpty
	CP0.B	W0
	BRA Z	L__BMS_Update196
	GOTO	L_BMS_Update93
L__BMS_Update196:
;BMS.c,557 :: 		_imCmd = Immediate_PopCommand();
	ADD	W14, #26, W0
	MOV	W0, [W15+6]
	CALL	_Immediate_PopCommand
	ADD	W14, #0, W1
	ADD	W14, #26, W0
	REPEAT	#8
	MOV.B	[W0++], [W1++]
;BMS.c,558 :: 		DebugUART_Send_Text("Da lay duoc lenh\r\n");
	MOV	#lo_addr(?lstr_25_BMS), W10
	CALL	_DebugUART_Send_Text
;BMS.c,559 :: 		_sendSetCommandPacket(_imCmd._commandID, _imCmd._payload, _imCmd._value);
	ADD	W14, #1, W0
	MOV.B	[W14+8], W12
	MOV	W0, W11
	MOV.B	[W14+0], W10
	CALL	BMS__sendSetCommandPacket
;BMS.c,561 :: 		} else if (!TX_IsEmpty()) {
	GOTO	L_BMS_Update94
L_BMS_Update93:
	CALL	_TX_IsEmpty
	CP0.B	W0
	BRA Z	L__BMS_Update197
	GOTO	L_BMS_Update95
L__BMS_Update197:
;BMS.c,562 :: 		_txCmd = TX_PopCommand();
	ADD	W14, #26, W0
	MOV	W0, [W15+6]
	CALL	_TX_PopCommand
	ADD	W14, #9, W1
	ADD	W14, #26, W0
	REPEAT	#8
	MOV.B	[W0++], [W1++]
;BMS.c,563 :: 		_sendCommandPacket(_txCmd._commandID, _txCmd._payload);
	ADD	W14, #10, W0
	MOV	W0, W11
	MOV.B	[W14+9], W10
	CALL	BMS__sendCommandPacket
;BMS.c,564 :: 		} else {
	GOTO	L_BMS_Update96
L_BMS_Update95:
;BMS.c,566 :: 		uint8_t _defaultPayload[8] = {0};
	ADD	W14, #18, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, 52
	MOV	#lo_addr(?ICSBMS_Update__defaultPayload_L1), W0
	REPEAT	#7
	MOV.B	[W0++], [W1++]
;BMS.c,567 :: 		switch(_defaultCommandIndex) {
	GOTO	L_BMS_Update97
;BMS.c,568 :: 		case 0: _sendCommandPacket(0x90, _defaultPayload); break;
L_BMS_Update99:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#144, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,569 :: 		case 1: _sendCommandPacket(0x91, _defaultPayload); break;
L_BMS_Update100:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#145, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,570 :: 		case 2: _sendCommandPacket(0x92, _defaultPayload); break;
L_BMS_Update101:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#146, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,571 :: 		case 3: _sendCommandPacket(0x93, _defaultPayload); break;
L_BMS_Update102:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#147, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,572 :: 		case 4: _sendCommandPacket(0x94, _defaultPayload); break;
L_BMS_Update103:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#148, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,573 :: 		case 5: _sendCommandPacket(0x95, _defaultPayload); break;
L_BMS_Update104:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#149, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,574 :: 		case 6: _sendCommandPacket(0x96, _defaultPayload); break;
L_BMS_Update105:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#150, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,575 :: 		case 7: _sendCommandPacket(0x97, _defaultPayload); break;
L_BMS_Update106:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#151, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,576 :: 		case 8: _sendCommandPacket(0x98, _defaultPayload); break;
L_BMS_Update107:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#152, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,577 :: 		case 9: _sendCommandPacket(0x99, _defaultPayload); break;
L_BMS_Update108:
	ADD	W14, #18, W0
	MOV	W0, W11
	MOV.B	#153, W10
	CALL	BMS__sendCommandPacket
	GOTO	L_BMS_Update98
;BMS.c,578 :: 		default: break;
L_BMS_Update109:
	GOTO	L_BMS_Update98
;BMS.c,579 :: 		}
L_BMS_Update97:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA NZ	L__BMS_Update198
	GOTO	L_BMS_Update99
L__BMS_Update198:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA NZ	L__BMS_Update199
	GOTO	L_BMS_Update100
L__BMS_Update199:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__BMS_Update200
	GOTO	L_BMS_Update101
L__BMS_Update200:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA NZ	L__BMS_Update201
	GOTO	L_BMS_Update102
L__BMS_Update201:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA NZ	L__BMS_Update202
	GOTO	L_BMS_Update103
L__BMS_Update202:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA NZ	L__BMS_Update203
	GOTO	L_BMS_Update104
L__BMS_Update203:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #6
	BRA NZ	L__BMS_Update204
	GOTO	L_BMS_Update105
L__BMS_Update204:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #7
	BRA NZ	L__BMS_Update205
	GOTO	L_BMS_Update106
L__BMS_Update205:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #8
	BRA NZ	L__BMS_Update206
	GOTO	L_BMS_Update107
L__BMS_Update206:
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #9
	BRA NZ	L__BMS_Update207
	GOTO	L_BMS_Update108
L__BMS_Update207:
	GOTO	L_BMS_Update109
L_BMS_Update98:
;BMS.c,580 :: 		_defaultCommandIndex++;
	MOV.B	#1, W1
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	ADD.B	W1, [W0], [W0]
;BMS.c,581 :: 		if (_defaultCommandIndex >= 10)
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA GEU	L__BMS_Update208
	GOTO	L_BMS_Update110
L__BMS_Update208:
;BMS.c,582 :: 		_defaultCommandIndex = 0;
	MOV	#lo_addr(BMS_Update__defaultCommandIndex_L0), W1
	CLR	W0
	MOV.B	W0, [W1]
L_BMS_Update110:
;BMS.c,583 :: 		}
L_BMS_Update96:
L_BMS_Update94:
;BMS.c,584 :: 		}
L_end_BMS_Update:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _BMS_Update

_BMS_Init:

;BMS.c,589 :: 		void BMS_Init(void) {
;BMS.c,591 :: 		_bmsData._sumVoltage = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData
	MOV	W1, __bmsData+2
;BMS.c,592 :: 		_bmsData._sumCurrent = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData+4
	MOV	W1, __bmsData+6
;BMS.c,593 :: 		_bmsData._sumSOC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData+8
	MOV	W1, __bmsData+10
;BMS.c,594 :: 		_bmsData._temperature = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData+36
	MOV	W1, __bmsData+38
;BMS.c,595 :: 		_bmsData._cycleCount = 0;
	CLR	W0
	MOV	W0, __bmsData+40
;BMS.c,596 :: 		_bmsData._protectionFlags = 0;
	MOV	#lo_addr(__bmsData+42), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,597 :: 		_bmsData._cellVoltages[0] = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData+16
	MOV	W1, __bmsData+18
;BMS.c,598 :: 		_bmsData._cellVoltages[1] = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData+20
	MOV	W1, __bmsData+22
;BMS.c,599 :: 		_bmsData._cellVoltages[2] = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData+24
	MOV	W1, __bmsData+26
;BMS.c,600 :: 		_bmsData._cellVoltages[3] = 0;
	CLR	W0
	CLR	W1
	MOV	W0, __bmsData+28
	MOV	W1, __bmsData+30
;BMS.c,603 :: 		_txBufferHead = 0;
	MOV	#lo_addr(__txBufferHead), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,604 :: 		_txBufferTail = 0;
	MOV	#lo_addr(__txBufferTail), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,605 :: 		_immediateQueueHead = 0;
	MOV	#lo_addr(__immediateQueueHead), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,606 :: 		_immediateQueueTail = 0;
	MOV	#lo_addr(__immediateQueueTail), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,607 :: 		_rxBufferHead = 0;
	MOV	#lo_addr(__rxBufferHead), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,608 :: 		_rxBufferTail = 0;
	MOV	#lo_addr(__rxBufferTail), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,609 :: 		_txBusy = 0;
	MOV	#lo_addr(__txBusy), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,611 :: 		_bmsData._charge_current_limit = 0;
	MOV	#lo_addr(__bmsData+88), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,612 :: 		_bmsData._discharge_current_limit = 0;
	MOV	#lo_addr(__bmsData+89), W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,614 :: 		IEC0bits.U1RXIE = 1;
	BSET	IEC0bits, #11
;BMS.c,615 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;BMS.c,616 :: 		}
L_end_BMS_Init:
	RETURN
; end of _BMS_Init

__UART1_Interrupt:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;BMS.c,623 :: 		void _UART1_Interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
;BMS.c,630 :: 		while (UART1_Data_Ready()) {
L__UART1_Interrupt111:
	CALL	_UART1_Data_Ready
	CP0	W0
	BRA NZ	L___UART1_Interrupt211
	GOTO	L__UART1_Interrupt112
L___UART1_Interrupt211:
;BMS.c,631 :: 		_byte = UART1_Read();  // ??c 1 byte t? UART1
	CALL	_UART1_Read
; _byte start address is: 6 (W3)
	MOV.B	W0, W3
;BMS.c,634 :: 		_next = (_rxBufferHead + 1) % _RX_BUFFER_SIZE;
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W0
	INC	W0
	MOV	#50, W2
	REPEAT	#17
	DIV.S	W0, W2
; _next start address is: 8 (W4)
	MOV	W1, W4
;BMS.c,635 :: 		if (_next != _rxBufferTail) {  // N?u buffer chua d?y
	MOV	#lo_addr(__rxBufferTail), W0
	ZE	[W0], W0
	CP	W1, W0
	BRA NZ	L___UART1_Interrupt212
	GOTO	L__UART1_Interrupt113
L___UART1_Interrupt212:
;BMS.c,636 :: 		_rxBuffer[_rxBufferHead] = _byte;  // Luu byte v?o buffer
	MOV	#lo_addr(__rxBufferHead), W0
	ZE	[W0], W1
	MOV	#lo_addr(__rxBuffer), W0
	ADD	W0, W1, W0
	MOV.B	W3, [W0]
; _byte end address is: 6 (W3)
;BMS.c,637 :: 		_rxBufferHead = _next;             // C?p nh?t ch? s? head
	MOV	#lo_addr(__rxBufferHead), W0
	MOV.B	W4, [W0]
; _next end address is: 8 (W4)
;BMS.c,638 :: 		}
L__UART1_Interrupt113:
;BMS.c,639 :: 		}
	GOTO	L__UART1_Interrupt111
L__UART1_Interrupt112:
;BMS.c,642 :: 		IFS0bits.U1RXIF = 0;
	BCLR	IFS0bits, #11
;BMS.c,643 :: 		}
L_end__UART1_Interrupt:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of __UART1_Interrupt
