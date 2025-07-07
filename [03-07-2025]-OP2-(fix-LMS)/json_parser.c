#include "json_parser.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "robot_system.h"

/*
   Luu �:
   - Do mikroC s? d?ng ki?u int cho strlen() n�n bi?n li�n quan d?n d? d�i v� offset du?c khai b�o du?i d?ng int.
   - DebugUART_Send_Text() du?c s? d?ng d? in th�ng b�o debug qua UART.
   - Ch�ng ta �p ki?u (char *) cho parser->json v� key khi g?i c�c h�m chu?i d? tr�nh c?nh b�o chuy?n d?i.
*/

/* Kh?i t?o JSON_Parser v?i chu?i JSON d?u v�o */
void JSON_Init(JSON_Parser *parser, const char *json) {
    if (parser == NULL) {
        DebugUART_Send_Text("JSON_Init: parser is NULL\n");
        return;
    }
    if (json == NULL) {
        DebugUART_Send_Text("JSON_Init: json string is NULL\n");
        return;
    }
    parser->json = json;
}

/* L?y gi� tr? s? nguy�n t? JSON v?i key cho tru?c */
int JSON_GetInt(JSON_Parser *parser, const char *key, int *value) {
    char *_pos;
    int json_len;
    int offset = 0;       // Bi?n d?m s? bu?c d� duy?t
    int key_len;

    if (!parser || !parser->json) {
        DebugUART_Send_Text("JSON_GetInt: parser or parser->json is NULL\n");
        return 0;
    }
    json_len = strlen((char *)parser->json);   // �p ki?u v� mikroC kh�ng d�ng const
    _pos = strstr((char *)parser->json, key);
    if (!_pos) {
        DebugUART_Send_Text("JSON_GetInt: key not found\n");
        return 0;
    }
    key_len = strlen(key);
    _pos += key_len;
    offset += key_len;
    while (*_pos && *_pos != ':' && offset < json_len) {
        _pos++;
        offset++;
    }
    if (offset >= json_len || *_pos != ':') {
        DebugUART_Send_Text("JSON_GetInt: ':' not found after key\n");
        return 0;
    }
    _pos++;
    offset++;
    while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
        _pos++;
        offset++;
    }
    *value = atoi(_pos);
  //  DebugUART_Send_Text("JSON_GetInt: value parsed successfully\n");
    return 1;
}

/* Ki?m tra s? t?n t?i c?a key trong JSON */
int JSON_ContainsKey(JSON_Parser *parser, const char *key) {
    if (!parser || !parser->json)
        return 0;
    return strstr((char *)parser->json, key) != NULL;
}

/* L?y gi� tr? chu?i t? JSON v?i key cho tru?c.
   out_size l� k�ch thu?c c?a buffer out (ki?u size_t theo d?nh nghia trong json_parser.h) */
int JSON_GetString(JSON_Parser *parser, const char *key, char *out, size_t out_size) {
    char *_pos;
    char *_start;
    int json_len, offset = 0;
    int key_len;
    int copy_len;

    if (!parser || !parser->json) {
        DebugUART_Send_Text("JSON_GetString: parser or parser->json is NULL\n");
        return 0;
    }
    if (!key) {
        DebugUART_Send_Text("JSON_GetString: key is NULL\n");
        return 0;
    }
    if (!out || out_size == 0) {
        DebugUART_Send_Text("JSON_GetString: invalid output buffer\n");
        return 0;
    }
    json_len = strlen((char *)parser->json);
    if (json_len <= 0) {
        DebugUART_Send_Text("JSON_GetString: empty JSON\n");
        return 0;
    }
    _pos = strstr((char *)parser->json, key);
    if (!_pos) {
        DebugUART_Send_Text("JSON_GetString: key not found in JSON\n");
        return 0;
    }
    key_len = strlen(key);
    _pos += key_len;
    offset += key_len;
    while (*_pos && *_pos != ':' && offset < json_len) {
        _pos++;
        offset++;
    }
    if (offset >= json_len || *_pos != ':') {
        DebugUART_Send_Text("JSON_GetString: ':' not found after key\n");
        return 0;
    }
    _pos++;
    offset++;
    while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
        _pos++;
        offset++;
    }
    if (*_pos != '\"') {
        DebugUART_Send_Text("JSON_GetString: opening '\"' not found\n");
        return 0;
    }
    _pos++;
    offset++;
    _start = _pos;
    while (*_pos && *_pos != '\"' && offset < json_len) {
        _pos++;
        offset++;
    }
    if (offset >= json_len || *_pos != '\"') {
        DebugUART_Send_Text("JSON_GetString: closing '\"' not found, potential infinite loop detected\n");
        return 0;
    }
    copy_len = _pos - _start;
    if (copy_len >= (int)out_size) {
        copy_len = (int)out_size - 1;
        DebugUART_Send_Text("JSON_GetString: output buffer too small, truncating result\n");
    }
    strncpy(out, _start, copy_len);
    out[copy_len] = '\0';
    //DebugUART_Send_Text("JSON_GetString: string parsed successfully\n");
    return 1;
}

/* L?y object JSON (du?i d?ng chu?i) v?i key cho tru?c */
int JSON_GetObject(JSON_Parser *parser, const char *key, char *out, size_t out_size) {
    char *_pos;
    char *_start;
    int _brace_count;
    int json_len, offset = 0;
    int copy_len;

    if (!parser || !parser->json) {
        DebugUART_Send_Text("JSON_GetObject: parser or parser->json is NULL\n");
        return 0;
    }
    if (!key) {
        DebugUART_Send_Text("JSON_GetObject: key is NULL\n");
        return 0;
    }
    if (!out || out_size == 0) {
        DebugUART_Send_Text("JSON_GetObject: invalid output buffer\n");
        return 0;
    }
    json_len = strlen((char *)parser->json);
    _pos = strstr((char *)parser->json, key);
    if (!_pos) {
        DebugUART_Send_Text("JSON_GetObject: key not found\n");
        return 0;
    }
    _pos += strlen(key);
    offset += strlen(key);
    while (*_pos && *_pos != ':' && offset < json_len) {
        _pos++;
        offset++;
    }
    if (offset >= json_len || *_pos != ':') {
        DebugUART_Send_Text("JSON_GetObject: ':' not found after key\n");
        return 0;
    }
    _pos++;
    offset++;
    while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
        _pos++;
        offset++;
    }
    if (*_pos != '{') {
        DebugUART_Send_Text("JSON_GetObject: '{' not found after key\n");
        return 0;
    }
    _start = _pos;
    _brace_count = 0;
    while (*_pos && offset < json_len) {
        if (*_pos == '{') {
            _brace_count++;
        } else if (*_pos == '}') {
            _brace_count--;
            if (_brace_count == 0) {
                _pos++;  // Bao g?m d?u '}'
                offset++;
                break;
            }
        }
        _pos++;
        offset++;
    }
    if (offset >= json_len || _brace_count != 0) {
        DebugUART_Send_Text("JSON_GetObject: Unmatched braces detected or infinite loop risk\n");
        return 0;
    }
    copy_len = _pos - _start;
    if (copy_len >= (int)out_size) {
        copy_len = (int)out_size - 1;
        DebugUART_Send_Text("JSON_GetObject: output buffer too small, truncating result\n");
    }
    strncpy(out, _start, copy_len);
    out[copy_len] = '\0';
   // DebugUART_Send_Text("JSON_GetObject: object parsed successfully\n");
    return 1;
}
