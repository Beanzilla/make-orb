
local game = "???"
if minetest.registered_nodes["default:dirt"] then
    game = "MTG"
elseif minetest.registered_nodes["mcl_core:dirt"] then
    game = "MCL"
end

makeorb = {
    pub = { -- Public api
        VERSION = "1.0"
    },
    __priv__ = { -- Private api
        game = game,
    },
    settings = { -- Settings
        show_growth_perc = false,
        growth_factor = 0.5 -- IN seconds (This was supposed to be changable in-game, but appears to not work)
    }
}

makeorb.__priv__.store = minetest.get_mod_storage()
makeorb.__priv__.modpath = minetest.get_modpath("makeorb")

function makeorb.__priv__.log(msg)
    if type(msg) == "table" then
        msg = minetest.serialize(msg)
        msg = msg:gsub("return ", "")
    elseif type(msg) ~= "string" then
        msg = tostring(msg)
    end
    minetest.log("action", "[makeorb] " .. msg)
end

function makeorb.__priv__.dofile(dir, file)
    if file == nil then
        dofile(makeorb.__priv__.modpath .. DIR_DELIM .. dir .. ".lua")
    else
        dofile(makeorb.__priv__.modpath .. DIR_DELIM .. dir .. DIR_DELIM .. file .. ".lua")
    end
end

function makeorb.__priv__.image(file)
    return "makeorb_" .. file .. ".png"
end

makeorb.__priv__.dofile("settings") -- Process settings via gui/minetest.conf
makeorb.__priv__.dofile("api") -- Support structs for compressors and their optional makes
makeorb.__priv__.dofile("crop") -- Make the crop and item
makeorb.__priv__.dofile("mapgen") -- Make the crop appear as appart of terrain generation (Note, this won't help old maps, new maps with this installed will increase the chances of finding the plant to start with this mod)
--makeorb.__priv__.dofile("crafting", "base") -- Crafting ingredients for compressors and storage tanks
--makeorb.dofile("compressor", "base") -- Make the compressor and use the api to define what various type of compressors can make
--makeorb.dofile("compressor", "ground") -- Makes dirt, stone, dirt_with_grass, sand, gravel, and others appart of the ground
--makeorb.dofile("compressor". "food") -- Makes bread, onions, carrots, wheat, rye, oats, and others appart of food and making food
--makeorb.dofile("storage", "base") -- Make the storage tank and use the api to define the limits of tank tiers
