/datum/migration/sqlite/ss13_prefs/_012
	id = 12
	name = "ERP"

/datum/migration/sqlite/ss13_prefs/_012/up()
	if(!hasColumn("body","virgin"))
		return execute("ALTER TABLE `body` ADD COLUMN virgin INTEGER DEFAULT 1")
	return TRUE

/datum/migration/sqlite/ss13_prefs/_012/down()
	if(hasColumn("body","virgin"))
		return execute("ALTER TABLE `body` DROP COLUMN virgin")
	return TRUE
