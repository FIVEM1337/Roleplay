ESX = nil

local infoped = nil
local jobmanped = nil
local docped = nil

CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	ESX.Game.MakeEntityFaceEntity = function(entity1, entity2)
		local p1 = GetEntityCoords(entity1, true)
		local p2 = GetEntityCoords(entity2, true)
	
		local dx = p2.x - p1.x
		local dy = p2.y - p1.y
	
		local heading = GetHeadingFromVector_2d(dx, dy)
		SetEntityHeading( entity1, heading )
	end
end)

local infoLoc = 1

local time = 0
local difftime = {Hours = 0, Mins = 0, Seconds = 0}

local soltime = 0
local diffSol = {Hours = 0, Mins = 0, Seconds = 0}

local isDead = false

local job = 0
local doneTasks = 0
local taskMax = 0

local injail = false
local jailCell = 0
local solcell = 0

local canGrab = false
local itemzie = {}

local createdCamera = 0
local beingMsg = {msg = nil, size = 0.0}
local beingSent = false

local blips = {}
local peds = {}
local PlayerHasProp = {}

local jailLocs = {}
local closestLoc = 1

local breakout = 0
local diffBreak = {Hours = 0, Mins = 0, Seconds = 0}
local breakout2 = false
local breakout3 = false
local breakout4 = true
local closestTower = 1
local closestBreak = 1

local inMenu = {is = false, coords = nil}
local inAnim = {Dict = nil, Anim = nil, Atr = 0, Freeze = false}
local needsEat = false

local closestShower = 1
local showerNow = false

local closestOut = 1
local workoutNow = false
local workoutLoc = 0

local switchie = false
local lockieDown = false
local inJailMenu = false

local closestPoliceInv = 1 

local pedsie = nil

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

CreateThread(function()
	Wait(500)
	if Config.JailBlip.Spawn then
		local blip2 = AddBlipForCoord(Config.JailLoc.x, Config.JailLoc.y, Config.JailLoc.z)
		SetBlipSprite(blip2, Config.JailBlip.Sprite)
		SetBlipScale(blip2, Config.JailBlip.Size)
		SetBlipColour(blip2, Config.JailBlip.Color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Sayings[160])
		EndTextCommandSetBlipName(blip2)
		SetBlipAsShortRange(blip2, true)
	end
end)

RegisterNetEvent('esx_jail_Blips:ReturnDelete')
AddEventHandler('esx_jail_Blips:ReturnDelete', function(resource, shit)
	if resource == GetCurrentResourceName() then
		if DoesBlipExist(shit) then
			RemoveBlip(shit)
		end
	end
end)



RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function()
    Spawned()
end)

function Spawned()
	CreateThread(function()
		while true do
			Wait(1000)
			if ESX ~= nil then
				if ESX.PlayerData.job ~= nil then
					Wait(3000)
					TriggerServerEvent('esx_jail:LoadedIn')
					break
				end
			end
		end
	end)
end



AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
		local removes = {}
		for i = 1, #blips, 1 do
			table.insert(removes, i)
		end
		for i = 1, #removes, 1 do
			if DoesBlipExist(blips[removes[i]].data) then
				RemoveBlip(blips[removes[i]].data)
			end
			table.remove(blips[removes[i]])
		end
		removes = {}
		for i = 1, #peds, 1 do
			table.insert(removes, i)
		end
		for i = 1, #removes, 1 do
			if DoesEntityExist(peds[removes[i]].data) then
				SetPedAsNoLongerNeeded(peds[removes[i]].data)
				DeletePed(peds[removes[i]].data)
			end
			table.remove(peds[removes[i]])
		end
		removes = {}
		for i = 1, #PlayerHasProp, 1 do
			table.insert(removes, i)
		end
		for i = 1, #removes, 1 do
			if DoesEntityExist(PlayerHasProp[removes[i]].object) then
				DeleteObject(PlayerHasProp[removes[i]].object)
			end
			table.remove(PlayerHasProp[removes[i]])
		end
		removes = {}
    end
end)

RegisterNetEvent('esx_jail:JailStart')
AddEventHandler('esx_jail:JailStart', function(timez)
	local ped = PlayerPedId()
	CreateThread(function()
		DoScreenFadeOut(1000)
		Wait(1000)
		LoadJailCell(timez, true)
	end)
end)



RegisterNetEvent('esx_jail:TakeBooze')
AddEventHandler('esx_jail:TakeBooze', function()
	local ped = PlayerPedId()

	Wait(2000)
	SetTimecycleModifier("spectator6")
	SetPedMotionBlur(ped, true)
	SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", true)
	SetPedIsDrunk(ped, true)
	AnimpostfxPlay("ChopVision", 10000001, true)
	ShakeGameplayCam("DRUNK_SHAKE", 1.0)
	Wait(Config.BoozeEffectTime *1000)
	SetPedMoveRateOverride(PlayerId(),1.0)
	SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
	SetPedIsDrunk(PlayerPedId(), false)		
	SetPedMotionBlur(ped, false)
	ResetPedMovementClipset(PlayerPedId())
	AnimpostfxStopAll()
	ShakeGameplayCam("DRUNK_SHAKE", 0.0)
	SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('esx_jail:ChangeLoc')
AddEventHandler('esx_jail:ChangeLoc', function(newLoc)
	if inMenu.is then
		if inMenu.coords == Config.InfoPedLoc[infoLoc].Loc then
			ESX.UI.Menu.CloseAll()
			inMenu.is = false
			inMenu.coords = false
		end
	end
	infoLoc = newLoc
	if time > 0 then
		local removes = {}
		for i = 1, #blips, 1 do
			if blips[i].id == 'info' then
				table.insert(removes, i)
			end
		end
		for i = 1, #removes, 1 do
			if DoesBlipExist(blips[removes[i]].data) then
				RemoveBlip(blips[removes[i]].data)
			end
			table.remove(blips[removes[i]])
		end
		removes = {}
		for i = 1, #peds, 1 do
			if peds[i].id == 'info' then
				table.insert(removes, i)
			end
		end
		for i = 1, #removes, 1 do
			if DoesEntityExist(peds[removes[i]].data) then
				SetPedAsNoLongerNeeded(peds[removes[i]].data)
				DeletePed(peds[removes[i]].data)
			end
			table.remove(peds[removes[i]])
		end
	
		if Config.InfoPedBlip.Spawn then
			local blip2 = AddBlipForCoord(Config.InfoPedLoc[infoLoc].Loc.x, Config.InfoPedLoc[infoLoc].Loc.y, Config.InfoPedLoc[infoLoc].Loc.z)
			SetBlipSprite(blip2, Config.InfoPedBlip.Sprite)
			SetBlipScale(blip2, Config.InfoPedBlip.Size)
			SetBlipColour(blip2, Config.InfoPedBlip.Color)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Sayings[10])
			EndTextCommandSetBlipName(blip2)
			table.insert(blips, {id = 'info', data = blip2})
		end
	
		RequestModel(Config.InfoPed)
	
		LoadPropDict(Config.InfoPed)
	
		local byped = CreatePed(5, Config.InfoPed, Config.InfoPedLoc[infoLoc].Loc.x, Config.InfoPedLoc[infoLoc].Loc.y, Config.InfoPedLoc[infoLoc].Loc.z - 1, Config.InfoPedLoc[infoLoc].Heading, false, true)
		PlaceObjectOnGroundProperly(byped)
		SetEntityAsMissionEntity(byped)
		SetPedDropsWeaponsWhenDead(byped, false)
		FreezeEntityPosition(byped, true)
		SetPedAsEnemy(byped, false)
		SetEntityInvincible(byped, true)
		SetModelAsNoLongerNeeded(Config.InfoPed)
		SetPedCanBeTargetted(byped, false)
		table.insert(peds, {id = 'info', data = byped})
		infoped = byped
	
		for i = 1, #jailLocs, 1 do
			if jailLocs[i].Id == 'info' then
				jailLocs[i].Loc = Config.InfoPedLoc[newLoc].Loc
			end
		end
	end
end)


RegisterNetEvent('esx_jail:GoToJail')
AddEventHandler('esx_jail:GoToJail', function(jtime, job, clothi)
	if clothi then
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
			end
		end)
	end
	LoadJailCell(jtime, false)
	StartJob(job, false)
end)

function LoadJailCell(timu, firstTime)
	local ped = PlayerPedId()
	DoScreenFadeOut(1000)
	Wait(1500)
	local keepWeapon = {}

	if Config.DontTakeGunUponEntry[1] ~= nil then
		for i = 1, #Config.DontTakeGunUponEntry, 1 do
			if HasPedGotWeapon(ped, GetHashKey(Config.DontTakeGunUponEntry[i]), false) then
				table.insert(keepWeapon, {hash = GetHashKey(Config.DontTakeGunUponEntry[i]), ammo = GetAmmoInPedWeapon(ped, GetHashKey(Config.DontTakeGunUponEntry[i]))})
			end
		end
	end
	RemoveAllPedWeapons(ped, false)
	if keepWeapon[1] ~= nil then
		for i = 1, #keepWeapon, 1 do
			GiveWeaponToPed(ped, keepWeapon.hash, keepWeapon.ammo, true, false)
		end
	end
	keepWeapon = {}

	ESX.TriggerServerCallback('esx_jail:GrabInfoLoc', function(locnum)
		infoLoc = locnum
	end)


	if Config.InfoPedBlip.Spawn then
		local blip2 = AddBlipForCoord(Config.InfoPedLoc[infoLoc].Loc.x, Config.InfoPedLoc[infoLoc].Loc.y, Config.InfoPedLoc[infoLoc].Loc.z)
		SetBlipSprite(blip2, Config.InfoPedBlip.Sprite)
		SetBlipScale(blip2, Config.InfoPedBlip.Size)
		SetBlipColour(blip2, Config.InfoPedBlip.Color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Sayings[10])
		EndTextCommandSetBlipName(blip2)
		table.insert(blips, {id = 'info', data = blip2})
	end
	if Config.JobManBlip.Spawn then
		local blip3 = AddBlipForCoord(Config.JobManLoc.Loc.x, Config.JobManLoc.Loc.y, Config.JobManLoc.Loc.z)
		SetBlipSprite(blip3, Config.JobManBlip.Sprite)
		SetBlipScale(blip3, Config.JobManBlip.Size)
		SetBlipColour(blip3, Config.JobManBlip.Color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Sayings[9])
		EndTextCommandSetBlipName(blip3)
		table.insert(blips, {id = 'jobman', data = blip3})
	end
	if Config.FoodBlip.Spawn then
		local blip4 = AddBlipForCoord(Config.GetFoodLoc.Loc.x, Config.GetFoodLoc.Loc.y, Config.GetFoodLoc.Loc.z)
		SetBlipSprite(blip4, Config.FoodBlip.Sprite)
		SetBlipScale(blip4, Config.FoodBlip.Size)
		SetBlipColour(blip4, Config.FoodBlip.Color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Sayings[32])
		EndTextCommandSetBlipName(blip4)
		table.insert(blips, {id = 'food', data = blip4})
	end
	if Config.ShowerBlip.Spawn and Config.Showers then
		local blip4 = AddBlipForCoord(Config.ShowerLoc.Loc.x, Config.ShowerLoc.Loc.y, Config.ShowerLoc.Loc.z)
		SetBlipSprite(blip4, Config.ShowerBlip.Sprite)
		SetBlipScale(blip4, Config.ShowerBlip.Size)
		SetBlipColour(blip4, Config.ShowerBlip.Color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Sayings[112])
		EndTextCommandSetBlipName(blip4)
		table.insert(blips, {id = 'shower', data = blip4})
	end
	if Config.WorkOutBlip.Spawn and Config.WorkingOut then
		for i = 1, #Config.WorkoutLocs, 1 do
			local blip4 = AddBlipForCoord(Config.WorkoutLocs[i].StartLoc.Loc.x, Config.WorkoutLocs[i].StartLoc.Loc.y, Config.WorkoutLocs[i].StartLoc.Loc.z)
			SetBlipSprite(blip4, Config.WorkOutBlip.Sprite)
			SetBlipScale(blip4, Config.WorkOutBlip.Size)
			SetBlipColour(blip4, Config.WorkOutBlip.Color)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Sayings[119])
			EndTextCommandSetBlipName(blip4)
			table.insert(blips, {id = 'workout'..i, data = blip4})
		end
	end


	RequestModel(Config.InfoPed)
	RequestModel(Config.JobManPed)

	LoadPropDict(Config.InfoPed)
	LoadPropDict(Config.JobManPed)

	local byped = CreatePed(5, Config.InfoPed, Config.InfoPedLoc[infoLoc].Loc.x, Config.InfoPedLoc[infoLoc].Loc.y, Config.InfoPedLoc[infoLoc].Loc.z - 1, Config.InfoPedLoc[infoLoc].Heading, false, true)
	PlaceObjectOnGroundProperly(byped)
	SetEntityAsMissionEntity(byped)
	SetPedDropsWeaponsWhenDead(byped, false)
	FreezeEntityPosition(byped, true)
	SetPedAsEnemy(byped, false)
	SetEntityInvincible(byped, true)
	SetModelAsNoLongerNeeded(Config.InfoPed)
	SetPedCanBeTargetted(byped, false)
	table.insert(peds, {id = 'info', data = byped})
	infoped = byped
	local byped2 = CreatePed(5, Config.JobManPed, Config.JobManLoc.Loc.x, Config.JobManLoc.Loc.y, Config.JobManLoc.Loc.z - 1, Config.JobManLoc.Heading, false, true)
	PlaceObjectOnGroundProperly(byped2)
	SetEntityAsMissionEntity(byped2)
	SetPedDropsWeaponsWhenDead(byped2, false)
	FreezeEntityPosition(byped2, true)
	SetPedAsEnemy(byped2, false)
	SetEntityInvincible(byped2, true)
	SetModelAsNoLongerNeeded(Config.JobManPed)
	SetPedCanBeTargetted(byped2, false)
	table.insert(peds, {id = 'jobman', data = byped2})
	jobmanped = byped2


	table.insert(jailLocs, {Text = Config.Sayings[27], Id = 'info', Loc = Config.InfoPedLoc[infoLoc].Loc, Sub = true, Mark = {Num = Config.IMarkNum, Color = Config.IMarkColor, Size = Config.IMarkSize}})
	table.insert(jailLocs, {Text = Config.Sayings[14], Id = 'jobman', Loc = Config.JobManLoc.Loc, Sub = true, Mark = {Num = Config.JMMarkNum, Color = Config.JMMarkColor, Size = Config.JMMarkSize}})
	table.insert(jailLocs, {Text = Config.Sayings[30], Id = 'food', Loc = Config.GetFoodLoc.Loc, Sub = false, Mark = {Num = Config.FoMarkNum, Color = Config.FoMarkColor, Size = Config.FoMarkSize}})
	if Config.Showers then
		table.insert(jailLocs, {Text = Config.Sayings[113], Id = 'shower', Loc = Config.ShowerLoc.Loc, Sub = false, Mark = {Num = Config.ShowMarkNum, Color = Config.ShowMarkColor, Size = Config.ShowMarkSize}})
	end
	if Config.WorkingOut then
		for i = 1, #Config.WorkoutLocs, 1 do
			table.insert(jailLocs, {Text = Config.Sayings[120], Id = 'workout'..i, Loc = Config.WorkoutLocs[i].StartLoc.Loc, Sub = false, Mark = {Num = Config.WoutMarkNum, Color = Config.WoutMarkColor, Size = Config.WoutMarkSize}})
		end
	end



	CreateThread(function()
		ESX.TriggerServerCallback('esx_jail:GetCell', function(cell)
			if cell ~= 0 then
				TriggerServerEvent('esx_jail:UpdateCell', cell)
				DoScreenFadeOut(1000)
				if Config.Breakout then
					table.insert(jailLocs, {Text = Config.Sayings[28], Id = 'break', Loc = Config.Cells[cell].BreakLoc.Loc, Sub = false, Mark = {Num = Config.BrMarkNum, Color = Config.BrMarkColor, Size = Config.BrMarkSize}})
				end
				table.insert(jailLocs, {Text = Config.Sayings[29], Id = 'chest', Loc = Config.Cells[cell].InvLoc.Loc, Sub = false, Mark = {Num = Config.ChMarkNum, Color = Config.ChMarkColor, Size = Config.ChMarkSize}})

				local blip5 = AddBlipForCoord(Config.Cells[cell].InvLoc.Loc.x, Config.Cells[cell].InvLoc.Loc.y, Config.Cells[cell].InvLoc.Loc.z)
				SetBlipSprite(blip5, Config.InvBlip.Sprite)
				SetBlipScale(blip5, Config.InvBlip.Size)
				SetBlipColour(blip5, Config.InvBlip.Color)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.Sayings[31])
				EndTextCommandSetBlipName(blip5)
			--	table.insert(blips, {id = 'chest', data = blip5})

				Wait(1500)
				beingSent = false
				beingMsg = {msg = nil, size = 0.0}
				CloseSecurityCamera()
				SetEntityCoords(ped, Config.Cells[cell].SpawnLoc.Loc.x, Config.Cells[cell].SpawnLoc.Loc.y, Config.Cells[cell].SpawnLoc.Loc.z - 1, false, false, false, false)
				SetEntityHeading(ped, Config.Cells[cell].SpawnLoc.Heading)

				Wait(200)

				SetEntityCoords(ped, Config.Cells[cell].SpawnLoc.Loc.x, Config.Cells[cell].SpawnLoc.Loc.y, Config.Cells[cell].SpawnLoc.Loc.z - 1, false, false, false, false)
				SetEntityHeading(ped, Config.Cells[cell].SpawnLoc.Heading)
				jailCell = cell
				if not Config.SimpleTime then
					local duration = timu
					local extraSeconds = duration%60
					local minutes = (duration-extraSeconds)/60
					if duration >= 60 then
						if minutes >= 60 then
							local extraMinutes = minutes%60
							local hours = (minutes-extraMinutes)/60
							difftime.Hours = math.floor(hours)
							difftime.Mins = math.ceil(extraMinutes)
							difftime.Seconds = extraSeconds
						end
					else
						difftime.Hours = 0
						difftime.Mins = 0
						difftime.Seconds = timu
					end
				end
				time = timu
				Wait(500)
				injail = true
				Wait(1000)
				TriggerServerEvent('esx_jail:CheckSol', GetPlayerServerId(PlayerId()))
			end
		end)
	end)
end

RegisterNetEvent('esx_jail:NotSol')
AddEventHandler('esx_jail:NotSol', function()
	DoScreenFadeIn(500)
end)

CreateThread(function()
	while true do
		Wait(5)
		if infoped ~= nil then
			TaskSetBlockingOfNonTemporaryEvents(infoped, true)
		end
		if jobmanped ~= nil then
			TaskSetBlockingOfNonTemporaryEvents(jobmanped, true)
		end
		if docped ~= nil then
			TaskSetBlockingOfNonTemporaryEvents(docped, true)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if breakout2 then
			local minDistance3 = 100
			local minDistance2 = 100
			for i = 1, #Config.WatchTowers, 1 do
				dist2 = Vdist(Config.WatchTowers[i].x, Config.WatchTowers[i].y, Config.WatchTowers[i].z, coords)
				if dist2 < minDistance3 then
					minDistance3 = dist2
					closestTower = i
				end
			end

			for i = 1, #Config.BreakLocs, 1 do
				dist = Vdist(Config.BreakLocs[i].StartLoc.Loc.x, Config.BreakLocs[i].StartLoc.Loc.y, Config.BreakLocs[i].StartLoc.Loc.z, coords)
				if dist < minDistance2 then
					minDistance2 = dist
					closestBreak = i
				end
			end
		else
			local minDistance = 5
			local minDistance2 = 5
			local minDistance3 = 5
			local minDistance4 = 15
			for i = 1, #jailLocs, 1 do
				dist = Vdist(jailLocs[i].Loc.x, jailLocs[i].Loc.y, jailLocs[i].Loc.z, coords)
				if dist < minDistance then
					minDistance = dist
					closestLoc = i
				end
			end

			for i = 1, #Config.ShowerLocs, 1 do
				dist = Vdist(Config.ShowerLocs[i].x, Config.ShowerLocs[i].y, Config.ShowerLocs[i].z, coords)
				if dist < minDistance2 then
					minDistance2 = dist
					closestShower = i
				end
			end

			if workoutNow then
				for i = 1, #Config.WorkoutLocs[workoutLoc].Locs, 1 do
					dist = Vdist(Config.WorkoutLocs[workoutLoc].Locs[i].Loc.x, Config.WorkoutLocs[workoutLoc].Locs[i].Loc.y, Config.WorkoutLocs[workoutLoc].Locs[i].Loc.z, coords)
					if dist < minDistance3 then
						minDistance3 = dist
						closestOut = i
					end
				end
			end

			for i = 1, #Config.PoliceRoles, 1 do
				if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.PoliceRoles[i] then
					for k = 1, #Config.Cells, 1 do
						dist = Vdist(Config.Cells[k].InvLoc.Loc.x, Config.Cells[k].InvLoc.Loc.y, Config.Cells[k].InvLoc.Loc.z, coords)
						if dist < minDistance4 then
							minDistance4 = dist
							closestPoliceInv = k
						end
					end
				end
			end
		end
	end
end)



CreateThread(function()
	while true do
		if beingSent then
			local ped = PlayerPedId()
			pedsie = ESX.Game.GetPeds({ped})
			Wait(250)
		else
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		if beingSent then
			Wait(5)
			drawTxt(beingMsg.msg,0,1,0.5,0.8,beingMsg.size,255,255,255,255)
			DisableAllControlActions(0)
			if pedsie ~= nil then
				for i=1, #pedsie, 1 do
					local pedo = pedsie[i]
					if IsPedAPlayer(pedo) then
						SetEntityLocallyInvisible(pedo)
						SetEntityNoCollisionEntity(ped, pedo, true)
					end
				end
			end
		elseif canGrab then
			local dist = Vdist(Config.ItemLoc.Loc.x, Config.ItemLoc.Loc.y, Config.ItemLoc.Loc.z, coords)
			if not using then
				if dist <= Config.ShowItemDist then
					Wait(5)
					DrawMarker(Config.LMarkNum, Config.ItemLoc.Loc.x, Config.ItemLoc.Loc.y, Config.ItemLoc.Loc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.LMarkSize.x, Config.LMarkSize.y, Config.LMarkSize.z, Config.LMarkColor.r, Config.LMarkColor.g, Config.LMarkColor.b, 100, false, false, 2, true, nil, nil, false)
					if dist <= Config.ItemTextDist then
						DrawText3D(Config.ItemLoc.Loc.x, Config.ItemLoc.Loc.y, Config.ItemLoc.Loc.z, Config.Sayings[12])
						if IsControlJustReleased(1,38) then
							canGrab = false
							SetEntityCoords(ped, Config.ItemLoc.Loc.x, Config.ItemLoc.Loc.y, Config.ItemLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.ItemLoc.Heading)
							
							RequestAnimDict('anim@amb@clubhouse@bar@drink@idle_a')
							
							LoadAnim('anim@amb@clubhouse@bar@drink@idle_a')
							
							TaskPlayAnim(ped, "anim@amb@clubhouse@bar@drink@idle_a", "idle_a_bartender", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = 'anim@amb@clubhouse@bar@drink@idle_a'
							inAnim.Anim = 'idle_a_bartender'
							inAnim.Atr = 1
							inAnim.Freeze = true
							FreezeEntityPosition(ped, true)
							exports['progressBars']:startUI(Config.RetreiveTime *1000, Config.Sayings[13])
							Wait(Config.RetreiveTime *1000)
							TriggerServerEvent('esx_jail:RetrieveItems', itemzie)
							local removes = {}
							for i = 1, #blips, 1 do
								if blips[i].id == 'items' then
									table.insert(removes, i)
								end
							end
							for i = 1, #removes, 1 do
								if DoesBlipExist(blips[removes[i]].data) then
									RemoveBlip(blips[removes[i]].data)
								end
								table.remove(blips[removes[i]])
							end
							RemoveAnimDict("anim@amb@clubhouse@bar@drink@idle_a")
							FreezeEntityPosition(ped, false)
							inAnim.Dict = nil
							inAnim.Anim = nil
							inAnim.Atr = 0
							inAnim.Freeze = false
							ClearPedTasksImmediately(ped)
							itemzie = {} 
						end
					end
				else
					Wait(1000)
				end
			else 
				Wait(1000)
			end
		elseif breakout2 then
			local dist = Vdist(Config.WatchTowers[closestTower].x, Config.WatchTowers[closestTower].y, Config.WatchTowers[closestTower].z - 1, coords)

			if not using and not isDead then
				if dist <= Config.SeeWatchDist then
					Wait(5)
					DrawMarker(1, Config.WatchTowers[closestTower].x, Config.WatchTowers[closestTower].y, Config.WatchTowers[closestTower].z -1, 0, 0, 0, 0, 0, 0, Config.WatchDist * 2, Config.WatchDist * 2, 2.0, Config.WatchMarkColor.r, Config.WatchMarkColor.g, Config.WatchMarkColor.b, 155, 0, 0, 2, 0, 0, 0, 0)
					if dist <= Config.WatchDist then
						breakout2 = false
						breakout4 = true
						TriggerServerEvent('esx_jail:UnBreak', GetPlayerServerId(PlayerId()))
					end
				else
					if dist >= Config.MaxWatchDist then
						IEscaped()
						breakout2 = false
						breakout4 = true
					end
					Wait(500)
				end
			else
				Wait(1000)
			end
		elseif time > 0 then
			local dist = Vdist(jailLocs[closestLoc].Loc.x, jailLocs[closestLoc].Loc.y, jailLocs[closestLoc].Loc.z, coords)
			
			if not using and not isDead then
				if dist <= Config.SeeDist then
					Wait(1)
					if jailLocs[closestLoc] ~= nil then
						if jailLocs[closestLoc].Sub then
							DrawMarker(jailLocs[closestLoc].Mark.Num, jailLocs[closestLoc].Loc.x, jailLocs[closestLoc].Loc.y, jailLocs[closestLoc].Loc.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, jailLocs[closestLoc].Mark.Size.x, jailLocs[closestLoc].Mark.Size.y, jailLocs[closestLoc].Mark.Size.z, jailLocs[closestLoc].Mark.Color.r, jailLocs[closestLoc].Mark.Color.g, jailLocs[closestLoc].Mark.Color.b, 100, false, false, 2, true, nil, nil, false)
						else
							DrawMarker(jailLocs[closestLoc].Mark.Num, jailLocs[closestLoc].Loc.x, jailLocs[closestLoc].Loc.y, jailLocs[closestLoc].Loc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, jailLocs[closestLoc].Mark.Size.x, jailLocs[closestLoc].Mark.Size.y, jailLocs[closestLoc].Mark.Size.z, jailLocs[closestLoc].Mark.Color.r, jailLocs[closestLoc].Mark.Color.g, jailLocs[closestLoc].Mark.Color.b, 100, false, false, 2, true, nil, nil, false)
						end
					end
					
					if dist <= Config.TextDist then
						DrawText3D(jailLocs[closestLoc].Loc.x, jailLocs[closestLoc].Loc.y, jailLocs[closestLoc].Loc.z + Config.TextLift, jailLocs[closestLoc].Text)
						if IsControlJustReleased(1,38) then
							if jailLocs[closestLoc].Id == 'jobman' then
								inMenu.coords = Config.JobManLoc.Loc 
								inMenu.is = true
								OpenJobManMenu()
							elseif jailLocs[closestLoc].Id == 'chest' then
								OpenChest(true)
							elseif jailLocs[closestLoc].Id == 'food' then
								OpenFood()
							elseif jailLocs[closestLoc].Id == 'info' then
								inMenu.coords = Config.InfoPedLoc[infoLoc].Loc 
								inMenu.is = true
								OpenInfoMenu()
							elseif jailLocs[closestLoc].Id == 'shower' then
								StartShower()
							elseif jailLocs[closestLoc].Id == 'break' then
								if breakout3 then
									inMenu.coords = nil
									inMenu.is = false
									BreakOutStart()
								else
									inMenu.coords = Config.Cells[jailCell].BreakLoc.Loc
									inMenu.is = true
									OpenWallMenu()
								end
							else 
								if not workoutNow then
									StartWorkout(closestOut)
								else
									EndWorkout()
								end
							end
						end
					end
				else 
					Wait(1000)
				end
			else
				Wait(1000)
			end
		else
			Wait(1000)
		end
	end
end)

CreateThread(function()
	while true do
		if breakout > 0 and not using then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local dist = Vdist(Config.BreakLocs[closestBreak].StartLoc.Loc.x, Config.BreakLocs[closestBreak].StartLoc.Loc.y, Config.BreakLocs[closestBreak].StartLoc.Loc.z, coords)
			if dist <= Config.SeeBreakDist and not isDead then
				Wait(5)
				DrawMarker(Config.BreakMarkNum, Config.BreakLocs[closestBreak].StartLoc.Loc.x, Config.BreakLocs[closestBreak].StartLoc.Loc.y, Config.BreakLocs[closestBreak].StartLoc.Loc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.BreakMarkSize.x, Config.BreakMarkSize.y, Config.BreakMarkSize.z, Config.BreakMarkColor.r, Config.BreakMarkColor.g, Config.BreakMarkColor.b, 100, false, false, 2, true, nil, nil, false)

				if dist <= Config.BreakTextDist then
					DrawText3D(Config.BreakLocs[closestBreak].StartLoc.Loc.x, Config.BreakLocs[closestBreak].StartLoc.Loc.y, Config.BreakLocs[closestBreak].StartLoc.Loc.z + Config.TextLift, Config.Sayings[93])

					if IsControlJustReleased(0, 38) then
						OpenBreakingMenu()
						inMenu.coords = Config.BreakLocs[closestBreak].StartLoc.Loc
						inMenu.is = true
					end
				end
			else
				Wait(1000)
			end
		elseif not isDead and workoutNow then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local dist = Vdist(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.x, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.y, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.z, coords)

			if dist <= Config.SeeWorkDist and not using then
				Wait(5)
				DrawMarker(Config.WoutMarkNum, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.x, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.y, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.WoutMarkSize.x, Config.WoutMarkSize.y, Config.WoutMarkSize.z, Config.WoutMarkColor.r, Config.WoutMarkColor.g, Config.WoutMarkColor.b, 100, false, false, 2, true, nil, nil, false)

				if dist <= Config.WorkText then
					DrawText3D(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.x, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.y, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.z + Config.TextLift, Config.Sayings[122]..Config.WorkoutLocs[workoutLoc].Locs[closestOut].Label)

					if IsControlJustReleased(0, 47) then
						using = true
						SetEntityCoords(ped, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.x, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.y, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.z - 1, false, false, false, false)
						SetEntityHeading(ped, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Heading)

						if Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Aim ~= nil then
							RequestAnimDict(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Dict)
		
							if not HasAnimDictLoaded(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Dict) then
								Wait(0)
							end
						
							TaskPlayAnim(ped, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Dict, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Aim, 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Dict
							inAnim.Anim = Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Aim
							inAnim.Atr = 1
							inAnim.Freeze = true
						else
							TaskStartScenarioInPlace(ped, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Dict, 0, true)
						end
						FreezeEntityPosition(ped, true)

						exports['progressBars']:startUI(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Time *1000, Config.Sayings[123])
						Wait(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Time *1000)
						if Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Aim ~= nil then
							TaskPlayAnim(ped, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Dict, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Aim, 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = nil
							inAnim.Anim = nil
							inAnim.Atr = 0
							inAnim.Freeze = false
							RemoveAnimDict(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Anim.Dict)
						end
						ClearPedTasksImmediately(ped)
						FreezeEntityPosition(ped, false)
						using = false
					end
				end
			else
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local dist = Vdist(Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.x, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.y, Config.WorkoutLocs[workoutLoc].Locs[closestOut].Loc.z, coords)

				if dist >= Config.MaxDistWorkout then
					workoutNow = false
					Wait(1000)
					workoutLoc = 0
					using = false
					Notification(Config.Sayings[124])
					TriggerEvent('skinchanger:getSkin', function(skin)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
						else
							TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
						end
					end)
				end
				Wait(500)
			end
		elseif not isDead and showerNow then
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local dist = Vdist(Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z, coords)

			if dist <= Config.ShowerFullDist then
				Wait(5)
				for i = 1, #Config.ShowerLocs, 1 do
					local dist2 = Vdist(Config.ShowerLocs[i].x, Config.ShowerLocs[i].y, Config.ShowerLocs[i].z, coords)
					if dist2 <= Config.ShowerMarkerDist then
						DrawMarker(Config.ShowMarkNum, Config.ShowerLocs[i].x, Config.ShowerLocs[i].y, Config.ShowerLocs[i].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.ShowMarkSize.x, Config.ShowMarkSize.y, Config.ShowMarkSize.z, Config.ShowMarkColor.r, Config.ShowMarkColor.g, Config.ShowMarkColor.b, 100, false, false, 2, true, nil, nil, false)
					end
				end

				if dist <= Config.ShowerDist and not isDead then
					DrawText3D(Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z + Config.TextLift, Config.Sayings[116])

					if IsControlJustReleased(0, 47) then
						showerNow = false
						SetEntityCoords(ped, Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z - 1, false, false, false, false)

						if not HasNamedPtfxAssetLoaded("core") then
							RequestNamedPtfxAsset("core")
							while not HasNamedPtfxAssetLoaded("core") do
								Wait(1)
							end
						end
						TaskStartScenarioInPlace((PlayerPedId()), "PROP_HUMAN_STAND_IMPATIENT", 0, true)
						exports['progressBars']:startUI(18 *1000, Config.Sayings[118])
						UseParticleFxAssetNextCall("core") particles  = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z +1.8, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Wait(3000) particles2  = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z +1.8, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Wait(3000) particles3  = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z +1.8, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Wait(3000) particles4  = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z +1.8, 0.0, 0.0, 0.0, 1.0, false, false, false, false) UseParticleFxAssetNextCall("core") Wait(3000) particles5  = StartParticleFxLoopedAtCoord("ent_sht_water", Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z +1.8, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
						Wait(6000)
						ClearPedTasksImmediately(ped)
						using = false
						TriggerEvent('skinchanger:getSkin', function(skin)
							if skin.sex == 0 then
								TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
							else
								TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
							end
						end)
					end
				end
			else
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local dist = Vdist(Config.ShowerLocs[closestShower].x, Config.ShowerLocs[closestShower].y, Config.ShowerLocs[closestShower].z, coords)

				if dist >= Config.MaxDistShower then
					showerNow = false
					using = false
					Notification(Config.Sayings[117])
					TriggerEvent('skinchanger:getSkin', function(skin)
						if skin.sex == 0 then
							TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
						else
							TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
						end
					end)
				end
				Wait(500)
			end
		else
			Wait(1000)
		end
	end
end)

function StartWorkout(Loc)
	CreateThread(function()
		local ped = PlayerPedId()

		using = true
		workoutLoc = Loc
		SetEntityCoords(ped, Config.WorkoutLocs[Loc].StartLoc.Loc.x, Config.WorkoutLocs[Loc].StartLoc.Loc.y, Config.WorkoutLocs[Loc].StartLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.WorkoutLocs[Loc].StartLoc.Heading)
		
		RequestAnimDict('clothingtie')
		
		if not HasAnimDictLoaded('clothingtie') then
			Wait(0)
		end
	
		TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		inAnim.Dict = 'clothingtie'
		inAnim.Anim = 'try_tie_positive_a'
		inAnim.Atr = 1
		inAnim.Freeze = true
		FreezeEntityPosition(ped, true)
		exports['progressBars']:startUI(Config.WorkReadyTime *1000, Config.Sayings[114])
		Wait(Config.WorkReadyTime *1000)
		RemoveAnimDict("clothingtie")
		FreezeEntityPosition(ped, false)
		inAnim.Dict = nil
		inAnim.Anim = nil
		inAnim.Atr = 0
		inAnim.Freeze = false
		for i = 1, #jailLocs, 1 do
			if jailLocs[i].Id == 'workout'..workoutLoc then
				jailLocs[i].Text = Config.Sayings[126]
			end
		end
		ClearPedTasksImmediately(ped)
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.WorkoutFit.male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.WorkoutFit.female)
			end
		end)
		Notification(Config.Sayings[121])
		using = false
		workoutNow = true
	end)
end

function EndWorkout()
	CreateThread(function()
		local ped = PlayerPedId()

		using = true
		workoutNow = false
		SetEntityCoords(ped, Config.WorkoutLocs[workoutLoc].StartLoc.Loc.x, Config.WorkoutLocs[workoutLoc].StartLoc.Loc.y, Config.WorkoutLocs[workoutLoc].StartLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.WorkoutLocs[workoutLoc].StartLoc.Heading)
	
		RequestAnimDict('clothingtie')
		
		if not HasAnimDictLoaded('clothingtie') then
			Wait(0)
		end
	
		TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		inAnim.Dict = 'clothingtie'
		inAnim.Anim = 'try_tie_positive_a'
		inAnim.Atr = 1
		inAnim.Freeze = true
		FreezeEntityPosition(ped, true)
		exports['progressBars']:startUI(Config.WorkReadyTime *1000, Config.Sayings[114])
		Wait(Config.WorkReadyTime *1000)
		RemoveAnimDict("clothingtie")
		FreezeEntityPosition(ped, false)
		inAnim.Dict = nil
		inAnim.Anim = nil
		inAnim.Atr = 0
		inAnim.Freeze = false
		ClearPedTasksImmediately(ped)

		for i = 1, #jailLocs, 1 do
			if jailLocs[i].Id == 'workout'..workoutLoc then
				jailLocs[i].Text = Config.Sayings[120]
			end
		end
		workoutLoc = 0		
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.female)
			end
		end)
		Notification(Config.Sayings[125])
		using = false
	end)
end

function StartShower()
	CreateThread(function()
		local ped = PlayerPedId()

		using = true
		SetEntityCoords(ped, Config.ShowerLoc.Loc.x, Config.ShowerLoc.Loc.y, Config.ShowerLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.ShowerLoc.Heading)
		
		RequestAnimDict('clothingtie')
		
		if not HasAnimDictLoaded('clothingtie') then
			Wait(0)
		end
	
		TaskPlayAnim(ped, "clothingtie", "try_tie_positive_a", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		inAnim.Dict = 'clothingtie'
		inAnim.Anim = 'try_tie_positive_a'
		inAnim.Atr = 1
		inAnim.Freeze = true
		FreezeEntityPosition(ped, true)
		exports['progressBars']:startUI(Config.GetReadyTime *1000, Config.Sayings[114])
		Wait(Config.GetReadyTime *1000)
		RemoveAnimDict("clothingtie")
		FreezeEntityPosition(ped, false)
		inAnim.Dict = nil
		inAnim.Anim = nil
		inAnim.Atr = 0
		inAnim.Freeze = false
		ClearPedTasksImmediately(ped)
		TriggerEvent('skinchanger:getSkin', function(skin)
			if skin.sex == 0 then
				TriggerEvent('skinchanger:loadClothes', skin, Config.ShowerFit.male)
			else
				TriggerEvent('skinchanger:loadClothes', skin, Config.ShowerFit.female)
			end
		end)
		Notification(Config.Sayings[115])
		showerNow = true
	end)
end

function OpenBreakingMenu()
	local ped = PlayerPedId()
	local element = {}
	local flip = false

	if not Config.BreakLocs[closestBreak].ExitFence then
		for i = 1, #Config.FenceTool, 1 do
			table.insert(element, {label = Config.FenceTool[i].Name, value = i})
		end
		flip = false
	else
		for i = 1, #Config.RoomTools, 1 do
			table.insert(element, {label = Config.RoomTools[i].Name, value = i})
		end
		flip = true
	end

	ESX.UI.Menu.CloseAll()

	CreateThread(function()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'fence_menu', {
			title    = Config.Sayings[94],
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if flip then
				ESX.TriggerServerCallback('esx_jail:CheckItemB2', function(can)
					if can then
						menu.close()
						local hnum = 0
						local rannum = math.random(1,10)
						hnum = rannum
						if hnum <= Config.RoomTools[data.current.value].Percent then
							using = true
							RequestAnimDict('mini@repair')
										
							if not HasAnimDictLoaded('mini@repair') then
								LoadAnim('mini@repair')
							end
			
							SetEntityCoords(ped, Config.BreakLocs[closestBreak].StartLoc.Loc.x, Config.BreakLocs[closestBreak].StartLoc.Loc.y, Config.BreakLocs[closestBreak].StartLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.BreakLocs[closestBreak].StartLoc.Heading)
							TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = 'mini@repair'
							inAnim.Anim = 'fixing_a_ped'
							inAnim.Atr = 1
							inAnim.Freeze = true
							FreezeEntityPosition(ped, true)
							exports['progressBars']:startUI(Config.RoomTools[data.current.value].Time *1000, Config.Sayings[96])
							Wait(Config.RoomTools[data.current.value].Time *1000)
							RemoveAnimDict("mini@repair")
							FreezeEntityPosition(ped, false)
							inAnim.Dict = nil
							inAnim.Anim = nil
							inAnim.Atr = 0
							inAnim.Freeze = false
							ClearPedTasksImmediately(ped)
							DoScreenFadeOut(1000)
							Wait(1500)
							SetEntityCoords(ped, Config.BreakLocs[closestBreak].ExitLoc.Loc.x, Config.BreakLocs[closestBreak].ExitLoc.Loc.y, Config.BreakLocs[closestBreak].ExitLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.BreakLocs[closestBreak].ExitLoc.Heading)
							TriggerServerEvent('esx_jail:UpdateBreaking')
							breakout3 = false
							breakout4 = false
							breakout = 0
							local removes = {}
							for i = 1, #blips, 1 do
								if blips[i].id == 'escape' then
									table.insert(removes, i)
								end
							end
							for i = 1, #removes, 1 do
								if DoesBlipExist(blips[removes[i]].data) then
									RemoveBlip(blips[removes[i]].data)
								end
								table.remove(blips[removes[i]])
							end
							DoScreenFadeIn(1000)
							Wait(1000)
							using = false
							Notification(Config.Sayings[90])
						else
							TriggerServerEvent('esx_jail:TakeItems2', Config.RoomTools[data.current.value].Item)
							using = true
							RequestAnimDict('mini@repair')
										
							if not HasAnimDictLoaded('mini@repair') then
								LoadAnim('mini@repair')
							end
			
							SetEntityCoords(ped, Config.BreakLocs[closestBreak].StartLoc.Loc.x, Config.BreakLocs[closestBreak].StartLoc.Loc.y, Config.BreakLocs[closestBreak].StartLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.BreakLocs[closestBreak].StartLoc.Heading)
							TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = 'mini@repair'
							inAnim.Anim = 'fixing_a_ped'
							inAnim.Atr = 0
							inAnim.Freeze = false
							FreezeEntityPosition(ped, true)
							exports['progressBars']:startUI(Config.RoomTools[data.current.value].Time *1000, Config.Sayings[96])
							Wait(Config.RoomTools[data.current.value].Time *1000)
							RemoveAnimDict("mini@repair")
							FreezeEntityPosition(ped, false)
							inAnim.Dict = nil
							inAnim.Anim = nil
							inAnim.Atr = 0
							inAnim.Freeze = false
							ClearPedTasksImmediately(ped)
							using = false
							Notification(Config.Sayings[91])
						end
					else
						Notification(Config.Sayings[95])
					end
				end, Config.RoomTools[data.current.value].Item)
			else
				ESX.TriggerServerCallback('esx_jail:CheckItemB2', function(can)
					if can then
						menu.close()
						local hnum = 0
						local rannum = math.random(1,10)
						hnum = rannum
						if hnum <= Config.FenceTool[data.current.value].Percent then
							using = true
							RequestAnimDict('mp_arresting')
										
							if not HasAnimDictLoaded('mp_arresting') then
								LoadAnim('mp_arresting')
							end
			
							SetEntityCoords(ped, Config.BreakLocs[closestBreak].StartLoc.Loc.x, Config.BreakLocs[closestBreak].StartLoc.Loc.y, Config.BreakLocs[closestBreak].StartLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.BreakLocs[closestBreak].StartLoc.Heading)
							TaskPlayAnim(ped, 'mp_arresting', 'a_uncuff', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = 'mp_arresting'
							inAnim.Anim = 'a_uncuff'
							inAnim.Atr = 1
							inAnim.Freeze = true
							FreezeEntityPosition(ped, true)
							exports['progressBars']:startUI(Config.FenceTool[data.current.value].Time *1000, Config.Sayings[97])
							Wait(Config.FenceTool[data.current.value].Time *1000)
							RemoveAnimDict("mp_arresting")
							FreezeEntityPosition(ped, false)
							inAnim.Dict = nil
							inAnim.Anim = nil
							inAnim.Atr = 0
							inAnim.Freeze = false
							ClearPedTasksImmediately(ped)
							using = false
							DoScreenFadeOut(1000)
							Wait(1500)
							SetEntityCoords(ped, Config.BreakLocs[closestBreak].ExitLoc.Loc.x, Config.BreakLocs[closestBreak].ExitLoc.Loc.y, Config.BreakLocs[closestBreak].ExitLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.BreakLocs[closestBreak].ExitLoc.Heading)
							DoScreenFadeIn(1000)
							Wait(1000)
							Notification(Config.Sayings[90])
						else
							TriggerServerEvent('esx_jail:TakeItems2', Config.RoomTools[data.current.value].Item)
							using = true
							RequestAnimDict('mp_arresting')
										
							if not HasAnimDictLoaded('mp_arresting') then
								LoadAnim('mp_arresting')
							end
			
							SetEntityCoords(ped, Config.BreakLocs[closestBreak].StartLoc.Loc.x, Config.BreakLocs[closestBreak].StartLoc.Loc.y, Config.BreakLocs[closestBreak].StartLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.BreakLocs[closestBreak].StartLoc.Heading)
							TaskPlayAnim(ped, 'mp_arresting', 'a_uncuff', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = 'mp_arresting'
							inAnim.Anim = 'a_uncuff'
							inAnim.Atr = 0
							inAnim.Freeze = false
							FreezeEntityPosition(ped, true)
							exports['progressBars']:startUI(Config.FenceTool[data.current.value].Time *1000, Config.Sayings[97])
							Wait(Config.FenceTool[data.current.value].Time *1000)
							RemoveAnimDict("mp_arresting")
							FreezeEntityPosition(ped, false)
							inAnim.Dict = nil
							inAnim.Anim = nil
							inAnim.Atr = 0
							inAnim.Freeze = false
							ClearPedTasksImmediately(ped)
							using = false
							Notification(Config.Sayings[91])
						end
					else
						Notification(Config.Sayings[95])
					end
				end, Config.FenceTool[data.current.value].Item)
			end
		end, function(data, menu)
			menu.close()
			inMenu.is = false
			inMenu.coords = nil
		end)
	end)
end

function IEscaped()
	TriggerServerEvent('esx_jail:UnJailPlayer', GetPlayerServerId(PlayerId()), false)
	TriggerServerEvent('esx_jail:PoliceNotify')
	time = 0
	soltime = 0
	job = 0
	doneTasks = 0
	taskMax = 0
	injail = false
	jailCell = 0
	solcell = 0
	canGrab = false	
	createdCamera = 0
	local removes = {}
	for i = 1, #blips, 1 do
		table.insert(removes, i)
	end
	for i = 1, #removes, 1 do
		if DoesBlipExist(blips[removes[i]].data) then
			RemoveBlip(blips[removes[i]].data)
		end
		table.remove(blips[removes[i]])
	end
	removes = {}
	for i = 1, #peds, 1 do
		table.insert(removes, i)
	end
	for i = 1, #removes, 1 do
		if DoesEntityExist(peds[removes[i]].data) then
			SetPedAsNoLongerNeeded(peds[removes[i]].data)
			DeletePed(peds[removes[i]].data)
		end
		table.remove(peds[removes[i]])
	end
	removes = {}
	for i = 1, #PlayerHasProp, 1 do
		table.insert(removes, i)
	end
	for i = 1, #removes, 1 do
		if DoesEntityExist(PlayerHasProp[removes[i]].object) then
			DeleteObject(PlayerHasProp[removes[i]].object)
		end
		table.remove(PlayerHasProp[removes[i]])
	end
	removes = {}
	closestLoc = 1
	breakout = 0
	breakout2 = false
	breakout3 = false
	breakout4 = true
	closestTower = 1
	closestBreak = 1
    Wait(500)
	jailLocs = {}
	inMenu = {is = false, coords = nil}
	needsEat = false
end

function OpenWallMenu()
	local ped = PlayerPedId()
	local element = {}


	for i = 1, #Config.RoomTools, 1 do
		table.insert(element, {label = Config.RoomTools[i].Name, value = i})
	end

	ESX.UI.Menu.CloseAll()

	CreateThread(function()
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'wall_menu', {
			title    = Config.Sayings[87],
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			ESX.TriggerServerCallback('esx_jail:CheckItemB', function(can)
				if can then
					local hnum = 0
					local rannum = math.random(1,10)
					hnum = rannum
					menu.close()
					if hnum <= Config.RoomTools[data.current.value].Percent then
						TriggerServerEvent('esx_jail:SuccessFul', GetPlayerServerId(PlayerId()), Config.RoomTools[data.current.value].Time *1000)
						using = true
						RequestAnimDict('mini@repair')
									
						if not HasAnimDictLoaded('mini@repair') then
							LoadAnim('mini@repair')
						end
		
						SetEntityCoords(ped, Config.Cells[jailCell].BreakLoc.Loc.x, Config.Cells[jailCell].BreakLoc.Loc.y, Config.Cells[jailCell].BreakLoc.Loc.z - 1, false, false, false, false)
						SetEntityHeading(ped, Config.Cells[jailCell].BreakLoc.Heading)
						TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
						inAnim.Dict = 'mini@repair'
						inAnim.Anim = 'fixing_a_ped'
						inAnim.Atr = 1
						inAnim.Freeze = true
						FreezeEntityPosition(ped, true)
						exports['progressBars']:startUI(Config.RoomTools[data.current.value].Time *1000, Config.Sayings[96])
						Wait(Config.RoomTools[data.current.value].Time *1000)
						RemoveAnimDict("mini@repair")
						FreezeEntityPosition(ped, false)
						inAnim.Dict = nil
						inAnim.Anim = nil
						inAnim.Atr = 0
						inAnim.Freeze = false
						ClearPedTasksImmediately(ped)
						using = false
						Notification(Config.Sayings[90])
					else
						TriggerServerEvent('esx_jail:TakeItems4', data.current.value)
						using = true
						RequestAnimDict('mini@repair')
									
						if not HasAnimDictLoaded('mini@repair') then
							LoadAnim('mini@repair')
						end
		
						SetEntityCoords(ped, Config.Cells[jailCell].BreakLoc.Loc.x, Config.Cells[jailCell].BreakLoc.Loc.y, Config.Cells[jailCell].BreakLoc.Loc.z - 1, false, false, false, false)
						SetEntityHeading(ped, Config.Cells[jailCell].BreakLoc.Heading)
						TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
						inAnim.Dict = 'mini@repair'
						inAnim.Anim = 'fixing_a_ped'
						inAnim.Atr = 1
						inAnim.Freeze = false
						FreezeEntityPosition(ped, true)
						exports['progressBars']:startUI(Config.RoomTools[data.current.value].Time *1000, Config.Sayings[96])
						Wait(Config.RoomTools[data.current.value].Time *1000)
						RemoveAnimDict("mini@repair")
						FreezeEntityPosition(ped, false)
						inAnim.Dict = nil
						inAnim.Anim = nil
						inAnim.Atr = 0
						inAnim.Freeze = false
						ClearPedTasksImmediately(ped)
						using = false
						Notification(Config.Sayings[91])
					end
				else
					Notification(Config.Sayings[88])
				end
			end, data.current.value)
		end, function(data, menu)
			menu.close()
			inMenu.is = false
			inMenu.coords = nil
		end)
	end)
end

function BreakOutStart()
	CreateThread(function()
		local ped = PlayerPedId()
		using = true
		RequestAnimDict('mini@repair')
					
		if not HasAnimDictLoaded('mini@repair') then
			LoadAnim('mini@repair')
		end
	
		SetEntityCoords(ped, Config.Cells[jailCell].BreakLoc.Loc.x, Config.Cells[jailCell].BreakLoc.Loc.y, Config.Cells[jailCell].BreakLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.Cells[jailCell].BreakLoc.Heading)
		TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		inAnim.Dict = 'mini@repair'
		inAnim.Anim = 'fixing_a_ped'
		inAnim.Atr = 1
		inAnim.Freeze = false
		FreezeEntityPosition(ped, true)
		exports['progressBars']:startUI(Config.CrawlTime *1000, Config.Sayings[161])
		Wait(Config.CrawlTime *1000)
		RemoveAnimDict("mini@repair")
		FreezeEntityPosition(ped, false)
		inAnim.Dict = nil
		inAnim.Anim = nil
		inAnim.Atr = 0
		inAnim.Freeze = false
		ClearPedTasksImmediately(ped)
		DoScreenFadeOut(1000)
		Wait(1000)
	
		for i = 1, #Config.BreakLocs, 1 do
			local blip5 = AddBlipForCoord(Config.BreakLocs[i].StartLoc.Loc.x, Config.BreakLocs[i].StartLoc.Loc.y, Config.BreakLocs[i].StartLoc.Loc.z)
			SetBlipSprite(blip5, Config.BreakBlips.Sprite)
			SetBlipScale(blip5, Config.BreakBlips.Size)
			SetBlipColour(blip5, Config.BreakBlips.Color)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Sayings[98])
			EndTextCommandSetBlipName(blip5)
			table.insert(blips, {id = 'escape', data = blip5})
		end
	
		for i = 1, #Config.WatchTowers, 1 do
			local blip5 = AddBlipForCoord(Config.WatchTowers[i].x, Config.WatchTowers[i].y, Config.WatchTowers[i].z)
			SetBlipSprite(blip5, Config.WatchBlip.Sprite)
			SetBlipScale(blip5, Config.WatchBlip.Size)
			SetBlipColour(blip5, Config.WatchBlip.Color)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Config.Sayings[99])
			EndTextCommandSetBlipName(blip5)
			table.insert(blips, {id = 'tower', data = blip5})
		end
		SetEntityCoords(ped, Config.Cells[jailCell].ExitLoc.Loc.x, Config.Cells[jailCell].ExitLoc.Loc.y, Config.Cells[jailCell].ExitLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.Cells[jailCell].ExitLoc.Heading)
		FreezeEntityPosition(ped, true)
		Wait(1000)
		FreezeEntityPosition(ped, false)
		TriggerServerEvent('esx_jail:UpdateBreak')
		breakout = Config.BreakoutTime 
		breakout2 = true
		DoScreenFadeIn(1000)
		Wait(1500)
	
		using = false
		for i = 1, #jailLocs, 1 do
			if jailLocs[i].Id == 'break' then
				jailLocs[i].Text = Config.Sayings[28]
			end
		end
	end)
end

RegisterNetEvent('esx_jail:UpBreaks')
AddEventHandler('esx_jail:UpBreaks', function(amt, flip, time)
	local ped = PlayerPedId()
	if amt >= Config.BreakHole then
		breakout3 = true
		if flip then
			Wait(time)
			Notification(Config.Sayings[102])
		end
		for i = 1, #jailLocs, 1 do
			if jailLocs[i].Id == 'break' then
				jailLocs[i].Text = Config.Sayings[89]
			end
		end
	else
		local leftamt = 0
		leftamt = Config.BreakHole - amt
		if flip then
			Wait(time)
			Notification(Config.Sayings[100]..leftamt..Config.Sayings[101])
		end
	end
end)

RegisterNetEvent('esx_jail:UnBreak2')
AddEventHandler('esx_jail:UnBreak2', function()
	CreateThread(function()
		local ped = PlayerPedId()
		breakout3 = false
		breakout = 0
		breakout2 = false
		DoScreenFadeOut(1000)
		FreezeEntityPosition(ped, true)
		Wait(1500)
		FreezeEntityPosition(ped, false)
		local removes = {}
		for i = 1, #blips, 1 do
			if blips[i].id == 'escape' then
				table.insert(removes, i)
			elseif blips[i].id == 'tower' then
				table.insert(removes, i)
			end
		end
		for i = 1, #removes, 1 do
			if DoesBlipExist(blips[removes[i]].data) then
				RemoveBlip(blips[removes[i]].data)
			end
			table.remove(blips[removes[i]])
		end
		if Config.FailBreakToSol and Config.Solitary then
			TriggerServerEvent('esx_jail:SendToSol', GetPlayerServerId(PlayerId()), Config.SolBreakTime, Config.Sayings[108])
		else
			SetEntityCoords(ped, Config.Cells[jailCell].SpawnLoc.Loc.x, Config.Cells[jailCell].SpawnLoc.Loc.y, Config.Cells[jailCell].SpawnLoc.Loc.z - 1, false, false, false, false)
			SetEntityHeading(ped, Config.Cells[jailCell].SpawnLoc.Heading)
		end
	end)
end)

CreateThread(function()
	while true do
		if not using and time > 0 then
			if job ~= 0 then
				if doneTasks ~= 0 then
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped)
					local dist = Vdist(Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.x, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.y, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.z, coords)
	
					if dist <= Config.SeeTaskMark then
						Wait(5)
						DrawMarker(Config.JobOptions[job].Tasks[doneTasks].MarkNum, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.x, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.y, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.JobOptions[job].Tasks[doneTasks].MarkSize.x, Config.JobOptions[job].Tasks[doneTasks].MarkSize.y, Config.JobOptions[job].Tasks[doneTasks].MarkSize.z, Config.JobOptions[job].Tasks[doneTasks].MarkColor.r, Config.JobOptions[job].Tasks[doneTasks].MarkColor.g, Config.JobOptions[job].Tasks[doneTasks].MarkColor.b, 100, false, false, 2, true, nil, nil, false)
						if dist <= Config.SeeTaskText then
							DrawText3D(Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.x, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.y, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.z + Config.TextLift, Config.Sayings[22]..Config.JobOptions[job].Tasks[doneTasks].TaskName)
							if IsControlJustReleased(0, 38) then
								TaskComplete()
							end
						end
					else
						Wait(1000)
					end
				else
					Wait(1000)
				end
			else
				Wait(1000)
			end
		elseif needsEat then
			Wait(5)
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)

			DrawText3D(coords.x, coords.y, coords.z, Config.Sayings[44])
			if IsControlJustReleased(0, 38) then
				exports['progressBars']:startUI(Config.EatTime *1000, Config.Sayings[139])
				Wait(Config.EatTime *1000)
				using = false
				needsEat = false
				inAnim.Dict = nil
				inAnim.Anim = nil
				inAnim.Atr = 0
				inAnim.Freeze = false
				ClearPedTasksImmediately(ped)
				local rem = {}
				for i = 1, #PlayerHasProp, 1 do
					if PlayerHasProp[i].id == 'food' then
						DeleteObject(PlayerHasProp[i].object)
						table.insert(rem, i)
					end
				end
				for i = 1, #rem, 1 do
					table.remove(PlayerHasProp, rem[i])
				end
				TriggerServerEvent('esx_jail:Ate')
			elseif IsControlJustReleased(0, 47) then
				using = false
				needsEat = false
				inAnim.Dict = nil
				inAnim.Anim = nil
				inAnim.Atr = 0
				inAnim.Freeze = false
				ClearPedTasksImmediately(ped)
				local rem = {}
				for i = 1, #PlayerHasProp, 1 do
					if PlayerHasProp[i].id == 'food' then
						DeleteObject(PlayerHasProp[i].object)
						table.insert(rem, i)
					end
				end
				for i = 1, #rem, 1 do
					table.remove(PlayerHasProp, rem[i])
				end
			end
		elseif not using and Config.PoliceCanSearchInv then
			if ESX.PlayerData.job ~= nil then
				local policep = false
				for i = 1, #Config.PoliceRoles, 1 do
					if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.PoliceRoles[i] then
						policep = true
					end
				end
				if policep then
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped)
					local dist = Vdist(Config.Cells[closestPoliceInv].InvLoc.Loc.x, Config.Cells[closestPoliceInv].InvLoc.Loc.y, Config.Cells[closestPoliceInv].InvLoc.Loc.z, coords)

					if dist <= Config.SeePoliceDist then
						Wait(5)
						DrawMarker(Config.PMarkNum, Config.Cells[closestPoliceInv].InvLoc.Loc.x, Config.Cells[closestPoliceInv].InvLoc.Loc.y, Config.Cells[closestPoliceInv].InvLoc.Loc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.PMarkSize.x, Config.PMarkSize.y, Config.PMarkSize.z, Config.PMarkColor.r, Config.PMarkColor.g, Config.PMarkColor.b, 100, false, false, 2, true, nil, nil, false)
						if dist <= Config.UsePoliceDist then
							DrawText3D(Config.Cells[closestPoliceInv].InvLoc.Loc.x, Config.Cells[closestPoliceInv].InvLoc.Loc.y, Config.Cells[closestPoliceInv].InvLoc.Loc.z + Config.TextLift, Config.Sayings[158])
							if IsControlJustReleased(0, 38) then
								OpenPoliceShitMenu()
								inMenu.coords = Config.Cells[closestPoliceInv].InvLoc.Loc
								inMenu.is = true
							end
						end
					else
						Wait(1000)
					end
				else
					Wait(3000)
				end
			else
				Wait(1000)
			end
		else
			Wait(1000)
		end
	end
end)

function OpenPoliceShitMenu()
	using = true
	ESX.TriggerServerCallback('esx_jail:GetPlayerInCell', function(players)
		local ped = PlayerPedId()
		local element = {}
	
		for i = 1, #players, 1 do
			table.insert(element, {label = players[i].name..Config.Sayings[156]..players[i].id, value = players[i].id, namio = players[i].name})
		end

		if element[1] == nil then
			table.insert(element, {label = Config.Sayings[69], value = 'none'})
		end

		ESX.UI.Menu.CloseAll()
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'police_shit', {
			title    = Config.Sayings[155],
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if data.current.value ~= 'none' then
				OpenPoliceMenu2(data.current.namio, data.current.value)
			end
		end, function(data, menu)
			menu.close()
			using = false
			inMenu.is = false
			inMenu.coords = nil
		end)
	end, closestPoliceInv)
end

function OpenPoliceMenu2(name, theirID)
	CreateThread(function()
		local ped = PlayerPedId()

		RequestAnimDict('mini@repair')
								
		if not HasAnimDictLoaded('mini@repair') then
			LoadAnim('mini@repair')
		end
		SetEntityCoords(ped, Config.Cells[closestPoliceInv].InvLoc.Loc.x, Config.Cells[closestPoliceInv].InvLoc.Loc.y, Config.Cells[closestPoliceInv].InvLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.Cells[closestPoliceInv].InvLoc.Heading)
		TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		inAnim.Dict = 'mini@repair'
		inAnim.Anim = 'fixing_a_ped'
		inAnim.Atr = 1
		inAnim.Freeze = true
		FreezeEntityPosition(ped, true)
		exports['progressBars']:startUI(Config.OpenCloseTime *1000, Config.Sayings[35])
		Wait(Config.OpenCloseTime *1000)
	
		ESX.TriggerServerCallback('esx_jail:GetChest2', function(cvalue)
			local valuesc = {}
			local element = {}
	
			valuesc = cvalue
			if valuesc[1] ~= nil then
				for i = 1, #valuesc, 1 do 
					table.insert(element, {label = valuesc[i].amt..'x '..valuesc[i].itemName, value = i})
				end
			else
				table.insert(element, {label = Config.Sayings[33], value = 'none'})
			end
	
			ESX.UI.Menu.CloseAll()
	
			ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inv_menu2', {
				title    = name..Config.Sayings[157],
				align    = Config.MenuLoc,
				elements = element
			}, function(data, menu)
				if data.current.value ~= 'none' then
					local numies = data.current.value
					menu.close()
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inv_amt', {
						title = (Config.Sayings[37])
					}, function(data, menu)
						local amount = tonumber(data.value)
			
						if amount == nil or amount < 0 then
							Notification(Config.Sayings[38])
						elseif amount > valuesc[numies].amt then
							Notification(Config.Sayings[39])
						else
							menu.close()
							TriggerServerEvent('esx_jail:RemoveItem2', valuesc[numies].ite, amount, valuesc[numies].itemName, theirID)
						end
					end, function(data, menu)
						menu.close()
						exports['progressBars']:startUI(Config.OpenCloseTime *1000, Config.Sayings[36])
						Wait(Config.OpenCloseTime *1000)
						FreezeEntityPosition(ped, false)
						inAnim.Dict = nil
						inAnim.Anim = nil
						inAnim.Atr = 0
						inAnim.Freeze = false
						RemoveAnimDict('mini@repair')
						ClearPedTasksImmediately(ped)
						OpenPoliceMenu2(name, theirID)
					end)
				end
			end, function(data, menu)
				menu.close()
				ClearPedTasksImmediately(ped)
				OpenPoliceShitMenu()
			end)
		end, theirID)
	end)
end

function OpenInfoMenu()
	local ped = PlayerPedId()
	local element = {
		[1] = {label = Config.Sayings[47], value = 'make'},
		[2] = {label = Config.Sayings[46], value = 'break'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'info_menu', {
		title    = Config.Sayings[45],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		if data.current.value == 'make' then
			OpenMakeMenu()
		else
			OpenBreakMenu()
		end
	end, function(data, menu)
		menu.close()
		inMenu.is = false
		inMenu.coords = nil
	end)
end

function OpenMakeMenu()
	local ped = PlayerPedId()
	local element = {}

	for i = 1, #Config.Crafts, 1 do
		table.insert(element, {label = Config.Crafts[i].Name, value = i})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'make_menu', {
		title    = Config.Sayings[48],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		OpenCraftMenu(data.current.value)
	end, function(data, menu)
		menu.close()
		OpenInfoMenu()
	end)
end

function OpenCraftMenu(itnum)
	CreateThread(function()
		local ped = PlayerPedId()
		local element = {
			[1] = {label = Config.Sayings[50], value = 'need'},
			[2] = {label = Config.Sayings[51], value = 'make'}
		}
	
		ESX.UI.Menu.CloseAll()
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'make_menu2', {
			title    = Config.Crafts[itnum].Name,
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if data.current.value == 'need' then
				OpenNeedsMenu(itnum)
			else
				menu.close()
				ESX.TriggerServerCallback('esx_jail:CheckItemMake', function(can)
					if can == 1 then
						Notification(Config.Sayings[83])
					elseif can == 2 then
						Notification(Config.Sayings[84])
					else
						CreateThread(function()
							using = true
							TriggerServerEvent('esx_jail:TakeItems', itnum)
							local pedi = nil
							for i = 1, #peds, 1 do
								if peds[i].id == 'info' then
									pedi = peds[i].data
								end
							end
							RequestAnimDict('missmic4')
								
							if not HasAnimDictLoaded('missmic4') then
								LoadAnim('missmic4')
							end
	
							FreezeEntityPosition(pedi, false)
							ESX.Game.MakeEntityFaceEntity(ped, pedi)
							ESX.Game.MakeEntityFaceEntity(pedi, ped)
							TaskPlayAnim(pedi, 'missmic4', 'michael_tux_fidget', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							TaskPlayAnim(ped, 'missmic4', 'michael_tux_fidget', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
							inAnim.Dict = 'missmic4'
							inAnim.Anim = 'michael_tux_fidget'
							inAnim.Atr = 1
							inAnim.Freeze = true
							FreezeEntityPosition(ped, true)
							FreezeEntityPosition(pedi, true)
							exports['progressBars']:startUI(Config.Crafts[itnum].Time *1000, Config.Sayings[85])
							Wait(Config.Crafts[itnum].Time *1000)
							ClearPedTasksImmediately(pedi)
							ClearPedTasksImmediately(ped)
							FreezeEntityPosition(pedi, false)
							SetEntityHeading(pedi, Config.InfoPedLoc[infoLoc].Heading)
							FreezeEntityPosition(pedi, true)
							FreezeEntityPosition(ped, false)
							inAnim.Dict = nil
							inAnim.Anim = nil
							inAnim.Atr = 0
							inAnim.Freeze = false
							using = false
						end)
					end
				end, itnum)
			end
		end, function(data, menu)
			menu.close()
			OpenMakeMenu()
		end)
	end)
end

function OpenNeedsMenu(numzioe)
	local ped = PlayerPedId()
	local element = {}

	for i = 1, #Config.Crafts[numzioe].Needed, 1 do
		table.insert(element, {label = Config.Crafts[numzioe].Needed[i].Amount..'x '..Config.Crafts[numzioe].Needed[i].Name, value = i})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'need_menu', {
		title    = Config.Sayings[52],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)

	end, function(data, menu)
		menu.close()
		OpenCraftMenu(numzioe)
	end)
end

function TaskComplete()
	CreateThread(function()
		local ped = PlayerPedId()
		RequestAnimDict(Config.JobOptions[job].Tasks[doneTasks].Anim.Dict)
								
		if not HasAnimDictLoaded(Config.JobOptions[job].Tasks[doneTasks].Anim.Dict) then
			LoadAnim(Config.JobOptions[job].Tasks[doneTasks].Anim.Dict)
		end
	
		local rem = {}
		for i = 1, #PlayerHasProp, 1 do
			if PlayerHasProp[i].id == 'task' then
				DeleteObject(PlayerHasProp[i].object)
				table.insert(rem, i)
			end
		end
		for i = 1, #rem, 1 do
			table.remove(PlayerHasProp, rem[i])
		end
		rem = {}
		using = true
		SetEntityCoords(ped, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.x, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.y, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Heading)
		if Config.JobOptions[job].Tasks[doneTasks].AttachItem.Attach then
			AddPropToPlayer(Config.JobOptions[job].Tasks[doneTasks].AttachItem.Prop, 28422, Config.JobOptions[job].Tasks[doneTasks].AttachItem.Offsets.First, Config.JobOptions[job].Tasks[doneTasks].AttachItem.Offsets.Second, Config.JobOptions[job].Tasks[doneTasks].AttachItem.Offsets.Third, Config.JobOptions[job].Tasks[doneTasks].AttachItem.Offsets.Four, Config.JobOptions[job].Tasks[doneTasks].AttachItem.Offsets.Five, Config.JobOptions[job].Tasks[doneTasks].AttachItem.Offsets.Six , 'task', nil, true)
		end
		TaskPlayAnim(ped, Config.JobOptions[job].Tasks[doneTasks].Anim.Dict, Config.JobOptions[job].Tasks[doneTasks].Anim.AnimName, 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		inAnim.Dict = Config.JobOptions[job].Tasks[doneTasks].Anim.Dict
		inAnim.Anim = Config.JobOptions[job].Tasks[doneTasks].Anim.AnimName
		inAnim.Atr = 1
		inAnim.Freeze = true
		FreezeEntityPosition(ped, true)
		exports['progressBars']:startUI(Config.JobOptions[job].Tasks[doneTasks].Time *1000, Config.Sayings[23])
		Wait(Config.JobOptions[job].Tasks[doneTasks].Time *1000)
		FreezeEntityPosition(ped, false)
		inAnim.Dict = nil
		inAnim.Anim = nil
		inAnim.Atr = 0
		inAnim.Freeze = false
		RemoveAnimDict(Config.JobOptions[job].Tasks[doneTasks].Anim.Dict)
		if Config.JobOptions[job].Tasks[doneTasks].AttachItem.Attach then
			for i = 1, #PlayerHasProp, 1 do
				if PlayerHasProp[i].id == 'task' then
					DeleteObject(PlayerHasProp[i].object)
					table.insert(rem, i)
				end
			end
			for i = 1, #rem, 1 do
				table.remove(PlayerHasProp, rem[i])
			end
			rem = {}
		end
		ClearPedTasksImmediately(ped)
		using = false
		
		if Config.JobOptions[job].Tasks[doneTasks].CarryItem.Attach then
			AddPropToPlayer(Config.JobOptions[job].Tasks[doneTasks].CarryItem.Prop, 28422, Config.JobOptions[job].Tasks[doneTasks].CarryItem.Offsets.First, Config.JobOptions[job].Tasks[doneTasks].CarryItem.Offsets.Second, Config.JobOptions[job].Tasks[doneTasks].CarryItem.Offsets.Third, Config.JobOptions[job].Tasks[doneTasks].CarryItem.Offsets.Four, Config.JobOptions[job].Tasks[doneTasks].CarryItem.Offsets.Five, Config.JobOptions[job].Tasks[doneTasks].CarryItem.Offsets.Six , 'task', nil, true)
		end
		if doneTasks >= taskMax then
			doneTasks = 1
			Notification(Config.Sayings[25])
			time = time - Config.JobOptions[job].TimeRemove
			TriggerServerEvent('esx_jail:TaskComplete', job)
		else
			doneTasks = doneTasks + 1
			Notification(Config.Sayings[24])
		end
	
		TriggerServerEvent('esx_jail:TaskComplete1', job)
	
		local removes = {}
		for i = 1, #blips, 1 do
			if blips[i].id == 'task' then
				table.insert(removes, i)
			end
		end
		for i = 1, #removes, 1 do
			if DoesBlipExist(blips[removes[i]].data) then
				RemoveBlip(blips[removes[i]].data)
			end
			table.remove(blips[removes[i]])
		end
	
		local blip4 = AddBlipForCoord(Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.x, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.y, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.z)
		SetBlipSprite(blip4, Config.JobOptions[job].Tasks[doneTasks].TBlip.Sprite)
		SetBlipScale(blip4, Config.JobOptions[job].Tasks[doneTasks].TBlip.Size)
		SetBlipColour(blip4, Config.JobOptions[job].Tasks[doneTasks].TBlip.Color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.JobOptions[job].Tasks[doneTasks].TaskName..' | '..Config.Sayings[26]..doneTasks..'/'..taskMax)
		EndTextCommandSetBlipName(blip4)
		table.insert(blips, {id = 'task', data = blip4})
	end)
end

CreateThread(function()
	while true do
		if time > 0 and not isDead and breakout4 then
			Wait(1000)
			if breakout > 0 then
				breakout = breakout - 1

				if not Config.SimpleTime then
					local duration = breakout
					local extraSeconds = duration%60
					local minutes = (duration-extraSeconds)/60
					if duration >= 60 then
						if minutes >= 60 then
							local extraMinutes = minutes%60
							local hours = (minutes-extraMinutes)/60
							diffBreak.Hours = math.floor(hours)
							diffBreak.Mins = math.ceil(extraMinutes)
							diffBreak.Seconds = extraSeconds
						else
							diffBreak.Hours = 0
							diffBreak.Mins = math.floor(minutes)
							diffBreak.Seconds = extraSeconds
						end
					else
						diffBreak.Hours = 0
						diffBreak.Mins = 0
						diffBreak.Seconds = breakout
					end
				end
		    elseif soltime > 0 then
				soltime = soltime - 1

				if not Config.SimpleTime then
					local duration = soltime
					local extraSeconds = duration%60
					local minutes = (duration-extraSeconds)/60
					if duration >= 60 then
						if minutes >= 60 then
							local extraMinutes = minutes%60
							local hours = (minutes-extraMinutes)/60
							diffSol.Hours = math.floor(hours)
							diffSol.Mins = math.ceil(extraMinutes)
							diffSol.Seconds = extraSeconds
						else
							diffSol.Hours = 0
							diffSol.Mins = math.floor(minutes)
							diffSol.Seconds = extraSeconds
						end
					else
						diffSol.Hours = 0
						diffSol.Mins = 0
						diffSol.Seconds = soltime
					end
				end

				if Config.TpBack then
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped)
					local dist = Vdist(Config.SolCells[solcell].Loc.x, Config.SolCells[solcell].Loc.y, Config.SolCells[solcell].Loc.z, coords)
					if dist > Config.MaxSolTpDist then
						DoScreenFadeOut(1000)
						Wait(1500)
						SetEntityCoords(ped, Config.SolCells[solcell].Loc.x, Config.SolCells[solcell].Loc.y, Config.SolCells[solcell].Loc.z - 1, false, false, false, false)
						SetEntityHeading(ped, Config.SolCells[solcell].Heading)
						FreezeEntityPosition(ped, true)
						Wait(1000)
						DoScreenFadeIn(1000)
					end
				end
			else
				time = time - 1

				if not Config.SimpleTime then
					local duration = time
					local extraSeconds = duration%60
					local minutes = (duration-extraSeconds)/60
					if duration >= 60 then
						if minutes >= 60 then
							local extraMinutes = minutes%60
							local hours = (minutes-extraMinutes)/60
							difftime.Hours = math.floor(hours)
							difftime.Mins = math.ceil(extraMinutes)
							difftime.Seconds = extraSeconds
						else
							difftime.Hours = 0
							difftime.Mins = math.floor(minutes)
							difftime.Seconds = extraSeconds
						end
					else
						difftime.Hours = 0
						difftime.Mins = 0
						difftime.Seconds = time
					end
				end

				if Config.TpBack then
					local ped = PlayerPedId()
					local coords = GetEntityCoords(ped)
					local dist = Vdist(Config.JailLoc.x, Config.JailLoc.y, Config.JailLoc.z, coords)
					if dist > Config.MaxTpDist then
						if Config.Sol4Run and Config.Solitary then
							TriggerServerEvent('esx_jail:SendToSol', GetPlayerServerId(PlayerId()), Config.SolRunTime, Config.Sayings[109])
							Wait(1000)
						else
							DoScreenFadeOut(1000)
							Wait(1500)
							SetEntityCoords(ped, Config.Cells[jailCell].SpawnLoc.Loc.x, Config.Cells[jailCell].SpawnLoc.Loc.y, Config.Cells[jailCell].SpawnLoc.Loc.z - 1, false, false, false, false)
							SetEntityHeading(ped, Config.Cells[jailCell].SpawnLoc.Heading)
							Wait(1000)
							DoScreenFadeIn(1000)
						end
					end
				end
			end

			if inAnim.Dict ~= nil and inAnim.Anim ~= nil then
				local ped = PlayerPedId()
				if not IsEntityPlayingAnim(ped, inAnim.Dict, inAnim.Anim, 3) then
					ClearPedTasksImmediately(ped)
					RequestAnimDict(inAnim.Dict)
								
					if not HasAnimDictLoaded(inAnim.Dict) then
						LoadAnim(inAnim.Dict)
					end

					if inAnim.Freeze then
						FreezeEntityPosition(ped, false)
					end
					TaskPlayAnim(ped, inAnim.Dict, inAnim.Anim, 8.0, 8.0, -1, inAnim.Atr, 1, 0, 0, 0)
					if inAnim.Freeze then
						FreezeEntityPosition(ped, true)
					end
					RemoveAnimDict(inAnim.Dict)
				end
			end
			if inMenu.is and inMenu.coords ~= nil then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local dist = Vdist(inMenu.coords.x, inMenu.coords.y, inMenu.coords.z, coords)

				if dist > Config.MaxMenuDist then
					ESX.UI.Menu.CloseAll()
					if inMenu.coords == Config.Cells[closestPoliceInv].InvLoc.Loc then
						using = false
					end
					inMenu.is = false
					inMenu.coords = nil
					Notification(Config.Sayings[111])
				end
			end
		else
			if inMenu.is and inMenu.coords ~= nil then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local dist = Vdist(inMenu.coords.x, inMenu.coords.y, inMenu.coords.z, coords)

				if dist > Config.MaxMenuDist then
					ESX.UI.Menu.CloseAll()
					if inMenu.coords == Config.Cells[closestPoliceInv].InvLoc.Loc then
						using = false
					end
					inMenu.is = false
					inMenu.coords = nil
					Notification(Config.Sayings[111])
				end
			end
			if inAnim.Dict ~= nil and inAnim.Anim ~= nil then
				local ped = PlayerPedId()
				if not IsEntityPlayingAnim(ped, inAnim.Dict, inAnim.Anim, 3) then
					ClearPedTasksImmediately(ped)
					RequestAnimDict(inAnim.Dict)
								
					if not HasAnimDictLoaded(inAnim.Dict) then
						LoadAnim(inAnim.Dict)
					end

					if inAnim.Freeze then
						FreezeEntityPosition(ped, false)
					end
					TaskPlayAnim(ped, inAnim.Dict, inAnim.Anim, 8.0, 8.0, -1, inAnim.Atr, 1, 0, 0, 0)
					if inAnim.Freeze then
						FreezeEntityPosition(ped, true)
					end
					RemoveAnimDict(inAnim.Dict)
				end
			end
			Wait(500)
		end
	end
end)

CreateThread(function()
	while true do
		if injail and time > 0 and breakout4 then
			Wait(1)
			if breakout > 0 then
				if not Config.SimpleTime then
					drawTxt(Config.Sayings[92]..diffBreak.Hours..'~w~H~o~ '..diffBreak.Mins..'~w~M~o~ '..diffBreak.Seconds..'~w~S',0,1,0.5,0.9,0.35,255,255,255,255)
				else
					drawTxt(Config.Sayings[92]..breakout..Config.Sayings[54],0,1,0.5,0.9,0.35,255,255,255,255)
				end
			elseif soltime > 0 then
				local ped = PlayerPedId()

				if not Config.SimpleTime then
					drawTxt(Config.Sayings[53]..diffSol.Hours..'~w~H~y~ '..diffSol.Mins..'~w~M~y~ '..diffSol.Seconds..'~w~S',0,1,0.5,0.9,0.35,255,255,255,255)
				else
					drawTxt(Config.Sayings[53]..soltime..Config.Sayings[54],0,1,0.5,0.9,0.35,255,255,255,255)
				end

				SetEntityCanBeDamaged(ped, false)
				SetPlayerCanDoDriveBy(ped, false)
				DisablePlayerFiring(ped, true)
				DisableControlAction(0, 140)
			else
				if Config.SimpleTime then
					if job ~= 0 then
						drawTxt(Config.Sayings[3]..time..Config.Sayings[4]..Config.JobOptions[job].Name..Config.Sayings[26]..doneTasks..'~w~/~b~'..taskMax,0,1,0.5,0.9,0.35,255,255,255,255)
					else
						drawTxt(Config.Sayings[3]..time..Config.Sayings[4]..Config.Sayings[6],0,1,0.5,0.9,0.35,255,255,255,255)
					end
				else
					if job ~= 0 then
						drawTxt(Config.Sayings[137]..difftime.Hours..'~w~H~r~ '..difftime.Mins..'~w~M~r~ '..difftime.Seconds..'~w~S'..Config.Sayings[138]..Config.JobOptions[job].Name,0,1,0.5,0.9,0.35,255,255,255,255)
					else
						drawTxt(Config.Sayings[137]..difftime.Hours..'~w~H~r~ '..difftime.Mins..'~w~M~r~ '..difftime.Seconds..'~w~S'..Config.Sayings[138]..Config.Sayings[6],0,1,0.5,0.9,0.35,255,255,255,255)
					end
				end
			end
		else
			Wait(1000)
		end
	end
end)

function OpenJobManMenu()
	local ped = PlayerPedId()
	local element = {}
	
	table.insert(element, {label = Config.Sayings[16], value = 0})
	for i = 1, #Config.JobOptions, 1 do 
		table.insert(element, {label = Config.JobOptions[i].Name, value = i})
	end
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu', {
		title    = Config.Sayings[15],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		OpenManMenu(data.current.value)
	end, function(data, menu)
		menu.close()
		inMenu.is = false
		inMenu.coords = nil
	end)
end

function OpenChest(reOpen)
	CreateThread(function()
		local ped = PlayerPedId()
		if reOpen then
			using = true
			RequestAnimDict('mini@repair')
							
			if not HasAnimDictLoaded('mini@repair') then
				LoadAnim('mini@repair')
			end
			SetEntityCoords(ped, Config.Cells[jailCell].InvLoc.Loc.x, Config.Cells[jailCell].InvLoc.Loc.y, Config.Cells[jailCell].InvLoc.Loc.z - 1, false, false, false, false)
			SetEntityHeading(ped, Config.Cells[jailCell].InvLoc.Heading)
			TaskPlayAnim(ped, 'mini@repair', 'fixing_a_ped', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
			inAnim.Dict = 'mini@repair'
			inAnim.Anim = 'fixing_a_ped'
			inAnim.Atr = 1
			inAnim.Freeze = true
			FreezeEntityPosition(ped, true)
			exports['progressBars']:startUI(Config.OpenCloseTime *1000, Config.Sayings[35])
			Wait(Config.OpenCloseTime *1000)
		end
	
		local element = {
			[1] = {label = Config.Sayings[41], value = 'open2'},
			[2] = {label = Config.Sayings[40], value = 'open'}
		}


		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inv_menu', {
			title    = Config.Sayings[34],
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if data.current.value == 'open' then
				OpenItChest()
			else
				OpenAddChest()
			end
		end, function(data, menu)
			menu.close()
			exports['progressBars']:startUI(Config.OpenCloseTime *1000, Config.Sayings[36])
			Wait(Config.OpenCloseTime *1000)
			FreezeEntityPosition(ped, false)
			inAnim.Dict = nil
			inAnim.Anim = nil
			inAnim.Atr = 0
			inAnim.Freeze = false
			RemoveAnimDict('mini@repair')
			ClearPedTasksImmediately(ped)
			using = false
		end)
	end)
end

function OpenAddChest()
	local ped = PlayerPedId()
	ESX.TriggerServerCallback('esx_jail:GetInventory', function(inv)
		local invie = nil
		local element = {}

		invie = inv.items
		if invie[1] ~= nil then
			for i=1, #invie, 1 do
				local item = invie[i]
	
				if item.count > 0 then
					table.insert(element, {label = item.count..'x '..item.label, value = i})
				end
			end
		else
			table.insert(element, {label = Config.Sayings[33], value = 'none'})
		end
		if element[1] == nil then
			table.insert(element, {label = Config.Sayings[33], value = 'none'})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inv_menu3', {
			title    = Config.Sayings[34],
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if data.current.value ~= 'none' then
				local numies = data.current.value
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inv_amt2', {
					title = (Config.Sayings[42])
				}, function(data, menu)
					local amount = tonumber(data.value)
		
					if amount == nil or amount < 0 then
						Notification(Config.Sayings[38])
					elseif amount > invie[numies].count then
						Notification(Config.Sayings[39])
					else
						menu.close()
						TriggerServerEvent('esx_jail:AddItem', invie[numies].name, amount, invie[numies].label, GetPlayerServerId(PlayerId()))
						OpenChest(false)
					end
				end, function(data, menu)
					menu.close()
					OpenAddChest()
				end)
			end
		end, function(data, menu)
			menu.close()
			OpenChest(false)
		end)
	end)
end

function OpenItChest()
	local ped = PlayerPedId()
	ESX.TriggerServerCallback('esx_jail:GetChest', function(cvalue)
		local valuesc = {}
		local element = {}

		valuesc = cvalue
		if valuesc[1] ~= nil then
			for i = 1, #valuesc, 1 do 
				table.insert(element, {label = valuesc[i].amt..'x '..valuesc[i].itemName, value = i})
			end
		else
			table.insert(element, {label = Config.Sayings[33], value = 'none'})
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'inv_menu2', {
			title    = Config.Sayings[34],
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if data.current.value ~= 'none' then
				local numies = data.current.value
				menu.close()
				ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inv_amt', {
					title = (Config.Sayings[37])
				}, function(data, menu)
					local amount = tonumber(data.value)
		
					if amount == nil or amount < 0 then
						Notification(Config.Sayings[38])
					elseif amount > valuesc[numies].amt then
						Notification(Config.Sayings[39])
					else
						menu.close()
						TriggerServerEvent('esx_jail:RemoveItem', valuesc[numies].ite, amount, valuesc[numies].itemName, GetPlayerServerId(PlayerId()))
						OpenChest(false)
					end
				end, function(data, menu)
					menu.close()
					OpenItChest()
				end)
			end
		end, function(data, menu)
			menu.close()
			OpenChest(false)
		end)
	end)
end

function OpenBreakMenu()
	local ped = PlayerPedId()
	local element = {
		[1] = {label = Config.Sayings[72], value = 'room'},
		[2] = {label = Config.Sayings[73], value = 'wall1'},
		[3] = {label = Config.Sayings[74], value = 'wall2'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Break_Menu2', {
		title    = Config.Sayings[71],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		OpenBreak2Menu(data.current.value)
	end, function(data, menu)
		menu.close()
		OpenInfoMenu()
	end)
end

function OpenBreak2Menu(vali)
	local ped = PlayerPedId()
	local element = {}
	local tit = nil

	if vali == 'room' then
		tit = Config.Sayings[72]
	elseif vali == 'wall1' then
		tit = Config.Sayings[73]
	else
		tit = Config.Sayings[74]
	end

	table.insert(element, {label = Config.Sayings[75], value = 'desc'})
	table.insert(element, {label = Config.Sayings[76], value = 'tools'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Break_Menu3', {
		title    = tit,
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		if data.current.value == 'desc' then
			if vali == 'room' then
				Notification(Config.Sayings[77])
			elseif vali == 'wall1' then
				Notification(Config.Sayings[78])
			else
				Notification(Config.Sayings[79])
			end
		else
			OpenBreak3Menu(vali)
		end
	end, function(data, menu)
		menu.close()
		OpenBreakMenu()
	end)
end

function OpenBreak3Menu(vali)
	local ped = PlayerPedId()
	local element = {}

	if vali == 'wall1' then
		for i = 1, #Config.FenceTool, 1 do 
			table.insert(element, {label = Config.FenceTool[i].Name, value = i})
		end
	else
		for i = 1, #Config.RoomTools, 1 do 
			table.insert(element, {label = Config.RoomTools[i].Name, value = i})
		end
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Break_Men4', {
		title    = Config.Sayings[76],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		OpenBreak4Menu(vali, data.current.value)
	end, function(data, menu)
		menu.close()
		OpenBreak2Menu(vali)
	end)
end

function OpenBreak4Menu(vali, numy)
	local ped = PlayerPedId()
	local element = {}
	local tit = nil

	if vali == 'wall1' then
		tit = Config.FenceTool[numy].Name
		local per = Config.FenceTool[numy].Percent *10
		table.insert(element, {label = Config.Sayings[80]..Config.FenceTool[numy].Time..Config.Sayings[81], value = 'time'})
		table.insert(element, {label = Config.Sayings[82]..per..'%', value = 'percent'})
	else
		tit = Config.RoomTools[numy].Name
		local per = Config.RoomTools[numy].Percent *10
		table.insert(element, {label = Config.Sayings[80]..Config.RoomTools[numy].Time..Config.Sayings[81], value = 'time'})
		table.insert(element, {label = Config.Sayings[82]..per..'%', value = 'percent'})
	end

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'Break_Men5', {
		title    = tit,
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
	end, function(data, menu)
		menu.close()
		OpenBreak3Menu(vali)
	end)
end

function OpenManMenu(numVal)
	local ped = PlayerPedId()
	local element = {}
	
	if numVal ~= 0 then
		local tTasks = 0 
		
		for i = 1, #Config.JobOptions[numVal].Tasks, 1 do 
			tTasks = tTasks + 1
		end
	
		table.insert(element, {label = Config.Sayings[17]..tTasks, value = 'task'})
		table.insert(element, {label = Config.Sayings[18]..Config.JobOptions[numVal].TimeRemove..'(s)', value = 'tR'})
		table.insert(element, {label = Config.Sayings[19] , value = 'confirm'})
	end
	
	ESX.UI.Menu.CloseAll()

	if numVal ~= 0 then
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu2', {
			title    = Config.JobOptions[numVal].Name,
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if data.current.value == 'confirm' then
				menu.close()
				StartJob(numVal, true)
			end
		end, function(data, menu)
			menu.close()
			OpenJobManMenu()
		end)
	else
		StartJob(numVal, true)
	end
end

function OpenFood()
	CreateThread(function()
		local ped = PlayerPedId()
		using = true

		RequestAnimDict('anim@amb@clubhouse@bar@drink@idle_a')

		if not HasAnimDictLoaded('anim@amb@clubhouse@bar@drink@idle_a') then
			LoadAnim('anim@amb@clubhouse@bar@drink@idle_a')
		end

		SetEntityCoords(ped, Config.GetFoodLoc.Loc.x, Config.GetFoodLoc.Loc.y, Config.GetFoodLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.GetFoodLoc.Heading)
		TaskPlayAnim(ped, 'anim@amb@clubhouse@bar@drink@idle_a', 'idle_a_bartender', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
		inAnim.Dict = 'anim@amb@clubhouse@bar@drink@idle_a'
		inAnim.Anim = 'idle_a_bartender'
		inAnim.Atr = 1
		inAnim.Freeze = true
		FreezeEntityPosition(ped, true)
		exports['progressBars']:startUI(Config.GrabFoodTime *1000, Config.Sayings[43])
		Wait(Config.GrabFoodTime *1000)
		FreezeEntityPosition(ped, false)
		inAnim.Dict = nil
		inAnim.Anim = nil
		inAnim.Atr = 0
		inAnim.Freeze = false
		RemoveAnimDict('anim@amb@clubhouse@bar@drink@idle_a')
		ClearPedTasksImmediately(ped)

		needsEat = true

		RequestAnimDict('anim@heists@box_carry@')
								
		if not HasAnimDictLoaded('anim@heists@box_carry@') then
			LoadAnim('anim@heists@box_carry@')
		end
	
		TaskPlayAnim(ped, 'anim@heists@box_carry@', 'idle', 8.0, 8.0, -1, 51, 1, 0, 0, 0)
		inAnim.Dict = 'anim@heists@box_carry@'
		inAnim.Anim = 'idle'
		inAnim.Atr = 51
		inAnim.Freeze = false
		RemoveAnimDict('anim@heists@box_carry@')
		AddPropToPlayer('prop_food_bs_tray_02', 60309, 0.000, -0.08, 0.200, -55.0, 290.0, 0.0, 'food', nil, true)
	end)
end

function StartJob(jobie, trip)
	TriggerServerEvent('esx_jail:SetJob', jobie, trip)
	local removes = {}
	for i = 1, #blips, 1 do
		if blips[i].id == 'task' then
			table.insert(removes, i)
		end
	end
	for i = 1, #removes, 1 do
		if DoesBlipExist(blips[removes[i]].data) then
			RemoveBlip(blips[removes[i]].data)
		end
		table.remove(blips[removes[i]])
	end
	removes = {}

	for i = 1, #PlayerHasProp, 1 do
		if PlayerHasProp[i].id == 'task' then
			table.insert(removes, i)
		end
	end
	for i = 1, #removes, 1 do
		if DoesEntityExist(PlayerHasProp[removes[i]].object) then
			DeleteObject(PlayerHasProp[removes[i]].object)
		end
		table.remove(PlayerHasProp[removes[i]])
	end
	removes = {}

	if jobie ~= 0 then
		job = jobie
		doneTasks = 1
		taskMax = 0
		for i = 1, #Config.JobOptions[jobie].Tasks, 1 do
			taskMax = taskMax + 1
		end
		Notification(Config.Sayings[20])
	
		local blip2 = AddBlipForCoord(Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.x, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.y, Config.JobOptions[job].Tasks[doneTasks].TaskLoc.Loc.z)
		SetBlipSprite(blip2, Config.JobOptions[job].Tasks[doneTasks].TBlip.Sprite)
		SetBlipScale(blip2, Config.JobOptions[job].Tasks[doneTasks].TBlip.Size)
		SetBlipColour(blip2, Config.JobOptions[job].Tasks[doneTasks].TBlip.Color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.JobOptions[job].Tasks[doneTasks].TaskName..' | '..Config.Sayings[26]..doneTasks..'/'..taskMax)
		EndTextCommandSetBlipName(blip2)
		table.insert(blips, {id = 'task', data = blip2})
	else
		job = jobie
		doneTasks = 1
		taskMax = 0
	end
end

RegisterNetEvent('esx_jail:UnnJail')
AddEventHandler('esx_jail:UnnJail', function(itemie, clothesi)
	CreateThread(function()
		if not using then
			local ped = PlayerPedId()
			DoScreenFadeOut(1000)
			Wait(1500)
			local removes = {}
			for i = 1, #blips, 1 do
				table.insert(removes, i)
			end
			for i = 1, #removes, 1 do
				if DoesBlipExist(blips[removes[i]].data) then
					RemoveBlip(blips[removes[i]].data)
				end
				table.remove(blips[removes[i]])
			end
			removes = {}
			for i = 1, #peds, 1 do
				table.insert(removes, i)
			end
			for i = 1, #removes, 1 do
				if DoesEntityExist(peds[removes[i]].data) then
					SetPedAsNoLongerNeeded(peds[removes[i]].data)
					DeletePed(peds[removes[i]].data)
				end
				table.remove(peds[removes[i]])
			end
			removes = {}
			for i = 1, #PlayerHasProp, 1 do
				table.insert(removes, i)
			end
			for i = 1, #removes, 1 do
				if DoesEntityExist(PlayerHasProp[removes[i]].object) then
					DeleteObject(PlayerHasProp[removes[i]].object)
				end
				table.remove(PlayerHasProp[removes[i]])
			end
			removes = {}
		
			TriggerEvent('skinchanger:getSkin', function(skin)
				TriggerEvent('skinchanger:loadClothes', skin, clothesi)
			end)
			time = 0
			soltime = 0
			job = 0
			doneTasks = 0
			taskMax = 0
			injail = false
			jailCell = 0
			solcell = 0
			canGrab = false	
			createdCamera = 0
			beingSent = false
			beingMsg = {msg = nil, size = 0.0}
			closestLoc = 1
			breakout = 0
			breakout2 = false
			breakout3 = false
			breakout4 = true
			closestTower = 1
			closestBreak = 1
			inMenu = {is = false, coords = nil}
			needsEat = false
			itemzie = itemie
			if itemzie[1] ~= nil then
				canGrab = true
				local blip2 = AddBlipForCoord(Config.ItemLoc.Loc.x, Config.ItemLoc.Loc.y, Config.ItemLoc.Loc.z)
				SetBlipSprite(blip2, Config.ItemBlip.Sprite)
				SetBlipScale(blip2, Config.ItemBlip.Size)
				SetBlipColour(blip2, Config.ItemBlip.Color)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(Config.Sayings[11])
				EndTextCommandSetBlipName(blip2)
				table.insert(blips, {id = 'items', data = blip2})
			end
			clothesi = {}
			SetEntityCoords(ped, Config.LeaveLoc.Loc.x, Config.LeaveLoc.Loc.y, Config.LeaveLoc.Loc.z - 1, false, false, false, false)
			SetEntityHeading(ped, Config.LeaveLoc.Heading)
			FreezeEntityPosition(ped, false)
			Wait(500)
			jailLocs = {}
			DoScreenFadeIn(500)
		else
			ResetLeave(itemie, clothesi)
		end
	end)
end)

function ResetLeave(oneone, twotwo)
	CreateThread(function()
		if not using then
			TriggerEvent('esx_jail:UnnJail', oneone, twotwo)
		else
			Wait(3000)
			ResetLeave(oneone, twotwo)
		end
	end)
end

RegisterNetEvent('esx_jail:SendSol')
AddEventHandler('esx_jail:SendSol', function(soltimez, cell)
	CreateThread(function()
		local ped = PlayerPedId()
		DoScreenFadeOut(1000)
		Wait(1500)
		soltime = soltimez
		solcell = cell
		SetEntityCoords(ped, Config.SolCells[cell].Loc.x, Config.SolCells[cell].Loc.y, Config.SolCells[cell].Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.SolCells[cell].Heading)
		FreezeEntityPosition(ped, true)
		Wait(500)
		DoScreenFadeIn(1000)
	end)
end)

RegisterNetEvent('esx_jail:UnnSol')
AddEventHandler('esx_jail:UnnSol', function()
	CreateThread(function()
		local ped = PlayerPedId()
		using = true
		DoScreenFadeOut(1000)
		Wait(1500)
		soltime = 0
		solcell = 0
		SetEntityCoords(ped, Config.Cells[jailCell].SpawnLoc.Loc.x, Config.Cells[jailCell].SpawnLoc.Loc.y, Config.Cells[jailCell].SpawnLoc.Loc.z - 1, false, false, false, false)
		SetEntityHeading(ped, Config.Cells[jailCell].SpawnLoc.Heading)
		FreezeEntityPosition(ped, false)
		Wait(500)
		using = false
		DoScreenFadeIn(1000)
	end)
end)

RegisterNetEvent('esx_jail:JailMenu')
AddEventHandler('esx_jail:JailMenu', function()
	ESX.TriggerServerCallback('esx_jail:CheckLockdown', function(elemento)
		local element = {}
		element = elemento

		local ped = PlayerPedId()
		local police = false
		inJailMenu = true
	
		for i = 1, #Config.PoliceRoles, 1 do
			if ESX.PlayerData.job and ESX.PlayerData.job.name == Config.PoliceRoles[i] then
				police = true
			end
		end
	
	
	
		ESX.UI.Menu.CloseAll()
	
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_main_menu', {
			title    = Config.Sayings[133],
			align    = Config.MenuLoc,
			elements = element
		}, function(data, menu)
			if data.current.value == 'jailplayer' then
				if police then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						inJailMenu = false
						TriggerEvent('esx_jail:GetJailInfo', GetPlayerServerId(GetPlayerPed(closestPlayer)), nil, nil)
					else
						Notification(Config.Sayings[135])
					end
				else
					inJailMenu = false
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt', {
						title = (Config.Sayings[134])
					}, function(data, menu)
						local amount = tonumber(data.value)
			
						if amount == nil or amount < 0 then
							Notification(Config.Sayings[38])
						else
							ESX.TriggerServerCallback('esx_jail:CheckID', function(can)
								if can then
									TriggerEvent('esx_jail:GetJailInfo', amount, nil, nil)
								else
									Notification(Config.Sayings[127])
								end
							end, amount)
						end
					end, function(data, menu)
						TriggerEvent('esx_jail:JailMenu')
					end)
				end
			elseif data.current.value == 'unjail' then
				if police then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						inJailMenu = false
						TriggerServerEvent('esx_jail:UnJailPlayer', GetPlayerServerId(GetPlayerPed(closestPlayer)), true)
					else
						Notification(Config.Sayings[135])
					end
				else
					inJailMenu = false
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt', {
						title = (Config.Sayings[134])
					}, function(data, menu)
						local amount = tonumber(data.value)
			
						if amount == nil or amount < 0 then
							Notification(Config.Sayings[38])
						else
							ESX.TriggerServerCallback('esx_jail:CheckID2', function(can)
								if can then
									ESX.UI.Menu.CloseAll()
									TriggerServerEvent('esx_jail:UnJailPlayer', amount, true)
								else
									Notification(Config.Sayings[127])
								end
							end, amount)
						end
					end, function(data, menu)
						TriggerEvent('esx_jail:JailMenu')
					end)
				end
			elseif data.current.value == 'add' then
				if police then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						inJailMenu = false
						TriggerEvent('esx_jail:AddJailTime', GetPlayerServerId(GetPlayerPed(closestPlayer)), nil, nil)
					else
						Notification(Config.Sayings[135])
					end
				else
					inJailMenu = false
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt', {
						title = (Config.Sayings[134])
					}, function(data, menu)
						local amount = tonumber(data.value)
			
						if amount == nil or amount < 0 then
							Notification(Config.Sayings[38])
						else
							ESX.TriggerServerCallback('esx_jail:CheckID2', function(can)
								if can then
									TriggerEvent('esx_jail:AddJailTime', amount, nil, nil)
								else
									Notification(Config.Sayings[127])
								end
							end, amount)
						end
					end, function(data, menu)
						TriggerEvent('esx_jail:JailMenu')
					end)
				end
			elseif data.current.value == 'remove' then
				if police then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						inJailMenu = false
						TriggerEvent('esx_jail:RemoveJailTime', GetPlayerServerId(GetPlayerPed(closestPlayer)), nil, nil)
					else
						Notification(Config.Sayings[135])
					end
				else
					inJailMenu = false
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt', {
						title = (Config.Sayings[134])
					}, function(data, menu)
						local amount = tonumber(data.value)
			
						if amount == nil or amount < 0 then
							Notification(Config.Sayings[38])
						else
							ESX.TriggerServerCallback('esx_jail:CheckID2', function(can)
								if can then
									TriggerEvent('esx_jail:RemoveJailTime', amount, nil, nil)
								else
									Notification(Config.Sayings[127])
								end
							end, amount)
						end
					end, function(data, menu)
						TriggerEvent('esx_jail:JailMenu')
					end)
				end
			elseif data.current.value == 'solitary' then
				if Config.Solitary then
					if police then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
						if closestPlayer ~= -1 and closestDistance <= 3.0 then
							inJailMenu = false
							TriggerEvent('esx_jail:SolitaryMenu', GetPlayerServerId(GetPlayerPed(closestPlayer)), nil, nil)
						else
							Notification(Config.Sayings[135])
						end
					else
						inJailMenu = false
						ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt', {
							title = (Config.Sayings[134])
						}, function(data, menu)
							local amount = tonumber(data.value)
				
							if amount == nil or amount < 0 then
								Notification(Config.Sayings[38])
							else
								ESX.TriggerServerCallback('esx_jail:CheckID2', function(can)
									if can then
										TriggerEvent('esx_jail:SolitaryMenu', amount, nil, nil)
									else
										Notification(Config.Sayings[127])
									end
								end, amount)
							end
						end, function(data, menu)
							TriggerEvent('esx_jail:JailMenu')
						end)
					end
				else
					Notification(Config.Sayings[136])
				end
			elseif data.current.value == 'unsolitary' then
				if police then
					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					if closestPlayer ~= -1 and closestDistance <= 3.0 then
						inJailMenu = false
						TriggerServerEvent('esx_jail:UnSol', GetPlayerServerId(GetPlayerPed(closestPlayer)))
					else
						Notification(Config.Sayings[135])
					end
				else
					inJailMenu = false
					ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt', {
						title = (Config.Sayings[134])
					}, function(data, menu)
						local amount = tonumber(data.value)
			
						if amount == nil or amount < 0 then
							Notification(Config.Sayings[38])
						else
							ESX.TriggerServerCallback('esx_jail:CheckID2', function(can)
								if can then
									ESX.UI.Menu.CloseAll()
									
									TriggerServerEvent('esx_jail:UnSol', amount)
								else
									Notification(Config.Sayings[127])
								end
							end, amount)
						end
					end, function(data, menu)
						TriggerEvent('esx_jail:JailMenu')
					end)
				end
			elseif data.current.value == 'lockdown' then
				if not switchie then
					switchie = true
					TriggerServerEvent('esx_jail:SwitchLock')
					Wait(3000)
					switchie = false
				end
			elseif data.current.value == 'mssg' then
				inJailMenu = false
				OpenReason(nil, nil, nil, 5)
			end
		end, function(data, menu)
			menu.close()
			inJailMenu = false
			for i=1, #Config.PoliceRoles, 1 do
				if ESX.PlayerData.job.name == Config.PoliceRoles[i] then
					TriggerEvent('esx_jail:ResetPMenu')
				end
			end
		end)
	end)
end)

RegisterNetEvent('esx_jail:GetJailInfo')
AddEventHandler('esx_jail:GetJailInfo', function(id, time, reason)
	local ped = PlayerPedId()
	local element = {
		[1] = {label = Config.Sayings[56]..id, value = 'id'}
	}

	if time ~= nil then
		table.insert(element, {label = Config.Sayings[57]..time..'(m)', value = 'time'})
	else
		table.insert(element, {label = Config.Sayings[58], value = 'time'})
	end
	table.insert(element, {label = Config.Sayings[59], value = 'reason'})
	table.insert(element, {label = Config.Sayings[60], value = 'confirm'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_menu', {
		title    = Config.Sayings[55],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		if data.current.value == 'id' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt', {
				title = (Config.Sayings[61])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
			    else
					ESX.TriggerServerCallback('esx_jail:CheckID', function(can)
						if can then
							TriggerEvent('esx_jail:GetJailInfo', amount, time, reason)
						else
							Notification(Config.Sayings[127])
						end
					end, amount)
				end
			end, function(data, menu)
				TriggerEvent('esx_jail:GetJailInfo', id, time, reason)
			end)
		elseif data.current.value == 'time' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'time_amt', {
				title = (Config.Sayings[63])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
				elseif amount > Config.MaxJail then
					Notification(Config.Sayings[62])
			    else
					TriggerEvent('esx_jail:GetJailInfo', id, amount, reason)
				end
			end, function(data, menu)
				TriggerEvent('esx_jail:GetJailInfo', id, time, reason)
			end)
		elseif data.current.value == 'reason' then
			OpenReason(id, time, reason, 1)
		else
			if reason ~= nil and id ~= nil and time ~= nil then
				menu.close()
				TriggerServerEvent('esx_jail:sendToJail', id, time *60, reason)
			else
				if reason == nil then
					Notification(Config.Sayings[105])
				elseif id == nil then
					Notification(Config.Sayings[106])
				else
					Notification(Config.Sayings[107])
				end
			end
		end
	end, function(data, menu)
		menu.close()
		TriggerEvent('esx_jail:JailMenu')
	end)
end)

RegisterNetEvent('esx_jail:AddJailTime')
AddEventHandler('esx_jail:AddJailTime', function(id, time, reason)
	local ped = PlayerPedId()
	local element = {
		[1] = {label = Config.Sayings[56]..id, value = 'id'},
	}

	if time ~= nil then
		table.insert(element, {label = Config.Sayings[57]..time..'(m)', value = 'time'})
	else
		table.insert(element, {label = Config.Sayings[58], value = 'time'})
	end
	table.insert(element, {label = Config.Sayings[59], value = 'reason'})
	table.insert(element, {label = Config.Sayings[60], value = 'confirm'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_menu5', {
		title    = Config.Sayings[55],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		if data.current.value == 'id' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt2', {
				title = (Config.Sayings[61])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
			    else
					ESX.TriggerServerCallback('esx_jail:CheckID2', function(yurrrr)
						if yurrrr then
							menu.close()
							TriggerEvent('esx_jail:AddJailTime', amount, time, reason)
						else
							Notification(Config.Sayings[103])
						end
					end, amount)
				end
			end, function(data, menu)
				menu.close()
				TriggerEvent('esx_jail:AddJailTime', id, time, reason)
			end)
		elseif data.current.value == 'time' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'time_amt2', {
				title = (Config.Sayings[63])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
				elseif amount > Config.MaxJail then
					Notification(Config.Sayings[62])
			    else
					menu.close()
					TriggerEvent('esx_jail:AddJailTime', id, amount, reason)
				end
			end, function(data, menu)
				menu.close()
				TriggerEvent('esx_jail:AddJailTime', id, time, reason)
			end)
		elseif data.current.value == 'reason' then
			OpenReason(id, time, reason, 2)
		else
			if reason ~= nil and id ~= nil and time ~= nil then
				menu.close()
				TriggerServerEvent('esx_jail:AddSomeTime', id, time *60, reason)
			end
		end
	end, function(data, menu)
		menu.close()
		TriggerEvent('esx_jail:JailMenu')
	end)
end)

RegisterNetEvent('esx_jail:RemoveJailTime')
AddEventHandler('esx_jail:RemoveJailTime', function(id, time, reason)
	local ped = PlayerPedId()
	local element = {
		[1] = {label = Config.Sayings[56]..id, value = 'id'},
	}

	if time ~= nil then
		table.insert(element, {label = Config.Sayings[57]..time..'(m)', value = 'time'})
	else
		table.insert(element, {label = Config.Sayings[58], value = 'time'})
	end
	table.insert(element, {label = Config.Sayings[59], value = 'reason'})
	table.insert(element, {label = Config.Sayings[60], value = 'confirm'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_menu6', {
		title    = Config.Sayings[55],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		if data.current.value == 'id' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt2', {
				title = (Config.Sayings[61])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
			    else
					ESX.TriggerServerCallback('esx_jail:CheckID2', function(yurrrr)
						if yurrrr then
							menu.close()
							TriggerEvent('esx_jail:RemoveJailTime', amount, time, reason)
						else
							Notification(Config.Sayings[103])
						end
					end, amount)
				end
			end, function(data, menu)
				menu.close()
				TriggerEvent('esx_jail:RemoveJailTime', id, time, reason)
			end)
		elseif data.current.value == 'time' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'time_amt2', {
				title = (Config.Sayings[63])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
				elseif amount > Config.MaxJail then
					Notification(Config.Sayings[62])
			    else
					menu.close()
					TriggerEvent('esx_jail:RemoveJailTime', id, amount, reason)
				end
			end, function(data, menu)
				menu.close()
				TriggerEvent('esx_jail:RemoveJailTime', id, time, reason)
			end)
		elseif data.current.value == 'reason' then
			OpenReason(id, time, reason, 3)
		else
			if reason ~= nil and id ~= nil and time ~= nil then
				menu.close()
				TriggerServerEvent('esx_jail:RemoveSomeTime', id, time *60, reason)
			end
		end
	end, function(data, menu)
		menu.close()
		TriggerEvent('esx_jail:JailMenu')
	end)
end)

RegisterNetEvent('esx_jail:SolitaryMenu')
AddEventHandler('esx_jail:SolitaryMenu', function(id, time, reason)
	local ped = PlayerPedId()
	local element = {
		[1] = {label = Config.Sayings[56]..id, value = 'id'},
	}

	if time ~= nil then
		table.insert(element, {label = Config.Sayings[57]..time..'(m)', value = 'time'})
	else
		table.insert(element, {label = Config.Sayings[58], value = 'time'})
	end
	table.insert(element, {label = Config.Sayings[59], value = 'reason'})
	table.insert(element, {label = Config.Sayings[60], value = 'confirm'})

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'jail_menu6', {
		title    = Config.Sayings[55],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		if data.current.value == 'id' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'id_amt2', {
				title = (Config.Sayings[61])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
			    else
					ESX.TriggerServerCallback('esx_jail:CheckID2', function(yurrrr)
						if yurrrr then
							menu.close()
							TriggerEvent('esx_jail:SolitaryMenu', amount, time, reason)
						else
							Notification(Config.Sayings[103])
						end
					end, amount)
				end
			end, function(data, menu)
				menu.close()
				TriggerEvent('esx_jail:SolitaryMenu', id, time, reason)
			end)
		elseif data.current.value == 'time' then
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'time_amt2', {
				title = (Config.Sayings[63])
			}, function(data, menu)
				local amount = tonumber(data.value)
	
				if amount == nil or amount < 0 then
					Notification(Config.Sayings[38])
				elseif amount > Config.MaxJail then
					Notification(Config.Sayings[62])
			    else
					menu.close()
					TriggerEvent('esx_jail:SolitaryMenu', id, amount, reason)
				end
			end, function(data, menu)
				menu.close()
				TriggerEvent('esx_jail:SolitaryMenu', id, time, reason)
			end)
		elseif data.current.value == 'reason' then
			OpenReason(id, time, reason, 4)
		else
			if reason ~= nil and id ~= nil and time ~= nil then
				menu.close()
				TriggerServerEvent('esx_jail:SendToSol', id, time, reason)
			end
		end
	end, function(data, menu)
		menu.close()
		TriggerEvent('esx_jail:JailMenu')
	end)
end)

RegisterNetEvent('esx_jail:AddItUp')
AddEventHandler('esx_jail:AddItUp', function(timy)
	if time > 0 then
		time = time + timy

		if not Config.SimpleTime then
			local dope = {Hours = 0, Mins = 0, Seconds = 0}

			local duration = timy
			local extraSeconds = duration%60
			local minutes = (duration-extraSeconds)/60
			if duration >= 60 then
				if minutes >= 60 then
					local extraMinutes = minutes%60
					local hours = (minutes-extraMinutes)/60
					dope.Hours = math.floor(hours)
					dope.Mins = math.ceil(extraMinutes)
					dope.Seconds = extraSeconds
				else
					dope.Hours = 0
					dope.Mins = math.floor(minutes)
					dope.Seconds = extraSeconds
				end
			else
				dope.Hours = 0
				dope.Mins = 0
				dope.Seconds = timy
			end
			Notification(dope.Hours..'H '..dope.Mins..'M '..dope.Seconds..'S '..Config.Sayings[140])
		else
			Notification(timy..Config.Sayings[104])
		end
	end
end)

RegisterNetEvent('esx_jail:Removeit')
AddEventHandler('esx_jail:Removeit', function(timy)
	if time > 0 then
		time = time - timy

		if not Config.SimpleTime then
			local dope = {Hours = 0, Mins = 0, Seconds = 0}

			local duration = timy
			local extraSeconds = duration%60
			local minutes = (duration-extraSeconds)/60
			if duration >= 60 then
				if minutes >= 60 then
					local extraMinutes = minutes%60
					local hours = (minutes-extraMinutes)/60
					dope.Hours = math.floor(hours)
					dope.Mins = math.ceil(extraMinutes)
					dope.Seconds = extraSeconds
				else
					dope.Hours = 0
					dope.Mins = math.floor(minutes)
					dope.Seconds = extraSeconds
				end
			else
				dope.Hours = 0
				dope.Mins = 0
				dope.Seconds = timy
			end
			Notification(dope.Hours..'H '..dope.Mins..'M '..dope.Seconds..'S '..Config.Sayings[142])
		else
			Notification(timy..Config.Sayings[143])
		end
	end
end)

function OpenReason(id, time, reason, menuz)
	local element = {
		[1] = {label = Config.Sayings[65], value = 'edit'},
		[2] = {label = Config.Sayings[67], value = 'see'},
		[3] = {label = Config.Sayings[66], value = 'confirm'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'reason_menu', {
		title    = Config.Sayings[68],
		align    = Config.MenuLoc,
		elements = element
	}, function(data, menu)
		if data.current.value == 'confirm' then
			if reason ~= nil then
				if menuz == 1 then
					TriggerEvent('esx_jail:GetJailInfo', id, time, reason)
				elseif menuz == 2 then
					TriggerEvent('esx_jail:AddJailTime', id, time, reason)
				elseif menuz == 3 then
					TriggerEvent('esx_jail:RemoveJailTime', id, time, reason)
				elseif menuz == 4 then
					TriggerEvent('esx_jail:SolitaryMenu', id, time, reason)
				elseif menuz == 5 then
					menu.close()
					TriggerServerEvent('esx_jail:Send2Prisoners', reason)
				end
			else
				Notification(Config.Sayings[167])
			end
		elseif data.current.value == 'see' then
			if reason ~= nil then
				Notification(reason)
			else
				Notification(Config.Sayings[69])
			end
		else
			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'text_re', {
				title = (Config.Sayings[68])
			}, function(data, menu)
				local val = data.value
				if val == nil then
					Notification(Config.Sayings[38])
			    else
					menu.close()
					OpenReason(id, time, val, menuz)
				end
			end, function(data, menu)
				menu.close()
				OpenReason(id, time, reason, menuz)
			end)
		end
	end, function(data, menu)
		menu.close()
		if menuz == 1 then
			TriggerEvent('esx_jail:GetJailInfo', id, time, reason)
		elseif menuz == 2 then
			TriggerEvent('esx_jail:AddJailTime', id, time, reason)
		elseif menuz == 3 then
			TriggerEvent('esx_jail:RemoveSomeTime', id, time, reason)
		elseif menuz == 4 then
			TriggerEvent('esx_jail:SolitaryMenu', id, time, reason)
		elseif menuz == 5 then
			TriggerEvent('esx_jail:JailMenu')
		end
	end)
end

local checkDeath = false
CreateThread(function()
	while true do
		local ped = PlayerPedId()

		if time > 0 then
			if IsPedDeadOrDying(ped, 1) and not checkDeath then
				Wait(5)
				checkDeath = true
				TriggerEvent('esx_jail:onPlayerDeath')
			elseif checkDeath and not IsPedDeadOrDying(ped, 1) then
				Wait(5)
				checkDeath = false
				TriggerEvent('esx_jail:onPlayerSpawn')
			else
				Wait(500)
			end
		else
			Wait(1000)
		end
	end
end)

RegisterNetEvent('esx_jail:onPlayerDeath')
AddEventHandler('esx_jail:onPlayerDeath', function()
	local PedKiller = GetPedSourceOfDeath(GetPlayerPed(PlayerId()))
	local Killer = nil
	isDead = true
	TriggerServerEvent('esx_jail:PlayerDie', true)
	if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
		if GetPlayerServerId(PedKiller) ~= GetPlayerServerId(PlayerId()) then
			Killer = GetPlayerServerId(PedKiller)
		end
	elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
		if GetPlayerServerId(GetPedInVehicleSeat(PedKiller, -1)) ~= GetPlayerServerId(PlayerId()) then
			Killer = GetPlayerServerId(GetPedInVehicleSeat(PedKiller, -1))
		end
	end
	if Killer ~= nil and Config.Sol4Kill and Config.Solitary then
		TriggerServerEvent('esx_jail:KilledBy', Killer)
	end
end)

RegisterNetEvent('esx_jail:onPlayerSpawn')
AddEventHandler('esx_jail:onPlayerSpawn', function()
	CreateThread(function()
		local ped = PlayerPedId()
		if isDead and time > 0 then
			using = true
			DoScreenFadeOut(1000)
			Wait(3000)
			if Config.Hospital then
				RequestAnimDict('anim@gangops@morgue@table@')
				RequestAnimDict('missfam4')
				RequestModel(Config.DoctorPed)
		
				if not HasAnimDictLoaded('anim@gangops@morgue@table@') then
					LoadAnim('anim@gangops@morgue@table@')
				end
				if not HasModelLoaded(Config.DoctorPed) then
					LoadPropDict(Config.DoctorPed)
				end
				if not HasAnimDictLoaded('missfam4') then
					LoadAnim('missfam4')
				end
		
		
				local bLocs = 0
				local numo = 0
				local removes = {}
		
				TriggerServerEvent('esx_jail:UnSee', GetPlayerServerId(PlayerId()))
		
				for i = 1, #Config.BedLocs, 1 do
					bLocs = bLocs + 1
				end
				numo = math.random(1, bLocs)
		
				SetEntityCoords(ped, Config.BedLocs[numo].SpawnLoc.Loc.x, Config.BedLocs[numo].SpawnLoc.Loc.y, Config.BedLocs[numo].SpawnLoc.Loc.z - 1, false, false, false, false)
				SetEntityHeading(ped, Config.BedLocs[numo].SpawnLoc.Heading)
				Wait(500)
				SetEntityCoords(ped, Config.BedLocs[numo].SpawnLoc.Loc.x, Config.BedLocs[numo].SpawnLoc.Loc.y, Config.BedLocs[numo].SpawnLoc.Loc.z - 1, false, false, false, false)
				SetEntityHeading(ped, Config.BedLocs[numo].SpawnLoc.Heading)
				TaskPlayAnim(ped, 'anim@gangops@morgue@table@', 'body_search', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
				RemoveAnimDict('anim@gangops@morgue@table@')
				inAnim.Dict = 'anim@gangops@morgue@table@'
				inAnim.Anim = 'body_search'
				inAnim.Atr = 1
				inAnim.Freeze = true
				FreezeEntityPosition(ped, true)
		
				local byped = CreatePed(5, Config.DoctorPed, Config.BedLocs[numo].DoctorSpawn.Loc.x, Config.BedLocs[numo].DoctorSpawn.Loc.y, Config.BedLocs[numo].DoctorSpawn.Loc.z - 1, Config.BedLocs[numo].DoctorSpawn.Heading, false, true)
				PlaceObjectOnGroundProperly(byped)
				SetEntityAsMissionEntity(byped)
				SetPedDropsWeaponsWhenDead(byped, false)
				SetPedAsEnemy(byped, false)
				SetEntityInvincible(byped, true)
				SetModelAsNoLongerNeeded(Config.DoctorPed)
				table.insert(peds, {id = 'doc', data = byped})
				TaskPlayAnim(byped, 'missfam4', 'base', 8.0, 8.0, -1, 51, 1, 0, 0, 0)
				RemoveAnimDict('missfam4')
				AddPropToPlayer('p_amb_clipboard_01', 36029, 0.16, 0.08, 0.1, -130.0, -50.0, 0.0, 'doc', byped, false)
				docped = byped
		
				DoScreenFadeIn(1000)
				Wait(1500)
				TaskGoStraightToCoord(byped, Config.BedLocs[numo].DocCheck.Loc.x, Config.BedLocs[numo].DocCheck.Loc.y, Config.BedLocs[numo].DocCheck.Loc.z, 1.0, Config.BedLocs[numo].DocWalkTime *1000, Config.BedLocs[numo].DocCheck.Heading, 0)
				Wait(Config.BedLocs[numo].DocWalkTime *1000)
				TaskAchieveHeading(byped, Config.BedLocs[numo].DocCheck.Heading, 1000)
				Wait(1000)
				exports['progressBars']:startUI(Config.CheckUpTime *1000, Config.Sayings[70])
				Wait(Config.CheckUpTime *1000)
				TaskGoStraightToCoord(byped, Config.BedLocs[numo].DoctorSpawn.Loc.x, Config.BedLocs[numo].DoctorSpawn.Loc.y, Config.BedLocs[numo].DoctorSpawn.Loc.z, 1.0, Config.BedLocs[numo].DocWalkTime *1000, Config.BedLocs[numo].DoctorSpawn.Heading, 0)
				Wait(Config.BedLocs[numo].DocWalkTime *1000)
				DoScreenFadeOut(1000)
				Wait(1500)
				SetEntityCoords(ped, Config.Cells[jailCell].SpawnLoc.Loc.x, Config.Cells[jailCell].SpawnLoc.Loc.y, Config.Cells[jailCell].SpawnLoc.Loc.z - 1, false, false, false, false)
				SetEntityHeading(ped, Config.Cells[jailCell].SpawnLoc.Heading)
				FreezeEntityPosition(ped, false)
				inAnim.Dict = nil
				inAnim.Anim = nil
				inAnim.Atr = 0
				inAnim.Freeze = false
				ClearPedTasksImmediately(ped)
				ClearPedTasksImmediately(byped)
				TriggerServerEvent('esx_jail:See', GetPlayerServerId(PlayerId()))
		
				removes = {}
				for i = 1, #PlayerHasProp, 1 do
					if PlayerHasProp[i].id == 'doc' then
						table.insert(removes, i)
					end
				end
				for i = 1, #removes, 1 do
					if DoesEntityExist(PlayerHasProp[removes[i]].object) then
						DeleteObject(PlayerHasProp[removes[i]].object)
					end
					table.remove(PlayerHasProp, removes[i])
				end
				removes = {}
				for i = 1, #peds, 1 do
					if peds[i].id == 'doc' then
						table.insert(removes, i)
					end
				end
				for i = 1, #removes, 1 do
					if DoesEntityExist(peds[removes[i]].data) then
						SetPedAsNoLongerNeeded(peds[removes[i]].data)
						DeletePed(peds[removes[i]].data)
					end
					table.remove(peds, removes[i])
				end
			else
				SetEntityCoords(ped, Config.Cells[jailCell].SpawnLoc.Loc.x, Config.Cells[jailCell].SpawnLoc.Loc.y, Config.Cells[jailCell].SpawnLoc.Loc.z - 1, false, false, false, false)
				SetEntityHeading(ped, Config.Cells[jailCell].SpawnLoc.Heading)
				Wait(500)
			end
			TriggerServerEvent('esx_jail:PlayerDie', false)
			isDead = false
			using = false
			DoScreenFadeIn(1000)
			Wait(1500)
		end
	end)
end)

RegisterNetEvent('esx_jail:ShankPull')
AddEventHandler('esx_jail:ShankPull', function()
	local ped = PlayerPedId()
	local current, curent = GetCurrentPedWeapon(ped, 1)
	local shankie = GetHashKey(Config.ShankWeapon)
	if shankie == curent then
		RemoveWeaponFromPed(ped, shankie)
	else
		GiveWeaponToPed(ped, shankie, 100, false, true)
	end
end)

RegisterNetEvent('esx_jail:GiveShankie')
AddEventHandler('esx_jail:GiveShankie', function()
	local ped = PlayerPedId()
	local shankie = GetHashKey(Config.ShankWeapon)
	GiveWeaponToPed(ped, shankie, 100, false, true)
end)

RegisterNetEvent('esx_jail:PoliceWarning')
AddEventHandler('esx_jail:PoliceWarning', function(name)
	local goodo = false
	for i = 1, #Config.PoliceRoles, 1 do
		if ESX.Player.job.name == Config.PoliceRoles[i] then
			goodo = true
		end
	end

	if goodo then
		Wait(Config.PoliceNotifyTime *60000)
		Notification(name..Config.Sayings[169])
	end
end)

RegisterNetEvent('esx_jail:SendNotif2')
AddEventHandler('esx_jail:SendNotif2', function(msg)
	if time > 0 then
		Notification(msg)
	end
end)

RegisterNetEvent('esx_jail:SendNotif')
AddEventHandler('esx_jail:SendNotif', function(msg)
	Notification(msg)
end)

RegisterNetEvent('esx_jail:CountWarn')
AddEventHandler('esx_jail:CountWarn', function(time)
	if time > 0 then
		Notification(time..Config.Sayings[149])
	end
end)

RegisterNetEvent('esx_jail:TurnOffLock')
AddEventHandler('esx_jail:TurnOffLock', function()
	lockieDown = false
	if inJailMenu then
		TriggerEvent('esx_jail:JailMenu')
	end
	if time > 0 then
		Notification(Config.Sayings[151])
	end
end)

RegisterNetEvent('esx_jail:CountFinish')
AddEventHandler('esx_jail:CountFinish', function()
	if inJailMenu then
		TriggerEvent('esx_jail:JailMenu')
	end
	lockieDown = true
	DoLockCheck()
	if time > 0 then
		Notification(Config.Sayings[152])
	end
end)

function DoLockCheck()
	CreateThread(function()
		while true do
			if lockieDown then
				if time > 0 then
					if not using then
						Wait(250)
						if soltime == 0 and breakout == 0 then
							local ped = PlayerPedId()
							local coords = GetEntityCoords(ped)
							local dist = Vdist(Config.Cells[jailCell].SpawnLoc.Loc.x, Config.Cells[jailCell].SpawnLoc.Loc.y, Config.Cells[jailCell].SpawnLoc.Loc.z, coords)
							if dist > Config.LockDownDist then
								if Config.Solitary and Config.Sol4Lock then
									using = true
									TriggerServerEvent('esx_jail:SendToSol', GetPlayerServerId(PlayerId()), Config.SolLockTime, Config.Sayings[150])
								else
									using = true
									SetEntityCoords(ped, Config.Cells[jailCell].SpawnLoc.Loc.x, Config.Cells[jailCell].SpawnLoc.Loc.y, Config.Cells[jailCell].SpawnLoc.Loc.z - 1, false, false, false, false)
									SetEntityHeading(ped, Config.Cells[jailCell].SpawnLoc.Heading)
									Wait(500)
									using = false
								end
							end
						end
					else
						Wait(500)
					end
				else
					Wait(1000)
				end
			else
				Wait(5)
				break
			end
		end
	end)
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
	if Config.Box then
		DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	end
    ClearDrawOrigin()
end

function AddPropToPlayer(prop1, bone, off1, off2, off3, rot1, rot2, rot3, namies, player, network)
	local Player = nil
	if player ~= nil then
		Player = player
	else
		Player = PlayerPedId()
	end
	local x,y,z = table.unpack(GetEntityCoords(Player))
  
	if not HasModelLoaded(prop1) then
	  LoadPropDict(prop1)
	end
  
	if network then
		prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  true,  true, true)
		AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
		table.insert(PlayerHasProp, {id = namies, object = prop})
		SetModelAsNoLongerNeeded(prop1)
	else
		prop = CreateObject(GetHashKey(prop1), x, y, z+0.2,  false,  true, true)
		AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
		table.insert(PlayerHasProp, {id = namies, object = prop})
		SetModelAsNoLongerNeeded(prop1)
	end
end

function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end

function ChangeSecurityCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Wait(250)
    createdCamera = cam
end

function CloseSecurityCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    SetFocusEntity(GetPlayerPed(PlayerId()))
    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end

function Notification(text)
	if Config.Notifications == 'esx' then
		ESX.ShowNotification(text)
	elseif Config.Notifications == 'tnotify' then
		exports['t-notify']:Alert({
			style = 'message', 
			message = text
		})
	elseif Config.Notifications == 'mythic' then
		exports['mythic_notify']:DoHudText('inform', text)


	elseif Config.Notifications == 'dopeNotify' then
		TriggerEvent('dopeNotify:Alert', "Gefängnis", text, 5000, 'info')
	end
end

function LoadAnim(dict)
	while not HasAnimDictLoaded(dict) do
	  RequestAnimDict(dict)
	  Wait(10)
	end
end

