local nuclear_fuels = require("lib.nuclear-fuels")
local zetaLib = {}

function zetaLib.isNuclearEnergy(burner)
    if (burner.fuel_categories) then
        return burner.fuel_categories["nuclear"]
    elseif (burner.fuel_category) then
        return burner.fuel_category == "nuclear"
    end
    return false
end

function zetaLib.entityHasNuclearBurner(entity)
    if (entity.burner) then
        return zetaLib.isNuclearEnergy(entity.burner)
    elseif (entity.energy_source) then
        return zetaLib.isNuclearEnergy(entity.energy_source)
    end
end

function zetaLib.setNuclearExplosion(prototype)
    for entry, _ in pairs(data.raw[prototype]) do
        local entity = data.raw[prototype][entry]
        if zetaLib.entityHasNuclearBurner(entity) then
            entity.dying_explosion = "nuclear-reactor-explosion"
        end
    end
end

function zetaLib.fuelIsNuclear(fuel)
    if (fuel) then
        for _, value in pairs(nuclear_fuels) do
            if string.match(fuel.name, value) then
                return true
            end
        end
    end
    return false
end

function zetaLib.spawnNuclearExplosion(entity)
    local surface = entity.surface
    local pos = entity.position
    surface.request_to_generate_chunks(pos, 4)
    surface.create_entity{ name = "atomic-rocket", position = pos, target = entity , force = "neutral", speed = 0.5 }
end

function zetaLib.createNuclearExplosion(entity)
    if zetaLib.fuelIsNuclear(entity.burner.currently_burning) then
        zetaLib.spawnNuclearExplosion(entity)
    end
end

return zetaLib
