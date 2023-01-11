
local stick = "group:stick"
local wood = "group:wood"
local logs = "group:tree"
local iron_ingot = "default:steel_ingot"
local gold_ingot = "default:gold_ingot"
local diamond = "default:diamond"
local coal_lump = "default:coal_lump"
local iron_lump = "default:iron_lump"
local gold_lump = "default:gold_lump"

makeorb.pub.items = {
    "makeorb:tree", -- log
    "makeorb:wood",
    "makeorb:stick",
    "makeorb:iron_ingot",
    "makeorb:gold_ingot",
    "makeorb:diamond"
}

minetest.register_craftitem("makeorb:stick", {
    short_description = "Make Stick",
    description = "Make Stick\nUsed in crafting various machines",
    inventory_image = makeorb.__priv__.image("orb"),
})
