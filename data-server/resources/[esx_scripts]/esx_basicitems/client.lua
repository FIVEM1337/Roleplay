local propsEntities = {}
local animationactive

RegisterNetEvent('basicitems:kevlar')
AddEventHandler('basicitems:kevlar', function()
    local playerPed = PlayerPedId()

    AddArmourToPed(playerPed, 100)
    SetPedArmour(playerPed, 100)
end)

RegisterNetEvent('esx_basicitems:onEat')
AddEventHandler('esx_basicitems:onEat', function(itemname)
	local dict
	if Config.FoodAnimations[itemname] then
		dict = Config.FoodAnimations[itemname]
	else
		dict = Config.FoodAnimations["default"]
	end
    playanim(dict)
end)

RegisterNetEvent('esx_basicitems:onDrink')
AddEventHandler('esx_basicitems:onDrink', function(itemname)
	local dict
	if Config.DrinkAnimations[itemname] then
		dict = Config.DrinkAnimations[itemname]
	else
		dict = Config.DrinkAnimations["default"]
	end
    playanim(dict)
end)

function playanim(dict)
	if animationactive then return end

	animationactive = true
	loaddict(dict.dict)
	playprop(dict.props)

	SetTimeout(dict.duration * 1000, function() clearanimation() end)

	TaskPlayAnim(PlayerPedId(), dict.dict, dict.anim, 1.5, 1.5, -1, 51, 0, false, false, false)
	RemoveAnimDict(dict.dict)
end

function playprop(props)
    if props then
        if props.prop then
            loadmodel(props.prop)
            loadPropCreation(PlayerPedId(), props.prop, props.propBone, props.propPlacement)
        end
        if props.propTwo then
            loadmodel(props.propTwo)
            loadPropCreation(PlayerPedId(), props.propTwo, props.propTwoBone, props.propTwoPlacement)
        end
    end
end

function loaddict(dict)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict) or timeout
end

function loadmodel(model)
    local timeout = false
    SetTimeout(5000, function() timeout = true end)

    local hashModel = GetHashKey(model)
    repeat
        RequestModel(hashModel)
        Wait(50)
    until HasModelLoaded(hashModel) or timeout
end

function loadPropCreation(ped, prop, bone, placement)
    local coords = GetEntityCoords(ped)
    local newProp = CreateObject(GetHashKey(prop), coords.x, coords.y, coords.z + 0.2, true, true, true)
    if newProp then
        AttachEntityToEntity(newProp, ped, GetPedBoneIndex(ped, bone), placement[1] + 0.0, placement[2] + 0.0, placement[3] + 0.0, placement[4] + 0.0, placement[5] + 0.0, placement[6] + 0.0, true, true, false, true, 1, true)
		table.insert(propsEntities, newProp)
	end
    SetModelAsNoLongerNeeded(prop)
end

function clearanimation()
	ClearPedTasks(PlayerPedId())

	for k, v in pairs(propsEntities) do
		DeleteObject(v)
	end
	propsEntities = {}

	animationactive = false
end