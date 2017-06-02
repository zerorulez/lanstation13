/datum/migration/sqlite/ss13_prefs/_010
	id = 10
	name = "Add Attack Animations"

/datum/migration/sqlite/ss13_prefs/_010/up()
	if(!hasColumn("client","attack_animation"))
		return execute("ALTER TABLE `client` ADD COLUMN attack_animation INTEGER DEFAULT 1")
	return TRUE

/datum/migration/sqlite/ss13_prefs/_010/down()
	if(hasColumn("client","attack_animation"))
		return execute("ALTER TABLE `client` DROP COLUMN attack_animation")
	return TRUE
