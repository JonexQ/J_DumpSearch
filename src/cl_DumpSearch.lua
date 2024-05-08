local ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local endTime = 0
local cooldowns = {}
local isNearTrash = false

RegisterNetEvent("Zoni:silmäroskis")
AddEventHandler("Zoni:silmäroskis", function()
    local player = GetPlayerPed(-1)
    local closestObj, closestDist

    -- Tarkista kaikki roskikset
    for _, model in ipairs({"prop_bin_01a", "prop_bin_05a", "prop_bin_06a", "prop_bin_07a", "prop_bin_07b", "prop_bin_07c", "prop_bin_07d", "prop_bin_08a", "prop_dumpster_4b", "prop_dumpster_01a", "prop_dumpster_02a", "prop_dumpster_02b"}) do
        local obj = GetClosestObjectOfType(GetEntityCoords(player).x, GetEntityCoords(player).y, GetEntityCoords(player).z, Distance, GetHashKey(model), false, true, true)
        local distance = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(obj), true)

        if distance < (closestDist or Distance) then
            closestObj = obj
            closestDist = distance
        end
    end

    if closestDist and closestDist <= Distance then
        local cooldown = cooldowns[closestObj] or 0
        local currentTime = GetGameTimer()

        if currentTime > cooldown then
            ESX.TriggerServerCallback('dyykkaus:getObject', function(cans)
                if cans then
                    if lib.progressCircle({
                        duration = TutkimisAika * 1000,
                        label = 'Tutkitaan...',
                        position = 'bottom',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true,
                        },
                        anim = {
                            dict = 'mini@repair',
                            clip = 'fixing_a_ped'
                        },
                    }) then
                        TriggerServerEvent('dyykkaus:search', cans, GetEntityCoords(closestObj))
                        cooldowns[closestObj] = currentTime + SearchCooldown * 60000
                        if math.random(1, 100) <= BleedChance then
                            lib.notify({title = 'Roskakori', description = 'Osuit johonkin terävään', position = 'top-right', type = 'info'})
                            local endTime = GetGameTimer() + BleedTime * 1000
                            while GetGameTimer() < endTime do
                                SetEntityHealth(player, GetEntityHealth(player) - BleedDamage)
                                StartScreenEffect('Rampage', 0, true)
                                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE ", 0.25)
                                SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
                                Wait(1000)
                            end
                            AnimpostfxStopAll()
                            ShakeGameplayCam("SMALL_EXPLOSION_SHAKE ", 0.0)
                            SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
                        end
                    end
                end
            end)
        else
            local remainingTime = math.ceil((cooldown - currentTime) / 1000)
            if remainingTime > 0 then
                lib.notify({title = 'Roskakori', description = 'Olet jo tutkinut tämän roskiksen!', position = 'top-right', type = 'info'})
            end
        end
    end
end)

if not UseTextUI then
    local options = {{
        name = 'atm',
        event = 'Zoni:silmäroskis',
        icon = 'fa-solid fa-dumpster',
        label = OxLibTextSwap['fi']['Search Trashcan']
    }}

    exports.ox_target:addModel({"prop_bin_01a", "prop_bin_05a", "prop_bin_06a", "prop_bin_07a", "prop_bin_07b", "prop_bin_07c", "prop_bin_07d", "prop_bin_08a", "prop_dumpster_4b", "prop_dumpster_01a", "prop_dumpster_02a", "prop_dumpster_02b"}, options)
else
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            local sleep = true
            local player = GetPlayerPed(-1)
            for k,v in pairs({"prop_bin_01a", "prop_bin_05a", "prop_bin_06a", "prop_bin_07a", "prop_bin_07b", "prop_bin_07c", "prop_bin_07d", "prop_bin_08a", "prop_dumpster_4b", "prop_dumpster_01a", "prop_dumpster_02a", "prop_dumpster_02b"}) do
                local distanceobject = Distance
                local obj = GetClosestObjectOfType(GetEntityCoords(player).x, GetEntityCoords(player).y, GetEntityCoords(player).z, distanceobject, GetHashKey(v), false, true ,true)
                local distance = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(obj), true)

                if distance <= distanceobject then
                    sleep = false
                    local ObjectCoords = GetEntityCoords(obj)

                    if distance <= Distance then
                        lib.showTextUI(OxLibTextSwap['fi']['Search_Trashcan'])
                        isNearTrash = true
                    elseif isNearTrash then
                        lib.hideTextUI()
                        isNearTrash = false
                    end

                    local cooldown = cooldowns[obj] or 0
                    local currentTime = GetGameTimer()

                    if IsControlJustPressed(0, 38) and IsPedOnFoot(player) then
                        if currentTime > cooldown then
                            inside(player, obj, ObjectCoords, distance)
                            cooldowns[obj] = currentTime + SearchCooldown * 60000
                        else
                            local remainingTime = math.ceil((cooldown - currentTime) / 1000)
                            lib.notify({title = 'Roskakori', description = 'Olet jo tutkinut tämän roskiksen!', position = 'top-right', type = 'info'})
                        end
                    end
                end
            end
            if sleep then
                lib.hideTextUI()
                isNearTrash = false
                Citizen.Wait(500)
            end
        end
    end)
end

function inside(player, obj, ObjectCoords, distance)
    if distance <= Distance then
        isNearTrash = false
        ESX.TriggerServerCallback('dyykkaus:getObject', function (cans)
            if cans then
                if lib.progressCircle({
                    duration = TutkimisAika * 1000,
                    label = 'Tutkitaan...',
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                    anim = {
                        dict = 'mini@repair',
                        clip = 'fixing_a_ped'
                    },
                }) then
                    TriggerServerEvent('dyykkaus:search', cans, ObjectCoords)
                    if math.random(1,100) <= BleedChance then
                        lib.notify({title = 'Roskakori', description = 'Osuit johonkin terävään', position = 'top-right', type = 'info'})
                        local endTime = GetGameTimer() + BleedTime * 1000
                        while GetGameTimer() < endTime do
                            SetEntityHealth(player, GetEntityHealth(player) - BleedDamage)
                            StartScreenEffect('Rampage', 0, true)
                            ShakeGameplayCam("SMALL_EXPLOSION_SHAKE ", 0.25)
                            SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
                            Wait(1000)
                        end
                        AnimpostfxStopAll()
                        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE ", 0.0)
                        SetPlayerHealthRechargeMultiplier(PlayerId(), 1.0)
                    end
                end
            end
        end)
    end
end
