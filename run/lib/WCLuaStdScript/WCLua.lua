tableInsert = table.insert
tableRemove = table.remove
tableUnpack = table.unpack
tablePack = table.pack

function isEmptyTable1(tbl)
    if type(tbl)~='table' then
        return nil
    end
    local _,v = next(tbl)
    return (v==nil)
end

-- local t = {}
-- print(isEmptyTable(t))
-- do
--     return nil
-- end

-- local function test()
--     return nil,5
-- end
-- if tableUnpack(tablePack(test())) then
--     print('+')
-- end
-- do
--     return nil
-- end

-- local t = {{1}}
-- print(#tableUnpack(t))
-- do
--     return nil
-- end

-- local function test1(a,b)
-- end
-- print(string.dump(test1))
-- local function test1(a)
-- end
-- print(string.dump(test1))
-- for key, value in pairs(string) do
--     if type(value)=='function' then
--         print(key)
--     end
-- end
-- do
--     return nil
-- end

local export = {}
do
    local tableInsert = tableInsert
    local tableUnpack = tableUnpack
    local tablePack = tablePack
    local next = next
    local type = type

    local function getTblValues(f,tbl)
        if type(f)~='function' or type(tbl)~='table' then
            return nil
        end
        local values = f(tableUnpack(tbl))
        local tblValues = tablePack(values)
        if #tblValues==1 then
            return tableUnpack(tblValues)
        else
            return tblValues
        end
    end
    export.getTblValues = getTblValues

    local function seriesFunc(f,tbl,...)
        local result = {}
        local args = {...}
        if type(tbl)=='table' then
            if tbl[1] and not tbl.class then
                tableInsert(result,getTblValues(f,tbl))
            else
                tableInsert(args,1,tbl)
                return f(tableUnpack(args))
            end
        else
            tableInsert(args,1,tbl)
            return f(tableUnpack(args))
        end
        if #args==0 then
            if #result==0 then
                return nil
            end
            return tableUnpack(result[1])
        end
        for i = 1, #args do
            if type(args[i])=='table' then
                tableInsert(result,getTblValues(f,args[i]))
            end
        end
        return result
    end

    function getSeriesFunc(f)
        if type(f) ~= 'function' then
            return nil
        end
        return function(tbl,...)
            return seriesFunc(f,tbl,...)
        end, true
    end
    function getSeriesXFunc(f)
        if type(f) ~= 'function' then
            return nil
        end
        return function(tbl,...)
            local args = {...}
            for i = 1, #args do
                args[i] = {args[i]}
            end
            return seriesFunc(f,{tbl},tableUnpack(args))
        end, true
    end

    local function seriesAndFunc(f,tbl,...)
        local result = {}
        local args = {...}
        if type(tbl)=='table' then
            if tbl[1] and not tbl.class then


                local values = f(tableUnpack(tbl))
                local tblValues = tablePack(values)
                if #tblValues==1 then
                    if not tableUnpack(tblValues) then
                        return false
                    end
                else
                    tableInsert(result,tblValues)
                end
            else
                tableInsert(args,1,tbl)
                return f(tableUnpack(args))
            end
        else
            tableInsert(args,1,tbl)
            return f(tableUnpack(args))
        end
        if #args==0 then
            if #result==0 then
                return nil
            end
            return tableUnpack(result[1])
        end
        for i = 1, #args do
            if type(args[i])=='table' then
                local values = f(tableUnpack(args[i]))
                local tblValues = tablePack(values)
                if #tblValues==1 then
                    tableInsert(result,tableUnpack(tblValues))
                else
                    tableInsert(result,tblValues)
                end
            end
        end
        return result
    end
end
getTblValues = export.getTblValues

filter = getSeriesFunc(function(n,nr)
    if type(n)=='number' and type(nr)=='number' then
        return n>nr and n or nil
    end
    return nil
end)
sum = getSeriesFunc(function(tbl)
    if type(tbl)~='table' then
        return nil
    end
    local s = 0
    for i = 1, #tbl do
        if type(tbl[i])=='number' then
            s=s+tbl[i]
        end
    end
    return s
end)
print(sum(filter({1,3},{2,3},{3,3},{4,3},{5,3})))
do
    return nil
end


-- sum = getSeriesFunc(function(x,y)
--     if type(x)=='number' and type(y)=='number' then
--         return x+y
--     end
--     return nil
-- end)
-- print(tableUnpack(sum({1,2},{3,4},{5,6})))

function formatType(type)
    if type=='number' or type=='string' or type=='boolean' or type=='table' or type=='function' then
        return type
    elseif type=='n' then
        return 'number'
    elseif type=='s' or type=='id' then
        if type=='id' then
            return 'string',true
        end
        return 'string'
    elseif type=='b' or type=='bn' then
        return 'boolean'
    elseif type=='t' then
        return 'table'
    elseif type=='f' then
        return 'function'
    else
        return nil
    end
end

function isAllTypes(t,...)
    
end
do
    return nil
end

function isAllType(t,...)
    local args = ...
    local len = #args
    local t = formatType(t)
    print(type(args[len]))
    if type(args[len])~=t then
        return false
    end
    tableRemove(args,len)
    if not isTableEmpty(args) and not isAllType(t,...) then
        return false
    end
    return true
end
print(isAllType('n',5,10,15,20))
do
    return nil
end

function mergeTable(tbl1,tbl2)
    for key, value in pairs(tbl2) do
        tbl1[key] = value
    end
    return tbl1
end

function isAllType(t,...)
    local result = {}
    local args = {...}
    local t = formatType(t)
    for i = 1, #args do
        tableInsert(result,type(args[i])==t)
    end
    return result
end

function toboolean(n)
    if type(n)=='boolean' then
        
    end
end