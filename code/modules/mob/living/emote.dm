/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typelist = list(/mob/living)
	mob_type_blacklist_typelist = list(/mob/living/simple_animal/slime, /mob/living/carbon/brain, /mob/living/silicon/ai, /mob/living/silicon/pai)

/datum/emote/living/bow
	key = "bow"
	key_third_person = "bows"
	message = "se curva."
	message_param = "se curva diante de %t."
	restraint_check = TRUE

/datum/emote/living/cross
	key = "cross"
	key_third_person = "crosses"
	message = "cruza os braços."
	message_mommi = "crosses their utility arms."
	restraint_check = TRUE

/datum/emote/living/collapse
	key = "collapse"
	key_third_person = "collapses"
	message = "collapses!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/glare
	key = "glare"
	key_third_person = "glares"
	message = "glares."
	message_mommi = "glares as best a robot spider can glare."
	message_param = "glares at %t."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/collapse/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Knockdown(10)
		L.Stun(10)

/datum/emote/living/dance
	key = "dance"
	key_third_person = "dances"
	message = "dances around happily."
	restraint_check = TRUE

/datum/emote/living/deathgasp
	key = "deathgasp"
	key_third_person = "deathgasps"
	message = "dá seu último suspiro e seus olhos perdem a vida..."
	message_robot = "shudders violently for a moment before falling still, its eyes slowly darkening."
	message_AI = "lets out a flurry of sparks, its screen flickering as its systems slowly halt."
	message_alien = "lets out a waning guttural screech, green blood bubbling from its maw..."
	message_larva = "lets out a sickly hiss of air and falls limply to the floor..."
	message_monkey = "lets out a faint chimper as it collapses and stops moving..."
	message_simple =  "stops moving..."
	mob_type_blacklist_typelist = list(/mob/living/carbon/brain) // Everyone can deathgasp

/datum/emote/living/deathgasp/run_emote(mob/living/user, params)
	. = ..()
	if(. && isalienadult(user))
		playsound(user.loc, 'sound/voice/hiss6.ogg', 80, 1, 1)
	if (. && user.stat == UNCONSCIOUS && !params)
		user.succumb_proc(0, 1)
	message = initial(message)

/datum/emote/living/carbon/drool
	key = "drool"
	key_third_person = "drools"
	message = "baba."

/datum/emote/living/faint
	key = "faint"
	key_third_person = "faints"
	message = "desmaia."

/datum/emote/living/faint/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.sleeping += 10 // You can't faint when you're asleep.

/datum/emote/living/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frowns."

/datum/emote/living/jump
	key = "jump"
	key_third_person = "jumps"
	message = "dá um pulo!"
	restraint_check = TRUE

/datum/emote/living/laugh/can_run_emote(mob/living/user, var/status_check = TRUE)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent

/datum/emote/living/look
	key = "look"
	key_third_person = "looks"
	message = "olha."
	message_param = "olha %t."

/datum/emote/living/nod
	key = "nod"
	key_third_person = "nods"
	message = "acena com a cabeça."
	message_mommi = "bobs its body in a rough approximation of nodding."
	message_param = "nods at %t."

/datum/emote/living/point
	key = "point"
	key_third_person = "points"
	message = "aponta."
	message_param = "aponta para %t."
	restraint_check = TRUE

/datum/emote/living/sit
	key = "sit"
	key_third_person = "sits"
	message = "senta."

/datum/emote/living/smile
	key = "smile"
	key_third_person = "smiles"
	message = "sorri."

/datum/emote/living/carbon/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "espirra"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/smug
	key = "smug"
	key_third_person = "smugs"
	message = "dá um sorriso presunçoso."

/datum/emote/living/stare
	key = "stare"
	key_third_person = "stares"
	message = "olha fixamente."
	message_param = "olha fixamente para %t."

/datum/emote/living/strech
	key = "stretch"
	key_third_person = "stretches"
	message = "alonga os braços."

/datum/emote/living/sulk
	key = "sulk"
	key_third_person = "sulks"
	message = "sulks down sadly."

/datum/emote/living/surrender
	key = "surrender"
	key_third_person = "surrenders"
	message = "coloca as mãos na cabeça e deita no chão."

/datum/emote/living/surrender/run_emote(mob/user, params)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Knockdown(10)
		L.Stun(10)

/datum/emote/living/sway
	key = "sway"
	key_third_person = "sways"
	message = "sways around dizzily."

/datum/emote/living/tremble
	key = "tremble"
	key_third_person = "trembles"
	message = "trembles in fear!"

/datum/emote/living/custom
	key = "custom"
	message = null

	mob_type_blacklist_typelist = list() // Everyone can custom emote.

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	. = TRUE
	if(copytext(input,1,5) == "says")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else if(copytext(input,1,9) == "exclaims")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else if(copytext(input,1,6) == "yells")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else if(copytext(input,1,5) == "asks")
		to_chat(user, "<span class='danger'>Invalid emote.</span>")
	else
		. = FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null)
	if(jobban_isbanned(user, "emote"))
		to_chat(user, "You cannot send custom emotes (banned).")
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, "You cannot send IC messages (muted).")
		return FALSE
	else if(!params)
		var/custom_emote = copytext(sanitize(input("Choose an emote to display.") as text|null), 1, MAX_MESSAGE_LEN)
		if(custom_emote && !check_invalid(user, custom_emote))
			var/type = input("Is this a visible or hearable emote?") as null|anything in list("Visible", "Hearable")
			switch(type)
				if("Visible")
					emote_type = EMOTE_VISIBLE
				if("Hearable")
					emote_type = EMOTE_AUDIBLE
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
			message = custom_emote
	else
		message = params
		if(type_override)
			emote_type = type_override
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/help
	key = "help"

/datum/emote/living/help/run_emote(mob/user, params)
	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	var/datum/emote/E

	for(var/e in emote_list)
		if(e in keys)
			continue
		E = emote_list[e]
		if(E.can_run_emote(user, status_check = FALSE))
			keys += E.key

	keys = sortList(keys)

	for(var/emote in keys)
		if(message.len > 1)
			message += ", [emote]"
		else
			message += "[emote]"

	message += "."

	message = jointext(message, "")

	to_chat(user, message)
