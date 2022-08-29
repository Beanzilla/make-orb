
-- Registers placement of the non growing crop
-- This is so the mod is actually obtainable, rather than being unobtainium.
minetest.register_decoration({
    deco_type = "simple",
    place_on = {"default:dirt_with_grass", "default:dry_dirt_with_dry_grass", "default:dirt_with_dry_grass"},
    sidelen = 16,
    noise_params = {
        offset = 0,
        scale = 0.003, -- +0.001 from farming
        spread = {x = 100, y = 100, z = 100},
        seed = 329,
        octaves = 3,
        persist = 0.6
    },
    y_min = 15,
    y_max = 40,
    decoration = {"makeorb:crop"},
    spawn_by = "",
    num_spawn_by = -1
})
