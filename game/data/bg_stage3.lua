local level = ...
local params = {}

params.bg_color = {217, 114, 108}
params.bg_color_alt = {110, 80, 115}

params.master_ambient = {30, 45, 59}
params.master_diffuse = {179, 179, 179}

params.normal_ambient = {0, 0, 0}
params.normal_diffuse = {255, 255, 255}

params.master_ambient_alt = {236, 226, 111}
params.master_diffuse_alt = {236, 226, 111}

params.normal_ambient_alt = {0, 0, 0}
params.normal_diffuse_alt = {255, 255, 255}

params.num_plains = 9
params.start_angle = 20
params.particles_blend_mode = "subtract"
params.particles_color = {255, 255, 255, 1}

params.particles_size = 5
params.particles_size_var = 5

import("bg_common", level, params)
