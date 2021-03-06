local level = ...
local params = {}
params.bg_color = {0, 255, 255}
params.bg_color_alt = {0, 0, 160}
params.master_ambient = {255, 128, 0}
params.master_diffuse = {128, 0, 255}
params.master_ambient_alt = {255, 0, 128}
params.master_diffuse_alt = {128, 0, 0}
params.normal_ambient = {64, 0, 64}
params.num_plains = "8"
params.start_angle = "20"
params.particles_blend_mode = "subtract"
params.particles_color = {255, 255, 255, 0.4}
import("bg_common", level, params)
