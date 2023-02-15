--!strict
--!nolint ImportUnused

local Dialogue = require(script.Parent:WaitForChild("Dialogue"))
local Stack = require(script.Parent:WaitForChild("Stack"))
local YarnProgram = require(script.Parent:WaitForChild("YarnProgram"))

export type VirtualMachine = {
	currentNode: YarnProgram.Node?,
	currentNodeName: string?,
	currentOptions: { Dialogue.Option },
	dialogue: Dialogue.Dialogue,
	executionState: ExecutionState,
	programCounter: number,
	stack: Stack.Stack,

	CheckCanContinue: (self: VirtualMachine) -> (),
	Continue: (self: VirtualMachine) -> (),
	FindInstructionPointForLabel: (self: VirtualMachine, labelName: string) -> number,
	GetLine: (self: VirtualMachine, stringKey: string, expressionCount: number?) -> Dialogue.Line,
	ResetState: (self: VirtualMachine) -> (),
	RunInstruction: (self: VirtualMachine, i: YarnProgram.Instruction) -> (),
	SetNode: (self: VirtualMachine, nodeName: string) -> (),
	SetSelectedOption: (self: VirtualMachine, selectedOptionID: number) -> (),
}

--- @type ExecutionState "Stopped" | "WaitingOnOptionSelection" | "WaitingForContinue" | "DeliveringContent" | "Running"
--- @within VirtualMachine
---
--- The different states the VirtualMachine can be in.
--- - `"Stopped"` - The VirtualMachine is not running a node.
--- - `"WaitingOnOptionSelection"` - The VirtualMachine is waiting on option selection. Call [SetSelectedOption](VirtualMachine#SetSelectedOption) before calling [Continue](VirtualMachine#Continue)
--- - `"WaitingForContinue"` - The VirtualMachine has finished delivering content to the client game, and is waiting for [Continue](VirtualMachine#Continue) to be called.
--- - `"DeliveringContent"` - The VirtualMachine is delivering a line, options, or a commmand to the client game.
--- - `"Running"` - The VirtualMachine is in the middle of executing code.
export type ExecutionState =
	"Stopped"
	| "WaitingOnOptionSelection"
	| "WaitingForContinue"
	| "DeliveringContent"
	| "Running"

return {}
