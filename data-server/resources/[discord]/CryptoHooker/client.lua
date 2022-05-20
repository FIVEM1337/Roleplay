


RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
    local killedbyPlayer = data.killedByPlayer
    local deathCause

    if Config.deathCauseList[data.deathCause] then
        deathCause = Config.deathCauseList[data.deathCause].reason
    else
        deathCause = data.deathCause 
    end

    if killedbyPlayer then
        local killerID = data.killerServerId
        local distance = data.distance
    else

    end
end)


