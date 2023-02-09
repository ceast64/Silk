--!strict

local types = script.Parent.Parent:WaitForChild("types")
local LibraryTypes = require(types:WaitForChild("Library"))
local YarnProgram = require(types:WaitForChild("YarnProgram"))

type YarnFunction = LibraryTypes.YarnFunction
type Operand = YarnProgram.Operand

-- Yarn uses a method for each operation for each type,
-- but that's unneccessary in Lua, so instead, we use
-- one set of methods, but registered to the function
-- name for each type

local function equalTo(a: Operand, b: Operand): Operand?
	return a == b
end

local function notEqualTo(a: Operand, b: Operand): Operand?
	return a ~= b
end

local function add(a: Operand, b: Operand): Operand?
	return a :: number + b :: number
end

local function minus(a: Operand, b: Operand): Operand?
	return a :: number - b :: number
end

local function divide(a: Operand, b: Operand): Operand?
	return a :: number / b :: number
end

local function multiply(a: Operand, b: Operand): Operand?
	return a :: number * b :: number
end

local function modulus(a: Operand, b: Operand): Operand?
	return a :: number % b :: number
end

local function unaryMinus(a: Operand): Operand?
	return -a :: number
end

local function greaterThan(a: Operand, b: Operand): Operand?
	return a :: number > b :: number
end

local function greaterThanOrEqualTo(a: Operand, b: Operand): Operand?
	return a :: number >= b :: number
end

local function lessThan(a: Operand, b: Operand): Operand?
	return (a :: number) < (b :: number)
end

local function lessThanOrEqualTo(a: Operand, b: Operand): Operand?
	return a :: number <= b :: number
end

local function logAnd(a: Operand, b: Operand): Operand?
	return a and b
end

local function logOr(a: Operand, b: Operand): Operand?
	return a or b
end

local function logNot(a: Operand): Operand?
	return not a
end

local function logXor(a: Operand, b: Operand): Operand?
	return (a ~= nil and a ~= false) ~= (b ~= nil and b ~= false)
end

local function concat(a: Operand, b: Operand): Operand?
	return a :: string .. b :: string
end

local std = {} :: { [string]: LibraryTypes.YarnFunction }

-- mapping of each function
local methods = {
	["Number"] = {
		["EqualTo"] = equalTo,
		["NotEqualTo"] = notEqualTo,
		["Add"] = add,
		["Minus"] = minus,
		["Divide"] = divide,
		["Multiply"] = multiply,
		["Modulo"] = modulus,
		["UnaryMinus"] = unaryMinus,
		["GreaterThan"] = greaterThan,
		["GreaterThanOrEqualTo"] = greaterThanOrEqualTo,
		["LessThan"] = lessThan,
		["LessThanOrEqualTo"] = lessThanOrEqualTo,
	},

	["String"] = {
		["EqualTo"] = equalTo,
		["NotEqualTo"] = notEqualTo,
		["Add"] = concat,
	},

	["Bool"] = {
		["EqualTo"] = equalTo,
		["NotEqualTo"] = notEqualTo,
		["And"] = logAnd,
		["Or"] = logOr,
		["Xor"] = logXor,
		["Not"] = logNot,
	},
} :: { [string]: { [string]: YarnFunction } }

for root, children in methods do
	for name, method in children do
		std[root .. "." .. name] = method
	end
end

return std
