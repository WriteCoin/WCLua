do
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
        if type(path) ~= 'string' then
            if path.class == tostring(Path) then
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
        
        function t.split(isFull)
            if t.dirPath or t.fileName or t.ext then
                return t.dirPath, t.fileName, t.ext
            end
            local dirpath, filename, ext
            local path
            if isFull then
                path = t.getFull()
            else
                path = t.path
            end
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
            if type(ext)=='string' then
                local len = ext:len()
                if ext:sub(1,1)=='.' and exts[ext:sub(2,len)] then
                    ext = ext:sub(2,len)
                end
            end
            local isExt = (type(ext)=='string' and exts[ext])
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
    function splitPath(path,isFull)
        local path = getPath(path)
        if not path then
            return nil
        end
        return path.split(isFull)
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
    do
        return nil
    end
    if not LAUNCHED_IN_GAME then
        local dofile_origin = dofile
        function dofile(path,files)
            local isDir = isDirPath(path)
            if not (type(path)=='string' and (type(files)=='string' or type(files)=='table' or not isDir)) then
                return nil
            end
            -- local result = {}
            -- for i = 1, #files do
            --     local path = getFilePath(files[i],'.lua')
            --     if path then
            --         table.insert(result,path)
            --     end
            -- end
            if not files then
                files = {}
            end
            local dir = currentDir
            if not isDir then
                table.insert(files,1,path)

                print(splitPath(path))
            else
                currentDir = currentDir..path..'/'
            end
            do
                return nil
            end
            if type(files)=='string' then
                files = getFilePath(files,'.lua')
                local file = files
                files = {}
                table.insert(files,file)
            end
            -- for i = 1, #result do
            --     print(currentDir)
            --     dofile_origin(result[i])
            -- end
            for i = 1, #files do
                local path = getFilePath(files[i],'.lua')
                if path then
                    dofile_origin(files[i])
                end
            end
            -- print(currentDir)
            currentDir = dir
        end
    end
end
dofile('_handles/_handles')