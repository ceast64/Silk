--!strict

--- @class RawProgram
---
--- Typedefs for Yarn programs outputted from the CLI tool.

--- @type RawProgram { name: string?, nodes: { [string]: RawProgram.Node }, initial_values: { [string]: RawProgram.Operand } }
--- @within RawProgram
export type RawProgram = {
	name: string?,
	nodes: { [string]: Node },
	initialValues: { [string]: Operand }?,
}

--- @type Node { name: string, instructions: {  }, labels: { [string]: number }?, tags: { string }?, sourceTextStringId: string?, headers: { RawProgram.Header }? }
--- @within RawProgram
export type Node = {
	name: string,
	instructions: { Instruction },
	labels: { [string]: number }?,
	tags: { string }?,
	sourceTextStringID: string?,
	headers: { Header }?,
}

--- @type Header { key: string, value: string }
--- @within RawProgram
export type Header = {
	key: string,
	value: string,
}

--- @type Instruction { opcode: RawProgram.Opcode, operands: { RawProgram.Operand }? }
--- @within RawProgram
export type Instruction = {
	opcode: Opcode,
	operands: { Operand }?,
}

--- @type Opcode "JUMP_TO" | "JUMP" | "RUN_LINE"	| "RUN_COMMAND"	| "ADD_OPTION"	| "SHOW_OPTIONS"	| "PUSH_STRING"	| "PUSH_FLOAT"	| "PUSH_BOOL"	| "PUSH_NULL"	| "JUMP_IF_FALSE"	| "POP"	| "CALL_FUNC" | "PUSH_VARIABLE" | "STORE_VARIABLE" | "STOP" | "RUN_NODE"
--- @within RawProgram
export type Opcode =
	"JUMP_TO"
	| "JUMP"
	| "RUN_LINE"
	| "RUN_COMMAND"
	| "ADD_OPTION"
	| "SHOW_OPTIONS"
	| "PUSH_STRING"
	| "PUSH_FLOAT"
	| "PUSH_BOOL"
	| "PUSH_NULL"
	| "JUMP_IF_FALSE"
	| "POP"
	| "CALL_FUNC"
	| "PUSH_VARIABLE"
	| "STORE_VARIABLE"
	| "STOP"
	| "RUN_NODE"

--- @type Operand { string_value: string?, bool_value: boolean?, float_value: number? }
--- @within RawProgram
export type Operand = {
	stringValue: string?,
	boolValue: boolean?,
	floatValue: number?,
}

--- @prop Opcodes { [Opcode]: number }
--- @within RawProgram
---
--- Opcode name to number lookup

return {
	Opcodes = {
		["JUMP_TO"] = 0,
		["JUMP"] = 1,
		["RUN_LINE"] = 2,
		["RUN_COMMAND"] = 3,
		["ADD_OPTION"] = 4,
		["SHOW_OPTIONS"] = 5,
		["PUSH_STRING"] = 6,
		["PUSH_FLOAT"] = 7,
		["PUSH_BOOL"] = 8,
		["PUSH_NULL"] = 9,
		["JUMP_IF_FALSE"] = 10,
		["POP"] = 11,
		["CALL_FUNC"] = 12,
		["PUSH_VARIABLE"] = 13,
		["STORE_VARIABLE"] = 14,
		["STOP"] = 15,
		["RUN_NODE"] = 16,
	} :: { [Opcode]: number },
}
