/datum/migration/sqlite/ss13_prefs/_009
	id = 9
	name = "Regras"

/datum/migration/sqlite/ss13_prefs/_009/up()
	if(!hasColumn("client","viu_regras"))
		return execute("ALTER TABLE `client` ADD COLUMN viu_regras INTEGER DEFAULT 0")
	return TRUE

/datum/migration/sqlite/ss13_prefs/_009/down()
	if(hasColumn("client","viu_regras"))
		return execute("ALTER TABLE `client` DROP COLUMN viu_regras")
	return TRUE