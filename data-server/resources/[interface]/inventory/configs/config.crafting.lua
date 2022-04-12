Config.Crafting = true -- toggle crafting plugin | default: true
Config.CraftingBuiltIn = true -- enabled crafting locations | default: true
Config.CraftingDelay = 250 -- delay of opening crafting menu | default: 250
Config.CraftingLocations = {

  --[[
  ["craft"] = {
    label = 'Workbench',
    license = false, -- add license name here, esx_license required!
    jobs = {"mechanic"}, -- set to false to disable whitelisting
    job_grades = {1}, -- set to false to disable grading
    blip = {id = 814, color = 5, scale = 0.8, hiddenForOthers = true},
    locations = {
      vector3(472.84, -1310.1, 28.65)
    },
    items = {
      {type = 'item', name = 'fishrod', count = 1, time = 2, ingredients = {
        {name = 'stick', count = 1},
        {name = 'hook', count = 2}
      }}
    }
  }
  ]]--
}