clearall()

local swidth = lt.right - lt.left
local back_button = images.back_arrow:Translate(lt.left + swidth / 6, button_bar_mid_y)
    :PointerDown(function(event)
        flash(function() import("title") end, true)
    end, lt.left, lt.bottom, lt.left + swidth / 3, lt.bottom + bottom_bar_height)
local divider = lt.Rect(lt.left + swidth / 3, lt.bottom, lt.left + swidth / 3 + 0.02, lt.bottom + bottom_bar_height)
    :Tint(unpack(config.ui_active_color))

local slider_w = 2
local grip_w = 0.5
local slider_h = 0.4
local
function make_slider(label, v, update)
    local layer = lt.Layer()
    local bg = lt.Rect(0, 0, slider_w, slider_h):Tint(unpack(config.ui_dark_blue))
    local grip_bg = lt.Rect(0, 0, grip_w, slider_h):Tint(unpack(config.ui_active_color))
    local text = lt.Text(string.format("%d", v * 10), font, "center", "center")
        :Scale(1.2):Translate(grip_w/2, slider_h/2)
    local grip = lt.Layer():Translate(0, 0)
    local label = lt.Text(label, font, "left", "bottom"):Translate(0, slider_h + 0.1)
    grip:Insert(grip_bg)
    grip:Insert(text)
    layer:Insert(label)
    local moving = nil
    local function do_update(event)
        grip.x = event.x - grip_w / 2
        if grip.x > slider_w - grip_w then
            grip.x = slider_w - grip_w
        elseif grip.x < 0 then
            grip.x = 0
        end
        local v = (grip.x) / (slider_w - grip_w)
        update(v)
        text.child.child = lt.Text(string.format("%d", v * 10), font, "center", "center")
    end
    do_update({x = v * (slider_w - grip_w) + grip_w/2})
    layer:PointerDown(function(event)
        if event.touch + event.button ~= 1 then return false end
        do_update(event)
        moving = true
    end, 0, 0, slider_w, slider_h)
    layer:PointerMove(function(event)
        if not moving then return false end
        do_update(event)
    end)
    layer:PointerUp(function(event)
        if moving and event.touch + event.button == 1 then
            moving = nil
        else
            return false
        end
    end)
    layer:Insert(bg)
    layer:Insert(grip)
    return layer
end

local toggle_w = 1.4

local
function make_toggle(label, v, update)
    local layer = lt.Layer()
    local grip_w = toggle_w / 2
    local bg = lt.Rect(0, 0, toggle_w, slider_h):Tint(unpack(config.ui_dark_blue))
    local grip_bg = lt.Rect(0, 0, grip_w, slider_h):Tint(unpack(config.ui_active_color))
    local text = lt.Text(v and "ON" or "OFF", font, "center", "center")
        :Scale(1.2):Translate(grip_w/2, slider_h/2)
    local grip = lt.Layer():Translate(0, 0)
    local label = lt.Text(label, font, "left", "bottom"):Translate(0, slider_h + 0.1)
    grip:Insert(grip_bg)
    grip:Insert(text)
    layer:Insert(label)
    local function do_update(v)
        local x
        if v then
            grip.x = toggle_w - grip_w
        else
            grip.x = 0
        end
        update(v)
        text.child.child = lt.Text(v and "ON" or "OFF", font, "center", "center")
    end
    do_update(v)
    layer:PointerDown(function(event)
        v = not v
        do_update(v)
        samples.uibleep:Play(1, lt.state.sfx_volume)
    end, 0, 0, toggle_w, slider_h)
    layer:Insert(bg)
    layer:Insert(grip)
    return layer
end

local
function make_prof_toggle()
    local layer = lt.Layer()
    local bg = lt.Rect(0, 0, slider_w, slider_h):Tint(unpack(config.ui_active_color))
    local text = lt.Text("ERIK", font, "center", "center")
        :Scale(1.2):Translate(slider_w/2, slider_h/2)
    local
    function update_txt()
        local txt
        if lt.state.prof_gender == "man" then
            txt = "ERIK"
        else
            txt = "NIVA"
        end
        text.child.child = lt.Text(txt, font, "center", "center")
    end
    update_txt()
    local label = lt.Text("PROFESSOR", font, "left", "bottom"):Translate(0, slider_h + 0.1)
    layer:PointerDown(function(event)
        if lt.state.prof_gender == "man" then
            lt.state.prof_gender = "woman"
        else
            lt.state.prof_gender = "man"
        end
        player_frames.images = nil
        update_txt()
        samples.uibleep:Play(1, lt.state.sfx_volume)
        collectgarbage()
    end, 0, 0, slider_w, slider_h)
    layer:Insert(bg)
    layer:Insert(label)
    layer:Insert(text)
    return layer
end

local music_slider = make_slider("MUSIC", lt.state.music_volume, function(v)
    lt.state.music_volume = v
end)

local sfx_slider = make_slider("SFX", lt.state.sfx_volume, function(v)
    lt.state.sfx_volume = v
end)

local tutorial_toggle = make_toggle("TUTORIAL", not lt.state.tutorial_complete, function(v)
    lt.state.tutorial_complete = not v
end)

local prof_toggle = make_prof_toggle()

main_scene.child = lt.Layer(
    music_slider:Translate(-0.3 - slider_w, 0.7),
    sfx_slider:Translate(0.3, 0.7),
    tutorial_toggle:Translate(-0.3 - slider_w, -0.5),
    prof_toggle:Translate(0.3, -0.5),
    back_button,
    divider,
    button_bar_overlay(),
    fs_overlay:Tint(unpack(config.ui_bg))
)

