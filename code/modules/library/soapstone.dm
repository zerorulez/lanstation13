/obj/item/soapstone
	name = "soapstone"
	desc = "Leave informative messages for the crew, including the crew of future shifts!"
	icon = 'icons/obj/darksouls.dmi'
	icon_state = "soapstone"
	throw_speed = 3
	throw_range = 5
	w_class = W_CLASS_TINY
	var/tool_speed = 50
	var/remaining_uses = 3

	var/w_engrave = "engrave"
	var/w_engraving = "engraving"
	var/w_chipping = "chipping"
	var/w_dull = "dull"

/obj/item/soapstone/New()
	. = ..()

/obj/item/soapstone/examine(mob/user)
	. = ..()
	user << "It has [remaining_uses] uses left."

/obj/item/soapstone/afterattack(atom/target, mob/user, proximity)
	var/turf/T = get_turf(target)
	if(!proximity)
		return

	if(!remaining_uses)
		// The dull chisel is dull.
		user << "<span class='warning'>[src] is [w_dull].</span>"
		return

	var/obj/structure/chisel_message/already_message = locate(/obj/structure/chisel_message) in T

	if(!good_chisel_message_location(T))
		user << "<span class='warning'>It's not appropriate to [w_engrave] on [T].</span>"
		return

	if(already_message)
		user.visible_message("<span class='notice'>[user] starts erasing [already_message].</span>", "<span class='notice'>You start erasing [already_message].</span>", "<span class='italics'>You hear a [w_chipping] sound.</span>")
		playsound(loc, 'sound/items/gavel.ogg', 50, 1, -1)

		if(do_after(user, tool_speed, target=target) && spend_use())
			user.visible_message("<span class='notice'>[user] has erased [already_message].</span>", "<span class='notice'>You erased [already_message].</span>")
			already_message.persists = FALSE
			qdel(already_message)
			playsound(loc, 'sound/items/gavel.ogg', 50, 1, -1)
		return

	var/message = stripped_input(user, "What would you like to [w_engrave]?", "Leave a Message")
	if(!message)
		user << "You decide not to [w_engrave] anything."
		return

	if(!target.Adjacent(user) && locate(/obj/structure/chisel_message) in T)
		user << "You decide not to [w_engrave] anything."
		return

	playsound(loc, 'sound/items/gavel.ogg', 50, 1, -1)
	user.visible_message("<span class='notice'>[user] starts [w_engraving] a message into [T].</span>", "You start [w_engraving] a message into [T].", "<span class='italics'>You hear a [w_chipping] sound.</span>")
	if(do_after(user, T, tool_speed))
		if(!(locate(/obj/structure/chisel_message) in T) && spend_use())
			user.visible_message("<span class='notice'>[user] leaves a message for future spacemen!</span>", "<span class='notice'>You [w_engrave] a message into [T]!</span>", "<span class='italics'>You hear a [w_chipping] sound.</span>")
			playsound(loc, 'sound/items/gavel.ogg', 50, 1, -1)
			var/obj/structure/chisel_message/M = new(T)
			M.register(user, message)

/obj/item/soapstone/proc/spend_use(mob/user)
	if(!remaining_uses)
		. = FALSE
	else
		remaining_uses--
		if(!remaining_uses)
			name = "[w_dull] [name]"
		. = TRUE

/* Persistent engraved messages, etched onto the station turfs to serve
   as instructions and/or memes for the next generation of spessmen.

   Limited in location to station_z only. Can be smashed out or exploded,
   but only permamently removed with the librarian's soapstone.
*/

/proc/good_chisel_message_location(turf/T)
	if(!T)
		. = FALSE
	else if(T.z != 1)
		. = FALSE
	else if(istype(get_area(T), /area/shuttle))
		. = FALSE
	else if(!(isfloorturf(T) || iswallturf(T)))
		. = FALSE
	else
		. = TRUE

/obj/structure/chisel_message
	name = "engraved message"
	desc = "A message from a past traveler."
	icon = 'icons/obj/darksouls.dmi'
	icon_state = "soapstone_message"
	density = 0
	anchored = 1
	luminosity = 1

	light_range = 2
	light_power = 0.25

	var/hidden_message
	var/creator_key
	var/creator_name
	var/realdate
	var/map
	var/persists = TRUE

	var/positive_ratings = 0
	var/negative_ratings = 0

	var/list/raters = list() //Ckeys who have rated this message

/obj/structure/chisel_message/attack_hand(mob/user)
	if(user.ckey == creator_key)
		user << "<span class='warning'>You can't rate your own messages!</span>"
		return
	if(raters[user.ckey])
		user << "<span class='warning'>You've already rated this message!</span>"
		return
	switch(alert(user, "How would you like to rate this message?", "Message Rating", "Positive", "Negative", "Cancel"))
		if("Positive")
			for(var/client/C in clients)
				if(C.ckey == creator_key)
					C.mob << "<span class='notice'>One of your messages was rated as positive!</span>"
			user << "<span class='noticealien'>You rated this message as positive.</span>"
			positive_ratings++
			raters[user.ckey] = "positive"
		if("Negative")
			for(var/client/C in clients)
				if(C.ckey == creator_key)
					C.mob << "<span class='danger'>One of your messages was rated as negative!</span>"
			user << "<span class='danger'>You rated this message as negative.</span>"
			negative_ratings++
			raters[user.ckey] = "negative"

/obj/structure/chisel_message/New(newloc)
	..()
	SSpersistence.chisel_messages += src
	var/turf/T = get_turf(src)
	if(!good_chisel_message_location(T))
		persists = FALSE
		qdel(src)

/obj/structure/chisel_message/proc/register(mob/user, newmessage)
	hidden_message = newmessage
	creator_name = html_encode(user.real_name)
	creator_key = user.ckey
	realdate = world.realtime
	map = global.map.nameLong
	update_icon()

/obj/structure/chisel_message/update_icon()
	..()
	var/hash = md5(hidden_message)
	var/newcolor = copytext(hash, 1, 7)
	color = "#[newcolor]"
	light_color = "#[newcolor]"

/obj/structure/chisel_message/proc/pack()
	var/list/data = list()
	data["hidden_message"] = html_encode(hidden_message)
	data["creator_name"] = html_decode(creator_name)
	data["creator_key"] = creator_key
	data["realdate"] = realdate
	data["map"] = global.map.nameLong
	var/turf/T = get_turf(src)
	data["x"] = T.x
	data["y"] = T.y
	data["pos_ratings"] = positive_ratings
	data["neg_ratings"] = positive_ratings
	data["raters"] = raters
	return data

/obj/structure/chisel_message/proc/unpack(list/data)
	if(!islist(data))
		return

	hidden_message = html_decode(data["hidden_message"])
	creator_name = data["creator_name"]
	creator_key = data["creator_key"]
	realdate = data["realdate"]
	positive_ratings = data["pos_ratings"]
	negative_ratings = data["neg_ratings"]
	raters = data["raters"]

	var/x = data["x"]
	var/y = data["y"]
	var/turf/newloc = locate(x, y, 1)
	forceMove(newloc)
	update_icon()

/obj/structure/chisel_message/examine(mob/user)
	..()
	user << "<span class='warning'>[hidden_message]</span>"
	user << "<b>Ratings:</b> </b><span class='radio'>[positive_ratings]</span></b> <span class='danger'>[negative_ratings]</span>"
	if(raters[user.ckey])
		user << "<i>You rated this message as [raters[user.ckey]].</i>"

/obj/structure/chisel_message/Destroy()
	if(persists)
		SSpersistence.SaveChiselMessage(src)
	SSpersistence.chisel_messages -= src
	. = ..()

/obj/structure/chisel_message/singularity_pull()
	return
