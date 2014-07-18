function play(game_state, music)

clearall()

local curr_action = nil

local first_stage = false
if not game_state or type(game_state) == "number" then
    game_state = {
        score = 0,
        stage_id = type(game_state) == "number" and game_state or 1,
    }
    first_stage = true
end

lt.state.stages_played[game_state.stage_id] = lt.state.stages_played[game_state.stage_id] + 1

if not music then
    music = import("music", game_state.stage_id)
elseif music.phase == 2 then
    music:reset()
end
game_state.music = music
music:Tween{gain = lt.state.music_volume, pitch = 1, time = 0.5}
samples.intro:Play(1, lt.state.sfx_volume)

local prev_best = lt.state.best_score[game_state.stage_id] or 0

load_player_frames()

---------------------------------------
local play_layer = lt.Layer()
play_layer:Insert(music)

-- We disallow touches for a short initial period in case the user
-- tapped the retry button several times.
local allow_touch = false

local overlay = lt.Rect(lt.left - 100, lt.bottom - 100, lt.right + 100, lt.top + 100):Tint(1, 1, 1, 1):BlendMode("add")
overlay:Tween{
    alpha = 0,
    time = 1.0,
    action = function()
        play_layer:Remove(overlay)
        allow_touch = true
    end
}
--[[
if first_stage then
    main_scene.child = lt.Layer()
    main_scene.child:Insert(
        images.light3:Scale(0)
            :Tween{
                scale = 4,
                time = 0.7,
                easing = "zoomin",
                action = function()
                    main_scene.child = play_layer
                end
            }:Translate(0, 0.3)
    )
    --play_start_sound()
else
    main_scene.child = play_layer
end
]]
main_scene.child = play_layer

---------------------------------------

local key_down = {}

local level = {}
init_level(level, config.num_lanes, game_state.stage_id)
level.base_color = {0.5, 0.5, 0.5, 0.5} --  XXX remove

local initial_speed = level.stage.initial_speed

local z_accum = 0
level.z = config.platform_depth_scale

local platform_base = viewport_bottom

local jump_down = false -- whether a jump button is being held down.
local touching_ground = true -- is the player touching a platform?
local jump_dir -- intended jump direction
-- jump_counter is set to a positive value when the user taps to jump
-- and decays over time.  It is used to allow a jump if the user
-- taps just before hitting the ground.
local jump_counter = 0
local jump_touch -- id of touch used to initialize jump
local is_double_jumping = false -- true while the jump key is being held down from being pressed when in mid-air.
local double_jump_end = false -- set to true when the jump key is released while double-jumping
local energy_boost_jump_power = 0
local time_since_jump = 0

local lighted_layer = lt.Layer()
local energy_boost_material =
    level.energy_boost_layer:Material{
        ambient_red = level.base_color[1] * 1.6,
        ambient_green = level.base_color[2] * 1.6,
        ambient_blue = level.base_color[3] * 1.6,
        diffuse_red = level.base_color[1],
        diffuse_green = level.base_color[2],
        diffuse_blue = level.base_color[3],
    }:Action(coroutine.wrap(function(dt, material)
        while true do
            material:Tween{
                emission_green = 0.7,
                emission_blue = 0.7,
                time = 0.6
            }
            coroutine.yield(0.6)
            material:Tween{
                emission_green = 0.1,
                emission_blue = 0.1,
                time = 1
            }
            coroutine.yield(1)
        end
    end))
lighted_layer:Insert(energy_boost_material)
level.energy_boost_material = energy_boost_material

lighted_layer:Insert(
    level.glowing_layer:Material{
        ambient_red = level.base_color[1] * 1.6,
        ambient_green = level.base_color[2] * 1.6,
        ambient_blue = level.base_color[3] * 1.6,
        diffuse_red = level.base_color[1],
        diffuse_green = level.base_color[2],
        diffuse_blue = level.base_color[3],
        specular_red = 0.7,
        specular_green = 0.7,
        specular_blue = 0.7,
        shininess = 50,
    }:Action(coroutine.wrap(function(dt, material)
        while true do
            material:Tween{
                emission_red = 0.8,
                emission_green = 0.7,
                emission_blue = 0.6,
                time = 0.3
            }
            coroutine.yield(0.3)
            material:Tween{
                emission_red = 0.3,
                emission_green = 0.2,
                emission_blue = 0.2,
                time = 0.34
            }
            coroutine.yield(0.34)
        end
    end)))
--[[
lighted_layer:Insert(
    level.barrier_layer:Material{
        ambient_red = level.base_color[1] * 0,
        ambient_green = level.base_color[2] * 0,
        ambient_blue = level.base_color[3] * 0,
        diffuse_red = level.base_color[1] * 0.2,
        diffuse_green = level.base_color[2] * 0.2,
        diffuse_blue = level.base_color[3] * 0.2,
        specular_red = 0.4,
        specular_green = 0.4,
        specular_blue = 0.4,
        shininess = 50,
    }:Action(coroutine.wrap(function(dt, material)
        local r = (level.base_color[1] ^ 1.5) * 2.0
        local g = (level.base_color[2] ^ 1.5) * 2.0
        local b = (level.base_color[3] ^ 1.5) * 2.0
        while true do
            material:Tween{
                emission_red = r,
                emission_green = g,
                emission_blue = b,
                time = 1
            }
            coroutine.yield(1)
            material:Tween{
                emission_red = 0.0,
                emission_green = 0.0,
                emission_blue = 0.0,
                time = 1
            }
            coroutine.yield(1)
        end
    end)))
]]
local normal_platform_material =
    level.solids_layer:Material{
        specular_red = 0.7,
        specular_green = 0.7,
        specular_blue = 0.7,
        shininess = 50,
    }
lighted_layer:Insert(normal_platform_material)
level.normal_platform_material = normal_platform_material
lighted_layer:Insert(
    level.props_layer:Material{
        ambient_red = level.base_color[1] * 0.7,
        ambient_green = level.base_color[2] * 0.7,
        ambient_blue = level.base_color[3] * 0.7,
        diffuse_red = level.base_color[1] * 0.4,
        diffuse_green = level.base_color[2] * 0.4,
        diffuse_blue = level.base_color[3] * 0.4,
        specular_red = 0.7,
        specular_green = 0.7,
        specular_blue = 0.7,
        shininess = 50,
    })
local flickering_material = 
    level.flickering_layer:Material{
        specular_red = 0.7,
        specular_green = 0.7,
        specular_blue = 0.7,
        shininess = 50,
    }:Action(coroutine.wrap(function(dt, material)
        while true do
            coroutine.yield(math.random() * 0.3 + 0.1)
            material.emission_red = 0.7
            material.emission_green = 0.04
            coroutine.yield(math.random() * 0.1 + 0.1)
            material.emission_red = 0
            material.emission_green = 0
        end
    end))
level.flickering_material = flickering_material
lighted_layer:Insert(flickering_material)
local fast_material = 
    level.fast_layer:Material{
        specular_red = 0.7,
        specular_green = 0.7,
        specular_blue = 0.7,
        shininess = 50,
    }:Action(coroutine.wrap(function(dt, material)
        while true do
            coroutine.yield(1/15)
            material.emission_red = 0.15
            material.emission_green = 0.15
            material.emission_blue = 0.15
            coroutine.yield(1/15)
            material.emission_red = 0
            material.emission_green = 0
            material.emission_blue = 0
        end
    end))
level.fast_material = fast_material
lighted_layer:Insert(fast_material)

local platforms_translate
platforms_translate = lt.Layer(
        level.scan_layer:BlendMode("add"):DepthMask(false):Lighting(false),
        lighted_layer:CullFace("back")
    )
    :DepthTest()
    :Rotate(-(level.start_lane - 1) * level.lane_rotate, 0, config.level_center_y)
    :Translate(0, 0)

local light = platforms_translate
    :Light{
        x = config.platform_width_scale * 3,
        y = 700,
        z = -10,
        l = 0.0000,
        q = 0.0000,
        ambient_red = 1,
        ambient_green = 1,
        ambient_blue = 1,
        diffuse_red = 5,
        diffuse_green = 5,
        diffuse_blue = 5,
        fixed = false,
    }
    :BlendMode("off")
    :Lighting()

level.light = light
local environment_layer =
    light:Perspective(1, 8, config.clip_depth + 10, 0, config.vanish_y_offset)
level.platforms_translate = platforms_translate

-- generate stage bg
import("bg_stage" .. game_state.stage_id, level)

local running_sprite = lt.Sprite(lt.MatchFields(player_frames.images,
    lt.state.prof_gender .. "_running_%d"), config.running_sprite_fps)
local jumping_sprite = lt.Sprite(lt.MatchFields(player_frames.images,
    lt.state.prof_gender .. "_jumping_%d"), config.running_sprite_fps)
jumping_sprite.loop = 12
local player_node_y_offset = config.player_y_offset + man_height / 2
local player_node = running_sprite:Translate(0.05, player_node_y_offset)
local player_glow = player_node:TextureMode("add"):Tint(0, 0, 0)

local
function glow_tween(t, d)
    player_glow:Tween{
        delay = d,
        red = 0.3,
        green = 0.8,
        blue = 0.8,
        time = t,
    }
end
player_glow:Action(coroutine.wrap(function(dt, node)
    for i = 1, 5 do
        node.mode = "modulate"
        node.alpha = 0
        coroutine.yield(0.1)
        node.alpha = 1
        coroutine.yield(0.1)
    end
    node.mode = "add"
    return true
end))
local player_layer = lt.Layer(player_glow)
local player_node_wrap = player_layer:Translate(0, 0)
--if lt.form_factor == "desktop" then
    player_node_wrap.y = -0.4
    player_node_wrap = player_node_wrap:Scale(0.8)
--end
local shadow = player_node:Scale(0.9, 0.2):Translate(0, config.player_y_offset + 0.58):Tint(0,0,0,0)
--local default_backpack = make_default_backpack()
--backpack_layer:Insert(default_backpack.node)

local player = {
    angle = (level.start_lane - 1) * level.lane_rotate,
    x = 0,
    y = 30.5,
    vy = 0,
    artifact = nil,
    node = player_node,
    jumping_sprite = jumping_sprite,
    running_sprite = running_sprite,
    lane = level.start_lane,
    game_state = game_state
}

level.player = player

local speed_display = lt.Text("", digits, "right", "center"):Scale(1)
local score_bg_w = 3
local score_bg_x = 0.05
local score_bg = lt.Rect(score_bg_x - score_bg_w, -0.22, score_bg_x, 0.28):Tint(0, 0, 0, 0.3)
--local percent = lt.Text("%", font, "left", "top"):Scale(1):Translate(0.02, 0.2)
--local energy_label = lt.Text("ENERGY:", font, "left", "top"):Scale(1):Translate(-2.5, 0.2)
local energy_bar = lt.Rect(score_bg_x - score_bg_w, 0.22, score_bg_x - score_bg_w, 0.28):Tint(0.7, 1, 1)
local score_layer = lt.Layer(energy_bar, speed_display, score_bg)
    :Scale(0.7):Translate(lt.right - 0.1, lt.top - 0.25)

local hud = lt.Layer():Wrap()
local update_hud_counter = 1
local hud_blinking = false
local beat_best = false
local dot = lt.Text(".", digits, "right", "center"):Translate(-0.67, 0)
local
function update_hud(force)
    if update_hud_counter == 5 or force then
        --local speed_whole = math.floor(level.progress * 100)
        --local speed_frac = math.floor((level.progress * 100 - speed_whole) * 100)
        --local frac_str = "" .. speed_frac
        --while #frac_str < 2 do
        --    frac_str = "0" .. frac_str
        --end
        --local whole_str = "" .. speed_whole
        --local text_whole = lt.Text(whole_str, digits, "right", "center")
        --local text_frac = lt.Text(frac_str, digits, "left", "center")
        local speed_str = string.format("%0.2f%%", level.progress * 100)
        local text = lt.Text(speed_str, digits, "right", "center")
        --local text = lt.Layer(text_whole:Translate(-0.81, 0), dot, text_frac:Translate(-0.65, 0))
        --local w = text_whole.width / 2 + 0.4
        --local w = (math.max(4, #speed_str) - 1) * 0.157 + 0.7
        --local w = (math.max(4, #speed_str) - 1) * 0.157 + 0.3
        --score_bg.x1 = - w * 2 - 0.1 
        --energy_label.x = score_bg.x1 + 0.1
        energy_bar.x2 = score_bg_x - math.max(0, (1 - level.progress) * score_bg_w)
        speed_display.child = text
        update_hud_counter = 0
        if not hud_blinking and level.speed > level.stage.max_speed then
            local empty = lt.Layer()
            local child = hud.child
            local ready_for_collision
            if not lt.state.stage_finished[game_state.stage_id] then
                local ready_for_collision_text = lt.Text("READY FOR COLLISION", font, "center", "top")
                    :Translate(score_bg_x - score_bg_w / 2, -0.24)
                    
                local ready_for_collision_bg = lt.Rect(score_bg_x - score_bg_w, -0.50, score_bg_x, -0.22):Tint(0.7, 0.1, 0.2, 0.6)
                ready_for_collision = lt.Layer(ready_for_collision_text, ready_for_collision_bg)
                    :Scale(0.7):Translate(lt.right - 0.1, lt.top - 0.25)
                child:Insert(ready_for_collision)
            end
            local is_empty = false
            local count = 0
            hud:Action(function(dt, disp)
                if is_empty then
                    hud.child = child
                    if count > 30 then
                        if ready_for_collision then
                            child:Remove(ready_for_collision)
                        end
                        return true
                    end
                else
                    hud.child = empty
                end
                is_empty = not is_empty
                count = count + 1
                return 0.2
            end)
            hud_blinking = true

            local
            function energy_pulse()
                energy_bar:Tween{red = 1, green = 1, blue = 1, time = 0.2, action = function()
                    energy_bar:Tween{red = 0, green = 0.5, blue = 0.5, time = 0.2, action = energy_pulse}
                end}
            end
            energy_pulse()
        end

        if not beat_best and prev_best > 0 and level.progress > prev_best then
            beat_best = true
            local newpeak_text = lt.Text("NEW PEAK", font, "left", "bottom")
                :Scale(0.6):Tint(0.5, 1, 1):Translate(score_bg_x - score_bg_w + 0.06, -0.22 + 0.04)
            local n = 11
            score_layer:Action(function(dt)
                if n == 0 then
                    return true
                elseif n % 2 == 0 then
                    newpeak_text.alpha = 0
                else
                    newpeak_text.alpha = 1
                end
                n = n - 1
                return 0.2
            end)
            score_layer:Insert(newpeak_text)
        end
    end
    update_hud_counter = update_hud_counter + 1
end

hud:Insert(score_layer)

local pause
local pause_button
do 
    local x = 0.05
    local w = 0.6

    pause_button = lt.Layer(
        lt.Rect(0.22, -0.08, 0.32, 0.14),
        lt.Rect(0.38, -0.08, 0.48, 0.14),
        lt.Rect(0.05, -0.22, 0.65, 0.28):Tint(0, 0, 0, 0.3))
        :Scale(0.7)
        :Translate(lt.left + 0.03, lt.top - 0.25)
end

local master_translate = lt.Layer()
--master_translate:Insert(level.music)
master_translate:Insert(level.background_layer)
master_translate:Insert(environment_layer)
master_translate:Insert(shadow)
master_translate:Insert(player_node_wrap)
master_translate = master_translate:Translate(0, 0)
level.master_translate = master_translate

local control_layer = lt.Layer()

play_layer:Insert(master_translate)
play_layer:Insert(hud)
if lt.form_factor ~= "desktop" then
    play_layer:Insert(pause_button)
end
play_layer:Insert(overlay)
play_layer:Insert(control_layer)

local time_since_last_step = 0
local time_since_last_breath = 0
local breath_gap = 0.8
local time_since_last_heartbeat = 0
local heartbeat_rate = 2.8

local
function advance_player(dt)
    local player_platform = level:get_platform_under(player.lane, player.y)
    if player_platform and
        player.vy <= 0 and 
        (player.y <= player_platform.y or player_platform.falling) and 
        math.abs(player_platform.y - player.y) < config.contact_error 
    then
        -- The player is on top of a platform.
        player.y = player_platform.y
        player.vy = 0
        shadow:Tween{alpha = 0.1, time = 0.1}
        if not touching_ground then
            player_node.child = running_sprite
            touching_ground = true
            play_land(math.min(1, level.progress))
            time_since_last_step = 0
            time_since_last_breath = breath_gap
            if is_double_jumping then
                double_jump_end = true
                is_double_jumping = false
            end
        end
        if time_since_last_step > 0.18 / level.speed then
            play_step(math.min(1, level.progress))
            time_since_last_step = 0
        else
            time_since_last_step = time_since_last_step + dt
        end
    else
        -- The player is in the air (or inside a platform).
        if jump_down and (config.allow_repeat_hang or not is_double_jumping) then
            player.vy = player.vy + config.jump_hang_speed
        end
        player.vy = player.vy - config.gravity
        if not jump_down and player.vy < 0 and player.vy > -0.12 then
            player.vy = -0.12
        end

        player.y = player.y + player.vy
        shadow:Tween{alpha = 0, time = 0.1}
        if touching_ground then
            player_node.child = jumping_sprite
            touching_ground = false
        end
    end

    if player.artifact then
        player.artifact:advance(level, dt)
    end
end

local
function die(death_kind)
    local complete = false
    if level.speed > level.stage.max_speed and not lt.state.stage_finished[game_state.stage_id] then
        complete = true
        local unlocked_before = {}
        for s = 1, num_stages do
            unlocked_before[s] = is_unlocked(s)
        end
        lt.state.stage_finished[game_state.stage_id] = true
        if game_state.stage_id < num_stages then
            game_state.stages_unlocked = true
        end
        local new_unlocks = {}
        for s = 1, num_stages do
            if not unlocked_before[s] and is_unlocked(s) then
                table.insert(new_unlocks, s)
            end
        end
        game_state.unlocks = new_unlocks
    else
        music:Tween{gain = 0.2 * lt.state.music_volume, pitch = 0.5, time = 0.1}
        game_state.unlocks = {}
    end

    lt.state.games_played = lt.state.games_played + 1

    update_hud(true)
    game_state.death_kind = death_kind
    game_state.score = level.progress
    main_scene.child = lt.Layer()
    main_scene.child:Insert(music)
    main_scene.child:Insert(explosion_track())
    main_scene.child:Insert(level.background_layer)
    local overlay = lt.Rect(lt.left, lt.bottom, lt.right, lt.top):BlendMode("add"):Tint(0.7, 0.7, 0.7, 1)
    main_scene.child:Insert(overlay)
    local explosion = gen_explosion(game_state)
    game_state.explosion = explosion
    main_scene.child:Insert(explosion)
    local
    function gameover()
        if complete then
            import("complete_transition", game_state)
        else
            import("gameover", game_state)
        end
    end
    clearall()

    overlay:Tween{alpha = 0, red = 0, green = 0, blue = 0, time = 0.6, action = function()
        overlay.mode = "multiply"
        overlay.red = 1
        overlay.green = 1
        overlay.blue = 1
        overlay:Tween{alpha = 1, red = 0.4, green = 0.4, blue = 0.4, time = 0.3}
        gameover()
    end}

    player.dead = true
end

player.die = die

local
function check_player_fallen()
    local y_cutoff = - config.fall_y_cutoff
    if player.y < y_cutoff then
        die("fall")
    end
    local inside_platform = level:is_inside_platform(player.lane, player.y)
    if inside_platform and not player.is_sidestepping then
        if player.vy > 0 then
            -- Hit head on top of platform
            player.vy = -player.vy
            player.y = player.y - 0.5
        elseif player.vy < -0.2 then
            die("fall")
        else
            die("hitwall")
        end
    end
end

local player_glowing = false
local energy_boost_particles = make_energy_boost_particles(0, 0):Translate(0, -0.4)
local energy_boost_sound = charge_track()
energy_boost_sound:Play()
player_layer:Insert(energy_boost_particles)
player_layer:Insert(energy_boost_sound)

local
function advance_energy_boost(dt)
    local player_platform = level:get_platform_under(player.lane, player.y)
    if touching_ground and player_platform and
        player_platform.has_energy_boost
    then
        local e = level.stage.energy_speedup
        -- The random variation is to help differentiate scores on the leaderboard
        level.speed = level.speed + e * (0.95 + math.random() * 0.1)

        if not player_glowing then
            glow_tween(0.2)
            player_glowing = true
            energy_boost_particles.emission_rate = 150
            energy_boost_sound.gain = 0
            energy_boost_sound.pitch = math.min(1, level.progress) * 0.5 + 1
            energy_boost_sound:Tween{gain = lt.state.sfx_volume, time = 0.2}
            energy_boost_sound:Tween{pitch = math.min(1, level.progress) * 0.5  + 2, time = 10}
            --energy_boost_sound:Play()
        end
    else
        if player_glowing then
            if level.progress < 1 then
                player_glow:Tween{
                    red = 0,
                    green = 0,
                    blue = 0,
                    time = 1,
                }
            end
            player_glowing = false
            energy_boost_particles.emission_rate = 0
            energy_boost_sound:Tween{gain = 0, time = 0.5, action = function()
                --energy_boost_sound:Stop()
            end}
        end
    end
end

local
function advance_breathing(dt)
    if time_since_last_breath > breath_gap then
        play_breath(math.min(1, level.progress))
        time_since_last_breath = 0
    else
        time_since_last_breath = time_since_last_breath + dt
    end
end

local 
function advance_heatbeat(dt)
    local speed = level.speed
    local gap = heartbeat_rate / (math.min(1, level.progress) + 1)
    if time_since_last_heartbeat > gap then
        time_since_last_heartbeat = 0
    else
        time_since_last_heartbeat = time_since_last_heartbeat + dt
    end
end

local
function advance_audio(dt)
    advance_breathing(dt)
    advance_heatbeat(dt)
end

local current_tutorial_arrows

local
function advance_tutorial_messages(dt)
    local msg = level.message_queue[level.front_row]
    if not msg then return end
    level.message_queue[level.front_row] = nil
    if msg == "tutorial_end" then
        lt.state.tutorial_complete = true
    elseif msg == "off" then
        if current_tutorial_arrows then
            play_layer:Remove(current_tutorial_arrows)
            current_tutorial_arrows = nil
        end
    else
        local a1 = 0.6
        local a2 = 0.2
        local arrows
        local dir
        local alt = true
        local down_t = 0.2
        local arrow_img = images.left_arrow_shadow:Wrap():Action(function(dt, node)
            local t = 0.4
            if not alt then
                node.child = images.left_arrow
                t = down_t
            else
                node.child = images.left_arrow_shadow
            end
            alt = not alt
            return t
        end)
        local y_os = 1.2
        local ybuf = 0.05
        local xbuf = 0.1
        local txt_scale = 0.7
        local img_scale = 1.2
        local alpha = 0.4
        local fnt = font_large
        if lt.form_factor == "desktop" then
            txt_scale = 0.8
            img_scale = 0
            alpha = 0.5
            fnt = font
        elseif lt.form_factor == "tablet" then
            img_scale = 1.0
        end
        if msg == "left" then
            local str = "TAP"
            if lt.form_factor == "desktop" then
                str = "LEFT ARROW: JUMP LEFT"
            end
            local txt = lt.Text(str, fnt, "center", "center")
            local w, h = txt.width * txt_scale * 0.5, txt.height * txt_scale * 0.5
            arrows = lt.Layer(
                arrow_img:Scale(img_scale):Translate(lt.left + 1, 0.1),
                txt:Scale(txt_scale):Translate(0, y_os),
                lt.Rect(-w - xbuf, -h - ybuf * 0.7, w + xbuf, h + ybuf):Tint(0, 0, 0, alpha):Translate(0, y_os)
            )
            dir = "left"
        elseif msg == "right" then
            local str = "HOLD"
            if lt.form_factor == "desktop" then
                str = "RIGHT ARROW: JUMP RIGHT\nHOLD FOR LONGER JUMPS"
            end
            local txt = lt.Text(str, fnt, "center", "center")
            local w, h = txt.width * txt_scale * 0.5, txt.height * txt_scale * 0.5
            arrows = lt.Layer(
                arrow_img:Scale(img_scale):Translate(lt.left + 1, 0.1):Scale(-1, 1),
                txt:Scale(txt_scale):Translate(0, y_os),
                lt.Rect(-w - xbuf, -h - ybuf * 0.7, w + xbuf, h + ybuf):Tint(0, 0, 0, alpha):Translate(0, y_os)
            )
            dir = "right"
            down_t = 1
        elseif msg == "straight" then
            local str = "TOGETHER"
            if lt.form_factor == "desktop" then
                str = "UP ARROW: JUMP STRAIGHT"
            end
            local txt = lt.Text(str, fnt, "center", "center")
            local w, h = txt.width * txt_scale * 0.5, txt.height * txt_scale * 0.5
            if lt.form_factor == "desktop" then
                arrows = lt.Layer(
                    txt:Scale(txt_scale):Translate(0, y_os + 0.1),
                    lt.Rect(-w - xbuf, -h - ybuf * 0.7, w + xbuf, h + ybuf):Tint(0, 0, 0, alpha):Translate(0, y_os + 0.1)
                )
            else
                arrows = lt.Layer(
                    arrow_img:Scale(img_scale):Translate(lt.left + 1, 0.1),
                    arrow_img:Scale(img_scale):Translate(lt.left + 1, 0.1):Scale(-1, 1),
                    txt:Scale(txt_scale):Translate(0, y_os),
                    lt.Rect(-w - xbuf, -h - ybuf * 0.7, w + xbuf, h + ybuf):Tint(0, 0, 0, alpha):Translate(0, y_os)
                )
            end

            dir = "straight"
            down_t = 1
        elseif tutorial_messages[msg] then
            if lt.form_factor ~= "desktop" then
                txt_scale = txt_scale * 2
            end
            local str = tutorial_messages[msg]
            local txt = lt.Text(str, font, "center", "center")
            local w, h = txt.width * txt_scale * 0.5, txt.height * txt_scale * 0.5
            local s = 0.7
            if lt.form_factor == "desktop" then
                s = 1
            end
            arrows = lt.Layer(
                txt:Scale(txt_scale * s):Translate(0, y_os),
                lt.Rect(-w - xbuf, -h - ybuf, w + xbuf, h + ybuf):Scale(s):Tint(0, 0, 0, alpha):Translate(0, y_os)
            )
        else
            return
        end
        if current_tutorial_arrows then
            play_layer:Remove(current_tutorial_arrows)
        end
        current_tutorial_arrows = arrows
        play_layer:Insert(arrows)
    end
end

local time_since_energy = 0

local start_speed = level.stage.initial_speed
local speed_range = level.stage.max_speed - start_speed

local achieved_critical = false

local extra_speed = 0

local
function advance_platforms(dt)
    local speed = level.speed
    local z = level.z
    z_accum = z_accum + speed
    z = z + speed
    if z_accum > config.platform_depth_scale then
        level:shift()
        speed = level.speed -- collecting a speedup can affect level speed.
        z_accum = z_accum - config.platform_depth_scale
        advance_tutorial_messages()
    end
    platforms_translate.z = z
    
    -- speed up running sprite
    running_sprite.spf = stages[1].initial_speed / (speed * config.running_sprite_fps) 

    platforms_translate.y = -player.y + config.player_y_offset

    level.z = z
    level.speed = speed
    level.progress = (speed - extra_speed - start_speed) / speed_range

    if not level.energy_due then
        time_since_energy = time_since_energy + dt
    end
    if time_since_energy > level.stage.energy_interval then
        level.energy_due = 1
        time_since_energy = 0
    end

    if not achieved_critical and speed > level.stage.max_speed then
        achieved_critical = true
        music:promote()
        samples.reach_critical:Play(1, lt.state.sfx_volume)
        environment_layer:Tween{origin = 3, time = 0.3, action = function()
            environment_layer:Tween{origin = 8, time = 0.8}
            extra_speed = speed_range * 0.5
            level.speed = level.speed + extra_speed
        end}
    end
end

local
function opposite_dir(dir)
    if dir == "right" then
        return "left"
    elseif dir == "left" then
        return "right"
    else
        return "straight"
    end
end

local
function change_lanes(dir)
    local new_lane
    if dir == "left" then
        new_lane = player.lane - 1
        if new_lane < 1 then
            new_lane = level.num_lanes
        end
    elseif dir == "right" then
        new_lane = player.lane + 1
        if new_lane > level.num_lanes then
            new_lane = 1
        end
    end
    if new_lane then
        player.is_sidestepping = true
        local new_angle = - (new_lane - 1) * level.lane_rotate
        local old_angle = platforms_translate.angle
        local diff = new_angle - old_angle
        if diff > 180 then
            diff = diff - 360
        elseif diff < -180 then
            diff = 360 + diff
        end
        player.lane = new_lane
        platforms_translate:Tween{
            angle = old_angle + diff,
            time = config.sidestep_speed,
            easing = "inout",
            action = function()
                platforms_translate.angle = new_angle
            end}
        lt.Timer(config.sidestep_speed/2, function()
            player.is_sidestepping = false
            local inside_platform = level:is_inside_platform(player.lane, player.y)
            if inside_platform then
                change_lanes(opposite_dir(dir))
                samples.hitside:Play(1, lt.state.sfx_volume)
                player_glow:Tween{red = 1, green = 1, blue = 1, time = 0.05, action = function() 
                    if level.progress > 1 then
                        glow_tween(0.05, 0.05)
                    else
                        player_glow:Tween{delay = 0.05, red = 0, green = 0, blue = 0, time = 0.05}
                    end
                end}
            end
        end)
    end
end

player.change_lanes = change_lanes

local
function do_jump()
    change_lanes(jump_dir)
    player.vy = config.jump_initial_speed
    player_node.child = jumping_sprite
    jumping_sprite:Reset()
    touching_ground = false
    play_jump(math.min(1, level.progress))
    time_since_last_breath = -0.5
    jump_dir = nil
    energy_boost_jump_power = config.energy_boost_jump_power
    time_since_jump = 0
end

local jump_correction_threshold = 60 * config.jump_correction_timeout
local last_jump_counter = 1000
local allow_jump_correction = config.allow_jump_correction
local initial_jump_dir

local
function advance_jump(dt)
    if double_jump_end then
        if player.artifact and player.artifact.double_jump_end then
            player.artifact:double_jump_end(level)
        end
        double_jump_end = false
    end
    if jump_dir and touching_ground and jump_counter > 0 then
        initial_jump_dir = jump_dir
        do_jump()
        last_jump_counter = 0
    elseif jump_dir and allow_jump_correction
        and jump_dir ~= initial_jump_dir
        and not touching_ground and last_jump_counter < jump_correction_threshold
    then
        change_lanes(jump_dir)
        jump_dir = nil
        last_jump_counter = 1000
    elseif jump_dir and not touching_ground then
        is_double_jumping = true
    end
    jump_counter = jump_counter - 1
    last_jump_counter = last_jump_counter + 1
    if jump_down then
        time_since_jump = time_since_jump + dt
    else
        time_since_jump = 0
    end
    energy_boost_jump_power = energy_boost_jump_power - config.energy_boost_jump_power_decay
    if energy_boost_jump_power < 0 then
        energy_boost_jump_power = 0
    end
end

play_layer:Action(function(dt)
    if curr_action then
        curr_action(dt)
    end
end)

local
function main_action(dt)
    advance_jump(dt)
    advance_platforms(dt)
    check_player_fallen()
    advance_player(dt)
    advance_energy_boost(dt)

    advance_audio(dt)

    lt.AdvanceGlobalTimers(dt)
    lt.AdvanceGlobalSprites(dt)

    local sprite = player_node.child
    local frame = sprite.frames[sprite.curr_frame]

    player.angle = -platforms_translate.angle

    update_hud()
end

curr_action = main_action

local
function record_jump_intention(dir)
    jump_dir = dir
    jump_counter = 60 * config.jump_grace_period
    jump_down = true
end

local
function stopjump()
    jump_down = false
    jump_touch = nil
    if is_double_jumping then
        double_jump_end = true
        is_double_jumping = false
    end
end

function pause()
    if lt.form_factor == "desktop" then
        samples.uiback:Play(1, lt.state.sfx_volume)
        import("stage_select")
        return
    end
    stopjump()
    local pause_layer = lt.Layer()
    local scene = main_scene.child
    pause_layer:Insert(scene)
    local overlay = lt.Rect(lt.left, lt.bottom, lt.right, lt.top):Tint(0.6, 0.6, 0.6, 1):BlendMode("subtract")
    pause_layer:Insert(overlay)

    local py_os = -0.3
    pause_layer:Insert(lt.Rect(-0.08, -0.076, 0.08, 0.076):Tint(unpack(config.ui_active_color)):Translate(-1.41, 1.2 + py_os))
    pause_layer:Insert(lt.Text("PAUSED", font, "left", "center"):Scale(1.1):Translate(-1.3, 1.193 + py_os):Tint(unpack(config.ui_light_grey)))
    local w = 1.49
    if lt.form_factor == "desktop" then
        w = 1.7
    end
    pause_layer:Insert(lt.Rect(-w, 0, w, 1):Tint(0, 0, 0, 0.5):Translate(0.08, -0.08 + py_os)) --shadow
    pause_layer:Insert(lt.Rect(-w, 0, w, 1):Tint(unpack(config.ui_bg)):Translate(0, py_os))

    local
    function resume()
        main_scene.child = scene
        scene:Resume()
    end

    local buttons = {}
    local
    function remove_buttons()
        for _, button in ipairs(buttons) do
            pause_layer:Remove(button)
        end
    end
    local
    function add_buttons()
        for _, button in ipairs(buttons) do
            pause_layer:Insert(button)
        end
    end

    local resume_label = "RESUME"
    if lt.form_factor == "desktop" then
        resume_label = resume_label .. " [ESC]"
    end
    local resume_button
    resume_button = make_button1(resume_label, resume):Translate(-0.8, 0.5 + py_os)
    table.insert(buttons, resume_button)

    local quit_button
    local quit_label = "ABANDON"
    if lt.form_factor == "desktop" then
        quit_label = quit_label .. " [Q]"
    end
    quit_button = make_button1(quit_label, function()
        samples.uiback:Play(1, lt.state.sfx_volume)
        import("stage_select")
    end):Translate(0.7, 0.5 + py_os)
    table.insert(buttons, quit_button)

    add_buttons()

    overlay:KeyDown(function(event)
        if event.key == "esc" then
            resume()
        elseif event.key == "Q" then
            import("stage_select")
        end
    end)
    overlay:KeyUp(function(event)
        key_down[event.key] = false
    end)

    main_scene.child = pause_layer
    scene:Pause()
end

local jump_keys = {
    up = "straight",
    down = "straight",
    W = "straight",
    S = "straight",
    left = "left",
    A = "left",
    right = "right",
    D = "right",
}

control_layer:KeyDown(function(event)
    local key = event.key
    key_down[key] = true
    local dir = jump_keys[key]
    if dir then
        local initial_dir = nil
        if jump_touch then
            if jump_dir then
                initial_dir = jump_dir
            end
            stopjump()
        end
        jump_touch = key
        if initial_dir == "right" and dir == "left" then
            dir = "straight"
        elseif initial_dir == "left" and dir == "right" then
            dir = "straight"
        end
        record_jump_intention(dir)
    --elseif key == "R" then
    --    play(game_state.stage_id)
    --elseif key == "H" then
    --    game_state.stage_id = game_state.stage_id + 1
    --    play(game_state)
    elseif key == "esc" then
        pause()
    end
end)

control_layer:PointerDown(function(event)
    if not allow_touch then return end
    local touch = event.touch + event.button
    local x, y = event.x, event.y
    if x < lt.left + 0.5 and y > lt.top - 0.5 then
        pause()
        return
    end
    local initial_dir = nil
    if jump_touch then
        if jump_dir then
            initial_dir = jump_dir
        end
        stopjump()
    end
    jump_touch = touch
    local dir
    if x < 0 then
        dir = "left"
    else
        dir = "right"
    end
    if initial_dir == "right" and dir == "left" then
        dir = "straight"
    elseif initial_dir == "left" and dir == "right" then
        dir = "straight"
    end
    record_jump_intention(dir)
end)

control_layer:KeyUp(function(event)
    local key = event.key
    key_down[key] = false
    if key == jump_touch then
        stopjump()
    end
end)

control_layer:PointerUp(function(event)
    local touch = event.button + event.touch
    if touch == jump_touch then
        stopjump()
    end
end)

end
