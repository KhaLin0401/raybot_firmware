#line 1 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/MotorDC.c"
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
#line 1 "d:/mikroc pro for dspic/include/stdio.h"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/robot_system.h"
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
unsigned long GetMillis(void);
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
#line 9 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/MotorDC.c"
extern unsigned int PWM_Init(unsigned long freq_hz, unsigned int enable_channel_x, unsigned int timer_prescale, unsigned int use_timer_x);
extern void PWM_Start(unsigned int channel);
extern void PWM_Set_Duty(unsigned int channel, unsigned int duty);
extern void ADC_Init(void);
extern void Delay_ms(unsigned int ms);
_MotorDC motorDC;

void _MotorDC_Init(_MotorDC *motor, float kp, float ki, float kd, float targetSpeed) {
 char debugBuffer[128];
 int maxDutyM1 ;
 int maxDutyM2;






 motor->_kp = kp;
 motor->_ki = ki;
 motor->_kd = kd;




 motor->_targetSpeed = targetSpeed;
 motor->_currentSpeed = 0;




 motor->_error = 0;
 motor->_lastError = 0;
 motor->_integral = 0;
 motor->_output = 0;



 motor->_accelerationLimit = 2;
 motor->_decelerationLimit = 3;
 sprintf(debugBuffer, "AccelerationLimit=%d, DecelerationLimit=%d\r\n", motor->_accelerationLimit, motor->_decelerationLimit);



 motor->_safeDistance = 40;




 maxDutyM1 = PWM_Init(5000,  1 , 1, 2);


 maxDutyM1 = maxDutyM1 * 0.92;

 maxDutyM2 = PWM_Init(5000,  2 , 1, 2);


 maxDutyM2 = maxDutyM2 * 0.92;

 motor->_maxDuty = maxDutyM1;


 PWM_Start( 1 );
 PWM_Start( 2 );



 motor->_direction = 0;
 motor->_status = 0;
 sprintf(debugBuffer, "Direction set to %d, Status set to %d\r\n", motor->_direction, motor->_status);



 motor->Update = _MotorDC_Update;




}



void _MotorDC_SetTargetSpeed(_MotorDC *motor, float targetSpeed) {
 if(targetSpeed < 0)
 targetSpeed = 0;
 else if(targetSpeed > 90)
 targetSpeed = 90;
 motor->_targetSpeed = targetSpeed;

 motor->_integral = 0;
 motor->_lastError = 0;
}


void _MotorDC_SetDirection(_MotorDC *motor, MotorDirection direction) {
 motor->_direction = direction;
 if(direction == MOTOR_DIRECTION_FORWARD) {
  LATC8_bit  = 1;
  LATC7_bit  = 0;
 } else {
  LATC8_bit  = 0;
  LATC7_bit  = 1;
 }
}



void _MotorDC_Enable(_MotorDC *motor) {

 motor->_status = 1;


  LATB12_bit  = 1;
}


void _MotorDC_Disable(_MotorDC *motor) {
 motor->_status = 0;
 motor->_targetSpeed = 0;
  LATB12_bit  = 0;
 PWM_Set_Duty(motor->_maxDuty, 1 );
}

void _MotorDC_Set_Idle(_MotorDC *motor){
 motor->_targetSpeed = 0;
 PWM_Set_Duty(10, 1 );
}

void _MotorDC_Disable_Emergency(_MotorDC *motor){

}


MotorStatus _MotorDC_GetStatus(_MotorDC *motor) {
 return motor->_status;
}


void _MotorDC_SetAccelerationLimit(_MotorDC *motor, float accLimit) {
 motor->_accelerationLimit = accLimit;
}

void _MotorDC_SetDecelerationLimit(_MotorDC *motor, float decLimit) {
 motor->_decelerationLimit = decLimit;
}


void _MotorDC_SetSafeDistance(_MotorDC *motor, float safeDistance) {
 motor->_safeDistance = safeDistance;
}


void _MotorDC_SetMaxDuty(_MotorDC *motor, unsigned int maxDuty) {
 motor->_maxDuty = maxDuty;
}
#line 172 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/MotorDC.c"
void _MotorDC_UpdatePID(_MotorDC *motor) {
 float targetPercent, currentPercent;
 float delta, newOutput, pidOutput, derivative;
 float distance;
 unsigned int pwmDuty;
 unsigned int temp;
 const float MAX_INTEGRAL = 100.0;


 targetPercent = motor->_targetSpeed;
 currentPercent = motor->_currentSpeed;
 distance = motor->_distanceSensorValue;


 motor->_error = targetPercent - currentPercent;
 motor->_integral += motor->_error;
 if(motor->_integral > MAX_INTEGRAL)
 motor->_integral = MAX_INTEGRAL;
 else if(motor->_integral < -MAX_INTEGRAL)
 motor->_integral = -MAX_INTEGRAL;
 derivative = motor->_error - motor->_lastError;
 pidOutput = motor->_kp * motor->_error + motor->_ki * motor->_integral + motor->_kd * derivative;
 motor->_lastError = motor->_error;


 if (distance >= motor->_safeDistance) {

 delta = pidOutput;
 if (delta > motor->_accelerationLimit)
 delta = motor->_accelerationLimit;
 else if (delta < -motor->_decelerationLimit)
 delta = -motor->_decelerationLimit;
 newOutput = motor->_output + delta;
 } else {

 newOutput = motor->_output - motor->_decelerationLimit;
 if(newOutput < 0)
 newOutput = 0;
 }

 if(newOutput > 90)
 newOutput = 90;
 else if(newOutput < 0)
 newOutput = 0;
 motor->_output = newOutput;



 motor->_currentSpeed = motor->_output;


 temp = (motor->_output * motor->_maxDuty) / 100.0;


 pwmDuty = motor->_maxDuty - temp;
 PWM_Set_Duty(pwmDuty, 1 );

}


void _MotorDC_Update(_MotorDC *motor) {
#line 240 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/MotorDC.c"
 _MotorDC_UpdatePID(motor);
}
#line 246 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/MotorDC.c"
float _MotorDC_GetTargetSpeed(_MotorDC *motor) {
 return motor->_targetSpeed;
}

float _MotorDC_GetCurrentSpeed(_MotorDC *motor) {
 return motor->_currentSpeed;
}

float _MotorDC_GetAccelerationLimit(_MotorDC *motor) {
 return motor->_accelerationLimit;
}

float _MotorDC_GetDecelerationLimit(_MotorDC *motor) {
 return motor->_decelerationLimit;
}

float _MotorDC_GetSafeDistance(_MotorDC *motor) {
 return motor->_safeDistance;
}

unsigned int _MotorDC_GetMaxDuty(_MotorDC *motor) {
 return (unsigned int)motor->_maxDuty;
}

MotorDirection _MotorDC_GetDirection(_MotorDC *motor) {
 return motor->_direction;
}

float _MotorDC_GetOutput(_MotorDC *motor) {
 return motor->_output;
}

float _MotorDC_GetDistanceSensorValue(_MotorDC *motor) {
 return motor->_distanceSensorValue;
}


char* _MotorDC_GetInfo(_MotorDC *motor) {
 static char _jsonStr[256];
 sprintf(_jsonStr,
 "{\"targetSpeed\":%.2f,\"currentSpeed\":%.2f,\"accelerationLimit\":%.2f,\"decelerationLimit\":%.2f,\"safeDistance\":%.2f,\"maxDuty\":%u,\"direction\":%d,\"status\":%d,\"output\":%.2f,\"distanceSensorValue\":%.2f}",
 motor->_targetSpeed,
 motor->_currentSpeed,
 motor->_accelerationLimit,
 motor->_decelerationLimit,
 motor->_safeDistance,
 (unsigned int)motor->_maxDuty,
 motor->_direction,
 motor->_status,
 motor->_output,
 motor->_distanceSensorValue
 );
 return _jsonStr;
}
