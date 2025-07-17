# Ví dụ sử dụng BMS Timeout System

## Cách tích hợp vào main.c

### 1. Cập nhật main loop
```c
#include "BMS.h"

int main(void) {
    // Khởi tạo hệ thống
    SystemInit();
    BMS_Init();
    
    while(1) {
        // Cập nhật system tick (quan trọng cho timeout)
        BMS_UpdateSystemTick();
        
        // Cập nhật BMS (bao gồm timeout check)
        BMS_Update();
        
        // Các task khác...
        // MotorControl_Update();
        // Sensor_Update();
        
        // Delay để tránh loop quá nhanh
        Delay_ms(10);
    }
}
```

### 2. Sử dụng timer interrupt để cập nhật system tick
```c
// Trong timer interrupt handler
void Timer1_Interrupt() {
    // Cập nhật system tick mỗi 1ms
    BMS_UpdateSystemTick();
    
    // Xóa cờ ngắt
    IFS0bits.T1IF = 0;
}
```

### 3. Kiểm tra trạng thái frame collection
```c
void CheckBMSStatus(void) {
    if (BMS_IsFrameCollectionActive()) {
        DebugUART_Send_Text("BMS: Frame collection in progress\r\n");
    } else {
        DebugUART_Send_Text("BMS: Ready for new commands\r\n");
    }
}
```

## Test scenarios

### Scenario 1: Timeout khi mất frame
```c
// Gửi lệnh 0x95 (cần 2 frame)
uint8_t payload[8] = {0};
BMS_PushCommand(0x95, payload);

// Chỉ nhận 1 frame (frame thứ 2 bị mất)
// Sau 1 giây, hệ thống sẽ:
// 1. Log: "Frame Collection Timeout! CMD: 0x95, Received: 1/2 frames"
// 2. Reset frame manager
// 3. Sẵn sàng xử lý lệnh mới
```

### Scenario 2: Hoạt động bình thường
```c
// Gửi lệnh 0x95
uint8_t payload[8] = {0};
BMS_PushCommand(0x95, payload);

// Nhận đủ 2 frame
// Hệ thống sẽ:
// 1. Xử lý dữ liệu cell voltages
// 2. Reset frame manager
// 3. Sẵn sàng cho lệnh tiếp theo
```

### Scenario 3: Lệnh đơn frame
```c
// Gửi lệnh 0x90 (đơn frame)
uint8_t payload[8] = {0};
BMS_PushCommand(0x90, payload);

// Nhận 1 frame
// Hệ thống sẽ:
// 1. Xử lý ngay lập tức (không cần frame collection)
// 2. Không có timeout
```

## Debug output examples

### Timeout message
```
Frame Collection Timeout! CMD: 0x95, Received: 1/2 frames
```

### Normal processing
```
Cell Voltages: 4088mV, 4119mV, 4123mV, 4138mV
```

### Frame collection active
```
BMS: Frame collection in progress
```

## Performance considerations

### 1. System tick frequency
- Nên cập nhật system tick mỗi 1ms
- Có thể sử dụng timer interrupt
- Không nên cập nhật quá thường xuyên (< 1ms)

### 2. Check interval
- Mặc định: 50ms
- Có thể tăng lên 100ms nếu cần tiết kiệm CPU
- Không nên giảm xuống < 10ms

### 3. Timeout duration
- Mặc định: 1000ms (1 giây)
- Có thể tăng lên 2000ms cho môi trường nhiễu cao
- Không nên giảm xuống < 500ms

## Troubleshooting checklist

### Vấn đề: Không có timeout
- [ ] `BMS_UpdateSystemTick()` được gọi định kỳ
- [ ] `BMS_Update()` được gọi trong main loop
- [ ] `BMS_Init()` được gọi khi khởi tạo

### Vấn đề: Timeout xảy ra quá sớm
- [ ] System tick được cập nhật đúng tần số
- [ ] Timeout duration đủ lớn
- [ ] Không có lỗi trong tính toán thời gian

### Vấn đề: Performance chậm
- [ ] Check interval không quá nhỏ
- [ ] System tick không được cập nhật quá thường xuyên
- [ ] Debug output không quá nhiều

## Integration với các module khác

### 1. Với MotorControl
```c
void MotorControl_Update(void) {
    // Kiểm tra BMS status trước khi điều khiển motor
    if (BMS_IsFrameCollectionActive()) {
        // Tạm dừng motor control nếu BMS đang bận
        return;
    }
    
    // Normal motor control logic
    // ...
}
```

### 2. Với Sensor module
```c
void Sensor_Update(void) {
    // Cập nhật sensor data
    // ...
    
    // Kiểm tra BMS timeout status
    if (BMS_IsFrameCollectionActive()) {
        DebugUART_Send_Text("Sensor: BMS busy, waiting...\r\n");
    }
}
```

### 3. Với Communication module
```c
void Communication_ProcessCommand(void) {
    // Xử lý command từ UART
    // ...
    
    // Gửi status về BMS
    char statusMsg[100];
    sprintf(statusMsg, "BMS Status: %s\r\n", 
            BMS_IsFrameCollectionActive() ? "Busy" : "Ready");
    UART2_Write_Text(statusMsg);
}
``` 