--!strict

local Stack = require(script:WaitForChild("Stack"))

local types = script.Parent:WaitForChild("types")
local YarnProgram = require(types:WaitForChild("YarnProgram"))
local VirtualMachineTypes = require(types:WaitForChild("VirtualMachine"))
local DialogueTypes = require(types:WaitForChild("Dialogue"))

type VirtualMachine = VirtualMachineTypes.VirtualMachine

--- @class VirtualMachine
---
--- Class that executes nodes and their instructions in a [Dialogue](Dialogue).
local VirtualMachine = {}
VirtualMachine.__index = VirtualMachine

--- @prop CurrentNode Node?
--- @within VirtualMachine
---
--- The current node the VirtualMachine is executing.

--- @prop CurrentNodeName string?
--- @within VirtualMachine
---
--- The name of the current node the VirtualMachine is executing.

--- @prop CurrentOptions { Option }
--- @within VirtualMachine
---
--- The current options the VirtualMachine has encountered.

--- @prop Dialogue Dialogue
--- @within VirtualMachine
---
--- The parent Dialogue for this VirtualMachine.

--- @prop ExecutionState ExecutionState
--- @within VirtualMachine
---
--- The VirtualMachine's current execution state.
--- See the docs for [ExecutionState](VirtualMachine#ExecutionState) for more info.

--- @prop ProgramCounter number
--- @within VirtualMachine
---
--- The index of the instruction being or to be executed by the VirtualMachine.

--- @prop Stack Stack
--- @within VirtualMachine
---
--- The VirtualMachine's stack, used for storing values during node execution.

--- Create a new VirtualMachine with parent Dialogue.
--- @within VirtualMachine
--- @tag constructor
---
--- The VirtualMachine will not have its current node set.
--- By default, it will use the [DefaultStartNodeName](Dialogue#DefaultStartNodeName)
--- property of the parent Dialogue.
--- @return VirtualMachine -- The new VirtualMachine
function VirtualMachine.new(dialogue: DialogueTypes.Dialogue): VirtualMachine
	local self = {
		CurrentNode = nil,
		CurrentNodeName = nil,
		CurrentOptions = {},
		Dialogue = dialogue,
		ExecutionState = "Stopped",
		ProgramCounter = 1,
		Stack = Stack.new(),
	}

	return setmetatable(self :: any, VirtualMachine) :: VirtualMachine
end

--- @within VirtualMachine
---
--- Runs a series of tests to see if the VirtualMachine is in a state
--- where [Continue](VirtualMachine#Continue) can be called.
--- Errors if it can't.
function VirtualMachine.CheckCanContinue(self: VirtualMachine)
	assert(self.CurrentNode, "Cannot continue running dialogue. No node has been selected.")
	assert(
		self.ExecutionState ~= "WaitingOnOptionSelection",
		"Cannot continue running dialogue. Still waiting on option selection."
	)

	local dialogue = self.Dialogue
	assert(dialogue.OnLine, "Cannot continue running dialogue. OnLine has not been set.")
	assert(dialogue.OnOptions, "Cannot continue running dialogue. OnOptions has not been set.")
	assert(dialogue.OnCommand, "Cannot continue running dialogue. OnCommand has not been set.")
	assert(dialogue.OnNodeComplete, "Cannot continue running dialogue. OnNodeComplete has not been set")
end

--- Resumes execution.
--- @within VirtualMachine
---
--- Calls [CheckCanContinue](VirtualMachine#CheckCanContinue) internally.
function VirtualMachine.Continue(self: VirtualMachine)
	if self.CurrentNode == nil or self.CurrentNodeName == nil then
		local defaultNode = assert(
			self.Dialogue.DefaultStartNodeName,
			"Cannot continue running dialogue. Current node has not been set and the DefaultStartNodeName property of the parent Dialogue is nil."
		)

		self:SetNode(defaultNode)
	end

	self:CheckCanContinue()

	if self.ExecutionState == "DeliveringContent" then
		-- we were delivering a line, option set, or command and
		-- the client has called Continue() on us. We're still
		-- inside the stack frame of the client callback, so to
		-- avoid recursion, we'll note that our state has changed
		-- back to Running; when we've left the callback, we'll
		-- continue executing instructions.
		self.ExecutionState = "Running"
		return
	end

	self.ExecutionState = "Running"

	-- execute instructions until something forces us to stop
	while self.ExecutionState == "Running" do
		local currentInstruction = assert(self.CurrentNode).instructions[self.ProgramCounter]

		if self.Dialogue.DebugMode and self.Dialogue.OnDebug then
			self.Dialogue.OnDebug(currentInstruction, self.Stack)
		end

		self:RunInstruction(currentInstruction)

		self.ProgramCounter += 1
		if self.ProgramCounter >= #self.CurrentNode.instructions then
			-- there are no more instructions, and we haven't jumped, so this is the end
			local dialogue = self.Dialogue

			if dialogue.OnNodeComplete then
				dialogue.OnNodeComplete(self.CurrentNode.name)
			end

			self.ExecutionState = "Stopped"

			if dialogue.OnDialogueComplete then
				dialogue.OnDialogueComplete()
			end
		end

		-- execute instructions one at a time by calling Continue()
		-- when debug mode enabled
		if self.Dialogue.DebugMode then
			return
		end
	end
end

--- Looks up the instruction number for a named label in the current node.
--- @within VirtualMachine
--- @private
---
--- @param labelName string -- The name of the node to search for
--- @return number -- The instruction number of the label
function VirtualMachine.FindInstructionPointForLabel(self: VirtualMachine, labelName: string): number
	assert(self.CurrentNode, "The current node is nil!")

	return assert(self.CurrentNode.labels[labelName], `Unknown label {labelName} in node {self.CurrentNode.name}`) + 1
end

--- Return a Line with the given string ID and expression count.
--- @within VirtualMachine
--- @private
---
--- @param stringKey string -- The string ID to use for the new Line
--- @param expressionCount number? -- The optional number of substitutions to pop off the Stack.
--- @return Line -- The new line with the substitutions added
function VirtualMachine.GetLine(self: VirtualMachine, stringKey: string, expressionCount: number?): DialogueTypes.Line
	local line = {
		id = stringKey,
		substitutions = nil,
	} :: DialogueTypes.Line

	-- the expressionCount operand, if provided, indicates
	-- the number of expressions in the line.
	-- we need to pop these values off the stack
	-- and deliver them to the line handler
	if expressionCount then
		local strings = table.create(expressionCount) :: { string }

		for expressionIndex = expressionCount, 1, -1 do
			strings[expressionIndex] = self.Stack:pop() :: string
		end

		line.substitutions = strings
	end

	return line
end

--- Reset the VirtualMachine's internal state.
--- @within VirtualMachine
---
--- This method resets the current node, program counter, options, and stack.
function VirtualMachine.ResetState(self: VirtualMachine)
	self.CurrentNodeName = nil
	self.CurrentNode = nil
	self.ProgramCounter = 1
	table.clear(self.CurrentOptions)
	self.Stack:clear()
end

--- Executes a Yarn instruction.
--- @within VirtualMachine
--- @private
---
--- This method will error if any handlers it requires are missing.
--- @param i Instruction -- Instruction to execute
function VirtualMachine.RunInstruction(self: VirtualMachine, i: YarnProgram.Instruction)
	local op = i.opcode
	local dialogue = self.Dialogue

	if op < 8 then
		if op < 3 then
			if op < 1 then
				-- JUMP_TO
				self.ProgramCounter = self:FindInstructionPointForLabel(i.operands[1] :: string) - 1
			elseif op > 1 then
				-- RUN_LINE
				local line = self:GetLine(i.operands[1] :: string, i.operands[2] :: number)

				-- suspend execution, we're about to deliver content
				self.ExecutionState = "DeliveringContent"

				if dialogue.OnLine then
					dialogue.OnLine(line)
				end

				if self.ExecutionState == "DeliveringContent" then
					-- the client didn't call Continue, so we'll
					-- wait here
					self.ExecutionState = "WaitingForContinue"
				end
			else
				-- JUMP
				local jumpDestination = self.Stack:peek() :: string
				self.ProgramCounter = self:FindInstructionPointForLabel(jumpDestination) - 1
			end
		elseif op > 3 then
			if op < 6 then
				if op > 4 then
					-- SHOW_OPTIONS

					-- if we have no options to show, immediately stop
					if #self.CurrentOptions < 1 then
						self.ExecutionState = "Stopped"

						if dialogue.OnDialogueComplete then
							dialogue.OnDialogueComplete()
						end

						return
					end

					-- present the list of options to the user and let them pick
					self.ExecutionState = "WaitingOnOptionSelection"

					if dialogue.OnOptions then
						dialogue.OnOptions(self.CurrentOptions)
					end

					if self.ExecutionState == "WaitingForContinue" then
						-- we are no longer waiting on an option selection
						-- the options handler must have called SetSelectedOption!
						-- continue running immediateley
						self.ExecutionState = "Running"
					end
				else
					-- ADD_OPTION
					local line = self:GetLine(i.operands[1] :: string, i.operands[3] :: number)

					-- indicates whether the VM believes that the
					-- option should be shown to the user, based on any
					-- conditions that were attached to the option.
					local lineConditionsPassed = true

					local hasLineCondition = i.operands[4]
					if hasLineCondition then
						lineConditionsPassed = self.Stack:pop() :: boolean
					end

					table.insert(self.CurrentOptions, {
						line = line,
						index = #self.CurrentOptions + 1,
						destination = i.operands[2] :: string,
						enabled = lineConditionsPassed,
					})
				end
			elseif op > 6 then
				-- PUSH_FLOAT
				self.Stack:push(i.operands[1] :: number)
			else
				-- PUSH_STRING
				self.Stack:push(i.operands[1] :: string)
			end
		else
			-- RUN_COMMAND
			local commandText = i.operands[1] :: string

			-- apply substitutions if there are any
			local expressionCount = i.operands[2] :: number
			if expressionCount then
				for i = expressionCount, 1, -1 do
					local substitution = self.Stack:pop() :: string
					commandText = string.gsub(commandText, `\{{i - 1}}`, substitution)
				end
			end

			self.ExecutionState = "DeliveringContent"

			-- run the command
			if dialogue.OnCommand then
				dialogue.OnCommand(commandText)
			end

			if self.ExecutionState == "DeliveringContent" then
				-- the client didn't call Continue, so we'll wait here
				self.ExecutionState = "WaitingForContinue"
			end
		end
	elseif op > 8 then
		if op < 13 then
			if op < 10 then
				-- PUSH_NULL
				error(
					"PushNull is no longer valid op code, because null is no longer a valid value from Yarn Spinner 2.0 onwards. To fix this error, re-compile the original source code."
				)
			elseif op > 10 then
				if op < 12 then
					-- POP
					self.Stack:pop()
				else
					-- CALL_FUNC
					local functionName = i.operands[1] :: string

					-- get the function from the Library
					local func = assert(
						dialogue.Library:GetFunction(functionName),
						`The function {functionName} does not exist!`
					)

					local expectedParamCount = func.argumentCount
					local actualParamCount = math.floor(self.Stack:pop() :: number)

					if actualParamCount ~= expectedParamCount then
						error(
							`Function {functionName} expected {expectedParamCount} parameters, but received {actualParamCount}`
						)
					end

					local params = table.create(actualParamCount)

					for param = actualParamCount, 1, -1 do
						params[param] = self.Stack:pop()
					end

					local ret = func.func(table.unpack(params))

					if ret ~= nil then
						self.Stack:push(ret)
					end
				end
			else
				-- JUMP_IF_FALSE
				if self.Stack:peek() == false then
					self.ProgramCounter = self:FindInstructionPointForLabel(i.operands[1] :: string) - 1
				end
			end
		elseif op > 13 then
			if op < 15 then
				-- STORE_VARIABLE
				local topValue = self.Stack:peek()
				local destinationVariableName = i.operands[1] :: string

				dialogue.VariableStorage[destinationVariableName] = topValue
			elseif op > 15 then
				-- RUN_NODE

				-- pop a string from the stack, and jump to a node
				-- with that name
				local nodeName = self.Stack:pop() :: string

				if dialogue.OnNodeComplete then
					dialogue.OnNodeComplete(assert(self.CurrentNodeName))
				end

				self:SetNode(nodeName)

				-- decrement program counter here, because it will
				-- be incremented when this function returns, and
				-- would mean skipping the first instruction
				self.ProgramCounter -= 1
			else
				-- STOP
				if dialogue.OnNodeComplete then
					dialogue.OnNodeComplete(assert(self.CurrentNodeName))
				end

				if dialogue.OnDialogueComplete then
					dialogue.OnDialogueComplete()
				end

				self.ExecutionState = "Stopped"
			end
		else
			-- PUSH_VARIABLE
			local variableName = i.operands[1] :: string

			local loadedValue = dialogue.VariableStorage[variableName]

			if loadedValue == nil then
				-- we don't have a value for this. the initial
				-- value may be found in the program. (if it's not,
				-- then the variable's value is undefined, which isn't
				-- allowed)
				loadedValue = assert(dialogue.Program).initial_values[variableName]
			end

			-- typecheck to ensure value is proper type for the stack
			local loadedType = typeof(loadedValue)
			assert(
				loadedType == "string" or loadedType == "boolean" or loadedType == "number",
				`Loaded variable {variableName} has an invalid type.`
			)

			self.Stack:push(loadedValue)
		end
	else
		-- PUSH_BOOL
		self.Stack:push(i.operands[1])
	end
end

--- Sets the node for the VirtualMachine to run.
--- @within VirtualMachine
---
--- This method will call [ResetState](VirtualMachine#ResetState) and invoke
--- the [PrepareForLinesHandler](Dialogue#OnPrepareForLines) in the parent Dialogue.
--- @param nodeName string -- Name of the node to load
function VirtualMachine.SetNode(self: VirtualMachine, nodeName: string)
	local program = assert(self.Dialogue.Program, `Cannot load node named {nodeName}: No nodes have been loaded.`)

	local node = assert(program.nodes[nodeName], `No node named {nodeName} has been loaded.`)

	self:ResetState()
	self.CurrentNode = node
	self.CurrentNodeName = nodeName

	if self.Dialogue.OnNodeStart then
		self.Dialogue.OnNodeStart(nodeName)
	end

	if self.Dialogue.OnPrepareForLines then
		-- create a list; we will never have more lines and options
		-- than instructions, so that's a decent capacity for the list
		local stringIDs = table.create(#node.instructions)

		-- loop over every instruction and find the ones that run a
		-- line or add an option, these are the two instructions that
		-- will signal a line can appear to the player
		for _, instruction in ipairs(node.instructions) do
			-- only RUN_LINE and ADD_OPTION
			if instruction.opcode == 2 or instruction.opcode == 4 then
				table.insert(stringIDs, instruction.operands[1] :: string)
			end
		end

		self.Dialogue.OnPrepareForLines(stringIDs)
	end

	return true
end

--- Sets the selected option
--- @within VirtualMachine
--- @private
---
--- :::caution
--- Calling this method when [ExecutionState](VirtualMachine#ExecutionState)
--- is not `"WaitingOnOptionSelection"` will cause an error.
--- :::
--- @param selectedOptionID number -- Index of an option inside [currentOptions](VirtualMachine#currentOptions)
function VirtualMachine.SetSelectedOption(self: VirtualMachine, selectedOptionID: number)
	assert(
		self.ExecutionState == "WaitingOnOptionSelection",
		"SetSelectedOption was called, but Dialogue wasn't waiting for a selection."
	)

	-- we now know what number option was selected, push the
	-- corresponding node name to the stack
	local selection =
		assert(self.CurrentOptions[selectedOptionID], `{tostring(selectedOptionID)} is not a valid option ID!`)
	self.Stack:push(selection.destination)

	-- we no longer need the options in the list
	table.clear(self.CurrentOptions)

	-- wait for the game to let us continue
	self.ExecutionState = "WaitingForContinue"
end

return VirtualMachine
