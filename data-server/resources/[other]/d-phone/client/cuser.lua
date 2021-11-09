RegisterNetEvent("d-customnotification")
AddEventHandler("d-customnotification", function(text, length, color)
    local color = color
    local length = length
    if color ~= nil then 
        color = "black"
    end
    if length ~= nil then 
        length = 4000
    end

    -- THIS IS AN EXAMPLE IF YOU WANT TO USE THE NORMAL ESX NOTIFIICATION
    ESX.ShowNotification(text)

    -- TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = text, length = length, style = { ['background-color'] = color, ['color'] = '#fff' } })
end)

--[[
Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}
]]

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if Phoneopen == true then
			for _,v in pairs(Keys) do
				DisableControlAction(0, v, true)
			end
			-- DisableControlAction(0, 1, true) -- Disable pan
			-- DisableControlAction(0, 2, true) -- Disable tilt
			-- DisableControlAction(0, 24, true) -- Attack
			-- DisableControlAction(0, 257, true) -- Attack 2
			-- DisableControlAction(0, 25, true) -- Aim
			-- DisableControlAction(0, 263, true) -- Melee Attack 1

			-- DisableControlAction(0, 45, true) -- Reload
			-- DisableControlAction(0, 22, true) -- Jump
			-- DisableControlAction(0, 44, true) -- Cover
			-- DisableControlAction(0, 37, true) -- Select Weapon

			-- DisableControlAction(0, 288,  true) -- Disable phone
			-- DisableControlAction(0, 289, true) -- Inventory
			-- DisableControlAction(0, 170, true) -- Animations
			-- DisableControlAction(0, 167, true) -- Job

			-- DisableControlAction(0, 0, true) -- Disable changing view
			-- DisableControlAction(0, 26, true) -- Disable looking behind
			-- DisableControlAction(0, 73, true) -- Disable clearing animation
			-- DisableControlAction(2, 199, true) -- Disable pause screen

			-- DisableControlAction(0, 47, true)  -- Disable weapon
			-- DisableControlAction(0, 264, true) -- Disable melee
			-- DisableControlAction(0, 257, true) -- Disable melee
			-- DisableControlAction(0, 140, true) -- Disable melee
			-- DisableControlAction(0, 141, true) -- Disable melee
			-- DisableControlAction(0, 142, true) -- Disable melee
			-- DisableControlAction(0, 143, true) -- Disable melee

            -- DisableControlAction(0, 200, true)
            -- DisableControlAction(0, 106, true) -- VehicleMouseControlOverride

			-- DisableControlAction(0, 245, true) -- T
			-- DisableControlAction(0, 44, true) -- T
			-- DisableControlAction(0, 157, true) -- T
			-- DisableControlAction(0, 158, true) -- T
			-- DisableControlAction(0, 160, true) -- T
			-- DisableControlAction(0, 164, true) -- T
			-- DisableControlAction(0, 165, true) -- T
			-- DisableControlAction(0, 159, true) -- T
			-- DisableControlAction(0, 161, true) -- T
			-- DisableControlAction(0, 162, true) -- T
			-- DisableControlAction(0, 163, true) -- T
			-- DisableControlAction(0, 44, true) -- T
			-- DisableControlAction(0, 44, true) -- T
		else
			Citizen.Wait(500)
		end
	end
end)