local extend = require("iron.util.tables").extend

local cpp = {}

local function magic(str)
    -- remove every space at beginning of a line
    str = str:gsub('^%s+', '')
    -- remove all comments
    str = str:gsub('//(.*)', '')
    -- remove every space at end of a line
    str = str:gsub('%s+$', '')
    -- remove line break and extra spaces eventually
    str = str:gsub([[\$]], '')
    str = str:gsub('%s+$', '')
    return str
end

local function lastmagic(str)
    -- check what character is the last of the line
    if str:len() == 0 then return false end
    local lastchar = str:sub(-1, -1)
    return lastchar == ';' or lastchar == '{' or lastchar == '}'
end

local function format(lines)
    if #lines == 1 then
        return {magic(lines[1]) .. '\13'}
    else
        local new = {}
        local aus = ''
        for line = 1, #lines do
            -- concatenate lines if they do not end with a lastmagic character.
            local l = magic(lines[line])
            aus = aus .. l
            if lastmagic(l) then
                table.insert(new, aus)
                aus = ''
            end
        end
        return extend(new, '')
    end
end

cpp.root = {command = {'root', '-l'}, format = format}

return cpp
