
_DalyBms_update:
	LNK	#4

;BMS.c,38 :: 		bool DalyBms_update(DalyBms* bms)
;BMS.c,40 :: 		if (current_millis() - bms->previousTime >= DELAYTINME)
	CALL	_current_millis
	MOV.D	[W10], W2
	SUB	W0, W2, W2
	SUBB	W1, W3, W3
	MOV	#150, W0
	MOV	#0, W1
	CP	W2, W0
	CPB	W3, W1
	BRA GEU	L__DalyBms_update243
	GOTO	L_DalyBms_update0
L__DalyBms_update243:
;BMS.c,42 :: 		switch (bms->requestCounter)
	ADD	W10, #4, W0
	MOV	W0, [W14+2]
	GOTO	L_DalyBms_update1
;BMS.c,44 :: 		case 0:
L_DalyBms_update3:
;BMS.c,45 :: 		bms->requestCounter++;
	ADD	W10, #4, W1
	MOV.B	[W1], W0
	ADD.B	W0, #1, [W1]
;BMS.c,46 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,47 :: 		case 1:
L_DalyBms_update4:
;BMS.c,48 :: 		if (DalyBms_getPackMeasurements(bms))
	PUSH	W10
	CALL	_DalyBms_getPackMeasurements
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update244
	GOTO	L_DalyBms_update5
L__DalyBms_update244:
;BMS.c,50 :: 		bms->get.connectionState = true;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#359, W0
	ADD	W1, W0, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,51 :: 		bms->errorCounter = 0;
	MOV	#404, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,52 :: 		bms->requestCounter++;
	ADD	W10, #4, W1
	MOV.B	[W1], W0
	ADD.B	W0, #1, [W1]
;BMS.c,53 :: 		}
	GOTO	L_DalyBms_update6
L_DalyBms_update5:
;BMS.c,56 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,57 :: 		if (bms->errorCounter < ERRORCOUNTER)
	MOV	#404, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #10
	BRA LTU	L__DalyBms_update245
	GOTO	L_DalyBms_update7
L__DalyBms_update245:
;BMS.c,59 :: 		bms->errorCounter++;
	MOV	#404, W0
	ADD	W10, W0, W1
	MOV	[W1], W0
	INC	W0
	MOV	W0, [W1]
;BMS.c,60 :: 		}
	GOTO	L_DalyBms_update8
L_DalyBms_update7:
;BMS.c,63 :: 		bms->get.connectionState = false;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#359, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,64 :: 		bms->errorCounter = 0;
	MOV	#404, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;BMS.c,65 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update246
	GOTO	L_DalyBms_update9
L__DalyBms_update246:
;BMS.c,66 :: 		bms->requestCallback(); // Call the callback function
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,67 :: 		}
L_DalyBms_update9:
;BMS.c,69 :: 		}
L_DalyBms_update8:
;BMS.c,70 :: 		}
L_DalyBms_update6:
;BMS.c,71 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,72 :: 		case 2:
L_DalyBms_update10:
;BMS.c,73 :: 		bms->requestCounter = DalyBms_getMinMaxCellVoltage(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getMinMaxCellVoltage
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update247
	GOTO	L_DalyBms_update11
L__DalyBms_update247:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T82 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T82 end address is: 2 (W1)
	GOTO	L_DalyBms_update12
L_DalyBms_update11:
; ?FLOC___DalyBms_update?T82 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T82 end address is: 2 (W1)
L_DalyBms_update12:
; ?FLOC___DalyBms_update?T82 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T82 end address is: 2 (W1)
;BMS.c,74 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,75 :: 		case 3:
L_DalyBms_update13:
;BMS.c,76 :: 		bms->requestCounter = DalyBms_getPackTemp(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	CALL	_DalyBms_getPackTemp
	CP0.B	W0
	BRA NZ	L__DalyBms_update248
	GOTO	L_DalyBms_update14
L__DalyBms_update248:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T93 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T93 end address is: 2 (W1)
	GOTO	L_DalyBms_update15
L_DalyBms_update14:
; ?FLOC___DalyBms_update?T93 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T93 end address is: 2 (W1)
L_DalyBms_update15:
; ?FLOC___DalyBms_update?T93 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T93 end address is: 2 (W1)
;BMS.c,77 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,78 :: 		case 4:
L_DalyBms_update16:
;BMS.c,79 :: 		bms->requestCounter = DalyBms_getDischargeChargeMosStatus(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getDischargeChargeMosStatus
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update249
	GOTO	L_DalyBms_update17
L__DalyBms_update249:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T104 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T104 end address is: 2 (W1)
	GOTO	L_DalyBms_update18
L_DalyBms_update17:
; ?FLOC___DalyBms_update?T104 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T104 end address is: 2 (W1)
L_DalyBms_update18:
; ?FLOC___DalyBms_update?T104 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T104 end address is: 2 (W1)
;BMS.c,80 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,81 :: 		case 5:
L_DalyBms_update19:
;BMS.c,82 :: 		bms->requestCounter = DalyBms_getStatusInfo(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	CALL	_DalyBms_getStatusInfo
	CP0.B	W0
	BRA NZ	L__DalyBms_update250
	GOTO	L_DalyBms_update20
L__DalyBms_update250:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T115 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T115 end address is: 2 (W1)
	GOTO	L_DalyBms_update21
L_DalyBms_update20:
; ?FLOC___DalyBms_update?T115 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T115 end address is: 2 (W1)
L_DalyBms_update21:
; ?FLOC___DalyBms_update?T115 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T115 end address is: 2 (W1)
;BMS.c,83 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,84 :: 		case 6:
L_DalyBms_update22:
;BMS.c,85 :: 		bms->requestCounter = DalyBms_getCellVoltages(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getCellVoltages
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update251
	GOTO	L_DalyBms_update23
L__DalyBms_update251:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T126 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T126 end address is: 2 (W1)
	GOTO	L_DalyBms_update24
L_DalyBms_update23:
; ?FLOC___DalyBms_update?T126 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T126 end address is: 2 (W1)
L_DalyBms_update24:
; ?FLOC___DalyBms_update?T126 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T126 end address is: 2 (W1)
;BMS.c,86 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,87 :: 		case 7:
L_DalyBms_update25:
;BMS.c,88 :: 		bms->requestCounter = DalyBms_getCellTemperature(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getCellTemperature
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update252
	GOTO	L_DalyBms_update26
L__DalyBms_update252:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T137 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T137 end address is: 2 (W1)
	GOTO	L_DalyBms_update27
L_DalyBms_update26:
; ?FLOC___DalyBms_update?T137 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T137 end address is: 2 (W1)
L_DalyBms_update27:
; ?FLOC___DalyBms_update?T137 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T137 end address is: 2 (W1)
;BMS.c,89 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,90 :: 		case 8:
L_DalyBms_update28:
;BMS.c,91 :: 		bms->requestCounter = DalyBms_getCellBalanceState(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	CALL	_DalyBms_getCellBalanceState
	CP0.B	W0
	BRA NZ	L__DalyBms_update253
	GOTO	L_DalyBms_update29
L__DalyBms_update253:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T148 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T148 end address is: 2 (W1)
	GOTO	L_DalyBms_update30
L_DalyBms_update29:
; ?FLOC___DalyBms_update?T148 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T148 end address is: 2 (W1)
L_DalyBms_update30:
; ?FLOC___DalyBms_update?T148 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T148 end address is: 2 (W1)
;BMS.c,92 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,93 :: 		case 9:
L_DalyBms_update31:
;BMS.c,94 :: 		bms->requestCounter = DalyBms_getFailureCodes(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	CALL	_DalyBms_getFailureCodes
	CP0.B	W0
	BRA NZ	L__DalyBms_update254
	GOTO	L_DalyBms_update32
L__DalyBms_update254:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T159 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T159 end address is: 2 (W1)
	GOTO	L_DalyBms_update33
L_DalyBms_update32:
; ?FLOC___DalyBms_update?T159 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T159 end address is: 2 (W1)
L_DalyBms_update33:
; ?FLOC___DalyBms_update?T159 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T159 end address is: 2 (W1)
;BMS.c,95 :: 		if (bms->getStaticData)
	MOV	#402, W0
	ADD	W10, W0, W0
	CP0.B	[W0]
	BRA NZ	L__DalyBms_update255
	GOTO	L_DalyBms_update34
L__DalyBms_update255:
;BMS.c,96 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
L_DalyBms_update34:
;BMS.c,97 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update256
	GOTO	L_DalyBms_update35
L__DalyBms_update256:
;BMS.c,98 :: 		bms->requestCallback();
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,99 :: 		}
L_DalyBms_update35:
;BMS.c,100 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,101 :: 		case 10:
L_DalyBms_update36:
;BMS.c,102 :: 		if (!bms->getStaticData)
	MOV	#402, W0
	ADD	W10, W0, W0
	CP0.B	[W0]
	BRA Z	L__DalyBms_update257
	GOTO	L_DalyBms_update37
L__DalyBms_update257:
;BMS.c,103 :: 		bms->requestCounter = DalyBms_getVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getVoltageThreshold
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update258
	GOTO	L_DalyBms_update38
L__DalyBms_update258:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T197 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T197 end address is: 2 (W1)
	GOTO	L_DalyBms_update39
L_DalyBms_update38:
; ?FLOC___DalyBms_update?T197 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T197 end address is: 2 (W1)
L_DalyBms_update39:
; ?FLOC___DalyBms_update?T197 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T197 end address is: 2 (W1)
L_DalyBms_update37:
;BMS.c,104 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update259
	GOTO	L_DalyBms_update40
L__DalyBms_update259:
;BMS.c,105 :: 		bms->requestCallback();
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,106 :: 		}
L_DalyBms_update40:
;BMS.c,107 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,108 :: 		case 11:
L_DalyBms_update41:
;BMS.c,109 :: 		if (!bms->getStaticData)
	MOV	#402, W0
	ADD	W10, W0, W0
	CP0.B	[W0]
	BRA Z	L__DalyBms_update260
	GOTO	L_DalyBms_update42
L__DalyBms_update260:
;BMS.c,110 :: 		bms->requestCounter = DalyBms_getPackVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	_DalyBms_getPackVoltageThreshold
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_update261
	GOTO	L_DalyBms_update43
L__DalyBms_update261:
	ADD	W10, #4, W0
	ZE	[W0], W0
; ?FLOC___DalyBms_update?T226 start address is: 2 (W1)
	ADD	W0, #1, W1
; ?FLOC___DalyBms_update?T226 end address is: 2 (W1)
	GOTO	L_DalyBms_update44
L_DalyBms_update43:
; ?FLOC___DalyBms_update?T226 start address is: 2 (W1)
	CLR	W1
; ?FLOC___DalyBms_update?T226 end address is: 2 (W1)
L_DalyBms_update44:
; ?FLOC___DalyBms_update?T226 start address is: 2 (W1)
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
; ?FLOC___DalyBms_update?T226 end address is: 2 (W1)
L_DalyBms_update42:
;BMS.c,111 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,112 :: 		if (bms->requestCallback != NULL) {
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__DalyBms_update262
	GOTO	L_DalyBms_update45
L__DalyBms_update262:
;BMS.c,113 :: 		bms->requestCallback();
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	CALL	W0
	POP	W10
;BMS.c,114 :: 		}
L_DalyBms_update45:
;BMS.c,115 :: 		bms->getStaticData = true;
	MOV	#402, W0
	ADD	W10, W0, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,116 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,118 :: 		default:
L_DalyBms_update46:
;BMS.c,119 :: 		break;
	GOTO	L_DalyBms_update2
;BMS.c,120 :: 		}
L_DalyBms_update1:
	MOV	[W14+2], W1
	MOV.B	[W1], W0
	CP.B	W0, #0
	BRA NZ	L__DalyBms_update263
	GOTO	L_DalyBms_update3
L__DalyBms_update263:
	MOV.B	[W1], W0
	CP.B	W0, #1
	BRA NZ	L__DalyBms_update264
	GOTO	L_DalyBms_update4
L__DalyBms_update264:
	MOV.B	[W1], W0
	CP.B	W0, #2
	BRA NZ	L__DalyBms_update265
	GOTO	L_DalyBms_update10
L__DalyBms_update265:
	MOV.B	[W1], W0
	CP.B	W0, #3
	BRA NZ	L__DalyBms_update266
	GOTO	L_DalyBms_update13
L__DalyBms_update266:
	MOV.B	[W1], W0
	CP.B	W0, #4
	BRA NZ	L__DalyBms_update267
	GOTO	L_DalyBms_update16
L__DalyBms_update267:
	MOV.B	[W1], W0
	CP.B	W0, #5
	BRA NZ	L__DalyBms_update268
	GOTO	L_DalyBms_update19
L__DalyBms_update268:
	MOV.B	[W1], W0
	CP.B	W0, #6
	BRA NZ	L__DalyBms_update269
	GOTO	L_DalyBms_update22
L__DalyBms_update269:
	MOV.B	[W1], W0
	CP.B	W0, #7
	BRA NZ	L__DalyBms_update270
	GOTO	L_DalyBms_update25
L__DalyBms_update270:
	MOV.B	[W1], W0
	CP.B	W0, #8
	BRA NZ	L__DalyBms_update271
	GOTO	L_DalyBms_update28
L__DalyBms_update271:
	MOV.B	[W1], W0
	CP.B	W0, #9
	BRA NZ	L__DalyBms_update272
	GOTO	L_DalyBms_update31
L__DalyBms_update272:
	MOV.B	[W1], W0
	CP.B	W0, #10
	BRA NZ	L__DalyBms_update273
	GOTO	L_DalyBms_update36
L__DalyBms_update273:
	MOV.B	[W1], W0
	CP.B	W0, #11
	BRA NZ	L__DalyBms_update274
	GOTO	L_DalyBms_update41
L__DalyBms_update274:
	GOTO	L_DalyBms_update46
L_DalyBms_update2:
;BMS.c,121 :: 		bms->previousTime = current_millis();
	MOV	W10, W0
	MOV	W0, [W14+0]
	CALL	_current_millis
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;BMS.c,122 :: 		}
L_DalyBms_update0:
;BMS.c,123 :: 		return true;
	MOV.B	#1, W0
;BMS.c,124 :: 		}
L_end_DalyBms_update:
	ULNK
	RETURN
; end of _DalyBms_update

_DalyBms_getVoltageThreshold:
	LNK	#2

;BMS.c,126 :: 		bool DalyBms_getVoltageThreshold(DalyBms* bms) // 0x59
;BMS.c,128 :: 		if (!DalyBms_requestData(bms, CELL_THRESHOLDS, 1))
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#89, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getVoltageThreshold276
	GOTO	L_DalyBms_getVoltageThreshold47
L__DalyBms_getVoltageThreshold276:
;BMS.c,130 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getVoltageThreshold
;BMS.c,131 :: 		}
L_DalyBms_getVoltageThreshold47:
;BMS.c,133 :: 		bms->get.maxCellThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
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
;BMS.c,134 :: 		bms->get.maxCellThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
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
;BMS.c,135 :: 		bms->get.minCellThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
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
;BMS.c,136 :: 		bms->get.minCellThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);
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
;BMS.c,138 :: 		return true;
	MOV.B	#1, W0
;BMS.c,139 :: 		}
;BMS.c,138 :: 		return true;
;BMS.c,139 :: 		}
L_end_DalyBms_getVoltageThreshold:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getVoltageThreshold

_DalyBms_getPackVoltageThreshold:
	LNK	#2

;BMS.c,141 :: 		bool DalyBms_getPackVoltageThreshold(DalyBms* bms) // 0x5A
;BMS.c,143 :: 		if (!DalyBms_requestData(bms, PACK_THRESHOLDS, 1))
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#90, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getPackVoltageThreshold278
	GOTO	L_DalyBms_getPackVoltageThreshold48
L__DalyBms_getPackVoltageThreshold278:
;BMS.c,145 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackVoltageThreshold
;BMS.c,146 :: 		}
L_DalyBms_getPackVoltageThreshold48:
;BMS.c,148 :: 		bms->get.maxPackThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
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
;BMS.c,149 :: 		bms->get.maxPackThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
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
;BMS.c,150 :: 		bms->get.minPackThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
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
;BMS.c,151 :: 		bms->get.minPackThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);
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
;BMS.c,153 :: 		return true;
	MOV.B	#1, W0
;BMS.c,154 :: 		}
;BMS.c,153 :: 		return true;
;BMS.c,154 :: 		}
L_end_DalyBms_getPackVoltageThreshold:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getPackVoltageThreshold

_DalyBms_getPackMeasurements:
	LNK	#2

;BMS.c,156 :: 		bool DalyBms_getPackMeasurements(DalyBms* bms) // 0x90
;BMS.c,158 :: 		if (!DalyBms_requestData(bms, VOUT_IOUT_SOC, 1))
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#144, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getPackMeasurements280
	GOTO	L_DalyBms_getPackMeasurements49
L__DalyBms_getPackMeasurements280:
;BMS.c,160 :: 		DalyBms_clearGet(bms);
	CALL	BMS_DalyBms_clearGet
;BMS.c,161 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackMeasurements
;BMS.c,162 :: 		}
L_DalyBms_getPackMeasurements49:
;BMS.c,166 :: 		if (((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f) == -3000.f)
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
	BRA NZ	L__DalyBms_getPackMeasurements281
	INC.B	W0
L__DalyBms_getPackMeasurements281:
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_getPackMeasurements282
	GOTO	L_DalyBms_getPackMeasurements51
L__DalyBms_getPackMeasurements282:
;BMS.c,168 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackMeasurements
;BMS.c,169 :: 		}
L_DalyBms_getPackMeasurements51:
;BMS.c,172 :: 		if (((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f) > 100.f)
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
	BRA LE	L__DalyBms_getPackMeasurements283
	INC.B	W0
L__DalyBms_getPackMeasurements283:
	POP	W10
	CP0.B	W0
	BRA NZ	L__DalyBms_getPackMeasurements284
	GOTO	L_DalyBms_getPackMeasurements53
L__DalyBms_getPackMeasurements284:
;BMS.c,174 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackMeasurements
;BMS.c,175 :: 		}
L_DalyBms_getPackMeasurements53:
;BMS.c,178 :: 		bms->get.packVoltage = ((float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]) / 10.0f);
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
;BMS.c,179 :: 		bms->get.packCurrent = ((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f);
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
;BMS.c,180 :: 		bms->get.packSOC = ((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f);
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
;BMS.c,181 :: 		return true;
	MOV.B	#1, W0
;BMS.c,182 :: 		}
;BMS.c,181 :: 		return true;
;BMS.c,182 :: 		}
L_end_DalyBms_getPackMeasurements:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getPackMeasurements

_DalyBms_getMinMaxCellVoltage:
	LNK	#2

;BMS.c,184 :: 		bool DalyBms_getMinMaxCellVoltage(DalyBms* bms) // 0x91
;BMS.c,186 :: 		if (!DalyBms_requestData(bms, MIN_MAX_CELL_VOLTAGE, 1))
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#145, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getMinMaxCellVoltage286
	GOTO	L_DalyBms_getMinMaxCellVoltage54
L__DalyBms_getMinMaxCellVoltage286:
;BMS.c,188 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getMinMaxCellVoltage
;BMS.c,189 :: 		}
L_DalyBms_getMinMaxCellVoltage54:
;BMS.c,191 :: 		bms->get.maxCellmV = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
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
;BMS.c,192 :: 		bms->get.maxCellVNum = bms->frameBuff[0][6];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#48, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,193 :: 		bms->get.minCellmV = (float)((bms->frameBuff[0][7] << 8) | bms->frameBuff[0][8]);
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
;BMS.c,194 :: 		bms->get.minCellVNum = bms->frameBuff[0][9];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#54, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,195 :: 		bms->get.cellDiff = (bms->get.maxCellmV - bms->get.minCellmV);
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
;BMS.c,197 :: 		return true;
	MOV.B	#1, W0
;BMS.c,198 :: 		}
;BMS.c,197 :: 		return true;
;BMS.c,198 :: 		}
L_end_DalyBms_getMinMaxCellVoltage:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getMinMaxCellVoltage

_DalyBms_getPackTemp:
	LNK	#2

;BMS.c,200 :: 		bool DalyBms_getPackTemp(DalyBms* bms) // 0x92
;BMS.c,202 :: 		if (!DalyBms_requestData(bms, MIN_MAX_TEMPERATURE, 1))
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#146, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getPackTemp288
	GOTO	L_DalyBms_getPackTemp55
L__DalyBms_getPackTemp288:
;BMS.c,204 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getPackTemp
;BMS.c,205 :: 		}
L_DalyBms_getPackTemp55:
;BMS.c,206 :: 		bms->get.tempAverage = ((bms->frameBuff[0][4] - 40) + (bms->frameBuff[0][6] - 40)) / 2;
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
;BMS.c,208 :: 		return true;
	MOV.B	#1, W0
;BMS.c,209 :: 		}
;BMS.c,208 :: 		return true;
;BMS.c,209 :: 		}
L_end_DalyBms_getPackTemp:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getPackTemp

_DalyBms_getDischargeChargeMosStatus:
	LNK	#18

;BMS.c,211 :: 		bool DalyBms_getDischargeChargeMosStatus(DalyBms* bms) // 0x93
;BMS.c,216 :: 		if (!DalyBms_requestData(bms, DISCHARGE_CHARGE_MOS_STATUS, 1))
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#147, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getDischargeChargeMosStatus290
	GOTO	L_DalyBms_getDischargeChargeMosStatus56
L__DalyBms_getDischargeChargeMosStatus290:
;BMS.c,218 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getDischargeChargeMosStatus
;BMS.c,219 :: 		}
L_DalyBms_getDischargeChargeMosStatus56:
;BMS.c,221 :: 		switch (bms->frameBuff[0][4])
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W2
	GOTO	L_DalyBms_getDischargeChargeMosStatus57
;BMS.c,223 :: 		case 0:
L_DalyBms_getDischargeChargeMosStatus59:
;BMS.c,224 :: 		bms->get.chargeDischargeStatus = "Stationary";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_1_BMS), W0
	MOV	W0, [W1]
;BMS.c,225 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,226 :: 		case 1:
L_DalyBms_getDischargeChargeMosStatus60:
;BMS.c,227 :: 		bms->get.chargeDischargeStatus = "Charge";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_2_BMS), W0
	MOV	W0, [W1]
;BMS.c,228 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,229 :: 		case 2:
L_DalyBms_getDischargeChargeMosStatus61:
;BMS.c,230 :: 		bms->get.chargeDischargeStatus = "Discharge";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_3_BMS), W0
	MOV	W0, [W1]
;BMS.c,231 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,232 :: 		default:
L_DalyBms_getDischargeChargeMosStatus62:
;BMS.c,233 :: 		bms->get.chargeDischargeStatus = "Unknown";
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_4_BMS), W0
	MOV	W0, [W1]
;BMS.c,234 :: 		break;
	GOTO	L_DalyBms_getDischargeChargeMosStatus58
;BMS.c,235 :: 		}
L_DalyBms_getDischargeChargeMosStatus57:
	MOV.B	[W2], W0
	CP.B	W0, #0
	BRA NZ	L__DalyBms_getDischargeChargeMosStatus291
	GOTO	L_DalyBms_getDischargeChargeMosStatus59
L__DalyBms_getDischargeChargeMosStatus291:
	MOV.B	[W2], W0
	CP.B	W0, #1
	BRA NZ	L__DalyBms_getDischargeChargeMosStatus292
	GOTO	L_DalyBms_getDischargeChargeMosStatus60
L__DalyBms_getDischargeChargeMosStatus292:
	MOV.B	[W2], W0
	CP.B	W0, #2
	BRA NZ	L__DalyBms_getDischargeChargeMosStatus293
	GOTO	L_DalyBms_getDischargeChargeMosStatus61
L__DalyBms_getDischargeChargeMosStatus293:
	GOTO	L_DalyBms_getDischargeChargeMosStatus62
L_DalyBms_getDischargeChargeMosStatus58:
;BMS.c,237 :: 		bms->get.chargeFetState = BIT_READ(bms->frameBuff[0][5], 0); // Assuming 0 or 1 indicates state
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
;BMS.c,238 :: 		bms->get.disChargeFetState = BIT_READ(bms->frameBuff[0][6], 0); // Assuming 0 or 1 indicates state
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
;BMS.c,239 :: 		bms->get.bmsHeartBeat = bms->frameBuff[0][7];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#64, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,240 :: 		tmpAh = (float)(((uint32_t)bms->frameBuff[0][8] << 0x18) | ((uint32_t)bms->frameBuff[0][9] << 0x10) | ((uint32_t)bms->frameBuff[0][10] << 0x08) | (uint32_t)bms->frameBuff[0][11]) * 0.001;
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
;BMS.c,241 :: 		sprintf(msgbuff, "%.1f", tmpAh); // Use sprintf for float to string conversion
	ADD	W14, #0, W2
	PUSH.D	W0
	MOV	#lo_addr(?lstr_5_BMS), W0
	PUSH	W0
	PUSH	W2
	CALL	_sprintf
	SUB	#8, W15
	POP	W10
;BMS.c,242 :: 		bms->get.resCapacityAh = atof(msgbuff);
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
;BMS.c,244 :: 		return true;
	MOV.B	#1, W0
;BMS.c,245 :: 		}
;BMS.c,244 :: 		return true;
;BMS.c,245 :: 		}
L_end_DalyBms_getDischargeChargeMosStatus:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _DalyBms_getDischargeChargeMosStatus

_DalyBms_getStatusInfo:

;BMS.c,247 :: 		bool DalyBms_getStatusInfo(DalyBms* bms) // 0x94
;BMS.c,251 :: 		if (!DalyBms_requestData(bms, STATUS_INFO, 1))
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#148, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getStatusInfo295
	GOTO	L_DalyBms_getStatusInfo63
L__DalyBms_getStatusInfo295:
;BMS.c,253 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getStatusInfo
;BMS.c,254 :: 		}
L_DalyBms_getStatusInfo63:
;BMS.c,256 :: 		bms->get.numberOfCells = bms->frameBuff[0][4];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,257 :: 		bms->get.numOfTempSensors = bms->frameBuff[0][5];
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W1
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	ZE	[W0], W0
	MOV	W0, [W1]
;BMS.c,258 :: 		bms->get.chargeState = BIT_READ(bms->frameBuff[0][6], 0); // Assuming 0 or 1 indicates state
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
;BMS.c,259 :: 		bms->get.loadState = BIT_READ(bms->frameBuff[0][7], 0);   // Assuming 0 or 1 indicates state
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
;BMS.c,262 :: 		for (i = 0; i < 8; i++)
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_DalyBms_getStatusInfo64:
; i start address is: 4 (W2)
	CP	W2, #8
	BRA LTU	L__DalyBms_getStatusInfo296
	GOTO	L_DalyBms_getStatusInfo65
L__DalyBms_getStatusInfo296:
;BMS.c,264 :: 		bms->get.dIO[i] = BIT_READ(bms->frameBuff[0][8], i);
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
;BMS.c,262 :: 		for (i = 0; i < 8; i++)
	INC	W2
;BMS.c,265 :: 		}
; i end address is: 4 (W2)
	GOTO	L_DalyBms_getStatusInfo64
L_DalyBms_getStatusInfo65:
;BMS.c,267 :: 		bms->get.bmsCycles = ((uint16_t)bms->frameBuff[0][9] << 0x08) | (uint16_t)bms->frameBuff[0][10];
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
;BMS.c,269 :: 		return true;
	MOV.B	#1, W0
;BMS.c,270 :: 		}
;BMS.c,269 :: 		return true;
;BMS.c,270 :: 		}
L_end_DalyBms_getStatusInfo:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_getStatusInfo

_DalyBms_getCellVoltages:
	LNK	#8

;BMS.c,272 :: 		bool DalyBms_getCellVoltages(DalyBms* bms) // 0x95
;BMS.c,279 :: 		cellNo = 0;
	PUSH	W11
	PUSH	W12
	CLR	W0
	MOV	W0, [W14+0]
;BMS.c,282 :: 		if (bms->get.numberOfCells < MIN_NUMBER_CELLS || bms->get.numberOfCells > MAX_NUMBER_CELLS)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA GEU	L__DalyBms_getCellVoltages298
	GOTO	L__DalyBms_getCellVoltages226
L__DalyBms_getCellVoltages298:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W1
	MOV	#48, W0
	CP	W1, W0
	BRA LEU	L__DalyBms_getCellVoltages299
	GOTO	L__DalyBms_getCellVoltages225
L__DalyBms_getCellVoltages299:
	GOTO	L_DalyBms_getCellVoltages69
L__DalyBms_getCellVoltages226:
L__DalyBms_getCellVoltages225:
;BMS.c,284 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellVoltages
;BMS.c,285 :: 		}
L_DalyBms_getCellVoltages69:
;BMS.c,287 :: 		if (DalyBms_requestData(bms, CELL_VOLTAGES, (unsigned int)ceil(bms->get.numberOfCells / 3.0)))
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
	MOV	W0, W12
	MOV.B	#149, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA NZ	L__DalyBms_getCellVoltages300
	GOTO	L_DalyBms_getCellVoltages70
L__DalyBms_getCellVoltages300:
;BMS.c,289 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numberOfCells / 3.0); k++)
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
	BRA GTU	L__DalyBms_getCellVoltages301
	GOTO	L_DalyBms_getCellVoltages72
L__DalyBms_getCellVoltages301:
;BMS.c,291 :: 		for (i = 0; i < 3; i++)
; i start address is: 10 (W5)
	CLR	W5
; i end address is: 10 (W5)
L_DalyBms_getCellVoltages74:
; i start address is: 10 (W5)
	CP	W5, #3
	BRA LTU	L__DalyBms_getCellVoltages302
	GOTO	L_DalyBms_getCellVoltages75
L__DalyBms_getCellVoltages302:
;BMS.c,293 :: 		if (cellNo < MAX_NUMBER_CELLS) { // Ensure no out-of-bounds access
	MOV	#48, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__DalyBms_getCellVoltages303
	GOTO	L_DalyBms_getCellVoltages77
L__DalyBms_getCellVoltages303:
;BMS.c,294 :: 		bms->get.cellVmV[cellNo] = (float)((bms->frameBuff[k][5 + (i * 2)] << 8) | bms->frameBuff[k][6 + (i * 2)]);
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
;BMS.c,295 :: 		}
L_DalyBms_getCellVoltages77:
;BMS.c,296 :: 		cellNo++;
	MOV	[W14+0], W0
	ADD	W0, #1, W2
	MOV	W2, [W14+0]
;BMS.c,297 :: 		if (cellNo >= bms->get.numberOfCells)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W2, W0
	BRA GEU	L__DalyBms_getCellVoltages304
	GOTO	L_DalyBms_getCellVoltages78
L__DalyBms_getCellVoltages304:
; i end address is: 10 (W5)
;BMS.c,298 :: 		break;
	GOTO	L_DalyBms_getCellVoltages75
L_DalyBms_getCellVoltages78:
;BMS.c,291 :: 		for (i = 0; i < 3; i++)
; i start address is: 0 (W0)
; i start address is: 10 (W5)
	ADD	W5, #1, W0
; i end address is: 10 (W5)
;BMS.c,299 :: 		}
	MOV	W0, W5
; i end address is: 0 (W0)
	GOTO	L_DalyBms_getCellVoltages74
L_DalyBms_getCellVoltages75:
;BMS.c,289 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numberOfCells / 3.0); k++)
	MOV	[W14+2], W1
	ADD	W14, #2, W0
	ADD	W1, #1, [W0]
;BMS.c,300 :: 		}
	GOTO	L_DalyBms_getCellVoltages71
L_DalyBms_getCellVoltages72:
;BMS.c,301 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_DalyBms_getCellVoltages
;BMS.c,302 :: 		}
L_DalyBms_getCellVoltages70:
;BMS.c,305 :: 		return false;
	CLR	W0
;BMS.c,307 :: 		}
;BMS.c,305 :: 		return false;
;BMS.c,307 :: 		}
L_end_DalyBms_getCellVoltages:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getCellVoltages

_DalyBms_getCellTemperature:
	LNK	#4

;BMS.c,309 :: 		bool DalyBms_getCellTemperature(DalyBms* bms) // 0x96
;BMS.c,316 :: 		sensorNo = 0;
	PUSH	W11
	PUSH	W12
	CLR	W0
	MOV	W0, [W14+0]
;BMS.c,319 :: 		if ((bms->get.numOfTempSensors < MIN_NUMBER_TEMP_SENSORS) || (bms->get.numOfTempSensors > MAX_NUMBER_TEMP_SENSORS))
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA GEU	L__DalyBms_getCellTemperature306
	GOTO	L__DalyBms_getCellTemperature229
L__DalyBms_getCellTemperature306:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #16
	BRA LEU	L__DalyBms_getCellTemperature307
	GOTO	L__DalyBms_getCellTemperature228
L__DalyBms_getCellTemperature307:
	GOTO	L_DalyBms_getCellTemperature82
L__DalyBms_getCellTemperature229:
L__DalyBms_getCellTemperature228:
;BMS.c,321 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellTemperature
;BMS.c,322 :: 		}
L_DalyBms_getCellTemperature82:
;BMS.c,324 :: 		if (DalyBms_requestData(bms, CELL_TEMPERATURE, (unsigned int)ceil(bms->get.numOfTempSensors / 7.0)))
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
	MOV	W0, W12
	MOV.B	#150, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA NZ	L__DalyBms_getCellTemperature308
	GOTO	L_DalyBms_getCellTemperature83
L__DalyBms_getCellTemperature308:
;BMS.c,326 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numOfTempSensors / 7.0); k++)
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
	BRA GTU	L__DalyBms_getCellTemperature309
	GOTO	L_DalyBms_getCellTemperature85
L__DalyBms_getCellTemperature309:
;BMS.c,328 :: 		for (i = 0; i < 7; i++)
; i start address is: 10 (W5)
	CLR	W5
; i end address is: 10 (W5)
	MOV	W5, W6
L_DalyBms_getCellTemperature87:
; i start address is: 12 (W6)
	CP	W6, #7
	BRA LTU	L__DalyBms_getCellTemperature310
	GOTO	L_DalyBms_getCellTemperature88
L__DalyBms_getCellTemperature310:
;BMS.c,330 :: 		if (sensorNo < MAX_NUMBER_TEMP_SENSORS) { // Ensure no out-of-bounds access
	MOV	[W14+0], W0
	CP	W0, #16
	BRA LTU	L__DalyBms_getCellTemperature311
	GOTO	L_DalyBms_getCellTemperature90
L__DalyBms_getCellTemperature311:
;BMS.c,331 :: 		bms->get.cellTemperature[sensorNo] = (bms->frameBuff[k][5 + i] - 40);
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
;BMS.c,332 :: 		}
L_DalyBms_getCellTemperature90:
;BMS.c,333 :: 		sensorNo++;
	MOV	[W14+0], W0
	ADD	W0, #1, W2
	MOV	W2, [W14+0]
;BMS.c,334 :: 		if (sensorNo >= bms->get.numOfTempSensors)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#72, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W2, W0
	BRA GEU	L__DalyBms_getCellTemperature312
	GOTO	L_DalyBms_getCellTemperature91
L__DalyBms_getCellTemperature312:
; i end address is: 12 (W6)
;BMS.c,335 :: 		break;
	GOTO	L_DalyBms_getCellTemperature88
L_DalyBms_getCellTemperature91:
;BMS.c,328 :: 		for (i = 0; i < 7; i++)
; i start address is: 10 (W5)
; i start address is: 12 (W6)
	ADD	W6, #1, W5
; i end address is: 12 (W6)
;BMS.c,336 :: 		}
	MOV	W5, W6
; i end address is: 10 (W5)
	GOTO	L_DalyBms_getCellTemperature87
L_DalyBms_getCellTemperature88:
;BMS.c,326 :: 		for (k = 0; k < (unsigned int)ceil(bms->get.numOfTempSensors / 7.0); k++)
	MOV	[W14+2], W1
	ADD	W14, #2, W0
	ADD	W1, #1, [W0]
;BMS.c,337 :: 		}
	GOTO	L_DalyBms_getCellTemperature84
L_DalyBms_getCellTemperature85:
;BMS.c,338 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_DalyBms_getCellTemperature
;BMS.c,339 :: 		}
L_DalyBms_getCellTemperature83:
;BMS.c,342 :: 		return false;
	CLR	W0
;BMS.c,344 :: 		}
;BMS.c,342 :: 		return false;
;BMS.c,344 :: 		}
L_end_DalyBms_getCellTemperature:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _DalyBms_getCellTemperature

_DalyBms_getCellBalanceState:

;BMS.c,346 :: 		bool DalyBms_getCellBalanceState(DalyBms* bms) // 0x97
;BMS.c,353 :: 		cellBalance = 0;
	PUSH	W11
	PUSH	W12
; cellBalance start address is: 14 (W7)
	CLR	W7
;BMS.c,354 :: 		cellBit = 0;
; cellBit start address is: 16 (W8)
	CLR	W8
;BMS.c,357 :: 		if (bms->get.numberOfCells < MIN_NUMBER_CELLS || bms->get.numberOfCells > MAX_NUMBER_CELLS)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA GEU	L__DalyBms_getCellBalanceState314
	GOTO	L__DalyBms_getCellBalanceState232
L__DalyBms_getCellBalanceState314:
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#70, W0
	ADD	W1, W0, W0
	MOV	[W0], W1
	MOV	#48, W0
	CP	W1, W0
	BRA LEU	L__DalyBms_getCellBalanceState315
	GOTO	L__DalyBms_getCellBalanceState231
L__DalyBms_getCellBalanceState315:
	GOTO	L_DalyBms_getCellBalanceState95
; cellBalance end address is: 14 (W7)
; cellBit end address is: 16 (W8)
L__DalyBms_getCellBalanceState232:
L__DalyBms_getCellBalanceState231:
;BMS.c,359 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellBalanceState
;BMS.c,360 :: 		}
L_DalyBms_getCellBalanceState95:
;BMS.c,362 :: 		if (!DalyBms_requestData(bms, CELL_BALANCE_STATE, 1))
; cellBit start address is: 16 (W8)
; cellBalance start address is: 14 (W7)
	MOV	#1, W12
	MOV.B	#151, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getCellBalanceState316
	GOTO	L_DalyBms_getCellBalanceState96
L__DalyBms_getCellBalanceState316:
; cellBalance end address is: 14 (W7)
; cellBit end address is: 16 (W8)
;BMS.c,364 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getCellBalanceState
;BMS.c,365 :: 		}
L_DalyBms_getCellBalanceState96:
;BMS.c,368 :: 		for (i = 0; i < 6; i++)
; i start address is: 6 (W3)
; cellBit start address is: 16 (W8)
; cellBalance start address is: 14 (W7)
	CLR	W3
; cellBalance end address is: 14 (W7)
; cellBit end address is: 16 (W8)
; i end address is: 6 (W3)
	MOV	W7, W6
	MOV	W8, W5
L_DalyBms_getCellBalanceState97:
; i start address is: 6 (W3)
; cellBit start address is: 10 (W5)
; cellBalance start address is: 12 (W6)
	CP	W3, #6
	BRA LTU	L__DalyBms_getCellBalanceState317
	GOTO	L__DalyBms_getCellBalanceState235
L__DalyBms_getCellBalanceState317:
;BMS.c,371 :: 		for (j = 0; j < 8; j++)
; j start address is: 8 (W4)
	CLR	W4
; cellBit end address is: 10 (W5)
; j end address is: 8 (W4)
; cellBalance end address is: 12 (W6)
; i end address is: 6 (W3)
L_DalyBms_getCellBalanceState100:
; j start address is: 8 (W4)
; cellBalance start address is: 12 (W6)
; cellBit start address is: 10 (W5)
; i start address is: 6 (W3)
	CP	W4, #8
	BRA LTU	L__DalyBms_getCellBalanceState318
	GOTO	L__DalyBms_getCellBalanceState234
L__DalyBms_getCellBalanceState318:
;BMS.c,373 :: 		if (cellBit < MAX_NUMBER_CELLS) { // Ensure no out-of-bounds access
	MOV	#48, W0
	CP	W5, W0
	BRA LT	L__DalyBms_getCellBalanceState319
	GOTO	L_DalyBms_getCellBalanceState103
L__DalyBms_getCellBalanceState319:
;BMS.c,374 :: 		bms->get.cellBalanceState[cellBit] = BIT_READ(bms->frameBuff[0][i + 4], j);
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#310, W0
	ADD	W1, W0, W0
	ADD	W0, W5, W2
	MOV	#602, W0
	ADD	W10, W0, W1
	ADD	W3, #4, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, W4, W0
	ZE	W0, W0
	AND	W0, #1, W0
	MOV.B	W0, [W2]
;BMS.c,375 :: 		}
L_DalyBms_getCellBalanceState103:
;BMS.c,376 :: 		if (BIT_READ(bms->frameBuff[0][i + 4], j))
	MOV	#602, W0
	ADD	W10, W0, W1
	ADD	W3, #4, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, W4, W0
	BTSS	W0, #0
	GOTO	L__DalyBms_getCellBalanceState233
;BMS.c,378 :: 		cellBalance++;
; cellBalance start address is: 4 (W2)
	ADD	W6, #1, W2
; cellBalance end address is: 12 (W6)
; cellBalance end address is: 4 (W2)
;BMS.c,379 :: 		}
	GOTO	L_DalyBms_getCellBalanceState104
L__DalyBms_getCellBalanceState233:
;BMS.c,376 :: 		if (BIT_READ(bms->frameBuff[0][i + 4], j))
	MOV	W6, W2
;BMS.c,379 :: 		}
L_DalyBms_getCellBalanceState104:
;BMS.c,380 :: 		cellBit++;
; cellBalance start address is: 4 (W2)
	ADD	W5, #1, W1
	MOV	W1, W5
;BMS.c,381 :: 		if (cellBit >= MAX_NUMBER_CELLS) // Changed 47 to MAX_NUMBER_CELLS for robustness
	MOV	#48, W0
	CP	W1, W0
	BRA GE	L__DalyBms_getCellBalanceState320
	GOTO	L_DalyBms_getCellBalanceState105
L__DalyBms_getCellBalanceState320:
; j end address is: 8 (W4)
;BMS.c,383 :: 		break;
	MOV	W2, W6
	MOV	W5, W1
	GOTO	L_DalyBms_getCellBalanceState101
;BMS.c,384 :: 		}
L_DalyBms_getCellBalanceState105:
;BMS.c,371 :: 		for (j = 0; j < 8; j++)
; j start address is: 8 (W4)
	INC	W4
;BMS.c,385 :: 		}
; cellBalance end address is: 4 (W2)
; cellBit end address is: 10 (W5)
; j end address is: 8 (W4)
	MOV	W2, W6
	GOTO	L_DalyBms_getCellBalanceState100
L__DalyBms_getCellBalanceState234:
;BMS.c,371 :: 		for (j = 0; j < 8; j++)
	MOV	W5, W1
;BMS.c,385 :: 		}
L_DalyBms_getCellBalanceState101:
;BMS.c,386 :: 		if (cellBit >= MAX_NUMBER_CELLS) {
; cellBit start address is: 2 (W1)
; cellBalance start address is: 12 (W6)
	MOV	#48, W0
	CP	W1, W0
	BRA GE	L__DalyBms_getCellBalanceState321
	GOTO	L_DalyBms_getCellBalanceState106
L__DalyBms_getCellBalanceState321:
; cellBit end address is: 2 (W1)
; i end address is: 6 (W3)
;BMS.c,387 :: 		break;
	MOV	W6, W0
	GOTO	L_DalyBms_getCellBalanceState98
;BMS.c,388 :: 		}
L_DalyBms_getCellBalanceState106:
;BMS.c,368 :: 		for (i = 0; i < 6; i++)
; i start address is: 6 (W3)
; cellBit start address is: 2 (W1)
	INC	W3
;BMS.c,389 :: 		}
; cellBit end address is: 2 (W1)
; cellBalance end address is: 12 (W6)
; i end address is: 6 (W3)
	MOV	W1, W5
	GOTO	L_DalyBms_getCellBalanceState97
L__DalyBms_getCellBalanceState235:
;BMS.c,368 :: 		for (i = 0; i < 6; i++)
	MOV	W6, W0
;BMS.c,389 :: 		}
L_DalyBms_getCellBalanceState98:
;BMS.c,391 :: 		if (cellBalance > 0)
; cellBalance start address is: 0 (W0)
	CP	W0, #0
	BRA GT	L__DalyBms_getCellBalanceState322
	GOTO	L_DalyBms_getCellBalanceState107
L__DalyBms_getCellBalanceState322:
; cellBalance end address is: 0 (W0)
;BMS.c,393 :: 		bms->get.cellBalanceActive = true;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#358, W0
	ADD	W1, W0, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,394 :: 		}
	GOTO	L_DalyBms_getCellBalanceState108
L_DalyBms_getCellBalanceState107:
;BMS.c,397 :: 		bms->get.cellBalanceActive = false;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#358, W0
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,398 :: 		}
L_DalyBms_getCellBalanceState108:
;BMS.c,400 :: 		return true;
	MOV.B	#1, W0
;BMS.c,401 :: 		}
;BMS.c,400 :: 		return true;
;BMS.c,401 :: 		}
L_end_DalyBms_getCellBalanceState:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_getCellBalanceState

_DalyBms_getFailureCodes:

;BMS.c,403 :: 		bool DalyBms_getFailureCodes(DalyBms* bms) // 0x98
;BMS.c,407 :: 		if (!DalyBms_requestData(bms, FAILURE_CODES, 1))
	PUSH	W11
	PUSH	W12
	MOV	#1, W12
	MOV.B	#152, W11
	CALL	BMS_DalyBms_requestData
	CP0.B	W0
	BRA Z	L__DalyBms_getFailureCodes324
	GOTO	L_DalyBms_getFailureCodes109
L__DalyBms_getFailureCodes324:
;BMS.c,409 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_getFailureCodes
;BMS.c,410 :: 		}
L_DalyBms_getFailureCodes109:
;BMS.c,412 :: 		bms->failCodeArr[0] = '\0'; // Clear the string
	ADD	W10, #10, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,415 :: 		if (BIT_READ(bms->frameBuff[0][4], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes110
;BMS.c,416 :: 		strcat(bms->failCodeArr, "Cell volt high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr6_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes111
L_DalyBms_getFailureCodes110:
;BMS.c,417 :: 		else if (BIT_READ(bms->frameBuff[0][4], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes112
;BMS.c,418 :: 		strcat(bms->failCodeArr, "Cell volt high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr7_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes112:
L_DalyBms_getFailureCodes111:
;BMS.c,419 :: 		if (BIT_READ(bms->frameBuff[0][4], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes113
;BMS.c,420 :: 		strcat(bms->failCodeArr, "Cell volt low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr8_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes114
L_DalyBms_getFailureCodes113:
;BMS.c,421 :: 		else if (BIT_READ(bms->frameBuff[0][4], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes115
;BMS.c,422 :: 		strcat(bms->failCodeArr, "Cell volt low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr9_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes115:
L_DalyBms_getFailureCodes114:
;BMS.c,423 :: 		if (BIT_READ(bms->frameBuff[0][4], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes116
;BMS.c,424 :: 		strcat(bms->failCodeArr, "Sum volt high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr10_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes117
L_DalyBms_getFailureCodes116:
;BMS.c,425 :: 		else if (BIT_READ(bms->frameBuff[0][4], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes118
;BMS.c,426 :: 		strcat(bms->failCodeArr, "Sum volt high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr11_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes118:
L_DalyBms_getFailureCodes117:
;BMS.c,427 :: 		if (BIT_READ(bms->frameBuff[0][4], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes119
;BMS.c,428 :: 		strcat(bms->failCodeArr, "Sum volt low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr12_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes120
L_DalyBms_getFailureCodes119:
;BMS.c,429 :: 		else if (BIT_READ(bms->frameBuff[0][4], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes121
;BMS.c,430 :: 		strcat(bms->failCodeArr, "Sum volt low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr13_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes121:
L_DalyBms_getFailureCodes120:
;BMS.c,432 :: 		if (BIT_READ(bms->frameBuff[0][5], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes122
;BMS.c,433 :: 		strcat(bms->failCodeArr, "Chg temp high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr14_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes123
L_DalyBms_getFailureCodes122:
;BMS.c,434 :: 		else if (BIT_READ(bms->frameBuff[0][5], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes124
;BMS.c,435 :: 		strcat(bms->failCodeArr, "Chg temp high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr15_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes124:
L_DalyBms_getFailureCodes123:
;BMS.c,436 :: 		if (BIT_READ(bms->frameBuff[0][5], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes125
;BMS.c,437 :: 		strcat(bms->failCodeArr, "Chg temp low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr16_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes126
L_DalyBms_getFailureCodes125:
;BMS.c,438 :: 		else if (BIT_READ(bms->frameBuff[0][5], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes127
;BMS.c,439 :: 		strcat(bms->failCodeArr, "Chg temp low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr17_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes127:
L_DalyBms_getFailureCodes126:
;BMS.c,440 :: 		if (BIT_READ(bms->frameBuff[0][5], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes128
;BMS.c,441 :: 		strcat(bms->failCodeArr, "Dischg temp high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr18_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes129
L_DalyBms_getFailureCodes128:
;BMS.c,442 :: 		else if (BIT_READ(bms->frameBuff[0][5], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes130
;BMS.c,443 :: 		strcat(bms->failCodeArr, "Dischg temp high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr19_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes130:
L_DalyBms_getFailureCodes129:
;BMS.c,444 :: 		if (BIT_READ(bms->frameBuff[0][5], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes131
;BMS.c,445 :: 		strcat(bms->failCodeArr, "Dischg temp low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr20_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes132
L_DalyBms_getFailureCodes131:
;BMS.c,446 :: 		else if (BIT_READ(bms->frameBuff[0][5], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes133
;BMS.c,447 :: 		strcat(bms->failCodeArr, "Dischg temp low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr21_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes133:
L_DalyBms_getFailureCodes132:
;BMS.c,449 :: 		if (BIT_READ(bms->frameBuff[0][6], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes134
;BMS.c,450 :: 		strcat(bms->failCodeArr, "Chg overcurrent level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr22_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes135
L_DalyBms_getFailureCodes134:
;BMS.c,451 :: 		else if (BIT_READ(bms->frameBuff[0][6], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes136
;BMS.c,452 :: 		strcat(bms->failCodeArr, "Chg overcurrent level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr23_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes136:
L_DalyBms_getFailureCodes135:
;BMS.c,453 :: 		if (BIT_READ(bms->frameBuff[0][6], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes137
;BMS.c,454 :: 		strcat(bms->failCodeArr, "Dischg overcurrent level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr24_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes138
L_DalyBms_getFailureCodes137:
;BMS.c,455 :: 		else if (BIT_READ(bms->frameBuff[0][6], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes139
;BMS.c,456 :: 		strcat(bms->failCodeArr, "Dischg overcurrent level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr25_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes139:
L_DalyBms_getFailureCodes138:
;BMS.c,457 :: 		if (BIT_READ(bms->frameBuff[0][6], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes140
;BMS.c,458 :: 		strcat(bms->failCodeArr, "SOC high level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr26_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes141
L_DalyBms_getFailureCodes140:
;BMS.c,459 :: 		else if (BIT_READ(bms->frameBuff[0][6], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes142
;BMS.c,460 :: 		strcat(bms->failCodeArr, "SOC high level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr27_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes142:
L_DalyBms_getFailureCodes141:
;BMS.c,461 :: 		if (BIT_READ(bms->frameBuff[0][6], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes143
;BMS.c,462 :: 		strcat(bms->failCodeArr, "SOC Low level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr28_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes144
L_DalyBms_getFailureCodes143:
;BMS.c,463 :: 		else if (BIT_READ(bms->frameBuff[0][6], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes145
;BMS.c,464 :: 		strcat(bms->failCodeArr, "SOC Low level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr29_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes145:
L_DalyBms_getFailureCodes144:
;BMS.c,466 :: 		if (BIT_READ(bms->frameBuff[0][7], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes146
;BMS.c,467 :: 		strcat(bms->failCodeArr, "Diff volt level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr30_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes147
L_DalyBms_getFailureCodes146:
;BMS.c,468 :: 		else if (BIT_READ(bms->frameBuff[0][7], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes148
;BMS.c,469 :: 		strcat(bms->failCodeArr, "Diff volt level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr31_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes148:
L_DalyBms_getFailureCodes147:
;BMS.c,470 :: 		if (BIT_READ(bms->frameBuff[0][7], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes149
;BMS.c,471 :: 		strcat(bms->failCodeArr, "Diff temp level 2,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr32_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
	GOTO	L_DalyBms_getFailureCodes150
L_DalyBms_getFailureCodes149:
;BMS.c,472 :: 		else if (BIT_READ(bms->frameBuff[0][7], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes151
;BMS.c,473 :: 		strcat(bms->failCodeArr, "Diff temp level 1,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr33_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes151:
L_DalyBms_getFailureCodes150:
;BMS.c,475 :: 		if (BIT_READ(bms->frameBuff[0][8], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes152
;BMS.c,476 :: 		strcat(bms->failCodeArr, "Chg MOS temp high alarm,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr34_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes152:
;BMS.c,477 :: 		if (BIT_READ(bms->frameBuff[0][8], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes153
;BMS.c,478 :: 		strcat(bms->failCodeArr, "Dischg MOS temp high alarm,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr35_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes153:
;BMS.c,479 :: 		if (BIT_READ(bms->frameBuff[0][8], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes154
;BMS.c,480 :: 		strcat(bms->failCodeArr, "Chg MOS temp sensor err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr36_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes154:
;BMS.c,481 :: 		if (BIT_READ(bms->frameBuff[0][8], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes155
;BMS.c,482 :: 		strcat(bms->failCodeArr, "Dischg MOS temp sensor err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr37_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes155:
;BMS.c,483 :: 		if (BIT_READ(bms->frameBuff[0][8], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes156
;BMS.c,484 :: 		strcat(bms->failCodeArr, "Chg MOS adhesion err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr38_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes156:
;BMS.c,485 :: 		if (BIT_READ(bms->frameBuff[0][8], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes157
;BMS.c,486 :: 		strcat(bms->failCodeArr, "Dischg MOS adhesion err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr39_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes157:
;BMS.c,487 :: 		if (BIT_READ(bms->frameBuff[0][8], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes158
;BMS.c,488 :: 		strcat(bms->failCodeArr, "Chg MOS open circuit err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr40_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes158:
;BMS.c,489 :: 		if (BIT_READ(bms->frameBuff[0][8], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes159
;BMS.c,490 :: 		strcat(bms->failCodeArr, " Discrg MOS open circuit err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr41_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes159:
;BMS.c,492 :: 		if (BIT_READ(bms->frameBuff[0][9], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes160
;BMS.c,493 :: 		strcat(bms->failCodeArr, "AFE collect chip err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr42_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes160:
;BMS.c,494 :: 		if (BIT_READ(bms->frameBuff[0][9], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes161
;BMS.c,495 :: 		strcat(bms->failCodeArr, "Voltage collect dropped,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr43_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes161:
;BMS.c,496 :: 		if (BIT_READ(bms->frameBuff[0][9], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes162
;BMS.c,497 :: 		strcat(bms->failCodeArr, "Cell temp sensor err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr44_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes162:
;BMS.c,498 :: 		if (BIT_READ(bms->frameBuff[0][9], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes163
;BMS.c,499 :: 		strcat(bms->failCodeArr, "EEPROM err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr45_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes163:
;BMS.c,500 :: 		if (BIT_READ(bms->frameBuff[0][9], 4))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #4, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes164
;BMS.c,501 :: 		strcat(bms->failCodeArr, "RTC err,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr46_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes164:
;BMS.c,502 :: 		if (BIT_READ(bms->frameBuff[0][9], 5))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #5, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes165
;BMS.c,503 :: 		strcat(bms->failCodeArr, "Precharge failure,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr47_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes165:
;BMS.c,504 :: 		if (BIT_READ(bms->frameBuff[0][9], 6))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #6, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes166
;BMS.c,505 :: 		strcat(bms->failCodeArr, "Communication failure,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr48_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes166:
;BMS.c,506 :: 		if (BIT_READ(bms->frameBuff[0][9], 7))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #7, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes167
;BMS.c,507 :: 		strcat(bms->failCodeArr, "Internal communication failure,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr49_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes167:
;BMS.c,509 :: 		if (BIT_READ(bms->frameBuff[0][10], 0))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes168
;BMS.c,510 :: 		strcat(bms->failCodeArr, "Current module fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr50_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes168:
;BMS.c,511 :: 		if (BIT_READ(bms->frameBuff[0][10], 1))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #1, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes169
;BMS.c,512 :: 		strcat(bms->failCodeArr, "Sum voltage detect fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr51_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes169:
;BMS.c,513 :: 		if (BIT_READ(bms->frameBuff[0][10], 2))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #2, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes170
;BMS.c,514 :: 		strcat(bms->failCodeArr, "Short circuit protect fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr52_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes170:
;BMS.c,515 :: 		if (BIT_READ(bms->frameBuff[0][10], 3))
	MOV	#602, W0
	ADD	W10, W0, W0
	ADD	W0, #10, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	LSR	W0, #3, W0
	BTSS	W0, #0
	GOTO	L_DalyBms_getFailureCodes171
;BMS.c,516 :: 		strcat(bms->failCodeArr, "Low volt forbidden chg fault,");
	ADD	W10, #10, W0
	PUSH	W10
	MOV	#lo_addr(?lstr53_BMS), W11
	MOV	W0, W10
	CALL	_strcat
	POP	W10
L_DalyBms_getFailureCodes171:
;BMS.c,518 :: 		len = strlen(bms->failCodeArr);
	ADD	W10, #10, W0
	PUSH	W10
	MOV	W0, W10
	CALL	_strlen
	POP	W10
; len start address is: 4 (W2)
	MOV	W0, W2
;BMS.c,519 :: 		if (len > 0 && bms->failCodeArr[len - 1] == ',')
	CP	W0, #0
	BRA GTU	L__DalyBms_getFailureCodes325
	GOTO	L__DalyBms_getFailureCodes238
L__DalyBms_getFailureCodes325:
	ADD	W10, #10, W1
	SUB	W2, #1, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA Z	L__DalyBms_getFailureCodes326
	GOTO	L__DalyBms_getFailureCodes237
L__DalyBms_getFailureCodes326:
L__DalyBms_getFailureCodes236:
;BMS.c,521 :: 		bms->failCodeArr[len - 1] = '\0';
	ADD	W10, #10, W1
	SUB	W2, #1, W0
; len end address is: 4 (W2)
	ADD	W1, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,519 :: 		if (len > 0 && bms->failCodeArr[len - 1] == ',')
L__DalyBms_getFailureCodes238:
L__DalyBms_getFailureCodes237:
;BMS.c,523 :: 		return true;
	MOV.B	#1, W0
;BMS.c,524 :: 		}
;BMS.c,523 :: 		return true;
;BMS.c,524 :: 		}
L_end_DalyBms_getFailureCodes:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_getFailureCodes

_DalyBms_setDischargeMOS:

;BMS.c,526 :: 		bool DalyBms_setDischargeMOS(DalyBms* bms, bool sw) // 0xD9 0x80 First Byte 0x01=ON 0x00=OFF
;BMS.c,528 :: 		bms->requestCounter = 0;
	PUSH	W11
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,529 :: 		if (sw)
	CP0.B	W11
	BRA NZ	L__DalyBms_setDischargeMOS328
	GOTO	L_DalyBms_setDischargeMOS175
L__DalyBms_setDischargeMOS328:
;BMS.c,532 :: 		bms->my_txBuffer[4] = 0x01;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,533 :: 		}
	GOTO	L_DalyBms_setDischargeMOS176
L_DalyBms_setDischargeMOS175:
;BMS.c,536 :: 		bms->my_txBuffer[4] = 0x00; // Explicitly set to 0 for OFF
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,537 :: 		}
L_DalyBms_setDischargeMOS176:
;BMS.c,539 :: 		DalyBms_sendCommand(bms, DISCHRG_FET);
	MOV.B	#217, W11
	CALL	BMS_DalyBms_sendCommand
;BMS.c,541 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setDischargeMOS329
	GOTO	L_DalyBms_setDischargeMOS177
L__DalyBms_setDischargeMOS329:
;BMS.c,543 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setDischargeMOS
;BMS.c,544 :: 		}
L_DalyBms_setDischargeMOS177:
;BMS.c,546 :: 		return true;
	MOV.B	#1, W0
;BMS.c,547 :: 		}
;BMS.c,546 :: 		return true;
;BMS.c,547 :: 		}
L_end_DalyBms_setDischargeMOS:
	POP	W11
	RETURN
; end of _DalyBms_setDischargeMOS

_DalyBms_setChargeMOS:

;BMS.c,549 :: 		bool DalyBms_setChargeMOS(DalyBms* bms, bool sw) // 0xDA 0x80 First Byte 0x01=ON 0x00=OFF
;BMS.c,551 :: 		bms->requestCounter = 0;
	PUSH	W11
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,552 :: 		if (sw)
	CP0.B	W11
	BRA NZ	L__DalyBms_setChargeMOS331
	GOTO	L_DalyBms_setChargeMOS178
L__DalyBms_setChargeMOS331:
;BMS.c,555 :: 		bms->my_txBuffer[4] = 0x01;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,556 :: 		}
	GOTO	L_DalyBms_setChargeMOS179
L_DalyBms_setChargeMOS178:
;BMS.c,559 :: 		bms->my_txBuffer[4] = 0x00; // Explicitly set to 0 for OFF
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,560 :: 		}
L_DalyBms_setChargeMOS179:
;BMS.c,561 :: 		DalyBms_sendCommand(bms, CHRG_FET);
	MOV.B	#218, W11
	CALL	BMS_DalyBms_sendCommand
;BMS.c,563 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setChargeMOS332
	GOTO	L_DalyBms_setChargeMOS180
L__DalyBms_setChargeMOS332:
;BMS.c,565 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setChargeMOS
;BMS.c,566 :: 		}
L_DalyBms_setChargeMOS180:
;BMS.c,568 :: 		return true;
	MOV.B	#1, W0
;BMS.c,569 :: 		}
;BMS.c,568 :: 		return true;
;BMS.c,569 :: 		}
L_end_DalyBms_setChargeMOS:
	POP	W11
	RETURN
; end of _DalyBms_setChargeMOS

_DalyBms_setBmsReset:

;BMS.c,571 :: 		bool DalyBms_setBmsReset(DalyBms* bms) // 0x00 Reset the BMS
;BMS.c,573 :: 		bms->requestCounter = 0;
	PUSH	W11
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,574 :: 		DalyBms_sendCommand(bms, BMS_RESET);
	CLR	W11
	CALL	BMS_DalyBms_sendCommand
;BMS.c,575 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setBmsReset334
	GOTO	L_DalyBms_setBmsReset181
L__DalyBms_setBmsReset334:
;BMS.c,577 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setBmsReset
;BMS.c,578 :: 		}
L_DalyBms_setBmsReset181:
;BMS.c,579 :: 		return true;
	MOV.B	#1, W0
;BMS.c,580 :: 		}
;BMS.c,579 :: 		return true;
;BMS.c,580 :: 		}
L_end_DalyBms_setBmsReset:
	POP	W11
	RETURN
; end of _DalyBms_setBmsReset

_DalyBms_setSOC:

;BMS.c,582 :: 		bool DalyBms_setSOC(DalyBms* bms, float val) // 0x21 last two byte is SOC
;BMS.c,587 :: 		if (val >= 0.0f && val <= 100.0f)
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
	BRA LT	L__DalyBms_setSOC336
	INC.B	W0
L__DalyBms_setSOC336:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L__DalyBms_setSOC337
	GOTO	L__DalyBms_setSOC241
L__DalyBms_setSOC337:
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
	BRA GT	L__DalyBms_setSOC338
	INC.B	W0
L__DalyBms_setSOC338:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L__DalyBms_setSOC339
	GOTO	L__DalyBms_setSOC240
L__DalyBms_setSOC339:
L__DalyBms_setSOC239:
;BMS.c,589 :: 		bms->requestCounter = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,592 :: 		DalyBms_sendCommand(bms, READ_SOC);
	PUSH	W11
	PUSH	W12
	MOV.B	#97, W11
	CALL	BMS_DalyBms_sendCommand
;BMS.c,593 :: 		if (!DalyBms_receiveBytes(bms))
	PUSH	W10
	CALL	BMS_DalyBms_receiveBytes
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA Z	L__DalyBms_setSOC340
	GOTO	L_DalyBms_setSOC185
L__DalyBms_setSOC340:
;BMS.c,595 :: 		bms->my_txBuffer[5] = 0x17; // year (current year - 2000)
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #5, W1
	MOV.B	#23, W0
	MOV.B	W0, [W1]
;BMS.c,596 :: 		bms->my_txBuffer[6] = 0x01; // month
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #6, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,597 :: 		bms->my_txBuffer[7] = 0x01; // day
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #7, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,598 :: 		bms->my_txBuffer[8] = 0x01; // hour
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #8, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,599 :: 		bms->my_txBuffer[9] = 0x01; // minute
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #9, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;BMS.c,600 :: 		}
	GOTO	L_DalyBms_setSOC186
L_DalyBms_setSOC185:
;BMS.c,603 :: 		for (i = 5; i <= 9; i++)
; i start address is: 4 (W2)
	MOV	#5, W2
; i end address is: 4 (W2)
L_DalyBms_setSOC187:
; i start address is: 4 (W2)
	CP	W2, #9
	BRA LEU	L__DalyBms_setSOC341
	GOTO	L_DalyBms_setSOC188
L__DalyBms_setSOC341:
;BMS.c,605 :: 		bms->my_txBuffer[i] = bms->my_rxBuffer[i];
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, W2, W1
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, W2, W0
	MOV.B	[W0], [W1]
;BMS.c,603 :: 		for (i = 5; i <= 9; i++)
	INC	W2
;BMS.c,606 :: 		}
; i end address is: 4 (W2)
	GOTO	L_DalyBms_setSOC187
L_DalyBms_setSOC188:
;BMS.c,607 :: 		}
L_DalyBms_setSOC186:
;BMS.c,608 :: 		value = (uint16_t)(val * 10.0f);
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
;BMS.c,609 :: 		bms->my_txBuffer[10] = (value >> 8) & 0xFF;
	MOV	#420, W1
	ADD	W10, W1, W1
	ADD	W1, #10, W2
	LSR	W0, #8, W1
	MOV	#255, W0
	AND	W1, W0, W0
	MOV.B	W0, [W2]
;BMS.c,610 :: 		bms->my_txBuffer[11] = value & 0xFF;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #11, W1
	MOV	#255, W0
	AND	W3, W0, W0
; value end address is: 6 (W3)
	MOV.B	W0, [W1]
;BMS.c,611 :: 		DalyBms_sendCommand(bms, SET_SOC);
	MOV.B	#33, W11
	CALL	BMS_DalyBms_sendCommand
;BMS.c,613 :: 		if (!DalyBms_receiveBytes(bms))
	CALL	BMS_DalyBms_receiveBytes
	CP0.B	W0
	BRA Z	L__DalyBms_setSOC342
	GOTO	L_DalyBms_setSOC190
L__DalyBms_setSOC342:
;BMS.c,615 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_setSOC
;BMS.c,616 :: 		}
L_DalyBms_setSOC190:
;BMS.c,619 :: 		return true;
	MOV.B	#1, W0
	GOTO	L_end_DalyBms_setSOC
;BMS.c,587 :: 		if (val >= 0.0f && val <= 100.0f)
L__DalyBms_setSOC241:
L__DalyBms_setSOC240:
;BMS.c,622 :: 		return false;
	CLR	W0
;BMS.c,623 :: 		}
;BMS.c,622 :: 		return false;
;BMS.c,623 :: 		}
L_end_DalyBms_setSOC:
	POP	W12
	POP	W11
	RETURN
; end of _DalyBms_setSOC

_DalyBms_getState:

;BMS.c,625 :: 		bool DalyBms_getState(DalyBms* bms) // Function to return the state of connection
;BMS.c,627 :: 		return bms->get.connectionState;
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#359, W0
	ADD	W1, W0, W0
	MOV.B	[W0], W0
;BMS.c,628 :: 		}
L_end_DalyBms_getState:
	RETURN
; end of _DalyBms_getState

_DalyBms_set_callback:

;BMS.c,630 :: 		void DalyBms_set_callback(DalyBms* bms, void (*func)(void)) // callback function when finish request
;BMS.c,632 :: 		bms->requestCallback = func;
	MOV	#760, W0
	ADD	W10, W0, W0
	MOV	W11, [W0]
;BMS.c,633 :: 		}
L_end_DalyBms_set_callback:
	RETURN
; end of _DalyBms_set_callback

BMS_DalyBms_requestData:

;BMS.c,640 :: 		static bool DalyBms_requestData(DalyBms* bms, DALY_BMS_COMMAND cmdID, unsigned int frameAmount)
;BMS.c,650 :: 		memset(bms->my_rxFrameBuffer, 0x00, sizeof(bms->my_rxFrameBuffer));
	MOV	#446, W0
	ADD	W10, W0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
;BMS.c,651 :: 		memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff));
	MOV	#602, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
;BMS.c,652 :: 		memset(bms->my_txBuffer, 0x00, XFER_BUFFER_LENGTH);
	MOV	#420, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
	POP	W12
;BMS.c,655 :: 		txChecksum = 0x00;    // transmit checksum buffer
; txChecksum start address is: 4 (W2)
	CLR	W2
;BMS.c,656 :: 		byteCounter = 0; // bytecounter for incoming data
; byteCounter start address is: 8 (W4)
	CLR	W4
;BMS.c,659 :: 		bms->my_txBuffer[0] = START_BYTE;
	MOV	#420, W0
	ADD	W10, W0, W1
	MOV.B	#165, W0
	MOV.B	W0, [W1]
;BMS.c,660 :: 		bms->my_txBuffer[1] = HOST_ADRESS;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,661 :: 		bms->my_txBuffer[2] = cmdID;
	MOV	#420, W0
	ADD	W10, W0, W0
	INC2	W0
	MOV.B	W11, [W0]
;BMS.c,662 :: 		bms->my_txBuffer[3] = FRAME_LENGTH;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,665 :: 		for (i = 0; i <= 11; i++)
; i start address is: 2 (W1)
	CLR	W1
; txChecksum end address is: 4 (W2)
; i end address is: 2 (W1)
; byteCounter end address is: 8 (W4)
L_BMS_DalyBms_requestData192:
; i start address is: 2 (W1)
; byteCounter start address is: 8 (W4)
; txChecksum start address is: 4 (W2)
	CP	W1, #11
	BRA LEU	L_BMS_DalyBms_requestData346
	GOTO	L_BMS_DalyBms_requestData193
L_BMS_DalyBms_requestData346:
;BMS.c,667 :: 		txChecksum += bms->my_txBuffer[i];
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, W1, W0
; txChecksum start address is: 0 (W0)
	ADD.B	W2, [W0], W0
; txChecksum end address is: 4 (W2)
;BMS.c,665 :: 		for (i = 0; i <= 11; i++)
	INC	W1
;BMS.c,668 :: 		}
	MOV.B	W0, W2
; txChecksum end address is: 0 (W0)
; i end address is: 2 (W1)
	GOTO	L_BMS_DalyBms_requestData192
L_BMS_DalyBms_requestData193:
;BMS.c,670 :: 		bms->my_txBuffer[12] = txChecksum;
; txChecksum start address is: 4 (W2)
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #12, W0
	MOV.B	W2, [W0]
; txChecksum end address is: 4 (W2)
;BMS.c,673 :: 		serial_write(bms->serial_handle, bms->my_txBuffer, XFER_BUFFER_LENGTH);
	MOV	#420, W0
	ADD	W10, W0, W1
	MOV	#418, W0
	ADD	W10, W0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	#13, W12
	MOV	W1, W11
	MOV	[W0], W10
	CALL	_serial_write
	POP.D	W10
	POP	W12
;BMS.c,675 :: 		serial_flush(bms->serial_handle);
	MOV	#418, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	[W0], W10
	CALL	_serial_flush
	POP	W10
;BMS.c,679 :: 		/*uint8_t rxByteNum = */ serial_read_bytes(bms->serial_handle, bms->my_rxFrameBuffer, XFER_BUFFER_LENGTH * frameAmount);
	MOV	#13, W0
	MUL.UU	W0, W12, W2
	MOV	#446, W0
	ADD	W10, W0, W1
	MOV	#418, W0
	ADD	W10, W0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W2, W12
	MOV	W1, W11
	MOV	[W0], W10
	CALL	_serial_read_bytes
	POP.D	W10
	POP	W12
;BMS.c,680 :: 		for (i = 0; i < frameAmount; i++)
; i start address is: 6 (W3)
	CLR	W3
; i end address is: 6 (W3)
; byteCounter end address is: 8 (W4)
L_BMS_DalyBms_requestData195:
; i start address is: 6 (W3)
; byteCounter start address is: 8 (W4)
	CP	W3, W12
	BRA LTU	L_BMS_DalyBms_requestData347
	GOTO	L_BMS_DalyBms_requestData196
L_BMS_DalyBms_requestData347:
;BMS.c,682 :: 		for (j = 0; j < XFER_BUFFER_LENGTH; j++)
; j start address is: 10 (W5)
	CLR	W5
; i end address is: 6 (W3)
; byteCounter end address is: 8 (W4)
; j end address is: 10 (W5)
L_BMS_DalyBms_requestData198:
; j start address is: 10 (W5)
; byteCounter start address is: 8 (W4)
; i start address is: 6 (W3)
	CP	W5, #13
	BRA LTU	L_BMS_DalyBms_requestData348
	GOTO	L_BMS_DalyBms_requestData199
L_BMS_DalyBms_requestData348:
;BMS.c,684 :: 		bms->frameBuff[i][j] = bms->my_rxFrameBuffer[byteCounter];
	MOV	#602, W0
	ADD	W10, W0, W2
	MOV	#13, W0
	MUL.UU	W0, W3, W0
	ADD	W2, W0, W0
	ADD	W0, W5, W1
	MOV	#446, W0
	ADD	W10, W0, W0
	ADD	W0, W4, W0
	MOV.B	[W0], [W1]
;BMS.c,685 :: 		byteCounter++;
	INC	W4
;BMS.c,682 :: 		for (j = 0; j < XFER_BUFFER_LENGTH; j++)
	INC	W5
;BMS.c,686 :: 		}
; j end address is: 10 (W5)
	GOTO	L_BMS_DalyBms_requestData198
L_BMS_DalyBms_requestData199:
;BMS.c,688 :: 		rxChecksum = 0x00;
; rxChecksum start address is: 12 (W6)
	CLR	W6
;BMS.c,689 :: 		for (k = 0; k < XFER_BUFFER_LENGTH - 1; k++)
; k start address is: 10 (W5)
	CLR	W5
; i end address is: 6 (W3)
; byteCounter end address is: 8 (W4)
; rxChecksum end address is: 12 (W6)
; k end address is: 10 (W5)
	PUSH	W3
	MOV	W4, W3
	POP	W4
L_BMS_DalyBms_requestData201:
; k start address is: 10 (W5)
; rxChecksum start address is: 12 (W6)
; i start address is: 8 (W4)
; byteCounter start address is: 6 (W3)
	CP	W5, #12
	BRA LT	L_BMS_DalyBms_requestData349
	GOTO	L_BMS_DalyBms_requestData202
L_BMS_DalyBms_requestData349:
;BMS.c,691 :: 		rxChecksum += bms->frameBuff[i][k];
	MOV	#602, W0
	ADD	W10, W0, W2
	MOV	#13, W0
	MUL.UU	W0, W4, W0
	ADD	W2, W0, W0
	ADD	W0, W5, W0
; rxChecksum start address is: 0 (W0)
	ADD.B	W6, [W0], W0
; rxChecksum end address is: 12 (W6)
;BMS.c,689 :: 		for (k = 0; k < XFER_BUFFER_LENGTH - 1; k++)
	INC	W5
;BMS.c,692 :: 		}
; rxChecksum end address is: 0 (W0)
; k end address is: 10 (W5)
	MOV.B	W0, W6
	GOTO	L_BMS_DalyBms_requestData201
L_BMS_DalyBms_requestData202:
;BMS.c,696 :: 		if (rxChecksum != bms->frameBuff[i][XFER_BUFFER_LENGTH - 1])
; rxChecksum start address is: 12 (W6)
	MOV	#602, W0
	ADD	W10, W0, W2
	MOV	#13, W0
	MUL.UU	W0, W4, W0
	ADD	W2, W0, W0
	ADD	W0, #12, W0
	CP.B	W6, [W0]
	BRA NZ	L_BMS_DalyBms_requestData350
	GOTO	L_BMS_DalyBms_requestData204
L_BMS_DalyBms_requestData350:
; rxChecksum end address is: 12 (W6)
; i end address is: 8 (W4)
; byteCounter end address is: 6 (W3)
;BMS.c,698 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_requestData
;BMS.c,699 :: 		}
L_BMS_DalyBms_requestData204:
;BMS.c,700 :: 		if (rxChecksum == 0) // This condition might indicate no data or all zeros, needs careful consideration for actual no-data scenario
; byteCounter start address is: 6 (W3)
; i start address is: 8 (W4)
; rxChecksum start address is: 12 (W6)
	CP.B	W6, #0
	BRA Z	L_BMS_DalyBms_requestData351
	GOTO	L_BMS_DalyBms_requestData205
L_BMS_DalyBms_requestData351:
; rxChecksum end address is: 12 (W6)
; i end address is: 8 (W4)
; byteCounter end address is: 6 (W3)
;BMS.c,702 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_requestData
;BMS.c,703 :: 		}
L_BMS_DalyBms_requestData205:
;BMS.c,704 :: 		if (bms->frameBuff[i][1] >= 0x20) // This check seems specific to a Daly BMS sleep state
; byteCounter start address is: 6 (W3)
; i start address is: 8 (W4)
	MOV	#602, W0
	ADD	W10, W0, W2
	MOV	#13, W0
	MUL.UU	W0, W4, W0
	ADD	W2, W0, W0
	INC	W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA GEU	L_BMS_DalyBms_requestData352
	GOTO	L_BMS_DalyBms_requestData206
L_BMS_DalyBms_requestData352:
; i end address is: 8 (W4)
; byteCounter end address is: 6 (W3)
;BMS.c,706 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_requestData
;BMS.c,707 :: 		}
L_BMS_DalyBms_requestData206:
;BMS.c,680 :: 		for (i = 0; i < frameAmount; i++)
; i start address is: 0 (W0)
; byteCounter start address is: 6 (W3)
; i start address is: 8 (W4)
	ADD	W4, #1, W0
; i end address is: 8 (W4)
;BMS.c,708 :: 		}
	MOV	W3, W4
; byteCounter end address is: 6 (W3)
; i end address is: 0 (W0)
	MOV	W0, W3
	GOTO	L_BMS_DalyBms_requestData195
L_BMS_DalyBms_requestData196:
;BMS.c,709 :: 		return true;
	MOV.B	#1, W0
;BMS.c,710 :: 		}
L_end_DalyBms_requestData:
	RETURN
; end of BMS_DalyBms_requestData

BMS_DalyBms_sendQueueAdd:

;BMS.c,712 :: 		static bool DalyBms_sendQueueAdd(DalyBms* bms, DALY_BMS_COMMAND cmdID)
;BMS.c,716 :: 		for (i = 0; i < sizeof(bms->commandQueue) / sizeof(bms->commandQueue[0]); i++)
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_BMS_DalyBms_sendQueueAdd207:
; i start address is: 4 (W2)
	CP	W2, #5
	BRA LTU	L_BMS_DalyBms_sendQueueAdd354
	GOTO	L_BMS_DalyBms_sendQueueAdd208
L_BMS_DalyBms_sendQueueAdd354:
;BMS.c,718 :: 		if (bms->commandQueue[i] == 0x100)
	MOV	#408, W0
	ADD	W10, W0, W1
	SL	W2, #1, W0
	ADD	W1, W0, W0
	MOV	[W0], W1
	MOV	#256, W0
	CP	W1, W0
	BRA Z	L_BMS_DalyBms_sendQueueAdd355
	GOTO	L_BMS_DalyBms_sendQueueAdd210
L_BMS_DalyBms_sendQueueAdd355:
;BMS.c,720 :: 		bms->commandQueue[i] = cmdID;
	MOV	#408, W0
	ADD	W10, W0, W1
	SL	W2, #1, W0
; i end address is: 4 (W2)
	ADD	W1, W0, W1
	ZE	W11, W0
	MOV	W0, [W1]
;BMS.c,721 :: 		break;
	GOTO	L_BMS_DalyBms_sendQueueAdd208
;BMS.c,722 :: 		}
L_BMS_DalyBms_sendQueueAdd210:
;BMS.c,716 :: 		for (i = 0; i < sizeof(bms->commandQueue) / sizeof(bms->commandQueue[0]); i++)
; i start address is: 4 (W2)
	INC	W2
;BMS.c,723 :: 		}
; i end address is: 4 (W2)
	GOTO	L_BMS_DalyBms_sendQueueAdd207
L_BMS_DalyBms_sendQueueAdd208:
;BMS.c,724 :: 		return true;
	MOV.B	#1, W0
;BMS.c,725 :: 		}
L_end_DalyBms_sendQueueAdd:
	RETURN
; end of BMS_DalyBms_sendQueueAdd

BMS_DalyBms_sendCommand:

;BMS.c,727 :: 		static bool DalyBms_sendCommand(DalyBms* bms, DALY_BMS_COMMAND cmdID)
;BMS.c,732 :: 		checksum = 0;
	PUSH	W12
; checksum start address is: 6 (W3)
	CLR	W3
; checksum end address is: 6 (W3)
;BMS.c,734 :: 		while (serial_read_byte(bms->serial_handle) > 0);
L_BMS_DalyBms_sendCommand211:
; checksum start address is: 6 (W3)
	MOV	#418, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	[W0], W10
	CALL	_serial_read_byte
	POP	W10
	CP	W0, #0
	BRA GT	L_BMS_DalyBms_sendCommand357
	GOTO	L_BMS_DalyBms_sendCommand212
L_BMS_DalyBms_sendCommand357:
	GOTO	L_BMS_DalyBms_sendCommand211
L_BMS_DalyBms_sendCommand212:
;BMS.c,737 :: 		bms->my_txBuffer[0] = START_BYTE;
	MOV	#420, W0
	ADD	W10, W0, W1
	MOV.B	#165, W0
	MOV.B	W0, [W1]
;BMS.c,738 :: 		bms->my_txBuffer[1] = HOST_ADRESS;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #1, W1
	MOV.B	#64, W0
	MOV.B	W0, [W1]
;BMS.c,739 :: 		bms->my_txBuffer[2] = cmdID;
	MOV	#420, W0
	ADD	W10, W0, W0
	INC2	W0
	MOV.B	W11, [W0]
;BMS.c,740 :: 		bms->my_txBuffer[3] = FRAME_LENGTH;
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #3, W1
	MOV.B	#8, W0
	MOV.B	W0, [W1]
;BMS.c,743 :: 		for (i = 0; i <= 11; i++)
; i start address is: 4 (W2)
	CLR	W2
; checksum end address is: 6 (W3)
; i end address is: 4 (W2)
L_BMS_DalyBms_sendCommand213:
; i start address is: 4 (W2)
; checksum start address is: 6 (W3)
	CP.B	W2, #11
	BRA LEU	L_BMS_DalyBms_sendCommand358
	GOTO	L_BMS_DalyBms_sendCommand214
L_BMS_DalyBms_sendCommand358:
;BMS.c,745 :: 		checksum += bms->my_txBuffer[i];
	MOV	#420, W0
	ADD	W10, W0, W1
	ZE	W2, W0
	ADD	W1, W0, W0
; checksum start address is: 0 (W0)
	ADD.B	W3, [W0], W0
; checksum end address is: 6 (W3)
;BMS.c,743 :: 		for (i = 0; i <= 11; i++)
	INC.B	W2
;BMS.c,746 :: 		}
	MOV.B	W0, W3
; checksum end address is: 0 (W0)
; i end address is: 4 (W2)
	GOTO	L_BMS_DalyBms_sendCommand213
L_BMS_DalyBms_sendCommand214:
;BMS.c,748 :: 		bms->my_txBuffer[12] = checksum;
; checksum start address is: 6 (W3)
	MOV	#420, W0
	ADD	W10, W0, W0
	ADD	W0, #12, W0
	MOV.B	W3, [W0]
; checksum end address is: 6 (W3)
;BMS.c,750 :: 		serial_write(bms->serial_handle, bms->my_txBuffer, XFER_BUFFER_LENGTH);
	MOV	#420, W0
	ADD	W10, W0, W1
	MOV	#418, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	#13, W12
	MOV	W1, W11
	MOV	[W0], W10
	CALL	_serial_write
	POP.D	W10
;BMS.c,753 :: 		serial_flush(bms->serial_handle);
	MOV	#418, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	[W0], W10
	CALL	_serial_flush
	POP	W10
;BMS.c,756 :: 		memset(bms->my_txBuffer, 0x00, XFER_BUFFER_LENGTH);
	MOV	#420, W0
	ADD	W10, W0, W0
	PUSH.D	W10
	MOV	#13, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP.D	W10
;BMS.c,757 :: 		bms->requestCounter = 0; // reset the request queue that we get actual data
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;BMS.c,758 :: 		return true;
	MOV.B	#1, W0
;BMS.c,759 :: 		}
;BMS.c,758 :: 		return true;
;BMS.c,759 :: 		}
L_end_DalyBms_sendCommand:
	POP	W12
	RETURN
; end of BMS_DalyBms_sendCommand

BMS_DalyBms_receiveBytes:

;BMS.c,761 :: 		static bool DalyBms_receiveBytes(DalyBms* bms)
;BMS.c,766 :: 		memset(bms->my_rxBuffer, 0x00, XFER_BUFFER_LENGTH);
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
;BMS.c,767 :: 		memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff)); // This line seems redundant if my_rxBuffer is the primary target
	MOV	#602, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#156, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;BMS.c,770 :: 		rxByteNum = serial_read_bytes(bms->serial_handle, bms->my_rxBuffer, XFER_BUFFER_LENGTH);
	MOV	#433, W0
	ADD	W10, W0, W1
	MOV	#418, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#13, W12
	MOV	W1, W11
	MOV	[W0], W10
	CALL	_serial_read_bytes
	POP	W10
;BMS.c,773 :: 		if (rxByteNum != XFER_BUFFER_LENGTH)
	CP.B	W0, #13
	BRA NZ	L_BMS_DalyBms_receiveBytes360
	GOTO	L_BMS_DalyBms_receiveBytes216
L_BMS_DalyBms_receiveBytes360:
;BMS.c,775 :: 		DalyBms_barfRXBuffer(bms);
	CALL	BMS_DalyBms_barfRXBuffer
;BMS.c,776 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_receiveBytes
;BMS.c,777 :: 		}
L_BMS_DalyBms_receiveBytes216:
;BMS.c,779 :: 		if (!DalyBms_validateChecksum(bms))
	CALL	BMS_DalyBms_validateChecksum
	CP0.B	W0
	BRA Z	L_BMS_DalyBms_receiveBytes361
	GOTO	L_BMS_DalyBms_receiveBytes217
L_BMS_DalyBms_receiveBytes361:
;BMS.c,781 :: 		DalyBms_barfRXBuffer(bms);
	CALL	BMS_DalyBms_barfRXBuffer
;BMS.c,782 :: 		return false;
	CLR	W0
	GOTO	L_end_DalyBms_receiveBytes
;BMS.c,783 :: 		}
L_BMS_DalyBms_receiveBytes217:
;BMS.c,785 :: 		return true;
	MOV.B	#1, W0
;BMS.c,786 :: 		}
;BMS.c,785 :: 		return true;
;BMS.c,786 :: 		}
L_end_DalyBms_receiveBytes:
	POP	W12
	POP	W11
	RETURN
; end of BMS_DalyBms_receiveBytes

BMS_DalyBms_validateChecksum:

;BMS.c,788 :: 		static bool DalyBms_validateChecksum(DalyBms* bms)
;BMS.c,793 :: 		checksum = 0x00;
; checksum start address is: 4 (W2)
	CLR	W2
;BMS.c,795 :: 		for (i = 0; i < XFER_BUFFER_LENGTH - 1; i++)
; i start address is: 2 (W1)
	CLR	W1
; checksum end address is: 4 (W2)
; i end address is: 2 (W1)
L_BMS_DalyBms_validateChecksum218:
; i start address is: 2 (W1)
; checksum start address is: 4 (W2)
	CP	W1, #12
	BRA LT	L_BMS_DalyBms_validateChecksum363
	GOTO	L_BMS_DalyBms_validateChecksum219
L_BMS_DalyBms_validateChecksum363:
;BMS.c,797 :: 		checksum += bms->my_rxBuffer[i];
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, W1, W0
; checksum start address is: 0 (W0)
	ADD.B	W2, [W0], W0
; checksum end address is: 4 (W2)
;BMS.c,795 :: 		for (i = 0; i < XFER_BUFFER_LENGTH - 1; i++)
	INC	W1
;BMS.c,798 :: 		}
	MOV.B	W0, W2
; checksum end address is: 0 (W0)
; i end address is: 2 (W1)
	GOTO	L_BMS_DalyBms_validateChecksum218
L_BMS_DalyBms_validateChecksum219:
;BMS.c,800 :: 		return (checksum == bms->my_rxBuffer[XFER_BUFFER_LENGTH - 1]);
; checksum start address is: 4 (W2)
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, #12, W0
	CP.B	W2, [W0]
	CLR.B	W0
	BRA NZ	L_BMS_DalyBms_validateChecksum364
	INC.B	W0
L_BMS_DalyBms_validateChecksum364:
; checksum end address is: 4 (W2)
;BMS.c,801 :: 		}
L_end_DalyBms_validateChecksum:
	RETURN
; end of BMS_DalyBms_validateChecksum

BMS_DalyBms_barfRXBuffer:

;BMS.c,803 :: 		static void DalyBms_barfRXBuffer(DalyBms* bms)
;BMS.c,808 :: 		for (i = 0; i < XFER_BUFFER_LENGTH; i++)
; i start address is: 2 (W1)
	CLR	W1
; i end address is: 2 (W1)
L_BMS_DalyBms_barfRXBuffer221:
; i start address is: 2 (W1)
	CP	W1, #13
	BRA LT	L_BMS_DalyBms_barfRXBuffer366
	GOTO	L_BMS_DalyBms_barfRXBuffer222
L_BMS_DalyBms_barfRXBuffer366:
;BMS.c,810 :: 		writeLog(",0x%02X", bms->my_rxBuffer[i]);
	MOV	#433, W0
	ADD	W10, W0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	PUSH	W1
	PUSH	W10
	PUSH	W0
	MOV	#lo_addr(?lstr_54_BMS), W0
	PUSH	W0
	CALL	_writeLog
	SUB	#4, W15
	POP	W10
	POP	W1
;BMS.c,808 :: 		for (i = 0; i < XFER_BUFFER_LENGTH; i++)
	INC	W1
;BMS.c,811 :: 		}
; i end address is: 2 (W1)
	GOTO	L_BMS_DalyBms_barfRXBuffer221
L_BMS_DalyBms_barfRXBuffer222:
;BMS.c,812 :: 		writeLog("]\n");
	MOV	#lo_addr(?lstr_55_BMS), W0
	PUSH	W10
	PUSH	W0
	CALL	_writeLog
	SUB	#2, W15
	POP	W10
;BMS.c,813 :: 		}
L_end_DalyBms_barfRXBuffer:
	RETURN
; end of BMS_DalyBms_barfRXBuffer

BMS_DalyBms_clearGet:

;BMS.c,815 :: 		static void DalyBms_clearGet(DalyBms* bms)
;BMS.c,817 :: 		bms->get.chargeDischargeStatus = "offline"; // charge/discharge status (0 stationary ,1 charge ,2 discharge)
	MOV	#42, W0
	ADD	W10, W0, W1
	MOV	#60, W0
	ADD	W1, W0, W1
	MOV	#lo_addr(?lstr_56_BMS), W0
	MOV	W0, [W1]
;BMS.c,820 :: 		}
L_end_DalyBms_clearGet:
	RETURN
; end of BMS_DalyBms_clearGet

_serial_begin:
	LNK	#0

;BMS.c,823 :: 		void serial_begin(void* handle, long baud, int config, int rx_pin, int tx_pin, bool inverse_logic) {
;BMS.c,825 :: 		}
L_end_serial_begin:
	ULNK
	RETURN
; end of _serial_begin

_serial_write:

;BMS.c,827 :: 		size_t serial_write(void* handle, const uint8_t *buffer, size_t size) {
;BMS.c,829 :: 		return size;
	MOV	W12, W0
;BMS.c,830 :: 		}
L_end_serial_write:
	RETURN
; end of _serial_write

_serial_flush:

;BMS.c,832 :: 		void serial_flush(void* handle) {
;BMS.c,834 :: 		}
L_end_serial_flush:
	RETURN
; end of _serial_flush

_serial_read_byte:

;BMS.c,836 :: 		int serial_read_byte(void* handle) {
;BMS.c,840 :: 		return -1; // No byte available
	MOV	#65535, W0
;BMS.c,841 :: 		}
L_end_serial_read_byte:
	RETURN
; end of _serial_read_byte

_serial_read_bytes:

;BMS.c,843 :: 		size_t serial_read_bytes(void* handle, uint8_t *buffer, size_t length) {
;BMS.c,849 :: 		return 0; // Return 0 to simulate no data received by default in mock
	CLR	W0
;BMS.c,850 :: 		}
L_end_serial_read_bytes:
	RETURN
; end of _serial_read_bytes

_current_millis:

;BMS.c,853 :: 		unsigned long current_millis() {
;BMS.c,857 :: 		return 0; // Always returns 0 for this mock. You need a real implementation.
	CLR	W0
	CLR	W1
;BMS.c,858 :: 		}
L_end_current_millis:
	RETURN
; end of _current_millis
