--!strict

--- @class Library
---
--- A collection of functions that can be called from Yarn programs.
--- You do not need to create instances of this class yourself.
--- The [Dialogue](Dialogue) class creates one of its own, which you can
--- access via the [Dialogue.Library](Dialogue#Library) property.
local Library = {}
Library.__index = Library

local types = script.Parent:WaitForChild("types")
local LibraryTypes = require(types:WaitForChild("Library"))

local StandardLibrary = require(script:WaitForChild("StandardLibrary"))

type Library = LibraryTypes.Library
type Function = LibraryTypes.Function
type YarnFunction = LibraryTypes.YarnFunction

--- Creates a new Library.
--- @within Library
--- @tag constructor
function Library.new(): Library
	local self = {}
	self.functions = {}

	return setmetatable(self :: any, Library) :: Library
end

--- Removes a function from this Library.
--- @within Library
---
--- If no function with the given name is present in the Library,
--- this method does nothing.
--- @param name string -- The name fo the function to remove
function Library.DeregisterFunction(self: Library, name: string)
	self.functions[name] = nil
end

--- Returns whether this Library contains a function named `name`.
--- @within Library
---
--- @param name string -- The name of the function to check
--- @return boolean -- Whether the function is registered
function Library.FunctionExists(self: Library, name: string): boolean
	return self.functions[name] ~= nil
end

--- Generates a unique tracking variable name.
--- @within Library
---
--- This is intended to be used to generate names for visting.
--- Ideally these will very reproduceable and sensible.
--- For now it will be something terrible and easy.
--- @param name string -- The name of the node that needs to have a tracking variable created.
--- @return string -- The new variable name
function Library.GenerateUniqueVisitedVariableForNode(self: Library, name: string): string
	return `$Yarn.Internal.Visiting.{name}`
end

--- @prop functions { [string]: Function }
--- @within Library
---
--- The mapping table of function names to functions.

--- Returns the [Function](Library#Function) with a given name.
--- @within Library
---
--- @param name string -- The name of the function to retrieve.
--- @return Function -- The named function.
function Library.GetFunction(self: Library, name: string): Function
	return assert(self.functions[name], "Function " .. name .. " is not present in the library.")
end

--- Loads functions from another Library.
--- @within Library
---
--- If the other Library contains a function with the same name as
--- one in this library, the function in the other library takes
--- precedence.
--- @param other Library -- The library to import functions from.
function Library.ImportLibrary(self: Library, other: Library)
	for name, func in other.functions do
		self.functions[name] = func
	end
end

--- Registers a new function that returns a value, which can be called from a Yarn program.
--- @within Library
---
--- @param name string -- The name of the function
--- @param func YarnFunction -- The method to be invoked when the function is called
function Library.RegisterFunction(self: Library, name: string, func: YarnFunction)
	local params, isVararg = debug.info(func, "a")

	assert(not isVararg, "Failed to register function, `...` is unsupported.")
	self.functions[name] = {
		argumentCount = params,
		func = func,
	}
end

--- Registers the standard library of functions to this Library.
--- @within Library
---
--- These functions are used for evaluating values within expressions.
function Library.RegisterStandardLibrary(self: Library)
	for name, func in StandardLibrary do
		self:RegisterFunction(name, func)
	end
end

return Library
