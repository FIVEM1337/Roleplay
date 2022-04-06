fx_version 'adamant'
game 'gta5'


dependency 'oxmysql'
server_script "@oxmysql/lib/MySQL.lua"

shared_scripts {
    'config.lua',
}

server_scripts {
    'server/*.lua'
}

client_scripts {
    "@NativeUILua_Reloaded/src/NativeUIReloaded.lua",
    'client/*.lua'
}


data_file "DLC_ITYP_REQUEST" "badge1.ytyp"

data_file "DLC_ITYP_REQUEST" "copbadge.ytyp"
