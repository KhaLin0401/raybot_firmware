#ifndef _DISTANCE_SENSOR_H_
#define _DISTANCE_SENSOR_H_

#include <stdint.h>

// S? lu?ng m?u trung b�nh (l?c)
#define FILTER_SIZE 10

// Lo?i c?m bi?n kho?ng c�ch
typedef enum {
    SENSOR_GP2Y0A21YK0F,  // 10 - 80 cm
    SENSOR_GP2Y0A02YK0F   // 15 - 150 cm
} SensorType;

// C?u tr�c d?i tu?ng c?m bi?n
typedef struct {
    uint16_t readings[FILTER_SIZE];  // M?ng luu gi� tr? ADC
    uint16_t filtered_value;         // Gi� tr? ADC trung b�nh d� l?c
    float distance_cm;               // Kho?ng c�ch t�nh b?ng cm
    uint8_t index;                   // V? tr� hi?n t?i trong m?ng readings
    float calib;                     // Gi� tr? hi?u ch?nh (cm)
    uint8_t adc_channel;             // K�nh ADC
    SensorType sensor_type;          // Lo?i c?m bi?n
} DistanceSensor;

// Kh?i t?o c?m bi?n
void DistanceSensor_Init(DistanceSensor *sensor, uint8_t channel, SensorType type);

// C?p nh?t gi� tr? c?m bi?n
void DistanceSensor_Update(DistanceSensor *sensor);

// L?y gi� tr? ADC trung b�nh d� l?c
uint16_t DistanceSensor_GetValue(DistanceSensor *sensor);

// L?y kho?ng c�ch t�nh theo cm
float DistanceSensor_GetDistanceCM(DistanceSensor *sensor);

#endif  // _DISTANCE_SENSOR_H_
