local stage = ...

local leaderboard_wrap = lt.Wrap()

local
function render_neighbourhood()
    local y = 0
    local rank_x, name_x, score_x = 0, 1.2, 6.9
    local nbh = lt.state.score_neighbourhood[stage]
    if nbh then
        local leaderboard = lt.Layer()
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
            leaderboard_wrap.child = leaderboard
            y = y - 0.22
        end
    else
        leaderboard_wrap.child = lt.Text("LOADING SCORES...", font, "center", "center")
        local alt = true
        leaderboard_wrap:Action(coroutine.wrap(function()
            submit_score_android(stage_id, lt.state.best_score[stage_id], 0)
            while not lt.state.score_neighbourhood[stage] do
                coroutine.yield(0.2)
            end
            return true
        end))
    end
end

render_neighbourhood()

local scene = lt.Layer()
scene:Insert(leaderboard_wrap:Scale(0.7):Translate(-2.5, 1))
main_scene.child = scene
