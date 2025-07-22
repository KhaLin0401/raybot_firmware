#line 1 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/json_parser.c"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/json_parser.h"
#line 1 "d:/mikroc pro for dspic/include/stddef.h"



typedef int ptrdiff_t;
typedef unsigned int size_t;
typedef unsigned int wchar_t;
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
#line 1 "d:/mikroc pro for dspic/include/ctype.h"





unsigned int islower(char character);
unsigned int isupper(char character);
unsigned int isalpha(char character);
unsigned int iscntrl(char character);
unsigned int isdigit(char character);
unsigned int isalnum(char character);
unsigned int isspace(char character);
unsigned int ispunct(char character);
unsigned int isgraph(char character);
unsigned int isxdigit(char character);
unsigned short tolower(char character);
unsigned short toupper(char character);
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
#line 16 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/json_parser.c"
void JSON_Init(JSON_Parser *parser, const char *json) {
 if (parser ==  ((void *)0) ) {
 DebugUART_Send_Text("JSON_Init: parser is NULL\n");
 return;
 }
 if (json ==  ((void *)0) ) {
 DebugUART_Send_Text("JSON_Init: json string is NULL\n");
 return;
 }
 parser->json = json;
}


int JSON_GetInt(JSON_Parser *parser, const char *key, int *value) {
 char *_pos;
 int json_len;
 int offset = 0;
 int key_len;

 if (!parser || !parser->json) {
 DebugUART_Send_Text("JSON_GetInt: parser or parser->json is NULL\n");
 return 0;
 }
 json_len = strlen((char *)parser->json);
 _pos = strstr((char *)parser->json, key);
 if (!_pos) {
 DebugUART_Send_Text("JSON_GetInt: key not found\n");
 return 0;
 }
 key_len = strlen(key);
 _pos += key_len;
 offset += key_len;
 while (*_pos && *_pos != ':' && offset < json_len) {
 _pos++;
 offset++;
 }
 if (offset >= json_len || *_pos != ':') {
 DebugUART_Send_Text("JSON_GetInt: ':' not found after key\n");
 return 0;
 }
 _pos++;
 offset++;
 while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
 _pos++;
 offset++;
 }
 *value = atoi(_pos);

 return 1;
}


int JSON_ContainsKey(JSON_Parser *parser, const char *key) {
 if (!parser || !parser->json)
 return 0;
 return strstr((char *)parser->json, key) !=  ((void *)0) ;
}
#line 76 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/json_parser.c"
int JSON_GetString(JSON_Parser *parser, const char *key, char *out, size_t out_size) {
 char *_pos;
 char *_start;
 int json_len, offset = 0;
 int key_len;
 int copy_len;

 if (!parser || !parser->json) {
 DebugUART_Send_Text("JSON_GetString: parser or parser->json is NULL\n");
 return 0;
 }
 if (!key) {
 DebugUART_Send_Text("JSON_GetString: key is NULL\n");
 return 0;
 }
 if (!out || out_size == 0) {
 DebugUART_Send_Text("JSON_GetString: invalid output buffer\n");
 return 0;
 }
 json_len = strlen((char *)parser->json);
 if (json_len <= 0) {
 DebugUART_Send_Text("JSON_GetString: empty JSON\n");
 return 0;
 }
 _pos = strstr((char *)parser->json, key);
 if (!_pos) {
 DebugUART_Send_Text("JSON_GetString: key not found in JSON\n");
 return 0;
 }
 key_len = strlen(key);
 _pos += key_len;
 offset += key_len;
 while (*_pos && *_pos != ':' && offset < json_len) {
 _pos++;
 offset++;
 }
 if (offset >= json_len || *_pos != ':') {
 DebugUART_Send_Text("JSON_GetString: ':' not found after key\n");
 return 0;
 }
 _pos++;
 offset++;
 while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
 _pos++;
 offset++;
 }
 if (*_pos != '\"') {
 DebugUART_Send_Text("JSON_GetString: opening '\"' not found\n");
 return 0;
 }
 _pos++;
 offset++;
 _start = _pos;
 while (*_pos && *_pos != '\"' && offset < json_len) {
 _pos++;
 offset++;
 }
 if (offset >= json_len || *_pos != '\"') {
 DebugUART_Send_Text("JSON_GetString: closing '\"' not found, potential infinite loop detected\n");
 return 0;
 }
 copy_len = _pos - _start;
 if (copy_len >= (int)out_size) {
 copy_len = (int)out_size - 1;
 DebugUART_Send_Text("JSON_GetString: output buffer too small, truncating result\n");
 }
 strncpy(out, _start, copy_len);
 out[copy_len] = '\0';

 return 1;
}


int JSON_GetObject(JSON_Parser *parser, const char *key, char *out, size_t out_size) {
 char *_pos;
 char *_start;
 int _brace_count;
 int json_len, offset = 0;
 int copy_len;

 if (!parser || !parser->json) {
 DebugUART_Send_Text("JSON_GetObject: parser or parser->json is NULL\n");
 return 0;
 }
 if (!key) {
 DebugUART_Send_Text("JSON_GetObject: key is NULL\n");
 return 0;
 }
 if (!out || out_size == 0) {
 DebugUART_Send_Text("JSON_GetObject: invalid output buffer\n");
 return 0;
 }
 json_len = strlen((char *)parser->json);
 _pos = strstr((char *)parser->json, key);
 if (!_pos) {
 DebugUART_Send_Text("JSON_GetObject: key not found\n");
 return 0;
 }
 _pos += strlen(key);
 offset += strlen(key);
 while (*_pos && *_pos != ':' && offset < json_len) {
 _pos++;
 offset++;
 }
 if (offset >= json_len || *_pos != ':') {
 DebugUART_Send_Text("JSON_GetObject: ':' not found after key\n");
 return 0;
 }
 _pos++;
 offset++;
 while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
 _pos++;
 offset++;
 }
 if (*_pos != '{') {
 DebugUART_Send_Text("JSON_GetObject: '{' not found after key\n");
 return 0;
 }
 _start = _pos;
 _brace_count = 0;
 while (*_pos && offset < json_len) {
 if (*_pos == '{') {
 _brace_count++;
 } else if (*_pos == '}') {
 _brace_count--;
 if (_brace_count == 0) {
 _pos++;
 offset++;
 break;
 }
 }
 _pos++;
 offset++;
 }
 if (offset >= json_len || _brace_count != 0) {
 DebugUART_Send_Text("JSON_GetObject: Unmatched braces detected or infinite loop risk\n");
 return 0;
 }
 copy_len = _pos - _start;
 if (copy_len >= (int)out_size) {
 copy_len = (int)out_size - 1;
 DebugUART_Send_Text("JSON_GetObject: output buffer too small, truncating result\n");
 }
 strncpy(out, _start, copy_len);
 out[copy_len] = '\0';

 return 1;
}
