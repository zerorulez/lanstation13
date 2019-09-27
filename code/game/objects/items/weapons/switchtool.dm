/obj/item/weapon/switchtool
	name = "switchtool"
	icon = 'icons/obj/switchtool.dmi'
	icon_state = "switchtool"
	desc = "A multi-deployable, multi-instrument, finely crafted multi-purpose tool. The envy of engineers everywhere."
	flags = FPRINT
	siemens_coefficient = 1
	force = 0
	w_class = W_CLASS_SMALL
	var/deploy_sound = "sound/weapons/switchblade.ogg"
	var/undeploy_sound = "sound/weapons/switchblade.ogg"
	throwforce = 6.0
	throw_speed = 3
	throw_range = 6
	starting_materials = list(MAT_IRON = 15000)
	w_type = RECYK_METAL
	melt_temperature = MELTPOINT_STEEL
	origin_tech = Tc_MATERIALS + "=9;" + Tc_BLUESPACE + "=5"
	var/hmodule = null

	//the colon separates the typepath from the name
	var/list/obj/item/stored_modules = list("/obj/item/weapon/screwdriver:screwdriver" = null,
											"/obj/item/weapon/wrench:wrench" = null,
											"/obj/item/weapon/wirecutters:wirecutters" = null,
											"/obj/item/weapon/crowbar:crowbar" = null,
											"/obj/item/weapon/chisel:chisel" = null,
											"/obj/item/device/multitool:multitool" = null)
	var/obj/item/deployed //what's currently in use
	var/removing_item = /obj/item/weapon/screwdriver //the type of item that lets you take tools out

/obj/item/weapon/switchtool/preattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(istype(target, /obj/item/weapon/storage)) //we place automatically
		return
	if(deployed)
		if(!deployed.preattack(target, user))
			if(proximity_flag)
				target.attackby(deployed, user)
			deployed.afterattack(target, user, proximity_flag, click_parameters)
		if(deployed.loc != src)
			for(var/module in stored_modules)
				if(stored_modules[module] == deployed)
					stored_modules[module] = null
			undeploy()
	..()

/obj/item/weapon/switchtool/New()
	..()
	for(var/module in stored_modules) //making the modules
		var/new_type = text2path(get_module_type(module))
		stored_modules[module] = new new_type(src)

/obj/item/weapon/switchtool/examine(mob/user)
	..()
	to_chat(user, "This one is capable of holding [get_formatted_modules()].")

/obj/item/weapon/switchtool/attack_self(mob/user)
	if(!user)
		return

	if(deployed)
		edit_deploy(0)
		to_chat(user, "You store \the [deployed].")
		undeploy()
	else
		choose_deploy(user)

/obj/item/weapon/switchtool/attackby(var/obj/item/used_item, mob/user)
	if(istype(used_item, removing_item) && deployed) //if it's the thing that lets us remove tools and we have something to remove
		return remove_module(user)
	if(add_module(used_item, user))
		return TRUE
	else
		return ..()

/obj/item/weapon/switchtool/proc/get_module_type(var/module)
	return copytext(module, 1, findtext(module, ":"))

/obj/item/weapon/switchtool/proc/get_module_name(var/module)
	return copytext(module, findtext(module, ":") + 1)

//makes the string list of modules ie "a screwdriver, a knife, and a clown horn"
//does not end with a full stop, but does contain commas
/obj/item/weapon/switchtool/proc/get_formatted_modules()
	var/counter = 0
	var/module_string = ""
	for(var/module in stored_modules)
		counter++
		if(counter == stored_modules.len)
			module_string += "and \a [get_module_name(module)]"
		else
			module_string += "\a [get_module_name(module)], "
	return module_string

/obj/item/weapon/switchtool/proc/add_module(var/obj/item/used_item, mob/user)
	if(!used_item || !user)
		return FALSE

	for(var/module in stored_modules)
		var/type_path = text2path(get_module_type(module))
		if(istype(used_item, type_path))
			if(stored_modules[module])
				to_chat(user, "\The [src] already has a [get_module_name(module)].")
				return FALSE
			else
				if(user.drop_item(used_item, src))
					stored_modules[module] = used_item
					to_chat(user, "You successfully load \the [used_item] into \the [src]'s [get_module_name(module)] slot.")
					return TRUE

/obj/item/weapon/switchtool/proc/remove_module(mob/user)
	edit_deploy(0)
	deployed.forceMove(get_turf(user))
	for(var/module in stored_modules)
		if(stored_modules[module] == deployed)
			stored_modules[module] = null
			break
	to_chat(user, "You successfully remove \the [deployed] from \the [src].")
	playsound(src, "sound/items/screwdriver.ogg", 10, 1)
	undeploy()
	return TRUE

/obj/item/weapon/switchtool/proc/undeploy()
	playsound(src, undeploy_sound, 10, 1)
	edit_deploy(0)
	deployed = null
	overlays.len = 0
	w_class = initial(w_class)
	update_icon()

/obj/item/weapon/switchtool/proc/deploy(var/module)
	if(!(module in stored_modules))
		return FALSE
	if(!stored_modules[module])
		return FALSE
	if(deployed)
		return FALSE

	playsound(src, deploy_sound, 10, 1)
	deployed = stored_modules[module]
	hmodule = get_module_name(module)
	overlays += hmodule
	w_class = max(w_class, deployed.w_class)
	update_icon()
	return TRUE

/obj/item/weapon/switchtool/proc/edit_deploy(var/doedit)
	if(doedit) //Makes the deployed item take on the features of the switchtool for attack animations and text. Other bandaid fixes for snowflake issues can go here.
		sharpness = deployed.sharpness
		deployed.name = name
		deployed.icon = icon
		deployed.icon_state = icon_state
		deployed.overlays = overlays
		deployed.cant_drop = TRUE
	else //Revert the changes to the deployed item.
		sharpness = initial(sharpness)
		deployed.name = initial(deployed.name)
		deployed.icon = initial(deployed.icon)
		deployed.icon_state = initial(deployed.icon_state)
		deployed.overlays = initial(deployed.overlays)
		deployed.cant_drop = FALSE

/obj/item/weapon/switchtool/proc/choose_deploy(mob/user)
	var/list/potential_modules = list()
	for(var/module in stored_modules)
		if(stored_modules[module])
			if(get_module_name(module) == stored_modules[module].name) //same name so listing actually name in parentheses is redundant
				potential_modules += "[get_module_name(module)]"
			else
				potential_modules += "[get_module_name(module)] \[[stored_modules[module].name]\]"

	if(!potential_modules.len)
		to_chat(user, "No modules to deploy.")
		return

	else if(potential_modules.len == 1)
		for(var/m in stored_modules)
			if(stored_modules[m])
				deploy(m)
				edit_deploy(1)
				return TRUE
		return

	else
		var/chosen_module = input(user,"What do you want to deploy?", "[src]", "Cancel") as anything in potential_modules
		if(chosen_module != "Cancel")
			var/true_module = ""
			for(var/checkmodule in stored_modules)
				if(findtext(chosen_module, " \[") && get_module_name(checkmodule) == copytext(chosen_module, 1, findtext(chosen_module, " \[")))
					// bracket in name
					true_module = checkmodule
					break
				else if(get_module_name(checkmodule) == chosen_module)
					// no bracket in name
					true_module = checkmodule
					break
			if(deploy(true_module))
				to_chat(user, "You deploy \the [deployed].")
				edit_deploy(1)
			return TRUE
		return

/obj/item/weapon/switchtool/surgery
	name = "surgeon's switchtool"

	icon_state = "surg_switchtool"
	desc = "A switchtool containing most of the necessary items for impromptu surgery. For the surgeon on the go."

	origin_tech = Tc_MATERIALS + "=4;" + Tc_BLUESPACE + "=3;" + Tc_BIOTECH + "=3"
	stored_modules = list("/obj/item/weapon/scalpel:scalpel" = null,
						"/obj/item/weapon/circular_saw/small:circular saw" = null,
						"/obj/item/weapon/surgicaldrill:surgical drill" = null,
						"/obj/item/weapon/cautery:cautery" = null,
						"/obj/item/weapon/hemostat:hemostat" = null,
						"/obj/item/weapon/retractor:retractor" = null,
						"/obj/item/weapon/bonesetter:bone setter" = null,
						"/obj/item/weapon/FixOVein:fixovein" = null,
						"/obj/item/weapon/bonegel:bonegel"= null)

/obj/item/weapon/switchtool/surgery/undeploy()
	playsound(src, undeploy_sound, 10, 1)
	edit_deploy(0)
	if(istype(deployed, /obj/item/weapon/scalpel/laser))
		var/obj/item/weapon/scalpel/laser/L = deployed
		L.icon_state += (L.cauterymode) ? "_on" : "_off" //since edit_deploy(0) reverts icon_state to its initial value ("scalpel_laser1(or 2)") which doesn't actually exist
	else if(istype(deployed, /obj/item/weapon/retractor/manager))
		var/obj/item/weapon/retractor/manager/M = deployed
		M.icon_state += "_off"
	deployed = null
	overlays.len = 0
	w_class = initial(w_class)
	update_icon()

/obj/item/weapon/switchtool/swiss_army_knife
	name = "swiss army knife"

	icon_state = "s_a_k"
	desc = "Crafted by the Space Swiss for everyday use in military campaigns. Nonpareil."

	stored_modules = list("/obj/item/weapon/screwdriver:screwdriver" = null,
						"/obj/item/weapon/wrench:wrench" = null,
						"/obj/item/weapon/wirecutters:wirecutters" = null,
						"/obj/item/weapon/crowbar:crowbar" = null,
						"/obj/item/weapon/kitchen/utensil/knife/large:kitchen knife" = null,
						"/obj/item/weapon/kitchen/utensil/fork:fork" = null,
						"/obj/item/weapon/hatchet:hatchet" = null,
						"/obj/item/weapon/lighter/zippo:Zippo lighter" = null,
						"/obj/item/weapon/match/strike_anywhere:strike-anywhere match" = null,
						"/obj/item/weapon/pen:pen" = null)

/obj/item/weapon/switchtool/swiss_army_knife/undeploy()
	if(istype(deployed, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/lighter = deployed
		lighter.lit = 0
	..()

/obj/item/weapon/switchtool/swiss_army_knife/deploy(var/module)
	..()
	if(istype(deployed, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/lighter = deployed
		lighter.lit = 1
		..()
