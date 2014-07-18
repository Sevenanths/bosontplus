local
function get_platform_under(level, lane, y)
    local platforms_in_lane = {}
    for _, path in ipairs(level.paths) do
        local platform = path[level.front_row]
        if platform and platform.lane == lane and not platform.is_gap then
            table.insert(platforms_in_lane, platform)
        end
    end
    table.sort(platforms_in_lane, function(p1, p2) return p1.y > p2.y end)
    for _, platform in ipairs(platforms_in_lane) do
        if platform.y <= y + config.contact_error then
            return platform
        end
    end
    return nil
end

local
function is_inside_platform(level, lane, y)
    local r = level.front_row
    for _, path in ipairs(level.paths) do
        local platform = path[r]
        if platform and platform.lane == lane and not platform.is_gap and
            --platform.end_row - 1 > r and
            platform.y > y + config.contact_error
            and platform.y - platform.height < y + man_height
        then
            return true
        end
    end
    return false
end

local
function get_lowest_platform(level)
    local lowest
    for _, path in ipairs(level.paths) do
        local platform = path[level.front_row]
        if platform and (not lowest or platform.y < lowest.y) then
            lowest = platform
        end
    end
    return lowest
end

local
function get_highest_platform(level, row)
    local highest
    for _, path in ipairs(level.paths) do
        local platform = path[row]
        if platform and (not highest or platform.y > highest.y) then
            highest = platform
        end
    end
    return highest
end

local
function get_resurrect_platform(level)
    local highest
    local r = level.front_row
    while not highest do
        for _, path in ipairs(level.paths) do
            local platform = path[r]
            if platform and not platform.is_gap and (not highest or platform.y > highest.y) then
                highest = platform
            end
        end
        r = r + 1
    end
    return highest
end

local
function get_nearest_platform(level, row, lane, y)
    local distance = 1000000
    local nearest = nil
    for _, path in ipairs(level.paths) do
        local platform = path[row]
        if platform and platform.lane == lane then
            local d = math.abs(platform.y - y)
            if d < distance then
                nearest = platform
                distance = d
            end
        end
    end
    return nearest, distance
end

local
function count_active_paths(level)
    local count = 0
    for _, path in ipairs(level.paths) do
        if path[level.back_row] then
            count = count + 1
        end
    end
    return count
end

local
function make_platform(lane, row, length, y, height)
    local z1 = -row * config.platform_depth_scale
    local z2 = z1 - length * config.platform_depth_scale
    return {
        lane = lane,
        length = length,
        start_row = row,
        end_row = row + length - 1,
        x = lane * config.platform_width_scale,
        y = y,
        z1 = z1,
        z2 = z2,
    }
end

local
function extend_existing_platforms(level)
    local back_row = level.back_row
    local prev_back_row = back_row - 1
    local did_extend = false
    for _, path in ipairs(level.paths) do
        local prev_platform = path[prev_back_row]
        if prev_platform and prev_platform.end_row > prev_back_row then
            path[back_row] = prev_platform
            did_extend = true
        end
    end
    return did_extend
end

local
function pick_pattern(candidates)
    local total_weight = 0
    for _, c in ipairs(candidates) do
        total_weight = total_weight + c.weight
    end
    local r = math.random()
    local weight = 0
    for _, c in ipairs(candidates) do
        weight = weight + c.weight / total_weight
        if weight >= r then
            return c
        end
    end
end

local
function create_pattern_row(level)
    local pattern = level.pattern
    local pos = level.pattern_pos
    local paths = level.paths
    local row = level.back_row
    local pattern_length = #pattern

    for lane = 1, level.num_lanes do
        local path = paths[lane]
        local curr_platform = path[row]
        if not curr_platform then
            local pat_lane = lane + level.pattern_offset
            if pat_lane > level.num_lanes then
                pat_lane = pat_lane - level.num_lanes
            end
            local cell = pattern[pos][pat_lane]
            if cell then
                local y = ((cell.y or 0) / 10) * config.level_center_y - 3
                local platform = make_platform(lane, row, cell.length, y or 0)
                platform.type = cell.type
                if cell.type == "energy" then
                    platform.has_energy_boost = true
                elseif cell.type == "collapsing" then
                    platform.will_fall = true
                elseif cell.type == "fast" then
                    platform.speedup = 2.6
                elseif cell.type == "barrier" then
                    platform.height = config.level_center_y
                    platform.y = config.level_center_y - 2
                    platform.width = config.platform_width_scale * 0.69
                end
                path[row] = platform
            end
        end
    end

    if pattern[pos].left_barrier then
        local lane = pattern[pos].left_barrier - level.pattern_offset
        if lane < 1 then
            lane = lane + level.num_lanes
        end
        add_left_barrier(level, row, lane)
    end
    if pattern[pos].right_barrier then
        local lane = pattern[pos].right_barrier - level.pattern_offset
        if lane < 1 then
            lane = lane + level.num_lanes
        end
        add_right_barrier(level, row, lane)
    end
    if pattern[pos].lightning and not level.portal_approaching then
        make_hscan(level)
    end

    if pattern[pos].message then
        level.message_queue[row] = pattern[pos].message
    end

    pos = pos + 1
    if pos > pattern_length then
        -- Pick next pattern
        if #level.pattern.nexts_without_energy == 0 then
            log("WARNING: no more compatible patterns without energy after " .. pattern.name)
            level.pattern = nil
        else
            local nxt
            if level.energy_due == 2 then
                level.energy_due = nil
            end
            if level.energy_due == 1 and #level.pattern.nexts_with_energy > 0 then
                nxt = level.pattern.nexts_with_energy[math.random(#level.pattern.nexts_with_energy)]
                level.energy_due = 2
            else
                nxt = pick_pattern(level.pattern.nexts_without_energy)
            end
            level.pattern = level.patterns[nxt.next]
            level.pattern_pos = 1
            level.pattern_offset = level.pattern_offset + nxt.offsets[math.random(#nxt.offsets)]
            if level.pattern_offset >= level.num_lanes then
                level.pattern_offset = level.pattern_offset - level.num_lanes
            end
        end
    else
        level.pattern_pos = pos
    end
end

local
function remove_front_row(level)
    local paths = level.paths
    local front_row = level.front_row
    local n = front_row - 1
    for _, path in ipairs(level.paths) do
        local platform = path[n]
        if platform then
            if platform.end_row == n then
                remove_platform(level, platform)
                path[n] = nil
            end
        end
    end
    level.front_row = front_row + 1
end

local
function display_back_row(level, sound)
    local max_sounds = 1
    local sound_count = 0
    for _, path in ipairs(level.paths) do
        local platform = path[level.back_row]
        if platform and platform.start_row == level.back_row and not platform.is_gap then
            add_platform(level, platform)
            if sound and sound_count < max_sounds then
                --play_platform_enter(level, platform)
                sound_count = sound_count + 1
            end
        end
    end
end

local
function add_new_back_row(level, sound)
    level.back_row = level.back_row + 1
    extend_existing_platforms(level)
    if level.pattern then
        create_pattern_row(level)
    end
    display_back_row(level, sound)
    level.depth = level.back_row - level.front_row + 1
end

local
function shift_level(level)
    add_new_back_row(level, true)
    remove_front_row(level)
end

local fps = lt.frames_per_sec

local
function project_player_z(level, t)
    local a = level.stage.acceleration
    t = t * fps
    local z = -(a * t * t * 0.5 + level.speed * t + level.z)
    return z
end

local
function compute_time(level, s)
    --[[
    local a = level.stage.acceleration
    local u = level.speed 
    local t = (math.sqrt(u * u + 2 * a * s) - u) / (a * fps)
    return t
    ]]
    return s / (level.speed * fps)
end

local
function init_level_2(level, num_lanes, stage_id)
    local stage = get_stage(stage_id)
    local depth = stage.level_depth
    local start_lane = math.ceil(num_lanes / 2)
    local num_path_slots = num_lanes
    --local path = {}
    --path[1] = make_platform(start_lane, 1, config.first_platform_length, 0)
    local paths = {}
    for i = 1, num_path_slots do
        paths[i] = {}
    end

    level.paths = paths
    level.max_paths = stage.max_paths
    level.num_path_slots = num_path_slots
    level.depth = 1
    level.num_lanes = num_lanes
    level.lane_rotate = 360 / num_lanes
    level.start_lane = start_lane
    level.gradient = stage.gradient
    level.add_layer = add_layer
    level.front_row = 1
    level.back_row = 1
    level.num_keys_collected = 0
    level.scan_layer = lt.Layer()
    level.cannon_layer = lt.Layer()
    level.solids_layer = lt.Layer()
    level.props_layer = lt.Layer()
    level.glowing_layer = lt.Layer()
    --level.barrier_layer = lt.Layer()
    level.energy_boost_layer = lt.Layer()
    level.flickering_layer = lt.Layer()
    level.fast_layer = lt.Layer()
    level.gateways_layer = lt.Layer()
    level.scan_count = 0
    level.barrier_count = 0
    level.speed = stage.initial_speed
    level.stage = stage
    level.stage_id = stage_id
    level.progress = 0
    level.portal_distance = 1

    level.patterns = patterns_for_stage(stage_id)
    level.pattern = level.patterns[1]
    level.pattern_pos = 1
    level.pattern_offset = 0

    level.shift = shift_level
    level.get_platform_under = get_platform_under
    level.is_inside_platform = is_inside_platform
    level.get_lowest_platform = get_lowest_platform
    level.get_highest_platform = get_highest_platform
    level.get_resurrect_platform = get_resurrect_platform
    level.num_paths = count_active_paths
    level.project_player_z = project_player_z
    level.compute_time = compute_time
    level.message_queue = {}
    level.generating = true
    display_back_row(level, false)

    for i = 1, depth do
        add_new_back_row(level, false)
    end
    level.generating = nil
    level.energy_due = 1
end

function init_level(level, num_lanes, stage_id)
    init_level_2(level, num_lanes, stage_id)
    return level
end

function dump_paths(level)
    for row = level.back_row, level.front_row, -1 do
        for lane = 1, level.num_lanes do
            for _, path in ipairs(level.paths) do
                -- TODO
            end
        end
    end
end
