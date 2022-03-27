local _menuPool                 = NativeUI.CreatePool()
local UI                  = nil
function showSubtitle(message, time)
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandPrint(time, 1)
end

function showHelpNotification(text)
    BeginTextCommandDisplayHelp("THREESTRINGS")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true,5000)
end

function showNotification(text)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(text)
    DrawNotification(0, 1)
end

function createBlip(name, blip, coords, options)
    local x, y, z = table.unpack(coords)
    local ourBlip = AddBlipForCoord(x, y, z)
    SetBlipSprite(ourBlip, blip)
    if options.type then SetBlipDisplay(ourBlip, options.type) end
    if options.scale then SetBlipScale(ourBlip, options.scale) end
    if options.color then SetBlipColour(ourBlip, options.color) end
    if options.shortRange then SetBlipAsShortRange(ourBlip, options.shortRange) end
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(name)
    EndTextCommandSetBlipName(ourBlip)
    return ourBlip
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

function openComputerMenu(listGames, computer)
    _menuPool:CloseAllMenus()
	if UI ~= nil and UI:Visible() then
		UI:Visible(false)
	end

    UI = NativeUI.CreateMenu("Computermenü", nil, nil)
    _menuPool:Add(UI)

    for k, game in ipairs(listGames) do
        local gameitem = NativeUI.CreateItem(game.name, '')

        UI:AddItem(gameitem)
        gameitem.Activated = function(sender, index)
            _menuPool:CloseAllMenus()
            SetNuiFocus(true, true)
            SendNUIMessage({
                type = "on",
                game = game.link,
                gpu = computer.computerGPU,
                cpu = computer.computerCPU
            })
        end
    end
    UI:Visible(true)
	_menuPool:RefreshIndex()
	_menuPool:MouseControlsEnabled(false)
	_menuPool:MouseEdgeEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end
