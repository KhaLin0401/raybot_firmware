# BMS Frame Collection Timeout System

## Tổng quan
Hệ thống timeout được thêm vào để giải quyết vấn đề frame collection bị treo khi chỉ nhận được một phần frame cần thiết (ví dụ: chỉ 1/2 frame cho lệnh 0x95).

## Vấn đề ban đầu
- Lệnh 0x95 cần 2 frame nhưng không có cơ chế timeout
- Nếu chỉ nhận được 1 frame, hệ thống sẽ bị treo vô thời hạn
- Frame manager không bao giờ được reset, dẫn đến mất khả năng xử lý các lệnh tiếp theo

## Giải pháp đã triển khai

### 1. Cấu trúc FrameManager mới
```c
typedef struct {
    uint8_t commandID;
    uint8_t frameCount;
    uint8_t receivedFrames;
    uint8_t frameData[4][13];
    uint8_t frameValid[4];
    uint32_t startTime;        // Thời điểm bắt đầu thu thập
    uint32_t timeoutMs;        // Timeout tính bằng millisecond
} FrameManager;
```

### 2. Hằng số timeout
```c
#define FRAME_COLLECTION_TIMEOUT_MS    1000    // 1 giây timeout
#define FRAME_COLLECTION_CHECK_INTERVAL_MS  50  // Kiểm tra mỗi 50ms
```

### 3. Các hàm mới
- `BMS_CheckFrameTimeout()`: Kiểm tra và xử lý timeout
- `BMS_IsFrameCollectionActive()`: Kiểm tra có frame collection đang hoạt động không
- `BMS_UpdateSystemTick()`: Cập nhật system tick count

### 4. Cơ chế hoạt động
1. **Bắt đầu frame collection**: Ghi lại thời điểm bắt đầu
2. **Kiểm tra định kỳ**: Mỗi 50ms kiểm tra timeout
3. **Xử lý timeout**: Nếu quá 1 giây, reset frame manager và log lỗi
4. **Tiếp tục hoạt động**: Hệ thống có thể xử lý các lệnh mới

## Cách sử dụng

### 1. Trong main loop
```c
int main(void) {
    BMS_Init();
    
    while(1) {
        // Cập nhật system tick (cần gọi định kỳ)
        BMS_UpdateSystemTick();
        
        // Cập nhật BMS (đã bao gồm timeout check)
        BMS_Update();
        
        Delay_ms(10);  // 10ms delay
    }
}
```

### 2. Kiểm tra trạng thái frame collection
```c
if (BMS_IsFrameCollectionActive()) {
    // Có frame collection đang hoạt động
    DebugUART_Send_Text("Frame collection in progress...\r\n");
}
```

## Lợi ích

### 1. Độ tin cậy cao hơn
- Không bị treo khi mất frame
- Tự động khôi phục sau timeout
- Log rõ ràng khi có lỗi

### 2. Debug dễ dàng hơn
- Thông báo timeout với thông tin chi tiết
- Biết được số frame đã nhận vs cần thiết
- Theo dõi được command ID bị timeout

### 3. Hiệu suất tốt hơn
- Kiểm tra timeout không thường xuyên (50ms)
- Không ảnh hưởng đến performance
- Tự động reset để xử lý lệnh mới

## Cấu hình timeout

### Thay đổi timeout duration
```c
// Trong BMS.h
#define FRAME_COLLECTION_TIMEOUT_MS    2000    // Tăng lên 2 giây
```

### Thay đổi check interval
```c
// Trong BMS.h  
#define FRAME_COLLECTION_CHECK_INTERVAL_MS  100  // Kiểm tra mỗi 100ms
```

## Testing

### Test case 1: Timeout khi mất frame
1. Gửi lệnh 0x95
2. Chỉ nhận 1 frame
3. Đợi 1 giây
4. Kiểm tra log timeout
5. Xác nhận frame manager được reset

### Test case 2: Hoạt động bình thường
1. Gửi lệnh 0x95
2. Nhận đủ 2 frame
3. Xác nhận xử lý thành công
4. Frame manager được reset

### Test case 3: Lệnh đơn frame
1. Gửi lệnh 0x90 (đơn frame)
2. Xác nhận xử lý bình thường
3. Không có timeout

## Troubleshooting

### Vấn đề: Timeout xảy ra quá sớm
**Nguyên nhân**: System tick không được cập nhật đúng
**Giải pháp**: Đảm bảo `BMS_UpdateSystemTick()` được gọi định kỳ

### Vấn đề: Không có timeout
**Nguyên nhân**: `BMS_CheckFrameTimeout()` không được gọi
**Giải pháp**: Kiểm tra `BMS_Update()` có được gọi không

### Vấn đề: Performance chậm
**Nguyên nhân**: Check interval quá nhỏ
**Giải pháp**: Tăng `FRAME_COLLECTION_CHECK_INTERVAL_MS`

## MODIFICATION LOG
- **Date**: 2025-01-03
- **Changed by**: AI Agent
- **Description**: Thêm hệ thống timeout cho frame collection
- **Reason**: Giải quyết vấn đề frame collection bị treo khi mất frame
- **Impact**: Cải thiện độ tin cậy và khả năng phục hồi của hệ thống BMS
- **Testing**: Test với các trường hợp mất frame và timeout 