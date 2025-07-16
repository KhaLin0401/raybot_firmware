/*
DALY2MQTT Project
https://github.com/softwarecrash/DALY2MQTT
*/
#ifndef BMS_H
#define BMS_H

#include <stdint.h> // For uint8_t
#include <stdbool.h> // For bool

// If you are using an Arduino environment and need SoftwareSerial, you'll need to handle it differently in C.
// For pure C, you would typically interact with hardware UART directly or provide your own software serial implementation.
// For this conversion, we will assume a generic serial interface.
// #include "SoftwareSerial.h" // Removed for pure C

#define XFER_BUFFER_LENGTH 13
#define MIN_NUMBER_CELLS 1
#define MAX_NUMBER_CELLS 48
#define MIN_NUMBER_TEMP_SENSORS 1
#define MAX_NUMBER_TEMP_SENSORS 16

#define START_BYTE 0xA5
#define HOST_ADRESS 0x40
#define FRAME_LENGTH 0x08
#define ERRORCOUNTER 10

//time in ms for delay the bms requests, to fast brings connection error
#define DELAYTINME 150

// Define COMMAND enum as a plain enum in C
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

// Define get struct
typedef struct
{
    // data from 0x59
    float maxCellThreshold1; // Level-1 alarm threshold for High Voltage in Millivolts
    float minCellThreshold1; // Level-1 alarm threshold for low Voltage in Millivolts
    float maxCellThreshold2; // Level-2 alarm threshold for High Voltage in Millivolts
    float minCellThreshold2; // Level-2 alarm threshold for low Voltage in Millivolts

    // data from 0x5A
    float maxPackThreshold1; // Level-1 alarm threshold for high voltage in decivolts
    float minPackThreshold1; // Level-1 alarm threshold for low voltage in decivolts
    float maxPackThreshold2; // Level-2 alarm threshold for high voltage in decivolts
    float minPackThreshold2; // Level-2 alarm threshold for low voltage in decivolts

    // data from 0x90
    float packVoltage; // pressure (0.1 V)
    float packCurrent; // acquisition (0.1 V)
    float packSOC;     // State Of Charge

    // data from 0x91
    float maxCellmV; // maximum monomer voltage (mV)
    int maxCellVNum; // Maximum Unit Voltage cell No.
    float minCellmV; // minimum monomer voltage (mV)
    int minCellVNum; // Minimum Unit Voltage cell No.
    int cellDiff;    // difference betwen cells

    // data from 0x92
    int tempAverage; // Avergae Temperature

    // data from 0x93
    // In C, const char* is used for string literals, but for status, an int or enum might be more appropriate.
    // For simplicity, keeping it as const char* and assuming it points to a string literal.
    const char *chargeDischargeStatus; // charge/discharge status (0 stationary ,1 charge ,2 discharge)
    bool chargeFetState;               // charging MOS tube status
    bool disChargeFetState;            // discharge MOS tube state
    int bmsHeartBeat;                  // BMS life(0~255 cycles)
    float resCapacityAh;               // residual capacity mAH

    // data from 0x94
    unsigned int numberOfCells;    // amount of cells
    unsigned int numOfTempSensors; // amount of temp sensors
    bool chargeState;              // charger status 0=disconnected 1=connected
    bool loadState;                // Load Status 0=disconnected 1=connected
    bool dIO[8];                   // No information about this
    int bmsCycles;                 // charge / discharge cycles

    // data from 0x95
    float cellVmV[48]; // Store Cell Voltages in mV

    // data from 0x96
    int cellTemperature[16]; // array of cell Temperature sensors

    // data from 0x97
    bool cellBalanceState[48]; // bool array of cell balance states
    bool cellBalanceActive;    // bool is cell balance active

    // get a state of the connection
    bool connectionState;

} DalyBmsData;

// Define the DalyBms structure (replaces the class in C++)
typedef struct DalyBms
{
    unsigned long previousTime;
    uint8_t requestCounter;
    int soft_tx;
    int soft_rx;
    // In C, String is not available. Use char arrays or dynamically allocated strings if needed.
    // For failure codes, you might want to represent them as an array of bytes or an integer.
    char failCodeArr[32]; // Example fixed-size buffer for failCodeArr

    DalyBmsData get;

    // Private members from C++ class are now part of the struct,
    // but their "private" nature is by convention or through encapsulation
    // via functions in C.
    bool getStaticData;
    unsigned int errorCounter;
    unsigned int requestCount;
    unsigned int commandQueue[5]; // Stores DALY_BMS_COMMAND values

    // SoftwareSerial *my_serialIntf; // Replaced with a generic void* or a specific serial port handle
    void *serial_handle; // Generic handle for serial communication

    uint8_t my_txBuffer[XFER_BUFFER_LENGTH];
    uint8_t my_rxBuffer[XFER_BUFFER_LENGTH];
    uint8_t my_rxFrameBuffer[XFER_BUFFER_LENGTH*12];
    uint8_t frameBuff[12][XFER_BUFFER_LENGTH];
    unsigned int frameCount;

    // Function pointer for the callback (replaces std::function<void()> func)
    void (*requestCallback)(void);

} DalyBms;

// Function prototypes (replaces member functions)

// Global BMS instance
extern DalyBms bms;

/**
 * @brief Initialize BMS module and UART1 communication
 * @param bms Pointer to the DalyBms object
 */
void DalyBms_Init(DalyBms* bms);

// Logging function
extern void writeLog(const char* format, ...);

/**
 * @brief put it in loop
 * @param bms Pointer to the DalyBms object
 * @return True if successful, false otherwise
 */
bool DalyBms_update(DalyBms* bms);

/**
 * @brief Update BMS data using sequential command calls with DalyBms_sendCommand
 * @details This function calls DalyBms_sendCommand directly in a sequential loop
 * to continuously fetch data from the BMS. It processes all commands in order:
 * 0x90, 0x91, 0x92, 0x93, 0x94, 0x95, 0x96, 0x97, 0x98, 0x59, 0x5A
 * @param bms Pointer to the DalyBms object
 * @return True if successful, false otherwise
 */
bool DalyBms_updateSequential(DalyBms* bms);

/**
 * @brief callback function
 * @param bms Pointer to the DalyBms object
 * @param func Function pointer to the callback function
 */
void DalyBms_set_callback(DalyBms* bms, void (*func)(void));

/**
 * @brief Gets Voltage, Current, and SOC measurements from the BMS
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getPackMeasurements(DalyBms* bms);

/**
 * @brief Gets Voltage thresholds
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getVoltageThreshold(DalyBms* bms);

/**
 * @brief Gets pack voltage thresholds
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getPackVoltageThreshold(DalyBms* bms);

/**
 * @brief Gets the pack temperature from the min and max of all the available temperature sensors
 * @details Populates tempMax, tempMax, and tempAverage in the "get" struct
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getPackTemp(DalyBms* bms);

/**
 * @brief Returns the highest and lowest individual cell voltage, and which cell is highest/lowest
 * @details Voltages are returned as floats with milliVolt precision (3 decimal places)
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getMinMaxCellVoltage(DalyBms* bms);

/**
 * @brief Get the general Status Info
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getStatusInfo(DalyBms* bms);

/**
 * @brief Get Cell Voltages
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getCellVoltages(DalyBms* bms);

/**
 * @brief Each temperature accounts for 1 byte, according to the actual number of temperature send, the maximum 21 byte, send in 3 frames Byte0:frame number, starting at 0 Byte1~byte7:cell temperature(40 Offset ,℃)
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getCellTemperature(DalyBms* bms);

/**
 * @brief 0： Closed 1： Open Bit0: Cell 1 balance state ... Bit47:Cell 48 balance state Bit48~Bit63：reserved
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getCellBalanceState(DalyBms* bms);

/**
 * @brief Get the Failure Codes
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getFailureCodes(DalyBms* bms);

/**
 * @brief set the Discharging MOS State
 * @param bms Pointer to the DalyBms object
 * @param sw Switch state (true for on, false for off)
 * @return True on successful setting, false otherwise
 */
bool DalyBms_setDischargeMOS(DalyBms* bms, bool sw);

/**
 * @brief set the Charging MOS State
 * @param bms Pointer to the DalyBms object
 * @param sw Switch state (true for on, false for off)
 * @return True on successful setting, false otherwise
 */
bool DalyBms_setChargeMOS(DalyBms* bms, bool sw);

/**
 * @brief set the SOC
 * @param bms Pointer to the DalyBms object
 * @param sw SOC value to set
 * @return True on successful setting, false otherwise
 */
bool DalyBms_setSOC(DalyBms* bms, float sw);

/**
 * @brief Read the charge and discharge MOS States
 * @param bms Pointer to the DalyBms object
 * @return True on successful acquisition, false otherwise
 */
bool DalyBms_getDischargeChargeMosStatus(DalyBms* bms);

/**
 * @brief Reseting The BMS
 * @details Reseting the BMS and let it restart
 * @param bms Pointer to the DalyBms object
 * @return True on successful reset, false otherwise
 */
bool DalyBms_setBmsReset(DalyBms* bms);

/**
 * @brief return the state of connection to the BMS
 * @details returns the following value for different connection state
 * -3 - could not open serial port
 * -2 - no data recived or wrong crc, check connection
 * -1 - working and collecting data, please wait
 * 0 - All data recived with correct crc, idleing
 * now changed to bool, only true if data avaible, false when no connection
 * @param bms Pointer to the DalyBms object
 * @return True if connection is active and data is available, false otherwise
 */
bool DalyBms_getState(DalyBms* bms);

// UART1 BMS Communication function prototypes
// These functions are provided by the UART1 module (uart1.h)
// and are used by the BMS module for communication with Daly BMS

// Mock implementation for millis() for environments without it
unsigned long current_millis(void);

// Private helper function prototypes (conventionally prefixed with DalyBms_)
static bool DalyBms_requestData(DalyBms* bms, DALY_BMS_COMMAND cmdID, unsigned int frameAmount);
static bool DalyBms_sendCommand(DalyBms* bms, DALY_BMS_COMMAND cmdID);
static bool DalyBms_sendQueueAdd(DalyBms* bms, DALY_BMS_COMMAND cmdID);
static bool DalyBms_receiveBytes(DalyBms* bms);
static bool DalyBms_validateChecksum(DalyBms* bms);
static void DalyBms_barfRXBuffer(DalyBms* bms);
static void DalyBms_clearGet(DalyBms* bms);

#endif // BMS_H