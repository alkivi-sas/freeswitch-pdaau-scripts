local pdaa = {}

local rootdir = os.getenv('PDAAU_ROOT_DIR')
if rootdir == nil then
    rootdir = '/var/lib/freeswitch/pdaau-sources'
end

local startswith = function (String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

local file_exists = function (file)
    local f = io.open(file, "rb")
    if f then f:close() end
    return f ~= nil
end


function pdaa.get_directory_from_insee (code)
    -- If code startswith 2A -> Corse-du-Sud -> 201
    if startswith(code, '2A') then
        return "201"
    end
    if startswith(code, '2B') then
        return "202"
    end
    if startswith(code, '97') then
        return string.sub(code, 0, 3)
    end
    -- If code startswith 2B -> Corde-du-Nord -> 202
    -- If code startswith 97 -> DOM -> 3 chiffres
    return string.format("%03d", string.sub(code, 0, 2))
end

function pdaa.parse_csv_line (line, sep)
    local res = {}
    local pos = 1
    sep = sep or ','
    while true do
        local c = string.sub(line,pos,pos)
        if (c == "") then break end
        if (c == '"') then
            -- quoted value (ignore separator within)
            local txt = ""
            repeat
                local startp,endp = string.find(line,'^%b""',pos)
                txt = txt..string.sub(line,startp+1,endp-1)
                pos = endp + 1
                c = string.sub(line,pos,pos)
                if (c == '"') then txt = txt..'"' end
                -- check first char AFTER quoted string, if it is another
                -- quoted string without separator, then append it
                -- this is the way to "escape" the quote char in a quote. example:
                --   value1,"blub""blip""boing",value3  will result in blub"blip"boing  for the middle
            until (c ~= '"')
            table.insert(res,txt)
            assert(c == sep or c == "")
            pos = pos + 1
        else
            -- no quotes used, just look for the first separator
            local startp,endp = string.find(line,sep,pos)
            if (startp) then
                table.insert(res,string.sub(line,pos,startp-1))
                pos = endp + 1
            else
                -- no separator found -> use rest of string and terminate
                table.insert(res,string.sub(line,pos))
                break
            end
        end
    end
    return res
end


function pdaa.get_unique_line_starting_with (file, pattern)
    if not file_exists(file) then return nil end
    local lines = {}
    for line in io.lines(file) do
        if startswith(line, pattern) then
            lines[#lines + 1] = line
        end
    end
    -- todo test if unique
    if #lines == 1 then
        return lines[1]
    else
        return nil
    end
end

function pdaa.translate (dialled_number, insee_code)
    local directory = pdaa.get_directory_from_insee(insee_code)

    -- build path of wanted files
    local pdaa_file = rootdir .. '/' .. directory .. '/pdaa.csv'
    local caau_file = rootdir .. '/' .. directory .. '/caau.csv'

    -- read pdaa
    local pdaa_search = insee_code .. "," .. dialled_number
    local pdaa_line = pdaa.get_unique_line_starting_with(pdaa_file, pdaa_search)
    if pdaa_line == nil then 
        return nil
    end
    local parsed_pdaa_line = pdaa.parse_csv_line(pdaa_line, ',')
    local pdaa_code = parsed_pdaa_line[5]

    --search caau
    local caau_search = dialled_number .. "," .. pdaa_code
    local caau_line = pdaa.get_unique_line_starting_with(caau_file, caau_search)
    if caau_line == nil then
        return nil
    end
    local parsed_caau_line = pdaa.parse_csv_line(caau_line, ',')
    local final_number = parsed_caau_line[9]
    return final_number
end

return pdaa
