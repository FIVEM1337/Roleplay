local displayTime = true
local displayDate = true
local offset = 2
local show = false

local timeAndDateString = nil

function CalculateTimeToDisplay()
	if month <= 9 then
		month = 0 .. month
	end
	if dayOfWeek <= 9 then
		dayOfWeek = 0 .. dayOfWeek
	end
	if hour <= 9 then
		hour = 0 .. hour
	end
	if minute <= 9 then
		minute = 0 .. minute
	end

	if secound <= 9 then
		secound = 0 .. secound
	end
end


Citizen.CreateThread(function()
	while true do
		Wait(1)

		if IsMinimapRendering() then
			show = true
		else
			show = false
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if show then
			year, month, dayOfWeek, hour, minute, secound = GetLocalTime()
			hour = hour + offset
			timeAndDateString = ""
			CalculateTimeToDisplay()
			if displayDate == true then
				timeAndDateString = timeAndDateString .. " " .. dayOfWeek .. "." .. month .. "." .. year .. " |"
			end

			if displayTime == true then
				timeAndDateString = timeAndDateString .. "~y~ " .. hour .. ":" .. minute .. ":" .. secound .. "~s~ Uhr"
			end

			SetTextFont(0)
			SetTextScale(0.30, 0.30)
			SetTextColour(255, 255, 255, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextWrap(0,0.95)
			SetTextEntry("STRING")
			AddTextComponentString(timeAndDateString)
			DrawText(0.017, 0.78)
		end
	end
end)