clearall()

local swidth = lt.right - lt.left
local back_button = images.back_arrow:Translate(lt.left + swidth / 6, button_bar_mid_y)
    :PointerDown(function(event)
        flash(function() import("title") end, true)
    end, lt.left, lt.bottom, lt.left + swidth / 3, lt.bottom + bottom_bar_height)
local divider = lt.Rect(lt.left + swidth / 3, lt.bottom, lt.left + swidth / 3 + 0.02, lt.bottom + bottom_bar_height)
    :Tint(unpack(config.ui_active_color))

local about_screen = lt.Layer()

local y_os = 0.08
local x_os = -0.15
about_screen:Insert(lt.Text("GAME BY MU & HEYO:", font, "left", "top")
    :Tint(unpack(config.ui_active_color)):Scale(0.5):Translate(-1.1 + x_os, 0.95 + y_os))
about_screen:Insert(lt.Text("    IAN MACLARTY\n    JON KERNEY", font, "left", "top")
    :Scale(0.45):Translate(-1.1 + x_os, 0.80 + y_os))
about_screen:Insert(lt.Text("    @MUCLORTY\n    @JONKERNEY", font, "left", "top")
    :Scale(0.45):Translate(0.3 + x_os, 0.80 + y_os))
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
    :Tint(unpack(config.ui_active_color)):Scale(0.5):Translate(-1.1 + x_os, 0.50 + y_os))
about_screen:Insert(lt.Text(playtesters, font, "left", "top")
    :Scale(0.45):Translate(-1.1 + x_os, 0.35 + y_os))
about_screen:Insert(lt.Text(twitters, font, "left", "top")
    :Scale(0.45):Translate(0.3 + x_os, 0.35 + y_os))

about_screen:Insert(lt.Text("WWW.MUANDHEYO.COM", font, "center", "center")
    :Scale(0.4):Tint(unpack(config.ui_light_grey)):Translate(0, -0.8))

main_scene.child = lt.Layer(
    about_screen:Scale(1.4):Translate(0, 0.1),
    back_button,
    divider,
    button_bar_overlay(),
    fs_overlay:Tint(unpack(config.ui_bg))
)
