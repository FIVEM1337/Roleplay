local iscitizen = false
ESX = nil

local x, y, z = table.unpack(Config.einreise)
local angle = Config.angle_einreise

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("iscitizen") 
AddEventHandler("iscitizen", function(status)
    iscitizen = status
end)


RegisterNetEvent("citizen:teleport")
AddEventHandler("citizen:teleport", function(coords, angle)
    local x, y, z = table.unpack(coords)
    SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
	SetEntityHeading(PlayerPedId(), angle)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
		print(iscitizen)
        if iscitizen == false then
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < 250 then
            else
                SetEntityCoords(PlayerPedId(), x, y, z, false, false, false, true)
				SetEntityHeading(PlayerPedId(), angle)
            end
        end
    end
end)