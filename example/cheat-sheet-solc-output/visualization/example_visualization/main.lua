-- LÖVE setup with execution flow tracking
local stack = {}
local memory = {}
local current_instruction = ""
local instruction_log = {}
local current_step = 1

-- Compatibility fix for unpack
local unpack = table.unpack or unpack

-- Utility Functions
local function push(value)
    table.insert(stack, 1, value)
end

local function pop()
    return table.remove(stack, 1)
end

local function log_instruction(opcode, operand)
    local log_entry = {
        step = current_step,
        opcode = opcode,
        operand = operand or "",
        stack_snapshot = {unpack(stack)}, -- Compatibility ensured
        memory_snapshot = {unpack(memory)} -- Compatibility ensured
    }
    table.insert(instruction_log, log_entry)
end

local function execute(opcode, operand)
    current_instruction = opcode .. (operand and " " .. operand or "")
    log_instruction(opcode, operand)

    if opcode == "PUSH1" then
        push(tonumber(operand, 16))
    elseif opcode == "CALLVALUE" then
        push(0x00) -- Simulate msg.value being 0
    elseif opcode == "ISZERO" then
        local value = pop()
        push(value == 0 and 1 or 0)
    elseif opcode == "MSTORE" then
        local value = pop()
        local address = pop()
        memory[address] = value
    elseif opcode == "CALLER" then
        push(0xabc) -- Simulate msg.sender
    elseif opcode == "SSTORE" then
        local value = pop()
        local slot = pop()
        memory[slot] = value
    elseif opcode == "DUP1" then
        local value = stack[1]
        push(value)
    elseif opcode == "JUMPI" then
        local condition = pop()
        if condition ~= 0 then
            print("Jumping (simulated)...")
        end
    elseif opcode == "REVERT" then
        stack = {}
    elseif opcode == "STOP" then
        stack = {}
    elseif opcode == "CODECOPY" then
        -- Simulate copying runtime code
        local offset = pop()
        local size = pop()
        memory[offset] = "Runtime Code"
    elseif opcode == "RETURN" then
        print("Returning runtime code.")
    end
end

-- Instructions
local instructions = {
    {"PUSH1", "0x60"}, {"PUSH1", "0x40"}, {"MSTORE"},
    {"CALLVALUE"}, {"ISZERO"}, {"PUSH1", "0x0e"}, {"JUMPI"},
    {"PUSH1", "0x00"}, {"DUP1"}, {"REVERT"}, -- Skipped by jump
    {"CALLER"}, {"PUSH1", "0x00"}, {"DUP1"}, {"PUSH2", "0x0100"}, {"EXP"}, {"DUP2"}, {"SSTORE"},
    {"PUSH1", "0x35"}, {"DUP1"}, {"PUSH1", "0x5b"}, {"PUSH1", "0x00"}, {"CODECOPY"}, {"PUSH1", "0x00"}, {"RETURN"}
}

-- LÖVE callbacks
function love.load()
    love.window.setTitle("EVM Stack and Execution Flow Visualization")
    love.window.setMode(1000, 800)
end

function love.keypressed(key)
    -- Advance execution one step at a time with space bar
    if key == "space" and current_step <= #instructions then
        local instruction = instructions[current_step]
        execute(instruction[1], instruction[2])
        current_step = current_step + 1
    end
end

function love.draw()
    -- Draw current instruction
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Press SPACE to execute the next instruction.", 20, 20)
    love.graphics.print("Current Instruction: " .. current_instruction, 20, 50)

    -- Draw execution log
    love.graphics.setColor(0.5, 1, 0.5)
    love.graphics.print("Execution Flow Log:", 20, 80)
    for i, log in ipairs(instruction_log) do
        local log_text = string.format("%d: %s %s", log.step, log.opcode, log.operand)
        love.graphics.print(log_text, 20, 100 + i * 15)
    end

    -- Draw Stack
    love.graphics.setColor(0.5, 0.8, 1)
    love.graphics.print("Stack:", 500, 50)
    for i, value in ipairs(stack) do
        love.graphics.rectangle("fill", 500, 70 + i * 30, 100, 25)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(tostring(value), 510, 75 + i * 30)
        love.graphics.setColor(0.5, 0.8, 1)
    end

    -- Draw Memory
    love.graphics.setColor(0.8, 0.6, 1)
    love.graphics.print("Memory:", 650, 50)
    local y_offset = 0
    for key, value in pairs(memory) do
        love.graphics.rectangle("fill", 650, 70 + y_offset, 200, 25)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(string.format("[%s]: %s", tostring(key), tostring(value)), 660, 75 + y_offset)
        love.graphics.setColor(0.8, 0.6, 1)
        y_offset = y_offset + 30
    end
end

