local level = ...
local params = {}
params.bg_color = {0, 0, 0}
params.bg_color_alt = {69, 209, 148}

params.master_ambient = {0, 0, 0}
params.master_diffuse = {230, 230, 230}

params.normal_diffuse = {204, 204, 204}

params.master_ambient_alt = {100, 100, 100}
params.master_diffuse_alt = {230, 230, 230}

params.normal_ambient_alt = {300, 300, 300}
params.normal_diffuse_alt = {230, 230, 230}

params.collapse_ambient_alt = {200, 200, 200}
params.collapse_diffuse_alt = {100, 100, 100}

params.num_plains = 5
params.start_angle = 20
params.particles_blend_mode = "add"
params.particles_color = {85, 66, 102}

params.particles_blend_mode_alt = "add"

params.particles_color_var = {26, 26, 26, 0}
params.particles_size = 14
params.particles_size_var = 7
params.num_particles = 400

import("bg_common", level, params)
