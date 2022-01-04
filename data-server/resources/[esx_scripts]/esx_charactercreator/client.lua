ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
    
end)


local _menuPool = NativeUI.CreatePool()
local creatorMenu
local mainMenu
-- CAM STUFF
local cam            = nil
local isCameraActive = false
local zoomOffset     = 0.0
local camOffset      = 0.0
local heading        = 90.0

Citizen.CreateThread(function()
    while true do

        -- if IsControlJustReleased(0, 38) then
        --     showCreator()
        -- end

        if _menuPool:IsAnyMenuOpen() then
            _menuPool:ProcessMenus()
        end

        if isCameraActive then
			if IsControlJustReleased(1, 202) then
				DeleteSkinCam()
			end
        end

        if cam ~= nil and not _menuPool:IsAnyMenuOpen() then
			DeleteSkinCam()
		end

        if IsDisabledControlJustReleased(1, 191) then
            -- if mainMenu ~= nil and mainMenu:Visible() then
            --     mainMenu:Visible(false)
            --     TriggerEvent('skinchanger:getSkin', function(finalSkin)
            --         TriggerServerEvent('register:saveSkin', finalSkin)
            --         --generateClothesMenu()
            --     end)
            --     DeleteSkinCam()
                
            -- else
            if creatorMenu ~= nil and creatorMenu:Visible() then
                creatorMenu:Visible(false)
                TriggerEvent('skinchanger:getSkin', function(finalSkin)
                    TriggerServerEvent('register:saveSkin', finalSkin)
                    if not firstspawn then
                 --       generateClothesMenu(finalSkin)
                    end
                end)
                DeleteSkinCam()
            end
        end

        Citizen.Wait(1)
    end
end)

RegisterNetEvent('myCreator:openMenu')
AddEventHandler('myCreator:openMenu', function(status)
    generateGenderMenu(status)
end)

if Cfg.useCommand then
    RegisterCommand('skin', function(source, args, raw)
		if Cfg.PermissionsRequired then
			ESX.TriggerServerCallback('esx_charactercreator:getGroup', function(group_res)
				if group_res == Cfg.AdminGroup then
					generateGenderMenu()
				end
			end)
		else
			generateGenderMenu()
		end
    end)

    RegisterCommand('skin2', function(source, args, raw)
		if Cfg.PermissionsRequired then
			ESX.TriggerServerCallback('esx_charactercreator:getGroup', function(group_res)
				if group_res == Cfg.AdminGroup then
					generateClothesMenu()
				end
			end)
		else
			generateClothesMenu()
		end  
    end)

    RegisterCommand('skin3', function(source, args, raw)
		if Cfg.PermissionsRequired then
			ESX.TriggerServerCallback('esx_charactercreator:getGroup', function(group_res)
				if group_res == Cfg.AdminGroup then
					generateFaceMenu()
				end
			end)
		else
			generateFaceMenu()
		end
    end)
end


local selectedMother = 1
local selectedFather = 1

local selectedSimilarity
local selectedComplexion

local currentGender = 0

function generateGenderMenu(firstspawn)
	if creatorMenu ~= nil and creatorMenu:Visible() then
		creatorMenu:Visible(false)
	end

    local hash = GetEntityModel(PlayerPedId())

    local model, type
    if hash == 1885233650 then
        model = "mp_m_freemode_01"
        type = 1
    else
        model = "mp_f_freemode_01"
        type = 2
    end

    if firstspawn then
        loadPed(model)
    end

    RequestModel(model)


    creatorMenu = NativeUI.CreateMenu(Translation[Cfg.Locale]['face_title'])
    _menuPool:Add(creatorMenu)

    creatorMenu.Controls.Back.Enabled = false

    local gender = {Translation[Cfg.Locale]['male'], Translation[Cfg.Locale]['female']}
    local sex = NativeUI.CreateListItem(Translation[Cfg.Locale]['sex'], gender, type)
    creatorMenu:AddItem(sex)

    local parents = _menuPool:AddSubMenu(creatorMenu, Translation[Cfg.Locale]['parents'])
    creatorMenu.Items[2]:SetLeftBadge(BadgeStyle.Heart)
    creatorMenu.Items[2]:RightLabel('~b~→→→')
    local heritageWindow = NativeUI.CreateHeritageWindow(selectedMother, selectedFather)
    parents.SubMenu:AddWindow(heritageWindow)

    local selectMotherItem = NativeUI.CreateListItem(Translation[Cfg.Locale]['mother'], Cfg.motherNames, 1)
    parents.SubMenu:AddItem(selectMotherItem)

    local selectedFatherItem = NativeUI.CreateListItem(Translation[Cfg.Locale]['father'], Cfg.fatherNames, 1)
    parents.SubMenu:AddItem(selectedFatherItem)

    local similaritySlider = NativeUI.CreateSliderHeritageItem(Translation[Cfg.Locale]['similarity'], Cfg.intensity, 1)
    similaritySlider:Index(6)
    parents.SubMenu:AddItem(similaritySlider)

    local complexionSlider = NativeUI.CreateSliderHeritageItem(Translation[Cfg.Locale]['complexion'], Cfg.intensity, 1)
    complexionSlider:Index(6)
    parents.SubMenu:AddItem(complexionSlider)

    parents.SubMenu.OnListChange = function(sender, item, index)
        CreateSkinCam()
        if item == selectMotherItem then
            selectedMother = index
        else
            selectedFather = index
        end

        zoomOffset = 0.6
        camOffset = 0.7

        heritageWindow:Index(selectedMother, selectedFather)
        TriggerEvent('skinchanger:change', 'mom', selectedMother)
        TriggerEvent('skinchanger:change', 'dad', selectedFather)
        TriggerEvent('skinchanger:change', 'face_md_weight', selectedSimilarity)
        TriggerEvent('skinchanger:change', 'skin_md_weight', selectedComplexion)
    end


    parents.SubMenu.OnSliderChange = function(sender, item, index)
        CreateSkinCam()
        if item == similaritySlider then
            selectedSimilarity = index / 10
        elseif item == complexionSlider then
            selectedComplexion = index / 10
        end

        zoomOffset = 0.6
        camOffset = 0.7

        TriggerEvent('skinchanger:change', 'mom', selectedMother)
        TriggerEvent('skinchanger:change', 'dad', selectedFather)
        TriggerEvent('skinchanger:change', 'face_md_weight', selectedSimilarity)
        TriggerEvent('skinchanger:change', 'skin_md_weight', selectedComplexion)
    end

    local intensityValues = {}
    for i=1, 10, 1 do
        table.insert(intensityValues, i)
    end

    local advancedFaceSubmenu = _menuPool:AddSubMenu(creatorMenu, Translation[Cfg.Locale]['advanced_face'])
    creatorMenu.Items[3]:RightLabel('~b~→→→')

    for k, v in pairs(Cfg.AdvancedFaceParts) do
        local advancedFaceItem = NativeUI.CreateListItem(v.label, intensityValues, 1)
        advancedFaceSubmenu.SubMenu:AddItem(advancedFaceItem)

        local currentIndex = 1 

        advancedFaceSubmenu.SubMenu.OnIndexChange = function(sender, index)
            currentIndex = index
        end

        advancedFaceSubmenu.SubMenu.OnListChange = function(sender, item, index)
            CreateSkinCam()
            TriggerEvent('skinchanger:change', Cfg.AdvancedFaceParts[currentIndex].type, index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        end
    end

    local ageingList = NativeUI.CreateListItem(Translation[Cfg.Locale]['ageing'], Cfg.ageing, 1)
    creatorMenu:AddItem(ageingList)


    local ageingListIntensity = NativeUI.CreateListItem(Translation[Cfg.Locale]['ageing_intensity'], intensityValues, 1)
    creatorMenu:AddItem(ageingListIntensity)

    local eyeColourList = NativeUI.CreateListItem(Translation[Cfg.Locale]['eyecolour'], Cfg.eyeColors, 1)
    creatorMenu:AddItem(eyeColourList)

    local eyebrowsList = NativeUI.CreateListItem(Translation[Cfg.Locale]['eyebrows'], Cfg.eyebrows, 1)
    creatorMenu:AddItem(eyebrowsList)

    local eyebrowsIntensityList = NativeUI.CreateListItem(Translation[Cfg.Locale]['eyebrows_intensity'], intensityValues, 1)
    creatorMenu:AddItem(eyebrowsIntensityList)

    local complexionList = NativeUI.CreateListItem(Translation[Cfg.Locale]['complexion'], Cfg.complexion, 1)
    creatorMenu:AddItem(complexionList)

    local complexionIntensityList = NativeUI.CreateListItem(Translation[Cfg.Locale]['complexion_intensity'], intensityValues, 1)
    creatorMenu:AddItem(complexionIntensityList)

    local sunDamageList = NativeUI.CreateListItem(Translation[Cfg.Locale]['sun_damage'], Cfg.sundamage, 1)
    creatorMenu:AddItem(sunDamageList)

    local sunDamageIntensityList = NativeUI.CreateListItem(Translation[Cfg.Locale]['sun_damage_intensity'], intensityValues, 1)
    creatorMenu:AddItem(sunDamageIntensityList)

    creatorMenu.OnListChange = function(sender, item, index)
        CreateSkinCam()
        if item == sex then
            TriggerEvent('skinchanger:change', 'sex', index-1)
            currentGender = index-1

            zoomOffset = 1.5
            camOffset = 0.2
        elseif item == eyeColourList then
            TriggerEvent('skinchanger:change', 'eye_color', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == ageingList then
            TriggerEvent('skinchanger:change', 'age_1', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == ageingListIntensity then
            TriggerEvent('skinchanger:change', 'age_2', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == complexionList then
            TriggerEvent('skinchanger:change', 'complexion_1', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == complexionIntensityList then
            TriggerEvent('skinchanger:change', 'complexion_2', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == sunDamageList then
            TriggerEvent('skinchanger:change', 'sun_1', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == sunDamageIntensityList then
            TriggerEvent('skinchanger:change', 'sun_2', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == eyebrowsList then
            TriggerEvent('skinchanger:change', 'eyebrows_1', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        elseif item == eyebrowsIntensityList then
            TriggerEvent('skinchanger:change', 'eyebrows_2', index - 1)
            zoomOffset = 0.6
            camOffset = 0.7
        end
    end

    creatorMenu:Visible(true)
    _menuPool:RefreshIndex()
	_menuPool:MouseEdgeEnabled (false)
end

function generateClothesMenu(skin_result)
	if mainMenu ~= nil and mainMenu:Visible() then
		mainMenu:Visible(false)
	end

    _menuPool:Remove()
    mainMenu = NativeUI.CreateMenu(Translation[Cfg.Locale]['face_title'], nil, nil)
    _menuPool:Add(mainMenu)
	
	mainMenu.Controls.Back.Enabled = false

    local LastSkin

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		if skin ~= nil then
			LastSkin = skin
		else
			LastSkin = skin_result
		end

        if LastSkin.sex == 0 then
            torsoData = Cfg.MaleTorsoData
        elseif LastSkin.sex == 1 then
            torsoData = Cfg.FemaleTorsoData
        end
    
        local menuItems = {}
        local componentValues = {}
        for k, v in pairs(Cfg.skinContent) do
            componentValues[v.name] = {}
    
            local amountOfComponents
            if v.type == 1 then
                amountOfComponents = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), v.componentID)-1
            elseif v.type == 2 then
                amountOfComponents = GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), v.componentID)-1
            else
                amountOfComponents = v.amountComponents
            end
            
            if v.name == 'ears_1' or v.name == 'helmet_1' then
                table.insert(componentValues[v.name], -1)
            end
    
    
            for i2=0, amountOfComponents-1, 1 do
                if v.blockedParts[LastSkin.sex] ~= nil and #v.blockedParts[LastSkin.sex] > 0 then
                    for j2, blockedNumber in pairs(v.blockedParts[LastSkin.sex]) do
                        if i2 == blockedNumber then
                            break
                        elseif j2 == #v.blockedParts[LastSkin.sex] then
                            table.insert(componentValues[v.name], i2)
    
                        end
                    end
                else
                    table.insert(componentValues[v.name], i2)
                end
                
            end
    
            local finalIndex = LastSkin[v.name]
            for findIndexCount, findIndexData in pairs(componentValues[v.name]) do
                if findIndexData == LastSkin[v.name] then
                    finalIndex = findIndexCount
                    break
                end
            end
            local newValues = {}
            for i=1, #componentValues[v.name], 1 do
                table.insert(newValues, i)
            end
            local Component1ListItem = NativeUI.CreateListItem('~o~→ ~s~' .. v.label, componentValues[v.name], finalIndex)
            mainMenu:AddItem(Component1ListItem)
            table.insert(menuItems, {
                item = Component1ListItem,
                type = 1,
                data = v})
    
    
            if v.name2 ~= nil then
                variationValues = {}
                local amountOfVariations
                if v.type == 1 then
                    amountOfVariations = GetNumberOfPedTextureVariations(GetPlayerPed(-1), v.componentID, LastSkin[v.name])
                elseif v.type == 2 then
                    amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v.componentID, LastSkin[v.name])
                else 
                    amountOfVariations = v.amountVariations
                end
                for i2=0, amountOfVariations, 1 do
                    table.insert(variationValues, i2)
                end
                
                local variationString = Translation[Cfg.Locale]['change_colour']
                if v.type == 3 then
                    variationString = Translation[Cfg.Locale]['change_variation']
                end
                Component2ListItem = NativeUI.CreateListItem(variationString, variationValues, LastSkin[v.name2])
                mainMenu:AddItem(Component2ListItem)
    
                menuItems[#menuItems].parent = Component2ListItem
                table.insert(menuItems, {
                    item = Component2ListItem,
                    type = 2,
                    data = v})
    
            end
            mainMenu.OnListChange = function(sender, item, index)
                local selectedIndex = index 

                for k2, v2 in pairs(menuItems) do
                    if v2.item == item then
    
                        if v2.type == 1 then
                            if v2.data.name ~= "arms" and v2.data.type ~= 3 then
                              TriggerEvent('skinchanger:change', v2.data.name2, 0)
                            end
                            TriggerEvent('skinchanger:change', v2.data.name, componentValues[v2.data.name][selectedIndex])
    
                            CreateSkinCam()
                            zoomOffset = v2.data.zoomOffset
                            camOffset = v2.data.camOffset
    
                            if v2.parent ~= nil then
    
                                variationValues = {}
                                local amountOfVariations
                                if v2.data.type == 1 then
                                    amountOfVariations = GetNumberOfPedTextureVariations(GetPlayerPed(-1), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                                elseif v2.data.type == 2 then
                                    amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                                else
                                    amountOfVariations = v2.data.amountVariations
                                end
                                for i3=0, amountOfVariations, 1 do
                                    table.insert(variationValues, i3)
                                end
                                v2.parent._Index = 1
                                v2.parent.Items = variationValues
                            end
    
                            if v2.data.componentID == 11 then
                                if torsoData[componentValues[v2.data.name][selectedIndex]] ~= nil then
                                    TriggerEvent('skinchanger:change', 'arms', torsoData[componentValues[v2.data.name][selectedIndex]].arms)
                                    TriggerEvent('skinchanger:change', 'tshirt_2', 0)
                                    TriggerEvent('skinchanger:change', 'tshirt_1', torsoData[componentValues[v2.data.name][selectedIndex]].validShirts[1])
                                end
                
                            end
                        elseif v2.type == 2 then
                            TriggerEvent('skinchanger:change', v2.data.name2, selectedIndex-1)
                        end
    
                        break
                    end
                end
            end
        end

        local spacerItem = NativeUI.CreateItem('~b~', '~b~')
        mainMenu:AddItem(spacerItem)

        local saveItem = NativeUI.CreateItem(Translation[Cfg.Locale]['save_skin'], '~b~')
        mainMenu:AddItem(saveItem)

        saveItem.Activated = function(sender, item, index)
            mainMenu:Visible(false)
            TriggerEvent('skinchanger:getSkin', function(finalSkin)
                TriggerServerEvent('register:saveSkin', finalSkin)
            end)
            DeleteSkinCam()
        end

        mainMenu:Visible(true)
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled (false)
        _menuPool:MouseEdgeEnabled (false)
        _menuPool:ControlDisablingEnabled(false)

    end)
end

function generateFaceMenu(skin_result)
	if mainMenu ~= nil and mainMenu:Visible() then
		mainMenu:Visible(false)
	end

    _menuPool:Remove()
    mainMenu = NativeUI.CreateMenu(Translation[Cfg.Locale]['face_title'], nil, nil)
    _menuPool:Add(mainMenu)
	
	mainMenu.Controls.Back.Enabled = false

    local LastSkin

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
		if skin ~= nil then
			LastSkin = skin
		else
			LastSkin = skin_result
		end

        if LastSkin.sex == 0 then
            torsoData = Cfg.MaleTorsoData
        elseif LastSkin.sex == 1 then
            torsoData = Cfg.FemaleTorsoData
        end
    
        local menuItems = {}
        local componentValues = {}
        for k, v in pairs(Cfg.faceContent) do
            componentValues[v.name] = {}
    
            local amountOfComponents
            if v.type == 1 then
                amountOfComponents = GetNumberOfPedDrawableVariations(GetPlayerPed(-1), v.componentID)-1
            elseif v.type == 2 then
                amountOfComponents = GetNumberOfPedPropDrawableVariations(GetPlayerPed(-1), v.componentID)-1
            else
                amountOfComponents = v.amountComponents
            end
            
            if v.name == 'ears_1' or v.name == 'helmet_1' then
                table.insert(componentValues[v.name], -1)
            end
    
    
            for i2=0, amountOfComponents-1, 1 do
                if v.blockedParts[LastSkin.sex] ~= nil and #v.blockedParts[LastSkin.sex] > 0 then
                    for j2, blockedNumber in pairs(v.blockedParts[LastSkin.sex]) do
                        if i2 == blockedNumber then
                            break
                        elseif j2 == #v.blockedParts[LastSkin.sex] then
                            table.insert(componentValues[v.name], i2)
    
                        end
                    end
                else
                    table.insert(componentValues[v.name], i2)
                end    
            end
    
            local finalIndex = LastSkin[v.name]
            for findIndexCount, findIndexData in pairs(componentValues[v.name]) do
                if findIndexData == LastSkin[v.name] then
                    finalIndex = findIndexCount
                    break
                end
            end
            local newValues = {}
            for i=1, #componentValues[v.name], 1 do
                table.insert(newValues, i)
            end
            local Component1ListItem = NativeUI.CreateListItem('~o~→ ~s~' .. v.label, componentValues[v.name], finalIndex)
            mainMenu:AddItem(Component1ListItem)
            table.insert(menuItems, {
                item = Component1ListItem,
                type = 1,
                data = v})
    
    
            if v.name2 ~= nil then
                variationValues = {}
                local amountOfVariations
                if v.type == 1 then
                    amountOfVariations = GetNumberOfPedTextureVariations(GetPlayerPed(-1), v.componentID, LastSkin[v.name])
                elseif v.type == 2 then
                    amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v.componentID, LastSkin[v.name])
                else 
                    amountOfVariations = v.amountVariations
                end
                for i2=0, amountOfVariations, 1 do
                    table.insert(variationValues, i2)
                end
                
                local variationString = Translation[Cfg.Locale]['change_colour']
                if v.type == 3 then
                    variationString = Translation[Cfg.Locale]['change_variation']
                end
                Component2ListItem = NativeUI.CreateListItem(variationString, variationValues, LastSkin[v.name2])
                mainMenu:AddItem(Component2ListItem)
    
                menuItems[#menuItems].parent = Component2ListItem
                table.insert(menuItems, {
                    item = Component2ListItem,
                    type = 2,
                    data = v})
    
            end
            mainMenu.OnListChange = function(sender, item, index)
                local selectedIndex = index 
    
                for k2, v2 in pairs(menuItems) do
                    if v2.item == item then
    
                        if v2.type == 1 then
                            if v2.data.name ~= "arms" and v2.data.type ~= 3 then
                              TriggerEvent('skinchanger:change', v2.data.name2, 0)
                            end
                            TriggerEvent('skinchanger:change', v2.data.name, componentValues[v2.data.name][selectedIndex])
    
                            CreateSkinCam()
                            zoomOffset = v2.data.zoomOffset
                            camOffset = v2.data.camOffset
    
                            if v2.parent ~= nil then
    
                                variationValues = {}
                                local amountOfVariations
                                if v2.data.type == 1 then
                                    amountOfVariations = GetNumberOfPedTextureVariations(GetPlayerPed(-1), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                                elseif v2.data.type == 2 then
                                    amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                                else
                                    amountOfVariations = v2.data.amountVariations
                                end
                                for i3=0, amountOfVariations, 1 do
                                    table.insert(variationValues, i3)
                                end
                                v2.parent._Index = 1
                                v2.parent.Items = variationValues
                            end
    
                            if v2.data.componentID == 11 then
                                if torsoData[componentValues[v2.data.name][selectedIndex]] ~= nil then
                                    TriggerEvent('skinchanger:change', 'arms', torsoData[componentValues[v2.data.name][selectedIndex]].arms)
                                    TriggerEvent('skinchanger:change', 'tshirt_2', 0)
                                    TriggerEvent('skinchanger:change', 'tshirt_1', torsoData[componentValues[v2.data.name][selectedIndex]].validShirts[1])
                                end
                
                            end
                        elseif v2.type == 2 then
                            TriggerEvent('skinchanger:change', v2.data.name2, selectedIndex-1)
                        end
    
                        break
                    end
                end
            end
        end

        local spacerItem = NativeUI.CreateItem('~b~', '~b~')
        mainMenu:AddItem(spacerItem)

        local saveItem = NativeUI.CreateItem(Translation[Cfg.Locale]['save_skin'], '~b~')
        mainMenu:AddItem(saveItem)

        saveItem.Activated = function(sender, item, index)
            mainMenu:Visible(false)
            TriggerEvent('skinchanger:getSkin', function(finalSkin)
                TriggerServerEvent('register:saveSkin', finalSkin)
            end)
            DeleteSkinCam()
        end

        mainMenu:Visible(true)
        _menuPool:RefreshIndex()
        _menuPool:MouseControlsEnabled (false)
        _menuPool:MouseEdgeEnabled (false)
        _menuPool:ControlDisablingEnabled(false)

    end)
end

function CreateSkinCam()
	local playerPed = GetPlayerPed(-1)

	if not isCameraActive then
		if not DoesCamExist(cam) then
			cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
		end
		SetCamActive(cam, true)
		RenderScriptCams(true, true, 500, true, true)
		isCameraActive = true
		SetCamRot(cam, 0.0, 0.0, 270.0, true)
		SetEntityHeading(playerPed, 90.0)
	end
end
	
function DeleteSkinCam()
	isCameraActive = false
	SetCamActive(cam, false)
	RenderScriptCams(false, true, 500, true, true)
	cam = nil
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isCameraActive then
            DisableControlAction(2, 30, true)
            DisableControlAction(2, 31, true)
            DisableControlAction(2, 32, true)
            DisableControlAction(2, 33, true)
            DisableControlAction(2, 34, true)
            DisableControlAction(2, 35, true)
        
            DisableControlAction(0, 25,   true) -- Input Aim
            DisableControlAction(0, 24,   true) -- Input Attack
        
            local playerPed = GetPlayerPed(-1)
            local coords    = GetEntityCoords(playerPed)
        
            local angle = heading * math.pi / 180.0
            local theta = {
                x = math.cos(angle),
                y = math.sin(angle)
            }
            local pos = {
                x = coords.x + (zoomOffset * theta.x),
                y = coords.y + (zoomOffset * theta.y),
            }
        
            local angleToLook = heading - 140.0
            if angleToLook > 360 then
                angleToLook = angleToLook - 360
            elseif angleToLook < 0 then
                angleToLook = angleToLook + 360
            end
            angleToLook = angleToLook * math.pi / 180.0
            local thetaToLook = {
                x = math.cos(angleToLook),
                y = math.sin(angleToLook)
            }
            local posToLook = {
                x = coords.x + (zoomOffset * thetaToLook.x),
                y = coords.y + (zoomOffset * thetaToLook.y),
            }
        
            SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
	
		end
	end
end)
	
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
	
Citizen.CreateThread(function()
	local angle = 180
	while true do
		Citizen.Wait(0)

		if isCameraActive then

            if IsDisabledControlPressed(0, 108) then
                angle = angle - 1
            elseif IsDisabledControlPressed(0, 109) then
                angle = angle + 1
            end

            if angle > 360 then
                angle = angle - 360
            elseif angle < 0 then
                angle = angle + 360
            end

            heading = angle + 0.0
		end
	end
end)