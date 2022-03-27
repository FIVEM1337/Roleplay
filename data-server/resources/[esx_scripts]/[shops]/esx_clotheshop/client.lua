ESX = nil
local PlayerData = {}
local _menuPool = NativeUI.CreatePool()
local mainMenu = nil
local menuWallpaper = 'shopui_title_highendfashion'

local cam            = nil
local isCameraActive = false
local zoomOffset     = 0.0
local camOffset      = 0.0
local heading        = 90.0

local isNearShop = false
local isInShop = false
local isPedLoaded = false
local npc = nil
local hasBought = false
local wasInMenu = false
local LastSkin  = nil

local torsoData = {}

Citizen.CreateThread(function()
    while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
    end
    
    PlayerData = ESX.GetPlayerData()
    
end)


local ped = Config.NormalShopPed
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(300)

		local playerPed = PlayerPedId()
        local playerloc = GetEntityCoords(playerPed, 0)

		isNearShop = false
		isInShop = false

		for k, loc in pairs(Config.Shops) do
			local distance = Vdist(playerloc, loc.x, loc.y, loc.z)

			if distance < 30 then
				isNearShop = true
                if not isPedLoaded then
                    
                    if loc.type == 'MASK' then
						ped = Config.MaskShopPed
					end
					RequestModel(GetHashKey(ped))
					while not HasModelLoaded(GetHashKey(ped)) do
						Wait(1)
					end
					npc = CreatePed(4, GetHashKey(ped), loc.x, loc.y, loc.z - 1.0, loc.rot, false, true)
					FreezeEntityPosition(npc, true)	
					SetEntityHeading(npc, loc.rot)
					SetEntityInvincible(npc, true)
					SetBlockingOfNonTemporaryEvents(npc, true)                    
					isPedLoaded = true
				end
			end

			if distance < 2.0 then
				isInShop = true
				menuWallpaper = loc.type
			end

		end

		if (isPedLoaded and not isNearShop) then
            DeleteEntity(npc)
			SetModelAsNoLongerNeeded(GetHashKey(ped))
			isPedLoaded = false
		end
		
		if (wasInMenu and not isInShop) then
			if not hasBought then
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
					TriggerEvent('skinchanger:loadSkin', skin)
				end)
				TriggerEvent('lils_accessoires:setAccessoires')
			end
			wasInMenu = false
		end
		
		if cam ~= nil and not _menuPool:IsAnyMenuOpen() then
			DeleteSkinCam()
		end


	end

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function (job)
	ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1)

		if ESX.PlayerData.job == nil then
			ESX.PlayerData = ESX.GetPlayerData()
		end

		if isInShop then
			_menuPool:ProcessMenus()
			showInfobar(Translation[Config.Locale]['press_e_interact'])
			if IsControlJustReleased(1, 38) then
				hasBought = false
                wasInMenu = true
				if ESX.PlayerData.job and ESX.PlayerData.job.can_manageoutfits then
					generateClothesMenuSelect()
				else
					generateClothesMenu()
				end
			end
		else
			_menuPool:CloseAllMenus()
		end

		if isCameraActive then
			if IsControlJustReleased(1, 202) then
				DeleteSkinCam()
			end
        end

	
	end

end)

Citizen.CreateThread(function()
	
	for i=1, #Config.Shops, 1 do
		if Config.Shops[i].type == 'MASK' then
			local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

			SetBlipSprite (blip, 362)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.0)
			SetBlipColour (blip, 2)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Translation[Config.Locale]['blip_mask'])
			EndTextCommandSetBlipName(blip)
		else
			local blip = AddBlipForCoord(Config.Shops[i].x, Config.Shops[i].y, Config.Shops[i].z)

			SetBlipSprite (blip, 73)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, 1.0)
			SetBlipColour (blip, Config.NormalBlipColour)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(Translation[Config.Locale]['blip_normal'])
			EndTextCommandSetBlipName(blip)
		end
	end

end)

function ShowNotification(text)
	SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
	DrawNotification(false, true)
end

function showInfobar(msg)

	CurrentActionMsg  = msg
	SetTextComponentFormat('STRING')
	AddTextComponentString(CurrentActionMsg)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)

end

local confirmMenu = nil

function generateConfirmMenu(sex, grade, outfittype)

	if confirmMenu ~= nil and confirmMenu:Visible() then
		confirmMenu:Visible(false)
	end

    confirmMenu = NativeUI.CreateMenu(Translation[Config.Locale]['menu_buy_clothes'], nil)
    _menuPool:Add(confirmMenu)
    local buy = NativeUI.CreateItem(Translation[Config.Locale]['menu_confirm'], '~b~')

	if not sex and not grade then
    	buy:RightLabel('~g~' .. Config.Price .. '.00$')
	end

    local abort = NativeUI.CreateItem(Translation[Config.Locale]['menu_abort'], '~b~')
    abort:SetRightBadge(BadgeStyle.Alert)

    confirmMenu:AddItem(buy)
    confirmMenu:AddItem(abort)

    confirmMenu.OnItemSelect = function(sender, item, index)

        if item == buy then
			if sex and grade then
				TriggerEvent('skinchanger:getSkin', function(finalSkin)
					TriggerServerEvent('esx_clotheshop:setJobSkin', sex, grade, finalSkin, outfittype)
					ShowNotification(Translation[Config.Locale]['save_job_complete'])
					_menuPool:CloseAllMenus()
				end)
			else
            	TriggerServerEvent('esx_clotheshop:buy')
			end
        elseif item == abort then
            _menuPool:CloseAllMenus()
        end
    end

    confirmMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)

end

local variationValues
local Component2ListItem


function generateClothesMenuSelect()
	if selectMenu ~= nil and selectMenu:Visible() then
		selectMenu:Visible(false)
	end
	
	selectedIndex = 1
	
	_menuPool:Remove()
	_menuPool:RefreshIndex()
	selectMenu = NativeUI.CreateMenu(nil, nil, nil)

	selectMenu = NativeUI.CreateMenu(Translation[Config.Locale]['menu_select_private_or_business'], nil, nil)
	_menuPool:Add(selectMenu)

	local Privat = NativeUI.CreateItem(Translation[Config.Locale]['menu_private'], Translation[Config.Locale]['menu_select_private_desc'])
	local Business = NativeUI.CreateItem(Translation[Config.Locale]['menu_business'], Translation[Config.Locale]['menu_select_business_desc'])
	selectMenu:AddItem(Privat)
	selectMenu:AddItem(Business)

	selectMenu.OnItemSelect = function(sender, item, index)

        if item == Privat then
			generateClothesMenu()
			selectMenu:Visible(false)
		else
			generateselectSex()	
			selectMenu:Visible(false)
        end
    end

	selectMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end

function generateselectSex()
	if selectSexMenu ~= nil and selectSexMenu:Visible() then
		selectSexMenu:Visible(false)
	end

    selectSexMenu = NativeUI.CreateMenu(Translation[Config.Locale]['select_sex'], nil)

	local male = NativeUI.CreateItem(Translation[Config.Locale]['male'], '~b~')
	local female = NativeUI.CreateItem(Translation[Config.Locale]['female'], '~b~')

	selectSexMenu:AddItem(male)
	selectSexMenu:AddItem(female)

	_menuPool:Add(selectSexMenu)

    selectSexMenu.OnItemSelect = function(sender, item, index)
        if item == male then
			generateselectGrade("male")
		else
			generateselectGrade("female")
        end
		selectSexMenu:Visible(false)
    end

    selectSexMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end

function generateselectGrade(sex)
	if selectGradeMenu ~= nil and selectGradeMenu:Visible() then
		selectGradeMenu:Visible(false)
	end

    selectGradeMenu = NativeUI.CreateMenu(Translation[Config.Locale]['menu_select_grade'], nil)


	local done = false
	ESX.TriggerServerCallback('esx_clotheshop:getjobgrades', function(grades)
		for k, v in ipairs(grades) do
			local buy = NativeUI.CreateItem(v.label, '~b~')
			selectGradeMenu:AddItem(buy)
		end
		done = true
	end)


	while true do
		Citizen.Wait(1)
		if done then
			_menuPool:Add(selectGradeMenu)
			break
		end
	end

    local abort = NativeUI.CreateItem(Translation[Config.Locale]['menu_abort'], '~b~')
    abort:SetRightBadge(BadgeStyle.Alert)

    selectGradeMenu:AddItem(abort)

    selectGradeMenu.OnItemSelect = function(sender, item, index)

        if item == abort then
            _menuPool:CloseAllMenus()
		else
			TriggerEvent('skinchanger:getSkin', function(finalSkin)
				selectjoboutfittype(sex, item.Text:Text())
			end)
        end
		selectGradeMenu:Visible(false)
    end

    selectGradeMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end


function selectjoboutfittype(sex, grade)
	if selectjoboutfittypeMenu ~= nil and selectjoboutfittypeMenu:Visible() then
		selectjoboutfittypeMenu:Visible(false)
	end

    selectjoboutfittypeMenu = NativeUI.CreateMenu(Translation[Config.Locale]['menu_select_grade'], nil)
	_menuPool:Add(selectjoboutfittypeMenu)

	local outfit1 = NativeUI.CreateItem("Arbeitskleidung 1", '~b~')
	local outfit2 = NativeUI.CreateItem("Arbeitskleidung 2", '~b~')
	local outfit3 = NativeUI.CreateItem("Arbeitskleidung 3", '~b~')
	selectjoboutfittypeMenu:AddItem(outfit1)
	selectjoboutfittypeMenu:AddItem(outfit2)
	selectjoboutfittypeMenu:AddItem(outfit3)


    local abort = NativeUI.CreateItem(Translation[Config.Locale]['menu_abort'], '~b~')
    abort:SetRightBadge(BadgeStyle.Alert)

    selectjoboutfittypeMenu:AddItem(abort)

    selectjoboutfittypeMenu.OnItemSelect = function(sender, item, index)

        if item == abort then
            _menuPool:CloseAllMenus()
		elseif item == outfit1 then
			TriggerEvent('skinchanger:getSkin', function(finalSkin)
				generateClothesMenu(sex, grade, 1)
			end)

		elseif item == outfit2 then
			TriggerEvent('skinchanger:getSkin', function(finalSkin)
				generateClothesMenu(sex, grade, 2)
			end)

		elseif item == outfit3 then
			TriggerEvent('skinchanger:getSkin', function(finalSkin)
				generateClothesMenu(sex, grade, 3)
			end)
        end
		selectjoboutfittypeMenu:Visible(false)
    end

    selectjoboutfittypeMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end

function generateClothesMenu(sex, grade, outfittype)
	LastSkin = nil
	if sex and grade then
		ESX.TriggerServerCallback('esx_jobs:getjobskinwithgrade', function(jobskin)
			if jobskin then
				LastSkin = json.decode(jobskin)
			else
				if sex == "male" then
					LastSkin = Config.MaleSkin
				else
					LastSkin = Config.FemaleSkin
				end
			end
			TriggerEvent('skinchanger:loadSkin', LastSkin)
		end, sex, outfittype, grade)
	else
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			LastSkin = skin
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
	end

	while true do
		Citizen.Wait(1)
		if LastSkin then
			LoadCorrectSkin(sex, grade, outfittype, LastSkin)
			break
		end
	end
end

function LoadCorrectSkin(sex, grade, outfittype, CurrentSkin)

	if menuWallpaper == 'MASK' then
		content = Config.MaskContent
	else
		if sex and grade then
			content = Config.AllContent
		else
			content = Config.shopContent
		end
	end

	if mainMenu ~= nil and mainMenu:Visible() then
		mainMenu:Visible(false)
	end
	
	selectedIndex = 1
	
    _menuPool:Remove()
    _menuPool:RefreshIndex()
    mainMenu = NativeUI.CreateMenu(nil, nil, nil)

    if content == Config.shopContent then
        local background = Sprite.New(menuWallpaper, menuWallpaper, 0, 0, 431, 38)
        mainMenu:SetBannerSprite(background, true)
    else
        mainMenu = NativeUI.CreateMenu(Translation[Config.Locale]['title_haters'], nil, nil)
    end
    _menuPool:Add(mainMenu)

    if CurrentSkin.sex == 0 then
        torsoData = Config.MaleTorsoData
    elseif CurrentSkin.sex == 1 then
        torsoData = Config.FemaleTorsoData
    end

    if Config.enableSavedOutfits then
		if not sex and not grade then
			local savedOutfits_sub = _menuPool:AddSubMenu(mainMenu, Translation[Config.Locale]['saved_outfits'])
			local background = Sprite.New(menuWallpaper, menuWallpaper, 0, 0, 431, 38)
			if content == Config.shopContent then
				savedOutfits_sub.SubMenu:SetBannerSprite(background, true)
			end
			if Config.useesx_clotheshopapi then
				ESX.TriggerServerCallback('clothes:requestData', function(dressing)
					for i=1, #dressing, 1 do
						local dress = _menuPool:AddSubMenu(savedOutfits_sub.SubMenu, dressing[i].name)
						local takeOn = NativeUI.CreateItem(Translation[Config.Locale]['outfin_use'], '~b~')
						local remove = NativeUI.CreateItem(Translation[Config.Locale]['outfit_remove'], '~b~')
						dress.SubMenu:AddItem(takeOn)
						dress.SubMenu:AddItem(remove)
			
						savedOutfits_sub.SubMenu.OnIndexChange = function(sender, index)
							selectedIndex = index
						end
			
						dress.SubMenu.OnItemSelect = function(sender, item, index)
							if item == takeOn then
								TriggerEvent('skinchanger:getSkin', function(skin)
			
									--ESX.TriggerServerCallback('lils_properties:getPlayerOutfit', function(clothes)
						
									TriggerEvent('skinchanger:loadClothes', skin, dressing[selectedIndex].clothesData)
									TriggerEvent('esx_skin:setCurrentSkin', skin)
					
									TriggerEvent('skinchanger:getSkin', function(skinnew)
									TriggerServerEvent('esx_skin:save', skinnew)
									--	CurrentSkin = skinnew
									end)
									
									hasBought = true
									
						
									--end, selectedIndex)
						
								end)
							elseif item == remove then
								TriggerServerEvent('clothes:removeOutfit', dressing[selectedIndex].id)
								ShowNotification(Translation[Config.Locale]['outfit_removed'] .. dressing[selectedIndex].name .. Translation[Config.Locale]['outfit_removed2'])
								_menuPool:CloseAllMenus()
							end
						end
						_menuPool:RefreshIndex()
						_menuPool:MouseEdgeEnabled (false)
					end
				end)
			else
				ESX.TriggerServerCallback('esx_clotheshop:getPlayerDressing', function(dressing)
					for i=1, #dressing, 1 do
						local dress = _menuPool:AddSubMenu(savedOutfits_sub.SubMenu, dressing[i])
						local takeOn = NativeUI.CreateItem(Translation[Config.Locale]['outfin_use'], '~b~')
						local remove = NativeUI.CreateItem(Translation[Config.Locale]['outfit_remove'], '~b~')
						dress.SubMenu:AddItem(takeOn)
						dress.SubMenu:AddItem(remove)
			
						savedOutfits_sub.SubMenu.OnIndexChange = function(sender, index)
							selectedIndex = index
						end
			
						dress.SubMenu.OnItemSelect = function(sender, item, index)
							if item == takeOn then
								TriggerEvent('skinchanger:getSkin', function(skin)
			
									ESX.TriggerServerCallback('esx_clotheshop:getPlayerOutfit', function(clothes)
						
										TriggerEvent('skinchanger:loadClothes', skin, clothes)
										TriggerEvent('esx_skin:setCurrentSkin', skin)
						
										TriggerEvent('skinchanger:getSkin', function(skinnew)
											TriggerServerEvent('esx_skin:save', skinnew)
											CurrentSkin = skinnew
										end)
										
										hasBought = true
										
						
									end, selectedIndex)
						
								end)
							elseif item == remove then
								TriggerServerEvent('esx_clotheshop:removeOutfit', selectedIndex)
								ShowNotification(Translation[Config.Locale]['outfit_removed'] .. dressing[selectedIndex] .. Translation[Config.Locale]['outfit_removed2'])
								_menuPool:CloseAllMenus()
							end
						end
						_menuPool:RefreshIndex()
						_menuPool:MouseEdgeEnabled (false)
					end
				end) --]]
			end
		end
    end

    local menuItems = {}
    local componentValues = {}
    for k, v in pairs(content) do
        componentValues[v.name] = {}

        local amountOfComponents
        if v.type == 1 then
            amountOfComponents = GetNumberOfPedDrawableVariations(PlayerPedId(), v.componentID)
        else
            amountOfComponents = GetNumberOfPedPropDrawableVariations(PlayerPedId(), v.componentID)
        end
        
        if v.name == 'ears_1' or v.name == 'helmet_1' then
            table.insert(componentValues[v.name], -1)
        end

        --print('amount of comp:' .. amountOfComponents)

        for i2=0, amountOfComponents-1, 1 do
			--print(#v.blockedParts[CurrentSkin.sex])
            if v.blockedParts[CurrentSkin.sex] ~= nil and #v.blockedParts[CurrentSkin.sex] > 0 then
                for j2, blockedNumber in pairs(v.blockedParts[CurrentSkin.sex]) do
                    if i2 == blockedNumber then

                        --print(i2 .. ' is blocked')
                        break
                    elseif j2 == #v.blockedParts[CurrentSkin.sex] then
                        table.insert(componentValues[v.name], i2)
                        --print(i2 .. ' is free')
                    end
                end
            else
                table.insert(componentValues[v.name], i2)
            end
            
        end

        --print('after block: ' .. #componentValues[v.name])
        local finalIndex = CurrentSkin[v.name]
        for findIndexCount, findIndexData in pairs(componentValues[v.name]) do
            if findIndexData == CurrentSkin[v.name] then
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
                amountOfVariations = GetNumberOfPedTextureVariations(PlayerPedId(), v.componentID, CurrentSkin[v.name])
            else
                amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v.componentID, CurrentSkin[v.name])
            end
			-- -1 here?
            for i2=0, amountOfVariations, 1 do
                table.insert(variationValues, i2)
            end
            --print(amountOfVariations)
            Component2ListItem = NativeUI.CreateListItem(Translation[Config.Locale]['change_colour'], variationValues, CurrentSkin[v.name2])
            mainMenu:AddItem(Component2ListItem)

            menuItems[#menuItems].parent = Component2ListItem
            table.insert(menuItems, {
                item = Component2ListItem,
                type = 2,
                data = v})

        end
        mainMenu.OnListChange = function(sender, item, index)
            local selectedIndex = index 
            --local selectedIndex = index - 1

            for k2, v2 in pairs(menuItems) do
                if v2.item == item then
                    --[[if v2.data.name == 'ears_1' or v2.data.name == 'helmet_1' then
                        selectedIndex = selectedIndex - 1
                    end--]]
                    if v2.type == 1 then
                        if v2.data.name ~= "arms" then
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
                                amountOfVariations = GetNumberOfPedTextureVariations(PlayerPedId(), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                            else
                                amountOfVariations = GetNumberOfPedPropTextureVariations(PlayerPedId(-1), v2.data.componentID, componentValues[v2.data.name][selectedIndex])
                            end
                            for i3=0, amountOfVariations, 1 do
                                table.insert(variationValues, i3)
                            end
                            v2.parent._Index = 1
                            v2.parent.Items = variationValues
                           -- print('Variation Values updated to ' .. #variationValues)
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
	local save = NativeUI.CreateItem(Translation[Config.Locale]['menu_confirm'], '~b~')
	mainMenu:AddItem(save)

    mainMenu.OnItemSelect = function(sender, item, index)
        if item == save then
			mainMenu:Visible(false)
			DeleteSkinCam()
			generateConfirmMenu(sex, grade, outfittype)
		end
	end

    mainMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
end

function CreateSkinCam()
	local playerPed = PlayerPedId()

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

function CreateDialog(OnScreenDisplayTitle_shopmenu) --general OnScreenDisplay for KeyboardInput
	AddTextEntry(OnScreenDisplayTitle_shopmenu, OnScreenDisplayTitle_shopmenu)
	DisplayOnscreenKeyboard(1, OnScreenDisplayTitle_shopmenu, "", "", "", "", "", 32)
	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0);
		Wait(0);
	end
	if (GetOnscreenKeyboardResult()) then
		local displayResult = GetOnscreenKeyboardResult()
		return displayResult
	end
end


RegisterNetEvent('esx_clotheshop:confirm')
AddEventHandler('esx_clotheshop:confirm', function(enoughMoney)

	_menuPool:CloseAllMenus()

	if enoughMoney then
		TriggerEvent('skinchanger:getSkin', function(skin)

			if LastSkin['helmet_1'] ~= skin['helmet_1'] or LastSkin['helmet_2'] ~= skin['helmet_2'] then
                --TriggerServerEvent('accessoires:updateAccessoire', 'helmet', skin['helmet_1'], skin['helmet_2'])
				if Config.ForceAccessoiresDelete then
					TriggerEvent('skinchanger:change', 'helmet_1', -1)
				end
                TriggerServerEvent('esx_accessories:save', skin, 'Helmet')
			end
			
			if LastSkin['ears_1'] ~= skin['ears_1'] or LastSkin['ears_2'] ~= skin['ears_2'] then
                --TriggerServerEvent('accessoires:updateAccessoire', 'ears', skin['ears_1'], skin['ears_2'])
				if Config.ForceAccessoiresDelete then
					TriggerEvent('skinchanger:change', 'ears_1', -1)
				end
                TriggerServerEvent('esx_accessories:save', skin, 'Ears')
			end
			
			if LastSkin['glasses_1'] ~= skin['glasses_1'] or LastSkin['glasses_2'] ~= skin['glasses_2'] then
                --TriggerServerEvent('accessoires:updateAccessoire', 'glasses', skin['glasses_1'], skin['glasses_2'])
				if Config.ForceAccessoiresDelete then
					TriggerEvent('skinchanger:change', 'glasses_1', 0)
				end
                TriggerServerEvent('esx_accessories:save', skin, 'Glasses')
			end
			
			if LastSkin['mask_1'] ~= skin['mask_1'] or LastSkin['mask_2'] ~= skin['mask_2'] then
                --TriggerServerEvent('accessoires:updateAccessoire', 'mask', skin['mask_1'], skin['mask_2'])
				if Config.ForceAccessoiresDelete then
					TriggerEvent('skinchanger:change', 'mask_1', 0)
				end
                TriggerServerEvent('esx_accessories:save', skin, 'Mask')
			end
			
			--[[if LastSkin['watch_1'] ~= skin['watch_1'] or LastSkin['watch_2'] ~= skin['watch_2'] then
				TriggerServerEvent('accessoires:updateAccessoire', 'watch', skin['watch_1'], skin['watch_2'])
			end
			
			if LastSkin['chain_1'] ~= skin['chain_1'] or LastSkin['chain_2'] ~= skin['chain_2'] then
				TriggerServerEvent('accessoires:updateAccessoire', 'chain', skin['chain_1'], skin['chain_1'])
			end
			
			if LastSkin['bags_1'] ~= skin['bags_1'] or LastSkin['bags_2'] ~= skin['bags_2'] then
				TriggerServerEvent('accessoires:updateAccessoire', 'backpack', skin['bags_1'], skin['bags_2'])
			end--]]
			TriggerEvent('skinchanger:getSkin', function(finalSkin)
				TriggerServerEvent('skin:save', finalSkin)
				LastSkin = finalSkin
				menu_ask_to_save(finalSkin)
			end)
		end)
        hasBought = true
        ShowNotification(Translation[Config.Locale]['buy_complete'])

	else
		ShowNotification(Translation[Config.Locale]['not_enough_money'])
		ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
			TriggerEvent('skinchanger:loadSkin', skin)
		end)
		TriggerEvent('lils_accessoires:setAccessoires')

	end

end)


function menu_ask_to_save(skin)
	if confirmMenu ~= nil and confirmMenu:Visible() then
		confirmMenu:Visible(false)
	end

    confirmMenu = NativeUI.CreateMenu(Translation[Config.Locale]['save_outfit'], nil)
    _menuPool:Add(confirmMenu)
    local save = NativeUI.CreateItem(Translation[Config.Locale]['menu_confirm'], '~b~')
	local abort = NativeUI.CreateItem(Translation[Config.Locale]['menu_abort'], '~b~')
    abort:SetRightBadge(BadgeStyle.Alert)

    confirmMenu:AddItem(save)
	confirmMenu:AddItem(abort)

    confirmMenu.OnItemSelect = function(sender, item, index)

        if item == save then
			if Config.useesx_clotheshopapi then
				local outfitname = CreateDialog('Name des Outfits eingeben')
				if tostring(outfitname) then
					ShowNotification(Translation[Config.Locale]['saved'] .. outfitname .. Translation[Config.Locale]['saved_2'])
					TriggerServerEvent('clothes:saveOutfit', outfitname, skin)
				end
			else
				ESX.TriggerServerCallback('esx_clotheshop:checkHavePropertyStore', function(foundStore)
					if foundStore then
						local outfitname = CreateDialog('Name des Outfits eingeben')
						if tostring(outfitname) then
							ShowNotification(Translation[Config.Locale]['saved'] .. outfitname .. Translation[Config.Locale]['saved_2'])
							TriggerServerEvent('esx_clotheshop:saveOutfit', outfitname, skin)
							--TriggerServerEvent('clothes:saveOutfit', outfitname, skin)
						end
					end
				end)
			end
			_menuPool:CloseAllMenus()
        elseif item == abort then
            _menuPool:CloseAllMenus()
        end
    end

    confirmMenu:Visible(true)
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)
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
	
		local playerPed = PlayerPedId()
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
	
		--SetTextComponentFormat("STRING")
		--AddTextComponentString(_U('use_rotate_view'))
		--DisplayHelpTextFromStringLabel(0, 0, 0, -1)
		end
	end
end)
	
Citizen.CreateThread(function()
	local angle = 90
	while true do
		Citizen.Wait(0)
		if isCameraActive then
		if IsControlPressed(0, 108) then
			angle = angle - 1
		elseif IsControlPressed(0, 109) then
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