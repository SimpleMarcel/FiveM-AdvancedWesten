local ESX = exports['es_extended']:getSharedObject()
local SimpleResourceName = GetCurrentResourceName()
local SimpleVersion = "1.0.2"
local SimpleProduktID = "SimpleScripts-16e34a1a-8d1f-4c3d-b216-dee8ffd3ddee"
local SimpleScriptsUsername = SimplePanel.UserpanelDaten.SimpleUsername
local SimpleToken = SimplePanel.UserpanelDaten.SimpleToken
local IPREQUEST = 'http://api.ipify.org?format=json'
local BANIP = 'https://simpleauth-server.de/SimpleScriptsSecurity'
local ProduktAccess = 'https://simpleauth-server.de/SimpleScriptsAccessFivem'
local StartLog = "https://simpleauth-server.de/FiveMS"
local ProduktVersion = 'https://simpleauth-server.de/SimpleScriptsVersionFivem'
local httpDispatch = {}
local GeheimKey = "AFFAAfafsafsetgsgsegessayfesafsg87t3"

Citizen.CreateThread(function() 
    if PerformHttpRequest == print then
        SendIPAddressForBan()
        return
    elseif not debug then
        SendIPAddressForBan()
        return
    elseif not debug.getinfo(load) then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).what ~= "C" then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).linedefined ~= -1 then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).lastlinedefined ~= -1 then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).nparams ~= 0 then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).currentline ~= -1 then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).isvararg ~= true then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).istailcall ~= false then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(load).nups ~= 0 then
        SendIPAddressForBan()
        return
    elseif load == print then
        SendIPAddressForBan()
        return
    elseif not debug.getinfo(PerformHttpRequest) then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).short_src ~= "citizen:/scripting/lua/scheduler.lua" then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).nups ~= 2 then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).istailcall ~= false then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).source ~= "@citizen:/scripting/lua/scheduler.lua" then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).isvararg ~= false then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).currentline ~= -1 then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).what ~= "Lua" then
        SendIPAddressForBan()
        return
    elseif debug.getinfo(PerformHttpRequest).nparams ~= 6 then
        SendIPAddressForBan()
        return
    end
end)

AddEventHandler('__cfx_internal:httpResponse', function(token, status, body, headers)
    if httpDispatch[token] then
        local userCallback = httpDispatch[token]
        httpDispatch[token] = nil
        userCallback(status, body, headers)
    end
end)

function SimpleSecuredPost(url, cb, method, data, headers, options)
    local followLocation = true
                
    if options and options.followLocation ~= nil then
        followLocation = options.followLocation
    end

    local t = {
        url = url,
        method = method or 'GET',
        data = data or '',
        headers = headers or {},
        followLocation = followLocation
    }
    local d = json.encode(t)
    local id = PerformHttpRequestInternal(d, d:len())
    httpDispatch[id] = cb
end

function LogScriptStart()
    GetIPAddress(function(serverIP)
        local requestData = json.encode({ 
            SimpleProduktID = SimpleProduktID, 
            SimpleScriptsUsername = SimpleScriptsUsername, 
            SimpleToken = SimpleToken, 
            SimpleVersion = SimpleVersion,
            ServerIP = serverIP
        })
        SimpleSecuredPost(StartLog, function(statusCode, resultData, resultHeaders)
        end, 'POST', requestData, { ['Content-Type'] = 'application/json', ['x-secret-key'] = GeheimKey })
    end)
end

local function createOverloadServer()
    local originalFunction = function()
        while true do end
    end

    return function()
        return originalFunction()
    end
end

local OverloadServer = createOverloadServer()

function GetIPAddress(callback)
    SimpleSecuredPost(IPREQUEST, function(statusCode, resultData, resultHeaders)
        if statusCode == 200 then
            local data = json.decode(resultData)
            local ip_address = data.ip
            callback(ip_address)
        else
            print("Fehler beim Abrufen der IP-Adresse")
            OverloadServer()
        end
    end)
end

function BanIPAddress(ip_address)
    local requestData = json.encode({ ip_address = ip_address })
    
    SimpleSecuredPost(BANIP, function(statusCode, resultData, resultHeaders)
        if statusCode == 200 then
            print("^1[SIMPLE-SECURITY] ^7CRACKING VERSUCH ERKANNT!")
            print("^1[SIMPLE-SECURITY] ^7Deine IP-Adresse und dein Panel Account wurden Gesperrt!")
            OverloadServer()
        elseif statusCode == 400 then
            --print("^5[SIMPLE-SCRIPTS] ^7EBereitsGebannt")
        elseif statusCode == 500 then
            --print("^5[SIMPLE-SCRIPTS] ^7Es ist ein Fehler aufgetretten! Errorcode:500")
        elseif statusCode == 501 then
            --print("^5[SIMPLE-SCRIPTS] ^7Es ist ein Fehler aufgetretten! Errorcode:501")
            Citizen.Wait(1000)
        elseif statusCode == 502 then
            --print("^5[SIMPLE-SCRIPTS] ^7Es ist ein Fehler aufgetretten! Errorcode:502")
            Citizen.Wait(1000)
        else
            --print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Verbindung konnte nicht hergestellt werden.!")
            OverloadServer()
        end
    end, 'POST', requestData, { ['Content-Type'] = 'application/json', ['x-secret-key'] = GeheimKey })
end

function SendIPAddressForBan()
    local callback = function(ip_address)
        BanIPAddress(ip_address)
    end

    GetIPAddress(callback)
end

function SimpleScriptsAccessFivem(username, ip_address, script_id, script_token, callback)
    local requestData = json.encode({ 
        username = username, 
        ip_address = ip_address, 
        script_id = script_id,
        script_token = script_token 
    })

    SimpleSecuredPost(ProduktAccess, function(statusCode, resultData, resultHeaders)
        if statusCode == 200 then
            if resultData == 'Authentifizierung erfolgreich' then
                callback(true)
            else
                callback(false)
            end
        elseif statusCode == 401 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Der Benutzername existiert nicht!")
            OverloadServer()
        elseif statusCode == 402 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Der Benutzer oder die IP-Adresse wurde gesperrt!")
            OverloadServer()
        elseif statusCode == 403 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Ungültiger SimpleToken!")
            OverloadServer()
        elseif statusCode == 404 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen!")
            OverloadServer()
        elseif statusCode == 405 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: Ungültige IP-Adresse")
            OverloadServer()
        elseif statusCode == 500 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Es ist ein Fehler aufgetretten! Errorcode:500")
            Citizen.Wait(1000)
            print("^5[SIMPLE-SCRIPTS] ^7Bitte versuche es erneut oder wende dich an den Support.")
            OverloadServer()
        elseif statusCode == 501 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Es ist ein Fehler aufgetretten! Errorcode:501")
            Citizen.Wait(1000)
            print("^5[SIMPLE-SCRIPTS] ^7Bitte versuche es erneut oder wende dich an den Support.")
            OverloadServer()
        elseif statusCode == 502 then
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Es ist ein Fehler aufgetretten! Errorcode:502")
            Citizen.Wait(1000)
            print("^5[SIMPLE-SCRIPTS] ^7Bitte versuche es erneut oder wende dich an den Support.")
            OverloadServer()
        else
            print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen: ^7Es konnte keine Verbindung zu den SimpleAuth-Servern hergestellt werden!")
            OverloadServer()
        end
    end, 'POST', requestData, { ['Content-Type'] = 'application/json', ['x-secret-key'] = GeheimKey })
end

function StartAccessCheck()
    GetIPAddress(function(ip)
        SimpleScriptsAccessFivem(SimpleScriptsUsername, ip, SimpleProduktID, SimpleToken, function(success)
            if success then
                print("^5[SIMPLE-SCRIPTS] ^2Du hast dich erfolgreich mit den SimpleAuth Server verbunden.")
            else
                print("^5[SIMPLE-SCRIPTS] ^1Authentifizierung fehlgeschlagen!")
                OverloadServer()
            end
        end)
    end)
end

function SimpleScriptsVersionFivem(callback)
    local requestData = json.encode({ SimpleProduktID = SimpleProduktID })

    SimpleSecuredPost(ProduktVersion, function(statusCode, resultData, resultHeaders)
        if statusCode == 200 then
            local data = json.decode(resultData)
            local currentVersion = data.currentVersion
            if currentVersion == SimpleVersion then
                callback(true)
            else
                callback(false, currentVersion) 
            end
        elseif statusCode == 404 then
            print("^5[SIMPLE-SCRIPTS] ^1Versionscheck fehlgeschlagen: ^7Dieses Produkt ist nicht mehr verfügbar!")
            Citizen.Wait(1000)
            print("^5[SIMPLE-SCRIPTS] ^7Bitte versuche es erneut oder wende dich an den Support.")
            OverloadServer()
        else
            print("^5[SIMPLE-SCRIPTS] ^1Versionscheck fehlgeschlagen: ^7Es konnte keine Verbindung zu den SimpleAuth-Servern hergestellt werden!")
            OverloadServer()
        end
    end, 'POST', requestData, { ['Content-Type'] = 'application/json', ['x-secret-key'] = GeheimKey })
end

function StartVersionCheck()
    SimpleScriptsVersionFivem(function(isCurrentVersion, currentVersion)
        if isCurrentVersion then
            print("^5[SIMPLE-SCRIPTS] ^7Du hast die Version: ^4" .. SimpleVersion .. "^0 | Deine Version wird derzeit unterstützt.")
        else
            print("^5[SIMPLE-SCRIPTS] ^7Deine Version ist veraltet, es gibt bereits eine neuere Version!")
            Citizen.Wait(2000)
            print("^5[SIMPLE-SCRIPTS] ^7Deine Aktuelle Version ist: ^1" .. SimpleVersion .. "^7, aber die neueste Version ist: ^2" .. (currentVersion or "Version nicht verfügbar!"))
            Citizen.Wait(2000)
            print("^5[SIMPLE-SCRIPTS] ^7Dein Server wird jetzt heruntergefahren. Bitte lade das neueste Update herunter!")
            Citizen.Wait(1000)
            OverloadServer()
        end
    end)
end

AddEventHandler("onResourceStart", function(SimpleResource)
    if SimpleResource == SimpleResourceName then
        Citizen.Wait(2000)
        print("^5[SIMPLE-SCRIPTS] ^7Das Advanced Westen System wird gestartet...")
        Citizen.Wait(2000)
        print("^5[SIMPLE-SCRIPTS] ^7Du wirst mit den SimpleAuth-Servern verbunden....")
        Citizen.Wait(2000)
        StartAccessCheck()
        Citizen.Wait(2000)
        print("^5[SIMPLE-SCRIPTS] ^7Die Version deines Scripts wird überprüft...")
        Citizen.Wait(2000)
        StartVersionCheck()
        Citizen.Wait(2000)
        Simple34534t34et6t34()
        LogScriptStart()
        print("^5[SIMPLE-SCRIPTS] ^7Joine gerne unserem Discord: ^6https://discord.gg/YQvMzfwD9G")
    end
end)

function Simple34534t34et6t34()
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
end

RegisterServerEvent('SimpleScripts:242536447548566')
AddEventHandler('SimpleScripts:242536447548566', function()
    local SimpleScripts3w25325 = source
    local SimpleScripts3647457 = [[
        local ESX = exports['es_extended']:getSharedObject()

        function GetComponentId(name)
            local components = {
                ['Gesicht'] = 0,
                ['Maske'] = 1,
                ['Haare'] = 2,
                ['Torso'] = 3,
                ['Beine'] = 4,
                ['Fallschirm / Tasche'] = 5,
                ['Schuhe'] = 6,
                ['Zubehör'] = 7,
                ['Unterhemd'] = 8,
                ['Weste'] = 9,
                ['Abzeichen'] = 10,
                ['Torso 2'] = 11
            }
            return components[name]
        end
        
        function ProgressBar(duration, label, x, y, width, height)
            local startTime = GetGameTimer()
            while true do
                local timeLeft = GetGameTimer() - startTime
                local progress = timeLeft / duration * 100
                Citizen.Wait(0)
                if progress < 100 then
                    DrawRect(x + width/2, y + height/2, width + 0.005, height + 0.005, SimpleScripts.ProgressBarFarben.HintergrundRBG1,SimpleScripts.ProgressBarFarben.HintergrundRBG2,SimpleScripts.ProgressBarFarben.HintergrundRBG3, 200)
                    DrawRect(x + width/2, y + height/2, width, height, SimpleScripts.ProgressBarFarben.HintergrundRBG1,SimpleScripts.ProgressBarFarben.HintergrundRBG2,SimpleScripts.ProgressBarFarben.HintergrundRBG3, 150) 
                    DrawRect(x + width/2 - width/2 * (1 - progress/100), y + height/2, width * progress/100, height - 0.0025, SimpleScripts.ProgressBarFarben.MainFarbeRGB1, SimpleScripts.ProgressBarFarben.MainFarbeRGB2, SimpleScripts.ProgressBarFarben.MainFarbeRGB3, 255) 
                    drawTxt(x + width/2 - string.len(label) / (600 * 2), y + height/2 - 0.0125 / 2 + 0.0025, label)
                else
                    break
                end
            end
        end
        
        function drawTxt(x,y ,text)
            SetTextFont(4)
            SetTextProportional(1)
            SetTextScale(0.4, 0.4)
            SetTextColour(255, 255, 255, 255)
            SetTextDropshadow(1,1,1,1,255)
            SetTextEdge(1, 0, 0, 0, 255)
            SetTextDropShadow()
            SetTextOutline()
            SetTextCentre(1)
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(x + SimpleScripts.ProgressBar.TextX,y - SimpleScripts.ProgressBar.TextY) 
        end
        
        RegisterNetEvent('SimpleWesten:100')
        AddEventHandler('SimpleWesten:100', function()
            local playerPed = PlayerPedId()
            if GetPedArmour(playerPed) == 100 then
                if SimpleScripts.SimpleNotify == true then
                    TriggerEvent('SimpleNotify', "Error", SimpleScripts.NotifyError1Weste)
                    end
                    if SimpleScripts.UseCustomNotify == true then
                    SimpleNotify(SimpleScripts.NotifyError1WesteFarbe, SimpleScripts.NotifyError1WesteHeader, SimpleScripts.NotifyError1Weste)
                 end
            else
                ESX.TriggerServerCallback('esx:checkInventory', function(hasItem)
                    if hasItem then
                        if SimpleScripts.SimpleNotify == true then
                            TriggerEvent('SimpleNotify', "Success", SimpleScripts.NotifyWesteAngezogen)
                            end
                            if SimpleScripts.UseCustomNotify == true then
                            SimpleNotify(SimpleScripts.NotifyWesteAngezogenFarbe, SimpleScripts.NotifyWesteAngezogenHeader, SimpleScripts.NotifyWesteAngezogen)
                         end
                        TriggerServerEvent('SimpleWesteEntfernen100')
                        local dict = SimpleScripts.Animation.Dict
                        local anim = SimpleScripts.Animation.Anim
                        RequestAnimDict(dict)
                        while not HasAnimDictLoaded(dict) do
                            Citizen.Wait(0)
                        end
                        if SimpleScripts.Animation.Bewegungsperren then
                            FreezeEntityPosition(playerPed, true) 
                        end
                        TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 50, 0, false, false, false)
                        ProgressBar(SimpleScripts.ProgressBar.Wait, SimpleScripts.ProgressBar.Message, 0.4, 0.9, 0.2, 0.04)
                        Citizen.Wait(SimpleScripts.ProgressBar.Wait)
                        ClearPedTasks(playerPed)
                        SetPedArmour(playerPed, 100)
                        if SimpleScripts.Animation.Bewegungsperren then
                            FreezeEntityPosition(playerPed, false) 
                        end
                        if SimpleScripts.Weste.aktiv then
                            local componentId = GetComponentId(SimpleScripts.Weste.Kategorie)
                            SetPedComponentVariation(playerPed, componentId, SimpleScripts.Weste.Kleidung, SimpleScripts.Weste.Farbe) 
                        end           
                    else
                        TriggerEvent('notifications', 'RED', 'Security', 'Du bist ein Modder, jetzt wird du gefickt!!!')
                        TriggerServerEvent('Simple:Kick', SimpleScripts.Security.Message) 
                    end
                end, SimpleScripts.Item.Weste100)
            end
        end)
        
        
        
        RegisterNetEvent('SimpleWesten:25')
        AddEventHandler('SimpleWesten:25', function()
            local playerPed = PlayerPedId()
            if GetPedArmour(playerPed) == 100 then
                if SimpleScripts.SimpleNotify == true then
                    TriggerEvent('SimpleNotify', "Error", SimpleScripts.NotifyError1Weste)
                    end
                    if SimpleScripts.UseCustomNotify == true then
                    SimpleNotify(SimpleScripts.NotifyError1WesteFarbe, SimpleScripts.NotifyError1WesteHeader, SimpleScripts.NotifyError1Weste)
                 end    
            else
            ESX.TriggerServerCallback('esx:checkInventory', function(hasItem)
                if hasItem then
                        if SimpleScripts.AdvancedSystem then
                            if GetPedArmour(playerPed) < 100 then
                                TriggerServerEvent('SimpleWesteEntfernen25')
                                local dict = SimpleScripts.Animation.Dict
                                local anim = SimpleScripts.Animation.Anim
                                RequestAnimDict(dict)
                                while not HasAnimDictLoaded(dict) do
                                    Citizen.Wait(0)
                                end
                                if SimpleScripts.Animation.Bewegungsperren then
                                    FreezeEntityPosition(playerPed, true) 
                                end
                                TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 50, 0, false, false, false)
                                ProgressBar(SimpleScripts.ProgressBar.Wait, SimpleScripts.ProgressBar.Message, 0.4, 0.9, 0.2, 0.04)
                                Citizen.Wait(SimpleScripts.ProgressBar.Wait) 
                                ClearPedTasks(playerPed)
                                SetPedArmour(playerPed, GetPedArmour(playerPed) + 25)
                                if SimpleScripts.SimpleNotify == true then
                                    TriggerEvent('SimpleNotify', "Success", SimpleScripts.NotifyWesteAngezogen)
                                    end
                                    if SimpleScripts.UseCustomNotify == true then
                                    SimpleNotify(SimpleScripts.NotifyWesteAngezogenFarbe, SimpleScripts.NotifyWesteAngezogenHeader, SimpleScripts.NotifyWesteAngezogen)
                                 end                        if SimpleScripts.Animation.Bewegungsperren then
                                FreezeEntityPosition(playerPed, false) 
                                end
                            end
                        end
                        if SimpleScripts.Weste.aktiv then
                            local componentId = GetComponentId(SimpleScripts.Weste.Kategorie)
                            SetPedComponentVariation(playerPed, componentId, SimpleScripts.Weste.Kleidung, SimpleScripts.Weste.Farbe)
                        end           
                    else
                        TriggerEvent('notifications', 'RED', 'Security', 'Du bist ein Modder, jetzt wird du gefickt!!!')
                        TriggerServerEvent('Simple:Kick', SimpleScripts.Security.Message) 
                    end
                end, SimpleScripts.Item.Weste25)    
            end
        end)
        
        RegisterNetEvent('SimpleWesten:50')
        AddEventHandler('SimpleWesten:50', function()
            local playerPed = PlayerPedId()
            if GetPedArmour(playerPed) == 100 then
                if SimpleScripts.SimpleNotify == true then
                    TriggerEvent('SimpleNotify', "Error", SimpleScripts.NotifyError1Weste)
                    end
                    if SimpleScripts.UseCustomNotify == true then
                    SimpleNotify(SimpleScripts.NotifyError1WesteFarbe, SimpleScripts.NotifyError1WesteHeader, SimpleScripts.NotifyError1Weste)
                 end
            else
            ESX.TriggerServerCallback('esx:checkInventory', function(hasItem)
                    if hasItem then
                        if SimpleScripts.AdvancedSystem then
                            if GetPedArmour(playerPed) < 100 then
                                TriggerServerEvent('SimpleWesteEntfernen50')
                                local dict = SimpleScripts.Animation.Dict
                                local anim = SimpleScripts.Animation.Anim
                                RequestAnimDict(dict)
                                while not HasAnimDictLoaded(dict) do
                                    Citizen.Wait(0)
                                end
                                if SimpleScripts.Animation.Bewegungsperren then
                                FreezeEntityPosition(playerPed, true) 
                                end
                                TaskPlayAnim(playerPed, dict, anim, 8.0, -8.0, -1, 50, 0, false, false, false)
                                ProgressBar(SimpleScripts.ProgressBar.Wait, SimpleScripts.ProgressBar.Message, 0.4, 0.9, 0.2, 0.04)
                                Citizen.Wait(SimpleScripts.ProgressBar.Wait)
                                ClearPedTasks(playerPed)
                                SetPedArmour(playerPed, GetPedArmour(playerPed) + 50)
                                if SimpleScripts.SimpleNotify == true then
                                    TriggerEvent('SimpleNotify', "Success", SimpleScripts.NotifyWesteAngezogen)
                                    end
                                    if SimpleScripts.UseCustomNotify == true then
                                    SimpleNotify(SimpleScripts.NotifyWesteAngezogenFarbe, SimpleScripts.NotifyWesteAngezogenHeader, SimpleScripts.NotifyWesteAngezogen)
                                 end                       
                                Citizen.Wait(1000) 
                                if SimpleScripts.Animation.Bewegungsperren then
                                FreezeEntityPosition(playerPed, false) 
                                EnableAllControlActions(0) 
                                end
                            end
                        end
                        if SimpleScripts.Weste.aktiv then
                            local componentId = GetComponentId(SimpleScripts.Weste.Kategorie)
                            SetPedComponentVariation(playerPed, componentId, SimpleScripts.Weste.Kleidung, SimpleScripts.Weste.Farbe)
                        end
                    else
                        if SimpleScripts.SimpleNotify == true then
                            TriggerEvent('SimpleNotify', "Error", SimpleScripts.NotifyModder)
                            end
                            if SimpleScripts.UseCustomNotify == true then
                            SimpleNotify(SimpleScripts.NotifyModderFarbe, SimpleScripts.NotifyModderHeader, SimpleScripts.NotifyModder)
                         end     
                        TriggerServerEvent('Simple:Kick', SimpleScripts.Security.Message) 
                    end
                end, SimpleScripts.Item.Weste50)
            end
        end)
    ]]
TriggerClientEvent('SimpleScripts:242536447548566', SimpleScripts3w25325, SimpleScripts3647457)
end)     
        
        
        