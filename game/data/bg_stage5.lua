local level = ...
local params = {}

params.bg_color = {4, 10, 50}
params.bg_color_alt = {0.7 * 255, 0.04 * 255, 0}

params.master_ambient = {8, 20, 93}
params.master_diffuse = {765, 765, 765}

params.normal_ambient = {204, 204, 204}

params.energy_ambient = {0, 153, 153}
params.energy_diffuse = {0, 0, 0}
params.collapse_ambient = {8, 20, 93}
params.collapse_diffuse = {0, 0, 0}

params.master_ambient_alt = {155, 80, 0}
params.master_diffuse_alt = {455, 200, 0}

params.collapse_ambient_alt = {0, 0, 0}
params.collapse_diffuse_alt = {0, 0, 0}

params.num_plains = 7
params.start_angle = 20
params.particles_blend_mode = "add"
params.particles_color = {55, 55, 55, 1}
params.num_particles = 100

import("bg_common", level, params)
