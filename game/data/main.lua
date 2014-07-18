-- uncomment this to reset state:
--lt.state = {}

math.randomseed(os.time())

import "ui"
import "audio"
import "energy_boost"
import "stages"
import "level"
import "platforms"
import "portal"
import "player_death"
import "lightning"
import "pattern_parser"
import "scan"
import "tutorial"
import "score"
import "play"
import "symbol"
import "button_bar"
--import "keyboard"

local game_images = {
    --"energy_boost_particle",
    "particle_square",
    --"particle_bubble",
    "particle_blob",
    --"particle_hline",
    "particle_vline",
    --"particle_bars",
    --"particle_cloud",
    --"particle_box",
    --"particle_triangle",
    --"particle_fade",
    --"particle_window",
    --"particle_hex",

    "light1",
    "light2",
    "light3",

    --[[
    "jetpack_mid",
    "jetpack_shoulder",
    "jetpack_wing_small",
    "jetpack_wing_big",
    "wings_main",
    "wing_inner",
    "wing_outer",
    "speedup_mid",
    "speedup_top_wing",
    "speedup_bottom_wing",
    "speedup_ring_small",
    "speedup_ring_med",
    "speedup_ring_big",
    "shield_mid",
    "shield_outer",
    "shield_top_piece",
    "shield_bottom_piece",
    "teleport_piece1",
    "teleport_piece2",
    "teleport_piece3",

    "default_backpack_zero",
    "default_backpack_mid",
    "default_backpack_ring",
    "default_backpack_notch",

    "prism1",
    "prism2",
    "prism3",

    "jetpack_rune",
    "wings_rune",
    "speedup_rune",
    "shield_rune",
    "teleport_rune",
    ]]

    "button_off",
    "button_hover",
    "button_down",

    "stage_select_button_undiscovered",
    "stage_select_button_discovered",
    "stage_select_button_locked",
    "stage_select_button_down",
    "stage1_label",
    "stage2_label",
    "stage3_label",
    "stage4_label",
    "stage5_label",
    "stage6_label",
    "discovered_text",
    "undiscovered_text",

    "xy_dragger",
    "rotate_dragger",

    "detector_graphic",
    "detector_notch1",
    "detector_notch2",

    "bosonx_symbol",
    "symbol_segment",
    "title_boson_x",
    "title_beam",
    "title_bg",

    "left_arrow",
    "left_arrow_shadow",

    "retry",
    "settings",
    "back_arrow",
    "info",
    "gamecenter",
    "leaderboard_icon",
}


local font_images = lt.LoadImages({
    {font = "font", glyphs = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.,-&?!%@/:()'=[]"},
    {font = "font_large", glyphs = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"},
    {font = "digits", glyphs = "1234567890.%"},
}, "linear", "linear")
font = font_images.font
font.hmove = 0.07
font.vmove = 1
digits = font_images.digits
--digits.fixed = true
digits.hmove = 0.07
font_large = font_images.font_large
font_large.hmove = 0.07

images = lt.LoadImages(game_images, "linear", "linear")

if lt.state.prof_gender == nil then
    lt.state.prof_gender = "man"
end
player_frames = {}
function load_player_frames()
    if player_frames.images == nil then
        local img_names = {}
        lt.AddSpriteFiles(img_names, lt.state.prof_gender .. "_running", config.running_sprite_num_frames)
        lt.AddSpriteFiles(img_names, lt.state.prof_gender .. "_jumping", config.jumping_sprite_num_frames)
        player_frames.images = lt.LoadImages(img_names, "linear", "linear")
    end
end
load_player_frames()

man_height = 2.0562

models = lt.LoadModels{
    --"circle_arch1",
    --"circle_arch2",
    --"circle_arch3",
    --"circle_arch4",
    --"square_arch1",
    --"square_arch2",
    --"square_arch3",
    --"hex_arch1",
    --"hex_arch2",
    --"hex_arch3",
    "cannon_inner",
    "cannon_outer",

    --"platform1",
    "platform2",
    --"platform3",

    --"gate",
    --"artifact",

    "barrier",
    --"barrier2",
}

function clearall()
    lt.ClearGlobalSprites()
    lt.ClearGlobalTimers()
end

function advanceall(dt)
    lt.AdvanceGlobalTimers(dt)
    lt.AdvanceGlobalSprites(dt)
end

main_scene = lt.root
main_scene.child = lt.Layer()

function reset_game()
    lt.state.tutorial_complete = false
    lt.state.stage_finished = {}
    lt.state.games_played = 0
    lt.state.score_neighbourhood = {}
    lt.state.userid = nil
    lt.state.username = nil
    lt.state.online = nil
    for s = 1, num_stages do
        lt.state.best_score[s] = 0
        lt.state.stages_played[s] = 0
        lt.state.score_history[s] = {0}
    end
end

if lt.os == "android" then
    leaderboards_url = "http://leaderboards-android.boson-x.com"
else
    leaderboards_url = "http://leaderboards-pc.boson-x.com"
end

lt.FixGlobals()

if not lt.state.stage_finished then
    lt.state.stage_finished = {}
end

if not lt.state.games_played then
    lt.state.games_played = 0
end

if not lt.state.stages_played then
    lt.state.stages_played = {}
end
for s = 1, num_stages do
    if not lt.state.stages_played[s] then
        lt.state.stages_played[s] = 0
    end
end
if not lt.state.score_neighbourhood then
    lt.state.score_neighbourhood = {}
end

lt.state.last_leaderboard_update_time = {}
for s = 1, num_stages do
    lt.state.last_leaderboard_update_time[s] = 0
end

if not lt.state.music_volume or not lt.state.sfx_volume then
    lt.state.music_volume = 1
    lt.state.sfx_volume = 1
end

--lt.state.best_score = nil
--lt.state.score_history = nil

if not lt.state.score_history then
    lt.state.score_history = {}
end
for s = 1, num_stages do
    if not lt.state.score_history[s] then
        lt.state.score_history[s] = {0}
    end
end

if type(lt.state.best_score) ~= "table" then
    lt.state.best_score = {}
end
for s = 1, num_stages do
    if not lt.state.best_score[s] then
        lt.state.best_score[s] = 0
    end
end

--import "play"
--import "stage_select"
import "title"
--import "enter_name"
--import "test_music"
--import "gameover"
--import "test"
--import "test_sound"
--import "test_explosion"
--import("complete_transition", {stage_id = 1, unlocks = {2, 4}, explosion = gen_explosion()})
--import("complete_transition", {stage_id = 2, unlocks = {3}})
--import("complete_transition", {stage_id = 3, unlocks = {}})
--import("complete_transition", {stage_id = 4, unlocks = {5}})
--import("complete_transition", {stage_id = 5, unlocks = {6}})
--import("complete_transition", {stage_id = 6, unlocks = {}, explosion = gen_explosion({score = 1})})
