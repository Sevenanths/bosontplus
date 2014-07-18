local level = ...
local params = {}

params.bg_color = {247, 210, 114}
-- params.bg_color_alt = {137, 230, 87}
params.bg_color_alt = {137, 200, 92}

params.master_ambient = {14, 50, 92}
params.master_diffuse = {230, 230, 230}

params.master_ambient_alt = {100, 100, 0}
params.master_diffuse_alt = {230, 230, 230}

params.num_plains = 8
params.start_angle = 20
params.particles_blend_mode = "subtract"
params.particles_blend_mode_alt = "add"
-- params.particles_color = {255, 255, 255, 0.5}
params.particles_color = {255, 255, 255, 0.4}
params.particles_color_alt = {255, 255, 255, 0.5}

import("bg_common", level, params)
