do
    tableInsert = table.insert
    tableRemove = table.remove

    function MergeTable(tbl1,tbl2)
        for key, value in pairs(tbl2) do
            tbl1[key] = value
        end
        return tbl1
    end
    function TableEmpty(tbl)
        for _, _ in pairs(tbl) do
            return false
        end
        return true
    end

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

    local exts = {
        lua = '.lua',
        txt = '.txt',
        bat = '.bat',
        mdx = '.mdx',
        mdl = '.mdl',
        blp = '.blp',
        tga = '.tga',
        imp = '.imp',
        wav = '.wav',
        mp3 = '.mp3',
        slk = '.slk',
        j = '.j',
        ai = '.ai',
        pld = '.pld'
    }
    Path = {}
    local function getPath(path)
        if not isString(path) then
            if isClass(path,Path) then
                return path
            else
                return nil
            end
        end
        local t = {
            class=tostring(Path)
        }
        t.path = path

        function t.getFull()
            if t.fullPath then
                return t.fullPath
            end
            local path = path
            if not path:find(currentDir) then
                path = currentDir .. path
                t.fullPath = path
            else
                t.fullPath = t.path
            end
            return t.fullPath
        end

        function t.checkIsDir()
            if t.isDir then
                return t.isDir
            end
            local path = t.getFull()
            local len = path:len()
            if path:sub(len,len)=='/' or path:sub(len,len)=='\\' then
                local pos = len-1
                while path:sub(pos,pos)=='/' or path:sub(pos,pos)=='\\' do
                    pos=pos-1
                end
                path = path:sub(1,pos)
            end
            local attr = lfs.attributes(path)
            t.isDir = (attr and attr.mode == 'directory')
            return t.isDir
        end
        
        function t.split()
            if t.dirPath or t.fileName or t.ext then
                return t.dirPath, t.fileName, t.ext
            end
            local dirpath, filename, ext
            local path = t.getFull()
            dirpath, filename = path:match("^%s*(.-)([^\\/]*)$")
            if filename then
                filename, ext = filename:match("([^%.]*)%.?(.*)$")
            end
            t.dirPath = dirpath
            t.fileName = filename
            t.ext = ext
            return t.dirPath, t.fileName, t.ext
        end

        function t.getFileExt()
            if t.fileExt then
                return t.fileExt
            end
            t.fullPath = t.getFull()
            local ext = t.fullPath:match("[^.]+$")
            if exts[ext] then
                t.fileExt = ext
            end
            return t.fileExt
        end

        function t.getFilePath(ext)
            if t.filePath then
                return t.filePath
            end
            if isString(ext) then
                local len = ext:len()
                if ext:sub(1,1)=='.' and exts[ext:sub(2,len)] then
                    ext = ext:sub(2,len)
                end
            end
            local isExt = (isString(ext) and exts[ext])
            t.fileExt = t.getFileExt()
            t.fullPath = t.getFull()
            if not t.fileExt then
                if not isExt then
                    return nil
                else
                    t.filePath = t.fullPath .. exts[ext]
                end
            else
                if not exts[t.fileExt] then
                    t.fileExt = '.' .. t.fileExt
                else
                    t.fileExt = exts[t.fileExt]
                end
                if isExt then
                    t.filePath = t.fullPath:gsub(t.fileExt,exts[ext],1)
                end
            end
            return t.filePath
        end

        return t
    end
    function getFullPath(path)
        local path = getPath(path)
        if not path then
            return nil
        end
        return path.getFull()
    end
    function isDirPath(path)
        local path = getPath(path)
        if not path then
            return nil
        end
        return path.checkIsDir()
    end
    function splitPath(path)
        local path = getPath(path)
        if not path then
            return nil
        end
        return path.split()
    end
    function getFileExt(path)
        local path = getPath(path)
        if not path then
            return nil
        end
        return path.getFileExt()
    end
    function getFilePath(path,ext)
        local path = getPath(path)
        if not path then
            return nil
        end
        return path.getFilePath(ext)
    end

    local dofile_origin = dofile
    function dofile(path,files)
        if not (isString(path) and (isString(files) or isTable(files))) then
            return nil
        end
        if isString(files) then
            files = Path.getFilePath(files,'.lua')
            local file = files
            files = {}
            tableInsert(files,file)
        end
        local dir = currentDir
        if not Path.isDir(path) then
            tableInsert(files,1,path)
        else
            currentDir = currentDir..path..'/'
        end
        for i = 1, #files do
            local path = Path.getFilePath(files[i],'.lua')
            if path then
                dofile_origin(files[i])
            end
        end
        currentDir = dir
    end
end