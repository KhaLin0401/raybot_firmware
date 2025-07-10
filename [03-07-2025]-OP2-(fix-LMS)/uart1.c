#include "uart1.h"
#include <string.h>
#include "robot_system.h"  // Giả sử chứa định nghĩa của DebugUART_Send_Text(), UART1_Read(), UART1_Write()

// Đối tượng toàn cục
_UART1_Object _uart1;

/* Khởi tạo module UART1 cho BMS:
   - Reset các chỉ số của RX và TX stack, cũng như temp buffer.
   - Kích hoạt ngắt RX.
   Các biến cục bộ được khai báo đầu hàm. */
void _UART1_Init(void) {
    int i;
    int j;
    
    // Reset các chỉ số
    _uart1._rx_head = 0;
    _uart1._rx_tail = 0;
    _uart1._tx_head = 0;
    _uart1._tx_tail = 0;
    _uart1._temp_index = 0;
    _uart1._frame_count = 0;
    _uart1._multi_frame_count = 0;
    _uart1._is_receiving = 0;
    _uart1._timeout_counter = 0;
    
    // Clear tất cả buffer
    memset(_uart1._temp_rx_buffer, 0, _UART1_BMS_BUFFER_SIZE);
    
    for(i = 0; i < _UART1_RX_STACK_SIZE; i++) {
        memset(_uart1._rx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
    }
    
    for(i = 0; i < _UART1_TX_STACK_SIZE; i++) {
        memset(_uart1._tx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
    }
    
    for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
        for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
            _uart1._multi_frame_buffer[i][j] = 0;
        }
    }
    
    // Kích hoạt ngắt UART1 RX
    IEC0bits.U1RXIE = 1;
    IFS0bits.U1RXIF = 0;
}

/* Hàm gửi dữ liệu blocking, gửi từng byte qua UART1.
   Các biến cục bộ được khai báo đầu hàm. */
int _UART1_SendBlocking(const uint8_t *frame) {
    int timeout;
    int result;
    int i;
    
    result = 1;
    for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
        timeout = 1000;
        while(U1STAbits.UTXBF && timeout > 0) {
            timeout--;
        }
        if(timeout == 0) {
            DebugUART_Send_Text("UART1 TX: Timeout waiting for TX buffer\n");
            result = 0;
            break;
        }
        UART1_Write(frame[i]);
    }
    return result;
}

/* Hàm push frame vào TX stack.
   Nếu TX stack đầy, frame sẽ bị từ chối.
   Các biến cục bộ được khai báo đầu hàm. */
void _UART1_SendPush(const uint8_t *frame) {
    uint8_t next_head;
    int i;
    
    next_head = (_uart1._tx_head + 1) % _UART1_TX_STACK_SIZE;
    if(next_head == _uart1._tx_tail) {
        DebugUART_Send_Text("UART1 TX Stack Full. Dropping frame.\n");
        return;
    }
    
    // Copy frame vào TX stack
    for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
        _uart1._tx_frame_stack[_uart1._tx_head][i] = frame[i];
    }
    _uart1._tx_head = next_head;
}

/* Hàm được scheduler gọi định kỳ để xử lý TX stack.
   Nếu có frame, lấy frame ra và gửi đi, sau đó xóa slot đó.
   Các biến cục bộ được khai báo đầu hàm. */
uint8_t _UART1_SendProcess(void) {
    uint8_t ret = 0;
    uint8_t *frame;
    int i;
    
    if(_uart1._tx_tail != _uart1._tx_head) {
        frame = _uart1._tx_frame_stack[_uart1._tx_tail];
        if(_UART1_SendBlocking(frame)) {
            // Clear frame đã gửi
            for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
                _uart1._tx_frame_stack[_uart1._tx_tail][i] = 0;
            }
            _uart1._tx_tail = (_uart1._tx_tail + 1) % _UART1_TX_STACK_SIZE;
            ret = 1;
        } else {
            DebugUART_Send_Text("UART1 TX: Failed to send frame.\n");
        }
    }
    return ret;
}

/* Hàm pop frame từ RX stack để scheduler lấy và xử lý.
   Sau khi lấy ra, slot được xóa và sẵn sàng nhận frame mới.
   Các biến cục bộ được khai báo đầu hàm. */
uint8_t _UART1_Rx_GetFrame(uint8_t *out_frame) {
    uint8_t ret = 0;
    int i;
    
    if(_uart1._rx_tail != _uart1._rx_head) {
        // Copy frame từ RX stack
        for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
            out_frame[i] = _uart1._rx_frame_stack[_uart1._rx_tail][i];
        }
        
        // Clear frame đã lấy
        for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
            _uart1._rx_frame_stack[_uart1._rx_tail][i] = 0;
        }
        _uart1._rx_tail = (_uart1._rx_tail + 1) % _UART1_RX_STACK_SIZE;
        ret = 1;
    }
    return ret;
}

/* Hàm lấy nhiều frame từ buffer (cho lệnh BMS cần nhiều frame) */
uint8_t _UART1_Rx_GetMultiFrames(uint8_t *out_frames, uint8_t max_frames) {
    uint8_t frame_count;
    int i;
    int j;
    
    frame_count = 0;
    if(_uart1._multi_frame_count > 0) {
        frame_count = (_uart1._multi_frame_count > max_frames) ? max_frames : _uart1._multi_frame_count;
        
        for(i = 0; i < frame_count; i++) {
            for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
                out_frames[i * _UART1_BMS_BUFFER_SIZE + j] = _uart1._multi_frame_buffer[i][j];
            }
        }
        
        // Clear các frame đã lấy
        for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
            for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
                _uart1._multi_frame_buffer[i][j] = 0;
            }
        }
        _uart1._multi_frame_count = 0;
    }
    
    return frame_count;
}

/* Hàm ISR xử lý RX:
   - Sử dụng buffer tạm (_temp_rx_buffer) để tích lũy byte nhận được.
   - Khi nhận đủ 13 byte (frame BMS), kiểm tra checksum:
         + Frame phải có start byte 0xA5
         + Checksum phải đúng
         + Nếu hợp lệ, push frame vào RX stack; nếu không, in lỗi.
   - Sau đó, reset buffer tạm.
   Tất cả biến cục bộ đều được khai báo đầu hàm. */
void _UART1_Rx_Receive_ISR(void) iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
    uint8_t c;
    uint8_t next_head;
    uint8_t checksum;
    int i;
    
    c = UART1_Read();

    // Kiểm tra start byte nếu đang bắt đầu frame mới
    if(_uart1._temp_index == 0) {
        if(c != 0xA5) {
            IFS0bits.U1RXIF = 0;
            return;
        }
    }

    // Tích lũy byte vào buffer tạm
    if(_uart1._temp_index < _UART1_BMS_BUFFER_SIZE) {
        _uart1._temp_rx_buffer[_uart1._temp_index] = c;
        _uart1._temp_index++;
    } else {
        DebugUART_Send_Text("UART1 RX: Frame too long. Discarding.\n");
        _uart1._temp_index = 0;
        IFS0bits.U1RXIF = 0;
        return;
    }

    // Kiểm tra nếu đã nhận đủ frame (13 byte)
    if(_uart1._temp_index >= _UART1_BMS_BUFFER_SIZE) {
        // Validate checksum
        if(_UART1_ValidateChecksum(_uart1._temp_rx_buffer)) {
            // Push frame vào RX stack
            next_head = (_uart1._rx_head + 1) % _UART1_RX_STACK_SIZE;
            if(next_head == _uart1._rx_tail) {
                DebugUART_Send_Text("UART1 RX Stack Full. Dropping frame.\n");
            } else {
                // Copy frame vào RX stack
                for(i = 0; i < _UART1_BMS_BUFFER_SIZE; i++) {
                    _uart1._rx_frame_stack[_uart1._rx_head][i] = _uart1._temp_rx_buffer[i];
                }
                _uart1._rx_head = next_head;
            }
        } else {
            DebugUART_Send_Text("UART1 RX: Invalid checksum. Discarding frame.\n");
        }
        _uart1._temp_index = 0; // Reset buffer tạm
    }
    
    IFS0bits.U1RXIF = 0;
}

/* Hàm validate checksum cho frame BMS */
uint8_t _UART1_ValidateChecksum(const uint8_t *frame) {
    uint8_t calculated_checksum;
    int i;
    
    calculated_checksum = 0;
    // Tính checksum cho 12 byte đầu
    for(i = 0; i < _UART1_BMS_BUFFER_SIZE - 1; i++) {
        calculated_checksum += frame[i];
    }
    
    // So sánh với checksum nhận được (byte cuối)
    return (calculated_checksum == frame[_UART1_BMS_BUFFER_SIZE - 1]);
}

/* Hàm tính checksum cho frame BMS */
uint8_t _UART1_CalculateChecksum(const uint8_t *frame, uint8_t length) {
    uint8_t checksum;
    int i;
    
    checksum = 0;
    for(i = 0; i < length; i++) {
        checksum += frame[i];
    }
    
    return checksum;
}

/* Hàm clear buffer và reset trạng thái */
void _UART1_ClearBuffers(void) {
    int i;
    int j;
    
    _uart1._rx_head = 0;
    _uart1._rx_tail = 0;
    _uart1._tx_head = 0;
    _uart1._tx_tail = 0;
    _uart1._temp_index = 0;
    _uart1._frame_count = 0;
    _uart1._multi_frame_count = 0;
    _uart1._is_receiving = 0;
    _uart1._timeout_counter = 0;
    
    // Clear tất cả buffer
    memset(_uart1._temp_rx_buffer, 0, _UART1_BMS_BUFFER_SIZE);
    
    for(i = 0; i < _UART1_RX_STACK_SIZE; i++) {
        memset(_uart1._rx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
    }
    
    for(i = 0; i < _UART1_TX_STACK_SIZE; i++) {
        memset(_uart1._tx_frame_stack[i], 0, _UART1_BMS_BUFFER_SIZE);
    }
    
    for(i = 0; i < _UART1_FRAME_STACK_SIZE; i++) {
        for(j = 0; j < _UART1_BMS_BUFFER_SIZE; j++) {
            _uart1._multi_frame_buffer[i][j] = 0;
        }
    }
}

/* Hàm kiểm tra trạng thái kết nối BMS */
uint8_t _UART1_IsConnected(void) {
    // Kiểm tra nếu có frame trong RX stack hoặc đang nhận dữ liệu
    return ((_uart1._rx_tail != _uart1._rx_head) || (_uart1._temp_index > 0));
} 