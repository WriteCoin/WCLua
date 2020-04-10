-- основной алгоритм внешнего скрипта проекта
dofile('test.lua')
do
    return nil
end
LAUNCHED_IN_GAME = (type(InitGlobals)=='function' and type(JASS_MAX_ARRAY_SIZE)=='number' and VERSION_REIGN_OF_CHAOS and VERSION_FROZEN_THRONE)
dofile('run/lib/WCLuaStdScript/WCLua.lua')
if not LAUNCHED_IN_GAME then
    print('\n\n\n\n\n'..tostring(0))
end