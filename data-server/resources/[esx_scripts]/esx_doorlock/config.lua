TriggerEvent("esx:getSharedObject", function(obj) ESX = obj; end)

AuthorizedItems = {
--  keys_missionrow_pd_front    = "Mission Row Key (Front)",
--  keys_master_key_single_use  = "Master Key (Single Use)",
--  keys_master_key             = "Master Key",
}

-- Minigame Presets
Minigames = {
  ['Hacking'] = {
    item = 'hacking_laptop',
    options = {
      time        = {min = 10, max = 60, step = 2},
      letters     = {min = 02, max = 10, step = 1},
    }
  },
  ['Lockpick'] = {
    item = 'lockpick',
    options = {
      pins        = {min = 01, max = 10, step = 1},
    }
  },
  -- Uncomment minigames that you own/want to use.
  --[[
  ['LockpickV2'] = {
    item = 'lockpickv2'
  },
  ['Thermite'] = {
    item = 'thermite',
    options = {      
      difficulty   = {min = 0.1, max = 1.0, step = 0.1},
      speed_scale  = {min = 0.1, max = 2.0, step = 0.1},
      score_inc    = {min = 0.1, max = 1.0, step = 0.1},
    }
  },  
  ]]
}

-- Translate here.
Labels = {
  unlock            = "~r~Verschlossen~s~",
  lock              = "~g~Geöffnet~s~",
  do_unlock         = " ",
  do_lock           = " ",
  access_granted    = "~g~Zugriff gewährt.~s~",
  access_denied     = "~r~Zugriff verweigert.~s~",
  police_warning    = "Jemand versucht, bei %s einzubrechen. \nDrücke ~INPUT_PICKUP~ um GPS einzustellen."
}
   
Controls = {
  TextOffset = {
    ["height"] = {
      codes = {96,97},
      text = "Höhe -/+",
    },
    ["forward"] = {
      codes = {172,173},
      text = "Vorwärts/Rückwärts",
    },
    ["right"] = {
      codes = {174,175},
      text = "Rechts/Links",
    },
    ["done"] = {
      codes = {191},
      text = "Bestätigen",
    },
  },
}

Config = {  
  -- ESX bank account name.
  BankAccountName = "bank",

  -- Warn police when a minigame/break in attempt has failed?
  WarnPoliceOnFail = true,

  -- Warn police wehn a minigame/break in attempt has succeeded?
  WarnPoliceOnSuccess = true,

  -- How long should we give the police to react to said notification? (Seconds).
  PoliceNotifyTimer = 15,

  -- Jobs to notify with above interactions.
  PoliceJobs = {
    police  = {min_rank = 1},
    sheriff = {min_rank = 2},
  },

  -- These jobs can access any door that allows raid access.
  RaidAccess = {
    police   = {min_rank = 1},
    sheriff  = {min_rank = 2},
  },

  -- Chunking effects MS usage with lots of doors.
  Chunking = {
    -- The acceptable range for doors to be considered for primary chunk.
    -- Reduce range to reduce MS.
    range     = 50.0,

    -- Timer: the time between re-chunks.
    -- Increase timer to reduce MS but also reduce overall "responsiveness" of mod.
    timer     = 5000,

    -- Movement: distance before chunking is reconsidered (overwriting timer).
    -- Increase movement to reduce MS, but too a high a value may cause unforseen effects with player teleportation.
    movement  = 50.0,
  },

  Doors = {
    {
      -- Locked by default?
      locked = false,

      -- Can the door be unlocked/locked from inside vehicle?
      interact_in_veh = false,

      -- Distance to interact.
      dist = 2.5,

      -- Distance to render.
      draw = 5.0,

      -- Interact text location.
      text_loc = vector3(434.747,-982.000,31.00),

      -- Can jobs from RaidAccess table lock/unlock this door uninhibited?
      allow_raid = true,

      -- Jobs that can unlock this door.
      -- NOTE: No need to put RaidAccess jobs in here if allow_raid is set to true above.
      -- NOTE: I only put them in here for an example.
      auth_jobs = {
        police    = {min_rank = 0},
        mechanic  = {min_rank = 2},
      },

      -- Items that can unlock this door.
      auth_items = {
        keys_missionrow_pd_front    = {take_item = false},
        keys_master_key_single_use  = {take_item = true},
        keys_master_key             = {take_item = false},
      },

      -- Can this door be broken into?
      can_break = true,
      -- Items that can break this door.
      -- Key is item name, value is corresponding action.
      break_items = {
        lockpick        = {minigame = "Lockpick",   take_item = false, take_on_fail = true},
        hacking_laptop  = {minigame = "Hacking",    take_item = false, take_on_fail = true},
        --lockpickv2      = {minigame = "LockpickV2", take_item = false, take_on_fail = true},   -- Uncomment me if you have the thermite minigame and want to use it here.
        --thermite        = {minigame = "Thermite",   take_item = false, take_on_fail = false},  -- Uncomment me if you have the lockpicking v2 minigame and want to use it here.
      },

      -- Difficulty preset for hacking minigame on this door.
      -- NOTE: Only required if using hacking on this door.
      hacking_preset = {
        time    = 35,
        letters = 7,
      },

      -- Difficulty preset for lockpicking minigame on this door.
      -- NOTE: Only required if using lockpicking on this door.
      lockpick_preset = {
        pins = 4
      },

      -- Difficulty preset for thermite minigame on this door.
      -- NOTE: Only required if using thermite on this door.
      thermite_preset = {  
        difficulty        = 0.5,
        speed_scale       = 1.5,
        score_inc         = 0.5,
      },

      -- Door definitions
      objects = {
        -- Each door object held in its own table.
        {
          -- Reposition the door on lock? 
          -- I only used this on the large prison gates. Other large doors may need to be repositioned also.
          reposition = false,
          -- Specify the door objects model, location and target rotation while locked.
          door_model = GetHashKey('v_ilev_ph_door01'),
          door_loc   = vector3(434.747,-980.618,30.839),
          door_rot   = vector3(0.0,0.0,-90.0),
        },
        {
          reposition = false,
          door_model = GetHashKey('v_ilev_ph_door002'),
          door_loc   = vector3(434.747,-983.215,30.839),
          door_rot   = vector3(0.0,0.0,-90.0),
        },
      }
    },
    {
      locked = true,
      interact_in_veh = true,

      dist = 5.0,
      draw = 10.0,

      text_loc = vector3(1844.998,2608.50,46.00),

      allow_raid = true,
      auth_jobs = {
        police    = {min_rank = 0},
        mechanic  = {min_rank = 2},
      },

      auth_items = {
        keys_master_key_single_use  = {take_item = true},
        keys_master_key             = {take_item = false},
      },

      can_break = true,
      break_items = {
        lockpick        = {minigame = "Lockpick",   take_item = false, take_on_fail = true},
        hacking_laptop  = {minigame = "Hacking",    take_item = false, take_on_fail = true},
        --lockpickv2      = {minigame = "LockpickV2", take_item = false, take_on_fail = true},
        --thermite        = {minigame = "Thermite",   take_item = false, take_on_fail = false},
      },

      hacking_preset = {
        time    = 35,
        letters = 7,
      },

      lockpick_preset = {
        pins = 4
      },

      thermite_preset = {  
        difficulty        = 0.5,
        speed_scale       = 1.5,
        score_inc         = 0.5,
      },

      objects = {
        {
          reposition = true,
          door_model = GetHashKey('prop_gate_prison_01'),
          door_loc   = vector3(1844.998,2604.810,44.638),
          door_rot   = vector3(0.0,0.0,90.0),
        },
      }
    },
    {
      locked = true,
      interact_in_veh = true,

      dist = 5.0,
      draw = 10.0,

      text_loc = vector3(1818.542,2608.512,46.011),

      allow_raid = true,
      auth_jobs = {},

      auth_items = {
        keys_master_key_single_use  = {take_item = true},
        keys_master_key             = {take_item = false},
      },

      can_break = true,
      break_items = {
        lockpick        = {minigame = "Lockpick",   take_item = false, take_on_fail = true},
        hacking_laptop  = {minigame = "Hacking",    take_item = false, take_on_fail = true},
        --lockpickv2      = {minigame = "LockpickV2", take_item = false, take_on_fail = true},
        --thermite        = {minigame = "Thermite",   take_item = false, take_on_fail = false},
      },

      hacking_preset = {
        time    = 35,
        letters = 7,
      },

      lockpick_preset = {
        pins = 4
      },

      thermite_preset = {  
        difficulty        = 0.5,
        speed_scale       = 1.5,
        score_inc         = 0.5,
      },

      objects = {
        {
          reposition = true,
          door_model = GetHashKey('prop_gate_prison_01'),
          door_loc   = vector3(1818.542,2604.812,44.611),
          door_rot   = vector3(0.0,0.0,90.0),
        },
      }
    },
    {    

      dist = 5.0,
      draw = 10.0,  
      auth_jobs = {
        police = {min_rank = 4},
      },
      break_items = {
        lockpick = false,
        thermite = {minigame = 'Thermite',take_on_fail = false,take_item = false},
        hacking_laptop = false,
        lockpickv2 = false,
      },
      locked = true,
      thermite_preset = {
        score_inc = 1,
        difficulty = 0.5,
        speed_scale = 0.5,
      },
      interact_in_veh = true,
      text_loc = vector3(22.14923, 6433.033, 31.37436),
      can_break = true,
      objects = {
        [1] = {
          door_rot = vector3(0, 0, 44.99994),
          door_loc = vector3(22.14923, 6433.033, 30.41879),
          reposition = false,
          door_model = -2007495856,
        },
      },
      allow_raid = true,
    }
  }
}

mLibs = exports["meta_libs"]