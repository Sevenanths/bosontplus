local
function add_gate_detector(level, x, y, z, w)
    level.energy_boost_layer:Insert(
        models.artifact:Rotate(0)
        :Action(function(dt, node)
            node.angle = 0
            node:Tween{angle = 360, time = 5}
            return 5
        end)
        :Pitch(0)
        :Action(function(dt, node)
            node.pitch = 0
            node:Tween{pitch = 360, time = 7}
            return 7
        end)
        :Translate(x, y + 1.6, z)
        :Action(function(dt, node)
            local player = level.player
            if level.z > -z then
                level.energy_boost_layer:Remove(node)
                if math.abs(player.x - x) < w/2 and player.y >= y and player.y < y + 2 then
                    collect_random_artifact(level)
                end
                return true
            end
        end))
end

function add_platform(level, platform)
    local x, y, z = platform.x, platform.y, (platform.z1 - platform.z2) / 2 + platform.z2
    local height = platform.height
    if not height then
        height = math.random(1, 1)
        platform.height = height
    end
    local width = platform.width
    if not width then
        width = 2 * (config.level_center_y - y) * sin(level.lane_rotate / 2)
        platform.width = width
    end
    local length = platform.z1 - platform.z2 + 0.05

    local n, f = platform.z1 - z, platform.z2 - z
    local plat
    if platform.type == "barrier" then
        plat = models.barrier
    else
        plat = models.platform2
    end

    if not level.generating and platform.speedup then
        length = length * platform.speedup
    end

    local e = 0.01
    local node = plat:Clone():Stretch(0, 0, 0, width/2-1, width/2-1, height-1, -1, length/2-1 + e, length/2-1 + e)

    --[[
    for i = 1, 7 do
        local piece = plat:Clone()
        local d = math.random() * 0.7 + 0.1
        local t = math.random() * height
        local h = math.max(0.4, math.random() * (height - t))
        local f = math.random() * length
        local l = math.max(1, math.random() * (length - f))
        piece:Stretch(0, 0, 0, d + width/2 - 1, 0, t + h - 1, -t - 1, l + f - 1 - length/2, -l - 1 + length/2)
        node:Merge(piece)
    end
    for i = 1, 7 do
        local piece = plat:Clone()
        local d = math.random() * 0.7 + 0.1
        local t = math.random() * height
        local h = math.max(0.4, math.random() * (height - t))
        local f = math.random() * length
        local l = math.max(1, math.random() * (length - f))
        piece:Stretch(0, 0, 0, 0, d + width/2 - 1, t + h - 1, -t - 1, l + f - 1 - length/2, -l - 1 + length/2)
        node:Merge(piece)
    end
    for i = 1, 4 do
        local piece = plat:Clone()
        local d = math.random() * 2 + 0.5
        local t = math.random() * height
        local h = math.max(0.4, math.random() * (height - t))
        local l = math.min(math.random() * width, width - 0.4)
        local w = math.max(0.4, math.random() * (width - l))
        piece:Stretch(0, 0, 0, -l + width/2 - 1, l - width/2 - 1 + w, t + h - 1, -t - 1, 0, length/2 - 1 + d)
        node:Merge(piece)
    end
    ]]
    if platform.has_gate then
        local gate = models.gate:Clone():Stretch(0, 0, 0, width/2 - 1, width/2 - 1, -1, 1, 0, 0)
        node:Merge(gate)
        add_gate_detector(level, x, y, z, width)
    end

    local angle = (platform.lane - 1) * level.lane_rotate
    if not level.generating then
        if level.stage_id == 1 then
            node = node:Translate(0, 0, -n):Scale(1, 1, 20):Translate(0, 0, n):Translate(0, y, z - 800)
                :Rotate(angle, 0, config.level_center_y)
            node:Tween{z = z, time = 0.3, easing = "zoomout"}
            node:Tween{scale_z = 1, time = 0.3, easing = "zoomout", delay = 0.1, action = function()
                node.child.child = node.child.child.child.child.child
            end}
        elseif level.stage_id == 5 then
            node = node:Scale(1, 20, 1):Translate(0, y - 100, z)
                :Rotate(angle, 0, config.level_center_y)
            node:Tween{y = y, time = 0.3, easing = "zoomout"}
            node:Tween{scale_y = 1, time = 0.3, easing = "zoomout", delay = 0.1, action = function()
                node.child.child = node.child.child.child
            end}
        elseif level.stage_id == 2 then
            node = node:Translate(0, y - 60, z)
                :Rotate(angle, 0, config.level_center_y)
            local level_z = level.z or 0
            local d = (- level_z - platform.z1) * 0.65
            local t = level:compute_time(d)
            node:Tween{y = y, time = t, easing = "decel"}
        elseif level.stage_id == 3 then
            node = node:Translate(0, 0, -n):Scale(1, 1, 20):Translate(0, 0, n):Translate(0, y, z - 800)
                :Rotate(angle, 0, config.level_center_y)
            node:Tween{z = z, time = 0.3, easing = "zoomout"}
            node:Tween{scale_z = 1, time = 0.3, easing = "zoomout", delay = 0.1, action = function()
                node.child.child = node.child.child.child.child.child
            end}
            local level_z = level.z or 0
            local d = (- level_z - platform.z1) * 0.8
            local t = level:compute_time(d)
            node.angle = angle - 360
            node:Tween{angle = angle, time = t, easing = "decel"}
        elseif level.stage_id == 4 then
            if platform.type == "barrier" then
                node = node:Translate(0, 0, -n):Scale(1, 1, 20):Translate(0, 0, n):Translate(0, y, z - 800)
                    :Rotate(angle, 0, config.level_center_y)
                node:Tween{z = z, time = 0.3, easing = "zoomout"}
                node:Tween{scale_z = 1, time = 0.3, easing = "zoomout", delay = 0.1, action = function()
                    node.child.child = node.child.child.child.child.child
                end}
                local level_z = level.z or 0
                local d = (- level_z - platform.z1) * 0.5
                local t = level:compute_time(d)
                node.angle = angle - (platform.start_row % 2 == 0 and 160 or -160)
                node:Tween{angle = angle, time = t, easing = "linear"}
            else
                node = node:Translate(0, y - 60, z)
                    :Rotate(angle, 0, config.level_center_y)
                local level_z = level.z or 0
                local d = (- level_z - platform.z1) * 0.3
                local t = level:compute_time(d)
                node:Tween{y = y, time = t}
            end
        elseif level.stage_id == 6 then
            node = node:Rotate(360):Pitch(180):Translate(0, y - 100, z)
            local level_z = level.z or 0
            local d = (- level_z - platform.z1) * 0.65
            local t = level:compute_time(d)
            node:Tween{y = y, pitch = 0, angle = 0, time = t * 0.4, easing = "out", action = function()
                node.child.child = node.child.child.child.child
            end}
            node = node
                :Rotate(angle, 0, config.level_center_y)
        else
            error("unhandled stage id :  " .. level.stage_id)
        end
        if platform.speedup then
            local level_z = level.z or 0
            local d = (- level_z - z)
            local d2 = d * platform.speedup
            local t = level:compute_time(d)
            local d3 = d2 - d
            local v = d3 / t
            local orig_z = z
            node.z = orig_z - d3
            node:Action(function(dt, n)
                level_z = level.z or 0
                d = (- level_z - orig_z)
                if d > 0.1 then
                    t = level:compute_time(d)
                    v = d3 / t
                end
                d3 = d3 - v * dt
                n.z = orig_z - d3
            end)
        end
    else
        node = node:Translate(0, y, z)
            :Rotate(angle, 0, config.level_center_y)
    end

    -- Record the scene node in the platform so we can remove it later.
    platform.node = node

    if platform.has_energy_boost then
        level.energy_boost_layer:Insert(node)
        platform.parent = level.energy_boost_layer
    elseif platform.will_fall then
        level.flickering_layer:Insert(node)
        platform.parent = level.flickering_layer
    elseif platform.speedup then
        level.fast_layer:Insert(node)
        platform.parent = level.fast_layer
    else
        level.solids_layer:Insert(node)
        platform.parent = level.solids_layer
    end

    if platform.will_fall then
        node:Action(function(dt)
            if platform.z1 > -level.z and platform.lane == level.player.lane
                and level.player.y - platform.y < 0.1 and level.player.vy <= 0
            then
                local
                function rumble()
                    node:Tween{x = math.random() * 0.4,
                        time = math.random() * 0.05 + 0.02,
                        action = rumble
                    }
                end
                rumble()
                local gain
                if platform.lane == level.player.lane then
                    play_rumble(1)
                end
                platform.falling = true
                node:Action(function(dt)
                    platform.y = platform.y - dt * 5.0
                    node.y = platform.y
                end)
                return true -- end current action
            end
        end)
    end
end

function remove_platform(level, platform)
    if platform.node then
        platform.parent:Remove(platform.node)
        platform.node = nil
        platform.parent = nil
    end
end

