
if Config.CustomMenuEnabled then
    local RuntimeTXD = CreateRuntimeTxd('Custom_Menu_Head')
    local Object = CreateDui(Config.MenuImage, 512, 128)
    _G.Object = Object
    local TextureThing = GetDuiHandle(Object)
    local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'Custom_Menu_Head', TextureThing)
    Menuthing = "Custom_Menu_Head"
else
    Menuthing = "shopui_title_sm_hangar"
end

_menuPool = NativeUI.CreatePool()

local EmoteTable = {}
local FavEmoteTable = {}
local KeyEmoteTable = {}
local DanceTable = {}
local AnimalTable = {}
local PropETable = {}
local WalkTable = {}
local FaceTable = {}
local ShareTable = {}
local FavoriteEmote = ""

if Config.FavKeybindEnabled then
    CreateThread(function()
        while true do
            if IsControlPressed(0, Config.FavKeybind) then
                if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                    if FavoriteEmote ~= "" then
                        EmoteCommandStart(nil, { FavoriteEmote, 0 })
                        Wait(3000)
                    end
                end
            end
            Wait(1)
        end
    end)
end

lang = Config.MenuLanguage

function AddEmoteMenu(menu)
    model = GetEntityModel(PlayerPedId())

    local submenu = _menuPool:AddSubMenu(menu, Config.Languages[lang]['emotes'], "", "", Menuthing, Menuthing)
    local dancemenu = _menuPool:AddSubMenu(submenu.SubMenu, Config.Languages[lang]['danceemotes'], "", "", Menuthing, Menuthing)
    local animalmenu
    
    if model ~= 1885233650 and model ~= 1667301416 then
        animalmenu = _menuPool:AddSubMenu(submenu.SubMenu, Config.Languages[lang]['animalemotes'], "", "", Menuthing, Menuthing)
    end

    local propmenu = _menuPool:AddSubMenu(submenu.SubMenu, Config.Languages[lang]['propemotes'], "", "", Menuthing, Menuthing)
    table.insert(EmoteTable, Config.Languages[lang]['danceemotes'])
    table.insert(EmoteTable, Config.Languages[lang]['danceemotes'])
    
    if animalmenu then
        table.insert(EmoteTable, Config.Languages[lang]['animalemotes'])
    end

    if Config.SharedEmotesEnabled then
        sharemenu = _menuPool:AddSubMenu(submenu.SubMenu, Config.Languages[lang]['shareemotes'], Config.Languages[lang]['shareemotesinfo'], "", Menuthing, Menuthing)
        shareddancemenu = _menuPool:AddSubMenu(sharemenu.SubMenu, Config.Languages[lang]['sharedanceemotes'], "", "", Menuthing, Menuthing)
        table.insert(ShareTable, 'none')
        table.insert(EmoteTable, Config.Languages[lang]['shareemotes'])
    end

    if not Config.SqlKeybinding then
        unbind2item = NativeUI.CreateItem(Config.Languages[lang]['rfavorite'], Config.Languages[lang]['rfavorite'])
        unbinditem = NativeUI.CreateItem(Config.Languages[lang]['prop2info'], "")
        favmenu = _menuPool:AddSubMenu(submenu.SubMenu, Config.Languages[lang]['favoriteemotes'], Config.Languages[lang]['favoriteinfo'], "", Menuthing, Menuthing)
        favmenu.SubMenu:AddItem(unbinditem)
        favmenu.SubMenu:AddItem(unbind2item)
        table.insert(FavEmoteTable, Config.Languages[lang]['rfavorite'])
        table.insert(FavEmoteTable, Config.Languages[lang]['rfavorite'])
        table.insert(EmoteTable, Config.Languages[lang]['favoriteemotes'])
    else
        table.insert(EmoteTable, "keybinds")
        keyinfo = NativeUI.CreateItem(Config.Languages[lang]['keybinds'], Config.Languages[lang]['keybindsinfo'] .. " /emotebind [~y~num4-9~w~] [~g~emotename~w~]")
        submenu.SubMenu:AddItem(keyinfo)
    end

    for a, b in pairsByKeys(DP.Emotes) do
        x, y, z = table.unpack(b)
        emoteitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        submenu.SubMenu:AddItem(emoteitem)
        table.insert(EmoteTable, a)
        if not Config.SqlKeybinding then
            favemoteitem = NativeUI.CreateItem(z, Config.Languages[lang]['set'] .. z .. Config.Languages[lang]['setboundemote'])
            favmenu.SubMenu:AddItem(favemoteitem)
            table.insert(FavEmoteTable, a)
        end
    end

    for a, b in pairsByKeys(DP.Dances) do
        x, y, z = table.unpack(b)
        danceitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        sharedanceitem = NativeUI.CreateItem(z, "")
        dancemenu.SubMenu:AddItem(danceitem)
        if Config.SharedEmotesEnabled then
            shareddancemenu.SubMenu:AddItem(sharedanceitem)
        end
        table.insert(DanceTable, a)
    end

    if animalmenu then
        for a, b in pairsByKeys(DP.AnimalEmotes) do
            x, y, z = table.unpack(b)
            animalitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
            animalmenu.SubMenu:AddItem(animalitem)
            table.insert(AnimalTable, a)
        end
    end

    if Config.SharedEmotesEnabled then
        for a, b in pairsByKeys(DP.Shared) do
            x, y, z, otheremotename = table.unpack(b)
            if otheremotename == nil then
                shareitem = NativeUI.CreateItem(z, "/nearby (~g~" .. a .. "~w~)")
            else
                shareitem = NativeUI.CreateItem(z, "/nearby (~g~" .. a .. "~w~) " .. Config.Languages[lang]['makenearby'] .. " (~y~" .. otheremotename .. "~w~)")
            end
            sharemenu.SubMenu:AddItem(shareitem)
            table.insert(ShareTable, a)
        end
    end

    for a, b in pairsByKeys(DP.PropEmotes) do
        x, y, z = table.unpack(b)
        propitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        propmenu.SubMenu:AddItem(propitem)
        table.insert(PropETable, a)
        if not Config.SqlKeybinding then
            propfavitem = NativeUI.CreateItem(z, Config.Languages[lang]['set'] .. z .. Config.Languages[lang]['setboundemote'])
            favmenu.SubMenu:AddItem(propfavitem)
            table.insert(FavEmoteTable, a)
        end
    end

    if not Config.SqlKeybinding then
        favmenu.SubMenu.OnItemSelect = function(sender, item, index)
            if FavEmoteTable[index] == Config.Languages[lang]['rfavorite'] then
                FavoriteEmote = ""
                TriggerEvent('dopeNotify:Alert', "", Config.Languages[lang]['rfavorite'], 5000, 'info')
                return
            end
            if Config.FavKeybindEnabled then
                FavoriteEmote = FavEmoteTable[index]
                TriggerEvent('dopeNotify:Alert', "", firstToUpper(FavoriteEmote) .. Config.Languages[lang]['newsetemote'], 5000, 'info')
            end
        end
    end

    dancemenu.SubMenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(DanceTable[index], "dances")
    end

    if animalmenu then
        animalmenu.SubMenu.OnItemSelect = function(sender, item, index)
            EmoteMenuStart(AnimalTable[index], "animals")
        end
    end

    if Config.SharedEmotesEnabled then
        sharemenu.SubMenu.OnItemSelect = function(sender, item, index)
            if ShareTable[index] ~= 'none' then
                target, distance = GetClosestPlayer()
                if (distance ~= -1 and distance < 3) then
                    _, _, rename = table.unpack(DP.Shared[ShareTable[index]])
                    TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), ShareTable[index])
                    SimpleNotify(Config.Languages[lang]['sentrequestto'] .. GetPlayerName(target))
                else
                    SimpleNotify(Config.Languages[lang]['nobodyclose'])
                end
            end
        end

        shareddancemenu.SubMenu.OnItemSelect = function(sender, item, index)
            target, distance = GetClosestPlayer()
            if (distance ~= -1 and distance < 3) then
                _, _, rename = table.unpack(DP.Dances[DanceTable[index]])
                TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), DanceTable[index], 'Dances')
                SimpleNotify(Config.Languages[lang]['sentrequestto'] .. GetPlayerName(target))
            else
                SimpleNotify(Config.Languages[lang]['nobodyclose'])
            end
        end
    end

    propmenu.SubMenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(PropETable[index], "props")
    end

    submenu.SubMenu.OnItemSelect = function(sender, item, index)
        if EmoteTable[index] ~= Config.Languages[lang]['favoriteemotes'] then
            EmoteMenuStart(EmoteTable[index], "emotes")
        end
    end
end

function AddCancelEmote(menu)
    local newitem = NativeUI.CreateItem(Config.Languages[lang]['cancelemote'], Config.Languages[lang]['cancelemoteinfo'])
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, checked_)
        if item == newitem then
            EmoteCancel()
            DestroyAllProps()
        end
    end
end

function AddWalkMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, Config.Languages[lang]['walkingstyles'], "", "", Menuthing, Menuthing)

    walkreset = NativeUI.CreateItem(Config.Languages[lang]['normalreset'], Config.Languages[lang]['resetdef'])
    submenu.SubMenu:AddItem(walkreset)
    table.insert(WalkTable, Config.Languages[lang]['resetdef'])

    WalkInjured = NativeUI.CreateItem("Injured", "")
    submenu.SubMenu:AddItem(WalkInjured)
    table.insert(WalkTable, "move_m@injured")

    for a, b in pairsByKeys(DP.Walks) do
        x = table.unpack(b)
        walkitem = NativeUI.CreateItem(a, "")
        submenu.SubMenu:AddItem(walkitem)
        table.insert(WalkTable, x)
    end

    submenu.SubMenu.OnItemSelect = function(sender, item, index)
        if item ~= walkreset then
            WalkMenuStart(WalkTable[index])
        else
            ResetPedMovementClipset(PlayerPedId())
        end
    end
end

function AddFaceMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, Config.Languages[lang]['moods'], "", "", Menuthing, Menuthing)

    facereset = NativeUI.CreateItem(Config.Languages[lang]['normalreset'], Config.Languages[lang]['resetdef'])
    submenu.SubMenu:AddItem(facereset)
    table.insert(FaceTable, "")

    for a, b in pairsByKeys(DP.Expressions) do
        x, y, z = table.unpack(b)
        faceitem = NativeUI.CreateItem(a, "")
        submenu.SubMenu:AddItem(faceitem)
        table.insert(FaceTable, a)
    end

    submenu.SubMenu.OnItemSelect = function(sender, item, index)
        if item ~= facereset then
            EmoteMenuStart(FaceTable[index], "expression")
        else
            ClearFacialIdleAnimOverride(PlayerPedId())
        end
    end
end

function AddInfoMenu(menu)
    if not UpdateAvailable then
        infomenu = _menuPool:AddSubMenu(menu, Config.Languages[lang]['infoupdate'], "(1.7.4)", "", Menuthing, Menuthing)
    else
        infomenu = _menuPool:AddSubMenu(menu, Config.Languages[lang]['infoupdateav'], Config.Languages[lang]['infoupdateavtext'], "", Menuthing, Menuthing)
    end
    contact = NativeUI.CreateItem(Config.Languages[lang]['suggestions'], Config.Languages[lang]['suggestionsinfo'])
    u170 = NativeUI.CreateItem("1.7.0", "Added /emotebind [key] [emote]!")
    u165 = NativeUI.CreateItem("1.6.5", "Updated camera/phone/pee/beg, added makeitrain/dance(glowstick/horse).")
    u160 = NativeUI.CreateItem("1.6.0", "Added shared emotes /nearby, or in menu, also fixed some emotes!")
    u151 = NativeUI.CreateItem("1.5.1", "Added /walk and /walks, for walking styles without menu")
    u150 = NativeUI.CreateItem("1.5.0", "Added Facial Expressions menu (if enabled by server owner)")
    infomenu:AddItem(contact)
    infomenu:AddItem(u170)
    infomenu:AddItem(u165)
    infomenu:AddItem(u160)
    infomenu:AddItem(u151)
    infomenu:AddItem(u150)
end

function OpenEmoteMenu()
    if _menuPool:IsAnyMenuOpen() then
        _menuPool:CloseAllMenus()
        return
    end
    _menuPool:CloseAllMenus()

    mainMenu = NativeUI.CreateMenu("Emotes", "", Config.MenuPosition, Config.MenuPosition, Menuthing, Menuthing)
    _menuPool:Add(mainMenu)

    AddEmoteMenu(mainMenu)

    AddCancelEmote(mainMenu)
    if Config.WalkingStylesEnabled then
        AddWalkMenu(mainMenu)
    end
    if Config.ExpressionsEnabled then
        AddFaceMenu(mainMenu)
    end
    _menuPool:RefreshIndex()

    mainMenu:Visible(not mainMenu:Visible())
	_menuPool:MouseControlsEnabled (false)
	_menuPool:MouseEdgeEnabled (false)
	_menuPool:ControlDisablingEnabled(false)

end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end


CreateThread(function()
    while true do
        if _menuPool:IsAnyMenuOpen() then 
            _menuPool:ProcessMenus()
        else
            _menuPool:CloseAllMenus()
        end
        Wait(1)
    end
end)

RegisterNetEvent("dp:Update")
AddEventHandler("dp:Update", function(state)
    UpdateAvailable = state
    AddInfoMenu(mainMenu)
    _menuPool:RefreshIndex()
end)

RegisterNetEvent("dp:RecieveMenu") -- For opening the emote menu from another resource.
AddEventHandler("dp:RecieveMenu", function()
    OpenEmoteMenu()
end)
