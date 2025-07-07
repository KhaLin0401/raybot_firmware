#line 1 "D:/Intern/RAY_ROBOT_V1.2 (3)/RAY_ROBOT_V1.2/Battery.c"
#line 1 "d:/intern/ray_robot_v1.2 (3)/ray_robot_v1.2/battery.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed int int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 5 "d:/intern/ray_robot_v1.2 (3)/ray_robot_v1.2/battery.h"
typedef struct {
 uint16_t battery_voltage;
 uint16_t cell_voltage[4];
 uint16_t battery_current;
 uint8_t battery_soc;
 uint8_t battery_health;
 uint8_t battery_temp;
 uint8_t battery_status;
 uint8_t battery_fault;
 uint8_t battery_perform;
 uint8_t charge_enable;
 uint8_t discharge_enable;
 uint16_t charge_current_limit;
 uint16_t discharge_current_limit;
} Battery;

extern Battery _battery;

void Battery_Init(Battery *bat);

void Battery_Update();
#line 50 "d:/intern/ray_robot_v1.2 (3)/ray_robot_v1.2/battery.h"
void set_chg_cur_lim();

void set_dis_cur_lim();

void set_chg_en();

void set_dis_en();
#line 4 "D:/Intern/RAY_ROBOT_V1.2 (3)/RAY_ROBOT_V1.2/Battery.c"
Battery _battery;

void Battery_Init(Battery *bat){
 bat->battery_voltage = 0;
 bat->cell_voltage[0] = 0;
 bat->cell_voltage[1] = 0;
 bat->cell_voltage[2] = 0;
 bat->cell_voltage[3] = 0;
 bat->battery_current = 0;
 bat->battery_soc = 0;
 bat->battery_health = 0;
 bat->battery_temp = 0;
 bat->battery_status = 0;
 bat->battery_fault = 0;
 bat->battery_perform = 0;
 bat->charge_enable = 0;
 bat->discharge_enable = 0;
 bat->charge_current_limit = 0;
 bat->discharge_current_limit = 0;
}

void Battery_Update(){
}
#line 53 "D:/Intern/RAY_ROBOT_V1.2 (3)/RAY_ROBOT_V1.2/Battery.c"
void set_chg_cur_lim(){
}

void set_dis_cur_lim(){
}

void set_chg_en(){
}

void set_dis_en(){
}
