--!strict
--!nolint ImportUnused

local YarnProgram = require(script.Parent:WaitForChild("YarnProgram"))

export type Library = {
	functions: { [string]: Function },

	GetFunction: (self: Library, name: string) -> Function,
	ImportLibrary: (self: Library, other: Library) -> (),
	RegisterFunction: (self: Library, name: string, func: YarnFunction) -> (),
	RegisterStandardLibrary: (self: Library) -> (),
	FunctionExists: (self: Library, name: string) -> boolean,
	DeregisterFunction: (self: Library, name: string) -> (),
	GenerateUniqueVisitedVariableForNode: (self: Library, name: string) -> string,
}

--- @type Function { argumentCount: number, func: YarnFunction }
--- @within Library
---
--- Represents a function registered to a Library.
export type Function = {
	argumentCount: number,
	func: YarnFunction,
}

--- @type YarnFunction (...Operand?) -> Operand
--- @within Library
---
--- A function to be called by a Yarn program.
export type YarnFunction = (...YarnProgram.Operand?) -> YarnProgram.Operand?

return {}
