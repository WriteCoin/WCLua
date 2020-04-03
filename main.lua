-- do
--     function sum(x,y)
--         if type(x)=='number' and type(y)=='number' then
--             return x+y
--         end
--     end
--     local _sum = sum
--     function sum(x_tbl,y)
--         local result = _sum(x_tbl,y)
--         if not result then
--             if type(x_tbl)=='table' then
--                 result = {}
--                 for i = 1, #x_tbl do
--                     if type(x_tbl[i])=='table' then
--                         result[i] = _sum(x_tbl[i][1],x_tbl[i][2])
--                     end
--                 end
--                 return result
--             else
--                 return nil
--             end
--         end
--         return result
--     end
--     local t = sum({{1,2},{2,3},{4,5}})
--     for i = 1, #t do
--         print(t[i])
--     end
-- end
do
    function emptyTable(tbl)
        if type(tbl)~='table' then
            return nil
        end
        for _, _ in pairs(tbl) do
            return false
        end
        return true
    end
    function seriesFunc(f,tbl,...)
        if not (type(f)=='function') then
            return nil
        end
        local result = {}
        local args = {...}
        if emptyTable(args) then
            local c=0
            for key, value in pairs(tbl) do
                if type(value)=='table' then
                    result[key] = f(value)
                    c=c+1
                end
            end
            if c==0 then
                return f(tbl)
            end
        else
            local c=0
            local firstKey = nil
            for key, _ in pairs(tbl) do
                c=c+1
                if c>1 then
                    break
                end
                firstKey = key
            end
            if c==1 then
                result[1] = f(tbl[firstKey])
            else
                result[1] = f(tbl)
            end
            for i = 1, #args do
                result[i+1] = f(args[i])
            end
        end
        return result
    end
    function seriesXFunc(f,x,...)
        return seriesFunc(f,{x},...)
    end
    function seriesAndFunc(f,tbl,...)
        if not (type(f)=='function') then
            return nil
        end
        local args = {...}
        if emptyTable(args) then
            local c=0
            for key, value in pairs(tbl) do
                if type(value)=='table' then
                    if not f(value) then
                        return false
                    end
                    c=c+1
                end
            end
            if c==0 and not f(tbl) then
                return false
            end
        else
            local c=0
            local firstKey = nil
            for key, _ in pairs(tbl) do
                c=c+1
                if c>1 then
                    break
                end
                firstKey = key
            end
            if c==1 then
                if not f(tbl[firstKey]) then
                    return false
                end
            elseif not f(tbl) then
                return false
            end
            for i = 1, #args do
                if not f(args[i]) then
                    return false
                end
            end
        end
        return true
    end
    function seriesAndXFunc(f,x,...)
        return seriesAndFunc(f,{x},...)
    end
    function seriesOrFunc(f,tbl,...)
        if not (type(f)=='function') then
            return nil
        end
        local args = {...}
        if emptyTable(args) then
            local c=0
            for key, value in pairs(tbl) do
                if type(value)=='table' then
                    if f(value) then
                        return true
                    end
                    c=c+1
                end
            end
            if c==0 and f(tbl) then
                return true
            end
        else
            local c=0
            local firstKey = nil
            for key, _ in pairs(tbl) do
                c=c+1
                if c>1 then
                    break
                end
                firstKey = key
            end
            if c==1 then
                if f(tbl[firstKey]) then
                    return true
                end
            elseif f(tbl) then
                return true
            end
            for i = 1, #args do
                if f(args[i]) then
                    return true
                end
            end
        end
        return false
    end
    function seriesOrXFunc(f,x,...)
        return seriesOrFunc(f,{x},...)
    end
    function seriesXorFunc(f,tbl,...)
        if not (type(f)=='function') then
            return nil
        end
        local args = {...}
        local count=0
        if emptyTable(args) then
            local c=0
            for key, value in pairs(tbl) do
                if type(value)=='table' then
                    if f(value) then
                        count=count+1
                    end
                    c=c+1
                end
            end
            if c==0 and f(tbl) then
                count=count+1
            end
        else
            local c=0
            local firstKey = nil
            for key, _ in pairs(tbl) do
                c=c+1
                if c>1 then
                    break
                end
                firstKey = key
            end
            if c==1 then
                if f(tbl[firstKey]) then
                    count=count+1
                end
            elseif f(tbl) then
                count=count+1
            end
            for i = 1, #args do
                if f(args[i]) then
                    count=count+1
                end
            end
        end
        return count==1
    end
    function seriesXorXFunc(f,x,...)
        return seriesXorFunc(f,{x},...)
    end
    
    function maxnTable(tbl)
        if type(tbl)~='table' then
            return nil
        end
        local c=0
        for _, _ in pairs(tbl) do
            c=c+1
        end
        return c
    end
    function isTableAnd(tbl)
        
    end
    function sum(x,y)
        if not (type(x)=='number' and type(y)=='number') then
            return nil
        end
        return x+y
    end
    function _sum(tbl)
        if not type(tbl)=='table' then
            return nil
        end
        return sum(tbl[1],tbl[2])
    end
    -- local t = seriesFunc(_sum,{{1,2},{3,4},{5,6},{7,8}})
    -- for i = 1, #t do
    --     io.write(tostring(t[i])..', ')
    -- end
    -- print(seriesXorFunc(_sum,{{1,2},{3,4},{5,6},{7,8}}))
end
do
    return nil
end
do
    local function getSubTableText(text,table,name,indents)
        indents = indents or 0
        local indent = string.rep('\t',indents)
        text = text .. indent .. name .. ' = {\n'
        for key, value in pairs(table) do
            if type(tonumber(key))=='number' then
                key = '['..key..']'
            end
            if type(value)=='table' then
                text = getSubTableText(text,value,key,indents+1)
            else
                if type(value)=='string' then
                    value = "'" .. value .. "'"
                end
                text = text .. indent .. '\t' .. key .. ' = ' .. tostring(value) .. ',\n'
            end
        end
        if indents>0 then
            text = text .. indent .. '},\n'
        else
            text = text .. '}'
        end
        return text
    end

    function GetTableText(table,name)
        if type(table) ~= 'table' then
            return nil
        end
        if type(name) ~= 'string' then
            name='defaultTable'
        end
        return getSubTableText('',table,name,0)
    end

    function _GetTableText(tbl)
        if not type(tbl)=='table' then
            return nil
        end
        return GetTableText(tbl[1],tbl[2])
    end

    function printTable(tbl,name)
        print(GetTableText(tbl,name))
    end
    function _printTable(tbl)
        if not type(tbl)=='table' then
            return nil
        end
        printTable(tbl[1],tbl[2])
    end

    seriesFunc(_printTable,{{{1,2,3},'table1'},{{4,5,6},'table2'}})
    printTable(seriesXFunc(tostring,5,10,15,20))
end

do
    return nil
end

-- function seriesFunc(f,...)
--     if type(f) ~= 'function' then
--         return nil
--     end
--     local args = {...}
--     if args then
--         for i = 1, #args do
--             if type(args[i])=='table' then
--                 local s = ''
--                 for j = 1, #args[i] do
--                     s=s..tostring(args[i][j])
--                 end
--                 loadstring('f('..s..')')()
--             end
--         end
--     end
-- end
do
    return nil
end
-- основной алгоритм внешнего скрипта проекта
IsMainExternal = true
do
    lfs = require 'lfs' -- https://keplerproject.github.io/luafilesystem/manual.html
    projectDir = lfs.currentdir()..'\\'
    currentDir = projectDir..'run/lib/WCLuaStdScript/'
    dofile(currentDir..'WCLua.lua')
    --dofile('-','File')

    --dofile('+TableParser','main')
    --dofile('--','build')
end
print('\n\n\n\n\n'..tostring(0))