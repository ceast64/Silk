--!strict

local types = script.Parent.Parent:WaitForChild("types")
local YarnProgram = require(types:WaitForChild("YarnProgram"))
local StackTypes = require(types:WaitForChild("Stack"))

--- @class Stack
---
--- Simple stack structure implementation for the Virtual Machine.
local Stack = {}
Stack.__index = Stack

--- @prop items { Operand }
--- @within Stack
---
--- The internal array containing all items on the Stack.

--- Push a value to the top of the Stack.
--- @within Stack
---
--- @param value Operand -- The value to push
--- @return number -- The new index of the top of the stack
function Stack.push(self: StackTypes.Stack, value: YarnProgram.Operand): number
	table.insert(self.items, value)
	return #self.items
end

--- Peek the value at the top of the Stack.
--- @within Stack
---
--- @return Operand -- The value at the top of the Stack.
function Stack.peek(self: StackTypes.Stack): YarnProgram.Operand
	return self.items[#self.items]
end

--- Pop a value off the top of the Stack.
--- @within Stack
---
--- @return Operand -- The value popped off the top of the Stack.
--- @error Stack underflow -- The Stack is currently empty, so a value cannot be popped.
function Stack.pop(self: StackTypes.Stack): YarnProgram.Operand
	assert(#self.items > 0, "Stack underflow")
	return assert(table.remove(self.items, #self.items))
end

--- Clear the Stack's values.
--- @within Stack
function Stack.clear(self: StackTypes.Stack)
	table.clear(self.items)
end

--- Create an empty Stack.
--- @within Stack
--- @tag constructor
---
--- @return Stack -- The new Stack.
function Stack.new(): StackTypes.Stack
	local self = {
		items = {},
	}

	return setmetatable(self :: any, Stack) :: StackTypes.Stack
end

return Stack
