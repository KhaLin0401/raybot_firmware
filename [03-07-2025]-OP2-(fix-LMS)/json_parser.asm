
_JSON_Init:

;json_parser.c,16 :: 		void JSON_Init(JSON_Parser *parser, const char *json) {
;json_parser.c,17 :: 		if (parser == NULL) {
	PUSH	W10
	CP	W10, #0
	BRA Z	L__JSON_Init151
	GOTO	L_JSON_Init0
L__JSON_Init151:
;json_parser.c,18 :: 		DebugUART_Send_Text("JSON_Init: parser is NULL\n");
	MOV	#lo_addr(?lstr_1_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,19 :: 		return;
	GOTO	L_end_JSON_Init
;json_parser.c,20 :: 		}
L_JSON_Init0:
;json_parser.c,21 :: 		if (json == NULL) {
	CP	W11, #0
	BRA Z	L__JSON_Init152
	GOTO	L_JSON_Init1
L__JSON_Init152:
;json_parser.c,22 :: 		DebugUART_Send_Text("JSON_Init: json string is NULL\n");
	MOV	#lo_addr(?lstr_2_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,23 :: 		return;
	GOTO	L_end_JSON_Init
;json_parser.c,24 :: 		}
L_JSON_Init1:
;json_parser.c,25 :: 		parser->json = json;
	MOV	W11, [W10]
;json_parser.c,26 :: 		}
L_end_JSON_Init:
	POP	W10
	RETURN
; end of _JSON_Init

_JSON_GetInt:

;json_parser.c,29 :: 		int JSON_GetInt(JSON_Parser *parser, const char *key, int *value) {
;json_parser.c,32 :: 		int offset = 0;       // Bi?n d?m s? bu?c dã duy?t
	PUSH	W10
; offset start address is: 6 (W3)
	CLR	W3
;json_parser.c,35 :: 		if (!parser || !parser->json) {
	CP0	W10
	BRA NZ	L__JSON_GetInt154
	GOTO	L__JSON_GetInt86
L__JSON_GetInt154:
	MOV	[W10], W0
	CP0	W0
	BRA NZ	L__JSON_GetInt155
	GOTO	L__JSON_GetInt85
L__JSON_GetInt155:
	GOTO	L_JSON_GetInt4
; offset end address is: 6 (W3)
L__JSON_GetInt86:
L__JSON_GetInt85:
;json_parser.c,36 :: 		DebugUART_Send_Text("JSON_GetInt: parser or parser->json is NULL\n");
	MOV	#lo_addr(?lstr_3_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,37 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetInt
;json_parser.c,38 :: 		}
L_JSON_GetInt4:
;json_parser.c,39 :: 		json_len = strlen((char *)parser->json);   // Ép ki?u vì mikroC không dùng const
; offset start address is: 6 (W3)
	MOV	[W10], W0
	PUSH	W10
	MOV	W0, W10
	CALL	_strlen
	POP	W10
; json_len start address is: 4 (W2)
	MOV	W0, W2
;json_parser.c,40 :: 		_pos = strstr((char *)parser->json, key);
	MOV	[W10], W0
	PUSH	W12
	PUSH	W11
	MOV	W0, W10
	CALL	_strstr
	POP	W11
	POP	W12
; _pos start address is: 8 (W4)
	MOV	W0, W4
;json_parser.c,41 :: 		if (!_pos) {
	CP0	W0
	BRA Z	L__JSON_GetInt156
	GOTO	L_JSON_GetInt5
L__JSON_GetInt156:
; _pos end address is: 8 (W4)
; json_len end address is: 4 (W2)
; offset end address is: 6 (W3)
;json_parser.c,42 :: 		DebugUART_Send_Text("JSON_GetInt: key not found\n");
	MOV	#lo_addr(?lstr_4_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,43 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetInt
;json_parser.c,44 :: 		}
L_JSON_GetInt5:
;json_parser.c,45 :: 		key_len = strlen(key);
; offset start address is: 6 (W3)
; json_len start address is: 4 (W2)
; _pos start address is: 8 (W4)
	MOV	W11, W10
	CALL	_strlen
;json_parser.c,46 :: 		_pos += key_len;
; _pos start address is: 2 (W1)
	ADD	W4, W0, W1
; _pos end address is: 8 (W4)
;json_parser.c,47 :: 		offset += key_len;
	ADD	W3, W0, W3
; _pos end address is: 2 (W1)
; json_len end address is: 4 (W2)
; offset end address is: 6 (W3)
	MOV	W1, W4
;json_parser.c,48 :: 		while (*_pos && *_pos != ':' && offset < json_len) {
L_JSON_GetInt6:
; offset start address is: 6 (W3)
; _pos start address is: 8 (W4)
; json_len start address is: 4 (W2)
	CP0.B	[W4]
	BRA NZ	L__JSON_GetInt157
	GOTO	L__JSON_GetInt89
L__JSON_GetInt157:
	MOV.B	[W4], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__JSON_GetInt158
	GOTO	L__JSON_GetInt88
L__JSON_GetInt158:
	CP	W3, W2
	BRA LT	L__JSON_GetInt159
	GOTO	L__JSON_GetInt87
L__JSON_GetInt159:
L__JSON_GetInt83:
;json_parser.c,49 :: 		_pos++;
	INC	W4
;json_parser.c,50 :: 		offset++;
	INC	W3
;json_parser.c,51 :: 		}
	GOTO	L_JSON_GetInt6
;json_parser.c,48 :: 		while (*_pos && *_pos != ':' && offset < json_len) {
L__JSON_GetInt89:
L__JSON_GetInt88:
L__JSON_GetInt87:
;json_parser.c,52 :: 		if (offset >= json_len || *_pos != ':') {
	CP	W3, W2
	BRA LT	L__JSON_GetInt160
	GOTO	L__JSON_GetInt91
L__JSON_GetInt160:
	MOV.B	[W4], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__JSON_GetInt161
	GOTO	L__JSON_GetInt90
L__JSON_GetInt161:
	GOTO	L_JSON_GetInt12
; _pos end address is: 8 (W4)
; json_len end address is: 4 (W2)
; offset end address is: 6 (W3)
L__JSON_GetInt91:
L__JSON_GetInt90:
;json_parser.c,53 :: 		DebugUART_Send_Text("JSON_GetInt: ':' not found after key\n");
	PUSH	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_5_json_parser), W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP	W12
;json_parser.c,54 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetInt
;json_parser.c,55 :: 		}
L_JSON_GetInt12:
;json_parser.c,56 :: 		_pos++;
; offset start address is: 6 (W3)
; json_len start address is: 4 (W2)
; _pos start address is: 0 (W0)
; _pos start address is: 8 (W4)
	ADD	W4, #1, W0
; _pos end address is: 8 (W4)
;json_parser.c,57 :: 		offset++;
	INC	W3
; _pos end address is: 0 (W0)
; offset end address is: 6 (W3)
	MOV	W0, W6
;json_parser.c,58 :: 		while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
L_JSON_GetInt13:
; offset start address is: 6 (W3)
; _pos start address is: 12 (W6)
; json_len start address is: 4 (W2)
; json_len end address is: 4 (W2)
	CP0.B	[W6]
	BRA NZ	L__JSON_GetInt162
	GOTO	L__JSON_GetInt94
L__JSON_GetInt162:
; json_len end address is: 4 (W2)
; json_len start address is: 4 (W2)
	PUSH	W10
	MOV.B	[W6], W10
	CALL	_isspace
	POP	W10
	CP0	W0
	BRA NZ	L__JSON_GetInt163
	GOTO	L__JSON_GetInt93
L__JSON_GetInt163:
	CP	W3, W2
	BRA LT	L__JSON_GetInt164
	GOTO	L__JSON_GetInt92
L__JSON_GetInt164:
L__JSON_GetInt81:
;json_parser.c,59 :: 		_pos++;
	INC	W6
;json_parser.c,60 :: 		offset++;
	INC	W3
;json_parser.c,61 :: 		}
; json_len end address is: 4 (W2)
; offset end address is: 6 (W3)
	GOTO	L_JSON_GetInt13
;json_parser.c,58 :: 		while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
L__JSON_GetInt94:
L__JSON_GetInt93:
L__JSON_GetInt92:
;json_parser.c,62 :: 		*value = atoi(_pos);
	PUSH	W10
; _pos end address is: 12 (W6)
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, [W12]
;json_parser.c,64 :: 		return 1;
	MOV	#1, W0
;json_parser.c,65 :: 		}
;json_parser.c,64 :: 		return 1;
;json_parser.c,65 :: 		}
L_end_JSON_GetInt:
	POP	W10
	RETURN
; end of _JSON_GetInt

_JSON_ContainsKey:

;json_parser.c,68 :: 		int JSON_ContainsKey(JSON_Parser *parser, const char *key) {
;json_parser.c,69 :: 		if (!parser || !parser->json)
	PUSH	W10
	CP0	W10
	BRA NZ	L__JSON_ContainsKey166
	GOTO	L__JSON_ContainsKey97
L__JSON_ContainsKey166:
	MOV	[W10], W0
	CP0	W0
	BRA NZ	L__JSON_ContainsKey167
	GOTO	L__JSON_ContainsKey96
L__JSON_ContainsKey167:
	GOTO	L_JSON_ContainsKey19
L__JSON_ContainsKey97:
L__JSON_ContainsKey96:
;json_parser.c,70 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_ContainsKey
L_JSON_ContainsKey19:
;json_parser.c,71 :: 		return strstr((char *)parser->json, key) != NULL;
	MOV	[W10], W0
	MOV	W0, W10
	CALL	_strstr
	CP	W0, #0
	CLR.B	W0
	BRA Z	L__JSON_ContainsKey168
	INC.B	W0
L__JSON_ContainsKey168:
	ZE	W0, W0
;json_parser.c,72 :: 		}
;json_parser.c,71 :: 		return strstr((char *)parser->json, key) != NULL;
;json_parser.c,72 :: 		}
L_end_JSON_ContainsKey:
	POP	W10
	RETURN
; end of _JSON_ContainsKey

_JSON_GetString:

;json_parser.c,76 :: 		int JSON_GetString(JSON_Parser *parser, const char *key, char *out, size_t out_size) {
;json_parser.c,79 :: 		int json_len, offset = 0;
	PUSH	W10
; offset start address is: 6 (W3)
	CLR	W3
;json_parser.c,83 :: 		if (!parser || !parser->json) {
	CP0	W10
	BRA NZ	L__JSON_GetString170
	GOTO	L__JSON_GetString106
L__JSON_GetString170:
	MOV	[W10], W0
	CP0	W0
	BRA NZ	L__JSON_GetString171
	GOTO	L__JSON_GetString105
L__JSON_GetString171:
	GOTO	L_JSON_GetString22
; offset end address is: 6 (W3)
L__JSON_GetString106:
L__JSON_GetString105:
;json_parser.c,84 :: 		DebugUART_Send_Text("JSON_GetString: parser or parser->json is NULL\n");
	MOV	#lo_addr(?lstr_6_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,85 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,86 :: 		}
L_JSON_GetString22:
;json_parser.c,87 :: 		if (!key) {
; offset start address is: 6 (W3)
	CP0	W11
	BRA Z	L__JSON_GetString172
	GOTO	L_JSON_GetString23
L__JSON_GetString172:
; offset end address is: 6 (W3)
;json_parser.c,88 :: 		DebugUART_Send_Text("JSON_GetString: key is NULL\n");
	MOV	#lo_addr(?lstr_7_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,89 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,90 :: 		}
L_JSON_GetString23:
;json_parser.c,91 :: 		if (!out || out_size == 0) {
; offset start address is: 6 (W3)
	CP0	W12
	BRA NZ	L__JSON_GetString173
	GOTO	L__JSON_GetString108
L__JSON_GetString173:
	CP	W13, #0
	BRA NZ	L__JSON_GetString174
	GOTO	L__JSON_GetString107
L__JSON_GetString174:
	GOTO	L_JSON_GetString26
; offset end address is: 6 (W3)
L__JSON_GetString108:
L__JSON_GetString107:
;json_parser.c,92 :: 		DebugUART_Send_Text("JSON_GetString: invalid output buffer\n");
	MOV	#lo_addr(?lstr_8_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,93 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,94 :: 		}
L_JSON_GetString26:
;json_parser.c,95 :: 		json_len = strlen((char *)parser->json);
; offset start address is: 6 (W3)
	MOV	[W10], W0
	PUSH	W10
	MOV	W0, W10
	CALL	_strlen
	POP	W10
; json_len start address is: 4 (W2)
	MOV	W0, W2
;json_parser.c,96 :: 		if (json_len <= 0) {
	CP	W0, #0
	BRA LE	L__JSON_GetString175
	GOTO	L_JSON_GetString27
L__JSON_GetString175:
; json_len end address is: 4 (W2)
; offset end address is: 6 (W3)
;json_parser.c,97 :: 		DebugUART_Send_Text("JSON_GetString: empty JSON\n");
	MOV	#lo_addr(?lstr_9_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,98 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,99 :: 		}
L_JSON_GetString27:
;json_parser.c,100 :: 		_pos = strstr((char *)parser->json, key);
; offset start address is: 6 (W3)
; json_len start address is: 4 (W2)
	MOV	[W10], W0
	PUSH	W12
	PUSH	W11
	MOV	W0, W10
	CALL	_strstr
	POP	W11
	POP	W12
; _pos start address is: 8 (W4)
	MOV	W0, W4
;json_parser.c,101 :: 		if (!_pos) {
	CP0	W0
	BRA Z	L__JSON_GetString176
	GOTO	L_JSON_GetString28
L__JSON_GetString176:
; json_len end address is: 4 (W2)
; _pos end address is: 8 (W4)
; offset end address is: 6 (W3)
;json_parser.c,102 :: 		DebugUART_Send_Text("JSON_GetString: key not found in JSON\n");
	MOV	#lo_addr(?lstr_10_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,103 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,104 :: 		}
L_JSON_GetString28:
;json_parser.c,105 :: 		key_len = strlen(key);
; offset start address is: 6 (W3)
; _pos start address is: 8 (W4)
; json_len start address is: 4 (W2)
	MOV	W11, W10
	CALL	_strlen
;json_parser.c,106 :: 		_pos += key_len;
; _pos start address is: 2 (W1)
	ADD	W4, W0, W1
; _pos end address is: 8 (W4)
;json_parser.c,107 :: 		offset += key_len;
	ADD	W3, W0, W3
; json_len end address is: 4 (W2)
; offset end address is: 6 (W3)
; _pos end address is: 2 (W1)
	MOV	W1, W4
;json_parser.c,108 :: 		while (*_pos && *_pos != ':' && offset < json_len) {
L_JSON_GetString29:
; offset start address is: 6 (W3)
; _pos start address is: 8 (W4)
; json_len start address is: 4 (W2)
	CP0.B	[W4]
	BRA NZ	L__JSON_GetString177
	GOTO	L__JSON_GetString111
L__JSON_GetString177:
	MOV.B	[W4], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__JSON_GetString178
	GOTO	L__JSON_GetString110
L__JSON_GetString178:
	CP	W3, W2
	BRA LT	L__JSON_GetString179
	GOTO	L__JSON_GetString109
L__JSON_GetString179:
L__JSON_GetString102:
;json_parser.c,109 :: 		_pos++;
	INC	W4
;json_parser.c,110 :: 		offset++;
	INC	W3
;json_parser.c,111 :: 		}
	GOTO	L_JSON_GetString29
;json_parser.c,108 :: 		while (*_pos && *_pos != ':' && offset < json_len) {
L__JSON_GetString111:
L__JSON_GetString110:
L__JSON_GetString109:
;json_parser.c,112 :: 		if (offset >= json_len || *_pos != ':') {
	CP	W3, W2
	BRA LT	L__JSON_GetString180
	GOTO	L__JSON_GetString113
L__JSON_GetString180:
	MOV.B	[W4], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__JSON_GetString181
	GOTO	L__JSON_GetString112
L__JSON_GetString181:
	GOTO	L_JSON_GetString35
; json_len end address is: 4 (W2)
; _pos end address is: 8 (W4)
; offset end address is: 6 (W3)
L__JSON_GetString113:
L__JSON_GetString112:
;json_parser.c,113 :: 		DebugUART_Send_Text("JSON_GetString: ':' not found after key\n");
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_11_json_parser), W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP.D	W12
;json_parser.c,114 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,115 :: 		}
L_JSON_GetString35:
;json_parser.c,116 :: 		_pos++;
; offset start address is: 6 (W3)
; _pos start address is: 8 (W4)
; json_len start address is: 4 (W2)
	INC	W4
;json_parser.c,117 :: 		offset++;
	INC	W3
; json_len end address is: 4 (W2)
; _pos end address is: 8 (W4)
; offset end address is: 6 (W3)
;json_parser.c,118 :: 		while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
L_JSON_GetString36:
; offset start address is: 6 (W3)
; _pos start address is: 8 (W4)
; json_len start address is: 4 (W2)
	CP0.B	[W4]
	BRA NZ	L__JSON_GetString182
	GOTO	L__JSON_GetString116
L__JSON_GetString182:
	PUSH	W10
	MOV.B	[W4], W10
	CALL	_isspace
	POP	W10
	CP0	W0
	BRA NZ	L__JSON_GetString183
	GOTO	L__JSON_GetString115
L__JSON_GetString183:
	CP	W3, W2
	BRA LT	L__JSON_GetString184
	GOTO	L__JSON_GetString114
L__JSON_GetString184:
L__JSON_GetString100:
;json_parser.c,119 :: 		_pos++;
	INC	W4
;json_parser.c,120 :: 		offset++;
	INC	W3
;json_parser.c,121 :: 		}
	GOTO	L_JSON_GetString36
;json_parser.c,118 :: 		while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
L__JSON_GetString116:
L__JSON_GetString115:
L__JSON_GetString114:
;json_parser.c,122 :: 		if (*_pos != '\"') {
	MOV.B	[W4], W1
	MOV.B	#34, W0
	CP.B	W1, W0
	BRA NZ	L__JSON_GetString185
	GOTO	L_JSON_GetString40
L__JSON_GetString185:
; json_len end address is: 4 (W2)
; _pos end address is: 8 (W4)
; offset end address is: 6 (W3)
;json_parser.c,123 :: 		DebugUART_Send_Text("JSON_GetString: opening '\"' not found\n");
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_12_json_parser), W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP.D	W12
;json_parser.c,124 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,125 :: 		}
L_JSON_GetString40:
;json_parser.c,126 :: 		_pos++;
; offset start address is: 6 (W3)
; _pos start address is: 8 (W4)
; json_len start address is: 4 (W2)
	ADD	W4, #1, W0
; _pos end address is: 8 (W4)
; _pos start address is: 2 (W1)
	MOV	W0, W1
;json_parser.c,127 :: 		offset++;
; offset start address is: 8 (W4)
	ADD	W3, #1, W4
; offset end address is: 6 (W3)
;json_parser.c,128 :: 		_start = _pos;
; _start start address is: 6 (W3)
	MOV	W0, W3
; json_len end address is: 4 (W2)
; _pos end address is: 2 (W1)
; _start end address is: 6 (W3)
; offset end address is: 8 (W4)
	PUSH	W3
	MOV	W2, W3
	MOV	W1, W5
	POP	W2
;json_parser.c,129 :: 		while (*_pos && *_pos != '\"' && offset < json_len) {
L_JSON_GetString41:
; _start start address is: 4 (W2)
; offset start address is: 8 (W4)
; _pos start address is: 10 (W5)
; json_len start address is: 6 (W3)
	CP0.B	[W5]
	BRA NZ	L__JSON_GetString186
	GOTO	L__JSON_GetString119
L__JSON_GetString186:
	MOV.B	[W5], W1
	MOV.B	#34, W0
	CP.B	W1, W0
	BRA NZ	L__JSON_GetString187
	GOTO	L__JSON_GetString118
L__JSON_GetString187:
	CP	W4, W3
	BRA LT	L__JSON_GetString188
	GOTO	L__JSON_GetString117
L__JSON_GetString188:
L__JSON_GetString99:
;json_parser.c,130 :: 		_pos++;
	INC	W5
;json_parser.c,131 :: 		offset++;
	INC	W4
;json_parser.c,132 :: 		}
	GOTO	L_JSON_GetString41
;json_parser.c,129 :: 		while (*_pos && *_pos != '\"' && offset < json_len) {
L__JSON_GetString119:
L__JSON_GetString118:
L__JSON_GetString117:
;json_parser.c,133 :: 		if (offset >= json_len || *_pos != '\"') {
	CP	W4, W3
	BRA LT	L__JSON_GetString189
	GOTO	L__JSON_GetString121
L__JSON_GetString189:
; json_len end address is: 6 (W3)
; offset end address is: 8 (W4)
	MOV.B	[W5], W1
	MOV.B	#34, W0
	CP.B	W1, W0
	BRA Z	L__JSON_GetString190
	GOTO	L__JSON_GetString120
L__JSON_GetString190:
	GOTO	L_JSON_GetString47
; _start end address is: 4 (W2)
; _pos end address is: 10 (W5)
L__JSON_GetString121:
L__JSON_GetString120:
;json_parser.c,134 :: 		DebugUART_Send_Text("JSON_GetString: closing '\"' not found, potential infinite loop detected\n");
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_13_json_parser), W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP.D	W12
;json_parser.c,135 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetString
;json_parser.c,136 :: 		}
L_JSON_GetString47:
;json_parser.c,137 :: 		copy_len = _pos - _start;
; _pos start address is: 10 (W5)
; _start start address is: 4 (W2)
	SUB	W5, W2, W0
; _pos end address is: 10 (W5)
; copy_len start address is: 2 (W1)
	MOV	W0, W1
;json_parser.c,138 :: 		if (copy_len >= (int)out_size) {
	CP	W0, W13
	BRA GE	L__JSON_GetString191
	GOTO	L__JSON_GetString122
L__JSON_GetString191:
; copy_len end address is: 2 (W1)
;json_parser.c,139 :: 		copy_len = (int)out_size - 1;
; copy_len start address is: 8 (W4)
	SUB	W13, #1, W4
;json_parser.c,140 :: 		DebugUART_Send_Text("JSON_GetString: output buffer too small, truncating result\n");
	PUSH	W4
	PUSH	W2
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_14_json_parser), W10
	CALL	_DebugUART_Send_Text
; copy_len end address is: 8 (W4)
	POP.D	W10
	POP.D	W12
	POP	W2
	POP	W4
;json_parser.c,141 :: 		}
	GOTO	L_JSON_GetString48
L__JSON_GetString122:
;json_parser.c,138 :: 		if (copy_len >= (int)out_size) {
	MOV	W1, W4
;json_parser.c,141 :: 		}
L_JSON_GetString48:
;json_parser.c,142 :: 		strncpy(out, _start, copy_len);
; copy_len start address is: 8 (W4)
	PUSH	W12
	PUSH.D	W10
	MOV	W2, W11
	MOV	W12, W10
; _start end address is: 4 (W2)
	MOV	W4, W12
	CALL	_strncpy
	POP.D	W10
	POP	W12
;json_parser.c,143 :: 		out[copy_len] = '\0';
	ADD	W12, W4, W1
; copy_len end address is: 8 (W4)
	CLR	W0
	MOV.B	W0, [W1]
;json_parser.c,145 :: 		return 1;
	MOV	#1, W0
;json_parser.c,146 :: 		}
;json_parser.c,145 :: 		return 1;
;json_parser.c,146 :: 		}
L_end_JSON_GetString:
	POP	W10
	RETURN
; end of _JSON_GetString

_JSON_GetObject:

;json_parser.c,149 :: 		int JSON_GetObject(JSON_Parser *parser, const char *key, char *out, size_t out_size) {
;json_parser.c,153 :: 		int json_len, offset = 0;
	PUSH	W10
; offset start address is: 4 (W2)
	CLR	W2
;json_parser.c,156 :: 		if (!parser || !parser->json) {
	CP0	W10
	BRA NZ	L__JSON_GetObject193
	GOTO	L__JSON_GetObject131
L__JSON_GetObject193:
	MOV	[W10], W0
	CP0	W0
	BRA NZ	L__JSON_GetObject194
	GOTO	L__JSON_GetObject130
L__JSON_GetObject194:
	GOTO	L_JSON_GetObject51
; offset end address is: 4 (W2)
L__JSON_GetObject131:
L__JSON_GetObject130:
;json_parser.c,157 :: 		DebugUART_Send_Text("JSON_GetObject: parser or parser->json is NULL\n");
	MOV	#lo_addr(?lstr_15_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,158 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetObject
;json_parser.c,159 :: 		}
L_JSON_GetObject51:
;json_parser.c,160 :: 		if (!key) {
; offset start address is: 4 (W2)
	CP0	W11
	BRA Z	L__JSON_GetObject195
	GOTO	L_JSON_GetObject52
L__JSON_GetObject195:
; offset end address is: 4 (W2)
;json_parser.c,161 :: 		DebugUART_Send_Text("JSON_GetObject: key is NULL\n");
	MOV	#lo_addr(?lstr_16_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,162 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetObject
;json_parser.c,163 :: 		}
L_JSON_GetObject52:
;json_parser.c,164 :: 		if (!out || out_size == 0) {
; offset start address is: 4 (W2)
	CP0	W12
	BRA NZ	L__JSON_GetObject196
	GOTO	L__JSON_GetObject133
L__JSON_GetObject196:
	CP	W13, #0
	BRA NZ	L__JSON_GetObject197
	GOTO	L__JSON_GetObject132
L__JSON_GetObject197:
	GOTO	L_JSON_GetObject55
; offset end address is: 4 (W2)
L__JSON_GetObject133:
L__JSON_GetObject132:
;json_parser.c,165 :: 		DebugUART_Send_Text("JSON_GetObject: invalid output buffer\n");
	MOV	#lo_addr(?lstr_17_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,166 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetObject
;json_parser.c,167 :: 		}
L_JSON_GetObject55:
;json_parser.c,168 :: 		json_len = strlen((char *)parser->json);
; offset start address is: 4 (W2)
	MOV	[W10], W0
	PUSH	W10
	MOV	W0, W10
	CALL	_strlen
	POP	W10
; json_len start address is: 6 (W3)
	MOV	W0, W3
;json_parser.c,169 :: 		_pos = strstr((char *)parser->json, key);
	MOV	[W10], W0
	PUSH	W12
	PUSH	W11
	MOV	W0, W10
	CALL	_strstr
	POP	W11
	POP	W12
; _pos start address is: 8 (W4)
	MOV	W0, W4
;json_parser.c,170 :: 		if (!_pos) {
	CP0	W0
	BRA Z	L__JSON_GetObject198
	GOTO	L_JSON_GetObject56
L__JSON_GetObject198:
; offset end address is: 4 (W2)
; json_len end address is: 6 (W3)
; _pos end address is: 8 (W4)
;json_parser.c,171 :: 		DebugUART_Send_Text("JSON_GetObject: key not found\n");
	MOV	#lo_addr(?lstr_18_json_parser), W10
	CALL	_DebugUART_Send_Text
;json_parser.c,172 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetObject
;json_parser.c,173 :: 		}
L_JSON_GetObject56:
;json_parser.c,174 :: 		_pos += strlen(key);
; _pos start address is: 8 (W4)
; json_len start address is: 6 (W3)
; offset start address is: 4 (W2)
	MOV	W11, W10
	CALL	_strlen
	ADD	W4, W0, W4
;json_parser.c,175 :: 		offset += strlen(key);
	MOV	W11, W10
	CALL	_strlen
	ADD	W2, W0, W2
; offset end address is: 4 (W2)
; json_len end address is: 6 (W3)
; _pos end address is: 8 (W4)
;json_parser.c,176 :: 		while (*_pos && *_pos != ':' && offset < json_len) {
L_JSON_GetObject57:
; offset start address is: 4 (W2)
; _pos start address is: 8 (W4)
; json_len start address is: 6 (W3)
	CP0.B	[W4]
	BRA NZ	L__JSON_GetObject199
	GOTO	L__JSON_GetObject136
L__JSON_GetObject199:
	MOV.B	[W4], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA NZ	L__JSON_GetObject200
	GOTO	L__JSON_GetObject135
L__JSON_GetObject200:
	CP	W2, W3
	BRA LT	L__JSON_GetObject201
	GOTO	L__JSON_GetObject134
L__JSON_GetObject201:
L__JSON_GetObject127:
;json_parser.c,177 :: 		_pos++;
	INC	W4
;json_parser.c,178 :: 		offset++;
	INC	W2
;json_parser.c,179 :: 		}
	GOTO	L_JSON_GetObject57
;json_parser.c,176 :: 		while (*_pos && *_pos != ':' && offset < json_len) {
L__JSON_GetObject136:
L__JSON_GetObject135:
L__JSON_GetObject134:
;json_parser.c,180 :: 		if (offset >= json_len || *_pos != ':') {
	CP	W2, W3
	BRA LT	L__JSON_GetObject202
	GOTO	L__JSON_GetObject138
L__JSON_GetObject202:
	MOV.B	[W4], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__JSON_GetObject203
	GOTO	L__JSON_GetObject137
L__JSON_GetObject203:
	GOTO	L_JSON_GetObject63
; offset end address is: 4 (W2)
; json_len end address is: 6 (W3)
; _pos end address is: 8 (W4)
L__JSON_GetObject138:
L__JSON_GetObject137:
;json_parser.c,181 :: 		DebugUART_Send_Text("JSON_GetObject: ':' not found after key\n");
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_19_json_parser), W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP.D	W12
;json_parser.c,182 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetObject
;json_parser.c,183 :: 		}
L_JSON_GetObject63:
;json_parser.c,184 :: 		_pos++;
; _pos start address is: 8 (W4)
; _pos start address is: 10 (W5)
; json_len start address is: 6 (W3)
; offset start address is: 4 (W2)
	ADD	W4, #1, W5
; _pos end address is: 8 (W4)
;json_parser.c,185 :: 		offset++;
; offset start address is: 8 (W4)
	ADD	W2, #1, W4
; offset end address is: 4 (W2)
; json_len end address is: 6 (W3)
; _pos end address is: 10 (W5)
; offset end address is: 8 (W4)
;json_parser.c,186 :: 		while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
L_JSON_GetObject64:
; offset start address is: 8 (W4)
; _pos start address is: 10 (W5)
; json_len start address is: 6 (W3)
	CP0.B	[W5]
	BRA NZ	L__JSON_GetObject204
	GOTO	L__JSON_GetObject141
L__JSON_GetObject204:
	PUSH	W10
	MOV.B	[W5], W10
	CALL	_isspace
	POP	W10
	CP0	W0
	BRA NZ	L__JSON_GetObject205
	GOTO	L__JSON_GetObject140
L__JSON_GetObject205:
	CP	W4, W3
	BRA LT	L__JSON_GetObject206
	GOTO	L__JSON_GetObject139
L__JSON_GetObject206:
L__JSON_GetObject125:
;json_parser.c,187 :: 		_pos++;
	INC	W5
;json_parser.c,188 :: 		offset++;
	INC	W4
;json_parser.c,189 :: 		}
	GOTO	L_JSON_GetObject64
;json_parser.c,186 :: 		while (*_pos && isspace((unsigned char)*_pos) && offset < json_len) {
L__JSON_GetObject141:
L__JSON_GetObject140:
L__JSON_GetObject139:
;json_parser.c,190 :: 		if (*_pos != '{') {
	MOV.B	[W5], W1
	MOV.B	#123, W0
	CP.B	W1, W0
	BRA NZ	L__JSON_GetObject207
	GOTO	L_JSON_GetObject68
L__JSON_GetObject207:
; json_len end address is: 6 (W3)
; _pos end address is: 10 (W5)
; offset end address is: 8 (W4)
;json_parser.c,191 :: 		DebugUART_Send_Text("JSON_GetObject: '{' not found after key\n");
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_20_json_parser), W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP.D	W12
;json_parser.c,192 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetObject
;json_parser.c,193 :: 		}
L_JSON_GetObject68:
;json_parser.c,194 :: 		_start = _pos;
; offset start address is: 8 (W4)
; _pos start address is: 10 (W5)
; json_len start address is: 6 (W3)
; _start start address is: 4 (W2)
	MOV	W5, W2
;json_parser.c,195 :: 		_brace_count = 0;
; _brace_count start address is: 12 (W6)
	CLR	W6
; _start end address is: 4 (W2)
; json_len end address is: 6 (W3)
; _brace_count end address is: 12 (W6)
; _pos end address is: 10 (W5)
; offset end address is: 8 (W4)
;json_parser.c,196 :: 		while (*_pos && offset < json_len) {
L_JSON_GetObject69:
; _brace_count start address is: 12 (W6)
; _start start address is: 4 (W2)
; json_len start address is: 6 (W3)
; _pos start address is: 10 (W5)
; offset start address is: 8 (W4)
	CP0.B	[W5]
	BRA NZ	L__JSON_GetObject208
	GOTO	L__JSON_GetObject147
L__JSON_GetObject208:
	CP	W4, W3
	BRA LT	L__JSON_GetObject209
	GOTO	L__JSON_GetObject148
L__JSON_GetObject209:
L__JSON_GetObject124:
;json_parser.c,197 :: 		if (*_pos == '{') {
	MOV.B	[W5], W1
	MOV.B	#123, W0
	CP.B	W1, W0
	BRA Z	L__JSON_GetObject210
	GOTO	L_JSON_GetObject73
L__JSON_GetObject210:
;json_parser.c,198 :: 		_brace_count++;
; _brace_count start address is: 12 (W6)
	INC	W6
; _brace_count end address is: 12 (W6)
;json_parser.c,199 :: 		} else if (*_pos == '}') {
	GOTO	L_JSON_GetObject74
L_JSON_GetObject73:
	MOV.B	[W5], W1
	MOV.B	#125, W0
	CP.B	W1, W0
	BRA Z	L__JSON_GetObject211
	GOTO	L__JSON_GetObject146
L__JSON_GetObject211:
;json_parser.c,200 :: 		_brace_count--;
	SUB	W6, #1, W0
; _brace_count end address is: 12 (W6)
; _brace_count start address is: 2 (W1)
	MOV	W0, W1
;json_parser.c,201 :: 		if (_brace_count == 0) {
	CP	W0, #0
	BRA Z	L__JSON_GetObject212
	GOTO	L_JSON_GetObject76
L__JSON_GetObject212:
;json_parser.c,202 :: 		_pos++;  // Bao g?m d?u '}'
; _pos start address is: 0 (W0)
	ADD	W5, #1, W0
; _pos end address is: 10 (W5)
;json_parser.c,203 :: 		offset++;
	INC	W4
;json_parser.c,204 :: 		break;
	GOTO	L_JSON_GetObject70
; _pos end address is: 0 (W0)
;json_parser.c,205 :: 		}
L_JSON_GetObject76:
;json_parser.c,206 :: 		}
	MOV	W1, W6
; _brace_count end address is: 2 (W1)
; _pos start address is: 10 (W5)
	GOTO	L_JSON_GetObject75
L__JSON_GetObject146:
;json_parser.c,199 :: 		} else if (*_pos == '}') {
;json_parser.c,206 :: 		}
L_JSON_GetObject75:
; _brace_count start address is: 12 (W6)
; _brace_count end address is: 12 (W6)
L_JSON_GetObject74:
;json_parser.c,207 :: 		_pos++;
; _brace_count start address is: 12 (W6)
	INC	W5
;json_parser.c,208 :: 		offset++;
	INC	W4
;json_parser.c,209 :: 		}
; _brace_count end address is: 12 (W6)
; _pos end address is: 10 (W5)
	GOTO	L_JSON_GetObject69
L_JSON_GetObject70:
;json_parser.c,196 :: 		while (*_pos && offset < json_len) {
; _brace_count start address is: 2 (W1)
; _pos start address is: 0 (W0)
	PUSH	W4
; _brace_count end address is: 2 (W1)
; offset end address is: 8 (W4)
	MOV	W0, W4
	POP	W0
	GOTO	L__JSON_GetObject143
; _pos end address is: 0 (W0)
L__JSON_GetObject147:
	MOV	W4, W0
	MOV	W5, W4
	MOV	W6, W1
L__JSON_GetObject143:
; offset start address is: 0 (W0)
; _pos start address is: 8 (W4)
; _brace_count start address is: 2 (W1)
	PUSH	W1
; offset end address is: 0 (W0)
; _pos end address is: 8 (W4)
; _brace_count end address is: 2 (W1)
	MOV	W4, W1
	MOV	W0, W4
	POP	W0
	GOTO	L__JSON_GetObject142
L__JSON_GetObject148:
	MOV	W6, W0
	MOV	W5, W1
L__JSON_GetObject142:
;json_parser.c,210 :: 		if (offset >= json_len || _brace_count != 0) {
; _brace_count start address is: 0 (W0)
; _pos start address is: 2 (W1)
; offset start address is: 8 (W4)
	CP	W4, W3
	BRA LT	L__JSON_GetObject213
	GOTO	L__JSON_GetObject145
L__JSON_GetObject213:
; json_len end address is: 6 (W3)
; offset end address is: 8 (W4)
	CP	W0, #0
	BRA Z	L__JSON_GetObject214
	GOTO	L__JSON_GetObject144
L__JSON_GetObject214:
; _brace_count end address is: 0 (W0)
	GOTO	L_JSON_GetObject79
; _start end address is: 4 (W2)
; _pos end address is: 2 (W1)
L__JSON_GetObject145:
L__JSON_GetObject144:
;json_parser.c,211 :: 		DebugUART_Send_Text("JSON_GetObject: Unmatched braces detected or infinite loop risk\n");
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_21_json_parser), W10
	CALL	_DebugUART_Send_Text
	POP.D	W10
	POP.D	W12
;json_parser.c,212 :: 		return 0;
	CLR	W0
	GOTO	L_end_JSON_GetObject
;json_parser.c,213 :: 		}
L_JSON_GetObject79:
;json_parser.c,214 :: 		copy_len = _pos - _start;
; _pos start address is: 2 (W1)
; _start start address is: 4 (W2)
	SUB	W1, W2, W0
; _pos end address is: 2 (W1)
; copy_len start address is: 2 (W1)
	MOV	W0, W1
;json_parser.c,215 :: 		if (copy_len >= (int)out_size) {
	CP	W0, W13
	BRA GE	L__JSON_GetObject215
	GOTO	L__JSON_GetObject149
L__JSON_GetObject215:
; copy_len end address is: 2 (W1)
;json_parser.c,216 :: 		copy_len = (int)out_size - 1;
; copy_len start address is: 8 (W4)
	SUB	W13, #1, W4
;json_parser.c,217 :: 		DebugUART_Send_Text("JSON_GetObject: output buffer too small, truncating result\n");
	PUSH	W4
	PUSH	W2
	PUSH.D	W12
	PUSH.D	W10
	MOV	#lo_addr(?lstr_22_json_parser), W10
	CALL	_DebugUART_Send_Text
; copy_len end address is: 8 (W4)
	POP.D	W10
	POP.D	W12
	POP	W2
	POP	W4
;json_parser.c,218 :: 		}
	GOTO	L_JSON_GetObject80
L__JSON_GetObject149:
;json_parser.c,215 :: 		if (copy_len >= (int)out_size) {
	MOV	W1, W4
;json_parser.c,218 :: 		}
L_JSON_GetObject80:
;json_parser.c,219 :: 		strncpy(out, _start, copy_len);
; copy_len start address is: 8 (W4)
	PUSH	W12
	PUSH.D	W10
	MOV	W2, W11
	MOV	W12, W10
; _start end address is: 4 (W2)
	MOV	W4, W12
	CALL	_strncpy
	POP.D	W10
	POP	W12
;json_parser.c,220 :: 		out[copy_len] = '\0';
	ADD	W12, W4, W1
; copy_len end address is: 8 (W4)
	CLR	W0
	MOV.B	W0, [W1]
;json_parser.c,222 :: 		return 1;
	MOV	#1, W0
;json_parser.c,223 :: 		}
;json_parser.c,222 :: 		return 1;
;json_parser.c,223 :: 		}
L_end_JSON_GetObject:
	POP	W10
	RETURN
; end of _JSON_GetObject
