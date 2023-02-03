--!strict
--!nolint ImportUnused

local YarnProgram = require(script.Parent:WaitForChild("YarnProgram"))

export type Stack = {
	items: { YarnProgram.Operand },

	push: (self: Stack, value: YarnProgram.Operand) -> number,
	peek: (self: Stack) -> YarnProgram.Operand,
	pop: (self: Stack) -> YarnProgram.Operand,
	clear: (self: Stack) -> (),
}

return {}
