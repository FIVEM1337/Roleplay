Config = {}
Config.Locale = 'de'
Config.Key = "X"

Config.MenuItems = {
    {
        id = 'dokumente',
        title = 'Dokumente',
        icon = 'user',
        items = {
            {
                id = 'Personalausweis',
                title = 'Personalausweis',
                icon = 'id-card',
                items = {
                    {
                        id = 'Personalausweis zeigen',
                        title = 'Personalausweis zeigen',
                        icon = 'id-card',
                        type = 'client',
                        event = 'esx_playerradialmenu:idcard',
                        args = {false},
                        shouldClose = false
                    }, 
                    {
                        id = 'Personalausweis anschauen',
                        title = 'Personalausweis anschauen',
                        icon = 'id-card',
                        type = 'client',
                        event = 'esx_playerradialmenu:idcard',
                        args = {true},
                        shouldClose = false
                    }, 
                }
            },
            {
                id = 'Führerschein',
                title = 'Führerschein',
                icon = 'driver-license',
                items = {
                    {
                        id = 'Führerschein zeigen',
                        title = 'Führerschein zeigen',
                        icon = 'driver-license',
                        type = 'client',
                        event = 'esx_playerradialmenu:idcard',
                        args = {false, "driver"},
                        shouldClose = false
                    }, 
                    {
                        id = 'Führerschein anschauen',
                        title = 'Führerschein anschauen',
                        icon = 'driver-license',
                        type = 'client',
                        event = 'esx_playerradialmenu:idcard',
                        args = {true, "driver"},
                        shouldClose = false
                    }, 
                }
            },
            {
                id = 'Waffenschein',
                title = 'Waffenschein',
                icon = 'weapon-license',
                items = {
                    {
                        id = 'Waffenschein zeigen',
                        title = 'Waffenschein zeigen',
                        icon = 'weapon-license',
                        type = 'client',
                        event = 'esx_playerradialmenu:idcard',
                        args = {false, "weapon"},
                        shouldClose = false
                    }, 
                    {
                        id = 'Waffenschein anschauen',
                        title = 'Waffenschein anschauen',
                        icon = 'weapon-license',
                        type = 'client',
                        event = 'esx_playerradialmenu:idcard',
                        args = {true, "weapon"},
                        shouldClose = false
                    }, 
                }
            },
        
        }
    },
    {
        id = 'clothesmenu',
        title = 'Kleidung',
        icon = 'tshirt',
        items = {
            {
                id = 'Hair',
                title = 'Haare',
                icon = 'user',
                type = 'client',
                event = 'esx_playerradialmenu:ToggleClothing',
                shouldClose = false
            }, 
            {
                id = 'Ear',
                title = 'Ohrstück',
                icon = 'deaf',
                type = 'client',
                event = 'esx_playerradialmenu:ToggleProps',
                shouldClose = false
            }, 
            {
                id = 'Neck',
                title = 'Hals',
                icon = 'user-tie',
                type = 'client',
                event = 'esx_playerradialmenu:ToggleClothing',
                shouldClose = false
            }, 
            {
                id = 'Top',
                title = 'Oberteil',
                icon = 'tshirt',
                type = 'client',
                event = 'esx_playerradialmenu:ToggleClothing',
                shouldClose = false
            }, 
            {
                id = 'Shirt',
                title = 'Shirt',
                icon = 'tshirt',
                type = 'client',
                event = 'esx_playerradialmenu:ToggleClothing',
                shouldClose = false
            }, 
            {
                id = 'Pants',
                title = 'Hose',
                icon = 'user',
                type = 'client',
                event = 'esx_playerradialmenu:ToggleClothing',
                shouldClose = false
            }, 
            {
                id = 'Shoes',
                title = 'Schuhe',
                icon = 'shoe-prints',
                type = 'client',
                event = 'esx_playerradialmenu:ToggleClothing',
                shouldClose = false
            }, 
            {
                id = 'meer',
                title = 'Extras',
                icon = 'plus',
                items = {
                    {
                        id = 'Hat',
                        title = 'Mütze',
                        icon = 'hat-cowboy-side',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleProps',
                        shouldClose = false
                    }, 
                    {
                        id = 'Glasses',
                        title = 'Brille',
                        icon = 'glasses',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleProps',
                        shouldClose = false
                    }, 
                    {
                        id = 'Visor',
                        title = 'Visier',
                        icon = 'hat-cowboy-side',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleProps',
                        shouldClose = false
                    }, 
                    {
                        id = 'Mask',
                        title = 'Maske',
                        icon = 'theater-masks',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleClothing',
                        shouldClose = false
                    }, 
                    { 
                        id = 'Vest',
                        title = 'Weste',
                        icon = 'vest',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleClothing',
                        shouldClose = false
                    }, 
                    {
                        id = 'Bag',
                        title = 'Rucksack',
                        icon = 'shopping-bag',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleClothing',
                        shouldClose = false
                    }, 
                    {
                        id = 'Bracelet',
                        title = 'Armband',
                        icon = 'user',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleProps',
                        shouldClose = false
                    }, 
                    {
                        id = 'Watch',
                        title = 'Uhr',
                        icon = 'stopwatch',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleProps',
                        shouldClose = false
                    }, 
                    {
                        id = 'Gloves',
                        title = 'Handschuhe',
                        icon = 'mitten',
                        type = 'client',
                        event = 'esx_playerradialmenu:ToggleClothing',
                        shouldClose = false
                    }
                }
            }
        }
    },
}

Config.Citzen = {
    {
        id = 'handcuff',
        title = 'Person fesseln',
        color = "green",
        icon = 'handcuff',
        type = 'client',
        event = 'esx_playerradialmenu:handcuff_trigger',
        shouldClose = false
    },
    {
        id = 'unhandcuff',
        title = 'Person entfesseln',
        color = "red",
        icon = 'handcuff',
        type = 'client',
        event = 'esx_playerradialmenu:uncuff_trigger',
        shouldClose = false
    },
    {
        id = 'bodysearch',
        title = 'Person durchsuchen',
        icon = 'search',
        type = 'client',
        event = 'esx_playerradialmenu:bodysearch_trigger',
        shouldClose = false
    },
    {
        id = 'bodydrag',
        title = 'Person tragen',
        icon = 'people-carry',
        type = 'client',
        event = 'esx_playerradialmenu:drag_trigger',
        shouldClose = false
    },
    {
        id = 'put_in_vehicle',
        title = 'Person in Fahrzeug setzen',
        icon = 'car-side',
        color = "green",
        type = 'client',
        event = 'esx_playerradialmenu:putInVehicle_trigger',
        shouldClose = false
    },
    {
        id = 'put_out_vehicle',
        title = 'Person aus Fahrzeug holen',
        icon = 'car-side',
        color = "red",
        type = 'client',
        event = 'esx_playerradialmenu:putOutVehicle_trigger',
        shouldClose = false
    },
}

Config.Vehicle = {
    {
        id = 'engine',
        title = 'Motor an | aus',
        icon = 'power-off',
        type = 'client',
        event = 'esx_playerradialmenu:engine',
        shouldClose = false
    },
    {
        id = 'vehiclewindows',
        title = 'Fenster öffnen | schließen',
        icon = 'car-side',
        items = {
            {
                id = 'window0',
                title = 'Vorne Rechts',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_window',
                args = {1},
                shouldClose = false
            },
            {
                id = 'window1',
                title = 'Hinten Rechts',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_window',
                args = {3},
                shouldClose = false
            },
            {
                id = 'window2',
                title = 'Alle öffnen',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_window',
                args = {0, 1, 2, 3},
                shouldClose = false
            },
            {
                id = 'window3',
                title = 'Hinten Links',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_window',
                args = {2},
                shouldClose = false
            },
            {
                id = 'window4',
                title = 'Vorne Links',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_window',
                args = {0},
                shouldClose = false
            },
        }
    },
    {
        id = 'vehicledoors',
        title = 'Fahrzeug Türen',
        icon = 'car-side',
        items = {
            {
                id = 'door0',
                title = 'Fahrertür',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_door',
                args = {0},
                shouldClose = false
            }, 
            {
                id = 'door4',
                title = 'Motorhaube',
                icon = 'car',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_door',
                args = {4},
                shouldClose = false
            }, 
            {
                id = 'door1',
                title = 'Beifahrertür',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_door',
                args = {1},
                shouldClose = false
            }, 
            {
                id = 'door3',
                title = 'Hinten Rechts',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_door',
                args = {3},
                shouldClose = false
            }, 
            {
                id = 'door5',
                title = 'Kofferraum',
                icon = 'car',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_door',
                args = {5},
                shouldClose = false
            }, 
            {
                id = 'door2',
                title = 'Hinten Links',
                icon = 'car-side',
                type = 'client',
                event = 'esx_playerradialmenu:vehicle_door',
                args = {2},
                shouldClose = false
            }
        }
    },
    {
        id = 'vehicleseats',
        title = 'Farzeug sitz',
        icon = 'chair',
        items = {
            {
                id = 0,
                title = 'Beifahrersitz',
                icon = 'chair',
                type = 'client',
                event = 'esx_playerradialmenu:ChangeSeat',
                shouldClose = false
            }, 
            {
                id = 2,
                title = 'Hinten Rechts',
                icon = 'chair',
                type = 'client',
                event = 'esx_playerradialmenu:ChangeSeat',
                shouldClose = false
            },
            {
                id = 1,
                title = 'Hinten Links',
                icon = 'chair',
                type = 'client',
                event = 'esx_playerradialmenu:ChangeSeat',
                shouldClose = false
            },
            {
                id = -1,
                title = 'Fahrersitz',
                icon = 'chair',
                type = 'client',
                event = 'esx_playerradialmenu:ChangeSeat',
                shouldClose = false
            }, 
        }
    },
}

Config.JobInteractions = {
    ["police"] = {
        {
            id = 'takedriverlicense',
            title = 'Revoke Drivers License',
            icon = 'id-card',
            type = 'client',
            event = 'police:client:SeizeDriverLicense',
            shouldClose = true
        },
        {
            id = 'policeinteraction',
            title = 'Police Actions',
            icon = 'tasks',
            items = 
            {
                {
                    id = 'statuscheck',
                    title = 'Check Health Status',
                    icon = 'heartbeat',
                    type = 'client',
                    event = 'hospital:client:CheckStatus',
                    shouldClose = true
                }, 
                {
                    id = 'checkstatus',
                    title = 'Check status',
                    icon = 'question',
                    type = 'client',
                    event = 'police:client:CheckStatus',
                    shouldClose = true
                }, 
                {
                    id = 'escort',
                    title = 'Escort',
                    icon = 'user-friends',
                    type = 'client',
                    event = 'police:client:EscortPlayer',
                    shouldClose = true
                }, 
                {
                    id = 'searchplayer',
                    title = 'Search',
                    icon = 'search',
                    type = 'client',
                    event = 'police:client:SearchPlayer',
                    shouldClose = true
                }, 
                {
                    id = 'jailplayer',
                    title = 'Jail',
                    icon = 'user-lock',
                    type = 'client',
                    event = 'police:client:JailPlayer',
                    shouldClose = true
                }
            }
        },
    },
}

Config.Commands = {
    ["top"] = {
        Func = function() ToggleClothing("Top") end,
        Sprite = "top",
        Desc = "Hemd an-/auszihen",
        Button = 1,
        Name = "Torso"
    },
    ["gloves"] = {
        Func = function() ToggleClothing("gloves") end,
        Sprite = "gloves",
        Desc = "Handschuhe an-/auszihen",
        Button = 2,
        Name = "Gloves"
    },
    ["visor"] = {
        Func = function() ToggleProps("visor") end,
        Sprite = "visor",
        Desc = "Visier an-/auszihen",
        Button = 3,
        Name = "Visor"
    },
    ["bag"] = {
        Func = function() ToggleClothing("Bag") end,
        Sprite = "bag",
        Desc = "Opens or closes your bag",
        Button = 8,
        Name = "Bag"
    },
    ["shoes"] = {
        Func = function() ToggleClothing("Shoes") end,
        Sprite = "shoes",
        Desc = "Schuhe an-/auszihen",
        Button = 5,
        Name = "Shoes"
    },
    ["vest"] = {
        Func = function() ToggleClothing("Vest") end,
        Sprite = "vest",
        Desc = "Weste an-/auszihen",
        Button = 14,
        Name = "Vest"
    },
    ["hair"] = {
        Func = function() ToggleClothing("hair") end,
        Sprite = "hair",
        Desc = "Put your hair up/down/in a bun/ponytail.",
        Button = 7,
        Name = "Hair"
    },
    ["hat"] = {
        Func = function() ToggleProps("Hat") end,
        Sprite = "hat",
        Desc = "Mütze an-/auszihen",
        Button = 4,
        Name = "Hat"
    },
    ["glasses"] = {
        Func = function() ToggleProps("Glasses") end,
        Sprite = "glasses",
        Desc = "Brille an-/auszihen",
        Button = 9,
        Name = "Glasses"
    },
    ["ear"] = {
        Func = function() ToggleProps("Ear") end,
        Sprite = "ear",
        Desc = "Ohrstück an-/auszihen",
        Button = 10,
        Name = "Ear"
    },
    ["neck"] = {
        Func = function() ToggleClothing("Neck") end,
        Sprite = "neck",
        Desc = "Hals an-/auszihen",
        Button = 11,
        Name = "Neck"
    },
    ["watch"] = {
        Func = function() ToggleProps("Watch") end,
        Sprite = "watch",
        Desc = "Uhr an-/auszihen",
        Button = 12,
        Name = "Watch",
        Rotation = 5.0
    },
    ["bracelet"] = {
        Func = function() ToggleProps("Bracelet") end,
        Sprite = "bracelet",
        Desc = "Armband an-/auszihen",
        Button = 13,
        Name = "Bracelet"
    },
    ["mask"] = {
        Func = function() ToggleClothing("Mask") end,
        Sprite = "mask",
        Desc = "Maske an-/auszihen",
        Button = 6,
        Name = "Mask"
    }
}
local bags = {[40] = true, [41] = true, [44] = true, [45] = true}

Config.ExtraCommands = {
    ["pants"] = {
        Func = function() ToggleClothing("Pants", true) end,
        Sprite = "pants",
        Desc = "Hose an-/auszihen",
        Name = "Pants",
        OffsetX = -0.04,
        OffsetY = 0.0
    },
    ["shirt"] = {
        Func = function() ToggleClothing("Shirt", true) end,
        Sprite = "shirt",
        Desc = "Shirt an-/auszihen",
        Name = "shirt",
        OffsetX = 0.04,
        OffsetY = 0.0
    },
    ["reset"] = {
        Func = function()
            if not ResetClothing(true) then
                Notify('Nothing To Reset', 'error')
            end
        end,
        Sprite = "reset",
        Desc = "Komplette Kleidung anziehen",
        Name = "reset",
        OffsetX = 0.12,
        OffsetY = 0.2,
        Rotate = true
    },
    ["bagoff"] = {
        Func = function() ToggleClothing("Bagoff", true) end,
        Sprite = "bagoff",
        SpriteFunc = function()
            local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
            local BagOff = LastEquipped["Bagoff"]
            if LastEquipped["Bagoff"] then
                if bags[BagOff.Drawable] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            end
            if Bag ~= 0 then
                if bags[Bag] then
                    return "bagoff"
                else
                    return "paraoff"
                end
            else
                return false
            end
        end,
        Desc = "Tasche an-/auszihen",
        Name = "bagoff",
        OffsetX = -0.12,
        OffsetY = 0.2
    }
}