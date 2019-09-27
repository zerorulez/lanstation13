/* Alien shit!
 * Contains:
 *		structure/alien
 *		Resin
 *		Weeds
 *		Egg
 *		effect/acid
 */


/obj/structure/alien
	icon = 'icons/mob/alien.dmi'

/*
 * Resin
 */
/obj/structure/alien/resin
	name = "resin"
	desc = "Looks like some kind of thick resin."
	icon_state = "resin"
	density = 1
	opacity = 1
	anchored = 1
	var/health = 200
	var/resintype = null

/obj/structure/alien/resin/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)

/obj/structure/alien/resin/New(location)
	relativewall()
	relativewall_neighbours()
	..()
	return

/obj/structure/alien/resin/Destroy()
	spawn(10)
		var/turf/T = loc
		T.relativewall_neighbours()
	..()

/obj/structure/alien/resin/Move()
	..()

/obj/structure/alien/resin/relativewall()
	var/junction=findSmoothingNeighbors()
	icon_state = "[resintype][junction]"

/obj/structure/alien/resin/wall
	name = "resin wall"
	desc = "Thick resin solidified into a wall."
	icon_state = "wall0"	//same as resin, but consistency ho!
	resintype = "wall"
	canSmoothWith = "/obj/structure/alien/resin/wall=0&/obj/structure/alien/resin/membrane=0"

/obj/structure/alien/resin/wall/New()
	relativewall_neighbours()
	..()


/obj/structure/alien/resin/membrane
	name = "resin membrane"
	desc = "Resin just thin enough to let light pass through."
	icon_state = "membrane0"
	opacity = 0
	health = 120
	resintype = "membrane"
	canSmoothWith = "/obj/structure/alien/resin/wall=0&/obj/structure/alien/resin/membrane=0"

/obj/structure/alien/resin/membrane/New()
	relativewall_neighbours()
	..()

/obj/structure/alien/resin/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()


/obj/structure/alien/resin/ex_act(severity)
	switch(severity)
		if(1.0)
			health -= 150
		if(2.0)
			health -= 100
		if(3.0)
			health -= 50
	healthcheck()


/obj/structure/alien/resin/blob_act()
	health -= 50
	healthcheck()


/obj/structure/alien/resin/hitby(atom/movable/AM)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(!isobj(AM))
		tforce = 10
	else
		var/obj/O = AM
		tforce = O.throwforce
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health -= tforce
	healthcheck()


/obj/structure/alien/resin/attack_hand(mob/user)
	user.delayNextAttack(10)
	user.do_attack_animation(src, user)
	if(M_HULK in user.mutations)
		user.visible_message("<span class='danger'>[user] destroys [src]!</span>")
		health = 0
	else
		user.visible_message("<span class='warning'>[user] claws at the [name]!</span>")
		health -= rand(5,10)
	healthcheck()

/obj/structure/alien/resin/attack_paw(mob/user)
	return attack_hand(user)


/obj/structure/alien/resin/attack_alien(mob/living/user)
	if (islarva(user))//Safety check for larva. /N
		return
	user.do_attack_animation(src, user)
	to_chat(user, "<span class='good'>You claw at the [name].</span>")
	for(var/mob/O in oviewers(src))
		O.show_message("<span class='warning'>[usr] claws at the resin!</span>", 1)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health -= rand(40, 60)
	if(health <= 0)
		to_chat(usr, "<span class='good'>You slice the [name] to pieces.</span>")
		for(var/mob/O in oviewers(src))
			O.show_message("<span class='warning'>[user] slices the [name] apart!</span>", 1)
	healthcheck()



/obj/structure/alien/resin/attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	/*if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(isalien(user)&&(ishuman(G.affecting)||ismonkey(G.affecting)))
		//Only aliens can stick humans and monkeys into resin walls. Also, the wall must not have a person inside already.
			if(!affecting)
				if(G.state<2)
					to_chat(user, "<span class='warning'>You need a better grip to do that!</span>")
					return
				G.affecting.forceMove(src)
				G.affecting.paralysis = 10
				for(var/mob/O in viewers(world.view, src))
					if (O.client)
						to_chat(O, text("<span class='good'>[] places [] in the resin wall!</span>", G.assailant, G.affecting))
				affecting=G.affecting
				del(W)
				spawn(0)
					process()
			else
				to_chat(user, "<span class='warning'>This wall is already occupied.</span>")
		return */
	user.delayNextAttack(10)
	user.do_attack_animation(src, W)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()


/*
 * Weeds
 */

#define NODERANGE 3

/obj/structure/alien/weeds
	name = "resin floor"
	desc = "A thick resin surface covers the floor."
	icon_state = "weeds"
	anchored = 1
	density = 0
	plane = ABOVE_TURF_PLANE
	layer = WEED_LAYER
	var/health = 15
	var/obj/structure/alien/weeds/node/linked_node = null


/obj/structure/alien/weeds/New(pos, node)
	..()
	linked_node = node
	if(istype(loc, /turf/space))
		qdel(src)
		return
	if(icon_state == "weeds")
		icon_state = pick("weeds", "weeds1", "weeds2")
	fullUpdateWeedOverlays()
	spawn(rand(150, 200))
		if(src)
			Life()


/obj/structure/alien/weeds/proc/Life()
	set background = BACKGROUND_ENABLED
	var/turf/U = get_turf(src)

	if(istype(U, /turf/space))
		qdel(src)
		return

	direction_loop:
		for(var/dirn in cardinal)
			var/turf/T = get_step(src, dirn)

			if (!istype(T) || T.density || locate(/obj/structure/alien/weeds) in T || istype(T, /turf/space))
				continue

			if(!linked_node || get_dist(linked_node, src) > linked_node.node_range)
				return

			for(var/obj/O in T)
				if(O.density)
					continue direction_loop

			new /obj/structure/alien/weeds(T, linked_node)


/obj/structure/alien/weeds/ex_act(severity)
	qdel(src)


/obj/structure/alien/weeds/attackby(var/obj/item/weapon/W, var/mob/user)
	user.delayNextAttack(10)
	if(W.attack_verb && W.attack_verb.len)
		visible_message("<span class='warning'><B>[user] [pick(W.attack_verb)] \the [src] with \the [W]!</span>")
	else
		visible_message("<span class='warning'><B>[user] attacks \the [src] with \the [W]!</span>")

	var/damage = W.force

	if(!W.is_hot())
		damage = damage / 4.0

	src.health -= damage
	src.healthcheck()

/obj/structure/alien/weeds/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/structure/alien/weeds/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()


/obj/structure/alien/weeds/proc/updateWeedOverlays()

	overlays.Cut()
	var/turf/N = get_step(src, NORTH)
	var/turf/S = get_step(src, SOUTH)
	var/turf/E = get_step(src, EAST)
	var/turf/W = get_step(src, WEST)
	if(!locate(/obj/structure/alien) in N.contents)
		if(istype(N, /turf/simulated/floor))
			src.overlays += image('icons/mob/alien.dmi', "weeds_side_s", layer=2.6, pixel_y = 32)
	if(!locate(/obj/structure/alien) in S.contents)
		if(istype(S, /turf/simulated/floor))
			src.overlays += image('icons/mob/alien.dmi', "weeds_side_n", layer=2.6, pixel_y = -32)
	if(!locate(/obj/structure/alien) in E.contents)
		if(istype(E, /turf/simulated/floor))
			src.overlays += image('icons/mob/alien.dmi', "weeds_side_w", layer=2.6, pixel_x = 32)
	if(!locate(/obj/structure/alien) in W.contents)
		if(istype(W, /turf/simulated/floor))
			src.overlays += image('icons/mob/alien.dmi', "weeds_side_e", layer=2.6, pixel_x = -32)


/obj/structure/alien/weeds/proc/fullUpdateWeedOverlays()
	for (var/obj/structure/alien/weeds/W in range(1,src))
		W.updateWeedOverlays()

//Weed nodes
/obj/structure/alien/weeds/node
	name = "glowing resin"
	desc = "Blue bioluminescence shines from beneath the surface."
	icon_state = "weednode"
	luminosity = NODERANGE
	var/node_range = NODERANGE


/obj/structure/alien/weeds/node/New()
	..(loc, src)

#undef NODERANGE


/*
 * Egg
 */

//for the status var
#define BURST 0
#define BURSTING 1
#define GROWING 2
#define GROWN 3
#define MIN_GROWTH_TIME 1800	//time it takes to grow a hugger
#define MAX_GROWTH_TIME 3000

/obj/structure/alien/egg
	name = "egg"
	desc = "A large mottled egg."
	icon_state = "egg_growing"
	density = 0
	anchored = 1
	var/health = 100
	var/status = GROWING	//can be GROWING, GROWN or BURST; all mutually exclusive


/obj/structure/alien/egg/New()
	new /obj/item/clothing/mask/facehugger(src)
	..()
	spawn(rand(MIN_GROWTH_TIME, MAX_GROWTH_TIME))
		Grow()


/obj/structure/alien/egg/attack_paw(mob/user)
	if(isalien(user))
		switch(status)
			if(BURST)
				user << "<span class='notice'>You clear the hatched egg.</span>"
				playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
				qdel(src)
				return
			if(GROWING)
				user << "<span class='notice'>The child is not developed yet.</span>"
				return
			if(GROWN)
				user << "<span class='notice'>You retrieve the child.</span>"
				Burst(0)
				return
	else
		return attack_hand(user)


/obj/structure/alien/egg/attack_hand(mob/user)
	user << "<span class='notice'>It feels slimy.</span>"


/obj/structure/alien/egg/proc/GetFacehugger()
	return locate(/obj/item/clothing/mask/facehugger) in contents


/obj/structure/alien/egg/proc/Grow()
	icon_state = "egg"
	status = GROWN


/obj/structure/alien/egg/proc/Burst(var/kill = 1)	//drops and kills the hugger if any is remaining
	if(status == GROWN || status == GROWING)
		icon_state = "egg_hatched"
		flick("egg_opening", src)
		status = BURSTING
		spawn(15)
			status = BURST
			var/obj/item/clothing/mask/facehugger/child = GetFacehugger()
			if(child)
				child.loc = get_turf(src)
				if(kill && istype(child))
					child.Die()
				else
					for(var/mob/M in range(1,src))
						if(CanHug(M))
							child.Attach(M)
							break


/obj/structure/alien/egg/bullet_act(obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()

/obj/structure/alien/egg/attackby(var/obj/item/weapon/W, var/mob/user)
	user.delayNextAttack(10)
	if(W.attack_verb && W.attack_verb.len)
		src.visible_message("<span class='warning'><B>[user] [pick(W.attack_verb)] \the [src] with \the [W]!</span>")
	else
		src.visible_message("<span class='warning'><B>[user] attacks \the [src] with \the [W]!</span>")

	var/damage = W.force

	if(W.is_hot())
		damage = damage * 2.0

	src.health -= damage
	src.healthcheck()

/obj/structure/alien/egg/proc/healthcheck()
	if(health <= 0)
		if(status != BURST && status != BURSTING)
			Burst()
		else if(status == BURST && prob(50))
			qdel(src)	//Remove the egg after it has been hit after bursting.


/obj/structure/alien/egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500)
		health -= 5
		healthcheck()


/obj/structure/alien/egg/HasProximity(atom/movable/AM)
	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.status_flags & XENO_HOST)
			return

		Burst(0)

#undef BURST
#undef BURSTING
#undef GROWING
#undef GROWN
#undef MIN_GROWTH_TIME
#undef MAX_GROWTH_TIME

/*
 * Acid
 */
/obj/effect/alien/acid
	name = "acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon = 'icons/mob/alien.dmi'
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1
	layer = ABOVE_DOOR_LAYER

	var/atom/target
	var/ticks = 0
	var/target_strength = 0

/obj/effect/alien/acid/hyper
	name = "hyper acid"
	desc = "Burbling corrossive stuff. The radical kind."
	icon_state = "acid"

/datum/locking_category/acid

/obj/effect/alien/acid/New(loc, atom/target)
	..(loc)
	src.target = target
	pixel_x = target.pixel_x
	pixel_y = target.pixel_y
	if(istype(target,/atom/movable))
		var/atom/movable/locker = target
		locker.lock_atom(src, /datum/locking_category/acid)

	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 8
	else
		target_strength = 4
	tick()

/obj/effect/alien/acid/proc/tick()
	if(!target)
		qdel(src)
		return

	ticks += 1

	if(ticks >= target_strength)

		visible_message("<span class='good'><B>[src.target] collapses under its own weight into a puddle of goop and undigested debris!</B></span>")
		target.acid_act()
		qdel(src)
		return

	switch(target_strength - ticks)
		if(6)
			visible_message("<span class='good'><B>[src.target] is holding up against the acid!</B></span>")
		if(4)
			visible_message("<span class='good'><B>[src.target]\s structure is being melted by the acid!</B></span>")
		if(2)
			visible_message("<span class='good'><B>[src.target] is struggling to withstand the acid!</B></span>")
		if(0 to 1)
			visible_message("<span class='good'><B>[src.target] begins to crumble under the acid!</B></span>")
	spawn(rand(150, 200)) tick()

/atom/proc/acid_act()

/obj/acid_act()
	qdel(src)

/turf/simulated/wall/acid_act()
	dismantle_wall(1)

/obj/effect/alien/acid/hyper/tick()
	visible_message("<span class='good'><B>[src.target] begins to crumble under the acid!</B></span>")
	spawn(rand(50,100))
		visible_message("<span class='good'><B>[src.target] collapses under its own weight into a puddle of goop and undigested debris!</B></span>")
		if(istype(target, /turf/simulated/wall))
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else
			qdel(target)
		qdel(src)