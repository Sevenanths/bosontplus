local
function pattern_defs_for_stage(stage)
    local patterns = import("patterns_stage" .. stage)
    return patterns
end

local type_map = {P = "normal", F = "fast", C = "collapsing", E = "energy", B = "barrier"}

local
function parse_pattern_def(patdef)
    local pattern = {}
    local pos = 1
    local chr
    local has_energy = false
    local patstr = patdef[1]
    local function nextchr()
        chr = patstr:sub(pos, pos)
        pos = pos + 1
    end
    local function prevchr()
        pos = pos - 1
        chr = patstr:sub(pos, pos)
    end
    local function eof()
        return chr == ""
    end
    local row = {}
    local col = 0
    local width = 0
    while true do
        nextchr()
        if eof() then
            break
        else
            local prev_row = pattern[1]
            local prev_cell
            if prev_row then
                prev_cell = prev_row[col]
            end
            if chr == "P" or chr == "F" or chr == "C" or chr == "E" then
                local type = type_map[chr]
                nextchr()
                local y = tonumber(chr)
                if prev_cell and prev_cell.type == type and prev_cell.y == y then
                    prev_cell.length = prev_cell.length + 1
                    row[col] = prev_cell
                else
                    row[col] = {type = type, y = y, length = 1}
                end
                if type == "energy" then
                    has_energy = true
                end
            elseif chr == "B" then
                if prev_cell and prev_cell.type == "barrier" then
                    prev_cell.length = prev_cell.length + 1
                    row[col] = prev_cell
                else
                    row[col] = {type = "barrier", length = 1}
                end
            elseif chr == ">" then
                row.left_barrier = col
                nextchr()
            elseif chr == "<" then
                row.right_barrier = col
                nextchr()
            elseif chr == "#" then
                row.lightning = true
            elseif chr == "m" then
                nextchr()
                local msg = ""
                while chr ~= "\n" do
                    msg = msg .. chr
                    nextchr()
                end
                prevchr()
                row.message = msg
            elseif chr == "|" then
                if col > width then
                    width = col
                end
                col = col + 1
            elseif chr == "\n" then
                table.insert(pattern, 1, row)
                row = {}
                col = 0
            end
        end
    end
    pattern.width = width
    pattern.name = patdef.name
    pattern.weight = patdef.weight or 1 / #pattern
    pattern.has_energy = has_energy and not patdef.noenergy
    return pattern
end

local
function parse_pattern_defs(pattern_defs)
    local patterns = {}
    for i, patdef in ipairs(pattern_defs) do
        patterns[i] = parse_pattern_def(patdef)
    end
    -- Remove tutorial if complete
    if patterns[1].name == "tutorial" then
        if lt.state.tutorial_complete then
            table.remove(patterns, 1)
        else
            -- remove start
            table.remove(patterns, 2)
        end
    end
    return patterns
end

local max_gap = 4

local
function is_compatible(pattern1, pattern2, offset)
    local length1 = #pattern1
    local length2 = #pattern2
    assert(pattern1.width == pattern2.width)
    local width = pattern1.width
    for lane1 = 1, width do
        local lane2 = lane1 + offset
        if lane2 > width then
            lane2 = lane2 - width
        end
        -- end1 is the row of the end of the last platform
        -- in pattern1 in lane1
        local end1
        for row = length1, math.max(1, length1 - max_gap), -1 do
            if pattern1[row][lane1] then
                if pattern1[row][lane1].type ~= "barrier" then
                    end1 = row
                end
                break
            end
        end
        if end1 then
            -- See if there is somewhere we can jump to from end1
            -- either in pattern1 or pattern2
            local found = false
            for lane = lane1 - 1, lane1 + 1 do
                if lane > width then
                    lane = lane - width
                elseif lane < 1 then
                    lane = lane + width
                end
                for row = end1 + 1, length1 + math.min(max_gap, length2) do
                    if row <= length1 then
                        local cell = pattern1[row][lane]
                        if cell and cell.type ~= "barrier" then
                            found = true
                            break
                        end
                    else
                        row = row - length1
                        local lane2 = lane + offset
                        if lane2 > width then
                            lane2 = lane2 - width
                        end
                        local cell = pattern2[row][lane2]
                        if cell and cell.type ~= "barrier" then
                            found = true
                            break
                        end
                    end
                end
                if found then
                    break
                end
            end
            if not found then
                return false
            end
        end
    end
    return true
end

local
function compute_compatibility(patterns)
    local w = patterns[1].width
    for i = 1, #patterns do
        local nexts_without_energy = {}
        local nexts_with_energy = {}
        patterns[i].nexts_without_energy = nexts_without_energy
        patterns[i].nexts_with_energy = nexts_with_energy
        for j = 2, #patterns do
            --log("checking compatibility between " .. patterns[i].name .. " and " .. patterns[j].name)
            if j ~= i then
                local offsets = {}
                for os = 0, w - 1 do
                    if is_compatible(patterns[i], patterns[j], os) then
                        table.insert(offsets, os)
                    end
                end
                if #offsets > 0 then
                    if patterns[j].has_energy then
                        table.insert(nexts_with_energy, {next = j, offsets = offsets, weight = patterns[j].weight})
                    else
                        table.insert(nexts_without_energy, {next = j, offsets = offsets, weight = patterns[j].weight})
                    end
                end
            end
        end
        --[[
        if #nexts_with_energy == 0 then
            log("WARNING: no compatible patterns with energy from pattern \"" .. patterns[i].name .. "\"")
        end
        ]]
        if #nexts_without_energy == 0 then
            log("WARNING: no compatible patterns without energy from pattern \"" .. patterns[i].name .. "\"")
        end
    end

    -- Check all patterns reachable from at least one other pattern besides the first
    for i = 2, #patterns do
        for j = 1, #patterns[i].nexts_without_energy do
            patterns[patterns[i].nexts_without_energy[j].next].reachable = true
        end
        for j = 1, #patterns[i].nexts_with_energy do
            patterns[patterns[i].nexts_with_energy[j].next].reachable = true
        end
    end
    for i = 2, #patterns do -- don't care if first pattern not reachable
        if not patterns[i].reachable then
            log("WARNING: pattern \"" .. patterns[i].name .. "\" not reachable")
        end
    end
end

function patterns_for_stage(stage)
    local patterns = parse_pattern_defs(pattern_defs_for_stage(stage))
    compute_compatibility(patterns)
    return patterns
end
