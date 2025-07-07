#include "Lifter.h"
#include <stdio.h>
#include "robot_system.h"
#include "Lms.h"
/* Khai b�o bi?n lifter to�n c?c */
_Lifter lifter;


/* H�m kh?i t?o lifter */
void _Lifter_Init(_Lifter *pLifter, float kp, float ki, float kd, float targetPosition) {
  char buffer[256];

  // C?u h�nh ch�n ENABLE (RB5)
  LIFTER_ENABLE_TRIS = 0; // Output
  LIFTER_ENABLE_LAT = 1;  // T?t m?c d?nh

  pLifter->_kp = kp;
  pLifter->_ki = ki;
  pLifter->_kd = kd;
  pLifter->_targetPosition = targetPosition;
  pLifter->_currentPosition = 0;
  pLifter->_error = 0;
  pLifter->_lastError = 0;
  pLifter->_integral = 0;
  pLifter->_output = 0;
  pLifter->_maxOutput = 100;

  /* Thi?t l?p gi?i h?n tang/gi?m t?c */
  pLifter->_accelerationLimit = 5.0;
  pLifter->_decelerationLimit = 7.0;

  /* Thi?t l?p gi?i h?n v? tr� */
  pLifter->_minPosition = 27;
  pLifter->_maxPosition = 235;

  /* Kh?i t?o PWM3 v� PWM4 */
  pLifter->_maxDuty = PWM_Init(5000, PWM_CHANNEL_ALI, 1, 3);
  PWM_Init(5000, PWM_CHANNEL_BLI, 1, 3); // Kh?i t?o PWM4 (RP6)
  PWM_Start(PWM_CHANNEL_ALI);
  PWM_Start(PWM_CHANNEL_BLI);

  /* Tr?ng th�i ban d?u: t?t h? th?ng lifter */
  pLifter->_status = LIFTER_STATUS_DISABLED;

  /* G�n h�m c?p nh?t PID v� PWM */
  pLifter->Update = _Lifter_Update;
}

/* H�m thi?t l?p gi?i h?n v? tr� */
void _Lifter_SetPositionLimits(_Lifter *pLifter, float minPosition, float maxPosition) {
pLifter->_minPosition = minPosition;
pLifter->_maxPosition = maxPosition;
}

/* H�m d?t v? tr� m?c ti�u */
void _Lifter_SetTargetPosition(_Lifter *pLifter, float targetPosition) {
  if (targetPosition < pLifter->_minPosition) {
     targetPosition = pLifter->_minPosition;
  } else if (targetPosition > pLifter->_maxPosition) {
    targetPosition = pLifter->_maxPosition;
  } 
  pLifter->_targetPosition = targetPosition;
  pLifter->_integral = 0;
  pLifter->_lastError = 0;
}

/* H�m b?t lifter */
void _Lifter_Enable(_Lifter *pLifter) {
pLifter->_status = LIFTER_STATUS_ENABLED;
LIFTER_ENABLE_LAT = 0; // B?t c?u H
}

/* H�m t?t lifter */
void _Lifter_Disable(_Lifter *pLifter) {
pLifter->_status = LIFTER_STATUS_DISABLED;
PWM_Set_Duty(0, PWM_CHANNEL_ALI);
PWM_Set_Duty(0, PWM_CHANNEL_BLI);
LIFTER_ENABLE_LAT = 1; // T?t c?u H
pLifter->_output = 0;
}

void _Lifter_Set_maxOutput(_Lifter *pLifter, float maxOutput){
     pLifter->_maxOutput = maxOutput;
}
/* H�m thi?t l?p gi?i h?n tang t?c */
void _Lifter_SetAccelerationLimit(_Lifter *pLifter, float accLimit) {
pLifter->_accelerationLimit = accLimit;
}

/* H�m thi?t l?p gi?i h?n gi?m t?c */
void _Lifter_SetDecelerationLimit(_Lifter *pLifter, float decLimit) {
     pLifter->_decelerationLimit = decLimit;
}

void _Lifter_Get_Run_Mode(_Lifter *pLifter){
     if (pLifter->_targetPosition > pLifter->_currentPosition && pLifter->_output == 0)
        pLifter->run_mode = LIFTER_RUN_DOWN;
     else if (pLifter->_targetPosition < pLifter->_currentPosition && pLifter->_output == 0)
        pLifter->run_mode = LIFTER_RUN_UP;
}

/* H�m c?p nh?t PID v� PWM */
void _Lifter_Update(_Lifter *pLifter) {
  unsigned int pwmDuty;
  float derivative, pidOutput, delta;

  if (pLifter->_status != LIFTER_STATUS_ENABLED) {
    PWM_Set_Duty(0, PWM_CHANNEL_ALI);
    PWM_Set_Duty(0, PWM_CHANNEL_BLI);
    LIFTER_ENABLE_LAT = 1; // T?t c?u H
    pLifter->_output = 0;
    return;
  }

  // B?t c?u H
  LIFTER_ENABLE_LAT = 0;

  // X�c d?nh ch? d? ch?y
  if (pLifter->_targetPosition > pLifter->_currentPosition && pLifter->_output == 0)
     pLifter->run_mode = LIFTER_RUN_DOWN;
  else if (pLifter->_targetPosition < pLifter->_currentPosition && pLifter->_output == 0)
       pLifter->run_mode = LIFTER_RUN_UP;

  if (pLifter->run_mode == LIFTER_RUN_DOWN) {
  // Th? xu?ng: ALI = PWM, BLI = 0
     PWM_Set_Duty(0, PWM_CHANNEL_BLI);
     pLifter->_error = pLifter->_targetPosition - pLifter->_currentPosition;

  if (pLifter->_currentPosition >= pLifter->_targetPosition ||
     pLifter->_currentPosition >= pLifter->_maxPosition) {
     PWM_Set_Duty(0, PWM_CHANNEL_ALI);
     PWM_Set_Duty(0, PWM_CHANNEL_BLI);
     LIFTER_ENABLE_LAT = 1;
     pLifter->_output = 0;
     pLifter->_status = LIFTER_STATUS_DISABLED;
  return;
  }

  pLifter->_integral += pLifter->_error;
  if (pLifter->_integral > 1000) pLifter->_integral = 1000;
  else if (pLifter->_integral < -1000) pLifter->_integral = -1000;

  derivative = pLifter->_error - pLifter->_lastError;
  pLifter->_lastError = pLifter->_error;
  pidOutput = pLifter->_kp * pLifter->_error +
  pLifter->_ki * pLifter->_integral +
  pLifter->_kd * derivative;

  delta = pidOutput;
  if (delta > pLifter->_accelerationLimit)
  delta = pLifter->_accelerationLimit;

  pLifter->_output += delta;
  if (pLifter->_output > pLifter->_maxOutput)
  pLifter->_output = pLifter->_maxOutput;
  else if (pLifter->_output < 0)
  pLifter->_output = 0;

  pwmDuty = (unsigned int)((pLifter->_output / 100.0) * pLifter->_maxDuty);
  PWM_Set_Duty(0, PWM_CHANNEL_BLI);
  PWM_Set_Duty(pwmDuty, PWM_CHANNEL_ALI);
  }
  else if (pLifter->run_mode == LIFTER_RUN_UP) {
  // K�o l�n: ALI = 0, BLI = PWM
  PWM_Set_Duty(0, PWM_CHANNEL_ALI);
  pLifter->_error = pLifter->_currentPosition - pLifter->_targetPosition;

  if (pLifter->_currentPosition <= pLifter->_targetPosition ||
  pLifter->_currentPosition <= pLifter->_minPosition) {
  PWM_Set_Duty(0, PWM_CHANNEL_ALI);
  PWM_Set_Duty(0, PWM_CHANNEL_BLI);
  LIFTER_ENABLE_LAT = 1;
  pLifter->_output = 0;
  pLifter->_status = LIFTER_STATUS_DISABLED;
  return;
  }

  pLifter->_integral += pLifter->_error;
  if (pLifter->_integral > 1000) pLifter->_integral = 1000;
  else if (pLifter->_integral < -1000) pLifter->_integral = -1000;

  derivative = pLifter->_error - pLifter->_lastError;
  pLifter->_lastError = pLifter->_error;
  pidOutput = pLifter->_kp * pLifter->_error +
  pLifter->_ki * pLifter->_integral +
  pLifter->_kd * derivative;

  delta = pidOutput;
  if (delta > pLifter->_accelerationLimit)
  delta = pLifter->_accelerationLimit;

  pLifter->_output += delta;
  if (pLifter->_output > pLifter->_maxOutput)
  pLifter->_output = pLifter->_maxOutput;
  else if (pLifter->_output < 0)
  pLifter->_output = 0;

  pwmDuty = (unsigned int)((pLifter->_output / 100.0) * pLifter->_maxDuty);
  PWM_Set_Duty(0, PWM_CHANNEL_ALI);
  PWM_Set_Duty(pwmDuty, PWM_CHANNEL_BLI);
  }
  else {
  PWM_Set_Duty(0, PWM_CHANNEL_ALI);
  PWM_Set_Duty(0, PWM_CHANNEL_BLI);
  LIFTER_ENABLE_LAT = 1;
  pLifter->_output = 0;
  pLifter->_status = LIFTER_STATUS_DISABLED;
  return;
  }
}

/* H�m l?y th�ng tin tr?ng th�i lifter du?i d?ng chu?i JSON /
char _Lifter_GetInfo(_Lifter *pLifter) {
static char jsonStr[256];
sprintf(jsonStr,
"{"targetPosition":%.2f,"currentPosition":%.2f,"minPosition":%.2f,"maxPosition":%.2f,"accelerationLimit":%.2f,"decelerationLimit":%.2f,"maxDuty":%u,"status":%d,"output":%.2f}",
pLifter->_targetPosition,
pLifter->_currentPosition,
pLifter->_minPosition,
pLifter->_maxPosition,
pLifter->_accelerationLimit,
pLifter->_decelerationLimit,
pLifter->_maxDuty,
pLifter->_status,
pLifter->_output
);
return jsonStr;
} */