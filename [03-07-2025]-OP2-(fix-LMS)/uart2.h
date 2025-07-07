#ifndef _UART2_H
#define _UART2_H

#include <stdint.h>

#define _UART2_CMD_BUFFER_SIZE 180   // S? ký t? t?i da cho 1 l?nh
#define _UART2_RX_STACK_SIZE   15    // S? ô c?a ngan x?p RX
#define _UART2_TX_STACK_SIZE   10    // S? ô c?a ngan x?p TX

typedef struct {
    // Ngan x?p l?nh nh?n du?c (RX)
    char _rx_stack[_UART2_RX_STACK_SIZE][_UART2_CMD_BUFFER_SIZE];
    volatile uint8_t _rx_head;  // V? trí ghi (push) m?i
    volatile uint8_t _rx_tail;  // V? trí d?c (pop) l?nh cu nh?t

    // Ngan x?p l?nh g?i di (TX)
    char _tx_stack[_UART2_TX_STACK_SIZE][_UART2_CMD_BUFFER_SIZE];
    volatile uint8_t _tx_head;  // V? trí ghi m?i
    volatile uint8_t _tx_tail;  // V? trí d?c l?nh c?n g?i

    // Buffer t?m th?i d? xây d?ng l?nh RX t? ISR
    char _temp_rx_buffer[_UART2_CMD_BUFFER_SIZE];
    volatile uint8_t _temp_index;
} _UART2_Object;

extern _UART2_Object _uart2;

/* Kh?i t?o module UART2 (bao g?m c?u hình ng?t RX) */
void _UART2_Init(void);

/* --- Ph?n TX --- */
/* Hàm push l?nh c?n g?i vào TX stack.
   N?u stack d?y, l?nh s? b? t? ch?i và in ra thông báo l?i. */
void _UART2_SendPush(const char *text);

/* Hàm g?i d? li?u blocking qua UART2 (dùng bên trong SendProcess) */
int _UART2_SendBlocking(const char *text);

/* Hàm du?c scheduler g?i d?nh k? d? l?y l?nh t? TX stack và g?i di.
   N?u có l?nh d? g?i, hàm s? pop l?nh ra và g?i hàm g?i blocking. */
uint8_t _UART2_SendProcess(void);

/* --- Ph?n RX --- */
/* Hàm pop l?nh t? RX stack d? scheduler l?y và x? lý.
   Sau khi l?y ra, ô dó du?c xóa và s?n sàng nh?n l?nh m?i. */
uint8_t _UART2_Rx_GetCommand(char *out_cmd);

/* Hàm ISR (du?c g?i trong ng?t UART2 RX) d? nh?n ký t? và xây d?ng l?nh.
   Ch? nh?ng l?nh có ký t? d?u tiên là '>' ho?c b?t d?u b?ng "GET" ho?c "SET"
   và k?t thúc b?ng '\n' ho?c '\r' m?i du?c dua vào RX stack. */
void _UART2_Rx_Receive_ISR(void);

#endif /* _UART2_H */
