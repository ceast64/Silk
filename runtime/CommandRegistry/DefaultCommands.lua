--!strict

local types = script.Parent.Parent:WaitForChild("types")
local CommandRegistryTypes = require(types:WaitForChild("CommandRegistry"))
local DialogueTypes = require(types:WaitForChild("Dialogue"))

local commands = {} :: { [string]: CommandRegistryTypes.Command }

commands["wait"] = {
	argumentType = "number",
	func = function(_, time: number?)
		task.wait(assert(time))
	end,
}

commands["stop"] = {
	argumentType = "nil",
	func = function(reg: DialogueTypes.Dialogue)
		reg:Stop()
	end,
}

table.freeze(commands)
return commands
