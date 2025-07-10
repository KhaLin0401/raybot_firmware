#line 1 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
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
#line 1 "d:/mikroc pro for dspic/include/string.h"





void * memchr(void *p, char n, unsigned int v);
int memcmp(void *s1, void *s2, int n);
void * memcpy(void * d1, void * s1, int n);
void * memmove(void * to, void * from, int n);
void * memset(void * p1, char character, int n);
char * strcat(char * to, char * from);
char * strchr(char * ptr, char chr);
int strcmp(char * s1, char * s2);
char * strcpy(char * to, char * from);
int strlen(char * s);
char * strncat(char * to, char * from, int size);
char * strncpy(char * to, char * from, int size);
int strspn(char * str1, char * str2);
char strcspn(char * s1, char * s2);
int strncmp(char * s1, char * s2, char len);
char * strpbrk(char * s1, char * s2);
char * strrchr(char *ptr, char chr);
char * strstr(char * s1, char * s2);
char * strtok(char * s1, char * s2);
#line 13 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
typedef struct {

 float _sumVoltage;
 float _sumCurrent;
 float _sumSOC;


 float _maxCellVoltage;
 float _cellVoltages[4];

 float _minCellVoltage;


 float _temperature;
 int _cycleCount;
 uint8_t _protectionFlags;
 float _performance;
 float _backup;


 int _cellCount;
 float _remainingCapacity;
 float _totalCapacity;
 float _highVoltageProtection;
 float _lowVoltageProtection;
 int _ntcCount;
 float *_ntcTemperatures;
 int _counter;
 uint8_t _errorCode;
 uint8_t _chargeMOS;
 uint8_t _dischargeMOS;
 uint8_t *_balanceStatus;
 int _errorCount;
 uint8_t _hardwareVersion;
 uint8_t _softwareVersion;
 char *_manufacturer;
 uint8_t _charge_current_limit;
 uint8_t _discharge_current_limit;
} BMSData;





void _updateMinMaxCellVoltage(BMSData *bmsData);

extern BMSData _bmsData;






typedef struct {
 uint8_t _commandID;
 uint8_t _payload[8];
} TXCommand;
extern TXCommand _txBuffer[ 10 ];
extern volatile uint8_t _txBufferHead;
extern volatile uint8_t _txBufferTail;
void TX_PushCommand(uint8_t _commandID, uint8_t * _payload);
uint8_t TX_IsEmpty(void);
TXCommand TX_PopCommand(void);





extern uint8_t _rxBuffer[ 50 ];
extern volatile uint8_t _rxBufferHead;
extern volatile uint8_t _rxBufferTail;
void RX_PushByte(uint8_t _data);
int RX_PopBytes(uint8_t * _buffer, uint16_t _length);
int RX_PeekBytes(uint8_t * _buffer, uint16_t _length);





typedef struct {
 uint8_t _commandID;
 uint8_t _payload[7];
 uint8_t _value;
} ImmediateCommand;
extern ImmediateCommand _immediateQueue[ 10 ];
extern volatile uint8_t _immediateQueueHead;
extern volatile uint8_t _immediateQueueTail;
void Immediate_PushCommand(uint8_t _commandID, uint8_t * _payload, uint8_t _value);
uint8_t Immediate_IsEmpty(void);
ImmediateCommand Immediate_PopCommand(void);




void BMS_Init(void);
void BMS_Update(void);


void BMS_SendCommandImmediate(uint8_t _commandID, uint8_t * _payload, uint8_t _value);


void BMS_PushCommand(uint8_t _commandID, uint8_t * _payload);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/robot_system.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 10 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
typedef struct {

 char _rx_stack[ 15 ][ 180 ];
 volatile uint8_t _rx_head;
 volatile uint8_t _rx_tail;


 char _tx_stack[ 10 ][ 180 ];
 volatile uint8_t _tx_head;
 volatile uint8_t _tx_tail;


 char _temp_rx_buffer[ 180 ];
 volatile uint8_t _temp_index;
} _UART2_Object;

extern _UART2_Object _uart2;


void _UART2_Init(void);
#line 34 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
void _UART2_SendPush(const char *text);


int _UART2_SendBlocking(const char *text);
#line 41 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
uint8_t _UART2_SendProcess(void);
#line 46 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
uint8_t _UART2_Rx_GetCommand(char *out_cmd);
#line 51 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
void _UART2_Rx_Receive_ISR(void);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/schedule_task.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 12 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/schedule_task.h"
extern uint8_t _task_uart;
extern uint8_t _task_update_system;
extern uint8_t _task_update_motor;
extern uint8_t _task_update_to_server;
extern uint8_t _task_respond_Init;
extern uint8_t _task_update_BMS;


void _F_schedule_init(void);
void _F_process_uart_command(void);
void _F_update_system_status(void);
void _F_update_to_server(void);
void _F_respond_to_server(void);
void Respond_Init();
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/distance_sensor.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 10 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/distance_sensor.h"
typedef enum {
 SENSOR_GP2Y0A21YK0F,
 SENSOR_GP2Y0A02YK0F
} SensorType;


typedef struct {
 uint16_t readings[ 10 ];
 uint16_t filtered_value;
 float distance_cm;
 uint8_t index;
 float calib;
 uint8_t adc_channel;
 SensorType sensor_type;
} DistanceSensor;


void DistanceSensor_Init(DistanceSensor *sensor, uint8_t channel, SensorType type);


void DistanceSensor_Update(DistanceSensor *sensor);


uint16_t DistanceSensor_GetValue(DistanceSensor *sensor);


float DistanceSensor_GetDistanceCM(DistanceSensor *sensor);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/command_handler.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 1 "d:/mikroc pro for dspic/include/string.h"
#line 1 "d:/mikroc pro for dspic/include/stdio.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/robot_system.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motorcontrol.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 27 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motorcontrol.h"
typedef struct {
 uint16_t speed;
 uint16_t target_speed;
 uint8_t direction;
 uint8_t enabled;
 int16_t front_distance;
 uint16_t Pwm_period_max;
 uint16_t Pwm_period_speed;


 int16_t error;
 int16_t last_error;
 int16_t integral;
 int16_t derivative;
 float Kp;
 float Ki;
 float Kd;


 void (*update)(void*);
 void (*set_speed)(void*, uint16_t);
 void (*set_target_speed)(void*, uint16_t);
 void (*set_direction)(void*, uint8_t);
 void (*enable)(void*, uint8_t);
 void (*pid_control)(void*);
 void (*pwm_update)(void*);
 void (*brake_control)(void*);
} MotorControl;


void MotorControl_Init(MotorControl* motor);


void MotorControl_SafeSetSpeed(MotorControl *motor, uint16_t speed);
void MotorControl_SafeSetTargetSpeed(MotorControl *motor, uint16_t target_speed);
void MotorControl_SafeSetDirection(MotorControl *motor, uint8_t direction);
void MotorControl_SafeEnable(MotorControl *motor, uint8_t enable);


void update_motor(void* self);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/json_parser.h"
#line 1 "d:/mikroc pro for dspic/include/stddef.h"



typedef int ptrdiff_t;
typedef unsigned int size_t;
typedef unsigned int wchar_t;
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 7 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/json_parser.h"
typedef struct {
 const char *json;
} JSON_Parser;


void JSON_Init(JSON_Parser *parser, const char *json);
#line 16 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/json_parser.h"
int JSON_GetInt(JSON_Parser *parser, const char *key, int *value);


int JSON_ContainsKey(JSON_Parser *parser, const char *key);
#line 24 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/json_parser.h"
int JSON_GetString(JSON_Parser *parser, const char *key, char *out, size_t out_size);
#line 30 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/json_parser.h"
int JSON_GetObject(JSON_Parser *parser, const char *key, char *out, size_t out_size);
#line 30 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/command_handler.h"
typedef struct {
 char command_name[32];
 int command_value;
 char response_buffer[128];
 uint8_t is_valid;
 char id[32];
} CommandHandler;


extern CommandHandler cmdHandler;


void CommandHandler_Init(CommandHandler *handler);
void CommandHandler_ParseCommand(CommandHandler *handler, const char *cmd);
void CommandHandler_Execute(CommandHandler *handler, const char *cmd);
void CommandHandler_Respond(CommandHandler *handler);
void handle_unknown_command(CommandHandler *handler);
void CommandHandler_ParseJSON(CommandHandler *handler, const char *cmd);
static void strip_newline(char *str);
#line 55 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/command_handler.h"
void handle_get_bat_info(CommandHandler *handler);
void handle_get_bat_current(CommandHandler *handler);
void handle_get_bat_fault(CommandHandler *handler);
void handle_get_bat_health(CommandHandler *handler);
void handle_get_bat_soc(CommandHandler *handler);
void handle_get_bat_status(CommandHandler *handler);
void handle_get_bat_temp(CommandHandler *handler);
void handle_get_bat_volt(CommandHandler *handler);
void handle_get_cell_volt(CommandHandler *handler);


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


void handle_get_di1(CommandHandler *handler);
void handle_get_di2(CommandHandler *handler);
void handle_get_di3(CommandHandler *handler);


void handle_get_dist_info(CommandHandler *handler);
void handle_get_down_dist(CommandHandler *handler);
void handle_get_front_dist(CommandHandler *handler);
void handle_get_rear_dist(CommandHandler *handler);
void handle_get_up_dist(CommandHandler *handler);


void handle_get_auto_mode(CommandHandler *handler);
void handle_set_auto_mode(CommandHandler *handler);


void handle_get_lifter_info(CommandHandler *handler);
void handle_get_lifter_dir(CommandHandler *handler);
void handle_set_lifter_dir(CommandHandler *handler);
void handle_get_lifter_lim_down(CommandHandler *handler);
void handle_get_lifter_lim_up(CommandHandler *handler);
void handle_get_lifter_speed(CommandHandler *handler);
void handle_set_lifter_speed(CommandHandler *handler);
void handle_get_lifter_status(CommandHandler *handler);


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


void handle_get_relay1(CommandHandler *handler);
void handle_set_relay1(CommandHandler *handler);
void handle_get_relay2(CommandHandler *handler);
void handle_set_relay2(CommandHandler *handler);


void handle_get_rfid_err(CommandHandler *handler);
void handle_get_rfid_cur_loc(CommandHandler *handler);
void handle_get_rfid_tar_loc(CommandHandler *handler);


void handle_get_fw_ver(CommandHandler *handler);
void handle_get_robot_model(CommandHandler *handler);
void handle_get_robot_id(CommandHandler *handler);
void handle_get_robot_serial(CommandHandler *handler);


void handle_get_safe_sensor_front(CommandHandler *handler);
void handle_get_safe_sensor_rear(CommandHandler *handler);


void handle_unknown_command(CommandHandler *handler);


void strip_newline(char *str);


void handle_get_update_status(CommandHandler *handler);
void handle_set_update_status(CommandHandler *handler);

void handle_charge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_discharge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_lifter_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_motorDC_config(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_ping_command(CommandHandler *handler, JSON_Parser *dataParser, char *id);
void handle_get_box_status(CommandHandler *handler);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
#line 53 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
typedef enum {
 MOTOR_DIRECTION_FORWARD = 0,
 MOTOR_DIRECTION_REVERSE = 1
} MotorDirection;

typedef enum {
 MOTOR_STATUS_DISABLED = 0,
 MOTOR_STATUS_ENABLED = 1
} MotorStatus;
#line 80 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
typedef struct _MotorDC {

 float _kp;
 float _ki;
 float _kd;
 float _targetSpeed;
 float _currentSpeed;


 float _error;
 float _lastError;
 float _integral;
 float _output;


 float _distanceSensorValue;


 float _accelerationLimit;
 float _decelerationLimit;


 float _safeDistance;


 float _maxDuty;


 int _direction;
 int _status;


 void (*Update)(struct _MotorDC *motor);
} _MotorDC;

extern _MotorDC motorDC;
#line 134 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_Init(_MotorDC *motor, float kp, float ki, float kd, float targetSpeed);
#line 142 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_SetTargetSpeed(_MotorDC *motor, float targetSpeed);
#line 151 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_SetDirection(_MotorDC *motor, MotorDirection direction);
#line 159 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_Enable(_MotorDC *motor);
#line 167 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_Disable(_MotorDC *motor);
#line 176 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_Disable_Emergency(_MotorDC *motor);

MotorStatus _MotorDC_GetStatus(_MotorDC *motor);
#line 186 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_SetAccelerationLimit(_MotorDC *motor, float accLimit);
#line 194 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_SetDecelerationLimit(_MotorDC *motor, float decLimit);
#line 202 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_SetSafeDistance(_MotorDC *motor, float safeDistance);
#line 210 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_SetMaxDuty(_MotorDC *motor, unsigned int maxDuty);
#line 215 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_Set_Idle(_MotorDC *motor);
#line 222 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_UpdatePID(_MotorDC *motor);
#line 227 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
void _MotorDC_Update(_MotorDC *motor);
#line 236 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
float _MotorDC_GetTargetSpeed(_MotorDC *motor);
#line 241 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
float _MotorDC_GetCurrentSpeed(_MotorDC *motor);
#line 246 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
float _MotorDC_GetAccelerationLimit(_MotorDC *motor);
#line 251 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
float _MotorDC_GetDecelerationLimit(_MotorDC *motor);
#line 256 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
float _MotorDC_GetSafeDistance(_MotorDC *motor);
#line 261 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
unsigned int _MotorDC_GetMaxDuty(_MotorDC *motor);
#line 266 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
MotorDirection _MotorDC_GetDirection(_MotorDC *motor);
#line 271 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
float _MotorDC_GetOutput(_MotorDC *motor);
#line 276 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
float _MotorDC_GetDistanceSensorValue(_MotorDC *motor);
#line 286 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
char* _MotorDC_GetInfo(_MotorDC *motor);
#line 29 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/robot_system.h"
extern char DEVICE_ID[16];
extern char DEVICE_SERIAL[16];
extern char ROBOT_MODEL[16];
extern char FW_VER[16];


extern DistanceSensor sensor_front;
extern DistanceSensor sensor_rear;
extern DistanceSensor sensor_lifter;
extern DistanceSensor sensor_box;

void init_distance_sensors();
void update_all_sensors();



void DebugUART_Init();
void DebugUART_Send_Text(const char *text);
#line 7 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
BMSData _bmsData;




TXCommand _txBuffer[ 10 ];
volatile uint8_t _txBufferHead = 0;
volatile uint8_t _txBufferTail = 0;


void TX_PushCommand(uint8_t _commandID, uint8_t * _payload) {
 int _next = (_txBufferHead + 1) %  10 ;
 if (_next != _txBufferTail) {
 _txBuffer[_txBufferHead]._commandID = _commandID;
 memcpy(_txBuffer[_txBufferHead]._payload, _payload, 8);
 _txBufferHead = _next;
 }
}

uint8_t TX_IsEmpty(void) {
 return (_txBufferHead == _txBufferTail);
}

TXCommand TX_PopCommand(void) {
 TXCommand _cmd;
 memset(&_cmd, 0, sizeof(TXCommand));
 if (_txBufferHead != _txBufferTail) {
 memcpy(&_cmd, &_txBuffer[_txBufferTail], sizeof(TXCommand));
 _txBufferTail = (_txBufferTail + 1) %  10 ;
 }
 return _cmd;
}




ImmediateCommand _immediateQueue[ 10 ];
volatile uint8_t _immediateQueueHead = 0;
volatile uint8_t _immediateQueueTail = 0;

void Immediate_PushCommand(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
#line 54 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
 int _next = (_immediateQueueHead + 1) %  10 ;

 if (_next != _immediateQueueTail) {
 _immediateQueue[_immediateQueueHead]._commandID = _commandID;
 memcpy(_immediateQueue[_immediateQueueHead]._payload, _payload, 7);
 _immediateQueue[_immediateQueueHead]._value = _value;
 _immediateQueueHead = _next;
 } else {

 DebugUART_Send_Text("Immediate Queue Full!\r\n");
 }
}

uint8_t Immediate_IsEmpty(void) {
 return (_immediateQueueHead == _immediateQueueTail);
}

ImmediateCommand Immediate_PopCommand(void) {
#line 79 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
 ImmediateCommand _cmd;
 char debug_cmd[30];
 memset(&_cmd, 0, sizeof(ImmediateCommand));


 if (_immediateQueueHead != _immediateQueueTail) {
 memcpy(&_cmd, &_immediateQueue[_immediateQueueTail], sizeof(ImmediateCommand));
 _immediateQueueTail = (_immediateQueueTail + 1) %  10 ;
 }
 DebugUART_Send_Text("chdebug da nhay vao day \n");
 sprintf(debug_cmd, "CMDID: %d, CMDVL: %d", _cmd._commandID, _cmd._value);
 DebugUART_Send_Text("\n");
 return _cmd;
}




uint8_t _rxBuffer[ 50 ];
volatile uint8_t _rxBufferHead = 0;
volatile uint8_t _rxBufferTail = 0;

void RX_PushByte(uint8_t _data) {
 int _next = (_rxBufferHead + 1) %  50 ;
 if (_next != _rxBufferTail) {
 _rxBuffer[_rxBufferHead] = _data;
 _rxBufferHead = _next;
 }
}

int RX_PopBytes(uint8_t * _buffer, uint16_t _length) {
 uint16_t _available;
 if (_rxBufferHead >= _rxBufferTail)
 _available = _rxBufferHead - _rxBufferTail;
 else
 _available =  50  - _rxBufferTail + _rxBufferHead;
 if (_available < _length)
 return 0;
 {
 uint16_t _i;
 for (_i = 0; _i < _length; _i++) {
 _buffer[_i] = _rxBuffer[_rxBufferTail];
 _rxBufferTail = (_rxBufferTail + 1) %  50 ;
 }
 }
 return _length;
}

int RX_PeekBytes(uint8_t * _buffer, uint16_t _length) {
 uint16_t _available;
 if (_rxBufferHead >= _rxBufferTail)
 _available = _rxBufferHead - _rxBufferTail;
 else
 _available =  50  - _rxBufferTail + _rxBufferHead;
 if (_available < _length)
 return 0;
 {
 uint16_t _i;
 uint8_t _idx = _rxBufferTail;
 for (_i = 0; _i < _length; _i++) {
 _buffer[_i] = _rxBuffer[_idx];
 _idx = (_idx + 1) %  50 ;
 }
 }
 return _length;
}




volatile uint8_t _txBusy = 0;






static uint8_t _getEndMarker(uint8_t _commandID) {
 if (_commandID >= 0x90 && _commandID <= 0x99)
 return 0x7D + (_commandID - 0x90);
 else if (_commandID == 0xD8)
 return 0xC5;
 else if (_commandID == 0xE3)
 return 0x58;
 else
 return 0x7D;
}





static void _sendCommandPacket(uint8_t _commandID, uint8_t * _payload) {
 uint8_t _packet[ 13 ];
 uint8_t _i;
 char _dbgStr[100] = "";


 _packet[0] = 0xA5;
 _packet[1] = 0x40;
 _packet[2] = _commandID;
 _packet[3] = 0x08;
 memcpy(&_packet[4], _payload, 8);
 _packet[12] = _getEndMarker(_commandID);


 for (_i = 0; _i <  13 ; _i++){
 UART1_Write(_packet[_i]);
 }


 for (_i = 0; _i <  13 ; _i++){
 char temp[10];
 sprintf(temp, "0x%02X ", _packet[_i]);
 strcat(_dbgStr, temp);
 }
 strcat(_dbgStr, "\r\n");

}
static void _sendSetCommandPacket(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
 uint8_t _packet[ 13 ];
 uint8_t _i;
 char _dbgStr[100] = "";


 _packet[0] = 0xA5;
 _packet[1] = 0x40;
 _packet[2] = _commandID;
 _packet[3] = 0x08;
 _packet[4] = _value;
 memcpy(&_packet[5], _payload, 7);
 if(_commandID == 0xD9){
 if(_value == 0x00)
 _packet[12] = 0xC6;
 else if (_value == 0x01)
 _packet[12] = 0xC7;
 else return;
 }
 else if(_commandID == 0xDA){
 if(_value == 0x00)
 _packet[12] = 0xC7;
 else if(_value == 0x01)
 _packet[12] = 0xC8;
 else return;
 }
 else {
 _packet[12] = _getEndMarker(_commandID);
 }

 for (_i = 0; _i <  13 ; _i++){
 UART1_Write(_packet[_i]);
 }


 for (_i = 0; _i <  13 ; _i++){
 char temp[10];
 sprintf(temp, "0x%02X ", _packet[_i]);
 strcat(_dbgStr, temp);
 }
 strcat(_dbgStr, "\r\n");
 DebugUART_Send_Text(_dbgStr);
}





static void _processReceivedResponsePacket(void) {

 uint8_t _temp[ 13 ];
 char _dbgStr[150];
 uint8_t _discard;
 uint8_t i,j = 0;
 uint16_t raw_value = 0;
 int16_t raw_signed = 0;
 uint8_t checksum = 0;
 char failCodeArr[] = "";


 if (RX_PeekBytes(_temp,  13 ) ==  13 ) {

 strcpy(_dbgStr, "Peeked Packet: ");
 for (i = 0; i <  13 ; i++) {
 char _byteStr[10];
 sprintf(_byteStr, "0x%02X ", _temp[i]);
 strcat(_dbgStr, _byteStr);
 }
 strcat(_dbgStr, "\r\n");



 if ((_temp[0] == 0xA5) && (_temp[1] == 0x01) &&
 (_temp[3] == 0x08) && (((_temp[2]) & 0xF0) == 0x90)) {




 RX_PopBytes(_temp,  13 );



 for (i = 0; i <  13  - 1; i++) {
 checksum += _temp[i];
 }

 if (checksum == _temp[ 13  - 1]) {

 switch (_temp[2]) {
 case 0x90: {





 raw_value = (((uint16_t)_temp[4]) << 8) | _temp[5];
 _bmsData._sumVoltage = raw_value / 10.0;

 raw_signed = ((((uint16_t)(_temp[8]) << 8) | (uint16_t)_temp[9]) / 10.0f) - 3000;
 _bmsData._sumCurrent = raw_signed;


 _bmsData._cellCount = 4;

 raw_value =(uint16_t)(_temp[10] << 8 | _temp[11]);
 _bmsData._sumSOC = (raw_value / 10.0f);




 break;
 }
 case 0x91: {




 raw_value = (((uint16_t)_temp[4]) << 8) | _temp[5];
 _bmsData._remainingCapacity = raw_value / 100.0;

 raw_value = (((uint16_t)_temp[6]) << 8) | _temp[7];
 _bmsData._totalCapacity = raw_value / 100.0;

 raw_value = (((uint16_t)_temp[8]) << 8) | _temp[9];
 _bmsData._cycleCount = raw_value;

 sprintf(_dbgStr, "Remaining Capacity: %.2f Ah, Total Capacity: %.2f Ah, Cycles: %d\r\n",
 _bmsData._remainingCapacity, _bmsData._totalCapacity, _bmsData._cycleCount);

 break;
 }
 case 0x92: {
#line 341 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
 raw_value = (uint16_t) ((((_temp[4]) - 40) + (( _temp[6]) - 40)) /2);
 _bmsData._temperature = raw_value;

 break;
 }
 case 0x93: {
#line 363 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
 _bmsData._chargeMOS = _temp[6];
 _bmsData._dischargeMOS = _temp[7];

 sprintf(_dbgStr, "Charge MOS: %s, Discharge MOS: %s\r\n",
 _bmsData._chargeMOS ? "ON" : "OFF",
 _bmsData._dischargeMOS ? "ON" : "OFF");
 DebugUART_Send_Text(_dbgStr);
 break;
 }
 case 0x94: {



 _bmsData._cellCount = _temp[4];
 _bmsData._ntcCount = _temp[5];

 sprintf(_dbgStr, "Cell Count: %d, NTC Count: %d\r\n",
 _bmsData._cellCount, _bmsData._ntcCount);

 break;
 }
 case 0x95: {







 for (j = 0; j < 3; j++){
 _bmsData._cellVoltages[j] = (_temp[5 + j + j] << 8) | _temp[6 + j + j];
 }

 _bmsData._cellVoltages[3] = (_bmsData._cellVoltages[0]
 + _bmsData._cellVoltages[1] + _bmsData._cellVoltages[2]) / 3;






 break;
 }
 case 0x96: {



 uint8_t cellIndex = _temp[4] - 1;
 if (cellIndex <  16 ) {
 raw_value = (((uint16_t)_temp[5]) << 8) | _temp[6];
 _bmsData._cellVoltages[cellIndex] = raw_value / 1000.0;

 sprintf(_dbgStr, "Cell %d Voltage: %.3f V\r\n",
 cellIndex + 1, _bmsData._cellVoltages[cellIndex]);



 if (cellIndex == _bmsData._cellCount - 1) {

 }
 }
 break;
 }
 case 0x97: {


 _bmsData._balanceStatus = _temp[4];

 sprintf(_dbgStr, "Balance Status: 0x%02X\r\n", _bmsData._balanceStatus);

 break;
 }
 case 0x98: {


 _bmsData._errorCount = _temp[4];

 sprintf(_dbgStr, "Error Count: %d\r\n", _bmsData._errorCount);

 break;
 }
 case 0x99: {




 _bmsData._hardwareVersion = (((uint16_t)_temp[4]) << 8) | _temp[5];
 _bmsData._softwareVersion = (((uint16_t)_temp[6]) << 8) | _temp[7];


 _bmsData._manufacturer[0] = _temp[10];
 _bmsData._manufacturer[1] = _temp[11];
 _bmsData._manufacturer[2] = '\0';

 sprintf(_dbgStr, "HW Version: 0x%04X, SW Version: 0x%04X, Manufacturer: %s\r\n",
 _bmsData._hardwareVersion, _bmsData._softwareVersion, _bmsData._manufacturer);

 break;
 }
 default:

 break;
 }
 } else {
 sprintf(_dbgStr, "Checksum Error! Calculated: 0x%02X, Received: 0x%02X\r\n",
 checksum, _temp[ 13  - 1]);

 }
 } else {

 sprintf(_dbgStr, "Invalid Packet Header: 0x%02X 0x%02X 0x%02X 0x%02X\r\n",
 _temp[0], _temp[1], _temp[2], _temp[3]);

 RX_PopBytes(&_discard, 1);
 }
 }
}


static void _updateMinMaxCellVoltage(void) {
 uint8_t i;


 _bmsData._minCellVoltage = _bmsData._cellVoltages[0];
 _bmsData._maxCellVoltage = _bmsData._cellVoltages[0];




 for (i = 1; i < _bmsData._cellCount; i++) {
 if (_bmsData._cellVoltages[i] < _bmsData._minCellVoltage) {
 _bmsData._minCellVoltage = _bmsData._cellVoltages[i];

 }
 if (_bmsData._cellVoltages[i] > _bmsData._maxCellVoltage) {
 _bmsData._maxCellVoltage = _bmsData._cellVoltages[i];

 }
 }
}






void BMS_SendCommandImmediate(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
#line 523 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
 ImmediateCommand _imCmd;
 Immediate_PushCommand(_commandID, _payload, _value);

 if (!_txBusy) {
 _txBusy = 1;
 while (!Immediate_IsEmpty()) {
 _imCmd = Immediate_PopCommand();
 _sendSetCommandPacket(_imCmd._commandID, _imCmd._payload, _imCmd._value);
 }

 _txBusy = 0;
 }
}




void BMS_PushCommand(uint8_t _commandID, uint8_t * _payload) {
 TX_PushCommand(_commandID, _payload);
}





void BMS_Update(void) {
 static uint8_t _defaultCommandIndex = 0;
 ImmediateCommand _imCmd;
 TXCommand _txCmd;


 _processReceivedResponsePacket();

 if (!Immediate_IsEmpty()) {
 _imCmd = Immediate_PopCommand();
 DebugUART_Send_Text("Da lay duoc lenh\r\n");
 _sendSetCommandPacket(_imCmd._commandID, _imCmd._payload, _imCmd._value);

 } else if (!TX_IsEmpty()) {
 _txCmd = TX_PopCommand();
 _sendCommandPacket(_txCmd._commandID, _txCmd._payload);
 } else {

 uint8_t _defaultPayload[8] = {0};
 switch(_defaultCommandIndex) {
 case 0: _sendCommandPacket(0x90, _defaultPayload); break;
 case 1: _sendCommandPacket(0x91, _defaultPayload); break;
 case 2: _sendCommandPacket(0x92, _defaultPayload); break;
 case 3: _sendCommandPacket(0x93, _defaultPayload); break;
 case 4: _sendCommandPacket(0x94, _defaultPayload); break;
 case 5: _sendCommandPacket(0x95, _defaultPayload); break;
 case 6: _sendCommandPacket(0x96, _defaultPayload); break;
 case 7: _sendCommandPacket(0x97, _defaultPayload); break;
 case 8: _sendCommandPacket(0x98, _defaultPayload); break;
 case 9: _sendCommandPacket(0x99, _defaultPayload); break;
 default: break;
 }
 _defaultCommandIndex++;
 if (_defaultCommandIndex >= 10)
 _defaultCommandIndex = 0;
 }
}




void BMS_Init(void) {

 _bmsData._sumVoltage = 0;
 _bmsData._sumCurrent = 0;
 _bmsData._sumSOC = 0;
 _bmsData._temperature = 0;
 _bmsData._cycleCount = 0;
 _bmsData._protectionFlags = 0;
 _bmsData._cellVoltages[0] = 0;
 _bmsData._cellVoltages[1] = 0;
 _bmsData._cellVoltages[2] = 0;
 _bmsData._cellVoltages[3] = 0;


 _txBufferHead = 0;
 _txBufferTail = 0;
 _immediateQueueHead = 0;
 _immediateQueueTail = 0;
 _rxBufferHead = 0;
 _rxBufferTail = 0;
 _txBusy = 0;

 _bmsData._charge_current_limit = 0;
 _bmsData._discharge_current_limit = 0;

 IEC0bits.U1RXIE = 1;
 IFS0bits.U1RXIF = 0;
}






void _UART1_Interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
 char _dbgStr[150];
 uint8_t _packet[ 13 ];
 int _next;
 uint8_t i; uint8_t _byte;
 uint8_t _dummy[13];

 while (UART1_Data_Ready()) {
 _byte = UART1_Read();


 _next = (_rxBufferHead + 1) %  50 ;
 if (_next != _rxBufferTail) {
 _rxBuffer[_rxBufferHead] = _byte;
 _rxBufferHead = _next;
 }
 }


 IFS0bits.U1RXIF = 0;
}
