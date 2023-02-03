--!strict
--!nolint ImportUnused

local YarnProgram = require(script.Parent:WaitForChild("YarnProgram"))

export type Dialogue = {
	DefaultStartNodeName: string?,
	VariableStorage: { [string]: YarnProgram.Operand },
	IsActive: boolean,
	Library: { [string]: LibraryFunction },
	CurrentNode: string?,

	Program: YarnProgram.YarnProgram?,
	VirtualMachine: any,

	OnOptions: OptionsHandler?,
	OnCommand: CommandHandler?,
	OnDialogueComplete: DialogueCompleteHandler?,
	OnLine: LineHandler?,
	OnNodeComplete: NodeCompleteHandler?,
	OnNodeStart: NodeStartHandler?,
	OnPrepareForLines: PrepareForLinesHandler?,

	BindFunction: (self: Dialogue, name: string, argCount: number, func: YarnFunction) -> (),
	UnbindFunction: (self: Dialogue, name: string) -> (),

	GetNodeNames: (self: Dialogue) -> { string },
	AddProgram: (self: Dialogue, program: YarnProgram.YarnProgram) -> (),
	Continue: (self: Dialogue) -> (),
	ExpandSubstitutions: (self: Dialogue, text: string, substitutions: { string }) -> string,
	GetTagsForNode: (self: Dialogue, nodeName: string) -> { string }?,
	SetProgram: (self: Dialogue, program: YarnProgram.YarnProgram) -> (),
	Stop: (self: Dialogue) -> (),
	UnloadAll: (self: Dialogue) -> (),
}

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

--- @type LibraryFunction { argCount: number, argTypes: { YarnType }, returnType: YarnType?, func: YarnFunction }
--- @within Dialogue
---
--- Represents a function callable by Yarn.
export type LibraryFunction = {
	argCount: number,
	argTypes: { YarnType },
	returnType: YarnType?,
	func: YarnFunction,
}

--- @type YarnType "string" | "boolean" | "number"
--- @within Dialogue
---
--- A type of argument to a bound Yarn function.
export type YarnType = "string" | "boolean" | "number"

--- @type YarnFunction (...Operand) -> ...Operand
--- @within Dialogue
---
--- A function that can be called by Yarn code.
export type YarnFunction = (...YarnProgram.Operand) -> ...YarnProgram.Operand

--- @type OptionsHandler ({ Option }) -> ()
--- @within Dialogue
--- @tag handlers
export type OptionsHandler = ({ Option }) -> ()

--- @type CommandHandler (text: string) -> ()
--- @within Dialogue
--- @tag handlers
---
--- Called by the Dialogue whenever a command is executed.
export type CommandHandler = (text: string) -> ()

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

return {}
