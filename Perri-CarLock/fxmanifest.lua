fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'perrituber'
description 'https://discord.gg/nqY4QNrXv3'

client_scripts {
    'Client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'Server/main.lua',
}

shared_scripts {
    'Config.lua',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

dependencies {
    'ox_lib'
}
