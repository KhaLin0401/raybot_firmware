#ifndef _UART1_H
#define _UART1_H

#include <stdint.h>

// Cấu hình cho UART1 BMS
#define _UART1_BMS_BUFFER_SIZE 13    // Kích thước frame BMS (XFER_BUFFER_LENGTH)
#define _UART1_RX_STACK_SIZE    5    // Số slot của ngăn xếp RX cho BMS
#define _UART1_TX_STACK_SIZE    3    // Số slot của ngăn xếp TX cho BMS
#define _UART1_FRAME_STACK_SIZE 12   // Số frame tối đa có thể nhận cùng lúc

typedef struct {
    // Ngăn xếp frame nhận được từ BMS (RX)
    uint8_t _rx_frame_stack[_UART1_RX_STACK_SIZE][_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _rx_head;  // Vị trí ghi (push) mới
    volatile uint8_t _rx_tail;  // Vị trí đọc (pop) frame cũ nhất

    // Ngăn xếp frame gửi đi đến BMS (TX)
    uint8_t _tx_frame_stack[_UART1_TX_STACK_SIZE][_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _tx_head;  // Vị trí ghi mới
    volatile uint8_t _tx_tail;  // Vị trí đọc frame cần gửi

    // Buffer tạm thời để xây dựng frame RX từ ISR
    uint8_t _temp_rx_buffer[_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _temp_index;
    volatile uint8_t _frame_count;  // Số frame đang nhận
    
    // Buffer cho nhiều frame (cho lệnh BMS cần nhiều frame)
    uint8_t _multi_frame_buffer[_UART1_FRAME_STACK_SIZE][_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _multi_frame_count;
    
    // Trạng thái giao tiếp
    volatile uint8_t _is_receiving;
    volatile uint8_t _timeout_counter;
    
} _UART1_Object;

extern _UART1_Object _uart1;

/* Khởi tạo module UART1 cho BMS (bao gồm cấu hình ngắt RX) */
void _UART1_Init(void);

/* --- Phần TX cho BMS --- */
/* Hàm push frame cần gửi vào TX stack.
   Nếu stack đầy, frame sẽ bị từ chối và in ra thông báo lỗi. */
void _UART1_SendPush(const uint8_t *frame);

/* Hàm gửi dữ liệu blocking qua UART1 (dùng bên trong SendProcess) */
int _UART1_SendBlocking(const uint8_t *frame);

/* Hàm được scheduler gọi định kỳ để lấy frame từ TX stack và gửi đi.
   Nếu có frame đang chờ gửi, hàm sẽ pop frame ra và gọi hàm gửi blocking. */
uint8_t _UART1_SendProcess(void);

/* --- Phần RX cho BMS --- */
/* Hàm pop frame từ RX stack để scheduler lấy và xử lý.
   Sau khi lấy ra, slot được xóa và sẵn sàng nhận frame mới. */
uint8_t _UART1_Rx_GetFrame(uint8_t *out_frame);

/* Hàm lấy nhiều frame từ buffer (cho lệnh BMS cần nhiều frame) */
uint8_t _UART1_Rx_GetMultiFrames(uint8_t *out_frames, uint8_t max_frames);

/* Hàm ISR (được gọi trong ngắt UART1 RX) để nhận byte và xây dựng frame.
   Chỉ những frame có checksum đúng mới được đưa vào RX stack. */
void _UART1_Rx_Receive_ISR(void);

/* Hàm validate checksum cho frame BMS */
uint8_t _UART1_ValidateChecksum(const uint8_t *frame);

/* Hàm tính checksum cho frame BMS */
uint8_t _UART1_CalculateChecksum(const uint8_t *frame, uint8_t length);

/* Hàm clear buffer và reset trạng thái */
void _UART1_ClearBuffers(void);

/* Hàm kiểm tra trạng thái kết nối BMS */
uint8_t _UART1_IsConnected(void);

#endif /* _UART1_H */ 