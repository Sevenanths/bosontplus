dofile("patterns.lua")
print("patterns={")
for name, pattern in pairs(patterns) do
    print("{name = \"" .. name .. "\", stages = {1, 2, 3}, [[")
    local len = #pattern[1]
    local width = #pattern
    for i = len-1, 1, -2 do
        local line = ""
        for j = 1, width do
            local cell = pattern[j]:sub(i, i+1)
            if cell == "  " or cell == "" then
                cell = "  "
            end
            line = line .. "|" .. cell
        end
        print(line .. "|")
    end
    print("]]},")
end
print("}")
