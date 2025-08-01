#line 1 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/schedule_task.h"
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
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/command_handler.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/motordc.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 1 "d:/mikroc pro for dspic/include/string.h"
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
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/lifter.h"
#line 1 "d:/mikroc pro for dspic/include/stdio.h"
#line 21 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/lifter.h"
typedef enum {
LIFTER_STATUS_DISABLED = 0,
LIFTER_STATUS_ENABLED = 1
} LifterStatus;

typedef enum {
LIFTER_RUN_DOWN = 0,
LIFTER_RUN_UP = 1
} run_mode_Status;


typedef struct _Lifter {
float _kp;
float _ki;
float _kd;
float _targetPosition;
float _currentPosition;


float _error;
float _lastError;
float _integral;
float _output;
float _maxOutput;


float _accelerationLimit;
float _decelerationLimit;


unsigned int _maxDuty;


float _minPosition;
float _maxPosition;


int _status;
int run_mode;


void (*Update)(struct _Lifter *pLifter);
} _Lifter;


extern _Lifter lifter;


void _Lifter_Init(_Lifter *pLifter, float kp, float ki, float kd, float targetPosition);
void _Lifter_SetPositionLimits(_Lifter *pLifter, float minPosition, float maxPosition);
void _Lifter_SetTargetPosition(_Lifter *pLifter, float targetPosition);
void _Lifter_Enable(_Lifter *pLifter);
void _Lifter_Disable(_Lifter *pLifter);
void _Lifter_Set_maxOutput(_Lifter *pLifter, float maxOutput);
void _Lifter_SetAccelerationLimit(_Lifter *pLifter, float accLimit);
void _Lifter_SetDecelerationLimit(_Lifter *pLifter, float decLimit);
void _Lifter_Update(_Lifter *pLifter);
char _Lifter_GetInfo(_Lifter *pLifter);
void _Lifter_Get_Run_Mode(_Lifter *pLifter);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/lms.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 5 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/lms.h"
typedef struct {
 uint8_t status;
 uint8_t buzzer;
} Lms;

extern Lms _lms;
void Lms_Init(void);
uint8_t Lms_isPressed(void);
void Lms_Task(void);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/box.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 11 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/box.h"
typedef enum {
 ACTIVE = 1,
 INACTIVE = 0
} Box_state;


typedef struct {
 float distance_inbox;
 uint8_t limit_switch_state;
 Box_state box_status;
 uint8_t object_detected;
 float detection_threshold;
 uint8_t key_touch;

} Box_Object;

extern Box_Object Box_t;

void Box_Init(Box_Object* box, float threshold);


uint8_t Box_KeyTouchStatus(Box_Object* box);


void Box_LimitSwitchStatus(Box_Object* box);


void Box_UpdateStatus(Box_Object* box);


uint8_t Box_IsObjectDetected(Box_Object* box);


Box_state Box_GetStatus(Box_Object* box);


float Box_GetDistance(Box_Object* box);


uint8_t Box_GetLimitSwitchState(Box_Object* box);


void Box_SetDetectionThreshold(Box_Object* box, float threshold);


float Box_GetDetectionThreshold(Box_Object* box);


void Box_GetDetailedStatus(Box_Object* box, char* status_info);
#line 10 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
int send_index;

uint8_t _task_uart;
uint8_t _task_update_system;
uint8_t _task_update_motor;
uint8_t _task_update_to_server;
uint8_t _task_respond_Init;
uint8_t _task_update_BMS;
#line 21 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
void _F_timer1_init(void) {



 T1CON = 0x8030;
 PR1 = 6200;
 TMR1 = 0;


 IPC0bits.T1IP = 5;
 IFS0bits.T1IF = 0;
 IEC0bits.T1IE = 1;
}
#line 38 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
void __attribute__() iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO {
 task_scheduler_clock();
 IFS0bits.T1IF = 0;
}
#line 48 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
void _F_process_uart_command(void) {
 char _command[ 180 ];
 uint8_t _command_available;


 if(_UART2_Rx_GetCommand(_command)) {


 if (strcmp(_command, "GET_STATUS") == 0) {


 }
 else if (strcmp(_command, "RESET") == 0) {



 }
 else if (strncmp(_command, "SET_", 4) == 0) {


 CommandHandler_Execute(&cmdHandler,_command);

 }
 else if (strncmp(_command, "GET_", 4) == 0) {


 CommandHandler_Execute(&cmdHandler,_command);

 }
 else if (_command[0] == '>') {


 CommandHandler_Execute(&cmdHandler,_command);

 }
 else {

 DebugUART_Send_Text("[Lenh khong hop le]\n");
 }



 }
 _UART2_SendProcess();


 BMS_Update();

}
#line 102 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
void _F_update_system_status(void) {


 update_all_sensors();
 Box_UpdateStatus(&Box_t);


}
#line 114 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
void _SC_update_motor(void) {

 if(motorDC._direction == 0)
 motorDC._distanceSensorValue = sensor_front.distance_cm;
 else if(motorDC._direction == 1)
 motorDC._distanceSensorValue = sensor_rear.distance_cm;
 else
 motorDC._distanceSensorValue = 0;
 lifter._currentPosition = sensor_lifter.distance_cm;



 _Lifter_Get_Run_Mode(&lifter);
 if (Lms_isPressed() && lifter.run_mode == LIFTER_RUN_UP){
 _Lifter_Disable(&lifter);
 LATA4_bit = 1;
 }
 else
 {

 _Lifter_Update(&lifter);
#line 141 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
 }

 if (lifter._currentPosition <= 25 || Lms_isPressed()){
 _MotorDC_UpdatePID(&motorDC);
 }
 if (motorDC._output <= 0){
 LATB4_bit = 1;
 LATA8_bit = 1;
 }
 else {
 LATB4_bit = 0;
 LATA8_bit = 0;
 }
#line 160 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
}


void _F_update_to_server(void){

 switch(send_index){
 case 0:
 handle_get_bat_info(&cmdHandler);
 CommandHandler_Respond(&cmdHandler);
 send_index = 1;
 break;
 case 1:
 handle_get_chg_info(&cmdHandler);
 CommandHandler_Respond(&cmdHandler);
 send_index = 2;
 break;
 case 2:
 handle_get_dis_info(&cmdHandler);
 CommandHandler_Respond(&cmdHandler);
 send_index = 3;
 break;
 case 3:
 handle_get_dist_info(&cmdHandler);
 CommandHandler_Respond(&cmdHandler);
 send_index = 4;
 break;
 case 4:
 handle_get_lifter_info(&cmdHandler);
 CommandHandler_Respond(&cmdHandler);
 send_index = 5;
 break;
 case 5:
 handle_get_motor_info(&cmdHandler);
 CommandHandler_Respond(&cmdHandler);
 send_index = 7;
 break;
 case 6:
 break;
 case 7:
 handle_get_box_status(&cmdHandler);
 CommandHandler_Respond(&cmdHandler);
 send_index = 0;
 break;
 default:
 send_index = 0;
 break;
 }

}
#line 215 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/schedule_task.c"
void _F_schedule_init(void) {
 DebugUART_Send_Text("Initializing Task Scheduler...\n");


 _F_timer1_init();

 task_scheduler_init(1000);


 _task_uart = task_add(_F_process_uart_command, 50);
 _task_update_to_server = task_add(_F_update_to_server, 950);
 _task_update_motor = task_add(_SC_update_motor, 100);
 _task_update_BMS = task_add(BMS_Update, 850);
 _task_update_system = task_add(_F_update_system_status, 75);
 task_scheduler_start();
 DebugUART_Send_Text("Task Scheduler initialization complete!\n");

}
