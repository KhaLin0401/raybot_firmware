#include "Lms.h"
#include "MotorDC.h"
#include "Lifter.h"

Lms _lms;


void Lms_Init(void){
    _lms.status = Button(&PORTA, 9, 20, 1);
    _lms.buzzer = 0;
}

uint8_t Lms_isPressed(void){
    _lms.status = Button(&PORTA, 9, 20, 1);
    if (_lms.status == 255)
        return 1;
    else return 0;
}

void Lms_Task(void){

}