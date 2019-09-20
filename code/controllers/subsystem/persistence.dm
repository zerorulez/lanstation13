var/datum/subsystem/persistence/SSpersistence

/datum/subsystem/persistence
	name = "Persistence"
	init_order = -100
	flags = SS_NO_FIRE
	var/list/obj/structure/chisel_message/chisel_messages = list()
	var/list/saved_messages = list()
	var/savefile/chisel_messages_sav

/datum/subsystem/persistence/New()
	NEW_SS_GLOBAL(SSpersistence)

/datum/subsystem/persistence/Initialize()
	LoadChiselMessages()
	..()

/datum/subsystem/persistence/proc/LoadChiselMessages()
	chisel_messages_sav = new /savefile("data/npc_saves/ChiselMessages.sav")
	var/saved_json
	chisel_messages_sav[global.map.nameLong] >> saved_json

	if(!saved_json)
		return

	var/list/saved_messages = json_decode(saved_json)

	for(var/item in saved_messages)
		var/turf/T = locate(item["x"], item["y"], 1)
		if(!isturf(T))
			continue
		if(locate(/obj/structure/chisel_message) in T)
			continue
		var/obj/structure/chisel_message/M = new(T)
		M.unpack(item)
		if(!M.loc)
			M.persists = FALSE
			qdel(M)


/datum/subsystem/persistence/proc/CollectData()
	CollectChiselMessages()

/datum/subsystem/persistence/proc/CollectChiselMessages()
	for(var/obj/structure/chisel_message/M in chisel_messages)
		saved_messages += list(M.pack())

	chisel_messages_sav[map.nameLong] << json_encode(saved_messages)

/datum/subsystem/persistence/proc/SaveChiselMessage(obj/structure/chisel_message/M)
	saved_messages += list(M.pack()) // dm eats one list.
