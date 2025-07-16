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
#line 1 "d:/mikroc pro for dspic/include/stdbool.h"



 typedef char _Bool;
#line 31 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
typedef enum
{
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
 SET_SOC = 0x21,
} DALY_BMS_COMMAND;


typedef struct
{

 float maxCellThreshold1;
 float minCellThreshold1;
 float maxCellThreshold2;
 float minCellThreshold2;


 float maxPackThreshold1;
 float minPackThreshold1;
 float maxPackThreshold2;
 float minPackThreshold2;


 float packVoltage;
 float packCurrent;
 float packSOC;


 float maxCellmV;
 int maxCellVNum;
 float minCellmV;
 int minCellVNum;
 int cellDiff;


 int tempAverage;




 const char *chargeDischargeStatus;
  _Bool  chargeFetState;
  _Bool  disChargeFetState;
 int bmsHeartBeat;
 float resCapacityAh;


 unsigned int numberOfCells;
 unsigned int numOfTempSensors;
  _Bool  chargeState;
  _Bool  loadState;
  _Bool  dIO[8];
 int bmsCycles;


 float cellVmV[48];


 int cellTemperature[16];


  _Bool  cellBalanceState[48];
  _Bool  cellBalanceActive;


  _Bool  connectionState;

} DalyBmsData;


typedef struct DalyBms
{
 unsigned long previousTime;
 uint8_t requestCounter;
 int soft_tx;
 int soft_rx;


 char failCodeArr[32];

 DalyBmsData get;




  _Bool  getStaticData;
 unsigned int errorCounter;
 unsigned int requestCount;
 unsigned int commandQueue[5];


 void *serial_handle;

 uint8_t my_txBuffer[ 13 ];
 uint8_t my_rxBuffer[ 13 ];
 uint8_t my_rxFrameBuffer[ 13 *12];
 uint8_t frameBuff[12][ 13 ];
 unsigned int frameCount;


 void (*requestCallback)(void);

} DalyBms;




extern DalyBms bms;
#line 157 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
void DalyBms_Init(DalyBms* bms);


extern void writeLog(const char* format, ...);
#line 167 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_update(DalyBms* bms);
#line 177 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_updateSequential(DalyBms* bms);
#line 184 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
void DalyBms_set_callback(DalyBms* bms, void (*func)(void));
#line 191 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getPackMeasurements(DalyBms* bms);
#line 198 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getVoltageThreshold(DalyBms* bms);
#line 205 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getPackVoltageThreshold(DalyBms* bms);
#line 213 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getPackTemp(DalyBms* bms);
#line 221 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getMinMaxCellVoltage(DalyBms* bms);
#line 228 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getStatusInfo(DalyBms* bms);
#line 235 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getCellVoltages(DalyBms* bms);
#line 242 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getCellTemperature(DalyBms* bms);
#line 249 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getCellBalanceState(DalyBms* bms);
#line 256 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getFailureCodes(DalyBms* bms);
#line 264 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setDischargeMOS(DalyBms* bms,  _Bool  sw);
#line 272 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setChargeMOS(DalyBms* bms,  _Bool  sw);
#line 280 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setSOC(DalyBms* bms, float sw);
#line 287 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getDischargeChargeMosStatus(DalyBms* bms);
#line 295 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_setBmsReset(DalyBms* bms);
#line 308 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/bms.h"
 _Bool  DalyBms_getState(DalyBms* bms);






unsigned long current_millis(void);


static  _Bool  DalyBms_requestData(DalyBms* bms, DALY_BMS_COMMAND cmdID, unsigned int frameAmount);
static  _Bool  DalyBms_sendCommand(DalyBms* bms, DALY_BMS_COMMAND cmdID);
static  _Bool  DalyBms_sendQueueAdd(DalyBms* bms, DALY_BMS_COMMAND cmdID);
static  _Bool  DalyBms_receiveBytes(DalyBms* bms);
static  _Bool  DalyBms_validateChecksum(DalyBms* bms);
static void DalyBms_barfRXBuffer(DalyBms* bms);
static void DalyBms_clearGet(DalyBms* bms);
#line 1 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart1.h"
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 12 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart1.h"
typedef struct {

 uint8_t _rx_frame_stack[ 5 ][ 13 ];
 volatile uint8_t _rx_head;
 volatile uint8_t _rx_tail;


 uint8_t _tx_frame_stack[ 3 ][ 13 ];
 volatile uint8_t _tx_head;
 volatile uint8_t _tx_tail;


 uint8_t _temp_rx_buffer[ 13 ];
 volatile uint8_t _temp_index;
 volatile uint8_t _frame_count;


 uint8_t _multi_frame_buffer[ 12 ][ 13 ];
 volatile uint8_t _multi_frame_count;


 volatile uint8_t _is_receiving;
 volatile uint8_t _timeout_counter;

} _UART1_Object;

extern _UART1_Object _uart1;


void _UART1_Init(void);
#line 46 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart1.h"
void _UART1_SendPush(const uint8_t *frame);


int _UART1_SendBlocking(const uint8_t *frame);
#line 53 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart1.h"
uint8_t _UART1_SendProcess(void);
#line 58 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart1.h"
uint8_t _UART1_Rx_GetFrame(uint8_t *out_frame);


uint8_t _UART1_Rx_GetMultiFrames(uint8_t *out_frames, uint8_t max_frames);
#line 65 "c:/users/asus/desktop/raybot/source/raybot_firmware/[03-07-2025]-op2-(fix-lms)/uart1.h"
void _UART1_Rx_Receive_ISR(void);


uint8_t _UART1_ValidateChecksum(const uint8_t *frame);


uint8_t _UART1_CalculateChecksum(const uint8_t *frame, uint8_t length);


void _UART1_ClearBuffers(void);


uint8_t _UART1_IsConnected(void);
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
#line 1 "d:/mikroc pro for dspic/include/stdio.h"
#line 1 "d:/mikroc pro for dspic/include/stdlib.h"







 typedef struct divstruct {
 int quot;
 int rem;
 } div_t;

 typedef struct ldivstruct {
 long quot;
 long rem;
 } ldiv_t;

 typedef struct uldivstruct {
 unsigned long quot;
 unsigned long rem;
 } uldiv_t;

int abs(int a);
float atof(char * s);
int atoi(char * s);
long atol(char * s);
div_t div(int number, int denom);
ldiv_t ldiv(long number, long denom);
uldiv_t uldiv(unsigned long number, unsigned long denom);
long labs(long x);
int max(int a, int b);
int min(int a, int b);
void srand(unsigned x);
int rand();
int xtoi(char * s);
#line 1 "d:/mikroc pro for dspic/include/math.h"





double fabs(double d);
double floor(double x);
double ceil(double x);
double frexp(double value, int * eptr);
double ldexp(double value, int newexp);
double modf(double val, double * iptr);
double sqrt(double x);
double atan(double f);
double asin(double x);
double acos(double x);
double atan2(double y,double x);
double sin(double f);
double cos(double f);
double tan(double x);
double exp(double x);
double log(double x);
double log10(double x);
double pow(double x, double y);
double sinh(double x);
double cosh(double x);
double tanh(double x);
#line 1 "d:/mikroc pro for dspic/include/ctype.h"





unsigned int islower(char character);
unsigned int isupper(char character);
unsigned int isalpha(char character);
unsigned int iscntrl(char character);
unsigned int isdigit(char character);
unsigned int isalnum(char character);
unsigned int isspace(char character);
unsigned int ispunct(char character);
unsigned int isgraph(char character);
unsigned int isxdigit(char character);
unsigned short tolower(char character);
unsigned short toupper(char character);
#line 1 "d:/mikroc pro for dspic/include/stddef.h"



typedef int ptrdiff_t;
typedef unsigned int size_t;
typedef unsigned int wchar_t;
#line 1 "d:/mikroc pro for dspic/include/stdarg.h"





typedef void * va_list[1];
#line 1 "d:/mikroc pro for dspic/include/stdint.h"
#line 17 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
DalyBms bms;
#line 41 "C:/Users/ASUS/Desktop/RAYBOT/SOURCE/raybot_firmware/[03-07-2025]-OP2-(fix-LMS)/BMS.c"
void DalyBms_Init(DalyBms* bms) {

 bms->previousTime = 0;
 bms->requestCounter = 0;
 bms->soft_tx = 0;
 bms->soft_rx = 0;
 bms->getStaticData =  0 ;
 bms->errorCounter = 0;
 bms->requestCount = 0;
 bms->frameCount = 0;
 bms->requestCallback =  ((void *)0) ;


 memset(bms->failCodeArr, 0, sizeof(bms->failCodeArr));
 memset(bms->my_txBuffer, 0,  13 );
 memset(bms->my_rxBuffer, 0,  13 );
 memset(bms->my_rxFrameBuffer, 0, sizeof(bms->my_rxFrameBuffer));
 memset(bms->frameBuff, 0, sizeof(bms->frameBuff));
 memset(bms->commandQueue, 0x100, sizeof(bms->commandQueue));


 _UART1_Init();


 DalyBms_clearGet(bms);
}

 _Bool  DalyBms_update(DalyBms* bms)
{
 if (current_millis() - bms->previousTime >=  150 )
 {
 switch (bms->requestCounter)
 {
 case 0:
 bms->requestCounter++;
 break;
 case 1:
 if (DalyBms_getPackMeasurements(bms))
 {
 bms->get.connectionState =  1 ;
 bms->errorCounter = 0;
 bms->requestCounter++;
 }
 else
 {
 bms->requestCounter = 0;
 if (bms->errorCounter <  10 )
 {
 bms->errorCounter++;
 }
 else
 {
 bms->get.connectionState =  0 ;
 bms->errorCounter = 0;
 if (bms->requestCallback !=  ((void *)0) ) {
 bms->requestCallback();
 }

 }
 }
 break;
 case 2:
 bms->requestCounter = DalyBms_getMinMaxCellVoltage(bms) ? (bms->requestCounter + 1) : 0;
 break;
 case 3:
 bms->requestCounter = DalyBms_getPackTemp(bms) ? (bms->requestCounter + 1) : 0;
 break;
 case 4:
 bms->requestCounter = DalyBms_getDischargeChargeMosStatus(bms) ? (bms->requestCounter + 1) : 0;
 break;
 case 5:
 bms->requestCounter = DalyBms_getStatusInfo(bms) ? (bms->requestCounter + 1) : 0;
 break;
 case 6:
 bms->requestCounter = DalyBms_getCellVoltages(bms) ? (bms->requestCounter + 1) : 0;
 break;
 case 7:
 bms->requestCounter = DalyBms_getCellTemperature(bms) ? (bms->requestCounter + 1) : 0;
 break;
 case 8:
 bms->requestCounter = DalyBms_getCellBalanceState(bms) ? (bms->requestCounter + 1) : 0;
 break;
 case 9:
 bms->requestCounter = DalyBms_getFailureCodes(bms) ? (bms->requestCounter + 1) : 0;
 if (bms->getStaticData)
 bms->requestCounter = 0;
 if (bms->requestCallback !=  ((void *)0) ) {
 bms->requestCallback();
 }
 break;
 case 10:
 if (!bms->getStaticData)
 bms->requestCounter = DalyBms_getVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
 if (bms->requestCallback !=  ((void *)0) ) {
 bms->requestCallback();
 }
 break;
 case 11:
 if (!bms->getStaticData)
 bms->requestCounter = DalyBms_getPackVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
 bms->requestCounter = 0;
 if (bms->requestCallback !=  ((void *)0) ) {
 bms->requestCallback();
 }
 bms->getStaticData =  1 ;
 break;

 default:
 break;
 }
 bms->previousTime = current_millis();
 }
 return  1 ;
}










 _Bool  DalyBms_updateSequential(DalyBms* bms)
{
 static unsigned int commandIndex = 0;
 static unsigned long lastCommandTime = 0;
 const unsigned long COMMAND_DELAY = 100;


 if (current_millis() - lastCommandTime < COMMAND_DELAY)
 {
 return  1 ;
 }


 DALY_BMS_COMMAND commandSequence[] = {
 VOUT_IOUT_SOC,
 MIN_MAX_CELL_VOLTAGE,
 MIN_MAX_TEMPERATURE,
 DISCHARGE_CHARGE_MOS_STATUS,
 STATUS_INFO,
 CELL_VOLTAGES,
 CELL_TEMPERATURE,
 CELL_BALANCE_STATE,
 FAILURE_CODES,
 CELL_THRESHOLDS,
 PACK_THRESHOLDS
 };

 const unsigned int TOTAL_COMMANDS = sizeof(commandSequence) / sizeof(commandSequence[0]);


 if (commandIndex < TOTAL_COMMANDS)
 {
 DALY_BMS_COMMAND currentCommand = commandSequence[commandIndex];


 if (DalyBms_sendCommand(bms, currentCommand))
 {

 if (DalyBms_receiveBytes(bms))
 {

 switch (currentCommand)
 {
 case VOUT_IOUT_SOC:
 DalyBms_processPackMeasurements(bms);
 break;
 case MIN_MAX_CELL_VOLTAGE:
 DalyBms_processMinMaxCellVoltage(bms);
 break;
 case MIN_MAX_TEMPERATURE:
 DalyBms_processPackTemp(bms);
 break;
 case DISCHARGE_CHARGE_MOS_STATUS:
 DalyBms_processDischargeChargeMosStatus(bms);
 break;
 case STATUS_INFO:
 DalyBms_processStatusInfo(bms);
 break;
 case CELL_VOLTAGES:
 DalyBms_processCellVoltages(bms);
 break;
 case CELL_TEMPERATURE:
 DalyBms_processCellTemperature(bms);
 break;
 case CELL_BALANCE_STATE:
 DalyBms_processCellBalanceState(bms);
 break;
 case FAILURE_CODES:
 DalyBms_processFailureCodes(bms);
 break;
 case CELL_THRESHOLDS:
 DalyBms_processVoltageThreshold(bms);
 break;
 case PACK_THRESHOLDS:
 DalyBms_processPackVoltageThreshold(bms);
 break;
 default:
 break;
 }


 bms->get.connectionState =  1 ;
 bms->errorCounter = 0;
 }
 else
 {

 bms->errorCounter++;
 if (bms->errorCounter >=  10 )
 {
 bms->get.connectionState =  0 ;
 bms->errorCounter = 0;
 }
 }
 }
 else
 {

 bms->errorCounter++;
 }


 commandIndex++;
 }
 else
 {

 commandIndex = 0;


 if (bms->requestCallback !=  ((void *)0) )
 {
 bms->requestCallback();
 }
 }

 lastCommandTime = current_millis();
 return  1 ;
}


static void DalyBms_processPackMeasurements(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == VOUT_IOUT_SOC)
 {

 if (((float)(((bms->my_rxBuffer[8] << 8) | bms->my_rxBuffer[9]) - 30000) / 10.0f) != -3000.f &&
 ((float)((bms->my_rxBuffer[10] << 8) | bms->my_rxBuffer[11]) / 10.0f) <= 100.f)
 {
 bms->get.packVoltage = ((float)((bms->my_rxBuffer[4] << 8) | bms->my_rxBuffer[5]) / 10.0f);
 bms->get.packCurrent = ((float)(((bms->my_rxBuffer[8] << 8) | bms->my_rxBuffer[9]) - 30000) / 10.0f);
 bms->get.packSOC = ((float)((bms->my_rxBuffer[10] << 8) | bms->my_rxBuffer[11]) / 10.0f);
 }
 }
}

static void DalyBms_processMinMaxCellVoltage(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == MIN_MAX_CELL_VOLTAGE)
 {
 bms->get.maxCellmV = (float)((bms->my_rxBuffer[4] << 8) | bms->my_rxBuffer[5]);
 bms->get.maxCellVNum = bms->my_rxBuffer[6];
 bms->get.minCellmV = (float)((bms->my_rxBuffer[7] << 8) | bms->my_rxBuffer[8]);
 bms->get.minCellVNum = bms->my_rxBuffer[9];
 bms->get.cellDiff = (bms->get.maxCellmV - bms->get.minCellmV);
 }
}

static void DalyBms_processPackTemp(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == MIN_MAX_TEMPERATURE)
 {
 bms->get.tempAverage = ((bms->my_rxBuffer[4] - 40) + (bms->my_rxBuffer[6] - 40)) / 2;
 }
}

static void DalyBms_processDischargeChargeMosStatus(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == DISCHARGE_CHARGE_MOS_STATUS)
 {
 char msgbuff[16];
 float tmpAh;

 switch (bms->my_rxBuffer[4])
 {
 case 0:
 bms->get.chargeDischargeStatus = "Stationary";
 break;
 case 1:
 bms->get.chargeDischargeStatus = "Charge";
 break;
 case 2:
 bms->get.chargeDischargeStatus = "Discharge";
 break;
 default:
 bms->get.chargeDischargeStatus = "Unknown";
 break;
 }

 bms->get.chargeFetState =  (((bms->my_rxBuffer[5]) >> (0)) & 1) ;
 bms->get.disChargeFetState =  (((bms->my_rxBuffer[6]) >> (0)) & 1) ;
 bms->get.bmsHeartBeat = bms->my_rxBuffer[7];

 tmpAh = (float)(((uint32_t)bms->my_rxBuffer[8] << 0x18) |
 ((uint32_t)bms->my_rxBuffer[9] << 0x10) |
 ((uint32_t)bms->my_rxBuffer[10] << 0x08) |
 (uint32_t)bms->my_rxBuffer[11]) * 0.001;
 sprintf(msgbuff, "%.1f", tmpAh);
 bms->get.resCapacityAh = atof(msgbuff);
 }
}

static void DalyBms_processStatusInfo(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == STATUS_INFO)
 {
 size_t i;

 bms->get.numberOfCells = bms->my_rxBuffer[4];
 bms->get.numOfTempSensors = bms->my_rxBuffer[5];
 bms->get.chargeState =  (((bms->my_rxBuffer[6]) >> (0)) & 1) ;
 bms->get.loadState =  (((bms->my_rxBuffer[7]) >> (0)) & 1) ;


 for (i = 0; i < 8; i++)
 {
 bms->get.dIO[i] =  (((bms->my_rxBuffer[8]) >> (i)) & 1) ;
 }

 bms->get.bmsCycles = ((uint16_t)bms->my_rxBuffer[9] << 0x08) | (uint16_t)bms->my_rxBuffer[10];
 }
}

static void DalyBms_processCellVoltages(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == CELL_VOLTAGES)
 {
 unsigned int cellNo = 0;
 size_t i;

 if (bms->get.numberOfCells >=  1  && bms->get.numberOfCells <=  48 )
 {
 for (i = 0; i < 3 && cellNo < bms->get.numberOfCells && cellNo <  48 ; i++)
 {
 bms->get.cellVmV[cellNo] = (float)((bms->my_rxBuffer[5 + (i * 2)] << 8) | bms->my_rxBuffer[6 + (i * 2)]);
 cellNo++;
 }
 }
 }
}

static void DalyBms_processCellTemperature(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == CELL_TEMPERATURE)
 {
 unsigned int sensorNo = 0;
 size_t i;

 if (bms->get.numOfTempSensors >=  1  && bms->get.numOfTempSensors <=  16 )
 {
 for (i = 0; i < 7 && sensorNo < bms->get.numOfTempSensors && sensorNo <  16 ; i++)
 {
 bms->get.cellTemperature[sensorNo] = (bms->my_rxBuffer[5 + i] - 40);
 sensorNo++;
 }
 }
 }
}

static void DalyBms_processCellBalanceState(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == CELL_BALANCE_STATE)
 {
 int cellBalance = 0;
 int cellBit = 0;
 size_t i, j;

 if (bms->get.numberOfCells >=  1  && bms->get.numberOfCells <=  48 )
 {
 for (i = 0; i < 6; i++)
 {
 for (j = 0; j < 8; j++)
 {
 if (cellBit <  48 )
 {
 bms->get.cellBalanceState[cellBit] =  (((bms->my_rxBuffer[i + 4]) >> (j)) & 1) ;
 if ( (((bms->my_rxBuffer[i + 4]) >> (j)) & 1) )
 {
 cellBalance++;
 }
 }
 cellBit++;
 if (cellBit >=  48 )
 break;
 }
 if (cellBit >=  48 )
 break;
 }

 bms->get.cellBalanceActive = (cellBalance > 0);
 }
 }
}

static void DalyBms_processFailureCodes(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == FAILURE_CODES)
 {
 size_t len;

 bms->failCodeArr[0] = '\0';


 if ( (((bms->my_rxBuffer[4]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Cell volt high level 2,");
 else if ( (((bms->my_rxBuffer[4]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Cell volt high level 1,");
 if ( (((bms->my_rxBuffer[4]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Cell volt low level 2,");
 else if ( (((bms->my_rxBuffer[4]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Cell volt low level 1,");
 if ( (((bms->my_rxBuffer[4]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Sum volt high level 2,");
 else if ( (((bms->my_rxBuffer[4]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "Sum volt high level 1,");
 if ( (((bms->my_rxBuffer[4]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "Sum volt low level 2,");
 else if ( (((bms->my_rxBuffer[4]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Sum volt low level 1,");

 if ( (((bms->my_rxBuffer[5]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Chg temp high level 2,");
 else if ( (((bms->my_rxBuffer[5]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Chg temp high level 1,");
 if ( (((bms->my_rxBuffer[5]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Chg temp low level 2,");
 else if ( (((bms->my_rxBuffer[5]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Chg temp low level 1,");
 if ( (((bms->my_rxBuffer[5]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp high level 2,");
 else if ( (((bms->my_rxBuffer[5]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp high level 1,");
 if ( (((bms->my_rxBuffer[5]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp low level 2,");
 else if ( (((bms->my_rxBuffer[5]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp low level 1,");

 if ( (((bms->my_rxBuffer[6]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Chg overcurrent level 2,");
 else if ( (((bms->my_rxBuffer[6]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Chg overcurrent level 1,");
 if ( (((bms->my_rxBuffer[6]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Dischg overcurrent level 2,");
 else if ( (((bms->my_rxBuffer[6]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Dischg overcurrent level 1,");
 if ( (((bms->my_rxBuffer[6]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "SOC high level 2,");
 else if ( (((bms->my_rxBuffer[6]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "SOC high level 1,");
 if ( (((bms->my_rxBuffer[6]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "SOC Low level 2,");
 else if ( (((bms->my_rxBuffer[6]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "SOC Low level 1,");

 if ( (((bms->my_rxBuffer[7]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Diff volt level 2,");
 else if ( (((bms->my_rxBuffer[7]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Diff volt level 1,");
 if ( (((bms->my_rxBuffer[7]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Diff temp level 2,");
 else if ( (((bms->my_rxBuffer[7]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Diff temp level 1,");

 if ( (((bms->my_rxBuffer[8]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS temp high alarm,");
 if ( (((bms->my_rxBuffer[8]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Dischg MOS temp high alarm,");
 if ( (((bms->my_rxBuffer[8]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS temp sensor err,");
 if ( (((bms->my_rxBuffer[8]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Dischg MOS temp sensor err,");
 if ( (((bms->my_rxBuffer[8]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS adhesion err,");
 if ( (((bms->my_rxBuffer[8]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Dischg MOS adhesion err,");
 if ( (((bms->my_rxBuffer[8]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS open circuit err,");
 if ( (((bms->my_rxBuffer[8]) >> (7)) & 1) )
 strcat(bms->failCodeArr, " Discrg MOS open circuit err,");

 if ( (((bms->my_rxBuffer[9]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "AFE collect chip err,");
 if ( (((bms->my_rxBuffer[9]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Voltage collect dropped,");
 if ( (((bms->my_rxBuffer[9]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Cell temp sensor err,");
 if ( (((bms->my_rxBuffer[9]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "EEPROM err,");
 if ( (((bms->my_rxBuffer[9]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "RTC err,");
 if ( (((bms->my_rxBuffer[9]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Precharge failure,");
 if ( (((bms->my_rxBuffer[9]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Communication failure,");
 if ( (((bms->my_rxBuffer[9]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "Internal communication failure,");

 if ( (((bms->my_rxBuffer[10]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Current module fault,");
 if ( (((bms->my_rxBuffer[10]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Sum voltage detect fault,");
 if ( (((bms->my_rxBuffer[10]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Short circuit protect fault,");
 if ( (((bms->my_rxBuffer[10]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Low volt forbidden chg fault,");

 len = strlen(bms->failCodeArr);
 if (len > 0 && bms->failCodeArr[len - 1] == ',')
 {
 bms->failCodeArr[len - 1] = '\0';
 }
 }
}

static void DalyBms_processVoltageThreshold(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == CELL_THRESHOLDS)
 {
 bms->get.maxCellThreshold1 = (float)((bms->my_rxBuffer[4] << 8) | bms->my_rxBuffer[5]);
 bms->get.maxCellThreshold2 = (float)((bms->my_rxBuffer[6] << 8) | bms->my_rxBuffer[7]);
 bms->get.minCellThreshold1 = (float)((bms->my_rxBuffer[8] << 8) | bms->my_rxBuffer[9]);
 bms->get.minCellThreshold2 = (float)((bms->my_rxBuffer[10] << 8) | bms->my_rxBuffer[11]);
 }
}

static void DalyBms_processPackVoltageThreshold(DalyBms* bms)
{

 if (bms->my_rxBuffer[2] == PACK_THRESHOLDS)
 {
 bms->get.maxPackThreshold1 = (float)((bms->my_rxBuffer[4] << 8) | bms->my_rxBuffer[5]);
 bms->get.maxPackThreshold2 = (float)((bms->my_rxBuffer[6] << 8) | bms->my_rxBuffer[7]);
 bms->get.minPackThreshold1 = (float)((bms->my_rxBuffer[8] << 8) | bms->my_rxBuffer[9]);
 bms->get.minPackThreshold2 = (float)((bms->my_rxBuffer[10] << 8) | bms->my_rxBuffer[11]);
 }
}

 _Bool  DalyBms_getVoltageThreshold(DalyBms* bms)
{
 if (!DalyBms_requestData(bms, CELL_THRESHOLDS, 1))
 {
 return  0 ;
 }

 bms->get.maxCellThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
 bms->get.maxCellThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
 bms->get.minCellThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
 bms->get.minCellThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);

 return  1 ;
}

 _Bool  DalyBms_getPackVoltageThreshold(DalyBms* bms)
{
 if (!DalyBms_requestData(bms, PACK_THRESHOLDS, 1))
 {
 return  0 ;
 }

 bms->get.maxPackThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
 bms->get.maxPackThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
 bms->get.minPackThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
 bms->get.minPackThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);

 return  1 ;
}

 _Bool  DalyBms_getPackMeasurements(DalyBms* bms)
{
 if (!DalyBms_requestData(bms, VOUT_IOUT_SOC, 1))
 {
 DalyBms_clearGet(bms);
 return  0 ;
 }
 else
 {

 if (((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f) == -3000.f)
 {
 return  0 ;
 }
 else

 if (((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f) > 100.f)
 {
 return  0 ;
 }
 }

 bms->get.packVoltage = ((float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]) / 10.0f);
 bms->get.packCurrent = ((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f);
 bms->get.packSOC = ((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f);
 return  1 ;
}

 _Bool  DalyBms_getMinMaxCellVoltage(DalyBms* bms)
{
 if (!DalyBms_requestData(bms, MIN_MAX_CELL_VOLTAGE, 1))
 {
 return  0 ;
 }

 bms->get.maxCellmV = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
 bms->get.maxCellVNum = bms->frameBuff[0][6];
 bms->get.minCellmV = (float)((bms->frameBuff[0][7] << 8) | bms->frameBuff[0][8]);
 bms->get.minCellVNum = bms->frameBuff[0][9];
 bms->get.cellDiff = (bms->get.maxCellmV - bms->get.minCellmV);

 return  1 ;
}

 _Bool  DalyBms_getPackTemp(DalyBms* bms)
{
 if (!DalyBms_requestData(bms, MIN_MAX_TEMPERATURE, 1))
 {
 return  0 ;
 }
 bms->get.tempAverage = ((bms->frameBuff[0][4] - 40) + (bms->frameBuff[0][6] - 40)) / 2;

 return  1 ;
}

 _Bool  DalyBms_getDischargeChargeMosStatus(DalyBms* bms)
{
 char msgbuff[16];
 float tmpAh;

 if (!DalyBms_requestData(bms, DISCHARGE_CHARGE_MOS_STATUS, 1))
 {
 return  0 ;
 }

 switch (bms->frameBuff[0][4])
 {
 case 0:
 bms->get.chargeDischargeStatus = "Stationary";
 break;
 case 1:
 bms->get.chargeDischargeStatus = "Charge";
 break;
 case 2:
 bms->get.chargeDischargeStatus = "Discharge";
 break;
 default:
 bms->get.chargeDischargeStatus = "Unknown";
 break;
 }

 bms->get.chargeFetState =  (((bms->frameBuff[0][5]) >> (0)) & 1) ;
 bms->get.disChargeFetState =  (((bms->frameBuff[0][6]) >> (0)) & 1) ;
 bms->get.bmsHeartBeat = bms->frameBuff[0][7];
 tmpAh = (float)(((uint32_t)bms->frameBuff[0][8] << 0x18) | ((uint32_t)bms->frameBuff[0][9] << 0x10) | ((uint32_t)bms->frameBuff[0][10] << 0x08) | (uint32_t)bms->frameBuff[0][11]) * 0.001;
 sprintf(msgbuff, "%.1f", tmpAh);
 bms->get.resCapacityAh = atof(msgbuff);

 return  1 ;
}

 _Bool  DalyBms_getStatusInfo(DalyBms* bms)
{
 size_t i;

 if (!DalyBms_requestData(bms, STATUS_INFO, 1))
 {
 return  0 ;
 }

 bms->get.numberOfCells = bms->frameBuff[0][4];
 bms->get.numOfTempSensors = bms->frameBuff[0][5];
 bms->get.chargeState =  (((bms->frameBuff[0][6]) >> (0)) & 1) ;
 bms->get.loadState =  (((bms->frameBuff[0][7]) >> (0)) & 1) ;


 for (i = 0; i < 8; i++)
 {
 bms->get.dIO[i] =  (((bms->frameBuff[0][8]) >> (i)) & 1) ;
 }

 bms->get.bmsCycles = ((uint16_t)bms->frameBuff[0][9] << 0x08) | (uint16_t)bms->frameBuff[0][10];

 return  1 ;
}

 _Bool  DalyBms_getCellVoltages(DalyBms* bms)
{
 unsigned int cellNo;
 size_t k;
 size_t i;


 cellNo = 0;


 if (bms->get.numberOfCells <  1  || bms->get.numberOfCells >  48 )
 {
 return  0 ;
 }

 if (DalyBms_requestData(bms, CELL_VOLTAGES, (unsigned int)ceil(bms->get.numberOfCells / 3.0)))
 {
 for (k = 0; k < (unsigned int)ceil(bms->get.numberOfCells / 3.0); k++)
 {
 for (i = 0; i < 3; i++)
 {
 if (cellNo <  48 ) {
 bms->get.cellVmV[cellNo] = (float)((bms->frameBuff[k][5 + (i * 2)] << 8) | bms->frameBuff[k][6 + (i * 2)]);
 }
 cellNo++;
 if (cellNo >= bms->get.numberOfCells)
 break;
 }
 }
 return  1 ;
 }
 else
 {
 return  0 ;
 }
}

 _Bool  DalyBms_getCellTemperature(DalyBms* bms)
{
 unsigned int sensorNo;
 size_t k;
 size_t i;


 sensorNo = 0;


 if ((bms->get.numOfTempSensors <  1 ) || (bms->get.numOfTempSensors >  16 ))
 {
 return  0 ;
 }

 if (DalyBms_requestData(bms, CELL_TEMPERATURE, (unsigned int)ceil(bms->get.numOfTempSensors / 7.0)))
 {
 for (k = 0; k < (unsigned int)ceil(bms->get.numOfTempSensors / 7.0); k++)
 {
 for (i = 0; i < 7; i++)
 {
 if (sensorNo <  16 ) {
 bms->get.cellTemperature[sensorNo] = (bms->frameBuff[k][5 + i] - 40);
 }
 sensorNo++;
 if (sensorNo >= bms->get.numOfTempSensors)
 break;
 }
 }
 return  1 ;
 }
 else
 {
 return  0 ;
 }
}

 _Bool  DalyBms_getCellBalanceState(DalyBms* bms)
{
 int cellBalance;
 int cellBit;
 size_t i;
 size_t j;

 cellBalance = 0;
 cellBit = 0;


 if (bms->get.numberOfCells <  1  || bms->get.numberOfCells >  48 )
 {
 return  0 ;
 }

 if (!DalyBms_requestData(bms, CELL_BALANCE_STATE, 1))
 {
 return  0 ;
 }


 for (i = 0; i < 6; i++)
 {

 for (j = 0; j < 8; j++)
 {
 if (cellBit <  48 ) {
 bms->get.cellBalanceState[cellBit] =  (((bms->frameBuff[0][i + 4]) >> (j)) & 1) ;
 }
 if ( (((bms->frameBuff[0][i + 4]) >> (j)) & 1) )
 {
 cellBalance++;
 }
 cellBit++;
 if (cellBit >=  48 )
 {
 break;
 }
 }
 if (cellBit >=  48 ) {
 break;
 }
 }

 if (cellBalance > 0)
 {
 bms->get.cellBalanceActive =  1 ;
 }
 else
 {
 bms->get.cellBalanceActive =  0 ;
 }

 return  1 ;
}

 _Bool  DalyBms_getFailureCodes(DalyBms* bms)
{
 size_t len;

 if (!DalyBms_requestData(bms, FAILURE_CODES, 1))
 {
 return  0 ;
 }

 bms->failCodeArr[0] = '\0';


 if ( (((bms->frameBuff[0][4]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Cell volt high level 2,");
 else if ( (((bms->frameBuff[0][4]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Cell volt high level 1,");
 if ( (((bms->frameBuff[0][4]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Cell volt low level 2,");
 else if ( (((bms->frameBuff[0][4]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Cell volt low level 1,");
 if ( (((bms->frameBuff[0][4]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Sum volt high level 2,");
 else if ( (((bms->frameBuff[0][4]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "Sum volt high level 1,");
 if ( (((bms->frameBuff[0][4]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "Sum volt low level 2,");
 else if ( (((bms->frameBuff[0][4]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Sum volt low level 1,");

 if ( (((bms->frameBuff[0][5]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Chg temp high level 2,");
 else if ( (((bms->frameBuff[0][5]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Chg temp high level 1,");
 if ( (((bms->frameBuff[0][5]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Chg temp low level 2,");
 else if ( (((bms->frameBuff[0][5]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Chg temp low level 1,");
 if ( (((bms->frameBuff[0][5]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp high level 2,");
 else if ( (((bms->frameBuff[0][5]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp high level 1,");
 if ( (((bms->frameBuff[0][5]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp low level 2,");
 else if ( (((bms->frameBuff[0][5]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Dischg temp low level 1,");

 if ( (((bms->frameBuff[0][6]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Chg overcurrent level 2,");
 else if ( (((bms->frameBuff[0][6]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Chg overcurrent level 1,");
 if ( (((bms->frameBuff[0][6]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Dischg overcurrent level 2,");
 else if ( (((bms->frameBuff[0][6]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Dischg overcurrent level 1,");
 if ( (((bms->frameBuff[0][6]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "SOC high level 2,");
 else if ( (((bms->frameBuff[0][6]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "SOC high level 1,");
 if ( (((bms->frameBuff[0][6]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "SOC Low level 2,");
 else if ( (((bms->frameBuff[0][6]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "SOC Low level 1,");

 if ( (((bms->frameBuff[0][7]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Diff volt level 2,");
 else if ( (((bms->frameBuff[0][7]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Diff volt level 1,");
 if ( (((bms->frameBuff[0][7]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Diff temp level 2,");
 else if ( (((bms->frameBuff[0][7]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Diff temp level 1,");

 if ( (((bms->frameBuff[0][8]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS temp high alarm,");
 if ( (((bms->frameBuff[0][8]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Dischg MOS temp high alarm,");
 if ( (((bms->frameBuff[0][8]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS temp sensor err,");
 if ( (((bms->frameBuff[0][8]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Dischg MOS temp sensor err,");
 if ( (((bms->frameBuff[0][8]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS adhesion err,");
 if ( (((bms->frameBuff[0][8]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Dischg MOS adhesion err,");
 if ( (((bms->frameBuff[0][8]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Chg MOS open circuit err,");
 if ( (((bms->frameBuff[0][8]) >> (7)) & 1) )
 strcat(bms->failCodeArr, " Discrg MOS open circuit err,");

 if ( (((bms->frameBuff[0][9]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "AFE collect chip err,");
 if ( (((bms->frameBuff[0][9]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Voltage collect dropped,");
 if ( (((bms->frameBuff[0][9]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Cell temp sensor err,");
 if ( (((bms->frameBuff[0][9]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "EEPROM err,");
 if ( (((bms->frameBuff[0][9]) >> (4)) & 1) )
 strcat(bms->failCodeArr, "RTC err,");
 if ( (((bms->frameBuff[0][9]) >> (5)) & 1) )
 strcat(bms->failCodeArr, "Precharge failure,");
 if ( (((bms->frameBuff[0][9]) >> (6)) & 1) )
 strcat(bms->failCodeArr, "Communication failure,");
 if ( (((bms->frameBuff[0][9]) >> (7)) & 1) )
 strcat(bms->failCodeArr, "Internal communication failure,");

 if ( (((bms->frameBuff[0][10]) >> (0)) & 1) )
 strcat(bms->failCodeArr, "Current module fault,");
 if ( (((bms->frameBuff[0][10]) >> (1)) & 1) )
 strcat(bms->failCodeArr, "Sum voltage detect fault,");
 if ( (((bms->frameBuff[0][10]) >> (2)) & 1) )
 strcat(bms->failCodeArr, "Short circuit protect fault,");
 if ( (((bms->frameBuff[0][10]) >> (3)) & 1) )
 strcat(bms->failCodeArr, "Low volt forbidden chg fault,");

 len = strlen(bms->failCodeArr);
 if (len > 0 && bms->failCodeArr[len - 1] == ',')
 {
 bms->failCodeArr[len - 1] = '\0';
 }
 return  1 ;
}

 _Bool  DalyBms_setDischargeMOS(DalyBms* bms,  _Bool  sw)
{
 bms->requestCounter = 0;
 if (sw)
 {

 bms->my_txBuffer[4] = 0x01;
 }
 else
 {
 bms->my_txBuffer[4] = 0x00;
 }

 DalyBms_sendCommand(bms, DISCHRG_FET);

 if (!DalyBms_receiveBytes(bms))
 {
 return  0 ;
 }

 return  1 ;
}

 _Bool  DalyBms_setChargeMOS(DalyBms* bms,  _Bool  sw)
{
 bms->requestCounter = 0;
 if (sw)
 {

 bms->my_txBuffer[4] = 0x01;
 }
 else
 {
 bms->my_txBuffer[4] = 0x00;
 }
 DalyBms_sendCommand(bms, CHRG_FET);

 if (!DalyBms_receiveBytes(bms))
 {
 return  0 ;
 }

 return  1 ;
}

 _Bool  DalyBms_setBmsReset(DalyBms* bms)
{
 bms->requestCounter = 0;
 DalyBms_sendCommand(bms, BMS_RESET);
 if (!DalyBms_receiveBytes(bms))
 {
 return  0 ;
 }
 return  1 ;
}

 _Bool  DalyBms_setSOC(DalyBms* bms, float val)
{
 uint16_t value;
 size_t i;

 if (val >= 0.0f && val <= 100.0f)
 {
 bms->requestCounter = 0;


 DalyBms_sendCommand(bms, READ_SOC);
 if (!DalyBms_receiveBytes(bms))
 {
 bms->my_txBuffer[5] = 0x17;
 bms->my_txBuffer[6] = 0x01;
 bms->my_txBuffer[7] = 0x01;
 bms->my_txBuffer[8] = 0x01;
 bms->my_txBuffer[9] = 0x01;
 }
 else
 {
 for (i = 5; i <= 9; i++)
 {
 bms->my_txBuffer[i] = bms->my_rxBuffer[i];
 }
 }
 value = (uint16_t)(val * 10.0f);
 bms->my_txBuffer[10] = (value >> 8) & 0xFF;
 bms->my_txBuffer[11] = value & 0xFF;
 DalyBms_sendCommand(bms, SET_SOC);

 if (!DalyBms_receiveBytes(bms))
 {
 return  0 ;
 }
 else
 {
 return  1 ;
 }
 }
 return  0 ;
}

 _Bool  DalyBms_getState(DalyBms* bms)
{
 return bms->get.connectionState;
}

void DalyBms_set_callback(DalyBms* bms, void (*func)(void))
{
 bms->requestCallback = func;
}






static  _Bool  DalyBms_requestData(DalyBms* bms, DALY_BMS_COMMAND cmdID, unsigned int frameAmount)
{
 uint8_t txChecksum;
 unsigned int byteCounter;
 size_t i;
 size_t j;
 uint8_t rxChecksum;
 int k;
 uint8_t frame_count;
 uint8_t received_frames;


 memset(bms->my_rxFrameBuffer, 0x00, sizeof(bms->my_rxFrameBuffer));
 memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff));
 memset(bms->my_txBuffer, 0x00,  13 );


 txChecksum = 0x00;
 byteCounter = 0;


 bms->my_txBuffer[0] =  0xA5 ;
 bms->my_txBuffer[1] =  0x40 ;
 bms->my_txBuffer[2] = cmdID;
 bms->my_txBuffer[3] =  0x08 ;


 for (i = 0; i <= 11; i++)
 {
 txChecksum += bms->my_txBuffer[i];
 }

 bms->my_txBuffer[12] = txChecksum;


 _UART1_SendPush(bms->my_txBuffer);

 _UART1_SendProcess();






 frame_count = 0;
 received_frames = 0;


 while (frame_count < frameAmount && received_frames < 10) {
 if (_UART1_Rx_GetFrame(bms->frameBuff[frame_count])) {
 frame_count++;
 }
 received_frames++;

 Delay_ms(1);
 }


 for (i = 0; i < frame_count; i++)
 {
 rxChecksum = 0x00;
 for (k = 0; k <  13  - 1; k++)
 {
 rxChecksum += bms->frameBuff[i][k];
 }



 if (rxChecksum != bms->frameBuff[i][ 13  - 1])
 {
 return  0 ;
 }
 if (rxChecksum == 0)
 {
 return  0 ;
 }
 if (bms->frameBuff[i][1] >= 0x20)
 {
 return  0 ;
 }
 }
 return  1 ;
}

static  _Bool  DalyBms_sendQueueAdd(DalyBms* bms, DALY_BMS_COMMAND cmdID)
{
 size_t i;

 for (i = 0; i < sizeof(bms->commandQueue) / sizeof(bms->commandQueue[0]); i++)
 {
 if (bms->commandQueue[i] == 0x100)
 {
 bms->commandQueue[i] = cmdID;
 break;
 }
 }
 return  1 ;
}

static  _Bool  DalyBms_sendCommand(DalyBms* bms, DALY_BMS_COMMAND cmdID)
{
 uint8_t checksum;
 uint8_t i;

 checksum = 0;

 _UART1_ClearBuffers();


 bms->my_txBuffer[0] =  0xA5 ;
 bms->my_txBuffer[1] =  0x40 ;
 bms->my_txBuffer[2] = cmdID;
 bms->my_txBuffer[3] =  0x08 ;


 for (i = 0; i <= 11; i++)
 {
 checksum += bms->my_txBuffer[i];
 }

 bms->my_txBuffer[12] = checksum;

 _UART1_SendPush(bms->my_txBuffer);

 _UART1_SendProcess();


 memset(bms->my_txBuffer, 0x00,  13 );
 bms->requestCounter = 0;
 return  1 ;
}

static  _Bool  DalyBms_receiveBytes(DalyBms* bms)
{
 uint8_t frame[ 13 ];


 memset(bms->my_rxBuffer, 0x00,  13 );
 memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff));


 if (!_UART1_Rx_GetFrame(frame))
 {
 DalyBms_barfRXBuffer(bms);
 return  0 ;
 }


 memcpy(bms->my_rxBuffer, frame,  13 );

 if (!DalyBms_validateChecksum(bms))
 {
 DalyBms_barfRXBuffer(bms);
 return  0 ;
 }

 return  1 ;
}

static  _Bool  DalyBms_validateChecksum(DalyBms* bms)
{
 uint8_t checksum;
 int i;

 checksum = 0x00;

 for (i = 0; i <  13  - 1; i++)
 {
 checksum += bms->my_rxBuffer[i];
 }

 return (checksum == bms->my_rxBuffer[ 13  - 1]);
}

static void DalyBms_barfRXBuffer(DalyBms* bms)
{
 int i;


 for (i = 0; i <  13 ; i++)
 {
 writeLog(",0x%02X", bms->my_rxBuffer[i]);
 }
 writeLog("]\n");
}

static void DalyBms_clearGet(DalyBms* bms)
{
 bms->get.chargeDischargeStatus = "offline";


}







unsigned long current_millis(void) {



 return 0;
}


void writeLog(const char* format, ...) {



 (void)format;
}
