--!strict

local Dialogue = {}
Dialogue.__index = Dialogue

local types = script.Parent:WaitForChild("types")
local YarnProgram = require(types:WaitForChild("YarnProgram"))
local DialogueTypes = require(types:WaitForChild("Dialogue"))

--- @class Dialogue
---
--- Dialogue class used for executing a Yarn script.
export type Dialogue = {
	DefaultStartNodeName: string,
	VariableStorage: { [string]: YarnProgram.Operand },
	IsActive: boolean,
	Library: { [string]: DialogueTypes.YarnFunction },
	CurrentNode: string,
	NodeNames: { string },

	Program: YarnProgram.YarnProgram?,

	OnOptions: DialogueTypes.OptionsHandler?,
	OnCommand: DialogueTypes.CommandHandler?,
	OnDialogueComplete: DialogueTypes.DialogueCompleteHandler?,
	OnLine: DialogueTypes.LineHandler?,
	OnNodeComplete: DialogueTypes.NodeCompleteHandler?,
	OnNodeStart: DialogueTypes.NodeStartHandler?,
	OnPrepareForLines: DialogueTypes.PrepareForLinesHandler?,

	AddProgram: (program: YarnProgram.YarnProgram) -> (),
	Continue: () -> (),
	ExpandSubstitutions: (text: string, substitutions: { string }) -> string,
	GetTagsForNode: (nodeName: string) -> { string }?,
	Stop: () -> (),
	UnloadAll: () -> (),
}

-- docs for Dialogue objects
--- @prop DefaultStartNodeName string
--- @within Dialogue
---
--- The node that execution will start from.

--- @prop VariableStorage { [string]: Operand }
--- @within Dialogue
---
--- The dictionary that provides access to the values of variables in use by this Dialogue.

--- @prop IsActive boolean
--- @within Dialogue
---
--- A value indicating whether the Dialogue is currently executing Yarn instructions.

--- @prop Library { [string]: YarnFunction }
--- @within Dialogue
---
--- The "library" of functions this Dialogue's Yarn code has access to.

--- @prop CurrentNode string
--- @within Dialogue
---
--- The name of the current Node being executed.

--- @prop NodeNames { string }
--- @within Dialogue
---
--- The names of all Nodes loaded in this Dialogue.

--- @prop Program YarnProgram?
--- @within Dialogue
---
--- The program being executed by this Dialogue.

--- @prop OnOptions OptionsHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue has options to deliver to the user.

--- @prop OnCommand CommandHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue has a command to execute.

--- @prop OnDialogueComplete DialogueCompleteHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue has no more code left to execute.

--- @prop OnLine LineHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue delivers a line to the game.

--- @prop OnNodeComplete NodeCompleteHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue has reached the end of a Node.

--- @prop OnNodeStart NodeStartHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue starts executing a Node.

--- @prop OnPrepareForLines PrepareForLinesHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue anticipates that lines will be delivered soon.
--- [See for more info.](Dialogue#PrepareForLinesHandler)

--- Loads the nodes from the specified Program, and adds them to the nodes already loaded.
--- @within Dialogue
---
--- @param program YarnProgram -- The additional Program to load.
function Dialogue.AddProgram(self: Dialogue, program: YarnProgram.YarnProgram) end

--- Starts or continues execution of the current Program.
--- @within Dialogue
---
--- This method repeatedly executes instructions until one of the following conditions is encountered:
--- - The [LineHandler](Dialogue#LineHandler) or [CommandHandler](Dialogue#CommandHandler) is called.
---   After calling either of these handlers, the Dialogue will wait until `Continue()` is called. `Continue()`
---   may be called from inside the LineHandler or CommandHandler, or may be called at any future time.
--- - The [OptionsHandler](Dialogue#OptionsHandler) is called. When this occurs, the Dialogue is waiting for the user to specify
---   which of the options has been selected, and `SetSelectedOption()` must be called before `Continue()` is called again.
--- - The Program reaches its end. When this occurs, `SetNode()` must be called before `Continue()` is called again.
--- - An error occurs while executing the Program.
--- This method has no effect if it is called while the Dialogue is currently in the process of executing instructions.
function Dialogue.Continue(self: Dialogue)
	-- TODO: start execution in VM
end

--- Replaces all substitution markers in a text with the given substitution list.
--- @within Dialogue
---
--- This method replaces substitution markers - for example, `{0}` - with the
--- corresponding entry in `substitutions`.
---
--- If `text` contains a substitution marker whose index is not present in `substitutions`,
--- it is ignored.
--- @param text string -- The text containing substitution markers
--- @param substitutions { string } -- The list of substitutions
--- @return string -- `text`, with the content from `substitutions` inserted.
function Dialogue.ExpandSubstitutions(self: Dialogue, text: string, substitutions: { string }): string
	for index, substitution in ipairs(substitutions) do
		text = string.gsub(text, "{" .. index .. "}", substitution)
	end

	return text
end

--- Returns the tags for the node `nodeName`.
--- @within Dialogue
---
--- The tags for a node are defined by setting the `tags` header in
--- the node's source code. This header must be a space-separated list.
--- @param nodeName string -- The name of the node
--- @return { string }? -- The node's tag, or `nil` if the node is not present in the Program
function Dialogue.GetTagsForNode(self: Dialogue, nodeName: string): { string }?
	assert(self.Program, "Tried to call GetTagsForNode, but no program has been loaded!")

	if #self.Program.nodes == 0 then
		-- TODO: log error, no nodes are loaded
		return nil
	end

	local node = self.Program.nodes[nodeName]
	if node then
		return node.tags
	end

	-- TODO: log error, node doesn't exist
	return nil
end

--- Immediately stops the `Dialogue`.
--- @within Dialogue
---
--- The [DialogueCompleteHandler](Dialogue#OnDialogueComplete) will not
--- be called if the dialogue is ended by calling [Stop](Dialogue#Stop).
function Dialogue.Stop(self: Dialogue)
	-- TODO: stop VM
end

--- Unloads all nodes from the `Dialogue`.
--- @within Dialogue
function Dialogue.UnloadAll(self: Dialogue)
	self.Program = nil
end

return Dialogue
