#line 1 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
#line 1 "d:/mikroc pro for dspic/include/stddef.h"



typedef int ptrdiff_t;
typedef unsigned int size_t;
typedef unsigned int wchar_t;
#line 1 "d:/mikroc pro for dspic/include/stdlib.h"







 typedef struct divstruct {
 int quot;
 int rem;
 } div_t;

 typedef struct ldivstruct {
 long quot;
 long rem;
 } ldiv_t;

 typedef struct uldivstruct {
 unsigned long quot;
 unsigned long rem;
 } uldiv_t;

int abs(int a);
float atof(char * s);
int atoi(char * s);
long atol(char * s);
div_t div(int number, int denom);
ldiv_t ldiv(long number, long denom);
uldiv_t uldiv(unsigned long number, unsigned long denom);
long labs(long x);
int max(int a, int b);
int min(int a, int b);
void srand(unsigned x);
int rand();
int xtoi(char * s);
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
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/command_handler.h"
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
#line 1 "d:/mikroc pro for dspic/include/stdio.h"
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
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/robot_system.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
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
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart2.h"
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
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/json_parser.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 1 "d:/mikroc pro for dspic/include/stdbool.h"



 typedef char _Bool;
#line 31 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
typedef enum
{
 CELL_THRESHOLDS = 0x59,
 PACK_THRESHOLDS = 0x5A,
 VOUT_IOUT_SOC = 0x90,
 MIN_MAX_CELL_VOLTAGE = 0x91,
 MIN_MAX_TEMPERATURE = 0x92,
 DISCHARGE_CHARGE_MOS_STATUS = 0x93,
 STATUS_INFO = 0x94,
 CELL_VOLTAGES = 0x95,
 CELL_TEMPERATURE = 0x96,
 CELL_BALANCE_STATE = 0x97,
 FAILURE_CODES = 0x98,
 DISCHRG_FET = 0xD9,
 CHRG_FET = 0xDA,
 BMS_RESET = 0x00,
 READ_SOC = 0x61,
 SET_SOC = 0x21,
} DALY_BMS_COMMAND;


typedef struct
{

 float maxCellThreshold1;
 float minCellThreshold1;
 float maxCellThreshold2;
 float minCellThreshold2;


 float maxPackThreshold1;
 float minPackThreshold1;
 float maxPackThreshold2;
 float minPackThreshold2;


 float packVoltage;
 float packCurrent;
 float packSOC;


 float maxCellmV;
 int maxCellVNum;
 float minCellmV;
 int minCellVNum;
 int cellDiff;


 int tempAverage;




 const char *chargeDischargeStatus;
  _Bool  chargeFetState;
  _Bool  disChargeFetState;
 int bmsHeartBeat;
 float resCapacityAh;


 unsigned int numberOfCells;
 unsigned int numOfTempSensors;
  _Bool  chargeState;
  _Bool  loadState;
  _Bool  dIO[8];
 int bmsCycles;


 float cellVmV[48];


 int cellTemperature[16];


  _Bool  cellBalanceState[48];
  _Bool  cellBalanceActive;


  _Bool  connectionState;

} DalyBmsData;


typedef struct DalyBms
{
 unsigned long previousTime;
 uint8_t requestCounter;
 int soft_tx;
 int soft_rx;


 char failCodeArr[32];

 DalyBmsData get;




  _Bool  getStaticData;
 unsigned int errorCounter;
 unsigned int requestCount;
 unsigned int commandQueue[5];


 void *serial_handle;

 uint8_t my_txBuffer[ 13 ];
 uint8_t my_rxBuffer[ 13 ];
 uint8_t my_rxFrameBuffer[ 13 *12];
 uint8_t frameBuff[12][ 13 ];
 unsigned int frameCount;


 void (*requestCallback)(void);

} DalyBms;
#line 156 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
DalyBms* DalyBms_create(int rx, int tx);
#line 164 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_init(DalyBms* bms);
#line 171 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_loop(DalyBms* bms);
#line 178 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
void DalyBms_set_callback(DalyBms* bms, void (*func)(void));
#line 185 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getPackMeasurements(DalyBms* bms);
#line 192 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getVoltageThreshold(DalyBms* bms);
#line 199 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getPackVoltageThreshold(DalyBms* bms);
#line 207 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getPackTemp(DalyBms* bms);
#line 215 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getMinMaxCellVoltage(DalyBms* bms);
#line 222 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getStatusInfo(DalyBms* bms);
#line 229 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getCellVoltages(DalyBms* bms);
#line 236 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getCellTemperature(DalyBms* bms);
#line 243 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getCellBalanceState(DalyBms* bms);
#line 250 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getFailureCodes(DalyBms* bms);
#line 258 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setDischargeMOS(DalyBms* bms,  _Bool  sw);
#line 266 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setChargeMOS(DalyBms* bms,  _Bool  sw);
#line 274 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setSOC(DalyBms* bms, float sw);
#line 281 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getDischargeChargeMosStatus(DalyBms* bms);
#line 289 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setBmsReset(DalyBms* bms);
#line 302 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getState(DalyBms* bms);


static  _Bool  DalyBms_requestData(DalyBms* bms, DALY_BMS_COMMAND cmdID, unsigned int frameAmount);
static  _Bool  DalyBms_sendCommand(DalyBms* bms, DALY_BMS_COMMAND cmdID);
static  _Bool  DalyBms_sendQueueAdd(DalyBms* bms, DALY_BMS_COMMAND cmdID);
static  _Bool  DalyBms_receiveBytes(DalyBms* bms);
static  _Bool  DalyBms_validateChecksum(DalyBms* bms);
static void DalyBms_barfRXBuffer(DalyBms* bms);
static void DalyBms_clearGet(DalyBms* bms);
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
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/robot_system.h"
#line 32 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
CommandHandler cmdHandler;
uint8_t _defaultSetPayload[7] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

typedef enum {
 PARSE_STATE_IDLE,
 PARSE_STATE_COMMAND,
 PARSE_STATE_VALUE
} ParseState;


static void strip_newline(char *str) {
 int len = strlen(str);
 while (len > 0 && (str[len - 1] == '\r' || str[len - 1] == '\n' || str[len - 1] == ' ')) {
 str[len - 1] = '\0';
 len--;
 }
}


static void trim_whitespace(char *str) {
 int i, start = 0;
 int len = strlen(str);

 while (start < len && (str[start]==' ' || str[start]=='\t')) {
 start++;
 }
 if (start > 0) {
 for (i = start; i < len; i++) {
 str[i - start] = str[i];
 }
 str[len - start] = '\0';
 }

 len = strlen(str);
 while (len > 0 && (str[len - 1]==' ' || str[len - 1]=='\t')) {
 str[len - 1] = '\0';
 len--;
 }
}


void CommandHandler_Init(CommandHandler *handler) {
 strcpy(handler->command_name, "");
 handler->command_value = 0;
 memset(handler->response_buffer, 0, sizeof(handler->response_buffer));
 handler->is_valid = 0;
 strcpy(handler->id, "");

}


void handle_unknown_command(CommandHandler *handler) {
 sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Unknown command: %s\"}\r\n", handler->id, handler->command_name);
  DebugUART_Send_Text(handler->response_buffer) ;
}
#line 93 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
void CommandHandler_Respond(CommandHandler *handler) {

 _UART2_SendPush(handler->response_buffer);
  DebugUART_Send_Text(handler->response_buffer) ;
}
#line 105 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
void CommandHandler_ParseJSON(CommandHandler *handler, const char *cmd) {

 char _buffer[128];
 char _id[32] = {0};
 int _cmd_type = -1;
 char _dataBuffer[128] = {0};
 JSON_Parser _parser;
 JSON_Parser _dataParser;
 int _param1 = 0, _param2 = 0, _param3 = 0;


 if (cmd[0] != '>')
 return;


 strncpy(_buffer, cmd + 1, sizeof(_buffer) - 1);
 _buffer[sizeof(_buffer) - 1] = '\0';


 strip_newline(_buffer);





 JSON_Init(&_parser, _buffer);


 if (!JSON_GetString(&_parser, "id", _id, sizeof(_id))) {
 sprintf(handler->response_buffer, ">{\"id\":\"\",\"error\":\"Invalid JSON: missing id\"}\r\n");
 return;
 }
 strcpy(handler->id, _id);



 if (!JSON_GetInt(&_parser, "type", &_cmd_type)) {
 sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Invalid JSON: missing type\"}\r\n", _id);
 return;
 }



 if (!JSON_GetObject(&_parser, "data", _dataBuffer, sizeof(_dataBuffer))) {
 sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Invalid JSON: missing data\"}\r\n", _id);
 return;
 }



 JSON_Init(&_dataParser, _dataBuffer);





 switch (_cmd_type) {
 case 0:
 handle_charge_config(handler, &_dataParser, _id);
 break;
 case 1:
 handle_discharge_config(handler, &_dataParser, _id);
 break;
 case 2:
 handle_lifter_config(handler, &_dataParser, _id);
 break;
 case 3:
 handle_motorDC_config(handler, &_dataParser, _id);
 break;
 default:

 sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", _id);
 break;
 }



}
#line 190 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
void CommandHandler_Execute(CommandHandler *handler, const char *cmd) {
 int found = 0;
 int i = 0;

 if (handler ==  ((void *)0) ) {
  DebugUART_Send_Text("CH DEBUG: Handler pointer is NULL. Exiting.\n") ;
 return;
 }
 if (cmd ==  ((void *)0) ) {
  DebugUART_Send_Text("CH DEBUG: Command string is NULL. Exiting.\n") ;
 return;
 }
#line 214 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
 if (cmd[0] == '>') {

 CommandHandler_ParseJSON(handler, cmd);

 CommandHandler_Respond(handler);

 return;
 } else {


 strcpy(handler->command_name, cmd);
 }



 if (!found) {

 handle_unknown_command(handler);
 }



 CommandHandler_Respond(handler);

}





void handle_get_bat_info(CommandHandler *handler) {
 sprintf(handler->response_buffer,
 ">{\"type\":0,\"state_type\":0,\"data\":{\"current\":%d,\"temp\":%d,\"voltage\":%d,\"cell_voltages\":[%d,%d,%d,%d],\"percent\":%d,\"fault\":%d,\"health\":%d,\"status\":%d}}\r\n",
 (int)_bmsData._sumCurrent,(int) _bmsData._temperature, (int)_bmsData._sumVoltage,
 (int)_bmsData._cellVoltages[0], (int)_bmsData._cellVoltages[1], (int)_bmsData._cellVoltages[2], 0,
 (int)_bmsData._sumSOC, (int)_bmsData._errorCount, (int)1, (int)1);
}
void handle_get_bat_current(CommandHandler *handler) {
 sprintf(handler->response_buffer, "BAT_CURRENT=%d\r\n",_bmsData._sumCurrent);
}
void handle_get_bat_fault(CommandHandler *handler) {
 sprintf(handler->response_buffer, "BAT_FAULT=%d\r\n",_bmsData._errorCount);
}
void handle_get_bat_health(CommandHandler *handler) {
 sprintf(handler->response_buffer, "BAT_HEALTH=%d\r\n", 0);
}
void handle_get_bat_soc(CommandHandler *handler) {
 sprintf(handler->response_buffer, "BAT_SOC=%d\r\n",_bmsData._sumSOC);
}
void handle_get_bat_status(CommandHandler *handler) {
 sprintf(handler->response_buffer, "BAT_STATUS=%d\r\n",0);
}
void handle_get_bat_temp(CommandHandler *handler) {
 sprintf(handler->response_buffer, "BAT_TEMP=%d\r\n",_bmsData._temperature);
}
void handle_get_bat_volt(CommandHandler *handler) {
 sprintf(handler->response_buffer, "BAT_VOLT=%d\r\n",_bmsData._sumVoltage);
}
void handle_get_cell_volt(CommandHandler *handler) {
 sprintf(handler->response_buffer, "CELL_VOLT=[%d,%d,%d,%d]\r\n",
 _bmsData._cellVoltages[0], _bmsData._cellVoltages[1], _bmsData._cellVoltages[2], 0);
}


void handle_get_chg_info(CommandHandler *handler){
 sprintf(handler->response_buffer,
 ">{\"type\":0,\"state_type\":1,\"data\":{\"current_limit\":%d,\"enabled\":%d}}\r\n",
 (int) _bmsData._charge_current_limit, (int) _bmsData._chargeMOS);
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
 (int) _bmsData._discharge_current_limit, (int) _bmsData._dischargeMOS);
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


void handle_get_di1(CommandHandler *handler) {
 sprintf(handler->response_buffer, "DI1=0\r\n");
}
void handle_get_di2(CommandHandler *handler) {
 sprintf(handler->response_buffer, "DI2=1\r\n");
}
void handle_get_di3(CommandHandler *handler) {
 sprintf(handler->response_buffer, "DI3=0\r\n");
}


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


void handle_get_auto_mode(CommandHandler *handler) {
 sprintf(handler->response_buffer, "AUTO_MODE=1\r\n");
}
void handle_set_auto_mode(CommandHandler *handler) {
 sprintf(handler->response_buffer, "AUTO_MODE set to %d\r\n", handler->command_value);
}


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


void handle_get_motor_info(CommandHandler *handler){
#line 405 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
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

 sprintf(handler->response_buffer, "MOTOR_DIR=%d\r\n", _MotorDC_GetDirection(&motorDC));
}

void handle_set_motor_dir(CommandHandler *handler) {

 if (handler->command_value == 0 || handler->command_value == 1) {
 _MotorDC_SetDirection(&motorDC, (MotorDirection)handler->command_value);
 sprintf(handler->response_buffer, "MOTOR_DIR set to %d\r\n", handler->command_value);
 } else {
 sprintf(handler->response_buffer, "Invalid MOTOR_DIR value: %d\r\n", handler->command_value);
 }
}

void handle_get_motor_en(CommandHandler *handler) {

 sprintf(handler->response_buffer, "MOTOR_EN=%d\r\n", _MotorDC_GetStatus(&motorDC));
}

void handle_set_motor_en(CommandHandler *handler) {
sprintf(handler->response_buffer, "MOTOR_EN set to %d\r\n", handler->command_value);
#line 453 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
}

void handle_get_motor_speed(CommandHandler *handler) {

 sprintf(handler->response_buffer, "MOTOR_SPEED=%.2f\r\n", _MotorDC_GetTargetSpeed(&motorDC));
}

void handle_set_motor_speed(CommandHandler *handler) {

 _MotorDC_SetTargetSpeed(&motorDC, handler->command_value);
 sprintf(handler->response_buffer, "MOTOR_SPEED set to %d\r\n", handler->command_value);
}





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


void handle_get_rfid_err(CommandHandler *handler) {
 sprintf(handler->response_buffer, "RFID_ERR=0\r\n");
}
void handle_get_rfid_cur_loc(CommandHandler *handler) {
 sprintf(handler->response_buffer, "RFID_CUR_LOC=Null\r\n");
}
void handle_get_rfid_tar_loc(CommandHandler *handler) {
 sprintf(handler->response_buffer, "RFID_TAR_LOC=Null\r\n");
}


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
 _bmsData._charge_current_limit = current_limit;
 if (enable == 0)
 Immediate_PushCommand(0xDA, _defaultSetPayload, 0x00);
 else if (enable == 1)
 Immediate_PushCommand(0xDA, _defaultSetPayload, 0x01);
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
 _bmsData._discharge_current_limit = current_limit;
 if (enable == 0)
 Immediate_PushCommand(0xD9, _defaultSetPayload, 0x00);
 else if (enable == 1)
 Immediate_PushCommand(0xD9, _defaultSetPayload, 0x01);
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
#line 580 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
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
#line 603 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/command_handler.c"
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

 _MotorDC_SetTargetSpeed(&motorDC, speed);
 if (enable == 1){
 _MotorDC_Enable(&motorDC);
 }

 else if (enable == 0){

 _MotorDC_Disable(&motorDC);
 }
 else {
 sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
 return;
 }
 sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);

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
