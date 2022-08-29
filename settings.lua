
makeorb.settings.show_growth_perc = minetest.settings:get_bool("makeorb.show_growth_perc")
if makeorb.settings.show_growth_perc == nil then
    makeorb.settings.show_growth_perc = false
    minetest.settings:set_bool("makeorb.show_growth_perc", false)
end
