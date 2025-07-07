#include "Battery.h"


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

/*uint16_t battery_voltage(Battery *bat){
}
uint16_t cell_voltage(Battery *bat){
}
uint16_t battery_current(Battery *bat){
}
uint8_t battery_soc(Battery *bat){
}
uint8_t battery_health(Battery *bat){
}
uint8_t battery_temp(Battery *bat){
}
uint8_t battery_status(Battery *bat){
}
uint8_t battery_fault(Battery *bat){
}
uint8_t charge_enable(Battery *bat){
}
uint8_t discharge_enable(Battery *bat){
}
uint16_t charge_current_limit(Battery *bat){
}
uint16_t discharge_current_limit(Battery *bat){
}*/

void set_chg_cur_lim(){
}

void set_dis_cur_lim(){
}

void set_chg_en(){
}

void set_dis_en(){
}