--!strict

local YarnProgram = require(script.Parent:WaitForChild("YarnProgram"))

--- @type Line { id: string, substitutions: { string } }
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
	substitutions: { string },
}

--- @type YarnFunction (...YarnProgram.Operand) -> ...YarnProgram.Operand
--- @within Dialogue
---
--- A function that can be called by Yarn code.
export type YarnFunction = (...YarnProgram.Operand) -> ...YarnProgram.Operand

--- @type OptionsHandler () -> ()
--- @within Dialogue
--- @tag handlers
export type OptionsHandler = () -> ()

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
