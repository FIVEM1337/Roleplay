local open = false

-- Open ID card
RegisterNetEvent('esx_visum:open')
AddEventHandler('esx_visum:open', function( data )
	open = true
	SendNUIMessage({
		action = "open",
		array  = data
	})
end)

-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, 322) and open or IsControlJustReleased(0, 177) and open then
			SendNUIMessage({
				action = "close"
			})
			open = false
		end
	end
end)
