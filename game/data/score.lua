local
function get_nbh_score(nbh)
    for _, row in ipairs(nbh) do
        if row.is_user then
            return row.score
        end
    end
    return 0
end

function submit_score_android(stage_id, score, prev_best)
    local data = {
        userid = lt.state.userid,
        name = lt.state.username,
        score = math.max(prev_best, score) * 100,
        stage = stage_id,
    }
    --log(leaderboards_url)
    --log(lt.ToJSON(data))
    local msg = lt.ToJSON(data)
    local req = lt.HTTPRequest(leaderboards_url, msg)
    main_scene:Action(function(dt)
        req:Poll()
        log("poll")
        if req.success then
            --log(req.response)
            local result = lt.FromJSON(req.response)
            if result then
                log("Response: " .. req.response)
                lt.state.userid = result.userid
                lt.state.score_neighbourhood[stage_id] = result.neighbourhood
                lt.state.last_leaderboard_update_time[stage_id] = os.time()
            else
                log("Bad response: " .. req.response)
            end
            return true
        elseif req.failure then
            log("Failed to submit score: " .. req.error)
            return true
        end
        return 0.2
    end)
end

function record_new_score(score, stage)
    local prev_best = lt.state.best_score[stage] or 0
    if not prev_best or prev_best < score then
        lt.state.best_score[stage] = score
    end

    table.insert(lt.state.score_history[stage], score)
    if #lt.state.score_history[stage] > config.score_history_size then
        table.remove(lt.state.score_history[stage], 1)
    end

    if lt.os == "ios" then
        lt.SubmitScore("bosonx.stage" .. stage, math.floor(score * 10000 + 0.5))
        if score > 1 then
            lt.SubmitAchievement("bosonx.finish_stage" .. stage)
        end
    elseif lt.os == "android" then
        if lt.state.online then
            local refresh_period = 300
            local nbh = lt.state.score_neighbourhood[stage]
            if score > prev_best or not nbh or #nbh == 0 or (get_nbh_score(nbh) + 0.00001) < (prev_best * 100) or
                os.difftime(os.time(), lt.state.last_leaderboard_update_time[stage]) > refresh_period
            then
                submit_score_android(stage, score, prev_best)
            end
        end
    end

    return prev_best
end
