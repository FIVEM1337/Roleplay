Config.Storages = true -- toggle storages | default: true
Config.StorageLocations = {
  ["pd1"] = {
    label = "Mission Row PD",
    jobs = {'police'}, -- set to false to disable whitelisting
    job_grades = {0, 1, 2, 3, 4}, -- set to false to disable grading
    weight = 100,
    delay = 250,
    openBtn = "Evidence Locker",
    blip = {id = 525, color = 7, scale = 0.8, hiddenForOthers = true},
    locations = {
      vector3(459.35, -990.03, 23.8),
    }
  },
}