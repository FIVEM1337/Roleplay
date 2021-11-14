Config = {}
Config.Locale = "en"
--GENERAL SETTING
Config.Mysql = 'mysql-async' -- "ghmattisql", "mysql-async", "oxmysql"
Config.ReturnDamage = true -- return visual damage when restoring vehicle from garage
Config.ReturnPayment = 1000 -- a value to pay if vehicle is not in garage
Config.UseRayZone = false -- unrelease script https://github.com/renzuzu/renzu_rayzone
Config.floatingtext = true -- use native floating text and marker to interact with garages (popui and floatingtext must be opposite settings) (popui must be false if this is true)
Config.UsePopUI = false -- Create a Thread for checking playercoords and Use POPUI to Trigger Event, set this to false if using rayzone. Popui is originaly built in to RayZone -- DOWNLOAD https://github.com/renzuzu/renzu_popui
Config.Quickpick = false -- if false system will create a garage shell and spawn every vehicle you preview
Config.UniqueCarperGarage = false -- if false, show all vehicles to all garage location! else if true, Vehicles Saved in Garage A cannot be take out from Garage B for example.
-- BLIPS --
Config.BlipNamesStatic = true -- if true no more garage a garage b blip names from MAP , only says  Garage
--GENERAL SETTING

-- VEHICLE IMAGES
Config.use_renzu_vehthumb = false


Config.EnableImpound = true -- enable/disable impound
Config.EnableHeliGarage = true -- enable/disable Helis
Config.PlateSpace = true -- enable / disable plate spaces (compatibility with esx 1.1?)
Config.EnableReturnVehicle = true -- enable / disable return vehicle feature
Config.DefaultPlate = 'ROLEPLAY' -- default plate being used to default_vehicles args

-- MARKER
Config.UseMarker = true -- Drawmarker
Config.MarkerDistance = 20 -- distance to draw the marker
--MARKER

-- PROPERTY GARAGE
Config.EnablePropertyCoordGarageCoord = false  -- set to false if you will use custom exports and events
-- TriggerEvent('renzu_garage:property',"Forum Drive 11/Apt13", vector3(-1053.82, -933.09, 3.36)) -- example manual trigger
Config.PropertyQuickPick = true -- quickpick -- deprecated method 1.72
Config.UniqueProperty = false -- if enable , only stored vehicles in this Property ID will be show -- deprecated 1.72
