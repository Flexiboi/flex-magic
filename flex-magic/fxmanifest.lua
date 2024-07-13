fx_version 'cerulean'
game 'gta5'

description 'flex-kerk'
version '0.1'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
}

server_script {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'
}

client_script {
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/ComboZone.lua',
    'client/client.lua',
}

lua54 'yes'
