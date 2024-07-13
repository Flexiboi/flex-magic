local QBCore = exports['qb-core']:GetCoreObject()
local Spelling = false
local ActiveSpells = {}

function showLoopParticle(dict, particleName, coords, scale, time, particletime, speller, spellid)
    RequestNamedPtfxAsset(dict)
    while not HasNamedPtfxAssetLoaded(dict) do Wait(0) end
    SetPtfxAssetNextCall(dict)
    if ActiveSpells[speller].particles[spellid] == nil then return end
    ActiveSpells[speller].particles[spellid][#ActiveSpells[speller].particles[spellid]+1] = StartParticleFxLoopedAtCoord(particleName, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, scale, false, false, false, false)
    if particletime then
        Wait(particletime)
        if not ActiveSpells[speller] then return end
        if ActiveSpells[speller].particles[spellid] == nil then return end
        StopParticleFxLooped(ActiveSpells[speller].particles[spellid][#ActiveSpells[speller].particles[spellid]], 0)
        -- ActiveSpells[speller].particles[#ActiveSpells[speller].particles] = nil
    end
    SetTimeout(time, function()
        if not ActiveSpells[speller] then return end
        if ActiveSpells[speller].particles[spellid] == nil then return end
        for k, v in pairs(ActiveSpells[speller].particles[spellid]) do
            StopParticleFxLooped(v, 0)
        end
        ActiveSpells[speller].particles[spellid] = nil
    end)
end

function drawSpelCircle(centerX, centerY, centerZ, radius, time, particles, speller, spellid)
    if particles.loop > 1 then
        for i=1, particles.loop do
            for angle = 0, 2*math.pi, .1 do
                if not ActiveSpells[speller] then return end
                local x = centerX + radius*math.cos(angle)
                local y = centerY + radius*math.sin(angle)
                local z = centerZ
                if particles.tothetop then
                    z = centerZ+(angle/3)
                end
                showLoopParticle(particles.dict, particles.particleName, vec3(x, y, z), particles.scale, time, particles.particletime, speller, spellid)
            end
        end
    else
        for angle = 0, 2*math.pi, .1 do
            if not ActiveSpells[speller] then return end
            local x = centerX + radius*math.cos(angle)
            local y = centerY + radius*math.sin(angle)
            showLoopParticle(particles.dict, particles.particleName, vec3(x, y, centerZ), particles.scale, time, nil, speller, spellid)
        end
    end
end

RegisterCommand("spell", function(src, args)
    if tonumber(args[1]) > 0 then
        if not Config.Spells[tonumber(args[1])] then return end
        if Spelling then return end
        Spelling = true
        SetTimeout(10000, function()
            Spelling = false
        end)
        TriggerServerEvent('flex-magic:server:SendSpell', tonumber(args[1]), GetEntityCoords(PlayerPedId()))
    end
end)

RegisterNetEvent('flex-magic:client:SendSpell', function(id, coords, speller, config)
    local ped = PlayerPedId()
    local pedId = GetPlayerServerId(PlayerId())
    local entCoords = GetEntityCoords(ped)

    ActiveSpells[speller] = {}
    ActiveSpells[speller].particles = {}
    ActiveSpells[speller].particles[#ActiveSpells[speller].particles + 1] = {}

    SetTimeout(100, function()
        MoveCheck(pedId, speller, coords, #ActiveSpells[speller].particles)
    end)

    if #(entCoords - coords) <= config.range then
        drawSpelCircle(coords.x, coords.y, coords.z+config.speleffects.particles.zoffset, config.range, 1000 * config.spelltime, config.speleffects.particles, speller, #ActiveSpells[speller].particles)
        if config.speleffects.heal.who:upper() == 'OTHER' and pedId ~= speller then
            Heal(config.speleffects.heal.amount, config.speleffects.heal.time)
        elseif config.speleffects.heal.who:upper() == 'SELF' and pedId == speller then
            Heal(config.speleffects.heal.amount, config.speleffects.heal.time)
        end
        if config.speleffects.damage.who:upper() == 'OTHER' and pedId ~= speller then
            Damage(config.speleffects.damage.amount, config.speleffects.damage.time)
        elseif config.speleffects.damage.who:upper() == 'SELF' and pedId == speller then
            Damage(config.speleffects.damage.amount, config.speleffects.damage.time)
        end
    end
end)

function Heal(amount, time)
    if amount <= 0 then return end
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    for i=1, amount do
        SetEntityHealth(ped, currentHealth + i)
        Wait(time)
    end
end

function Damage(amount, time)
    if amount <= 0 then return end
    local ped = PlayerPedId()
    local currentHealth = GetEntityHealth(ped)
    for i=1, amount do
        SetEntityHealth(ped, currentHealth - i)
        Wait(time)
    end
end

function MoveCheck(pedId, speller, coords, id)
    local ped = PlayerPedId()
    local entCoords = GetEntityCoords(ped)
    if pedId == speller then
        while ActiveSpells[speller] do
            if not ActiveSpells[speller].particles[id] then return end
            if not IsEntityPlayingAnim(ped, 'rcmbarry', 'bar_1_attack_idle_aln', 3) and ActiveSpells[speller] then
                QBCore.Functions.PlayAnim('rcmbarry', 'bar_1_attack_idle_aln', 0, -1)
            end
            entCoords = GetEntityCoords(ped)
            if #(entCoords - coords) > 5 then
                TriggerServerEvent('flex-magic:server:ForceStopSpel', speller)
            end
            Wait(1000)
        end
    end
end

RegisterNetEvent('flex-magic:client:ForceStopSpel', function(id)
    if not ActiveSpells[id] then return end
    for k, v in pairs(ActiveSpells[id].particles) do
        StopParticleFxLooped(v, 0)
    end
    ActiveSpells[id] = nil
end)