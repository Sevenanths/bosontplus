samples = lt.LoadSamples({
    "step1",
    "step2",
    "step3",
    "step4",

    "breath1",
    "breath2",
    "breath3",
    "breath4",
    "breath5",
    "breath6",
    "breath7",

    "breath_tired1",
    "breath_tired2",
    "breath_tired3",
    "breath_tired4",

    --[[
    "jump1",
    "jump2",
    "jump3",
    "jump4",
    "jump5",
    "jump6",
    ]]

    --"collect",
    "electric1",
    "charge",
    "explosion",
    "reach_critical",
    "hitside",
    "intro",
    --[[
    "ambience1",
    "ambience2",
    "ambience3",
    "ambience4",
    ]]
    "platform_arrive",
    "portal_hum",
    "rumble",
    "title_beam",
    --[[
    "printer",
    "start_sound",
    "barrier_close",
    "back_hum",
    ]]

    --[[
    "cheerful_trance",
    "bassdrum",
    "bass",
    "cymbal",
    "highnote",
    ]]

    "select",
    "not_allowed",

    "uibleep",
    "uiback",
})

local rand = math.random
local min = math.min
local max = math.max

local
function gain_from_progress(progress)
    return 1
end

function play_step(progress)
    local pitch = rand() * 0.7 + 0.6
    local gain = 0.5
    samples["step" .. rand(4)]:Play(pitch, gain * lt.state.sfx_volume)
end

function play_land(progress)
    local gain = gain_from_progress(progress) * 0.5
    local gain1 = gain + rand() * 0.2
    local gain2 = gain + rand() * 0.2
    local pitch1 = rand() * 0.7 + 0.6
    local pitch2 = rand() * 0.7 + 0.6
    local sample1 = rand(4)
    local sample2
    repeat
        sample2 = rand(4)
    until sample1 ~= sample2
    samples["step" .. sample1]:Play(pitch1, gain1 * lt.state.sfx_volume)
    samples["step" .. sample2]:Play(pitch2, gain2 * lt.state.sfx_volume)
end

--[[
local portal_track1 = lt.Track()
portal_track1:Queue(samples.portal1)
portal_track1:SetLoop(true)
local portal_base_gain = 0.01

function play_portal()
    portal_track1.gain = portal_base_gain
    portal_track1:Play()
end

function stop_portal()
    portal_track1:Pause()
end

function set_portal_gain(gain)
    portal_track1.gain = gain + portal_base_gain
end
]]

function play_breath(progress)
    local pitch = rand() * 0.05 + 0.98
    if lt.state.prof_gender == "woman" then
        pitch = pitch * 1.22641
    end
    local gain = gain_from_progress(progress)
    if gain > 0.9 and rand() < 0.1 then
        samples["breath_tired" .. rand(4)]:Play(pitch, gain * lt.state.sfx_volume)
    else
        samples["breath" .. rand(7)]:Play(pitch, gain * lt.state.sfx_volume)
    end
end

--[[
function play_heartbeat(progress)
    local pitch = rand() * 0.05 + 0.98
    local gain = rand() * 0.05 + 0.98
    samples.heartbeat:Play(pitch, gain)
end
]]

function play_jump(progress)
    local pitch = rand() * 0.1 + 0.95
    play_land(progress)
end

function play_collect()
    samples.collect:Play(rand() * 0.05 + 0.4, 0.2 * lt.state.sfx_volume)
end


function back_hum_track()
    local track = lt.Track()
    track:Queue(samples.back_hum)
    track:SetLoop(true)
    track.gain = 0
    return track
end

function add_heart_monitor_track(layer)
    local track = lt.Track()
    track:Queue(samples.heart_monitor)
    track:SetLoop(true)
    track.gain = 0.3 * lt.state.sfx_volume
    track:Action(coroutine.wrap(function(dt)
        track:Play()
        coroutine.yield(0.2)
        track:Pause()
        coroutine.yield(0.5)
        track:Play()
        coroutine.yield(0.2)
        track:Pause()
        coroutine.yield(0.5)
        track:Play()
        track:Tween{delay = 0.5, time = 6, gain = 0}
        coroutine.yield(6)
        track:Stop()
        layer:Remove(track)
        return true
    end))
    layer:Insert(track)
end

function electric_track()
    local track = lt.Track()
    track:Queue(samples.electric1)
    track.gain = 0.01 * lt.state.sfx_volume
    track.pitch = math.random() * 0.2 + 0.9
    track:Tween{gain = 1 * lt.state.sfx_volume, time = 4, easing="zoomin"}
    track:Play()
    return track
end

function charge_track()
    local track = lt.Track()
    track:Queue(samples.charge)
    track:SetLoop(true)
    track.gain = 0
    return track
end

function explosion_track()
    local track = lt.Track()
    track.gain = lt.state.sfx_volume
    track:Queue(samples.explosion)
    track:Play()
    return track
end

function title_sounds()
    local track = lt.Track()
    track:Queue(samples.title_beam)
    track:SetLoop(true)
    track.gain = 0
    track:Play()
    track:Action(coroutine.wrap(function(dt)
        track:Tween{
            gain = 0.4 * lt.state.sfx_volume, time = 1
        }
        coroutine.yield(4)
        while true do
            local t = math.random() * 10
            track:Tween{
                pitch = math.random() * 0.05 + 0.975,
                time = t,
            }
            coroutine.yield(t)
        end
    end))
    return track
end

function portal_sound(level)
    local track = lt.Track()
    track:Queue(samples.portal_hum)
    track:SetLoop(true)
    track.gain = 0
    track:Play()
    track:Action(function(dt, track)
        track.gain = (1 - level.portal_distance) * lt.state.sfx_volume
    end)
    return track
end

function game_ambience(level)
    local tracks = lt.Layer()
    for i = 1, 3 do
        local track = lt.Track()
        track:Queue(samples["ambience"..i])
        track:SetLoop(true)
        track:Play()
        track.gain = 0
        track:Action(coroutine.wrap(function(dt)
            while true do
                local t = math.random() * 2 + 0.1
                local p = math.random() * 1 + 0.5 + math.min((level.stage.id - 1) * 0.15, 0.5)
                local g = math.random() * 0.1 + 0.1
                track:Tween{pitch = p, gain = g * lt.state.sfx_volume, time = t}
                coroutine.yield(t)
            end
        end))
        tracks:Insert(track)
    end
    return tracks
end

function play_platform_enter(level, platform)
    local gain = 0.3 --(level.progress) * 0.5 + 0.3
    local pitch
    if platform.has_energy_boost then
        pitch = math.random() * 0.3 + 1.4
        gain = gain * 1.2 
    elseif platform.will_fall then
        pitch = math.random() * 0.1 + 0.6
        gain = gain * 1.5
    else
        pitch = math.random() * 0.1 + 0.9
    end
    pitch = pitch + math.min((level.stage.id - 1) * 0.15, 0.5)
    samples.platform_arrive:Play(pitch, gain * lt.state.sfx_volume)
end

function play_rumble(gain)
    samples.rumble:Play(math.random() * 0.1 + 0.9, gain * lt.state.sfx_volume)
end

function printer_sound()
    local track = lt.Track()
    track:Queue(samples.printer)
    track:SetLoop(true)
    track.gain = 1 * lt.state.sfx_volume
    return track
end

function play_start_sound()
    samples.start_sound:Play()
end

function computer_sounds()
    local tracks = lt.Layer()
    do
        local track = lt.Track()
        track:Queue(samples.printer)
        track:SetLoop(true)
        track.gain = 0
        track:Tween{gain = 0.1 * lt.state.sfx_volume, time = 5, easing = "linear"}
        track:Action(coroutine.wrap(function(dt, track)
            while true do
                coroutine.yield(math.random() * math.random() * 1 + 0.1)
                track.pitch = math.random(2) * 0.1 + 0.8
                track:Play()
                coroutine.yield(math.random() * 0.1 + 0.1)
                track:Pause()
            end
        end))
        tracks:Insert(track)
    end
    do
        local track = lt.Track()
        track:Queue(samples.printer)
        track:SetLoop(true)
        track.gain = 0
        track:Tween{gain = 0.2 * lt.state.sfx_volume, time = 5, easing = "linear"}
        track.pitch = 0.4
        track:Action(coroutine.wrap(function(dt, track)
            while true do
                coroutine.yield(math.random() * math.random() * 2 + 0.5)
                track:Play()
                coroutine.yield(math.random() * 0.4 + 0.2)
                track:Pause()
            end
        end))
        tracks:Insert(track)
    end
    do
        local track = lt.Track()
        track:Queue(samples.printer)
        track:SetLoop(true)
        track.gain = 0
        track:Tween{gain = 0.2 * lt.state.sfx_volume, time = 5, easing = "linear"}
        track.pitch = 1.4
        track:Action(coroutine.wrap(function(dt, track)
            while true do
                coroutine.yield(math.random() * math.random() * 2 + 0.5)
                track:Play()
                coroutine.yield(math.random() * 0.4 + 0.2)
                track:Pause()
            end
        end))
        tracks:Insert(track)
    end
    return tracks
end
