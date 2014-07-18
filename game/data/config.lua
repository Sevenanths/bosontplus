-- App config

--lt.os = "android"
--lt.form_factor = "phone"
lt.config.short_name = "bosonx"

lt.SetAppShortName(lt.config.short_name)
lt.RestoreState()

-- Display setup
aspect_ratio = 480/320
if lt.form_factor == "desktop" then
    aspect_ratio = 1280/720
end
viewport_height = 4
viewport_width = viewport_height * aspect_ratio
viewport_left = -viewport_width / 2
viewport_right = -viewport_left
viewport_bottom = -viewport_height / 2
viewport_top = -viewport_bottom

lt.config.world_left = viewport_left
lt.config.world_right = viewport_right
lt.config.world_bottom = viewport_bottom
lt.config.world_top = viewport_top

lt.config.design_width = 640 * aspect_ratio
lt.config.design_height = 640 
lt.config.orientation = "landscape"
if lt.form_factor == "desktop" then
    if lt.state.fullscreen == nil then
        lt.state.fullscreen = true
    end
else
    lt.state.fullscreen = false
end
lt.config.fullscreen = lt.state.fullscreen
if lt.form_factor == "desktop" then
    lt.config.letterbox = not lt.config.fullscreen
else
    lt.config.letterbox = false
end
lt.config.show_mouse_cursor = not lt.config.fullscreen

lt.config.start_script = "main"

config = {}

config.bg_w = 320 * aspect_ratio
config.bg_h = 320
if lt.form_factor == "desktop" then
    config.bg_w = 640 * aspect_ratio
    config.bg_h = 640
end

setfenv(1, config)

-- Gameplay settings
gravity = 0.012
jump_initial_speed = 0.12
jump_hang_speed = 0.01
sidestep_speed = 0.2
energy_boost_jump_power = 0.004
energy_boost_jump_power_decay = 0.000012

contact_error = 1
jump_grace_period = 0.2
allow_repeat_hang = false
fall_y_cutoff = 30

allow_jump_correction = true
jump_correction_timeout = 0.15

-- Scans
scan_min_y = -5
scan_max_y = 5
scan_warning_time = 5

-- Level generation settings
num_lanes = 10
branching_probability = 0.4
energy_boost_probability = 0.12
merge_path_y_threshold = 2
min_path_y_separation = 100
max_path_y_increase = 1.5
max_path_y_decrease = 2
platform_min_length = 3
platform_max_length = 8
rune_probability = 0.5
first_platform_length = 16

-- Player draw settings
player_y_offset = -2.0
player_alpha = 1
portal_y_offset = 5.0

-- Level draw settings
clip_depth = 1600
portal_depth = 799.9
platform_depth_scale = 10
platform_width_scale = 5
level_center_y = 8

-- Sprite settings
running_sprite_fps = 40
running_sprite_num_frames = 27
jumping_sprite_num_frames = 42

-- Perspective settings
vanish_y_offset = 0.4

-- Best scores
score_history_size = 30

-- Interface
ui_active_color = {204/255, 129/255, 129/255}
ui_light_grey = {246/255, 245/255, 233/255}
ui_bg = {49/255, 110/255, 162/255}
--ui_bg_complete = {49/255, 110/255, 162/255}
--ui_bg_complete = {153/255, 73/255, 74/255}
ui_bg_complete = {0/255, 0/255, 0/255}
ui_dark_blue = {45/255, 78/255, 106/255}
