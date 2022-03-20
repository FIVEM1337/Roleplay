-- Problist https://gta-objects.xyz
-- Animlist https://wiki.gtanet.work/index.php?title=Animations

Config = {}

Config.Drinks = {
    'drink_water', 
    'drink_milkshake', 
    'drink_shot1', 
    'drink_shot2', 
    'drink_shot3', 
    'drink_shot4', 
    'drink_shot5', 
    'drink_tequila', 
    'drink_whiskey', 
    'drink_rum'
}

Config.Foods = {
    'food_bread', 
    'food_mcrib', 
    'food_sandwich', 
    'food_taco',
    'food_watermelon',
    
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
}