local tabletStatus = false

Citizen.CreateThread(function()
		while true do
			Citizen.Wait(1);
			if (IsControlJustPressed(0, 244)) then
				tabletStatus = not tabletStatus
				SetNuiFocus(tabletStatus, tabletStatus)
				SendNUIMessage({show = tabletStatus, name = GetCurrentResourceName()})
				playAnimation()
			end

			if (tabletStatus) then
				local ped = GetPlayerPed(-1)
                DisableControlAction(0, 1, tabletStatus)
                DisableControlAction(0, 2, tabletStatus)
                DisableControlAction(0, 24, tabletStatus)
                DisablePlayerFiring(ped, tabletStatus)
                DisableControlAction(0, 142, tabletStatus)
                DisableControlAction(0, 106, tabletStatus)
			end
		end
	end
)

RegisterNUICallback('close', function(data, cb)
	tabletStatus = false
	SetNuiFocus(false, false)
	SendNUIMessage({show = false})
	ClearPedTasks(PlayerPedId())
end)

function playAnimation ()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		return
	end
	local dict = "amb@world_human_tourist_map@male@base"
	local anim = "base"

	RequestAnimDict(dict)

	Citizen.CreateThread(function ()
		while not HasAnimDictLoaded(dict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(PlayerPedId(), dict, anim, 2.0, 2.0, -1, 1, 0, false, false, false)
	end)
end
