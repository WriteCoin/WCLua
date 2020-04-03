do
    function MergeTable(tbl1,tbl2)
        for key, value in pairs(tbl2) do
            tbl1[key] = value
        end
        return tbl1
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