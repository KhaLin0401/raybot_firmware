#ifndef _ROBOT_SYSTEM_H_
#define _ROBOT_SYSTEM_H_

#include <stdint.h>
#include "uart2.h"
#include "schedule_task.h"
#include "distance_sensor.h"
#include "command_handler.h"  // �?m b?o khai b�o tru?c `cmdHandler`
#include "MotorDC.h"


/* ===== UART Configuration ===== */
#define TX1 8
#define RX1 9
#define TX2 10
#define RX2 11

/* ===== Relay Outputs ===== */
#define RELAY1 12
#define RELAY2 15

/* ===== C?m bi?n kho?ng c�ch (Analog Inputs) ===== */
#define SENS3 4
#define SENS4 5
#define SENS5 6
#define SENS6 7

/* ===== �?nh danh h? th?ng ===== */
extern char DEVICE_ID[16];
extern char DEVICE_SERIAL[16];
extern char ROBOT_MODEL[16];  // ID thi?t b?
extern char FW_VER[16]; // S? serial c?a thi?t b?

/* ===== C?m bi?n kho?ng c�ch ===== */
extern DistanceSensor sensor_front;
extern DistanceSensor sensor_rear;
extern DistanceSensor sensor_lifter;
extern DistanceSensor sensor_box;

void init_distance_sensors();
void update_all_sensors();


/* ===== KHOI TAO USSB DEBUG ===== */
void DebugUART_Init();
void DebugUART_Send_Text(const char *text);



#endif  // _ROBOT_SYSTEM_H_