function Alert(title, message, time, type)
	SendNUIMessage({
		action = 'open',
		title = title,
		type = type,
		message = message,
		time = time,
	})
end

RegisterNetEvent('dopeNotify:Alert')
AddEventHandler('dopeNotify:Alert', function(title, message, time, type)
	Alert(title, message, time, type)
end)

---[ EXAMPLE NOTIFY (DELETE THIS BELOW) ]---

RegisterCommand('1', function()
	exports['dopeNotify']:Alert("SUCCESS", "<span style='color:#c7c7c7'>You have widthdrawn <span style='color:#069a19'><b>100$</b></span>!", 5000, 'success')
end)

RegisterCommand('2', function()
	exports['dopeNotify']:Alert("INFORMATION", "<span style='color:#c7c7c7'>Server restart in <span style='color:#fff'>5 minutes</span>!", 5000, 'info')
end)

RegisterCommand('3', function()
	exports['dopeNotify']:Alert("ERROR", "<span style='color:#c7c7c7'>You have no <span style='color:#ff0000'>permissions</span>!", 5000, 'error')
end)

RegisterCommand('4', function()
	exports['dopeNotify']:Alert("NEW SMS", "<span style='color:#ffc107'>695-2713: </span><span style='color:#c7c7c7'> How are you?", 5000, 'warning')
end)

RegisterCommand('5', function()
	exports['dopeNotify']:Alert("TWITTER", "<span style='color:#01a2dc'>@USER69: </span><span style='color:#c7c7c7'> Hello everyone!", 5000, 'sms')
end)

RegisterCommand('6', function()
	exports['dopeNotify']:Alert("SAVED", "<span style='color:#c7c7c7'>Clothes saved successfully!", 5000, 'long')
end)

---[ ALL IN ONE NOTIFY (DELETE THIS BELOW) ]---

RegisterCommand('allnoty', function()
	exports['dopeNotify']:Alert("SUCCESS", "<span style='color:#c7c7c7'>You have widthdrawn <span style='color:#069a19'><b>100$</b></span>!", 5000, 'success')
	exports['dopeNotify']:Alert("INFORMATION", "<span style='color:#c7c7c7'>Server restart in <span style='color:#fff'>5 minutes</span>!", 5000, 'info')
	exports['dopeNotify']:Alert("ERROR", "<span style='color:#c7c7c7'>You have no <span style='color:#ff0000'>permissions</span>!", 5000, 'error')
	exports['dopeNotify']:Alert("NEW SMS", "<span style='color:#ffc107'>695-2713: </span><span style='color:#c7c7c7'> How are you?", 5000, 'warning')
	exports['dopeNotify']:Alert("TWITTER", "<span style='color:#01a2dc'>@USER69: </span><span style='color:#c7c7c7'> Hello everyone!", 5000, 'sms')
	exports['dopeNotify']:Alert("SAVED", "<span style='color:#c7c7c7'>Clothes saved successfully!", 5000, 'long')
end)