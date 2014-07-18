local r, g, b = 0.5, 1, 1

function make_energy_boost_node(platform)
    local x, y, z = platform.x, platform.y + 0.3, (platform.z1 - platform.z2)/2 + platform.z2
    local vertices = {
        {x-0.1, y+0.9, z, r+0.3, g+0.3, b+0.3, 1},
        {x+0.1, y+0.9, z, r+0.3, g+0.3, b+0.3, 1},
        {x,     y+0.7, z, r+0.3, g+0.3, b+0.3, 1},

        {x-0.2, y+1,   z, r+0.1, g+0.1, b+0.1, 1},
        {x+0.2, y+1,   z, r+0.1, g+0.1, b+0.1, 1},
        {x,     y+0.6, z, r+0.1, g+0.1, b+0.1, 1},

        {x-0.5, y+1.3, z, r, g, b, 0},
        {x+0.5, y+1.3, z, r, g, b, 0},
        {x,     y+0.8, z, r, g, b, 1},

        {x-0.5, y+1.3, z, r, g, b, 0},
        {x,     y+0.3, z, r, g, b, 0},
        {x,     y+0.8, z, r, g, b, 1},

        {x+0.5, y+1.3, z, r, g, b, 0},
        {x,     y+0.3, z, r, g, b, 0},
        {x,     y+0.8, z, r, g, b, 1},
    }
    return lt.DrawVector(lt.Vector(vertices), "triangles", 3, 4)
end

function make_energy_boost_particles(x, y)
    return lt.ParticleSystem(images.particle_square, 100, {
        source_position_x = x,
        source_position_y = y - man_height + 0.2,
        source_position_variance_x = 0.5,
        source_position_variance_y = 0,
        emission_rate = 0,
        duration = -1,
        gravity_y = -6,
        speed = 2.5,
        speed_variance = 0.8,
        angle = 90,
        angle_variance = 10,
        start_size = 0,
        start_size_variance = 0,
        end_size = 2.5,
        end_size_variance = 0,
        life = 0.55,
        life_variance = 0,
        radial_accel = -8,
        start_color_red = r,
        start_color_green = g,
        start_color_blue = b,
        start_color_alpha = 1,
        start_color_variance_red = 0,
        start_color_variance_green = 0,
        start_color_variance_blue = 0,
        end_color_red = r,
        end_color_green = g,
        end_color_blue = b,
        end_color_alpha = 1,
        end_color_variance_red = 0,
        end_color_variance_green = 0,
        end_color_variance_blue = 0,
    }):BlendMode("add")
end
