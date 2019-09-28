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
								to_chat(src, "<span class='warning'>Your stomach hurts.</span>")
							if(1)
								to_chat(src, "<span class='warning'>Your stomach starts rumbling as /the [M] is shifted around.</span>")
							if(2 to INFINITY)
								visible_message(src, "<span class='warning'>\The [src] vomits.</span>", "<span class='warning'>You vomit up what little remains of \the [M].</span>")
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
