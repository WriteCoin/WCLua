--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
add = function(____, x) return function(____, y) return x + y end end
print(
    add(_G, 2)(_G, 4)
)
add2 = add(_G, 2)
print(
    add2(_G, 2)
)
print(
    __TS__ArrayMap({1, 2, 3}, add2)
)
