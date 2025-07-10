
_DalyBms_Init:

;BMS.c,41 :: 		void DalyBms_Init(DalyBms* bms) {
;BMS.c,43 :: 		bms->previousTime = 0;
	PUSH	W11
	PUSH	W12
	CLR	W0
	CLR	W1
	MOV.D	W0, [W10]
;BMS.c,44 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,45 :: 		bms->soft_tx = 0;
	ADD	W10, #6, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,46 :: 		bms->soft_rx = 0;
	ADD	W10, #8, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,47 :: 		bms->getStaticData = false;
	MOV	#402, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,48 :: 		bms->errorCounter = 0;
	MOV	#404, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,49 :: 		bms->requestCount = 0;
	MOV	#406, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,50 :: 		bms->frameCount = 0;
	MOV	#758, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,51 :: 		bms->requestCallback = NULL;
	MOV	#760, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,54 :: 		memset(bms->failCodeArr, 0, sizeof(bms->failCodeArr));
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#32, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;BMS.c,55 :: 		memset(bms->my_txBuffer, 0, XFER_BUFFER_LENGTH);
	MOV	#420, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;BMS.c,56 :: 		memset(bms->my_rxBuffer, 0, XFER_BUFFER_LENGTH);
	MOV	#433, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;BMS.c,57 :: 		memset(bms->my_rxFrameBuffer, 0, sizeof(bms->my_rxFrameBuffer));
	MOV	#446, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;BMS.c,58 :: 		memset(bms->frameBuff, 0, sizeof(bms->frameBuff));
	MOV	#602, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;BMS.c,59 :: 		memset(bms->commandQueue, 0x100, sizeof(bms->commandQueue));
	MOV	#408, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#10, W12
	MOV.B	#0, W11
	MOV	W0, W10
	CALL	_memset
;BMS.c,62 :: 		_UART1_Init();
	CALL	__UART1_Init
	POP	W10
;BMS.c,65 :: 		DalyBms_clearGet(bms);
	CALL	BMS_DalyBms_clearGet
;BMS.c,66 :: 		}
L_end_DalyBms_Init:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_Init

_DalyBms_update:
	LNK	#4

;BMS.c,68 :: 		bool DalyBms_update(DalyBms* bms)
;BMS.c,70 :: 		if (current_millis() - bms->previousTime >= DELAYTINME)
	CALL	_current_millis
	MOV.D	[W10], W2
	SUB	W0, W2, W2
	SUBB	W1, W3, W3
	MOV	#150, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA GEU	L__DalyBms_update247
	GOTO	L_DalyBms_update0
L__DalyBms_update247:
;BMS.c,72 :: 		switch (bms->requestCounter)
	ADD	W10, #4, W0
	MOV	W0, [W14+2]
	GOTO	L_DalyBms_update1
;BMS.c,74 :: 		case 0:
L_DalyBms_update3:
;BMS.c,75 :: 		bms->requestCounter++;
	ADD	W10, #4, W1
	MOV.B	[W1], W0
	ADD.B	W0, #1, [W1]
;BMS.c,76 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,77 :: 		case 1:
L_DalyBms_update4:
;BMS.c,78 :: 		if (DalyBms_getPackMeasurements(bms))
	PUSH	W10
	CALL	_DalyBms_getPackMeasurements
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update248
	GOTO	L_DalyBms_update5
L__DalyBms_update248:
;BMS.c,80 :: 		bms->get.connectionState = true;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#359, W0
	ADD	W1, W0, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,81 :: 		bms->errorCounter = 0;
	MOV	#404, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,82 :: 		bms->requestCounter++;
	ADD	W10, #4, W1
	MOV.B	[W1], W0
	ADD.B	W0, #1, [W1]
;BMS.c,83 :: 		}
	GOTO	L_DalyBms_update6
L_DalyBms_update5:
;BMS.c,86 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,87 :: 		if (bms->errorCounter < ERRORCOUNTER)
	MOV	#404, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #10
	BRA LTU	L__DalyBms_update249
	GOTO	L_DalyBms_update7
L__DalyBms_update249:
;BMS.c,89 :: 		bms->errorCounter++;
	MOV	#404, W0
	ADD	W10, W0, W1
	MOV	[W1], W0
	INC	W0
	MOV	W0, [W1]
;BMS.c,90 :: 		}
	GOTO	L_DalyBms_update8
L_DalyBms_update7:
;BMS.c,93 :: 		bms->get.connectionState = false;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#359, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,94 :: 		bms->errorCounter = 0;
	MOV	#404, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,95 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update250
	GOTO	L_DalyBms_update9
L__DalyBms_update250:
;BMS.c,96 :: 		bms->requestCallback(); // Call the callback function
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,97 :: 		}
L_DalyBms_update9:
;BMS.c,99 :: 		}
L_DalyBms_update8:
;BMS.c,100 :: 		}
L_DalyBms_update6:
;BMS.c,101 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,102 :: 		case 2:
L_DalyBms_update10:
;BMS.c,103 :: 		bms->requestCounter = DalyBms_getMinMaxCellVoltage(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getMinMaxCellVoltage
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update251
	GOTO	L_DalyBms_update11
L__DalyBms_update251:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T165 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T165 end address is: 2 (W1)
	GOTO	L_DalyBms_update12
L_DalyBms_update11:
; ?FLOC___DalyBms_update?T165 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T165 end address is: 2 (W1)
L_DalyBms_update12:
; ?FLOC___DalyBms_update?T165 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T165 end address is: 2 (W1)
;BMS.c,104 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,105 :: 		case 3:
L_DalyBms_update13:
;BMS.c,106 :: 		bms->requestCounter = DalyBms_getPackTemp(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getPackTemp
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update252
	GOTO	L_DalyBms_update14
L__DalyBms_update252:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T176 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T176 end address is: 2 (W1)
	GOTO	L_DalyBms_update15
L_DalyBms_update14:
; ?FLOC___DalyBms_update?T176 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T176 end address is: 2 (W1)
L_DalyBms_update15:
; ?FLOC___DalyBms_update?T176 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T176 end address is: 2 (W1)
;BMS.c,107 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,108 :: 		case 4:
L_DalyBms_update16:
;BMS.c,109 :: 		bms->requestCounter = DalyBms_getDischargeChargeMosStatus(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getDischargeChargeMosStatus
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update253
	GOTO	L_DalyBms_update17
L__DalyBms_update253:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T187 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T187 end address is: 2 (W1)
	GOTO	L_DalyBms_update18
L_DalyBms_update17:
; ?FLOC___DalyBms_update?T187 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T187 end address is: 2 (W1)
L_DalyBms_update18:
; ?FLOC___DalyBms_update?T187 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T187 end address is: 2 (W1)
;BMS.c,110 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,111 :: 		case 5:
L_DalyBms_update19:
;BMS.c,112 :: 		bms->requestCounter = DalyBms_getStatusInfo(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getStatusInfo
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update254
	GOTO	L_DalyBms_update20
L__DalyBms_update254:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T198 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T198 end address is: 2 (W1)
	GOTO	L_DalyBms_update21
L_DalyBms_update20:
; ?FLOC___DalyBms_update?T198 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T198 end address is: 2 (W1)
L_DalyBms_update21:
; ?FLOC___DalyBms_update?T198 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T198 end address is: 2 (W1)
;BMS.c,113 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,114 :: 		case 6:
L_DalyBms_update22:
;BMS.c,115 :: 		bms->requestCounter = DalyBms_getCellVoltages(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getCellVoltages
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update255
	GOTO	L_DalyBms_update23
L__DalyBms_update255:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T209 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T209 end address is: 2 (W1)
	GOTO	L_DalyBms_update24
L_DalyBms_update23:
; ?FLOC___DalyBms_update?T209 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T209 end address is: 2 (W1)
L_DalyBms_update24:
; ?FLOC___DalyBms_update?T209 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T209 end address is: 2 (W1)
;BMS.c,116 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,117 :: 		case 7:
L_DalyBms_update25:
;BMS.c,118 :: 		bms->requestCounter = DalyBms_getCellTemperature(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getCellTemperature
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update256
	GOTO	L_DalyBms_update26
L__DalyBms_update256:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T220 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T220 end address is: 2 (W1)
	GOTO	L_DalyBms_update27
L_DalyBms_update26:
; ?FLOC___DalyBms_update?T220 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T220 end address is: 2 (W1)
L_DalyBms_update27:
; ?FLOC___DalyBms_update?T220 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T220 end address is: 2 (W1)
;BMS.c,119 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,120 :: 		case 8:
L_DalyBms_update28:
;BMS.c,121 :: 		bms->requestCounter = DalyBms_getCellBalanceState(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getCellBalanceState
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update257
	GOTO	L_DalyBms_update29
L__DalyBms_update257:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T231 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T231 end address is: 2 (W1)
	GOTO	L_DalyBms_update30
L_DalyBms_update29:
; ?FLOC___DalyBms_update?T231 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T231 end address is: 2 (W1)
L_DalyBms_update30:
; ?FLOC___DalyBms_update?T231 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T231 end address is: 2 (W1)
;BMS.c,122 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,123 :: 		case 9:
L_DalyBms_update31:
;BMS.c,124 :: 		bms->requestCounter = DalyBms_getFailureCodes(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getFailureCodes
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update258
	GOTO	L_DalyBms_update32
L__DalyBms_update258:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T242 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T242 end address is: 2 (W1)
	GOTO	L_DalyBms_update33
L_DalyBms_update32:
; ?FLOC___DalyBms_update?T242 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T242 end address is: 2 (W1)
L_DalyBms_update33:
; ?FLOC___DalyBms_update?T242 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T242 end address is: 2 (W1)
;BMS.c,125 :: 		if (bms->getStaticData)
	MOV	#402, W0
	ADD	W10, W0, W0
	CP0.B	[W0]
	BRA NZ	L__DalyBms_update259
	GOTO	L_DalyBms_update34
L__DalyBms_update259:
;BMS.c,126 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
L_DalyBms_update34:
;BMS.c,127 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update260
	GOTO	L_DalyBms_update35
L__DalyBms_update260:
;BMS.c,128 :: 		bms->requestCallback();
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,129 :: 		}
L_DalyBms_update35:
;BMS.c,130 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,131 :: 		case 10:
L_DalyBms_update36:
;BMS.c,132 :: 		if (!bms->getStaticData)
	MOV	#402, W0
	ADD	W10, W0, W0
	CP0.B	[W0]
	BRA Z	L__DalyBms_update261
	GOTO	L_DalyBms_update37
L__DalyBms_update261:
;BMS.c,133 :: 		bms->requestCounter = DalyBms_getVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getVoltageThreshold
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update262
	GOTO	L_DalyBms_update38
L__DalyBms_update262:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T280 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T280 end address is: 2 (W1)
	GOTO	L_DalyBms_update39
L_DalyBms_update38:
; ?FLOC___DalyBms_update?T280 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T280 end address is: 2 (W1)
L_DalyBms_update39:
; ?FLOC___DalyBms_update?T280 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T280 end address is: 2 (W1)
L_DalyBms_update37:
;BMS.c,134 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update263
	GOTO	L_DalyBms_update40
L__DalyBms_update263:
;BMS.c,135 :: 		bms->requestCallback();
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,136 :: 		}
L_DalyBms_update40:
;BMS.c,137 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,138 :: 		case 11:
L_DalyBms_update41:
;BMS.c,139 :: 		if (!bms->getStaticData)
	MOV	#402, W0
	ADD	W10, W0, W0
	CP0.B	[W0]
	BRA Z	L__DalyBms_update264
	GOTO	L_DalyBms_update42
L__DalyBms_update264:
;BMS.c,140 :: 		bms->requestCounter = DalyBms_getPackVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getPackVoltageThreshold
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update265
	GOTO	L_DalyBms_update43
L__DalyBms_update265:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T309 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T309 end address is: 2 (W1)
	GOTO	L_DalyBms_update44
L_DalyBms_update43:
; ?FLOC___DalyBms_update?T309 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T309 end address is: 2 (W1)
L_DalyBms_update44:
; ?FLOC___DalyBms_update?T309 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T309 end address is: 2 (W1)
L_DalyBms_update42:
;BMS.c,141 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,142 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update266
	GOTO	L_DalyBms_update45
L__DalyBms_update266:
;BMS.c,143 :: 		bms->requestCallback();
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,144 :: 		}
L_DalyBms_update45:
;BMS.c,145 :: 		bms->getStaticData = true;
	MOV	#402, W0
	ADD	W10, W0, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,146 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,148 :: 		default:
L_DalyBms_update46:
;BMS.c,149 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,150 :: 		}
L_DalyBms_update1:
	MOV	[W14+2], W1
	MOV.B	[W1], W0
	CP.B	W0, #0
	BRA NZ	L__DalyBms_update267
	GOTO	L_DalyBms_update3
L__DalyBms_update267:
	MOV.B	[W1], W0
	CP.B	W0, #1
	BRA NZ	L__DalyBms_update268
	GOTO	L_DalyBms_update4
L__DalyBms_update268:
	MOV.B	[W1], W0
	CP.B	W0, #2
	BRA NZ	L__DalyBms_update269
	GOTO	L_DalyBms_update10
L__DalyBms_update269:
	MOV.B	[W1], W0
	CP.B	W0, #3
	BRA NZ	L__DalyBms_update270
	GOTO	L_DalyBms_update13
L__DalyBms_update270:
	MOV.B	[W1], W0
	CP.B	W0, #4
	BRA NZ	L__DalyBms_update271
	GOTO	L_DalyBms_update16
L__DalyBms_update271:
	MOV.B	[W1], W0
	CP.B	W0, #5
	BRA NZ	L__DalyBms_update272
	GOTO	L_DalyBms_update19
L__DalyBms_update272:
	MOV.B	[W1], W0
	CP.B	W0, #6
	BRA NZ	L__DalyBms_update273
	GOTO	L_DalyBms_update22
L__DalyBms_update273:
	MOV.B	[W1], W0
	CP.B	W0, #7
	BRA NZ	L__DalyBms_update274
	GOTO	L_DalyBms_update25
L__DalyBms_update274:
	MOV.B	[W1], W0
	CP.B	W0, #8
	BRA NZ	L__DalyBms_update275
	GOTO	L_DalyBms_update28
L__DalyBms_update275:
	MOV.B	[W1], W0
	CP.B	W0, #9
	BRA NZ	L__DalyBms_update276
	GOTO	L_DalyBms_update31
L__DalyBms_update276:
	MOV.B	[W1], W0
	CP.B	W0, #10
	BRA NZ	L__DalyBms_update277
	GOTO	L_DalyBms_update36
L__DalyBms_update277:
	MOV.B	[W1], W0
	CP.B	W0, #11
	BRA NZ	L__DalyBms_update278
	GOTO	L_DalyBms_update41
L__DalyBms_update278:
	GOTO	L_DalyBms_update46
L_DalyBms_update2:
;BMS.c,151 :: 		bms->previousTime = current_millis();
	MOV	W10, W0
	MOV	W0, [W14+0]
	CALL	_current_millis
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,152 :: 		}
L_DalyBms_update0:
;BMS.c,153 :: 		return true;
	MOV.B	#1, W0
;BMS.c,154 :: 		}
L_end_DalyBms_update:
	ULNK
	RETURN
; end of _DalyBms_update

_DalyBms_getVoltageThreshold:
	LNK	#2

;BMS.c,156 :: 		bool DalyBms_getVoltageThreshold(DalyBms* bms) // 0x59
;BMS.c,158 :: 		if (!DalyBms_requestData(bms, CELL_THRESHOLDS, 1))
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#89, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getVoltageThreshold280
	GOTO	L_DalyBms_getVoltageThreshold47
L__DalyBms_getVoltageThreshold280:
;BMS.c,160 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getVoltageThreshold
;BMS.c,161 :: 		}
L_DalyBms_getVoltageThreshold47:
;BMS.c,163 :: 		bms->get.maxCellThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
	MOV	#42, W0
	ADD	W10, W0, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,164 :: 		bms->get.maxCellThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
	MOV	#42, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #7, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,165 :: 		bms->get.minCellThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
	MOV	#42, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,166 :: 		bms->get.minCellThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);
	MOV	#42, W0
	ADD	W10, W0, W0
	ADD	W0, #12, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #11, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	CLR	W1
	CALL	__Long2Float
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,168 :: 		return true;
	MOV.B	#1, W0
;BMS.c,169 :: 		}
;BMS.c,168 :: 		return true;
;BMS.c,169 :: 		}
L_end_DalyBms_getVoltageThreshold:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getVoltageThreshold

_DalyBms_getPackVoltageThreshold:
	LNK	#2

;BMS.c,171 :: 		bool DalyBms_getPackVoltageThreshold(DalyBms* bms) // 0x5A
;BMS.c,173 :: 		if (!DalyBms_requestData(bms, PACK_THRESHOLDS, 1))
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#90, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getPackVoltageThreshold282
	GOTO	L_DalyBms_getPackVoltageThreshold48
L__DalyBms_getPackVoltageThreshold282:
;BMS.c,175 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackVoltageThreshold
;BMS.c,176 :: 		}
L_DalyBms_getPackVoltageThreshold48:
;BMS.c,178 :: 		bms->get.maxPackThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
	MOV	#42, W0
	ADD	W10, W0, W0
	ADD	W0, #16, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,179 :: 		bms->get.maxPackThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
	MOV	#42, W0
	ADD	W10, W0, W0
	ADD	W0, #24, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #7, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,180 :: 		bms->get.minPackThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
	MOV	#42, W0
	ADD	W10, W0, W0
	ADD	W0, #20, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,181 :: 		bms->get.minPackThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);
	MOV	#42, W0
	ADD	W10, W0, W0
	ADD	W0, #28, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #11, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	CLR	W1
	CALL	__Long2Float
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,183 :: 		return true;
	MOV.B	#1, W0
;BMS.c,184 :: 		}
;BMS.c,183 :: 		return true;
;BMS.c,184 :: 		}
L_end_DalyBms_getPackVoltageThreshold:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getPackVoltageThreshold

_DalyBms_getPackMeasurements:
	LNK	#2

;BMS.c,186 :: 		bool DalyBms_getPackMeasurements(DalyBms* bms) // 0x90
;BMS.c,188 :: 		if (!DalyBms_requestData(bms, VOUT_IOUT_SOC, 1))
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#144, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getPackMeasurements284
	GOTO	L_DalyBms_getPackMeasurements49
L__DalyBms_getPackMeasurements284:
;BMS.c,190 :: 		DalyBms_clearGet(bms);
	CALL	BMS_DalyBms_clearGet
;BMS.c,191 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackMeasurements
;BMS.c,192 :: 		}
L_DalyBms_getPackMeasurements49:
;BMS.c,196 :: 		if (((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f) == -3000.f)
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W1
	MOV	#30000, W0
	SUB	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	#32768, W2
	MOV	#50491, W3
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA NZ	L__DalyBms_getPackMeasurements285
	INC.B	W0
L__DalyBms_getPackMeasurements285:
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_getPackMeasurements286
	GOTO	L_DalyBms_getPackMeasurements51
L__DalyBms_getPackMeasurements286:
;BMS.c,198 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackMeasurements
;BMS.c,199 :: 		}
L_DalyBms_getPackMeasurements51:
;BMS.c,202 :: 		if (((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f) > 100.f)
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #11, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	#0, W2
	MOV	#17096, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L__DalyBms_getPackMeasurements287
	INC.B	W0
L__DalyBms_getPackMeasurements287:
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_getPackMeasurements288
	GOTO	L_DalyBms_getPackMeasurements53
L__DalyBms_getPackMeasurements288:
;BMS.c,204 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackMeasurements
;BMS.c,205 :: 		}
L_DalyBms_getPackMeasurements53:
;BMS.c,208 :: 		bms->get.packVoltage = ((float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]) / 10.0f);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#32, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,209 :: 		bms->get.packCurrent = ((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#36, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #9, W0
	ZE	[W0], W0
	IOR	W1, W0, W1
	MOV	#30000, W0
	SUB	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,210 :: 		bms->get.packSOC = ((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#40, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #11, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Div_FP
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,211 :: 		return true;
	MOV.B	#1, W0
;BMS.c,212 :: 		}
;BMS.c,211 :: 		return true;
;BMS.c,212 :: 		}
L_end_DalyBms_getPackMeasurements:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getPackMeasurements

_DalyBms_getMinMaxCellVoltage:
	LNK	#2

;BMS.c,214 :: 		bool DalyBms_getMinMaxCellVoltage(DalyBms* bms) // 0x91
;BMS.c,216 :: 		if (!DalyBms_requestData(bms, MIN_MAX_CELL_VOLTAGE, 1))
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#145, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getMinMaxCellVoltage290
	GOTO	L_DalyBms_getMinMaxCellVoltage54
L__DalyBms_getMinMaxCellVoltage290:
;BMS.c,218 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getMinMaxCellVoltage
;BMS.c,219 :: 		}
L_DalyBms_getMinMaxCellVoltage54:
;BMS.c,221 :: 		bms->get.maxCellmV = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#44, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #5, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,222 :: 		bms->get.maxCellVNum = bms->frameBuff[0][6];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#48, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,223 :: 		bms->get.minCellmV = (float)((bms->frameBuff[0][7] << 8) | bms->frameBuff[0][8]);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#50, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #8, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,224 :: 		bms->get.minCellVNum = bms->frameBuff[0][9];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#54, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,225 :: 		bms->get.cellDiff = (bms->get.maxCellmV - bms->get.minCellmV);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#56, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+0]
	MOV	#44, W0
	ADD	W1, W0, W0
	MOV.D	[W0], W4
	MOV	#50, W0
	ADD	W1, W0, W0
	MOV.D	[W0], W2
	MOV.D	W4, W0
	CALL	__Sub_FP
	CALL	__Float2Longint
	MOV	[W14+0], W1
	MOV	W0, [W1]
;BMS.c,227 :: 		return true;
	MOV.B	#1, W0
;BMS.c,228 :: 		}
;BMS.c,227 :: 		return true;
;BMS.c,228 :: 		}
L_end_DalyBms_getMinMaxCellVoltage:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getMinMaxCellVoltage

_DalyBms_getPackTemp:
	LNK	#2

;BMS.c,230 :: 		bool DalyBms_getPackTemp(DalyBms* bms) // 0x92
;BMS.c,232 :: 		if (!DalyBms_requestData(bms, MIN_MAX_TEMPERATURE, 1))
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#146, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getPackTemp292
	GOTO	L_DalyBms_getPackTemp55
L__DalyBms_getPackTemp292:
;BMS.c,234 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackTemp
;BMS.c,235 :: 		}
L_DalyBms_getPackTemp55:
;BMS.c,236 :: 		bms->get.tempAverage = ((bms->frameBuff[0][4] - 40) + (bms->frameBuff[0][6] - 40)) / 2;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#58, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+0]
	MOV	#602, W0
	ADD	W10, W0, W3
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
	MOV	W0, W1
	MOV	[W14+0], W0
	MOV	W1, [W0]
;BMS.c,238 :: 		return true;
	MOV.B	#1, W0
;BMS.c,239 :: 		}
;BMS.c,238 :: 		return true;
;BMS.c,239 :: 		}
L_end_DalyBms_getPackTemp:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getPackTemp

_DalyBms_getDischargeChargeMosStatus:
	LNK	#18

;BMS.c,241 :: 		bool DalyBms_getDischargeChargeMosStatus(DalyBms* bms) // 0x93
;BMS.c,246 :: 		if (!DalyBms_requestData(bms, DISCHARGE_CHARGE_MOS_STATUS, 1))
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#147, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getDischargeChargeMosStatus294
	GOTO	L_DalyBms_getDischargeChargeMosStatus56
L__DalyBms_getDischargeChargeMosStatus294:
;BMS.c,248 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getDischargeChargeMosStatus
;BMS.c,249 :: 		}
L_DalyBms_getDischargeChargeMosStatus56:
;BMS.c,251 :: 		switch (bms->frameBuff[0][4])
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W2
	GOTO	L_DalyBms_getDischargeChargeMosStatus57
;BMS.c,253 :: 		case 0:
L_DalyBms_getDischargeChargeMosStatus59:
;BMS.c,254 :: 		bms->get.chargeDischargeStatus = "Stationary";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_1_BMS), W0
	MOV	W0, [W1]
;BMS.c,255 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,256 :: 		case 1:
L_DalyBms_getDischargeChargeMosStatus60:
;BMS.c,257 :: 		bms->get.chargeDischargeStatus = "Charge";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_2_BMS), W0
	MOV	W0, [W1]
;BMS.c,258 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,259 :: 		case 2:
L_DalyBms_getDischargeChargeMosStatus61:
;BMS.c,260 :: 		bms->get.chargeDischargeStatus = "Discharge";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_3_BMS), W0
	MOV	W0, [W1]
;BMS.c,261 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,262 :: 		default:
L_DalyBms_getDischargeChargeMosStatus62:
;BMS.c,263 :: 		bms->get.chargeDischargeStatus = "Unknown";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_4_BMS), W0
	MOV	W0, [W1]
;BMS.c,264 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,265 :: 		}
L_DalyBms_getDischargeChargeMosStatus57:
	MOV.B	[W2], W0
	CP.B	W0, #0
	BRA NZ	L__DalyBms_getDischargeChargeMosStatus295
	GOTO	L_DalyBms_getDischargeChargeMosStatus59
L__DalyBms_getDischargeChargeMosStatus295:
	MOV.B	[W2], W0
	CP.B	W0, #1
	BRA NZ	L__DalyBms_getDischargeChargeMosStatus296
	GOTO	L_DalyBms_getDischargeChargeMosStatus60
L__DalyBms_getDischargeChargeMosStatus296:
	MOV.B	[W2], W0
	CP.B	W0, #2
	BRA NZ	L__DalyBms_getDischargeChargeMosStatus297
	GOTO	L_DalyBms_getDischargeChargeMosStatus61
L__DalyBms_getDischargeChargeMosStatus297:
	GOTO	L_DalyBms_getDischargeChargeMosStatus62
L_DalyBms_getDischargeChargeMosStatus58:
;BMS.c,267 :: 		bms->get.chargeFetState = BIT_READ(bms->frameBuff[0][5], 0); // Assuming 0 or 1 indicates state
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#62, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	ZE	[W0], W0
	AND	W0, #1, W0
	MOV.B	W0, [W1]
;BMS.c,268 :: 		bms->get.disChargeFetState = BIT_READ(bms->frameBuff[0][6], 0); // Assuming 0 or 1 indicates state
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#63, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	ZE	[W0], W0
	AND	W0, #1, W0
	MOV.B	W0, [W1]
;BMS.c,269 :: 		bms->get.bmsHeartBeat = bms->frameBuff[0][7];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#64, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,270 :: 		tmpAh = (float)(((uint32_t)bms->frameBuff[0][8] << 0x18) | ((uint32_t)bms->frameBuff[0][9] << 0x10) | ((uint32_t)bms->frameBuff[0][10] << 0x08) | (uint32_t)bms->frameBuff[0][11]) * 0.001;
	MOV	#602, W0
	ADD	W10, W0, W6
	ADD	W6, #8, W0
	ZE	[W0], W0
	CLR	W1
	SL	W0, #8, W3
	CLR	W2
	ADD	W6, #9, W0
	ZE	[W0], W0
	CLR	W1
	MOV	W0, W1
	CLR	W0
	IOR	W2, W0, W4
	IOR	W3, W1, W5
	ADD	W6, #10, W0
	ZE	[W0], W2
	CLR	W3
	SL	W3, #8, W1
	LSR	W2, #8, W0
	IOR	W0, W1, W1
	SL	W2, #8, W0
	IOR	W4, W0, W2
	IOR	W5, W1, W3
	ADD	W6, #11, W0
	ZE	[W0], W0
	CLR	W1
	IOR	W2, W0, W0
	IOR	W3, W1, W1
	PUSH	W10
	CALL	__Long2Float
	MOV	#4719, W2
	MOV	#14979, W3
	CALL	__Mul_FP
;BMS.c,271 :: 		sprintf(msgbuff, "%.1f", tmpAh); // Use sprintf for float to string conversion
	ADD	W14, #0, W2
	PUSH.D	W0
	MOV	#lo_addr(?lstr_5_BMS), W0
	PUSH	W0
	PUSH	W2
	CALL	_sprintf
	SUB	#8, W15
	POP	W10
;BMS.c,272 :: 		bms->get.resCapacityAh = atof(msgbuff);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#66, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+16]
	ADD	W14, #0, W0
	MOV	W0, W10
	CALL	_atof
	MOV	[W14+16], W2
	MOV.D	W0, [W2]
;BMS.c,274 :: 		return true;
	MOV.B	#1, W0
;BMS.c,275 :: 		}
;BMS.c,274 :: 		return true;
;BMS.c,275 :: 		}
L_end_DalyBms_getDischargeChargeMosStatus:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _DalyBms_getDischargeChargeMosStatus

_DalyBms_getStatusInfo:

;BMS.c,277 :: 		bool DalyBms_getStatusInfo(DalyBms* bms) // 0x94
;BMS.c,281 :: 		if (!DalyBms_requestData(bms, STATUS_INFO, 1))
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#148, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getStatusInfo299
	GOTO	L_DalyBms_getStatusInfo63
L__DalyBms_getStatusInfo299:
;BMS.c,283 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getStatusInfo
;BMS.c,284 :: 		}
L_DalyBms_getStatusInfo63:
;BMS.c,286 :: 		bms->get.numberOfCells = bms->frameBuff[0][4];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,287 :: 		bms->get.numOfTempSensors = bms->frameBuff[0][5];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,288 :: 		bms->get.chargeState = BIT_READ(bms->frameBuff[0][6], 0); // Assuming 0 or 1 indicates state
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#74, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	ZE	[W0], W0
	AND	W0, #1, W0
	MOV.B	W0, [W1]
;BMS.c,289 :: 		bms->get.loadState = BIT_READ(bms->frameBuff[0][7], 0);   // Assuming 0 or 1 indicates state
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#75, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	ZE	[W0], W0
	AND	W0, #1, W0
	MOV.B	W0, [W1]
;BMS.c,292 :: 		for (i = 0; i < 8; i++)
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_DalyBms_getStatusInfo64:
; i start address is: 4 (W2)
	CP	W2, #8
	BRA LTU	L__DalyBms_getStatusInfo300
	GOTO	L_DalyBms_getStatusInfo65
L__DalyBms_getStatusInfo300:
;BMS.c,294 :: 		bms->get.dIO[i] = BIT_READ(bms->frameBuff[0][8], i);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#76, W0
	ADD	W1, W0, W0
	ADD	W0, W2, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, W2, W0
	ZE	W0, W0
	AND	W0, #1, W0
	MOV.B	W0, [W1]
;BMS.c,292 :: 		for (i = 0; i < 8; i++)
	INC	W2
;BMS.c,295 :: 		}
; i end address is: 4 (W2)
	GOTO	L_DalyBms_getStatusInfo64
L_DalyBms_getStatusInfo65:
;BMS.c,297 :: 		bms->get.bmsCycles = ((uint16_t)bms->frameBuff[0][9] << 0x08) | (uint16_t)bms->frameBuff[0][10];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#84, W0
	ADD	W1, W0, W3
	MOV	#602, W0
	ADD	W10, W0, W2
	ADD	W2, #9, W0
	ZE	[W0], W0
	SL	W0, #8, W1
	ADD	W2, #10, W0
	ZE	[W0], W0
	IOR	W1, W0, [W3]
;BMS.c,299 :: 		return true;
	MOV.B	#1, W0
;BMS.c,300 :: 		}
;BMS.c,299 :: 		return true;
;BMS.c,300 :: 		}
L_end_DalyBms_getStatusInfo:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_getStatusInfo

_DalyBms_getCellVoltages:
	LNK	#8

;BMS.c,302 :: 		bool DalyBms_getCellVoltages(DalyBms* bms) // 0x95
;BMS.c,309 :: 		cellNo = 0;
	PUSH	W11
	PUSH	W12
	CLR	W0
	MOV	W0, [W14+0]
;BMS.c,312 :: 		if (bms->get.numberOfCells < MIN_NUMBER_CELLS || bms->get.numberOfCells > MAX_NUMBER_CELLS)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA GEU	L__DalyBms_getCellVoltages302
	GOTO	L__DalyBms_getCellVoltages232
L__DalyBms_getCellVoltages302:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W1
	MOV	#48, W0
	CP	W1, W0
	BRA LEU	L__DalyBms_getCellVoltages303
	GOTO	L__DalyBms_getCellVoltages231
L__DalyBms_getCellVoltages303:
	GOTO	L_DalyBms_getCellVoltages69
L__DalyBms_getCellVoltages232:
L__DalyBms_getCellVoltages231:
;BMS.c,314 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellVoltages
;BMS.c,315 :: 		}
L_DalyBms_getCellVoltages69:
;BMS.c,317 :: 		if (DalyBms_requestData(bms, CELL_VOLTAGES, (unsigned int)ceil(bms->get.numberOfCells / 3.0)))
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W2
	PUSH	W10
	MOV	[W2], W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16448, W3
	CALL	__Div_FP
	MOV.D	W0, W10
	CALL	_ceil
	CALL	__Float2Longint
	POP	W10
	PUSH	W10
	MOV	W0, W12
	MOV.B	#149, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_getCellVoltages304
	GOTO	L_DalyBms_getCellVoltages70
L__DalyBms_getCellVoltages304:
;BMS.c,319 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numberOfCells / 3.0); k++)
	CLR	W0
	MOV	W0, [W14+2]
L_DalyBms_getCellVoltages71:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W2
	PUSH	W10
	MOV	[W2], W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16448, W3
	CALL	__Div_FP
	MOV.D	W0, W10
	CALL	_ceil
	CALL	__Float2Longint
	POP	W10
	ADD	W14, #2, W1
	CP	W0, [W1]
	BRA GTU	L__DalyBms_getCellVoltages305
	GOTO	L_DalyBms_getCellVoltages72
L__DalyBms_getCellVoltages305:
;BMS.c,321 :: 		for (i = 0; i < 3; i++)
; i start address is: 10 (W5)
	CLR	W5
; i end address is: 10 (W5)
L_DalyBms_getCellVoltages74:
; i start address is: 10 (W5)
	CP	W5, #3
	BRA LTU	L__DalyBms_getCellVoltages306
	GOTO	L_DalyBms_getCellVoltages75
L__DalyBms_getCellVoltages306:
;BMS.c,323 :: 		if (cellNo < MAX_NUMBER_CELLS) { // Ensure no out-of-bounds access
	MOV	#48, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__DalyBms_getCellVoltages307
	GOTO	L_DalyBms_getCellVoltages77
L__DalyBms_getCellVoltages307:
;BMS.c,324 :: 		bms->get.cellVmV[cellNo] = (float)((bms->frameBuff[k][5 + (i * 2)] << 8) | bms->frameBuff[k][6 + (i * 2)]);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#86, W0
	ADD	W1, W0, W1
	MOV	[W14+0], W0
	SL	W0, #2, W0
	ADD	W1, W0, W0
	MOV	W0, [W14+6]
	MOV	#602, W0
	ADD	W10, W0, W4
	MOV	#13, W3
	ADD	W14, #2, W2
	MUL.UU	W3, [W2], W0
	ADD	W4, W0, W3
	SL	W5, #1, W2
	ADD	W2, #5, W0
	ADD	W3, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #8, W1
	ADD	W2, #6, W0
	ADD	W3, W0, W0
	ZE	[W0], W0
	IOR	W1, W0, W0
	PUSH	W5
	PUSH	W10
	CLR	W1
	CALL	__Long2Float
	POP	W10
	POP	W5
	MOV	[W14+6], W2
	MOV.D	W0, [W2]
;BMS.c,325 :: 		}
L_DalyBms_getCellVoltages77:
;BMS.c,326 :: 		cellNo++;
	MOV	[W14+0], W0
	ADD	W0, #1, W2
	MOV	W2, [W14+0]
;BMS.c,327 :: 		if (cellNo >= bms->get.numberOfCells)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W2, W0
	BRA GEU	L__DalyBms_getCellVoltages308
	GOTO	L_DalyBms_getCellVoltages78
L__DalyBms_getCellVoltages308:
; i end address is: 10 (W5)
;BMS.c,328 :: 		break;
	GOTO	L_DalyBms_getCellVoltages75
L_DalyBms_getCellVoltages78:
;BMS.c,321 :: 		for (i = 0; i < 3; i++)
; i start address is: 0 (W0)
; i start address is: 10 (W5)
	ADD	W5, #1, W0
; i end address is: 10 (W5)
;BMS.c,329 :: 		}
	MOV	W0, W5
; i end address is: 0 (W0)
	GOTO	L_DalyBms_getCellVoltages74
L_DalyBms_getCellVoltages75:
;BMS.c,319 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numberOfCells / 3.0); k++)
	MOV	[W14+2], W1
	ADD	W14, #2, W0
	ADD	W1, #1, [W0]
;BMS.c,330 :: 		}
	GOTO	L_DalyBms_getCellVoltages71
L_DalyBms_getCellVoltages72:
;BMS.c,331 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_DalyBms_getCellVoltages
;BMS.c,332 :: 		}
L_DalyBms_getCellVoltages70:
;BMS.c,335 :: 		return false;
	CLR	W0
;BMS.c,337 :: 		}
;BMS.c,335 :: 		return false;
;BMS.c,337 :: 		}
L_end_DalyBms_getCellVoltages:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getCellVoltages

_DalyBms_getCellTemperature:
	LNK	#4

;BMS.c,339 :: 		bool DalyBms_getCellTemperature(DalyBms* bms) // 0x96
;BMS.c,346 :: 		sensorNo = 0;
	PUSH	W11
	PUSH	W12
	CLR	W0
	MOV	W0, [W14+0]
;BMS.c,349 :: 		if ((bms->get.numOfTempSensors < MIN_NUMBER_TEMP_SENSORS) || (bms->get.numOfTempSensors > MAX_NUMBER_TEMP_SENSORS))
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA GEU	L__DalyBms_getCellTemperature310
	GOTO	L__DalyBms_getCellTemperature235
L__DalyBms_getCellTemperature310:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #16
	BRA LEU	L__DalyBms_getCellTemperature311
	GOTO	L__DalyBms_getCellTemperature234
L__DalyBms_getCellTemperature311:
	GOTO	L_DalyBms_getCellTemperature82
L__DalyBms_getCellTemperature235:
L__DalyBms_getCellTemperature234:
;BMS.c,351 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellTemperature
;BMS.c,352 :: 		}
L_DalyBms_getCellTemperature82:
;BMS.c,354 :: 		if (DalyBms_requestData(bms, CELL_TEMPERATURE, (unsigned int)ceil(bms->get.numOfTempSensors / 7.0)))
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W2
	PUSH	W10
	MOV	[W2], W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16608, W3
	CALL	__Div_FP
	MOV.D	W0, W10
	CALL	_ceil
	CALL	__Float2Longint
	POP	W10
	PUSH	W10
	MOV	W0, W12
	MOV.B	#150, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_getCellTemperature312
	GOTO	L_DalyBms_getCellTemperature83
L__DalyBms_getCellTemperature312:
;BMS.c,356 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numOfTempSensors / 7.0); k++)
	CLR	W0
	MOV	W0, [W14+2]
L_DalyBms_getCellTemperature84:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W2
	PUSH	W10
	MOV	[W2], W0
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16608, W3
	CALL	__Div_FP
	MOV.D	W0, W10
	CALL	_ceil
	CALL	__Float2Longint
	POP	W10
	ADD	W14, #2, W1
	CP	W0, [W1]
	BRA GTU	L__DalyBms_getCellTemperature313
	GOTO	L_DalyBms_getCellTemperature85
L__DalyBms_getCellTemperature313:
;BMS.c,358 :: 		for (i = 0; i < 7; i++)
; i start address is: 10 (W5)
	CLR	W5
; i end address is: 10 (W5)
	MOV	W5, W6
L_DalyBms_getCellTemperature87:
; i start address is: 12 (W6)
	CP	W6, #7
	BRA LTU	L__DalyBms_getCellTemperature314
	GOTO	L_DalyBms_getCellTemperature88
L__DalyBms_getCellTemperature314:
;BMS.c,360 :: 		if (sensorNo < MAX_NUMBER_TEMP_SENSORS) { // Ensure no out-of-bounds access
	MOV	[W14+0], W0
	CP	W0, #16
	BRA LTU	L__DalyBms_getCellTemperature315
	GOTO	L_DalyBms_getCellTemperature90
L__DalyBms_getCellTemperature315:
;BMS.c,361 :: 		bms->get.cellTemperature[sensorNo] = (bms->frameBuff[k][5 + i] - 40);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#278, W0
	ADD	W1, W0, W1
	MOV	[W14+0], W0
	SL	W0, #1, W0
	ADD	W1, W0, W5
	MOV	#602, W0
	ADD	W10, W0, W4
	MOV	#13, W3
	ADD	W14, #2, W2
	MUL.UU	W3, [W2], W0
	ADD	W4, W0, W1
	ADD	W6, #5, W0
	ADD	W1, W0, W0
	ZE	[W0], W1
	MOV	#40, W0
	SUB	W1, W0, W0
	MOV	W0, [W5]
;BMS.c,362 :: 		}
L_DalyBms_getCellTemperature90:
;BMS.c,363 :: 		sensorNo++;
	MOV	[W14+0], W0
	ADD	W0, #1, W2
	MOV	W2, [W14+0]
;BMS.c,364 :: 		if (sensorNo >= bms->get.numOfTempSensors)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W2, W0
	BRA GEU	L__DalyBms_getCellTemperature316
	GOTO	L_DalyBms_getCellTemperature91
L__DalyBms_getCellTemperature316:
; i end address is: 12 (W6)
;BMS.c,365 :: 		break;
	GOTO	L_DalyBms_getCellTemperature88
L_DalyBms_getCellTemperature91:
;BMS.c,358 :: 		for (i = 0; i < 7; i++)
; i start address is: 10 (W5)
; i start address is: 12 (W6)
	ADD	W6, #1, W5
; i end address is: 12 (W6)
;BMS.c,366 :: 		}
	MOV	W5, W6
; i end address is: 10 (W5)
	GOTO	L_DalyBms_getCellTemperature87
L_DalyBms_getCellTemperature88:
;BMS.c,356 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numOfTempSensors / 7.0); k++)
	MOV	[W14+2], W1
	ADD	W14, #2, W0
	ADD	W1, #1, [W0]
;BMS.c,367 :: 		}
	GOTO	L_DalyBms_getCellTemperature84
L_DalyBms_getCellTemperature85:
;BMS.c,368 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_DalyBms_getCellTemperature
;BMS.c,369 :: 		}
L_DalyBms_getCellTemperature83:
;BMS.c,372 :: 		return false;
	CLR	W0
;BMS.c,374 :: 		}
;BMS.c,372 :: 		return false;
;BMS.c,374 :: 		}
L_end_DalyBms_getCellTemperature:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getCellTemperature

_DalyBms_getCellBalanceState:
	LNK	#4

;BMS.c,376 :: 		bool DalyBms_getCellBalanceState(DalyBms* bms) // 0x97
;BMS.c,383 :: 		cellBalance = 0;
	PUSH	W11
	PUSH	W12
	CLR	W0
	MOV	W0, [W14+0]
;BMS.c,384 :: 		cellBit = 0;
	CLR	W0
	MOV	W0, [W14+2]
;BMS.c,387 :: 		if (bms->get.numberOfCells < MIN_NUMBER_CELLS || bms->get.numberOfCells > MAX_NUMBER_CELLS)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA GEU	L__DalyBms_getCellBalanceState318
	GOTO	L__DalyBms_getCellBalanceState238
L__DalyBms_getCellBalanceState318:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W1
	MOV	#48, W0
	CP	W1, W0
	BRA LEU	L__DalyBms_getCellBalanceState319
	GOTO	L__DalyBms_getCellBalanceState237
L__DalyBms_getCellBalanceState319:
	GOTO	L_DalyBms_getCellBalanceState95
L__DalyBms_getCellBalanceState238:
L__DalyBms_getCellBalanceState237:
;BMS.c,389 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellBalanceState
;BMS.c,390 :: 		}
L_DalyBms_getCellBalanceState95:
;BMS.c,392 :: 		if (!DalyBms_requestData(bms, CELL_BALANCE_STATE, 1))
	PUSH	W10
	MOV	#1, W12
	MOV.B	#151, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getCellBalanceState320
	GOTO	L_DalyBms_getCellBalanceState96
L__DalyBms_getCellBalanceState320:
;BMS.c,394 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellBalanceState
;BMS.c,395 :: 		}
L_DalyBms_getCellBalanceState96:
;BMS.c,398 :: 		for (i = 0; i < 6; i++)
; i start address is: 0 (W0)
	CLR	W0
; i end address is: 0 (W0)
L_DalyBms_getCellBalanceState97:
; i start address is: 0 (W0)
	CP	W0, #6
	BRA LTU	L__DalyBms_getCellBalanceState321
	GOTO	L_DalyBms_getCellBalanceState98
L__DalyBms_getCellBalanceState321:
;BMS.c,401 :: 		for (j = 0; j < 8; j++)
; j start address is: 8 (W4)
	CLR	W4
; i end address is: 0 (W0)
; j end address is: 8 (W4)
	MOV	W4, W3
	MOV	W0, W4
L_DalyBms_getCellBalanceState100:
; j start address is: 6 (W3)
; i start address is: 8 (W4)
	CP	W3, #8
	BRA LTU	L__DalyBms_getCellBalanceState322
	GOTO	L_DalyBms_getCellBalanceState101
L__DalyBms_getCellBalanceState322:
;BMS.c,403 :: 		if (cellBit < MAX_NUMBER_CELLS) { // Ensure no out-of-bounds access
	MOV	#48, W1
	ADD	W14, #2, W0
	CP	W1, [W0]
	BRA GT	L__DalyBms_getCellBalanceState323
	GOTO	L_DalyBms_getCellBalanceState103
L__DalyBms_getCellBalanceState323:
;BMS.c,404 :: 		bms->get.cellBalanceState[cellBit] = BIT_READ(bms->frameBuff[0][i + 4], j);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#310, W0
	ADD	W1, W0, W1
	ADD	W14, #2, W0
	ADD	W1, [W0], W2
	MOV	#602, W0
	ADD	W10, W0, W1
	ADD	W4, #4, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, W3, W0
	ZE	W0, W0
	AND	W0, #1, W0
	MOV.B	W0, [W2]
;BMS.c,405 :: 		}
L_DalyBms_getCellBalanceState103:
;BMS.c,406 :: 		if (BIT_READ(bms->frameBuff[0][i + 4], j))
	MOV	#602, W0
	ADD	W10, W0, W1
	ADD	W4, #4, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, W3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getCellBalanceState104
;BMS.c,408 :: 		cellBalance++;
	MOV	[W14+0], W1
	ADD	W14, #0, W0
	ADD	W1, #1, [W0]
;BMS.c,409 :: 		}
L_DalyBms_getCellBalanceState104:
;BMS.c,410 :: 		cellBit++;
	MOV	[W14+2], W0
	ADD	W0, #1, W1
	MOV	W1, [W14+2]
;BMS.c,411 :: 		if (cellBit >= MAX_NUMBER_CELLS) // Changed 47 to MAX_NUMBER_CELLS for robustness
	MOV	#48, W0
	CP	W1, W0
	BRA GE	L__DalyBms_getCellBalanceState324
	GOTO	L_DalyBms_getCellBalanceState105
L__DalyBms_getCellBalanceState324:
; j end address is: 6 (W3)
;BMS.c,413 :: 		break;
	GOTO	L_DalyBms_getCellBalanceState101
;BMS.c,414 :: 		}
L_DalyBms_getCellBalanceState105:
;BMS.c,401 :: 		for (j = 0; j < 8; j++)
; j start address is: 2 (W1)
; j start address is: 6 (W3)
	ADD	W3, #1, W1
; j end address is: 6 (W3)
;BMS.c,415 :: 		}
; j end address is: 2 (W1)
	MOV	W1, W3
	GOTO	L_DalyBms_getCellBalanceState100
L_DalyBms_getCellBalanceState101:
;BMS.c,416 :: 		if (cellBit >= MAX_NUMBER_CELLS) {
	MOV	#48, W1
	ADD	W14, #2, W0
	CP	W1, [W0]
	BRA LE	L__DalyBms_getCellBalanceState325
	GOTO	L_DalyBms_getCellBalanceState106
L__DalyBms_getCellBalanceState325:
; i end address is: 8 (W4)
;BMS.c,417 :: 		break;
	GOTO	L_DalyBms_getCellBalanceState98
;BMS.c,418 :: 		}
L_DalyBms_getCellBalanceState106:
;BMS.c,398 :: 		for (i = 0; i < 6; i++)
; i start address is: 6 (W3)
; i start address is: 8 (W4)
	ADD	W4, #1, W3
; i end address is: 8 (W4)
;BMS.c,419 :: 		}
	MOV	W3, W0
; i end address is: 6 (W3)
	GOTO	L_DalyBms_getCellBalanceState97
L_DalyBms_getCellBalanceState98:
;BMS.c,421 :: 		if (cellBalance > 0)
	MOV	[W14+0], W0
	CP	W0, #0
	BRA GT	L__DalyBms_getCellBalanceState326
	GOTO	L_DalyBms_getCellBalanceState107
L__DalyBms_getCellBalanceState326:
;BMS.c,423 :: 		bms->get.cellBalanceActive = true;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#358, W0
	ADD	W1, W0, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,424 :: 		}
	GOTO	L_DalyBms_getCellBalanceState108
L_DalyBms_getCellBalanceState107:
;BMS.c,427 :: 		bms->get.cellBalanceActive = false;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#358, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,428 :: 		}
L_DalyBms_getCellBalanceState108:
;BMS.c,430 :: 		return true;
	MOV.B	#1, W0
;BMS.c,431 :: 		}
;BMS.c,430 :: 		return true;
;BMS.c,431 :: 		}
L_end_DalyBms_getCellBalanceState:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getCellBalanceState

_DalyBms_getFailureCodes:

;BMS.c,433 :: 		bool DalyBms_getFailureCodes(DalyBms* bms) // 0x98
;BMS.c,437 :: 		if (!DalyBms_requestData(bms, FAILURE_CODES, 1))
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#1, W12
	MOV.B	#152, W11
	CALL	BMS_DalyBms_requestData
	POP	W10
	CP0.B	W0
	BRA Z	L__DalyBms_getFailureCodes328
	GOTO	L_DalyBms_getFailureCodes109
L__DalyBms_getFailureCodes328:
;BMS.c,439 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getFailureCodes
;BMS.c,440 :: 		}
L_DalyBms_getFailureCodes109:
;BMS.c,442 :: 		bms->failCodeArr[0] = '\0'; // Clear the string
	ADD	W10, #10, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,445 :: 		if (BIT_READ(bms->frameBuff[0][4], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes110
;BMS.c,446 :: 		strcat(bms->failCodeArr, "Cell volt high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr6_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes111
L_DalyBms_getFailureCodes110:
;BMS.c,447 :: 		else if (BIT_READ(bms->frameBuff[0][4], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes112
;BMS.c,448 :: 		strcat(bms->failCodeArr, "Cell volt high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr7_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes112:
L_DalyBms_getFailureCodes111:
;BMS.c,449 :: 		if (BIT_READ(bms->frameBuff[0][4], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes113
;BMS.c,450 :: 		strcat(bms->failCodeArr, "Cell volt low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr8_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes114
L_DalyBms_getFailureCodes113:
;BMS.c,451 :: 		else if (BIT_READ(bms->frameBuff[0][4], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes115
;BMS.c,452 :: 		strcat(bms->failCodeArr, "Cell volt low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr9_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes115:
L_DalyBms_getFailureCodes114:
;BMS.c,453 :: 		if (BIT_READ(bms->frameBuff[0][4], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes116
;BMS.c,454 :: 		strcat(bms->failCodeArr, "Sum volt high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr10_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes117
L_DalyBms_getFailureCodes116:
;BMS.c,455 :: 		else if (BIT_READ(bms->frameBuff[0][4], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes118
;BMS.c,456 :: 		strcat(bms->failCodeArr, "Sum volt high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr11_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes118:
L_DalyBms_getFailureCodes117:
;BMS.c,457 :: 		if (BIT_READ(bms->frameBuff[0][4], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes119
;BMS.c,458 :: 		strcat(bms->failCodeArr, "Sum volt low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr12_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes120
L_DalyBms_getFailureCodes119:
;BMS.c,459 :: 		else if (BIT_READ(bms->frameBuff[0][4], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes121
;BMS.c,460 :: 		strcat(bms->failCodeArr, "Sum volt low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr13_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes121:
L_DalyBms_getFailureCodes120:
;BMS.c,462 :: 		if (BIT_READ(bms->frameBuff[0][5], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes122
;BMS.c,463 :: 		strcat(bms->failCodeArr, "Chg temp high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr14_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes123
L_DalyBms_getFailureCodes122:
;BMS.c,464 :: 		else if (BIT_READ(bms->frameBuff[0][5], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes124
;BMS.c,465 :: 		strcat(bms->failCodeArr, "Chg temp high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr15_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes124:
L_DalyBms_getFailureCodes123:
;BMS.c,466 :: 		if (BIT_READ(bms->frameBuff[0][5], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes125
;BMS.c,467 :: 		strcat(bms->failCodeArr, "Chg temp low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr16_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes126
L_DalyBms_getFailureCodes125:
;BMS.c,468 :: 		else if (BIT_READ(bms->frameBuff[0][5], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes127
;BMS.c,469 :: 		strcat(bms->failCodeArr, "Chg temp low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr17_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes127:
L_DalyBms_getFailureCodes126:
;BMS.c,470 :: 		if (BIT_READ(bms->frameBuff[0][5], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes128
;BMS.c,471 :: 		strcat(bms->failCodeArr, "Dischg temp high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr18_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes129
L_DalyBms_getFailureCodes128:
;BMS.c,472 :: 		else if (BIT_READ(bms->frameBuff[0][5], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes130
;BMS.c,473 :: 		strcat(bms->failCodeArr, "Dischg temp high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr19_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes130:
L_DalyBms_getFailureCodes129:
;BMS.c,474 :: 		if (BIT_READ(bms->frameBuff[0][5], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes131
;BMS.c,475 :: 		strcat(bms->failCodeArr, "Dischg temp low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr20_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes132
L_DalyBms_getFailureCodes131:
;BMS.c,476 :: 		else if (BIT_READ(bms->frameBuff[0][5], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes133
;BMS.c,477 :: 		strcat(bms->failCodeArr, "Dischg temp low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr21_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes133:
L_DalyBms_getFailureCodes132:
;BMS.c,479 :: 		if (BIT_READ(bms->frameBuff[0][6], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes134
;BMS.c,480 :: 		strcat(bms->failCodeArr, "Chg overcurrent level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr22_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes135
L_DalyBms_getFailureCodes134:
;BMS.c,481 :: 		else if (BIT_READ(bms->frameBuff[0][6], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes136
;BMS.c,482 :: 		strcat(bms->failCodeArr, "Chg overcurrent level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr23_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes136:
L_DalyBms_getFailureCodes135:
;BMS.c,483 :: 		if (BIT_READ(bms->frameBuff[0][6], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes137
;BMS.c,484 :: 		strcat(bms->failCodeArr, "Dischg overcurrent level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr24_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes138
L_DalyBms_getFailureCodes137:
;BMS.c,485 :: 		else if (BIT_READ(bms->frameBuff[0][6], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes139
;BMS.c,486 :: 		strcat(bms->failCodeArr, "Dischg overcurrent level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr25_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes139:
L_DalyBms_getFailureCodes138:
;BMS.c,487 :: 		if (BIT_READ(bms->frameBuff[0][6], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes140
;BMS.c,488 :: 		strcat(bms->failCodeArr, "SOC high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr26_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes141
L_DalyBms_getFailureCodes140:
;BMS.c,489 :: 		else if (BIT_READ(bms->frameBuff[0][6], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes142
;BMS.c,490 :: 		strcat(bms->failCodeArr, "SOC high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr27_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes142:
L_DalyBms_getFailureCodes141:
;BMS.c,491 :: 		if (BIT_READ(bms->frameBuff[0][6], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes143
;BMS.c,492 :: 		strcat(bms->failCodeArr, "SOC Low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr28_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes144
L_DalyBms_getFailureCodes143:
;BMS.c,493 :: 		else if (BIT_READ(bms->frameBuff[0][6], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes145
;BMS.c,494 :: 		strcat(bms->failCodeArr, "SOC Low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr29_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes145:
L_DalyBms_getFailureCodes144:
;BMS.c,496 :: 		if (BIT_READ(bms->frameBuff[0][7], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes146
;BMS.c,497 :: 		strcat(bms->failCodeArr, "Diff volt level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr30_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes147
L_DalyBms_getFailureCodes146:
;BMS.c,498 :: 		else if (BIT_READ(bms->frameBuff[0][7], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes148
;BMS.c,499 :: 		strcat(bms->failCodeArr, "Diff volt level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr31_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes148:
L_DalyBms_getFailureCodes147:
;BMS.c,500 :: 		if (BIT_READ(bms->frameBuff[0][7], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes149
;BMS.c,501 :: 		strcat(bms->failCodeArr, "Diff temp level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr32_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes150
L_DalyBms_getFailureCodes149:
;BMS.c,502 :: 		else if (BIT_READ(bms->frameBuff[0][7], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes151
;BMS.c,503 :: 		strcat(bms->failCodeArr, "Diff temp level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr33_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes151:
L_DalyBms_getFailureCodes150:
;BMS.c,505 :: 		if (BIT_READ(bms->frameBuff[0][8], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes152
;BMS.c,506 :: 		strcat(bms->failCodeArr, "Chg MOS temp high alarm,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr34_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes152:
;BMS.c,507 :: 		if (BIT_READ(bms->frameBuff[0][8], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes153
;BMS.c,508 :: 		strcat(bms->failCodeArr, "Dischg MOS temp high alarm,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr35_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes153:
;BMS.c,509 :: 		if (BIT_READ(bms->frameBuff[0][8], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes154
;BMS.c,510 :: 		strcat(bms->failCodeArr, "Chg MOS temp sensor err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr36_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes154:
;BMS.c,511 :: 		if (BIT_READ(bms->frameBuff[0][8], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes155
;BMS.c,512 :: 		strcat(bms->failCodeArr, "Dischg MOS temp sensor err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr37_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes155:
;BMS.c,513 :: 		if (BIT_READ(bms->frameBuff[0][8], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes156
;BMS.c,514 :: 		strcat(bms->failCodeArr, "Chg MOS adhesion err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr38_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes156:
;BMS.c,515 :: 		if (BIT_READ(bms->frameBuff[0][8], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes157
;BMS.c,516 :: 		strcat(bms->failCodeArr, "Dischg MOS adhesion err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr39_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes157:
;BMS.c,517 :: 		if (BIT_READ(bms->frameBuff[0][8], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes158
;BMS.c,518 :: 		strcat(bms->failCodeArr, "Chg MOS open circuit err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr40_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes158:
;BMS.c,519 :: 		if (BIT_READ(bms->frameBuff[0][8], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes159
;BMS.c,520 :: 		strcat(bms->failCodeArr, " Discrg MOS open circuit err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr41_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes159:
;BMS.c,522 :: 		if (BIT_READ(bms->frameBuff[0][9], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes160
;BMS.c,523 :: 		strcat(bms->failCodeArr, "AFE collect chip err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr42_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes160:
;BMS.c,524 :: 		if (BIT_READ(bms->frameBuff[0][9], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes161
;BMS.c,525 :: 		strcat(bms->failCodeArr, "Voltage collect dropped,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr43_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes161:
;BMS.c,526 :: 		if (BIT_READ(bms->frameBuff[0][9], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes162
;BMS.c,527 :: 		strcat(bms->failCodeArr, "Cell temp sensor err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr44_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes162:
;BMS.c,528 :: 		if (BIT_READ(bms->frameBuff[0][9], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes163
;BMS.c,529 :: 		strcat(bms->failCodeArr, "EEPROM err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr45_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes163:
;BMS.c,530 :: 		if (BIT_READ(bms->frameBuff[0][9], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes164
;BMS.c,531 :: 		strcat(bms->failCodeArr, "RTC err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr46_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes164:
;BMS.c,532 :: 		if (BIT_READ(bms->frameBuff[0][9], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes165
;BMS.c,533 :: 		strcat(bms->failCodeArr, "Precharge failure,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr47_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes165:
;BMS.c,534 :: 		if (BIT_READ(bms->frameBuff[0][9], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes166
;BMS.c,535 :: 		strcat(bms->failCodeArr, "Communication failure,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr48_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes166:
;BMS.c,536 :: 		if (BIT_READ(bms->frameBuff[0][9], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes167
;BMS.c,537 :: 		strcat(bms->failCodeArr, "Internal communication failure,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr49_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes167:
;BMS.c,539 :: 		if (BIT_READ(bms->frameBuff[0][10], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes168
;BMS.c,540 :: 		strcat(bms->failCodeArr, "Current module fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr50_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes168:
;BMS.c,541 :: 		if (BIT_READ(bms->frameBuff[0][10], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes169
;BMS.c,542 :: 		strcat(bms->failCodeArr, "Sum voltage detect fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr51_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes169:
;BMS.c,543 :: 		if (BIT_READ(bms->frameBuff[0][10], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes170
;BMS.c,544 :: 		strcat(bms->failCodeArr, "Short circuit protect fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr52_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes170:
;BMS.c,545 :: 		if (BIT_READ(bms->frameBuff[0][10], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes171
;BMS.c,546 :: 		strcat(bms->failCodeArr, "Low volt forbidden chg fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr53_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes171:
;BMS.c,548 :: 		len = strlen(bms->failCodeArr);
	ADD	W10, #10, W0
	PUSH	W10
	MOV	W0, W10
	CALL	_strlen
	POP	W10
; len start address is: 4 (W2)
	MOV	W0, W2
;BMS.c,549 :: 		if (len > 0 && bms->failCodeArr[len - 1] == ',')
	CP	W0, #0
	BRA GTU	L__DalyBms_getFailureCodes329
	GOTO	L__DalyBms_getFailureCodes241
L__DalyBms_getFailureCodes329:
	ADD	W10, #10, W1
	SUB	W2, #1, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA Z	L__DalyBms_getFailureCodes330
	GOTO	L__DalyBms_getFailureCodes240
L__DalyBms_getFailureCodes330:
L__DalyBms_getFailureCodes239:
;BMS.c,551 :: 		bms->failCodeArr[len - 1] = '\0';
	ADD	W10, #10, W1
	SUB	W2, #1, W0
; len end address is: 4 (W2)
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,549 :: 		if (len > 0 && bms->failCodeArr[len - 1] == ',')
L__DalyBms_getFailureCodes241:
L__DalyBms_getFailureCodes240:
;BMS.c,553 :: 		return true;
	MOV.B	#1, W0
;BMS.c,554 :: 		}
;BMS.c,553 :: 		return true;
;BMS.c,554 :: 		}
L_end_DalyBms_getFailureCodes:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_getFailureCodes

_DalyBms_setDischargeMOS:

;BMS.c,556 :: 		bool DalyBms_setDischargeMOS(DalyBms* bms, bool sw) // 0xD9 0x80 First Byte 0x01=ON 0x00=OFF
;BMS.c,558 :: 		bms->requestCounter = 0;
	PUSH	W11
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,559 :: 		if (sw)
	CP0.B	W11
	BRA NZ	L__DalyBms_setDischargeMOS332
	GOTO	L_DalyBms_setDischargeMOS175
L__DalyBms_setDischargeMOS332:
;BMS.c,562 :: 		bms->my_txBuffer[4] = 0x01;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,563 :: 		}
	GOTO	L_DalyBms_setDischargeMOS176
L_DalyBms_setDischargeMOS175:
;BMS.c,566 :: 		bms->my_txBuffer[4] = 0x00; // Explicitly set to 0 for OFF
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,567 :: 		}
L_DalyBms_setDischargeMOS176:
;BMS.c,569 :: 		DalyBms_sendCommand(bms, DISCHRG_FET);
	PUSH	W10
	MOV.B	#217, W11
	CALL	BMS_DalyBms_sendCommand
	POP	W10
;BMS.c,571 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setDischargeMOS333
	GOTO	L_DalyBms_setDischargeMOS177
L__DalyBms_setDischargeMOS333:
;BMS.c,573 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setDischargeMOS
;BMS.c,574 :: 		}
L_DalyBms_setDischargeMOS177:
;BMS.c,576 :: 		return true;
	MOV.B	#1, W0
;BMS.c,577 :: 		}
;BMS.c,576 :: 		return true;
;BMS.c,577 :: 		}
L_end_DalyBms_setDischargeMOS:
	POP	W11
	RETURN
; end of _DalyBms_setDischargeMOS

_DalyBms_setChargeMOS:

;BMS.c,579 :: 		bool DalyBms_setChargeMOS(DalyBms* bms, bool sw) // 0xDA 0x80 First Byte 0x01=ON 0x00=OFF
;BMS.c,581 :: 		bms->requestCounter = 0;
	PUSH	W11
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,582 :: 		if (sw)
	CP0.B	W11
	BRA NZ	L__DalyBms_setChargeMOS335
	GOTO	L_DalyBms_setChargeMOS178
L__DalyBms_setChargeMOS335:
;BMS.c,585 :: 		bms->my_txBuffer[4] = 0x01;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,586 :: 		}
	GOTO	L_DalyBms_setChargeMOS179
L_DalyBms_setChargeMOS178:
;BMS.c,589 :: 		bms->my_txBuffer[4] = 0x00; // Explicitly set to 0 for OFF
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,590 :: 		}
L_DalyBms_setChargeMOS179:
;BMS.c,591 :: 		DalyBms_sendCommand(bms, CHRG_FET);
	PUSH	W10
	MOV.B	#218, W11
	CALL	BMS_DalyBms_sendCommand
	POP	W10
;BMS.c,593 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setChargeMOS336
	GOTO	L_DalyBms_setChargeMOS180
L__DalyBms_setChargeMOS336:
;BMS.c,595 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setChargeMOS
;BMS.c,596 :: 		}
L_DalyBms_setChargeMOS180:
;BMS.c,598 :: 		return true;
	MOV.B	#1, W0
;BMS.c,599 :: 		}
;BMS.c,598 :: 		return true;
;BMS.c,599 :: 		}
L_end_DalyBms_setChargeMOS:
	POP	W11
	RETURN
; end of _DalyBms_setChargeMOS

_DalyBms_setBmsReset:

;BMS.c,601 :: 		bool DalyBms_setBmsReset(DalyBms* bms) // 0x00 Reset the BMS
;BMS.c,603 :: 		bms->requestCounter = 0;
	PUSH	W11
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,604 :: 		DalyBms_sendCommand(bms, BMS_RESET);
	PUSH	W10
	CLR	W11
	CALL	BMS_DalyBms_sendCommand
	POP	W10
;BMS.c,605 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setBmsReset338
	GOTO	L_DalyBms_setBmsReset181
L__DalyBms_setBmsReset338:
;BMS.c,607 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setBmsReset
;BMS.c,608 :: 		}
L_DalyBms_setBmsReset181:
;BMS.c,609 :: 		return true;
	MOV.B	#1, W0
;BMS.c,610 :: 		}
;BMS.c,609 :: 		return true;
;BMS.c,610 :: 		}
L_end_DalyBms_setBmsReset:
	POP	W11
	RETURN
; end of _DalyBms_setBmsReset

_DalyBms_setSOC:

;BMS.c,612 :: 		bool DalyBms_setSOC(DalyBms* bms, float val) // 0x21 last two byte is SOC
;BMS.c,617 :: 		if (val >= 0.0f && val <= 100.0f)
	PUSH	W11
	PUSH	W12
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CLR	W2
	CLR	W3
	MOV	W11, W0
	MOV	W12, W1
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LT	L__DalyBms_setSOC340
	INC.B	W0
L__DalyBms_setSOC340:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L__DalyBms_setSOC341
	GOTO	L__DalyBms_setSOC244
L__DalyBms_setSOC341:
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	#0, W2
	MOV	#17096, W3
	MOV	W11, W0
	MOV	W12, W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GT	L__DalyBms_setSOC342
	INC.B	W0
L__DalyBms_setSOC342:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L__DalyBms_setSOC343
	GOTO	L__DalyBms_setSOC243
L__DalyBms_setSOC343:
L__DalyBms_setSOC242:
;BMS.c,619 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,622 :: 		DalyBms_sendCommand(bms, READ_SOC);
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV.B	#97, W11
	CALL	BMS_DalyBms_sendCommand
	POP	W10
;BMS.c,623 :: 		if (!DalyBms_receiveBytes(bms))
	PUSH	W10
	CALL	BMS_DalyBms_receiveBytes
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA Z	L__DalyBms_setSOC344
	GOTO	L_DalyBms_setSOC185
L__DalyBms_setSOC344:
;BMS.c,625 :: 		bms->my_txBuffer[5] = 0x17; // year (current year - 2000)
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W1
	MOV.B	#23, W0
	MOV.B	W0, [W1]
;BMS.c,626 :: 		bms->my_txBuffer[6] = 0x01; // month
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,627 :: 		bms->my_txBuffer[7] = 0x01; // day
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,628 :: 		bms->my_txBuffer[8] = 0x01; // hour
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,629 :: 		bms->my_txBuffer[9] = 0x01; // minute
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,630 :: 		}
	GOTO	L_DalyBms_setSOC186
L_DalyBms_setSOC185:
;BMS.c,633 :: 		for (i = 5; i <= 9; i++)
; i start address is: 4 (W2)
	MOV	#5, W2
; i end address is: 4 (W2)
L_DalyBms_setSOC187:
; i start address is: 4 (W2)
	CP	W2, #9
	BRA LEU	L__DalyBms_setSOC345
	GOTO	L_DalyBms_setSOC188
L__DalyBms_setSOC345:
;BMS.c,635 :: 		bms->my_txBuffer[i] = bms->my_rxBuffer[i];
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, W2, W1
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, W2, W0
	MOV.B	[W0], [W1]
;BMS.c,633 :: 		for (i = 5; i <= 9; i++)
	INC	W2
;BMS.c,636 :: 		}
; i end address is: 4 (W2)
	GOTO	L_DalyBms_setSOC187
L_DalyBms_setSOC188:
;BMS.c,637 :: 		}
L_DalyBms_setSOC186:
;BMS.c,638 :: 		value = (uint16_t)(val * 10.0f);
	PUSH	W10
	MOV	W11, W0
	MOV	W12, W1
	MOV	#0, W2
	MOV	#16672, W3
	CALL	__Mul_FP
	CALL	__Float2Longint
	POP	W10
; value start address is: 6 (W3)
	MOV	W0, W3
;BMS.c,639 :: 		bms->my_txBuffer[10] = (value >> 8) & 0xFF;
	MOV	#420, W1
	ADD	W10, W1, W1
	ADD	W1, #10, W2
	LSR	W0, #8, W1
	MOV	#255, W0
	AND	W1, W0, W0
	MOV.B	W0, [W2]
;BMS.c,640 :: 		bms->my_txBuffer[11] = value & 0xFF;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #11, W1
	MOV	#255, W0
	AND	W3, W0, W0
; value end address is: 6 (W3)
	MOV.B	W0, [W1]
;BMS.c,641 :: 		DalyBms_sendCommand(bms, SET_SOC);
	PUSH	W10
	MOV.B	#33, W11
	CALL	BMS_DalyBms_sendCommand
	POP	W10
;BMS.c,643 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setSOC346
	GOTO	L_DalyBms_setSOC190
L__DalyBms_setSOC346:
;BMS.c,645 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setSOC
;BMS.c,646 :: 		}
L_DalyBms_setSOC190:
;BMS.c,649 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_DalyBms_setSOC
;BMS.c,617 :: 		if (val >= 0.0f && val <= 100.0f)
L__DalyBms_setSOC244:
L__DalyBms_setSOC243:
;BMS.c,652 :: 		return false;
	CLR	W0
;BMS.c,653 :: 		}
;BMS.c,652 :: 		return false;
;BMS.c,653 :: 		}
L_end_DalyBms_setSOC:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_setSOC

_DalyBms_getState:

;BMS.c,655 :: 		bool DalyBms_getState(DalyBms* bms) // Function to return the state of connection
;BMS.c,657 :: 		return bms->get.connectionState;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#359, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
;BMS.c,658 :: 		}
L_end_DalyBms_getState:
	RETURN
; end of _DalyBms_getState

_DalyBms_set_callback:

;BMS.c,660 :: 		void DalyBms_set_callback(DalyBms* bms, void (*func)(void)) // callback function when finish request
;BMS.c,662 :: 		bms->requestCallback = func;
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	W11, [W0]
;BMS.c,663 :: 		}
L_end_DalyBms_set_callback:
	RETURN
; end of _DalyBms_set_callback

BMS_DalyBms_requestData:

;BMS.c,670 :: 		static bool DalyBms_requestData(DalyBms* bms, DALY_BMS_COMMAND cmdID, unsigned int frameAmount)
;BMS.c,682 :: 		memset(bms->my_rxFrameBuffer, 0x00, sizeof(bms->my_rxFrameBuffer));
	MOV	#446, W0
	ADD	W10, W0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
;BMS.c,683 :: 		memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff));
	MOV	#602, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
;BMS.c,684 :: 		memset(bms->my_txBuffer, 0x00, XFER_BUFFER_LENGTH);
	MOV	#420, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
	POP	W12
;BMS.c,687 :: 		txChecksum = 0x00;    // transmit checksum buffer
; txChecksum start address is: 4 (W2)
	CLR	W2
;BMS.c,691 :: 		bms->my_txBuffer[0] = START_BYTE;
	MOV	#420, W0
	ADD	W10, W0, W1
	MOV.B	#165, W0
	MOV.B	W0, [W1]
;BMS.c,692 :: 		bms->my_txBuffer[1] = HOST_ADRESS;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,693 :: 		bms->my_txBuffer[2] = cmdID;
	MOV	#420, W0
	ADD	W10, W0, W0
	INC2	W0
	MOV.B	W11, [W0]
;BMS.c,694 :: 		bms->my_txBuffer[3] = FRAME_LENGTH;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,697 :: 		for (i = 0; i <= 11; i++)
; i start address is: 2 (W1)
	CLR	W1
; txChecksum end address is: 4 (W2)
; i end address is: 2 (W1)
L_BMS_DalyBms_requestData192:
; i start address is: 2 (W1)
; txChecksum start address is: 4 (W2)
	CP	W1, #11
	BRA LEU	L_BMS_DalyBms_requestData350
	GOTO	L_BMS_DalyBms_requestData193
L_BMS_DalyBms_requestData350:
;BMS.c,699 :: 		txChecksum += bms->my_txBuffer[i];
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, W1, W0
; txChecksum start address is: 0 (W0)
	ADD.B	W2, [W0], W0
; txChecksum end address is: 4 (W2)
;BMS.c,697 :: 		for (i = 0; i <= 11; i++)
	INC	W1
;BMS.c,700 :: 		}
	MOV.B	W0, W2
; txChecksum end address is: 0 (W0)
; i end address is: 2 (W1)
	GOTO	L_BMS_DalyBms_requestData192
L_BMS_DalyBms_requestData193:
;BMS.c,702 :: 		bms->my_txBuffer[12] = txChecksum;
; txChecksum start address is: 4 (W2)
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #12, W0
	MOV.B	W2, [W0]
; txChecksum end address is: 4 (W2)
;BMS.c,705 :: 		_UART1_SendPush(bms->my_txBuffer);
	MOV	#420, W0
	ADD	W10, W0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W10
	CALL	__UART1_SendPush
;BMS.c,707 :: 		_UART1_SendProcess();
	CALL	__UART1_SendProcess
	POP.D	W10
	POP	W12
;BMS.c,714 :: 		frame_count = 0;
; frame_count start address is: 8 (W4)
	CLR	W4
;BMS.c,715 :: 		received_frames = 0;
; received_frames start address is: 6 (W3)
	CLR	W3
; frame_count end address is: 8 (W4)
; received_frames end address is: 6 (W3)
;BMS.c,718 :: 		while (frame_count < frameAmount && received_frames < 10) { // Max 10 attempts
L_BMS_DalyBms_requestData195:
; received_frames start address is: 6 (W3)
; frame_count start address is: 8 (W4)
	ZE	W4, W0
	CP	W0, W12
	BRA LTU	L_BMS_DalyBms_requestData351
	GOTO	L_BMS_DalyBms_requestData228
L_BMS_DalyBms_requestData351:
	CP.B	W3, #10
	BRA LTU	L_BMS_DalyBms_requestData352
	GOTO	L_BMS_DalyBms_requestData227
L_BMS_DalyBms_requestData352:
L_BMS_DalyBms_requestData226:
;BMS.c,719 :: 		if (_UART1_Rx_GetFrame(bms->frameBuff[frame_count])) {
	MOV	#602, W0
	ADD	W10, W0, W2
	ZE	W4, W1
	MOV	#13, W0
	MUL.UU	W0, W1, W0
	ADD	W2, W0, W0
	PUSH	W4
	PUSH	W3
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W10
	CALL	__UART1_Rx_GetFrame
	POP.D	W10
	POP	W12
	POP	W3
	POP	W4
	CP0.B	W0
	BRA NZ	L_BMS_DalyBms_requestData353
	GOTO	L_BMS_DalyBms_requestData229
L_BMS_DalyBms_requestData353:
;BMS.c,720 :: 		frame_count++;
; frame_count start address is: 8 (W4)
	INC.B	W4
; frame_count end address is: 8 (W4)
; frame_count end address is: 8 (W4)
;BMS.c,721 :: 		}
	GOTO	L_BMS_DalyBms_requestData199
L_BMS_DalyBms_requestData229:
;BMS.c,719 :: 		if (_UART1_Rx_GetFrame(bms->frameBuff[frame_count])) {
;BMS.c,721 :: 		}
L_BMS_DalyBms_requestData199:
;BMS.c,722 :: 		received_frames++;
; frame_count start address is: 8 (W4)
	INC.B	W3
;BMS.c,724 :: 		Delay_ms(1);
	MOV	#2666, W7
L_BMS_DalyBms_requestData200:
	DEC	W7
	BRA NZ	L_BMS_DalyBms_requestData200
	NOP
	NOP
;BMS.c,725 :: 		}
; received_frames end address is: 6 (W3)
	GOTO	L_BMS_DalyBms_requestData195
;BMS.c,718 :: 		while (frame_count < frameAmount && received_frames < 10) { // Max 10 attempts
L_BMS_DalyBms_requestData228:
L_BMS_DalyBms_requestData227:
;BMS.c,728 :: 		for (i = 0; i < frame_count; i++)
; i start address is: 0 (W0)
	CLR	W0
; frame_count end address is: 8 (W4)
; i end address is: 0 (W0)
	MOV.B	W4, W3
	MOV	W0, W4
L_BMS_DalyBms_requestData202:
; i start address is: 8 (W4)
; frame_count start address is: 6 (W3)
	ZE	W3, W0
	CP	W4, W0
	BRA LTU	L_BMS_DalyBms_requestData354
	GOTO	L_BMS_DalyBms_requestData203
L_BMS_DalyBms_requestData354:
;BMS.c,730 :: 		rxChecksum = 0x00;
; rxChecksum start address is: 12 (W6)
	CLR	W6
;BMS.c,731 :: 		for (k = 0; k < XFER_BUFFER_LENGTH - 1; k++)
; k start address is: 10 (W5)
	CLR	W5
; rxChecksum end address is: 12 (W6)
; frame_count end address is: 6 (W3)
; k end address is: 10 (W5)
; i end address is: 8 (W4)
L_BMS_DalyBms_requestData205:
; k start address is: 10 (W5)
; rxChecksum start address is: 12 (W6)
; frame_count start address is: 6 (W3)
; i start address is: 8 (W4)
	CP	W5, #12
	BRA LT	L_BMS_DalyBms_requestData355
	GOTO	L_BMS_DalyBms_requestData206
L_BMS_DalyBms_requestData355:
;BMS.c,733 :: 		rxChecksum += bms->frameBuff[i][k];
	MOV	#602, W0
	ADD	W10, W0, W2
	MOV	#13, W0
	MUL.UU	W0, W4, W0
	ADD	W2, W0, W0
	ADD	W0, W5, W0
; rxChecksum start address is: 0 (W0)
	ADD.B	W6, [W0], W0
; rxChecksum end address is: 12 (W6)
;BMS.c,731 :: 		for (k = 0; k < XFER_BUFFER_LENGTH - 1; k++)
	INC	W5
;BMS.c,734 :: 		}
; rxChecksum end address is: 0 (W0)
; k end address is: 10 (W5)
	MOV.B	W0, W6
	GOTO	L_BMS_DalyBms_requestData205
L_BMS_DalyBms_requestData206:
;BMS.c,738 :: 		if (rxChecksum != bms->frameBuff[i][XFER_BUFFER_LENGTH - 1])
; rxChecksum start address is: 12 (W6)
	MOV	#602, W0
	ADD	W10, W0, W2
	MOV	#13, W0
	MUL.UU	W0, W4, W0
	ADD	W2, W0, W0
	ADD	W0, #12, W0
	CP.B	W6, [W0]
	BRA NZ	L_BMS_DalyBms_requestData356
	GOTO	L_BMS_DalyBms_requestData208
L_BMS_DalyBms_requestData356:
; rxChecksum end address is: 12 (W6)
; frame_count end address is: 6 (W3)
; i end address is: 8 (W4)
;BMS.c,740 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_requestData
;BMS.c,741 :: 		}
L_BMS_DalyBms_requestData208:
;BMS.c,742 :: 		if (rxChecksum == 0) // This condition might indicate no data or all zeros, needs careful consideration for actual no-data scenario
; i start address is: 8 (W4)
; frame_count start address is: 6 (W3)
; rxChecksum start address is: 12 (W6)
	CP.B	W6, #0
	BRA Z	L_BMS_DalyBms_requestData357
	GOTO	L_BMS_DalyBms_requestData209
L_BMS_DalyBms_requestData357:
; rxChecksum end address is: 12 (W6)
; frame_count end address is: 6 (W3)
; i end address is: 8 (W4)
;BMS.c,744 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_requestData
;BMS.c,745 :: 		}
L_BMS_DalyBms_requestData209:
;BMS.c,746 :: 		if (bms->frameBuff[i][1] >= 0x20) // This check seems specific to a Daly BMS sleep state
; i start address is: 8 (W4)
; frame_count start address is: 6 (W3)
	MOV	#602, W0
	ADD	W10, W0, W2
	MOV	#13, W0
	MUL.UU	W0, W4, W0
	ADD	W2, W0, W0
	INC	W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA GEU	L_BMS_DalyBms_requestData358
	GOTO	L_BMS_DalyBms_requestData210
L_BMS_DalyBms_requestData358:
; frame_count end address is: 6 (W3)
; i end address is: 8 (W4)
;BMS.c,748 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_requestData
;BMS.c,749 :: 		}
L_BMS_DalyBms_requestData210:
;BMS.c,728 :: 		for (i = 0; i < frame_count; i++)
; i start address is: 8 (W4)
; frame_count start address is: 6 (W3)
	INC	W4
;BMS.c,750 :: 		}
; frame_count end address is: 6 (W3)
; i end address is: 8 (W4)
	GOTO	L_BMS_DalyBms_requestData202
L_BMS_DalyBms_requestData203:
;BMS.c,751 :: 		return true;
	MOV.B	#1, W0
;BMS.c,752 :: 		}
L_end_DalyBms_requestData:
	RETURN
; end of BMS_DalyBms_requestData

BMS_DalyBms_sendQueueAdd:

;BMS.c,754 :: 		static bool DalyBms_sendQueueAdd(DalyBms* bms, DALY_BMS_COMMAND cmdID)
;BMS.c,758 :: 		for (i = 0; i < sizeof(bms->commandQueue) / sizeof(bms->commandQueue[0]); i++)
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_DalyBms_sendQueueAdd211:
; i start address is: 4 (W2)
	CP	W2, #5
	BRA LTU	L_BMS_DalyBms_sendQueueAdd360
	GOTO	L_BMS_DalyBms_sendQueueAdd212
L_BMS_DalyBms_sendQueueAdd360:
;BMS.c,760 :: 		if (bms->commandQueue[i] == 0x100)
	MOV	#408, W0
	ADD	W10, W0, W1
	SL	W2, #1, W0
	ADD	W1, W0, W0
	MOV	[W0], W1
	MOV	#256, W0
	CP	W1, W0
	BRA Z	L_BMS_DalyBms_sendQueueAdd361
	GOTO	L_BMS_DalyBms_sendQueueAdd214
L_BMS_DalyBms_sendQueueAdd361:
;BMS.c,762 :: 		bms->commandQueue[i] = cmdID;
	MOV	#408, W0
	ADD	W10, W0, W1
	SL	W2, #1, W0
; i end address is: 4 (W2)
	ADD	W1, W0, W1
	ZE	W11, W0
	MOV	W0, [W1]
;BMS.c,763 :: 		break;
	GOTO	L_BMS_DalyBms_sendQueueAdd212
;BMS.c,764 :: 		}
L_BMS_DalyBms_sendQueueAdd214:
;BMS.c,758 :: 		for (i = 0; i < sizeof(bms->commandQueue) / sizeof(bms->commandQueue[0]); i++)
; i start address is: 4 (W2)
	INC	W2
;BMS.c,765 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_DalyBms_sendQueueAdd211
L_BMS_DalyBms_sendQueueAdd212:
;BMS.c,766 :: 		return true;
	MOV.B	#1, W0
;BMS.c,767 :: 		}
L_end_DalyBms_sendQueueAdd:
	RETURN
; end of BMS_DalyBms_sendQueueAdd

BMS_DalyBms_sendCommand:

;BMS.c,769 :: 		static bool DalyBms_sendCommand(DalyBms* bms, DALY_BMS_COMMAND cmdID)
;BMS.c,774 :: 		checksum = 0;
	PUSH	W12
; checksum start address is: 4 (W2)
	CLR	W2
;BMS.c,776 :: 		_UART1_ClearBuffers();
	PUSH	W2
	PUSH.D	W10
	CALL	__UART1_ClearBuffers
	POP.D	W10
	POP	W2
;BMS.c,779 :: 		bms->my_txBuffer[0] = START_BYTE;
	MOV	#420, W0
	ADD	W10, W0, W1
	MOV.B	#165, W0
	MOV.B	W0, [W1]
;BMS.c,780 :: 		bms->my_txBuffer[1] = HOST_ADRESS;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,781 :: 		bms->my_txBuffer[2] = cmdID;
	MOV	#420, W0
	ADD	W10, W0, W0
	INC2	W0
	MOV.B	W11, [W0]
;BMS.c,782 :: 		bms->my_txBuffer[3] = FRAME_LENGTH;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,785 :: 		for (i = 0; i <= 11; i++)
; i start address is: 0 (W0)
	CLR	W0
; checksum end address is: 4 (W2)
; i end address is: 0 (W0)
	MOV.B	W2, W3
	MOV.B	W0, W2
L_BMS_DalyBms_sendCommand215:
; i start address is: 4 (W2)
; checksum start address is: 6 (W3)
	CP.B	W2, #11
	BRA LEU	L_BMS_DalyBms_sendCommand363
	GOTO	L_BMS_DalyBms_sendCommand216
L_BMS_DalyBms_sendCommand363:
;BMS.c,787 :: 		checksum += bms->my_txBuffer[i];
	MOV	#420, W0
	ADD	W10, W0, W1
	ZE	W2, W0
	ADD	W1, W0, W0
; checksum start address is: 0 (W0)
	ADD.B	W3, [W0], W0
; checksum end address is: 6 (W3)
;BMS.c,785 :: 		for (i = 0; i <= 11; i++)
	INC.B	W2
;BMS.c,788 :: 		}
	MOV.B	W0, W3
; checksum end address is: 0 (W0)
; i end address is: 4 (W2)
	GOTO	L_BMS_DalyBms_sendCommand215
L_BMS_DalyBms_sendCommand216:
;BMS.c,790 :: 		bms->my_txBuffer[12] = checksum;
; checksum start address is: 6 (W3)
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #12, W0
	MOV.B	W3, [W0]
; checksum end address is: 6 (W3)
;BMS.c,792 :: 		_UART1_SendPush(bms->my_txBuffer);
	MOV	#420, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	W0, W10
	CALL	__UART1_SendPush
;BMS.c,794 :: 		_UART1_SendProcess();
	CALL	__UART1_SendProcess
	POP.D	W10
;BMS.c,797 :: 		memset(bms->my_txBuffer, 0x00, XFER_BUFFER_LENGTH);
	MOV	#420, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
;BMS.c,798 :: 		bms->requestCounter = 0; // reset the request queue that we get actual data
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,799 :: 		return true;
	MOV.B	#1, W0
;BMS.c,800 :: 		}
;BMS.c,799 :: 		return true;
;BMS.c,800 :: 		}
L_end_DalyBms_sendCommand:
	POP	W12
	RETURN
; end of BMS_DalyBms_sendCommand

BMS_DalyBms_receiveBytes:
	LNK	#14

;BMS.c,802 :: 		static bool DalyBms_receiveBytes(DalyBms* bms)
;BMS.c,807 :: 		memset(bms->my_rxBuffer, 0x00, XFER_BUFFER_LENGTH);
	PUSH	W11
	PUSH	W12
	MOV	#433, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;BMS.c,808 :: 		memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff));
	MOV	#602, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
;BMS.c,811 :: 		if (!_UART1_Rx_GetFrame(frame))
	ADD	W14, #0, W0
	MOV	W0, W10
	CALL	__UART1_Rx_GetFrame
	POP	W10
	CP0.B	W0
	BRA Z	L_BMS_DalyBms_receiveBytes365
	GOTO	L_BMS_DalyBms_receiveBytes218
L_BMS_DalyBms_receiveBytes365:
;BMS.c,813 :: 		DalyBms_barfRXBuffer(bms);
	CALL	BMS_DalyBms_barfRXBuffer
;BMS.c,814 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_receiveBytes
;BMS.c,815 :: 		}
L_BMS_DalyBms_receiveBytes218:
;BMS.c,818 :: 		memcpy(bms->my_rxBuffer, frame, XFER_BUFFER_LENGTH);
	ADD	W14, #0, W1
	MOV	#433, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#13, W12
	MOV	W1, W11
	MOV	W0, W10
	CALL	_memcpy
	POP	W10
;BMS.c,820 :: 		if (!DalyBms_validateChecksum(bms))
	CALL	BMS_DalyBms_validateChecksum
	CP0.B	W0
	BRA Z	L_BMS_DalyBms_receiveBytes366
	GOTO	L_BMS_DalyBms_receiveBytes219
L_BMS_DalyBms_receiveBytes366:
;BMS.c,822 :: 		DalyBms_barfRXBuffer(bms);
	CALL	BMS_DalyBms_barfRXBuffer
;BMS.c,823 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_receiveBytes
;BMS.c,824 :: 		}
L_BMS_DalyBms_receiveBytes219:
;BMS.c,826 :: 		return true;
	MOV.B	#1, W0
;BMS.c,827 :: 		}
;BMS.c,826 :: 		return true;
;BMS.c,827 :: 		}
L_end_DalyBms_receiveBytes:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of BMS_DalyBms_receiveBytes

BMS_DalyBms_validateChecksum:

;BMS.c,829 :: 		static bool DalyBms_validateChecksum(DalyBms* bms)
;BMS.c,834 :: 		checksum = 0x00;
; checksum start address is: 4 (W2)
	CLR	W2
;BMS.c,836 :: 		for (i = 0; i < XFER_BUFFER_LENGTH - 1; i++)
; i start address is: 2 (W1)
	CLR	W1
; checksum end address is: 4 (W2)
; i end address is: 2 (W1)
L_BMS_DalyBms_validateChecksum220:
; i start address is: 2 (W1)
; checksum start address is: 4 (W2)
	CP	W1, #12
	BRA LT	L_BMS_DalyBms_validateChecksum368
	GOTO	L_BMS_DalyBms_validateChecksum221
L_BMS_DalyBms_validateChecksum368:
;BMS.c,838 :: 		checksum += bms->my_rxBuffer[i];
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, W1, W0
; checksum start address is: 0 (W0)
	ADD.B	W2, [W0], W0
; checksum end address is: 4 (W2)
;BMS.c,836 :: 		for (i = 0; i < XFER_BUFFER_LENGTH - 1; i++)
	INC	W1
;BMS.c,839 :: 		}
	MOV.B	W0, W2
; checksum end address is: 0 (W0)
; i end address is: 2 (W1)
	GOTO	L_BMS_DalyBms_validateChecksum220
L_BMS_DalyBms_validateChecksum221:
;BMS.c,841 :: 		return (checksum == bms->my_rxBuffer[XFER_BUFFER_LENGTH - 1]);
; checksum start address is: 4 (W2)
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, #12, W0
	CP.B	W2, [W0]
	CLR.B	W0
	BRA NZ	L_BMS_DalyBms_validateChecksum369
	INC.B	W0
L_BMS_DalyBms_validateChecksum369:
; checksum end address is: 4 (W2)
;BMS.c,842 :: 		}
L_end_DalyBms_validateChecksum:
	RETURN
; end of BMS_DalyBms_validateChecksum

BMS_DalyBms_barfRXBuffer:

;BMS.c,844 :: 		static void DalyBms_barfRXBuffer(DalyBms* bms)
;BMS.c,849 :: 		for (i = 0; i < XFER_BUFFER_LENGTH; i++)
; i start address is: 2 (W1)
	CLR	W1
; i end address is: 2 (W1)
L_BMS_DalyBms_barfRXBuffer223:
; i start address is: 2 (W1)
	CP	W1, #13
	BRA LT	L_BMS_DalyBms_barfRXBuffer371
	GOTO	L_BMS_DalyBms_barfRXBuffer224
L_BMS_DalyBms_barfRXBuffer371:
;BMS.c,851 :: 		writeLog(",0x%02X", bms->my_rxBuffer[i]);
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	PUSH	W0
	MOV	#lo_addr(?lstr_54_BMS), W0
	PUSH	W0
	CALL	_writeLog
	SUB	#4, W15
;BMS.c,849 :: 		for (i = 0; i < XFER_BUFFER_LENGTH; i++)
	INC	W1
;BMS.c,852 :: 		}
; i end address is: 2 (W1)
	GOTO	L_BMS_DalyBms_barfRXBuffer223
L_BMS_DalyBms_barfRXBuffer224:
;BMS.c,853 :: 		writeLog("]\n");
	MOV	#lo_addr(?lstr_55_BMS), W0
	PUSH	W0
	CALL	_writeLog
	SUB	#2, W15
;BMS.c,854 :: 		}
L_end_DalyBms_barfRXBuffer:
	RETURN
; end of BMS_DalyBms_barfRXBuffer

BMS_DalyBms_clearGet:

;BMS.c,856 :: 		static void DalyBms_clearGet(DalyBms* bms)
;BMS.c,858 :: 		bms->get.chargeDischargeStatus = "offline"; // charge/discharge status (0 stationary ,1 charge ,2 discharge)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_56_BMS), W0
	MOV	W0, [W1]
;BMS.c,861 :: 		}
L_end_DalyBms_clearGet:
	RETURN
; end of BMS_DalyBms_clearGet

_current_millis:

;BMS.c,869 :: 		unsigned long current_millis(void) {
;BMS.c,873 :: 		return 0; // Always returns 0 for this mock. You need a real implementation.
	CLR	W0
	CLR	W1
;BMS.c,874 :: 		}
L_end_current_millis:
	RETURN
; end of _current_millis

_writeLog:
	LNK	#0

;BMS.c,877 :: 		void writeLog(const char* format, ...) {
;BMS.c,882 :: 		}
L_end_writeLog:
	ULNK
	RETURN
; end of _writeLog
