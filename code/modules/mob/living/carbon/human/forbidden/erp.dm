/*
 *
 * FORBIDDEN FRUITS
 *
 */

/mob/living/carbon/human
	var/pleasure = 0

	var/virgin = TRUE
	var/anal_virgin = TRUE
	var/penis_size = 0

	var/mob/living/carbon/human/lastfucked		// Last person you did something
	var/datum/forbidden/action/lfaction			// Last action you did to someone

	var/mob/living/carbon/human/lastreceived	// Last person you reveived something
	var/datum/forbidden/action/lraction			// Last action you received by someone

	var/click_CD
	var/remove_CD
	var/pleasure_CD

	var/last_cum

/*
 * UI
 */

/mob/living/carbon/human/MouseDrop_T(mob/living/carbon/human/target, mob/living/carbon/human/user)
	// User drag himself to [src]
	if(istype(target) && istype(user))
		if(user == target && get_dist(user, src) <= 1)
			ui_interact(user)
	return ..()

/mob/living/carbon/human/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(!ishuman(user))
		return 0

	var/list/penis_actions = list()
	var/list/vagina_actions = list()
	var/list/mouth_actions = list()
	var/list/misc_actions = list()
	for(var/key in forbidden_actions)
		var/datum/forbidden/action/A = forbidden_actions[key]

		var/c = A.conditions(user, src)
		if(c == -1)
			continue

		if(isoral(A))
			mouth_actions.Add(list(list(\
				"action_button" = A.actionButton(user, src), \
				"status" = (c ? null : "disabled"), \
				"name" = A.name)))
		else if(isfuck(A))
			penis_actions.Add(list(list(\
				"action_button" = A.actionButton(user, src), \
				"status" = (c ? null : "disabled"), \
				"name" = A.name)))
		else if(isvagina(A))
			vagina_actions.Add(list(list(\
				"action_button" = A.actionButton(user, src), \
				"status" = (c ? null : "disabled"), \
				"name" = A.name)))
		else
			misc_actions.Add(list(list(\
				"action_button" = A.actionButton(user, src), \
				"status" = (c ? null : "disabled"), \
				"name" = A.name)))


	var/list/emote_list = list()
	for(var/key in forbidden_emotes)
		var/datum/forbidden/emote/E = forbidden_emotes[key]

		var/c = E.conditions(user, src)
		if(c == -1)
			continue

		emote_list.Add(list(list(\
			"action_button" = E.actionButton(user, src), \
			"status" = (c ? null : "disabled"), \
			"name" = E.name)))

	var/icon_action = "venus-mars"

	if(gender == user.gender && gender == MALE)
		icon_action = "venus-double"
	else if(gender == user.gender && gender == FEMALE)
		icon_action = "mars-double"

	var/list/data = list(
			"lens" = list("penis_len" = penis_actions.len, "vagina_len" = vagina_actions.len, "mouth_len" = mouth_actions.len, "misc_len" = misc_actions.len, "emote_len" = emote_list.len),
			"penis_list" = penis_actions,
			"vagina_list" = vagina_actions,
			"mouth_list" = mouth_actions,
			"misc_list" = misc_actions,
			"emote_list" = emote_list,
			"src_name" = name,
			"icon" = icon_action
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if(!ui)
		ui = new(user, src, ui_key, "erp.tmpl", "Forbidden Fruits", 460, 550)
		ui.set_initial_data(data)
		ui.open()


/mob/living/carbon/human/proc/process_erp_href(href_list, mob/living/carbon/human/user)
	if(user.restrained())
		return 0
	if(href_list["action"])
		if(!(href_list["action"] in forbidden_actions))
			return 1

		var/datum/forbidden/action/A = forbidden_actions[href_list["action"]]
		if(!A.conditions(user, src))
			return 1
		user.fuck(src, A)
		return 1

	if(href_list["emote"])
		if(!(href_list["emote"] in forbidden_emotes))
			return 1

		var/datum/forbidden/emote/M = forbidden_emotes[href_list["emote"]]
		if(!M.conditions(user, src))
			return 1

		user.actionEmote(src, M)
		return 1


/*
 *
 * HELPERS PROCS
 *
 */

/*
 * IS HELPERS
 */
/mob/living/carbon/human/proc/is_nude()
	if(wear_suit && !check_hidden_body_flags(HIDEJUMPSUIT))
		return FALSE
	if(w_uniform)
		return FALSE
	return TRUE

mob/living/carbon/human/proc/breast_nude()
	if(wear_suit && !check_hidden_body_flags(HIDEJUMPSUIT))
		return FALSE
	if(w_uniform)
		return FALSE
	return TRUE

/mob/living/carbon/human/proc/is_face_clean()
	if(check_body_part_coverage(MOUTH))
		return FALSE
	return TRUE

/*
 * HAS HELPERS
 */
/mob/living/carbon/human/proc/has_penis()
	var/datum/organ/external/G = organs_by_name["groin"]
	return (species.genitals && gender == MALE && (G && G.is_usable()))

/mob/living/carbon/human/proc/has_vagina()
	var/datum/organ/external/G = organs_by_name["groin"]
	return (species.genitals && gender == FEMALE && (G && G.is_usable()))

/mob/living/carbon/human/proc/has_hands()
	var/datum/organ/external/H = organs_by_name["r_hand"]
	var/hashands = (H && H.is_usable())
	if(!hashands)
		H = organs_by_name["l_hand"]
		hashands = (H && H.is_usable())
	return hashands

/mob/living/carbon/human/proc/has_foots()
	var/datum/organ/external/F = organs_by_name["r_foot"]
	var/hashands = (F && F.is_usable())
	if(!hashands)
		F = organs_by_name["l_foot"]
		hashands = (F && F.is_usable())
	return hashands

/*
 * ACTION HELPERS
 */
/mob/living/carbon/human/proc/do_fucking_animation(mob/living/carbon/human/P)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/final_pixel_y = initial(pixel_y)

	var/direction = get_dir(src, P)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	if(pixel_x_diff == 0 && pixel_y_diff == 0)
		pixel_x_diff = rand(-3,3)
		pixel_y_diff = rand(-3,3)
		animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
		animate(pixel_x = initial(pixel_x), pixel_y = initial(pixel_y), time = 2)
		return

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = initial(pixel_x), pixel_y = final_pixel_y, time = 2)

/*
 * Forbidden Controller
 */

/mob/living/carbon/human/proc/fuck(mob/living/carbon/human/P, datum/forbidden/action/action)
	if(!istype(P) || !istype(action) || !check_forbidden_cooldown())
		return 0

	if(!action.conditions(src, P))
		return 0

	P.remove_CD = world.time + 100
	remove_CD = world.time + 100

	pleasure_CD = 150
	P.pleasure_CD = 150

	click_CD = world.time + 5

	face_atom(P)

	lfaction = action
	lastfucked = P

	var/begins = 0
	if(P.lastreceived != src || P.lraction != action)
		begins = 1
		action.logAction(src, P)

	action.fuckText(src, P, begins)
	action.doAction(src, P, begins)

	P.lastreceived = src
	P.lraction = action

	return 1

/mob/living/carbon/human/proc/moan()
	if(stat != DEAD)
		// Pleasure messages
		if(pleasure >= 70 && prob(15) && gender == FEMALE)
			visible_message("<span class='erp'><b>[src]</b> twists in orgasm!</span>")
			if(gender == FEMALE)
				playsound(loc, "sound/forbidden/erp/moan_f[rand(1, 7)].ogg", 50, 1, 0)
			else
				playsound(loc, "sound/forbidden/erp/moan_m[rand(0, 12)].ogg", 50, 1, 0)
		if(pleasure >= 10 && prob(15))
			visible_message("<span class='erp'><b>[src]</b> [gender == FEMALE ? pick("moans in pleasure", "moans") : "moans"].</span>")
			if(gender == FEMALE)
				playsound(loc, "sound/forbidden/erp/moan_f[rand(1, 7)].ogg", 50, 1, 0)
			else
				playsound(loc, "sound/forbidden/erp/moan_m[rand(0, 12)].ogg", 50, 1, 0)
/mob/living/carbon/human/proc/cum(mob/living/carbon/human/P, hole = "floor")
	if(stat == DEAD)
		return 0

	if(last_cum > world.time)
		return

	var/pleasure_message = pick("... I'M FEELING SO GOOD! ...",  "... It's just INCREDIBLE! ...", "... MORE AND MORE AND MORE! ...")
	to_chat(src, "<span class='cum'>[pleasure_message]</span>")

	if(has_penis())
		switch(hole)
			if("floor")
				visible_message("<span class='cum'>[src] cums on the floor!</span>")
			if("vagina")
				visible_message("<span class='cum'>[src] cums into <b>[P]</b>!</span>")
			if("anus")
				visible_message("<span class='cum'>[src] cums into [P]'s ass!</span>")
			if("mouth")
				visible_message("<span class='cum'>[src] cums into [P]'s mouth!</span>")
		var/obj/effect/decal/cleanable/sex/cum = new /obj/effect/decal/cleanable/sex/semen(loc)
		cum.blood_DNA = blood_DNA.Copy()
		playsound(loc, "sound/forbidden/erp/final_m[rand(1, 5)].ogg", 50, 1, 0)
	else if(has_vagina())
		visible_message("<span class='cum'>[src] cums!</span>")
		var/obj/effect/decal/cleanable/sex/cum = new /obj/effect/decal/cleanable/sex/femjuice(loc)
		cum.blood_DNA = blood_DNA.Copy()
		playsound(loc, "sound/forbidden/erp/final_f[rand(1, 3)].ogg", 50, 1, 0)
	else
		visible_message("<span class='cum'>[src] cums!</span>")

	add_logs(P, src, "came on")

	last_cum = world.time + rand(100, 600)

/mob/living/carbon/human/proc/handle_lust()
	if(world.time >= remove_CD)
		if(lastfucked)
			if(lastfucked.lastreceived == src)
				lastfucked.lastreceived = null
				lastfucked.lraction = null
			lastfucked = null
			lfaction = null

		if(world.time >= pleasure_CD)
			pleasure -= 3
			pleasure_CD = world.time + 150


	if(pleasure <= 0)
		pleasure = 0

/mob/living/carbon/human/proc/check_forbidden_cooldown()
	if(world.time >= click_CD)
		return TRUE
	return FALSE


/mob/living/carbon/human/verb/interact()
	set name = "Interact"
	set category = "IC"
	set src in view(1)

	if(!ishuman(usr))
		return

	if(usr.incapacitated())
		return

	ui_interact(usr)