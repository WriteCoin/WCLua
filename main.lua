-- основной алгоритм внешнего скрипта проекта
LAUNCHED_IN_GAME = (type(InitGlobals)=='function' and type(JASS_MAX_ARRAY_SIZE)=='number' and VERSION_REIGN_OF_CHAOS and VERSION_FROZEN_THRONE)
do
    lfs = require 'lfs' -- https://keplerproject.github.io/luafilesystem/manual.html
    projectDir = lfs.currentdir()..'\\'
    currentDir = projectDir..'run/lib/WCLuaStdScript/'
    dofile(currentDir..'WCLua.lua')
    
end
print('\n\n\n\n\n'..tostring(0))