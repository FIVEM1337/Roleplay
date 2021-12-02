heli = {
    -- chopper models for each jobs
    ["police"] = {
        -- job
        {plate = "PDHELI1", model = "maverick", grade = 8},
        {plate = "PDHELI2", model = "frogger", grade = 9},
        {plate = "PDHELI3", model = "polmav", grade = 9},
        {plate = "PDHELI4", model = "valkyrie", grade = 10},
        {plate = "PDHELI5", model = "akula", grade = 10},
        {plate = "PDHELI6", model = "buzzard", grade = 11},
        {plate = "PDHELI7", model = "cargobob2", grade = 11}
    },
    ["ambulance"] = {
        -- job
        {plate = "AMBHELI1", model = "maverick", grade = 8},
        {plate = "AMBHELI2", model = "frogger", grade = 8},
        {plate = "AMBHELI3", model = "polmav", grade = 8},
        {plate = "AMBHELI4", model = "valkyrie", grade = 8},
        {plate = "AMBHELI5", model = "akula", grade = 8},
        {plate = "AMBHELI6", model = "buzzard", grade = 8},
        {plate = "AMBHELI7", model = "cargobob2", grade = 8}
    },
}

helispawn = {
    -- coordinates for jobs helicopters
    ["police"] = {
        [1] = {
            garage = "Police Chopper A",
            Blip = {color = 38, sprite = 43, scale = 0.6},
            coords = vector3(449.27, -981.05, 43.69),
            distance = 8
        }
    }
}