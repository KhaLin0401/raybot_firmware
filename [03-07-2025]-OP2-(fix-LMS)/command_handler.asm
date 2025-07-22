
command_handler_strip_newline:

;command_handler.c,42 :: 		static void strip_newline(char *str) {
;command_handler.c,43 :: 		int len = strlen(str);
	CALL	_strlen
; len start address is: 4 (W2)
	MOV	W0, W2
; len end address is: 4 (W2)
;command_handler.c,44 :: 		while (len > 0 && (str[len - 1] == '\r' || str[len - 1] == '\n' || str[len - 1] == ' ')) {
L_command_handler_strip_newline0:
; len start address is: 4 (W2)
	CP	W2, #0
	BRA GT	L_command_handler_strip_newline146
	GOTO	L_command_handler_strip_newline105
L_command_handler_strip_newline146:
	SUB	W2, #1, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #13
	BRA NZ	L_command_handler_strip_newline147
	GOTO	L_command_handler_strip_newline104
L_command_handler_strip_newline147:
	SUB	W2, #1, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA NZ	L_command_handler_strip_newline148
	GOTO	L_command_handler_strip_newline103
L_command_handler_strip_newline148:
	SUB	W2, #1, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA NZ	L_command_handler_strip_newline149
	GOTO	L_command_handler_strip_newline102
L_command_handler_strip_newline149:
; len end address is: 4 (W2)
	GOTO	L_command_handler_strip_newline1
L_command_handler_strip_newline104:
; len start address is: 4 (W2)
L_command_handler_strip_newline103:
L_command_handler_strip_newline102:
L_command_handler_strip_newline100:
;command_handler.c,45 :: 		str[len - 1] = '\0';
	SUB	W2, #1, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;command_handler.c,46 :: 		len--;
	DEC	W2
;command_handler.c,47 :: 		}
; len end address is: 4 (W2)
	GOTO	L_command_handler_strip_newline0
L_command_handler_strip_newline1:
;command_handler.c,44 :: 		while (len > 0 && (str[len - 1] == '\r' || str[len - 1] == '\n' || str[len - 1] == ' ')) {
L_command_handler_strip_newline105:
;command_handler.c,48 :: 		}
L_end_strip_newline:
	RETURN
; end of command_handler_strip_newline

command_handler_trim_whitespace:

;command_handler.c,51 :: 		static void trim_whitespace(char *str) {
;command_handler.c,52 :: 		int i, start = 0;
; start start address is: 6 (W3)
	CLR	W3
;command_handler.c,53 :: 		int len = strlen(str);
	CALL	_strlen
; len start address is: 8 (W4)
	MOV	W0, W4
; start end address is: 6 (W3)
; len end address is: 8 (W4)
;command_handler.c,55 :: 		while (start < len && (str[start]==' ' || str[start]=='\t')) {
L_command_handler_trim_whitespace6:
; len start address is: 8 (W4)
; start start address is: 6 (W3)
	CP	W3, W4
	BRA LT	L_command_handler_trim_whitespace151
	GOTO	L_command_handler_trim_whitespace112
L_command_handler_trim_whitespace151:
	ADD	W10, W3, W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA NZ	L_command_handler_trim_whitespace152
	GOTO	L_command_handler_trim_whitespace111
L_command_handler_trim_whitespace152:
	ADD	W10, W3, W0
	MOV.B	[W0], W0
	CP.B	W0, #9
	BRA NZ	L_command_handler_trim_whitespace153
	GOTO	L_command_handler_trim_whitespace110
L_command_handler_trim_whitespace153:
	GOTO	L_command_handler_trim_whitespace7
L_command_handler_trim_whitespace111:
L_command_handler_trim_whitespace110:
L_command_handler_trim_whitespace108:
;command_handler.c,56 :: 		start++;
	INC	W3
;command_handler.c,57 :: 		}
	GOTO	L_command_handler_trim_whitespace6
L_command_handler_trim_whitespace7:
;command_handler.c,55 :: 		while (start < len && (str[start]==' ' || str[start]=='\t')) {
L_command_handler_trim_whitespace112:
;command_handler.c,58 :: 		if (start > 0) {
	CP	W3, #0
	BRA GT	L_command_handler_trim_whitespace154
	GOTO	L_command_handler_trim_whitespace12
L_command_handler_trim_whitespace154:
;command_handler.c,59 :: 		for (i = start; i < len; i++) {
; i start address is: 4 (W2)
	MOV	W3, W2
; start end address is: 6 (W3)
; len end address is: 8 (W4)
; i end address is: 4 (W2)
L_command_handler_trim_whitespace13:
; i start address is: 4 (W2)
; start start address is: 6 (W3)
; len start address is: 8 (W4)
	CP	W2, W4
	BRA LT	L_command_handler_trim_whitespace155
	GOTO	L_command_handler_trim_whitespace14
L_command_handler_trim_whitespace155:
;command_handler.c,60 :: 		str[i - start] = str[i];
	SUB	W2, W3, W0
	ADD	W10, W0, W1
	ADD	W10, W2, W0
	MOV.B	[W0], [W1]
;command_handler.c,59 :: 		for (i = start; i < len; i++) {
	INC	W2
;command_handler.c,61 :: 		}
; i end address is: 4 (W2)
	GOTO	L_command_handler_trim_whitespace13
L_command_handler_trim_whitespace14:
;command_handler.c,62 :: 		str[len - start] = '\0';
	SUB	W4, W3, W0
; start end address is: 6 (W3)
; len end address is: 8 (W4)
	ADD	W10, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;command_handler.c,63 :: 		}
L_command_handler_trim_whitespace12:
;command_handler.c,65 :: 		len = strlen(str);
	CALL	_strlen
; len start address is: 4 (W2)
	MOV	W0, W2
; len end address is: 4 (W2)
;command_handler.c,66 :: 		while (len > 0 && (str[len - 1]==' ' || str[len - 1]=='\t')) {
L_command_handler_trim_whitespace16:
; len start address is: 4 (W2)
	CP	W2, #0
	BRA GT	L_command_handler_trim_whitespace156
	GOTO	L_command_handler_trim_whitespace115
L_command_handler_trim_whitespace156:
	SUB	W2, #1, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W1
	MOV.B	#32, W0
	CP.B	W1, W0
	BRA NZ	L_command_handler_trim_whitespace157
	GOTO	L_command_handler_trim_whitespace114
L_command_handler_trim_whitespace157:
	SUB	W2, #1, W0
	ADD	W10, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #9
	BRA NZ	L_command_handler_trim_whitespace158
	GOTO	L_command_handler_trim_whitespace113
L_command_handler_trim_whitespace158:
; len end address is: 4 (W2)
	GOTO	L_command_handler_trim_whitespace17
L_command_handler_trim_whitespace114:
; len start address is: 4 (W2)
L_command_handler_trim_whitespace113:
L_command_handler_trim_whitespace106:
;command_handler.c,67 :: 		str[len - 1] = '\0';
	SUB	W2, #1, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;command_handler.c,68 :: 		len--;
	DEC	W2
;command_handler.c,69 :: 		}
; len end address is: 4 (W2)
	GOTO	L_command_handler_trim_whitespace16
L_command_handler_trim_whitespace17:
;command_handler.c,66 :: 		while (len > 0 && (str[len - 1]==' ' || str[len - 1]=='\t')) {
L_command_handler_trim_whitespace115:
;command_handler.c,70 :: 		}
L_end_trim_whitespace:
	RETURN
; end of command_handler_trim_whitespace

_CommandHandler_Init:

;command_handler.c,73 :: 		void CommandHandler_Init(CommandHandler *handler) {
;command_handler.c,74 :: 		strcpy(handler->command_name, "");
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(?lstr1_command_handler), W11
	CALL	_strcpy
;command_handler.c,75 :: 		handler->command_value = 0;
	MOV	#32, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV	W0, [W1]
;command_handler.c,76 :: 		memset(handler->response_buffer, 0, sizeof(handler->response_buffer));
	MOV	#34, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	#128, W12
	CLR	W11
	MOV	W0, W10
	CALL	_memset
	POP	W10
;command_handler.c,77 :: 		handler->is_valid = 0;
	MOV	#162, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;command_handler.c,78 :: 		strcpy(handler->id, "");
	MOV	#163, W0
	ADD	W10, W0, W0
	MOV	#lo_addr(?lstr2_command_handler), W11
	MOV	W0, W10
	CALL	_strcpy
;command_handler.c,80 :: 		}
L_end_CommandHandler_Init:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _CommandHandler_Init

_handle_unknown_command:

;command_handler.c,83 :: 		void handle_unknown_command(CommandHandler *handler) {
;command_handler.c,84 :: 		sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Unknown command: %s\"}\r\n", handler->id, handler->command_name);
	PUSH	W10
	MOV	#163, W0
	ADD	W10, W0, W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W10
	PUSH	W10
	PUSH	W2
	MOV	#lo_addr(?lstr_3_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#8, W15
	POP	W10
;command_handler.c,85 :: 		DEBUG_PRINT(handler->response_buffer);
	MOV	#34, W0
	ADD	W10, W0, W0
	MOV	W0, W10
	CALL	_DebugUART_Send_Text
;command_handler.c,86 :: 		}
L_end_handle_unknown_command:
	POP	W10
	RETURN
; end of _handle_unknown_command

_CommandHandler_Respond:

;command_handler.c,93 :: 		void CommandHandler_Respond(CommandHandler *handler) {
;command_handler.c,95 :: 		_UART2_SendPush(handler->response_buffer);
	PUSH	W10
	MOV	#34, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	W0, W10
	CALL	__UART2_SendPush
	POP	W10
;command_handler.c,96 :: 		DEBUG_PRINT(handler->response_buffer);
	MOV	#34, W0
	ADD	W10, W0, W0
	MOV	W0, W10
	CALL	_DebugUART_Send_Text
;command_handler.c,97 :: 		}
L_end_CommandHandler_Respond:
	POP	W10
	RETURN
; end of _CommandHandler_Respond

_CommandHandler_ParseJSON:
	LNK	#294

;command_handler.c,105 :: 		void CommandHandler_ParseJSON(CommandHandler *handler, const char *cmd) {
;command_handler.c,108 :: 		char _id[32] = {0};
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#132, W1
	ADD	W14, W1, W1
	MOV	#___Lib_System_DefaultPage, W0
	MOV	W0, 52
	MOV	#lo_addr(?ICSCommandHandler_ParseJSON__id_L0), W0
	REPEAT	#161
	MOV.B	[W0++], [W1++]
;command_handler.c,109 :: 		int _cmd_type = -1;
;command_handler.c,110 :: 		char _dataBuffer[128] = {0};
;command_handler.c,113 :: 		int _param1 = 0, _param2 = 0, _param3 = 0;
;command_handler.c,116 :: 		if (cmd[0] != '>')
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W11], W1
	MOV.B	#62, W0
	CP.B	W1, W0
	BRA NZ	L__CommandHandler_ParseJSON163
	GOTO	L_CommandHandler_ParseJSON22
L__CommandHandler_ParseJSON163:
;command_handler.c,117 :: 		return;
	GOTO	L_end_CommandHandler_ParseJSON
L_CommandHandler_ParseJSON22:
;command_handler.c,120 :: 		strncpy(_buffer, cmd + 1, sizeof(_buffer) - 1);
	ADD	W11, #1, W1
	ADD	W14, #0, W0
	PUSH	W10
	MOV	#127, W12
	MOV	W1, W11
	MOV	W0, W10
	CALL	_strncpy
;command_handler.c,121 :: 		_buffer[sizeof(_buffer) - 1] = '\0';
	ADD	W14, #0, W2
	MOV	#127, W0
	ADD	W2, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;command_handler.c,124 :: 		strip_newline(_buffer);
	MOV	W2, W10
	CALL	command_handler_strip_newline
;command_handler.c,130 :: 		JSON_Init(&_parser, _buffer);
	ADD	W14, #0, W1
	MOV	#128, W0
	ADD	W14, W0, W0
	MOV	W1, W11
	MOV	W0, W10
	CALL	_JSON_Init
;command_handler.c,133 :: 		if (!JSON_GetString(&_parser, "id", _id, sizeof(_id))) {
	MOV	#132, W1
	ADD	W14, W1, W1
	MOV	#128, W0
	ADD	W14, W0, W0
	MOV	#32, W13
	MOV	W1, W12
	MOV	#lo_addr(?lstr_4_command_handler), W11
	MOV	W0, W10
	CALL	_JSON_GetString
	POP	W10
	CP0	W0
	BRA Z	L__CommandHandler_ParseJSON164
	GOTO	L_CommandHandler_ParseJSON23
L__CommandHandler_ParseJSON164:
;command_handler.c,134 :: 		sprintf(handler->response_buffer, ">{\"id\":\"\",\"error\":\"Invalid JSON: missing id\"}\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_5_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,135 :: 		return;
	GOTO	L_end_CommandHandler_ParseJSON
;command_handler.c,136 :: 		}
L_CommandHandler_ParseJSON23:
;command_handler.c,137 :: 		strcpy(handler->id, _id);
	MOV	#132, W1
	ADD	W14, W1, W1
	MOV	#163, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV	W1, W11
	MOV	W0, W10
	CALL	_strcpy
;command_handler.c,141 :: 		if (!JSON_GetInt(&_parser, "type", &_cmd_type)) {
	MOV	#164, W1
	ADD	W14, W1, W1
	MOV	#128, W0
	ADD	W14, W0, W0
	MOV	W1, W12
	MOV	#lo_addr(?lstr_6_command_handler), W11
	MOV	W0, W10
	CALL	_JSON_GetInt
	POP	W10
	CP0	W0
	BRA Z	L__CommandHandler_ParseJSON165
	GOTO	L_CommandHandler_ParseJSON24
L__CommandHandler_ParseJSON165:
;command_handler.c,142 :: 		sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Invalid JSON: missing type\"}\r\n", _id);
	MOV	#132, W2
	ADD	W14, W2, W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_7_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,143 :: 		return;
	GOTO	L_end_CommandHandler_ParseJSON
;command_handler.c,144 :: 		}
L_CommandHandler_ParseJSON24:
;command_handler.c,148 :: 		if (!JSON_GetObject(&_parser, "data", _dataBuffer, sizeof(_dataBuffer))) {
	MOV	#166, W1
	ADD	W14, W1, W1
	MOV	#128, W0
	ADD	W14, W0, W0
	PUSH	W10
	MOV	#128, W13
	MOV	W1, W12
	MOV	#lo_addr(?lstr_8_command_handler), W11
	MOV	W0, W10
	CALL	_JSON_GetObject
	POP	W10
	CP0	W0
	BRA Z	L__CommandHandler_ParseJSON166
	GOTO	L_CommandHandler_ParseJSON25
L__CommandHandler_ParseJSON166:
;command_handler.c,149 :: 		sprintf(handler->response_buffer, ">{\"id\":\"%s\",\"error\":\"Invalid JSON: missing data\"}\r\n", _id);
	MOV	#132, W2
	ADD	W14, W2, W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_9_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,150 :: 		return;
	GOTO	L_end_CommandHandler_ParseJSON
;command_handler.c,151 :: 		}
L_CommandHandler_ParseJSON25:
;command_handler.c,155 :: 		JSON_Init(&_dataParser, _dataBuffer);
	MOV	#166, W1
	ADD	W14, W1, W1
	MOV	#130, W0
	ADD	W14, W0, W0
	PUSH	W10
	MOV	W1, W11
	MOV	W0, W10
	CALL	_JSON_Init
	POP	W10
;command_handler.c,161 :: 		switch (_cmd_type) {
	GOTO	L_CommandHandler_ParseJSON26
;command_handler.c,162 :: 		case 0: // Charge config: mong d?i c? key "current_limit" v? "enable"
L_CommandHandler_ParseJSON28:
;command_handler.c,163 :: 		handle_charge_config(handler, &_dataParser, _id);
	MOV	#132, W1
	ADD	W14, W1, W1
	MOV	#130, W0
	ADD	W14, W0, W0
	MOV	W1, W12
	MOV	W0, W11
	CALL	_handle_charge_config
;command_handler.c,164 :: 		break;
	GOTO	L_CommandHandler_ParseJSON27
;command_handler.c,165 :: 		case 1: // Discharge config: mong d?i c? key "current_limit" v? "enable"
L_CommandHandler_ParseJSON29:
;command_handler.c,166 :: 		handle_discharge_config(handler, &_dataParser, _id);
	MOV	#132, W1
	ADD	W14, W1, W1
	MOV	#130, W0
	ADD	W14, W0, W0
	MOV	W1, W12
	MOV	W0, W11
	CALL	_handle_discharge_config
;command_handler.c,167 :: 		break;
	GOTO	L_CommandHandler_ParseJSON27
;command_handler.c,168 :: 		case 2: // Lifter config: mong d?i c? key "target_position" v? "enable"
L_CommandHandler_ParseJSON30:
;command_handler.c,169 :: 		handle_lifter_config(handler, &_dataParser, _id);
	MOV	#132, W1
	ADD	W14, W1, W1
	MOV	#130, W0
	ADD	W14, W0, W0
	MOV	W1, W12
	MOV	W0, W11
	CALL	_handle_lifter_config
;command_handler.c,170 :: 		break;
	GOTO	L_CommandHandler_ParseJSON27
;command_handler.c,171 :: 		case 3: // Motor config: mong d?i c? key "direction", "speed" v? "enable"
L_CommandHandler_ParseJSON31:
;command_handler.c,172 :: 		handle_motorDC_config(handler, &_dataParser, _id);
	MOV	#132, W1
	ADD	W14, W1, W1
	MOV	#130, W0
	ADD	W14, W0, W0
	MOV	W1, W12
	MOV	W0, W11
	CALL	_handle_motorDC_config
;command_handler.c,173 :: 		break;
	GOTO	L_CommandHandler_ParseJSON27
;command_handler.c,174 :: 		default:
L_CommandHandler_ParseJSON32:
;command_handler.c,176 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", _id);
	MOV	#132, W2
	ADD	W14, W2, W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_10_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,177 :: 		break;
	GOTO	L_CommandHandler_ParseJSON27
;command_handler.c,178 :: 		}
L_CommandHandler_ParseJSON26:
	MOV	[W14+164], W0
	CP	W0, #0
	BRA NZ	L__CommandHandler_ParseJSON167
	GOTO	L_CommandHandler_ParseJSON28
L__CommandHandler_ParseJSON167:
	MOV	[W14+164], W0
	CP	W0, #1
	BRA NZ	L__CommandHandler_ParseJSON168
	GOTO	L_CommandHandler_ParseJSON29
L__CommandHandler_ParseJSON168:
	MOV	[W14+164], W0
	CP	W0, #2
	BRA NZ	L__CommandHandler_ParseJSON169
	GOTO	L_CommandHandler_ParseJSON30
L__CommandHandler_ParseJSON169:
	MOV	[W14+164], W0
	CP	W0, #3
	BRA NZ	L__CommandHandler_ParseJSON170
	GOTO	L_CommandHandler_ParseJSON31
L__CommandHandler_ParseJSON170:
	GOTO	L_CommandHandler_ParseJSON32
L_CommandHandler_ParseJSON27:
;command_handler.c,182 :: 		}
L_end_CommandHandler_ParseJSON:
	POP	W13
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _CommandHandler_ParseJSON

_CommandHandler_Execute:

;command_handler.c,190 :: 		void CommandHandler_Execute(CommandHandler *handler, const char *cmd) {
;command_handler.c,191 :: 		int found = 0;
	PUSH	W10
; found start address is: 8 (W4)
	CLR	W4
;command_handler.c,192 :: 		int i = 0;
;command_handler.c,194 :: 		if (handler == NULL) {
	CP	W10, #0
	BRA Z	L__CommandHandler_Execute172
	GOTO	L_CommandHandler_Execute33
L__CommandHandler_Execute172:
; found end address is: 8 (W4)
;command_handler.c,195 :: 		DEBUG_PRINT("CH DEBUG: Handler pointer is NULL. Exiting.\n");
	MOV	#lo_addr(?lstr_11_command_handler), W10
	CALL	_DebugUART_Send_Text
;command_handler.c,196 :: 		return;
	GOTO	L_end_CommandHandler_Execute
;command_handler.c,197 :: 		}
L_CommandHandler_Execute33:
;command_handler.c,198 :: 		if (cmd == NULL) {
; found start address is: 8 (W4)
	CP	W11, #0
	BRA Z	L__CommandHandler_Execute173
	GOTO	L_CommandHandler_Execute34
L__CommandHandler_Execute173:
; found end address is: 8 (W4)
;command_handler.c,199 :: 		DEBUG_PRINT("CH DEBUG: Command string is NULL. Exiting.\n");
	MOV	#lo_addr(?lstr_12_command_handler), W10
	CALL	_DebugUART_Send_Text
;command_handler.c,200 :: 		return;
	GOTO	L_end_CommandHandler_Execute
;command_handler.c,201 :: 		}
L_CommandHandler_Execute34:
;command_handler.c,214 :: 		if (cmd[0] == '>') {
; found start address is: 8 (W4)
	MOV	#___Lib_System_DefaultPage, W0
	MOV	WREG, 52
	MOV.B	[W11], W1
	MOV.B	#62, W0
	CP.B	W1, W0
	BRA Z	L__CommandHandler_Execute174
	GOTO	L_CommandHandler_Execute35
L__CommandHandler_Execute174:
; found end address is: 8 (W4)
;command_handler.c,216 :: 		CommandHandler_ParseJSON(handler, cmd);
	PUSH	W10
	CALL	_CommandHandler_ParseJSON
	POP	W10
;command_handler.c,218 :: 		CommandHandler_Respond(handler);
	CALL	_CommandHandler_Respond
;command_handler.c,220 :: 		return;
	GOTO	L_end_CommandHandler_Execute
;command_handler.c,221 :: 		} else {
L_CommandHandler_Execute35:
;command_handler.c,224 :: 		strcpy(handler->command_name, cmd);
; found start address is: 8 (W4)
	CALL	_strcpy
;command_handler.c,229 :: 		if (!found) {
	CP0	W4
	BRA Z	L__CommandHandler_Execute175
	GOTO	L_CommandHandler_Execute37
L__CommandHandler_Execute175:
; found end address is: 8 (W4)
;command_handler.c,231 :: 		handle_unknown_command(handler);
	PUSH	W10
	CALL	_handle_unknown_command
	POP	W10
;command_handler.c,232 :: 		}
L_CommandHandler_Execute37:
;command_handler.c,236 :: 		CommandHandler_Respond(handler);
	CALL	_CommandHandler_Respond
;command_handler.c,238 :: 		}
L_end_CommandHandler_Execute:
	POP	W10
	RETURN
; end of _CommandHandler_Execute

_handle_get_bat_info:
	LNK	#16

;command_handler.c,244 :: 		void handle_get_bat_info(CommandHandler *handler) {
;command_handler.c,250 :: 		(uint8_t)_bmsData._sumSOC, (int)_bmsData._errorCount, (int)1, (int)1);
	MOV	__bmsData+196, W0
	MOV	W0, [W14+14]
	PUSH	W10
	MOV	__bmsData+8, W0
	MOV	__bmsData+10, W1
	CALL	__Float2Longint
	MOV.B	W0, [W14+12]
;command_handler.c,249 :: 		(int)_bmsData._cellVoltages[2], (int)_bmsData._cellVoltages[3],
	MOV	__bmsData+32, W0
	MOV	__bmsData+34, W1
	CALL	__Float2Longint
	MOV	W0, [W14+10]
	MOV	__bmsData+28, W0
	MOV	__bmsData+30, W1
	CALL	__Float2Longint
	MOV	W0, [W14+8]
;command_handler.c,248 :: 		(int)_bmsData._cellVoltages[0], (int)_bmsData._cellVoltages[1],
	MOV	__bmsData+24, W0
	MOV	__bmsData+26, W1
	CALL	__Float2Longint
	MOV	W0, [W14+6]
	MOV	__bmsData+20, W0
	MOV	__bmsData+22, W1
	CALL	__Float2Longint
	MOV	W0, [W14+4]
;command_handler.c,247 :: 		(int)_bmsData._sumCurrent,(int) _bmsData._temperature, (int)_bmsData._sumVoltage,
	MOV	__bmsData, W0
	MOV	__bmsData+2, W1
	CALL	__Float2Longint
	MOV	W0, [W14+2]
	MOV	__bmsData+84, W0
	MOV	__bmsData+86, W1
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	__bmsData+4, W0
	MOV	__bmsData+6, W1
	CALL	__Float2Longint
	POP	W10
;command_handler.c,245 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W8
;command_handler.c,250 :: 		(uint8_t)_bmsData._sumSOC, (int)_bmsData._errorCount, (int)1, (int)1);
	MOV	#1, W1
	PUSH	W1
	MOV	#1, W2
	MOV	[W14+14], W1
	PUSH	W2
	PUSH	W1
	MOV.B	[W14+12], W1
	ZE	W1, W7
	MOV	[W14+10], W6
	MOV	[W14+8], W5
	MOV	[W14+6], W4
	MOV	[W14+4], W3
	MOV	[W14+2], W2
	MOV	[W14+0], W1
	PUSH	W7
;command_handler.c,249 :: 		(int)_bmsData._cellVoltages[2], (int)_bmsData._cellVoltages[3],
	PUSH	W6
	PUSH	W5
;command_handler.c,248 :: 		(int)_bmsData._cellVoltages[0], (int)_bmsData._cellVoltages[1],
	PUSH	W4
	PUSH	W3
;command_handler.c,247 :: 		(int)_bmsData._sumCurrent,(int) _bmsData._temperature, (int)_bmsData._sumVoltage,
	PUSH	W2
	PUSH	W1
	PUSH	W0
;command_handler.c,246 :: 		">{\"type\":0,\"state_type\":0,\"data\":{\"current\":%d,\"temp\":%d,\"voltage\":%d,\"cell_voltages\":[%d,%d,%d,%d],\"percent\":%d,\"fault\":%d,\"health\":%d,\"status\":%d}}\r\n",
	MOV	#lo_addr(?lstr_13_command_handler), W0
	PUSH	W0
;command_handler.c,245 :: 		sprintf(handler->response_buffer,
	PUSH	W8
;command_handler.c,250 :: 		(uint8_t)_bmsData._sumSOC, (int)_bmsData._errorCount, (int)1, (int)1);
	CALL	_sprintf
	SUB	#26, W15
;command_handler.c,251 :: 		}
L_end_handle_get_bat_info:
	ULNK
	RETURN
; end of _handle_get_bat_info

_handle_get_bat_current:

;command_handler.c,252 :: 		void handle_get_bat_current(CommandHandler *handler) {
;command_handler.c,253 :: 		sprintf(handler->response_buffer, "BAT_CURRENT=%d\r\n",_bmsData._sumCurrent);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	__bmsData+4
	PUSH	__bmsData+6
	MOV	#lo_addr(?lstr_14_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#8, W15
;command_handler.c,254 :: 		}
L_end_handle_get_bat_current:
	RETURN
; end of _handle_get_bat_current

_handle_get_bat_fault:

;command_handler.c,255 :: 		void handle_get_bat_fault(CommandHandler *handler) {
;command_handler.c,256 :: 		sprintf(handler->response_buffer, "BAT_FAULT=%d\r\n",_bmsData._errorCount);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	__bmsData+196
	MOV	#lo_addr(?lstr_15_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,257 :: 		}
L_end_handle_get_bat_fault:
	RETURN
; end of _handle_get_bat_fault

_handle_get_bat_health:

;command_handler.c,258 :: 		void handle_get_bat_health(CommandHandler *handler) {
;command_handler.c,259 :: 		sprintf(handler->response_buffer, "BAT_HEALTH=%d\r\n", 0);
	MOV	#34, W0
	ADD	W10, W0, W1
	CLR	W0
	PUSH	W0
	MOV	#lo_addr(?lstr_16_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,260 :: 		}
L_end_handle_get_bat_health:
	RETURN
; end of _handle_get_bat_health

_handle_get_bat_soc:

;command_handler.c,261 :: 		void handle_get_bat_soc(CommandHandler *handler) {
;command_handler.c,262 :: 		sprintf(handler->response_buffer, "BAT_SOC=%d\r\n",_bmsData._sumSOC);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	__bmsData+8
	PUSH	__bmsData+10
	MOV	#lo_addr(?lstr_17_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#8, W15
;command_handler.c,263 :: 		}
L_end_handle_get_bat_soc:
	RETURN
; end of _handle_get_bat_soc

_handle_get_bat_status:

;command_handler.c,264 :: 		void handle_get_bat_status(CommandHandler *handler) {
;command_handler.c,265 :: 		sprintf(handler->response_buffer, "BAT_STATUS=%d\r\n",0);
	MOV	#34, W0
	ADD	W10, W0, W1
	CLR	W0
	PUSH	W0
	MOV	#lo_addr(?lstr_18_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,266 :: 		}
L_end_handle_get_bat_status:
	RETURN
; end of _handle_get_bat_status

_handle_get_bat_temp:

;command_handler.c,267 :: 		void handle_get_bat_temp(CommandHandler *handler) {
;command_handler.c,268 :: 		sprintf(handler->response_buffer, "BAT_TEMP=%d\r\n",_bmsData._temperature);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	__bmsData+84
	PUSH	__bmsData+86
	MOV	#lo_addr(?lstr_19_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#8, W15
;command_handler.c,269 :: 		}
L_end_handle_get_bat_temp:
	RETURN
; end of _handle_get_bat_temp

_handle_get_bat_volt:

;command_handler.c,270 :: 		void handle_get_bat_volt(CommandHandler *handler) {
;command_handler.c,271 :: 		sprintf(handler->response_buffer, "BAT_VOLT=%d\r\n",_bmsData._sumVoltage);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	__bmsData
	PUSH	__bmsData+2
	MOV	#lo_addr(?lstr_20_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#8, W15
;command_handler.c,272 :: 		}
L_end_handle_get_bat_volt:
	RETURN
; end of _handle_get_bat_volt

_handle_get_cell_volt:

;command_handler.c,273 :: 		void handle_get_cell_volt(CommandHandler *handler) {
;command_handler.c,276 :: 		}
L_end_handle_get_cell_volt:
	RETURN
; end of _handle_get_cell_volt

_handle_get_chg_info:

;command_handler.c,279 :: 		void handle_get_chg_info(CommandHandler *handler){
;command_handler.c,282 :: 		(int) _bmsData._charge_current_limit, (int) LATB4_bit);
	CLR	W3
	BTSC	LATB4_bit, BitPos(LATB4_bit+0)
	INC	W3
	MOV	#lo_addr(__bmsData+240), W0
	ZE	[W0], W2
;command_handler.c,280 :: 		sprintf(handler->response_buffer,
	MOV	#34, W0
	ADD	W10, W0, W1
;command_handler.c,282 :: 		(int) _bmsData._charge_current_limit, (int) LATB4_bit);
	PUSH	W3
	PUSH	W2
;command_handler.c,281 :: 		">{\"type\":0,\"state_type\":1,\"data\":{\"current_limit\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_21_command_handler), W0
	PUSH	W0
;command_handler.c,280 :: 		sprintf(handler->response_buffer,
	PUSH	W1
;command_handler.c,282 :: 		(int) _bmsData._charge_current_limit, (int) LATB4_bit);
	CALL	_sprintf
	SUB	#8, W15
;command_handler.c,283 :: 		}
L_end_handle_get_chg_info:
	RETURN
; end of _handle_get_chg_info

_handle_get_chg_cur_lim:

;command_handler.c,284 :: 		void handle_get_chg_cur_lim(CommandHandler *handler) {
;command_handler.c,285 :: 		sprintf(handler->response_buffer, "CHG_CUR_LIM=3000\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_22_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,286 :: 		}
L_end_handle_get_chg_cur_lim:
	RETURN
; end of _handle_get_chg_cur_lim

_handle_set_chg_cur_lim:

;command_handler.c,287 :: 		void handle_set_chg_cur_lim(CommandHandler *handler) {
;command_handler.c,288 :: 		sprintf(handler->response_buffer, "CHG_CUR_LIM set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_23_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,289 :: 		}
L_end_handle_set_chg_cur_lim:
	RETURN
; end of _handle_set_chg_cur_lim

_handle_get_chg_en:

;command_handler.c,290 :: 		void handle_get_chg_en(CommandHandler *handler) {
;command_handler.c,291 :: 		sprintf(handler->response_buffer, "CHG_EN=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_24_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,292 :: 		}
L_end_handle_get_chg_en:
	RETURN
; end of _handle_get_chg_en

_handle_set_chg_en:

;command_handler.c,293 :: 		void handle_set_chg_en(CommandHandler *handler) {
;command_handler.c,294 :: 		sprintf(handler->response_buffer, "CHG_EN set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_25_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,295 :: 		}
L_end_handle_set_chg_en:
	RETURN
; end of _handle_set_chg_en

_handle_get_dis_info:

;command_handler.c,296 :: 		void handle_get_dis_info(CommandHandler *handler){
;command_handler.c,299 :: 		(int) _bmsData._discharge_current_limit, (int) _bmsData._dischargeMOS);
	MOV	#lo_addr(__bmsData+191), W0
	ZE	[W0], W3
	MOV	#lo_addr(__bmsData+241), W0
	ZE	[W0], W2
;command_handler.c,297 :: 		sprintf(handler->response_buffer,
	MOV	#34, W0
	ADD	W10, W0, W1
;command_handler.c,299 :: 		(int) _bmsData._discharge_current_limit, (int) _bmsData._dischargeMOS);
	PUSH	W3
	PUSH	W2
;command_handler.c,298 :: 		">{\"type\":0,\"state_type\":2,\"data\":{\"current_limit\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_26_command_handler), W0
	PUSH	W0
;command_handler.c,297 :: 		sprintf(handler->response_buffer,
	PUSH	W1
;command_handler.c,299 :: 		(int) _bmsData._discharge_current_limit, (int) _bmsData._dischargeMOS);
	CALL	_sprintf
	SUB	#8, W15
;command_handler.c,300 :: 		}
L_end_handle_get_dis_info:
	RETURN
; end of _handle_get_dis_info

_handle_get_dis_cur_lim:

;command_handler.c,301 :: 		void handle_get_dis_cur_lim(CommandHandler *handler) {
;command_handler.c,302 :: 		sprintf(handler->response_buffer, "DIS_CUR_LIM=5000\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_27_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,303 :: 		}
L_end_handle_get_dis_cur_lim:
	RETURN
; end of _handle_get_dis_cur_lim

_handle_set_dis_cur_lim:

;command_handler.c,304 :: 		void handle_set_dis_cur_lim(CommandHandler *handler) {
;command_handler.c,305 :: 		sprintf(handler->response_buffer, "DIS_CUR_LIM set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_28_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,306 :: 		}
L_end_handle_set_dis_cur_lim:
	RETURN
; end of _handle_set_dis_cur_lim

_handle_get_dis_en:

;command_handler.c,307 :: 		void handle_get_dis_en(CommandHandler *handler) {
;command_handler.c,308 :: 		sprintf(handler->response_buffer, "DIS_EN=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_29_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,309 :: 		}
L_end_handle_get_dis_en:
	RETURN
; end of _handle_get_dis_en

_handle_set_dis_en:

;command_handler.c,310 :: 		void handle_set_dis_en(CommandHandler *handler) {
;command_handler.c,311 :: 		sprintf(handler->response_buffer, "DIS_EN set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_30_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,312 :: 		}
L_end_handle_set_dis_en:
	RETURN
; end of _handle_set_dis_en

_handle_get_di1:

;command_handler.c,315 :: 		void handle_get_di1(CommandHandler *handler) {
;command_handler.c,316 :: 		sprintf(handler->response_buffer, "DI1=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_31_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,317 :: 		}
L_end_handle_get_di1:
	RETURN
; end of _handle_get_di1

_handle_get_di2:

;command_handler.c,318 :: 		void handle_get_di2(CommandHandler *handler) {
;command_handler.c,319 :: 		sprintf(handler->response_buffer, "DI2=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_32_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,320 :: 		}
L_end_handle_get_di2:
	RETURN
; end of _handle_get_di2

_handle_get_di3:

;command_handler.c,321 :: 		void handle_get_di3(CommandHandler *handler) {
;command_handler.c,322 :: 		sprintf(handler->response_buffer, "DI3=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_33_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,323 :: 		}
L_end_handle_get_di3:
	RETURN
; end of _handle_get_di3

_handle_get_dist_info:
	LNK	#4

;command_handler.c,326 :: 		void handle_get_dist_info(CommandHandler *handler){
;command_handler.c,329 :: 		(int)sensor_front.distance_cm, (int)sensor_rear.distance_cm, (int)sensor_lifter.distance_cm);
	PUSH	W10
	MOV	_sensor_lifter+22, W0
	MOV	_sensor_lifter+24, W1
	CALL	__Float2Longint
	MOV	W0, [W14+2]
	MOV	_sensor_rear+22, W0
	MOV	_sensor_rear+24, W1
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	_sensor_front+22, W0
	MOV	_sensor_front+24, W1
	CALL	__Float2Longint
	POP	W10
;command_handler.c,327 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W3
;command_handler.c,329 :: 		(int)sensor_front.distance_cm, (int)sensor_rear.distance_cm, (int)sensor_lifter.distance_cm);
	MOV	[W14+2], W2
	MOV	[W14+0], W1
	PUSH	W2
	PUSH	W1
	PUSH	W0
;command_handler.c,328 :: 		">{\"type\":0,\"state_type\":3,\"data\":{\"front\":%d,\"back\":%d,\"down\":%d}}\r\n",
	MOV	#lo_addr(?lstr_34_command_handler), W0
	PUSH	W0
;command_handler.c,327 :: 		sprintf(handler->response_buffer,
	PUSH	W3
;command_handler.c,329 :: 		(int)sensor_front.distance_cm, (int)sensor_rear.distance_cm, (int)sensor_lifter.distance_cm);
	CALL	_sprintf
	SUB	#10, W15
;command_handler.c,330 :: 		}
L_end_handle_get_dist_info:
	ULNK
	RETURN
; end of _handle_get_dist_info

_handle_get_down_dist:

;command_handler.c,331 :: 		void handle_get_down_dist(CommandHandler *handler) {
;command_handler.c,332 :: 		sprintf(handler->response_buffer, "DOWN_DIST=30\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_35_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,333 :: 		}
L_end_handle_get_down_dist:
	RETURN
; end of _handle_get_down_dist

_handle_get_front_dist:

;command_handler.c,334 :: 		void handle_get_front_dist(CommandHandler *handler) {
;command_handler.c,335 :: 		sprintf(handler->response_buffer, "FRONT_DIST=100\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_36_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,336 :: 		}
L_end_handle_get_front_dist:
	RETURN
; end of _handle_get_front_dist

_handle_get_rear_dist:

;command_handler.c,337 :: 		void handle_get_rear_dist(CommandHandler *handler) {
;command_handler.c,338 :: 		sprintf(handler->response_buffer, "REAR_DIST=120\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_37_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,339 :: 		}
L_end_handle_get_rear_dist:
	RETURN
; end of _handle_get_rear_dist

_handle_get_up_dist:

;command_handler.c,340 :: 		void handle_get_up_dist(CommandHandler *handler) {
;command_handler.c,341 :: 		sprintf(handler->response_buffer, "UP_DIST=50\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_38_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,342 :: 		}
L_end_handle_get_up_dist:
	RETURN
; end of _handle_get_up_dist

_handle_get_auto_mode:

;command_handler.c,345 :: 		void handle_get_auto_mode(CommandHandler *handler) {
;command_handler.c,346 :: 		sprintf(handler->response_buffer, "AUTO_MODE=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_39_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,347 :: 		}
L_end_handle_get_auto_mode:
	RETURN
; end of _handle_get_auto_mode

_handle_set_auto_mode:

;command_handler.c,348 :: 		void handle_set_auto_mode(CommandHandler *handler) {
;command_handler.c,349 :: 		sprintf(handler->response_buffer, "AUTO_MODE set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_40_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,350 :: 		}
L_end_handle_set_auto_mode:
	RETURN
; end of _handle_set_auto_mode

_handle_get_lifter_info:
	LNK	#2

;command_handler.c,353 :: 		void handle_get_lifter_info(CommandHandler *handler){
;command_handler.c,354 :: 		if(lifter._output > 0 && lifter._status == 1){
	PUSH	W10
	CLR	W2
	CLR	W3
	MOV	_lifter+32, W0
	MOV	_lifter+34, W1
	CALL	__Compare_Ge_Fp
	CP0	W0
	CLR.B	W0
	BRA LE	L__handle_get_lifter_info206
	INC.B	W0
L__handle_get_lifter_info206:
	POP	W10
	CP0.B	W0
	BRA NZ	L__handle_get_lifter_info207
	GOTO	L__handle_get_lifter_info138
L__handle_get_lifter_info207:
	MOV	_lifter+58, W0
	CP	W0, #1
	BRA Z	L__handle_get_lifter_info208
	GOTO	L__handle_get_lifter_info137
L__handle_get_lifter_info208:
L__handle_get_lifter_info136:
;command_handler.c,357 :: 		(int)lifter._currentPosition,(int) lifter._targetPosition, 1 ,lifter._status);
	PUSH	W10
	MOV	_lifter+12, W0
	MOV	_lifter+14, W1
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	_lifter+16, W0
	MOV	_lifter+18, W1
	CALL	__Float2Longint
	POP	W10
;command_handler.c,355 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W3
;command_handler.c,357 :: 		(int)lifter._currentPosition,(int) lifter._targetPosition, 1 ,lifter._status);
	PUSH	_lifter+58
	MOV	#1, W2
	MOV	[W14+0], W1
	PUSH	W2
	PUSH	W1
	PUSH	W0
;command_handler.c,356 :: 		">{\"type\":0,\"state_type\":4,\"data\":{\"current_position\":%d,\"target_position\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_41_command_handler), W0
	PUSH	W0
;command_handler.c,355 :: 		sprintf(handler->response_buffer,
	PUSH	W3
;command_handler.c,357 :: 		(int)lifter._currentPosition,(int) lifter._targetPosition, 1 ,lifter._status);
	CALL	_sprintf
	SUB	#12, W15
;command_handler.c,358 :: 		}
	GOTO	L_handle_get_lifter_info41
;command_handler.c,354 :: 		if(lifter._output > 0 && lifter._status == 1){
L__handle_get_lifter_info138:
L__handle_get_lifter_info137:
;command_handler.c,359 :: 		else if(lifter._status == 0) {
	MOV	_lifter+58, W0
	CP	W0, #0
	BRA Z	L__handle_get_lifter_info209
	GOTO	L_handle_get_lifter_info42
L__handle_get_lifter_info209:
;command_handler.c,362 :: 		(int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
	PUSH	W10
	MOV	_lifter+12, W0
	MOV	_lifter+14, W1
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	_lifter+16, W0
	MOV	_lifter+18, W1
	CALL	__Float2Longint
	POP	W10
;command_handler.c,360 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W3
;command_handler.c,362 :: 		(int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
	PUSH	_lifter+58
	CLR	W2
	MOV	[W14+0], W1
	PUSH	W2
	PUSH	W1
	PUSH	W0
;command_handler.c,361 :: 		">{\"type\":0,\"state_type\":4,\"data\":{\"current_position\":%d,\"target_position\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_42_command_handler), W0
	PUSH	W0
;command_handler.c,360 :: 		sprintf(handler->response_buffer,
	PUSH	W3
;command_handler.c,362 :: 		(int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
	CALL	_sprintf
	SUB	#12, W15
;command_handler.c,363 :: 		}
	GOTO	L_handle_get_lifter_info43
L_handle_get_lifter_info42:
;command_handler.c,367 :: 		(int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
	PUSH	W10
	MOV	_lifter+12, W0
	MOV	_lifter+14, W1
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	_lifter+16, W0
	MOV	_lifter+18, W1
	CALL	__Float2Longint
	POP	W10
;command_handler.c,365 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W3
;command_handler.c,367 :: 		(int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
	PUSH	_lifter+58
	CLR	W2
	MOV	[W14+0], W1
	PUSH	W2
	PUSH	W1
	PUSH	W0
;command_handler.c,366 :: 		">{\"type\":0,\"state_type\":4,\"data\":{\"current_position\":%d,\"target_position\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_43_command_handler), W0
	PUSH	W0
;command_handler.c,365 :: 		sprintf(handler->response_buffer,
	PUSH	W3
;command_handler.c,367 :: 		(int)lifter._currentPosition, (int)lifter._targetPosition, 0 ,lifter._status);
	CALL	_sprintf
	SUB	#12, W15
;command_handler.c,368 :: 		}
L_handle_get_lifter_info43:
L_handle_get_lifter_info41:
;command_handler.c,369 :: 		}
L_end_handle_get_lifter_info:
	ULNK
	RETURN
; end of _handle_get_lifter_info

_handle_get_lifter_dir:

;command_handler.c,370 :: 		void handle_get_lifter_dir(CommandHandler *handler) {
;command_handler.c,371 :: 		sprintf(handler->response_buffer, "LIFTER_DIR=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_44_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,372 :: 		}
L_end_handle_get_lifter_dir:
	RETURN
; end of _handle_get_lifter_dir

_handle_set_lifter_dir:

;command_handler.c,373 :: 		void handle_set_lifter_dir(CommandHandler *handler) {
;command_handler.c,374 :: 		sprintf(handler->response_buffer, "LIFTER_DIR set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_45_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,375 :: 		}
L_end_handle_set_lifter_dir:
	RETURN
; end of _handle_set_lifter_dir

_handle_get_lifter_lim_down:

;command_handler.c,376 :: 		void handle_get_lifter_lim_down(CommandHandler *handler) {
;command_handler.c,377 :: 		sprintf(handler->response_buffer, "LIFTER_LIM_DOWN=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_46_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,378 :: 		}
L_end_handle_get_lifter_lim_down:
	RETURN
; end of _handle_get_lifter_lim_down

_handle_get_lifter_lim_up:

;command_handler.c,379 :: 		void handle_get_lifter_lim_up(CommandHandler *handler) {
;command_handler.c,380 :: 		sprintf(handler->response_buffer, "LIFTER_LIM_UP=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_47_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,381 :: 		}
L_end_handle_get_lifter_lim_up:
	RETURN
; end of _handle_get_lifter_lim_up

_handle_get_lifter_speed:

;command_handler.c,382 :: 		void handle_get_lifter_speed(CommandHandler *handler) {
;command_handler.c,383 :: 		sprintf(handler->response_buffer, "LIFTER_SPEED=200\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_48_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,384 :: 		}
L_end_handle_get_lifter_speed:
	RETURN
; end of _handle_get_lifter_speed

_handle_set_lifter_speed:

;command_handler.c,385 :: 		void handle_set_lifter_speed(CommandHandler *handler) {
;command_handler.c,386 :: 		sprintf(handler->response_buffer, "LIFTER_SPEED set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_49_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,387 :: 		}
L_end_handle_set_lifter_speed:
	RETURN
; end of _handle_set_lifter_speed

_handle_get_lifter_status:

;command_handler.c,388 :: 		void handle_get_lifter_status(CommandHandler *handler) {
;command_handler.c,389 :: 		sprintf(handler->response_buffer, "LIFTER_STATUS=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_50_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,390 :: 		}
L_end_handle_get_lifter_status:
	RETURN
; end of _handle_get_lifter_status

_handle_get_motor_info:
	LNK	#4

;command_handler.c,393 :: 		void handle_get_motor_info(CommandHandler *handler){
;command_handler.c,406 :: 		if (_MotorDC_GetStatus(&motorDC) == 0){
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetStatus
	POP	W10
	CP.B	W0, #0
	BRA Z	L__handle_get_motor_info218
	GOTO	L_handle_get_motor_info44
L__handle_get_motor_info218:
;command_handler.c,409 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetStatus
	MOV.B	W0, [W14+2]
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetCurrentSpeed
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetDirection
	POP	W10
;command_handler.c,407 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W3
;command_handler.c,409 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
	MOV.B	[W14+2], W1
	ZE	W1, W1
	PUSH	W1
	CLR	W2
	MOV	[W14+0], W1
	PUSH	W2
	PUSH	W1
	ZE	W0, W0
	PUSH	W0
;command_handler.c,408 :: 		">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_51_command_handler), W0
	PUSH	W0
;command_handler.c,407 :: 		sprintf(handler->response_buffer,
	PUSH	W3
;command_handler.c,409 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
	CALL	_sprintf
	SUB	#12, W15
;command_handler.c,410 :: 		}
	GOTO	L_handle_get_motor_info45
L_handle_get_motor_info44:
;command_handler.c,411 :: 		else if (_MotorDC_GetStatus(&motorDC) == 1 && (int)_MotorDC_GetCurrentSpeed(&motorDC) < 10){
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetStatus
	POP	W10
	CP.B	W0, #1
	BRA Z	L__handle_get_motor_info219
	GOTO	L__handle_get_motor_info141
L__handle_get_motor_info219:
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetCurrentSpeed
	CALL	__Float2Longint
	POP	W10
	CP	W0, #10
	BRA LT	L__handle_get_motor_info220
	GOTO	L__handle_get_motor_info140
L__handle_get_motor_info220:
L__handle_get_motor_info139:
;command_handler.c,414 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetStatus
	MOV.B	W0, [W14+2]
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetCurrentSpeed
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetDirection
	POP	W10
;command_handler.c,412 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W3
;command_handler.c,414 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
	MOV.B	[W14+2], W1
	ZE	W1, W1
	PUSH	W1
	CLR	W2
	MOV	[W14+0], W1
	PUSH	W2
	PUSH	W1
	ZE	W0, W0
	PUSH	W0
;command_handler.c,413 :: 		">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_52_command_handler), W0
	PUSH	W0
;command_handler.c,412 :: 		sprintf(handler->response_buffer,
	PUSH	W3
;command_handler.c,414 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 0 ,_MotorDC_GetStatus(&motorDC));
	CALL	_sprintf
	SUB	#12, W15
;command_handler.c,415 :: 		}
	GOTO	L_handle_get_motor_info49
;command_handler.c,411 :: 		else if (_MotorDC_GetStatus(&motorDC) == 1 && (int)_MotorDC_GetCurrentSpeed(&motorDC) < 10){
L__handle_get_motor_info141:
L__handle_get_motor_info140:
;command_handler.c,419 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 1 ,_MotorDC_GetStatus(&motorDC));
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetStatus
	MOV.B	W0, [W14+2]
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetCurrentSpeed
	CALL	__Float2Longint
	MOV	W0, [W14+0]
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetDirection
	POP	W10
;command_handler.c,417 :: 		sprintf(handler->response_buffer,
	MOV	#34, W1
	ADD	W10, W1, W3
;command_handler.c,419 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 1 ,_MotorDC_GetStatus(&motorDC));
	MOV.B	[W14+2], W1
	ZE	W1, W1
	PUSH	W1
	MOV	#1, W2
	MOV	[W14+0], W1
	PUSH	W2
	PUSH	W1
	ZE	W0, W0
	PUSH	W0
;command_handler.c,418 :: 		">{\"type\":0,\"state_type\":5,\"data\":{\"direction\":%d,\"speed\":%d,\"is_running\":%d,\"enabled\":%d}}\r\n",
	MOV	#lo_addr(?lstr_53_command_handler), W0
	PUSH	W0
;command_handler.c,417 :: 		sprintf(handler->response_buffer,
	PUSH	W3
;command_handler.c,419 :: 		_MotorDC_GetDirection(&motorDC),(int)_MotorDC_GetCurrentSpeed(&motorDC), 1 ,_MotorDC_GetStatus(&motorDC));
	CALL	_sprintf
	SUB	#12, W15
;command_handler.c,420 :: 		}
L_handle_get_motor_info49:
L_handle_get_motor_info45:
;command_handler.c,421 :: 		}
L_end_handle_get_motor_info:
	ULNK
	RETURN
; end of _handle_get_motor_info

_handle_get_motor_dir:

;command_handler.c,422 :: 		void handle_get_motor_dir(CommandHandler *handler) {
;command_handler.c,424 :: 		sprintf(handler->response_buffer, "MOTOR_DIR=%d\r\n", _MotorDC_GetDirection(&motorDC));
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetDirection
	POP	W10
	MOV	#34, W1
	ADD	W10, W1, W1
	ZE	W0, W0
	PUSH	W0
	MOV	#lo_addr(?lstr_54_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,425 :: 		}
L_end_handle_get_motor_dir:
	RETURN
; end of _handle_get_motor_dir

_handle_set_motor_dir:

;command_handler.c,427 :: 		void handle_set_motor_dir(CommandHandler *handler) {
;command_handler.c,429 :: 		if (handler->command_value == 0 || handler->command_value == 1) {
	PUSH	W11
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA NZ	L__handle_set_motor_dir223
	GOTO	L__handle_set_motor_dir144
L__handle_set_motor_dir223:
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA NZ	L__handle_set_motor_dir224
	GOTO	L__handle_set_motor_dir143
L__handle_set_motor_dir224:
	GOTO	L_handle_set_motor_dir52
L__handle_set_motor_dir144:
L__handle_set_motor_dir143:
;command_handler.c,430 :: 		_MotorDC_SetDirection(&motorDC, (MotorDirection)handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	PUSH	W10
	MOV.B	[W0], W11
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_SetDirection
	POP	W10
;command_handler.c,431 :: 		sprintf(handler->response_buffer, "MOTOR_DIR set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_55_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,432 :: 		} else {
	GOTO	L_handle_set_motor_dir53
L_handle_set_motor_dir52:
;command_handler.c,433 :: 		sprintf(handler->response_buffer, "Invalid MOTOR_DIR value: %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_56_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,434 :: 		}
L_handle_set_motor_dir53:
;command_handler.c,435 :: 		}
L_end_handle_set_motor_dir:
	POP	W11
	RETURN
; end of _handle_set_motor_dir

_handle_get_motor_en:

;command_handler.c,437 :: 		void handle_get_motor_en(CommandHandler *handler) {
;command_handler.c,439 :: 		sprintf(handler->response_buffer, "MOTOR_EN=%d\r\n", _MotorDC_GetStatus(&motorDC));
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetStatus
	POP	W10
	MOV	#34, W1
	ADD	W10, W1, W1
	ZE	W0, W0
	PUSH	W0
	MOV	#lo_addr(?lstr_57_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,440 :: 		}
L_end_handle_get_motor_en:
	RETURN
; end of _handle_get_motor_en

_handle_set_motor_en:

;command_handler.c,442 :: 		void handle_set_motor_en(CommandHandler *handler) {
;command_handler.c,443 :: 		sprintf(handler->response_buffer, "MOTOR_EN set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_58_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,454 :: 		}
L_end_handle_set_motor_en:
	RETURN
; end of _handle_set_motor_en

_handle_get_motor_speed:

;command_handler.c,456 :: 		void handle_get_motor_speed(CommandHandler *handler) {
;command_handler.c,458 :: 		sprintf(handler->response_buffer, "MOTOR_SPEED=%.2f\r\n", _MotorDC_GetTargetSpeed(&motorDC));
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_GetTargetSpeed
	POP	W10
	MOV	#34, W2
	ADD	W10, W2, W2
	PUSH.D	W0
	MOV	#lo_addr(?lstr_59_command_handler), W0
	PUSH	W0
	PUSH	W2
	CALL	_sprintf
	SUB	#8, W15
;command_handler.c,459 :: 		}
L_end_handle_get_motor_speed:
	RETURN
; end of _handle_get_motor_speed

_handle_set_motor_speed:

;command_handler.c,461 :: 		void handle_set_motor_speed(CommandHandler *handler) {
;command_handler.c,463 :: 		_MotorDC_SetTargetSpeed(&motorDC, handler->command_value);
	PUSH	W11
	PUSH	W12
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	PUSH	W10
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, W11
	MOV	W1, W12
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_SetTargetSpeed
	POP	W10
;command_handler.c,464 :: 		sprintf(handler->response_buffer, "MOTOR_SPEED set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_60_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,465 :: 		}
L_end_handle_set_motor_speed:
	POP	W12
	POP	W11
	RETURN
; end of _handle_set_motor_speed

_handle_get_relay1:

;command_handler.c,471 :: 		void handle_get_relay1(CommandHandler *handler) {
;command_handler.c,472 :: 		sprintf(handler->response_buffer, "RELAY1=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_61_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,473 :: 		}
L_end_handle_get_relay1:
	RETURN
; end of _handle_get_relay1

_handle_set_relay1:

;command_handler.c,474 :: 		void handle_set_relay1(CommandHandler *handler) {
;command_handler.c,475 :: 		sprintf(handler->response_buffer, "RELAY1 set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_62_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,476 :: 		}
L_end_handle_set_relay1:
	RETURN
; end of _handle_set_relay1

_handle_get_relay2:

;command_handler.c,477 :: 		void handle_get_relay2(CommandHandler *handler) {
;command_handler.c,478 :: 		sprintf(handler->response_buffer, "RELAY2=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_63_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,479 :: 		}
L_end_handle_get_relay2:
	RETURN
; end of _handle_get_relay2

_handle_set_relay2:

;command_handler.c,480 :: 		void handle_set_relay2(CommandHandler *handler) {
;command_handler.c,481 :: 		sprintf(handler->response_buffer, "RELAY2 set to %d\r\n", handler->command_value);
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W2
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W2
	MOV	#lo_addr(?lstr_64_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,482 :: 		}
L_end_handle_set_relay2:
	RETURN
; end of _handle_set_relay2

_handle_get_rfid_err:

;command_handler.c,485 :: 		void handle_get_rfid_err(CommandHandler *handler) {
;command_handler.c,486 :: 		sprintf(handler->response_buffer, "RFID_ERR=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_65_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,487 :: 		}
L_end_handle_get_rfid_err:
	RETURN
; end of _handle_get_rfid_err

_handle_get_rfid_cur_loc:

;command_handler.c,488 :: 		void handle_get_rfid_cur_loc(CommandHandler *handler) {
;command_handler.c,489 :: 		sprintf(handler->response_buffer, "RFID_CUR_LOC=Null\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_66_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,490 :: 		}
L_end_handle_get_rfid_cur_loc:
	RETURN
; end of _handle_get_rfid_cur_loc

_handle_get_rfid_tar_loc:

;command_handler.c,491 :: 		void handle_get_rfid_tar_loc(CommandHandler *handler) {
;command_handler.c,492 :: 		sprintf(handler->response_buffer, "RFID_TAR_LOC=Null\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_67_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,493 :: 		}
L_end_handle_get_rfid_tar_loc:
	RETURN
; end of _handle_get_rfid_tar_loc

_handle_get_fw_ver:

;command_handler.c,496 :: 		void handle_get_fw_ver(CommandHandler *handler) {
;command_handler.c,497 :: 		sprintf(handler->response_buffer, "FW_VER=%s\r\n"),FW_VER;
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_68_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,498 :: 		}
L_end_handle_get_fw_ver:
	RETURN
; end of _handle_get_fw_ver

_handle_get_robot_model:

;command_handler.c,499 :: 		void handle_get_robot_model(CommandHandler *handler) {
;command_handler.c,500 :: 		sprintf(handler->response_buffer, "ROBOT_MODEL=%s\r\n",ROBOT_MODEL);
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(_ROBOT_MODEL), W0
	PUSH	W0
	MOV	#lo_addr(?lstr_69_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,501 :: 		}
L_end_handle_get_robot_model:
	RETURN
; end of _handle_get_robot_model

_handle_get_robot_id:

;command_handler.c,502 :: 		void handle_get_robot_id(CommandHandler *handler) {
;command_handler.c,503 :: 		sprintf(handler->response_buffer, "ROBOT_ID=%s\r\n", DEVICE_ID);
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(_DEVICE_ID), W0
	PUSH	W0
	MOV	#lo_addr(?lstr_70_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,504 :: 		}
L_end_handle_get_robot_id:
	RETURN
; end of _handle_get_robot_id

_handle_get_robot_serial:

;command_handler.c,506 :: 		void handle_get_robot_serial(CommandHandler *handler) {
;command_handler.c,507 :: 		sprintf(handler->response_buffer, "ROBOT_SERIAL=%s\r\n", DEVICE_SERIAL);
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(_DEVICE_SERIAL), W0
	PUSH	W0
	MOV	#lo_addr(?lstr_71_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,508 :: 		}
L_end_handle_get_robot_serial:
	RETURN
; end of _handle_get_robot_serial

_handle_get_safe_sensor_front:

;command_handler.c,511 :: 		void handle_get_safe_sensor_front(CommandHandler *handler) {
;command_handler.c,512 :: 		sprintf(handler->response_buffer, "SAFE_SENSOR_FRONT=1\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_72_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,513 :: 		}
L_end_handle_get_safe_sensor_front:
	RETURN
; end of _handle_get_safe_sensor_front

_handle_get_safe_sensor_rear:

;command_handler.c,514 :: 		void handle_get_safe_sensor_rear(CommandHandler *handler) {
;command_handler.c,515 :: 		sprintf(handler->response_buffer, "SAFE_SENSOR_REAR=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_73_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,516 :: 		}
L_end_handle_get_safe_sensor_rear:
	RETURN
; end of _handle_get_safe_sensor_rear

_handle_get_update_status:

;command_handler.c,518 :: 		void handle_get_update_status(CommandHandler *handler){
;command_handler.c,519 :: 		sprintf(handler->response_buffer, "UPDATE_TASK_STATUS =% d\r\n",task_get_status(_task_update_to_server));
	MOV	#lo_addr(__task_update_to_server), W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_task_get_status
	POP	W10
	MOV	#34, W1
	ADD	W10, W1, W1
	ZE	W0, W0
	PUSH	W0
	MOV	#lo_addr(?lstr_74_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,520 :: 		}
L_end_handle_get_update_status:
	RETURN
; end of _handle_get_update_status

_handle_set_update_status:

;command_handler.c,521 :: 		void handle_set_update_status(CommandHandler *handler){
;command_handler.c,522 :: 		sprintf(handler->response_buffer, "SAFE_SENSOR_REAR=0\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_75_command_handler), W0
	PUSH	W10
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
	POP	W10
;command_handler.c,523 :: 		if (handler->command_value == 1) {
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #1
	BRA Z	L__handle_set_update_status244
	GOTO	L_handle_set_update_status54
L__handle_set_update_status244:
;command_handler.c,524 :: 		task_resume(_task_update_to_server);
	MOV	#lo_addr(__task_update_to_server), W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_task_resume
	POP	W10
;command_handler.c,525 :: 		sprintf(handler->response_buffer, "UPDATE_TASK_STATUS ON\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_76_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,526 :: 		} else if (handler->command_value == 0) {
	GOTO	L_handle_set_update_status55
L_handle_set_update_status54:
	MOV	#32, W0
	ADD	W10, W0, W0
	MOV	[W0], W0
	CP	W0, #0
	BRA Z	L__handle_set_update_status245
	GOTO	L_handle_set_update_status56
L__handle_set_update_status245:
;command_handler.c,527 :: 		task_stop(_task_update_to_server);
	MOV	#lo_addr(__task_update_to_server), W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_task_stop
	POP	W10
;command_handler.c,528 :: 		sprintf(handler->response_buffer, "UPDATE_TASK_STATUS OFF\r\n");
	MOV	#34, W0
	ADD	W10, W0, W1
	MOV	#lo_addr(?lstr_77_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#4, W15
;command_handler.c,529 :: 		}
L_handle_set_update_status56:
L_handle_set_update_status55:
;command_handler.c,530 :: 		}
L_end_handle_set_update_status:
	RETURN
; end of _handle_set_update_status

_handle_charge_config:
	LNK	#4

;command_handler.c,532 :: 		void handle_charge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
;command_handler.c,534 :: 		if (JSON_GetInt(dataParser, "current_limit", &current_limit) &&
	PUSH	W11
	ADD	W14, #0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_78_command_handler), W11
	CALL	_JSON_GetInt
	POP.D	W10
	POP	W12
;command_handler.c,535 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
	CP0	W0
	BRA NZ	L__handle_charge_config247
	GOTO	L__handle_charge_config118
L__handle_charge_config247:
	ADD	W14, #2, W0
	PUSH	W12
	PUSH	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_79_command_handler), W11
	CALL	_JSON_GetInt
	POP	W10
	POP	W12
	CP0	W0
	BRA NZ	L__handle_charge_config248
	GOTO	L__handle_charge_config117
L__handle_charge_config248:
L__handle_charge_config116:
;command_handler.c,537 :: 		if (enable == 0)
	MOV	[W14+2], W0
	CP	W0, #0
	BRA Z	L__handle_charge_config249
	GOTO	L_handle_charge_config60
L__handle_charge_config249:
;command_handler.c,539 :: 		LATB4_bit = 0;
	BCLR	LATB4_bit, BitPos(LATB4_bit+0)
;command_handler.c,540 :: 		LATA8_bit = 0;
	BCLR	LATA8_bit, BitPos(LATA8_bit+0)
;command_handler.c,541 :: 		}
	GOTO	L_handle_charge_config61
L_handle_charge_config60:
;command_handler.c,542 :: 		else if (enable == 1)
	MOV	[W14+2], W0
	CP	W0, #1
	BRA Z	L__handle_charge_config250
	GOTO	L_handle_charge_config62
L__handle_charge_config250:
;command_handler.c,544 :: 		LATB4_bit = 1;
	BSET	LATB4_bit, BitPos(LATB4_bit+0)
;command_handler.c,545 :: 		LATA8_bit = 1;
	BSET	LATA8_bit, BitPos(LATA8_bit+0)
;command_handler.c,546 :: 		}
	GOTO	L_handle_charge_config63
L_handle_charge_config62:
;command_handler.c,549 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_80_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,550 :: 		return;
	GOTO	L_end_handle_charge_config
;command_handler.c,551 :: 		}
L_handle_charge_config63:
L_handle_charge_config61:
;command_handler.c,552 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_81_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,553 :: 		} else {
	GOTO	L_handle_charge_config64
;command_handler.c,535 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
L__handle_charge_config118:
L__handle_charge_config117:
;command_handler.c,554 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_82_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,555 :: 		}
L_handle_charge_config64:
;command_handler.c,556 :: 		}
L_end_handle_charge_config:
	POP	W11
	ULNK
	RETURN
; end of _handle_charge_config

_handle_discharge_config:

;command_handler.c,559 :: 		void handle_discharge_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
;command_handler.c,576 :: 		}
L_end_handle_discharge_config:
	RETURN
; end of _handle_discharge_config

_handle_lifter_config:
	LNK	#6

;command_handler.c,578 :: 		void handle_lifter_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
;command_handler.c,581 :: 		if (JSON_GetInt(dataParser, "target_position", &target_position) &&
	PUSH	W10
	PUSH	W11
	ADD	W14, #0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_83_command_handler), W11
	CALL	_JSON_GetInt
	POP.D	W10
	POP	W12
;command_handler.c,582 :: 		JSON_GetInt(dataParser, "max_output", &max_output) &&
	CP0	W0
	BRA NZ	L__handle_lifter_config253
	GOTO	L__handle_lifter_config126
L__handle_lifter_config253:
	ADD	W14, #4, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_84_command_handler), W11
	CALL	_JSON_GetInt
	POP.D	W10
	POP	W12
	CP0	W0
	BRA NZ	L__handle_lifter_config254
	GOTO	L__handle_lifter_config125
L__handle_lifter_config254:
;command_handler.c,583 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
	ADD	W14, #2, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_85_command_handler), W11
	CALL	_JSON_GetInt
	POP.D	W10
	POP	W12
	CP0	W0
	BRA NZ	L__handle_lifter_config255
	GOTO	L__handle_lifter_config124
L__handle_lifter_config255:
L__handle_lifter_config121:
;command_handler.c,588 :: 		_Lifter_SetTargetPosition(&lifter, target_position);
	PUSH	W12
	PUSH	W10
	MOV	[W14+0], W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, W11
	MOV	W1, W12
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_SetTargetPosition
	POP	W10
	POP	W12
;command_handler.c,589 :: 		if (max_output > 100 || max_output < 0)
	MOV	#100, W1
	ADD	W14, #4, W0
	CP	W1, [W0]
	BRA GE	L__handle_lifter_config256
	GOTO	L__handle_lifter_config123
L__handle_lifter_config256:
	MOV	[W14+4], W0
	CP	W0, #0
	BRA GE	L__handle_lifter_config257
	GOTO	L__handle_lifter_config122
L__handle_lifter_config257:
	GOTO	L_handle_lifter_config70
L__handle_lifter_config123:
L__handle_lifter_config122:
;command_handler.c,590 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	PUSH	W10
	PUSH	W12
	MOV	#lo_addr(?lstr_86_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
	POP	W10
	POP	W12
	GOTO	L_handle_lifter_config71
L_handle_lifter_config70:
;command_handler.c,592 :: 		_Lifter_Set_maxOutput(&lifter, max_output);
	PUSH	W12
	PUSH	W10
	MOV	[W14+4], W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, W11
	MOV	W1, W12
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Set_maxOutput
	POP	W10
	POP	W12
;command_handler.c,593 :: 		}
L_handle_lifter_config71:
;command_handler.c,594 :: 		if (enable == 0)
	MOV	[W14+2], W0
	CP	W0, #0
	BRA Z	L__handle_lifter_config258
	GOTO	L_handle_lifter_config72
L__handle_lifter_config258:
;command_handler.c,595 :: 		_Lifter_Disable(&lifter);
	PUSH	W12
	PUSH	W10
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Disable
	POP	W10
	POP	W12
	GOTO	L_handle_lifter_config73
L_handle_lifter_config72:
;command_handler.c,596 :: 		else if (enable == 1)
	MOV	[W14+2], W0
	CP	W0, #1
	BRA Z	L__handle_lifter_config259
	GOTO	L_handle_lifter_config74
L__handle_lifter_config259:
;command_handler.c,597 :: 		_Lifter_Enable(&lifter);
	PUSH	W12
	PUSH	W10
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Enable
	POP	W10
	POP	W12
	GOTO	L_handle_lifter_config75
L_handle_lifter_config74:
;command_handler.c,599 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_87_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,600 :: 		_Lifter_Disable(&lifter);
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Disable
;command_handler.c,601 :: 		return;
	GOTO	L_end_handle_lifter_config
;command_handler.c,602 :: 		}
L_handle_lifter_config75:
L_handle_lifter_config73:
;command_handler.c,603 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_88_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,604 :: 		}
	GOTO	L_handle_lifter_config76
;command_handler.c,582 :: 		JSON_GetInt(dataParser, "max_output", &max_output) &&
L__handle_lifter_config126:
L__handle_lifter_config125:
;command_handler.c,583 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
L__handle_lifter_config124:
;command_handler.c,605 :: 		else if (JSON_GetInt(dataParser, "target_position", &target_position) &&
	ADD	W14, #0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_89_command_handler), W11
	CALL	_JSON_GetInt
	POP.D	W10
	POP	W12
;command_handler.c,606 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
	CP0	W0
	BRA NZ	L__handle_lifter_config260
	GOTO	L__handle_lifter_config128
L__handle_lifter_config260:
	ADD	W14, #2, W0
	PUSH	W12
	PUSH	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_90_command_handler), W11
	CALL	_JSON_GetInt
	POP	W10
	POP	W12
	CP0	W0
	BRA NZ	L__handle_lifter_config261
	GOTO	L__handle_lifter_config127
L__handle_lifter_config261:
L__handle_lifter_config119:
;command_handler.c,611 :: 		_Lifter_SetTargetPosition(&lifter, target_position);
	PUSH	W12
	PUSH	W10
	MOV	[W14+0], W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, W11
	MOV	W1, W12
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_SetTargetPosition
	POP	W10
	POP	W12
;command_handler.c,612 :: 		if (enable == 0)
	MOV	[W14+2], W0
	CP	W0, #0
	BRA Z	L__handle_lifter_config262
	GOTO	L_handle_lifter_config80
L__handle_lifter_config262:
;command_handler.c,613 :: 		_Lifter_Disable(&lifter);
	PUSH	W12
	PUSH	W10
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Disable
	POP	W10
	POP	W12
	GOTO	L_handle_lifter_config81
L_handle_lifter_config80:
;command_handler.c,614 :: 		else if (enable == 1)
	MOV	[W14+2], W0
	CP	W0, #1
	BRA Z	L__handle_lifter_config263
	GOTO	L_handle_lifter_config82
L__handle_lifter_config263:
;command_handler.c,615 :: 		_Lifter_Enable(&lifter);
	PUSH	W12
	PUSH	W10
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Enable
	POP	W10
	POP	W12
	GOTO	L_handle_lifter_config83
L_handle_lifter_config82:
;command_handler.c,617 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_91_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,618 :: 		_Lifter_Disable(&lifter);
	MOV	#lo_addr(_lifter), W10
	CALL	__Lifter_Disable
;command_handler.c,619 :: 		return;
	GOTO	L_end_handle_lifter_config
;command_handler.c,620 :: 		}
L_handle_lifter_config83:
L_handle_lifter_config81:
;command_handler.c,621 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_92_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,622 :: 		}
	GOTO	L_handle_lifter_config84
;command_handler.c,606 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
L__handle_lifter_config128:
L__handle_lifter_config127:
;command_handler.c,625 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_93_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,626 :: 		}
L_handle_lifter_config84:
L_handle_lifter_config76:
;command_handler.c,627 :: 		}
L_end_handle_lifter_config:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _handle_lifter_config

_handle_motorDC_config:
	LNK	#6

;command_handler.c,629 :: 		void handle_motorDC_config(CommandHandler *handler, JSON_Parser *dataParser, char *id){
;command_handler.c,631 :: 		if (JSON_GetInt(dataParser, "direction", &direction) &&
	PUSH	W11
	ADD	W14, #0, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_94_command_handler), W11
	CALL	_JSON_GetInt
	POP.D	W10
	POP	W12
;command_handler.c,632 :: 		JSON_GetInt(dataParser, "speed", &speed) &&
	CP0	W0
	BRA NZ	L__handle_motorDC_config265
	GOTO	L__handle_motorDC_config135
L__handle_motorDC_config265:
	ADD	W14, #2, W0
	PUSH	W12
	PUSH.D	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_95_command_handler), W11
	CALL	_JSON_GetInt
	POP.D	W10
	POP	W12
	CP0	W0
	BRA NZ	L__handle_motorDC_config266
	GOTO	L__handle_motorDC_config134
L__handle_motorDC_config266:
;command_handler.c,633 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
	ADD	W14, #4, W0
	PUSH	W12
	PUSH	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_96_command_handler), W11
	CALL	_JSON_GetInt
	POP	W10
	POP	W12
	CP0	W0
	BRA NZ	L__handle_motorDC_config267
	GOTO	L__handle_motorDC_config133
L__handle_motorDC_config267:
L__handle_motorDC_config130:
;command_handler.c,634 :: 		if (direction == 0 || direction == 1)
	MOV	[W14+0], W0
	CP	W0, #0
	BRA NZ	L__handle_motorDC_config268
	GOTO	L__handle_motorDC_config132
L__handle_motorDC_config268:
	MOV	[W14+0], W0
	CP	W0, #1
	BRA NZ	L__handle_motorDC_config269
	GOTO	L__handle_motorDC_config131
L__handle_motorDC_config269:
	GOTO	L_handle_motorDC_config90
L__handle_motorDC_config132:
L__handle_motorDC_config131:
;command_handler.c,635 :: 		_MotorDC_SetDirection(&motorDC, direction);
	PUSH	W12
	PUSH	W10
	MOV.B	[W14+0], W11
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_SetDirection
	POP	W10
	POP	W12
	GOTO	L_handle_motorDC_config91
L_handle_motorDC_config90:
;command_handler.c,637 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_97_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,638 :: 		return;
	GOTO	L_end_handle_motorDC_config
;command_handler.c,639 :: 		}
L_handle_motorDC_config91:
;command_handler.c,641 :: 		_MotorDC_SetTargetSpeed(&motorDC, speed);
	PUSH	W12
	PUSH	W10
	MOV	[W14+2], W0
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	W0, W11
	MOV	W1, W12
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_SetTargetSpeed
	POP	W10
	POP	W12
;command_handler.c,642 :: 		if (enable == 1){
	MOV	[W14+4], W0
	CP	W0, #1
	BRA Z	L__handle_motorDC_config270
	GOTO	L_handle_motorDC_config92
L__handle_motorDC_config270:
;command_handler.c,643 :: 		_MotorDC_Enable(&motorDC);
	PUSH	W12
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_Enable
	POP	W10
	POP	W12
;command_handler.c,644 :: 		}
	GOTO	L_handle_motorDC_config93
L_handle_motorDC_config92:
;command_handler.c,646 :: 		else if (enable == 0){
	MOV	[W14+4], W0
	CP	W0, #0
	BRA Z	L__handle_motorDC_config271
	GOTO	L_handle_motorDC_config94
L__handle_motorDC_config271:
;command_handler.c,648 :: 		_MotorDC_Disable(&motorDC);
	PUSH	W12
	PUSH	W10
	MOV	#lo_addr(_motorDC), W10
	CALL	__MotorDC_Disable
	POP	W10
	POP	W12
;command_handler.c,649 :: 		}
	GOTO	L_handle_motorDC_config95
L_handle_motorDC_config94:
;command_handler.c,651 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_98_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,652 :: 		return;
	GOTO	L_end_handle_motorDC_config
;command_handler.c,653 :: 		}
L_handle_motorDC_config95:
L_handle_motorDC_config93:
;command_handler.c,654 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":1}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_99_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,656 :: 		} else {
	GOTO	L_handle_motorDC_config96
;command_handler.c,632 :: 		JSON_GetInt(dataParser, "speed", &speed) &&
L__handle_motorDC_config135:
L__handle_motorDC_config134:
;command_handler.c,633 :: 		JSON_GetInt(dataParser, "enable", &enable)) {
L__handle_motorDC_config133:
;command_handler.c,657 :: 		sprintf(handler->response_buffer, ">{\"type\":1,\"id\":\"%s\",\"status\":0}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_100_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,659 :: 		}
L_handle_motorDC_config96:
;command_handler.c,660 :: 		}
L_end_handle_motorDC_config:
	POP	W11
	ULNK
	RETURN
; end of _handle_motorDC_config

_handle_ping_command:
	LNK	#2

;command_handler.c,662 :: 		void handle_ping_command(CommandHandler *handler, JSON_Parser *dataParser, char *id){
;command_handler.c,664 :: 		if (JSON_GetInt(dataParser, "type", &type)){
	PUSH	W11
	ADD	W14, #0, W0
	PUSH	W12
	PUSH	W10
	MOV	W0, W12
	MOV	W11, W10
	MOV	#lo_addr(?lstr_101_command_handler), W11
	CALL	_JSON_GetInt
	POP	W10
	POP	W12
	CP0	W0
	BRA NZ	L__handle_ping_command273
	GOTO	L_handle_ping_command97
L__handle_ping_command273:
;command_handler.c,665 :: 		if (type == 4){
	MOV	[W14+0], W0
	CP	W0, #4
	BRA Z	L__handle_ping_command274
	GOTO	L_handle_ping_command98
L__handle_ping_command274:
;command_handler.c,666 :: 		sprintf(handler->response_buffer, ">{\"type\":4,\"id\":\"%s\",\"dev_id\":\"pic\"}\r\n", id);
	MOV	#34, W0
	ADD	W10, W0, W1
	PUSH	W12
	MOV	#lo_addr(?lstr_102_command_handler), W0
	PUSH	W0
	PUSH	W1
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,667 :: 		return;
	GOTO	L_end_handle_ping_command
;command_handler.c,668 :: 		}
L_handle_ping_command98:
;command_handler.c,669 :: 		}
	GOTO	L_handle_ping_command99
L_handle_ping_command97:
;command_handler.c,670 :: 		else return;
	GOTO	L_end_handle_ping_command
L_handle_ping_command99:
;command_handler.c,671 :: 		}
L_end_handle_ping_command:
	POP	W11
	ULNK
	RETURN
; end of _handle_ping_command

_handle_get_box_status:

;command_handler.c,672 :: 		void handle_get_box_status(CommandHandler *handler){
;command_handler.c,674 :: 		(int) Box_t.limit_switch_state);
	MOV	#lo_addr(_Box_t+4), W0
	ZE	[W0], W2
;command_handler.c,673 :: 		sprintf(handler->response_buffer, ">{\"type\":0,\"state_type\":7,\"data\":{\"object\":%d}}\r\n",
	MOV	#34, W0
	ADD	W10, W0, W1
;command_handler.c,674 :: 		(int) Box_t.limit_switch_state);
	PUSH	W2
;command_handler.c,673 :: 		sprintf(handler->response_buffer, ">{\"type\":0,\"state_type\":7,\"data\":{\"object\":%d}}\r\n",
	MOV	#lo_addr(?lstr_103_command_handler), W0
	PUSH	W0
	PUSH	W1
;command_handler.c,674 :: 		(int) Box_t.limit_switch_state);
	CALL	_sprintf
	SUB	#6, W15
;command_handler.c,675 :: 		}
L_end_handle_get_box_status:
	RETURN
; end of _handle_get_box_status
