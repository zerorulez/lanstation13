/mob/living/silicon/robot/Process_Spacemove()
	if(module)
		for(var/obj/item/weapon/tank/jetpack/J in module.modules)
			if(J && istype(J, /obj/item/weapon/tank/jetpack))
				if(J.allow_thrust(0.01))
					return 1
	if(..())
		return 1
	return 0

 //No longer needed, but I'll leave it here incase we plan to re-use it.
/mob/living/silicon/robot/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed

	if(module_active && istype(module_active,/obj/item/borg/combat/mobility))
		tally-=3 // JESUS FUCKING CHRIST WHY

	var/turf/T = loc
	if(istype(T))
		tally = T.adjust_slowdown(src, tally)

		if(tally == -1)
			return tally

	return tally+config.robot_delay

/mob/living/silicon/robot/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	if(..())
		if(istype(NewLoc, /turf/unsimulated/floor/asteroid) && istype(module, /obj/item/weapon/robot_module/miner))
			var/obj/item/weapon/storage/bag/ore/ore_bag = locate(/obj/item/weapon/storage/bag/ore) in get_all_slots() //find it in our modules
			if(ore_bag)
				var/atom/newloc = NewLoc //NewLoc isn't actually typecast
				for(var/obj/item/stack/ore/ore in newloc.contents)
					ore_bag.preattack(NewLoc, src, 1) //collects everything
					break
