/mob/living/carbon/alien/humanoid/hunter
	name = "alien hunter" //The alien hunter, not Alien Hunter
	caste = "h"
	maxHealth = 250
	health = 250
	plasma = 100
	max_plasma = 150
	icon_state = "alienh_s"
	plasma_rate = 5

/mob/living/carbon/alien/humanoid/hunter/proc/toggle_leap()
	leap_on_click = !leap_on_click
	leap_icon.icon_state = "leap_[leap_on_click ? "on":"off"]"
	update_icons()

/mob/living/carbon/alien/humanoid/hunter/movement_delay()
	var/tally = -1 + move_delay_add + config.alien_delay //Hunters are fast

	var/turf/T = loc
	if(istype(T))
		tally = T.adjust_slowdown(src, tally)

	return tally

/mob/living/carbon/alien/humanoid/hunter/ClickOn(var/atom/A, var/params)
	face_atom(A)
	if(leap_on_click)
		leap_at(A)
	else
		..()


#define MAX_ALIEN_LEAP_DIST 7

/mob/living/carbon/alien/humanoid/hunter/proc/leap_at(var/atom/A)
	if(!canmove || lying || leaping)
		return

	if(pounce_cooldown > world.time)
		to_chat(src, "<span class='alertalien'>You are too fatigued to pounce right now!</span>")
		return

	pass_flags |= PASSTABLE
	var/turf/T = get_turf(src)
	var/area/AR = get_area(T)
	if(!T.has_gravity() || !AR.has_gravity)
		src << "<span class='alertalien'>It is unsafe to leap without gravity!</span>"
		//It's also extremely buggy visually, so it's balance+bugfix
		return
	else //Maybe uses plasma in the future, although that wouldn't make any sense...
		pounce_cooldown = world.time + pounce_cooldown_time
		leaping = TRUE
		update_icons()
		throw_at(A,MAX_ALIEN_LEAP_DIST,1)
		leaping = FALSE
		update_icons()
	toggle_leap()

	pass_flags &= ~PASSTABLE

/mob/living/carbon/alien/humanoid/hunter/throw_impact(atom/A)
	if(!leaping)
		return ..()

	if(A)
		if(isliving(A))
			var/blocked = FALSE
			var/mob/living/L = A
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				if(H.check_shields(0, "the [name]"))
					blocked = TRUE
			if(!blocked)
				L.visible_message("<span class ='danger'>[src] pounces on [L]!</span>", "<span class ='userdanger'>[src] pounces on you!</span>")
				L.Knockdown(10)
				sleep(2)//Runtime prevention (infinite bump() calls on hulks)
				step_towards(src,L)
			else
				Knockdown(20)
	if(leaping)
		leaping = FALSE
		update_canmove()
		update_icons()

//Modified throw_at() that will use diagonal dirs where appropriate
//instead of locking it to cardinal dirs
/mob/living/carbon/alien/humanoid/throw_at(atom/target, range, speed)
	if(!target || !src)	return 0

	src.throwing = 1

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dist_travelled = 0
	var/dist_since_sleep = 0

	var/tdist_x = dist_x;
	var/tdist_y = dist_y;

	if(dist_x <= dist_y)
		tdist_x = dist_y;
		tdist_y = dist_x;

	var/error = tdist_x/2 - tdist_y
	while(target && (((((dist_x > dist_y) && ((src.x < target.x) || (src.x > target.x))) || ((dist_x <= dist_y) && ((src.y < target.y) || (src.y > target.y))) || (src.x > target.x)) && dist_travelled < range)))

		if(!src.throwing) break
		if(!istype(src.loc, /turf)) break

		var/atom/step = get_step(src, get_dir(src,target))
		if(!step)
			break
		src.Move(step, get_dir(src, step))
		hit_check()
		error += (error < 0) ? tdist_x : -tdist_y;
		dist_travelled++
		dist_since_sleep++
		if(dist_since_sleep >= speed)
			dist_since_sleep = 0
			sleep(1)


	src.throwing = 0

	return 1

/mob/living/carbon/alien/humanoid/hunter/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	if(name == "alien hunter")
		name = text("alien hunter ([rand(1, 1000)])")
	real_name = name
	..()
	add_language(LANGUAGE_XENO)
	default_language = all_languages[LANGUAGE_XENO]

/mob/living/carbon/alien/humanoid/hunter
	handle_regular_hud_updates()

		..() //-Yvarov

		if(healths)
			if(stat != 2)
				switch(health)
					if(250 to INFINITY)
						healths.icon_state = "health0"
					if(150 to 250)
						healths.icon_state = "health1"
					if(100 to 150)
						healths.icon_state = "health2"
					if(50 to 100)
						healths.icon_state = "health3"
					if(0 to 50)
						healths.icon_state = "health4"
					else
						healths.icon_state = "health5"
			else
				healths.icon_state = "health6"


	handle_environment()
		if(m_intent == "run" || resting)
			..()
		else
			AdjustPlasma(-heal_rate)


//Hunter verbs
//This ought to be fixed, maybe not now though
/*
/mob/living/carbon/alien/humanoid/hunter/verb/invis()
	set name = "Invisibility (50)"
	set desc = "Makes you invisible for 15 seconds"
	set category = "Alien"

	if(alien_invis)
		update_icons()
	else
		if(powerc(50))
			AdjustPlasma(-50)
			alien_invis = 1.0
			update_icons()
			to_chat(src, "<span class='good'>You are now invisible.</span>")
			visible_message("<span class='danger'>\The [src] fades into the surroundings!</span>", "<span class='alien'>You are now invisible</span>")
			spawn(250)
				if(!isnull(src)) //Don't want the game to runtime error when the mob no-longer exists.
					alien_invis = 0.0
					update_icons()
					to_chat(src, "<span class='alien'>You are no longer invisible.</span>")
	return
*/