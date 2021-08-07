local zetaLib = require("lib.zetaLib")

function OnDestroyed(e)
    if(e.entity) then
        local entity = e.entity
        local triggers = { locomotive = true, car = true }
        if triggers[e.entity.type] then
            zetaLib.createNuclearExplosion(entity)
        end
    end
end

-- trigger meltdown
script.on_event(defines.events.on_entity_died, OnDestroyed)
script.on_event(defines.events.script_raised_destroy, OnDestroyed)
