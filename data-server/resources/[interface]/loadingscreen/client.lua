local finished = false

-- Wait until client is loaded into the map
AddEventHandler("playerSpawned", function ()
	if not finished then
		ShutdownLoadingScreenNui()
		finished = true
	end
end)
