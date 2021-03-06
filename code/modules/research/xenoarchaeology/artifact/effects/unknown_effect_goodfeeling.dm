
/datum/artifact_effect/goodfeeling
	effecttype = "goodfeeling"
	effect_type = 2
	var/list/messages = list("I feel good.",\
		"Everything seems to be going alright",\
		"I've got a good feeling about this",\
		"My instincts tell me everything is going to get better.",\
		"There's a good feeling in the air.",\
		"Something smells... good.",\
		"The tips of your fingers feel tingly.",\
		"I've got a good feeling about this.",\
		"I feel happy.",\
		"I fight the urge to smile.",\
		"My scalp prickles.",\
		"All the colours seem a bit more vibrant.",\
		"Everything seems a little lighter.",\
		"The troubles of the world seem to fade away.")

	var/list/drastic_messages = list("I want to hug everyone I meet!",\
		"Everything is going so well!",\
		"I feel euphoric.",\
		"I feel giddy.",\
		"I'am so happy suddenly, you almost want to dance and sing.",\
		"I feel like the world is out to help you.")

/datum/artifact_effect/goodfeeling/DoEffectTouch(var/mob/user)
	if(user)
		if (istype(user, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(prob(50))
				if(prob(75))
					to_chat(H, "<b><font color='blue' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<font color='blue'>[pick(messages)]</font>")

			if(prob(50))
				H.dizziness += rand(3,5)

/datum/artifact_effect/goodfeeling/DoEffectAura()
	if(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,holder))
			if(prob(5))
				if(prob(75))
					to_chat(H, "<font color='blue'>[pick(messages)]</font>")
				else
					to_chat(H, "<font color='blue' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")

			if(prob(5))
				H.dizziness += rand(3,5)
		return 1

/datum/artifact_effect/goodfeeling/DoEffectPulse()
	if(holder)
		for (var/mob/living/carbon/human/H in range(src.effectrange,holder))
			if(prob(50))
				if(prob(95))
					to_chat(H, "<font color='blue' size='[num2text(rand(1,5))]'><b>[pick(drastic_messages)]</b></font>")
				else
					to_chat(H, "<font color='blue'>[pick(messages)]</font>")

			if(prob(50))
				H.dizziness += rand(3,5)
			else if(prob(25))
				H.dizziness += rand(5,15)
		return 1
