-- основной алгоритм внешнего скрипта проекта
LAUNCHED_IN_GAME = (type(InitGlobals)=='function' and type(JASS_MAX_ARRAY_SIZE)=='number' and VERSION_REIGN_OF_CHAOS and VERSION_FROZEN_THRONE)
local path = 'run/lib/WCLuaStdScript/WCLua.lua'
dofile(path)
if not LAUNCHED_IN_GAME then
    print('\n\n\n\n\n'..tostring(0))
end