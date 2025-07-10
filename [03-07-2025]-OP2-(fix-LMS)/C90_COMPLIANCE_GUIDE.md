# Hướng dẫn tuân thủ chuẩn C90 cho mikroC

## Tổng quan

Chuẩn C90 (ANSI C) có một số hạn chế quan trọng mà mikroC compiler yêu cầu tuân thủ. Tài liệu này liệt kê các quy tắc và cách tuân thủ.

## Các quy tắc C90 quan trọng

### 1. Khai báo biến

#### ❌ Không được phép (C99+):
```c
void function() {
    int i;
    for(int j = 0; j < 10; j++) {  // Khai báo trong for - C99
        // code
    }
    
    int value = 5;  // Khởi tạo trong khai báo
    // code
}
```

#### ✅ Được phép (C90):
```c
void function() {
    int i;
    int j;
    int value;
    
    value = 5;  // Khởi tạo riêng
    
    for(j = 0; j < 10; j++) {  // Khai báo trước for
        // code
    }
}
```

### 2. Khai báo biến trong vòng lặp

#### ❌ Không được phép:
```c
for(int i = 0; i < 10; i++) {  // C99 syntax
    // code
}
```

#### ✅ Được phép:
```c
int i;
for(i = 0; i < 10; i++) {  // C90 syntax
    // code
}
```

### 3. Khởi tạo biến

#### ❌ Không được phép:
```c
int value = 0;  // Khởi tạo trong khai báo
char *str = "hello";  // Khởi tạo trong khai báo
```

#### ✅ Được phép:
```c
int value;
char *str;
value = 0;  // Khởi tạo riêng
str = "hello";  // Gán riêng
```

### 4. Khai báo biến trong struct

#### ✅ Được phép:
```c
typedef struct {
    int x;
    int y;
    char name[20];
} Point;
```

### 5. Function prototypes

#### ✅ Bắt buộc:
```c
// Khai báo prototype trước khi sử dụng
void function1(void);
int function2(int param);
```

## Các vi phạm thường gặp

### 1. Khai báo biến trong for loop
```c
// ❌ Sai
for(int i = 0; i < 10; i++) { }

// ✅ Đúng
int i;
for(i = 0; i < 10; i++) { }
```

### 2. Khởi tạo trong khai báo
```c
// ❌ Sai
int value = 0;
char buffer[10] = {0};

// ✅ Đúng
int value;
char buffer[10];
value = 0;
memset(buffer, 0, sizeof(buffer));
```

### 3. Khai báo biến ở giữa function
```c
// ❌ Sai
void function() {
    int a = 1;
    // code
    int b = 2;  // Khai báo ở giữa
}

// ✅ Đúng
void function() {
    int a;
    int b;
    a = 1;
    // code
    b = 2;
}
```

## Quy tắc cho mikroC

### 1. Khai báo biến
- Tất cả biến phải được khai báo ở đầu function
- Không được khai báo biến ở giữa function
- Không được khởi tạo trong khai báo

### 2. Vòng lặp
- Biến vòng lặp phải được khai báo trước
- Không được khai báo biến trong for()

### 3. Struct và Union
- Phải khai báo đầy đủ các thành viên
- Không được có flexible array members

### 4. Function
- Phải có prototype cho tất cả function
- Không được có inline functions
- Không được có variadic macros

## Kiểm tra C90 Compliance

### 1. Compiler Warnings
```bash
# Kiểm tra với strict C90 mode
mikroC -std=c90 -Wall -Wextra -Werror
```

### 2. Common Issues
- `error: 'for' loop initial declarations are only allowed in C99 mode`
- `error: mixed declarations and code`
- `error: variable length array`

### 3. Fixes
```c
// ❌ Before
void function() {
    for(int i = 0; i < 10; i++) {
        int value = i * 2;
        // code
    }
}

// ✅ After
void function() {
    int i;
    int value;
    
    for(i = 0; i < 10; i++) {
        value = i * 2;
        // code
    }
}
```

## Best Practices

### 1. Code Organization
```c
void function(void) {
    // 1. Khai báo tất cả biến
    int i;
    int j;
    char buffer[100];
    
    // 2. Khởi tạo biến
    i = 0;
    j = 0;
    memset(buffer, 0, sizeof(buffer));
    
    // 3. Logic chính
    for(i = 0; i < 10; i++) {
        // code
    }
}
```

### 2. Function Prototypes
```c
// Header file
#ifndef MODULE_H
#define MODULE_H

// Prototypes
void function1(void);
int function2(int param);
void function3(char *str);

#endif
```

### 3. Struct Definitions
```c
typedef struct {
    int id;
    char name[50];
    float value;
} MyStruct;
```

## Lưu ý đặc biệt cho mikroC

### 1. Hardware Registers
```c
// ✅ Đúng cách truy cập register
TRISAbits.TRISA0 = 1;
LATAbits.LATA0 = 1;
```

### 2. Interrupt Functions
```c
// ✅ Đúng syntax cho ISR
void interrupt() iv IVT_ADDR_U1RXINTERRUPT ics ICS_AUTO {
    // ISR code
}
```

### 3. Delay Functions
```c
// ✅ Đúng tên function mikroC
Delay_ms(100);
Delay_us(50);
```

## Tóm tắt

1. **Khai báo biến**: Chỉ ở đầu function
2. **Khởi tạo**: Tách riêng khỏi khai báo
3. **Vòng lặp**: Khai báo biến trước for()
4. **Prototypes**: Bắt buộc cho tất cả function
5. **Struct**: Khai báo đầy đủ thành viên

Tuân thủ các quy tắc này sẽ đảm bảo code tương thích với mikroC compiler và chuẩn C90. 