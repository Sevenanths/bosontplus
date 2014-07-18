local stage = ...

local loops = lt.LoadSamples({
    "stage" .. stage .. "a",
    "stage" .. stage .. "b"
})

local sample1 = loops["stage" .. stage .. "a"]
local sample2 = loops["stage" .. stage .. "b"]
local track = lt.Track()
local wrap = track:Wrap()
track:Queue(sample1)
track.gain = 0
track.loop = true
track:Play()

function wrap:reset()
    track = lt.Track()
    track:Queue(sample1)
    track.gain = 0
    track.loop = true
    track:Play()
    wrap.child = track
    wrap.phase = 1
end

function wrap:promote()
    track = lt.Track()
    track:Queue(sample2)
    track.gain = lt.state.music_volume
    track.loop = true
    track:Play()
    wrap.child = track
    wrap.phase = 2
end

return wrap
