local level = ...
local params = {}

-- params.bg_color = {200, 200, 200}
params.bg_color = {220, 220, 215}
params.bg_color_alt = {30, 30, 30}

-- params.master_ambient = {130, 130, 130}
-- params.master_diffuse = {220, 220, 220}
params.master_ambient = {100, 100, 95}
params.master_diffuse = {250, 250, 250}
--params.master_ambient = {113, 53, 19}
--params.master_diffuse = {102, 230, 102}

params.normal_ambient = {134, 134, 134}
params.normal_diffuse = {104, 104, 104}

-- params.collapse_ambient = {204, 204, 204}
-- params.collapse_diffuse = {64, 64, 64}

params.collapse_ambient = {204, 80, 80}
params.collapse_diffuse = {64, 0, 0}

params.master_ambient_alt = {126, 203, 229}
params.master_diffuse_alt = {126, 203, 229}
params.normal_ambient_alt = {104, 104, 104}
params.normal_diffuse_alt = {104, 104, 104}

params.num_plains = 5
params.start_angle = 20
params.particles_blend_mode = "add"
params.particles_blend_mode_alt = "add"

-- params.particles_color = {86, 65, 110, 1}
params.particles_color = {255, 255, 250, .3}
params.particles_color_alt = {255, 255, 255, 1}
--params.particles_color = {143, 53, 26, 1}
--params.particles_color_var = {77, 0, 25, 0}


params.particles_size = 6

import("bg_common", level, params)
