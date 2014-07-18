function make_portal_node()
    local portal = lt.Layer()
    local light1 = images.light1:Rotate(0)
    local light2 = images.light2:Rotate(0)
    portal:Insert(light1)
    portal:Insert(light2)
    local
    function tween1()
        light1.angle = 0
        light1:Tween{angle = 360, time = 27, action = tween1}
    end
    local
    function tween2()
        light2.angle = 0
        light2:Tween{angle = -360, time = 40, action = tween2}
    end
    tween1()
    tween2()
    portal = portal
    return portal
end

function add_portal(level, lane, effect)
    if lane < 1 then
        lane = 1
    elseif lane > level.num_lanes then
        lane = level.num_lanes
    end
    local highest
    local r = level.back_row
    while not highest do
        highest = level:get_highest_platform(r)
        r = r - 1
    end
    local y = highest.y + 3
    local node = make_portal_node():Translate(lane * config.platform_width_scale,
            y, -level.back_row * config.platform_depth_scale):BlendMode("add")
    level.collectables[lane][level.back_row] = {
        node = node,
        effect = effect,
        y = y,
    }
    level.collectables_layer:InsertBack(node)
end
