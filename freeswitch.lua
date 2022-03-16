session:execute('log', 'WARNING emergency number lua script called')

local pdaau = require('pdaau')

local dialled_number = argv[1]
local insee_code = argv[2]

session:execute('log', 'WARNING dialled ' .. dialled_number .. ' with insee ' .. insee_code)

local final_number = pdaau.translate(dialled_number, insee_code)
if final_number == nil then
    session:execute('log', 'WARNING Unable to map emergency number')
    return
end

session:execute('log', 'WARNING final_number is ' .. final_number)
session:execute("transfer", final_number)
