AddEventHandler('chatMessage', function(source, msg)
    msg = "**"..msg.."**"
    CreateLog(source, nil, msg, "chatMessage")
end)