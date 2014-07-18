local toload = ...
clearall()

main_scene.child = lt.Layer()
main_scene.child:Insert(images.how_to_play_wide)
local loading = lt.Text("Loading...", font, "center", "center")
main_scene.child:Insert(loading)

local count = 0
main_scene.child:Action(function(dt)
    if count == 5 then
        import(toload)
    else
        collectgarbage()
        count = count + 1
    end
end)
