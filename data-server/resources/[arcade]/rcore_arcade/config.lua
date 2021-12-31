Config = {}

-- Which translation you wish to use ?
Config.Locale = "de"

-- Key settings
Config.keyToOpenTicketMenu = "E"
Config.keyToOpenComputer = "E"

-- Marker for buying ticket
Config.Arcade = {
    {
        blip = {
            position = vector3(336.18, -912.88, 29.6),
            blipId = 521,
            scale = 1.0,
            color = 0,
            name = "Arcade house",
            shortRange = true,
            enable = true,
        },
    },
}

-- is arcade payed ?
Config.enableGameHouse = true
-- do not change unless you know what you're doing
Config.GPUList = {
    [1] = "ETX2080",
    [2] = "ETX1050",
    [3] = "ETX660",
}

-- do not change unless you know what you're doing
Config.CPUList = {
    [1] = "U9_9900",
    [2] = "U7_8700",
    [3] = "U3_6300",
    [4] = "BENTIUM",
}

Config.MyList = {
    {
        name = "name",
        link = "bleh",
    },
}

-- game list for retro machine
Config.RetroMachine = {
    {
        name = "Pacman",
        link = "http://xogos.robinko.eu/PACMAN/",
    },
    {
        name = "Tetris",
        link = "http://xogos.robinko.eu/TETRIS/",
    },
    {
        name = "Ping Pong",
        link = "http://xogos.robinko.eu/PONG/",
    },
    {
        name = "DOOM",
        link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/Doom.zip", "./DOOM.EXE"),
    },
    {
        name = "Duke Nukem 3D",
        link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/duke3d.zip", "./DUKE3D.EXE"),
    },
    {
        name = "Wolfenstein 3D",
        link = string.format("nui://rcore_arcade/html/msdos.html?url=%s&params=%s", "https://www.retrogames.cz/dos/zip/Wolfenstein3D.zip", "./WOLF3D.EXE"),
    },
}

-- game list for gaming machine
Config.GamingMachine = {
    {
        name = "Slide a Lama",
        link = "http://lama.robinko.eu/fullscreen.html",
    },
    {
        name = "Uno",
        link = "https://duowfriends.eu/",
    },
    {
        name = "Ants",
        link = "http://ants.robinko.eu/fullscreen.html",
    },
    {
        name = "FlappyParrot",
        link = "http://xogos.robinko.eu/FlappyParrot/",
    },
    {
        name = "Zoopaloola",
        link = "http://zoopaloola.robinko.eu/Embed/fullscreen.html"
    }
}

-- game list for super computer
Config.SuperMachine = {}

for i = 1, #Config.RetroMachine do
    table.insert(Config.SuperMachine, Config.RetroMachine[i])
end

for i = 1, #Config.GamingMachine do
    table.insert(Config.SuperMachine, Config.GamingMachine[i])
end

-- computer list in world
Config.computerList = {
    -- Retro machines
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(323.77, -919.89, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(323.77, -916.66, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(323.77, -915.75, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(323.77, -914.78, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(324.96, -912.99, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(325.77, -912.99, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },

    { --Disco Lower Section
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(366.03, -914.57, 24.64),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    { --Disco Lower Section
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(366.03, -913.46, 24.64),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    { --Disco Lower Section
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(366.03, -912.5, 24.64),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    { --Disco Lower Section
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(366.03, -911.6, 24.64),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    { --Disco Lower Section
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(366.03, -910.6, 24.64),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    { --Disco Lower Section
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(366.03, -908.6, 24.64),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    { --Disco Lower Section
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(366.03, -907.78, 24.64),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },

    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.RetroMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 31,
        position = vector3(326.7, -912.99, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 255, g = 255, b = 255, a = 125 },
            rotate = true,
        },
    },
    -- Gaming computers
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(324.7, -904.27, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(326.39, -904.27, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(328.04, -904.27, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(329.66, -904.27, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(331.35, -904.27, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(336.93, -903.16, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(338.66, -903.16, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(340.36, -903.16, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(342.01, -903.16, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    },
    {
        -- if false player dont need a ticket to play on this computer.
        isInGamingHouse = false,
        computerType = Config.GamingMachine,
        computerGPU = Config.GPUList[2],
        computerCPU = Config.CPUList[2],
        markerType = 42,
        position = vector3(343.89, -903.16, 29.26),
        markerOptions = {
            scale = { x = 0.5, y = 0.5, z = 0.5 },
            color = { r = 125, g = 125, b = 255, a = 125 },
            rotate = true,
        },
    }
}
