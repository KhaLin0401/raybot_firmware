#ifndef _UART2_H
#define _UART2_H

#include <stdint.h>

#define _UART2_CMD_BUFFER_SIZE 180   // S? k� t? t?i da cho 1 l?nh
#define _UART2_RX_STACK_SIZE   15    // S? � c?a ngan x?p RX
#define _UART2_TX_STACK_SIZE   10    // S? � c?a ngan x?p TX

typedef struct {
    // Ngan x?p l?nh nh?n du?c (RX)
    char _rx_stack[_UART2_RX_STACK_SIZE][_UART2_CMD_BUFFER_SIZE];
    volatile uint8_t _rx_head;  // V? tr� ghi (push) m?i
    volatile uint8_t _rx_tail;  // V? tr� d?c (pop) l?nh cu nh?t

    // Ngan x?p l?nh g?i di (TX)
    char _tx_stack[_UART2_TX_STACK_SIZE][_UART2_CMD_BUFFER_SIZE];
    volatile uint8_t _tx_head;  // V? tr� ghi m?i
    volatile uint8_t _tx_tail;  // V? tr� d?c l?nh c?n g?i

    // Buffer t?m th?i d? x�y d?ng l?nh RX t? ISR
    char _temp_rx_buffer[_UART2_CMD_BUFFER_SIZE];
    volatile uint8_t _temp_index;
} _UART2_Object;

extern _UART2_Object _uart2;

/* Kh?i t?o module UART2 (bao g?m c?u h�nh ng?t RX) */
void _UART2_Init(void);

/* --- Ph?n TX --- */
/* H�m push l?nh c?n g?i v�o TX stack.
   N?u stack d?y, l?nh s? b? t? ch?i v� in ra th�ng b�o l?i. */
void _UART2_SendPush(const char *text);

/* H�m g?i d? li?u blocking qua UART2 (d�ng b�n trong SendProcess) */
int _UART2_SendBlocking(const char *text);

/* H�m du?c scheduler g?i d?nh k? d? l?y l?nh t? TX stack v� g?i di.
   N?u c� l?nh d? g?i, h�m s? pop l?nh ra v� g?i h�m g?i blocking. */
uint8_t _UART2_SendProcess(void);

/* --- Ph?n RX --- */
/* H�m pop l?nh t? RX stack d? scheduler l?y v� x? l�.
   Sau khi l?y ra, � d� du?c x�a v� s?n s�ng nh?n l?nh m?i. */
uint8_t _UART2_Rx_GetCommand(char *out_cmd);

/* H�m ISR (du?c g?i trong ng?t UART2 RX) d? nh?n k� t? v� x�y d?ng l?nh.
   Ch? nh?ng l?nh c� k� t? d?u ti�n l� '>' ho?c b?t d?u b?ng "GET" ho?c "SET"
   v� k?t th�c b?ng '\n' ho?c '\r' m?i du?c dua v�o RX stack. */
void _UART2_Rx_Receive_ISR(void);

#endif /* _UART2_H */
