-- основной алгоритм внешнего скрипта проекта
IsMainExternal = true
do
    lfs = require 'lfs' -- https://keplerproject.github.io/luafilesystem/manual.html
    dofile(lfs.currentdir()..'/run/lib/WCLua/WCLua.lua')
    --dofile('-','File')

    --dofile('+TableParser','main')
    --dofile('--','build')
end
print('\n\n\n\n\n'..tostring(0))