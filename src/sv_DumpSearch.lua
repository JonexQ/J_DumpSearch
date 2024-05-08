ESX = nil
ESX = exports["es_extended"]:getSharedObject()

local objects = {}

-- Itemit --
local rewardTable = {
    ["standard"] = {
        [1] = { name = "panties", min = 1, max = 5},
        [2] = { name = "cola", min = 1, max = 2},
        [3] = { name = "burger", min = 1, max = 1},
        [4] = { name = "garbage", min = 1, max = 3},
        [5] = { name = "stone", min = 1, max = 1},
        [6] = { name = "wood_plank", min = 1, max = 1},
        [7] = { name = "mustard", min = 1, max = 1},
    },
    ["rare"] = {
        [1] = { name = "classic_phone", min = 1, max = 1},
        [2] = { name = "scratch_ticket", min = 1, max = 2},
        [3] = { name = "money", min = 10, max = 25},
        [4] = { name = "weed_joint", min = 1, max = 2},
        [5] = { name = "bandage", min = 1, max = 2},
        [6] = { name = "muoviromu", min = 1, max = 2},
        [7] = { name = "spade", min = 1, max = 1},
    },
    ["epic"] = {
        [1] = { name = "lockpick", min = 1, max = 1},
        [2] = { name = "mysteeriaine", min = 1, max = 1},
        [3] = { name = "coke_pure", min = 1, max = 1},
        [4] = { name = "radio", min = 1, max = 1},
        [5] = { name = "gold_phone", min = 1, max = 1},
        [6] = { name = "diamond", min = 1, max = 1},
    },
    ["weapons"] = {
        [1] = { name = "WEAPON_BOTTLE", weapon = true},
    }
}

RegisterNetEvent('dyykkaus:search')
AddEventHandler('dyykkaus:search', function(object, obj)
    local src = source
    local lucky = math.random(1,300)
    if lucky >= 1 and lucky <= 264 then
        class = "standard"
    elseif lucky >= 265 and lucky <= 293 then
        class = "rare"
    elseif lucky >= 294 and lucky <= 296 then
        class = "weapons"
    else
        class = "epic"
    end
    local item = math.random(1,#rewardTable[class])

    if rewardTable[class][item].weapon == true then
        exports['ox_inventory']:AddItem(src, rewardTable[class][item].name, 1)
    else
        local amount = math.random(rewardTable[class][item].min, rewardTable[class][item].max)
        exports['ox_inventory']:AddItem(src, rewardTable[class][item].name, amount)
    end
end)

ESX.RegisterServerCallback('dyykkaus:getObject', function(source, cb, object)
    local player = ESX.GetPlayerFromId(source)

    if not objects[object] then
        cb(true)
    else
        cb(false)
    end
end)
