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

function openComputerMenu(listGames, computer_)
    local computer = computer_
    local index = 0
    local gameMenu = MenuAPI:CreateMenu("gamelist")

    gameMenu.SetMenuTitle("Computermenü")

    gameMenu.SetProperties({
        float = "right",
        position = "middle",
    })

    for key, value in pairs(listGames) do
        index = index + 1
        print(index, value.name)
        gameMenu.AddItem(index, value.name, function()
            SendNUIMessage({
                type = "on",
                game = value.link,
                gpu = computer.computerGPU,
                cpu = computer.computerCPU
            })
            SetNuiFocus(true, true)
            gameMenu.Close()
        end)
    end

    gameMenu.Open()
end