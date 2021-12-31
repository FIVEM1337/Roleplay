-------------------
-- Exports
-------------------
MenuAPI = exports.MenuAPI
-------------------


--create npc, blip, marker
Citizen.CreateThread(function()
    for k, v in pairs(Config.Arcade) do
        if v.blip and v.blip.enable then
            createBlip(v.blip.name, v.blip.blipId, v.blip.position, v.blip)
        end
    end
end)

--create markers for computers
Citizen.CreateThread(function()
    for k, v in pairs(Config.computerList) do
        local newPos = v.position - vector3(0, 0, 0.4)
        local computerMarker = createMarker()

        computerMarker.setKeys({38})

        computerMarker.setRenderDistance(10)
        computerMarker.setPosition(newPos)

        computerMarker.render()

        computerMarker.setColor(v.markerOptions.color)
        computerMarker.setScale(v.markerOptions.scale)
        computerMarker.setType(v.markerType)

        computerMarker.setRotation(v.markerOptions.rotate)

        computerMarker.on('enter', function()
            showHelpNotification("Drücke ~INPUT_CONTEXT~ um den Computer zu starten.")
        end)
        computerMarker.on('leave', function()
            MenuAPI:CloseAll()
        end)
        computerMarker.on('key', function()
            openComputerMenu(v.computerType, v)
        end)
    end
end)