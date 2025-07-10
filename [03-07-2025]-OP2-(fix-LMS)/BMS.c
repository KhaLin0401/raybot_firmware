#include "BMS.h"
#include "robot_system.h"

//==================================
// Bi?n to?n c?c luu tr? d? li?u BMS
//==================================
BMSData _bmsData;

//==================================
// TX Ring Buffer (FIFO)
//==================================
TXCommand _txBuffer[_TX_BUFFER_SIZE];
volatile uint8_t _txBufferHead = 0;
volatile uint8_t _txBufferTail = 0;


void TX_PushCommand(uint8_t _commandID, uint8_t * _payload) {
    int _next = (_txBufferHead + 1) % _TX_BUFFER_SIZE;
    if (_next != _txBufferTail) {  // N?u kh?ng d?y
        _txBuffer[_txBufferHead]._commandID = _commandID;
        memcpy(_txBuffer[_txBufferHead]._payload, _payload, 8);
        _txBufferHead = _next;
    }
}

uint8_t TX_IsEmpty(void) {
    return (_txBufferHead == _txBufferTail);
}

TXCommand TX_PopCommand(void) {
    TXCommand _cmd;
    memset(&_cmd, 0, sizeof(TXCommand));
    if (_txBufferHead != _txBufferTail) {
        memcpy(&_cmd, &_txBuffer[_txBufferTail], sizeof(TXCommand));
        _txBufferTail = (_txBufferTail + 1) % _TX_BUFFER_SIZE;
    }
    return _cmd;
}

//==================================
// Immediate TX Queue (FIFO)
//==================================
ImmediateCommand _immediateQueue[_IMMEDIATE_QUEUE_SIZE];
volatile uint8_t _immediateQueueHead = 0;
volatile uint8_t _immediateQueueTail = 0;

void Immediate_PushCommand(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
    /*int _next = (_immediateQueueHead + 1) % _IMMEDIATE_QUEUE_SIZE;
    if (_next != _immediateQueueTail) {
        _immediateQueue[_immediateQueueHead]._commandID = _commandID;
        memcpy(_immediateQueue[_immediateQueueHead]._payload, _payload, 8);
        _immediateQueueHead = _next;
    }*/
    int _next = (_immediateQueueHead + 1) % _IMMEDIATE_QUEUE_SIZE;

    if (_next != _immediateQueueTail) {
        _immediateQueue[_immediateQueueHead]._commandID = _commandID;
        memcpy(_immediateQueue[_immediateQueueHead]._payload, _payload, 7);
        _immediateQueue[_immediateQueueHead]._value = _value;
        _immediateQueueHead = _next;
    } else {
        // Optional: B?o l?i queue d?y
        DebugUART_Send_Text("Immediate Queue Full!\r\n");
    }
}

uint8_t Immediate_IsEmpty(void) {
    return (_immediateQueueHead == _immediateQueueTail);
}

ImmediateCommand Immediate_PopCommand(void) {
    /*ImmediateCommand _cmd;
    memset(&_cmd, 0, sizeof(ImmediateCommand));
    if (_immediateQueueHead != _immediateQueueTail) {
        memcpy(&_cmd, &_immediateQueue[_immediateQueueTail], sizeof(ImmediateCommand));
        _immediateQueueTail = (_immediateQueueTail + 1) % _IMMEDIATE_QUEUE_SIZE;
    }
    return _cmd;*/
    ImmediateCommand _cmd;
    char debug_cmd[30];
    memset(&_cmd, 0, sizeof(ImmediateCommand));


    if (_immediateQueueHead != _immediateQueueTail) {
        memcpy(&_cmd, &_immediateQueue[_immediateQueueTail], sizeof(ImmediateCommand));
        _immediateQueueTail = (_immediateQueueTail + 1) % _IMMEDIATE_QUEUE_SIZE;
    }
    DebugUART_Send_Text("chdebug da nhay vao day \n");
    sprintf(debug_cmd, "CMDID: %d, CMDVL: %d", _cmd._commandID, _cmd._value);
    DebugUART_Send_Text("\n");
    return _cmd;
}

//==================================
// RX Ring Buffer (FIFO) cho UART1
//==================================
uint8_t _rxBuffer[_RX_BUFFER_SIZE];
volatile uint8_t _rxBufferHead = 0;
volatile uint8_t _rxBufferTail = 0;

void RX_PushByte(uint8_t _data) {
    int _next = (_rxBufferHead + 1) % _RX_BUFFER_SIZE;
    if (_next != _rxBufferTail) {
        _rxBuffer[_rxBufferHead] = _data;
        _rxBufferHead = _next;
    }
}

int RX_PopBytes(uint8_t * _buffer, uint16_t _length) {
    uint16_t _available;
    if (_rxBufferHead >= _rxBufferTail)
        _available = _rxBufferHead - _rxBufferTail;
    else
        _available = _RX_BUFFER_SIZE - _rxBufferTail + _rxBufferHead;
    if (_available < _length)
        return 0;  // Kh?ng d? d? li?u
    {
        uint16_t _i;
        for (_i = 0; _i < _length; _i++) {
            _buffer[_i] = _rxBuffer[_rxBufferTail];
            _rxBufferTail = (_rxBufferTail + 1) % _RX_BUFFER_SIZE;
        }
    }
    return _length;
}

int RX_PeekBytes(uint8_t * _buffer, uint16_t _length) {
    uint16_t _available;
    if (_rxBufferHead >= _rxBufferTail)
        _available = _rxBufferHead - _rxBufferTail;
    else
        _available = _RX_BUFFER_SIZE - _rxBufferTail + _rxBufferHead;
    if (_available < _length)
        return 0;
    {
        uint16_t _i;
        uint8_t _idx = _rxBufferTail;
        for (_i = 0; _i < _length; _i++) {
            _buffer[_i] = _rxBuffer[_idx];
            _idx = (_idx + 1) % _RX_BUFFER_SIZE;
        }
    }
    return _length;
}

//==================================
// Flag d?nh d?u TX dang b?n
//==================================
volatile uint8_t _txBusy = 0;

//==================================
// H?m t?nh End Marker d?a v?o CommandID
// V?i l?nh 0x90..0x99: End Marker = 0x7D + (CommandID - 0x90)
// V?i l?nh 0xD8: End Marker = 0xC5; 0xE3: End Marker = 0x58; ngu?c l?i: m?c d?nh 0x7D
//==================================
static uint8_t _getEndMarker(uint8_t _commandID) {
    if (_commandID >= 0x90 && _commandID <= 0x99)
        return 0x7D + (_commandID - 0x90);
    else if (_commandID == 0xD8)
        return 0xC5;
    else if (_commandID == 0xE3)
        return 0x58;
    else
        return 0x7D;
}

//==================================
// H?m x?y d?ng v? g?i g?i l?nh qua UART1
// G?i l?nh: [0xA5, 0x40, CommandID, 0x08, payload[8], EndMarker]
//==================================
static void _sendCommandPacket(uint8_t _commandID, uint8_t * _payload) {
    uint8_t _packet[_SEND_PACKET_SIZE];
    uint8_t _i;  // khai b?o bi?n ngay d?u h?m
    char _dbgStr[100] = ""; // Buffer debug d? ch?a chu?i hex

    // X?y d?ng g?i l?nh theo d?nh d?ng: [0xA5, 0x40, CommandID, 0x08, payload[0..7], EndMarker]
    _packet[0] = 0xA5;                      // Start Marker
    _packet[1] = 0x40;                      // Command Code khi g?i (m?c d?nh 0x40)
    _packet[2] = _commandID;                // Parameter Identifier
    _packet[3] = 0x08;                      // Data Length = 8 byte
    memcpy(&_packet[4], _payload, 8);        // Copy payload (8 byte)
    _packet[12] = _getEndMarker(_commandID); // End Marker du?c t?nh theo CommandID

    // G?i t?ng byte c?a g?i l?nh qua UART1
    for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
        UART1_Write(_packet[_i]);
    }

    // Debug: Chuy?n m?ng nh? ph?n th?nh chu?i hex d? in ra DebugUART
    for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
        char temp[10];
        sprintf(temp, "0x%02X ", _packet[_i]);
        strcat(_dbgStr, temp);
    }
    strcat(_dbgStr, "\r\n");
//    DebugUART_Send_Text(_dbgStr);
}
static void _sendSetCommandPacket(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
    uint8_t _packet[_SEND_PACKET_SIZE];
    uint8_t _i;  // khai b?o bi?n ngay d?u h?m
    char _dbgStr[100] = ""; // Buffer debug d? ch?a chu?i hex

    // X?y d?ng g?i l?nh theo d?nh d?ng: [0xA5, 0x40, CommandID, 0x08, payload[0..7], EndMarker]
    _packet[0] = 0xA5;                      // Start Marker
    _packet[1] = 0x40;                      // Command Code khi g?i (m?c d?nh 0x40)
    _packet[2] = _commandID;                // Parameter Identifier
    _packet[3] = 0x08;
    _packet[4] = _value;                      // Data Length = 8 byte
    memcpy(&_packet[5], _payload, 7);        // Copy payload (8 byte)
    if(_commandID == 0xD9){
        if(_value == 0x00)
             _packet[12] = 0xC6;
        else if (_value == 0x01)
             _packet[12] = 0xC7;
        else return;
    }
    else if(_commandID == 0xDA){
         if(_value == 0x00)
             _packet[12] = 0xC7;
         else if(_value == 0x01)
             _packet[12] = 0xC8;
         else return;
    }
    else {
         _packet[12] = _getEndMarker(_commandID);
    }
    // G?i t?ng byte c?a g?i l?nh qua UART1
    for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
        UART1_Write(_packet[_i]);
    }

    // Debug: Chuy?n m?ng nh? ph?n th?nh chu?i hex d? in ra DebugUART
    for (_i = 0; _i < _SEND_PACKET_SIZE; _i++){
        char temp[10];
        sprintf(temp, "0x%02X ", _packet[_i]);
        strcat(_dbgStr, temp);
    }
    strcat(_dbgStr, "\r\n");
    DebugUART_Send_Text(_dbgStr);
}
//==================================
// H?m x? l? c?c g?i ph?n h?i nh?n du?c (kh?ng ch? blocking)
// ?i?u ki?n h?p l?: g?i 13 byte v?i header: [A5, 01, 9x, 08, ...]
// Sau d?, g?i h?p l? s? du?c pop ra v? x? l?
//==================================
static void _processReceivedResponsePacket(void) {
    // Khai b?o bi?n ngay d?u h?m
    uint8_t _temp[_EXPECTED_PACKET_SIZE];
    char _dbgStr[150];
    uint8_t _discard;
    uint8_t i,j = 0;
    uint16_t raw_value = 0;
    int16_t raw_signed = 0;
    uint8_t checksum = 0;
    char failCodeArr[] = "";

    // N?u trong RX buffer c? d? 13 byte, th?c hi?n Peek
    if (RX_PeekBytes(_temp, _EXPECTED_PACKET_SIZE) == _EXPECTED_PACKET_SIZE) {
        // In ra g?i du?c Peek (d?ng hex)
        strcpy(_dbgStr, "Peeked Packet: ");
        for (i = 0; i < _EXPECTED_PACKET_SIZE; i++) {
            char _byteStr[10];
            sprintf(_byteStr, "0x%02X ", _temp[i]);
            strcat(_dbgStr, _byteStr);
        }
        strcat(_dbgStr, "\r\n");
        //DebugUART_Send_Text(_dbgStr);

        // Ki?m tra header: Byte0 = 0xA5, Byte1 = 0x01, Byte3 = 0x08 v? Byte2 thu?c 0x90..0x9F
        if ((_temp[0] == 0xA5) && (_temp[1] == 0x01) &&
            (_temp[3] == 0x08) && (((_temp[2]) & 0xF0) == 0x90)) {

            //DebugUART_Send_Text("Valid Packet Found.\r\n");

            // Pop 13 byte kh?i RX buffer v? d? x? l?
            RX_PopBytes(_temp, _EXPECTED_PACKET_SIZE);

            // Ki?m tra checksum tru?c khi x? l?

            for (i = 0; i < _EXPECTED_PACKET_SIZE - 1; i++) {
                checksum += _temp[i];
            }

            if (checksum == _temp[_EXPECTED_PACKET_SIZE - 1]) {
                // Checksum h?p l?, ti?p t?c x? l?
                switch (_temp[2]) {
                    case 0x90: {
                        // G?i 0x90: Payload g?m 8 byte:
                        //  - Bytes 4-5: Sum Voltage, quy u?c chia cho 10 -> v? d?: 0x00 0x7B = 123 => 12.3 V
                        //  - Bytes 6-7: Sum Current, chia cho 10 -> v? d?: 0x00 0x00 = 0 A
                        //  - Bytes 8-9: S? lu?ng cell v? tr?ng th?i h? th?ng
                        //  - Bytes 10-11: Sum SOC, chia cho 10 -> v? d?: 0x03 0xE3 = 995 => 99.5 %
                        raw_value = (((uint16_t)_temp[4]) << 8) | _temp[5];
                        _bmsData._sumVoltage = raw_value / 10.0;

                        raw_signed = ((((uint16_t)(_temp[8]) << 8) | (uint16_t)_temp[9]) / 10.0f) - 3000;
                        _bmsData._sumCurrent = raw_signed;

                        // Luu s? lu?ng cell
                        _bmsData._cellCount = 4;

                         raw_value =(uint16_t)(_temp[10] << 8 | _temp[11]);
                        _bmsData._sumSOC = (raw_value / 10.0f);

//                        sprintf(_dbgStr, "Sum Voltage: %.2f V, Sum Current: %.2f A, Cell Count: %d, Sum SOC: %.2f %%\r\n",
//                                _bmsData._sumVoltage, _bmsData._sumCurrent, _bmsData._cellCount, _bmsData._sumSOC);
//                        DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x91: {
                        // G?i 0x91: Th?ng tin v? dung lu?ng pin
                        // Bytes 4-5: 0x10 0x2A = 4138 mAh (dung lu?ng c?n l?i)
                        // Bytes 6-7: 0x03 0x0F = 783 (dung lu?ng thi?t k?)
                        // Bytes 8-9: 0xF8 0x01 = s? chu k? s?c/x?
                        raw_value = (((uint16_t)_temp[4]) << 8) | _temp[5];
                        _bmsData._remainingCapacity = raw_value / 100.0; // Convert to Ah

                        raw_value = (((uint16_t)_temp[6]) << 8) | _temp[7];
                        _bmsData._totalCapacity = raw_value / 100.0; // Convert to Ah

                        raw_value = (((uint16_t)_temp[8]) << 8) | _temp[9];
                        _bmsData._cycleCount = raw_value;

                        sprintf(_dbgStr, "Remaining Capacity: %.2f Ah, Total Capacity: %.2f Ah, Cycles: %d\r\n",
                                _bmsData._remainingCapacity, _bmsData._totalCapacity, _bmsData._cycleCount);
                        //DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x92: {
                        // G?i 0x92: Th?ng tin ngu?ng b?o v?
                        // Bytes 4-5: ?i?n ?p b?o v? cao
                        // Bytes 6-7: ?i?n ?p b?o v? th?p
                        // raw_value = (((uint16_t)_temp[4]) << 8) | _temp[5];
                        // _bmsData._highVoltageProtection = raw_value / 10.0;

                        // raw_value = (((uint16_t)_temp[6]) << 8) | _temp[7];
                        // _bmsData._lowVoltageProtection = raw_value / 10.0;

                        // sprintf(_dbgStr, "High Voltage Protection: %.1f V, Low Voltage Protection: %.1f V\r\n",
                        //         _bmsData._highVoltageProtection, _bmsData._lowVoltageProtection);
                        raw_value =  (uint16_t) ((((_temp[4]) - 40) + (( _temp[6]) - 40)) /2);
                        _bmsData._temperature = raw_value;
                        //DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x93: {
                        /*// G?i 0x93: Th?ng tin nhi?t d?
                        // Byte 4: S? lu?ng c?m bi?n nhi?t d?
                        // Byte 5-6: Nhi?t d? (c?n c?ng th?m 20 d? c? nhi?t d? th?c)
                        _bmsData._ntcCount = _temp[4];
                        //_bmsData._temperature[0] = _temp[5] + 20;
                        //_bmsData._temperature[1] = _temp[6] + 20;

                        _bmsData._counter = _temp[7]; // B? d?m tr?ng th?i

                        // Bytes 10-11: M? l?i/c?nh b?o
                        raw_value = (((uint16_t)_temp[10]) << 8) | _temp[11];
                        _bmsData._errorCode = raw_value;

                        sprintf(_dbgStr, "NTC Count: %d, Temp1: %d ?C, Temp2: %d ?C, Counter: %d, Error: 0x%04X\r\n",
                                _temp[5] + 20, _temp[5] + 20, _temp[6] + 20,
                                _bmsData._counter, _bmsData._errorCode);*/
                        _bmsData._chargeMOS = _temp[6];
                        _bmsData._dischargeMOS = _temp[7];

                        sprintf(_dbgStr, "Charge MOS: %s, Discharge MOS: %s\r\n",
                                _bmsData._chargeMOS ? "ON" : "OFF",
                                _bmsData._dischargeMOS ? "ON" : "OFF");
                        DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x94: {
                        // G?i 0x94: Th?ng tin c?n b?ng pin
                        // Byte 4: S? lu?ng cell
                        // Byte 5: S? lu?ng c?m bi?n nhi?t d?
                        _bmsData._cellCount = _temp[4];
                        _bmsData._ntcCount = _temp[5];

                        sprintf(_dbgStr, "Cell Count: %d, NTC Count: %d\r\n",
                                _bmsData._cellCount, _bmsData._ntcCount);
                       // DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x95: {
                        // G?i 0x95: Th?ng tin MOSFET
                        // Byte 4: Tr?ng th?i MOSFET s?c (1 = ON, 0 = OFF)
                        // Bytes 5-6: Th?i gian s?c c?n l?i
                        // Byte 7: Tr?ng th?i MOSFET x? (1 = ON, 0 = OFF)
                        // Bytes 8-9: Th?i gian x? c?n l?i
                        // _bmsData._chargeMOS = _temp[4];
                        // _bmsData._dischargeMOS = _temp[7];
                        for (j = 0; j < 3; j++){
                            _bmsData._cellVoltages[j] = (_temp[5 + j + j] << 8) | _temp[6 + j + j];
                        }

                        _bmsData._cellVoltages[3] = (_bmsData._cellVoltages[0] 
                            + _bmsData._cellVoltages[1] + _bmsData._cellVoltages[2]) / 3;

                        // sprintf(_dbgStr, "Charge MOS: %s, Discharge MOS: %s\r\n",
                        //         _bmsData._chargeMOS ? "ON" : "OFF",
                        //         _bmsData._dischargeMOS ? "ON" : "OFF");

                        //DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x96: {
                        // G?i 0x96: Th?ng tin di?n ?p cell
                        // Byte 4: S? lu?ng cell trong g?i n?y
                        // Bytes 5-6: ?i?n ?p cell
                        uint8_t cellIndex = _temp[4] - 1;
                        if (cellIndex < MAX_CELL_COUNT) {
                            raw_value = (((uint16_t)_temp[5]) << 8) | _temp[6];
                            _bmsData._cellVoltages[cellIndex] = raw_value / 1000.0;

                            sprintf(_dbgStr, "Cell %d Voltage: %.3f V\r\n",
                                    cellIndex + 1, _bmsData._cellVoltages[cellIndex]);
                            //DebugUART_Send_Text(_dbgStr);

                            // C?p nh?t min/max sau khi nh?n du?c t?t c? c?c di?n ?p cell
                            if (cellIndex == _bmsData._cellCount - 1) {
                                //_updateMinMaxCellVoltage();
                            }
                        }
                        break;
                    }
                    case 0x97: {
                        // G?i 0x97: Th?ng tin c?n b?ng m? r?ng
                        // Th?ng tin c?n b?ng pin cho t?t c? c?c cell
                        _bmsData._balanceStatus = _temp[4];

                        sprintf(_dbgStr, "Balance Status: 0x%02X\r\n", _bmsData._balanceStatus);
                       // DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x98: {
                        // G?i 0x98: Th?ng tin l?i
                        // Byte 4: S? lu?ng l?i
                        _bmsData._errorCount = _temp[4];
                        
                        sprintf(_dbgStr, "Error Count: %d\r\n", _bmsData._errorCount);
                       // DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    case 0x99: {
                        // G?i 0x99: Th?ng tin phi?n b?n
                        // Bytes 4-5: M? phi?n b?n ph?n c?ng
                        // Bytes 6-7: M? phi?n b?n ph?n m?m
                        // Bytes 10-11: M? nh? s?n xu?t
                        _bmsData._hardwareVersion = (((uint16_t)_temp[4]) << 8) | _temp[5];
                        _bmsData._softwareVersion = (((uint16_t)_temp[6]) << 8) | _temp[7];

                        // Luu m? nh? s?n xu?t (2 byte ASCII)
                        _bmsData._manufacturer[0] = _temp[10];
                        _bmsData._manufacturer[1] = _temp[11];
                        _bmsData._manufacturer[2] = '\0';

                        sprintf(_dbgStr, "HW Version: 0x%04X, SW Version: 0x%04X, Manufacturer: %s\r\n",
                                _bmsData._hardwareVersion, _bmsData._softwareVersion, _bmsData._manufacturer);
                      //  DebugUART_Send_Text(_dbgStr);
                        break;
                    }
                    default:
                       // DebugUART_Send_Text("Unknown command in received packet.\r\n");
                        break;
                }
            } else {
                sprintf(_dbgStr, "Checksum Error! Calculated: 0x%02X, Received: 0x%02X\r\n",
                        checksum, _temp[_EXPECTED_PACKET_SIZE - 1]);
                //DebugUART_Send_Text(_dbgStr);
            }
        } else {
            // N?u header kh?ng h?p l?, in ra v? lo?i b? 1 byte d? d?ng b? l?i
            sprintf(_dbgStr, "Invalid Packet Header: 0x%02X 0x%02X 0x%02X 0x%02X\r\n",
                    _temp[0], _temp[1], _temp[2], _temp[3]);
            //DebugUART_Send_Text(_dbgStr);
            RX_PopBytes(&_discard, 1);
        }
    }
}

// H?m c?p nh?t di?n ?p cell min/max
static void _updateMinMaxCellVoltage(void) {
    uint8_t i;

    // Kh?i t?o min/max b?ng di?n ?p cell d?u ti?n
    _bmsData._minCellVoltage = _bmsData._cellVoltages[0];
    _bmsData._maxCellVoltage = _bmsData._cellVoltages[0];
    //_bmsData._minCellIndex = 0;
    //_bmsData._maxCellIndex = 0;

    // T?m min/max
    for (i = 1; i < _bmsData._cellCount; i++) {
        if (_bmsData._cellVoltages[i] < _bmsData._minCellVoltage) {
            _bmsData._minCellVoltage = _bmsData._cellVoltages[i];
            //_bmsData._minCellIndex = i;
        }
        if (_bmsData._cellVoltages[i] > _bmsData._maxCellVoltage) {
            _bmsData._maxCellVoltage = _bmsData._cellVoltages[i];
            //_bmsData._maxCellIndex = i;
        }
    }
}


//==================================
// H?m g?i l?nh ngay l?p t?c (immediate)
// N?u TX dang b?n th? l?nh du?c dua v?o Immediate queue
//==================================
void BMS_SendCommandImmediate(uint8_t _commandID, uint8_t * _payload, uint8_t _value) {
    /*ImmediateCommand _imCmd;
    if (_txBusy) {
        Immediate_PushCommand(_commandID, _payload);
    } else {
        _txBusy = 1;
        _sendSetCommandPacket(_commandID, _payload, _value);
        // Kh?ng ch? blocking nh?n ph?n h?i; ph?n h?i s? du?c luu v?o RX ring buffer qua ng?t.
        _txBusy = 0;
        if (!Immediate_IsEmpty()) {
            _imCmd = Immediate_PopCommand();
            BMS_SendCommandImmediate(_imCmd._commandID, _imCmd._payload);
        }
    }*/
    ImmediateCommand _imCmd;
    Immediate_PushCommand(_commandID, _payload, _value);

    if (!_txBusy) {
        _txBusy = 1;
        while (!Immediate_IsEmpty()) {
            _imCmd = Immediate_PopCommand();
            _sendSetCommandPacket(_imCmd._commandID, _imCmd._payload, _imCmd._value);
        }

        _txBusy = 0;
    }
}

//==================================
// H?m push l?nh v?o TX ring buffer (d? g?i sau qua BMS_Update)
//==================================
void BMS_PushCommand(uint8_t _commandID, uint8_t * _payload) {
    TX_PushCommand(_commandID, _payload);
}

//==================================
// H?m BMS_Update: Uu ti?n x? l? Immediate queue, sau d? TX ring buffer,
// n?u c? hai d?u r?ng th? g?i c?c l?nh m?c d?nh (0x91 d?n 0x99) theo v?ng l?p FIFO.
// ??ng th?i, tru?c khi g?i l?nh m?i, g?i _processReceivedResponsePacket() d? x? l? c?c ph?n h?i d? nh?n.
void BMS_Update(void) {
    static uint8_t _defaultCommandIndex = 0;
    ImmediateCommand _imCmd;
    TXCommand _txCmd;
    //DebugUART_Send_Text("co ngat UART 1 xay ra \n");
    // X? l? c?c ph?n h?i d? nh?n (kh?ng blocking)
    _processReceivedResponsePacket();

    if (!Immediate_IsEmpty()) {
        _imCmd = Immediate_PopCommand();
        DebugUART_Send_Text("Da lay duoc lenh\r\n");
        _sendSetCommandPacket(_imCmd._commandID, _imCmd._payload, _imCmd._value);
        //BMS_SendCommandImmediate(_imCmd._commandID, _imCmd._payload, _imCmd._value);
    } else if (!TX_IsEmpty()) {
        _txCmd = TX_PopCommand();
        _sendCommandPacket(_txCmd._commandID, _txCmd._payload);
    } else {
        // G?i l?nh m?c d?nh 0x91 d?n 0x99 theo th? t? FIFO
        uint8_t _defaultPayload[8] = {0};
        switch(_defaultCommandIndex) {
            case 0: _sendCommandPacket(0x90, _defaultPayload); break;
            case 1: _sendCommandPacket(0x91, _defaultPayload); break;
            case 2: _sendCommandPacket(0x92, _defaultPayload); break;
            case 3: _sendCommandPacket(0x93, _defaultPayload); break;
            case 4: _sendCommandPacket(0x94, _defaultPayload); break;
            case 5: _sendCommandPacket(0x95, _defaultPayload); break;
            case 6: _sendCommandPacket(0x96, _defaultPayload); break;
            case 7: _sendCommandPacket(0x97, _defaultPayload); break;
            case 8: _sendCommandPacket(0x98, _defaultPayload); break;
            case 9: _sendCommandPacket(0x99, _defaultPayload); break;
            default: break;
        }
        _defaultCommandIndex++;
        if (_defaultCommandIndex >= 10)
            _defaultCommandIndex = 0;
    }
}

//==================================
// H?m BMS_Init: kh?i t?o UART1, b?t ng?t RX, reset d? li?u v? c?c ring buffer
//==================================
void BMS_Init(void) {

    _bmsData._sumVoltage = 0;
    _bmsData._sumCurrent = 0;
    _bmsData._sumSOC = 0;
    _bmsData._temperature = 0;
    _bmsData._cycleCount = 0;
    _bmsData._protectionFlags = 0;
    _bmsData._cellVoltages[0] = 0;
    _bmsData._cellVoltages[1] = 0;
    _bmsData._cellVoltages[2] = 0;
    _bmsData._cellVoltages[3] = 0;


    _txBufferHead = 0;
    _txBufferTail = 0;
    _immediateQueueHead = 0;
    _immediateQueueTail = 0;
    _rxBufferHead = 0;
    _rxBufferTail = 0;
    _txBusy = 0;

    _bmsData._charge_current_limit = 0;
    _bmsData._discharge_current_limit = 0;

    IEC0bits.U1RXIE = 1;
    IFS0bits.U1RXIF = 0;
}

//==================================
// H?m ng?t UART1: luu t?ng byte nh?n du?c v?o RX ring buffer (FIFO)
//==================================
// H?m ng?t UART1: du?c g?i khi c? d? li?u d?n t? UART1.
// M?c d?ch: ??c 1 byte d? li?u t? UART1, luu v?o RX ring buffer v? in ra debug th?ng tin (byte nh?n v? tr?ng th?i ring buffer).
void _UART1_Interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
    char _dbgStr[150];          // Buffer ch?a chu?i debug
    uint8_t _packet[_SEND_PACKET_SIZE];  // Buffer t?m d? ch?a g?i 13 byte
    int _next;                  // Bi?n d?ng d? t?nh ch? s? ti?p theo c?a RX ring buffer
    uint8_t i;  uint8_t _byte;
    uint8_t _dummy[13];
    // ??c t?t c? c?c byte c? s?n t? UART1 v? luu v?o RX ring buffer
    while (UART1_Data_Ready()) {
         _byte = UART1_Read();  // ??c 1 byte t? UART1

        // T?nh ch? s? ti?p theo theo co ch? ring buffer
        _next = (_rxBufferHead + 1) % _RX_BUFFER_SIZE;
        if (_next != _rxBufferTail) {  // N?u buffer chua d?y
            _rxBuffer[_rxBufferHead] = _byte;  // Luu byte v?o buffer
            _rxBufferHead = _next;             // C?p nh?t ch? s? head
        }
    }

    // X?a c? ng?t RX d? ng?t c? th? k?ch ho?t l?i
    IFS0bits.U1RXIF = 0;
}