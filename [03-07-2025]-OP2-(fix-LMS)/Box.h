#ifndef BOX_H
#define BOX_H

#include <stdint.h>

#define LIMIT_SWITCH_PIN 1
#define DISTANCE_SENSOR_PIN 2
#define DETECTION_THRESHOLD 10.0f

// Định nghĩa trạng thái của box
typedef enum {
    ACTIVE = 1,    // Box có chứa vật thể
    INACTIVE = 0   // Box trống
} Box_state;

// Cấu trúc đối tượng Box
typedef struct {
    float distance_inbox;        // Khoảng cách từ cảm biến đến vật thể (cm)
    uint8_t limit_switch_state;  // Trạng thái công tắc hành trình (0: không kích hoạt, 1: kích hoạt)
    Box_state box_status;        // Trạng thái tổng thể của box
    uint8_t object_detected;     // Cờ báo hiệu có vật thể được phát hiện
    float detection_threshold;
    uint8_t key_touch;           // Trang thai nut nhan cam ung
       // Ngưỡng khoảng cách để phát hiện vật thể (cm)
} Box_Object;

extern Box_Object Box_t;
// Hàm khởi tạo đối tượng Box
void Box_Init(Box_Object* box, float threshold);

// Ham kiem tra trang thai nut nhan cam ung
uint8_t Box_KeyTouchStatus(Box_Object* box);

// Hàm kiểm tra trạng thái công tắc hành trình
void Box_LimitSwitchStatus(Box_Object* box);

// Hàm cập nhật trạng thái box dựa trên cảm biến
void Box_UpdateStatus(Box_Object* box);

// Hàm kiểm tra xem có vật thể trong box không
uint8_t Box_IsObjectDetected(Box_Object* box);

// Hàm lấy trạng thái hiện tại của box
Box_state Box_GetStatus(Box_Object* box);

// Hàm lấy khoảng cách hiện tại
float Box_GetDistance(Box_Object* box);

// Hàm lấy trạng thái công tắc hành trình
uint8_t Box_GetLimitSwitchState(Box_Object* box);

// Hàm thiết lập ngưỡng phát hiện vật thể
void Box_SetDetectionThreshold(Box_Object* box, float threshold);

// Hàm lấy ngưỡng phát hiện vật thể hiện tại
float Box_GetDetectionThreshold(Box_Object* box);

// Hàm lấy thông tin chi tiết về trạng thái box
void Box_GetDetailedStatus(Box_Object* box, char* status_info);

#endif