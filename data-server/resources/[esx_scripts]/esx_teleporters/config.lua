Config = {}

Config.Teleporters = {
    {
        menu_title = "Krankenhaus",
        menu_desc = "Aufzug",
        notification = "Aufzug Menü drücke E",
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
            {coords = vector3(-435.81503295898,-357.58737182617,34.910697937012), heading = 353.59, label = "Eingang", description = ""},
            {coords = vector3(-421.77685546875,-345.86068725586,24.229345321655), heading = 0.0, label = "Tiefgarage", description = ""},
            {coords = vector3(-446.28753662109,-334.81015014648,78.317268371582), heading = 0.0, label = "Dachgarage", description = ""},
        },
    },
}
