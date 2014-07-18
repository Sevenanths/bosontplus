clearall()

local stage = compute_progress()
local symbol = make_symbol(stage):Translate(0, 1)
local bg = fs_overlay:Tint(unpack(compute_ui_bg_color(stage)))

local title = images.title_boson_x:Translate(0, 0.1)

local status = lt.Layer()
local discovered_color = config.ui_active_color
local discovered_text = "STATUS: UNDISCOVERED"
if lt.state.stage_finished[num_stages] then
    discovered_color = {20/255, 200/255, 200/255}
    discovered_text = "STATUS: DISCOVERED"
end
local status_text = lt.Text(discovered_text, font, "left", "center")
local status_text_scale = 0.6
local status_text_width = status_text.width * status_text_scale
local status_rect_width = 0.1
local status_buf = 0.05
local status_rect_x = -(status_text_width + status_rect_width + status_buf) / 2
local status_text_x = status_rect_x + status_rect_width + status_buf
status:Insert(lt.Rect(0, -0.04, status_rect_width, 0.05):Tint(unpack(discovered_color)):Translate(status_rect_x, 0))
status:Insert(lt.Text(discovered_text, font, "left", "center")
    :Scale(status_text_scale):Translate(status_text_x, 0):Tint(unpack(config.ui_light_grey)))

local start_screen = lt.Layer(title, status:Translate(0, -0.20), symbol)
local copyright_y = lt.bottom + 1.05
if lt.form_factor ~= "desktop" then
    copyright_y = lt.bottom + 0.9
end
start_screen:Insert(lt.Text("COPYRIGHT 2013 IAN MACLARTY & JON KERNEY", font, "center", "center")
    :Scale(0.4):Tint(unpack(config.ui_light_grey)):Translate(0, copyright_y))
if lt.form_factor ~= "desktop" then
    start_screen:Insert(lt.Text("TAP TO START", font_large, "center", "center")
        :Scale(0.5):Translate(0, -0.65):Tint(1, 1, 1)
        :Action(function(dt, n)
            if n.alpha > 0.5 then
                n.alpha = 0
            else
                n.alpha = 1
            end
            return 0.4
        end))
end

if lt.form_factor == "desktop" then
    start_screen = start_screen:Translate(0, -0.2)
else
    start_screen = start_screen:Translate(0, 0.0)
end

--[[
if lt.form_factor == "desktop" then
    start_screen:Insert(
        lt.Text("PRESS ENTER TO START", font_large, "center", "center"):Tint(1, 1, 1)
        :Scale(0.6):Translate(0, -0.7)
        :Action(function(dt, n)
            if n.alpha > 0.5 then
                n.alpha = 0
            else
                n.alpha = 1
            end
            return 0.4
        end)
    )
end
]]

local active_area = "button_bar"

local content_area = start_screen:Wrap()

local options_screen = lt.Layer()

local options_scale = 0.7

local options_cursor = lt.Rect(-0.05, -0.04, 0.05, 0.05):Translate(-0.12, 0)

-- reset 

local reset_option = lt.Layer(
    lt.Text("RESET", font, "left", "center"):Scale(options_scale))
    :Tint(1, 1, 1)

local confirm_dialog = nil

function reset_option.enter()
    confirm_dialog = lt.Layer()
    confirm_dialog:Insert(fs_overlay:Tint(0, 0, 0, 0.9))
    confirm_dialog:Insert(lt.Rect(-1.2, -0.3, 1.2, 0.3):Tint(unpack(config.ui_dark_blue)))
    confirm_dialog:Insert(lt.Text("RESET GAME\nARE YOU SURE? (Y/N)", font, "center", "center"):Scale(0.6))
    main_scene:Insert(confirm_dialog)
    samples.uibleep:Play(1, lt.state.sfx_volume)
end

-- professor 

local professor_text = lt.Text("PROFESSOR: ERIK", font, "left", "center"):Scale(options_scale)
local professor_option = lt.Layer(professor_text):Tint(1, 1, 1)
local
function update_professor_option()
    local txt
    if lt.state.prof_gender == "man" then
        txt = "PROFESSOR: ERIK"
    else
        txt = "PROFESSOR: NIVA"
    end
    professor_text.child = lt.Text(txt, font, "left", "center")
end
update_professor_option()
function professor_option.enter()
    if lt.state.prof_gender == "man" then
        lt.state.prof_gender = "woman"
    else
        lt.state.prof_gender = "man"
    end
    update_professor_option()
    samples.uibleep:Play(1, lt.state.sfx_volume)
    player_frames.images = nil
    collectgarbage()
end
professor_option.left = professor_option.enter
professor_option.right = professor_option.enter

-- tutorial 

local tutorial_text = lt.Text("TUTORIAL: OFF", font, "left", "center"):Scale(options_scale)
local tutorial_option = lt.Layer(tutorial_text):Tint(1, 1, 1)
local
function update_tutorial_option()
    local txt
    if lt.state.tutorial_complete then
        txt = "TUTORIAL: OFF"
    else
        txt = "TUTORIAL: ON"
    end
    tutorial_text.child = lt.Text(txt, font, "left", "center")
end
update_tutorial_option()
function tutorial_option.enter()
    lt.state.tutorial_complete = not lt.state.tutorial_complete
    update_tutorial_option()
    samples.uibleep:Play(1, lt.state.sfx_volume)
end
tutorial_option.left = tutorial_option.enter
tutorial_option.right = tutorial_option.enter

-- fullscreen 

local fullscreen_text = lt.Text("FULLSCREEN: " .. (lt.state.fullscreen and "ON" or "OFF"), font, "left", "center"):Scale(options_scale)
local fullscreen_option = lt.Layer(fullscreen_text):Tint(1, 1, 1)
function fullscreen_option.enter()
    samples.uibleep:Play(1, lt.state.sfx_volume)
    lt.state.fullscreen = not lt.state.fullscreen
    lt.SetShowMouseCursor(not lt.state.fullscreen)
    lt.SetFullScreen(lt.state.fullscreen)
end
fullscreen_option.left = fullscreen_option.enter
fullscreen_option.right = fullscreen_option.enter

-- music volume 

local music_text = lt.Text("MUSIC: 100%", font, "left", "center"):Scale(options_scale)
local music_option = lt.Layer(music_text):Tint(1, 1, 1)
local
function update_music_option()
    local txt = "MUSIC: " .. string.format("%.0f%%", lt.state.music_volume * 100)
    music_text.child = lt.Text(txt, font, "left", "center")
end
update_music_option()
function music_option.left()
    lt.state.music_volume = math.max(0, lt.state.music_volume - 0.1)
    update_music_option()
    samples.uibleep:Play(1, lt.state.music_volume)
end
function music_option.right()
    lt.state.music_volume = math.min(1, lt.state.music_volume + 0.1)
    update_music_option()
    samples.uibleep:Play(1, lt.state.music_volume)
end

-- sfx volume 

local sfx_text = lt.Text("SFX: 100%", font, "left", "center"):Scale(options_scale)
local sfx_option = lt.Layer(sfx_text):Tint(1, 1, 1)
local
function update_sfx_option()
    local txt = "SFX: " .. string.format("%.0f%%", lt.state.sfx_volume * 100)
    sfx_text.child = lt.Text(txt, font, "left", "center")
end
update_sfx_option()
function sfx_option.left()
    lt.state.sfx_volume = math.max(0, lt.state.sfx_volume - 0.1)
    update_sfx_option()
    samples.uibleep:Play(1, lt.state.sfx_volume)
end
function sfx_option.right()
    lt.state.sfx_volume = math.min(1, lt.state.sfx_volume + 0.1)
    update_sfx_option()
    samples.uibleep:Play(1, lt.state.sfx_volume)
end

--

local button_bar

local option_i = 0
local options = {music_option, sfx_option, fullscreen_option, professor_option, tutorial_option, reset_option}

local
function prev_option()
    if option_i > 0 then
        options[option_i]:Remove(options_cursor)
        options[option_i].red = 1
        options[option_i].green = 1
        options[option_i].blue = 1
    end
    option_i = option_i + 1
    if option_i <= #options then
        options[option_i]:Insert(options_cursor)
        options[option_i].red = config.ui_active_color[1]
        options[option_i].green = config.ui_active_color[2]
        options[option_i].blue = config.ui_active_color[3]
    else
        option_i = 0
        active_area = "button_bar"
        button_bar.cursor_on()
    end
    samples.uibleep:Play(1, lt.state.sfx_volume)
end

local
function next_option()
    if option_i > 0 then
        options[option_i]:Remove(options_cursor)
        options[option_i].red = 1
        options[option_i].green = 1
        options[option_i].blue = 1
        option_i = option_i - 1
    else
        option_i = #options
    end
    if option_i > 0 then
        options[option_i]:Insert(options_cursor)
        options[option_i].red = config.ui_active_color[1]
        options[option_i].green = config.ui_active_color[2]
        options[option_i].blue = config.ui_active_color[3]
    else
        active_area = "button_bar"
        button_bar.cursor_on()
    end
    samples.uibleep:Play(1, lt.state.sfx_volume)
end


local about_screen = lt.Layer()

local y_os = 0.08
local x_os = -0.15
about_screen:Insert(lt.Text("GAME BY MU & HEYO:", font, "left", "top"):Scale(0.5):Translate(-1 + x_os, 0.95 + y_os)
    :Tint(unpack(config.ui_active_color)))
about_screen:Insert(lt.Text("    IAN MACLARTY\n    JON KERNEY", font, "left", "top")
    :Scale(0.45):Translate(-1 + x_os, 0.80 + y_os))
about_screen:Insert(lt.Text("    @MUCLORTY\n    @JONKERNEY", font, "left", "top")
    :Scale(0.45):Translate(0.2 + x_os, 0.80 + y_os))
local playtesters = [[
    MARK JOHNSON
    STEVE HALL
    BETHANY WILKSCH
    TANYA WILDING
    SIMON JOSLIN
    HARRY LEE
    BEN GREIG
    MICHAEL BEECH
    JAMES MACPHERSON]]
local twitters = [[
    @INFLAPPABLEMRAK

    @BETHANYWILKSCH

    @SIMONJOSLIN
    @LEEHSL
    @BENJIGREIG
    @BEECHDESIGN]]
about_screen:Insert(lt.Text("THANKS TO:", font, "left", "top")
    :Scale(0.5):Translate(-1 + x_os, 0.50 + y_os)
    :Tint(unpack(config.ui_active_color)))
about_screen:Insert(lt.Text(playtesters, font, "left", "top")
    :Scale(0.45):Translate(-1 + x_os, 0.35 + y_os))
about_screen:Insert(lt.Text(twitters, font, "left", "top")
    :Scale(0.45):Translate(0.2 + x_os, 0.35 + y_os))

do
    local about_bottom = -0.70
    local about_top = 1.24
    about_screen:Insert(lt.Rect(-1.3, about_bottom, 1.3, about_bottom + 0.01))
    about_screen:Insert(lt.Rect(-1.3, about_top, 1.3, about_top - 0.01))
end

about_screen:Insert(lt.Text("WWW.MUANDHEYO.COM", font, "center", "center")
    :Scale(0.4):Tint(unpack(config.ui_light_grey)):Translate(0, lt.bottom + 1.05 - 0.2))

--

do
    local y = -0.15
    local x = -0.7
    for i = 1, #options do
        options_screen:Insert(options[i]:Translate(x, y))
        y = y + 0.2
    end

    local options_bottom = -0.70
    local options_top = 1.24
    options_screen:Insert(lt.Rect(-1.3, options_bottom, 1.3, options_bottom + 0.01))
    options_screen:Insert(lt.Rect(-1.3, options_top, 1.3, options_top - 0.01))
end

local buttons_y = button_bar_mid_y - 0.08
if lt.form_factor ~= "desktop" then
    buttons_y = button_bar_mid_y
end

if lt.form_factor == "desktop" then
    button_bar = make_button_bar({
        {
            label = "START",
            select_action = function()
                samples.uibleep:Play(1, lt.state.sfx_volume)
                content_area.child = start_screen
            end,
            enter_action = function()
                samples.uibleep:Play(1, lt.state.sfx_volume)
                import("stage_select")
            end
        },
        {
            label = "OPTIONS",
            select_action = function()
                samples.uibleep:Play(1, lt.state.sfx_volume)
                content_area.child = options_screen
            end
        },
        {
            label = "ABOUT",
            select_action = function()
                samples.uibleep:Play(1, lt.state.sfx_volume)
                content_area.child = about_screen
            end
        },
    })
else
    local w = lt.right - lt.left
    local left_x = w / 6 + lt.left
    local right_x = lt.right - w / 6
    local img
    if lt.os == "ios" then
        img = images.gamecenter
    else
        img = images.leaderboard_icon
    end
    local gamecenter_button = img:Translate(left_x, 0):Tint(1, 1, 1):Action(function(dt, n)
        if lt.GameCenterAvailable() or lt.os ~= "ios" then
            n.red = 1
            n.alpha = 1
        else
            n.red = 0.6
            n.alpha = 0.6
        end
        return 0.5
    end)
    local settings_button = images.settings:Translate(0, 0)
    local info_button = images.info:Translate(right_x, 0)
    button_bar = lt.Layer()
    button_bar:Insert(settings_button)
    button_bar:Insert(gamecenter_button)
    button_bar:Insert(info_button)

    local bw = 0.02
    local h2 = bottom_bar_height / 2
    local bl = w / 3 + lt.left
    local br = lt.right - w / 3
    button_bar:Insert(lt.Rect(bl, -h2, bl + bw, h2)
        :Tint(unpack(config.ui_active_color)))
    button_bar:Insert(lt.Rect(br, -h2, br + bw, h2)
        :Tint(unpack(config.ui_active_color)))
end


main_scene.child = lt.Layer(
    button_bar:Translate(0, buttons_y),
    button_bar_overlay(),
    content_area,
    bg
):KeyDown(function(event)
    if confirm_dialog then
        if event.key == "Y" then
            samples.uibleep:Play(1, lt.state.sfx_volume)
            reset_game()
            import "title"
        else
            samples.uiback:Play(1, lt.state.sfx_volume)
            main_scene.child:Remove(confirm_dialog)
            confirm_dialog = nil
        end
    else
        if event.key == "esc" then
            samples.uiback:Play(1, lt.state.sfx_volume)
            lt.Quit()
        elseif active_area == "button_bar" then
            if event.key == "left" then
                button_bar.left()
            elseif event.key == "right" then
                button_bar.right()
            elseif event.key == "enter" then
                button_bar.enter()
            elseif (event.key == "up" or event.key == "down") and content_area.child == options_screen then
                active_area = "options"
                button_bar.cursor_off()
                if event.key == "up" then
                    prev_option()
                elseif event.key == "down" then
                    next_option()
                end
            end
        elseif active_area == "options" then
            local current_option = options[option_i]
            if event.key == "left" then
                if current_option.left then
                    current_option.left()
                end
            elseif event.key == "right" then
                if current_option.right then
                    current_option.right()
                end
            elseif event.key == "enter" then
                if current_option.enter then
                    current_option.enter()
                end
            elseif event.key == "up" then
                prev_option()
            elseif event.key == "down" then
                next_option()
            end
        end
        
        --[[
        elseif event.key == "R" then
        elseif event.key == "F" then
            lt.state.fullscreen = not lt.state.fullscreen
            lt.SetShowMouseCursor(not lt.state.fullscreen)
            lt.SetFullScreen(lt.state.fullscreen)
        end
        ]]
    end
end)
:PointerDown(function(event)
    if lt.form_factor == "desktop" then
        return
    end
    if event.y > lt.bottom + bottom_bar_height then
        flash(function() import("stage_select") end)
    else
        local w = lt.right - lt.left
        local l = w / 3 + lt.left
        local r = lt.right - w / 3
        if event.x < l then
            if lt.os == "android" then
                if lt.state.username == nil then
                    import("enter_name", function(name)
                        lt.state.username = name
                        lt.state.online = true
                        import("leaderboard", 1)
                    end)
                else
                    lt.state.online = true
                    import("leaderboard", 1)
                end
            elseif lt.GameCenterAvailable() then
                samples.uibleep:Play(1, lt.state.sfx_volume)
                lt.ShowLeaderboard("bosonx.stage1")
            end
        elseif event.x < r then
            flash(function() import("options") end)
        else
            flash(function() import("about") end)
        end
    end
end)

if lt.form_factor == "desktop" then
    local commands_txt = "ESC: QUIT"
    local commands = lt.Text(commands_txt, font, "left", "bottom"):Tint(unpack(config.ui_bg))
        :Scale(0.6):Translate(lt.left + 0.1, lt.bottom + 0.1)
    main_scene.child:Insert(commands)

    local msg = [[v1.0.5]]

    local msg_text = lt.Text(msg, font, "right", "bottom"):Tint(unpack(config.ui_bg))
        :Scale(0.4):Translate(lt.right - 0.1, lt.bottom + 0.1)
    main_scene.child:Insert(msg_text)
else
    
end
