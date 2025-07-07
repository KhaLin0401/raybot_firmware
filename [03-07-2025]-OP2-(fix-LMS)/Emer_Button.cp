#line 1 "C:/Users/ASUS/Desktop/RAYBOT/CODE/[13-05-25]-OP2-(feat-lifter-speed)/Emer_Button.c"
#line 1 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/emer_button.h"
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
#line 5 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/emer_button.h"
typedef struct {
 uint8_t status;
 uint8_t buzzer;
 uint8_t emergency;
 float motorTargetSpeed;
 float lifterTargetPosition;
 int8_t motorState;
 int8_t lifterState;
} EmerButton;

extern EmerButton _button;
void Emer_Button_Init(void);
uint8_t Emer_Button_isPressed(void);
void Emer_Button_Task(void);
#line 1 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
#line 53 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
typedef enum {
 MOTOR_DIRECTION_FORWARD = 0,
 MOTOR_DIRECTION_REVERSE = 1
} MotorDirection;

typedef enum {
 MOTOR_STATUS_DISABLED = 0,
 MOTOR_STATUS_ENABLED = 1
} MotorStatus;
#line 80 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
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
#line 134 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_Init(_MotorDC *motor, float kp, float ki, float kd, float targetSpeed);
#line 142 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_SetTargetSpeed(_MotorDC *motor, float targetSpeed);
#line 151 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_SetDirection(_MotorDC *motor, MotorDirection direction);
#line 159 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_Enable(_MotorDC *motor);
#line 167 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_Disable(_MotorDC *motor);
#line 176 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_Disable_Emergency(_MotorDC *motor);

MotorStatus _MotorDC_GetStatus(_MotorDC *motor);
#line 186 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_SetAccelerationLimit(_MotorDC *motor, float accLimit);
#line 194 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_SetDecelerationLimit(_MotorDC *motor, float decLimit);
#line 202 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_SetSafeDistance(_MotorDC *motor, float safeDistance);
#line 210 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_SetMaxDuty(_MotorDC *motor, unsigned int maxDuty);
#line 222 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_UpdatePID(_MotorDC *motor);
#line 227 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
void _MotorDC_Update(_MotorDC *motor);
#line 236 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
float _MotorDC_GetTargetSpeed(_MotorDC *motor);
#line 241 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
float _MotorDC_GetCurrentSpeed(_MotorDC *motor);
#line 246 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
float _MotorDC_GetAccelerationLimit(_MotorDC *motor);
#line 251 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
float _MotorDC_GetDecelerationLimit(_MotorDC *motor);
#line 256 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
float _MotorDC_GetSafeDistance(_MotorDC *motor);
#line 261 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
unsigned int _MotorDC_GetMaxDuty(_MotorDC *motor);
#line 266 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
MotorDirection _MotorDC_GetDirection(_MotorDC *motor);
#line 271 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
float _MotorDC_GetOutput(_MotorDC *motor);
#line 276 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
float _MotorDC_GetDistanceSensorValue(_MotorDC *motor);
#line 286 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/motordc.h"
char* _MotorDC_GetInfo(_MotorDC *motor);
#line 1 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/lifter.h"
#line 1 "d:/mikroc pro for dspic/include/stdio.h"
#line 21 "c:/users/asus/desktop/raybot/code/[13-05-25]-op2-(feat-lifter-speed)/lifter.h"
typedef enum {
LIFTER_STATUS_DISABLED = 1,
LIFTER_STATUS_ENABLED = 0
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
#line 5 "C:/Users/ASUS/Desktop/RAYBOT/CODE/[13-05-25]-OP2-(feat-lifter-speed)/Emer_Button.c"
EmerButton _button;


void Emer_Button_Init(void){
#line 16 "C:/Users/ASUS/Desktop/RAYBOT/CODE/[13-05-25]-OP2-(feat-lifter-speed)/Emer_Button.c"
}

uint8_t Emer_Button_isPressed(void){
#line 21 "C:/Users/ASUS/Desktop/RAYBOT/CODE/[13-05-25]-OP2-(feat-lifter-speed)/Emer_Button.c"
}

void Emer_Button_Task(void){
#line 48 "C:/Users/ASUS/Desktop/RAYBOT/CODE/[13-05-25]-OP2-(feat-lifter-speed)/Emer_Button.c"
}
