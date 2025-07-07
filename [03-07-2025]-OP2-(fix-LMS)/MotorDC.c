#include "MotorDC.h"
#include <stdio.h>
#include "robot_system.h"
/*
Ham PWM_Init co cu phap:
    PWM_Init(unsigned long freq_hz, unsigned int enable_channel_x, unsigned int timer_prescale, unsigned int use_timer_x);
Voi Timer 1 va prescale = 0, gia tri tra ve duoc gan cho _maxDuty.
*/
extern unsigned int PWM_Init(unsigned long freq_hz, unsigned int enable_channel_x, unsigned int timer_prescale, unsigned int use_timer_x);
extern void PWM_Start(unsigned int channel);
extern void PWM_Set_Duty(unsigned int channel, unsigned int duty);
extern void ADC_Init(void);
extern void Delay_ms(unsigned int ms);
_MotorDC motorDC;
/* ===== Ham khoi tao doi tuong _MotorDC ===== */
void _MotorDC_Init(_MotorDC *motor, float kp, float ki, float kd, float targetSpeed) {
    char debugBuffer[128];
    int maxDutyM1 ;
    int maxDutyM2;

    // In ra thông s? d?u vào
    //sprintf(debugBuffer, "Entering _MotorDC_Init: kp=%.2f, ki=%.2f, kd=%.2f, targetSpeed=%.2f\r\n", kp, ki, kd, targetSpeed);
    //DebugUART_Send_Text(debugBuffer);

    /* --- Cài d?t các giá tr? PID --- */
    motor->_kp = kp;
    motor->_ki = ki;
    motor->_kd = kd;
    //sprintf(debugBuffer, "PID set: kp=%.2f, ki=%.2f, kd=%.2f\r\n", motor->_kp, motor->_ki, motor->_kd);
    //DebugUART_Send_Text(debugBuffer);

    /* --- Cài d?t t?c d? --- */
    motor->_targetSpeed = targetSpeed;  // Luu du?i d?ng ph?n tram
    motor->_currentSpeed = 0;           // Ban d?u là 0, s? c?p nh?t sau
    //sprintf(debugBuffer, "Speeds set: targetSpeed=%.2f, currentSpeed=%.2f\r\n", motor->_targetSpeed, motor->_currentSpeed);
    //DebugUART_Send_Text(debugBuffer);

    /* --- Kh?i t?o các bi?n PID khác --- */
    motor->_error = 0;
    motor->_lastError = 0;
    motor->_integral = 0;
    motor->_output = 0;
    //DebugUART_Send_Text("PID state (error, lastError, integral, output) initialized to 0\r\n");

    /* --- Cài d?t gi?i h?n tang/giam t?c --- */
    motor->_accelerationLimit = 2;  // M?c d?nh: 50%/chu k? (có th? di?u ch?nh)
    motor->_decelerationLimit = 3;  // M?c d?nh: 100%/chu k? (có th? di?u ch?nh)
    sprintf(debugBuffer, "AccelerationLimit=%d, DecelerationLimit=%d\r\n", motor->_accelerationLimit, motor->_decelerationLimit);
    //DebugUART_Send_Text(debugBuffer);

   /* --- Cài d?t kho?ng cách an toàn --- */
    motor->_safeDistance = 40;      // Ðon v? cm
    //sprintf(debugBuffer, "SafeDistance set to %d cm\r\n", motor->_safeDistance);
    //DebugUART_Send_Text(debugBuffer);

    /* --- Kh?i t?o PWM cho d?ng co --- */
     maxDutyM1 = PWM_Init(5000, PWM_CHANNEL_M1, 1, 2); // S? d?ng h?ng s? dã d?nh nghia cho kênh M1
    //sprintf(debugBuffer, "PWM_Init for M1 returned maxDuty=%d\r\n", maxDutyM1);
    //DebugUART_Send_Text(debugBuffer);
     maxDutyM1 = maxDutyM1 * 0.92;

     maxDutyM2 = PWM_Init(5000, PWM_CHANNEL_M2, 1, 2); // S? d?ng h?ng s? dã d?nh nghia cho kênh M2
    //sprintf(debugBuffer, "PWM_Init for M2 returned maxDuty=%d\r\n", maxDutyM2);
    //DebugUART_Send_Text(debugBuffer);
     maxDutyM2 = maxDutyM2 * 0.92;
    // N?u c?n luu riêng, có th? luu c? maxDuty cho t?ng kênh. ? dây luu giá tr? t? kênh M2 vào _maxDuty.
    motor->_maxDuty = maxDutyM1;

    // B?t d?u ch?y PWM cho 2 kênh
    PWM_Start(PWM_CHANNEL_M1);
    PWM_Start(PWM_CHANNEL_M2);
    //DebugUART_Send_Text("PWM channels M1 and M2 started\r\n");

    /* --- Cài d?t hu?ng quay và tr?ng thái ban d?u --- */
    motor->_direction = 0;  // Hu?ng m?c d?nh (ví d?: 0 có th? là FORWARD)
    motor->_status = 0;     // Tr?ng thái ban d?u: t?t (disabled)
    sprintf(debugBuffer, "Direction set to %d, Status set to %d\r\n", motor->_direction, motor->_status);
    //DebugUART_Send_Text(debugBuffer);

    /* --- Gán con tr? hàm Update --- */
    motor->Update = _MotorDC_Update;
    //DebugUART_Send_Text("Update function assigned\r\n");

    // K?t thúc hàm kh?i t?o
    //DebugUART_Send_Text("Exiting _MotorDC_Init\r\n");
}


/* ===== Ham cai dat toc do muc tieu (0-100%) ===== */
void _MotorDC_SetTargetSpeed(_MotorDC *motor, float targetSpeed) {
    if(targetSpeed < 0)
        targetSpeed = 0;
    else if(targetSpeed > 90)
        targetSpeed = 90;
    motor->_targetSpeed = targetSpeed;
    /* Reset cac bien PID */
    motor->_integral = 0;
    motor->_lastError = 0;
}

/* ===== Ham cai dat huong quay ===== */
void _MotorDC_SetDirection(_MotorDC *motor, MotorDirection direction) {
    motor->_direction = direction;
    if(direction == MOTOR_DIRECTION_FORWARD) {
        MOTOR1_DIR_LAT = 1;
        MOTOR2_DIR_LAT = 0;
    } else {
        MOTOR1_DIR_LAT = 0;
        MOTOR2_DIR_LAT = 1;
    }
}


/* ===== Ham bat dong co ===== */
void _MotorDC_Enable(_MotorDC *motor) {

    motor->_status = 1;
    /* Su dung macro MOTOR_ENABLE_LAT de bat chan Enable */

    MOTOR_ENABLE_LAT = 1;
}

/* ===== Ham tat dong co ===== */
void _MotorDC_Disable(_MotorDC *motor) {
    motor->_status = 0;
    motor->_targetSpeed = 0;
    MOTOR_ENABLE_LAT = 0;
    PWM_Set_Duty(motor->_maxDuty,PWM_CHANNEL_M1);
}

void _MotorDC_Set_Idle(_MotorDC *motor){
    motor->_targetSpeed = 0;
    PWM_Set_Duty(10,PWM_CHANNEL_M1);
}

void _MotorDC_Disable_Emergency(_MotorDC *motor){

}

/* ===== Ham lay trang thai dong co ===== */
MotorStatus _MotorDC_GetStatus(_MotorDC *motor) {
    return motor->_status;
}

/* ===== Ham cai dat gioi han tang/giam toc (don vi % cua _maxDuty) ===== */
void _MotorDC_SetAccelerationLimit(_MotorDC *motor, float accLimit) {
    motor->_accelerationLimit = accLimit;
}

void _MotorDC_SetDecelerationLimit(_MotorDC *motor, float decLimit) {
    motor->_decelerationLimit = decLimit;
}

/* ===== Ham cai dat khoang cach an toan (cm) ===== */
void _MotorDC_SetSafeDistance(_MotorDC *motor, float safeDistance) {
    motor->_safeDistance = safeDistance;
}

/* ===== Ham cai dat gia tri PWM toi da (_maxDuty) ===== */
void _MotorDC_SetMaxDuty(_MotorDC *motor, unsigned int maxDuty) {
    motor->_maxDuty = maxDuty;
}

/* ==============================
     HAM CAP NHAT & PID
   ============================== */
/*
Toan bo cac tinh toan PID duoc quy doi sang 0-100%.
- _targetSpeed va _currentSpeed (va cac gia tri lien quan) duoc lam viec theo don vi %.
- Gia tri _output (0-100%) sau do duoc chuyen sang gia tri PWM thuc te: (output * _maxDuty)/100.
*/
void _MotorDC_UpdatePID(_MotorDC *motor) {
    float targetPercent, currentPercent;
    float delta, newOutput, pidOutput, derivative;
    float distance;
    unsigned int pwmDuty;
    unsigned int temp;
    const float MAX_INTEGRAL = 100.0;  // Gioi han tich phan

    /* Lay cac gia tri theo don vi % */
    targetPercent = motor->_targetSpeed;
    currentPercent = motor->_currentSpeed; // Nguoi dung co the cap nhat _currentSpeed theo phan hoi (0-100%)
    distance = motor->_distanceSensorValue;  // (cm)

    /* Tinh sai so PID theo % */
    motor->_error = targetPercent - currentPercent;
    motor->_integral += motor->_error;
    if(motor->_integral > MAX_INTEGRAL)
        motor->_integral = MAX_INTEGRAL;
    else if(motor->_integral < -MAX_INTEGRAL)
        motor->_integral = -MAX_INTEGRAL;
    derivative = motor->_error - motor->_lastError;
    pidOutput = motor->_kp * motor->_error + motor->_ki * motor->_integral + motor->_kd * derivative;
    motor->_lastError = motor->_error;

    /* Cap nhat output theo don vi % */
    if (distance >= motor->_safeDistance) {
        /* Neu khoang cach an toan, cap nhat output theo PID voi gioi han */
        delta = pidOutput;
        if (delta > motor->_accelerationLimit)
            delta = motor->_accelerationLimit;
        else if (delta < -motor->_decelerationLimit)
            delta = -motor->_decelerationLimit;
        newOutput = motor->_output + delta;
    } else {
        /* Neu khoang cach khong an toan, ep buoc giam toc theo _decelerationLimit */
        newOutput = motor->_output - motor->_decelerationLimit;
        if(newOutput < 0)
            newOutput = 0;
    }

    if(newOutput > 90)
        newOutput = 90;
    else if(newOutput < 0)
        newOutput = 0;
    motor->_output = newOutput;

    /* (Option) Cap nhat _currentSpeed theo output, neu khong co phan hoi tu dong co */
    // motor->_currentSpeed = motor->_output;
    motor->_currentSpeed = motor->_output;
    /* Chuyen output (%) sang gia tri PWM thuc te */

    temp = (motor->_output * motor->_maxDuty) / 100.0;  // Tính giá tr? theo ki?u float

    /*pwmDuty = motor->_maxDuty - temp;*/
    pwmDuty = motor->_maxDuty - temp;
    PWM_Set_Duty(pwmDuty,PWM_CHANNEL_M1);
//    PWM_Set_Duty(pwmDuty,PWM_CHANNEL_M2);
}

/* ===== Ham Update tong hop ===== */
void _MotorDC_Update(_MotorDC *motor) {
    /*if(motor->_status == MOTOR_STATUS_ENABLED)
        _MotorDC_UpdatePID(motor);
    else
    {
        PWM_Set_Duty(0,PWM_CHANNEL_M1);
        PWM_Set_Duty(0,PWM_CHANNEL_M2);
    }*/
    _MotorDC_UpdatePID(motor);
}

/* ==============================
     CAC HAM GET THONG TIN
   ============================== */
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

/* ===== Ham get toan bo thong tin cua _MotorDC duoi dang chuoi JSON ===== */
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