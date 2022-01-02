Config = Config or {}
Config.Locale = 'de'
Config.EnablePlayerManagement     = true -- Enable society managing.

Config.ActionDistance = 3.0
Config.Keys = {
    action = {key = 38, label = 'E', name = 'INPUT_PICKUP'}
}

Config.Positions = {
    {
        pos = {x = 1020.87, y = -2310.03, z = 30.51},
        whitelistJobName = 'mechanic',


        lifter = {

            lifter1 = vector3(1019.05, -2309.51, 30.5),
            lifter2 = vector3(1019.05, -2315.94, 30.5),
            lifter3 = vector3(1019.05, -2322.09, 30.5),
            lifter4 = vector3(1019.05, -2328.25, 30.5),
            lifter5 = vector3(1019.05, -2334.82, 30.5),
        }
    }
}
