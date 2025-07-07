#ifndef LIFTER_H
#define LIFTER_H

/**

@file Lifter.h
@brief Module di?u khi?n lifter s? d?ng PID cho mikroC.
Mô t?:
Module này cung c?p giao di?n di?u khi?n lifter, cho phép d?t v? trí m?c tiêu,
b?t/t?t h? th?ng, và c?p nh?t d?u ra di?u khi?n d?a trên thu?t toán PID.
K?t qu? di?u khi?n du?c chuy?n thành giá tr? PWM trên hai kênh (PWM3, PWM4). */
#include <stdio.h>

/* ===== C?u hình kênh PWM và chân ENABLE ===== */
#define PWM_CHANNEL_ALI 3  // PWM3 cho ALI (RP7)
#define PWM_CHANNEL_BLI 4  // PWM4 cho BLI (RP6)
#define LIFTER_ENABLE_TRIS TRISB5_bit  // Chân RB5 làm ENABLE
#define LIFTER_ENABLE_LAT  LATB5_bit    // Ði?u khi?n ENABLE (0: b?t, 1: t?t)

/* ===== Ð?nh nghia tr?ng thái lifter ===== */
typedef enum {
LIFTER_STATUS_DISABLED = 0,
LIFTER_STATUS_ENABLED  = 1
} LifterStatus;

typedef enum {
LIFTER_RUN_DOWN = 0,  // Hu?ng th? xu?ng (ALI PWM, BLI = 0)
LIFTER_RUN_UP   = 1   // Hu?ng kéo lên (BLI PWM, ALI = 0)
} run_mode_Status;

/* ===== C?u trúc di?u khi?n lifter ===== */
typedef struct _Lifter {
float _kp;                      /* H? s? P c?a PID */
float _ki;                      /* H? s? I c?a PID */
float _kd;                      /* H? s? D c?a PID */
float _targetPosition;          /* V? trí m?c tiêu (mm ho?c cm) */
float _currentPosition;         /**< V? trí hi?n t?i (c?p nh?t t? c?m bi?n) */

/* Bi?n n?i b? cho PID */
float _error;                   /* Sai s? gi?a v? trí m?c tiêu và hi?n t?i */
float _lastError;               /* Sai s? vòng tru?c */
float _integral;                /* Tích phân c?a sai s? */
float _output;
float _maxOutput;                  /* Ð?u ra c?a PID (0-100%) */

/* Gi?i h?n tang/gi?m t?c */
float _accelerationLimit;       /* Gi?i h?n tang t?c (%/chu k?) */
float _decelerationLimit;       /* Gi?i h?n gi?m t?c (%/chu k?) */

/* Tham s? PWM */
unsigned int _maxDuty;          /**< Giá tr? PWM t?i da */

/* Gi?i h?n v? trí */
float _minPosition;             /* V? trí t?i thi?u c?a lifter */
float _maxPosition;             /* V? trí t?i da c?a lifter */

/* Tr?ng thái ho?t d?ng */
int _status;                    /* Tr?ng thái lifter (ENABLE hay DISABLE) */
int run_mode;                   /* Ch? d? ch?y (DOWN hay UP) */

/* Con tr? hàm c?p nh?t PID và PWM */
void (*Update)(struct _Lifter *pLifter);
} _Lifter;

/* Khai báo bi?n lifter toàn c?c */
extern _Lifter lifter;

/* ===== Prototype các hàm API c?a module lifter ===== */
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
#endif