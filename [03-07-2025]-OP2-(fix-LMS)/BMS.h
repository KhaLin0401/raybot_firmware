#ifndef _BMS_H_
#define _BMS_H_

#include <stdint.h>
#include <string.h>


// K?ch thu?c g?i l?nh (m?i g?i c? 13 byte)
#define _SEND_PACKET_SIZE       13
#define _EXPECTED_PACKET_SIZE   13

// C?u tr?c luu tr? d? li?u BMS (d? li?u do du?c t? BMS)
typedef struct {
    // D? li?u g?i 0x90 (t?ng)
    float _sumVoltage;      // T?ng di?n ?p (V), v? d?: 12,3 V
    float _sumCurrent;      // T?ng d?ng di?n (A), v? d?: 0,0 A
    float _sumSOC;          // T?ng SOC (%), v? d?: 99,5 %

    // D? li?u di?n ?p cell:
    float _maxCellVoltage;  // T? g?i 0x91, v? d?: ~4,138 V
    float _cellVoltages[4]; // T? c?c g?i 0x92, 0x93, 0x94, ?ng v?i Cell 1, Cell 2, Cell 3
                            // (v? d?: ~4,088 V, ~4,119 V, ~4,123 V)
    float _minCellVoltage;  // T?nh du?c: min c?a 3 cell tr?n (v? d?: ~4,088 V)

    // C?c th?ng s? kh?c:
    float _temperature;     // Nhi?t d? (?C) ? gi? s? l?y t? g?i 0x97 (n?u sensor NTC c? gi? tr?)
    int   _cycleCount;      // S? chu k? s?c/x?, t? g?i 0x95
    uint8_t _protectionFlags; // Tr?ng th?i b?o v?, t? g?i 0x96
    float _performance;     // Th?ng s? hi?u su?t, t? g?i 0x98
    float _backup;          // Th?ng s? d? ph?ng, t? g?i 0x99

    // C?c tru?ng b? sung t? th?ng b?o l?i:
    int   _cellCount;       // S? lu?ng cell
    float _remainingCapacity;  // Dung lu?ng c?n l?i
    float _totalCapacity;   // T?ng dung lu?ng
    float _highVoltageProtection;  // Ngu?ng b?o v? di?n ?p cao
    float _lowVoltageProtection;   // Ngu?ng b?o v? di?n ?p th?p
    int   _ntcCount;        // S? lu?ng c?m bi?n nhi?t NTC
    float *_ntcTemperatures; // M?ng nhi?t d? t? c?c c?m bi?n NTC
    int   _counter;         // B? d?m
    uint8_t _errorCode;     // M? l?i
    uint8_t  _chargeMOS;       // Tr?ng th?i MOS s?c
    uint8_t  _dischargeMOS;    // Tr?ng th?i MOS x?
    uint8_t *_balanceStatus;  // Tr?ng th?i c?n b?ng c?c cell
    int   _errorCount;      // S? lu?ng l?i
    uint8_t _hardwareVersion; // Phi?n b?n ph?n c?ng
    uint8_t _softwareVersion; // Phi?n b?n ph?n m?m
    char *_manufacturer;    // Nh? s?n xu?t
    uint8_t _charge_current_limit;
    uint8_t _discharge_current_limit;
} BMSData;

// ??nh nghia h?ng s? MAX_CELL_COUNT
#define MAX_CELL_COUNT 16

// Khai b?o h?m c?p nh?t gi? tr? min/max c?a cell
void _updateMinMaxCellVoltage(BMSData *bmsData);

extern BMSData _bmsData;


//---------------------------
// TX Ring Buffer (FIFO) cho c?c l?nh g?i th?ng thu?ng
//---------------------------
#define _TX_BUFFER_SIZE  10
typedef struct {
    uint8_t _commandID;      // M? l?nh (v? d?: 0x90 ~ 0x99)
    uint8_t _payload[8];     // Payload 8 byte (n?u kh?ng c? tham s?, to?n 0)
} TXCommand;
extern TXCommand _txBuffer[_TX_BUFFER_SIZE];
extern volatile uint8_t _txBufferHead; // index d? push
extern volatile uint8_t _txBufferTail; // index d? pop
void TX_PushCommand(uint8_t _commandID, uint8_t * _payload);
uint8_t TX_IsEmpty(void);
TXCommand TX_PopCommand(void);

//---------------------------
// RX Ring Buffer (FIFO) cho c?c byte nh?n t? UART1
//---------------------------
#define _RX_BUFFER_SIZE  50
extern uint8_t _rxBuffer[_RX_BUFFER_SIZE];
extern volatile uint8_t _rxBufferHead;
extern volatile uint8_t _rxBufferTail;
void RX_PushByte(uint8_t _data);
int RX_PopBytes(uint8_t * _buffer, uint16_t _length);
int RX_PeekBytes(uint8_t * _buffer, uint16_t _length);  // L?y d? li?u m? kh?ng pop

//---------------------------
// Immediate TX Queue (FIFO) cho c?c l?nh c?n g?i ngay (uu ti?n)
//---------------------------
#define _IMMEDIATE_QUEUE_SIZE  10
typedef struct {
    uint8_t _commandID;
    uint8_t _payload[7];
    uint8_t _value;
} ImmediateCommand;
extern ImmediateCommand _immediateQueue[_IMMEDIATE_QUEUE_SIZE];
extern volatile uint8_t _immediateQueueHead;
extern volatile uint8_t _immediateQueueTail;
void Immediate_PushCommand(uint8_t _commandID, uint8_t * _payload, uint8_t _value);
uint8_t Immediate_IsEmpty(void);
ImmediateCommand Immediate_PopCommand(void);

//-------------------------------------
// C?c h?m h? th?ng cho BMS
//-------------------------------------
void BMS_Init(void);
void BMS_Update(void);

// H?m g?i l?nh ngay l?p t?c (immediate); n?u TX dang b?n th? l?nh s? du?c dua v?o Immediate queue.
void BMS_SendCommandImmediate(uint8_t _commandID, uint8_t * _payload, uint8_t _value);

// H?m push l?nh v?o TX ring buffer d? g?i sau.
void BMS_PushCommand(uint8_t _commandID, uint8_t * _payload);

#endif