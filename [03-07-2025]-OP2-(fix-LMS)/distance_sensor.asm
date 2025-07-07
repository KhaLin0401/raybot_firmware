
distance_sensor_calculate_average:

;distance_sensor.c,10 :: 		static uint16_t calculate_average(uint16_t *datat) {
;distance_sensor.c,11 :: 		int i = 0;
;distance_sensor.c,12 :: 		uint32_t sum = 0;
; sum start address is: 6 (W3)
	CLR	W3
	CLR	W4
;distance_sensor.c,13 :: 		for (i = 0; i < FILTER_SIZE; i++) {
; i start address is: 4 (W2)
	CLR	W2
; sum end address is: 6 (W3)
; i end address is: 4 (W2)
L_distance_sensor_calculate_average0:
; i start address is: 4 (W2)
; sum start address is: 6 (W3)
	CP	W2, #10
	BRA LT	L_distance_sensor_calculate_average14
	GOTO	L_distance_sensor_calculate_average1
L_distance_sensor_calculate_average14:
;distance_sensor.c,14 :: 		sum += datat[i];
	SL	W2, #1, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CLR	W1
	ADD	W3, W0, W3
	ADDC	W4, W1, W4
;distance_sensor.c,13 :: 		for (i = 0; i < FILTER_SIZE; i++) {
	INC	W2
;distance_sensor.c,15 :: 		}
; i end address is: 4 (W2)
	GOTO	L_distance_sensor_calculate_average0
L_distance_sensor_calculate_average1:
;distance_sensor.c,16 :: 		return (uint16_t)(sum / FILTER_SIZE);
	PUSH	W10
; sum end address is: 6 (W3)
	MOV	W3, W0
	MOV	W4, W1
	MOV	#10, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	POP	W10
;distance_sensor.c,17 :: 		}
L_end_calculate_average:
	RETURN
; end of distance_sensor_calculate_average

_DistanceSensor_Init:

;distance_sensor.c,20 :: 		void DistanceSensor_Init(DistanceSensor *sensor, uint8_t channel, SensorType type) {
;distance_sensor.c,21 :: 		int i = 0;
;distance_sensor.c,22 :: 		sensor->adc_channel = channel;
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV.B	W11, [W0]
;distance_sensor.c,23 :: 		sensor->sensor_type = type;
	MOV	#33, W0
	ADD	W10, W0, W0
	MOV.B	W12, [W0]
;distance_sensor.c,24 :: 		sensor->filtered_value = 0;
	ADD	W10, #20, W1
	CLR	W0
	MOV	W0, [W1]
;distance_sensor.c,25 :: 		sensor->distance_cm = 0.0;
	ADD	W10, #22, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;distance_sensor.c,26 :: 		sensor->index = 0;
	ADD	W10, #26, W1
	CLR	W0
	MOV.B	W0, [W1]
;distance_sensor.c,29 :: 		for (i = 0; i < FILTER_SIZE; i++) {
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_DistanceSensor_Init3:
; i start address is: 4 (W2)
	CP	W2, #10
	BRA LT	L__DistanceSensor_Init16
	GOTO	L_DistanceSensor_Init4
L__DistanceSensor_Init16:
;distance_sensor.c,30 :: 		sensor->readings[i] = 0;
	SL	W2, #1, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;distance_sensor.c,29 :: 		for (i = 0; i < FILTER_SIZE; i++) {
	INC	W2
;distance_sensor.c,31 :: 		}
; i end address is: 4 (W2)
	GOTO	L_DistanceSensor_Init3
L_DistanceSensor_Init4:
;distance_sensor.c,32 :: 		}
L_end_DistanceSensor_Init:
	RETURN
; end of _DistanceSensor_Init

distance_sensor_convert_gp2y0a21yk0f:
	LNK	#4

;distance_sensor.c,35 :: 		static float convert_gp2y0a21yk0f(uint16_t adc_value) {
;distance_sensor.c,36 :: 		float voltage = (adc_value * VREF) / 1023.0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	W10, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#13107, W2
	MOV	#16467, W3
	CALL	__Mul_FP
	MOV	#49152, W2
	MOV	#17535, W3
	CALL	__Div_FP
;distance_sensor.c,37 :: 		float distance_cm = 27.86 * pow(voltage, -1.15);  // H? s? th?c nghi?m
	MOV	#13107, W12
	MOV	#49043, W13
	MOV.D	W0, W10
	CALL	_pow
	MOV	#57672, W2
	MOV	#16862, W3
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;distance_sensor.c,39 :: 		if (distance_cm > 80.0) return 80.0;
	MOV	#0, W2
	MOV	#17056, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L_distance_sensor_convert_gp2y0a21yk0f18
	INC.B	W0
L_distance_sensor_convert_gp2y0a21yk0f18:
	CP0.B	W0
	BRA NZ	L_distance_sensor_convert_gp2y0a21yk0f19
	GOTO	L_distance_sensor_convert_gp2y0a21yk0f6
L_distance_sensor_convert_gp2y0a21yk0f19:
	MOV	#0, W0
	MOV	#17056, W1
	GOTO	L_end_convert_gp2y0a21yk0f
L_distance_sensor_convert_gp2y0a21yk0f6:
;distance_sensor.c,40 :: 		if (distance_cm < 10.0) return 10.0;
	MOV	#0, W2
	MOV	#16672, W3
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L_distance_sensor_convert_gp2y0a21yk0f20
	INC.B	W0
L_distance_sensor_convert_gp2y0a21yk0f20:
	CP0.B	W0
	BRA NZ	L_distance_sensor_convert_gp2y0a21yk0f21
	GOTO	L_distance_sensor_convert_gp2y0a21yk0f7
L_distance_sensor_convert_gp2y0a21yk0f21:
	MOV	#0, W0
	MOV	#16672, W1
	GOTO	L_end_convert_gp2y0a21yk0f
L_distance_sensor_convert_gp2y0a21yk0f7:
;distance_sensor.c,41 :: 		return distance_cm;
	MOV	[W14+0], W0
	MOV	[W14+2], W1
;distance_sensor.c,42 :: 		}
;distance_sensor.c,41 :: 		return distance_cm;
;distance_sensor.c,42 :: 		}
L_end_convert_gp2y0a21yk0f:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of distance_sensor_convert_gp2y0a21yk0f

distance_sensor_convert_gp2y0a02yk0f:
	LNK	#4

;distance_sensor.c,45 :: 		static float convert_gp2y0a02yk0f(uint16_t adc_value) {
;distance_sensor.c,46 :: 		float voltage = (adc_value * VREF) / 1023.0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	W10, W0
	CLR	W1
	CALL	__Long2Float
	MOV	#13107, W2
	MOV	#16467, W3
	CALL	__Mul_FP
	MOV	#49152, W2
	MOV	#17535, W3
	CALL	__Div_FP
;distance_sensor.c,47 :: 		float distance_cm = 47.4 * pow(voltage, -1.10);  // H? s? th?c nghi?m
	MOV	#52429, W12
	MOV	#49036, W13
	MOV.D	W0, W10
	CALL	_pow
	MOV	#39322, W2
	MOV	#16957, W3
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;distance_sensor.c,49 :: 		if (distance_cm > 250.0) return 250.0;
	MOV	#0, W2
	MOV	#17274, W3
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L_distance_sensor_convert_gp2y0a02yk0f23
	INC.B	W0
L_distance_sensor_convert_gp2y0a02yk0f23:
	CP0.B	W0
	BRA NZ	L_distance_sensor_convert_gp2y0a02yk0f24
	GOTO	L_distance_sensor_convert_gp2y0a02yk0f8
L_distance_sensor_convert_gp2y0a02yk0f24:
	MOV	#0, W0
	MOV	#17274, W1
	GOTO	L_end_convert_gp2y0a02yk0f
L_distance_sensor_convert_gp2y0a02yk0f8:
;distance_sensor.c,50 :: 		if (distance_cm < 20.0) return 20.0;
	MOV	#0, W2
	MOV	#16800, W3
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	CALL	__Compare_Le_Fp
	CP0	W0
	CLR.B	W0
	BRA GE	L_distance_sensor_convert_gp2y0a02yk0f25
	INC.B	W0
L_distance_sensor_convert_gp2y0a02yk0f25:
	CP0.B	W0
	BRA NZ	L_distance_sensor_convert_gp2y0a02yk0f26
	GOTO	L_distance_sensor_convert_gp2y0a02yk0f9
L_distance_sensor_convert_gp2y0a02yk0f26:
	MOV	#0, W0
	MOV	#16800, W1
	GOTO	L_end_convert_gp2y0a02yk0f
L_distance_sensor_convert_gp2y0a02yk0f9:
;distance_sensor.c,52 :: 		return distance_cm;
	MOV	[W14+0], W0
	MOV	[W14+2], W1
;distance_sensor.c,53 :: 		}
;distance_sensor.c,52 :: 		return distance_cm;
;distance_sensor.c,53 :: 		}
L_end_convert_gp2y0a02yk0f:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of distance_sensor_convert_gp2y0a02yk0f

_DistanceSensor_Update:
	LNK	#2

;distance_sensor.c,56 :: 		void DistanceSensor_Update(DistanceSensor *sensor) {
;distance_sensor.c,59 :: 		sensor->readings[sensor->index] = ADC1_Get_Sample(sensor->adc_channel);
	ADD	W10, #26, W0
	MOV.B	[W0], W0
	ZE	W0, W0
	SL	W0, #1, W0
	ADD	W10, W0, W0
	MOV	W0, [W14+0]
	MOV	#32, W0
	ADD	W10, W0, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_ADC1_Get_Sample
	POP	W10
	MOV	[W14+0], W1
	MOV	W0, [W1]
;distance_sensor.c,60 :: 		sensor->filtered_value = calculate_average(sensor->readings);
	ADD	W10, #20, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CALL	distance_sensor_calculate_average
	POP	W10
	MOV	[W14+0], W1
	MOV	W0, [W1]
;distance_sensor.c,63 :: 		if (sensor->sensor_type == SENSOR_GP2Y0A21YK0F) {
	MOV	#33, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__DistanceSensor_Update28
	GOTO	L_DistanceSensor_Update10
L__DistanceSensor_Update28:
;distance_sensor.c,64 :: 		sensor->distance_cm = convert_gp2y0a21yk0f(sensor->filtered_value);
	ADD	W10, #22, W0
	MOV	W0, [W14+0]
	ADD	W10, #20, W0
	PUSH	W10
	MOV	[W0], W10
	CALL	distance_sensor_convert_gp2y0a21yk0f
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;distance_sensor.c,65 :: 		} else if (sensor->sensor_type == SENSOR_GP2Y0A02YK0F) {
	GOTO	L_DistanceSensor_Update11
L_DistanceSensor_Update10:
	MOV	#33, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__DistanceSensor_Update29
	GOTO	L_DistanceSensor_Update12
L__DistanceSensor_Update29:
;distance_sensor.c,66 :: 		sensor->distance_cm = convert_gp2y0a02yk0f(sensor->filtered_value);
	ADD	W10, #22, W0
	MOV	W0, [W14+0]
	ADD	W10, #20, W0
	PUSH	W10
	MOV	[W0], W10
	CALL	distance_sensor_convert_gp2y0a02yk0f
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;distance_sensor.c,67 :: 		}
L_DistanceSensor_Update12:
L_DistanceSensor_Update11:
;distance_sensor.c,68 :: 		sensor->distance_cm = sensor->distance_cm + sensor->calib;
	ADD	W10, #22, W0
	MOV	W0, [W14+0]
	MOV	[W0++], W3
	MOV	[W0--], W4
	ADD	W10, #28, W2
	MOV.D	[W2], W0
	PUSH	W10
	MOV	W3, W2
	MOV	W4, W3
	CALL	__AddSub_FP
	POP	W10
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;distance_sensor.c,76 :: 		sensor->index = (sensor->index + 1) % FILTER_SIZE;
	ADD	W10, #26, W0
	MOV	W0, [W14+0]
	ZE	[W0], W0
	INC	W0
	MOV	#10, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	[W14+0], W0
	MOV.B	W1, [W0]
;distance_sensor.c,77 :: 		}
L_end_DistanceSensor_Update:
	ULNK
	RETURN
; end of _DistanceSensor_Update

_DistanceSensor_GetValue:

;distance_sensor.c,80 :: 		uint16_t DistanceSensor_GetValue(DistanceSensor *sensor) {
;distance_sensor.c,81 :: 		return sensor->filtered_value;
	ADD	W10, #20, W0
	MOV	[W0], W0
;distance_sensor.c,82 :: 		}
L_end_DistanceSensor_GetValue:
	RETURN
; end of _DistanceSensor_GetValue

_DistanceSensor_GetDistanceCM:

;distance_sensor.c,85 :: 		float DistanceSensor_GetDistanceCM(DistanceSensor *sensor) {
;distance_sensor.c,86 :: 		return sensor->distance_cm;
	ADD	W10, #22, W2
	MOV.D	[W2], W0
;distance_sensor.c,87 :: 		}
L_end_DistanceSensor_GetDistanceCM:
	RETURN
; end of _DistanceSensor_GetDistanceCM
