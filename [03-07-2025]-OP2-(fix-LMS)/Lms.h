#ifndef EMER_BUTTON_H
#define EMER_BUTTON_H
#include <stdint.h>

typedef struct {
     uint8_t status;
     uint8_t buzzer;
} Lms;

extern Lms _lms;
void Lms_Init(void);
uint8_t Lms_isPressed(void);
void Lms_Task(void);

#endif