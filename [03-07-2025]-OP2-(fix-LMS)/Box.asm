
_Box_KeyTouchStatus:

;Box.c,27 :: 		uint8_t Box_KeyTouchStatus(Box_Object* box) {
;Box.c,28 :: 		if (box == NULL) return 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CP	W10, #0
	BRA Z	L__Box_KeyTouchStatus18
	GOTO	L_Box_KeyTouchStatus0
L__Box_KeyTouchStatus18:
	CLR	W0
	GOTO	L_end_Box_KeyTouchStatus
L_Box_KeyTouchStatus0:
;Box.c,32 :: 		if (Button(&PORTC, 4, 20, 0)) {
	CLR	W13
	MOV	#20, W12
	MOV	#4, W11
	MOV	#lo_addr(PORTC), W10
	CALL	_Button
	CP0	W0
	BRA NZ	L__Box_KeyTouchStatus19
	GOTO	L_Box_KeyTouchStatus1
L__Box_KeyTouchStatus19:
;Box.c,33 :: 		return 1;  // Nút được nhấn
	MOV.B	#1, W0
	GOTO	L_end_Box_KeyTouchStatus
;Box.c,34 :: 		} else {
L_Box_KeyTouchStatus1:
;Box.c,35 :: 		return 0;  // Nút không được nhấn
	CLR	W0
;Box.c,37 :: 		}
;Box.c,35 :: 		return 0;  // Nút không được nhấn
;Box.c,37 :: 		}
L_end_Box_KeyTouchStatus:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Box_KeyTouchStatus

_Box_LimitSwitchStatus:

;Box.c,44 :: 		void Box_LimitSwitchStatus(Box_Object* box) {
;Box.c,45 :: 		if (box == NULL) return ;
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CP	W10, #0
	BRA Z	L__Box_LimitSwitchStatus21
	GOTO	L_Box_LimitSwitchStatus3
L__Box_LimitSwitchStatus21:
	GOTO	L_end_Box_LimitSwitchStatus
L_Box_LimitSwitchStatus3:
;Box.c,49 :: 		if (Button(&PORTC, 4, 20, 1)) {
	PUSH	W10
	MOV	#1, W13
	MOV	#20, W12
	MOV	#4, W11
	MOV	#lo_addr(PORTC), W10
	CALL	_Button
	POP	W10
	CP0	W0
	BRA NZ	L__Box_LimitSwitchStatus22
	GOTO	L_Box_LimitSwitchStatus4
L__Box_LimitSwitchStatus22:
;Box.c,50 :: 		box->limit_switch_state = 1;  // Công tắc được kích hoạt
	ADD	W10, #4, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Box.c,51 :: 		} else {
	GOTO	L_Box_LimitSwitchStatus5
L_Box_LimitSwitchStatus4:
;Box.c,52 :: 		box->limit_switch_state = 0;  // Công tắc không kích hoạt
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;Box.c,53 :: 		}
L_Box_LimitSwitchStatus5:
;Box.c,54 :: 		}
L_end_Box_LimitSwitchStatus:
	POP	W13
	POP	W12
	POP	W11
	RETURN
; end of _Box_LimitSwitchStatus

_Box_Init:
	LNK	#2

;Box.c,56 :: 		void Box_Init(Box_Object* box, float threshold) {
;Box.c,60 :: 		box->distance_inbox = sensor_box.distance_cm;
	MOV	_sensor_box+22, W0
	MOV	_sensor_box+24, W1
	MOV.D	W0, [W10]
;Box.c,61 :: 		box->limit_switch_state = 0;
	ADD	W10, #4, W1
	CLR	W0
	MOV.B	W0, [W1]
;Box.c,62 :: 		box->box_status = INACTIVE;
	ADD	W10, #5, W1
	CLR	W0
	MOV.B	W0, [W1]
;Box.c,63 :: 		box->object_detected = 0;
	ADD	W10, #6, W1
	CLR	W0
	MOV.B	W0, [W1]
;Box.c,64 :: 		box->key_touch = Box_KeyTouchStatus(box);
	ADD	W10, #12, W0
	MOV	W0, [W14+0]
	PUSH	W11
	PUSH	W12
	CALL	_Box_KeyTouchStatus
	POP	W12
	POP	W11
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Box.c,65 :: 		box->detection_threshold = threshold;
	ADD	W10, #8, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;Box.c,66 :: 		}
L_end_Box_Init:
	ULNK
	RETURN
; end of _Box_Init

_Box_UpdateStatus:
	LNK	#2

;Box.c,76 :: 		void Box_UpdateStatus(Box_Object* box) {
;Box.c,79 :: 		box->distance_inbox = sensor_box.distance_cm;
	MOV	_sensor_box+22, W0
	MOV	_sensor_box+24, W1
	MOV.D	W0, [W10]
;Box.c,80 :: 		Box_LimitSwitchStatus(box);
	CALL	_Box_LimitSwitchStatus
;Box.c,81 :: 		box->key_touch = Box_KeyTouchStatus(box);
	ADD	W10, #12, W0
	MOV	W0, [W14+0]
	CALL	_Box_KeyTouchStatus
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;Box.c,86 :: 		if (box->key_touch == 1) {
	ADD	W10, #12, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Box_UpdateStatus25
	GOTO	L_Box_UpdateStatus6
L__Box_UpdateStatus25:
;Box.c,87 :: 		box->box_status = ACTIVE;  // Box có vật thể khi công tắc được kích hoạt
	ADD	W10, #5, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Box.c,88 :: 		} else {
	GOTO	L_Box_UpdateStatus7
L_Box_UpdateStatus6:
;Box.c,89 :: 		box->box_status = INACTIVE; // Box trống khi công tắc không kích hoạt
	ADD	W10, #5, W1
	CLR	W0
	MOV.B	W0, [W1]
;Box.c,90 :: 		}
L_Box_UpdateStatus7:
;Box.c,93 :: 		if (box->limit_switch_state == 1) {
	ADD	W10, #4, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Box_UpdateStatus26
	GOTO	L_Box_UpdateStatus8
L__Box_UpdateStatus26:
;Box.c,94 :: 		box->object_detected = 1;
	ADD	W10, #6, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Box.c,95 :: 		} else {
	GOTO	L_Box_UpdateStatus9
L_Box_UpdateStatus8:
;Box.c,96 :: 		box->object_detected = 0;
	ADD	W10, #6, W1
	CLR	W0
	MOV.B	W0, [W1]
;Box.c,97 :: 		}
L_Box_UpdateStatus9:
;Box.c,98 :: 		}
L_end_Box_UpdateStatus:
	ULNK
	RETURN
; end of _Box_UpdateStatus

_Box_IsObjectDetected:

;Box.c,105 :: 		uint8_t Box_IsObjectDetected(Box_Object* box) {
;Box.c,106 :: 		if (box == NULL) return 0;
	CP	W10, #0
	BRA Z	L__Box_IsObjectDetected28
	GOTO	L_Box_IsObjectDetected10
L__Box_IsObjectDetected28:
	CLR	W0
	GOTO	L_end_Box_IsObjectDetected
L_Box_IsObjectDetected10:
;Box.c,107 :: 		return box->object_detected;
	ADD	W10, #6, W0
	MOV.B	[W0], W0
;Box.c,108 :: 		}
L_end_Box_IsObjectDetected:
	RETURN
; end of _Box_IsObjectDetected

_Box_GetStatus:

;Box.c,115 :: 		Box_state Box_GetStatus(Box_Object* box) {
;Box.c,116 :: 		if (box == NULL) return INACTIVE;
	CP	W10, #0
	BRA Z	L__Box_GetStatus30
	GOTO	L_Box_GetStatus11
L__Box_GetStatus30:
	CLR	W0
	GOTO	L_end_Box_GetStatus
L_Box_GetStatus11:
;Box.c,117 :: 		return box->box_status;
	ADD	W10, #5, W0
	MOV.B	[W0], W0
;Box.c,118 :: 		}
L_end_Box_GetStatus:
	RETURN
; end of _Box_GetStatus

_Box_GetDistance:

;Box.c,125 :: 		float Box_GetDistance(Box_Object* box) {
;Box.c,126 :: 		if (box == NULL) return 0.0f;
	CP	W10, #0
	BRA Z	L__Box_GetDistance32
	GOTO	L_Box_GetDistance12
L__Box_GetDistance32:
	CLR	W0
	CLR	W1
	GOTO	L_end_Box_GetDistance
L_Box_GetDistance12:
;Box.c,127 :: 		return box->distance_inbox;
	MOV.D	[W10], W0
;Box.c,128 :: 		}
L_end_Box_GetDistance:
	RETURN
; end of _Box_GetDistance

_Box_GetLimitSwitchState:

;Box.c,135 :: 		uint8_t Box_GetLimitSwitchState(Box_Object* box) {
;Box.c,136 :: 		if (box == NULL) return 0;
	CP	W10, #0
	BRA Z	L__Box_GetLimitSwitchState34
	GOTO	L_Box_GetLimitSwitchState13
L__Box_GetLimitSwitchState34:
	CLR	W0
	GOTO	L_end_Box_GetLimitSwitchState
L_Box_GetLimitSwitchState13:
;Box.c,137 :: 		return box->limit_switch_state;
	ADD	W10, #4, W0
	MOV.B	[W0], W0
;Box.c,138 :: 		}
L_end_Box_GetLimitSwitchState:
	RETURN
; end of _Box_GetLimitSwitchState

_Box_SetDetectionThreshold:

;Box.c,145 :: 		void Box_SetDetectionThreshold(Box_Object* box, float threshold) {
;Box.c,146 :: 		if (box == NULL) return;
	CP	W10, #0
	BRA Z	L__Box_SetDetectionThreshold36
	GOTO	L_Box_SetDetectionThreshold14
L__Box_SetDetectionThreshold36:
	GOTO	L_end_Box_SetDetectionThreshold
L_Box_SetDetectionThreshold14:
;Box.c,147 :: 		if (threshold > 0) {
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
	BRA LE	L__Box_SetDetectionThreshold37
	INC.B	W0
L__Box_SetDetectionThreshold37:
	POP	W10
	POP	W12
	POP	W11
	CP0.B	W0
	BRA NZ	L__Box_SetDetectionThreshold38
	GOTO	L_Box_SetDetectionThreshold15
L__Box_SetDetectionThreshold38:
;Box.c,148 :: 		box->detection_threshold = threshold;
	ADD	W10, #8, W0
	MOV	W11, [W0++]
	MOV	W12, [W0--]
;Box.c,149 :: 		}
L_Box_SetDetectionThreshold15:
;Box.c,150 :: 		}
L_end_Box_SetDetectionThreshold:
	RETURN
; end of _Box_SetDetectionThreshold

_Box_GetDetectionThreshold:

;Box.c,157 :: 		float Box_GetDetectionThreshold(Box_Object* box) {
;Box.c,158 :: 		if (box == NULL) return 0.0f;
	CP	W10, #0
	BRA Z	L__Box_GetDetectionThreshold40
	GOTO	L_Box_GetDetectionThreshold16
L__Box_GetDetectionThreshold40:
	CLR	W0
	CLR	W1
	GOTO	L_end_Box_GetDetectionThreshold
L_Box_GetDetectionThreshold16:
;Box.c,159 :: 		return box->detection_threshold;
	ADD	W10, #8, W2
	MOV.D	[W2], W0
;Box.c,160 :: 		}
L_end_Box_GetDetectionThreshold:
	RETURN
; end of _Box_GetDetectionThreshold

_Box_GetDetailedStatus:

;Box.c,167 :: 		void Box_GetDetailedStatus(Box_Object* box, char* status_info) {
;Box.c,181 :: 		}
L_end_Box_GetDetailedStatus:
	RETURN
; end of _Box_GetDetailedStatus
