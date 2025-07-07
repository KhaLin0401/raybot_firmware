#ifndef LIFTER_H
#define LIFTER_H

/**

@file Lifter.h
@brief Module di?u khi?n lifter s? d?ng PID cho mikroC.
M� t?:
Module n�y cung c?p giao di?n di?u khi?n lifter, cho ph�p d?t v? tr� m?c ti�u,
b?t/t?t h? th?ng, v� c?p nh?t d?u ra di?u khi?n d?a tr�n thu?t to�n PID.
K?t qu? di?u khi?n du?c chuy?n th�nh gi� tr? PWM tr�n hai k�nh (PWM3, PWM4). */
#include <stdio.h>

/* ===== C?u h�nh k�nh PWM v� ch�n ENABLE ===== */
#define PWM_CHANNEL_ALI 3  // PWM3 cho ALI (RP7)
#define PWM_CHANNEL_BLI 4  // PWM4 cho BLI (RP6)
#define LIFTER_ENABLE_TRIS TRISB5_bit  // Ch�n RB5 l�m ENABLE
#define LIFTER_ENABLE_LAT  LATB5_bit    // �i?u khi?n ENABLE (0: b?t, 1: t?t)

/* ===== �?nh nghia tr?ng th�i lifter ===== */
typedef enum {
LIFTER_STATUS_DISABLED = 0,
LIFTER_STATUS_ENABLED  = 1
} LifterStatus;

typedef enum {
LIFTER_RUN_DOWN = 0,  // Hu?ng th? xu?ng (ALI PWM, BLI = 0)
LIFTER_RUN_UP   = 1   // Hu?ng k�o l�n (BLI PWM, ALI = 0)
} run_mode_Status;

/* ===== C?u tr�c di?u khi?n lifter ===== */
typedef struct _Lifter {
float _kp;                      /* H? s? P c?a PID */
float _ki;                      /* H? s? I c?a PID */
float _kd;                      /* H? s? D c?a PID */
float _targetPosition;          /* V? tr� m?c ti�u (mm ho?c cm) */
float _currentPosition;         /**< V? tr� hi?n t?i (c?p nh?t t? c?m bi?n) */

/* Bi?n n?i b? cho PID */
float _error;                   /* Sai s? gi?a v? tr� m?c ti�u v� hi?n t?i */
float _lastError;               /* Sai s? v�ng tru?c */
float _integral;                /* T�ch ph�n c?a sai s? */
float _output;
float _maxOutput;                  /* �?u ra c?a PID (0-100%) */

/* Gi?i h?n tang/gi?m t?c */
float _accelerationLimit;       /* Gi?i h?n tang t?c (%/chu k?) */
float _decelerationLimit;       /* Gi?i h?n gi?m t?c (%/chu k?) */

/* Tham s? PWM */
unsigned int _maxDuty;          /**< Gi� tr? PWM t?i da */

/* Gi?i h?n v? tr� */
float _minPosition;             /* V? tr� t?i thi?u c?a lifter */
float _maxPosition;             /* V? tr� t?i da c?a lifter */

/* Tr?ng th�i ho?t d?ng */
int _status;                    /* Tr?ng th�i lifter (ENABLE hay DISABLE) */
int run_mode;                   /* Ch? d? ch?y (DOWN hay UP) */

/* Con tr? h�m c?p nh?t PID v� PWM */
void (*Update)(struct _Lifter *pLifter);
} _Lifter;

/* Khai b�o bi?n lifter to�n c?c */
extern _Lifter lifter;

/* ===== Prototype c�c h�m API c?a module lifter ===== */
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