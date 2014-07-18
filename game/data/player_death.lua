--[[
function scan_death_ani(player_node)
    local w = 128
    local h = 128

    local render_target = lt.RenderTarget(nil,
        w, h,
        -1, -1.8, 1, 0.4,
        -1, -1.8, 1, 0.4,
        "nearest", "nearest")

    player_node:Draw(render_target, 0, 0, 0, 0)

    local node = render_target:TextureMode("add"):BlendMode("add"):Tint(0.8, 0, 0, 0.7)

    node:Action(coroutine.wrap(function()
        while w > 4 do
            w = w * 0.9
            h = h * 0.9
            render_target.pwidth = w
            render_target.pheight = h
            player_node:Draw(render_target, 0, 0, 0, 0)
            coroutine.yield(2/60)
        end
        return true
    end))

    return node
end
]]

function scan_death_ani()
    local particles = lt.ParticleSystem(images.particle_square, 300, {
        source_position_x = 0,
        source_position_y = -0.3,
        source_position_variance_x = 0,
        source_position_variance_y = 0.2,
        gravity_y = -2,
        duration = 0.3,
        emission_rate = 20000,
        life = 2,
        life_variance = 1,
        speed = 3,
        speed_variance = 2.5,
        damping = 3,
        damping_variance = 3,
        angle = 0,
        angle_variance = 180,
        start_size = 1.5,
        start_size_variance = 0.3,
        end_size = 1.5,
        end_size_variance = 0.3,
        start_color_red = 1,
        start_color_green = 0.8,
        start_color_blue = 0.8,
        start_color_alpha = 1,
        start_color_variance_red = 0,
        start_color_variance_green = 0,
        start_color_variance_blue = 0,
        start_color_variance_alpha = 0.5,
        end_color_red = 1,
        end_color_green = 0.5,
        end_color_blue = 0.5,
        end_color_alpha = 0,
        end_color_variance_red = 0,
        end_color_variance_green = 0,
        end_color_variance_blue = 0,
        end_color_variance_alpha = 0.5,
    }):BlendMode("add")
    for i = 1, 5 do
        particles:Advance(0.04)
    end
    return particles;
end

function gen_explosion(game_state)

    local num_particles = math.floor(800 * game_state.score)
    if num_particles < 100 then
        num_particles = 100
    elseif num_particles > 1000 then
        num_particles = 1000
    end
    local confetti = lt.ParticleSystem(images.particle_square, num_particles, {
        source_position_x = 0,
        source_position_y = -0.3,
        source_position_variance_x = 0,
        source_position_variance_y = 0.2,
        gravity_y = 0,
        duration = 0.3,
        emission_rate = 20000,
        life = 1,
        life_variance = 0.5,
        speed = 7,
        speed_variance = 2.5,
        damping = 3,
        damping_variance = 3,
        angle = 0,
        angle_variance = 180,
        start_size = 1.7,
        start_size_variance = 0.3,
        end_size = 0.6,
        end_size_variance = 0.7,
        start_color_red = 0.2,
        start_color_green = 1,
        start_color_blue = 1,
        start_color_alpha = 0.8,
        start_color_variance_red = 0,
        start_color_variance_green = 0,
        start_color_variance_blue = 0,
        start_color_variance_alpha = 0,
        end_color_red = 0.2,
        end_color_green = 1,
        end_color_blue = 1,
        end_color_alpha = 0.7,
        end_color_variance_red = 0,
        end_color_variance_green = 0,
        end_color_variance_blue = 0,
        end_color_variance_alpha = 0.2,
    }):BlendMode("add")

    for i = 1, 5 do
        confetti:Advance(1/60)
    end
    return confetti
end

function gen_particle_trace(game_state)
    local stage = game_state.stage_id
    local score = game_state.score
    local color = {255, 255, 255}
    local color_var = {1, 1, 1}
    if stage == 1 and score < 1 then
        color = {28, 119, 186}
        color_var = {0.1, 0.1, 0.1}
    elseif stage == 1 and score >= 1 then
        color = {232, 143, 38}
        color_var = {0.1, 0.1, 0.1}
    elseif stage == 2 and score < 1 then
        color = {247, 210, 40}
        color_var = {0.1, 0.1, 0.1}
    elseif stage == 2 and score >= 1 then
        color = {10, 203, 21}
        color_var = {0.1, 0.1, 0.1}
    elseif stage == 3 and score < 1 then
        color = {217, 40, 40}
        color_var = {0.1, 0.1, 0.1}
    elseif stage == 3 and score >= 1 then
        color = {80, 30, 225}
        color_var = {0.1, 0.1, 0.1}
    elseif stage == 4 and score < 1 then
        color = {200, 50, 140}
        color_var = {0.1, 0.1, 0.1}
    elseif stage == 4 and score >= 1 then
        color = {26, 203, 229}
        color_var = {0.2, 0.2, 0.2}
    elseif stage == 5 and score < 1 then
        color = {4, 10, 250}
        color_var = {0.2, 0.2, 0.2}
    elseif stage == 5 and score >= 1 then
        color = {255, 30, 0}
        color_var = {0.2, 0.2, 0.2}
    elseif stage == 6 and score < 1 then
        color = {185, 66, 202}
        color_var = {0.3, 0.1, 0.3}
    elseif stage == 6 and score >= 1 then
        color = {128, 128, 128}
        color_var = {0.5, 0.5, 0.5}
    end
    color[1] = color[1]/555
    color[2] = color[2]/555
    color[3] = color[3]/555

    local num_particles = score >= 1 and 6 or math.max(10, score * 50)
    local particles = lt.ParticleSystem(images.particle_square, num_particles, {
        source_position_x = 0,
        source_position_y = 0,
        source_position_variance_x = 0,
        source_position_variance_y = 0,
        gravity_y = 0,
        duration = 0.1,
        emission_rate = 20000,
        life = 0.3,
        life_variance = 0,
        speed = 8,
        speed_variance = 0,
        damping = 0,
        damping_variance = 0,
        angle = 0,
        angle_variance = 180,
        start_size = 0.8,--math.random() * 0.6 + 0.2,
        start_size_variance = 0.0,--math.random() * 0.3,
        end_size = 0.8,--math.random() * 0.4 + 0.2,
        end_size_variance = 0.0,--math.random() * 0.15,
        tangential_accel = 0,
        tangential_accel_variance = 0, --math.random() * 100,
        start_color_red = color[1],
        start_color_green = color[2],
        start_color_blue = color[3],
        start_color_alpha = 1,
        start_color_variance_red = color_var[1],
        start_color_variance_green = color_var[2],
        start_color_variance_blue = color_var[3],
        start_color_variance_alpha = 0,
        end_color_red = color[1],
        end_color_green = color[2],
        end_color_blue = color[3],
        end_color_alpha = 1,
        end_color_variance_red = color_var[1],
        end_color_variance_green = color_var[2],
        end_color_variance_blue = color_var[3],
        end_color_variance_alpha = 0,
    }):BlendMode("add")

    if score >= 1 then
        local layer = lt.Layer()
        for i = 1, 10 do
            local a1 = math.random() * 360
            local a2 = math.random(2) == 1 and (a1 + math.random() * 400 - 200) or a1
            local p = particles:Rotate(a1):Tween{angle = a2 * 2, time = 1}
            layer:Insert(p)
        end
        particles = layer
    end

    local target = lt.RenderTarget(nil,
        512, 512,
        -3, -3, 3, 3,
        -3, -3, 3, 3,
        "linear", "linear")

    local hidden = particles:Hidden()
    hidden.action_speed = 0.2
    local all = lt.Layer(target, hidden)

    particles:Draw(target, 0, 0, 0, 0)
    local time = 0
    target:Action(function(dt)
        if time < 10 then
            particles:Draw(target)
            time = time + 2 * dt
        else
            all:Remove(hidden)
            return true
        end
    end)
    return all:BlendMode("add")
end
