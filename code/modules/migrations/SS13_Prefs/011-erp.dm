/datum/migration/sqlite/ss13_prefs/_011
	id = 11
	name = "ERP"

/datum/migration/sqlite/ss13_prefs/_011/up()
	if(!hasColumn("body","forbidden"))
		return execute("ALTER TABLE `body` ADD COLUMN forbidden TEXT")
	return TRUE

/datum/migration/sqlite/ss13_prefs/_011/down()
	if(hasColumn("client","attack_animation"))
		return execute("ALTER TABLE `body` DROP COLUMN forbidden")
	return TRUE
