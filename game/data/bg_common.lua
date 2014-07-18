local level, params = ...

local default_color = {128, 128, 128}
local bg_color = params.bg_color
local bg_color_alt = params.bg_color_alt

local master_ambient = params.master_ambient
local master_diffuse = params.master_diffuse
local normal_ambient = params.normal_ambient or default_color
local normal_diffuse = params.normal_diffuse or default_color
local energy_ambient = params.energy_ambient or master_ambient
local energy_diffuse = params.energy_diffuse or
    {master_diffuse[1] * 0.6, master_diffuse[2] * 0.6, master_diffuse[3] * 0.6}
local collapse_ambient = params.collapse_ambient or default_color
local collapse_diffuse = params.collapse_diffuse or default_color

local master_ambient_alt = params.master_ambient_alt or master_ambient
local master_diffuse_alt = params.master_diffuse_alt or master_diffuse
local normal_ambient_alt = params.normal_ambient_alt or normal_ambient
local normal_diffuse_alt = params.normal_diffuse_alt or normal_diffuse
local energy_ambient_alt = params.energy_ambient_alt or energy_ambient
local energy_diffuse_alt = params.energy_diffuse_alt or energy_diffuse
local collapse_ambient_alt = params.collapse_ambient_alt or collapse_ambient
local collapse_diffuse_alt = params.collapse_diffuse_alt or collapse_diffuse

local num_plains = params.num_plains
local start_angle = params.start_angle
local particles_blend_mode = params.particles_blend_mode
local particles_blend_mode_alt = params.particles_blend_mode_alt or particles_blend_mode
local particles_color = params.particles_color
local particles_color_var = params.particles_color_var or {0, 0, 0, 0}
local particles_size = params.particles_size or 5
local particles_size_var = params.particles_size_var or 1
local particles_width = params.particles_width or 15
local num_particles = params.num_particles or 500

local
function make_bg_particles()
    local img = images.particle_vline
    local particles = lt.ParticleSystem(img, num_particles, {
            source_position_x = 0,
            source_position_y = 0,
            source_position_variance_x = particles_width,
            source_position_variance_y = 0,
            duration = -1,
            --emission_rate = 200,
            life = 2,
            life_variance = 0,
            speed = 80,
            speed_variance = 20,
            angle = 90,
            angle_variance = 0,
            start_size = particles_size,
            start_size_variance = particles_size_var,
            end_size = particles_size,
            end_size_variance = particles_size_var,
            start_spin = 0,
            start_spin_variance = 0,
            end_spin = 0,
            end_spin_variance = 0,

            start_color_red = particles_color[1]/255,
            start_color_green = particles_color[2]/255,
            start_color_blue = particles_color[3]/255,
            start_color_alpha = particles_color[4],
            start_color_variance_red = particles_color_var[1]/255,
            start_color_variance_green = particles_color_var[2]/255,
            start_color_variance_blue = particles_color_var[3]/255,
            start_color_variance_alpha = particles_color_var[4],
            end_color_red = particles_color[1]/255,
            end_color_green = particles_color[2]/255,
            end_color_blue = particles_color[3]/255,
            end_color_alpha = particles_color[4],
            end_color_variance_red = particles_color_var[1]/255,
            end_color_variance_green = particles_color_var[2]/255,
            end_color_variance_blue = particles_color_var[3]/255,
            end_color_variance_alpha = particles_color_var[4],
        })
    return particles
end

local
function make_background(level)
    local particles = make_bg_particles()

    local bg_node = lt.Layer()

    local plain = lt.Layer(particles):Pitch(90)
        :Scale(1, 1, 3.5)
        :Translate(0, 7, -400)

    do
        local a = start_angle
        local n = num_plains
        local inc = 360 / n
        bg_node = lt.Layer()
        for i = 0, n - 1 do
            bg_node:Insert(plain:Translate(0, 1):Rotate(i * inc + a))
        end
    end

    bg_node = bg_node
        :BlendMode(particles_blend_mode):Fog(50, 400, 0, 0, 0)
        :Perspective(1, 10, 810, 0, 0.4)

    level.background_layer = lt.Layer(bg_node)

    level.light.ambient_red = master_ambient[1] / 255
    level.light.ambient_green = master_ambient[2] / 255
    level.light.ambient_blue = master_ambient[3] / 255
    level.light.diffuse_red = master_diffuse[1] / 255
    level.light.diffuse_green = master_diffuse[2] / 255
    level.light.diffuse_blue = master_diffuse[3] / 255

    level.normal_platform_material.ambient_red = normal_ambient[1] / 255
    level.normal_platform_material.ambient_green = normal_ambient[2] / 255
    level.normal_platform_material.ambient_blue = normal_ambient[3] / 255
    level.normal_platform_material.diffuse_red = normal_diffuse[1] / 255
    level.normal_platform_material.diffuse_green = normal_diffuse[2] / 255
    level.normal_platform_material.diffuse_blue = normal_diffuse[3] / 255

    level.fast_material.ambient_red = normal_ambient[1] / 255
    level.fast_material.ambient_green = normal_ambient[2] / 255
    level.fast_material.ambient_blue = normal_ambient[3] / 255
    level.fast_material.diffuse_red = normal_diffuse[1] / 255
    level.fast_material.diffuse_green = normal_diffuse[2] / 255
    level.fast_material.diffuse_blue = normal_diffuse[3] / 255

    level.energy_boost_material.ambient_red = energy_ambient[1] / 255
    level.energy_boost_material.ambient_green = energy_ambient[2] / 255
    level.energy_boost_material.ambient_blue = energy_ambient[3] / 255
    level.energy_boost_material.diffuse_red = energy_diffuse[1] / 255
    level.energy_boost_material.diffuse_green = energy_diffuse[2] / 255
    level.energy_boost_material.diffuse_blue = energy_diffuse[3] / 255

    level.flickering_material.ambient_red = collapse_ambient[1] / 255
    level.flickering_material.ambient_green = collapse_ambient[2] / 255
    level.flickering_material.ambient_blue = collapse_ambient[3] / 255
    level.flickering_material.diffuse_red = collapse_diffuse[1] / 255
    level.flickering_material.diffuse_green = collapse_diffuse[2] / 255
    level.flickering_material.diffuse_blue = collapse_diffuse[3] / 255

    local min_speed = level.stage.initial_speed
    local max_speed = level.stage.max_speed
    local passed_max = false

    local overlay = fs_overlay:Tint(bg_color[1]/255, bg_color[2]/255, bg_color[3]/255)

    level.background_layer:Action(function(dt)
        particles.action_speed = 0.2 * level.speed

        if not passed_max and level.speed > max_speed then
            level.light:Tween{
                ambient_red = 1,
                ambient_green = 1,
                ambient_blue = 1,
                diffuse_red = 1,
                diffuse_green = 1,
                diffuse_blue = 1,
                time = 0.4
            }
            local
            function tween_bg()
                overlay:Tween{blue = 1, green = 1, red = 1, time = 0.5, action = function()
                    overlay:Tween{
                        red = bg_color_alt[1]/255,
                        green = bg_color_alt[2]/255,
                        blue = bg_color_alt[3]/255,
                        time = 0.8}
                    bg_node.mode = particles_blend_mode_alt
                    if level.stage_id == num_stages then
                        local
                        function cycle()
                            local r, g, b
                            repeat
                                r, g, b = math.random(), math.random(), math.random()
                                local total = r + g + b
                                local max = math.max(r, g, b)
                            until max > 0.8 and total < 2.0
                            overlay:Tween{red = r, green = g, blue = b, time = 0.4, action = cycle}
                        end
                        cycle()
                    end

                    level.light:Tween{
                        ambient_red = master_ambient_alt[1] / 255,
                        ambient_green = master_ambient_alt[2] / 255,
                        ambient_blue = master_ambient_alt[3] / 255,
                        diffuse_red = master_diffuse_alt[1] / 255,
                        diffuse_green = master_diffuse_alt[2] / 255,
                        diffuse_blue = master_diffuse_alt[3] / 255,
                        time = 0.3,
                    }

                    level.normal_platform_material:Tween{
                        ambient_red = normal_ambient_alt[1] / 255,
                        ambient_green = normal_ambient_alt[2] / 255,
                        ambient_blue = normal_ambient_alt[3] / 255,
                        diffuse_red = normal_diffuse_alt[1] / 255,
                        diffuse_green = normal_diffuse_alt[2] / 255,
                        diffuse_blue = normal_diffuse_alt[3] / 255,
                        time = 0.3,
                    }

                    level.fast_material:Tween{
                        ambient_red = normal_ambient_alt[1] / 255,
                        ambient_green = normal_ambient_alt[2] / 255,
                        ambient_blue = normal_ambient_alt[3] / 255,
                        diffuse_red = normal_diffuse_alt[1] / 255,
                        diffuse_green = normal_diffuse_alt[2] / 255,
                        diffuse_blue = normal_diffuse_alt[3] / 255,
                        time = 0.3,
                    }

                    level.energy_boost_material:Tween{
                        ambient_red = energy_ambient_alt[1] / 255,
                        ambient_green = energy_ambient_alt[2] / 255,
                        ambient_blue = energy_ambient_alt[3] / 255,
                        diffuse_red = energy_diffuse_alt[1] / 255,
                        diffuse_green = energy_diffuse_alt[2] / 255,
                        diffuse_blue = energy_diffuse_alt[3] / 255,
                        time = 0.3,
                    }

                    level.flickering_material:Tween{
                        ambient_red = collapse_ambient_alt[1] / 255,
                        ambient_green = collapse_ambient_alt[2] / 255,
                        ambient_blue = collapse_ambient_alt[3] / 255,
                        diffuse_red = collapse_diffuse_alt[1] / 255,
                        diffuse_green = collapse_diffuse_alt[2] / 255,
                        diffuse_blue = collapse_diffuse_alt[3] / 255,
                        time = 0.3,
                    }
                end}
            end
            tween_bg()
            passed_max = true
        end
    end)

    level.background_layer:InsertBack(overlay:BlendMode("off"))

    -- warm up particles
    for i = 1, 180 do
        particles:Advance(1/60)
    end
end

make_background(...)
