#include "schedule_task.h"
#include "robot_system.h"
#include "uart2.h"
#include "command_handler.h"
#include "MotorDC.h"
#include "BMS.h"
#include "Lifter.h"
#include "Lms.h"
#include "Box.h"
int send_index;
// Khai b?o Task ID
uint8_t _task_uart;          // Task x? l? l?nh UART
uint8_t _task_update_system; // Task c?p nh?t c?m bi?n
uint8_t _task_update_motor;  // Task c?p nh?t d?ng co
uint8_t _task_update_to_server;  // Task c?p nh?t d?ng co
uint8_t _task_respond_Init;
uint8_t _task_update_BMS;
/**
 * @brief Kh?i t?o Timer2 v?i tick ~1ms.
 */
void _F_timer1_init(void) {
    // C?u h�nh Timer1:
    //  - T1CON = 0x8030: b?t Timer1, thi?t l?p prescaler 1:256 (v?i gi� tr? prescaler h?p l?: 1, 8, 64, 256)
    //  - PR1 = 6200: thi?t l?p chu k?, tick kho?ng 1ms (theo c�ch t�nh d?a tr�n Fosc)
    T1CON = 0x8030;
    PR1 = 6200;
    TMR1 = 0;

    // C�i d?t m?c uu ti�n ng?t cho Timer1 (v� d?: 5)
    IPC0bits.T1IP = 5;
    IFS0bits.T1IF = 0;  // X�a c? ng?t Timer1
    IEC0bits.T1IE = 1;  // Cho ph�p ng?t Timer1
}

/**
 * @brief Ng?t Timer1 (ISR): G?i h�m task_scheduler_clock() cho m?i tick (~1ms).
 */
void __attribute__() iv IVT_ADDR_T1INTERRUPT ics ICS_AUTO {
    task_scheduler_clock();
    IFS0bits.T1IF = 0;
}

/**
 * @brief Task x? l? l?nh UART t? h?ng d?i (kh?ng blocking).
 */
// Ham xu ly lenh nhan duoc tu UART2
// Goi dinh ky trong task UART2 (5-10ms)
void _F_process_uart_command(void) {
    char _command[_UART2_CMD_BUFFER_SIZE];
    uint8_t _command_available;
    

    if(_UART2_Rx_GetCommand(_command)) {

        // Bat dau xu ly cac lenh nhan duoc tai day
        if (strcmp(_command, "GET_STATUS") == 0) {
            // Xu ly lenh GET_STATUS
//           DebugUART_Send_Text("[Lenh GET_STATUS nhan duoc]\n");
        }
        else if (strcmp(_command, "RESET") == 0) {
            // Goi ham reset he thong
//           DebugUART_Send_Text("[He thong dang RESET]\n");
            // System_Reset();
        }
        else if (strncmp(_command, "SET_", 4) == 0) {
            // Goi ham xu ly lenh SET
//            DebugUART_Send_Text("[Lenh SET_ nhan duoc]\n");
            CommandHandler_Execute(&cmdHandler,_command);
            // Handle_SetCommand(_command);
        }
        else if (strncmp(_command, "GET_", 4) == 0) {
            // Goi ham xu ly lenh GET
            //DebugUART_Send_Text("[Lenh GET_ nhan duoc]\n");
            CommandHandler_Execute(&cmdHandler,_command);
            // Process_Get_Command(_command);
        }
        else if (_command[0] == '>') {
             // Goi ham xu ly lenh GET
//             DebugUART_Send_Text("[Lenh_Json_Nhan_duoc]\n");
             CommandHandler_Execute(&cmdHandler,_command);
            // Process_Get_Command(_command);
        }
        else {
            // Lenh khong hop le, bao loi
            DebugUART_Send_Text("[Lenh khong hop le]\n");
        }



    }
    _UART2_SendProcess();
    // Tiep tuc gui cac du lieu con lai trong hang doi UART2 (neu co)

    BMS_Update();
    //DebugUART_Send_Text("CHDEBUG: Task-1 ");
}


/**
 * @brief Task c?p nh?t d? li?u c?m bi?n.
 */
void _F_update_system_status(void) {
    // Kh?ng d?ng Delay_ms(), c?p nh?t ngay.
    //Emer_Button_Task();
    update_all_sensors();
    Box_UpdateStatus(&Box_t);

  //  DebugUART_Send_Text("CHDEBUG: Task-2 ");
}

/**
 * @brief Task c?p nh?t d?ng co: t?nh PID, ?p d?ng smoothing v? c?p nh?t PWM.
 */
void _SC_update_motor(void) {
        //DebugUART_Send_Text("KHOI TAO HOAN TAT \n");
        if(motorDC._direction == 0) // Chay THUAN
            motorDC._distanceSensorValue = sensor_front.distance_cm;
        else if(motorDC._direction == 1)
            motorDC._distanceSensorValue = sensor_rear.distance_cm;
        else
            motorDC._distanceSensorValue = 0;
        lifter._currentPosition = sensor_lifter.distance_cm;
        //test
        //motorDC._distanceSensorValue = 50;
        // G?i h?m Update c?a motorDC d? c?p nh?t PID v? PWM
        _Lifter_Get_Run_Mode(&lifter);
        if (Lms_isPressed() && lifter.run_mode == LIFTER_RUN_UP){
          _Lifter_Disable(&lifter);         // D?ng motor n�ng h?       // C?p nh?t motor ph?
          LATA4_bit = 1;                    // Buzzer k�u c?nh b�o
        }
        else
        {

            _Lifter_Update(&lifter);             // C?p nh?t PID cho lifter

            /*if (lifter._output > 0 && lifter._status == 1) {
                LATA4_bit = 0;                   // N?u v?n dang ch?y ? buzzer t?t
            } else {
                LATA4_bit = 1;
            }*/
        }
        //motorDC.Update(&motorDC);  // N?u c�ng t?c h�nh tr�nh b? k�ch ho?c xu?ng du?i m?c min
        if (lifter._currentPosition <= 25 || Lms_isPressed()){
            _MotorDC_UpdatePID(&motorDC);
        }
        if (motorDC._output <= 0){
            LATB4_bit = 1;
            LATA8_bit = 1;
        }
        else {
            LATB4_bit = 0;
            LATA8_bit = 0;
        }
        /*else {
            motorDC._targetSpeed = 0;
            motorDC.Update(&motorDC);
        }*/
//     DebugUART_Send_Text("CHDEBUG: Task-3 ");

}


void _F_update_to_server(void){

     switch(send_index){
           case 0:
                handle_get_bat_info(&cmdHandler);
                CommandHandler_Respond(&cmdHandler);
                send_index = 1;
                break;
           case 1:
               handle_get_chg_info(&cmdHandler);
               CommandHandler_Respond(&cmdHandler);
                send_index = 2;
                break;
           case 2:
                handle_get_dis_info(&cmdHandler);
                CommandHandler_Respond(&cmdHandler);
                send_index = 3;
                break;
           case 3:
               handle_get_dist_info(&cmdHandler);
                CommandHandler_Respond(&cmdHandler);
                send_index = 4;
                break;
           case 4:
               handle_get_lifter_info(&cmdHandler);
                CommandHandler_Respond(&cmdHandler);
                send_index = 5;
                break;
           case 5:
                handle_get_motor_info(&cmdHandler);
                CommandHandler_Respond(&cmdHandler);
                send_index = 7;
                break;
           case 6:
                break;
           case 7:
                handle_get_box_status(&cmdHandler);
                CommandHandler_Respond(&cmdHandler);
                send_index = 0;
                break;
           default:
                send_index = 0;
                break;
      }
      //DebugUART_Send_Text("CHDEBUG: Task-4 ");
}



/**
 * @brief Kh?i t?o Scheduler v? th?m c?c task.
 */
void _F_schedule_init(void) {
    DebugUART_Send_Text("Initializing Task Scheduler...\n");

    // Kh?i t?o Timer2 v?i tick ~1ms
    _F_timer1_init();
    // Kh?i t?o scheduler v?i tick = 1000 (1ms/tick)
    task_scheduler_init(1000);

    // Th?m task: c?c kho?ng th?i gian t?nh b?ng ms (non-blocking)
    _task_uart = task_add(_F_process_uart_command, 50);
    _task_update_to_server = task_add(_F_update_to_server, 950);
    _task_update_motor = task_add(_SC_update_motor, 100);
    _task_update_BMS = task_add(BMS_Update, 850);
    _task_update_system = task_add(_F_update_system_status, 75);
    task_scheduler_start();
    DebugUART_Send_Text("Task Scheduler initialization complete!\n");

}