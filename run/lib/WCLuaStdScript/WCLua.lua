do
    if not lfs then
        lfs = require 'lfs'
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
    function isTable(var)
        return type(var) == 'table'
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
    function newObject(class)
        return { class = tostring(class) }
    end

    Path = {}
    currentDir = lfs.currentdir()..'\\'..'run/lib/WCLua/'
    projectDir = currentDir
    local exts = {
        lua = '.lua',
        txt = '.txt',
        bat = '.bat'
    }
    function Path.get(path)
        if not isString(path) then
            if isClass(path,Path) then
                return path
            else
                return nil
            end
        end
        local t = newObject(Path)
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
        function Path.getFileExt(path)
            local path = Path.get(path)
            if not path then
                return nil
            end
            return path.getFileExt()
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
    function Path.getFull(path)
        local path = Path.get(path)
        if not path then
            return nil
        end
        return path.getFull()
    end
    function Path.isDir(path)
        local path = Path.get(path)
        if not path then
            return nil
        end
        return path.checkIsDir()
    end
    function Path.split(path)
        local path = Path.get(path)
        if not path then
            return nil
        end
        return path.split()
    end
    function Path.getFilePath(path,ext)
        local path = Path.get(path)
        if not path then
            return nil
        end
        return path.getFilePath(ext)
    end

    tableInsert = table.insert

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