/datum/emote/silicon
	mob_type_allowed_typelist = list(/mob/living/silicon)
	emote_type = EMOTE_AUDIBLE
	var/module_quirk_required
	var/pai_software_required

/datum/emote/sound/silicon
	mob_type_allowed_typelist = list(/mob/living/silicon, /mob/living/carbon/brain)
	emote_type = EMOTE_AUDIBLE
	var/module_quirk_required
	var/pai_software_required

/datum/emote/sound/silicon/can_run_emote(var/mob/user, var/status_check = TRUE)
	. = ..()
	if (. && isbrain(user) && !module_quirk_required)
		return TRUE
	if (. && isAI(user) && !module_quirk_required)
		return TRUE
	var/mob/living/silicon/pai/the_pai = user
	if (. && istype(the_pai) && (!pai_software_required || (pai_software_required in the_pai.software)))
		return TRUE
	var/mob/living/silicon/robot/R = user
	if (!istype(R))
		return FALSE

/datum/emote/silicon/can_run_emote(var/mob/user, var/status_check = TRUE)
	. = ..()
	var/mob/living/silicon/pai/the_pai = user
	if (. && istype(the_pai) && (!pai_software_required || (pai_software_required in the_pai.software)))
		return TRUE
	var/mob/living/silicon/robot/R = user
	if (!istype(R))
		return FALSE

/datum/emote/silicon/boop
	key = "boop"
	key_third_person = "boops"
	message = "boops."


/datum/emote/sound/silicon/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps."
	message_param = "beeps at %t."
	sound = 'sound/machines/twobeep.ogg'

/datum/emote/sound/silicon/buzz
	key = "buzz"
	key_third_person = "buzzes"
	message = "buzzes."
	message_param = "buzzes at %t."
	sound = 'sound/machines/buzz-sigh.ogg'

/datum/emote/sound/silicon/buzz2
	key = "buzz2"
	message = "buzzes twice."
	sound = 'sound/machines/buzz-two.ogg'

/datum/emote/sound/silicon/chime
	key = "chime"
	key_third_person = "chimes"
	message = "chimes."
	sound = 'sound/machines/chime.ogg'

/datum/emote/sound/silicon/honk
	key = "honk"
	key_third_person = "honks"
	message = "honks."
	vary = TRUE
	sound = 'sound/items/bikehorn.ogg'

/datum/emote/sound/silicon/ping
	key = "ping"
	key_third_person = "pings"
	message = "pings."
	message_param = "pings at %t."
	sound = 'sound/machines/ping.ogg'

/datum/emote/sound/silicon/chime
	key = "chime"
	key_third_person = "chimes"
	message = "chimes."
	sound = 'sound/machines/chime.ogg'

/datum/emote/sound/silicon/warn
	key = "warn"
	message = "blares an alarm!"
	sound = 'sound/machines/warning-buzzer.ogg'

/mob/living/silicon/robot/verb/powerwarn()
	set category = "Robot Commands"
	set name = "Power Warning"

	if(stat != DEAD)
		if(!cell || !cell.charge)
			visible_message("The power warning light on <span class='name'>[src]</span> flashes urgently.")
			to_chat(src, "<span class='info' style=\"font-family:Courier\">You announce you are operating in low power mode.</span>")
			playsound(loc, 'sound/machines/buzz-two.ogg', 50, 0)
		else
			to_chat(src, "<span class='warning'>You can only use this emote when you're out of charge.</span>")
