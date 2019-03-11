// What is this?
// This is where projectiles for energy weapons are defined, since we don't want them to be beams on lanstation13.

/obj/item/projectile/laser
	name = "laser"
	icon_state = "laser_old"
	layer = PROJECTILE_LAYER
	plane = EFFECTS_PLANE
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage = 30
	damage_type = BURN
	flag = "laser"
	eyeblur = 4
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/projectile/laser/captain
	name = "captain laser"
	damage = 40

/obj/item/projectile/laser/retro

/obj/item/projectile/laser/practice
	damage = 0

/obj/item/projectile/laser/practice/stormtrooper
	fire_sound = "sound/weapons/blaster-storm.ogg"

/obj/item/projectile/laser/practice/stormtrooper/on_hit(var/atom/target, var/blocked = 0)
	if(..(target, blocked))
		var/mob/living/L = target
		var/message = pick("\the [src] narrowly whizzes past [L]!","\the [src] almost hits [L]!","\the [src] straight up misses its target.","[L]'s hair is singed off by \the [src]!","\the [src] misses [L] by a millimetre!","\the [src] doesn't hit","\the [src] misses its intended target.","[L] has a lucky escape from \the [src]!")
		target.loc.visible_message("<span class='danger'>[message]</span>")

/obj/item/projectile/laser/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser_old"
	damage = 60
	fire_sound = 'sound/weapons/lasercannonfire.ogg'

/obj/item/projectile/laser/xray
	name = "xray beam"
	icon_state = "xray_old"
	damage = 30
	fire_sound = 'sound/weapons/laser3.ogg'

/obj/item/projectile/laser/pulse
	name = "pulse"
	icon_state = "u_laser_old"
	damage = 50
	destroy = TRUE
	fire_sound = 'sound/weapons/pulse.ogg'

/obj/item/projectile/laser/deathlaser
	name = "death laser"
	icon_state = "heavylaser_old"
	damage = 60

////////Laser Tag////////////////////
/obj/item/projectile/laser/lasertag
	name = "lasertag beam"
	damage = 0
	icon_state = "bluelaser_old"
	var/list/enemy_vest_types = list(/obj/item/clothing/suit/redtag)

/obj/item/projectile/beam/lasertag/on_hit(var/atom/target, var/blocked = 0)
	if(istype(target, /mob/living/carbon/human))
		var/mob/living/carbon/human/M = target
		if(is_type_in_list(M.wear_suit, enemy_vest_types))
			if(!M.lying) //Kick a man while he's down, will ya
				var/obj/item/weapon/gun/energy/tag/taggun = shot_from
				if(istype(taggun))
					taggun.score()
			M.Knockdown(5)
	return 1

/obj/item/projectile/laser/lasertag/blue
	icon_state = "bluelaser_old"
	enemy_vest_types = list(/obj/item/clothing/suit/redtag)

/obj/item/projectile/laser/lasertag/red
	icon_state = "laser_old"
	enemy_vest_types = list(/obj/item/clothing/suit/bluetag)

/obj/item/projectile/laser/lasertag/omni //A laser tag ray that stuns EVERYONE
	icon_state = "omnilaser_old"
	enemy_vest_types = list(/obj/item/clothing/suit/redtag, /obj/item/clothing/suit/bluetag)