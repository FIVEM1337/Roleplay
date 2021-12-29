fx_version 'cerulean'
game 'gta5'

files {
    '**/*.meta',
    '**/*.xml',
    '**/*.dat',
    '**/*.ytyp'
}

data_file 'HANDLING_FILE'            '**/handling*.meta'
data_file 'VEHICLE_LAYOUTS_FILE'    '**/vehiclelayouts*.meta'
data_file 'VEHICLE_METADATA_FILE'    '**/vehicles*.meta'
data_file 'CARCOLS_FILE'            '**/carcols*.meta'
data_file 'VEHICLE_VARIATION_FILE'    '**/carvariations*.meta'
data_file 'CONTENT_UNLOCKING_META_FILE' '**/*unlocks.meta'
data_file 'PTFXASSETINFO_FILE' '**/ptfxassetinfo.meta'
data_file 'DLC_ITYP_REQUEST' '**/*.ytyp'


client_scripts {
    'vehicle_names.lua',
}