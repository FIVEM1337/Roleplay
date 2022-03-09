fx_version      'adamant'
game            'gta5'
description     'D-Phone from Deun Services'
version         '0.73 Beta 6'
ui_page         'html/main.html'

lua54 'yes'

server_script {
  "@mysql-async/lib/MySQL.lua",
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/de.lua',
  "config/config.lua",
  "config/ipconfig.lua",
  "server/server.lua",
  "server/suser.lua",
}

client_script {
  '@es_extended/locale.lua',
  'locales/en.lua',
  'locales/de.lua',
  "config/config.lua",
  "config/ipconfig.lua",
  "client/client.lua",
  "client/cuser.lua",
  "client/animation.lua",
  "client/photo.lua",
}


files {
    'html/main.html',
    'html/js/*.js',
    'html/js/locales/*.js',
    'html/img/*.png',
    'html/css/*.css',
    'html/sound/*.ogg',
    'html/fonts/font-1.ttf',
    'html/fonts/HalveticaNeue-Medium.ttf',
    'html/fonts/KeepCalm-Medium.ttf',
    'html/fonts/Azonix.otf',
    'html/fonts/keepcalm.otf',
    'html/fonts/*.woff',
    'html/fonts/Roboto/*.ttf',
}

escrow_ignore {
  "config/config.lua",
  "server/suser.lua",
  "client/cuser.lua",
  "client/animation.lua",
  "client/photo.lua",
  'locales/en.lua',
  'locales/de.lua',
}
dependency '/assetpacks'