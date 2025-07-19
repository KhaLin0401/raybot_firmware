#include "uart2.h"
#include <string.h>
#include "robot_system.h"  // Gi? s? ch?a d?nh nghia c?a DebugUART_Send_Text(), UART2_Read(), UART2_Write()

// �?i tu?ng to�n c?c
_UART2_Object _uart2;

/* Kh?i t?o module UART2:
   - Reset c�c ch? s? c?a RX v� TX stack, cung nhu temp buffer.
   - K�ch ho?t ng?t RX.
   C�c bi?n c?c b? du?c khai b�o d?u h�m. */
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

/* H�m g?i d? li?u blocking, g?i t?ng k� t? qua UART2.
   C�c bi?n c?c b? du?c khai b�o d?u h�m. */
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

/* H�m push l?nh v�o TX stack.
   N?u TX stack d?y, l?nh s? b? t? ch?i.
   C�c bi?n c?c b? du?c khai b�o d?u h�m. */
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

/* H�m du?c scheduler g?i d?nh k? d? x? l� TX stack.
   N?u c� l?nh, l?y l?nh ra v� g?i di, sau d� x�a � d�.
   C�c bi?n c?c b? du?c khai b�o d?u h�m. */
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

/* H�m pop l?nh t? RX stack d? scheduler l?y v� x? l�.
   Sau khi l?y ra, � d� du?c x�a v� s?n s�ng nh?n l?nh m?i.
   C�c bi?n c?c b? du?c khai b�o d?u h�m. */
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

/* H�m ISR x? l� RX:
   - S? d?ng buffer t?m (_temp_rx_buffer) d? t�ch luy k� t? nh?n du?c.
   - Khi g?p k� t? k?t th�c ('\n' ho?c '\r'), ki?m tra l?nh:
         + L?nh ph?i b?t d?u b?ng '>' ho?c "GET" ho?c "SET".
         + N?u h?p l?, push l?nh v�o RX stack; n?u kh�ng, in l?i.
   - Sau d�, reset buffer t?m.
   T?t c? bi?n c?c b? d?u du?c khai b�o d?u h�m. */
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
