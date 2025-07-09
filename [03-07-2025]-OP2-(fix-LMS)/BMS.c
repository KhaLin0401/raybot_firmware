/*
DALY2MQTT Project
https://github.com/softwarecrash/DALY2MQTT
*/
#include "BMS.h" // Assuming daly.h is the converted header file you provided earlier
#include <string.h> // For memset, strcat, strlen
#include <stdio.h>  // For sprintf (if needed for logging)
#include <stdlib.h> // For atof
#include <math.h>   // For ceil
#include <ctype.h>
#include <stddef.h>

extern void writeLog(const char* format, ...);

// Forward declarations for mock serial functions (you'll replace these with actual implementations)
// These functions would typically interact with your hardware UART or a software serial library written in C.
// For this example, they are placeholders.

unsigned long current_millis(); // You need to define this function in your environment

DalyBms bms;
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

    // send the packet
    serial_write(bms->serial_handle, bms->my_txBuffer, XFER_BUFFER_LENGTH);
    // first wait for transmission end
    serial_flush(bms->serial_handle);
    //-------------------------------------------

    //-----------Receive Part---------------------
    /*uint8_t rxByteNum = */ serial_read_bytes(bms->serial_handle, bms->my_rxFrameBuffer, XFER_BUFFER_LENGTH * frameAmount);
    for (i = 0; i < frameAmount; i++)
    {
        for (j = 0; j < XFER_BUFFER_LENGTH; j++)
        {
            bms->frameBuff[i][j] = bms->my_rxFrameBuffer[byteCounter];
            byteCounter++;
        }

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
    while (serial_read_byte(bms->serial_handle) > 0);

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

    serial_write(bms->serial_handle, bms->my_txBuffer, XFER_BUFFER_LENGTH);
    // fix the sleep Bug
    // first wait for transmission end
    serial_flush(bms->serial_handle);

    // after send clear the transmit buffer
    memset(bms->my_txBuffer, 0x00, XFER_BUFFER_LENGTH);
    bms->requestCounter = 0; // reset the request queue that we get actual data
    return true;
}

static bool DalyBms_receiveBytes(DalyBms* bms)
{
    uint8_t rxByteNum;
    
    // Clear out the input buffer
    memset(bms->my_rxBuffer, 0x00, XFER_BUFFER_LENGTH);
    memset(bms->frameBuff, 0x00, sizeof(bms->frameBuff)); // This line seems redundant if my_rxBuffer is the primary target

    // Read bytes from the specified serial interface
    rxByteNum = serial_read_bytes(bms->serial_handle, bms->my_rxBuffer, XFER_BUFFER_LENGTH);

    // Make sure we got the correct number of bytes
    if (rxByteNum != XFER_BUFFER_LENGTH)
    {
        DalyBms_barfRXBuffer(bms);
        return false;
    }

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

// --- Mock Serial Functions (replace with your actual hardware/software serial implementation) ---
void serial_begin(void* handle, long baud, int config, int rx_pin, int tx_pin, bool inverse_logic) {
    // Implement your serial initialization here
}

size_t serial_write(void* handle, const uint8_t *buffer, size_t size) {
    // Implement your serial write here
    return size;
}

void serial_flush(void* handle) {
    // Implement your serial flush here
}

int serial_read_byte(void* handle) {
    // Implement your serial read byte here. Return -1 if no byte available.
    // For this mock, always return 0 for clearing the buffer, or a dummy value.
    // In a real scenario, you'd read from hardware.
    return -1; // No byte available
}

size_t serial_read_bytes(void* handle, uint8_t *buffer, size_t length) {
    // Implement your serial read bytes here.
    // For this mock, fill with dummy data or return 0 for no data.
    // In a real scenario, you'd read from hardware.
    // Example: fill buffer with some dummy data for testing purposes
    // memset(buffer, 0xAA, length);
    return 0; // Return 0 to simulate no data received by default in mock
}

// Mock implementation for millis() for environments without it
unsigned long current_millis() {
    // In a real embedded system, this would typically read a hardware timer.
    // For a desktop C program, you might use time.h for rough simulation.
    // This is a placeholder.
    return 0; // Always returns 0 for this mock. You need a real implementation.
}