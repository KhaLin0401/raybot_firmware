
_Battery_Init:

;Battery.c,6 :: 		void Battery_Init(Battery *bat){
;Battery.c,7 :: 		bat->battery_voltage = 0;
	CLR	W0
	MOV	W0, [W10]
;Battery.c,8 :: 		bat->cell_voltage[0] = 0;
	ADD	W10, #2, W1
	CLR	W0
	MOV	W0, [W1]
;Battery.c,9 :: 		bat->cell_voltage[1] = 0;
	ADD	W10, #2, W0
	ADD	W0, #2, W1
	CLR	W0
	MOV	W0, [W1]
;Battery.c,10 :: 		bat->cell_voltage[2] = 0;
	ADD	W10, #2, W0
	ADD	W0, #4, W1
	CLR	W0
	MOV	W0, [W1]
;Battery.c,11 :: 		bat->cell_voltage[3] = 0;
	ADD	W10, #2, W0
	ADD	W0, #6, W1
	CLR	W0
	MOV	W0, [W1]
;Battery.c,12 :: 		bat->battery_current = 0;
	ADD	W10, #10, W1
	CLR	W0
	MOV	W0, [W1]
;Battery.c,13 :: 		bat->battery_soc = 0;
	ADD	W10, #12, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,14 :: 		bat->battery_health = 0;
	ADD	W10, #13, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,15 :: 		bat->battery_temp = 0;
	ADD	W10, #14, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,16 :: 		bat->battery_status = 0;
	ADD	W10, #15, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,17 :: 		bat->battery_fault = 0;
	ADD	W10, #16, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,18 :: 		bat->battery_perform = 0;
	ADD	W10, #17, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,19 :: 		bat->charge_enable = 0;
	ADD	W10, #18, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,20 :: 		bat->discharge_enable = 0;
	ADD	W10, #19, W1
	CLR	W0
	MOV.B	W0, [W1]
;Battery.c,21 :: 		bat->charge_current_limit = 0;
	ADD	W10, #20, W1
	CLR	W0
	MOV	W0, [W1]
;Battery.c,22 :: 		bat->discharge_current_limit = 0;
	ADD	W10, #22, W1
	CLR	W0
	MOV	W0, [W1]
;Battery.c,23 :: 		}
L_end_Battery_Init:
	RETURN
; end of _Battery_Init

_Battery_Update:

;Battery.c,25 :: 		void Battery_Update(){
;Battery.c,26 :: 		}
L_end_Battery_Update:
	RETURN
; end of _Battery_Update

_set_chg_cur_lim:

;Battery.c,53 :: 		void set_chg_cur_lim(){
;Battery.c,54 :: 		}
L_end_set_chg_cur_lim:
	RETURN
; end of _set_chg_cur_lim

_set_dis_cur_lim:

;Battery.c,56 :: 		void set_dis_cur_lim(){
;Battery.c,57 :: 		}
L_end_set_dis_cur_lim:
	RETURN
; end of _set_dis_cur_lim

_set_chg_en:

;Battery.c,59 :: 		void set_chg_en(){
;Battery.c,60 :: 		}
L_end_set_chg_en:
	RETURN
; end of _set_chg_en

_set_dis_en:

;Battery.c,62 :: 		void set_dis_en(){
;Battery.c,63 :: 		}
L_end_set_dis_en:
	RETURN
; end of _set_dis_en
