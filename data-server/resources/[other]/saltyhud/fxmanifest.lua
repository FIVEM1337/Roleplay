fx_version 'adamant'
game 'gta5'

ui_page 'NUI/hud.html'

client_script 'SaltyClient.net.dll'

files {
    'SaltyClient.net.pdb',
    'NUI/*',
    'Newtonsoft.Json.dll',
    'config.json'
}

exports {
    'SetEnabled'
}

dependencies {
    'saltychat'
}
