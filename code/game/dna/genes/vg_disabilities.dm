
/datum/dna/gene/disability/loud
	name = "Loud"
	desc = "Forces the speaking centre of the subjects brain to yell every sentence."
	activation_message = "YOU FEEL LIKE YELLING!"
	deactivation_message = "You feel like being quiet.."

/datum/dna/gene/disability/loud/New()
	..()
	block = LOUDBLOCK

/datum/dna/gene/disability/loud/OnSay(var/mob/M, var/datum/speech/speech)
	speech.message = replacetext(speech.message,".","!")
	speech.message = replacetext(speech.message,"?","?!")
	speech.message = replacetext(speech.message,"!","!!")

	speech.message = uppertext(speech.message)


/datum/dna/gene/disability/whisper
	name = "Quiet"
	desc = "Damages the subjects vocal cords"
	activation_message = "<i>Your throat feels sore..</i>"
	deactivation_message = "You feel fine again."

/datum/dna/gene/disability/whisper/New()
	..()
	block = WHISPERBLOCK

/datum/dna/gene/disability/whisper/can_activate(var/mob/M,var/flags)
	// No loud whispering.
	if(M_LOUD in M.mutations)
		return 0
	return ..(M,flags)

/datum/dna/gene/disability/whisper/OnSay(var/mob/M, var/datum/speech/speech)
	//M.whisper(message)
	return 0


/datum/dna/gene/disability/dizzy
	name = "Dizzy"
	desc = "Causes the cerebellum to shut down in some places."
	activation_message = "You feel very dizzy..."
	deactivation_message = "You regain your balance."
	flags = GENE_UNNATURAL

/datum/dna/gene/disability/dizzy/New()
	..()
	block = DIZZYBLOCK

/datum/dna/gene/disability/dizzy/OnMobLife(var/mob/living/carbon/human/M)
	if(!istype(M))
		return
	if(M_DIZZY in M.mutations)
		M.Dizzy(300)


/datum/dna/gene/disability/sans
	name = "Wacky"
	desc = "Forces the subject to talk in an odd manner."
	activation_message = "You feel an off sensation in your voicebox.."
	deactivation_message = "The off sensation passes.."

/datum/dna/gene/disability/sans/New()
	..()
	block = SANSBLOCK

/datum/dna/gene/disability/sans/OnSay(var/mob/M, var/datum/speech/speech)
	speech.message_classes.Add("sans") // SPEECH 2.0!!!1
