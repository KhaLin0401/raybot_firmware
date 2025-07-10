# UART1 BMS Communication Module

## Tổng quan

Module UART1 được thiết kế đặc biệt cho giao tiếp với Daly BMS thông qua UART1 hardware. Module này cung cấp cơ chế truyền nhận frame BMS với checksum validation và interrupt handling.

## Cấu trúc Module

### File chính:
- `uart1.h` - Header file với định nghĩa cấu trúc và prototype
- `uart1.c` - Implementation với ISR và các hàm xử lý

### Cấu trúc dữ liệu:
```c
typedef struct {
    // RX Stack - Nhận frame từ BMS
    uint8_t _rx_frame_stack[_UART1_RX_STACK_SIZE][_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _rx_head;  // Vị trí ghi mới
    volatile uint8_t _rx_tail;  // Vị trí đọc cũ nhất
    
    // TX Stack - Gửi frame đến BMS
    uint8_t _tx_frame_stack[_UART1_TX_STACK_SIZE][_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _tx_head;  // Vị trí ghi mới
    volatile uint8_t _tx_tail;  // Vị trí đọc cần gửi
    
    // Buffer tạm thời cho ISR
    uint8_t _temp_rx_buffer[_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _temp_index;
    
    // Buffer cho nhiều frame
    uint8_t _multi_frame_buffer[_UART1_FRAME_STACK_SIZE][_UART1_BMS_BUFFER_SIZE];
    volatile uint8_t _multi_frame_count;
    
    // Trạng thái giao tiếp
    volatile uint8_t _is_receiving;
    volatile uint8_t _timeout_counter;
} _UART1_Object;
```

## Các hàm chính

### Khởi tạo:
```c
void _UART1_Init(void);
```
- Khởi tạo UART1 hardware
- Reset tất cả buffer và chỉ số
- Kích hoạt ngắt RX

### Gửi dữ liệu:
```c
void _UART1_SendPush(const uint8_t *frame);
uint8_t _UART1_SendProcess(void);
int _UART1_SendBlocking(const uint8_t *frame);
```

### Nhận dữ liệu:
```c
uint8_t _UART1_Rx_GetFrame(uint8_t *out_frame);
uint8_t _UART1_Rx_GetMultiFrames(uint8_t *out_frames, uint8_t max_frames);
```

### Validation:
```c
uint8_t _UART1_ValidateChecksum(const uint8_t *frame);
uint8_t _UART1_CalculateChecksum(const uint8_t *frame, uint8_t length);
```

### Utility:
```c
void _UART1_ClearBuffers(void);
uint8_t _UART1_IsConnected(void);
```

## Cơ chế hoạt động

### 1. Gửi Frame:
```
[Application] → _UART1_SendPush() → [TX Stack] → _UART1_SendProcess() → [UART1 Hardware]
```

### 2. Nhận Frame:
```
[UART1 Hardware] → ISR → [Temp Buffer] → [Validation] → [RX Stack] → _UART1_Rx_GetFrame()
```

### 3. ISR Processing:
- Nhận byte từ UART1
- Kiểm tra start byte (0xA5)
- Tích lũy vào temp buffer
- Khi đủ 13 byte, validate checksum
- Push frame hợp lệ vào RX stack

## Tích hợp với BMS Module

### Trong BMS.c:
```c
#include "uart1.h"

// Thay thế các hàm serial mock
_UART1_SendPush(bms->my_txBuffer);
_UART1_SendProcess();

if (_UART1_Rx_GetFrame(frame)) {
    // Process frame
}
```

### Khởi tạo BMS:
```c
void DalyBms_Init(DalyBms* bms) {
    // Initialize BMS structure
    // ...
    
    // Initialize UART1 for BMS communication
    _UART1_Init();
    
    // Initialize BMS data structure
    DalyBms_clearGet(bms);
}
```

## Cấu hình Hardware

### UART1 Pins:
- RX: U1RX (configurable pin)
- TX: U1TX (configurable pin)
- Baud rate: 9600 (for Daly BMS)

### Interrupt Configuration:
```c
// Enable UART1 RX interrupt
IEC0bits.U1RXIE = 1;
IFS0bits.U1RXIF = 0;
```

## Đặc điểm quan trọng

### 1. Frame Format:
- Start byte: 0xA5
- Length: 13 bytes
- Checksum: Byte cuối (tổng 12 byte đầu)

### 2. Error Handling:
- Invalid start byte
- Invalid checksum
- Buffer overflow protection
- Timeout handling

### 3. Performance:
- Non-blocking ISR
- Stack-based queuing
- Immediate processing cho TX

## Sử dụng trong Main Loop

```c
void main() {
    // Initialize BMS
    DalyBms_Init(&bms);
    
    while(1) {
        // Process BMS communication
        DalyBms_update(&bms);
        
        // Process UART1 TX stack
        _UART1_SendProcess();
        
        // Other tasks...
    }
}
```

## Lưu ý quan trọng

1. **Interrupt Priority**: UART1 ISR phải có priority phù hợp
2. **Buffer Size**: Đảm bảo đủ buffer cho frame BMS (13 bytes)
3. **Checksum**: Luôn validate checksum trước khi xử lý frame
4. **Timeout**: Implement timeout mechanism cho giao tiếp
5. **Error Recovery**: Clear buffer khi có lỗi

## Testing

### Test Cases:
1. Gửi frame đơn lẻ
2. Nhận frame hợp lệ
3. Xử lý frame không hợp lệ
4. Buffer overflow
5. Timeout scenarios
6. Multi-frame communication

### Debug Output:
```c
DebugUART_Send_Text("UART1 TX: Timeout waiting for TX buffer\n");
DebugUART_Send_Text("UART1 RX: Invalid checksum. Discarding frame.\n");
DebugUART_Send_Text("UART1 RX Stack Full. Dropping frame.\n");
``` 