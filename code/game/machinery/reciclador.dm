#define SAFETY_COOLDOWN 100

/obj/machinery/mineral/processing_unit/recycle/recycler
	name = "recycler"
	desc = "A large crushing machine which is used to recycle objects. There are lights on the side of it."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "grinder-o0"
	plane = ABOVE_HUMAN_PLANE
	anchored = TRUE
	density = TRUE
	in_dir = WEST // Input direction of the to be recycled atoms, can be changed on the map
	out_dir = EAST // Output direction

	var/safety_mode = FALSE // Used for temporarily stopping the machine if it detects a mob
	var/icon_name = "grinder-o" // Used in update_icon()
	var/blood = FALSE // Used in update_icon() for a bloody icon when it grinds a mob

/obj/machinery/mineral/processing_unit/recycle/recycler/New()
	..()
	update_icon()

// Warnings about the machine.
// Ought to be visual changes in the machine's sprite as well
/obj/machinery/mineral/processing_unit/recycle/recycler/examine(var/mob/user)
	..()
	to_chat(user, "The power light is [(stat & NOPOWER) ? "off" : "on"].")
	to_chat(user, "The safety-mode light is [safety_mode ? "on" : "off"].")
	to_chat(user, "The safety-sensors status light is [emagged ? "off" : "on"].")


// Proc used when the machine is hacked or emagged, allowing to grind mobs
/obj/machinery/mineral/processing_unit/recycle/recycler/proc/toggle_safety_protocols(var/hacked, var/mob/M)
	emagged = hacked
	update_icon()

	if(M)
		to_chat(M, "<span class='notice'>You [emagged ? "disable": "enable"] \the [src] safety protocols.</span>")

	playsound(loc, "sparks", 75, 1, -1)
	var/datum/effect/effect/system/spark_spread/S = new /datum/effect/effect/system/spark_spread
	S.set_up(3, 1, loc)
	S.start()

/obj/machinery/mineral/processing_unit/recycle/recycler/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		toggle_safety_protocols(TRUE, user)
		return
	else if(istype(I, /obj/item/weapon/screwdriver) && emagged)
		playsound(get_turf(user), 'sound/items/Screwdriver.ogg', 50, 1)
		toggle_safety_protocols(FALSE, user)
		return
	..()

/obj/machinery/mineral/processing_unit/recycle/recycler/update_icon()
	var/is_powered = (!(stat & (BROKEN|NOPOWER)) && on)

	if(safety_mode)
		is_powered = FALSE

	icon_state = icon_name + "[is_powered]" + "[(blood ? "bld" : "")]" // Add the blood tag at the end

/obj/machinery/mineral/processing_unit/recycle/recycler/Cross(var/atom/movable/AM)
	if(!istype(AM))
		return 0

	if(stat & (BROKEN|NOPOWER) || !on)
		return 0

	if(safety_mode)
		return 0

	if(isliving(AM))
		emagged ? eat(AM) : stop(AM) // Will only eat mobs when emagged
		return 0

	if(istype(AM, /obj/item)) // Ignores structures and machinery
		playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
		AM.recycle(ore)
		qdel(AM)

	return 0

// Overrides parent's proc since it's function is handled by Cross() with better performance
/obj/machinery/mineral/processing_unit/recycle/recycler/grab_ores()
	return

/obj/machinery/mineral/processing_unit/recycle/recycler/proc/stop(var/mob/living/L)
	playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
	safety_mode = TRUE
	update_icon()

	sleep(SAFETY_COOLDOWN)

	playsound(loc, 'sound/machines/ping.ogg', 50, 0)
	safety_mode = FALSE
	update_icon()

/obj/machinery/mineral/processing_unit/recycle/recycler/proc/eat(var/mob/living/L)
	// We move the mob to our location so it can get out on the other side
	L.forceMove(loc)

	// Instantly lie down and also go unconscious from the pain before you die
	L.Paralyse(5)

	var/issilicon = issilicon(L) // Using the proc only once
	var/sound = issilicon ? 'sound/items/Welder.ogg' : 'sound/effects/splat.ogg'
	playsound(loc, sound, 50, 1)

	var/gib = TRUE	// By default, the emagged recycler will gib all non-carbons. (human simple animal mobs don't count)

	if(iscarbon(L))
		gib = FALSE
		L.audible_scream()
		add_blood(L)

	if(!blood && !issilicon)
		blood = TRUE
		update_icon()

	// Drops all items from the mob
	for(var/obj/item/I in L.get_equipped_items())
		L.drop_from_inventory(I)

	// Var edit emagged to 2 for admin fun!
	if(gib || emagged == 2)
		L.gib()
	else if(emagged)
		L.adjustBruteLoss(300) // Certain death and has a small chance of beheading humans

#undef SAFETY_COOLDOWN
