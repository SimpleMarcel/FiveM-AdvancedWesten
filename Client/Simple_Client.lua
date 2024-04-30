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



