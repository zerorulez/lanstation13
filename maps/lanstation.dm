
//**************************************************************
// Map Datum -- LanStation
//**************************************************************

/datum/map/active
	nameShort = "lan"
	nameLong  = "lanstation"
	map_dir   = "lanstation"
	tDomeX = 128
	tDomeY = 69
	tDomeZ = 2
	zLevels = list(
		/datum/zLevel/station,
		/datum/zLevel/centcomm,
		/datum/zLevel/space{
			name = "spaceOldSat" ;
			},
		/datum/zLevel/space{
			name = "derelict" ;
			}
		)
	unavailable_items = list(
		/obj/item/clothing/shoes/magboots/elite,
		/obj/item/clothing/suit/space/nasavoid,
		/obj/item/clothing/under/rank/research_director,
		/obj/item/clothing/under/rank/chief_engineer,
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/under/rank/head_of_security
		)
////////////////////////////////////////////////////////////////

#include "lanstation.dmm"

#if !defined(MAP_OVERRIDE_FILES)
	#define MAP_OVERRIDE_FILES
	#include "mini2\misc.dm"
	#include "lanstation\misc.dm"
	#include "lanstation\job\jobs.dm"
	#include "lanstation\job\removed.dm"
//