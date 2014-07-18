local game_state = ...

local old_scene = main_scene.child

local scene = lt.Layer(old_scene)

local stage_id = game_state.stage_id
local stage_new = compute_progress()
local stage_old = stage_new - 1

local symbol = make_symbol(stage_old):Scale(1.3):Rotate(0):Translate(0, 0.6)
local bg = fs_overlay:Tint(unpack(compute_ui_bg_color(stage_old)))

local done = false
main_scene:Action(function(dt)
    if not done then
        done = true
        return 0.6
    else
        main_scene.child = scene
        return true
    end
end)

scene:Insert(bg)
scene:Insert(symbol)
scene:Insert(game_state.explosion)
game_state.explosion = nil

if stage_new < 6 then
    scene:Action(coroutine.wrap(function(dt)
        coroutine.yield(2.0)
        bg:Tween{red = 1, green = 1, blue = 1, time = 0.1}
        coroutine.yield(0.1)
        symbol.child.child.child = make_symbol(stage_new)
        local col = compute_ui_bg_color(stage_new)
        bg:Tween{red = col[1], green = col[2], blue = col[3], time = 0.1}
        coroutine.yield(0.1)
        return true
    end))
else
    scene:Action(coroutine.wrap(function(dt)
        bg:Tween{red = 0, green = 0, blue = 0, time = 2}
        symbol:Tween{delay = 2, angle = -2800, time = 8.4, easing = "accel"}
        local symbol2 = make_symbol(stage_old):Scale(1.3):Rotate(0):Translate(0, 0.6)
            :Tint(1, 1, 1, 0):BlendMode("add")
        scene:Insert(symbol2)
        symbol2:Tween{delay = 4, alpha = 0.6, time = 2}
        symbol2:Tween{delay = 4, angle = 1800, time = 7.4, easing = "accel"}
        symbol:Tween{delay = 4, scale = 1.5, time = 5}
        symbol2:Tween{delay = 4, scale = 1.5, time = 5}
        coroutine.yield(8.0)
        symbol:Tween{scale = 0, time = 2.6, easing = "zoomin"}
        symbol2:Tween{scale = 0, time = 2.6, easing = "zoomin"}
        coroutine.yield(4.5)
        symbol.child.child.child = make_symbol(stage_new)
        symbol.angle = 0
        local col = compute_ui_bg_color(stage_new)
        bg:Tween{red = col[1], green = col[2], blue = col[3], time = 0.1}
        symbol:Tween{scale = 5, time = 1.2, easing = "zoomout"}
        coroutine.yield(1.2)
        symbol:Tween{scale = 1, time = 3.2, easing = "linear"}
        coroutine.yield(3.2)
        return true
    end))
end

scene:Action(coroutine.wrap(function(dt)
    local congrats = lt.Text("CONGRATULATIONS", font_large, "center", "center"):Scale(0.75):Translate(0, -0.5)
    scene:Insert(congrats)
    --coroutine.yield(1.0)
    local finished = lt.Text(string.upper(stages[stage_id].particle_name) .. " PARTICLE DISCOVERED", font, "center", "center")
        :Scale(0.8):Translate(0, -0.85):Tint(1, 1, 1, 1)
    scene:Insert(finished)
    --finished:Tween{alpha = 1, time = 0.5}
    coroutine.yield(3.5)
    local unlocked
    local i = 1
    while i <= #game_state.unlocks do
        if unlocked then
            unlocked:Tween{alpha = 0, time = 0.3}
            coroutine.yield(0.3)
            scene:Remove(unlocked)
        end
        local s = game_state.unlocks[i]
        unlocked = lt.Text(string.upper(stages[s].particle_name) .. " EXPERIMENT UNLOCKED", font, "center", "center")
            :Scale(0.8):Translate(0, -1.15):Tint(1, 1, 1, 0)
        scene:Insert(unlocked)
        unlocked:Tween{alpha = 1, time = 0.3}
        coroutine.yield(2)
        i = i + 1
    end
    if stage_new >= 6 then
        local research_complete = lt.Text("RESEARCH COMPLETE", font_large, "center", "center")
            :Scale(0.6):Translate(0, -1.2)
        coroutine.yield(14)
        scene:Insert(research_complete)
        coroutine.yield(2)
    end
    local continue_text
    if lt.form_factor == "desktop" then
        continue_text = "PRESS ENTER TO CONTINUE"
    else
        continue_text = "TAP TO CONTINUE"
    end
    local cont = lt.Text(continue_text, font, "center", "center")
        :Scale(0.7):Translate(0, lt.bottom + 0.2):Tint(unpack(config.ui_light_grey))
    scene:Insert(cont)
    scene:KeyDown(function(event)
        if event.key == "enter" or event.key == "space" or event.key == "esc" then
            main_scene.child = old_scene
            import("gameover", game_state)
        end
    end)
    scene:PointerDown(function(event)
        main_scene.child = old_scene
        import("gameover", game_state)
    end)
    return true
end))
