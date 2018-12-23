//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_stomach()
	spawn(0)
		for(var/mob/living/M in stomach_contents)
			if(M.loc != src)
				stomach_contents.Remove(M)
				continue
			if(istype(M, /mob/living/carbon) && stat & stat != DEAD)//Only digest carbons and only when not dead
				var/digest = 0
				if(M.stat == DEAD)//Only digest if mob inside is dead
					M.death(0)
					if(prob(10))
						switch(digest)
							if(0)
								to_chat(src, "<span class='warning'>My stomach hurts.</span>")
							if(1)
								to_chat(src, "<span class='warning'>My stomach starts rumbling as /the [M] is shifted around.</span>")
							if(2 to INFINITY)
								visible_message(src, "<span class='warning'>\The [src] vomits.</span>", "<span class='warning'>I vomit up what little remains of \the [M].</span>")
								vomit()
								new /obj/effect/decal/remains/human(src.loc)
								M.ghostize(1)
								drop_stomach_contents()
								qdel(M)
						digest++
					continue
				if(SSair.current_cycle % 3 == 1)
					if(!(M.status_flags & GODMODE))
						M.adjustBruteLoss(5)
					nutrition += 10

	//I put the nutriment stuff here
/*
	if(!hardcore_mode_on)
		return //If hardcore mode isn't on, return
	if(!eligible_for_hardcore_mode(src))
		return //If our mob isn't affected by hardcore mode (like it isn't player controlled), return
*/
	if(src.isDead())
		return //Don't affect dead dudes

	if(nutrition < 100) //Nutrition is below 100 = starvation

		var/list/hunger_phrases = list(
			"I feel weak and malnourished. I must find something to eat now",
			"I haven't eaten in ages, and my body feels weak. It's time to eat something",
			"I can barely remember the last time I had a proper, nutritional meal. My body will shut down soon if I don't eat something",
			"My body is running out of essential nutrients! I have to eat something soon",
			"If I don't eat something very soon, I am going to starve to death"
			)

		//When you're starving, the rate at which oxygen damage is healed is reduced by 80% (you only restore 1 oxygen damage per life tick, instead of 5)

		switch(nutrition)
			if(STARVATION_NOTICE to STARVATION_MIN) //60-80
				if(sleeping)
					return

				if(prob(2))
					to_chat(src, "<span class='notice'>[pick("I am very hungry","I really could use a meal right now")]</span>")

			if(STARVATION_WEAKNESS to STARVATION_NOTICE) //30-60
				if(sleeping)
					return

				if(prob(3)) //3% chance of a tiny amount of oxygen damage (1-10)

					adjustOxyLoss(rand(1,10))
					to_chat(src, "<span class='danger'>[pick(hunger_phrases)]</span>")

				else if(prob(5)) //5% chance of being knocked down

					eye_blurry += 10
					Knockdown(10)
					adjustOxyLoss(rand(1,15))
					to_chat(src, "<span class='danger'>I am starving! The lack of strength makes me black out for a few moments...</span>")

			if(STARVATION_NEARDEATH to STARVATION_WEAKNESS) //5-30, 5% chance of weakening and 1-230 oxygen damage. 5% chance of a seizure. 10% chance of dropping item
				if(sleeping)
					return

				if(prob(5))

					adjustOxyLoss(rand(1,20))
					to_chat(src, "<span class='danger'>I am starving. I feel my life force slowly leaving my body...</span>")
					eye_blurry += 20
					if(knockdown < 1)
						Knockdown(20)

				else if(paralysis<1 && prob(5)) //Mini seizure (25% duration and strength of a normal seizure)

					visible_message("<span class='danger'>\The [src] starts having a seizure!</span>", \
							"<span class='warning'>I have a seizure</span>")
					Paralyse(5)
					Jitter(500)
					adjustOxyLoss(rand(1,25))
					eye_blurry += 20

			if(-INFINITY to STARVATION_NEARDEATH) //Fuck the whole body up at this point
				to_chat(src, "<span class='danger'>I am dying from starvation</span>")
				adjustToxLoss(STARVATION_TOX_DAMAGE)
				adjustOxyLoss(STARVATION_OXY_DAMAGE)
				adjustBrainLoss(STARVATION_BRAIN_DAMAGE)

				if(prob(10))
					Knockdown(15)
