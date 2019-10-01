/obj/screen/plane_master
	screen_loc = "CENTER"
	icon_state = "blank"
	appearance_flags = PLANE_MASTER|NO_CLIENT_COLOR
	blend_mode = BLEND_OVERLAY
	var/show_alpha = 255
	var/hide_alpha = 0

/obj/screen/plane_master/proc/Show(override)
	alpha = override || show_alpha

/obj/screen/plane_master/proc/Hide(override)
	alpha = override || hide_alpha

//Why do plane masters need a backdrop sometimes? Read http://www.byond.com/forum/?post=2141928
//Trust me, you need one. Period. If you don't think you do, you're doing something extremely wrong.
/obj/screen/plane_master/proc/backdrop(mob/mymob)

/obj/screen/plane_master/lighting
	name = "lighting plane master"
	plane = LIGHTING_PLANE
	blend_mode = BLEND_MULTIPLY
	show_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	alpha = LIGHTING_PLANE_ALPHA_VISIBLE
	mouse_opacity = 0

/obj/screen/plane_master/lighting/backdrop(mob/mymob)
	mymob.overlay_fullscreen("lighting_backdrop_lit", /obj/screen/fullscreen/lighting_backdrop/lit)
	mymob.overlay_fullscreen("lighting_backdrop_unlit", /obj/screen/fullscreen/lighting_backdrop/unlit)

/obj/screen/plane_master/noir_master
	plane = NOIR_BLOOD_PLANE
	color = list(1,0,0,0,
				 0,1,0,0,
				 0,0,1,0,
				 0,0,0,1)
	appearance_flags = NO_CLIENT_COLOR|PLANE_MASTER

/obj/screen/plane_master/ambient_occlusion
	name = "ambient occlusion master"
	plane = OBJ_PLANE
	appearance_flags = PLANE_MASTER
	blend_mode = BLEND_OVERLAY

/obj/screen/plane_master/ambient_occlusion/backdrop(mob/mymob)
	if(istype(mymob) && mymob.client)
		filters += AMBIENT_OCCLUSION

/obj/screen/plane_master/ambient_occlusion/lying_mob
	plane = LYING_MOB_PLANE

/obj/screen/plane_master/ambient_occlusion/lying_human
	plane = LYING_HUMAN_PLANE

/obj/screen/plane_master/ambient_occlusion/above_obj
	plane = ABOVE_OBJ_PLANE

/obj/screen/plane_master/ambient_occlusion/human_plane
	plane = HUMAN_PLANE

/obj/screen/plane_master/ambient_occlusion/mob_plane
	plane = MOB_PLANE

/obj/screen/plane_master/ambient_occlusion/above_human_plane
	plane = ABOVE_HUMAN_PLANE

/obj/screen/plane_master/ambient_occlusion/effects_plane
	plane = EFFECTS_PLANE