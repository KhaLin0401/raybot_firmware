#include "uart2.h"
#include <string.h>
#include "robot_system.h"  // Gi? s? ch?a d?nh nghia c?a DebugUART_Send_Text(), UART2_Read(), UART2_Write()

// Ð?i tu?ng toàn c?c
_UART2_Object _uart2;

/* Kh?i t?o module UART2:
   - Reset các ch? s? c?a RX và TX stack, cung nhu temp buffer.
   - Kích ho?t ng?t RX.
   Các bi?n c?c b? du?c khai báo d?u hàm. */
void _UART2_Init(void) {
    int i;
    _uart2._rx_head = 0;
    _uart2._rx_tail = 0;
    _uart2._tx_head = 0;
    _uart2._tx_tail = 0;
    _uart2._temp_index = 0;
    memset(_uart2._temp_rx_buffer, 0, _UART2_CMD_BUFFER_SIZE);
    for(i = 0; i < _UART2_RX_STACK_SIZE; i++) {
        _uart2._rx_stack[i][0] = '\0';
    }
    for(i = 0; i < _UART2_TX_STACK_SIZE; i++) {
        _uart2._tx_stack[i][0] = '\0';
    }
    IEC1bits.U2RXIE = 1;
    IFS1bits.U2RXIF = 0;
}

/* Hàm g?i d? li?u blocking, g?i t?ng ký t? qua UART2.
   Các bi?n c?c b? du?c khai báo d?u hàm. */
int _UART2_SendBlocking(const char *text) {
    int timeout;
    int result = 1;
    while(*text) {
        timeout = 1000;
        while(U2STAbits.UTXBF && timeout > 0) {
            timeout--;
        }
        if(timeout == 0) {
            DebugUART_Send_Text("UART2 TX: Timeout waiting for TX buffer\n");
            result = 0;
            break;
        }
        UART2_Write(*text++);
    }
    return result;
}

/* Hàm push l?nh vào TX stack.
   N?u TX stack d?y, l?nh s? b? t? ch?i.
   Các bi?n c?c b? du?c khai báo d?u hàm. */
void _UART2_SendPush(const char *text) {
    uint8_t next_head;
    next_head = (_uart2._tx_head + 1) % _UART2_TX_STACK_SIZE;
    if(next_head == _uart2._tx_tail) {
        DebugUART_Send_Text("UART2 TX Stack Full. Dropping command.\n");
        return;
    }
    strncpy(_uart2._tx_stack[_uart2._tx_head], text, _UART2_CMD_BUFFER_SIZE - 1);
    _uart2._tx_stack[_uart2._tx_head][_UART2_CMD_BUFFER_SIZE - 1] = '\0';
    _uart2._tx_head = next_head;
}

/* Hàm du?c scheduler g?i d?nh k? d? x? lý TX stack.
   N?u có l?nh, l?y l?nh ra và g?i di, sau dó xóa ô dó.
   Các bi?n c?c b? du?c khai báo d?u hàm. */
uint8_t _UART2_SendProcess(void) {
    uint8_t ret = 0;char *cmd;
    if(_uart2._tx_tail != _uart2._tx_head) {

        cmd = _uart2._tx_stack[_uart2._tx_tail];
        if(_UART2_SendBlocking(cmd)) {
            _uart2._tx_stack[_uart2._tx_tail][0] = '\0';
            _uart2._tx_tail = (_uart2._tx_tail + 1) % _UART2_TX_STACK_SIZE;
            ret = 1;
        } else {
            DebugUART_Send_Text("UART2 TX: Failed to send command.\n");
        }
    }
    return ret;
}

/* Hàm pop l?nh t? RX stack d? scheduler l?y và x? lý.
   Sau khi l?y ra, ô dó du?c xóa và s?n sàng nh?n l?nh m?i.
   Các bi?n c?c b? du?c khai báo d?u hàm. */
uint8_t _UART2_Rx_GetCommand(char *out_cmd) {
    uint8_t ret = 0;
    if(_uart2._rx_tail != _uart2._rx_head) {
        strncpy(out_cmd, _uart2._rx_stack[_uart2._rx_tail], _UART2_CMD_BUFFER_SIZE - 1);
        out_cmd[_UART2_CMD_BUFFER_SIZE - 1] = '\0';
        _uart2._rx_stack[_uart2._rx_tail][0] = '\0';
        _uart2._rx_tail = (_uart2._rx_tail + 1) % _UART2_RX_STACK_SIZE;
        ret = 1;
    }
    return ret;
}

/* Hàm ISR x? lý RX:
   - S? d?ng buffer t?m (_temp_rx_buffer) d? tích luy ký t? nh?n du?c.
   - Khi g?p ký t? k?t thúc ('\n' ho?c '\r'), ki?m tra l?nh:
         + L?nh ph?i b?t d?u b?ng '>' ho?c "GET" ho?c "SET".
         + N?u h?p l?, push l?nh vào RX stack; n?u không, in l?i.
   - Sau dó, reset buffer t?m.
   T?t c? bi?n c?c b? d?u du?c khai báo d?u hàm. */
void _UART2_Rx_Receive_ISR(void) iv IVT_ADDR_U2RXINTERRUPT ics ICS_AUTO {
    char c;
    uint8_t next_head;
    c = UART2_Read();

    if(_uart2._temp_index == 0) {
        if(c != '>' && c != 'G' && c != 'S') {
            IFS1bits.U2RXIF = 0;
            return;
        }
    }

    if(c != '\n' && c != '\r') {
        if(_uart2._temp_index < (_UART2_CMD_BUFFER_SIZE - 1)) {
            _uart2._temp_rx_buffer[_uart2._temp_index] = c;
            _uart2._temp_index++;
        } else {
            DebugUART_Send_Text("UART2 RX: Command too long. Discarding.\n");
            _uart2._temp_index = 0;
        }
    } else {
        _uart2._temp_rx_buffer[_uart2._temp_index] = '\0';
        if(!((_uart2._temp_rx_buffer[0] == '>') ||
             (strncmp(_uart2._temp_rx_buffer, "GET", 3) == 0) ||
             (strncmp(_uart2._temp_rx_buffer, "SET", 3) == 0))) {
            DebugUART_Send_Text("UART2 RX: Invalid command. Discarding.\n");
        } else {
            next_head = (_uart2._rx_head + 1) % _UART2_RX_STACK_SIZE;
            if(next_head == _uart2._rx_tail) {
                DebugUART_Send_Text("UART2 RX Stack Full. Dropping command.\n");
            } else {
                strncpy(_uart2._rx_stack[_uart2._rx_head], _uart2._temp_rx_buffer, _UART2_CMD_BUFFER_SIZE - 1);
                _uart2._rx_stack[_uart2._rx_head][_UART2_CMD_BUFFER_SIZE - 1] = '\0';
                _uart2._rx_head = next_head;
            }
        }
        _uart2._temp_index = 0;
    }
    IFS1bits.U2RXIF = 0;
}
