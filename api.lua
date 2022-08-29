

function makeorb.__priv__.make_set(basename)
    return {__mkorb__=true, base=basename, data={}, __from__="makeorb"}
end

function makeorb.__priv__.debug_set(st)
    makeorb.__priv__.log()
end

function makeorb.pub.is_set(st)
    return st.__mkorb__ == true
end

function makeorb.pub.is_makeorb(st)
    if makeorb.pub.is_set(st) then
        return st.__from__ == "makeorb"
    else
        return false
    end
end

function makeorb.pub.make_set(your_mod_name, basename)
    if your_mod_name == "makeorb" then
        makeorb.__priv__.log({errtype = "violation", errmsg="makeorb.pub.make_set was given 'makeorb' as your_mod_name, this is invalid", param={your_mod_name=your_mod_name, basename=basename}})
        return nil
    end
    if basename ~= nil then
        return {__mkorb__=true, base=basename, data={}, __from__=your_mod_name}
    else
        local current_mod = minetest.get_current_modname()
        return {__mkorb__=true, base=your_mod_name, data={}, __from__=current_mod}
    end
end
