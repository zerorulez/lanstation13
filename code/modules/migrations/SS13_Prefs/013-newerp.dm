/datum/migration/sqlite/ss13_prefs/_013
	id = 13
	name = "ERP"

/datum/migration/sqlite/ss13_prefs/_013/up()
	if(!hasColumn("body","anal_virgin"))
		return execute("ALTER TABLE `body` ADD COLUMN anal_virgin INTEGER DEFAULT 1")
	return TRUE

/datum/migration/sqlite/ss13_prefs/_013/down()
	if(hasColumn("body","anal_virgin"))
		return execute("ALTER TABLE `body` DROP COLUMN anal_virgin")
	return TRUE