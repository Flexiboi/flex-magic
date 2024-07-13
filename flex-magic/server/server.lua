local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('flex-magic:server:SendSpell', function(id, coords)
    local src = source
    TriggerClientEvent('flex-magic:client:SendSpell', -1, id, coords, src, Config.Spells[id])
end)

RegisterNetEvent('flex-magic:server:ForceStopSpel', function(id)
    TriggerClientEvent('flex-magic:client:ForceStopSpel', -1, id)
end)