--!strict

--- @class Silk
---
--- Main module containing libraries to interact with Yarn dialogue.
local Silk = {}

local Dialogue = require(script:WaitForChild("Dialogue"))
local VirtualMachine = require(script:WaitForChild("VirtualMachine"))
local Library = require(script:WaitForChild("Library"))
local CommandRegistry = require(script:WaitForChild("CommandRegistry"))

local lib = script:WaitForChild("lib")
local Base64 = require(lib:WaitForChild("Base64"))

local types = script:WaitForChild("types")
local RawProgram = require(types:WaitForChild("RawProgram"))
local YarnProgram = require(types:WaitForChild("YarnProgram"))
local DialogueTypes = require(types:WaitForChild("Dialogue"))
local LibraryTypes = require(types:WaitForChild("Library"))

-- export these types here for ease of use in generated scripts

--- @type Line Dialogue.Line
--- @within Silk
---
--- [See full type here.](Dialogue#Line)
export type Line = DialogueTypes.Line

--- @type Option Dialogue.Option
--- @within Silk
---
--- [See full type here.](Dialogue#Option)
export type Option = DialogueTypes.Option

--- @type Program YarnProgram.YarnProgram
--- @within Silk
---
--- [See full type here.](YarnProgram)
export type Program = YarnProgram.YarnProgram

--- @type RawProgram RawProgram.RawProgram
--- @within Silk
---
--- [See full type here.](RawProgram)
export type RawProgram = RawProgram.RawProgram

--- @type YarnArgument YarnProgram.Operand
--- @within Silk
---
--- [See full type here.](YarnProgram#Operand)
export type YarnArgument = YarnProgram.Operand

--- @type YarnFunction Library.YarnFunction
--- @within Silk
---
--- [See full type here.](Library#YarnFunction)
export type YarnFunction = LibraryTypes.YarnFunction

--- @prop Base64 Base64
--- @within Silk
--- @tag libraries
---
--- Base64 library used by generated modules.
Silk.Base64 = Base64

--- @prop CommandRegistry CommandRegistry
--- @within Silk
--- @tag libraries
---
--- Acts as an organizer for commands and executes command strings
--- from [`Dialogue.OnCommand`](Dialogue#OnCommand)
Silk.CommandRegistry = CommandRegistry

--- @prop Dialogue Dialogue
--- @within Silk
--- @tag libraries
---
--- Dialogue library used for running a Yarn script.
Silk.Dialogue = Dialogue

--- @prop VirtualMachine VirtualMachine
--- @within Silk
--- @tag libraries
---
--- Virtual machine library used for executing Yarn instructions.
Silk.VirtualMachine = VirtualMachine

--- @prop Library Library
--- @within Silk
--- @tag libraries
---
--- Library used for storing functions bound to a Yarn program.
Silk.Library = Library

local function getOperand(operand: RawProgram.Operand): YarnProgram.Operand
	return if operand.boolValue ~= nil
		then operand.boolValue
		elseif operand.floatValue ~= nil then operand.floatValue
		elseif operand.stringValue ~= nil then operand.stringValue
		else error("Operand has no value!")
end

local function decodeInstructions(code: { RawProgram.Instruction }): { YarnProgram.Instruction }
	local newCode = table.create(#code)

	for _, ins in ipairs(code) do
		local new = {}
		new.opcode = RawProgram.Opcodes[ins.opcode or "JUMP_TO" :: RawProgram.Opcode]
		new.operands = table.create(if ins.operands then #ins.operands else 0)

		if ins.operands then
			for _, operand in ipairs(ins.operands) do
				table.insert(new.operands, getOperand(operand))
			end
		end

		table.insert(newCode, new :: YarnProgram.Instruction)
	end

	return newCode
end

--- Decode a compiled Yarn program
--- :::note
---   This method will usually only be used by generated Silk scripts.
--- :::
--- @within Silk
---
--- @param compiled RawProgram -- Compiled program data
--- @return string? -- Program name if exists
--- @return { [string]: YarnProgram.Node } -- Node lookup table
--- @return { [string]: YarnProgram.Operand } -- Initial values table
function Silk.DecodeProgram(
	compiled: RawProgram
): (string?, { [string]: YarnProgram.Node }, { [string]: YarnProgram.Operand })
	local newNodes = {} :: { [string]: YarnProgram.Node }
	local newInitialValues = {} :: { [string]: YarnProgram.Operand }

	for key, node in compiled.nodes do
		newNodes[key] = {
			name = node.name,
			instructions = decodeInstructions(node.instructions),
			labels = node.labels or {},
			tags = node.tags or {},
			sourceTextStringID = node.sourceTextStringID,
			headers = node.headers or {},
		}
	end

	if compiled.initialValues then
		for key, val in compiled.initialValues do
			newInitialValues[key] = getOperand(val)
		end
	end

	return compiled.name, newNodes, newInitialValues
end

return table.freeze(Silk)
