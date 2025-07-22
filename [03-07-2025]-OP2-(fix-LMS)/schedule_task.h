#ifndef SCHEDULE_TASK_H
#define SCHEDULE_TASK_H

#include <stdint.h>

/* ==============================
   schedule_task.h - Task Scheduler
   M� t?: Qu?n l� c�c task trong h? th?ng, ch?y theo tick 1ms.
   ============================== */

/* ===== Khai b�o ID cho c�c task ===== */
extern uint8_t _task_uart;          // Task x? l� l?nh UART
extern uint8_t _task_update_system; // Task c?p nh?t c?m bi?n
extern uint8_t _task_update_motor; // Task c?p nh?t c?m bi?n
extern uint8_t _task_update_to_server; // Task c?p nh?t c?m bi?n
extern uint8_t _task_respond_Init;
extern uint8_t _task_update_BMS;

/* ===== Khai b�o c�c h�m qu?n l� Task ===== */
void _F_schedule_init(void);         // Kh?i t?o Task Scheduler
void _F_process_uart_command(void);  // X? l� l?nh UART
void _F_update_system_status(void);  // C?p nh?t c?m bi?n
void _F_update_to_server(void);  // C?p nh?t c?m bi?n
void _F_respond_to_server(void);
void Respond_Init();
unsigned long GetMillis(void);
#endif /* SCHEDULE_TASK_H */