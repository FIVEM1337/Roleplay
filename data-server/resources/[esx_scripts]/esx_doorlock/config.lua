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

  Doors = {}
  
}

mLibs = exports["meta_libs"]