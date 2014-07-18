local scene = lt.Layer()
main_scene.child = scene

local swidth = lt.right - lt.left

local x_spacing = 0.85
local y_spacing = 0.52
local button_width = images.stage_select_button_undiscovered.width
local button_height = images.stage_select_button_undiscovered.height

local buttons = lt.Layer()

local select_mesh = images.button_off:Mesh():Grid(3, 3):Stretch(0, 0, 0, 0.38, 0.38, 0.35, 0.35, 0, 0):Translate(0, 0)
local button_layers = {}

local selected_stage = 1
for s = 1, num_stages do
    if is_unlocked(s) and not lt.state.stage_finished[s] then
        selected_stage = s
        break
    end
end

local
function update_selected_stage(new_selected, no_play)
    if is_unlocked(new_selected) then
        button_layers[selected_stage]:Remove(select_mesh)
        selected_stage = new_selected
        button_layers[selected_stage]:Insert(select_mesh)
        if not no_play then
            samples.uibleep:Play(1, lt.state.sfx_volume)
        end
    end
end

local
function loadstage(stage)
    samples.uibleep:Play(1, lt.state.sfx_volume)
    main_scene.child = lt.Layer(make_getready(stage), fs_overlay:BlendMode("off"))
    local alt = true
    main_scene.child:Action(function(dt)
        if alt then
            alt = false
            return 1.0
        else
            play(stage)
            return true
        end
    end)
end

for s = 1, num_stages do
    local stage_button
    local stage = stages[s]
    local button_text
    if lt.state.stage_finished[s] then
        button_text = lt.Layer(
            images["stage" .. s .. "_label"],
            images.discovered_text,
            lt.Text(string.format("%0.2f%%", lt.state.best_score[s] * 100), font, "left", "top")
                :Scale(0.4):Translate(-0.6, -0.25):Tint(45/255, 78/255, 106/255)
        )
    elseif is_unlocked(s) then
        button_text = lt.Layer(
            images["stage" .. s .. "_label"],
            images.undiscovered_text,
            lt.Text(string.format("%0.2f%%", lt.state.best_score[s] * 100), font, "left", "top")
                :Scale(0.4):Translate(-0.6, -0.25):Tint(45/255, 78/255, 106/255)
        )
    else
        button_text = lt.Layer(
            lt.Text(" ", font):Tint(0, 0, 0, 0.2):Scale(1.2):Translate(-0.05, 0)
        )
    end
    if not is_unlocked(s) then
        button_text = button_text:Tint(1, 1, 1, 0.6)
    end
    if lt.state.stage_finished[s] then
        stage_button = make_button1(button_text, function()
            loadstage(s)
        end, {button_width, button_height},
        images.stage_select_button_discovered)
    elseif is_unlocked(s) then
        local img = images.stage_select_button_undiscovered
        if lt.state.stages_played[s] == 0 then
            -- flash if not played yet.
            img = img:Tint(1, 1, 1):Action(coroutine.wrap(function(dt, node)
                local t = 0.6
                while true do
                    node:Tween{alpha = 0.6, time = t/2}
                    coroutine.yield(t/2)
                    node:Tween{alpha = 1, time = t/2}
                    coroutine.yield(t)
                end
            end))
        end
        stage_button = make_button1(button_text, function()
            loadstage(s)
        end, {button_width, button_height},
        img)
    else
        stage_button = make_button1(button_text, function()
            -- do nothing
        end, {button_width, button_height},
        images.stage_select_button_locked)
    end
    local x = (((s - 1) % 3) * 2 - 2) * x_spacing
    local y = (1 - math.floor((s - 1) / 3) * 2) * y_spacing
    table.insert(button_layers, stage_button)
    buttons:Insert(stage_button:Translate(x, y))
end

if lt.form_factor == "desktop" then
    update_selected_stage(selected_stage, true)
end

buttons:KeyDown(function(event)
    local stage = tonumber(event.key)
    if stage and stage >= 1 and stage <= num_stages and is_unlocked(stage) then
        play(stage)
    end
    if event.key == "enter" or event.key == "space" then
        if is_unlocked(selected_stage) then
            play(selected_stage)
        else
            samples.not_allowed:Play()
        end
    end
    if event.key == "up" or event.key == "down" then
        local s = selected_stage + 3
        if s > 6 then
            s = s - 6
        end
        update_selected_stage(s)
    elseif event.key == "right" then
        local s = selected_stage + 1
        if s > 6 then
            s = s - 6
        end
        update_selected_stage(s)
    elseif event.key == "left" then
        local s = selected_stage - 1
        if s < 1 then
            s = s + 6
        end
        update_selected_stage(s)
    end
    if event.key == "esc" then
        flash(function() import("title") end, true)
    end
end)

local back_button
local select_button
if lt.form_factor == "desktop" then
    local back_label = "ESC: BACK"
    back_button = lt.Text(back_label, font, "left", "bottom"):Tint(unpack(config.ui_bg))
        :Scale(0.6):Translate(lt.left + 0.1, lt.bottom + 0.1)
    select_button = lt.Text("ENTER: SELECT", font, "right", "bottom"):Tint(unpack(config.ui_bg))
        :Scale(0.8):Translate(lt.right - 0.1, lt.bottom + 0.1)
else
    local back_img = images.back_arrow:Translate(lt.left + swidth / 6, button_bar_mid_y)
    local divider = lt.Rect(lt.left + swidth / 3, lt.bottom, lt.left + swidth / 3 + 0.02, lt.bottom + bottom_bar_height)
        :Tint(unpack(config.ui_active_color))
    back_button = lt.Layer(back_img, divider)
        :PointerDown(function(event)
            flash(function() import("title") end, true)
        end, lt.left, lt.bottom, lt.left + swidth / 3, lt.bottom + bottom_bar_height)
end

scene:Insert(fs_overlay:Tint(unpack(config.ui_bg)))
scene:Insert(button_bar_overlay())
scene:Insert(back_button)
if select_button then
    scene:Insert(select_button)
end
scene:Insert(buttons:Translate(0, 0.05))
if lt.form_factor == "desktop" then
    scene:Insert(lt.Rect(-0.08, -0.056, 0.08, 0.056):Tint(unpack(config.ui_active_color)):Translate(-2.41, 1.5))
    scene:Insert(lt.Text("SELECT EXPERIMENT", font, "left", "center"):Scale(0.8):Translate(-2.2, 1.494):Tint(unpack(config.ui_light_grey)))
else
    scene:Insert(lt.Rect(-0.08, -0.076, 0.08, 0.076):Tint(unpack(config.ui_active_color)):Translate(-2.41, 1.5))
    scene:Insert(lt.Text("SELECT EXPERIMENT", font, "left", "center"):Scale(1.1):Translate(-2.3, 1.494):Tint(unpack(config.ui_light_grey)))
end
