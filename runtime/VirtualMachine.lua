--!strict

local Dialogue = require(script.Parent:WaitForChild("Dialogue"))

local types = script.Parent:WaitForChild("types")

--- @class VirtualMachine
---
--- Class that executes nodes and their instructions in a [Dialogue](Dialogue).
local VirtualMachine = {}
VirtualMachine.__index = VirtualMachine

return VirtualMachine