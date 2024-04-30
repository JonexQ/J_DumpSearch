ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local objects = {}

-- Items --
local rewardTable = {
    ["standard"] = {
        [1] = { name = "ITEM", min = 1, max = 5},
    },
    ["rare"] = {
        [1] = { name = "ITEM", min = 1, max = 1},
    },
    ["epic"] = {
        [1] = { name = "ITEM", min = 1, max = 1},
    },
    ["weapons"] = {
        [1] = { name = "WEAPON_NAME", weapon = true},
    }
}

RegisterNetEvent('J_DumpSearch:search')
AddEventHandler('J_DumpSearch:search', function(object, obj)
    local chance = math.random(1,300)
    if chance >= 1 and chance <= 264 then
        class = "standard"
    elseif chance >= 265 and chance <= 293 then
        class = "rare"
    elseif chance >= 294 and chance <= 296 then
        class = "weapons"
    else
        class = "epic"
    end
    local item = math.random(1,#rewardTable[class])

    if rewardTable[class][item].weapon == true then
        exports['ox_inventory']:AddItem(source, rewardTable[class][item].name, 1)
    else
        local amount = math.random(rewardTable[class][item].min, rewardTable[class][item].max)
        exports['ox_inventory']:AddItem(source, rewardTable[class][item].name, amount)
    end
end)

ESX.RegisterServerCallback('J_DumpSearch:getObject', function(source, cb, object)
    local player = ESX.GetPlayerFromId(source)

    if not objects[object] then
        cb(true)
    else
        cb(false)
    end
end)