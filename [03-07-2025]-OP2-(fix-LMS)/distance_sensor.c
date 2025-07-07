#include "distance_sensor.h"
#include <math.h>
#include <stdio.h>
#include "robot_system.h"

// Ði?n áp tham chi?u ADC (tùy h? th?ng: 3.3V ho?c 5V)
#define VREF 3.3

// Hàm tính trung bình các giá tr? d?c
static uint16_t calculate_average(uint16_t *datat) {
    int i = 0;
    uint32_t sum = 0;
    for (i = 0; i < FILTER_SIZE; i++) {
        sum += datat[i];
    }
    return (uint16_t)(sum / FILTER_SIZE);
}

// Kh?i t?o c?m bi?n
void DistanceSensor_Init(DistanceSensor *sensor, uint8_t channel, SensorType type) {
    int i = 0;
    sensor->adc_channel = channel;
    sensor->sensor_type = type;
    sensor->filtered_value = 0;
    sensor->distance_cm = 0.0;
    sensor->index = 0;

    // Kh?i t?o m?ng readings v?i giá tr? 0
    for (i = 0; i < FILTER_SIZE; i++) {
        sensor->readings[i] = 0;
    }
}

// Chuy?n d?i ADC sang kho?ng cách cho GP2Y0A21YK0F (10-80 cm)
static float convert_gp2y0a21yk0f(uint16_t adc_value) {
    float voltage = (adc_value * VREF) / 1023.0;
    float distance_cm = 27.86 * pow(voltage, -1.15);  // H? s? th?c nghi?m

    if (distance_cm > 80.0) return 80.0;
    if (distance_cm < 10.0) return 10.0;
    return distance_cm;
}

// Chuy?n d?i ADC sang kho?ng cách cho GP2Y0A02YK0F (15-150 cm)
static float convert_gp2y0a02yk0f(uint16_t adc_value) {
    float voltage = (adc_value * VREF) / 1023.0;
    float distance_cm = 47.4 * pow(voltage, -1.10);  // H? s? th?c nghi?m

    if (distance_cm > 250.0) return 250.0;
    if (distance_cm < 20.0) return 20.0;
    
    return distance_cm;
}

// C?p nh?t c?m bi?n và tính kho?ng cách
void DistanceSensor_Update(DistanceSensor *sensor) {
     char debug_buffer[128];
    // Ð?c giá tr? ADC
    sensor->readings[sensor->index] = ADC1_Get_Sample(sensor->adc_channel);
    sensor->filtered_value = calculate_average(sensor->readings);

    // Xác d?nh lo?i c?m bi?n và chuy?n d?i kho?ng cách
    if (sensor->sensor_type == SENSOR_GP2Y0A21YK0F) {
        sensor->distance_cm = convert_gp2y0a21yk0f(sensor->filtered_value);
    } else if (sensor->sensor_type == SENSOR_GP2Y0A02YK0F) {
        sensor->distance_cm = convert_gp2y0a02yk0f(sensor->filtered_value);
    }
    sensor->distance_cm = sensor->distance_cm + sensor->calib;
    // G?i thông tin debug qua UART

    /*sprintf(debug_buffer, "ADC Channel %d: ADC=%u, Distance=%.2f cm\r\n",
            sensor->adc_channel, sensor->filtered_value, sensor->distance_cm);
    DebugUART_Send_Text(debug_buffer);*/

    // C?p nh?t index vòng l?p
    sensor->index = (sensor->index + 1) % FILTER_SIZE;
}

// L?y giá tr? ADC trung bình dã l?c
uint16_t DistanceSensor_GetValue(DistanceSensor *sensor) {
    return sensor->filtered_value;
}

// L?y kho?ng cách tính theo cm
float DistanceSensor_GetDistanceCM(DistanceSensor *sensor) {
    return sensor->distance_cm;
}