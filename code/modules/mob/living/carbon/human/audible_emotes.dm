/mob/proc/agony_scream()
	if(stat)
		return
	var/screamsound = null
	var/muzzled = istype(wear_mask, /obj/item/clothing/mask/muzzle)
	var/message = null
	var/M_type = HEARABLE

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(!muzzled)
			if(ismonkey(H))
				screamsound = "sound/voice/monkey_pain[rand(1,3)].ogg"

			else if(src.gender == MALE)
				screamsound = "sound/voice/man_pain[rand(1,3)].ogg"

			else if(H.miming)
				custom_emote(VISIBLE,"[src.name] simula um escândalo!")
				M_type = VISIBLE

			else
				screamsound = "sound/voice/woman_agony[rand(1,3)].ogg"
			message = "grita em agonia!"

		else
			message = "faz um barulho alto!"
			screamsound = "sound/voice/gagscream[rand(1,3)].wav"

	if(screamsound)
		playsound(src, screamsound, 75, 0, 1)

	if(message)
		custom_emote(M_type, message)

/mob/proc/gasp_sound()
	var/gaspsound = null
	var/muzzled = istype(wear_mask, /obj/item/clothing/mask/muzzle)
	if(stat)
		return

	if(muzzled)
		custom_emote(2,"[src.name] makes a muffled gasping noise.")
		return

	if(gender == MALE)
		gaspsound = "sound/voice/gasp_male[rand(1,7)].ogg"

	if(gender == FEMALE)
		gaspsound = "sound/voice/gasp_female[rand(1,7)].ogg"

	if(gaspsound)
		playsound(src, gaspsound, 25, 0, 1)
