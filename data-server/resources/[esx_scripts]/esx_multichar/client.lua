
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(200)
        TriggerEvent('esx:getSharedObject', function (obj) ESX = obj end)
    end
end)


_menuPool = NativeUI.CreatePool()
local cam = nil
local cam2 = nil
local IsChoosing = true
local charData = {}
local gotCharData = false

local playerPed = nil
local sex = "mp_m_freemode_01"

local group 

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if IsChoosing then
            DisplayHud(false)
            DisplayRadar(false)
        end

        if _menuPool:IsAnyMenuOpen() then
            _menuPool:ProcessMenus()
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        --print('check')
        if ESX ~= nil then
            --print('ESX~=nil')
            if NetworkIsSessionStarted() then
                --print('final do')
                Citizen.Wait(100)
                gotCharData = false
                TriggerServerEvent('myMultichar:GetPlayerCharacters')
                setPlayerInVoid()
                return -- break the loop
            end
        end
    end
end)


RegisterNetEvent('myMultichar:SpawnCharacter')
AddEventHandler('myMultichar:SpawnCharacter', function(spawn, isnew)

	IsChoosing = false

	if playerPed ~= nil then
		DeleteEntity(playerPed)
		SetModelAsNoLongerNeeded(GetHashKey(sex))
	end

    local pos = spawn
    if pos == nil then
        pos = Config.FirstSpawnLocation
    end

    DoScreenFadeIn(500)
    Citizen.Wait(500)
    cam2 = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.86, -996.74, -99.0 + 250, 300.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam2, pos.x,pos.y,pos.z+200)
    SetCamActiveWithInterp(cam2, cam, 900, true, true)
    Citizen.Wait(1500)
	
	if Config.useSpawnmanager then
		exports.spawnmanager:setAutoSpawn(false)
	end
	
	 if (Config.ShowSpawnSelectionForEverybody and not isnew) then
        selectSpawnPoint(spawn, isnew)
     elseif (not Config.ShowSpawnSelectionForEverybody and not isnew) then
        finishSpawn(pos, isnew)
     elseif isnew and Config.ShowSpawnSelectionOnFirstJoin then
        selectSpawnPoint(spawn, isnew)
     elseif isnew and not Config.ShowSpawnSelectionOnFirstJoin then
        finishSpawn(pos, isnew)
     end

     
end)

local selectedIndex

function generateMenu(chars, max)

    _menuPool:Remove()
    collectgarbage()

	gotCharData = true
	charData = chars

    local mainMenu = NativeUI.CreateMenu(Translation[Config.Locale]['select_character'], Translation[Config.Locale]['select_character_desc'])
    _menuPool:Add(mainMenu)
	mainMenu.Controls.Back.Enabled = false

    for k, char in pairs(chars) do

        -- local character_item = NativeUI.CreateItem(char.firstname .. ' ' .. char.lastname, '~b~')
        -- if char.pedModel ~= nil then
        --     character_item:SetRightBadge(BadgeStyle.Mask) -- Star
        -- end


        -- mainMenu:AddItem(character_item)
		if char.firstname == nil or char.lastname == nil then
			char.firstname = 'Unknown'
			char.lastname = 'Unknown'
		end
		
        local character_sub = _menuPool:AddSubMenu(mainMenu, char.firstname .. ' ' .. char.lastname, '~b~')
        if char.pedModel ~= nil then
            -- character_item:SetRightBadge(BadgeStyle.Mask) -- Star
            mainMenu.Items[k]:SetRightBadge(BadgeStyle.Mask)
        end
        
        local enter = NativeUI.CreateItem(Translation[Config.Locale]['enter_char'], '~b~')
        character_sub.SubMenu:AddItem(enter)

        enter.Activated = function(sender, index)
            character_sub.SubMenu:Visible(false)
            TriggerServerEvent('myMultichar:CharSelected', selectedIndex, false)
        end

        if Config.CanPlayersDeleteTheirCharacter then

            local delete = _menuPool:AddSubMenu(character_sub.SubMenu, Translation[Config.Locale]['delete_char'], '~b~')
            local deleteConfirm = NativeUI.CreateItem(Translation[Config.Locale]['delete_char_conirm'], '~b~')
            delete.SubMenu:AddItem(deleteConfirm)

            deleteConfirm.Activated = function(sender, index)
                TriggerServerEvent('myMultichar:deleteChar', selectedIndex, max)
                _menuPool:CloseAllMenus()
                --ShowNotification('~g~Charakter wird gelöscht...')
                gotCharData = false
                TriggerServerEvent('myMultichar:GetPlayerCharacters')
                return
            end

        end


    end

    local createCharText = Translation[Config.Locale]['new_character']
    local labelText = #chars .. '/' .. max
    local createCharDesc = Translation[Config.Locale]['new_character_desc']

    if #chars >= max then
        createCharText = '~c~' .. Translation[Config.Locale]['new_character']
        createCharDesc = Translation[Config.Locale]['slots_full']
        labelText = '~c~' .. #chars .. '/' .. max
    end

    local createChar = NativeUI.CreateItem(createCharText, createCharDesc)
    createChar:RightLabel(labelText)
    mainMenu:AddItem(createChar)

	mainMenu.OnIndexChange = function(sender, index)
		
		if item ~= createChar then
		
			if chars[index] ~= nil then
                
                if chars[index].skin ~= nil then
                    local skinData = json.decode(chars[index].skin)
                    setPedClothing(skinData, chars[index].pedModel)
                end
				
			end

		end
	
	end

    mainMenu.OnItemSelect = function(sender, item, index)

        if item == createChar then
            if #chars < max then
                mainMenu:Visible(false)
                TriggerServerEvent('myMultichar:CharSelected', #chars + 1, true)
            end
        else
            
            selectedIndex = index
            --print(selectedIndex)

        end
        --[[else
            mainMenu:Visible(false)
            TriggerServerEvent('myMultichar:CharSelected', index, false)
        end--]]
        
    end

    mainMenu:Visible(not mainMenu:Visible())
    TriggerEvent('endLoadingScreen')
    print('Loadingscreen will be closed')
    ShutdownLoadingScreenNui()
    _menuPool:RefreshIndex()
    _menuPool:MouseEdgeEnabled(false)


end

function selectSpawnPoint(lastLocation, isnew)

    _menuPool:Remove()
    collectgarbage()
    
    local selectorMenu = NativeUI.CreateMenu(Translation[Config.Locale]['select_title'])
    _menuPool:Add(selectorMenu) 
    selectorMenu.Controls.Back.Enabled = false

    local spawnAtLastLocation = NativeUI.CreateItem(Translation[Config.Locale]['last_position'], '~b~')
    selectorMenu:AddItem(spawnAtLastLocation)    

    spawnAtLastLocation.Activated = function(sender, index)
        finishSpawn(lastLocation, isnew)
    end

    for k, v in pairs(Config.SpawnLocations) do
        local spawnpoint = NativeUI.CreateItem(v.label, Translation[Config.Locale]['position_desc'] .. v.label .. Translation[Config.Locale]['position_desc_2'])
        selectorMenu:AddItem(spawnpoint, isnew)

        spawnpoint.Activated = function(sender, index)
            finishSpawn(v.pos, isnew)
        end
    end

    if Config.useMyProperties then
        ESX.TriggerServerCallback('myProperties:receiveAllPropertiesFromPlayer', function(props)
            if props ~= nil then
                for k2, v2 in pairs(props) do
                    local propSpawn = NativeUI.CreateItem(v2.label, '~b~')
                    propSpawn:SetLeftBadge(BadgeStyle.Heart)
                    selectorMenu:AddItem(propSpawn)

                    propSpawn.Activated = function(sender, index)
                        finishSpawn(v2.coords, isnew)
                    end
                end
                
            end
        end)
    end
    Wait(200)

    selectorMenu:Visible(true)
    _menuPool:RefreshIndex()
    _menuPool:MouseEdgeEnabled(false)
end


function finishSpawn(pos, isnew)
    TriggerServerEvent('es:firstJoinProper')
    TriggerEvent('es:allowedToSpawn')

    TriggerServerEvent('zeus:CheckSteamId')
    TriggerServerEvent('vehicleShop:InsertLicense')

    _menuPool:CloseAllMenus()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x,pos.y,pos.z+250, 6000.00,0.00,0.00, 100.00, false, 0)
    PointCamAtCoord(cam, pos.x,pos.y,pos.z+2)
    SetCamActiveWithInterp(cam, cam2, 3700, true, true)
    Citizen.Wait(3700)
    PlaySoundFrontend(-1, "Zoom_Out", "DLC_HEIST_PLANNING_BOARD_SOUNDS", 1)
    RenderScriptCams(false, true, 500, true, true)
    PlaySoundFrontend(-1, "CAR_BIKE_WHOOSH", "MP_LOBBY_SOUNDS", 1)
	SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    Citizen.Wait(500)
    SetCamActive(cam, false)
    DestroyCam(cam, true)
    DisplayHud(true)
    DisplayRadar(true)

    if isnew then
		if Config.useRegisterMenu then
			TriggerEvent('myMultichar:RegisterNewAccount')
		end
    end

    TriggerEvent('myMultichar:loaded')
	
end

function setPlayerInVoid()
	
    FreezeEntityPosition(GetPlayerPed(-1), true)
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", 402.99,-999.01,-98.0, 300.00, 0.00 ,0.00, 70.00, false, 0)
	PointCamAtCoord(cam, 402.86, -996.74, -99.0)

	SetCamActive(cam, true)
    RenderScriptCams(true, false, 1, true, true)
		
	while not gotCharData do
		Citizen.Wait(10)
	end
	
	SetTimecycleModifier('default')
	if charData[1] ~= nil then
		local skinData = json.decode(charData[1].skin)
		setPedClothing(skinData, charData[1].pedModel)
	else
		setPedClothing(nil, nil)
	end

end


function setPedClothing(skin, pedModel)

    if playerPed ~= nil then
		DeleteEntity(playerPed)
		SetModelAsNoLongerNeeded(GetHashKey(sex))
	end

    if pedModel ~= nil then
        sex = pedModel
    else
		sex = "mp_m_freemode_01"
		if skin ~= nil then
			if skin.sex ~= 0 then
				sex = "mp_f_freemode_01"
			end
		end
     
    end

	RequestModel(GetHashKey(sex))
	while not HasModelLoaded(GetHashKey(sex)) do
		Wait(1)
	end
	
	if IsChoosing then
		SetEntityCoords(GetPlayerPed(-1), 397.92, -1004.4, -99.0)
	end

	playerPed = CreatePed(4, GetHashKey(sex), 402.86, -996.74, -99.0 - 1.0, 180.0, false, true)
	FreezeEntityPosition(playerPed, true)	
	SetEntityHeading(playerPed, 180.0)
	SetEntityInvincible(playerPed, true)
	SetBlockingOfNonTemporaryEvents(playerPed, true)

	if skin ~= nil then
		if skin.mom == 0 and skin.dad == 0 then
			SetPedHeadBlendData(playerPed, skin.face, skin.face, skin.face, skin.skin, skin.skin, skin.skin, 1.0, 1.0, 1.0, true)
		else
			SetPedHeadBlendData(playerPed, skin.mom, skin.dad, 0, skin.mom, skin.dad, 0, skin.face_md_weight,  skin.skin_md_weight, 0.0, true)
		end
		
		SetPedHairColor         (playerPed,       skin.hair_color_1,   skin.hair_color_2)           -- Hair Color
		SetPedHeadOverlay       (playerPed, 3,    skin.age_1,         (skin.age_2 / 10) + 0.0)      -- Age + opacity
		SetPedHeadOverlay       (playerPed, 1,    skin.beard_1,       (skin.beard_2 / 10) + 0.0)    -- Beard + opacity
		SetPedHeadOverlay       (playerPed, 2,    skin.eyebrows_1,    (skin.eyebrows_2 / 10) + 0.0) -- Eyebrows + opacity
		SetPedHeadOverlay       (playerPed, 4,    skin.makeup_1,      (skin.makeup_2 / 10) + 0.0)   -- Makeup + opacity
		SetPedHeadOverlay       (playerPed, 8,    skin.lipstick_1,    (skin.lipstick_2 / 10) + 0.0) -- Lipstick + opacity
		SetPedComponentVariation(playerPed, 2,    skin.hair_1,         skin.hair_2, 2)              -- Hair
		SetPedHeadOverlayColor  (playerPed, 1, 1, skin.beard_3,        skin.beard_4)                -- Beard Color
		SetPedHeadOverlayColor  (playerPed, 2, 1, skin.eyebrows_3,     skin.eyebrows_4)             -- Eyebrows Color
		SetPedHeadOverlayColor  (playerPed, 4, 1, skin.makeup_3,       skin.makeup_4)               -- Makeup Color
		SetPedHeadOverlayColor  (playerPed, 8, 1, skin.lipstick_3,     skin.lipstick_4)
		
		SetPedPropIndex(playerPed, 2, skin.ears_1, skin.ears_2, 2)  -- Ears Accessories

		SetPedComponentVariation(playerPed, 8,  skin.tshirt_1,  skin.tshirt_2, 2)     -- Tshirt
		SetPedComponentVariation(playerPed, 11, skin.torso_1,   skin.torso_2, 2)      -- torso parts
		SetPedComponentVariation(playerPed, 3,  skin.arms, 0, 2)                              -- torso
		SetPedComponentVariation(playerPed, 10, skin.decals_1,  skin.decals_2, 2)     -- decals
		SetPedComponentVariation(playerPed, 4,  skin.pants_1,   skin.pants_2, 2)      -- pants
		SetPedComponentVariation(playerPed, 6,  skin.shoes_1,   skin.shoes_2, 2)      -- shoes
		SetPedComponentVariation(playerPed, 1,  skin.mask_1,    skin.mask_2, 2)       -- mask
		SetPedComponentVariation(playerPed, 9,  skin.bproof_1,  skin.bproof_2, 2)     -- bulletproof
		SetPedComponentVariation(playerPed, 7,  skin.chain_1,   skin.chain_2, 2)      -- chain
		SetPedComponentVariation(playerPed, 5,  skin.bags_1,    skin.bags_2, 2)       -- Bag
		
		SetPedPropIndex(playerPed, 0, skin.helmet_1, skin.helmet_2, 2)  -- Helmet
		SetPedPropIndex(playerPed, 1, skin.glasses_1, skin.glasses_2, 2)  -- Glasses
		SetPedPropIndex(playerPed, 6, skin.watch_1, skin.watch_2, -1)
	else
		SetPedDefaultComponentVariation(playerPed)
	end
end

RegisterNetEvent('myMultichar:receiveChars')
AddEventHandler('myMultichar:receiveChars', function(characters, maxCharacters)

    generateMenu(characters, maxCharacters)

end)

-- register menu

local isInRegistration = false

local firstnameStr = nil
local lastnameStr = nil
local dateofbirthStr = nil
local heightStr = nil
local sexStr = 'm'

local registerMenu

RegisterNetEvent('myMultichar:RegisterNewAccount')
AddEventHandler('myMultichar:RegisterNewAccount', function(firstnameOld, lastnameOld, dobOld, sexOld, heightOld)
    _menuPool:Remove()
    collectgarbage()
	    
	if registerMenu ~= nil and registerMenu:Visible() then
        registerMenu:Visible(false)
    end
	
    isInRegistration = true
	
	if Config.ForceMultiplayerPed then
		loadPed("mp_m_freemode_01")
	end
	
    local firstnameStr = firstnameOld
    local lastnameStr = lastnameOld
    local dateofbirthStr = dobOld
    local heightStr = heightOld
    local sexStr = sexOld or 'm'

    registerMenu = NativeUI.CreateMenu(Translation[Config.Locale]['register_title'], Translation[Config.Locale]['register_title_desc'])
    registerMenu.Controls.Back.Enabled = false
    _menuPool:Add(registerMenu)
    
    local gender = {
        Translation[Config.Locale]['gender_m'],
        Translation[Config.Locale]['gender_f'],
    }

    local firstname = NativeUI.CreateItem(Translation[Config.Locale]['name'], '~b~')
    firstname:RightLabel(firstnameStr)
    local lastname = NativeUI.CreateItem(Translation[Config.Locale]['lastname'], '~b~')
    lastname:RightLabel(lastnameStr)
    local dateofbirth = NativeUI.CreateItem(Translation[Config.Locale]['dob'], '~b~')
    dateofbirth:RightLabel(dateofbirthStr)
    local height = NativeUI.CreateItem(Translation[Config.Locale]['height'], '~b~')
    height:RightLabel(heightStr)
    local sex = NativeUI.CreateListItem(Translation[Config.Locale]['sex'], gender, 1, nil)
    

    registerMenu:AddItem(firstname)
    registerMenu:AddItem(lastname)
    registerMenu:AddItem(dateofbirth)
    registerMenu:AddItem(height)
    registerMenu:AddItem(sex)

    local spacer = NativeUI.CreateItem('', '~b~')
    registerMenu:AddItem(spacer)

    local confirm = NativeUI.CreateItem(Translation[Config.Locale]['confirm'], Translation[Config.Locale]['confirm_desc'])
    confirm:RightLabel('~b~→→→')
    registerMenu:AddItem(confirm)

    registerMenu.OnListChange = function(sender, item, index)

        if item == sex then
            if gender[index] == Translation[Config.Locale]['gender_m'] then
                sexStr = 'm'
            elseif gender[index] == Translation[Config.Locale]['gender_f'] then
                sexStr = 'f'
            end
        end

    end

    registerMenu.OnItemSelect = function(sender, item, index)

        if item == firstname then
            local inserted = KeyboardInput(Translation[Config.Locale]['insert_name'], firstnameStr, 20)
            if tostring(inserted) then
                local firstname_res = tostring(inserted)
                firstname:RightLabel(firstname_res)
                firstnameStr = firstname_res
            end
        elseif item == lastname then
            local inserted = KeyboardInput(Translation[Config.Locale]['insert_lastname'], lastnameStr, 20)
            if tostring(inserted) then
                local lastname_res = tostring(inserted)
                lastname:RightLabel(lastname_res)
                lastnameStr = lastname_res
            end
        elseif item == dateofbirth then
            local inserted = KeyboardInput(Translation[Config.Locale]['insert_dob'], dateofbirthStr, 20)
            if tostring(inserted) then
                local dob_res = tostring(inserted)
                dateofbirth:RightLabel(dob_res)
                dateofbirthStr = dob_res
            end
        elseif item == height then
            local inserted = KeyboardInput(Translation[Config.Locale]['insert_height'], heightStr, 20)
            if tostring(inserted) then
                local height_res = tostring(inserted)
                height:RightLabel(height_res .. Translation[Config.Locale]['height_unit'])
                heightStr = height_res
            end
        elseif item == confirm then

            if firstnameStr ~= nil and lastnameStr ~= nil and dateofbirthStr ~= nil and heightStr ~= nil then
                registerMenu:Visible(false)
                isInRegistration = false
                TriggerServerEvent('myMultichar:updateAccount', firstnameStr, lastnameStr, dateofbirthStr, sexStr, heightStr)
                Wait(500)
                if Config.useMyCharCreator then
					TriggerEvent('myCreator:openMenu')
				else
					TriggerEvent('esx_skin:openSaveableMenu')
				end
                _menuPool:CloseAllMenus()
				
            else
                ShowNotification(Translation[Config.Locale]['register_error'])
            end
        end


    end


    registerMenu:Visible(true)
    _menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled (false)

end)

-- ped stuff

RegisterNetEvent('myMultichar:applyPed')
AddEventHandler('myMultichar:applyPed', function(currentPedModel)
    Citizen.Wait(Config.ApplyDelay)
    loadPed(GetHashKey(currentPedModel))
end)

RegisterNetEvent('myMultichar:openPedMenu')
AddEventHandler('myMultichar:openPedMenu', function(currentPedModel)
    _menuPool:Remove()
    collectgarbage()

    local pedMenu = NativeUI.CreateMenu(Translation[Config.Locale]['ped_models'], nil)
    _menuPool:Add(pedMenu)

    local default = NativeUI.CreateItem(Translation[Config.Locale]['default_ped'], '~b~')
    pedMenu:AddItem(default)

    default.Activated = function(sender, index)  
        loadDefault()
        TriggerServerEvent('myMultichar:updatePedModel', nil)
    end

    for k, v in pairs(Config.Peds) do
        local pedOption = NativeUI.CreateItem(v.name, '~b~')
        pedMenu:AddItem(pedOption)

        pedOption.Activated = function(sender, index)
            loadPed(GetHashKey(v.hash))
            TriggerServerEvent('myMultichar:updatePedModel', v.hash)
        end
    end

    pedMenu.OnIndexChange = function(sender, index)
        if index > 1 then -- ignore default
            showPed(Config.Peds[index-1].hash)
        end
    end

    pedMenu:Visible(true)  
    _menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled (false)
end)

local demoPed = nil

function loadDefault()
    if (demoPed ~= nil) then
		DeletePed(demoPed)
    end
    
	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		local model = nil

		if skin.sex == 0 then
			model = GetHashKey("mp_m_freemode_01")
		else
			model = GetHashKey("mp_f_freemode_01")
		end

		RequestModel(model)
		while not HasModelLoaded(model) do
			RequestModel(model)
			Citizen.Wait(1)
		end

		SetPlayerModel(PlayerId(), model)
		SetModelAsNoLongerNeeded(model)

		TriggerEvent('skinchanger:loadSkin', skin)
		TriggerEvent('esx:restoreLoadout')

		SetEntityCanBeDamaged(PlayerPedId(), true)
		
	end)
end

function showPed(pedHash)
	if (demoPed ~= nil) then
		DeletePed(demoPed)
	end

	RequestModel(pedHash)

    while not HasModelLoaded(pedHash) do
        RequestModel(pedHash)
        Citizen.Wait(1)
    end
	
	demoPed = CreatePed(5, pedHash, GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, -0.5), GetEntityHeading(PlayerPedId())-180.0, true, true) --spawn ped
	SetModelAsNoLongerNeeded(pedHash)
	SetPedDefaultComponentVariation(ped)

end

function loadPed(pedHash)
    if (demoPed ~= nil) then
		DeletePed(demoPed)
    end
    
    RequestModel(pedHash)

    while not HasModelLoaded(pedHash) do
        RequestModel(pedHash)
        Citizen.Wait(1)
    end

    SetPlayerModel(PlayerId(), pedHash)

    SetEntityMaxHealth(PlayerPedId(), 200)
    SetEntityHealth(PlayerPedId(), 200)

	SetPedComponentVariation(PlayerPedId(), 0, 0, 1, 0)
	Wait(1000)
	SetPedDefaultComponentVariation(PlayerPedId())
    SetModelAsNoLongerNeeded(pedHash)
end

RegisterCommand(Config.PermissionsCommand, function(source, args, raw)
    if group == Config.AdminGroup then
        if args[1] == nil or args[2] == nil or args[3] == nil then
            ShowNotification(Translation[Config.Locale]['giveperm_wrong_usage'])
        else
            if (args[2] == 'charamount' or args[2] == 'pedmode') then
                local targetSource = args[1]
                local type = args[2]
                local allowed = args[3]
                TriggerServerEvent('myMultichar:updatePermissions', targetSource, type, allowed)
            else
                ShowNotification(Translation[Config.Locale]['giveperm_wrong_usage'])
            end
        end
        
    end
end)
-- General functions

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false 
		return result 
	else
		Citizen.Wait(500) 
		blockinput = false
		return nil
	end
end

RegisterNetEvent('myMultichar:msg')
AddEventHandler('myMultichar:msg', function(message)
    ShowNotification(message)
end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end