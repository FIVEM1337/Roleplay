-- Problist https://gta-objects.xyz
-- Animlist https://wiki.gtanet.work/index.php?title=Animations

Config = {}

Config.HealUseTime = 10
Config.KevlarUseTime = 10
Config.RepairkitUseTime = 20

Config.Drinks = {
    'drink_beer',
    'drink_milkshake',
    'drink_rum', 
    'drink_shot1', 
    'drink_shot2', 
    'drink_shot3', 
    'drink_shot4', 
    'drink_shot5', 
    'drink_tequila', 
    'drink_water', 
    'drink_whiskey',
}

Config.Foods = {
    'food_burger',
    'food_chips',
    'food_donut',
    'food_hotdog',
    'food_mcrib',
    'food_sandwich',
    'food_taco',
}

Config.DrinkAnimations = {
    default = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_drink_whisky",
            propBone = 28422,
            propPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_milkshake = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_cs_milk_01",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_rum = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_rum_bottle",
            propBone = 28422,
            propPlacement = {0.01, -0.01, -0.16, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_shot1 = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_drink_whisky",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_shot2 = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_drink_whisky",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_shot3 = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_drink_whisky",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_shot4 = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_drink_whisky",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_shot5 = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_drink_whisky",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_tequila = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_tequila_bottle",
            propBone = 28422,
            propPlacement = {0.01, -0.01, -0.18, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_water = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_ld_flow_bottle",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_whiskey = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_drink_whisky",
            propBone = 28422,
            propPlacement = {0.01, -0.01, -0.06, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_beer = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "prop_amb_beer_bottle",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
    drink_coffee = {
        dict = "amb@world_human_drinking@coffee@male@idle_a",
        anim = "idle_a",
        duration = 5,
        props = {
            prop = "p_amb_coffeecup_01",
            propBone = 28422,
            propPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
        },
        status = {
            {status = 'thirst', value = '200000', dotype = 'add'},
        }
    },
}


Config.FoodAnimations = {
    default = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "prop_cs_burger_01",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
    food_burger = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "prop_cs_burger_01",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
    food_chips = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "ng_proc_food_chips01a",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
    food_donut = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "prop_amb_donut",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
    food_hotdog = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "prop_cs_hotdog_01",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
    food_mcrib = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "prop_food_bs_burger2",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
    food_sandwich = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "prop_sandwich_01",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
    food_taco = {
        dict = "mp_player_inteat@burger",
        anim = "mp_player_int_eat_burger",
        duration = 5,
        props = {
            prop = "prop_taco_01",
            propBone = 18905,
            propPlacement = {0.13, 0.05, 0.02, -50.0, 16.0, 60.0}
        },
        status = {
            {status = 'hunger', value = '200000', dotype = 'add'},
        }
    },
}