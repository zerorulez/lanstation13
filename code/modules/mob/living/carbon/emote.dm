/datum/emote/living/carbon
	mob_type_allowed_typelist = list(/mob/living/carbon)

/datum/emote/living/carbon/airguitar
	key = "airguitar"
	message = "is strumming the air and headbanging like a safari chimp."
	restraint_check = TRUE

/datum/emote/living/carbon/blink
	key = "blink"
	key_third_person = "blinks"
	message = "pisca."

/datum/emote/living/carbon/blink_r
	key = "blink_r"
	message = "pisca rapidamente."

/datum/emote/living/carbon/gnarl
	key = "gnarl"
	key_third_person = "gnarls"
	message = "gnarls and shows its teeth..."
	mob_type_allowed_typelist = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)

/datum/emote/living/carbon/moan
	key = "moan"
	key_third_person = "moans"
	message = "geme!"
	message_mime = "appears to moan!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/roll
	key = "roll"
	key_third_person = "rolls"
	message = "rolls."
	mob_type_allowed_typelist = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)
	restraint_check = TRUE

/datum/emote/living/carbon/scratch
	key = "scratch"
	key_third_person = "scratches"
	message = "scratches."
	mob_type_allowed_typelist = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)
	restraint_check = TRUE

/datum/emote/living/carbon/screech
	key = "screech"
	key_third_person = "screeches"
	message = "screeches."
	mob_type_allowed_typelist = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)

/datum/emote/living/carbon/sign
	key = "sign"
	key_third_person = "signs"
	message_param = "signs the number %t."
	mob_type_allowed_typelist = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)
	restraint_check = TRUE

/datum/emote/living/carbon/sign/select_param(mob/user, params)
	. = ..()
	if(!isnum(text2num(params)))
		return message

/datum/emote/living/carbon/sign/signal
	key = "signal"
	key_third_person = "signals"
	message_param = "levanta %t dedos."
	mob_type_allowed_typelist = list(/mob/living/carbon/human)
	restraint_check = TRUE

/datum/emote/living/carbon/tail
	key = "tail"
	message = "balança sua cauda."
	mob_type_allowed_typelist = list(/mob/living/carbon/monkey, /mob/living/carbon/alien)

/datum/emote/living/carbon/wink
	key = "wink"
	key_third_person = "winks"
	message = "dá uma piscadela."

/datum/emote/living/carbon/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "tem um espasmo violento."

/datum/emote/living/carbon/twitch_s
	key = "twitch_s"
	message = "tem um espasmo."

/datum/emote/living/carbon/wave
	key = "wave"
	key_third_person = "waves"
	message = "acena com a mão."

/datum/emote/living/carbon/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."
	message_mime = "appears hurt."

/datum/emote/living/carbon/wsmile
	key = "wsmile"
	key_third_person = "wsmiles"
	message = "dá um leve sorriso."

/datum/emote/living/carbon/sniff
	key = "sniff"
	key_third_person = "sniffs"
	message = "sniffs."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/snore
	key = "snore"
	key_third_person = "snores"
	message = "ronca."
	message_mime = "ronca silenciosamente."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS

/datum/emote/living/carbon/pout
	key = "pout"
	key_third_person = "pouts"
	message = "faz beicinho."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/scowl
	key = "scowl"
	key_third_person = "scowls"
	message = "franze as sombrancelhas."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/shake
	key = "shake"
	key_third_person = "shakes"
	message = "balança sua cabeça."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/shiver
	key = "shiver"
	key_third_person = "shiver"
	message = "tem um calafrio."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/kiss
	key = "kiss"
	key_third_person = "kisses"
	message = "sopra um beijo."
	message_param = "sopra um beijo para %t."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/gag
	key = "gag"
	key_third_person = "gags"
	message = "gags."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/grin
	key = "grin"
	key_third_person = "grins"
	message = "dá um grande sorriso."

/datum/emote/living/carbon/groan
	key = "groan"
	key_third_person = "groans"
	message = "groans!"
	message_mime = "appears to groan!"

/datum/emote/living/carbon/grimace
	key = "grimace"
	key_third_person = "grimaces"
	message = "grimaces."

/datum/emote/living/carbon/burp
	key = "burp"
	key_third_person = "burps"
	message = "arrota."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/choke
	key = "choke"
	key_third_person = "chokes"
	message = "chokes!"
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "chuckles."
	emote_type = EMOTE_AUDIBLE

/datum/emote/living/carbon/blush
	key = "blush"
	key_third_person = "blushes"
	message = "se envergonha."

/datum/emote/living/carbon/sound/scream
	key = "scream"
	key_third_person = "screams"
	message = "grita!"
	message_mime = "finge que está gritando!"
	emote_type = EMOTE_AUDIBLE
	male_sounds =  list('sound/emotes/man_pain.ogg', 'sound/emotes/man_pain2.ogg', 'sound/emotes/man_pain3.ogg')
	female_sounds = list('sound/emotes/fear_woman1.ogg', 'sound/emotes/fear_woman2.ogg', 'sound/emotes/fear_woman3.ogg')
	voxemote = FALSE

/datum/emote/living/carbon/sound/clearthroat
	key = "clearthroat"
	key_third_person = "clearthroat"
	message = "limpa sua garganta."
	emote_type = EMOTE_AUDIBLE
	male_sounds = list('sound/emotes/throatclear_male.ogg')
	female_sounds = list('sound/emotes/throatclear_female.ogg')

/datum/emote/living/carbon/sound/gasp
	key = "gasp"
	key_third_person = "gasps"
	message = "gasps!"
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	male_sounds = list('sound/emotes/gasp_male1.ogg', 'sound/emotes/gasp_male2.ogg', 'sound/emotes/gasp_male3.ogg', 'sound/emotes/gasp_male4.ogg', 'sound/emotes/gasp_male5.ogg', 'sound/emotes/gasp_male6.ogg', 'sound/emotes/gasp_male7.ogg')
	female_sounds = list('sound/emotes/gasp_female1.ogg', 'sound/emotes/gasp_female2.ogg', 'sound/emotes/gasp_female3.ogg', 'sound/emotes/gasp_female4.ogg', 'sound/emotes/gasp_female5.ogg', 'sound/emotes/gasp_female6.ogg', 'sound/emotes/gasp_female7.ogg')
	sound_message = "gasps!"

/datum/emote/living/carbon/sound/cry
	key = "cry"
	key_third_person = "cries"
	message = "chora."
	message_mime = "finge que está chorando."
	emote_type = EMOTE_AUDIBLE
	male_sounds = list('sound/emotes/cry_man01.ogg', 'sound/emotes/cry_man02.ogg')
	female_sounds = list('sound/emotes/cry_woman01.ogg', 'sound/emotes/cry_woman02.ogg', 'sound/emotes/cry_woman03.ogg')

/datum/emote/living/carbon/sound/shriek
	key = "shriek"
	key_third_person = "shrieks"
	message = "shrieks!"
	message_mime = "acts out a shriek!"
	emote_type = EMOTE_AUDIBLE
	birb_sounds = list('sound/misc/shriek1.ogg')
	sound_message = "shrieks in agony!"
	voxemote = TRUE
	voxrestrictedemote = TRUE

/datum/emote/living/carbon/sound/cough
	key = "cough"
	key_third_person = "coughs"
	message = "tosse!"
	message_mime = "tosse silenciosamente!"
	emote_type = EMOTE_AUDIBLE
	male_sounds = list('sound/emotes/cough01_man.ogg', 'sound/emotes/cough02_man.ogg', 'sound/emotes/cough03_man.ogg', 'sound/emotes/cough04_man.ogg', 'sound/emotes/cough_01.ogg', 'sound/emotes/cough_02.ogg')
	female_sounds = list('sound/emotes/cough_female.ogg', 'sound/emotes/cough01_woman.ogg', 'sound/emotes/cough02_woman.ogg', 'sound/emotes/cough03_woman.ogg', 'sound/emotes/cough04_woman.ogg', 'sound/emotes/cough05_woman.ogg', 'sound/emotes/cough06_woman.ogg', 'sound/emotes/cough07_woman.ogg')

/datum/emote/living/carbon/sound/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "dá uma risada."
	message_mime = "laughs silently!"
	emote_type = EMOTE_AUDIBLE
	male_sounds = list('sound/emotes/01laugh1.wav', 'sound/emotes/01laugh2.wav', 'sound/emotes/01laugh3.wav', 'sound/emotes/01laugh5.wav', 'sound/emotes/01laugh6.wav', 'sound/emotes/01laugh7.wav', 'sound/emotes/01laugh8.wav')
	female_sounds = list('sound/emotes/laugh_female1.ogg', 'sound/emotes/laugh_female2.ogg')

/datum/emote/living/carbon/sound/sigh
	key = "sigh"
	key_third_person = "sighs"
	message = "suspira fundo."
	emote_type = EMOTE_AUDIBLE
	male_sounds = list('sound/emotes/sigh_male.ogg')
	female_sounds = list('sound/emotes/sigh_woman.ogg')

/datum/emote/living/carbon/sound/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "boceja."
	emote_type = EMOTE_AUDIBLE
	male_sounds = list('sound/emotes/yawn01_man.ogg', 'sound/emotes/yawn02_man.ogg')
	female_sounds = list('sound/emotes/yawn01_woman.ogg', 'sound/emotes/yawn02_woman.ogg', 'sound/emotes/yawn03_woman.ogg')

/datum/emote/living/carbon/sound/clap
	key = "clap"
	key_third_person = "claps"
	message = "bate palmas."
	muzzle_ignore = TRUE
	restraint_check = TRUE
	emote_type = EMOTE_AUDIBLE
	male_sounds = list('sound/emotes/clap.wav')
	female_sounds = list('sound/emotes/clap.wav')

/datum/emote/living/carbon/sound/giggle
	key = "giggle"
	key_third_person = "giggles"
	message = "dá uma risadinha."
	emote_type = EMOTE_AUDIBLE
	male_sounds = list()
	female_sounds = list('sound/emotes/giggle01_woman.ogg', 'sound/emotes/giggle02_woman.ogg')

/datum/emote/living/carbon/sound/run_emote(mob/user, params)
	var/mob/living/carbon/human/H = user
	if (!istype(H))
		return ..()
	if (H.stat == DEAD)
		return
	if (!H.is_muzzled() && !issilent(H)) // Silent = mime, mute species.
		if(world.time-H.last_emote_sound >= 30) //prevent spam
			if(sound_message)
				message = sound_message
			var/list/sound
			if (isvox(H))
				sound = pick(birb_sounds)

			else
				switch(H.gender)
					if (MALE)
						sound = male_sounds
					if (FEMALE)
						sound = female_sounds
			if(sound && sound.len)
				playsound(user, pick(sound), 50, 0)
			H.last_emote_sound = world.time
	else
		message = "makes a very loud noise."

	return ..()
