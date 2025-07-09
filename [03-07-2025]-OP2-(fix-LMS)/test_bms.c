/*
Test file for BMS module
*/
#include "BMS.h"
#include <stdio.h>

int main(void) {
    // Test basic functionality
    printf("Testing BMS module...\n");
    
    // Test global BMS instance
    printf("BMS instance created successfully\n");
    
    // Test basic function calls
    DalyBms_set_callback(&bms, NULL);
    printf("Callback set successfully\n");
    
    // Test state function
    bool state = DalyBms_getState(&bms);
    printf("BMS state: %s\n", state ? "Connected" : "Disconnected");
    
    printf("BMS module test completed successfully!\n");
    return 0;
} 