/*
DALY2MQTT Project
https://github.com/softwarecrash/DALY2MQTT
*/
#include "BMS.h" // Assuming daly.h is the converted header file you provided earlier
#include "uart1.h" // Include UART1 module for BMS communication
#include <string.h> // For memset, strcat, strlen
#include <stdio.h>  // For sprintf (if needed for logging)
#include <stdlib.h> // For atof
#include <math.h>   // For ceil
#include <ctype.h>
#include <stddef.h>
#include <stdarg.h>
#include <stdint.h>

// Global BMS instance
DalyBms bms;

// MODIFICATION LOG
// Date: [2025-01-03 HH:MM]
// Changed by: AI Agent
// Description: Modified BMS module to use UART1 instead of mock serial functions
// Reason: Integration with hardware UART1 for Daly BMS communication
// Impact: BMS communication now uses dedicated UART1 module with proper ISR handling
// Testing: Test BMS communication with actual Daly BMS hardware

// Mock implementation for bitRead if not available on your platform
#define BIT_READ(value, bit) (((value) >> (bit)) & 1)

// Dummy SoftwareSerial equivalent for demonstration. In a real C project,
// you'd typically manage UART directly or use a C-compatible software serial library.
// For this example, the `serial_handle` in DalyBms will be a placeholder.
// If you are compiling for Arduino with a C compiler, you might need to
// bridge `SoftwareSerial` methods to C functions.

//----------------------------------------------------------------------
// Public Functions
//----------------------------------------------------------------------

// Constructor equivalent for C
void DalyBms_Init(DalyBms* bms) {
    // Initialize BMS structure
    bms->previousTime = 0;
    bms->requestCounter = 0;
    bms->soft_tx = 0;
    bms->soft_rx = 0;
    bms->getStaticData = false;
    bms->errorCounter = 0;
    bms->requestCount = 0;
    bms->frameCount = 0;
    bms->requestCallback = NULL;
    
    // Clear buffers
    memset(bms->failCodeArr, 0, sizeof(bms->failCodeArr));
    memset(bms->my_txBuffer, 0, XFER_BUFFER_LENGTH);
    memset(bms->my_rxBuffer, 0, XFER_BUFFER_LENGTH);
    memset(bms->my_rxFrameBuffer, 0, sizeof(bms->my_rxFrameBuffer));
    memset(bms->frameBuff, 0, sizeof(bms->frameBuff));
    memset(bms->commandQueue, 0x100, sizeof(bms->commandQueue));
    
    // Initialize UART1 for BMS communication
    _UART1_Init();
    
    // Initialize BMS data structure
    DalyBms_clearGet(bms);
}

bool DalyBms_update(DalyBms* bms)
{
    if (current_millis() - bms->previousTime >= DELAYTINME)
    {
        switch (bms->requestCounter)
        {
        case 0:
            bms->requestCounter++;
            break;
        case 1:
            if (DalyBms_getPackMeasurements(bms))
            {
                bms->get.connectionState = true;
                bms->errorCounter = 0;
                bms->requestCounter++;
            }
            else
            {
                bms->requestCounter = 0;
                if (bms->errorCounter < ERRORCOUNTER)
                {
                    bms->errorCounter++;
                }
                else
                {
                    bms->get.connectionState = false;
                    bms->errorCounter = 0;
                    if (bms->requestCallback != NULL) {
                        bms->requestCallback(); // Call the callback function
                    }
                    // DalyBms_clearGet(bms); // Uncomment if clearGet is desired on connection loss
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
            if (bms->requestCallback != NULL) {
                bms->requestCallback();
            }
            break;
        case 10:
            if (!bms->getStaticData)
                bms->requestCounter = DalyBms_getVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
            if (bms->requestCallback != NULL) {
                bms->requestCallback();
            }
            break;
        case 11:
            if (!bms->getStaticData)
                bms->requestCounter = DalyBms_getPackVoltageThreshold(bms) ? (bms->requestCounter + 1) : 0;
            bms->requestCounter = 0;
            if (bms->requestCallback != NULL) {
                bms->requestCallback();
            }
            bms->getStaticData = true;
            break;

        default:
            break;
        }
        bms->previousTime = current_millis();
    }
    return true;
}

// MODIFICATION LOG
// Date: [2025-01-03 HH:MM]
// Changed by: AI Agent
// Description: Thêm hàm DalyBms_updateSequential để gọi DalyBms_sendCommand trực tiếp theo vòng lặp tuần tự
// Reason: Cho phép gọi trực tiếp các lệnh BMS theo thứ tự để lấy dữ liệu liên tục
// Impact: Cung cấp phương thức mới để giao tiếp với BMS theo vòng lặp tuần tự
// Testing: Test với các lệnh BMS khác nhau để đảm bảo hoạt động đúng

// Hàm mới để gọi DalyBms_sendCommand theo vòng lặp tuần tự
bool DalyBms_updateSequential(DalyBms* bms)
{
    static unsigned int commandIndex = 0;
    static unsigned long lastCommandTime = 0;
    const unsigned long COMMAND_DELAY = 100; // Delay 100ms giữa các lệnh
    
    // Kiểm tra thời gian delay giữa các lệnh
    if (current_millis() - lastCommandTime < COMMAND_DELAY)
    {
        return true; // Chưa đến lúc gửi lệnh tiếp theo
    }
    
    // Danh sách các lệnh cần gọi tuần tự
    DALY_BMS_COMMAND commandSequence[] = {
        VOUT_IOUT_SOC,           // 0x90 - Pack measurements
        MIN_MAX_CELL_VOLTAGE,    // 0x91 - Min/Max cell voltage
        MIN_MAX_TEMPERATURE,     // 0x92 - Pack temperature
        DISCHARGE_CHARGE_MOS_STATUS, // 0x93 - MOSFET status
        STATUS_INFO,             // 0x94 - Status info
        CELL_VOLTAGES,           // 0x95 - Cell voltages
        CELL_TEMPERATURE,        // 0x96 - Cell temperature
        CELL_BALANCE_STATE,      // 0x97 - Cell balance state
        FAILURE_CODES,           // 0x98 - Failure codes
        CELL_THRESHOLDS,         // 0x59 - Voltage thresholds
        PACK_THRESHOLDS          // 0x5A - Pack voltage thresholds
    };
    
    const unsigned int TOTAL_COMMANDS = sizeof(commandSequence) / sizeof(commandSequence[0]);
    
    // Gửi lệnh hiện tại
    if (commandIndex < TOTAL_COMMANDS)
    {
        DALY_BMS_COMMAND currentCommand = commandSequence[commandIndex];
        
        // Gửi lệnh
        if (DalyBms_sendCommand(bms, currentCommand))
        {
            // Đợi và nhận dữ liệu
            if (DalyBms_receiveBytes(bms))
            {
                // Xử lý dữ liệu nhận được theo từng loại lệnh
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
                
                // Cập nhật trạng thái kết nối
                bms->get.connectionState = true;
                bms->errorCounter = 0;
            }
            else
            {
                // Lỗi nhận dữ liệu
                bms->errorCounter++;
                if (bms->errorCounter >= ERRORCOUNTER)
                {
                    bms->get.connectionState = false;
                    bms->errorCounter = 0;
                }
            }
        }
        else
        {
            // Lỗi gửi lệnh
            bms->errorCounter++;
        }
        
        // Chuyển sang lệnh tiếp theo
        commandIndex++;
    }
    else
    {
        // Hoàn thành một vòng lặp, reset về lệnh đầu tiên
        commandIndex = 0;
        
        // Gọi callback nếu có
        if (bms->requestCallback != NULL)
        {
            bms->requestCallback();
        }
    }
    
    lastCommandTime = current_millis();
    return true;
}

// Các hàm xử lý dữ liệu cho từng loại lệnh
static void DalyBms_processPackMeasurements(DalyBms* bms)
{
    // Xử lý dữ liệu pack measurements (0x90)
    if (bms->my_rxBuffer[2] == VOUT_IOUT_SOC)
    {
        // Kiểm tra dữ liệu hợp lệ
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
    // Xử lý dữ liệu min/max cell voltage (0x91)
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
    // Xử lý dữ liệu pack temperature (0x92)
    if (bms->my_rxBuffer[2] == MIN_MAX_TEMPERATURE)
    {
        bms->get.tempAverage = ((bms->my_rxBuffer[4] - 40) + (bms->my_rxBuffer[6] - 40)) / 2;
    }
}

static void DalyBms_processDischargeChargeMosStatus(DalyBms* bms)
{
    // Xử lý dữ liệu MOSFET status (0x93)
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
        
        bms->get.chargeFetState = BIT_READ(bms->my_rxBuffer[5], 0);
        bms->get.disChargeFetState = BIT_READ(bms->my_rxBuffer[6], 0);
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
    // Xử lý dữ liệu status info (0x94)
    if (bms->my_rxBuffer[2] == STATUS_INFO)
    {
        size_t i;
        
        bms->get.numberOfCells = bms->my_rxBuffer[4];
        bms->get.numOfTempSensors = bms->my_rxBuffer[5];
        bms->get.chargeState = BIT_READ(bms->my_rxBuffer[6], 0);
        bms->get.loadState = BIT_READ(bms->my_rxBuffer[7], 0);
        
        // Parse Digital IO states
        for (i = 0; i < 8; i++)
        {
            bms->get.dIO[i] = BIT_READ(bms->my_rxBuffer[8], i);
        }
        
        bms->get.bmsCycles = ((uint16_t)bms->my_rxBuffer[9] << 0x08) | (uint16_t)bms->my_rxBuffer[10];
    }
}

static void DalyBms_processCellVoltages(DalyBms* bms)
{
    // Xử lý dữ liệu cell voltages (0x95)
    if (bms->my_rxBuffer[2] == CELL_VOLTAGES)
    {
        unsigned int cellNo = 0;
        size_t i;
        
        if (bms->get.numberOfCells >= MIN_NUMBER_CELLS && bms->get.numberOfCells <= MAX_NUMBER_CELLS)
        {
            for (i = 0; i < 3 && cellNo < bms->get.numberOfCells && cellNo < MAX_NUMBER_CELLS; i++)
            {
                bms->get.cellVmV[cellNo] = (float)((bms->my_rxBuffer[5 + (i * 2)] << 8) | bms->my_rxBuffer[6 + (i * 2)]);
                cellNo++;
            }
        }
    }
}

static void DalyBms_processCellTemperature(DalyBms* bms)
{
    // Xử lý dữ liệu cell temperature (0x96)
    if (bms->my_rxBuffer[2] == CELL_TEMPERATURE)
    {
        unsigned int sensorNo = 0;
        size_t i;
        
        if (bms->get.numOfTempSensors >= MIN_NUMBER_TEMP_SENSORS && bms->get.numOfTempSensors <= MAX_NUMBER_TEMP_SENSORS)
        {
            for (i = 0; i < 7 && sensorNo < bms->get.numOfTempSensors && sensorNo < MAX_NUMBER_TEMP_SENSORS; i++)
            {
                bms->get.cellTemperature[sensorNo] = (bms->my_rxBuffer[5 + i] - 40);
                sensorNo++;
            }
        }
    }
}

static void DalyBms_processCellBalanceState(DalyBms* bms)
{
    // Xử lý dữ liệu cell balance state (0x97)
    if (bms->my_rxBuffer[2] == CELL_BALANCE_STATE)
    {
        int cellBalance = 0;
        int cellBit = 0;
        size_t i, j;
        
        if (bms->get.numberOfCells >= MIN_NUMBER_CELLS && bms->get.numberOfCells <= MAX_NUMBER_CELLS)
        {
            for (i = 0; i < 6; i++)
            {
                for (j = 0; j < 8; j++)
                {
                    if (cellBit < MAX_NUMBER_CELLS)
                    {
                        bms->get.cellBalanceState[cellBit] = BIT_READ(bms->my_rxBuffer[i + 4], j);
                        if (BIT_READ(bms->my_rxBuffer[i + 4], j))
                        {
                            cellBalance++;
                        }
                    }
                    cellBit++;
                    if (cellBit >= MAX_NUMBER_CELLS)
                        break;
                }
                if (cellBit >= MAX_NUMBER_CELLS)
                    break;
            }
            
            bms->get.cellBalanceActive = (cellBalance > 0);
        }
    }
}

static void DalyBms_processFailureCodes(DalyBms* bms)
{
    // Xử lý dữ liệu failure codes (0x98)
    if (bms->my_rxBuffer[2] == FAILURE_CODES)
    {
        size_t len;
        
        bms->failCodeArr[0] = '\0';
        
        // Parse failure codes từ buffer
        if (BIT_READ(bms->my_rxBuffer[4], 1))
            strcat(bms->failCodeArr, "Cell volt high level 2,");
        else if (BIT_READ(bms->my_rxBuffer[4], 0))
            strcat(bms->failCodeArr, "Cell volt high level 1,");
        if (BIT_READ(bms->my_rxBuffer[4], 3))
            strcat(bms->failCodeArr, "Cell volt low level 2,");
        else if (BIT_READ(bms->my_rxBuffer[4], 2))
            strcat(bms->failCodeArr, "Cell volt low level 1,");
        if (BIT_READ(bms->my_rxBuffer[4], 5))
            strcat(bms->failCodeArr, "Sum volt high level 2,");
        else if (BIT_READ(bms->my_rxBuffer[4], 4))
            strcat(bms->failCodeArr, "Sum volt high level 1,");
        if (BIT_READ(bms->my_rxBuffer[4], 7))
            strcat(bms->failCodeArr, "Sum volt low level 2,");
        else if (BIT_READ(bms->my_rxBuffer[4], 6))
            strcat(bms->failCodeArr, "Sum volt low level 1,");
        /* 0x01 */
        if (BIT_READ(bms->my_rxBuffer[5], 1))
            strcat(bms->failCodeArr, "Chg temp high level 2,");
        else if (BIT_READ(bms->my_rxBuffer[5], 0))
            strcat(bms->failCodeArr, "Chg temp high level 1,");
        if (BIT_READ(bms->my_rxBuffer[5], 3))
            strcat(bms->failCodeArr, "Chg temp low level 2,");
        else if (BIT_READ(bms->my_rxBuffer[5], 2))
            strcat(bms->failCodeArr, "Chg temp low level 1,");
        if (BIT_READ(bms->my_rxBuffer[5], 5))
            strcat(bms->failCodeArr, "Dischg temp high level 2,");
        else if (BIT_READ(bms->my_rxBuffer[5], 4))
            strcat(bms->failCodeArr, "Dischg temp high level 1,");
        if (BIT_READ(bms->my_rxBuffer[5], 7))
            strcat(bms->failCodeArr, "Dischg temp low level 2,");
        else if (BIT_READ(bms->my_rxBuffer[5], 6))
            strcat(bms->failCodeArr, "Dischg temp low level 1,");
        /* 0x02 */
        if (BIT_READ(bms->my_rxBuffer[6], 1))
            strcat(bms->failCodeArr, "Chg overcurrent level 2,");
        else if (BIT_READ(bms->my_rxBuffer[6], 0))
            strcat(bms->failCodeArr, "Chg overcurrent level 1,");
        if (BIT_READ(bms->my_rxBuffer[6], 3))
            strcat(bms->failCodeArr, "Dischg overcurrent level 2,");
        else if (BIT_READ(bms->my_rxBuffer[6], 2))
            strcat(bms->failCodeArr, "Dischg overcurrent level 1,");
        if (BIT_READ(bms->my_rxBuffer[6], 5))
            strcat(bms->failCodeArr, "SOC high level 2,");
        else if (BIT_READ(bms->my_rxBuffer[6], 4))
            strcat(bms->failCodeArr, "SOC high level 1,");
        if (BIT_READ(bms->my_rxBuffer[6], 7))
            strcat(bms->failCodeArr, "SOC Low level 2,");
        else if (BIT_READ(bms->my_rxBuffer[6], 6))
            strcat(bms->failCodeArr, "SOC Low level 1,");
        /* 0x03 */
        if (BIT_READ(bms->my_rxBuffer[7], 1))
            strcat(bms->failCodeArr, "Diff volt level 2,");
        else if (BIT_READ(bms->my_rxBuffer[7], 0))
            strcat(bms->failCodeArr, "Diff volt level 1,");
        if (BIT_READ(bms->my_rxBuffer[7], 3))
            strcat(bms->failCodeArr, "Diff temp level 2,");
        else if (BIT_READ(bms->my_rxBuffer[7], 2))
            strcat(bms->failCodeArr, "Diff temp level 1,");
        /* 0x04 */
        if (BIT_READ(bms->my_rxBuffer[8], 0))
            strcat(bms->failCodeArr, "Chg MOS temp high alarm,");
        if (BIT_READ(bms->my_rxBuffer[8], 1))
            strcat(bms->failCodeArr, "Dischg MOS temp high alarm,");
        if (BIT_READ(bms->my_rxBuffer[8], 2))
            strcat(bms->failCodeArr, "Chg MOS temp sensor err,");
        if (BIT_READ(bms->my_rxBuffer[8], 3))
            strcat(bms->failCodeArr, "Dischg MOS temp sensor err,");
        if (BIT_READ(bms->my_rxBuffer[8], 4))
            strcat(bms->failCodeArr, "Chg MOS adhesion err,");
        if (BIT_READ(bms->my_rxBuffer[8], 5))
            strcat(bms->failCodeArr, "Dischg MOS adhesion err,");
        if (BIT_READ(bms->my_rxBuffer[8], 6))
            strcat(bms->failCodeArr, "Chg MOS open circuit err,");
        if (BIT_READ(bms->my_rxBuffer[8], 7))
            strcat(bms->failCodeArr, " Discrg MOS open circuit err,");
        /* 0x05 */
        if (BIT_READ(bms->my_rxBuffer[9], 0))
            strcat(bms->failCodeArr, "AFE collect chip err,");
        if (BIT_READ(bms->my_rxBuffer[9], 1))
            strcat(bms->failCodeArr, "Voltage collect dropped,");
        if (BIT_READ(bms->my_rxBuffer[9], 2))
            strcat(bms->failCodeArr, "Cell temp sensor err,");
        if (BIT_READ(bms->my_rxBuffer[9], 3))
            strcat(bms->failCodeArr, "EEPROM err,");
        if (BIT_READ(bms->my_rxBuffer[9], 4))
            strcat(bms->failCodeArr, "RTC err,");
        if (BIT_READ(bms->my_rxBuffer[9], 5))
            strcat(bms->failCodeArr, "Precharge failure,");
        if (BIT_READ(bms->my_rxBuffer[9], 6))
            strcat(bms->failCodeArr, "Communication failure,");
        if (BIT_READ(bms->my_rxBuffer[9], 7))
            strcat(bms->failCodeArr, "Internal communication failure,");
        /* 0x06 */
        if (BIT_READ(bms->my_rxBuffer[10], 0))
            strcat(bms->failCodeArr, "Current module fault,");
        if (BIT_READ(bms->my_rxBuffer[10], 1))
            strcat(bms->failCodeArr, "Sum voltage detect fault,");
        if (BIT_READ(bms->my_rxBuffer[10], 2))
            strcat(bms->failCodeArr, "Short circuit protect fault,");
        if (BIT_READ(bms->my_rxBuffer[10], 3))
            strcat(bms->failCodeArr, "Low volt forbidden chg fault,");
        // remove the last character
        len = strlen(bms->failCodeArr);
        if (len > 0 && bms->failCodeArr[len - 1] == ',')
        {
            bms->failCodeArr[len - 1] = '\0';
        }
    }
}

static void DalyBms_processVoltageThreshold(DalyBms* bms)
{
    // Xử lý dữ liệu voltage threshold (0x59)
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
    // Xử lý dữ liệu pack voltage threshold (0x5A)
    if (bms->my_rxBuffer[2] == PACK_THRESHOLDS)
    {
        bms->get.maxPackThreshold1 = (float)((bms->my_rxBuffer[4] << 8) | bms->my_rxBuffer[5]);
        bms->get.maxPackThreshold2 = (float)((bms->my_rxBuffer[6] << 8) | bms->my_rxBuffer[7]);
        bms->get.minPackThreshold1 = (float)((bms->my_rxBuffer[8] << 8) | bms->my_rxBuffer[9]);
        bms->get.minPackThreshold2 = (float)((bms->my_rxBuffer[10] << 8) | bms->my_rxBuffer[11]);
    }
}

bool DalyBms_getVoltageThreshold(DalyBms* bms) // 0x59
{
    if (!DalyBms_requestData(bms, CELL_THRESHOLDS, 1))
    {
        return false;
    }

    bms->get.maxCellThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
    bms->get.maxCellThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
    bms->get.minCellThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
    bms->get.minCellThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);

    return true;
}

bool DalyBms_getPackVoltageThreshold(DalyBms* bms) // 0x5A
{
    if (!DalyBms_requestData(bms, PACK_THRESHOLDS, 1))
    {
        return false;
    }

    bms->get.maxPackThreshold1 = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
    bms->get.maxPackThreshold2 = (float)((bms->frameBuff[0][6] << 8) | bms->frameBuff[0][7]);
    bms->get.minPackThreshold1 = (float)((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]);
    bms->get.minPackThreshold2 = (float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]);

    return true;
}

bool DalyBms_getPackMeasurements(DalyBms* bms) // 0x90
{
    if (!DalyBms_requestData(bms, VOUT_IOUT_SOC, 1))
    {
        DalyBms_clearGet(bms);
        return false;
    }
    else
    {
        // check if packCurrent in range
        if (((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f) == -3000.f)
        {
            return false;
        }
        else
            // check if SOC in range
            if (((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f) > 100.f)
            {
                return false;
            }
    }
    // Pull the relevant values out of the buffer
    bms->get.packVoltage = ((float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]) / 10.0f);
    bms->get.packCurrent = ((float)(((bms->frameBuff[0][8] << 8) | bms->frameBuff[0][9]) - 30000) / 10.0f);
    bms->get.packSOC = ((float)((bms->frameBuff[0][10] << 8) | bms->frameBuff[0][11]) / 10.0f);
    return true;
}

bool DalyBms_getMinMaxCellVoltage(DalyBms* bms) // 0x91
{
    if (!DalyBms_requestData(bms, MIN_MAX_CELL_VOLTAGE, 1))
    {
        return false;
    }

    bms->get.maxCellmV = (float)((bms->frameBuff[0][4] << 8) | bms->frameBuff[0][5]);
    bms->get.maxCellVNum = bms->frameBuff[0][6];
    bms->get.minCellmV = (float)((bms->frameBuff[0][7] << 8) | bms->frameBuff[0][8]);
    bms->get.minCellVNum = bms->frameBuff[0][9];
    bms->get.cellDiff = (bms->get.maxCellmV - bms->get.minCellmV);

    return true;
}

bool DalyBms_getPackTemp(DalyBms* bms) // 0x92
{
    if (!DalyBms_requestData(bms, MIN_MAX_TEMPERATURE, 1))
    {
        return false;
    }
    bms->get.tempAverage = ((bms->frameBuff[0][4] - 40) + (bms->frameBuff[0][6] - 40)) / 2;

    return true;
}

bool DalyBms_getDischargeChargeMosStatus(DalyBms* bms) // 0x93
{
    char msgbuff[16];
    float tmpAh;
    
    if (!DalyBms_requestData(bms, DISCHARGE_CHARGE_MOS_STATUS, 1))
    {
        return false;
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

    bms->get.chargeFetState = BIT_READ(bms->frameBuff[0][5], 0); // Assuming 0 or 1 indicates state
    bms->get.disChargeFetState = BIT_READ(bms->frameBuff[0][6], 0); // Assuming 0 or 1 indicates state
    bms->get.bmsHeartBeat = bms->frameBuff[0][7];
    tmpAh = (float)(((uint32_t)bms->frameBuff[0][8] << 0x18) | ((uint32_t)bms->frameBuff[0][9] << 0x10) | ((uint32_t)bms->frameBuff[0][10] << 0x08) | (uint32_t)bms->frameBuff[0][11]) * 0.001;
    sprintf(msgbuff, "%.1f", tmpAh); // Use sprintf for float to string conversion
    bms->get.resCapacityAh = atof(msgbuff);

    return true;
}

bool DalyBms_getStatusInfo(DalyBms* bms) // 0x94
{
    size_t i;
    
    if (!DalyBms_requestData(bms, STATUS_INFO, 1))
    {
        return false;
    }

    bms->get.numberOfCells = bms->frameBuff[0][4];
    bms->get.numOfTempSensors = bms->frameBuff[0][5];
    bms->get.chargeState = BIT_READ(bms->frameBuff[0][6], 0); // Assuming 0 or 1 indicates state
    bms->get.loadState = BIT_READ(bms->frameBuff[0][7], 0);   // Assuming 0 or 1 indicates state

    // Parse the 8 bits into 8 booleans that represent the states of the Digital IO
    for (i = 0; i < 8; i++)
    {
        bms->get.dIO[i] = BIT_READ(bms->frameBuff[0][8], i);
    }

    bms->get.bmsCycles = ((uint16_t)bms->frameBuff[0][9] << 0x08) | (uint16_t)bms->frameBuff[0][10];

    return true;
}

bool DalyBms_getCellVoltages(DalyBms* bms) // 0x95
{
    unsigned int cellNo;
    size_t k;
    size_t i;

    // start with cell no. 1
    cellNo = 0;

    // Check to make sure we have a valid number of cells
    if (bms->get.numberOfCells < MIN_NUMBER_CELLS || bms->get.numberOfCells > MAX_NUMBER_CELLS)
    {
        return false;
    }

    if (DalyBms_requestData(bms, CELL_VOLTAGES, (unsigned int)ceil(bms->get.numberOfCells / 3.0)))
    {
        for (k = 0; k < (unsigned int)ceil(bms->get.numberOfCells / 3.0); k++)
        {
            for (i = 0; i < 3; i++)
            {
                if (cellNo < MAX_NUMBER_CELLS) { // Ensure no out-of-bounds access
                    bms->get.cellVmV[cellNo] = (float)((bms->frameBuff[k][5 + (i * 2)] << 8) | bms->frameBuff[k][6 + (i * 2)]);
                }
                cellNo++;
                if (cellNo >= bms->get.numberOfCells)
                    break;
            }
        }
        return true;
    }
    else
    {
        return false;
    }
}

bool DalyBms_getCellTemperature(DalyBms* bms) // 0x96
{
    unsigned int sensorNo;
    size_t k;
    size_t i;
    
    // start with sensor no. 1
    sensorNo = 0;
    
    // Check to make sure we have a valid number of temp sensors
    if ((bms->get.numOfTempSensors < MIN_NUMBER_TEMP_SENSORS) || (bms->get.numOfTempSensors > MAX_NUMBER_TEMP_SENSORS))
    {
        return false;
    }

    if (DalyBms_requestData(bms, CELL_TEMPERATURE, (unsigned int)ceil(bms->get.numOfTempSensors / 7.0)))
    {
        for (k = 0; k < (unsigned int)ceil(bms->get.numOfTempSensors / 7.0); k++)
        {
            for (i = 0; i < 7; i++)
            {
                if (sensorNo < MAX_NUMBER_TEMP_SENSORS) { // Ensure no out-of-bounds access
                    bms->get.cellTemperature[sensorNo] = (bms->frameBuff[k][5 + i] - 40);
                }
                sensorNo++;
                if (sensorNo >= bms->get.numOfTempSensors)
                    break;
            }
        }
        return true;
    }
    else
    {
        return false;
    }
}

bool DalyBms_getCellBalanceState(DalyBms* bms) // 0x97
{
    int cellBalance;
    int cellBit;
    size_t i;
    size_t j;

    cellBalance = 0;
    cellBit = 0;

    // Check to make sure we have a valid number of cells
    if (bms->get.numberOfCells < MIN_NUMBER_CELLS || bms->get.numberOfCells > MAX_NUMBER_CELLS)
    {
        return false;
    }

    if (!DalyBms_requestData(bms, CELL_BALANCE_STATE, 1))
    {
        return false;
    }

    // We expect 6 bytes response for this command
    for (i = 0; i < 6; i++)
    {
        // For each bit in the byte, pull out the cell balance state boolean
        for (j = 0; j < 8; j++)
        {
            if (cellBit < MAX_NUMBER_CELLS) { // Ensure no out-of-bounds access
                bms->get.cellBalanceState[cellBit] = BIT_READ(bms->frameBuff[0][i + 4], j);
            }
            if (BIT_READ(bms->frameBuff[0][i + 4], j))
            {
                cellBalance++;
            }
            cellBit++;
            if (cellBit >= MAX_NUMBER_CELLS) // Changed 47 to MAX_NUMBER_CELLS for robustness
            {
                break;
            }
        }
        if (cellBit >= MAX_NUMBER_CELLS) {
            break;
        }
    }

    if (cellBalance > 0)
    {
        bms->get.cellBalanceActive = true;
    }
    else
    {
        bms->get.cellBalanceActive = false;
    }

    return true;
}

bool DalyBms_getFailureCodes(DalyBms* bms) // 0x98
{
    size_t len;
    
    if (!DalyBms_requestData(bms, FAILURE_CODES, 1))
    {
        return false;
    }

    bms->failCodeArr[0] = '\0'; // Clear the string

    /* 0x00 */
    if (BIT_READ(bms->frameBuff[0][4], 1))
        strcat(bms->failCodeArr, "Cell volt high level 2,");
    else if (BIT_READ(bms->frameBuff[0][4], 0))
        strcat(bms->failCodeArr, "Cell volt high level 1,");
    if (BIT_READ(bms->frameBuff[0][4], 3))
        strcat(bms->failCodeArr, "Cell volt low level 2,");
    else if (BIT_READ(bms->frameBuff[0][4], 2))
        strcat(bms->failCodeArr, "Cell volt low level 1,");
    if (BIT_READ(bms->frameBuff[0][4], 5))
        strcat(bms->failCodeArr, "Sum volt high level 2,");
    else if (BIT_READ(bms->frameBuff[0][4], 4))
        strcat(bms->failCodeArr, "Sum volt high level 1,");
    if (BIT_READ(bms->frameBuff[0][4], 7))
        strcat(bms->failCodeArr, "Sum volt low level 2,");
    else if (BIT_READ(bms->frameBuff[0][4], 6))
        strcat(bms->failCodeArr, "Sum volt low level 1,");
    /* 0x01 */
    if (BIT_READ(bms->frameBuff[0][5], 1))
        strcat(bms->failCodeArr, "Chg temp high level 2,");
    else if (BIT_READ(bms->frameBuff[0][5], 0))
        strcat(bms->failCodeArr, "Chg temp high level 1,");
    if (BIT_READ(bms->frameBuff[0][5], 3))
        strcat(bms->failCodeArr, "Chg temp low level 2,");
    else if (BIT_READ(bms->frameBuff[0][5], 2))
        strcat(bms->failCodeArr, "Chg temp low level 1,");
    if (BIT_READ(bms->frameBuff[0][5], 5))
        strcat(bms->failCodeArr, "Dischg temp high level 2,");
    else if (BIT_READ(bms->frameBuff[0][5], 4))
        strcat(bms->failCodeArr, "Dischg temp high level 1,");
    if (BIT_READ(bms->frameBuff[0][5], 7))
        strcat(bms->failCodeArr, "Dischg temp low level 2,");
    else if (BIT_READ(bms->frameBuff[0][5], 6))
        strcat(bms->failCodeArr, "Dischg temp low level 1,");
    /* 0x02 */
    if (BIT_READ(bms->frameBuff[0][6], 1))
        strcat(bms->failCodeArr, "Chg overcurrent level 2,");
    else if (BIT_READ(bms->frameBuff[0][6], 0))
        strcat(bms->failCodeArr, "Chg overcurrent level 1,");
    if (BIT_READ(bms->frameBuff[0][6], 3))
        strcat(bms->failCodeArr, "Dischg overcurrent level 2,");
    else if (BIT_READ(bms->frameBuff[0][6], 2))
        strcat(bms->failCodeArr, "Dischg overcurrent level 1,");
    if (BIT_READ(bms->frameBuff[0][6], 5))
        strcat(bms->failCodeArr, "SOC high level 2,");
    else if (BIT_READ(bms->frameBuff[0][6], 4))
        strcat(bms->failCodeArr, "SOC high level 1,");
    if (BIT_READ(bms->frameBuff[0][6], 7))
        strcat(bms->failCodeArr, "SOC Low level 2,");
    else if (BIT_READ(bms->frameBuff[0][6], 6))
        strcat(bms->failCodeArr, "SOC Low level 1,");
    /* 0x03 */
    if (BIT_READ(bms->frameBuff[0][7], 1))
        strcat(bms->failCodeArr, "Diff volt level 2,");
    else if (BIT_READ(bms->frameBuff[0][7], 0))
        strcat(bms->failCodeArr, "Diff volt level 1,");
    if (BIT_READ(bms->frameBuff[0][7], 3))
        strcat(bms->failCodeArr, "Diff temp level 2,");
    else if (BIT_READ(bms->frameBuff[0][7], 2))
        strcat(bms->failCodeArr, "Diff temp level 1,");
    /* 0x04 */
    if (BIT_READ(bms->frameBuff[0][8], 0))
        strcat(bms->failCodeArr, "Chg MOS temp high alarm,");
    if (BIT_READ(bms->frameBuff[0][8], 1))
        strcat(bms->failCodeArr, "Dischg MOS temp high alarm,");
    if (BIT_READ(bms->frameBuff[0][8], 2))
        strcat(bms->failCodeArr, "Chg MOS temp sensor err,");
    if (BIT_READ(bms->frameBuff[0][8], 3))
        strcat(bms->failCodeArr, "Dischg MOS temp sensor err,");
    if (BIT_READ(bms->frameBuff[0][8], 4))
        strcat(bms->failCodeArr, "Chg MOS adhesion err,");
    if (BIT_READ(bms->frameBuff[0][8], 5))
        strcat(bms->failCodeArr, "Dischg MOS adhesion err,");
    if (BIT_READ(bms->frameBuff[0][8], 6))
        strcat(bms->failCodeArr, "Chg MOS open circuit err,");
    if (BIT_READ(bms->frameBuff[0][8], 7))
        strcat(bms->failCodeArr, " Discrg MOS open circuit err,");
    /* 0x05 */
    if (BIT_READ(bms->frameBuff[0][9], 0))
        strcat(bms->failCodeArr, "AFE collect chip err,");
    if (BIT_READ(bms->frameBuff[0][9], 1))
        strcat(bms->failCodeArr, "Voltage collect dropped,");
    if (BIT_READ(bms->frameBuff[0][9], 2))
        strcat(bms->failCodeArr, "Cell temp sensor err,");
    if (BIT_READ(bms->frameBuff[0][9], 3))
        strcat(bms->failCodeArr, "EEPROM err,");
    if (BIT_READ(bms->frameBuff[0][9], 4))
        strcat(bms->failCodeArr, "RTC err,");
    if (BIT_READ(bms->frameBuff[0][9], 5))
        strcat(bms->failCodeArr, "Precharge failure,");
    if (BIT_READ(bms->frameBuff[0][9], 6))
        strcat(bms->failCodeArr, "Communication failure,");
    if (BIT_READ(bms->frameBuff[0][9], 7))
        strcat(bms->failCodeArr, "Internal communication failure,");
    /* 0x06 */
    if (BIT_READ(bms->frameBuff[0][10], 0))
        strcat(bms->failCodeArr, "Current module fault,");
    if (BIT_READ(bms->frameBuff[0][10], 1))
        strcat(bms->failCodeArr, "Sum voltage detect fault,");
    if (BIT_READ(bms->frameBuff[0][10], 2))
        strcat(bms->failCodeArr, "Short circuit protect fault,");
    if (BIT_READ(bms->frameBuff[0][10], 3))
        strcat(bms->failCodeArr, "Low volt forbidden chg fault,");
    // remove the last character
    len = strlen(bms->failCodeArr);
    if (len > 0 && bms->failCodeArr[len - 1] == ',')
    {
        bms->failCodeArr[len - 1] = '\0';
    }
    return true;
}

bool DalyBms_setDischargeMOS(DalyBms* bms, bool sw) // 0xD9 0x80 First Byte 0x01=ON 0x00=OFF
{
    bms->requestCounter = 0;
    if (sw)
    {
        // Set the first byte of the data payload to 1, indicating that we want to switch on the MOSFET
        bms->my_txBuffer[4] = 0x01;
    }
    else
    {
        bms->my_txBuffer[4] = 0x00; // Explicitly set to 0 for OFF
    }
    
    DalyBms_sendCommand(bms, DISCHRG_FET);

    if (!DalyBms_receiveBytes(bms))
    {
        return false;
    }

    return true;
}

bool DalyBms_setChargeMOS(DalyBms* bms, bool sw) // 0xDA 0x80 First Byte 0x01=ON 0x00=OFF
{
    bms->requestCounter = 0;
    if (sw)
    {
        // Set the first byte of the data payload to 1, indicating that we want to switch on the MOSFET
        bms->my_txBuffer[4] = 0x01;
    }
    else
    {
        bms->my_txBuffer[4] = 0x00; // Explicitly set to 0 for OFF
    }
    DalyBms_sendCommand(bms, CHRG_FET);

    if (!DalyBms_receiveBytes(bms))
    {
        return false;
    }

    return true;
}

bool DalyBms_setBmsReset(DalyBms* bms) // 0x00 Reset the BMS
{
    bms->requestCounter = 0;
    DalyBms_sendCommand(bms, BMS_RESET);
    if (!DalyBms_receiveBytes(bms))
    {
        return false;
    }
    return true;
}

bool DalyBms_setSOC(DalyBms* bms, float val) // 0x21 last two byte is SOC
{
    uint16_t value;
    size_t i;
    
    if (val >= 0.0f && val <= 100.0f)
    {
        bms->requestCounter = 0;

        // try read with 0x61
        DalyBms_sendCommand(bms, READ_SOC);
        if (!DalyBms_receiveBytes(bms))
        {
            bms->my_txBuffer[5] = 0x17; // year (current year - 2000)
            bms->my_txBuffer[6] = 0x01; // month
            bms->my_txBuffer[7] = 0x01; // day
            bms->my_txBuffer[8] = 0x01; // hour
            bms->my_txBuffer[9] = 0x01; // minute
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
            return false;
        }
        else
        {
            return true;
        }
    }
    return false;
}

bool DalyBms_getState(DalyBms* bms) // Function to return the state of connection
{
    return bms->get.connectionState;
}

void DalyBms_set_callback(DalyBms* bms, void (*func)(void)) // callback function when finish request
{
    bms->requestCallback = func;
}

//----------------------------------------------------------------------
// Private Functions (renamed with DalyBms_ prefix and static scope in a real .c file)
// For this example, they are prefixed and included here.
//----------------------------------------------------------------------

static bool DalyBms_requestData(DalyBms* bms, DALY_BMS_COMMAND cmdID, unsigned int frameAmount)
{
    uint8_t txChecksum;
    unsigned int byteCounter;
    size_t i;
    size_t j;
    uint8_t rxChecksum;
    int k;
    uint8_t frame_count;
    uint8_t received_frames;
    
    // Clear out the buffers
    memset(bms->my_rxFrameBuffer, 0x00, sizeof(bms->my_rxFrameBuffer));
    memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff));
    memset(bms->my_txBuffer, 0x00, XFER_BUFFER_LENGTH);
    
    //--------------send part--------------------
    txChecksum = 0x00;    // transmit checksum buffer
    byteCounter = 0; // bytecounter for incoming data
    
    // prepare the frame with static data and command ID
    bms->my_txBuffer[0] = START_BYTE;
    bms->my_txBuffer[1] = HOST_ADRESS;
    bms->my_txBuffer[2] = cmdID;
    bms->my_txBuffer[3] = FRAME_LENGTH;

    // Calculate the checksum
    for (i = 0; i <= 11; i++)
    {
        txChecksum += bms->my_txBuffer[i];
    }
    // put it on the frame
    bms->my_txBuffer[12] = txChecksum;

    // send the packet using UART1
    _UART1_SendPush(bms->my_txBuffer);
    // Process TX stack immediately for blocking operation
    _UART1_SendProcess();
    //-------------------------------------------

    //-----------Receive Part---------------------
    // Wait for frames from UART1 RX stack

    
    frame_count = 0;
    received_frames = 0;
    
    // Try to get frames from UART1 RX stack
    while (frame_count < frameAmount && received_frames < 10) { // Max 10 attempts
        if (_UART1_Rx_GetFrame(bms->frameBuff[frame_count])) {
            frame_count++;
        }
        received_frames++;
        // Small delay to allow ISR to process
        Delay_ms(1);
    }
    
    // Process received frames
    for (i = 0; i < frame_count; i++)
    {
        rxChecksum = 0x00;
        for (k = 0; k < XFER_BUFFER_LENGTH - 1; k++)
        {
            rxChecksum += bms->frameBuff[i][k];
        }
        //char debugBuff[128];
        //sprintf(debugBuff, "<UART>[Command: 0x%2X][CRC Rec: %2X][CRC Calc: %2X]", cmdID, rxChecksum, bms->frameBuff[i][XFER_BUFFER_LENGTH - 1]);

        if (rxChecksum != bms->frameBuff[i][XFER_BUFFER_LENGTH - 1])
        {
            return false;
        }
        if (rxChecksum == 0) // This condition might indicate no data or all zeros, needs careful consideration for actual no-data scenario
        {
            return false;
        }
        if (bms->frameBuff[i][1] >= 0x20) // This check seems specific to a Daly BMS sleep state
        {
            return false;
        }
    }
    return true;
}

static bool DalyBms_sendQueueAdd(DalyBms* bms, DALY_BMS_COMMAND cmdID)
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
    return true;
}

static bool DalyBms_sendCommand(DalyBms* bms, DALY_BMS_COMMAND cmdID)
{
    uint8_t checksum;
    uint8_t i;
    
    checksum = 0;
    // clear all incoming serial to avoid data collision
    _UART1_ClearBuffers();

    // prepare the frame with static data and command ID
    bms->my_txBuffer[0] = START_BYTE;
    bms->my_txBuffer[1] = HOST_ADRESS;
    bms->my_txBuffer[2] = cmdID;
    bms->my_txBuffer[3] = FRAME_LENGTH;

    // Calculate the checksum
    for (i = 0; i <= 11; i++)
    {
        checksum += bms->my_txBuffer[i];
    }
    // put it on the frame
    bms->my_txBuffer[12] = checksum;

    _UART1_SendPush(bms->my_txBuffer);
    // Process TX stack immediately for blocking operation
    _UART1_SendProcess();

    // after send clear the transmit buffer
    memset(bms->my_txBuffer, 0x00, XFER_BUFFER_LENGTH);
    bms->requestCounter = 0; // reset the request queue that we get actual data
    return true;
}

static bool DalyBms_receiveBytes(DalyBms* bms)
{
    uint8_t frame[XFER_BUFFER_LENGTH];
    
    // Clear out the input buffer
    memset(bms->my_rxBuffer, 0x00, XFER_BUFFER_LENGTH);
    memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff));

    // Try to get frame from UART1 RX stack
    if (!_UART1_Rx_GetFrame(frame))
    {
        DalyBms_barfRXBuffer(bms);
        return false;
    }

    // Copy frame to my_rxBuffer
    memcpy(bms->my_rxBuffer, frame, XFER_BUFFER_LENGTH);

    if (!DalyBms_validateChecksum(bms))
    {
        DalyBms_barfRXBuffer(bms);
        return false;
    }

    return true;
}

static bool DalyBms_validateChecksum(DalyBms* bms)
{
    uint8_t checksum;
    int i;
    
    checksum = 0x00;

    for (i = 0; i < XFER_BUFFER_LENGTH - 1; i++)
    {
        checksum += bms->my_rxBuffer[i];
    }
    // Compare the calculated checksum to the real checksum (the last received byte)
    return (checksum == bms->my_rxBuffer[XFER_BUFFER_LENGTH - 1]);
}

static void DalyBms_barfRXBuffer(DalyBms* bms)
{
    int i;
    
    // These were C++ String operations, replaced with C-style logging
    for (i = 0; i < XFER_BUFFER_LENGTH; i++)
    {
        writeLog(",0x%02X", bms->my_rxBuffer[i]);
    }
    writeLog("]\n");
}

static void DalyBms_clearGet(DalyBms* bms)
{
    bms->get.chargeDischargeStatus = "offline"; // charge/discharge status (0 stationary ,1 charge ,2 discharge)
    // You might want to memset the entire get struct to zero or initialize other fields here as well
    // memset(&(bms->get), 0x00, sizeof(DalyBmsData)); // Be careful if you have pointers in DalyBmsData
}

// --- UART1 BMS Communication Functions ---
// These functions are now handled by the UART1 module
// The BMS module uses _UART1_SendPush(), _UART1_SendProcess(), and _UART1_Rx_GetFrame()
// instead of the mock serial functions

// Mock implementation for millis() for environments without it
unsigned long current_millis(void) {
    // In a real embedded system, this would typically read a hardware timer.
    // For a desktop C program, you might use time.h for rough simulation.
    // This is a placeholder.
    return 0; // Always returns 0 for this mock. You need a real implementation.
}

// Implementation for writeLog function
void writeLog(const char* format, ...) {
    // This is a mock implementation. In a real embedded system,
    // you would implement this to write to UART, LCD, or other output device.
    // For now, we'll leave it empty to avoid compilation issues.
    (void)format; // Suppress unused parameter warning
}

// MODIFICATION LOG
// Date: [2025-01-03 HH:MM]
// Changed by: AI Agent
// Description: Thêm ví dụ sử dụng hàm DalyBms_updateSequential
// Reason: Minh họa cách sử dụng hàm mới để gọi DalyBms_sendCommand theo vòng lặp tuần tự
// Impact: Cung cấp hướng dẫn sử dụng cho developer
// Testing: Test trong main loop để đảm bảo hoạt động đúng

/*
VÍ DỤ SỬ DỤNG HÀM DalyBms_updateSequential:

// Trong main loop hoặc task scheduler:
void BMS_Task(void)
{
    // Khởi tạo BMS (chỉ gọi một lần)
    static bool bmsInitialized = false;
    if (!bmsInitialized)
    {
        DalyBms_Init(&bms);
        bmsInitialized = true;
    }
    
    // Gọi hàm update sequential để lấy dữ liệu liên tục
    DalyBms_updateSequential(&bms);
    
    // Kiểm tra trạng thái kết nối
    if (bms.get.connectionState)
    {
        // Dữ liệu BMS đã sẵn sàng, có thể sử dụng:
        // bms.get.packVoltage - Điện áp pack
        // bms.get.packCurrent - Dòng điện pack  
        // bms.get.packSOC - Mức sạc
        // bms.get.maxCellmV - Điện áp cell cao nhất
        // bms.get.minCellmV - Điện áp cell thấp nhất
        // bms.get.tempAverage - Nhiệt độ trung bình
        // bms.get.chargeFetState - Trạng thái MOSFET sạc
        // bms.get.disChargeFetState - Trạng thái MOSFET xả
        // bms.get.numberOfCells - Số lượng cell
        // bms.get.cellVmV[i] - Điện áp từng cell
        // bms.get.cellTemperature[i] - Nhiệt độ từng sensor
        // bms.get.cellBalanceState[i] - Trạng thái cân bằng cell
        // bms.failCodeArr - Mã lỗi (nếu có)
    }
    else
    {
        // BMS không kết nối hoặc có lỗi
        // Xử lý lỗi kết nối
    }
}

// Hoặc sử dụng trong main loop:
int main(void)
{
    // Khởi tạo hệ thống
    SystemInit();
    
    // Khởi tạo BMS
    DalyBms_Init(&bms);
    
    while(1)
    {
        // Gọi hàm update sequential
        DalyBms_updateSequential(&bms);
        
        // Xử lý dữ liệu BMS
        if (bms.get.connectionState)
        {
            // Hiển thị thông tin BMS
            printf("Pack Voltage: %.1fV\n", bms.get.packVoltage);
            printf("Pack Current: %.1fA\n", bms.get.packCurrent);
            printf("Pack SOC: %.1f%%\n", bms.get.packSOC);
            printf("Max Cell: %.0fmV (Cell %d)\n", bms.get.maxCellmV, bms.get.maxCellVNum);
            printf("Min Cell: %.0fmV (Cell %d)\n", bms.get.minCellmV, bms.get.minCellVNum);
            printf("Temperature: %d°C\n", bms.get.tempAverage);
        }
        
        // Delay để tránh gọi quá nhanh
        Delay_ms(10);
    }
}
*/