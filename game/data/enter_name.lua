local on_done = ...
local old_scene = main_scene.child

local scene = lt.Layer()
scene:Insert(old_scene)
scene:Insert(fs_overlay:Tint(0, 0, 0, 0.9))
main_scene.child = scene

local title = lt.Text("ENTER A USERNAME", font, "center", "center"):Tint(0.8, 0.8, 0.8)
    :Scale(0.8):Translate(0, 0.6)
local subtitle = lt.Text("THIS WILL BE DISPLAYED ON THE PUBLIC LEADERBOARDS", font, "center", "center"):Tint(0.8, 0.8, 0.8)
    :Scale(0.6):Translate(0, 0.4)

local cancel = lt.Text("ESC: CANCEL", font, "left", "bottom"):Tint(0.8, 0.8, 0.8)
    :Scale(0.6):Translate(lt.left + 0.1, lt.bottom + 0.1)
local accept = lt.Text("ENTER: ACCEPT", font, "right", "bottom"):Tint(0.8, 0.8, 0.8)
    :Scale(0.6):Translate(lt.right - 0.1, lt.bottom + 0.1)

local input = lt.Layer()
input:Insert(title)
input:Insert(subtitle)
if lt.os == "android" then
    input = input:Translate(0, 1.2)
end
scene:Insert(input)
if lt.form_factor == "desktop" then
    scene:Insert(accept)
    scene:Insert(cancel)
end

local text_box = lt.Wrap()
local name = ""

local blick = true
local cursor = lt.Rect(-0.02, -0.1, 0.02, 0.1):Tint(1, 1, 1, 1)
    :Action(function(dt, c)
        if blick then
            c.alpha = 1
        else
            c.alpha = 0
        end
        blick = not blick
        return 0.3
    end)
    :Translate(0, 0)

local
function update_text()
    text_box.child = lt.Text(name, font, "center", "center")
    cursor.x = text_box.child.width / 2 + 0.05
end
update_text()

local text_area = lt.Layer(text_box, cursor):Scale(0.6)

if lt.os == "android" then
    text_area = text_area:Scale(1.5)
end
input:Insert(text_area)

local key_map = {
    ["A"] = "A",
    ["B"] = "B",
    ["C"] = "C",
    ["D"] = "D",
    ["E"] = "E",
    ["F"] = "F",
    ["G"] = "G",
    ["H"] = "H",
    ["I"] = "I",
    ["J"] = "J",
    ["K"] = "K",
    ["L"] = "L",
    ["M"] = "M",
    ["N"] = "N",
    ["O"] = "O",
    ["P"] = "P",
    ["Q"] = "Q",
    ["R"] = "R",
    ["S"] = "S",
    ["T"] = "T",
    ["U"] = "U",
    ["V"] = "V",
    ["W"] = "W",
    ["X"] = "X",
    ["Y"] = "Y",
    ["Z"] = "Z",
    ["1"] = "1",
    ["2"] = "2",
    ["3"] = "3",
    ["4"] = "4",
    ["5"] = "5",
    ["6"] = "6",
    ["7"] = "7",
    ["8"] = "8",
    ["9"] = "9",
    ["0"] = "0",
    ["space"] = " ",
}

local
function handle_key(key)
    local chr = key_map[key]
    if chr and #name < 20 then
        name = name .. chr
        update_text()
    elseif key == "del" then
        name = name:sub(1, -2)
        update_text()
    elseif key == "esc" then
        main_scene.child = old_scene
    elseif key == "enter" and #name > 0 then
        main_scene.child = old_scene
        on_done(name)
    end
end

if lt.form_factor == "desktop" then
    scene:KeyDown(function(event)
        log("key pressed " .. event.key)
        handle_key(event.key)
    end)
elseif lt.os == "android" then
    local keyboard = make_keyboard(handle_key)
    scene:Insert(keyboard)
end
