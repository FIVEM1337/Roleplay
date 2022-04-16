ESX = nil
GLOBAL_PED, GLOBAL_COORDS = nil, nil

CreateThread(function()
	while not ESX do
		--Fetching esx library, due to new to esx using this.

		TriggerEvent("esx:getSharedObject", function(library) 
			ESX = library 
		end)

		Wait(0)
	end
end)

RegisterNetEvent("esx_fishing:StartFish")
AddEventHandler("esx_fishing:StartFish", function()
	print("hee")
	InitFishing(false)
end)

CreateThread(function()
	while true do
		GLOBAL_PED = PlayerPedId()
		GLOBAL_COORDS = GetEntityCoords(GLOBAL_PED, true)
		Wait(1500)
	end
end)

CreateThread(function() while true do Wait(30000) collectgarbage() end end)-- Prevents RAM LEAKS :)