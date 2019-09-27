
/datum/artifact_effect/badfeeling
	effecttype = "badfeeling"
	effect_type = 2
	var/list/messages = list("I feel worried.",\
		"Something doesn't feel right.",\
		"I get a strange feeling in your gut.",\
		"My instincts are trying to warn me about something.",\
		"Someone just walked over your grave.",\
		"There's a strange feeling in the air.",\
		"There's a strange smell in the air.",\
		"The tips of your fingers feel tingly.",\
		"I feel twitchy.",\
		"I have a terrible sense of foreboding.",\
		"I've got a bad feeling about this.",\
		"My scalp prickles.",\
		"The light seems to flicker.",\
		"The shadows seem to lengthen.",\
		"The walls are getting closer.",\
		"Something is wrong")

	var/list/drastic_messages = list("I've got to get out of here!",\
		"Someone's trying to kill you!",\
		"There's something out there!",\
		"What's happening to you?",\
		"OH GOD!",\
		"HELP ME!")

/datum/artifact_effect/badfeeling/DoEffectTouch(var/mob/user)
	if(user)
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(prob(50))
				if(prob(75))
					to_chat(H, "<b><font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<font color='red'>[pick(messages)]</font>")

			if(prob(50))
				H.dizziness += rand(3,5)

/datum/artifact_effect/badfeeling/DoEffectAura()
	if(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,holder))
			if(prob(5))
				if(prob(75))
					to_chat(H, "<font color='red'>[pick(messages)]</font>")
				else
					to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")

			if(prob(10))
				H.dizziness += rand(3,5)
		return 1

/datum/artifact_effect/badfeeling/DoEffectPulse()
	if(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,holder))
			if(prob(50))
				if(prob(95))
					to_chat(H, "<font color='red' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<font color='red'>[pick(messages)]</font>")

			if(prob(50))
				H.dizziness += rand(3,5)
			else if(prob(25))
				H.dizziness += rand(5,15)
		return 1
