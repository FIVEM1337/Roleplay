Config = Config or {}

Config.Menus = {
    ['empty'] = {
        title = '',
        options = {},
    },
    ['main'] = {
        title = '',
        options = {
            {label = 'Reparieren', img = 'img/icons/repair.png', price = 1000, onSelect = function() repairtVehicle(customVehicle) end},
            {label = 'Optik', img = 'img/icons/visual.png', openSubMenu = 'visual'},
            {label = 'Tuning', img = 'img/icons/upgrade.png', openSubMenu = 'upgrade'}
        },
        onBack = function() closeUI(1) end,
        defaultOption = 1
    },
        ['upgrade'] = {
            title = 'TUNNING',
            options = {
                {label = 'Motor', img = 'img/icons/engine.png', modType = 11, priceMult = {20.0, 40.0, 60.0, 90.0, 120.0, 180.0}},
                {label = 'Bremsen', img = 'img/icons/brakes.png', modType = 12, priceMult = {5.0, 15.0, 3.0, 4.0, 5.0}},
                {label = 'Getriebe', img = 'img/icons/transmission.png', modType = 13, priceMult = {5.0, 2.0, 3.0, 4.0, 5.0}},
                {label = 'Federung', img = 'img/icons/suspension.png', modType = 15, priceMult = {5.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0}},
                {label = 'Panzerung', img = 'img/icons/armor.png', modType = 16, priceMult = {5.0, 2.0, 0.0, 3.0, 4.0, 5.0, 6.0, 7.0}},
                {label = 'Turbo', img = 'img/icons/engine.png', modType = 18, priceMult = {40.0, 100.0}},
            },
            onBack = function() updateMenu('main') end
        },
        ['visual'] = {
            title = 'OPTIK',
            options = {
                {label = 'Karosserie', img = 'img/icons/body.png', openSubMenu = 'body_parts'},
                {label = 'Interior', img = 'img/icons/body.png', openSubMenu = 'inside_parts'},
                {label = 'Lackierung', img = 'img/icons/respray.png', openSubMenu = 'respray'},
                {label = 'Felgen / Reifen', img = 'img/icons/wheel.png', openSubMenu = 'wheels', onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', {x = -1.8, y = 0.0, z = 0.0}, {x = 0.0, y = 0.0, z = -20.0})
                end},
                {label = 'Kennzeichen', img = 'img/icons/plate.png', openSubMenu = 'plate'},
                {label = 'Beleuchtung', img = 'img/icons/headlights.png', openSubMenu = 'lights'},
                {label = 'Folierung', img = 'img/icons/respray.png', openSubMenu = 'stickers'},
                {label = 'Extras', img = 'img/icons/plus.png', modType = 'extras', priceMult = 2.0},
                {label = 'Scheibentönung', img = 'img/icons/door.png', modType = 'windowTint', priceMult = 1.12, onSelect = function()
                    moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'window_lf', {x = -2.0, y = 0.0, z = 0.0}, {x = 0.0, y = 0.0, z = -10.0})
                end, onSubBack = function()
                    SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                end},
                {label = 'Hupe', img = 'img/icons/horn.png', modType = 14, priceMult = 1.12},
                {label = 'Interior', img = 'img/icons/body.png', modType = 27, priceMult = 6.98},
                {label = 'Plaketten', img = '', modType = 35, priceMult = 4.19},
                {label = 'Lautsprecher', img = 'img/icons/speaker.png', modType = 36, priceMult = 6.98},
                {label = 'Kofferraum', img = 'img/icons/trunk.png', modType = 37, priceMult = 5.58, onSelect = function() openDoors(customVehicle, {0,0,0,0,0,1,1}) end},
                {label = 'Hydraulik', img = 'img/icons/hydrulics.png', modType = 38, priceMult = 5.12},
                {label = 'Motorblock', img = 'img/icons/engine_block.png', modType = 39, priceMult = 5.12, onSelect = function() openDoors(customVehicle, {0,0,0,0,1,0,0}) end},
                {label = 'Luftfilter', img = 'img/icons/air_filter.png', modType = 40, priceMult = 3.72},
                {label = 'Streben', img = 'img/icons/suspension.png', modType = 41, priceMult = 6.51},
                {label = 'Tank', img = 'img/icons/gas_tank.png', modType = 45, priceMult = 4.19},
            },
            onBack = function() updateMenu('main') end
        },
            ['body_parts'] = {
                title = 'KAROSSERIE',
                options = {
                    {label = 'Spoiler', img = 'img/icons/spoiler.png', modType = 0, priceMult = 2.65, onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'boot', {x = 0.0, y = -4.0, z = 1.5}, {x = -30.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Vordere Stoßstange', img = 'img/icons/bumper.png', modType = 1, priceMult = 2.12},
                    {label = 'Hintere Stoßstange', img = 'img/icons/bumper.png', modType = 2, priceMult = 2.12, onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'bumper_r', {x = 0.0, y = -4.0, z = 1.5}, {x = -30.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Seitenschweller', img = 'img/icons/bumper.png', modType = 3, priceMult = 2.65, onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'wheel_lf', {x = -2.5, y = 0.0, z = 0.0}, {x = 0.0, y = 0.0, z = -20.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Auspuff', img = 'img/icons/exhaust.png', modType = 4, priceMult = 2.12, onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'bumper_r', {x = 0.0, y = -4.0, z = 1.5}, {x = -30.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Käfig', img = 'img/icons/body.png', modType = 5, priceMult = 2.12, onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'interiorlight', {x = 0.0, y = 1.0, z = -0.1}, {x = 0.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Kählergrill', img = 'img/icons/body.png', modType = 6, priceMult = 2.72},
                    {label = 'Motorhaube', img = 'img/icons/hood.png', modType = 7, priceMult = 2.88},
                    {label = 'Linker Kotflügel', img = 'img/icons/bumper.png', modType = 8, priceMult = 2.12},
                    {label = 'Rechter Kotflügel', img = 'img/icons/bumper.png', modType = 9, priceMult = 2.12},
                    {label = 'Dach', img = 'img/icons/body.png', modType = 10, priceMult = 2.58},
                    {label = 'Arch Cover', img = 'img/icons/bumper.png', modType = 42, priceMult = 4.19},
                    {label = 'Antenne', img = '', modType = 43, priceMult = 1.12},
                    {label = 'Flügel', img = 'img/icons/bumper.png', modType = 44, priceMult = 6.05},
                    {label = 'Fenster', img = 'img/icons/door.png', modType = 46, priceMult = 1.0},
                },
                onBack = function() updateMenu('visual') end
            },
            ['inside_parts'] = {
                title = 'ITERIOR',
                options = {
                    {label = 'Armaturenbrett', img = 'img/icons/dashboard.png', modType = 29, priceMult = 4.65},
                    {label = 'Dial', img = 'img/icons/dashboard.png', modType = 30, priceMult = 4.19},
                    {label = 'Türlautsprecher', img = 'img/icons/speaker.png', modType = 31, priceMult = 5.58, onSelect = function() openDoors(customVehicle, {1,1,1,1,0,0,0}) end},
                    {label = 'Sitz', img = 'img/icons/seat.png', modType = 32, priceMult = 4.65},
                    {label = 'Lenkrad', img = 'img/icons/steering_wheel.png', modType = 33, priceMult = 4.19},
                    {label = 'Schalthebel', img = 'img/icons/shifter_leaver.png', modType = 34, priceMult = 3.26},
                    {label = 'Ornamente', img = '', modType = 28, priceMult = 0.9},
                },
                onBack = function() updateMenu('visual') end
            },
            ['respray'] = {
                title = 'LACKIERUNG',
                options = {
                    {label = 'Primär', img = 'img/icons/respray.png', modType = 'color1', customType = 'customColor', priceMult = 1.12, onSelect = function() openColorPicker('Primary Color', 'color1', true, 0.1) end},
                    {label = 'Sekundär', img = 'img/icons/respray.png', modType = 'color2', customType = 'customColor', priceMult = 0.66, onSelect = function() openColorPicker('Secondary Color', 'color2', true, 0.5) end},
                    {label = 'Primärer Farbtyp', img = 'img/icons/respray.png', modType = 'paintType1', priceMult = 0.5},
                    {label = 'Sekundärer Farbtyp', img = 'img/icons/respray.png', modType = 'paintType2', priceMult = 0.5},
                    {label = 'Perlglanz', img = 'img/icons/respray.png', modType = 'pearlescentColor', customType = 'color', priceMult = 0.88, onSelect = function() openColorPicker('Pearlescent Color', 'pearlescentColor', false, 0.5) end},
                },
                onBack = function() updateMenu('visual') end
            },
            ['wheels'] = {
                title = 'FELGEN & REIFEN',
                options = {
                    {label = 'Felgentyp', img = 'img/icons/wheel.png', onSelect = function() updateMenu('wheels_type') end},
                    {label = 'Felgenfarbe', img = 'img/icons/respray.png', modType = 'wheelColor', customType = 'color', priceMult = 0.66, onSelect = function() openColorPicker('Wheels Color', 'wheelColor', false, 0.5) end},
                    {label = 'Rauchfarbe', img = 'img/icons/respray.png', modType = 'tyreSmokeColor', customType = 'customColor', priceMult = 1.12, onSelect = function() openColorPicker('Tyre Smoke Color', 'tyreSmokeColor', true, 0.5) end},
                },
                onBack = function() updateMenu('visual') SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true) end
            },
                ['wheels_type'] = {
                    title = 'FELENTYPEN',
                    options = {
                        {label = 'Sport', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 0) end},
                        {label = 'Muscle ', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 1) end},
                        {label = 'Lowrider', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 2) end},
                        {label = 'SUV', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 3) end},
                        {label = 'Offroad', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 4) end},
                        {label = 'Tuner', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 5) end},
                        {label = 'Bike Wheels', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 6) end},
                        {label = 'High End', img = 'img/icons/wheel.png', modType = 23, priceMult = 1.65, onSelect = function() SetVehicleModData(customVehicle, 'wheels', 7) end},
                    },
                    onBack = function() updateMenu('wheels') end
                },
            ['plate'] = {
                title = 'KENNZEICHEN',
                options = {
                    {label = 'Typ', img = 'img/icons/plate.png', modType = 25, priceMult = 1.1},
                    {label = 'Farbe', img = 'img/icons/respray.png', modType = 'plateIndex', priceMult = 1.1, onSelect = function()
                        moveToCameraToBoneSmoth(customCamMain, customCamSec, customVehicle, 'bumper_r', {x = -2.0, y = -2.0, z = 1.5}, {x = -30.0, y = 0.0, z = 0.0})
                    end, onSubBack = function()
                        SetCamActiveWithInterp(customCamMain, customCamSec, 500, true, true)
                    end},
                    {label = 'Halter', img = 'img/icons/bumper.png', modType = 26, priceMult = 3.49},
                },
                onBack = function() updateMenu('visual') end
            },
            ['lights'] = {
                title = 'BELEUCHTUNG',
                options = {
                    {label = 'Xenon', img = 'img/icons/headlights.png', modType = 'modXenon', priceMult = 0.1, onSelect = function() SetVehicleEngineOn(customVehicle, true, false, false) end},
                    {label = 'Neon', img = 'img/icons/headlights.png', modType = 'neonColor', customType = 'customColor', priceMult = 1.12, onSelect = function() SetVehicleEngineOn(customVehicle, true, false, false) openColorPicker('Neon Color', 'neonColor', true, 0.5) end},
                },
                onBack = function() updateMenu('visual') end
            },
            ['stickers'] = {
                title = 'AUFKLEBER',
                options = {
                    {label = 'Aufkleber', img = 'img/icons/respray.png', modType = 48, priceMult = 6.0},
                    {label = 'Lackierung', img = 'img/icons/respray.png', modType = 'livery', priceMult = 6.0},
                },
                onBack = function() updateMenu('visual') end
            },
}