#ifndef COMMAND_HANDLER_H
#define COMMAND_HANDLER_H
#ifndef DEBUG_LEVEL
#define DEBUG_LEVEL 2   // 0: Off, 1: Error, 2: Info, 3: Verbose
#endif

// Macro debug (ch? in n?u m?c debug cao hon m?c du?c d?nh nghia)
#if DEBUG_LEVEL >= 2
#define DEBUG_PRINT(text) DebugUART_Send_Text(text)
#define DEBUG_PRINTF(fmt, ...) { char _dbg[128]; sprintf(_dbg, fmt, __VA_ARGS__); DebugUART_Send_Text(_dbg); }
#else
#define DEBUG_PRINT(text)
#define DEBUG_PRINTF(fmt, ...)
#endif

#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include "uart2.h"
#include "robot_system.h"
#include "MotorControl.h"
#include "json_parser.h"

/*
  command_handler.h - Khai b?o c?c h?m x? l? l?nh (GET/SET)
  d?a tr?n b?ng l?nh b?n cung c?p.
*/

/* ===== ??nh nghia ki?u d? li?u CommandHandler ===== */
typedef struct {
    char command_name[32];
    int command_value;
    char response_buffer[128];
    uint8_t is_valid;
    char id[32];
} CommandHandler;

/* ===== Bi?n to?n c?c ===== */
extern CommandHandler cmdHandler;

/* ===== Kh?i t?o & X? l? l?nh ===== */
void CommandHandler_Init(CommandHandler *handler);
void CommandHandler_ParseCommand(CommandHandler *handler, const char *cmd);
void CommandHandler_Execute(CommandHandler *handler, const char *cmd);
void CommandHandler_Respond(CommandHandler *handler);
void handle_unknown_command(CommandHandler *handler);
void CommandHandler_ParseJSON(CommandHandler *handler, const char *cmd);
static void strip_newline(char *str);
/*
   === Nh?m h?m x? l? GET/SET (theo b?ng) ===
   B?n c? th? b? sung logic l?y/tr? d? li?u th?c t? trong m?i h?m.
*/

/* ========== Battery ========== */
void handle_get_bat_info(CommandHandler *handler);
void handle_get_bat_current(CommandHandler *handler);
void handle_get_bat_fault(CommandHandler *handler);
void handle_get_bat_health(CommandHandler *handler);
void handle_get_bat_soc(CommandHandler *handler);
void handle_get_bat_status(CommandHandler *handler);
void handle_get_bat_temp(CommandHandler *handler);
void handle_get_bat_volt(CommandHandler *handler);
void handle_get_cell_volt(CommandHandler *handler);

/* ========== Charging ========== */
void handle_get_chg_info(CommandHandler *handler);
void handle_get_chg_cur_lim(CommandHandler *handler);
void handle_set_chg_cur_lim(CommandHandler *handler);
void handle_get_chg_en(CommandHandler *handler);
void handle_set_chg_en(CommandHandler *handler);
void handle_get_dis_info(CommandHandler *handler);
void handle_get_dis_cur_lim(CommandHandler *handler);
void handle_set_dis_cur_lim(CommandHandler *handler);
void handle_get_dis_en(CommandHandler *handler);
void handle_set_dis_en(CommandHandler *handler);

/* ========== Digital Inputs ========== */
void handle_get_di1(CommandHandler *handler);
void handle_get_di2(CommandHandler *handler);
void handle_get_di3(CommandHandler *handler);

/* ========== Distance Sensors ========== */
void handle_get_dist_info(CommandHandler *handler);
void handle_get_down_dist(CommandHandler *handler);
void handle_get_front_dist(CommandHandler *handler);
void handle_get_rear_dist(CommandHandler *handler);
void handle_get_up_dist(CommandHandler *handler);

/* ========== Identification ========== */
void handle_get_auto_mode(CommandHandler *handler);
void handle_set_auto_mode(CommandHandler *handler);

/* ========== Lifter ========== */
void handle_get_lifter_info(CommandHandler *handler);
void handle_get_lifter_dir(CommandHandler *handler);
void handle_set_lifter_dir(CommandHandler *handler);
void handle_get_lifter_lim_down(CommandHandler *handler);
void handle_get_lifter_lim_up(CommandHandler *handler);
void handle_get_lifter_speed(CommandHandler *handler);
void handle_set_lifter_speed(CommandHandler *handler);
void handle_get_lifter_status(CommandHandler *handler);

/* ========== Motor ========== */
void handle_get_motor_info(CommandHandler *handler);
void handle_get_motor_brake(CommandHandler *handler);
void handle_set_motor_brake(CommandHandler *handler);
void handle_get_motor_dir(CommandHandler *handler);
void handle_set_motor_dir(CommandHandler *handler);
void handle_get_motor_en(CommandHandler *handler);
void handle_set_motor_en(CommandHandler *handler);
void handle_get_motor_speed(CommandHandler *handler);
void handle_set_motor_speed(CommandHandler *handler);
void handle_get_travel_lim_front(CommandHandler *handler);
void handle_get_travel_lim_rear(CommandHandler *handler);

/* ========== Relay ========== */
void handle_get_relay1(CommandHandler *handler);
void handle_set_relay1(CommandHandler *handler);
void handle_get_relay2(CommandHandler *handler);
void handle_set_relay2(CommandHandler *handler);

/* ========== RFID ========== */
void handle_get_rfid_err(CommandHandler *handler);
void handle_get_rfid_cur_loc(CommandHandler *handler);
void handle_get_rfid_tar_loc(CommandHandler *handler);

/* ========== Robot ========== */
void handle_get_fw_ver(CommandHandler *handler);
void handle_get_robot_model(CommandHandler *handler);
void handle_get_robot_id(CommandHandler *handler);
void handle_get_robot_serial(CommandHandler *handler);

/* ========== Sensors ========== */
void handle_get_safe_sensor_front(CommandHandler *handler);
void handle_get_safe_sensor_rear(CommandHandler *handler);


void handle_unknown_command(CommandHandler *handler);

// N?u mu?n s? d?ng strip_newline ? ngo?i file command_handler.c, th?m prototype:
void strip_newline(char *str);

/*=========== UPDATE ============*/
void handle_get_update_status(CommandHandler *handler);
void handle_set_update_status(CommandHandler *handler);

void handle_charge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_discharge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_lifter_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_motorDC_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_ping_command(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_get_box_status(CommandHandler *handler); // Ham tra cap nhat trang thai doi tuong hop

#endif /* COMMAND_HANDLER_H */