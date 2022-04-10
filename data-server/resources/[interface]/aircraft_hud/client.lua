-- Config here
local UI = { 
	x = 0.345,
	y = 0.40,
}

function Text(text, x, y, scale)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextOutline()
	SetTextJustification(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)

		local Ped = PlayerPedId()
		local Heli = IsPedInAnyHeli(Ped)
		local Plane = IsPedInAnyPlane(Ped)
		local PedVehicle = GetVehiclePedIsIn(PlayerPedId(),false)
		
		local class = GetVehicleClass(PedVehicle)


		if IsPedInAnyVehicle(Ped) and not IsEntityDead(Ped) and class == 15 or class == 16 then
			local Speed = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6 or 0
			local Engine = GetIsVehicleEngineRunning(PedVehicle) or 0
			local Height = GetEntityHeightAboveGround(PedVehicle) or 0
			local FuelAmount = GetVehicleFuelLevel(GetPlayersLastVehicle()) or 0
			

				-- engine display
			if Engine then
				Text("~g~ENG", UI.x + 0.377, UI.y + 0.476, 0.55)
				Text("~g~__", UI.x + 0.377, UI.y + 0.47, 0.79)
			elseif Engine == false then
				Text("~r~ENG", UI.x + 0.377, UI.y + 0.476, 0.55)
				Text("~r~__", UI.x + 0.377, UI.y + 0.47, 0.79)
			end

			if Heli then
				local MainRotorHealth = GetHeliMainRotorHealth(PedVehicle) or 0
				local TailRotorHealth = GetHeliTailRotorHealth(PedVehicle) or 0
				
				if MainRotorHealth > 800 and Engine then
					Text("~g~MAIN", UI.x + 0.426, UI.y + 0.476, 0.55)
					Text("~g~__", UI.x + 0.426, UI.y + 0.47, 0.79)
				elseif MainRotorHealth > 200 and MainRotorHealth < 800 and Engine then
					Text("~y~MAIN", UI.x + 0.426, UI.y + 0.476, 0.55)
					Text("~y~__", UI.x + 0.426, UI.y + 0.47, 0.79)
				elseif MainRotorHealth < 200 and Engine then
					Text("~r~MAIN", UI.x + 0.426, UI.y + 0.476, 0.55)
					Text("~r~__", UI.x + 0.426, UI.y + 0.47, 0.79)
				elseif Engine == false then
					Text("~r~MAIN", UI.x + 0.426, UI.y + 0.476, 0.55)
					Text("~r~__", UI.x + 0.426, UI.y + 0.47, 0.79)
				end

				-- Tail rotor display
				if TailRotorHealth > 300 and Engine then
					Text("~g~TAIL", UI.x + 0.475, UI.y + 0.476, 0.55)
					Text("~g~__", UI.x + 0.475, UI.y + 0.47, 0.79)
				elseif TailRotorHealth > 100 and TailRotorHealth < 300 and Engine then
					Text("~y~TAIL", UI.x + 0.475, UI.y + 0.476, 0.55)
					Text("~y~__", UI.x + 0.475, UI.y + 0.47, 0.79)
				elseif TailRotorHealth < 100 and Engine then
					Text("~r~TAIL", UI.x + 0.475, UI.y + 0.476, 0.55)
					Text("~r~__", UI.x + 0.475, UI.y + 0.47, 0.79)
				elseif Engine == false then
					Text("~r~TAIL", UI.x + 0.475, UI.y + 0.476, 0.55)
					Text("~r~__", UI.x + 0.475, UI.y + 0.47, 0.79)
				end
			
			elseif Plane then
				local PlanePropellers = ArePlanePropellersIntact(PedVehicle)
				local PlaneWings  =  ArePlaneWingsIntact(PedVehicle)

				if PlanePropellers then
					Text("~g~PROP", UI.x + 0.426, UI.y + 0.476, 0.55)
					Text("~g~__", UI.x + 0.426, UI.y + 0.47, 0.79)
				else
					Text("~r~PROP", UI.x + 0.426, UI.y + 0.476, 0.55)
					Text("~r~__", UI.x + 0.426, UI.y + 0.47, 0.79)
				end

				-- Tail rotor display
				if PlaneWings then
					Text("~g~WING", UI.x + 0.475, UI.y + 0.476, 0.55)
					Text("~g~__", UI.x + 0.475, UI.y + 0.47, 0.79)
				else
					Text("~r~TAIL", UI.x + 0.475, UI.y + 0.476, 0.55)
					Text("~r~__", UI.x + 0.475, UI.y + 0.47, 0.79)
				end			
			end

				-- Altitude and speed display
			Text(math.ceil(Height), UI.x + 0.524, UI.y + 0.476, 0.45)
			Text("HÖHE", UI.x + 0.524, UI.y + 0.502, 0.29)
			if Speed == 0.0 then
				Text("0", UI.x + 0.573, UI.y + 0.476, 0.45)
			else
				Text(math.ceil(Speed), UI.x + 0.573, UI.y + 0.476, 0.45)
			end
			Text("KM/H", UI.x + 0.573, UI.y + 0.502, 0.29)
			Text(math.ceil(FuelAmount), UI.x + 0.622, UI.y + 0.476, 0.45)
			Text("TANK", UI.x + 0.622, UI.y + 0.502, 0.29)
			-- Big rectangels on the ui
			DrawRect(UI.x + 0.5, UI.y + 0.5, 0.304, 0.085, 25, 25, 25, 255)
			DrawRect(UI.x + 0.5, UI.y + 0.5, 0.299, 0.075, 51, 51, 51, 255)
			-- Smaller squares in the rectangels.
			DrawRect(UI.x + 0.377, UI.y + 0.5, 0.040, 0.050, 25, 25, 25, 255)
			DrawRect(UI.x + 0.426, UI.y + 0.5, 0.040, 0.050, 25, 25, 25, 255)
			DrawRect(UI.x + 0.475, UI.y + 0.5, 0.040, 0.050, 25, 25, 25, 255)
			DrawRect(UI.x + 0.524, UI.y + 0.5, 0.040, 0.050, 25, 25, 25, 255)
			DrawRect(UI.x + 0.573, UI.y + 0.5, 0.040, 0.050, 25, 25, 25, 255)
			DrawRect(UI.x + 0.622, UI.y + 0.5, 0.040, 0.050, 25, 25, 25, 255)
		end
	end	
end)