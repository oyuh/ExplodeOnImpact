RegisterServerEvent('SetVehicleReadyToExplode')
AddEventHandler('SetVehicleReadyToExplode', function()
    local _source = source
    TriggerClientEvent('ClientSetVehicleReadyToExplode', _source)
end)

RegisterServerEvent('ExplodeVehicle')
AddEventHandler('ExplodeVehicle', function(vehicle)
    TriggerClientEvent('ClientExplodeVehicle', -1, vehicle)
end)

RegisterNetEvent('ClientExplodeVehicle')
AddEventHandler('ClientExplodeVehicle', function(vehicle)
    if DoesEntityExist(vehicle) then
        AddExplosion(GetEntityCoords(vehicle), 4, 1.0, true, false, 1.0)
    end
end)
