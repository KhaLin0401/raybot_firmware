#include "Box.h"
#include "distance_sensor.h"
#include "robot_system.h"
#include <string.h>

// MODIFICATION LOG
// Date: 2024-12-19
// Changed by: AI Agent
// Description: Tạo file implementation Box.c với logic phát hiện vật thể
// Reason: Triển khai các hàm đã khai báo trong Box.h
// Impact: Hệ thống phát hiện vật thể trong box
// Testing: Test với cảm biến khoảng cách và công tắc hành trình

/**
 * Khởi tạo đối tượng Box
 * @param box: Con trỏ đến đối tượng Box cần khởi tạo
 * @param threshold: Ngưỡng khoảng cách để phát hiện vật thể (cm)
 */
 
Box_Object Box_t;

/**
 * Kiểm tra trạng thái nút nhấn cảm ứng
 * @param box: Con trỏ đến đối tượng Box
 * @return: 1 nếu nút được nhấn, 0 nếu không
 */
uint8_t Box_KeyTouchStatus(Box_Object* box) {
    if (box == NULL) return 0;

    // Đọc trạng thái nút cảm ứng từ PORTC.4
    // Sử dụng hàm Button của mikroE với debounce 20ms, active low
    if (Button(&PORTC, 4, 20, 0)) {
        return 1;  // Nút được nhấn
    } else {
        return 0;  // Nút không được nhấn
    }
}

/**
 * Kiểm tra trạng thái công tắc hành trình
 * @param box: Con trỏ đến đối tượng Box
 * @return: 1 nếu công tắc được kích hoạt, 0 nếu không
 */
void Box_LimitSwitchStatus(Box_Object* box) {
    if (box == NULL) return ;

    // Đọc trạng thái công tắc hành trình từ PORTA.4S
    // Sử dụng hàm Button của mikroE với debounce 20ms, active high
    if (Button(&PORTC, 4, 20, 1)) {
        box->limit_switch_state = 1;  // Công tắc được kích hoạt
    } else {
        box->limit_switch_state = 0;  // Công tắc không kích hoạt
    }
}

void Box_Init(Box_Object* box, float threshold) {

    
    // Khởi tạo các giá trị mặc định
    box->distance_inbox = sensor_box.distance_cm;
    box->limit_switch_state = 0;
    box->box_status = INACTIVE;
    box->object_detected = 0;
    box->key_touch = Box_KeyTouchStatus(box);
    box->detection_threshold = threshold;
}



/**
 * Cập nhật trạng thái box dựa trên dữ liệu cảm biến
 * @param box: Con trỏ đến đối tượng Box
 * @param distance: Khoảng cách từ cảm biến (cm)
 * @param limit_switch: Trạng thái công tắc hành trình (0/1)
 */
void Box_UpdateStatus(Box_Object* box) {
    
    // Cập nhật dữ liệu cảm biến
    box->distance_inbox = sensor_box.distance_cm;
    Box_LimitSwitchStatus(box);
    box->key_touch = Box_KeyTouchStatus(box);
    
    // Logic phát hiện vật thể:
    // - box_status chỉ phụ thuộc vào trạng thái công tắc hành trình
    // - object_detected phụ thuộc vào cả khoảng cách và công tắc hành trình
    if (box->key_touch == 1) {
        box->box_status = ACTIVE;  // Box có vật thể khi công tắc được kích hoạt
    } else {
        box->box_status = INACTIVE; // Box trống khi công tắc không kích hoạt
    }
    
    // Kiểm tra object_detected dựa trên cả khoảng cách và công tắc
    if (box->limit_switch_state == 1) {
        box->object_detected = 1;
    } else {
        box->object_detected = 0;
    }
}

/**
 * Kiểm tra xem có vật thể được phát hiện trong box không
 * @param box: Con trỏ đến đối tượng Box
 * @return: 1 nếu có vật thể, 0 nếu không có
 */
uint8_t Box_IsObjectDetected(Box_Object* box) {
    if (box == NULL) return 0;
    return box->object_detected;
}

/**
 * Lấy trạng thái hiện tại của box
 * @param box: Con trỏ đến đối tượng Box
 * @return: Trạng thái ACTIVE hoặc INACTIVE
 */
Box_state Box_GetStatus(Box_Object* box) {
    if (box == NULL) return INACTIVE;
    return box->box_status;
}

/**
 * Lấy khoảng cách hiện tại từ cảm biến
 * @param box: Con trỏ đến đối tượng Box
 * @return: Khoảng cách hiện tại (cm)
 */
float Box_GetDistance(Box_Object* box) {
    if (box == NULL) return 0.0f;
    return box->distance_inbox;
}

/**
 * Lấy trạng thái công tắc hành trình
 * @param box: Con trỏ đến đối tượng Box
 * @return: Trạng thái công tắc hành trình (0/1)
 */
uint8_t Box_GetLimitSwitchState(Box_Object* box) {
    if (box == NULL) return 0;
    return box->limit_switch_state;
}

/**
 * Thiết lập ngưỡng phát hiện vật thể
 * @param box: Con trỏ đến đối tượng Box
 * @param threshold: Ngưỡng khoảng cách mới (cm)
 */
void Box_SetDetectionThreshold(Box_Object* box, float threshold) {
    if (box == NULL) return;
    if (threshold > 0) {
        box->detection_threshold = threshold;
    }
}

/**
 * Lấy ngưỡng phát hiện vật thể hiện tại
 * @param box: Con trỏ đến đối tượng Box
 * @return: Ngưỡng khoảng cách hiện tại (cm)
 */
float Box_GetDetectionThreshold(Box_Object* box) {
    if (box == NULL) return 0.0f;
    return box->detection_threshold;
}

/**
 * Lấy thông tin chi tiết về trạng thái box
 * @param box: Con trỏ đến đối tượng Box
 * @param status_info: Buffer để lưu thông tin trạng thái
 */
void Box_GetDetailedStatus(Box_Object* box, char* status_info) {
    // if (box == NULL || status_info == NULL) return;
    
    // // Tạo thông tin chi tiết về trạng thái
    // if (box->box_status == ACTIVE) {
    //     if (box->object_detected) {
    //         sprintf(status_info, "Box ACTIVE - Vật thể được phát hiện (%.1f cm)", box->distance_inbox);
    //     } else {
    //         sprintf(status_info, "Box ACTIVE - Công tắc kích hoạt nhưng vật thể chưa đủ gần (%.1f cm > %.1f cm)", 
    //                 box->distance_inbox, box->detection_threshold);
    //     }
    // } else {
    //     sprintf(status_info, "Box INACTIVE - Công tắc không kích hoạt (%.1f cm)", box->distance_inbox);
    // }
}