#include "bms.h"
#include "schedule_task.h"


/* Biến toàn cục */
BMSData _bmsData;
TXCommand _txBuffer[_TX_BUFFER_SIZE];
uint8_t _rxFrameBuffer[_RX_FRAME_COUNT][_RX_FRAME_SIZE];

/* Biến quản lý ngắt UART */
static volatile uint8_t _currentFrameIndex = 0;
static volatile uint8_t _currentByteIndex = 0;
static volatile uint8_t _frameStarted = 0;
static volatile uint8_t _framesReceived = 0;

/* Biến đếm mili giây */


/* Bộ đếm cho vòng lặp lệnh */
static uint8_t requestCounter = 0;
static uint8_t errorCounter = 0;

/* Hàm lấy thời gian mili giây */



void BMS_Init(void) {
    /* Khởi tạo UART1 với baud rate 9600 */

    
    /* Bật ngắt UART1 RX */
    IEC0bits.U1RXIE = 1;
    IFS0bits.U1RXIF = 0;

    /* Xóa buffer TX và RX */
    memset(_txBuffer, 0, sizeof(_txBuffer));
    memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));

    /* Reset biến ngắt */
    _currentFrameIndex = 0;
    _currentByteIndex = 0;
    _frameStarted = 0;
    _framesReceived = 0;

    /* Xóa và khởi tạo struct _bmsData */
    BMS_ClearData();

    /* Reset bộ đếm */
    requestCounter = 0;
    errorCounter = 0;
}

void BMS_ClearData(void) {
    memset(&_bmsData, 0, sizeof(BMSData));
    strcpy(_bmsData._manufacturer, "DALY");
    strcpy(_bmsData._chargeDischargeStatus, "offline");
    _bmsData._errorCount = 0;
}

uint8_t BMS_SendCommand(BMS_Command cmdID, uint8_t *payload) {
    uint8_t packet[_SEND_PACKET_SIZE];
    uint8_t checksum;
    uint8_t i;

    /* Xóa buffer RX */
    while (UART1_Data_Ready()) {
        UART1_Read();
    }

    /* Reset biến ngắt */
    _currentFrameIndex = 0;
    _currentByteIndex = 0;
    _frameStarted = 0;
    _framesReceived = 0;
    memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));

    /* Tạo gói tin */
    packet[0] = START_BYTE;
    packet[1] = HOST_ADDRESS;
    packet[2] = cmdID;
    packet[3] = 0x08;

    /* Sao chép payload */
    if (payload != ((void *)0)) {
        for (i = 0; i < 8; i++) {
            packet[4 + i] = payload[i];
        }
    } else {
        for (i = 0; i < 8; i++) {
            packet[4 + i] = 0x00;
        }
    }

    /* Tính checksum */
    checksum = 0;
    for (i = 0; i < 12; i++) {
        checksum += packet[i];
    }
    packet[12] = checksum;

    /* Gửi gói tin */
    for (i = 0; i < _SEND_PACKET_SIZE; i++) {
        UART1_Write(packet[i]);
    }

    /* Đợi truyền xong */
    while (!UART1_Tx_Idle()) {
    }

    return 1;
}

uint8_t BMS_ReceiveData(uint8_t expectedFrames) {
    unsigned long startTime;
    uint8_t framesReceived;

    startTime = GetMillis();
    while (_framesReceived < expectedFrames && (GetMillis() - startTime < 150)) {
        /* Chờ ngắt UART điền dữ liệu */
    }

    framesReceived = _framesReceived;

    /* Reset biến ngắt */
    _currentFrameIndex = 0;
    _currentByteIndex = 0;
    _frameStarted = 0;
    _framesReceived = 0;

    if (framesReceived < expectedFrames) {
        _bmsData._errorCount++;
        _bmsData._errorCode = 6;
    }

    return framesReceived;
}

uint8_t BMS_ValidateChecksum(uint8_t frameIndex) {
    uint8_t checksum;
    uint8_t i;

    if (frameIndex >= _RX_FRAME_COUNT) {
        _bmsData._errorCount++;
        return 0;
    }

    if (_rxFrameBuffer[frameIndex][0] != START_BYTE) {
        _bmsData._errorCount++;
        return 0;
    }

    if (_rxFrameBuffer[frameIndex][1] != 0x01) {
        if (_rxFrameBuffer[frameIndex][1] >= 0x20) {
            _bmsData._errorCount++;
            _bmsData._errorCode = 1;
        }
        return 0;
    }

    checksum = 0;
    for (i = 0; i < _RX_FRAME_SIZE - 1; i++) {
        checksum += _rxFrameBuffer[frameIndex][i];
    }

    if (checksum != _rxFrameBuffer[frameIndex][_RX_FRAME_SIZE - 1]) {
        _bmsData._errorCount++;
        _bmsData._errorCode = 2;
        return 0;
    }

    if (checksum == 0) {
        _bmsData._errorCount++;
        _bmsData._errorCode = 3;
        return 0;
    }

    return 1;
}

void BMS_ProcessData(BMS_Command cmdID, uint8_t frameIndex) {
    uint16_t tempValue;
    uint8_t i;

    if (frameIndex >= _RX_FRAME_COUNT) {
        _bmsData._errorCount++;
        _bmsData._errorCode = 4;
        return;
    }

    switch (cmdID) {
        case VOUT_IOUT_SOC:
            tempValue = (_rxFrameBuffer[frameIndex][4] << 8) | _rxFrameBuffer[frameIndex][5];
            _bmsData._sumVoltage = (float)tempValue / 10.0;

            tempValue = (_rxFrameBuffer[frameIndex][8] << 8) | _rxFrameBuffer[frameIndex][9];
            if (tempValue == 0) break;
            _bmsData._sumCurrent = ((float)(tempValue - 30000)) / 10.0;

            tempValue = (_rxFrameBuffer[frameIndex][10] << 8) | _rxFrameBuffer[frameIndex][11];
            if (tempValue > 1000) break;
            _bmsData._sumSOC = (float)tempValue / 10.0;
            break;

        case MIN_MAX_CELL_VOLTAGE:
            tempValue = (_rxFrameBuffer[frameIndex][4] << 8) | _rxFrameBuffer[frameIndex][5];
            _bmsData._maxCellVoltage = (float)tempValue / 1000.0;

            tempValue = (_rxFrameBuffer[frameIndex][7] << 8) | _rxFrameBuffer[frameIndex][8];
            _bmsData._minCellVoltage = (float)tempValue / 1000.0;
            break;

        case MIN_MAX_TEMPERATURE:
            _bmsData._temperature = ((float)(_rxFrameBuffer[frameIndex][4] + _rxFrameBuffer[frameIndex][6]) - 80.0) / 2.0;
            break;

        case DISCHARGE_CHARGE_MOS_STATUS:
            switch (_rxFrameBuffer[frameIndex][4]) {
                case 0:
                    strcpy(_bmsData._chargeDischargeStatus, "Stationary");
                    break;
                case 1:
                    strcpy(_bmsData._chargeDischargeStatus, "Charge");
                    break;
                case 2:
                    strcpy(_bmsData._chargeDischargeStatus, "Discharge");
                    break;
                default:
                    strcpy(_bmsData._chargeDischargeStatus, "Unknown");
                    break;
            }

            _bmsData._chargeMOS = _rxFrameBuffer[frameIndex][5];
            _bmsData._dischargeMOS = _rxFrameBuffer[frameIndex][6];

            _bmsData._remainingCapacity = (float)((((uint32_t)_rxFrameBuffer[frameIndex][8] << 24) |
                                                  ((uint32_t)_rxFrameBuffer[frameIndex][9] << 16) |
                                                  ((uint32_t)_rxFrameBuffer[frameIndex][10] << 8) |
                                                  _rxFrameBuffer[frameIndex][11])) / 1000.0;
            break;

        case STATUS_INFO:
            _bmsData._cellCount = _rxFrameBuffer[frameIndex][4];
            _bmsData._ntcCount = _rxFrameBuffer[frameIndex][5];
            _bmsData._chargeState = _rxFrameBuffer[frameIndex][6];
            _bmsData._loadState = _rxFrameBuffer[frameIndex][7];
            _bmsData._cycleCount = (_rxFrameBuffer[frameIndex][9] << 8) | _rxFrameBuffer[frameIndex][10];
            break;

        case CELL_VOLTAGES:
            for (i = 0; i < 3; i++) {
                uint8_t cellIndex;
                cellIndex = frameIndex * 3 + i;
                if (cellIndex < _bmsData._cellCount && cellIndex < MAX_CELL_COUNT) {
                    tempValue = (_rxFrameBuffer[frameIndex][5 + i * 2] << 8) | _rxFrameBuffer[frameIndex][6 + i * 2];
                    _bmsData._cellVoltages[cellIndex] = (float)tempValue / 1000.0;
                }
            }
            break;

        case CELL_TEMPERATURE:
            for (i = 0; i < 7; i++) {
                uint8_t sensorIndex;
                sensorIndex = frameIndex * 7 + i;
                if (sensorIndex < _bmsData._ntcCount && sensorIndex < MAX_CELL_COUNT) {
                    _bmsData._ntcTemperatures[sensorIndex] = (float)(_rxFrameBuffer[frameIndex][5 + i] - 40);
                }
            }
            break;

        case CELL_BALANCE_STATE:
            for (i = 0; i < 6; i++) {
                uint8_t cellIndex;
                uint8_t j;
                cellIndex = i * 8;
                for (j = 0; j < 8; j++) {
                    if (cellIndex + j < _bmsData._cellCount && cellIndex + j < MAX_CELL_COUNT) {
                        _bmsData._balanceStatus[cellIndex + j] = (_rxFrameBuffer[frameIndex][4 + i] >> j) & 0x01;
                    }
                }
            }
            break;

        case FAILURE_CODES:
            _bmsData._errorCode = _rxFrameBuffer[frameIndex][4];
            break;

        default:
            _bmsData._errorCount++;
            _bmsData._errorCode = 5;
            break;
    }
}

uint8_t BMS_Update(void) {
    static BMS_Command commands[] = {
        VOUT_IOUT_SOC,
        MIN_MAX_CELL_VOLTAGE,
        MIN_MAX_TEMPERATURE,
        DISCHARGE_CHARGE_MOS_STATUS,
        STATUS_INFO,
        CELL_VOLTAGES,
        CELL_TEMPERATURE,
        CELL_BALANCE_STATE,
        FAILURE_CODES
    };
    static const uint8_t commandCount = sizeof(commands) / sizeof(commands[0]);
    uint8_t payload[8];
    uint8_t framesExpected;
    uint8_t framesReceived;
    uint8_t i;
    uint8_t success;

    /* Khởi tạo biến */
    success = 0;
    for (i = 0; i < 8; i++) {
        payload[i] = 0;
    }

    /* Chọn lệnh hiện tại */
    switch (commands[requestCounter]) {
        case CELL_VOLTAGES:
            framesExpected = (_bmsData._cellCount + 2) / 3;
            break;
        case CELL_TEMPERATURE:
            framesExpected = (_bmsData._ntcCount + 6) / 7;
            break;
        case CELL_BALANCE_STATE:
            framesExpected = (_bmsData._cellCount + 47) / 48;
            break;
        default:
            framesExpected = 1;
            break;
    }

    /* Gửi lệnh */
    if (BMS_SendCommand(commands[requestCounter], payload)) {
        /* Nhận dữ liệu */
        framesReceived = BMS_ReceiveData(framesExpected);

        /* Kiểm tra và xử lý dữ liệu */
        if (framesReceived > 0) {
            success = 1;
            for (i = 0; i < framesReceived; i++) {
                if (BMS_ValidateChecksum(i)) {
                    BMS_ProcessData(commands[requestCounter], i);
                } else {
                    success = 0;
                    break;
                }
            }
        }
    }

    /* Xử lý lỗi */
    if (!success) {
        errorCounter++;
        if (errorCounter >= 10) {
            BMS_ClearData();
            requestCounter = 0;
            errorCounter = 0;
            strcpy(_bmsData._chargeDischargeStatus, "offline");
            return 0;
        }
    } else {
        errorCounter = 0;
        strcpy(_bmsData._chargeDischargeStatus, "online");
    }

    /* Tăng bộ đếm lệnh */
    requestCounter = (requestCounter + 1) % commandCount;

    return success;
}

void _UART1_Interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
    uint8_t byte;

    while (UART1_Data_Ready()) {
        byte = UART1_Read();

        if (!_frameStarted && byte == START_BYTE) {
            _frameStarted = 1;
            _currentByteIndex = 0;
            if (_currentFrameIndex < _RX_FRAME_COUNT) {
                _rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
                _currentByteIndex++;
            }
        } else if (_frameStarted) {
            if (_currentFrameIndex < _RX_FRAME_COUNT && _currentByteIndex < _RX_FRAME_SIZE) {
                _rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
                _currentByteIndex++;

                if (_currentByteIndex >= _RX_FRAME_SIZE) {
                    _framesReceived++;
                    _currentFrameIndex++;
                    _frameStarted = 0;
                }
            } else {
                _frameStarted = 0;
                _bmsData._errorCount++;
                _bmsData._errorCode = 7;
            }
        }
    }

    IFS0bits.U1RXIF = 0;
}