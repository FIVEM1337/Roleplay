Config = {}

local container = 300
Config.UI = {
    Size = {
        BUTTON_SIZE = 56,
        ITEM_SIZE = 68,
        CONTAINER_SIZE = container,
        RADIUS = container / 2,
        ICON_SIZE = 40
    },
    Colors = {
        PRIMARY = '#00b4d8',
        PRIMARY_2 = '#0096c7',
        BORDER = '#dadada',
        TEXT = '#656565',
    }
}

Config.Open = {
    key = 'x',
    commandonly = false,
    command = 'Interaktionsmenu'
}

Config.RadialMenu = {
    {
        label="Dokumente",
        icon="MdPerson",
        submenu= {
            {
                label="Personalausweis",
                icon="MdAccountBox",
                submenu = 
                {
                    {
                        label="Personalausweis zeigen",
                        event="esx_radialmenu:idcard",
                        args = {false},
                        shouldClose=false,
                        icon="MdAccountBox",
                        client=true
                    },
                    {
                        label="Personalausweis anschauen",
                        event="esx_radialmenu:idcard",
                        args = {true},
                        shouldClose=true,
                        icon="MdAccountBox",
                        client=true
                    },
                }
            },
            {
                label="Führerschein",
                icon="MdAccountBox",
                submenu = 
                {
                    {
                        label="Führerschein zeigen",
                        event="esx_radialmenu:idcard",
                        args = {false, "driver"},
                        shouldClose=false,
                        icon="MdAccountBox",
                        client=true
                    },
                    {
                        label="Führerschein anschauen",
                        event="esx_radialmenu:idcard",
                        args = {true, "driver"},
                        shouldClose=true,
                        icon="MdAccountBox",
                        client=true
                    },
                }
            },
            {
                label="Waffenschein",
                icon="MdAccountBox",
                submenu = 
                {
                    {
                        label="Waffenschein zeigen",
                        event="esx_radialmenu:idcard",
                        args = {false, "weapon"},
                        shouldClose=false,
                        icon="MdAccountBox",
                        client=true
                    },
                    {
                        label="Waffenschein anschauen",
                        event="esx_radialmenu:idcard",
                        args = {true, "weapon"},
                        shouldClose=true,
                        icon="MdAccountBox",
                        client=true
                    },
                }
            },
        }
    },

    {
        label="Personen Interaktionen",
        icon="MdPerson",
        submenu= {
            {
                label="Person fesseln",
                icon="MdSettingsAccessibility",
                client=true,
                shouldClose=true,
                event="esx_radialmenu:handcuff",
            },
            {
                label="Person entfesseln",
                icon="MdSettingsAccessibility",
                client=true,
                shouldClose=true,
                event="esx_radialmenu:uncuff",
            },
            {
                label="Person durchsuchen",
                icon="MdSettingsAccessibility",
                client=true,
                shouldClose=true,
                event="esx_jobs:startbodysearch"
            },
        }
    },
}


Config.VehicleMenu = {
    {
        label="Motor an | aus",
        event="esx_radialmenu:engine",
        shouldClose=true,
        icon="MdPhoneIphone",
        client=true
    },
    {
        label="Türen öffnen | schließen",
        icon="MdPerson",
        submenu= {
            {
                label="Vorne öffnen",
                event="esx_radialmenu:vehicle_door",
                args = {4},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Vorne Rechts",
                event="esx_radialmenu:vehicle_door",
                args = {1},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Hinten Rechts",
                event="esx_radialmenu:vehicle_door",
                args = {3},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Kofferraum",
                event="esx_radialmenu:vehicle_door",
                args = {5},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Hinten Links",
                event="esx_radialmenu:vehicle_door",
                args = {2},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Vorne Links",
                event="esx_radialmenu:vehicle_door",
                args = {0},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
        }
    },
    {
        label="Fenster öffnen | schließen",
        icon="MdPerson",
        submenu= {
            {
                label="Alle öffnen",
                event="esx_radialmenu:vehicle_window",
                args = {{0, 1, 2, 3}},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Vorne Rechts",
                event="esx_radialmenu:vehicle_window",
                args = {{1}},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Hinten Rechts",
                event="esx_radialmenu:vehicle_window",
                args = {{3}},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Hinten",
                event="esx_radialmenu:vehicle_window",
                args = {{2, 3}},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Vorne",
                event="esx_radialmenu:vehicle_window",
                args = {{0, 1}},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Hinten Links",
                event="esx_radialmenu:vehicle_window",
                args = {{2}},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
            {
                label="Vorne Links",
                event="esx_radialmenu:vehicle_window",
                args = {{0}},
                shouldClose=false,
                icon="MdAccountBox",
                client=true
            },
        }
    },
}
