#ifndef _BMS_H_
#define _BMS_H_

#include <stdint.h>
#include <string.h>

// Kích thước gói lệnh (mỗi gói có 13 byte)
#define _SEND_PACKET_SIZE       13
#define _EXPECTED_PACKET_SIZE   13
#define MAX_CELL_COUNT          16
#define _TX_BUFFER_SIZE         10
#define _RX_FRAME_COUNT         10    // 10 frame
#define _RX_FRAME_SIZE          13    // Mỗi frame 13 byte
#define _RX_BUFFER_SIZE         (_RX_FRAME_COUNT * _RX_FRAME_SIZE)

// Định nghĩa các Command ID
typedef enum {
    START_BYTE = 0xA5,
    HOST_ADDRESS = 0x40,
    CELL_THRESHOLDS = 0x59,
    PACK_THRESHOLDS = 0x5A,
    VOUT_IOUT_SOC = 0x90,
    MIN_MAX_CELL_VOLTAGE = 0x91,
    MIN_MAX_TEMPERATURE = 0x92,
    DISCHARGE_CHARGE_MOS_STATUS = 0x93,
    STATUS_INFO = 0x94,
    CELL_VOLTAGES = 0x95,
    CELL_TEMPERATURE = 0x96,
    CELL_BALANCE_STATE = 0x97,
    FAILURE_CODES = 0x98,
    DISCHRG_FET = 0xD9,
    CHRG_FET = 0xDA,
    BMS_RESET = 0x00,
    READ_SOC = 0x61,
    SET_SOC = 0x21
} BMS_Command;

// Cấu trúc lưu trữ dữ liệu BMS
typedef struct {
    // Dữ liệu gói 0x90 (tổng)
    float _sumVoltage;      // Tổng điện áp (V)
    float _sumCurrent;      // Tổng dòng điện (A)
    float _sumSOC;          // Tổng SOC (%)

    // Dữ liệu điện áp cell (gói 0x91, 0x95)
    float _maxCellVoltage;  // Điện áp cell cao nhất (V)
    float _minCellVoltage;  // Điện áp cell thấp nhất (V)
    float _cellVoltages[MAX_CELL_COUNT]; // Mảng điện áp từng cell (V)
    
    // Nhiệt độ và các thông số khác
    float _temperature;     // Nhiệt độ trung bình (°C)
    int   _cycleCount;      // Số chu kỳ sạc/xả
    uint8_t _protectionFlags; // Trạng thái bảo vệ
    float _remainingCapacity;  // Dung lượng còn lại (Ah)
    float _totalCapacity;   // Tổng dung lượng (Ah)
    float _highVoltageProtection; // Ngưỡng bảo vệ điện áp cao
    float _lowVoltageProtection;  // Ngưỡng bảo vệ điện áp thấp
    int   _ntcCount;        // Số lượng cảm biến nhiệt NTC
    float _ntcTemperatures[MAX_CELL_COUNT]; // Mảng nhiệt độ từ cảm biến NTC
    uint8_t _balanceStatus[MAX_CELL_COUNT]; // Trạng thái cân bằng cell
    uint8_t _chargeMOS;     // Trạng thái MOS sạc
    uint8_t _dischargeMOS;  // Trạng thái MOS xả
    int   _cellCount;       // Số lượng cell
    uint8_t _errorCode;     // Mã lỗi
    int   _errorCount;      // Số lượng lỗi
    uint8_t _hardwareVersion; // Phiên bản phần cứng
    uint8_t _softwareVersion; // Phiên bản phần mềm
    char _manufacturer[20];
    char _chargeDischargeStatus[20];  // Nhà sản xuất
    uint8_t _charge_current_limit; // Giới hạn dòng sạc
    uint8_t _discharge_current_limit; // Giới hạn dòng xả
    uint8_t _chargeState;   /* Trạng thái sạc (bật/tắt) */
    uint8_t _loadState;     /* Trạng thái tải (bật/tắt) */
} BMSData;

// TX Ring Buffer (FIFO) cho các lệnh gửi
typedef struct {
    uint8_t _commandID;      // Mã lệnh (ví dụ: 0x90)
    uint8_t _payload[8];     // Payload 8 byte
} TXCommand;

// Khai báo biến toàn cục
extern BMSData _bmsData;
extern TXCommand _txBuffer[_TX_BUFFER_SIZE];
extern uint8_t _rxFrameBuffer[_RX_FRAME_COUNT][_RX_FRAME_SIZE];

// Khai báo hàm
void BMS_Init(void);
uint8_t BMS_SendCommand(BMS_Command cmdID, uint8_t *payload);
uint8_t BMS_ReceiveData(uint8_t expectedFrames);
uint8_t BMS_ValidateChecksum(uint8_t *frame);
void BMS_ProcessData(BMS_Command cmdID, uint8_t frameIndex);
uint8_t BMS_Update(void);
void BMS_ClearData(void);
uint8_t BMS_GetState(void);

#endif // _BMS_H_