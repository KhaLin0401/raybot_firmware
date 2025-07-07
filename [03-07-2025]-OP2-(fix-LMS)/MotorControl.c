#include "MotorControl.h"
#include <built_in.h>
#include "robot_system.h"

// Các hàm n?i b? (private) dã d?nh nghia
static void set_motor_speed(void* self, uint16_t speed);
static void set_motor_target_speed(void* self, uint16_t speed);
static void set_motor_direction(void* self, uint8_t direction);
static void enable_motor(void* self, uint8_t enable);
static void motor_pid_control(void* self);
static void pwm_update(void* self);
static void brake_control(void* self);

// Hàm kh?i t?o d?i tu?ng MotorControl
void MotorControl_Init(MotorControl* motor) {
    // C?u hình các chân I/O
    MOTOR_ENABLE_TRIS = 0;   // C?u hình chân ENABLE làm output
    MOTOR_DIR_TRIS = 0;      // C?u hình chân DIR làm output
    MOTOR_ENABLE_LAT = 0;    // Kh?i t?o m?c tín hi?u ban d?u cho ENABLE
    MOTOR_DIR_LAT = 0;       // Kh?i t?o m?c tín hi?u ban d?u cho DIR

    // Kh?i t?o các giá tr? ban d?u cho d?i tu?ng
    motor->speed = 0;
    motor->Pwm_period_max = PWM_Init(5000, PWM_CHANNEL, 0, 1); // Hàm PWM_Init tr? v? giá tr? period t?i da
    motor->Pwm_period_speed = 0;
    motor->target_speed = 0;
    motor->direction = MOTOR_STOP;
    motor->enabled = 0;
    motor->front_distance = 0;
    motor->error = 0;
    motor->last_error = 0;
    motor->integral = 0;
    motor->derivative = 0;
    motor->Kp = 1.0;
    motor->Ki = 0.0;
    motor->Kd = 0.0;

    // Gán con tr? hàm giao di?n
    motor->set_speed = set_motor_speed;
    motor->set_target_speed = set_motor_target_speed;
    motor->set_direction = set_motor_direction;
    motor->enable = enable_motor;
    motor->pid_control = motor_pid_control;
    motor->pwm_update = pwm_update;
    motor->brake_control = brake_control;

    DebugUART_Send_Text("TASK 4-1 : KHOI TAO MOTOR CONTROL ... \n");
}

//--- Các hàm n?i b? (không xu?t ra ngoài) ---
static void set_motor_speed(void* self, uint16_t speed) {
    MotorControl* motor = (MotorControl*)self;
    if (speed > 100)
        speed = 100;
    motor->speed = speed;
    motor->pwm_update(motor);
}

static void set_motor_target_speed(void* self, uint16_t speed) {
    MotorControl* motor = (MotorControl*)self;
    if (speed > 100)
        speed = 100;
    motor->target_speed = speed;
    {
        char dbg[50];
        sprintf(dbg, "TASK 4-3 : SET TARGET SPEED: %d\n", motor->target_speed);
        DebugUART_Send_Text(dbg);
    }
}

static void set_motor_direction(void* self, uint8_t direction) {
    MotorControl* motor = (MotorControl*)self;
    if (direction == MOTOR_STOP) {
        MOTOR_ENABLE_LAT = 0;
        motor->target_speed = 0;
        {
            char dbg[50];
            sprintf(dbg, "TASK 4-4 : STOP MOTOR %d\n", direction);
            DebugUART_Send_Text(dbg);
        }
    } else if (direction == MOTOR_FORWARD || direction == MOTOR_BACKWARD) {
        motor->direction = direction;
        MOTOR_DIR_LAT = direction;
        {
            char dbg[50];
            sprintf(dbg, "TASK 4-4 : SET MOTOR DIRECTION: %d\n", direction);
            DebugUART_Send_Text(dbg);
        }
    }
}

static void enable_motor(void* self, uint8_t enable) {
    MotorControl* motor = (MotorControl*)self;
    motor->enabled = enable;
    MOTOR_ENABLE_LAT = enable;
    DebugUART_Send_Text("CHDEBUG: Motor Enable called.\n");
    {
        char dbg[50];
        sprintf(dbg, "TASK 4-5 : MOTOR ENABLE set to: %d\n", enable);
        DebugUART_Send_Text(dbg);
    }
}

static void motor_pid_control(void* self) {
    char dbg[50];
    int16_t output;
    MotorControl* motor = (MotorControl*)self;
    int16_t error = motor->target_speed - motor->speed;
    motor->integral += error;
    if (motor->integral > MAX_INTEGRAL) motor->integral = MAX_INTEGRAL;
    if (motor->integral < -MAX_INTEGRAL) motor->integral = -MAX_INTEGRAL;
    motor->derivative = error - motor->last_error;
    output = (int16_t)(motor->Kp * error + motor->Ki * motor->integral + motor->Kd * motor->derivative);
    if (output > 100) output = 100;
    if (output < 0) output = 0;
    motor->last_error = error;
    motor->set_speed(motor, output);
    sprintf(dbg, "TASK 4-6 : PID: Error=%d, Output=%d\n", error, output);
    DebugUART_Send_Text(dbg);
}

static void pwm_update(void* self) {
    char dbg[50];
    MotorControl* motor = (MotorControl*)self;
    motor->Pwm_period_speed = (motor->speed * motor->Pwm_period_max) / 100;
    PWM_Set_Duty(PWM_CHANNEL, motor->Pwm_period_speed);
    sprintf(dbg, "TASK 4-8 : PWM: Speed=%d, PWM=%d\n", motor->speed, motor->Pwm_period_speed);
    DebugUART_Send_Text(dbg);
}

static void brake_control(void* self) {
    MotorControl* motor = (MotorControl*)self;
    if (motor->front_distance < EMERGENCY_STOP_DISTANCE) {
        motor->enable(motor, 0);
    } else if (motor->front_distance < WARNING_DISTANCE) {
        motor->direction = MOTOR_BACKWARD;
        motor->speed = motor->speed / 2;
    } else {
        motor->direction = MOTOR_FORWARD;
    }
}

//--- Hàm update du?c g?i t? Scheduler ---
// Ðây là hàm update du?c xu?t ra (không static) d? Scheduler có th? g?i qua symbol
void update_motor(void* self) {
    char dbg[100];
    int16_t error, pid_output, new_speed;
    const float smoothing_factor = 0.2; // H? s? làm mu?t (ramp)
    MotorControl* motor = (MotorControl*)self;

    // N?u motor không du?c kích ho?t, d?t speed = 0 và thoát
    if (!motor->enabled) {
        motor->set_speed(motor, 0);
        return;
    }

    // Tính toán PID
    error = motor->target_speed - motor->speed;
    motor->integral += error;
    if (motor->integral > MAX_INTEGRAL) motor->integral = MAX_INTEGRAL;
    if (motor->integral < -MAX_INTEGRAL) motor->integral = -MAX_INTEGRAL;
    motor->derivative = error - motor->last_error;
    pid_output = (int16_t)(motor->Kp * error + motor->Ki * motor->integral + motor->Kd * motor->derivative);
    if (pid_output > 100) pid_output = 100;
    if (pid_output < 0) pid_output = 0;
    motor->last_error = error;

    // Áp d?ng smoothing (ramp limiter)
    new_speed = motor->speed + (int16_t)(smoothing_factor * (pid_output - motor->speed));
    motor->set_speed(motor, new_speed);
    motor->pwm_update(motor);

    sprintf(dbg, "TASK 4-7 : UPDATE MOTOR: Speed=%d (target=%d)\n", motor->speed, motor->target_speed);
    DebugUART_Send_Text(dbg);

    // Ví d?: Clear Watchdog Timer (n?u thu vi?n h? tr?)
    // ClearWatchdog();
}


/* --- Các hàm Safe b?o v? critical section --- */
void MotorControl_SafeSetSpeed(MotorControl *motor, uint16_t speed) {
    // __disable_interrupt();
    motor->set_speed(motor, speed);
    // __enable_interrupt();
}

void MotorControl_SafeSetTargetSpeed(MotorControl *motor, uint16_t target_speed) {
    // __disable_interrupt();
    motor->set_target_speed(motor, target_speed);
    // __enable_interrupt();
}

void MotorControl_SafeSetDirection(MotorControl *motor, uint8_t direction) {
    // __disable_interrupt();
    motor->set_direction(motor, direction);
    // __enable_interrupt();
}

void MotorControl_SafeEnable(MotorControl *motor, uint8_t enable) {
    // __disable_interrupt();
    motor->enable(motor, enable);
    // __enable_interrupt();
}
