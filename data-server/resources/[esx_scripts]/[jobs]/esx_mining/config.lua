Config = {
    Prices = {
        -- ['item'] = {min, max} --
        ['steel'] = {40, 60},
        ['iron'] = {50, 70},
        ['copper'] = {60, 80},
        ['diamond'] = {100, 150},
        ['emerald'] = {100, 150}
    },
    ChanceToGetItem = 20, -- if math.random(0, 100) <= ChanceToGetItem then give item
    Items = {'steel','steel','steel','steel','iron', 'iron', 'iron', 'copper', 'copper', 'diamond', 'emerald'},
    Sell = vector3(-97.12, -1013.8, 26.3),
    Objects = {
        ['pickaxe'] = 'prop_tool_pickaxe',
    },
    MiningPositions = {
        {coords = vector3(2992.77, 2750.64, 42.78), heading = 209.29},
        {coords = vector3(2983.03, 2750.9, 42.02), heading = 214.08},
        {coords = vector3(2976.74, 2740.94, 43.63), heading = 246.21}
    },
}

Strings = {
    ['press_mine'] = 'Drücke ~INPUT_CONTEXT~ um abzubauen.',
    ['mining_info'] = 'Drücke ~INPUT_ATTACK~ um abzubauen, ~INPUT_FRONTEND_RRIGHT~ um aufzuhören.',
    ['you_sold'] = 'Du hast %sx %s für %s verkauft',
    ['e_sell'] = 'Drücke ~INPUT_CONTEXT~ to sell all your mined items.',
    ['someone_close'] = 'Ein Spieler ist zu nah bei dir!',
    ['mining'] = 'Bergwerk',
    ['sell_mine'] = 'Erz-ankauf'
}