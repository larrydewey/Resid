local n = tonumber(arg[1])
local s = ""
for i = 0, n - 1 do s = s .. tostring(i) .. "," end
print(#s)
