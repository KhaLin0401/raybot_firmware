#line 1 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"




typedef signed char int8_t;
typedef signed int int16_t;
typedef signed long int int32_t;


typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long int uint32_t;


typedef signed char int_least8_t;
typedef signed int int_least16_t;
typedef signed long int int_least32_t;


typedef unsigned char uint_least8_t;
typedef unsigned int uint_least16_t;
typedef unsigned long int uint_least32_t;



typedef signed int int_fast8_t;
typedef signed int int_fast16_t;
typedef signed long int int_fast32_t;


typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned long int uint_fast32_t;


typedef signed int intptr_t;
typedef unsigned int uintptr_t;


typedef signed long int intmax_t;
typedef unsigned long int uintmax_t;
#line 1 "d:/mikroc pro for dspic/include/string.h"





void * memchr(void *p, char n, unsigned int v);
int memcmp(void *s1, void *s2, int n);
void * memcpy(void * d1, void * s1, int n);
void * memmove(void * to, void * from, int n);
void * memset(void * p1, char character, int n);
char * strcat(char * to, char * from);
char * strchr(char * ptr, char chr);
int strcmp(char * s1, char * s2);
char * strcpy(char * to, char * from);
int strlen(char * s);
char * strncat(char * to, char * from, int size);
char * strncpy(char * to, char * from, int size);
int strspn(char * str1, char * str2);
char strcspn(char * s1, char * s2);
int strncmp(char * s1, char * s2, char len);
char * strpbrk(char * s1, char * s2);
char * strrchr(char *ptr, char chr);
char * strstr(char * s1, char * s2);
char * strtok(char * s1, char * s2);
#line 114 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
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


typedef struct {
 float _sumVoltage;
 float _sumCurrent;
 float _sumSOC;
 float _maxCellVoltage;
 float _minCellVoltage;
 float _cellVoltages[ 16 ];
 float _temperature;
 int _cycleCount;
 uint8_t _protectionFlags;
 float _remainingCapacity;
 float _totalCapacity;
 float _highVoltageProtection;
 float _lowVoltageProtection;
 int _ntcCount;
 float _ntcTemperatures[ 16 ];
 uint8_t _balanceStatus[ 16 ];
 uint8_t _chargeMOS;
 uint8_t _dischargeMOS;
 int _cellCount;
 uint8_t _errorCode;
 int _errorCount;
 uint8_t _hardwareVersion;
 uint8_t _softwareVersion;
 char _manufacturer[20];
 uint8_t _charge_current_limit;
 uint8_t _discharge_current_limit;
 char _chargeDischargeStatus[20];
 uint8_t _chargeState;
 uint8_t _loadState;
} BMSData;


typedef struct {
 uint8_t _commandID;
 uint8_t _payload[8];
} TXCommand;


extern BMSData _bmsData;
extern TXCommand _txBuffer[ 10 ];
extern uint8_t _rxFrameBuffer[ 10 ][ 13 ];


void BMS_Init(void);
void BMS_ClearData(void);
uint8_t BMS_SendCommand(BMS_Command cmdID, uint8_t *payload);
uint8_t BMS_ReceiveData(uint8_t expectedFrames);
uint8_t BMS_ValidateChecksum(uint8_t frameIndex);
void BMS_ProcessData(BMS_Command cmdID, uint8_t frameIndex);
uint8_t BMS_Update(void);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/schedule_task.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 12 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/schedule_task.h"
extern uint8_t _task_uart;
extern uint8_t _task_update_system;
extern uint8_t _task_update_motor;
extern uint8_t _task_update_to_server;
extern uint8_t _task_respond_Init;
extern uint8_t _task_update_BMS;


void _F_schedule_init(void);
void _F_process_uart_command(void);
void _F_update_system_status(void);
void _F_update_to_server(void);
void _F_respond_to_server(void);
void Respond_Init();
unsigned long GetMillis(void);
#line 413 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
BMSData _bmsData;
TXCommand _txBuffer[ 10 ];
uint8_t _rxFrameBuffer[ 10 ][ 13 ];


static volatile uint8_t _currentFrameIndex = 0;
static volatile uint8_t _currentByteIndex = 0;
static volatile uint8_t _frameStarted = 0;
static volatile uint8_t _framesReceived = 0;


static volatile unsigned long _millis = 0;


typedef enum {
 BMS_STATE_IDLE,
 BMS_STATE_SEND_COMMAND,
 BMS_STATE_WAIT_RESPONSE,
 BMS_STATE_PROCESS_DATA,
 BMS_STATE_ERROR
} BMS_State;

static BMS_State _bmsState = BMS_STATE_IDLE;
static unsigned long _startTime = 0;
static uint8_t _currentCommandIndex = 0;
static uint8_t _expectedFrames = 1;
static uint8_t _errorCounter = 0;


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



void BMS_Init(void) {


 IEC0bits.U1RXIE = 1;
 IFS0bits.U1RXIF = 0;


 memset(_txBuffer, 0, sizeof(_txBuffer));
 memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));


 _currentFrameIndex = 0;
 _currentByteIndex = 0;
 _frameStarted = 0;
 _framesReceived = 0;


 _bmsState = BMS_STATE_IDLE;
 _currentCommandIndex = 0;
 _expectedFrames = 1;
 _errorCounter = 0;
 _startTime = 0;


 BMS_ClearData();
}

void BMS_ClearData(void) {
 memset(&_bmsData, 0, sizeof(BMSData));
 strcpy(_bmsData._manufacturer, "DALY");
 strcpy(_bmsData._chargeDischargeStatus, "offline");
 _bmsData._errorCount = 0;
 _bmsData._chargeState = 0;
 _bmsData._loadState = 0;
}

uint8_t BMS_SendCommand(BMS_Command cmdID, uint8_t *payload) {
 uint8_t packet[ 13 ];
 uint8_t checksum;
 uint8_t i;


 while (UART1_Data_Ready()) {
 UART1_Read();
 }


 _currentFrameIndex = 0;
 _currentByteIndex = 0;
 _frameStarted = 0;
 _framesReceived = 0;
 memset(_rxFrameBuffer, 0, sizeof(_rxFrameBuffer));


 packet[0] = START_BYTE;
 packet[1] = HOST_ADDRESS;
 packet[2] = cmdID;
 packet[3] = 0x08;


 if (payload != ((void *)0)) {
 for (i = 0; i < 8; i++) {
 packet[4 + i] = payload[i];
 }
 } else {
 for (i = 0; i < 8; i++) {
 packet[4 + i] = 0x00;
 }
 }


 checksum = 0;
 for (i = 0; i < 12; i++) {
 checksum += packet[i];
 }
 packet[12] = checksum;


 for (i = 0; i <  13 ; i++) {
 UART1_Write(packet[i]);
 }

 return 1;
}

uint8_t BMS_ValidateChecksum(uint8_t frameIndex) {
 uint8_t checksum;
 uint8_t i;

 if (frameIndex >=  10 ) {
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
 for (i = 0; i <  13  - 1; i++) {
 checksum += _rxFrameBuffer[frameIndex][i];
 }

 if (checksum != _rxFrameBuffer[frameIndex][ 13  - 1]) {
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

 if (frameIndex >=  10 ) {
 _bmsData._errorCount++;
 _bmsData._errorCode = 4;
 return;
 }

 switch (cmdID) {
 case VOUT_IOUT_SOC:
 tempValue = (_rxFrameBuffer[frameIndex][4] << 8) | _rxFrameBuffer[frameIndex][5];
 _bmsData._sumVoltage = (float)tempValue * 100.0;

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
 if (cellIndex < _bmsData._cellCount && cellIndex <  16 ) {
 tempValue = (_rxFrameBuffer[frameIndex][5 + i * 2] << 8) | _rxFrameBuffer[frameIndex][6 + i * 2];
 _bmsData._cellVoltages[cellIndex] = (float)tempValue ;
 }
 }
 break;

 case CELL_TEMPERATURE:
 for (i = 0; i < 7; i++) {
 uint8_t sensorIndex;
 sensorIndex = frameIndex * 7 + i;
 if (sensorIndex < _bmsData._ntcCount && sensorIndex <  16 ) {
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
 if (cellIndex + j < _bmsData._cellCount && cellIndex + j <  16 ) {
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
 uint8_t payload[8];
 uint8_t i;
 uint8_t success;


 if (_bmsData._errorCount > 200)
 _bmsData._errorCount = 1;
 success = 0;
 for (i = 0; i < 8; i++) {
 payload[i] = 0;
 }

 switch (_bmsState) {
 case BMS_STATE_IDLE:

 switch (commands[_currentCommandIndex]) {
 case CELL_VOLTAGES:
 _expectedFrames = (_bmsData._cellCount + 2) / 3;
 break;
 case CELL_TEMPERATURE:
 _expectedFrames = (_bmsData._ntcCount + 6) / 7;
 break;
 case CELL_BALANCE_STATE:
 _expectedFrames = (_bmsData._cellCount + 47) / 48;
 break;
 default:
 _expectedFrames = 1;
 break;
 }
 _bmsState = BMS_STATE_SEND_COMMAND;
 return 0;

 case BMS_STATE_SEND_COMMAND:

 if (BMS_SendCommand(commands[_currentCommandIndex], payload)) {
 _startTime = GetMillis();
 _bmsState = BMS_STATE_WAIT_RESPONSE;
 } else {
 _bmsState = BMS_STATE_ERROR;
 }
 return 0;

 case BMS_STATE_WAIT_RESPONSE:

 if (GetMillis() - _startTime >= 150) {
 _bmsData._errorCount++;
 _bmsData._errorCode = 6;
 _bmsState = BMS_STATE_ERROR;
 } else if (_framesReceived >= _expectedFrames) {
 _bmsState = BMS_STATE_PROCESS_DATA;
 }
 return 0;

 case BMS_STATE_PROCESS_DATA:

 if (_framesReceived > 0) {
 success = 1;
 for (i = 0; i < _framesReceived; i++) {
 if (BMS_ValidateChecksum(i)) {
 BMS_ProcessData(commands[_currentCommandIndex], i);
 } else {
 success = 0;
 break;
 }
 }
 } else {
 success = 0;
 }


 _currentFrameIndex = 0;
 _currentByteIndex = 0;
 _frameStarted = 0;
 _framesReceived = 0;


 if (!success) {
 _errorCounter++;
 if (_errorCounter >= 10) {
 BMS_ClearData();
 _currentCommandIndex = 0;
 _errorCounter = 0;
 strcpy(_bmsData._chargeDischargeStatus, "offline");
 _bmsState = BMS_STATE_IDLE;
 return 0;
 }
 } else {
 _errorCounter = 0;
 strcpy(_bmsData._chargeDischargeStatus, "online");
 }


 _currentCommandIndex = (_currentCommandIndex + 1) % commandCount;
 _bmsState = BMS_STATE_IDLE;
 return success;

 case BMS_STATE_ERROR:
 _errorCounter++;
 if (_errorCounter >= 10) {
 BMS_ClearData();
 _currentCommandIndex = 0;
 _errorCounter = 0;
 strcpy(_bmsData._chargeDischargeStatus, "offline");
 }
 _bmsState = BMS_STATE_IDLE;
 return 0;
 }

 return 0;
}

void _UART1_Interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
 uint8_t byte;

 while (UART1_Data_Ready()) {
 byte = UART1_Read();

 if (!_frameStarted && byte == START_BYTE) {
 _frameStarted = 1;
 _currentByteIndex = 0;
 if (_currentFrameIndex <  10 ) {
 _rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
 _currentByteIndex++;
 }
 } else if (_frameStarted) {
 if (_currentFrameIndex <  10  && _currentByteIndex <  13 ) {
 _rxFrameBuffer[_currentFrameIndex][_currentByteIndex] = byte;
 _currentByteIndex++;

 if (_currentByteIndex >=  13 ) {
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
