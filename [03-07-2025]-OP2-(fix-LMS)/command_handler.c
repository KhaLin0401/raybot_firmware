#include <stddef.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include "command_handler.h"
#include "uart2.h"
#include "Lifter.h"
#include "json_parser.h"
#include "BMS.h"
#include "Box.h"

#include "robot_system.h"

/*
   C?u h?nh debug level:
   DEBUG_LEVEL = 0: T?t log
   DEBUG_LEVEL = 1: Log l?i
   DEBUG_LEVEL = 2: Log th?ng tin co b?n
   DEBUG_LEVEL = 3: Log chi ti?t
*/
#ifndef DEBUG_LEVEL
#define DEBUG_LEVEL 2
#endif

#if DEBUG_LEVEL >= 2
#define DEBUG_PRINT(text) DebugUART_Send_Text(text)
#define DEBUG_PRINTF(fmt, ...) { char _dbg[128]; sprintf(_dbg, fmt, __VA_ARGS__); DebugUART_Send_Text(_dbg); }
#else
#define DEBUG_PRINT(text)
#define DEBUG_PRINTF(fmt, ...)
#endif
CommandHandler cmdHandler;
uint8_t _defaultSetPayload[7] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
// State machine states cho vi?c ph?n t?ch l?nh
typedef enum {
    PARSE_STATE_IDLE,
    PARSE_STATE_COMMAND,
    PARSE_STATE_VALUE
} ParseState;

// H?m lo?i b? k? t? newline, carriage return v? kho?ng tr?ng th?a ? cu?i chu?i
static void strip_newline(char *str) {
    int len = strlen(str);
    while (len > 0 && (str[len - 1] == '\r' || str[len - 1] == '\n' || str[len - 1] == ' ')) {
        str[len - 1] = '\0';
        len--;
    }
}

// H?m trim kho?ng tr?ng d?u v? cu?i chu?i
static void trim_whitespace(char *str) {
    int i, start = 0;
    int len = strlen(str);
    // Lo?i b? kho?ng tr?ng ? d?u chu?i
    while (start < len && (str[start]==' ' || str[start]=='\t')) {
        start++;
    }
    if (start > 0) {
        for (i = start; i < len; i++) {
            str[i - start] = str[i];
        }
        str[len - start] = '\0';
    }
    // Lo?i b? kho?ng tr?ng ? cu?i chu?i
    len = strlen(str);
    while (len > 0 && (str[len - 1]==' ' || str[len - 1]=='\t')) {
        str[len - 1] = '\0';
        len--;
    }
}

/* ===== Kh?i t?o CommandHandler ===== */
void CommandHandler_Init(CommandHandler *handler) {
    strcpy(handler->command_name, "");
    handler->command_value = 0;
    memset(handler->response_buffer, 0, sizeof(handler->response_buffer));
    handler->is_valid = 0;
    strcpy(handler->id, "");

}

/* ===== X? l? l?nh kh?ng h?p l? ===== */
void handle_unknown_command(CommandHandler *handler) {
    sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Unknown command: %s\"}\r\n", handler->id, handler->command_name);
    DEBUG_PRINT(handler->response_buffer);
}

/*
   C?u tr?c ?nh x? l?nh: m?i ph?n t? bao g?m t?n l?nh v? con tr? h?m x? l? tuong ?ng.
*/

/* ===== G?i ph?n h?i sau khi th?c thi l?nh ===== */
void CommandHandler_Respond(CommandHandler *handler) {
    // Thay v? g?i tr?c ti?p, d?y ph?n h?i v?o h?ng d?i c?a transmitter.
    _UART2_SendPush(handler->response_buffer);
    DEBUG_PRINT(handler->response_buffer);
}

/*
   === ??NH NGHIA C?C H?M X? L? C? TH? (STUB/PLACEHOLDER) ===
   B?n c? th? thay th? gi? tr? "xxx=..." b?ng d? li?u th?c t?.
   ? d?y ch? l?m v? d? d? code compile th?nh c?ng.
*/

void CommandHandler_ParseJSON(CommandHandler *handler, const char *cmd) {
    // Khai b?o buffer v? bi?n c?c b? c?n thi?t
    char _buffer[128];
    char _id[32] = {0};
    int _cmd_type = -1;
    char _dataBuffer[128] = {0};
    JSON_Parser _parser;    // Parser cho to?n b? chu?i JSON
    JSON_Parser _dataParser; // Parser ri?ng cho object "data"
    int _param1 = 0, _param2 = 0, _param3 = 0;

    // Ki?m tra n?u chu?i l?nh kh?ng b?t d?u b?ng k? t? '>' th? b? qua (kh?ng ph?i l?nh JSON)
    if (cmd[0] != '>')
        return;

    // Sao ch?p chu?i l?nh, b? k? t? '>' d?u ti?n
    strncpy(_buffer, cmd + 1, sizeof(_buffer) - 1);
    _buffer[sizeof(_buffer) - 1] = '\0';

    // Lo?i b? k? t? newline, carriage return v? kho?ng tr?ng th?a cu?i chu?i
    strip_newline(_buffer);

    // Debug: In ra chu?i JSON d? du?c l?m s?ch
//    DEBUG_PRINTF("DEBUG: Parsed JSON string: %s\n", _buffer);

    // Kh?i t?o parser v?i chu?i JSON
    JSON_Init(&_parser, _buffer);

    // L?y tru?ng "id" t? JSON
    if (!JSON_GetString(&_parser, "id", _id, sizeof(_id))) {
        sprintf(handler->response_buffer, ">{\"id\":\"\",\"error\":\"Invalid JSON: missing id\"}\r\n");
        return;
    }
    strcpy(handler->id, _id);
//    DEBUG_PRINTF("DEBUG: Extracted id: %s\n", _id);

    // L?y tru?ng "type" t? JSON (ki?u s? nguy?n)
    if (!JSON_GetInt(&_parser, "type", &_cmd_type)) {
        sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Invalid JSON: missing type\"}\r\n", _id);
        return;
    }
//    DEBUG_PRINTF("DEBUG: Command type: %d\n", _cmd_type);

    // L?y object "data" t? JSON
    if (!JSON_GetObject(&_parser, "data", _dataBuffer, sizeof(_dataBuffer))) {
        sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Invalid JSON: missing data\"}\r\n", _id);
        return;
    }
//    DEBUG_PRINTF("DEBUG: Extracted data object: %s\n", _dataBuffer);

    // Kh?i t?o parser cho object "data"
    JSON_Init(&_dataParser, _dataBuffer);

    // Debug ban d?u: In gi? tr? m?c d?nh c?a c?c bi?n (chua du?c g?n)
//    DEBUG_PRINTF("DEBUG: Before switch: _param1=%d, _param2=%d, _param3=%d\n", _param1, _param2, _param3);

    // X? l? theo lo?i l?nh (_cmd_type)
    switch (_cmd_type) {
        case 0: // Charge config: mong d?i c? key "current_limit" v? "enable"
            handle_charge_config(handler, &_dataParser, _id);
            break;
        case 1: // Discharge config: mong d?i c? key "current_limit" v? "enable"
            handle_discharge_config(handler, &_dataParser, _id);
            break;
        case 2: // Lifter config: mong d?i c? key "target_position" v? "enable"
            handle_lifter_config(handler, &_dataParser, _id);
            break;
        case 3: // Motor config: mong d?i c? key "direction", "speed" v? "enable"
            handle_motorDC_config(handler, &_dataParser, _id);
            break;
        default:
            // N?u kh?ng nh?n di?n du?c lo?i l?nh, b?o l?i
            sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", _id);
            break;
    }

    // Debug: Th?ng b?o ho?n th?nh x? l? l?nh
  //  DebugUART_Send_Text(" \n Xu ly xong lenh \n");
}


/*
    Ham CommandHandler_Execute: thuc thi lenh
    - Neu lenh bat dau bang '>' thi xu ly che do JSON
    - Nguoc lai, xu ly che do text dua tren command_table
*/
void CommandHandler_Execute(CommandHandler *handler, const char *cmd) {
    int found = 0;
    int i = 0;
    // Ki?m tra con tr? null
    if (handler == NULL) {
        DEBUG_PRINT("CH DEBUG: Handler pointer is NULL. Exiting.\n");
        return;
    }
    if (cmd == NULL) {
        DEBUG_PRINT("CH DEBUG: Command string is NULL. Exiting.\n");
        return;
    }

//    DEBUG_PRINT("CH DEBUG: Entering CommandHandler_Execute.\n");

    // Kh?i t?o CommandHandler
//    DEBUG_PRINT("CH DEBUG: Initializing CommandHandler.\n");
    //CommandHandler_Init(handler);

/*DEBUG_PRINT("CH DEBUG: Received command: ");
    DEBUG_PRINT(cmd);
    DEBUG_PRINT("\n");*/

    // N?u l?nh b?t d?u b?ng '>', xem nhu l? l?nh JSON
    if (cmd[0] == '>') {
//        DEBUG_PRINT("CH DEBUG: Command starts with '>', treating as JSON command.\n");
        CommandHandler_ParseJSON(handler, cmd);
//       DEBUG_PRINT("CH DEBUG: JSON command parsed. Preparing response.\n");
        CommandHandler_Respond(handler);
//        DEBUG_PRINT("CH DEBUG: Response sent. Exiting CommandHandler_Execute.\n");
        return;
    } else {
//        DEBUG_PRINT("CH DEBUG: Command is non-JSON. Setting handler->command_name.\n");
        // N?u command_name l? m?ng, s? d?ng strcpy thay v? g?n tr?c ti?p.
        strcpy(handler->command_name, cmd);
    }


    // N?u kh?ng t?m th?y l?nh ph? h?p, x? l? l?nh kh?ng x?c d?nh
    if (!found) {
//        DEBUG_PRINT("CH DEBUG: No matching command found. Executing unknown command handler.\n");
        handle_unknown_command(handler);
    }

    // G?i ph?n h?i
//    DEBUG_PRINT("CH DEBUG: Sending response.\n");
    CommandHandler_Respond(handler);
//    DEBUG_PRINT("CH DEBUG: Exiting CommandHandler_Execute.\n");
}




/* ========== Battery ========== */
void handle_get_bat_info(CommandHandler *handler) {
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":0,\"data\":{\"current\":%d,\"temp\":%d,\"voltage\":%d,\"cell_voltages\":[%d,%d,%d,%d],\"percent\":%d,\"fault\":%d,\"health\":%d,\"status\":%d}}\r\n",
    (int)bms.get.packCurrent,(int) bms.get.tempAverage, (int)bms.get.packVoltage,
    (int)bms.get.cellVmV[0], (int)bms.get.cellVmV[1], (int)bms.get.cellVmV[2], bms.get.cellVmV[3],
    (int)bms.get.packSOC, (int)bms.errorCounter, (int) 90, (int)1);
}
// void handle_get_bat_current(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "BAT_CURRENT=%d\r\n",bms._sumCurrent);
// }
// void handle_get_bat_fault(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "BAT_FAULT=%d\r\n",bms._errorCount);
// }
// void handle_get_bat_health(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "BAT_HEALTH=%d\r\n", 0);
// }
// void handle_get_bat_soc(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "BAT_SOC=%d\r\n",bms._sumSOC);
// }
// void handle_get_bat_status(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "BAT_STATUS=%d\r\n",0);
// }
// void handle_get_bat_temp(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "BAT_TEMP=%d\r\n",bms._temperature);
// }
// void handle_get_bat_volt(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "BAT_VOLT=%d\r\n",bms._sumVoltage);
// }
// void handle_get_cell_volt(CommandHandler *handler) {
//     sprintf(handler->response_buffer, "CELL_VOLT=[%d,%d,%d,%d]\r\n",
//     bms._cellVoltages[0], bms._cellVoltages[1], bms._cellVoltages[2], 0);
// }

/* ========== Charging ========== */
void handle_get_chg_info(CommandHandler *handler){
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":1,\"data\":{\"current_limit\":%d,\"enabled\":%d}}\r\n",
    (int) 1, (int) bms.get.chargeFetState);
}
void handle_get_chg_cur_lim(CommandHandler *handler) {
    sprintf(handler->response_buffer, "CHG_CUR_LIM=3000\r\n");
}
void handle_set_chg_cur_lim(CommandHandler *handler) {
    sprintf(handler->response_buffer, "CHG_CUR_LIM set to %d\r\n", handler->command_value);
}
void handle_get_chg_en(CommandHandler *handler) {
    sprintf(handler->response_buffer, "CHG_EN=1\r\n");
}
void handle_set_chg_en(CommandHandler *handler) {
    sprintf(handler->response_buffer, "CHG_EN set to %d\r\n", handler->command_value);
}
void handle_get_dis_info(CommandHandler *handler){
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":2,\"data\":{\"current_limit\":%d,\"enabled\":%d}}\r\n",
    (int) 1, (int) bms.get.chargeDischargeStatus);
}
void handle_get_dis_cur_lim(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DIS_CUR_LIM=5000\r\n");
}
void handle_set_dis_cur_lim(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DIS_CUR_LIM set to %d\r\n", handler->command_value);
}
void handle_get_dis_en(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DIS_EN=1\r\n");
}
void handle_set_dis_en(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DIS_EN set to %d\r\n", handler->command_value);
}

/* ========== Digital Inputs ========== */
void handle_get_di1(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DI1=0\r\n");
}
void handle_get_di2(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DI2=1\r\n");
}
void handle_get_di3(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DI3=0\r\n");
}

/* ========== Distance Sensors ========== */
void handle_get_dist_info(CommandHandler *handler){
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":3,\"data\":{\"front\":%d,\"back\":%d,\"down\":%d}}\r\n",
    (int)sensor_front.distance_cm, (int)sensor_rear.distance_cm, (int)sensor_lifter.distance_cm);
}
void handle_get_down_dist(CommandHandler *handler) {
    sprintf(handler->response_buffer, "DOWN_DIST=30\r\n");
}
void handle_get_front_dist(CommandHandler *handler) {
    sprintf(handler->response_buffer, "FRONT_DIST=100\r\n");
}
void handle_get_rear_dist(CommandHandler *handler) {
    sprintf(handler->response_buffer, "REAR_DIST=120\r\n");
}
void handle_get_up_dist(CommandHandler *handler) {
    sprintf(handler->response_buffer, "UP_DIST=50\r\n");
}

/* ========== Identification ========== */
void handle_get_auto_mode(CommandHandler *handler) {
    sprintf(handler->response_buffer, "AUTO_MODE=1\r\n");
}
void handle_set_auto_mode(CommandHandler *handler) {
    sprintf(handler->response_buffer, "AUTO_MODE set to %d\r\n", handler->command_value);
}

/* ========== Lifter ========== */
void handle_get_lifter_info(CommandHandler *handler){
    if(lifter._output > 0 && lifter._status == 1){
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":4,\"data\":{\"current_position\":%d,\"target_position\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
    (int)lifter._currentPosition,(int) lifter._targetPosition, 1 ,lifter._status);
    }
    else if(lifter._status == 0) {
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":4,\"data\":{\"current_position\":%d,\"target_position\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
    (int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
    }
    else {
        sprintf(handler->response_buffer,
        ">{\"type\":0,\"state_type\":4,\"data\":{\"current_position\":%d,\"target_position\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
        (int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
    }
}
void handle_get_lifter_dir(CommandHandler *handler) {
    sprintf(handler->response_buffer, "LIFTER_DIR=1\r\n");
}
void handle_set_lifter_dir(CommandHandler *handler) {
    sprintf(handler->response_buffer, "LIFTER_DIR set to %d\r\n", handler->command_value);
}
void handle_get_lifter_lim_down(CommandHandler *handler) {
    sprintf(handler->response_buffer, "LIFTER_LIM_DOWN=0\r\n");
}
void handle_get_lifter_lim_up(CommandHandler *handler) {
    sprintf(handler->response_buffer, "LIFTER_LIM_UP=0\r\n");
}
void handle_get_lifter_speed(CommandHandler *handler) {
    sprintf(handler->response_buffer, "LIFTER_SPEED=200\r\n");
}
void handle_set_lifter_speed(CommandHandler *handler) {
    sprintf(handler->response_buffer, "LIFTER_SPEED set to %d\r\n", handler->command_value);
}
void handle_get_lifter_status(CommandHandler *handler) {
    sprintf(handler->response_buffer, "LIFTER_STATUS=1\r\n");
}

/* ========== Motor ========== */     //chinh lai target speed thanh current speed
void handle_get_motor_info(CommandHandler *handler){
    //if(_MotorDC_GetCurrentSpeed(&motorDC) > 0 && _MotorDC_GetStatus(&motorDC) == 1)
    /*if(_MotorDC_GetStatus(&motorDC) == 1)
    {
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
    _MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 1 ,_MotorDC_GetStatus(&motorDC));
    }
    else if(_MotorDC_GetStatus(&motorDC) == 0) {
    sprintf(handler->response_buffer,
    ">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
    _MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
    }*/
    if (_MotorDC_GetStatus(&motorDC) == 0){
       sprintf(handler->response_buffer,
       ">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
       _MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
    }
    else if (_MotorDC_GetStatus(&motorDC) == 1 && (int)_MotorDC_GetCurrentSpeed(&motorDC) < 10){
       sprintf(handler->response_buffer,
       ">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
       _MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
    }
    else{
       sprintf(handler->response_buffer,
       ">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
       _MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 1 ,_MotorDC_GetStatus(&motorDC));
    }
}
void handle_get_motor_dir(CommandHandler *handler) {
    // L?y hu?ng quay c?a d?ng co t? module MotorDC v? tr? v? gi? tr? (0: FORWARD, 1: REVERSE)
    sprintf(handler->response_buffer, "MOTOR_DIR=%d\r\n", _MotorDC_GetDirection(&motorDC));
}

void handle_set_motor_dir(CommandHandler *handler) {
    // Ki?m tra gi? tr? truy?n v?o, ch? ch?p nh?n 0 ho?c 1
    if (handler->command_value == 0 || handler->command_value == 1) {
        _MotorDC_SetDirection(&motorDC, (MotorDirection)handler->command_value);
        sprintf(handler->response_buffer, "MOTOR_DIR set to %d\r\n", handler->command_value);
    } else {
        sprintf(handler->response_buffer, "Invalid MOTOR_DIR value: %d\r\n", handler->command_value);
    }
}

void handle_get_motor_en(CommandHandler *handler) {
    // Tr? v? tr?ng th?i b?t/t?t c?a d?ng co (0: disabled, 1: enabled)
    sprintf(handler->response_buffer, "MOTOR_EN=%d\r\n", _MotorDC_GetStatus(&motorDC));
}

void handle_set_motor_en(CommandHandler *handler) {
sprintf(handler->response_buffer, "MOTOR_EN set to %d\r\n", handler->command_value);
   /*// Cho ph?p b?t (1) ho?c t?t (0) d?ng co
    if (handler->command_value == 1) {
        _MotorDC_Enable(&motor);
        sprintf(handler->response_buffer, "MOTOR_EN set to %d\r\n", handler->command_value);
    } else if (handler->command_value == 0) {
        _MotorDC_Disable(&motor);
        sprintf(handler->response_buffer, "MOTOR_EN set to %d\r\n", handler->command_value);
    } else {
        sprintf(handler->response_buffer, "Invalid MOTOR_EN value: %d\r\n", handler->command_value);
    }*/
}

void handle_get_motor_speed(CommandHandler *handler) {
    // L?y t?c d? m?c ti?u hi?n t?i c?a d?ng co (d?ng float, nhung hi?n th? l?m s? th?c 2 ch? s? th?p ph?n)
    sprintf(handler->response_buffer, "MOTOR_SPEED=%.2f\r\n", _MotorDC_GetTargetSpeed(&motorDC));
}

void handle_set_motor_speed(CommandHandler *handler) {
    // ??t t?c d? m?c ti?u cho d?ng co d?a tr?n gi? tr? nh?n du?c t? l?nh
    _MotorDC_SetTargetSpeed(&motorDC, handler->command_value);
    sprintf(handler->response_buffer, "MOTOR_SPEED set to %d\r\n", handler->command_value);
}




/* ========== Relay ========== */
void handle_get_relay1(CommandHandler *handler) {
    sprintf(handler->response_buffer, "RELAY1=1\r\n");
}
void handle_set_relay1(CommandHandler *handler) {
    sprintf(handler->response_buffer, "RELAY1 set to %d\r\n", handler->command_value);
}
void handle_get_relay2(CommandHandler *handler) {
    sprintf(handler->response_buffer, "RELAY2=0\r\n");
}
void handle_set_relay2(CommandHandler *handler) {
    sprintf(handler->response_buffer, "RELAY2 set to %d\r\n", handler->command_value);
}

/* ========== RFID ========== */
void handle_get_rfid_err(CommandHandler *handler) {
    sprintf(handler->response_buffer, "RFID_ERR=0\r\n");
}
void handle_get_rfid_cur_loc(CommandHandler *handler) {
    sprintf(handler->response_buffer, "RFID_CUR_LOC=Null\r\n");
}
void handle_get_rfid_tar_loc(CommandHandler *handler) {
    sprintf(handler->response_buffer, "RFID_TAR_LOC=Null\r\n");
}

/* ========== Robot ========== */
void handle_get_fw_ver(CommandHandler *handler) {
    sprintf(handler->response_buffer, "FW_VER=%s\r\n"),FW_VER;
}
void handle_get_robot_model(CommandHandler *handler) {
    sprintf(handler->response_buffer, "ROBOT_MODEL=%s\r\n",ROBOT_MODEL);
}
void handle_get_robot_id(CommandHandler *handler) {
    sprintf(handler->response_buffer, "ROBOT_ID=%s\r\n", DEVICE_ID);
}

void handle_get_robot_serial(CommandHandler *handler) {
    sprintf(handler->response_buffer, "ROBOT_SERIAL=%s\r\n", DEVICE_SERIAL);
}

/* ========== Sensors ========== */
void handle_get_safe_sensor_front(CommandHandler *handler) {
    sprintf(handler->response_buffer, "SAFE_SENSOR_FRONT=1\r\n");
}
void handle_get_safe_sensor_rear(CommandHandler *handler) {
    sprintf(handler->response_buffer, "SAFE_SENSOR_REAR=0\r\n");
}

void handle_get_update_status(CommandHandler *handler){
    sprintf(handler->response_buffer, "UPDATE_TASK_STATUS =% d\r\n",task_get_status(_task_update_to_server));
}
void handle_set_update_status(CommandHandler *handler){
   sprintf(handler->response_buffer, "SAFE_SENSOR_REAR=0\r\n");
   if (handler->command_value == 1) {
        task_resume(_task_update_to_server);
        sprintf(handler->response_buffer, "UPDATE_TASK_STATUS ON\r\n");
    } else if (handler->command_value == 0) {
        task_stop(_task_update_to_server);
        sprintf(handler->response_buffer, "UPDATE_TASK_STATUS OFF\r\n");
    }
}

void handle_charge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
    int current_limit, enable;
    if (JSON_GetInt(dataParser, "current_limit", &current_limit) &&
        JSON_GetInt(dataParser, "enable", &enable)) {
        //bms._charge_current_limit = current_limit;
        if (enable == 0)
            DalyBms_setChargeMOS(&bms, 0);
        else if (enable == 1)
            DalyBms_setChargeMOS(&bms, 1);
        else {
            sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
            return;
        }
        sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
    } else {
        sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
    }
}


void handle_discharge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
    int current_limit, enable;
    if (JSON_GetInt(dataParser, "current_limit", &current_limit) &&
        JSON_GetInt(dataParser, "enable", &enable)) {
        //bms._discharge_current_limit = current_limit;
        if (enable == 0)
            DalyBms_setDischargeMOS(&bms, 0);
        else if (enable == 1)
            DalyBms_setDischargeMOS(&bms, 1);
        else {
            sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
            return;
        }
        sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
    } else {
        sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
    }
}

void handle_lifter_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
     char strdata;
     int target_position, enable, max_output;
     if (JSON_GetInt(dataParser, "target_position", &target_position) &&
        JSON_GetInt(dataParser, "max_output", &max_output) &&
        JSON_GetInt(dataParser, "enable", &enable)) {
      /*sprintf(strdata, "{\"TargetPos\": %d, \"Enable\": %d}", target_position, enable);
        DebugUART_Send_Text("KLDebug strdata -" );
        DebugUART_Send_Text(strdata);
        DebugUART_Send_Text("\n");*/
        _Lifter_SetTargetPosition(&lifter, target_position);
        if (max_output > 100 || max_output < 0)
            sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
        else {
             _Lifter_Set_maxOutput(&lifter, max_output);
        }
        if (enable == 0)
            _Lifter_Disable(&lifter);
        else if (enable == 1)
            _Lifter_Enable(&lifter);
        else {
            sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
            _Lifter_Disable(&lifter);
            return;
        }
        sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
    }
    else if (JSON_GetInt(dataParser, "target_position", &target_position) &&
        JSON_GetInt(dataParser, "enable", &enable)) {
       /*sprintf(strdata, "{\"TargetPos\": %d, \"Enable\": %d}", target_position, enable);
        DebugUART_Send_Text("KLDebug strdata -" );
        DebugUART_Send_Text(strdata);
        DebugUART_Send_Text("\n");*/
        _Lifter_SetTargetPosition(&lifter, target_position);
        if (enable == 0)
            _Lifter_Disable(&lifter);
        else if (enable == 1)
            _Lifter_Enable(&lifter);
        else {
            sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
            _Lifter_Disable(&lifter);
            return;
        }
        sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
    }
    else {

        sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
        }
}

void handle_motorDC_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
     int direction, speed, enable;
      if (JSON_GetInt(dataParser, "direction", &direction) &&
          JSON_GetInt(dataParser, "speed", &speed) &&
          JSON_GetInt(dataParser, "enable", &enable)) {
         if (direction == 0 || direction == 1)
              _MotorDC_SetDirection(&motorDC, direction);
          else {
              sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
              return;
          }
          // ddieeuf ien speed
          _MotorDC_SetTargetSpeed(&motorDC, speed);
          if (enable == 1){
              _MotorDC_Enable(&motorDC);
          }
              
          else if (enable == 0){
              //_MotorDC_Disable(&motorDC);
              _MotorDC_Disable(&motorDC);
          }
          else {
              sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
              return;
          }
          sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
          //DebugUART_Send_Text("CHDEBUG: da xu ly o day")  ;
      } else {
          sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
          
      }
}

void handle_ping_command(CommandHandler *handler, JSON_Parser *dataParser, char *id){
     int type;
     if (JSON_GetInt(dataParser, "type", &type)){
        if (type == 4){
           sprintf(handler->response_buffer, ">{\"type\":4,\"id\":\"%s\",\"dev_id\":\"pic\"}\r\n", id);
           return;
        }
     }
     else return;
}
void handle_get_box_status(CommandHandler *handler){
    sprintf(handler->response_buffer, ">{\"type\":0,\"state_type\":7,\"data\":{\"object\":%d}}\r\n",
    (int) Box_t.limit_switch_state);
}