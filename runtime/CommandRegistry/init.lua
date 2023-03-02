--!strict

--- @class CommandRegistry
---
--- A collection of commands that can be called from Yarn programs.
local CommandRegistry = {}
CommandRegistry.__index = CommandRegistry

local types = script.Parent:WaitForChild("types")
local CommandRegistryTypes = require(types:WaitForChild("CommandRegistry"))
local DialogueTypes = require(types:WaitForChild("Dialogue"))

local DefaultCommands = require(script:WaitForChild("DefaultCommands"))

type CommandRegistry = CommandRegistryTypes.CommandRegistry
type Command = CommandRegistryTypes.Command

--- Creates a new CommandRegistry.
--- @within CommandRegistry
--- @tag constructor
--- @param noDefaults boolean? -- If `true`, skips registering the default commands.
function CommandRegistry.new(noDefaults: boolean?): CommandRegistry
	local self = {}
	self.commands = {}

	local registry = setmetatable(self :: any, CommandRegistry) :: CommandRegistry
	if noDefaults ~= true then
		registry:RegisterDefaults()
	end

	return registry
end

--- @method DeregisterCommand
--- Removes a command from this CommandRegistry.
--- @within CommandRegistry
---
--- @param name string -- The name of the command to remove
function CommandRegistry.DeregisterCommand(self: CommandRegistry, name: string)
	self.commands[name] = nil
end

--- @method ExecuteCommand
--- Parses and executes a command string.
--- @within CommandRegistry
---
--- :::caution
--- Will error if the command is not registered!
--- :::
--- @param command string -- The command to execute, usually from the [OnCommand](Dialogue#OnCommand) handler.
--- @param dialogue Dialogue -- The dialogue the command is being executed by. This is required for commands like `stop`, and allows you to re-use CommandRegistry instances across different programs.
function CommandRegistry.ExecuteCommand(self: CommandRegistry, command: string, dialogue: DialogueTypes.Dialogue)
	local nameIdx = string.find(command, "%s")

	local name, rawArg
	if nameIdx then
		name = string.sub(command, 1, nameIdx - 1)
		rawArg = string.sub(command, nameIdx + 1, -1)
	else
		name = command
		rawArg = ""
	end

	local commandObj = assert(self.commands[name], `Failed to find command {name}`)

	local argType = commandObj.argumentType
	local arg = if argType == "string"
		then rawArg
		elseif argType == "number" then tonumber(rawArg)
		elseif argType == "boolean" then string.lower(rawArg) == "true"
		else nil

	commandObj.func(dialogue, arg)
end

--- @method RegisterCommand
--- Registers a new command to this CommandRegistry.
--- @within CommandRegistry
---
--- :::caution
--- Will error if a command with the same name is already registered.
--- :::
--- @param name string -- The name of the command to register
--- @param command Command -- The command object to register
function CommandRegistry.RegisterCommand(self: CommandRegistry, name: string, command: Command)
	assert(self.commands[name] == nil, `Command named "{name}" has already been registered!`)

	self.commands[name] = command
end

--- @method RegisterDefaults
--- Registers the default commands to this CommandRegistry.
--- @within CommandRegistry
function CommandRegistry.RegisterDefaults(self: CommandRegistry)
	for name, command in DefaultCommands do
		if self.commands[name] then
			warn(`Default command {name} has already been registered and will be overwritten!`)
		end

		self.commands[name] = command
	end
end

return CommandRegistry
