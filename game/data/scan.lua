local hscan_line = generate_hlightning(33)

local speed = 2

function make_hscan(level)
    if level.generating then
        return
    end
    local y_error1 = -0.5
    local y_error2 = man_height + 0.5
    local x_error = config.platform_width_scale * 0.4
    local player = level.player
    local y = config.level_center_y
    local x = 0
    local z1 = -level.z - 800
    local inner_cannon = models.cannon_inner:Rotate(0)
    local outer_cannon = models.cannon_outer:Rotate(0)
    local rotation_speed = math.random() * 2 - 1
    local angle = (math.random(8) - 1) * 45
    outer_cannon = outer_cannon:Scale(0):Translate(x, y, z1)
    inner_cannon = inner_cannon:Scale(0):Translate(x, y, z1)
    outer_cannon:Tween{scale = 33, time = 1, easing = "zoomout"}
    inner_cannon:Tween{scale = 33, time = 1, easing = "zoomout"}
    local track = electric_track()
    local scan_node = hscan_line:Rotate(0):Translate(x, y, z1)
    level.scan_layer:InsertBack(scan_node)
    level.scan_layer:Insert(track)
    local checked = false
    scan_node:Action(function(dt)
        local prev_z = level.z - level.speed
        local scan_z = scan_node.z + speed
        scan_node.z = scan_z
        inner_cannon.z = scan_z
        outer_cannon.z = scan_z
        angle = angle + rotation_speed
        if angle > 360 then
            angle = angle - 360
        elseif angle < -360 then
            angle = angle + 360
        end
        outer_cannon.angle = angle
        inner_cannon.angle = angle
        scan_node.angle = angle
        if -scan_z < (level.z + 2) and not checked and not player.dead then
            local dx = player.x - x
            local dy = player.y - y
            local h = math.sqrt(dx * dx + dy * dy)
            local theta = angle - player.angle
            local abs_theta = math.abs(theta)
            local ray_x, ray_y
            if abs_theta ~= 90 and abs_theta ~= 270 then
                local t = tan(theta)
                ray_y = t * dx + y
                ray_x = dy / t + x
            else
                ray_y = player.y + man_height/2
                ray_x = x
            end
            if player.y + y_error1 < ray_y and ray_y < player.y + y_error2
               or player.x > ray_x - x_error and player.x < ray_x + x_error
            then
                if player.artifact and player.artifact.is_shield_up then
                    player.artifact.shield_effect()
                    player.energy = player.energy - 0.3
                    if player.energy < 0 then
                        player.energy = 0
                    end
                else
                    player.die("scan")
                end
            end
            checked = true
        end
        if -scan_z < level.z - 2 then
            level.scan_layer:Remove(scan_node)
            track:Tween{gain = 0, time = 2, action = function()
                track:Stop()
                level.scan_layer:Remove(track)
            end}
            level.solids_layer:Remove(outer_cannon)
            level.glowing_layer:Remove(inner_cannon)
        end
    end)
    level.solids_layer:InsertBack(outer_cannon)
    level.glowing_layer:InsertBack(inner_cannon)
end
