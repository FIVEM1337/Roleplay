garagecoord = {
    {
        garage = "A", --LEGION
        Dist = 7, -- distance (DEPRECATED)
        Type = "car",
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 241.1,
        garage_y = -757.1,
        garage_z = 34.639263153076, -- coordinates for this garage
        spawn_x = 245.59975585938,
        spawn_y = -743.73449707031,
        spawn_z = 33.954160003662,
        heading = 154.98515319824 -- Vehicle spawn location
    },
    {
        garage = "B", --PINK MOTEL
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 273.0,
        garage_y = -343.85,
        garage_z = 44.91,
        spawn_x = 270.75,
        spawn_y = -340.51,
        spawn_z = 44.92,
        heading = 342.03
    },
    {
        garage = "C", --GROVE
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -71.46,
        garage_y = -1821.83,
        garage_z = 26.94,
        spawn_x = -66.51,
        spawn_y = -1828.01,
        spawn_z = 26.94,
        heading = 235.64
    },
    {
        garage = "D", --MIRROR
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 1032.84,
        garage_y = -765.1,
        garage_z = 58.18,
        spawn_x = 1023.2,
        spawn_y = -764.27,
        spawn_z = 57.96,
        heading = 319.66
    },
    {
        garage = "E", --BEACH
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -1248.69,
        garage_y = -1425.71,
        garage_z = 4.32,
        spawn_x = -1244.27,
        spawn_y = -1422.08,
        spawn_z = 4.32,
        heading = 37.12,
        s
    },
    {
        garage = "F", --GO HIGHWAY
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -2961.58,
        garage_y = 375.93,
        garage_z = 15.02,
        spawn_x = -2964.96,
        spawn_y = 372.07,
        spawn_z = 14.78,
        heading = 86.07
    },
    {
        garage = "G", --SANDY WEST
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 217.33,
        garage_y = 2605.65,
        garage_z = 46.04,
        spawn_x = 216.94,
        spawn_y = 2608.44,
        spawn_z = 46.33,
        heading = 14.07
    },
    {
        garage = "H", --SANDY MAIN
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 1878.44,
        garage_y = 3760.1,
        garage_z = 32.94,
        spawn_x = 1880.14,
        spawn_y = 3757.73,
        spawn_z = 32.93,
        heading = 215.54
    },
    {
        garage = "I", --VINEWOOD
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 365.21,
        garage_y = 295.65,
        garage_z = 103.46,
        spawn_x = 364.84,
        spawn_y = 289.73,
        spawn_z = 103.42,
        heading = 164.23
    },
    {
        garage = "J", --GRAPESEED
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 1713.06,
        garage_y = 4745.32,
        garage_z = 41.96,
        spawn_x = 1710.64,
        spawn_y = 4746.94,
        spawn_z = 41.95,
        heading = 90.11
    },
    {
        garage = "K", --PALETO
        Type = "car",
        Dist = 7,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 107.32,
        garage_y = 6611.77,
        garage_z = 31.98,
        spawn_x = 110.84,
        spawn_y = 6607.82,
        spawn_z = 31.86,
        heading = 265.28
    },
    {
        garage = "Bayview Garage", --PALETO
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -686.14886474609,
        garage_y = 5782.2724609375,
        garage_z = 17.330951690674,
        spawn_x = -674.87390136719,
        spawn_y = 5779.3217773438,
        spawn_z = 16.652997970581,
        heading = 63.428153991699
    },
    --JOB GARAGE
    {
        garage = "Police Garage", --PALETO
        job = "police",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 662, scale = 0.6},
        garage_x = 427.20556640625,
        garage_y = -1011.4292602539,
        garage_z = 28.954322814941,
        spawn_x = 432.20071411133,
        spawn_y = -1015.4301757813,
        spawn_z = 28.840564727783,
        heading = 85.93824005127,
        default_vehicle = { -- the vehicle listed here is like a goverment property and can be used for patrol etc. (this can be used in other garage, public or other job garage)
            [1] = {model = 'police', name = 'Police', type = 'car', grade = 1, plateprefix = 'LSPD'}, -- minimum grade
            [2] = {model = 'police2', name = 'Police 2', type = 'car', grade = 1, plateprefix = 'LSPD'}, -- minimum grade
            [3] = {model = 'police3', name = 'Police 3', type = 'car', grade = 1, plateprefix = 'LSPD'}, -- minimum grade
        },
    },
    {
        garage = "Police Public Garage", -- public garage job
        garage_type = 'public', -- public = every police job can acccess the garage vehicle list (this can be used in other job garages too)
        job = "police",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 662, scale = 0.6},
        garage_x = 450.5574645996, -- 450.55746459961,-1025.3254394531,28.56488609314,52.594207763672
        garage_y = -1025.3254394531,
        garage_z = 28.56488609314,
        spawn_x = 443.62295532227, -- 443.62295532227,-1019.6309814453,27.948703765869,91.976776123047
        spawn_y = -1019.6309814453,
        spawn_z = 27.948703765869,
        heading = 91.976776123047,
    },
    --JOB GARAGE
    {
        garage = "Sheriff Garage", --PALETO
        job = "sheriff",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -450.94107055664,
        garage_y = 5989.919921875,
        garage_z = 31.338258743286,
        spawn_x = -450.94107055664,
        spawn_y = 5989.919921875,
        spawn_z = 31.338258743286,
        heading = 312.01202392578
    },
    {
        garage = "Sheriff Garage", --PALETO
        job = "sheriff",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 376.8639831543,
        garage_y = -1627.7742919922,
        garage_z = 28.504697799683,
        spawn_x = 395.60012817383,
        spawn_y = -1622.9046630859,
        spawn_z = 29.221649169922,
        heading = 227.15142822266
    },
    {
        garage = "Hospital Garage", --PALETO
        job = "ambulance",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = 291.01055908203,
        garage_y = -566.08709716797,
        garage_z = 43.260692596436,
        spawn_x = 286.06204223633,
        spawn_y = -562.79351806641,
        spawn_z = 43.117538452148,
        heading = 82.327735900879
    },
    {
        garage = "Mechanic Garage", --PALETO
        job = "mechanic",
        Type = "car",
        Dist = 10,
        Blip = {color = 38, sprite = 289, scale = 0.6},
        garage_x = -192.95492553711,
        garage_y = -1296.2727050781,
        garage_z = 31.295988082886,
        spawn_x = -194.388671875,
        spawn_y = -1304.6813964844,
        spawn_z = 31.330451965332,
        heading = 80.139533996582
    },

    -- BOAT GARAGE
    {
        garage = "Boat Garage A", --YACHT CLUB
        --job = "all", -- uncomment if job
        Type = "boat",
        Dist = 10,
        Store_dist = 40,
        Blip = {color = 38, sprite = 410, scale = 0.6},
        garage_x = -828.34112548828,
        garage_y = -1410.7623291016,
        garage_z = 1.6053801774979, -- coordinates for this garage
        spawn_x = -827.5205078125,
        spawn_y = -1418.7016601562,
        spawn_z = 0.11820656061172,
        heading = 103.99516296387, -- Vehicle spawn location
    },
    -- PLANE HANGAR
    {
        garage = "Plane Hangar A", --Devin Westons Hangar
        --job = "all", -- uncomment if job
        Type = "plane",
        Dist = 10,
        Store_dist = 50,
        Blip = {color = 38, sprite = 423, scale = 0.8},
        garage_x = -1025.9724121094,
        garage_y = -3018.4951171875,
        garage_z = 13.945039749146, -- coordinates for this garage
        spawn_x = -999.55120849609,
        spawn_y = -2998.3647460938,
        spawn_z = 14.783174514771,
        store_x = -1002.9470214844,
        store_y = -3009.9311523438,
        store_z = 13.945080757141,
        heading = 63.61706161499, -- Vehicle spawn location
    },
}