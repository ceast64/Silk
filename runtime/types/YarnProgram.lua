--!strict

--- @class YarnProgram
---
--- Typedefs for Yarn programs to be used with the interpreter.

--- @type Header { key: string, value: string }
--- @within YarnProgram
export type Header = {
	key: string,
	value: string,
}

--- @type Instruction { opcode: number, operands: { Operand } }
--- @within YarnProgram
export type Instruction = {
	opcode: number,
	operands: { Operand },
}

--- @type Node { name: string, instructions: { Instruction }, labels: { [string]: number }, tags: { string }, sourceTextStringID: string?, headers: { Header } }
--- @within YarnProgram
export type Node = {
	name: string,
	instructions: { Instruction },
	labels: { [string]: number },
	tags: { string },
	sourceTextStringID: string?,
	headers: { Header },
}

--- @type Operand string | boolean | number
--- @within YarnProgram
export type Operand = string | boolean | number

--- @type StringInfo { text: string, nodeName: string, lineNumber: number, fileName: string, isImplicitTag: boolean, metadata: { string } }
--- @within YarnProgram
export type StringInfo = {
	text: string,
	nodeName: string,
	lineNumber: number,
	fileName: string,
	isImplicitTag: boolean,
	metadata: { string },
}

--- @type YarnProgram { name: string?,	nodes: { Node }, initial_values: { [string]: Operand },	strings: { [string]: StringInfo }, clone: () -> YarnProgram }
--- @within YarnProgram
export type YarnProgram = {
	name: string?,
	nodes: { [string]: Node },
	initial_values: { [string]: Operand },

	strings: { [string]: StringInfo },

	clone: () -> YarnProgram,
}

return {}
