# BMS Troubleshooting Guide - Không đọc được giá trị

## Vấn đề hiện tại
BMS không đọc được giá trị từ BMS module. Có thể do nhiều nguyên nhân khác nhau.

## Các nguyên nhân có thể và giải pháp

### 1. UART1 Interrupt chưa được bật
**Triệu chứng:**
- Không có debug output từ UART1 interrupt
- BMS không nhận được dữ liệu

**Giải pháp:**
```c
// Trong BMS_Init(), thêm:
IEC0bits.U1RXIE = 1;  // Bật ngắt UART1 RX
IFS0bits.U1RXIF = 0;  // Xóa cờ ngắt UART1 RX
```

### 2. BMS_Update() không được gọi trong main loop
**Triệu chứng:**
- BMS không gửi lệnh
- Không có timeout check

**Giải pháp:**
```c
// Trong Main.c, thêm vào main loop:
while (1) {
    BMS_UpdateSystemTick();  // Cập nhật system tick
    BMS_Update();            // Cập nhật BMS
    task_dispatch();         // Gọi Scheduler của MikroE
}
```

### 3. UART1 chưa được khởi tạo đúng
**Triệu chứng:**
- Không có communication với BMS
- UART1 không hoạt động

**Giải pháp:**
```c
// Trong Main.c, đảm bảo:
UART1_Init(9600);  // Khởi tạo UART1 với baud rate 9600
```

### 4. Kết nối hardware không đúng
**Triệu chứng:**
- Không có dữ liệu đến từ BMS
- UART1 không nhận được byte nào

**Kiểm tra:**
- Kết nối TX/RX giữa dsPIC và BMS module
- Baud rate phải giống nhau (9600)
- Ground connection
- Power supply cho BMS module

### 5. BMS module không phản hồi
**Triệu chứng:**
- Gửi lệnh nhưng không nhận được phản hồi
- Timeout xảy ra liên tục

**Kiểm tra:**
- BMS module có được cấp nguồn không
- BMS module có hoạt động không
- Protocol có đúng không

## Debug Steps

### Step 1: Kiểm tra UART1 Interrupt
```c
// Thêm debug output trong _UART1_Interrupt():
void _UART1_Interrupt() {
    DebugUART_Send_Text("BMS: UART1 interrupt triggered\r\n");
    // ... rest of code
}
```

### Step 2: Kiểm tra BMS_Update
```c
// Thêm debug output trong BMS_Update():
void BMS_Update(void) {
    static uint8_t debugCounter = 0;
    debugCounter++;
    
    if (debugCounter >= 100) {  // Mỗi 100 lần gọi
        DebugUART_Send_Text("BMS: Update called\r\n");
        debugCounter = 0;
    }
    
    // ... rest of code
}
```

### Step 3: Kiểm tra gửi lệnh
```c
// Thêm debug output trong _sendCommandPacket():
static void _sendCommandPacket(uint8_t _commandID, uint8_t * _payload) {
    char debugStr[50];
    sprintf(debugStr, "BMS: Sending command 0x%02X\r\n", _commandID);
    DebugUART_Send_Text(debugStr);
    
    // ... rest of code
}
```

### Step 4: Kiểm tra nhận dữ liệu
```c
// Thêm debug output trong _processReceivedResponsePacket():
static void _processReceivedResponsePacket(void) {
    // ... existing code ...
    
    if (RX_PeekBytes(_temp, _EXPECTED_PACKET_SIZE) == _EXPECTED_PACKET_SIZE) {
        DebugUART_Send_Text("BMS: Data available for processing\r\n");
        // ... rest of code
    }
}
```

## Test Cases

### Test Case 1: Kiểm tra UART1 Interrupt
1. Thêm debug output trong `_UART1_Interrupt()`
2. Gửi dữ liệu từ BMS module
3. Kiểm tra có debug output không

### Test Case 2: Kiểm tra BMS_Update
1. Thêm debug output trong `BMS_Update()`
2. Chạy chương trình
3. Kiểm tra có debug output định kỳ không

### Test Case 3: Kiểm tra gửi lệnh
1. Thêm debug output trong `_sendCommandPacket()`
2. Chạy chương trình
3. Kiểm tra có debug output khi gửi lệnh không

### Test Case 4: Kiểm tra nhận dữ liệu
1. Thêm debug output trong `_processReceivedResponsePacket()`
2. Gửi dữ liệu từ BMS module
3. Kiểm tra có debug output khi nhận dữ liệu không

## Expected Debug Output

### Khi hoạt động bình thường:
```
BMS_Init: System initialized
BMS: Update called
BMS: Sending command 0x90
BMS: UART1 interrupt triggered
BMS: Received frame 0, byte count: 0
BMS: Processing packet: 0xA5 0x01 0x90 0x08 ...
BMS: Valid packet header found
BMS: Checksum valid
BMS: 0x90 - Voltage: 12.30V, Current: 0.00A, SOC: 99.50%
```

### Khi có lỗi:
```
BMS: Invalid Packet Header: 0x00 0x00 0x00 0x00
BMS: Checksum Error! Calculated: 0xXX, Received: 0xYY
BMS: Frame Collection Timeout! CMD: 0x95, Received: 1/2 frames
```

## Các bước khắc phục

### 1. Kiểm tra hardware
- Đo điện áp trên TX/RX pins
- Kiểm tra kết nối ground
- Kiểm tra power supply cho BMS module

### 2. Kiểm tra software
- Đảm bảo UART1 interrupt được bật
- Đảm bảo BMS_Update() được gọi định kỳ
- Kiểm tra baud rate (9600)

### 3. Kiểm tra protocol
- Đảm bảo format gói tin đúng
- Kiểm tra checksum calculation
- Kiểm tra command ID

### 4. Debug step by step
- Thêm debug output ở từng bước
- Kiểm tra từng function riêng biệt
- Xác định chính xác điểm lỗi

## Kết luận

Để khắc phục vấn đề BMS không đọc được giá trị:

1. **Bật UART1 interrupt** trong BMS_Init()
2. **Gọi BMS_Update()** trong main loop
3. **Thêm debug output** để theo dõi
4. **Kiểm tra hardware** connections
5. **Test từng bước** để xác định nguyên nhân

Sau khi thực hiện các bước trên, BMS sẽ có thể đọc được giá trị từ BMS module. 