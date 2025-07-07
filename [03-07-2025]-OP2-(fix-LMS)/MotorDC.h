#ifndef MOTORDC_H
#define MOTORDC_H

/*
======================================
  README - MODULE _MotorDC
======================================

MO TA:
Module _MotorDC cung cap giao dien dieu khien dong co DC su dung dieu khien PID.
Nguoi dung co the dat toc do muc tieu (0-100%) va he thong se dieu chinh PWM de dat toc do mong muon.
Module ho tro dieu chinh chan H-bridge thong qua cac macro phan cung de dieu khien huong quay va enable dong co.
Ngoai ra, module cung ho tro cac tinh nang:
  - Gioi han tang/giam toc do (don vi % cua tong pham vi 0-100%)
  - Dieu chinh toc do dua tren cam bien khoang cach (don vi cm)
  - Xuat thong tin toan bo trang thai dong co duoi dang chuoi JSON

TINH NANG CHINH:
  - Dieu khien dong co DC voi thuat toan PID.
  - Cai dat toc do muc tieu tu 0-100%.
  - Gioi han tang/giam toc cho moi chu ky cap nhat (theo %).
  - Ho tro cam bien khoang cach de giam toc khi gap vat can.
  - Cung cap ham get thong tin trang thai dong co duoi dang chuoi JSON.
  - Ho tro dieu khien chan enable va direction cua H-bridge thong qua cac macro phan cung.

CAU TRUC DU LIEU CHINH:
  - _MotorDC: Dinh nghia doi tuong dong co DC, luu tru cac tham so PID, du lieu cam bien va cac thong so dieu khien.

HAM API CHINH:
  - Khoi tao va cai dat doi tuong: _MotorDC_Init(), _MotorDC_SetTargetSpeed(), _MotorDC_SetDirection(), ...
  - Bat/Tat dong co: _MotorDC_Enable(), _MotorDC_Disable()
  - Cap nhat dieu khien PID: _MotorDC_Update()
  - Xuat thong tin duoi dang chuoi JSON: _MotorDC_GetInfo()

======================================
*/

/* ===== CAC MACRO PHAN CUNG ===== */
/* Cac macro dieu khien chan cua H-bridge */
#define MOTOR_ENABLE_TRIS  TRISB12_bit   // Vi du: cau hinh chan Enable cua dong co
#define MOTOR_ENABLE_LAT   LATB12_bit    // Macro set gia tri chan Enable (1: bat, 0: tat)
// Motor 1
#define MOTOR1_DIR_TRIS    TRISC8_bit
#define MOTOR1_DIR_LAT     LATC8_bit
#define PWM_CHANNEL_M1     1

// Motor 2
#define MOTOR2_DIR_TRIS    TRISC7_bit
#define MOTOR2_DIR_LAT     LATC7_bit
#define PWM_CHANNEL_M2     2

/* ===== DINH NGHIA CAC KIEU DU LIEU CHO TRANG THAI DONG CO ===== */
typedef enum {
    MOTOR_DIRECTION_FORWARD = 0,   // Quay theo chieu thuan
    MOTOR_DIRECTION_REVERSE = 1    // Quay theo chieu nguoc
} MotorDirection;

typedef enum {
    MOTOR_STATUS_DISABLED = 0,     // Dong co bi vo hieu
    MOTOR_STATUS_ENABLED  = 1      // Dong co dang hoat dong
} MotorStatus;


/* ===== CAU TRUC DU LIEU CHINH: _MotorDC ===== */
/**
 * @brief Cau truc _MotorDC chua cac tham so PID va cac thong so dieu khien dong co.
 *
 * Cac truong chinh:
 *   - _targetSpeed: Toc do muc tieu (0-100%).
 *   - _currentSpeed: Toc do hien tai (0-100%), da chuyen sang don vi %.
 *   - _error, _lastError, _integral, _output: Bien noi bo dung de tinh toan PID (don vi %).
 *   - _distanceSensorValue: Gia tri khoang cach (cm) duoc cap nhat tu ben ngoai.
 *   - _accelerationLimit, _decelerationLimit: Gioi han tang/giam toc, don vi % (tung chu ky).
 *   - _safeDistance: Khoang cach an toan (cm).
 *   - _maxDuty: Gia tri PWM toi da, duoc lay tu PWM_Init.
 *   - _direction: Huong quay cua dong co.
 *   - _status: Trang thai dong co (bat/tat).
 *   - Update: Con tro ham cap nhat (PID + PWM), co the override trong module con.
 */
typedef struct _MotorDC {
    /* Tham so PID */
    float _kp;                      /**< He so P cua PID */
    float _ki;                      /**< He so I cua PID */
    float _kd;                      /**< He so D cua PID */
    float _targetSpeed;             /**< Toc do muc tieu (0-100%) */
    float _currentSpeed;            /**< Toc do hien tai (0-100%) */

    /* Bien noi bo cho PID */
    float _error;                   /**< Sai so hien tai */
    float _lastError;               /**< Sai so vong truoc */
    float _integral;                /**< Gia tri tich phan */
    float _output;                  /**< Gia tri dau ra dieu khien (0-100%) */

    /* Cam bien */
    float _distanceSensorValue;     /**< Gia tri khoang cach (cm), duoc cap nhat tu ben ngoai */

    /* Gioi han tang/giam toc (don vi % cua _maxDuty) */
    float _accelerationLimit;       /**< Gioi han tang toc (% cua _maxDuty) */
    float _decelerationLimit;       /**< Gioi han giam toc (% cua _maxDuty) */

    /* Khoang cach an toan */
    float _safeDistance;            /**< Khoang cach an toan (cm) */

    /* Thong so PWM */
    float _maxDuty;                 /**< Gia tri PWM toi da */

    /* Trang thai he thong */
    int _direction;      /**< Huong quay */
    int _status;            /**< Trang thai dong co */

    /* Con tro ham Update */
    void (*Update)(struct _MotorDC *motor); /**< Ham cap nhat (PID + PWM) */
} _MotorDC;

extern _MotorDC motorDC;
/* ==============================
     HAM KHOI TAO & CAI DAT
   ============================== */

/**
 * @brief Khoi tao doi tuong _MotorDC.
 *
 * Ham nay khoi tao cac tham so ban dau cua _MotorDC va goi ham PWM_Init voi:
 *   - Tan so: 5000 Hz
 *   - Kenh PWM: PWM_CHANNEL
 *   - Timer_prescale: 0
 *   - Su dung Timer 1.
 * Gia tri tra ve cua PWM_Init duoc gan cho _maxDuty.
 *
 * @param motor        Con tro den doi tuong _MotorDC.
 * @param kp, ki, kd   He so PID.
 * @param targetSpeed  Toc do muc tieu ban dau (0-100%).
 */
void _MotorDC_Init(_MotorDC *motor, float kp, float ki, float kd, float targetSpeed);

/**
 * @brief Dat toc do muc tieu cua dong co (0-100%).
 *
 * @param motor        Con tro den doi tuong _MotorDC.
 * @param targetSpeed  Toc do muc tieu (0-100%).
 */
void _MotorDC_SetTargetSpeed(_MotorDC *motor, float targetSpeed);

/**
 * @brief Dat huong quay cua dong co.
 *
 * @param motor     Con tro den doi tuong _MotorDC.
 * @param direction Huong quay (MOTOR_DIRECTION_FORWARD hoac MOTOR_DIRECTION_REVERSE).
 * @note Su dung macro MOTOR_DIR_LAT de set chan dieu khien huong.
 */
void _MotorDC_SetDirection(_MotorDC *motor, MotorDirection direction);

/**
 * @brief Bat dong co.
 *
 * @param motor Con tro den doi tuong _MotorDC.
 * @note Su dung macro MOTOR_ENABLE_LAT de bat chan enable.
 */
void _MotorDC_Enable(_MotorDC *motor);

/**
 * @brief Tat dong co.
 *
 * @param motor Con tro den doi tuong _MotorDC.
 * @note Su dung macro MOTOR_ENABLE_LAT de tat chan enable.
 */
void _MotorDC_Disable(_MotorDC *motor);

/**
 * @brief Lay trang thai cua dong co.
 *
 * @param motor Con tro den doi tuong _MotorDC.
 * @return MotorStatus Trang thai (MOTOR_STATUS_ENABLED hoac MOTOR_STATUS_DISABLED).
 */
 
void _MotorDC_Disable_Emergency(_MotorDC *motor);
 
MotorStatus _MotorDC_GetStatus(_MotorDC *motor);

/**
 * @brief Dat gioi han tang toc (don vi % cua _maxDuty).
 *
 * @param motor    Con tro den doi tuong _MotorDC.
 * @param accLimit Gia tri gioi han tang toc (0-100%), duoc tinh theo % cua _maxDuty.
 */
void _MotorDC_SetAccelerationLimit(_MotorDC *motor, float accLimit);

/**
 * @brief Dat gioi han giam toc (don vi % cua _maxDuty).
 *
 * @param motor    Con tro den doi tuong _MotorDC.
 * @param decLimit Gia tri gioi han giam toc (0-100%), duoc tinh theo % cua _maxDuty.
 */
void _MotorDC_SetDecelerationLimit(_MotorDC *motor, float decLimit);

/**
 * @brief Dat khoang cach an toan (cm).
 *
 * @param motor       Con tro den doi tuong _MotorDC.
 * @param safeDistance Khoang cach an toan (cm).
 */
void _MotorDC_SetSafeDistance(_MotorDC *motor, float safeDistance);

/**
 * @brief Dat gia tri PWM toi da (_maxDuty).
 *
 * @param motor   Con tro den doi tuong _MotorDC.
 * @param maxDuty Gia tri PWM toi da.
 */
void _MotorDC_SetMaxDuty(_MotorDC *motor, unsigned int maxDuty);

/* ==============================
     HAM CAP NHAT & PID
   ============================== */
void _MotorDC_Set_Idle(_MotorDC *motor);
/**
 * @brief Cap nhat thuat toan PID va dieu chinh PWM.
 *
 * Toan bo cac tinh toan duoc quy doi sang 0-100%. Gia tri output (0-100%) sau do duoc chuyen sang
 * gia tri PWM thuc te: (output * _maxDuty)/100.
 */
void _MotorDC_UpdatePID(_MotorDC *motor);

/**
 * @brief Ham Update tong hop: neu dong co duoc bat thi cap nhat PID va PWM.
 */
void _MotorDC_Update(_MotorDC *motor);

/* ==============================
     CAC HAM GET THONG TIN
   ============================== */

/**
 * @brief Lay toc do muc tieu (0-100%).
 */
float _MotorDC_GetTargetSpeed(_MotorDC *motor);

/**
 * @brief Lay toc do hien tai (0-100%).
 */
float _MotorDC_GetCurrentSpeed(_MotorDC *motor);

/**
 * @brief Lay gioi han tang toc (don vi % cua _maxDuty).
 */
float _MotorDC_GetAccelerationLimit(_MotorDC *motor);

/**
 * @brief Lay gioi han giam toc (don vi % cua _maxDuty).
 */
float _MotorDC_GetDecelerationLimit(_MotorDC *motor);

/**
 * @brief Lay khoang cach an toan (cm).
 */
float _MotorDC_GetSafeDistance(_MotorDC *motor);

/**
 * @brief Lay gia tri PWM toi da (_maxDuty).
 */
unsigned int _MotorDC_GetMaxDuty(_MotorDC *motor);

/**
 * @brief Lay huong quay.
 */
MotorDirection _MotorDC_GetDirection(_MotorDC *motor);

/**
 * @brief Lay gia tri dau ra (output) cua PID (0-100%).
 */
float _MotorDC_GetOutput(_MotorDC *motor);

/**
 * @brief Lay gia tri khoang cach (cm) tu cam bien.
 */
float _MotorDC_GetDistanceSensorValue(_MotorDC *motor);

/**
 * @brief Xuat toan bo thong tin cua _MotorDC duoi dang chuoi JSON.
 *
 * Chuoi JSON gom cac truong: targetSpeed, currentSpeed, accelerationLimit,
 * decelerationLimit, safeDistance, maxDuty, direction, status, output, distanceSensorValue.
 *
 * @return Con tro den chuoi JSON.
 */
char* _MotorDC_GetInfo(_MotorDC *motor);

#endif  // MOTORDC_H