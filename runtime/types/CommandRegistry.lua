--!strict

local Dialogue = require(script.Parent:WaitForChild("Dialogue"))

export type CommandRegistry = {
	commands: { [string]: Command },

	DeregisterCommand: (self: CommandRegistry, name: string) -> (),
	ExecuteCommand: (self: CommandRegistry, command: string, dialogue: Dialogue.Dialogue) -> (),
	RegisterCommand: (self: CommandRegistry, name: string, command: Command) -> (),
	RegisterDefaults: (self: CommandRegistry) -> (),
}

--- @type Command { argument: "string" | "number" | "boolean" | "nil", func: CommandFunction }
--- @within CommandRegistry
---
--- Represents a command registered to a CommandRegistry
export type Command = {
	argumentType: "string" | "number" | "boolean" | "nil",
	func: CommandFunction,
}

--- @type CommandFunction (caller: Dialogue, arg: any?) -> ()
--- @within CommandRegistry
---
--- A function to be called by a command.
export type CommandFunction = (caller: Dialogue.Dialogue, arg: any?) -> ()

return {}
