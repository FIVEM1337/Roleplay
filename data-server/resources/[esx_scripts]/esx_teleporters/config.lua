Config = {}

Config.Teleporters = {
    {
        menu_title = "Teleporters Title",
        menu_desc = "Teleporters Description",
        notification = "Teleporter Notification",
        allowed_jobs = {all = true, police = true, ambulance = true},
        Marker = {
            show = true,
            type = 1,
            size = 1.5,
            height = 0.5,
            Offset = -0.9,
            DrawDistance = 5.0,
            color = {red = 255, green = 0, blue = 0, alpha = 100},
        },
        teleporters = {
            {coords = vector3(-496.57040405273,-331.58822631836,42.320701599121), heading = 0.0, label = "Zu Punkt 1", description = "Zu Punkt 1"},
            {coords = vector3(-503.34750366211,-328.78970336914,42.320686340332), heading = 0.0, label = "Zu Punkt 2", description = "Zu Punkt 2"},
            {coords = vector3(-504.79238891602,-336.37454223633,42.330974578857), heading = 0.0, label = "Zu Punkt 3", description = "Zu Punkt 3"},
        },
    },
}
