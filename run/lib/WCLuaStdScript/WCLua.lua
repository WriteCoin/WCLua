do
    function string.slashDel(path,isAll)
        if type(path)~='string' then
            return nil
        end
        local len = path:len()
        if path:sub(len,len)=='/' or path:sub(len,len)=='\\' then
            local pos = nil
            if isAll then
                pos = len
            else
                pos=len-1
            end
            while path:sub(pos,pos)=='/' or path:sub(pos,pos)=='\\' do
                pos=pos-1
            end
            path = path:sub(1,pos)
        end
        return path
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
            local path = t.getFull():slashDel()
            -- local len = path:len()
            -- if path:sub(len,len)=='/' or path:sub(len,len)=='\\' then
            --     local pos = len-1
            --     while path:sub(pos,pos)=='/' or path:sub(pos,pos)=='\\' do
            --         pos=pos-1
            --     end
            --     path = path:sub(1,pos)
            -- end
            local attr = require('lfs').attributes(path)
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
    -- print(isDirPath(''))
    -- do
    --     return nil
    -- end
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
    -- local dir,filename,ext = splitPath('_handles/')
    -- print(filename=='')
    -- do
    --     return nil
    -- end

    if not LAUNCHED_IN_GAME then

        -- see if the file exists
        function FileExists(file)
            if type(file)~='string' then
                return nil
            end
            local f = io.open(file,'rb')
            if f then f:close() end
            return f ~= nil
        end

        local dofile_origin = dofile
        function dofile(filesTbl)
            local files = {}
            if type(filesTbl)=='table' then
                files = filesTbl
            elseif type(filesTbl)=='string' then
                files = {filesTbl}
            else
                return nil
            end
            local dir = currentDir
            for i = 1, #files do
                local path = files[i]
                if type(path)=='string' then
                    local dirPath,filename = splitPath(path)
                    if isDirPath(dirPath) then
                        --print(dirPath,filename)
                        if filename=='' then
                            local pathCopy = path:slashDel(true)
                            path = path .. pathCopy
                        end
                        --print('path: '..path)
                        local path = getFilePath(path,'.lua')
                        if FileExists(path) then
                            dirPath = dirPath:gsub(currentDir,'')
                            currentDir = currentDir .. dirPath .. '/'
                            dofile_origin(path)
                            currentDir = dir
                        else
                            print('Ошибка: файл ' .. path .. ' не существует.')
                        end
                    end
                end
            end
        end
    end
end
dofile({
    '_handles/',

})