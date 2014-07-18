function make_symbol(stage)
    if stage < 6 then 
        local patterns = {
            {1, 0, 0, 0, 0, 1, 0, 0, 0, 0},
            {1, 2, 0, 0, 0, 1, 2, 0, 0, 0},
            {1, 2, 3, 0, 0, 1, 2, 3, 0, 0},
            {1, 2, 3, 4, 0, 1, 2, 3, 4, 0},
            {1, 2, 3, 4, 5, 1, 2, 3, 4, 5},
        }
        local colors = {
            {212/255, 149/255, 87/255},
            {145/255, 186/255, 87/255},
            {144/255, 119/255, 181/255},
            {77/255,  165/255, 209/255},
            {194/255, 105/255, 105/255},
        }
        
        local p = stage / 5
        local brightness = 1 --p ^ 2 * 0.5 + 0.5
        local flash_rate = (1 - p ^ 2) + 0.05

        local symbol0 = lt.Layer()
        local symbol1 = lt.Layer():Translate(0, 0)
        local symbol2 = lt.Layer():Translate(0, 0)
        local symbol = lt.Layer(symbol1:Tint(1, 1, 1, 0.5):BlendMode("add"), symbol2, symbol0)
        for i = 0, 9 do
            local segment0 = images.symbol_segment:Rotate(i * 36):Tint(unpack(config.ui_dark_blue))
            --[[
            segment0.red = segment0.red * (1-p)
            segment0.green = segment0.green * (1-p)
            segment0.blue = segment0.blue * (1-p)
            ]]
            symbol0:Insert(segment0)

            if stage > 0 and patterns[stage][i + 1] > 0 then
                local segment = images.symbol_segment:Translate(0, 0)
                local color = colors[patterns[stage][i + 1]]
                segment = segment:Rotate(i * 36):Tint(color[1], color[2], color[3], brightness)
                segment:Action(function(dt)
                    if math.random(2) == 1 then
                        segment:Tween{alpha = brightness, time = flash_rate}
                    else
                        segment:Tween{alpha = brightness * 0.6, time = flash_rate}
                    end
                    return math.random() * flash_rate
                end)
                symbol1:Insert(segment)
                symbol2:Insert(segment)
            end
        end

        --[[
        local shift = (p ^ 3) * 0.1
        symbol1:Action(function(dt, s)
            s.x = math.random() * shift - shift / 2
            return 0.05
        end)
        symbol2:Action(function(dt, s)
            s.x = math.random() * (shift / 8) - shift / 16
            return 0.05
        end)
        ]]

        symbol = symbol:Scale(0.5)
        return symbol
    else
        local symbol = lt.Layer()

        local bg_color = fs_overlay:Tint(unpack(compute_ui_bg_color(stage)))

        local boson_bg = images.title_bg:Mesh():Grid(1, 30)
            :Stretch(-1.5, 0, 0, 40, 0, 0, 0, 0, 0)
            :Stretch(1.5, 0, 0, 0, 40, 0, 0, 0, 0)
            --:Rotate(0):Action(function(dt, n)
            --    n.angle = n.angle + 10 * dt                
            --end)
            :Scale(1)
        local portal = make_portal_node():Scale(0.3):BlendMode("add")
        local
        function pulse()
            portal:Tween{scale = math.random() * 0.1 + 0.5, time = math.random() * 0.1 + 0.05,
                action = pulse
            }
        end
        pulse()
        local beam = images.title_beam:Scale(60, 1):Tint(1, 1, 1)

        beam:Action(function(dt)
            if math.random() < 0.3 then
                beam.red = 0.5
                beam.green = 0.5
                beam.blue = 0.5
                boson_bg.scale = 1.3
            else
                beam.red = 1
                beam.green = 1
                beam.blue = 1
                boson_bg.scale = 1.35
            end
        end)

        --symbol:Insert(boson_bg)
        symbol:Insert(boson_bg)
        symbol:Insert(beam)
        symbol:Insert(portal)
        return symbol
    end
end

function make_getready(s)
    local symbol = lt.Layer()
    for i = 0, 9 do
        local segment = images.symbol_segment:Rotate(i * 36)
        symbol:Insert(segment)
    end
    local layer = lt.Layer()
    layer:Insert(symbol:Scale(0.5))
    layer:Insert(lt.Text("PRIMING DETECTOR " .. s .. "\nGET READY!", font, "center", "center"):Scale(1):Translate(0, -1.2))
    return layer:Tint(0.6, 0.6, 0.6):Translate(0, 0.5)
end
