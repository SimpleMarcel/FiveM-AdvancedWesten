local ESX = exports['es_extended']:getSharedObject()

ESX.RegisterUsableItem(SimpleScripts.Item.Weste100, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('SimpleWesten:100', source)
end)

ESX.RegisterUsableItem(SimpleScripts.Item.Weste25, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('SimpleWesten:25', source)
end)

ESX.RegisterUsableItem(SimpleScripts.Item.Weste50, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('SimpleWesten:50', source)
end)

RegisterNetEvent('SimpleWesteEntfernen100')
AddEventHandler('SimpleWesteEntfernen100', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(SimpleScripts.Item.Weste100, 1)
end)

RegisterNetEvent('SimpleWesteEntfernen50')
AddEventHandler('SimpleWesteEntfernen50', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(SimpleScripts.Item.Weste50, 1)
end)

RegisterNetEvent('SimpleWesteEntfernen25')
AddEventHandler('SimpleWesteEntfernen25', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(SimpleScripts.Item.Weste25, 1)
end)

RegisterCommand('useweste', function(source, args, rawCommand)
    TriggerClientEvent('SimpleWesten:25', source)
end, false)

ESX.RegisterServerCallback('esx:checkInventory', function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(item)
    if item and item.count > 0 then
        cb(true)
    else
        cb(false)
    end
end)

local SimpleDiscordWebhook = Simple.Security.Webhook 

function SendDiscordLog(content)
    local embed = {
        {
            ["color"] = Simple.Security.Farbe, 
            ["title"] = Simple.Security.Header,
            ["description"] = content,
            ["footer"] = {
            ["text"] = Simple.Security.Footer,
            },
            ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%S'),
        }
    }

    local data = {
        username = Simple.Security.Name,
        embeds = embed
    }

    SimpleSecuredPost(SimpleDiscordWebhook, function(statusCode, text, headers) end, 'POST', json.encode(data), {["Content-Type"] = 'application/json'})
end

RegisterServerEvent('Simple:Kick')
AddEventHandler('Simple:Kick', function(reason)
    local src = source
    local playerName = GetPlayerName(src)
    local playerIdentifier = GetPlayerIdentifiers(src)
    local identifiersString = ""

    for _, identifier in ipairs(playerIdentifier) do
        identifiersString = identifiersString .. "- " .. identifier .. "\n"
    end

    local discordMessage = string.format("**Spieler:** %s\n**ID:** %d\n**Grund:** %s\n\n**Identifiers:**\n%s", playerName, src, reason, identifiersString)

    if SimpleDiscordWebhook ~= nil and SimpleDiscordWebhook ~= "" then
        SendDiscordLog(discordMessage)
    end

    if Simple.Security.Kick then
    DropPlayer(src, reason)
    end
end)
