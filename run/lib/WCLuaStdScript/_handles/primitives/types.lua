do
    function isTable(var)
        return type(var)=='table'
    end
    local _isTable = isTable
    function isTable(var,tbl,...)
        local result = {}
        if not _isTable(tbl) then
            local a = tbl
            tbl = {}
        end
        if _isTable(tbl) then
            for key, _ in pairs(tbl) do
                result[key] = _isTable(tbl[key])
            end
        end
        tbl = {...}
        for i = 1, tbl do
            result[i] = _isTable({...}[i])
        end
    end

    function formatType(type)
        local typeIsId = nil
        if type=='number' or type=='string' or type=='boolean' or type=='table' or type=='function' then
            return type
        elseif type=='n' then
            type='number'
        elseif type=='s' or type=='id' then
            type='string'
            if type=='id' then
                typeIsId = true
            end
        elseif type=='b' or type=='bn' then
            type='boolean'
        elseif type=='t' then
            type='table'
        elseif type=='f' then
            type='function'
        else
            type=nil
        end
        return type,typeIsId
    end
    local inj = formatType
    function formatType(type,tbl,...)
        
    end
    
    function isType(var,varType)
        if not isTable(arr) then
            return type(var)==formatType(varType)
        end
        tableInsert(arr,1,var)
        tableInsert(arr,2,varType)
        local c=0
        for i = 1, #arr do
            if i%2>0 then
                var = arr[i]
                c=c+1
            else
                local varType = formatType(arr[i])
                if varType and type(var)==varType then
                    c=c+1
                end
            end
        end
        return c==#arr
    end
    -- print(IsType(5,'number','abc','string',4,'string'))

    function isTable(tbl,...)
        return type(var) == 'table'
    end
    function isBoolean(var)
        return type(var) == 'boolean'
    end
    function isNumber(var)
        return type(var) == 'number'
    end
    function isString(var)
        return type(var) == 'string'
    end
    function isFunction(var)
        return type(var) == 'function'
    end
    function isClass(obj,class)
        if not isTable(obj) then
            return nil
        end
        return obj.class == tostring(class)
    end
end