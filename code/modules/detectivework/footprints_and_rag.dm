/mob
	var/bloody_hands = 0
	var/mob/living/carbon/human/bloody_hands_mob
	var/track_blood = 0
	var/list/feet_blood_DNA
	var/feet_blood_color
	var/track_blood_type

/obj/item/clothing/gloves
	var/transfer_blood = 0
	var/mob/living/carbon/human/bloody_hands_mob

/obj/item/clothing/shoes/
	var/track_blood = 0

/obj/item/weapon/reagent_containers/glass/rag
	name = "rag" //changed to "rag" from "damp rag" - Hinaichigo
	desc = "For cleaning up messes, you suppose."
	w_class = W_CLASS_TINY
	icon = 'icons/obj/toy.dmi'
	icon_state = "rag"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10)
	volume = 10
	can_be_placed_into = null

/obj/item/weapon/reagent_containers/glass/rag/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/glass/rag/mop_act(obj/item/weapon/mop/M, mob/user)
	return 0

/obj/item/weapon/reagent_containers/glass/rag/attack(mob/living/M as mob, mob/living/user as mob, def_zone)
	if(user.zone_sel.selecting == "mouth")
		if(ismob(M) && M.reagents && reagents.total_volume)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.check_body_part_coverage(MOUTH))
					to_chat(user, "<span class='warning'>It won't work. Their mouth needs to be uncovered..</span>")
					return FALSE
			user.visible_message("<span class='warning'>\The [M] has been smothered with \the [src] by \the [user]!</span>", "<span class='warning'>You smother \the [M] with \the [src]!</span>", "I hear some struggling and muffled cries of surprise")
			src.reagents.reaction(M, TOUCH)
			spawn(5) src.reagents.clear_reagents()
			return TRUE
	else
		..()

/obj/item/weapon/reagent_containers/glass/rag/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return // Not adjacent

	if(ismob(target) && user.zone_sel.selecting == "mouth")
		return

	if(reagents.total_volume < 1)
		to_chat(user, "<span class='notice'>Your rag is dry!</span>")
		return

	if(target)
		target.clean_blood()
		if(isturf(target))
			for(var/obj/effect/O in target)
				if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
					qdel(O)
		reagents.remove_any(1)
		user.visible_message("<span class='notice'>[user] wipes down \the [target].</span>", "<span class='notice'>You wipe down \the [target]!</span>")
	return