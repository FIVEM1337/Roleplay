Config = {}
Translation = {}

Config.Locale = 'de'

Config.useMyDrugs = false -- If you use myDrugs enable this
Config.useMyProperties = false -- If you use myProperties enable this
Config.useSpawnmanager = true

Config.useRegisterMenu = false   -- Enable if you want to register with firstname and lastname ...
Config.use_esx_charactercreator = true

Config.ApplyDelay = 3000 -- Don't edit this if you don't know what you do ^^
Config.ForceMultiplayerPed = true -- Don't edit this if you don't know what you do ^^

Config.CanPlayersDeleteTheirCharacter = true

Config.AdminGroup = 'superadmin'
Config.PermissionsCommand = 'giveperm'

-- Insert all tables from your database here, where an identifier is saved.
-- Also when the column name is owner or steamID or....
Config.Tables = {
	--{table = "phone_users_contacts", column = "identifier"},
	{table = "users", column = "identifier"},
    {table = "billing", column = "identifier"},
    {table = "datastore_data", column = "owner"},
    {table = "owned_vehicles", column = "owner"},
    {table = "phone_banking", column = "identifier"},
    {table = "phone_contacts", column = "identifier"},
    {table = "phone_information", column = "identifier"},
    {table = "phone_twitter_accounts", column = "identifier"},
    {table = "phone_twitter_likes", column = "identifier"},
    {table = "phone_twitter_messages", column = "identifier"},
    {table = "sprays", column = "identifier"},
    {table = "user_licenses", column = "owner"},
    {table = "user_clothes", column = "identifier"},   
    {table = "prop_owner", column = "owner"},
}

Config.SpawnLocations = {
    {label = 'Los Santos International Airfield', pos = {x = -1035.2248535156, y = -2729.5324707031, z = 13.756646156311}},
    {label = 'Del Perro Beach', pos = {x = -1646.1577148438, y = -1006.9326171875, z = 13.017389297485}},
    {label = 'Paleto Bay', pos = {x = -439.59637451172, y = 6020.2290039062, z = 31.490133285522}},
    {label = 'Grapeseed', pos = {x = 2169.8049316406, y = 4776.5668945312, z = 41.221500396729}},
    {label = 'Sandy Shores', pos = {x = 1782.5380859375, y = 3309.3269042969, z = 41.366504669189}},
    {label = 'Legion Square', pos = {x = 223.65687561035, y = -859.32794189453, z = 30.130056381226}},
    {label = 'Mirror Park', pos = {x = 1057.3858642578, y = -718.24951171875, z = 56.8473777771}},
}

Config.ShowSpawnSelectionOnFirstJoin = false


Config.FirstSpawnLocations = {
    {x = 3864.57, y = 4463.69, z = 2.72},
    {x = 3822.24, y = 4516.16, z = 2.9},
    {x = 3792.85, y = 4546.85, z = 1.96},
    {x = 3915.56, y = 4341.13, z = 3.29},
    {x = 3881.12, y = 4312.46, z = 2.03},
}

Config.ShowSpawnSelectionForEverybody = false

Config.Peds = {

    {hash = 'a_c_rottweiler', name = "Rottweiler"},
    {hash = 'a_c_cat_01', name = "Cat"},
    {hash = 'a_c_westy', name = "Westy"},
    {hash = 'a_c_chickenhawk', name = "Chicken Hawk"},
    {hash = 'a_c_cow', name = "Cow"},
    {hash = 'a_c_deer', name = "Deer"},
    {hash = 'a_c_crow', name = "Crow"},
    {hash = 'a_c_cormorant', name = "Cormorant"},
    {hash = 'a_c_hen', name = "Hen"},
    {hash = 'a_c_husky', name = "Husky"},
    {hash = 'a_c_pig', name = "Pig"},
    {hash = 'a_c_retriever', name = "Retriever"},
    {hash = 'a_c_shepherd', name = "Shepheard"},
    {hash = 'a_c_shepherd', name = "Shepheard"},
}

Translation = {
    ['de'] = {
        ['select_character'] = 'Charakterauswahl',
        ['select_character_desc'] = '~b~Wähle einen Charakter aus.',
        ['new_character'] = '~b~Charakter erstellen.',
        ['new_character_desc'] = 'Erstelle einen neuen Charakter.',
        ['slots_full'] = 'Du kannst keinen weiteren Char erstellen!',

        ['select_title'] = 'Einreise',
        ['last_position'] = '~b~→ ~s~Letzte Position',
        ['position_desc'] = 'Klicke, um bei ~b~',
        ['position_desc_2'] = ' ~s~zu spawnen.',    
        
        ['register_title'] = 'Charakter erstellen',
        ['register_title_desc'] = 'Vervollständige deine Papiere für die Einreise',
        ['gender_m'] = ' männlich ',
        ['gender_f'] = ' weiblich ',
        ['name'] = 'Vorname',
        ['lastname'] = 'Nachname',
        ['dob'] = 'Geburtsdatum',
        ['height'] = 'Größe',
        ['sex'] = 'Geschlecht',
        ['confirm'] = '~b~Einreise',
        ['confirm_desc'] = 'Alles korrekt eingegeben? Dann kann es jetzt losgehen!',
        ['insert_name'] = 'Vorname eingeben',
        ['insert_lastname'] = 'Nachname eingeben',
        ['insert_dob'] = 'Geburtsdatum eingeben (Format: 01.01.2000)',
        ['insert_height'] = 'Größe eingeben (140-200)',
        ['height_unit'] = 'cm',
        ['register_error'] = '~r~Mindestens ein Feld wurde nicht korrekt ausgefüllt!',

        ['ped_models'] = 'Ped Models',
        ['default_ped'] = 'Standard Ped',
        ['pedmode_no_perms'] = '~r~Keine Rechte!',

        ['enter_char'] = 'Einreisen',
        ['delete_char'] = '~r~Charakter löschen',
        ['delete_char_conirm'] = '~r~Charakter löschen bestätigen',

        ['giveperm_wrong_usage'] = '~r~Falsche Bedienung! ~w~/giveperm [Player-ID] [charamount/pedmode] [Value]',
        ['giveperm_success'] = '~g~Successfully added permission',
        ['giveperm_error'] = '~r~Player is not online!',
    },
    ['en'] = {
        ['select_character'] = 'My Characters',
        ['select_character_desc'] = '~b~Choose a Character.',
        ['new_character'] = '~b~Create new Character',
        ['new_character_desc'] = 'Create a new Character.',
        ['slots_full'] = 'You do not have enough Char Slots!',

        ['select_title'] = 'Register',
        ['last_position'] = '~b~→ ~s~Last Position',
        ['position_desc'] = 'Click to spawn at ~b~',
        ['position_desc_2'] = '~s~.',    
        
        ['register_title'] = 'Create character',
        ['register_title_desc'] = 'Complete your ID-Card!',
        ['gender_m'] = ' male ',
        ['gender_f'] = ' female ',
        ['name'] = 'First name',
        ['lastname'] = 'Last name',
        ['dob'] = 'Date of birth',
        ['height'] = 'Height',
        ['sex'] = 'Gender',
        ['confirm'] = '~b~Enter the island',
        ['confirm_desc'] = 'Everything correct?',
        ['insert_name'] = 'Enter first name',
        ['insert_lastname'] = 'Enter last name',
        ['insert_dob'] = 'Enter date of birth (example: 01.01.2000)',
        ['insert_height'] = 'Insert height (140-200)',
        ['height_unit'] = 'cm',
        ['register_error'] = '~r~At least one field is not correct!',

        ['ped_models'] = 'Ped Models',
        ['default_ped'] = 'Default Ped',
        ['pedmode_no_perms'] = '~r~You can not do this!',

        ['enter_char'] = 'Enter',
        ['delete_char'] = '~r~Delete character',
        ['delete_char_conirm'] = '~r~Delete character confirm',

        ['giveperm_wrong_usage'] = '~r~Wrong usage! ~w~/giveperm [Player-ID] [charamount/pedmode] [Value]',
        ['giveperm_success'] = '~g~Successfully added permission',
        ['giveperm_error'] = '~r~Player is not online!',
    }
}