function generate_hlightning(length)
    local lightning_frames = {}

    -- generate frames
    local num_frames = 20
    for i = 1, num_frames do
        local verts = {}   
        local x = -length
        local red = 1
        while x <= length do
            local y1 = math.random() * 2 - 0.8
            local y2 = y1 - math.random() * 0.6 - 0.2
            local z1 = math.random() * 30 - 15
            local z2 = z1 - 10
            table.append(verts,
                {{x, y1, z1, 1, math.random() * 0.5 + 0.5, math.random() * 0.5 + 0.5, 1},
                 {x, y2, z2, 1, math.random() * 0.5 + 0.5, math.random() * 0.5 + 0.5, 1}})
            x = x + math.random() + 2
        end
        local lightning_node = lt.DrawVector(lt.Vector(verts), "triangle_strip", 3, 4)
        table.insert(lightning_frames, lightning_node)
    end

    local lightning1 = lt.Wrap(lightning_frames[1])
    local lightning2 = lt.Wrap(lightning_frames[1])
    lightning1:Action(function(dt)
        lightning1.child = lightning_frames[math.random(num_frames)]
        return math.random() * 0.05 + 0.01
    end)
    lightning2:Action(function(dt)
        lightning2.child = lightning_frames[math.random(num_frames)]
        return 0.05
    end)

    return lt.Layer(lightning1, lightning2)
end
