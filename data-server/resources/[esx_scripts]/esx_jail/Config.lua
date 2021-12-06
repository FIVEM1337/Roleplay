Config = {}

--Important Configs
Config.MenuLoc = 'left' --Where all esx mneus will shows up in this script
Config.Notifications = 'dopeNotify' --This either can be {esx, mythic, tnotify, dopeNotify}
Config.SyncInterval = 2 --How often the server updates the database for times left on players
Config.MaxPerCell = 4 --How many are allowed per cell! Would recommend leaving high
Config.MaxJail = 600 --Max amount someone can be intially jailed for

Config.ServerName = 'Servername' --Server name to show up on 2D text! If you want it to be blank leave it blank!

Config.PoliceNotifyTime = 5 --How long for police to know that someone escaped (in mins)
Config.PoliceRoles = { --All police roles so that they have access to search and use menu
    'police'
}
Config.PoliceRanks = { --All ranks for being able to use certain things on menu
    Jailing = {
        {Job = 'police', Grade = 1}
    },
    UnJail = {
        {Job = 'police', Grade = 4}
    },
    AddTime = {
        {Job = 'police', Grade = 2}
    },
    RemoveTime = {
        {Job = 'police', Grade = 4}
    },
    Send2Solitary = {
        {Job = 'police', Grade = 3}
    },
    RemoveFromSolitary = {
        {Job = 'police', Grade = 4}
    },
    Lockdown = {
        {Job = 'police', Grade = 2}
    },
    Message = {
        {Job = 'police', Grade = 1}
    }
}

Config.DefaultSetJob = {Name = 'unemployed', Grade = 0} --This is the default job that it will set if not saved somehow in database
Config.SimpleTime = false --This is if you wan the time to just be seconds, recommend leaving this to false

--General Configs
Config.SeeDist = 5 --How close you have to be to see 3D markers
Config.TextDist = 1 --How close you have to be to see 3D text
Config.TextLift = 0.3 --How much the 3D text is lifted over marker

Config.JailBlip = {Spawn = true, Sprite = 238, Color = 1, Size = 0.7} --All blip related things for the Prison Blip
Config.JailLoc = vector3(1702.8293457031, 2584.7778320312, 45.524826049805) --Location of the prison (usually center so that it doesn read wrong for checking location)
Config.TpBack = true --If players get tp'd back when they walk out of the jail without using script breakout (suggest to keep true)
Config.MaxTpDist = 250 --How far until it will tp you back
Config.MaxSolTpDist = 5 --How far you get from solitary before it tp's you back
Config.MaxMenuDist = 2 --How far you can walk before it auto closes your esx menu

Config.RanMessage = true --If it gives random notifactions for prisoners
Config.RanMessageTime = 5 --How often it sends a message (in mins)
--LockDown Configs
Config.StartLockCount = 60 --Starting time for lockdown (in seconds)
Config.WarnLockNums = {45, 30, 15, 10, 5, 4, 3, 2, 1} --All warning notifications for time on lockdown, make sure its within the number above

Config.LockDownDist = 4 --How far you can get from cell before it tp's you back or sends you to solitary

--Police Search Configs
Config.PoliceCanSearchInv = true --If police can search the inventories

Config.SeePoliceDist = 5 --How close you have to be to see 3D markers
Config.UsePoliceDist = 1 --How close you have to be to see 3D text
Config.PMarkNum = 22 --Marker Number
Config.PMarkColor = {r = 235, g = 116, b = 52} --Marker Colors
Config.PMarkSize = {x = 0.5, y = 0.5, z = 0.3} --Marker Size

--Usable Item Configs
Config.ShankWeapon = 'weapon_knife' --Weapon name for shank (don't change)
Config.ShankItem = true --If the shank/weapon is used in hotbar inventory
Config.ShankAllowed = true --If you can use the shank

Config.BoozeAllowed = true --If you can use the booze item
Config.BoozeEffect = true --If taking booze has an effect
Config.BoozeGive = 80000 --How much thirst gives for drinking booze (out of 1,000,000)
Config.BoozeProp = nil --Prop to be spawned while using item (leave nil if you want default cup)
Config.BoozeEffectTime = 30 --How long the effect lasts

Config.PunchAllowed = true --If you can use the punch item
Config.PunchGive = 100000 --How much thirst gives for drinking punch (out of 1,000,000)
Config.PunchProp = nil --Prop to be spawned while using item (leave nil if you want default cup)

--Entering Guide
Config.HaveGuide = true --If there is a guide of the prison when they are first sent
Config.TimePer = 5 --How long per cam for guide (in seconds)

Config.PrisonCam = vector3(1845.1083984375, 2521.7490234375, 98.70295715332) --Position of the camera view 
Config.PrisonCamRot = {x = -35.0, y = 0.0, z = 90.0} --Rotation of the camera view 

Config.JobCam = vector3(1762.9641113281, 2490.5341796875, 45.740699768066) --Position of the camera view 
Config.JobCamRot = {x = 0.0, y = 0.0, z = 45.0} --Rotation of the camera view 

Config.SolCam = vector3(1653.9808349609, 2567.3181152344, 47.35973739624) --Position of the camera view (Only Will Show If Solitary Is On)
Config.SolCamRot = {x = -25.0, y = 0.0, z = 45.0} --Rotation of the camera view (Only Will Show If Solitary Is On)

Config.WorkOutCam = vector3(1747.7087402344, 2485.6455078125, 47.630657196045) --Position of the camera view (Only Will Show If WorkOut Is On)
Config.WorkOutCamRot = {x = 0.0, y = 0.0, z = 170.0} --Rotation of the camera view (Only Will Show If WorkOut Is On)

Config.ShowerCam = vector3(1747.7087402344, 2485.6455078125, 47.630657196045) --Position of the camera view (Only Will Show If Shower Is On)
Config.ShowerCamRot = {x = 0.0, y = 0.0, z = 0.0} --Rotation of the camera view (Only Will Show If Shower Is On)

Config.FoodCam = vector3(1780.7712402344, 2556.1508789062, 45.97308807373) --Position of the camera view 
Config.FoodCamRot = {x = 0.0, y = 0.0, z = 0.0} --Rotation of the camera view 

Config.HospitalCam = vector3(1772.5382080078, 2590.3508300781, 47.437080383301) --Position of the camera view (Only Will Show If Hospital Is On)
Config.HospitalCamRot = {x = -25.0, y = 0.0, z = 45.0} --Rotation of the camera view (Only Will Show If Hospital Is On)

Config.ItemCam = vector3(1840.4741210938, 2583.3911132812, 46.014289855957) --Position of the camera view (Only Will Show If There Is Items To Keep)
Config.ItemCamRot = {x = 0.0, y = 0.0, z = 180.0} --Rotation of the camera view (Only Will Show If There Is Items To Keep)

--Entering Prison Cutscene Configs (Don't touch this unless you know what you're doing!)
Config.GuardPed = 'csb_cop' --The ped that carries you in
Config.GuardSpawn = {Loc = vector3(405.60272216797, -1000.9990844727, -99.004028320312), Heading = 2.9} --Where the guard spawns
Config.HandCuffLoc = vector3(405.94161987305, -999.58270263672, -99.004028320312) --Where it spawns you
Config.ClothesLoc = {Loc = vector3(402.74792480469, -1000.0263671875, -99.004043579102), Heading = 183.02} --Where the gaurd carries you to
Config.ClothesProp = 'prop_cs_t_shirt_pile' --Prop that is in hands and on table
Config.ClothPropLoc = {Loc = vector3(402.36535644531, -1001.2421264648, -98.086471557617), Heading = 356.48} --Location of the prop spawn
Config.ComputerLoc = {Loc = vector3(401.48217773438, -1001.8327026367, -99.004035949707), Heading = 1.97} --Where the gaurd looks at his computer
Config.PointLoc = {Loc = vector3(402.08111572266, -1001.8852539062, -99.004035949707), Heading = 357.9} --Where the gaurd comes and points
Config.GrabLoc = {Loc = vector3(403.19427490234, -997.42065429688, -99.001533508301), Heading = 12.43} --Where the gaurd goes to grab the player after
Config.GrabTurnHead = 258.46 --Heading which faces the exit
Config.PedGrabHeading = 24.44 --Which heading you face when grabbed
Config.StopnLook = {Loc = vector3(403.37203979492, -1002.0308837891, -99.004119873047), Heading = 359.19} --Stop and go point for gaurd so they don't have issues
Config.StopnLook2 = 85.28 --Heading for second stop n go
Config.StopnTurn = {Loc = vector3(405.93243408203, -997.45745849609, -99.004119873047), Heading = 97.76} --Another stop n go poi
Config.Undressed = { --Undressed Player Outfit
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 15, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 21,
        ['pants_2']  = 0,   ['shoes_1']  = 34,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
        ['torso_1']  = 15,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 15,
        ['pants_2']  = 0,  ['shoes_1']  = 35,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}
Config.EnterLoc = vector3(402.86895751953, -996.55413818359, -99.00025177002) --Sign Location
Config.EnterHeadings = {Front = 178.32, Side = 264.63} --Both Sign Headings
Config.WalkLoc = vector3(406.04782104492, -997.09332275391, -99.004028320312) --Final walk to desination in the hallway

Config.Cam = vector3(402.91775512695, -1002.5331420898, -99.004035949707) --Position of the camera view
Config.CamRot = {x = 0.0, y = 0.0, z = 0.0} --Rotation of the camera view

Config.DontTakeGunUponEntry = { --All weapons that arn't taken upon entering jail

}
Config.DontTakeItemsUponEntry = { --These are all the items that don't get taken upon entering the jail (whitelisting items)
    'apple'
}
Config.DontGiveBackItems = { --These are all the items that it won't give back upon grabbing items when leaving (black listing items)
    'drugs'
}

Config.AlertServerUponJail = true --Whether a chat message is sent when jailed

--Leave Configs
Config.LeaveLoc = {Loc = vector3(1838.3707275391, 2585.6594238281, 46.014293670654), Heading = 267.82} --Leave spawn location with heading

Config.LMarkNum = 22 --Marker Num for picking up items
Config.LMarkColor = {r = 235, g = 116, b = 52} --Marker Color for picking up items
Config.LMarkSize = {x = 0.5, y = 0.5, z = 0.3} --Marker Size for picking up items
Config.ItemLoc = {Loc = vector3(1840.2237548828, 2579.3427734375, 46.014301300049), Heading = 182.62} --Location on where to pick up items
Config.ItemBlip = {Spawn = true, Sprite = 475, Color = 1, Size = 0.7} --Blip for picking up items
Config.ShowItemDist = 7 --Showing the 3d marker distance 
Config.ItemTextDist = 1 --Distance for showing 3dtext above marker
Config.RetreiveTime = 5 --How long it takes to grab items back (in seconds)

--Food Configs
Config.GetFoodLoc = {Loc = vector3(1781.326171875, 2558.8811035156, 45.673065185547), Heading = 353.93} --Where you grab food in prison
Config.FoodBlip = {Spawn = true, Sprite = 272, Color = 2, Size = 0.7} --Blip on map for grabbing food in prison
Config.GrabFoodTime = 5 --How long it takes to grab the food (in seconds)
Config.EatTime = 7 --How long it takes to eat the food (in seconds)

Config.FoodAmt = 100000 --How much Hunger is added to esx_status (out of 1,000,000)
Config.DrinkAmt = 100000 --How much Thirst is added to esx_status (out of 1,000,000)

Config.FoMarkNum = 29 --Marker Num for food
Config.FoMarkColor = {r = 46, g = 166, b = 25} --Marker Color for food
Config.FoMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Marker Size for food

--Break Configs
Config.BrMarkNum = 32 --Marker Num for breaking out in cell location
Config.BrMarkColor = {r = 227, g = 122, b = 16} --Marker Color for breaking out in cell location
Config.BrMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Marker Size for breaking out in cell location

--Inventory Configs
Config.InvBlip = {Spawn = true, Sprite = 587, Color = 29, Size = 0.7} --Blip for the under the bed inventory

Config.OpenCloseTime = 5 --How long it takes to open or close the inventory (in seconds)
Config.ChMarkNum = 21 --Marker Num for bed inventory
Config.ChMarkColor = {r = 16, g = 83, b = 227} --Marker Color for bed inventory
Config.ChMarkSize = {x = 0.5, y = 0.5, z = 0.3} --Marker Size for bed inventory


--Crafting Configs
Config.Crafts = { --All things that can be crafted with Old Man
    [1] = {
        Name = "Shank", --Name in menu of item
        Time = 20, --How long it takes to craft
        MakeItem = 'Shank', --The item name in DB of what is given
        Descripe = "You can use this for self defense!", --The description of this item
        Needed = { --These are all the needed items to make the item above
            [1] = {
                Name = "Broken Spoon", --Name of needed item
                Amount = 1, --How many needed
                Item = 'jspoon' --Name in db of item thats needed
            },
            [2] = {
                Name = "Change",
                Amount = 2,
                Item = 'sChange'
            }
        }
    },
    [2] = {
        Name = "Broken Spoon",
        Time = 8,
        MakeItem = 'jspoon',
        Descripe = "You can use this for breaking out or for more crafting!",
        Needed = {
            [1] = {
                Name = "Spoon",
                Amount = 1,
                Item = 'spoon'
            }
        }
    },
    [3] = {
        Name = "Broken Spoon With Wet Cloth",
        Time = 5,
        MakeItem = 'bCloth',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Broken Spoon",
                Amount = 1,
                Item = 'jspoon'
            },
            [2] = {
                Name = "Wet Cloth",
                Amount = 1,
                Item = 'wCloth'
            }
        }
    },
    [4] = {
        Name = "Wet Cloth",
        Time = 10,
        MakeItem = 'wCloth',
        Descripe = "You can use this for more crafting!",
        Needed = {
            [1] = {
                Name = "Cleaner",
                Amount = 1,
                Item = 'cleaner'
            },
            [2] = {
                Name = "Cloth",
                Amount = 1,
                Item = 'cloth'
            }
        }
    },
    [5] = {
        Name = "File",
        Time = 20,
        MakeItem = 'file',
        Descripe = "You can use this for breaking out or more crafting!",
        Needed = {
            [1] = {
                Name = "Rock",
                Amount = 2,
                Item = 'rock'
            },
            [2] = {
                Name = "Broken Ladle",
                Amount = 1,
                Item = 'bLadle'
            }
        }
    },
    [6] = {
        Name = "Broken Ladle",
        Time = 5,
        MakeItem = 'bLadle',
        Descripe = "You can use this for more crafting!",
        Needed = {
            [1] = {
                Name = "Ladle",
                Amount = 1,
                Item = 'ladle'
            }
        }
    },
    [7] = {
        Name = "Sharp Metal",
        Time = 20,
        MakeItem = 'sMetal',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Metal",
                Amount = 1,
                Item = 'metal'
            },
            [2] = {
                Name = "Rock",
                Amount = 2,
                Item = 'rock'
            },
            [3] = {
                Name = "File",
                Amount = 1,
                Item = 'file'
            }
        }
    },
    [8] = {
        Name = "Acid",
        Time = 30,
        MakeItem = 'acid',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Bottle",
                Amount = 1,
                Item = 'bottle'
            },
            [2] = {
                Name = "Grease",
                Amount = 3,
                Item = 'grease'
            },
            [3] = {
                Name = "Dirty Liquid",
                Amount = 1,
                Item = 'dLiquid'
            },
            [4] = {
                Name = "Cleaner",
                Amount = 1,
                Item = 'cleaner'
            },
            [5] = {
                Name = "Spoon",
                Amount = 1,
                Item = 'spoon'
            }
        }
    },
    [9] = {
        Name = "Mini Hammer",
        Time = 25,
        MakeItem = 'miniH',
        Descripe = "You can use this for breaking out!",
        Needed = {
            [1] = {
                Name = "Metal",
                Amount = 1,
                Item = 'metal'
            },
            [2] = {
                Name = "Rock",
                Amount = 1,
                Item = 'rock'
            },
            [3] = {
                Name = "Ladle",
                Amount = 1,
                Item = 'ladle'
            },
            [4] = {
                Name = "Cloth",
                Amount = 1,
                Item = 'cloth'
            }
        }
    },
    [10] = {
        Name = "Prison Punch",
        Time = 10,
        MakeItem = 'pPunch',
        Descripe = "You can use this to tend to your thirst!",
        Needed = {
            [1] = {
                Name = "Dirty Liquid",
                Amount = 1,
                Item = 'dLiquid'
            },
            [2] = {
                Name = "Flavor Packet",
                Amount = 3,
                Item = 'fPacket'
            },
            [3] = {
                Name = "Bottle",
                Amount = 1,
                Item = 'bottle'
            }
        }
    },
    [11] = {
        Name = "Immersion Heater",
        Time = 25,
        MakeItem = 'iHeat',
        Descripe = "You can use this to distil alcohol!",
        Needed = {
            [1] = {
                Name = "Plug",
                Amount = 1,
                Item = 'plug'
            },
            [2] = {
                Name = "Spare Change",
                Amount = 2,
                Item = 'sChange'
            }
        }
    },
    [12] = {
        Name = "Booze",
        Time = 15,
        MakeItem = 'booze',
        Descripe = "You can use this to get drunk!",
        Needed = {
            [1] = {
                Name = "Immersion Heater",
                Amount = 1,
                Item = 'iHeat'
            },
            [2] = {
                Name = "Prison Punch",
                Amount = 1,
                Item = 'pPunch'
            }
        }
    }
}

--Information Configs (Old Man Configs)
Config.InfoPed = 'csb_rashcosvki' --Model of the Old Man ped
Config.InfoPedChangeTime = 3 -- How long until the old man changes locations (in mins)
Config.InfoPedLoc = { --All the locations that the ped could be
    [1] = {Loc = vector3(1716.1424560547, 2526.4265136719, 45.56489944458), Heading = 181.72},
    [2] = {Loc = vector3(1717.8244628906, 2487.7265625, 45.564964294434), Heading = 12.84},
    [3] = {Loc = vector3(1791.0882568359, 2558.2438964844, 45.67308807373), Heading = 133.35},
    [4] = {Loc = vector3(1755.4329833984, 2474.6091308594, 45.740661621094), Heading = 333.23}
}
Config.InfoPedBlip = {Spawn = true, Sprite = 66, Color = 5, Size = 0.7} --All blip configs for the old man

Config.IMarkNum = 27 --Old man 3d marker num
Config.IMarkColor = {r = 227, g = 223, b = 16} --Old man 3d marker color
Config.IMarkSize = {x = 1.0, y = 1.0, z = 0.5} --Old man 3d marker size

--Job Manager Configs
Config.JobManLoc = {Loc = vector3(1760.7283935547, 2493.3891601562, 45.74068069458), Heading = 203.93} --Job manager ped location
Config.JobManBlip = {Spawn = true, Sprite = 468, Color = 50, Size = 0.7} --Job manager blip
Config.JobManPed = 's_m_m_prisguard_01' --Job manager ped

Config.JMMarkNum = 27 --Job manager 3d marker num
Config.JMMarkColor = {r = 255, g = 0, b = 255} --Job manager 3d marker color
Config.JMMarkSize = {x = 1.0, y = 1.0, z = 0.5} --Job manager 3d marker size

Config.SeeTaskMark = 5 --How close you have to be to see the 3d marker
Config.SeeTaskText = 0.8 --How close you have to be to do the task
Config.JobOptions = {
    [1] = {
        Name = "Cook",
        TimeRemove = 25,
        StealChance = 4,
        StealItems = {
            [1] = {Name = "Bottle", Item = 'bottle', Chance = 2},
            [2] = {Name = "Grease", Item = 'grease', Chance = 5},
            [3] = {Name = "Dirty Liquid", Item = 'dLiquid', Chance = 5},
            [4] = {Name = "Spoon", Item = 'spoon', Chance = 8},
            [5] = {Name = "Ladle", Item = 'ladle', Chance = 7},
            [6] = {Name = "Flavor Packet", Item = 'fPacket', Chance = 10}
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Pan",
                TaskLoc = {Loc = vector3(1777.892578125, 2563.3972167969, 45.673080444336), Heading = 80.78},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_copper_pan', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Start Cooker",
                TaskLoc = {Loc = vector3(1780.5457763672, 2564.2126464844, 45.673080444336), Heading = 351.55},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Grab Food",
                TaskLoc = {Loc = vector3(1786.4158935547, 2564.3146972656, 45.673080444336), Heading = 353.08},
                Anim = {Dict = 'mp_arresting', AnimName = 'a_uncuff'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'ng_proc_food_ornge1a', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Cook Food",
                TaskLoc = {Loc = vector3(1780.8120117188, 2564.2136230469, 45.673080444336), Heading = 359.29},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 20,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Grab Trays",
                TaskLoc = {Loc = vector3(1787.3264160156, 2561.5522460938, 45.673080444336), Heading = 271.05},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'ng_proc_food_burg02a', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Set Trays Down",
                TaskLoc = {Loc = vector3(1783.5938720703, 2560.744140625, 45.673080444336), Heading = 171.9},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Grab Cooked Food",
                TaskLoc = {Loc = vector3(1780.6555175781, 2564.2763671875, 45.673080444336), Heading = 355.99},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_copper_pan', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Set Cooked Food Down",
                TaskLoc = {Loc = vector3(1781.2731933594, 2560.783203125, 45.673080444336), Heading = 182.83},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    },
    [2] = {
        Name = "Trash Cleaner",
        TimeRemove = 25,
        StealChance = 3,
        StealItems = {
            [1] = {Name = "Bottle", Item = 'bottle', Chance = 2},
            [2] = {Name = "Rock", Item = 'rock', Chance = 5},
            [3] = {Name = "Broken Ladle", Item = 'bLadle', Chance = 3},
            [4] = {Name = "Metal", Item = 'metal', Chance = 4},
            [5] = {Name = "Broken Spoon", Item = 'jspoon', Chance = 6},
            [6] = {Name = "Spare Change", Item = 'sChange', Chance = 6},
            [7] = {Name = "Cloth", Item = 'cloth', Chance = 6},
            [8] = {Name = "Plug", Item = 'plug', Chance = 4}
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1704.4982910156, 2551.7905273438, 45.564895629883), Heading = 91.44},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1700.7912597656, 2555.5249023438, 45.56489944458), Heading = 188.0},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1719.0423583984, 2501.5693359375, 45.564853668213), Heading = 275.89},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Grab Trash",
                TaskLoc = {Loc = vector3(1719.6976318359, 2503.8447265625, 45.564853668213), Heading = 274.05},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'hei_prop_heist_binbag', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Drop Trash",
                TaskLoc = {Loc = vector3(1622.4766845703, 2615.7399902344, 45.564853668213), Heading = 192.76},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [9] = {
                TaskName = "Grab Empty Bags",
                TaskLoc = {Loc = vector3(1779.5200195312, 2545.5639648438, 45.673049926758), Heading = 95.18},
                Anim = {Dict = 'amb@prop_human_bum_bin@base', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [10] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1704.4982910156, 2551.7905273438, 45.564895629883), Heading = 91.44},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [11] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1700.7912597656, 2555.5249023438, 45.56489944458), Heading = 188.0},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [12] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1719.0423583984, 2501.5693359375, 45.564853668213), Heading = 275.89},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [13] = {
                TaskName = "Put Trash Bag In",
                TaskLoc = {Loc = vector3(1719.6976318359, 2503.8447265625, 45.564853668213), Heading = 274.05},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 167, g = 66, b = 245},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    },
    [3] = {
        Name = "Tray Cleaner",
        TimeRemove = 25,
        StealChance = 4,
        StealItems = {
            [1] = {Name = "Bottle", Item = 'bottle', Chance = 2},
            [2] = {Name = "Grease", Item = 'grease', Chance = 5},
            [3] = {Name = "Dirty Liquid", Item = 'dLiquid', Chance = 5},
            [4] = {Name = "Spoon", Item = 'spoon', Chance = 8},
            [5] = {Name = "Flavor Packet", Item = 'fPacket', Chance = 10}
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Tray",
                TaskLoc = {Loc = vector3(1781.5991210938, 2555.8354492188, 45.673080444336), Heading = 182.01},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_food_bs_tray_02', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Put In Sink",
                TaskLoc = {Loc = vector3(1778.3990478516, 2564.4326171875, 45.673080444336), Heading = 357.18},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Grab Tray",
                TaskLoc = {Loc = vector3(1780.7900390625, 2549.4860839844, 45.67308807373), Heading = 353.27},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_food_bs_tray_02', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Put In Sink",
                TaskLoc = {Loc = vector3(1778.3990478516, 2564.4326171875, 45.673080444336), Heading = 357.18},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Grab Tray",
                TaskLoc = {Loc = vector3(1787.3134765625, 2548.6909179688, 45.67308807373), Heading = 173.54},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_food_bs_tray_02', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Put In Sink",
                TaskLoc = {Loc = vector3(1778.3990478516, 2564.4326171875, 45.673080444336), Heading = 357.18},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Wash Trays",
                TaskLoc = {Loc = vector3(1778.3990478516, 2564.4326171875, 45.673080444336), Heading = 357.18},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_food_bs_tray_02', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Set Trays Down",
                TaskLoc = {Loc = vector3(1783.6007080078, 2560.7143554688, 45.673049926758), Heading = 173.87},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    },
    [4] = {
        Name = "Wall Cleaner",
        TimeRemove = 25,
        StealChance = 4,
        StealItems = {
            [1] = {Name = "Bottle", Item = 'bottle', Chance = 2},
            [2] = {Name = "Dirty Liquid", Item = 'dLiquid', Chance = 5},
            [3] = {Name = "Cleaner", Item = 'cleaner', Chance = 5}
        },
        Tasks = {
            [1] = {
                TaskName = "Grab Cleaner",
                TaskLoc = {Loc = vector3(1778.146484375, 2546.1821289062, 45.673091888428), Heading = 176.86},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [2] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1771.7099609375, 2497.0373535156, 45.740657806396), Heading = 304.25},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [3] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1773.87109375, 2493.15234375, 45.740657806396), Heading = 300.58},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [4] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1775.8498535156, 2489.8669433594, 45.740657806396), Heading = 302.28},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [5] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1752.3601074219, 2480.5798339844, 45.740669250488), Heading = 119.21},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [6] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1754.1047363281, 2477.3103027344, 49.690319061279), Heading = 121.47},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [7] = {
                TaskName = "Clean Spot",
                TaskLoc = {Loc = vector3(1750.1640625, 2483.8474121094, 49.690319061279), Heading = 115.98},
                Anim = {Dict = 'amb@world_human_maid_clean@', AnimName = 'base'},
                Time = 10,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 235, g = 116, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            },
            [8] = {
                TaskName = "Put Back Cleaner",
                TaskLoc = {Loc = vector3(1778.146484375, 2546.1821289062, 45.673091888428), Heading = 176.86},
                Anim = {Dict = 'mini@repair', AnimName = 'fixing_a_ped'},
                Time = 5,
                TBlip = {Spawn = true, Sprite = 162, Color = 46, Size = 0.7},
                MarkNum = 20,
                MarkColor = {r = 229, g = 235, b = 52},
                MarkSize = {x = 0.5, y = 0.5, z = 0.3},
                AttachItem = {Attach = true, Prop = 'prop_sponge_01', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}},
                CarryItem = {Attach = false, Prop = 'nil', Offsets = {First = 0.0, Second =  0.0, Third = -0.01, Four = 90.0, Five = 0.0, Six = 0.0}}
            }
        }
    }
}

--Uniform Configs
Config.Uniforms = { --The outfit for the uniforms
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 146, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 0,   ['pants_1']  = 5,
        ['pants_2']  = 7,   ['shoes_1']  = 6,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
        ['torso_1']  = 118,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 4,   ['pants_1']  = 4,
        ['pants_2']  = 5,  ['shoes_1']  = 16,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}

--Cell Configs
Config.Cells = { --All cells in the prison
    [1] = {
        SpawnLoc = {Loc = vector3(1767.8718261719, 2500.2575683594, 45.740673065186), Heading = 203.32}, --Spawning in location (usually the middle of cell)
        InvLoc = {Loc = vector3(1766.9310302734, 2500.6433105469, 45.740673065186), Heading = 114.99}, --Inventory location or Bed location
        BreakLoc = {Loc = vector3(1765.3460693359, 2501.6667480469, 45.740673065186), Heading = 33.03}, --Breaking out location 
        ExitLoc = {Loc = vector3(1792.7447509766, 2586.0417480469, 45.665006256104), Heading = 277.17} --Exit after crawling throug for breakout (usually on outside of building)
    },
    [2] = {
        SpawnLoc = {Loc = vector3(1764.5062255859, 2498.9411621094, 45.740673065186), Heading = 209.46},
        InvLoc = {Loc = vector3(1763.7933349609, 2498.890625, 45.740673065186), Heading = 121.75},
        BreakLoc = {Loc = vector3(1762.1844482422, 2499.92578125, 45.740673065186), Heading = 32.46},
        ExitLoc = {Loc = vector3(1792.7575683594, 2582.9362792969, 45.669316864014), Heading = 270.17}
    },
    [3] = {
        SpawnLoc = {Loc = vector3(1761.4002685547, 2496.8559570312, 45.740673065186), Heading = 209.4},
        InvLoc = {Loc = vector3(1760.6062011719, 2496.9904785156, 45.740673065186), Heading = 120.62},
        BreakLoc = {Loc = vector3(1760.9107666016, 2499.0793457031, 45.740673065186), Heading = 4.59},
        ExitLoc = {Loc = vector3(1792.9602050781, 2576.8312988281, 45.664994812012), Heading = 271.07}
    },
    [4] = {
        SpawnLoc = {Loc = vector3(1754.9996337891, 2493.5383300781, 45.740676879883), Heading = 210.37},
        InvLoc = {Loc = vector3(1754.4213867188, 2493.4118652344, 45.740676879883), Heading = 120.56},
        BreakLoc = {Loc = vector3(1753.9085693359, 2495.1262207031, 45.740676879883), Heading = 28.48},
        ExitLoc = {Loc = vector3(1792.7788085938, 2574.1337890625, 45.67181930542), Heading = 272.06}
    },
    [5] = {
        SpawnLoc = {Loc = vector3(1751.8713378906, 2491.6437988281, 45.740676879883), Heading = 208.98},
        InvLoc = {Loc = vector3(1751.2376708984, 2491.5583496094, 45.740676879883), Heading = 121.94},
        BreakLoc = {Loc = vector3(1750.2940673828, 2493.044921875, 45.740676879883), Heading = 31.55},
        ExitLoc = {Loc = vector3(1758.7697753906, 2568.9208984375, 45.670770263672), Heading = 179.05}
    },
    [6] = {
        SpawnLoc = {Loc = vector3(1748.7263183594, 2489.6721191406, 45.740676879883), Heading = 211.51},
        InvLoc = {Loc = vector3(1748.0694580078, 2489.6850585938, 45.740676879883), Heading = 120.5},
        BreakLoc = {Loc = vector3(1748.3312988281, 2491.8117675781, 45.740676879883), Heading = 4.15},
        ExitLoc = {Loc = vector3(1753.0543212891, 2566.626953125, 45.665174102783), Heading = 219.48}
    },
    [7] = {
        SpawnLoc = {Loc = vector3(1767.6938476562, 2500.7824707031, 49.693054199219), Heading = 208.61},
        InvLoc = {Loc = vector3(1766.9036865234, 2500.6447753906, 49.693054199219), Heading = 119.63},
        BreakLoc = {Loc = vector3(1767.1446533203, 2502.67578125, 49.693054199219), Heading = 22.38},
        ExitLoc = {Loc = vector3(1722.1971435547, 2598.5705566406, 45.664910888672), Heading = 85.51}
    },
    [8] = {
        SpawnLoc = {Loc = vector3(1764.5076904297, 2498.935546875, 49.693054199219), Heading = 208.88},
        InvLoc = {Loc = vector3(1763.7937011719, 2498.7409667969, 49.693054199219), Heading = 119.74},
        BreakLoc = {Loc = vector3(1764.1223144531, 2500.8439941406, 49.693054199219), Heading = 15.52},
        ExitLoc = {Loc = vector3(1758.4462890625, 2589.9626464844, 45.672082519531), Heading = 82.03}
    },
    [9] = {
        SpawnLoc = {Loc = vector3(1761.3359375, 2497.1242675781, 49.693054199219), Heading = 206.53},
        InvLoc = {Loc = vector3(1760.7202148438, 2496.9821777344, 49.693054199219), Heading = 115.78},
        BreakLoc = {Loc = vector3(1759.6845703125, 2498.4396972656, 49.693073272705), Heading = 40.71},
        ExitLoc = {Loc = vector3(1787.9368896484, 2621.6682128906, 55.568738555908), Heading = 353.32}
    },
    [10] = {
        SpawnLoc = {Loc = vector3(1758.2523193359, 2495.228515625, 49.693050384521), Heading = 210.6},
        InvLoc = {Loc = vector3(1757.6192626953, 2495.0617675781, 49.693050384521), Heading = 117.17},
        BreakLoc = {Loc = vector3(1756.6911621094, 2496.751953125, 49.693050384521), Heading = 28.2},
        ExitLoc = {Loc = vector3(1793.4119873047, 2597.4797363281, 50.549686431885), Heading = 271.54}
    },
    [11] = {
        SpawnLoc = {Loc = vector3(1755.2034912109, 2493.4658203125, 49.693054199219), Heading = 205.01},
        InvLoc = {Loc = vector3(1754.4888916016, 2493.2265625, 49.693054199219), Heading = 119.78},
        BreakLoc = {Loc = vector3(1752.7800292969, 2494.3869628906, 49.693054199219), Heading = 35.15},
        ExitLoc = {Loc = vector3(1792.5063476562, 2590.3471679688, 50.549644470215), Heading = 259.79}
    },
    [12] = {
        SpawnLoc = {Loc = vector3(1751.8504638672, 2491.5363769531, 49.693058013916), Heading = 208.11},
        InvLoc = {Loc = vector3(1751.3817138672, 2491.3540039062, 49.693058013916), Heading = 119.52},
        BreakLoc = {Loc = vector3(1749.6419677734, 2492.6877441406, 49.693058013916), Heading = 23.54},
        ExitLoc = {Loc = vector3(1792.3619384766, 2589.2690429688, 50.549682617188), Heading = 280.44}
    },
    [13] = {
        SpawnLoc = {Loc = vector3(1748.6665039062, 2490.1772460938, 49.693050384521), Heading = 207.05},
        InvLoc = {Loc = vector3(1748.1062011719, 2489.7622070312, 49.693050384521), Heading = 123.41},
        BreakLoc = {Loc = vector3(1748.3289794922, 2491.8100585938, 49.693050384521), Heading = 13.81},
        ExitLoc = {Loc = vector3(1792.3813476562, 2586.5346679688, 50.54967880249), Heading = 266.62}
    },
    [14] = {
        SpawnLoc = {Loc = vector3(1758.4401855469, 2472.5861816406, 45.740692138672), Heading = 29.94},
        InvLoc = {Loc = vector3(1758.9227294922, 2472.740234375, 45.740692138672), Heading = 305.52},
        BreakLoc = {Loc = vector3(1759.8782958984, 2471.3757324219, 45.740692138672), Heading = 209.42},
        ExitLoc = {Loc = vector3(1792.3929443359, 2582.7661132812, 50.549682617188), Heading = 267.4}
    },
    [15] = {
        SpawnLoc = {Loc = vector3(1761.4652099609, 2474.4931640625, 45.740692138672), Heading = 29.25},
        InvLoc = {Loc = vector3(1761.9697265625, 2474.7185058594, 45.740692138672), Heading = 303.55},
        BreakLoc = {Loc = vector3(1761.7722167969, 2472.5825195312, 45.740692138672), Heading = 194.33},
        ExitLoc = {Loc = vector3(1792.3698730469, 2577.6137695312, 50.54967880249), Heading = 248.78}
    },
    [16] = {
        SpawnLoc = {Loc = vector3(1764.6083984375, 2476.3559570312, 45.740676879883), Heading = 26.58},
        InvLoc = {Loc = vector3(1765.1470947266, 2476.4558105469, 45.740676879883), Heading = 301.22},
        BreakLoc = {Loc = vector3(1766.7583007812, 2475.3459472656, 45.740676879883), Heading = 210.04},
        ExitLoc = {Loc = vector3(1792.3802490234, 2573.1860351562, 50.549674987793), Heading = 267.48}
    },
    [17] = {
        SpawnLoc = {Loc = vector3(1767.8315429688, 2478.0419921875, 45.740676879883), Heading = 27.52},
        InvLoc = {Loc = vector3(1768.4107666016, 2478.2338867188, 45.740676879883), Heading = 302.47},
        BreakLoc = {Loc = vector3(1768.8189697266, 2476.4736328125, 45.740676879883), Heading = 207.23},
        ExitLoc = {Loc = vector3(1786.3596191406, 2566.0595703125, 50.655014038086), Heading = 170.67}
    },
    [18] = {
        SpawnLoc = {Loc = vector3(1770.9608154297, 2480.0043945312, 45.740688323975), Heading = 28.47},
        InvLoc = {Loc = vector3(1771.4709472656, 2480.1728515625, 45.740688323975), Heading = 299.49},
        BreakLoc = {Loc = vector3(1772.8822021484, 2478.8259277344, 45.740688323975), Heading = 210.0},
        ExitLoc = {Loc = vector3(1781.01171875, 2566.0622558594, 50.653945922852), Heading = 170.54}
    },
    [19] = {
        SpawnLoc = {Loc = vector3(1774.0610351562, 2481.7414550781, 45.740673065186), Heading = 29.14},
        InvLoc = {Loc = vector3(1774.6887207031, 2481.8264160156, 45.740673065186), Heading = 302.06},
        BreakLoc = {Loc = vector3(1774.4154052734, 2479.7685546875, 45.740673065186), Heading = 195.82},
        ExitLoc = {Loc = vector3(1778.8533935547, 2566.0939941406, 50.654499053955), Heading = 182.02}
    },
    [20] = {
        SpawnLoc = {Loc = vector3(1777.3656005859, 2483.4807128906, 45.740684509277), Heading = 24.65},
        InvLoc = {Loc = vector3(1777.7369384766, 2483.8627929688, 45.740684509277), Heading = 299.03},
        BreakLoc = {Loc = vector3(1778.5122070312, 2482.1279296875, 45.740684509277), Heading = 210.96},
        ExitLoc = {Loc = vector3(1773.5793457031, 2566.2719726562, 50.549644470215), Heading = 173.38}
    },
    [21] = {
        SpawnLoc = {Loc = vector3(1758.4194335938, 2472.4934082031, 49.693042755127), Heading = 25.24},
        InvLoc = {Loc = vector3(1758.9002685547, 2472.7790527344, 49.693042755127), Heading = 310.37},
        BreakLoc = {Loc = vector3(1758.7806396484, 2470.6794433594, 49.693042755127), Heading = 205.23},
        ExitLoc = {Loc = vector3(1762.2921142578, 2568.4255371094, 55.439956665039), Heading = 96.7}
    },
    [22] = {
        SpawnLoc = {Loc = vector3(1761.4099121094, 2474.4533691406, 49.693050384521), Heading = 26.74},
        InvLoc = {Loc = vector3(1761.9937744141, 2474.6579589844, 49.693050384521), Heading = 302.63},
        BreakLoc = {Loc = vector3(1762.8979492188, 2473.107421875, 49.693050384521), Heading = 202.74},
        ExitLoc = {Loc = vector3(1759.328125, 2579.0798339844, 55.447151184082), Heading = 90.71}
    },
    [23] = {
        SpawnLoc = {Loc = vector3(1764.7454833984, 2476.1672363281, 49.693054199219), Heading = 27.45},
        InvLoc = {Loc = vector3(1765.1617431641, 2476.4187011719, 49.693054199219), Heading = 306.94},
        BreakLoc = {Loc = vector3(1765.4128417969, 2474.5676269531, 49.693054199219), Heading = 204.61},
        ExitLoc = {Loc = vector3(1759.5678710938, 2580.3923339844, 55.437309265137), Heading = 96.67}
    },
    [24] = {
        SpawnLoc = {Loc = vector3(1767.8469238281, 2477.9758300781, 49.693054199219), Heading = 28.02},
        InvLoc = {Loc = vector3(1768.3463134766, 2478.3410644531, 49.693054199219), Heading = 296.71},
        BreakLoc = {Loc = vector3(1768.1273193359, 2476.1379394531, 49.693054199219), Heading = 208.62},
        ExitLoc = {Loc = vector3(1759.5157470703, 2585.5126953125, 55.452182769775), Heading = 98.75}
    },
    [25] = {
        SpawnLoc = {Loc = vector3(1770.8740234375, 2479.841796875, 49.693054199219), Heading = 23.12},
        InvLoc = {Loc = vector3(1771.390625, 2480.1652832031, 49.693054199219), Heading = 305.29},
        BreakLoc = {Loc = vector3(1772.3399658203, 2478.5795898438, 49.693054199219), Heading = 207.37},
        ExitLoc = {Loc = vector3(1759.3814697266, 2589.8505859375, 55.438919067383), Heading = 92.57}
    },
    [26] = {
        SpawnLoc = {Loc = vector3(1774.2631835938, 2481.6071777344, 49.693054199219), Heading = 29.42},
        InvLoc = {Loc = vector3(1774.5646972656, 2481.9309082031, 49.693054199219), Heading = 307.62},
        BreakLoc = {Loc = vector3(1775.6508789062, 2480.4819335938, 49.693054199219), Heading = 213.24},
        ExitLoc = {Loc = vector3(1759.5305175781, 2594.8474121094, 55.43803024292), Heading = 98.24}
    },
    [27] = {
        SpawnLoc = {Loc = vector3(1777.2138671875, 2483.5002441406, 49.693054199219), Heading = 25.86},
        InvLoc = {Loc = vector3(1777.7836914062, 2483.6999511719, 49.693054199219), Heading = 303.78},
        BreakLoc = {Loc = vector3(1779.3515625, 2482.6164550781, 49.693054199219), Heading = 209.94},
        ExitLoc = {Loc = vector3(1759.4516601562, 2598.236328125, 55.44762802124), Heading = 89.31}
    }
}

--Solitary Configs
Config.Solitary = true --If you want there to be solitary or if you have solitary cells

Config.Sol4Run = true --If you want solitary for when they run away without using the jail script (ex. Using emotes to get through fences and other stuff)
Config.SolRunTime = 1 --Time in mins for the one above

Config.FailBreakToSol = true --If you want solitary for when they fail to breakout in time
Config.SolBreakTime = 1 --Time in mins for the one above

Config.Sol4Lock = false --If you want solitary for when they try to leave their cell on lockdown
Config.SolLockTime = 1 --Time in mins for the one above

Config.Sol4Kill = true --IF you want solitary for when you kill someone
Config.SolKillTime = 1 --Time in mins for the one above

Config.SolCells = { --All of the solitary locations
    [1] = {Loc = vector3(1651.3109130859, 2570.517578125, 45.564849853516), Heading = 358.7},
    [2] = {Loc = vector3(1642.8580322266, 2570.9304199219, 45.56485748291), Heading = 356.09},
    [3] = {Loc = vector3(1628.7922363281, 2570.3327636719, 45.56485748291), Heading = 337.41}
}

--Revive Configs
Config.Hospital = true --If you want the hospital
Config.DoctorPed = 's_m_m_doctor_01' --Doctor ped for the hospital
Config.CheckUpTime = 10 --How long it takes to checkup a prisoner (in secs)
Config.BedLocs = {
    [1] = {
        SpawnLoc = {Loc = vector3(1777.4617919922, 2565.4919433594, 46.722312927246), Heading = 268.2}, --Ped Spawn location
        DoctorSpawn = {Loc = vector3(1767.2258300781, 2598.5749511719, 45.729839324951), Heading = 358.14}, --Doctor spawn location
        DocCheck = {Loc = vector3(1770.5090332031, 2597.9077148438, 45.729793548584), Heading = 265.93}, --Where the doctor walks to, to check up
        DocWalkTime = 4 --How long it should take the doctor to walk there (in secs)
    },
    [2] = {
        SpawnLoc = {Loc = vector3(1771.8907470703, 2595.0358886719, 46.65856552124), Heading = 87.45},
        DoctorSpawn = {Loc = vector3(1767.2258300781, 2598.5749511719, 45.729839324951), Heading = 358.14},
        DocCheck = {Loc = vector3(1770.0236816406, 2594.7294921875, 45.729797363281), Heading = 266.02},
        DocWalkTime = 5
    },
    [3] = {
        SpawnLoc = {Loc = vector3(1772.0306396484, 2591.8979492188, 46.658573150635), Heading = 87.49},
        DoctorSpawn = {Loc = vector3(1767.2258300781, 2598.5749511719, 45.729839324951), Heading = 358.14},
        DocCheck = {Loc = vector3(1770.5025634766, 2591.775390625, 45.729804992676), Heading = 265.59},
        DocWalkTime = 6
    },
    [4] = {
        SpawnLoc = {Loc = vector3(1761.8626708984, 2597.5595703125, 46.658550262451), Heading = 272.06},
        DoctorSpawn = {Loc = vector3(1767.2258300781, 2598.5749511719, 45.729839324951), Heading = 358.14},
        DocCheck = {Loc = vector3(1763.8330078125, 2597.7548828125, 45.729824066162), Heading = 82.19},
        DocWalkTime = 4
    },
    [5] = {
        SpawnLoc = {Loc = vector3(1761.9383544922, 2594.5578613281, 46.65856552124), Heading = 267.01},
        DoctorSpawn = {Loc = vector3(1767.2258300781, 2598.5749511719, 45.729839324951), Heading = 358.14},
        DocCheck = {Loc = vector3(1763.4051513672, 2594.6535644531, 45.729804992676), Heading = 86.38},
        DocWalkTime = 5
    },
    [6] = {
        SpawnLoc = {Loc = vector3(1761.8590087891, 2591.3845214844, 46.658531188965), Heading = 268.7},
        DoctorSpawn = {Loc = vector3(1767.2258300781, 2598.5749511719, 45.729839324951), Heading = 358.14},
        DocCheck = {Loc = vector3(1763.3443603516, 2591.55859375, 45.729801177979), Heading = 87.35},
        DocWalkTime = 6
    }
}

--All Breaking Out Configs
Config.Breakout = true --If prisoners can breakout of the prison
Config.BreakHole = 5 --How many successful digs they need

Config.CrawlTime = 15 --How long it takes to crawl through the wall (in secs)
Config.BreakoutTime = 120  --How long they are able to breakout before being caught (in seconds)

Config.BreakMarkNum = 22 --Breakout marker num
Config.BreakMarkColor = {r = 255, g = 255, b = 255} --Breakout marker color
Config.BreakMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Breakout marker size

Config.SeeBreakDist = 15 --How close you have to be to see the markers
Config.BreakTextDist = 1 --How close you have to be to use
Config.BreakBlips = {Spawn = true, Sprite = 186, Color = 49, Size = 0.5} --Blips for all breakout / cutting locations

Config.BreakLocs = { --All cutting / digging locations when breaking out (StartLoc is the location to do the anim and the marker, ExitLoc is where they are tp'd, ExitFence is only true if its the last exit before they are completely out of the prison)
    [1] = {StartLoc = {Loc = vector3(1806.3610839844, 2531.4916992188, 45.506214141846), Heading = 288.92}, ExitLoc = {Loc = vector3(1807.9256591797, 2531.9982910156, 45.506652832031), Heading = 285.75}, ExitFence = false}, 
    [2] = {StartLoc = {Loc = vector3(1809.7244873047, 2508.5112304688, 45.457614898682), Heading = 283.54}, ExitLoc = {Loc = vector3(1811.3291015625, 2508.8952636719, 45.457614898682), Heading = 283.48}, ExitFence = false},
    [3] = {StartLoc = {Loc = vector3(1790.8776855469, 2457.107421875, 45.479621887207), Heading = 234.54}, ExitLoc = {Loc = vector3(1792.2528076172, 2456.1962890625, 45.479621887207), Heading = 287.84}, ExitFence = false},
    [4] = {StartLoc = {Loc = vector3(1775.9188232422, 2441.3542480469, 45.439235687256), Heading = 233.33}, ExitLoc = {Loc = vector3(1777.6038818359, 2440.0998535156, 45.439235687256), Heading = 283.33}, ExitFence = false},
    [5] = {StartLoc = {Loc = vector3(1724.5666503906, 2417.2282714844, 45.438968658447), Heading = 190.83}, ExitLoc = {Loc = vector3(1724.9614257812, 2415.1672363281, 45.438968658447), Heading = 190.83}, ExitFence = false},
    [6] = {StartLoc = {Loc = vector3(1691.9315185547, 2412.2934570312, 45.428443908691), Heading = 186.27}, ExitLoc = {Loc = vector3(1692.1114501953, 2410.6525878906, 45.428447723389), Heading = 186.27}, ExitFence = false},
    [7] = {StartLoc = {Loc = vector3(1624.4016113281, 2428.8767089844, 45.434959411621), Heading = 155.76}, ExitLoc = {Loc = vector3(1623.6633300781, 2427.2360839844, 45.433925628662), Heading = 155.76}, ExitFence = false},
    [8] = {StartLoc = {Loc = vector3(1580.7204589844, 2456.4575195312, 45.453197479248), Heading = 150.39}, ExitLoc = {Loc = vector3(1579.8312988281, 2454.8930664062, 45.451251983643), Heading = 150.39}, ExitFence = false},
    [9] = {StartLoc = {Loc = vector3(1551.0321044922, 2507.4912109375, 45.442741394043), Heading = 102.38}, ExitLoc = {Loc = vector3(1548.9813232422, 2507.0400390625, 45.442741394043), Heading = 102.38}, ExitFence = false},
    [10] = {StartLoc = {Loc = vector3(1549.2059326172, 2553.435546875, 45.448348999023), Heading = 94.47}, ExitLoc = {Loc = vector3(1547.4114990234, 2553.294921875, 45.448348999023), Heading = 94.47}, ExitFence = false},
    [11] = {StartLoc = {Loc = vector3(1555.7008056641, 2609.8635253906, 45.43217086792), Heading = 66.16}, ExitLoc = {Loc = vector3(1553.7633056641, 2610.4404296875, 45.431995391846), Heading = 74.34}, ExitFence = false},
    [12] = {StartLoc = {Loc = vector3(1570.4975585938, 2649.8615722656, 45.430034637451), Heading = 77.84}, ExitLoc = {Loc = vector3(1568.4450683594, 2650.3024902344, 45.430034637451), Heading = 77.84}, ExitFence = false},
    [13] = {StartLoc = {Loc = vector3(1598.7795410156, 2692.2275390625, 45.414165496826), Heading = 54.58}, ExitLoc = {Loc = vector3(1597.4354248047, 2693.18359375, 45.414165496826), Heading = 54.58}, ExitFence = false},
    [14] = {StartLoc = {Loc = vector3(1635.0993652344, 2727.2709960938, 45.431541442871), Heading = 57.41}, ExitLoc = {Loc = vector3(1633.7095947266, 2728.1599121094, 45.431541442871), Heading = 57.41}, ExitFence = false},
    [15] = {StartLoc = {Loc = vector3(1680.9978027344, 2748.4436035156, 45.513088226318), Heading = 14.11}, ExitLoc = {Loc = vector3(1680.5450439453, 2750.4870605469, 45.543704986572), Heading = 355.39}, ExitFence = false},
    [16] = {StartLoc = {Loc = vector3(1745.5191650391, 2750.9538574219, 45.542251586914), Heading = 2.11}, ExitLoc = {Loc = vector3(1745.4588623047, 2752.6025390625, 45.542247772217), Heading = 2.11}, ExitFence = false},
    [17] = {StartLoc = {Loc = vector3(1791.0699462891, 2734.2351074219, 45.404987335205), Heading = 322.09}, ExitLoc = {Loc = vector3(1792.2680664062, 2735.7744140625, 45.404987335205), Heading = 322.09}, ExitFence = false},
    [18] = {StartLoc = {Loc = vector3(1817.7440185547, 2712.5649414062, 45.476692199707), Heading = 324.15}, ExitLoc = {Loc = vector3(1819.060546875, 2714.388671875, 45.476692199707), Heading = 324.15}, ExitFence = false},
    [19] = {StartLoc = {Loc = vector3(1828.8676757812, 2674.0642089844, 45.486404418945), Heading = 256.23}, ExitLoc = {Loc = vector3(1831.4047851562, 2674.646484375, 45.354648590088), Heading = 258.15}, ExitFence = false},
    [20] = {StartLoc = {Loc = vector3(1818.7711181641, 2645.3774414062, 45.348693847656), Heading = 260.1}, ExitLoc = {Loc = vector3(1820.6928710938, 2645.041015625, 45.348693847656), Heading = 260.1}, ExitFence = false},
    [21] = {StartLoc = {Loc = vector3(1772.18359375, 2535.2783203125, 45.564914703369), Heading = 242.16}, ExitLoc = {Loc = vector3(1773.2451171875, 2534.7177734375, 45.564914703369), Heading = 242.16}, ExitFence = false},
    [22] = {StartLoc = {Loc = vector3(1723.4884033203, 2489.8776855469, 45.564838409424), Heading = 186.26}, ExitLoc = {Loc = vector3(1723.6029052734, 2488.8334960938, 45.564838409424), Heading = 186.26}, ExitFence = false},
    [23] = {StartLoc = {Loc = vector3(1662.0093994141, 2487.1945800781, 45.564903259277), Heading = 142.98}, ExitLoc = {Loc = vector3(1661.3770751953, 2486.35546875, 45.564903259277), Heading = 142.98}, ExitFence = false},
    [24] = {StartLoc = {Loc = vector3(1682.1802978516, 2679.4465332031, 45.564884185791), Heading = 18.41}, ExitLoc = {Loc = vector3(1681.7540283203, 2680.7275390625, 45.564884185791), Heading = 18.41}, ExitFence = false},
    [25] = {StartLoc = {Loc = vector3(1739.771484375, 2678.1396484375, 45.564884185791), Heading = 6.5}, ExitLoc = {Loc = vector3(1739.6357421875, 2679.3310546875, 45.564884185791), Heading = 6.5}, ExitFence = false},
    [26] = {StartLoc = {Loc = vector3(1816.478515625, 2527.4321289062, 43.414501190186), Heading = 285.83}, ExitLoc = {Loc = vector3(1817.9105224609, 2527.8410644531, 45.671981811523), Heading = 285.83}, ExitFence = true},
    [27] = {StartLoc = {Loc = vector3(1791.41796875, 2442.8901367188, 43.414661407471), Heading = 237.53}, ExitLoc = {Loc = vector3(1793.2797851562, 2442.3059082031, 45.378692626953), Heading = 234.75}, ExitFence = true},
    [28] = {StartLoc = {Loc = vector3(1706.1419677734, 2404.3161621094, 43.414566040039), Heading = 193.26}, ExitLoc = {Loc = vector3(1706.5561523438, 2402.623046875, 45.418384552002), Heading = 195.3}, ExitFence = true},
    [29] = {StartLoc = {Loc = vector3(1601.6594238281, 2431.8190917969, 43.414520263672), Heading = 151.75}, ExitLoc = {Loc = vector3(1600.7275390625, 2429.994140625, 45.46654510498), Heading = 154.19}, ExitFence = true},
    [30] = {StartLoc = {Loc = vector3(1539.9753417969, 2535.681640625, 43.411609649658), Heading = 94.72}, ExitLoc = {Loc = vector3(1537.3840332031, 2535.4677734375, 45.400444030762), Heading = 94.72}, ExitFence = true},
    [31] = {StartLoc = {Loc = vector3(1555.5706787109, 2638.220703125, 43.40873336792), Heading = 80.13}, ExitLoc = {Loc = vector3(1553.6495361328, 2638.5546875, 45.380565643311), Heading = 80.13}, ExitFence = true},
    [32] = {StartLoc = {Loc = vector3(1612.7268066406, 2719.677734375, 43.389865875244), Heading = 48.96}, ExitLoc = {Loc = vector3(1610.7020263672, 2721.3942871094, 45.390205383301), Heading = 49.79}, ExitFence = true},
    [33] = {StartLoc = {Loc = vector3(1722.103515625, 2759.9365234375, 43.389808654785), Heading = 5.83}, ExitLoc = {Loc = vector3(1721.8388671875, 2762.5234375, 45.469844818115), Heading = 5.83}, ExitFence = true},
    [34] = {StartLoc = {Loc = vector3(1811.4265136719, 2730.2138671875, 43.389869689941), Heading = 325.4}, ExitLoc = {Loc = vector3(1812.5876464844, 2731.9035644531, 45.41854095459), Heading = 324.84}, ExitFence = true},
    [35] = {StartLoc = {Loc = vector3(1832.2895507812, 2654.2846679688, 43.200504302979), Heading = 257.19}, ExitLoc = {Loc = vector3(11834.8247070312, 2653.7084960938, 45.467952728271), Heading = 257.19}, ExitFence = true}
}


Config.RoomTools = { --All the tools for cell and exit locations
    [1] = {
        Name = "Broken Spoon", --Name of the tool
        Item = 'jspoon', --DB item name of the tool
        Time = 10, --How long it takes to use
        Percent = 2 --Percentage chance of it working (ex. 2 = 20%)
    },
    [2] = {
        Name = "Broken Spoon With Wet Cloth",
        Item = 'bCloth',
        Time = 7,
        Percent = 5
    },
    [3] = {
        Name = "Sharp Metal",
        Item = 'sMetal',
        Time = 5,
        Percent = 8
    },
    [4] = {
        Name = "Acid",
        Item = 'acid',
        Time = 20,
        Percent = 8
    },
    [5] = {
        Name = "Mini Hammer",
        Item = 'miniH',
        Time = 25,
        Percent = 9
    }
}

Config.FenceTool = { --Tools for fences that are not exit locations
    [1] = {
        Name = "File", --Name of the tool
        Item = 'file', --DB name of the tool
        Time = 10, --How long it takes
        Percent = 4 --Percentage of it working (ex. 4 = 40%)
    },
    [2] = {
        Name = "Sharp Metal",
        Item = 'sMetal',
        Time = 4,
        Percent = 7
    },
    [3] = {
        Name = "Acid",
        Item = 'acid',
        Time = 20,
        Percent = 9
    },
    [4] = {
        Name = "Mini Hammer",
        Item = 'miniH',
        Time = 15,
        Percent = 7
    },
    [5] = {
        Name = "Immersion Heater",
        Item = 'iHeat',
        Time = 20,
        Percent = 9
    }
}


Config.WatchMarkNum = 1 --Watch tower marker num
Config.WatchMarkColor = {r = 255, g = 0, b = 0} --Color of watch tower marker

Config.WatchBlip = {Spawn = true, Sprite = 181, Color = 1, Size = 0.7} --Watch tower blip configs
Config.WatchDist = 20.0 --How big the circle is or how close you have to be
Config.MaxWatchDist = 150 --How far you have to get to fully escape
Config.SeeWatchDist = 75 --How close you have to be to see the 3d circle
Config.WatchTowers = { --All watch tower locations
    [1] = vector3(1823.9467773438, 2621.1137695312, 45.8014793396),
    [2] = vector3(1848.8317871094, 2699.4509277344, 45.8014793396),
    [3] = vector3(1773.2802734375, 2762.8894042969, 45.8014793396),
    [4] = vector3(1649.5051269531, 2758.0935058594, 45.8014793396),
    [5] = vector3(1569.8160400391, 2680.447265625, 45.8014793396),
    [6] = vector3(1534.6882324219, 2585.3349609375, 45.550983428955),
    [7] = vector3(1540.5181884766, 2469.6254882812, 45.550983428955),
    [8] = vector3(1658.923828125, 2394.5964355469, 45.550983428955),
    [9] = vector3(1761.4342041016, 2410.2609863281, 45.550983428955),
    [10] = vector3(1824.2727050781, 2475.5314941406, 45.550983428955),
    [11] = vector3(1822.5385742188, 2574.7231445312, 45.67200088501)
}

--Showering Configs
Config.Showers = false --If you want there to be showers in the prison
Config.ShowerLoc = {Loc = vector3(1762.8851318359, 2585.8771972656, 45.7978515625), Heading = 182.28} --Change location for the showers
Config.ShowerBlip = {Spawn = true, Sprite = 365, Color = 29, Size = 0.7} -- Blip configs for the shower

Config.ShowMarkNum = 21 --Shower 3d marker num
Config.ShowMarkColor = {r = 50, g = 109, b = 168} --Shower 3d marker color
Config.ShowMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Shower 3d marker size

Config.GetReadyTime = 5 --How long it takes to change
Config.ShowerFullDist = 7 --How close you have to be to see the 3d marker
Config.ShowerMarkerDist = 10 --How close you have to see intial marker
Config.ShowerDist = 1 --How close you have to be to use the shower
Config.MaxDistShower = 20 --How far you can get before it cancels the shower

Config.ShowerLocs = { --All shower locations
    [1] = vector3(1762.7790527344, 2584.0666503906, 45.797847747803),
    [2] = vector3(1762.7525634766, 2583.0002441406, 45.797847747803),
    [3] = vector3(1762.7590332031, 2581.9731445312, 45.797847747803),
    [4] = vector3(1762.6904296875, 2580.8610839844, 45.797847747803),
    [5] = vector3(1762.4088134766, 2579.8779296875, 45.797847747803),
    [6] = vector3(1764.2062988281, 2579.9309082031, 45.797847747803),
    [7] = vector3(1764.3111572266, 2581.0004882812, 45.797847747803),
    [8] = vector3(1764.3537597656, 2582.1296386719, 45.797847747803),
    [9] = vector3(1764.1920166016, 2583.0842285156, 45.797847747803),
    [10] = vector3(1764.1859130859, 2584.1840820312, 45.797847747803)
}

Config.ShowerFit = { --Shower outfit (should be a naked ped or ped with trousers on)
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 15, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 21,
        ['pants_2']  = 0,   ['shoes_1']  = 34,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
        ['torso_1']  = 15,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 15,
        ['pants_2']  = 0,  ['shoes_1']  = 35,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}

--Working Out
Config.WorkingOut = true --If you can workout in prison

Config.WorkOutBlip = {Spawn = true, Sprite = 354, Color = 1, Size = 0.7} --All blip configs for workout areas

Config.WoutMarkNum = 21 --Workout 3d Marker Nums
Config.WoutMarkColor = {r = 255, g = 0, b = 0} --Workout 3d Marker Colors
Config.WoutMarkSize = {x = 0.5, y = 0.5, z = 0.5} --Workout 3d Marker Size

Config.WorkoutLocs = { --All diffrent workout areas
    [1] = {
        StartLoc = {Loc = vector3(1749.0866699219, 2482.6984863281, 45.740661621094), Heading = 301.46}, --Starting location for changing in this area
        Locs = { --All workout locations in area (Label = Name of task, Loc = location of marker, Heading = direction you are facing, Anim.Dict = Animation Dictionary / Scenario, Anim.Aim = Animation thats played within that Dictionary(leave nil if scenario), Time = How long it plays anim (in secs))
            [1] = {Label = "Pullups", Loc = vector3(1746.5831298828, 2481.6899414062, 45.740665435791), Heading = 118.15, Anim = {Dict = 'PROP_HUMAN_MUSCLE_CHIN_UPS', Aim = nil}, Time = 10},
            [2] = {Label = "Pushups", Loc = vector3(1745.9583740234, 2483.3618164062, 45.740665435791), Heading = 29.58, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [3] = {Label = "Pushups", Loc = vector3(1748.1650390625, 2484.8806152344, 45.740665435791), Heading = 29.07, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [4] = {Label = "Yoga", Loc = vector3(1743.1531982422, 2480.8400878906, 45.759346008301), Heading = 120.85, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [5] = {Label = "Yoga", Loc = vector3(1743.9919433594, 2479.3266601562, 45.759338378906), Heading = 119.44, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [6] = {Label = "Yoga", Loc = vector3(1744.7452392578, 2477.9130859375, 45.759208679199), Heading = 117.14, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10}
        }
    },
    [2] = {
        StartLoc = {Loc = vector3(1645.4556884766, 2536.8881835938, 45.56489944458), Heading = 224.19},
        Locs = {
            [1] = {Label = "Pullups", Loc = vector3(1648.861328125, 2529.6850585938, 45.56489944458), Heading = 232.36, Anim = {Dict = 'PROP_HUMAN_MUSCLE_CHIN_UPS', Aim = nil}, Time = 10},
            [2] = {Label = "Pullups", Loc = vector3(1643.1571044922, 2527.9553222656, 45.56489944458), Heading = 230.56, Anim = {Dict = 'PROP_HUMAN_MUSCLE_CHIN_UPS', Aim = nil}, Time = 10},
            [3] = {Label = "Pushups", Loc = vector3(1645.3740234375, 2525.0317382812, 45.56489944458), Heading = 229.27, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [4] = {Label = "Pushups", Loc = vector3(1647.0649414062, 2527.0151367188, 45.56489944458), Heading = 229.75, Anim = {Dict = 'amb@world_human_push_ups@male@idle_a', Aim = 'idle_d'}, Time = 10},
            [5] = {Label = "Yoga", Loc = vector3(1639.0922851562, 2531.6369628906, 45.56489944458), Heading = 50.31, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [6] = {Label = "Yoga", Loc = vector3(1636.4968261719, 2528.7780761719, 45.56489944458), Heading = 50.95, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [7] = {Label = "Yoga", Loc = vector3(1641.2993164062, 2534.5576171875, 45.564907073975), Heading = 50.68, Anim = {Dict = 'WORLD_HUMAN_YOGA', Aim = nil}, Time = 10},
            [8] = {Label = "Situps", Loc = vector3(1635.4010009766, 2524.4096679688, 45.564907073975), Heading = 140.72, Anim = {Dict = 'amb@world_human_sit_ups@male@idle_a', Aim = 'idle_a'}, Time = 10},
            [9] = {Label = "Situps", Loc = vector3(1637.3043212891, 2522.7822265625, 45.564907073975), Heading = 140.01, Anim = {Dict = 'amb@world_human_sit_ups@male@idle_a', Aim = 'idle_a'}, Time = 10}
        }
    }
}

Config.SeeWorkDist = 7 --How close you have to be to see 3D marker
Config.WorkReadyTime = 5 --How long it takes to get ready for a workout (in secs)
Config.MaxDistWorkout = 10 --How far you have to be for it to auto cancel workout
Config.WorkText = 1 --How close you have to be to see work text
Config.WorkoutFit = { --Workout fit for female and male
    male = {
        ['tshirt_1'] = 15,  ['tshirt_2'] = 0,
        ['torso_1']  = 15, ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 42,
        ['pants_2']  = 2,   ['shoes_1']  = 6,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    },
    female = {
        ['tshirt_1'] = 15,   ['tshirt_2'] = 0,
        ['torso_1']  = 15,  ['torso_2']  = 0,
        ['decals_1'] = 0,   ['decals_2'] = 0,
        ['arms']     = 15,   ['pants_1']  = 2,
        ['pants_2']  = 0,  ['shoes_1']  = 16,
        ['shoes_2']  = 0,   ['mask_1']   = 0,
        ['mask_2']   = 0,   ['bproof_1'] = 0,
        ['bproof_2'] = 0,   ['chain_1']  = 0,
        ['chain_2']  = 0,   ['helmet_1'] = -1,
        ['helmet_2'] = 0,   ['glasses_1'] = 0,
        ['glasses_2'] = 0
    }
}


--All Sayings
Config.RanMessages = {
    [1] = "You smell! Go take a shower!",
    [2] = "You're lookin weak! Go workout!",
    [3] = "You're being lazy! Go do your job!"
}

Config.Sayings = { --All sayings in the whole script
    [1] = "Prison",
    [2] = "Doing Task",
    [3] = " ~y~Jail~w~ | Time Left:~r~ ",
    [4] = "(s) ~w~| Job =~o~ ",
    [5] = "You Are Being Sent To Jail",
    [6] = "None",
    [7] = "Judge ",
    [8] = " is being sentenced ",
    [9] = "Jail Job Manager",
    [10] = "Old Man",
    [11] = "Jail Item Retreival",
	[12] = "[~p~E~w~] Retreive Items",
    [13] = "Grabbing Belongings",
    [14] = "[~p~E~w~] Job Manager",
    [15] = "Available Jobs",
    [16] = "No Job",
    [17] = "Tasks: ",
    [18] = "Time Deduction: ",
    [19] = "Start Job",
    [20] = "You chose a job! Go do the tasks!",
    [21] = "(mins) in Bolingbroke Penitentiary | Reason: ",
    [22] = "[~y~E~w~] ",
    [23] = "Doing Task",
    [24] = "You completed a task! Go to the next task!",
    [25] = "You completed all the tasks! Your time was reduced and tasks reset!",
    [26] = "Task: ",
    [27] = "[~y~E~w~] Old Man",
    [28] = "[~o~E~w~] Start Digging",
    [29] = "[~b~E~w~] Lift Bed",
    [30] = "[~g~E~w~] Get Food",
    [31] = "Inventory",
    [32] = "Food Court",
    [33] = "No Items",
    [34] = "Under the Bed",
    [35] = "Lifting Bed",
    [36] = "Lowering Bed",
    [37] = "How many do you want to pull out?",
    [38] = "Invalid Amount/Message",
    [39] = "Amount is too much",
    [40] = "Remove Items",
    [41] = "Add Items",
    [42] = "How many would you like to add?",
    [43] = "Grabbing tray of food",
    [44] = "[~y~E~w~] Eat Food [~g~G~w~] Throw Away",
    [45] = "What would you like to talk about?",
    [46] = "Breaking out of here",
    [47] = "Making Items",
    [48] = "What were you looking to make?",
    [49] = "What about breaking out?",
    [50] = "What I need",
    [51] = "Make it",
    [52] = "Needed",
    [53] = " ~r~Solitary ~w~| Time Left: ~y~",
    [54] = "~w~(~r~s~w~)",
    [55] = "Jailing Info",
    [56] = "ID: ",
    [57] = "Time: ",
    [58] = "Time: None",
    [59] = "Reason",
    [60] = "Confirm",
    [61] = "Change ID For Jailing",
    [62] = "Jail Time is too long, above max Jail Time!",
    [63] = "Change Time Amount",
    [64] = "Reason For Jailing",
    [65] = "Edit Reason",
    [66] = "Confirm Reason",
    [67] = "See Reason",
    [68] = "Reason For Jail",
    [69] = "None",
    [70] = "The Doctor Is Checking You Up",
    [71] = "What would you like to know?",
    [72] = "Breaking Out Of Cell",
    [73] = "Breaking Through Fence 1",
    [74] = "Breaking Through Fence 2",
    [75] = "Description",
    [76] = "Tools that can be used",
    [77] = "You need a tool to dig through the wall! Once you make a hole you can climb through!",
    [78] = "You need a tool to cut through the fence! Once you cut through you can climb through!",
    [79] = "You need a tool to dig through the ground and wall! Once you make a hole you can crawl out!",
    [80] = "Time: ",
    [81] = "~w~(~y~s~w~)",
    [82] = "Success Percentage: ",
    [83] = "Missing Items To Craft",
    [84] = "Action Not Possible",
    [85] = "Crafting",
    [86] = "You stole a ",
    [87] = "What would you like to dig with?",
    [88] = "You do not have this item!",
    [89] = "[~o~E~w~] Break Out",
    [90] = "You your dig was successful",
    [91] = "Your tool broke",
    [92] = "You Are ~b~Breaking Out~w~! | Time Until Gaurds Notice:~o~ ",
    [93] = "[~g~E~w~] Cut Fence",
    [94] = "What would you like to cut with?",
    [95] = "You don't have this item!",
    [96] = "Digging",
    [97] = "Cutting",
    [98] = "Dig / Cut",
    [99] = "Watch Tower",
    [100] = "You have to successfully dig ",
    [101] = " times to go through the wall!",
    [102] = "You finished digging! Crawl through the hole to start your escape!",
    [103] = "That ID is not in jail!",
    [104] = "(s) was added to your sentence!",
    [105] = "Your reason is invalid",
    [106] = "Your ID is invalid",
    [107] = "Your time is invalid",
    [108] = "Failed To Break Out In Time",
    [109] = "Got To Far From Prison",
    [110] = "Killed Someone In Prison",
    [111] = "You walked too far away and the Menu Closed!",
    [112] = "Showers",
    [113] = "[~b~E~w~] Get Ready For Shower",
    [114] = "Changing Clothes",
    [115] = "Go to one of the showers",
    [116] = "[~b~G~w~] Shower",
    [117] = "Shower Cancelled! You walked to far away!",
    [118] = "Showering",
    [119] = "Working Out",
    [120] = "[~r~E~w~] Start Working Out",
    [121] = "You are working out! Go and use one of the machines or use the ground!",
    [122] = "[~r~G~w~] ",
    [123] = "Working Out",
    [124] = "Workout Cancelled! You walked to far away!",
    [125] = "Workout Ended",
    [126] = "[~r~E~w~] End Working Out",
    [127] = "Invalid ID",
    [128] = "Jail Someone",
    [129] = "UnJail Someone",
    [130] = "Add Time to Someone",
    [131] = "Remove Time from Someone",
    [132] = "Send Someone to Solitary",
    [133] = "Jail Options",
    [134] = "Enter ID of Player",
    [135] = "No Players Nearby",
    [136] = "Solitary Is Not Allowed",

    [137] = " ~y~Jail~w~ | Time:~r~ ",
    [138] = " | Job =~o~ ",
    [139] = "Eating",
    [140] = " was added to your sentence!",
    [141] = "Time is too much to remove!",
    [142] = " was removed from your sentence!",
    [143] = "(s) was removed from your sentence!",
    [144] = "Remove Someone From Solitary",
    [145] = "Lockdown: ",
    [146] = "On",
    [147] = "Off",
    [148] = "Can't Turn On/Off Lockdown, Currently Counting Down!",
    [149] = "(s) Until Lockdown! Get to Your Cell!",
    [150] = "Left Cell During Lockdown",
    [151] = "No Longer in LockDown",
    [152] = "You are now in LockDown!",
    [153] = "LockDown Started, Will be in Effect in ",
    [154] = "(s)!",
    [155] = "All Players In This Cell",
    [156] = " | ID: ",
    [157] = "'s Bed",
    [158] = "[~o~E~w~] Lift Bed",
    [159] = "Action Not Allowed",
    [160] = "Prison",
    [161] = "Crawling Through Hole",
    [162] = "Cant use!",
    [163] = "You drank some booze!",
    [164] = "You drank some punch!",
    [165] = "Notify All Prisoners",
    [166] = "What would you like to tell them?",
    [167] = "Can't confirm! Invalid reason!",
    [168] = "[Prison Intercom] : ",

    [169] = "In This Prison You Can",
    [170] = "~y~Work A Job To Get Time Removed",
    [171] = "~g~Grab Food To Eat",
    [172] = "~r~Get Sent To Solitary",
    [173] = "~o~Workout To Get Strong",
    [174] = "~b~Take Showers To Stay Clean",
    [175] = "~r~Get Help From A Doctor",
    [176] = "~y~Retrive Items Upon Release",
    [177] = "~g~Much More Hidden Things",
    [178] = " Is Not In Their Cell! They Escaped The Jail!"
}