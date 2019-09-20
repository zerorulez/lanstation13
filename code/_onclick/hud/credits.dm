#define CREDIT_ROLL_SPEED 120
#define CREDIT_SPAWN_SPEED 4
#define CREDIT_ANIMATE_HEIGHT (16 * world.icon_size) //13 would cause credits to get stacked at the top of the screen, so we let them go past the top edge
#define CREDIT_EASE_DURATION 24

var/global/list/end_titles = list()

/proc/RollCredits()
	global.end_titles += "<br>"
	global.end_titles += "<br>"
	generate_credit_text()
	global.end_titles += "<center><h1>Diretores:</h1>"
	global.end_titles += "<br>"
	global.end_titles += "<center><h2>Morphi</h2>"
	global.end_titles += "<center><h2>Gmaker2</h2>"
	global.end_titles += "<center><h2>Anao22</h2>"
	global.end_titles += "<br>"
	global.end_titles += "<br>"
	global.end_titles += "<center><h1>Continua...</h1>"

	for(var/client/C in global.clients)
		C.screen += new /obj/screen/credit/title_card(null, null, ticker.mode.title_icon)

	sleep(CREDIT_SPAWN_SPEED * 3)
	for(var/i in 1 to end_titles.len)
		var/C = global.end_titles[i]
		if(!C)
			continue

		create_credit(C)
		sleep(CREDIT_SPAWN_SPEED)


/proc/create_credit(credit)
	new /obj/screen/credit(null, credit)

/obj/screen/credit
	icon_state = "blank"
	mouse_opacity = 0
	alpha = 0
	screen_loc = "2,2"
	layer = 10
	plane = CREDITS_PLANE
	var/matrix/target

/obj/screen/credit/New(mapload, credited)
	. = ..()
//	maptext = "<font face='Verdana'>[credited]</font>"
	maptext = credited
	maptext_height = world.icon_size * 2
	maptext_width = world.icon_size * 13
	var/matrix/M = matrix(transform)
	M.Translate(0, CREDIT_ANIMATE_HEIGHT)
	animate(src, transform = M, time = CREDIT_ROLL_SPEED)
	target = M
	animate(src, alpha = 255, time = CREDIT_EASE_DURATION, flags = ANIMATION_PARALLEL)
	add_to_clients()

/obj/screen/credit/proc/add_to_clients()
	for(var/client/C in global.clients)
		C.screen += src

/obj/screen/credit/title_card
	icon = 'icons/titlecards.dmi'
	icon_state = "default"
	screen_loc = "4,1"

/obj/screen/credit/title_card/New(mapload, credited, title_icon_state)
	icon_state = title_icon_state
	. = ..()
	maptext = null

/proc/generate_credit_text()
	get_star()
	ticker.mode.credittext()
	global.end_titles += "<br>"
	draft_caststring()

/proc/get_star()
	var/mob/living/carbon/human/most_talked
	for(var/mob/living/carbon/human/H in mob_list)
		if(!H.key || H.iscorpse)
			continue
		if(!most_talked || H.talkcount > most_talked.talkcount)
			most_talked = H
	global.end_titles += "<center><h1>Estrelando:</h1>"
	global.end_titles += "<br>"
	global.end_titles += "<center><h2>[most_talked.real_name] como [most_talked.mind.assigned_role]</h2>"
	global.end_titles += "<br>"
	global.end_titles += "<br>"

/proc/draft_caststring()
	global.end_titles += "<center><h1>Elenco:<h1>"
	global.end_titles += "<br>"
	for(var/mob/living/carbon/human/H in mob_list)
		if(!H.key || H.iscorpse || H.stat == DEAD)
			continue
		global.end_titles += "<center><h2>[H.real_name] como [H.mind.assigned_role]</h2>"

	for(var/mob/living/silicon/S in mob_list)
		if(!S.key)
			continue
		global.end_titles += "<center><h2>[S.name] como [S.mind.assigned_role]</h2>"

	var/list/corpses = list()
	for(var/mob/living/carbon/human/H in dead_mob_list)
		if(!H.key || H.iscorpse || H.stat != DEAD)
			continue
		corpses += H
	if(corpses.len)
		global.end_titles += "<br>"
		global.end_titles += "<br>"
		global.end_titles += "<center><h1>Em memória daqueles que não sobreviveram:</h1>"
		global.end_titles += "<br>"
		for(var/mob/living/carbon/human/DH in corpses)
			global.end_titles += "<center><h2>[DH.real_name] como [DH.mind.assigned_role]</h2>"
	global.end_titles += "<br>"
	global.end_titles += "<br>"
