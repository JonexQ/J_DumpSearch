local ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local endTime = 0
local cooldowns = {}
local isNearTrash = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local sleep = true
        local player = GetPlayerPed(-1)
        for k,v in pairs(Objects) do
            local distanceobject = Distance
            local obj = GetClosestObjectOfType(GetEntityCoords(player).x, GetEntityCoords(player).y, GetEntityCoords(player).z, distanceobject, v, false, true ,true)
            local distance = GetDistanceBetweenCoords(GetEntityCoords(player), GetEntityCoords(obj), true)

            if distance <= distanceobject then
                sleep = false
                local ObjectCoords = GetEntityCoords(obj)

                if distance <= Distance then
                    lib.showTextUI('[E] - Search Trashcan')
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
                        lib.notify({title = 'Trashcan', description = 'You have already explored this Trashcan!', position = 'top-right', type = 'info'})
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

function inside(player, obj, ObjectCoords, distance)
    if distance <= Distance then
        isNearTrash = false
        ESX.TriggerServerCallback('J_DumpSearch:getObject', function (cans)
            if cans then
                if lib.progressCircle({
                    duration = SearchingTime * 1000,
                    label = 'Searching...',
                    position = 'bottom',
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        car = true,
                        move = true,
                        combat = true,
                    },
                    anim = { -- Animation, change if you want different
                        dict = 'mini@repair',
                        clip = 'fixing_a_ped'
                    },
                }) then
                    TriggerServerEvent('J_DumpSearch:search', cans, ObjectCoords)
                    if math.random(1,100) <= BleedChance then
                        lib.notify({title = 'Trashcan', description = 'You hit something sharp', position = 'top-right', type = 'info'})
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