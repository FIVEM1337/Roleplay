
RegisterNetEvent('sendProximityMessageMe')
AddEventHandler('sendProximityMessageMe', function(id, name, last, message)
    local myId = PlayerId()
    local pid = GetPlayerFromServerId(id)

    if pid == myId then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(156, 41, 161, 0.5); border-radius: 3px;"><i class="fas fa-user"></i> [{0}] {1} {2} {3}</div>',
            args = { id, name, last, message }
        })
    elseif GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(myId)), GetEntityCoords(GetPlayerPed(pid)), true) < 19.9 then
        TriggerEvent('chat:addMessage', {
            template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(156, 41, 161, 0.5); border-radius: 3px;"><i class="fas fa-user"></i> [{0}] {1} {2} {3}</div>',
            args = { id, name, last, message }
        })
    end
end)
