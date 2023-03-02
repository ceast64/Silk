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

-- normal functions
function std.visited(node_name: Operand?): Operand?
	-- TODO
	error("")
	return false
end

function std.visited_count(node_name: Operand?): Operand?
	-- TODO
	return false
end

local random = Random.new()

function std.random(): number
	return random:NextNumber()
end

function std.random_range(a, b): number
	assert(a and type(a) == "number", `expected number for argument a, got {a}`)
	assert(b and type(b) == "number", `expected number for argument b, got {b}`)
	return random:NextInteger(a :: number, b :: number)
end

function std.dice(sides): number
	assert(sides and type(sides) == "number", `expected number for argument sides, got {sides}`)
	return random:NextInteger(1, sides :: number)
end

function std.round(n): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	return math.round(n)
end

function std.round_places(n, places): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	assert(places and type(places) == "number", `expected number for argument places, got {places}`)
	local mult = 10 ^ places :: number
	return math.floor(n :: number * mult + 0.5) / mult
end

function std.floor(n): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	return math.floor(n)
end

function std.ceil(n): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	return math.ceil(n)
end

function std.inc(n): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	return if math.ceil(n) == n then n + 1 else math.ceil(n)
end

function std.dec(n): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	return if math.floor(n) == n then n - 1 else math.floor(n)
end

function std.decimal(n): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	return n % 1
end

function std.int(n): number
	assert(n and type(n) == "number", `expected number for argument n, got {n}`)
	return n - (n % 1)
end

-- mapping of each function for equations
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

table.freeze(std)
return std
