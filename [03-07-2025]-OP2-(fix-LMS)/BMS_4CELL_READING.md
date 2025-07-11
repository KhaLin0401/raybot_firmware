# BMS 4-CELL READING IMPLEMENTATION

## Mô tả vấn đề
- Mỗi frame 0x95 chỉ chứa thông tin của 3 cell pin
- Để đọc đủ 4 cell, cần 2 frame 0x95 liên tiếp
- Cần xử lý và kết hợp dữ liệu từ 2 frame

## Giải pháp đã triển khai

### 1. Thêm biến theo dõi trong BMSData
```c
// Biến theo dõi frame 0x95 cho 4 cell pin
uint8_t _cell95FrameCount;  // Đếm số frame 0x95 đã nhận (0 hoặc 1)
uint32_t _cell95LastFrameTime; // Thời gian nhận frame cuối cùng (để timeout)
uint8_t _cell95FrameValid;     // Đánh dấu dữ liệu 4 cell đã hợp lệ (0/1)
```

### 2. Phân biệt frame bằng Frame Index
```c
// Byte 4 trong frame 0x95 chứa Frame Index:
// - frameIndex = 0: Frame đầu tiên (Cell1, Cell2, Cell3)
// - frameIndex = 1: Frame thứ hai (Cell4)
uint8_t frameIndex = _temp[4];
```

### 3. Timeout và Validation
```c
// Kiểm tra timeout: nếu quá 5 giây kể từ frame cuối, reset
if (currentTime - _cell95LastFrameTime > 5000) {
    _cell95FrameCount = 0;
    _cell95FrameValid = 0;
}
```

### 2. Logic xử lý 2 frame

#### Frame đầu tiên (Frame Index = 0):
- Nhận 3 cell đầu tiên: Cell1, Cell2, Cell3
- Lưu trực tiếp vào `_cellVoltages0`, `_cellVoltages1`, `_cellVoltages2`
- Đặt `_cell95FrameCount = 1`, `_cell95FrameValid = 0`
- Cập nhật `_cell95LastFrameTime`
- In debug: "Frame 0x95 #1 (Index=0): Cell1=X.XXXV, Cell2=X.XXXV, Cell3=X.XXXV"

#### Frame thứ hai (Frame Index = 1):
- Nhận cell thứ 4: Cell4
- Lưu vào `_cellVoltages3`
- Reset `_cell95FrameCount = 0`, `_cell95FrameValid = 1`
- Cập nhật `_cell95LastFrameTime`
- Tính toán min/max cell voltage từ 4 cell
- In debug: "Frame 0x95 #2 (Index=1): Cell4=X.XXXV, Min=X.XXXV, Max=X.XXXV [VALID]"

#### Timeout handling:
- Nếu quá 5 giây kể từ frame cuối: Reset `_cell95FrameCount = 0`, `_cell95FrameValid = 0`
- In debug: "Frame 0x95: Timeout reset"

#### Error handling:
- Nếu frameIndex khác 0 và 1: In lỗi "Frame 0x95 Error: Invalid frame index X"

### 3. Khởi tạo
Trong `BMS_Init()`:
```c
_bmsData._cell95FrameCount = 0;  // Reset frame counter
```

## Cách sử dụng

### Đọc điện áp cell:
```c
// Sau khi nhận đủ 2 frame 0x95:
float cell1_voltage = _bmsData._cellVoltages0 / 1000.0;  // V
float cell2_voltage = _bmsData._cellVoltages1 / 1000.0;  // V  
float cell3_voltage = _bmsData._cellVoltages2 / 1000.0;  // V
float cell4_voltage = _bmsData._cellVoltages3 / 1000.0;  // V

// Min/Max cell voltage:
float min_cell = _bmsData._minCellVoltage / 1000.0;      // V
float max_cell = _bmsData._maxCellVoltage / 1000.0;      // V
```

### Debug output:
- Frame #1: Hiển thị 3 cell đầu tiên
- Frame #2: Hiển thị cell thứ 4 và min/max voltage

## Lưu ý quan trọng

1. **Thứ tự frame**: Phải nhận frame #1 trước, sau đó mới frame #2
2. **Timeout**: Nếu không nhận được frame #2 trong thời gian nhất định, có thể reset `_cell95FrameCount = 0`
3. **Error handling**: Cần xử lý trường hợp nhận sai thứ tự frame
4. **Data validation**: Kiểm tra tính hợp lệ của dữ liệu cell voltage

## MODIFICATION LOG
```
// MODIFICATION LOG
// Date: 2025-01-03
// Changed by: AI Agent
// Description: Implemented 4-cell reading from 2 consecutive 0x95 frames
// Reason: Each 0x95 frame only contains 3 cells, need 2 frames for 4 cells
// Impact: BMS cell voltage reading system
// Testing: Verify both frames are received and data is combined correctly
``` 