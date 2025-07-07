#ifndef MOTOR_CONTROL_H
#define MOTOR_CONTROL_H

#include <stdint.h>

/* --- C?u h�nh ch�n --- */
#define MOTOR_ENABLE_TRIS  TRISB12_bit
#define MOTOR_ENABLE_LAT   LATB12_bit
#define MOTOR_DIR_TRIS     TRISC6_bit
#define MOTOR_DIR_LAT      LATC6_bit

/* --- C�c h?ng s? --- */
#define MOTOR_FORWARD            1   // Hu??ng ti�n
#define MOTOR_BACKWARD           0   // Hu??ng l�i
#define MOTOR_STOP               2   // D?ng

#define SAFE_DISTANCE            50   // (cm)
#define WARNING_DISTANCE         30   // (cm)
#define EMERGENCY_STOP_DISTANCE  10   // (cm)

#define MAX_SPEED_STEP           5    // Bu?c thay d?i t?c d? t?i da m?i bu?c
//#define MAX_INTEGRAL             1000 // Gi?i h?n t�ch ph�n cho PID

#define PWM_CHANNEL              1    // K�nh PWM s? d?ng

/* --- Ki?u d? li?u MotorControl --- */
typedef struct {
    uint16_t speed;              // T?c d? hi?n t?i (0-100%)
    uint16_t target_speed;       // T?c d? m?c ti�u (0-100%)
    uint8_t direction;           // Hu?ng (MOTOR_FORWARD, MOTOR_BACKWARD, MOTOR_STOP)
    uint8_t enabled;             // 0: t?t, 1: b?t
    int16_t front_distance;      // Kho?ng c�ch do du?c t? c?m bi?n ph�a tru?c (cm)
    uint16_t Pwm_period_max;     // Gi� tr? period PWM t?i da (khi speed = 100%)
    uint16_t Pwm_period_speed;   // Gi� tr? PWM tuong ?ng v?i t?c d? hi?n t?i

    // C�c bi?n PID
    int16_t error;
    int16_t last_error;
    int16_t integral;
    int16_t derivative;
    float Kp;
    float Ki;
    float Kd;

    // Con tr? h�m giao di?n (public interface)
    void (*update)(void*);
    void (*set_speed)(void*, uint16_t);
    void (*set_target_speed)(void*, uint16_t);
    void (*set_direction)(void*, uint8_t);
    void (*enable)(void*, uint8_t);
    void (*pid_control)(void*);
    void (*pwm_update)(void*);
    void (*brake_control)(void*);
} MotorControl;

/* H�m kh?i t?o d?i tu?ng MotorControl */
void MotorControl_Init(MotorControl* motor);

/* C�c h�m �safe� b?o v? critical section */
void MotorControl_SafeSetSpeed(MotorControl *motor, uint16_t speed);
void MotorControl_SafeSetTargetSpeed(MotorControl *motor, uint16_t target_speed);
void MotorControl_SafeSetDirection(MotorControl *motor, uint8_t direction);
void MotorControl_SafeEnable(MotorControl *motor, uint8_t enable);

/* H�m update du?c g?i trong Scheduler */
void update_motor(void* self);

#endif // MOTOR_CONTROL_H