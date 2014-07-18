function make_button1(str, action, dims, off_bg_in, hit_box)
    local off_color = {1, 1, 1}
    local hover_color = {1, 1, 1}
    local down_color = {0, 0, 0}
    local text
    if type(str) == "string" then
        text = lt.Text(str, font, "center", "center")
    else
        text = str
    end
    local w, h
    if not dims then
        w = text.width * 0.8
        h = text.height * 0.8
    else
        w = dims[1]
        h = dims[2]
    end
    if not off_bg_in then
        text = text
            :Scale(0.8):Tint(unpack(off_color))
    end
    local
    function set_color(color)
        if not off_bg_in then
            text.red = color[1]
            text.green = color[2]
            text.blue = color[3]
        end
    end

    local border_x = 0
    local border_y = 0
    if not dims then
        border_x = 0.1
        border_y = 0.05
    end
    local off_bg = off_bg_in and off_bg_in:Wrap() or
        lt.Rect(-w/2 - border_x, -h/2 - border_y, w/2 + border_x, h/2 + border_y):Tint(unpack(config.ui_active_color))
    local left, bottom, right, top
    if not hit_box then
        left, bottom, right, top = -w/2 - border_x, -h/2 - border_y, w/2 + border_x, h/2 + border_y
    else
        left, bottom, right, top = unpack(hit_box)
    end
    if (lt.form_factor == "phone" or lt.form_factor == "tablet") and not off_bg_in then
        local buf = 0.2
        left = left - buf
        bottom = bottom - buf
        right = right + buf
        top = top + buf
    end

    local button
    local button_hover
    local button_down_in
    local button_down_out
    local button_off = off_bg
        :PointerDown(function(event)
            if event.touch + event.button == 1 then
                action()
            end
        end, left, bottom, right, top)
    button = button_off:Wrap()
    local button_layer = lt.Layer(text, button)
    button_layer.text = function(str)
        text.child.child = lt.Text(str, font, "center", "center")
    end
    return button_layer
end

function make_disabled_button(str, dims)
    local off_color = {0.5, 0.5, 0.5}
    local text
    if type(str) == "string" then
        text = lt.Text(str, font, "center", "center")
    else
        text = str
    end
    local w, h
    if not dims then
        w = text.width * 0.8
        h = text.height * 0.8
    else
        w = dims[1]
        h = dims[2]
    end
    text = text
        :Scale(0.8)

    local off_bg = images.button_hover:Mesh()
    local iw2 = images.button_off.width / 2
    local ih2 = images.button_off.height / 2
    local border_x = 0
    local border_y = 0
    if not dims then
        if lt.form_factor == "phone" then
            border_x = 0.2
            border_y = 0.2
        else
            border_x = 0.1
            border_y = 0.05
        end
    end
    off_bg:Grid(3, 3):Stretch(0, 0, 0, w/2 - iw2 + border_x, w/2 - iw2 + border_x,
        h/2 - ih2 + border_y, h/2 - ih2 + border_y, 0, 0)

    return lt.Layer(text, off_bg):Tint(unpack(off_color))
end

if lt.form_factor == "phone" then
    bottom_bar_height = 0.75
else
    bottom_bar_height = 0.65
end
button_bar_mid_y = lt.bottom + bottom_bar_height / 2

function button_bar_overlay()
    return lt.Layer(
        lt.Rect(lt.left, lt.bottom, lt.right, lt.bottom + bottom_bar_height)
            :Tint(unpack(config.ui_light_grey)),
        lt.Rect(lt.left, lt.bottom + bottom_bar_height, lt.right, lt.bottom + bottom_bar_height + 0.01)
            :Tint(unpack(config.ui_dark_blue))
    )
end

function compute_ui_bg_color(stage)
    if stage < 6 then
        --local bg_scale = 1 - (stage) / 5
        --return {config.ui_bg[1] * bg_scale, config.ui_bg[2] * bg_scale, config.ui_bg[3] * bg_scale}
        return config.ui_bg
    else
        return config.ui_bg_complete
    end
end

fs_overlay = lt.Rect(lt.left, lt.bottom, lt.right, lt.top)

ui_bg_overlay = fs_overlay:Tint(unpack(config.ui_bg))

function flash(after, back)
    if back then
        samples.uiback:Play(1, lt.state.sfx_volume)
    else
        samples.uibleep:Play(1, lt.state.sfx_volume)
    end
    main_scene.child = lt.Layer(fs_overlay:BlendMode("off")--[[, main_scene.child]]):Wrap()
    local alt = true
    main_scene.child:Action(function(dt)
        if alt then
            alt = false
            return 0.06
        else
            after()
            return true
        end
    end)
end
