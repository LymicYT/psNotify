fx_version 'cerulean'
game 'gta5'

author 'PulsarStudios'
description 'psNotify By PulsarStudios - A Notification System.'
version '1.0.0'

client_scripts {
    'client.lua',
    'psNotify_client.lua'
}
server_scripts {
    'server.lua'
}


ui_page 'web/ui.html'

files {
    'web/ui.html',
    'web/styles.css',
    'web/scripts.js',
    'web/notify.mp3'
}

dependency 'qb-core'
