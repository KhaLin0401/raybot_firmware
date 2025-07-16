#include "robot_system.h"
#include "uart2.h"

#include "BMS.h"
#include "Lifter.h"
#include "Lms.h"


void init_hardware() {
    // C?u h�nh c�c ch�n l�m input
    TRISAbits.TRISA0 = 1;
    TRISAbits.TRISA1 = 1;
   // TRISBbits.TRISB2 = 1;
   // TRISBbits.TRISB3 = 1;
    TRISCbits.TRISC0 = 1;
    TRISCbits.TRISC1 = 1;

    // Kh?i t?o ADC
    ADC1_Init();

    // Chuy?n RA9, RC3 sang digital input
    TRISAbits.TRISA9 = 1;
    AD1PCFGbits.PCFG9 = 1;
    TRISCbits.TRISC4 = 1;
    AD1PCFGbits.PCFG4 = 1;
    
    // // RA8: output
    TRISAbits.TRISA4 = 1;
    LATA4_bit = 1;
    TRISB4_bit = 1; // RB4: output
    LATB4_bit = 1;
    TRISA8_bit = 0; // RA8: output
    LATA8_bit = 1;
    
    // C?u h�nh c�c ch�n di?u khi?n motor (Direction)
    TRISC7_bit = 0; // RC7: output
    LATC7_bit = 1;
    TRISC6_bit = 0; // RB6: output
    LATC6_bit = 0;
    TRISC8_bit = 0; // RC8: output
    LATC8_bit = 1;

    // C?u h�nh ch�n enable cho motor v� lifter
    TRISB12_bit = 0; // EN_M1/M2
    LATB12_bit = 0;
    TRISB5_bit = 0; // EN_lifter
    LATB5_bit = 0;

    // C?u h�nh PPS cho UART v� PWM
    Unlock_IOLOCK();
        PPS_Mapping_NoLock(RX1, _INPUT, _U1RX); // RP13 -> U1RX
        PPS_Mapping_NoLock(TX1, _OUTPUT, _U1TX); // RP14 -> U1TX
        PPS_Mapping_NoLock(RX2, _INPUT, _U2RX);  // RP15 -> U2RX
        PPS_Mapping_NoLock(TX2, _OUTPUT, _U2TX);  // RP12 -> U2TX
        PPS_Mapping_NoLock(25, _OUTPUT, _OC1);    // RP25 -> PWM1
        PPS_Mapping_NoLock(22, _OUTPUT, _OC2);     // RP22  -> PWM2
        PPS_Mapping_NoLock(7, _OUTPUT, _OC3);    // RP7 -> lifter (PWM3)
        PPS_Mapping_NoLock(6, _OUTPUT, _OC4);    // RP6 -> lifter (PWM4)
    Lock_IOLOCK();
}


void main() {
    init_hardware();
    UART1_Init(9600);
    UART2_Init(9600);
    _UART2_Init();

    DebugUART_Init();
    _MotorDC_Init(&motorDC, 2.5, 0.5, 1.0, 0);
    _MotorDC_SetSafeDistance(&motorDC, 40);
    _Lifter_Init(&lifter, 1.0, 0.5, 0.1, 30);
    //DalyBms_init(&bms);
    Lms_Init();
    init_distance_sensors();
    CommandHandler_Init(&cmdHandler);

    _F_schedule_init();

    while (1) {
        task_dispatch(); // Gọi Scheduler của MikroE
    }
}