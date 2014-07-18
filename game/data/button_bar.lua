function make_button_bar(buttons)
    local off_color = config.ui_bg
    local on_color = config.ui_active_color
    local gap = 0.4
    local border_x = 0.1
    local border_y = 0.05
    local text_scale = 0.8
    local button_texts = {}
    local total_width = 0
    for i, button in ipairs(buttons) do
        button_texts[i] = lt.Text(button.label, font, "left", "bottom")
        total_width = total_width + button_texts[i].width * text_scale
    end
    total_width = total_width + gap * (#buttons - 1)

    local x = -total_width / 2
    local layer = lt.Layer()
    local button_nodes = {}
    for i, button in ipairs(buttons) do
        local w = button_texts[i].width * text_scale
        local h = button_texts[i].height * text_scale
        local iw2 = images.button_off.width / 2
        local ih2 = images.button_off.height / 2
        local frame = images.button_off:Mesh()
        frame:Grid(3, 3)
             :Stretch(0, 0, 0,
                - iw2 + border_x, w - iw2 + border_x,
                - ih2 + border_y, h - ih2 + border_y, 0, 0)
        local node = button_texts[i]:Scale(text_scale):Tint(unpack(off_color))
        button_nodes[i] = lt.Layer(node)
        button_nodes[i].select = function()
            if not button_nodes[i].selected then
                button_nodes[i]:Insert(frame)
                node.red   = on_color[1]
                node.green = on_color[2]
                node.blue  = on_color[3]
                button_nodes[i].selected = true
            end
        end
        button_nodes[i].unselect = function()
            if button_nodes[i].selected then
                button_nodes[i]:Remove(frame)
                node.red   = off_color[1]
                node.green = off_color[2]
                node.blue  = off_color[3]
                button_nodes[i].selected = false
            end
        end
        button_nodes[i].hide_cursor = function()
            button_nodes[i]:Remove(frame)
        end
        button_nodes[i].show_cursor = function()
            button_nodes[i]:Insert(frame)
        end
        layer:Insert(button_nodes[i]:Translate(x, 0))
        x = x + gap + button_texts[i].width * text_scale
    end

    local selected = 1
    button_nodes[selected].select()

    function layer.right()
        local prev = selected
        selected = math.min(#buttons, selected + 1)
        if selected ~= prev then
            button_nodes[prev].unselect()
            button_nodes[selected].select()
            if buttons[selected].select_action then
                buttons[selected].select_action()
            end
        end
    end

    function layer.left()
        local prev = selected
        selected = math.max(1, selected - 1)
        if selected ~= prev then
            button_nodes[prev].unselect()
            button_nodes[selected].select()
            if buttons[selected].select_action then
                buttons[selected].select_action()
            end
        end
    end

    function layer.enter()
        if buttons[selected].enter_action then
            buttons[selected].enter_action()
        end
    end

    local cursor_is_on = true

    function layer.cursor_off()
        if cursor_is_on then
            button_nodes[selected].hide_cursor()
            cursor_is_on = false
        end
    end

    function layer.cursor_on()
        if not cursor_is_on then
            button_nodes[selected].show_cursor()
            cursor_is_on = true
        end
    end

    return layer
end
