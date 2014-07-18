stages = {
    -- STAGE 1
    {
        initial_speed = 0.7,
        max_speed = 1.2,
        energy_interval = 6,
        energy_speedup = 0.00135,
        level_depth = 28,
        particle_name = "geon",
        particle_abbv = "ge",
    },
    { -- STAGE 2
        initial_speed = 1.0,
        max_speed = 1.3,
        energy_interval = 8,
        energy_speedup = 0.00149,
        level_depth = 26,
        particle_name = "acceleron",
        particle_abbv = "ac",
    },
    { -- STAGE 3
        initial_speed = 1.0,
        max_speed = 1.2,
        energy_interval = 6,
        energy_speedup = 0.000509,
        level_depth = 26,
        particle_name = "radion",
        particle_abbv = "rd",
    },
    { -- STAGE 4
        initial_speed = 1.5,
        max_speed = 1.7,
        energy_interval = 10,
        energy_speedup = 0.00103,
        level_depth = 25,
        particle_name = "graviton",
        particle_abbv = "gv",
    },
    { -- STAGE 5
        initial_speed = 1.2,
        max_speed = 1.7,
        energy_interval = 4,
        energy_speedup = 0.001609,
        level_depth = 25,
        particle_name = "Y boson",
        particle_abbv = "yb",
    },
    { -- STAGE 6
        initial_speed = 1.8,
        max_speed = 2.2,
        energy_interval = 12,
        energy_speedup = 0.000903,
        level_depth = 25,
        particle_name = "X boson",
        particle_abbv = "xb",
    },
}

num_stages = #stages

-- Set stage ids
for i = 1, num_stages do
    stages[i].id = i
end

function get_stage(stage_id)
    --return stages[num_stages]
    return stages[math.min(num_stages, stage_id)]
end

function is_unlocked(s)
    return s == 1
        or s == 2 and lt.state.stage_finished[1]
        or s == 3 and lt.state.stage_finished[2]
        or s == 4 and lt.state.stage_finished[1]
        or s == 5 and lt.state.stage_finished[4]
        or s == 6 and lt.state.stage_finished[5] and lt.state.stage_finished[3]
end

function compute_progress()
    --if 1 == 1 then return 6 end
    local stage = 0
    for s = 1, num_stages do
        if lt.state.stage_finished[s] then
            stage = stage + 1
        end
    end
    return stage
end
