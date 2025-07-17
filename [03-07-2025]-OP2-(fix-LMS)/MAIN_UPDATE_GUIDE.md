# Hướng dẫn cập nhật Main.c cho BMS

## Vấn đề hiện tại
Main.c hiện tại không gọi `BMS_Update()` trong main loop, khiến BMS không hoạt động.

## Cách sửa Main.c

### 1. Cập nhật main loop
**Trước:**
```c
void main() {
    init_hardware();
    UART1_Init(9600);
    UART2_Init(9600);
    _UART2_Init();

    DebugUART_Init();
    _MotorDC_Init(&motorDC, 2.5, 0.5, 1.0, 0);
    _MotorDC_SetSafeDistance(&motorDC, 40);
    _Lifter_Init(&lifter, 1.0, 0.5, 0.1, 30);
    BMS_Init();
    Lms_Init();
    init_distance_sensors();
    CommandHandler_Init(&cmdHandler);

    _F_schedule_init();

    while (1) {
        task_dispatch(); // Gọi Scheduler của MikroE
    }
}
```

**Sau:**
```c
void main() {
    init_hardware();
    UART1_Init(9600);
    UART2_Init(9600);
    _UART2_Init();

    DebugUART_Init();
    _MotorDC_Init(&motorDC, 2.5, 0.5, 1.0, 0);
    _MotorDC_SetSafeDistance(&motorDC, 40);
    _Lifter_Init(&lifter, 1.0, 0.5, 0.1, 30);
    BMS_Init();
    Lms_Init();
    init_distance_sensors();
    CommandHandler_Init(&cmdHandler);

    _F_schedule_init();

    while (1) {
        /* Cập nhật system tick cho BMS timeout */
        BMS_UpdateSystemTick();
        
        /* Cập nhật BMS - gửi lệnh và xử lý phản hồi */
        BMS_Update();
        
        /* Gọi Scheduler của MikroE */
        task_dispatch();
    }
}
```

### 2. Thêm include cho BMS
Đảm bảo có include:
```c
#include "BMS.h"
```

### 3. Bật UART1 interrupt (tùy chọn)
Nếu cần bật interrupt trong Main.c:
```c
void main() {
    // ... existing code ...
    
    BMS_Init();
    
    /* Bật UART1 interrupt */
    IEC0bits.U1RXIE = 1;  /* Bật ngắt UART1 RX */
    IFS0bits.U1RXIF = 0;  /* Xóa cờ ngắt UART1 RX */
    
    // ... rest of code ...
}
```

## Giải thích các thay đổi

### 1. BMS_UpdateSystemTick()
- Cập nhật system tick count cho timeout mechanism
- Cần gọi định kỳ để timeout hoạt động đúng

### 2. BMS_Update()
- Gửi lệnh đến BMS module
- Xử lý phản hồi từ BMS
- Kiểm tra timeout cho frame collection
- Quản lý immediate queue và TX buffer

### 3. Thứ tự gọi
- `BMS_UpdateSystemTick()` trước
- `BMS_Update()` sau
- `task_dispatch()` cuối cùng

## Debug Output mong đợi

Sau khi cập nhật, bạn sẽ thấy:
```
BMS_Init: System initialized
BMS: Update called
BMS: Sending command 0x90
BMS: Sent packet: 0xA5 0x40 0x90 0x08 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x7D
BMS: UART1 interrupt triggered
BMS: Received frame 0, byte count: 0
BMS: Processing packet: 0xA5 0x01 0x90 0x08 ...
BMS: Valid packet header found
BMS: Checksum valid
BMS: 0x90 - Voltage: 12.30V, Current: 0.00A, SOC: 99.50%
```

## Testing

### Test 1: Kiểm tra BMS_Update được gọi
- Chạy chương trình
- Kiểm tra có "BMS: Update called" mỗi 100 lần gọi

### Test 2: Kiểm tra gửi lệnh
- Chạy chương trình
- Kiểm tra có "BMS: Sending command 0x9X" định kỳ

### Test 3: Kiểm tra nhận dữ liệu
- Kết nối BMS module
- Kiểm tra có "BMS: Processing packet" khi nhận dữ liệu

### Test 4: Kiểm tra timeout
- Ngắt kết nối BMS module
- Kiểm tra có "BMS: Frame Collection Timeout" sau 1 giây

## Troubleshooting

### Nếu không có debug output:
1. Kiểm tra `BMS_Update()` có được gọi không
2. Kiểm tra `DebugUART_Send_Text()` có hoạt động không
3. Kiểm tra UART1 có được khởi tạo đúng không

### Nếu có gửi lệnh nhưng không nhận phản hồi:
1. Kiểm tra kết nối hardware
2. Kiểm tra baud rate (9600)
3. Kiểm tra BMS module có hoạt động không

### Nếu nhận dữ liệu nhưng không xử lý:
1. Kiểm tra format gói tin
2. Kiểm tra checksum calculation
3. Kiểm tra command ID

## Kết luận

Sau khi cập nhật Main.c theo hướng dẫn trên:

1. **BMS sẽ hoạt động đúng** - gửi lệnh và nhận phản hồi
2. **Timeout mechanism hoạt động** - tự động reset khi mất frame
3. **Debug output đầy đủ** - dễ dàng theo dõi và debug
4. **Tương thích với scheduler** - không ảnh hưởng đến các task khác

BMS sẽ có thể đọc được giá trị từ BMS module một cách ổn định và đáng tin cậy. 