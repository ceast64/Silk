--!strict

--- @class Dialogue
---
--- Dialogue class used for executing a Yarn script.
--- This class wraps some methods from the underlying
--- [VirtualMachine](VirtualMachine) for ease of use.
local Dialogue = {}
Dialogue.__index = Dialogue

local types = script.Parent:WaitForChild("types")
local YarnProgram = require(types:WaitForChild("YarnProgram"))
local DialogueTypes = require(types:WaitForChild("Dialogue"))
local VirtualMachineTypes = require(types:WaitForChild("VirtualMachine"))

local VirtualMachine = require(script.Parent:WaitForChild("VirtualMachine"))
local Library = require(script.Parent:WaitForChild("Library"))

--- @prop OnCommand CommandHandler?
--- @within Dialogue
--- @tag callbacks
--- @tag required
---
--- Called when the Dialogue has a command to execute.

--- @prop OnDebug DebugHandler?
--- @within Dialogue
--- @tag callbacks
--- @private
---
--- Called by the virtual machine when [DebugMode](Dialogue#DebugMode)
--- is enabled.

--- @prop OnDialogueComplete DialogueCompleteHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue has no more code left to execute.

--- @prop OnLine LineHandler?
--- @within Dialogue
--- @tag callbacks
--- @tag required
---
--- Called when the Dialogue delivers a line to the game.

--- @prop OnNodeComplete NodeCompleteHandler?
--- @within Dialogue
--- @tag callbacks
--- @tag required
---
--- Called when the Dialogue has reached the end of a Node.

--- @prop OnNodeStart NodeStartHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue starts executing a Node.

--- @prop OnOptions OptionsHandler?
--- @within Dialogue
--- @tag callbacks
--- @tag required
---
--- Called when the Dialogue has options to deliver to the user.

--- @prop OnPrepareForLines PrepareForLinesHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue anticipates that lines will be delivered soon.
--- [See for more info.](Dialogue#PrepareForLinesHandler)

--- @prop CurrentNode string?
--- @within Dialogue
---
--- The name of the current Node being executed.

--- @prop DebugMode boolean?
--- @within Dialogue
--- @private
---
--- When `true`, the virtual machine will wait for [`Continue()`](Dialogue#Continue)
--- to be called before executing the next instruction, even if no content or options
--- have been delivered. It will also

--- @prop DefaultStartNodeName string
--- @within Dialogue
---
--- The node that execution will start from.

--- @prop IsActive boolean
--- @within Dialogue
---
--- A value indicating whether the Dialogue is currently executing Yarn instructions.

--- @prop Library Library
--- @within Dialogue
---
--- The "library" of functions this Dialogue's Yarn code has access to.

--- @prop Program YarnProgram?
--- @within Dialogue
---
--- The program being executed by this Dialogue.

--- @prop VariableStorage { [string]: Operand }
--- @within Dialogue
---
--- The dictionary that provides access to the values of variables in use by this Dialogue.

--- @prop VirtualMachine VirtualMachine
--- @within Dialogue
---
--- The underlying virtual machine executing this Dialogue.

--- Create a new Dialogue object with optional source program and starting node.
--- @within Dialogue
--- @tag constructor
---
--- @param source YarnProgram? -- Source program
--- @param startNode string? -- Starting node name
--- @param noStandardLibrary boolean? -- Skip registering the standard library functions, only useful for debugging
--- @return Dialogue -- New dialogue object
function Dialogue.new(
	source: YarnProgram.YarnProgram?,
	startNode: string?,
	noStandardLibrary: boolean?
): DialogueTypes.Dialogue
	local self = {
		DefaultStartNodeName = startNode,
		VariableStorage = {},
		IsActive = false,
		Library = {},
		CurrentNode = nil,
		Program = source,
	}

	local new = setmetatable(self :: any, Dialogue) :: DialogueTypes.Dialogue
	self.VirtualMachine = VirtualMachine.new(new)
	local library = Library.new()

	if noStandardLibrary ~= true then
		library:RegisterStandardLibrary()
	end

	self.Library = library

	return new
end

--- @method AddProgram
--- Loads the nodes from the specified Program, and adds them to the nodes already loaded.
--- @within Dialogue
---
--- If [Dialogue.Program](Dialogue#Program) is nil, this method has the same effect as calling
--- [Dialogue:SetProgram](Dialogue#SetProgram).
--- @param program YarnProgram -- The additional Program to load.
function Dialogue.AddProgram(self: DialogueTypes.Dialogue, program: YarnProgram.YarnProgram)
	if self.Program == nil then
		self:SetProgram(program)
		return
	end

	assert(self.Program) -- ???

	-- not very efficient, but mirrors C# implementation closely
	local clone = self.Program.clone()
	local clone2 = program.clone()

	for key, node in clone2.nodes do
		assert(clone.nodes[key] ~= nil, `This program already contains a node with the name {key}`)
		clone.nodes[key] = node
	end

	for key, value in clone2.initial_values do
		clone.initial_values[key] = value
	end

	-- although we do copy strings as well
	for key, str in clone2.strings do
		clone.strings[key] = str
	end

	self.Program = clone
end

--- @method Continue
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
function Dialogue.Continue(self: DialogueTypes.Dialogue)
	local vm = self.VirtualMachine :: VirtualMachineTypes.VirtualMachine
	vm:Continue()
end

--- @method ExpandSubstitutions
--- Replaces all substitution markers in a text with the given substitution list.
--- @within Dialogue
---
--- This method replaces substitution markers - for example, `{0}` - with the
--- corresponding entry in `substitutions`.
---
--- If `text` contains a substitution marker whose index is not present in `substitutions`,
--- it is ignored.
---
--- If `substitutions` is nil, will return the original string unmodified.
--- @param text string -- The text containing substitution markers
--- @param substitutions { string }? -- The list of substitutions
--- @return string -- `text`, with the content from `substitutions` inserted.
function Dialogue.ExpandSubstitutions(self: DialogueTypes.Dialogue, text: string, substitutions: { string }?): string
	for index, substitution in ipairs(substitutions or {}) do
		text = string.gsub(text, `\{{index - 1}}`, substitution)
	end

	return text
end

--- @method GetExecutionState
--- Retrieves the execution state of the Dialogue.
--- @within Dialogue
---
--- This reflects the current action of the virtual machine, whether it is
--- executing instructions, delivering content, or waiting for user
--- interaction.
--- @return ExecutionState
function Dialogue.GetExecutionState(
	self: DialogueTypes.Dialogue
): "Stopped" | "WaitingOnOptionSelection" | "WaitingForContinue" | "DeliveringContent" | "Running"
	return (self.VirtualMachine :: VirtualMachineTypes.VirtualMachine).ExecutionState
end

--- @method GetNodeNames
--- Returns a list of all loaded nodes in the program.
--- @within Dialogue
---
--- @return { string } -- The names of all loaded nodes
function Dialogue.GetNodeNames(self: DialogueTypes.Dialogue): { string }
	assert(self.Program, "Tried to call GetNodeNames, but no program has been loaded!")

	local ret = {}

	for key, _ in self.Program.nodes do
		table.insert(ret, key)
	end

	return ret
end

--- @method GetTagsForNode
--- Returns the tags for the node `nodeName`.
--- @within Dialogue
---
--- The tags for a node are defined by setting the `tags` header in
--- the node's source code. This header must be a space-separated list.
--- @param nodeName string -- The name of the node
--- @return { string }? -- The node's tag, or `nil` if the node is not present in the Program
function Dialogue.GetTagsForNode(self: DialogueTypes.Dialogue, nodeName: string): { string }?
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

--- @method SetProgram
--- Loads all nodes from the provided Program.
--- @within Dialogue
---
--- This method replaces any existing nodes that have been loaded.
--- If you want to load nodes from an _additional_ Program, use the [AddProgram](Dialogue#AddProgram) method.
--- @param program YarnProgram -- The Program to use
function Dialogue.SetProgram(self: DialogueTypes.Dialogue, program: YarnProgram.YarnProgram)
	self.Program = program
end

--- @method SetSelectedOption
--- Set the selected dialogue option.
--- @within Dialogue
---
--- :::caution
--- Calling this method when [executionState](VirtualMachine#executionState)
--- is not `"WaitingOnOptionSelection"` will cause an error.
--- :::
--- @param selectedOptionID number -- Index of an option inside the options table sent by [OnOptions](Dialogue#OnOptions)
function Dialogue.SetSelectedOption(self: DialogueTypes.Dialogue, selectedOptionID: number)
	(self.VirtualMachine :: VirtualMachineTypes.VirtualMachine):SetSelectedOption(selectedOptionID)
end

--- @method Stop
--- Immediately stops the `Dialogue`.
--- @within Dialogue
---
--- The [DialogueCompleteHandler](Dialogue#OnDialogueComplete) will not
--- be called if the dialogue is ended by calling [Stop](Dialogue#Stop).
function Dialogue.Stop(self: DialogueTypes.Dialogue)
	local vm = self.VirtualMachine :: VirtualMachineTypes.VirtualMachine
	vm.ExecutionState = "Stopped"
end

--- @method UnloadAll
--- Unloads all nodes from the `Dialogue`.
--- @within Dialogue
function Dialogue.UnloadAll(self: DialogueTypes.Dialogue)
	self.Program = nil
end

return Dialogue
