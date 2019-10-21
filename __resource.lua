resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

server_scripts {
	'config.lua',
	'server.lua',
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
}

dependencies {
	'es_extended',
	'cron'
}