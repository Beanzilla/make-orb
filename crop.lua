
local MAX_PARTS = 930
local STAGE_1 = 90
local STAGE_2 = 210
local STAGE_3 = 390
local STAGE_4 = 570 -- Begin harvestable
local STAGE_5 = 750

function makeorb.__priv__.grow(pos)
    local meta = minetest.get_meta(pos)
    local node = minetest.get_node_or_nil(pos)
    if not node or meta:get_int("stage") == -1 then
        --makeorb.__priv__.log({errtype="debug", errmsg="Failed obtaining node, or node meta stage is 0 or -1", param={pos=pos, stage=meta:get_int("stage")}})
        return true -- We can't do anything right now, but let's keep the node timer running
    end
    local part = meta:get_int("part")
    if part == -1 then -- Skip this point, we are getting that this node isn't growable
        --makeorb.__priv__.log({errtype="debug", errmsg="Failed, the part is -1, non-growable", param={pos=pos, stage=meta:get_int("stage"), part=meta:get_int("part")}})
        return true
    end
    local light = minetest.get_node_light(pos) or 0
    if light >= 8 then -- Only decrement the growth if light level is 8 or higher
        part = part - 1
        meta:set_int("part", part)
        --makeorb.__priv__.log({errtype="debug", errmsg="Part decrements", param={pos=pos, stage=meta:get_int("stage"), part=meta:get_int("part")}})
        local perc = 0
        local p = 0
        local stage = meta:get_int("stage")
        if stage == 1 then
            p = STAGE_1 + (90 - part)
        elseif stage == 2 then
            p = STAGE_2 + (120 - part)
        elseif stage == 3 then
            p = STAGE_3 + (180 - part)
        elseif stage == 4 then -- Might not want to include the other stages as hidden
            p = STAGE_4 + (180 - part)
        elseif stage >= 5 then
            --p = STAGE_5 + (180 - part)
            p = STAGE_4
        end
        --perc = (p / MAX_PARTS) * 100.0
        perc = (p / STAGE_4) * 100.0

        if makeorb.settings.show_growth_perc then
            meta:set_string("infotext", string.format("%0.1f", perc) .. "%")
        else
            if meta:get_string("infotext") ~= "" then
                meta:set_string("infotext", "")
            end
        end
    end
    if part <= 0 then -- Next stage!
        --makeorb.__priv__.log({errtype="debug", errmsg="Node moves onto next stage", param={pos=pos, stage=meta:get_int("stage"), part=meta:get_int("part")}})
        -- Find next node to swap_node with
        if node.name == "makeorb:crop_1" then
            meta:set_int("stage", 2)
            meta:set_int("part", 120) -- 2m (120s) diff +30s
            minetest.swap_node(pos, {name="makeorb:crop_2"})
        elseif node.name == "makeorb:crop_2" then
            meta:set_int("stage", 3)
            meta:set_int("part", 180) -- 3m (180s) diff +1m (+60s)
            minetest.swap_node(pos, {name="makeorb:crop_3"})
        elseif node.name == "makeorb:crop_3" then
            meta:set_int("drop", 1)
            meta:set_int("stage", 4)
            meta:set_int("part", 180) -- 3m (180s) diff 0s
            minetest.swap_node(pos, {name="makeorb:crop_4"}) -- Ready for harvest
        elseif node.name == "makeorb:crop_4" and meta:get_int("stage") == 4 then
            meta:set_int("drop", 2)
            meta:set_int("stage", 5)
            meta:set_int("part", 180) -- 3m (180s) diff 0s
        elseif node.name == "makeorb:crop_4" and meta:get_int("stage") == 5 then -- Final, just wait for harvest
            meta:set_int("drop", 3)
            meta:set_int("stage", 6)
            meta:set_int("part", -1) -- Set to not growable
        end
    end
    local timer_speed = meta:get_string("timer") or "0.0"
    if timer_speed ~= tostring(makeorb.settings.growth_factor) then
        local timer = minetest.get_node_timer(pos)
        timer:stop()
        timer:start(makeorb.settings.growth_factor)
        meta:set_string("timer", tostring(makeorb.settings.growth_factor))
    end
    return true -- Keep that timer running
end

function makeorb.__priv__.handle_harvest(pos)
    local meta = minetest.get_meta(pos)
    if meta:get_int("drop") ~= 0 and meta:get_int("stage") ~= -1 then
        minetest.swap_node(pos, {name="makeorb:crop_1"})
        meta:set_int("stage", 1)
        meta:set_int("part", 90)
        minetest.item_drop(ItemStack("makeorb:orb "..meta:get_int("drop")), nil, pos)
        meta:set_int("drop", 0)
    elseif meta:get_int("drop") ~= 0 and meta:get_int("stage") == -1 then
        minetest.swap_node(pos, {name="air"})
        minetest.item_drop(ItemStack("makeorb:orb "..meta:get_int("drop")), nil, pos)
        meta:set_int("drop", 0)
    end
    local timer = minetest.get_node_timer(pos)
    if not timer:is_started() and meta:get_int("stage") ~= -1 then
        timer:start(makeorb.settings.growth_factor)
        meta:set_string("timer", tostring(makeorb.settings.growth_factor))
    end
end

function makeorb.__priv__.handle_place(stack, pointed)
    local name = stack:get_name()
    local pos = pointed.under
    local node = minetest.get_node_or_nil(pos)
    if not node or minetest.get_item_group(node.name, "soil") < 3 then
        --makeorb.__priv__.log({errtype="violation", errmsg="Attempting to plant an orb on non-soil but soil required", param={stack=stack:to_table(), pointed=pointed.under, pos=pos}})
        return stack
    end
    pos.y = pos.y + 1
    local meta = minetest.get_meta(pos)
    local new_node = minetest.get_node_or_nil(pos)
    if not new_node or new_node.name ~= "air" then
        --makeorb.__priv__.log({errtype="violation", errmsg="Attempting to plant an orb with no room to place orb_crop", param={stack=stack:to_table(), pointed=pointed.under, pos=pos}})
        return stack
    end
    if name == "makeorb:orb" or name == "makeorb:crop_1" then
        meta:set_int("stage", 1)
        meta:set_int("part", 90) -- 1m30s (90s)
        meta:set_int("drop", 0)
        minetest.swap_node(pos, {name="makeorb:crop_1"})
    elseif name == "makeorb:crop_2" then
        meta:set_int("stage", 2)
        meta:set_int("part", 120) -- 2m (120s)
        meta:set_int("drop", 0)
        minetest.swap_node(pos, {name="makeorb:crop_2"})
    elseif name == "makeorb:crop_3" then
        meta:set_int("stage", 3)
        meta:set_int("part", 180) -- 3m (180s)
        meta:set_int("drop", 0)
        minetest.swap_node(pos, {name="makeorb:crop_3"})
    elseif name == "makeorb:crop_4" then
        meta:set_int("stage", 4)
        meta:set_int("part", 180) -- 3m (180s)
        meta:set_int("drop", 1)
        -- This upgrades 2 more times stage 5, and stage 6
        -- All the extra stages do is increase the drops
        -- At stage 6 we stop growing as 3 drops is a lot of drops
        minetest.swap_node(pos, {name="makeorb:crop_4"})
    elseif name == "makeorb:crop" then
        meta:set_int("stage", -1)
        meta:set_int("part", -1)
        meta:set_int("drop", 1)
        minetest.swap_node(pos, {name="makeorb:crop"})
    end
    --makeorb.__priv__.log({errtype="debug", errmsg="Setup node", param={stack=stack:to_table(), pos=pos, stage=meta:get_int("stage"), part=meta:get_int("part"), drop=meta:get_int("drop")}})
    local timer = minetest.get_node_timer(pos)
    if not timer:is_started() and meta:get_int("stage") ~= -1 then
        timer:start(makeorb.settings.growth_factor)
        meta:set_string("timer", tostring(makeorb.settings.growth_factor))
    end
    stack:take_item()
    return stack
end

minetest.register_craftitem("makeorb:orb", {
    short_description = "Make Orb",
    description = "Make Orb\nUse this to make things.\nPlace on wet soil to grow.",
    inventory_image = makeorb.__priv__.image("orb"),
    on_place = function (stack, player, pointed)
        return makeorb.__priv__.handle_place(stack, pointed)
    end
})

minetest.register_node("makeorb:crop_1", {
    short_description = "Make Orb Crop",
    description = "Make Orb Crop\nStage: 1\nTime to next stage: 1m30s (90s)",
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    drop = "",
    waving = 1, -- plantlike waving
    tiles = {makeorb.__priv__.image("crop_1")},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.5+0.25, 0.5}
        },
    },
    groups = {handy=1, snappy=3, flammable=2, not_in_creative_inventory=1, plant=1},
    _mcl_hardness = 2,
    on_timer = function (pos, elapsed)
        return makeorb.__priv__.grow(pos)
    end,
    on_punch = function (pos, node, player, pointed)
        makeorb.__priv__.handle_harvest(pos)
    end,
    on_place = function (stack, player, pointed)
        return makeorb.__priv__.handle_place(stack, pointed)
    end
})

minetest.register_node("makeorb:crop_2", {
    short_description = "Make Orb Crop",
    description = "Make Orb Crop\nStage: 2\nTime to next stage: 2m (120s)",
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    drop = "",
    waving = 1, -- plantlike waving
    tiles = {makeorb.__priv__.image("crop_2")},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.5+0.5, 0.5}
        },
    },
    groups = {handy=1, snappy=3, flammable=2, not_in_creative_inventory=1, plant=1},
    _mcl_hardness = 2,
    on_timer = function (pos, elapsed)
        return makeorb.__priv__.grow(pos)
    end,
    on_punch = function (pos, node, player, pointed)
        makeorb.__priv__.handle_harvest(pos)
    end,
    on_place = function (stack, player, pointed)
        return makeorb.__priv__.handle_place(stack, pointed)
    end
})

minetest.register_node("makeorb:crop_3", {
    short_description = "Make Orb Crop",
    description = "Make Orb Crop\nStage: 3\nTime to next stage: 3m (180s)",
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    drop = "",
    waving = 1, -- plantlike waving
    tiles = {makeorb.__priv__.image("crop_3")},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.5+0.75, 0.5}
        },
    },
    groups = {handy=1, snappy=3, flammable=2, not_in_creative_inventory=1, plant=1},
    _mcl_hardness = 2,
    on_timer = function (pos, elapsed)
        return makeorb.__priv__.grow(pos)
    end,
    on_punch = function (pos, node, player, pointed)
        makeorb.__priv__.handle_harvest(pos)
    end,
    on_place = function (stack, player, pointed)
        return makeorb.__priv__.handle_place(stack, pointed)
    end
})

minetest.register_node("makeorb:crop_4", {
    short_description = "Make Orb Crop",
    description = "Make Orb Crop\nStage: 4\nTime to next stage: 3m (90s)",
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    drop = "",
    waving = 1, -- plantlike waving
    tiles = {makeorb.__priv__.image("crop_orb")},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.5+1, 0.5}
        },
    },
    groups = {handy=1, snappy=3, flammable=2, not_in_creative_inventory=1, plant=1},
    _mcl_hardness = 2,
    on_timer = function (pos, elapsed)
        return makeorb.__priv__.grow(pos)
    end,
    on_punch = function (pos, node, player, pointed)
        makeorb.__priv__.handle_harvest(pos)
    end,
    on_place = function (stack, player, pointed)
        return makeorb.__priv__.handle_place(stack, pointed)
    end
})

-- This version is used for mapgeneration only, but it is avaible via creative mode for those who wish to use it
minetest.register_node("makeorb:crop", {
    short_description = "Make Orb Crop",
    description = "Make Orb Crop\nThis one doesn't grow\nUsed for terrain generation",
    paramtype = "light",
    walkable = false,
    drawtype = "plantlike",
    drop = "makeorb:orb",
    waving = 1, -- plantlike waving
    tiles = {makeorb.__priv__.image("crop_orb")},
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.5+1, 0.5}
        },
    },
    groups = {handy=1, snappy=3, flammable=2, plant=1},
    _mcl_hardness = 2,
    on_timer = function (pos, elapsed)
        return makeorb.__priv__.grow(pos)
    end,
    on_punch = function (pos, node, player, pointed)
        makeorb.__priv__.handle_harvest(pos)
    end,
    on_place = function (stack, player, pointed)
        return makeorb.__priv__.handle_place(stack, pointed)
    end
})
