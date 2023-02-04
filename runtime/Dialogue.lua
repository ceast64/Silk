--!strict

--- @class Dialogue
---
--- Dialogue class used for executing a Yarn script.
local Dialogue = {}
Dialogue.__index = Dialogue

local types = script.Parent:WaitForChild("types")
local YarnProgram = require(types:WaitForChild("YarnProgram"))
local DialogueTypes = require(types:WaitForChild("Dialogue"))

local VirtualMachine = require(types:WaitForChild("VirtualMachine"))

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

--- @prop Library { [string]: LibraryFunction }
--- @within Dialogue
---
--- The "library" of functions this Dialogue's Yarn code has access to.

--- @prop CurrentNode string?
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
--- @tag required
---
--- Called when the Dialogue has options to deliver to the user.

--- @prop OnCommand CommandHandler?
--- @within Dialogue
--- @tag callbacks
--- @tag required
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

--- @prop OnPrepareForLines PrepareForLinesHandler?
--- @within Dialogue
--- @tag callbacks
---
--- Called when the Dialogue anticipates that lines will be delivered soon.
--- [See for more info.](Dialogue#PrepareForLinesHandler)

--- Binds a function to this Dialogue's [Library](Dialogue#Library).
--- @within Dialogue
---
--- :::caution
--- Will error if a function with the same name is already bound!
--- :::
--- @param name string -- The name of the function to bind
--- @param argCount number -- The number of arguments the virtual machine should expect
--- @param argTypes { YarnType } -- The types of each argument to the function
--- @param returnType YarnType? -- The type the function returns, or nil if it returns nothing
--- @param func YarnFunction -- The Lua function to bind
function Dialogue.BindFunction(
	self: DialogueTypes.Dialogue,
	name: string,
	argCount: number,
	argTypes: { DialogueTypes.YarnType },
	returnType: DialogueTypes.YarnType?,
	func: DialogueTypes.YarnFunction
)
	assert(self.Library[name] == nil, "Function " .. name .. " is already bound.")
	self.Library[name] = {
		argCount = argCount,
		argTypes = argTypes,
		returnType = returnType,
		func = func,
	}
end

--- Unbinds a function from this Dialogue's [Library](Dialogue#Library).
--- @within Dialogue
---
--- @param name string -- The name of the function to unbind
function Dialogue.UnbindFunction(self: DialogueTypes.Dialogue, name: string)
	self.Library[name] = nil
end

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
		assert(clone.nodes[key] ~= nil, "This program already contains a node with the name " .. key)
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
	local vm = self.VirtualMachine :: VirtualMachine.VirtualMachine
	vm:Continue()
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
function Dialogue.ExpandSubstitutions(self: DialogueTypes.Dialogue, text: string, substitutions: { string }): string
	for index, substitution in ipairs(substitutions) do
		text = string.gsub(text, "{" .. index - 1 .. "}", substitution)
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

--- Loads all nodes from the provided Program.
--- @within Dialogue
---
--- This method replaces any existing nodes that have been loaded.
--- If you want to load nodes from an _additional_ Program, use the [AddProgram](Dialogue#AddProgram) method.
--- @param program YarnProgram -- The Program to use
function Dialogue.SetProgram(self: DialogueTypes.Dialogue, program: YarnProgram.YarnProgram)
	self.Program = program
end

--- Immediately stops the `Dialogue`.
--- @within Dialogue
---
--- The [DialogueCompleteHandler](Dialogue#OnDialogueComplete) will not
--- be called if the dialogue is ended by calling [Stop](Dialogue#Stop).
function Dialogue.Stop(self: DialogueTypes.Dialogue)
	local vm = self.VirtualMachine :: VirtualMachine.VirtualMachine
	vm.executionState = "Stopped"
end

--- Unloads all nodes from the `Dialogue`.
--- @within Dialogue
function Dialogue.UnloadAll(self: DialogueTypes.Dialogue)
	self.Program = nil
end

--- Create a new Dialogue object with optional source program and starting node.
--- @within Dialogue
--- @tag constructor
---
--- @param source YarnProgram? -- Source program
--- @param startNode string? -- Starting node name
--- @return Dialogue -- New dialogue object
function Dialogue.new(source: YarnProgram.YarnProgram?, startNode: string?): DialogueTypes.Dialogue
	local self = {
		DefaultStartNodeName = startNode,
		VariableStorage = {},
		IsActive = false,
		Library = {},
		CurrentNode = nil,
		Program = source,
	}

	return setmetatable(self :: any, Dialogue) :: DialogueTypes.Dialogue
end

return Dialogue
