local vehicleHealthThreshold = 300.0
local speedThreshold = 10.0
local debugMode = false
local debugDelay = 2000
local hasCollided = false
local hasExploded = false

-- Toggle debug mode
RegisterCommand("debugvehicle", function()
    debugMode = not debugMode
end, false)

-- Set vehicle to be ready to explode
RegisterCommand("setexplode", function()
    local ped = GetPlayerPed(-1)
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        SetVehicleEngineHealth(vehicle, 300.0)
        TriggerEvent("chatMessage", "System", {255, 0, 0}, "Vehicle is now ready to explode.")
    else
        TriggerEvent("chatMessage", "System", {255, 0, 0}, "You are not in a vehicle.")
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 then
            local currentEngineHealth = GetVehicleEngineHealth(vehicle)
            local speed = GetEntitySpeed(vehicle) * 2.23694
            local collision = HasEntityCollidedWithAnything(vehicle)

            if collision then
                hasCollided = true
            end

            if currentEngineHealth < vehicleHealthThreshold and speed > speedThreshold and hasCollided then
                AddExplosion(GetEntityCoords(vehicle), 4, 1.0, true, false, 1.0)
                hasCollided = false
            end
        else
            hasCollided = false
        end
    end
end)

-- Debug Thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(debugDelay)
        if debugMode then
            local ped = GetPlayerPed(-1)
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            if vehicle ~= 0 then
                local currentEngineHealth = GetVehicleEngineHealth(vehicle)
                local speed = GetEntitySpeed(vehicle) * 2.23694
                local willBlowUp = (currentEngineHealth < vehicleHealthThreshold and speed > speedThreshold and hasCollided)
                
                TriggerEvent("chatMessage", "DEBUG", {255, 0, 0},
                    "Speed: " .. tostring(speed) .. "\n" ..
                    "Engine Health: " .. tostring(currentEngineHealth) .. "\n" ..
                    "Will blow up: " .. tostring(willBlowUp)
                )
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

local ped = GetPlayerPed(-1)
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle ~= 0 then
            local currentEngineHealth = GetVehicleEngineHealth(vehicle)
            local speed = GetEntitySpeed(vehicle) * 2.23694
            local collision = HasEntityCollidedWithAnything(vehicle)

            if collision then
                hasCollided = true
            end

            if not hasExploded and currentEngineHealth < vehicleHealthThreshold and speed > speedThreshold and hasCollided then
                AddExplosion(GetEntityCoords(vehicle), 4, 1.0, true, false, 1.0)
                hasCollided = false
                hasExploded = true
            end
        else
            hasCollided = false
            hasExploded = false  -- Resetting the flag when you're not in a vehicle
        end
    end
end)
