local NumberCharset = {}
local Charset = {}
npc_list = {}
blip_list = {}


CreateThread(function()
	while true do
		Wait(100)
		if npc_list then
            for k,v in pairs(npc_list) do
                TaskSetBlockingOfNonTemporaryEvents(v, true)
            end
		end
	end
end)


for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

		ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function (isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

-- mixing async with sync tasks
function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('esx_vehicleshop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Wait(0)
	end

	return callback
end

function GetRandomNumber(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end


function Draw3DText(coords,text,scale)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local pX,pY,pZ = table.unpack(GetGameplayCamCoords())
	SetTextScale(scale, scale)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextEntry("STRING")
	SetTextCentre(true)
	SetTextColour(255, 255, 255, 255)
	AddTextComponentString(text)
	DrawText(x,y)
	local factor = (string.len( text )) / 700
	DrawRect(x, y + 0.0150, 0.06 +factor, 0.03, 0, 0, 0, 200)
end

function SpawnNpcs()
	for k, v in pairs(Config.VehicleShops) do
		if v.npc then
            RequestModel(v.npc.model)
            LoadPropDict(v.npc.model)
            local ped = CreatePed(5, v.npc.model , v.coords.x, v.coords.y, v.coords.z - 1.0, v.npc.heading, false, true)
            PlaceObjectOnGroundProperly(ped)
            SetEntityAsMissionEntity(ped)
            SetPedDropsWeaponsWhenDead(ped, false)
            FreezeEntityPosition(ped, true)
            SetPedAsEnemy(ped, false)
            SetEntityInvincible(ped, true)
            SetModelAsNoLongerNeeded(v.npc.model)
            SetPedCanBeTargetted(ped, false)
            table.insert(npc_list, ped)
        end
	end
end

function CreateBlips()
	for k, v in pairs(Config.VehicleShops) do
		if v.blip then
			local blip = AddBlipForCoord(v.coords)
			SetBlipSprite(blip, v.blip.sprite)
			SetBlipDisplay(blip, 4)
			SetBlipScale(blip, v.blip.scale)
			SetBlipColour(blip, v.blip.color)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName('STRING')	
			AddTextComponentSubstringPlayerName(v.blip.name)
			EndTextCommandSetBlipName(blip)
			table.insert(blip_list, blip)
        end
	end
end


function LoadPropDict(model)
	while not HasModelLoaded(GetHashKey(model)) do
	  RequestModel(GetHashKey(model))
	  Wait(10)
	end
end

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
