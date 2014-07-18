local game_state = ...

local swidth = lt.right - lt.left

if not game_state then
    game_state = { score = 0.97, stage_id = 1 }
end
local particle_trace = gen_particle_trace(game_state)

local stage_id = game_state.stage_id
local score = game_state.score

local experiment_no = lt.state.games_played


local prev_best = record_new_score(score, stage_id)

lt.SaveState()

local label = "AGAIN"
if game_state.stages_unlocked then
    label = "SELECT EXPERIMENT"
end
local
function retry()
    if game_state.stages_unlocked then
        samples.uibleep:Play(1, lt.state.sfx_volume)
        import("stage_select")
    else
        play(stage_id, game_state.music)
    end
end

local restart_button
if lt.form_factor == "desktop" then
    restart_button = lt.Text("ENTER: " .. label, font, "right", "bottom"):Tint(unpack(config.ui_bg))
        :Scale(0.8):Translate(lt.right - 0.1, lt.bottom + 0.1)
else
    local img = images.retry
    if game_state.stages_unlocked then
        img = images.back_arrow:Scale(-1, 1)
    end
    local retry_img = img:Translate(lt.right - swidth / 4, button_bar_mid_y)
    local divider = lt.Rect(lt.right - swidth / 2, lt.bottom, lt.right - swidth / 2 - 0.02, lt.bottom + bottom_bar_height)
        :Tint(unpack(config.ui_active_color))

    restart_button = lt.Layer(retry_img, divider)
        :PointerDown(retry,
            lt.right - swidth / 2, lt.bottom, lt.right, lt.bottom + bottom_bar_height)
        :PointerDown(retry,
            lt.left, lt.bottom + bottom_bar_height, lt.right, lt.top)
end

local online_button
local update_online_button
if lt.form_factor == "desktop" then
    online_button = lt.Layer():Tint(unpack(config.ui_bg))
        :Scale(0.6):Translate(lt.left + 0.1, lt.bottom + 0.24)
    function update_online_button()
        local msg = "O: GO ONLINE"
        if lt.state.online then
            msg = "O: GO OFFLINE"
        end
        online_button.child.child.child = lt.Text(msg, font, "left", "bottom")
    end
    update_online_button()
end

local abandon_button
if lt.form_factor == "desktop" then
    abandon_button = lt.Text("ESC:BACK", font, "left", "bottom"):Tint(unpack(config.ui_bg))
        :Scale(0.6):Translate(lt.left + 0.1, lt.bottom + 0.1)
else
    local back_img = images.back_arrow:Translate(lt.left + swidth / 8, button_bar_mid_y)
    local divider = lt.Rect(lt.left + swidth / 4, lt.bottom, lt.left + swidth / 4 + 0.02, lt.bottom + bottom_bar_height)
        :Tint(unpack(config.ui_active_color))
    abandon_button = lt.Layer(back_img, divider)
        :PointerDown(function(event)
            flash(function() import("stage_select") end, true)
        end, lt.left, lt.bottom, lt.left + swidth / 4, lt.bottom + bottom_bar_height)
end

local leaderboard_wrap = lt.Wrap()

local
function refresh_leaderboard()
    local leaderboard = lt.Layer()

    local
    function render_neighbourhood()
        local y = 0
        local rank_x, name_x, score_x = 0, 1.2, 6.9
        local nbh = lt.state.score_neighbourhood[stage_id]
        if nbh then
            local user_pos, start, finish
            for p, row in ipairs(nbh) do
                if row.is_user then
                    user_pos = p
                    break
                end
            end
            if not user_pos then return end
            start = user_pos - 2
            if start < 1 then
                start = 1
            end
            finish = start + 4
            if finish > #nbh then
                finish = #nbh
                start = math.max(1, finish - 4)
            end
            for p = start, finish do
                local row = nbh[p]
                local row_layer = lt.Layer()
                row_layer:Insert(lt.Text(row.rank .. ".", font, "left", "top"):Translate(rank_x, 0))
                row_layer:Insert(lt.Text(row.name, font, "left", "top"):Translate(name_x, 0))
                row_layer:Insert(lt.Text(string.format("%.2f%%", row.score), font, "right", "top"):Translate(score_x, 0))
                if row.is_user then
                    row_layer = row_layer:Tint(0.5, 1, 1)
                else
                    row_layer = row_layer:Tint(unpack(config.ui_light_grey))
                end
                leaderboard:Insert(row_layer:Translate(0, y))
                y = y - 0.22
            end
        end
    end

    local
    function submit_score()
        local data = {
            userid = lt.state.userid,
            name = lt.state.username,
            score = tostring(score * 100),
            stage = stage_id,
        }
        if data.userid then
            data.check = lt.Secret(data.score .. " " .. data.stage .. " " .. data.userid)
        else
            data.check = lt.Secret(data.score .. " " .. data.stage .. " " .. data.name)
        end
        --log(leaderboards_url)
        --log(lt.ToJSON(data))
        local loading_text = lt.Text("LOADING SCORES...", font, "left", "top")
            :Translate(0, -0.1):Tint(unpack(config.ui_light_grey))
        leaderboard:Insert(loading_text)
        local msg = lt.ToJSON(data)
        local req = lt.HTTPRequest(leaderboards_url, msg)
        leaderboard:Action(function(dt)
            req:Poll()
            --log("poll")
            if req.success then
                --log(req.response)
                local result = lt.FromJSON(req.response)
                if result then
                    lt.state.userid = result.userid
                    lt.state.score_neighbourhood[stage_id] = result.neighbourhood
                    leaderboard:Remove(loading_text)
                    render_neighbourhood()
                    lt.state.last_leaderboard_update_time[stage_id] = os.time()
                    return true
                else
                    leaderboard:Remove(loading_text)
                    log("Bad response: " .. req.response)
                    leaderboard:Remove(loading_text)
                    leaderboard:Insert(lt.Text("CONNECTION ERROR", font, "left", "top")
                        :Translate(0, -0.1):Tint(unpack(config.ui_light_grey)))
                end
                return true
            elseif req.failure then
                log("Failed to submit score: " .. req.error)
                leaderboard:Remove(loading_text)
                leaderboard:Insert(lt.Text("CONNECTION ERROR", font, "left", "top")
                    :Translate(0, -0.1):Tint(unpack(config.ui_light_grey)))
                return true
            end
            return 0.2
        end)
    end

    local
    function get_nbh_score(nbh)
        for _, row in ipairs(nbh) do
            if row.is_user then
                return row.score
            end
        end
        return 0
    end

    if lt.form_factor == "desktop" then
        local scale
        if lt.state.online then
            local nbh = lt.state.score_neighbourhood[stage_id]
            local refresh_period = 300

            if score > prev_best or not nbh or #nbh == 0 or (get_nbh_score(nbh) + 0.00001) < (score * 100) or
                os.difftime(os.time(), lt.state.last_leaderboard_update_time[stage_id]) > refresh_period
            then
                --log("REFRESHING")
                submit_score()
            else
                render_neighbourhood()
            end
            scale = 0.4
        else
            leaderboard:Insert(lt.Text("LEADERBOADS OFFLINE\nPRESS [O] TO GO ONLINE", font, "left", "top")
                :Translate(0, -0.1):Tint(unpack(config.ui_light_grey)))
            scale = 0.45
        end
        leaderboard_wrap.child = leaderboard:Scale(scale):Translate(-2.7, -0.4)
    end
end


local gamecenter_button
if lt.form_factor ~= "desktop" then
    local img
    if lt.os == "ios" then
        img = images.gamecenter
    else
        img = images.leaderboard_icon
    end
    local img = img:Translate(lt.left + swidth * (3/8), button_bar_mid_y)
    gamecenter_button = img
        :Tint(1, 1, 1):Action(function(dt, n)
                if lt.GameCenterAvailable() or lt.os ~= "ios" then
                    n.red = 1
                    n.alpha = 1
                else
                    n.red = 0.6
                    n.alpha = 0.6
                end
                return 0.5
            end)
        :PointerDown(function(event)
            if lt.GameCenterAvailable() and lt.io == "ios" then
                samples.uibleep:Play(1, lt.state.sfx_volume)
                lt.ShowLeaderboard("bosonx.stage" .. stage_id)
            elseif lt.os == "android" then
                samples.uibleep:Play(1, lt.state.sfx_volume)
                if lt.state.username == nil then
                    import("enter_name", function(name)
                        lt.state.username = name
                        lt.state.online = true
                        import("leaderboard", stage_id)
                    end)
                else
                    lt.state.online = true
                    import("leaderboard", stage_id)
                end
            end
        end, lt.left + swidth / 4, lt.bottom, lt.left + swidth / 4 + swidth / 4, lt.bottom + bottom_bar_height)
end

local
function text_writer(text)
    local pos = 1
    local len = text:len()
    return lt.Wrap(lt.Layer()):Action(function(dt, node)
        pos = pos + 2
        node.child = lt.Text(text:sub(1, pos), font, "left", "bottom")
        if pos > len then
            return true
        else
            return 0.06
        end
    end)
end


local graph
do
    local max = math.max(1, prev_best, score)
    local graph_points = {}
    local graph_width = 2.8
    local graph_height = 1.1
    if lt.form_factor == "desktop" then
        graph_height = 0.65
    end
    local x = 0
    local dx = graph_width / (config.score_history_size - 1)
    for i = 1, config.score_history_size do
        local score = lt.state.score_history[stage_id][i] or 0
        if score > max then
            max = score
        end
    end
    max = math.ceil(max * 2) * 0.5
    for i = 1, config.score_history_size - 1 do
        if lt.state.score_history[stage_id][i + 1] then
            local y1 = (lt.state.score_history[stage_id][i] / max) * graph_height
            local y2 = (lt.state.score_history[stage_id][i + 1] / max) * graph_height
            table.append(graph_points, {
                {x, y1,      1, 1, 1, 1},
                {x + dx, y2, 1, 1, 1, 1}
            })
            x = x + dx
        end
    end
    local y = (math.max(prev_best, score) / max) * graph_height
    table.append(graph_points, {
        {0, y,           0, 1, 1, 1},
        {graph_width, y, 0, 1, 1, 1},
    })
    local label_top = lt.Text(string.format("%d%%", max * 100), font, "left", "bottom"):Scale(0.4)
        :Translate(0.02, graph_height + 0.00)
        :Tint(unpack(config.ui_light_grey))
    local label_bottom = lt.Text("0%", font, "left", "top"):Scale(0.4)
        :Translate(0.02, -0.00)
        :Tint(unpack(config.ui_light_grey))
    local buffer = 0.0
    graph = lt.Layer(
        label_top,
        label_bottom,
        lt.DrawVector(lt.Vector(graph_points), "lines", 2, 3),
        lt.Rect(-buffer, -buffer, graph_width + buffer, graph_height + buffer):Tint(0.9, 0.9, 0.9, 0.2)
    ):Translate(-2.7, -0.7 + (1.1 - graph_height))
end

if lt.form_factor == "desktop" then
    refresh_leaderboard()
end

local score_text = lt.Text(string.format("%0.2f%%", score * 100), digits, "left", "top")
local prev_best_text = lt.Text(string.format("%0.2f%%", prev_best * 100), font, "left", "bottom")

local notches1 = lt.Layer()
local num_notches1 = 50
notches1:Action(function(dt, node)
    if num_notches1 > 0 then
        local a1 = math.random() * 360
        local a2 = a1 + (math.random() * 60 - 30)
        notches1:Insert(images.detector_notch1:Rotate(a1):Tween{angle = a2, time = 0.5})
        num_notches1 = num_notches1 - 1
        return 0.02
    else
        return true
    end
end)
notches1 = notches1:Translate(0, 0.01)

local notches2 = lt.Layer()
local num_notches2 = 20
notches1:Action(function(dt, node)
    if num_notches2 > 0 then
        local a1 = math.random() * 360
        local a2 = a1 + (math.random() * 60 - 30)
        notches2:Insert(images.detector_notch2:Rotate(a1):Tween{angle = a2, time = 0.5})
        num_notches2 = num_notches2 - 1
        return 0.05
    else
        return true
    end
end)
notches2 = notches2:Translate(0, 0.01)

particle_trace = lt.Layer(
    particle_trace:Scale(0.3),
    particle_trace:Scale(0.3):Translate(0.005, 0.005),
    notches1,
    notches2,
    images.detector_graphic:Tint(1, 1, 1, 0.3)
    ):Translate(1.66, 0.25)

main_scene.child = lt.Layer(main_scene.child)
--main_scene.child:Insert(computer_sounds())
main_scene.child:Insert(button_bar_overlay():Translate(0, -2):Tween{y = 0, time = 0.5, action = function()
    main_scene.child:Insert(restart_button)
    main_scene.child:Insert(abandon_button)
    if online_button then
        main_scene.child:Insert(online_button)
    end
    if gamecenter_button then
        main_scene.child:Insert(gamecenter_button)
    end
end})
main_scene.child:Action(coroutine.wrap(function(dt, node)
    node:Insert(lt.Text("EXPERIMENT ", font, "left", "bottom")
        :Scale(0.6)
        :Translate(-2.7, 1.5)
        :Tint(unpack(config.ui_light_grey)))
    node:Insert(lt.Text(string.upper(stages[stage_id].particle_name), font, "left", "bottom")
        :Scale(0.6)
        :Translate(-1.76, 1.5)
        :Tint(1, 1, 1))
    coroutine.yield(0.1)
    local status_string = "PARTICLE UNDISCOVERED"
    local status_color = {1, 1, 1}
    if game_state.stages_unlocked then
        status_string = "NEW PARTICLE DISCOVERED"
        status_color = {1, 0.5, 0}
    elseif lt.state.stage_finished[stage_id] then
        status_string = "PARTICLE DISCOVERED"
    end
    local status_node = lt.Text(status_string, font, "left", "bottom")
        :Scale(0.7):Translate(-2.7, 1.3)
        :Tint(unpack(status_color))
    node:Insert(status_node)
    if game_state.stages_unlocked then
        node:Insert(lt.Text("EXPERIMENT COMPLETE", font, "left", "top"):Scale(0.4)
            :Translate(-2.7, 1.31)
            :Tint(0.5, 1, 1))
    end

    coroutine.yield(0.1)
    node:Insert(lt.Text("ENERGY\nREADING", font, "left", "top")
        :Scale(0.55):Translate(-2.7, 1.145)
        :Tint(unpack(config.ui_light_grey)))
    node:Insert(score_text:Scale(0.8)
            :Translate(-1.86, 1.15)
            :Tint(1, 1, 1))
    if score > prev_best then
        node:Insert(lt.Text("NEW PEAK", font, "left", "top"):Scale(0.4)
            :Translate(-1.85, 0.88)
            :Tint(0.5, 1, 1))
    end

    coroutine.yield(0.1)
    node:Insert(lt.Text("PREVIOUS PEAK", font, "left", "bottom")
        :Scale(0.4):Translate(-2.7, 0.613)
        :Tint(unpack(config.ui_light_grey)))
    node:Insert(prev_best_text:Scale(0.6)
            :Translate(-1.85, 0.58)
            :Tint(1, 1, 1))

    coroutine.yield(0.1)
    node:Insert(graph)
    if lt.form_factor == "desktop" then
        node:Insert(leaderboard_wrap)
    end
    coroutine.yield(0.1)
    local run_count = lt.Text("RUN COUNT", font, "left", "bottom")
    node:Insert(run_count
        :Scale(0.6):Translate(0.7, 1.5)
        :Tint(unpack(config.ui_light_grey)))
    node:Insert(lt.Text(tostring(lt.state.stages_played[stage_id]), font, "left", "bottom")
        :Scale(0.6):Translate(0.7 + run_count.width * 0.6 + 0.08, 1.5)
        :Tint(1, 1, 1))
    local trace_text = "DETECTOR " .. stage_id .. " PARTICLE TRACE"
    node:Insert(lt.Text(trace_text, font, "left", "bottom")
        :Scale(0.4):Translate(0.7, 1.4)
        :Tint(unpack(config.ui_light_grey)))
    coroutine.yield(0.1)
    node:Insert(particle_trace)
    return true
end))

main_scene.child:KeyDown(function(event)
    local key = event.key
    if key == "enter" or key == "space" then
        retry()
    elseif key == "esc" then
        import "stage_select"
    elseif key == "O" or key == "0" then
        if not lt.state.online then
            if lt.state.username then
                lt.state.online = true
                refresh_leaderboard()
                update_online_button()
            else
                import("enter_name", function(name)
                    lt.state.username = name
                    lt.state.online = true
                    refresh_leaderboard()
                    update_online_button()
                end)
            end
        else
            lt.state.online = nil
            refresh_leaderboard()
            update_online_button()
        end
    end
end)
