/* ==========================
   robot_system.c - Implementation File
   M� t?: Ch?a ph?n tri?n khai c�c h�m cho h? th?ng robot.
   ========================== */

#include "robot_system.h"
#include <string.h>


/* ===== �?nh danh h? th?ng ===== */
char DEVICE_ID[16] = "UPPER_BOARD_001";  // ID thi?t b?
char DEVICE_SERIAL[16] = "SN_UPPER_001"; // S? serial c?a thi?t b?
char ROBOT_MODEL[16] = "RAYBOT_2024";  // ID thi?t b?
char FW_VER[16] = "1.0.0"; // S? serial c?a thi?t b?

/* ===== C?m bi?n kho?ng c�ch =====  */
DistanceSensor sensor_front;  // C?m bi?n ph�a tru?c
DistanceSensor sensor_rear;   // C?m bi?n ph�a sau
DistanceSensor sensor_lifter; // C?m bi?n n�ng
DistanceSensor sensor_box;    // Cam bien phat hien vat the trong hop

/**
 * @brief Kh?i t?o c?m bi?n kho?ng c�ch
 */
void init_distance_sensors() {
    DistanceSensor_Init(&sensor_front, SENS3, SENSOR_GP2Y0A21YK0F);
    DistanceSensor_Init(&sensor_rear, SENS4, SENSOR_GP2Y0A21YK0F);
    DistanceSensor_Init(&sensor_lifter, SENS5, SENSOR_GP2Y0A02YK0F);
    DistanceSensor_Init(&sensor_box, SENS6, SENSOR_GP2Y0A21YK0F);

}

/**
 * @brief C?p nh?t gi� tr? c?a t?t c? c?m bi?n kho?ng c�ch
 */
void update_all_sensors() {
    char debug_msg[128];
    DistanceSensor_Update(&sensor_front);
    DistanceSensor_Update(&sensor_rear);
    DistanceSensor_Update(&sensor_lifter);
    DistanceSensor_Update(&sensor_box);

    // =======================
    // Debug th�ng tin c?m bi?n
    // =======================
    /*sprintf(debug_msg, "Sensor Front: %d mm\n", sensor_front.distance_cm);
    DebugUART_Send_Text(debug_msg);

    sprintf(debug_msg, "Sensor Rear: %d mm\n", sensor_rear.distance_cm);
    DebugUART_Send_Text(debug_msg);

    sprintf(debug_msg, "Sensor Lifter: %d mm\n", sensor_lifter.distance_cm);
    DebugUART_Send_Text(debug_msg);*/
}

/* ===== UART Debug ===== */
char debug_uart_buffer[64];

/**
 * @brief Kh?i t?o UART debug
 */
void DebugUART_Init() {
    Soft_UART_Init(&PORTA, 1, 0, 9600, 0); // TX: RC7, RX: RC6, Baud 9600
}

/**
 * @brief G?i chu?i van b?n qua UART debug
 * @param text Chu?i c?n g?i
 */
void DebugUART_Send_Text(const char *text) {
    int i;
    for (i = 0; i < 150 && text[i] != '\0'; i++) {
        Soft_UART_Write(text[i]);
    }
}