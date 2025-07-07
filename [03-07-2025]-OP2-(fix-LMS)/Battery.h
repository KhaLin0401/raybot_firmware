#ifndef BATTERY_H
#define BATTERY_H

#include <stdint.h>
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

void  Battery_Init(Battery *bat);

void Battery_Update();
/*uint16_t battery_voltage(Battery *bat);

uint16_t cell_voltage(Battery *bat);

uint16_t battery_current(Battery *bat);

uint8_t battery_soc(Battery *bat);

uint8_t battery_health(Battery *bat);

uint8_t battery_temp(Battery *bat);

uint8_t battery_status(Battery *bat);

uint8_t battery_fault(Battery *bat);

uint8_t charge_enable(Battery *bat);

uint8_t discharge_enable(Battery *bat);

uint16_t charge_current_limit(Battery *bat);

uint16_t discharge_current_limit(Battery *bat);*/

void set_chg_cur_lim();

void set_dis_cur_lim();

void set_chg_en();

void set_dis_en();

#endif