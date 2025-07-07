#ifndef JSON_PARSER_H
#define JSON_PARSER_H

#include <stddef.h>
#include <stdint.h>

typedef struct {
    const char *json;
} JSON_Parser;

/* Khoi tao parser voi chuoi JSON dau vao */
void JSON_Init(JSON_Parser *parser, const char *json);

/* Lay gia tri so nguyen tu JSON voi key cho truoc.
   Tra ve 1 neu thanh cong, 0 neu khong tim thay. */
int JSON_GetInt(JSON_Parser *parser, const char *key, int *value);

/* Kiem tra su ton tai cua key trong chuoi JSON */
int JSON_ContainsKey(JSON_Parser *parser, const char *key);

/* Lay gia tri chuoi tu JSON voi key cho truoc.
   Ket qua duoc copy vao out (dung luong out_size).
   Tra ve 1 neu thanh cong, 0 neu khong tim thay hoac dinh dang khong hop le. */
int JSON_GetString(JSON_Parser *parser, const char *key, char *out, size_t out_size);

/* Lay object con (duoi dang chuoi) tu JSON voi key cho truoc.
   Vi du: key "data" voi gia tri { ... }.
   Ket qua duoc copy vao out (dung luong out_size).
   Tra ve 1 neu thanh cong, 0 neu khong tim thay hoac dinh dang khong hop le. */
int JSON_GetObject(JSON_Parser *parser, const char *key, char *out, size_t out_size);

#endif /* JSON_PARSER_H */
