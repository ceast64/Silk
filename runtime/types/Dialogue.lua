--!strict
--!nolint ImportUnused

local YarnProgram = require(script.Parent:WaitForChild("YarnProgram"))
local Library = require(script.Parent:WaitForChild("Library"))
local Stack = require(script.Parent:WaitForChild("Stack"))

export type Dialogue = {
	CurrentNode: string?,
	DebugMode: boolean?,
	DefaultStartNodeName: string?,
	IsActive: boolean,
	Library: Library.Library,
	Program: YarnProgram.YarnProgram?,
	VariableStorage: { [string]: YarnProgram.Operand },
	VirtualMachine: any,

	OnCommand: CommandHandler?,
	OnDebug: DebugHandler?,
	OnDialogueComplete: DialogueCompleteHandler?,
	OnLine: LineHandler?,
	OnNodeComplete: NodeCompleteHandler?,
	OnNodeStart: NodeStartHandler?,
	OnOptions: OptionsHandler?,
	OnPrepareForLines: PrepareForLinesHandler?,

	AddProgram: (self: Dialogue, program: YarnProgram.YarnProgram) -> (),
	Continue: (self: Dialogue) -> (),
	ExpandSubstitutions: (self: Dialogue, text: string, substitutions: { string }?) -> string,
	GetExecutionState: (
		self: Dialogue
	) -> "Stopped" | "WaitingOnOptionSelection" | "WaitingForContinue" | "DeliveringContent" | "Running",
	GetNodeNames: (self: Dialogue) -> { string },
	GetTagsForNode: (self: Dialogue, nodeName: string) -> { string }?,
	SetProgram: (self: Dialogue, program: YarnProgram.YarnProgram) -> (),
	SetSelectedOption: (self: Dialogue, selectedOptionID: number) -> (),
	Stop: (self: Dialogue) -> (),
	UnloadAll: (self: Dialogue) -> (),
}
--- @type CommandHandler (text: string) -> ()
--- @within Dialogue
--- @tag handlers
---
--- Called by the Dialogue whenever a command is executed.
export type CommandHandler = (text: string) -> ()

--- @type DebugHandler (i: Instruction, stack: Stack) -> ()
--- @within Dialogue
--- @tag handlers
--- @private
---
--- Called by the [VirtualMachine](VirtualMachine) when [DebugMode](Dialogue#DebugMode) is enabled.
--- Contains debug information about the current instruction
--- and the stack.
export type DebugHandler = (i: YarnProgram.Instruction, stack: Stack.Stack) -> ()

--- @type DialogueCompleteHandler () -> ()
--- @within Dialogue
--- @tag handlers
---
--- Called by the Dialogue when the dialogue has reached its end and there is no more code to run.
export type DialogueCompleteHandler = () -> ()

--- @type LineHandler (line: Line) -> ()
--- @within Dialogue
--- @tag handlers
---
--- Called by the Dialogue when it delivers a line to the game.
export type LineHandler = (line: Line) -> ()

--- @type NodeCompleteHandler (name: string) -> ()
--- @within Dialogue
--- @tag handlers
---
--- Called by the Dialogue when it reaches the end of a Node.
export type NodeCompleteHandler = (name: string) -> ()

--- @type NodeStartHandler (name: string) -> ()
--- @within Dialogue
--- @tag handlers
---
--- Called by the Dialogue when it begins executing a Node.
export type NodeStartHandler = (name: string) -> ()

--- @type OptionsHandler ({ Option }) -> ()
--- @within Dialogue
--- @tag handlers
export type OptionsHandler = ({ Option }) -> ()

--- @type PrepareForLinesHandler (lineIDs: { string }) -> ()
--- @within Dialogue
--- @tag handlers
---
--- Called by the Dialogue when it anticipates that it will deliver lines.
--- This method should begin preparing to run the lines.  For example,
--- if a game delivers dialogue via voice-over, the appropriate audio files should be loaded.
--- :::caution
--- This method serves to provide a hint to the game that a line _may_ be run. Not every line indicated in `lineIDs` may end up actually running.
--- :::
--- This method may be called any number of times during a dialogue session.
export type PrepareForLinesHandler = (lineIDs: { string }) -> ()

--- @type Line { id: string, substitutions: { string }? }
--- @within Dialogue
---
--- Represents a line of Yarn dialogue.
--- :::caution
--- When the game receives a Line, it should do the following things to prepare the line for presentation to the user.
--- - Use the value in the ID property to look up the appropriate user-facing text in the string table.
--- - Use `ExpandSubstitutions()` to replace all substitutions in the user-facing text.
--- - Parse any markup in the line.
--- :::
export type Line = {
	id: string,
	substitutions: { string }?,
}

--- @type Option { line: Line, destination: string, enabled: boolean }
--- @within Dialogue
---
--- Represents an option in a Yarn dialogue. The `destination` property is
--- the node ID to run if the option is selected.
export type Option = {
	line: Line,
	index: number,
	destination: string,
	enabled: boolean,
}

return {}
