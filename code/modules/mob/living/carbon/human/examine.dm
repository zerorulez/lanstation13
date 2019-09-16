#define JITTER_MEDIUM 100
#define JITTER_HIGH 300

/mob/living/carbon/human/examine(mob/user)
	if(!isobserver(user))
		user.visible_message("<font size=1><b>[user.name]</b> looks at <b>[src].</b></font>")
	var/list/obscured = check_obscured_slots()
	var/skipgloves = 0
	//var/skipsuitstorage = 0
	var/skipjumpsuit = 0
	var/skipshoes = 0
	var/skipmask = 0
	var/skipface = 0

/*



	//exosuits and helmets obscure our view and stuff.
	if(wear_suit)
		skipgloves = wear_suit.flags_inv & HIDEGLOVES
		skipsuitstorage = wear_suit.flags_inv & HIDESUITSTORAGE
		skipjumpsuit = wear_suit.flags_inv & HIDEJUMPSUIT
		skipshoes = wear_suit.flags_inv & HIDESHOES

	if(head)
		skipmask = head.flags_inv & HIDEMASK
		skipeyes = head.flags_inv & HIDEEYES
		skipears = head.flags_inv & HIDEEARS
		skipface = head.flags_inv & HIDEFACE


*/

	if(wear_mask)
		skipface |= check_hidden_head_flags(HIDEFACE)

	// crappy hacks because you can't do \his[src] etc. I'm sorry this proc is so unreadable, blame the text macros :<
	var/t_He = "It" //capitalised for use at the start of each line.
	var/t_his = "its"
	var/t_him = "it"
	var/t_has = "has"
	var/t_is = "is"

	var/msg = "<span class='info2'>*---------*\n"

	if(skipface)
		t_He = "They"
		t_his = "their"
		t_him = "them"
		t_has = "have"
		t_is = "are"
	else
		switch(gender)
			if(MALE)
				t_He = "He"
				t_his = "his"
				t_him = "him"
			if(FEMALE)
				t_He = "She"
				t_his = "her"
				t_him = "her"

	var/distance = get_dist(user,src)
	if(istype(user, /mob/dead/observer) || user.stat == 2) // ghosts can see anything
		distance = 1

	// below we have fluff text to help determining the mob looks for immersions purpose

	var/fluff_age = age_fluff	// can't use age_fluff itself because we're nulling this var if we can't see the mob's head
								// and we want to cache age_fluff instead of changing it every time the mob is examined

	if(!fluff_age)				// will only run once per round for each mob if they are examined
		switch(age)
			if(15 to 17)
				age_fluff = "[gender == MALE ? "um adolescente" : "uma adolescente"]"
			if(18 to 24)
				age_fluff = "[gender == MALE ? "um jovem" : "uma jovem"]"
			if(25 to 29)
				age_fluff = "[gender == MALE ? "um jovem adulto" : "uma jovem adulta"]"
			if(30 to 39)
				age_fluff = "[gender == MALE ? "um adulto" : "uma adulta"]"
			if(40 to 55)
				age_fluff = "[gender == MALE ? "um homem de meia-idade" : "uma mulher de meia-idade"]"
			else
				age_fluff = "[gender == MALE ? "um idoso" : "uma idosa"]"

		fluff_age = age_fluff

	var/datum/organ/external/head/limb_head = get_organ(LIMB_HEAD)
	if((wear_mask && (is_slot_hidden(wear_mask.body_parts_covered,HIDEFACE))) || (head && (is_slot_hidden(head.body_parts_covered,HIDEFACE))) || !limb_head || limb_head.disfigured || (limb_head.status & ORGAN_DESTROYED) || !real_name || (M_HUSK in mutations) ) //Wearing a mask, having no head, being disfigured, or being a husk means no flavor text for you.
		fluff_age = null

	msg += "<b>[src.name]</b>[fluff_age ? ", [fluff_age]." : null]\n"

	//uniform
	if(w_uniform && !(slot_w_uniform in obscured))
		if(w_uniform.blood_DNA && w_uniform.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_is] wearing <b>\icon[w_uniform] [w_uniform.gender==PLURAL?"some":"a"] blood-stained [w_uniform.name]</b>![w_uniform.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_is] wearing <b>\icon[w_uniform] \a [w_uniform]</b>.[w_uniform.description_accessories()]\n"

	//head
	if(head)
		if(head.blood_DNA && head.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_is] wearing <b>\icon[head] [head.gender==PLURAL?"some":"a"] blood-stained [head.name]</b> on [t_his] head![head.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_is] wearing <b>\icon[head] \a [head]</b> on [t_his] head.[head.description_accessories()]\n"

	//suit/armour
	if(wear_suit)
		if(wear_suit.blood_DNA && wear_suit.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_is] wearing <b>\icon[wear_suit] [wear_suit.gender==PLURAL?"some":"a"] blood-stained [wear_suit.name]!</b>[wear_suit.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_is] wearing <b>\icon[wear_suit] \a [wear_suit]</b>.[wear_suit.description_accessories()]\n"

		//suit/armour storage
		if(s_store)
			if(s_store.blood_DNA && s_store.blood_DNA.len)
				msg += "<span class='warning'>[t_He] [t_is] carrying <b>\icon[s_store] [s_store.gender==PLURAL?"some":"a"] blood-stained [s_store.name]</b> on [t_his] [wear_suit.name]!</span>\n"
			else
				msg += "[t_He] [t_is] carrying <b>\icon[s_store] \a [s_store]</b> on [t_his] <b>[wear_suit.name]</b>.\n"

	//back
	if(back)
		if(back.blood_DNA && back.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_has] <b>\icon[back] [back.gender==PLURAL?"some":"a"] blood-stained [back]</b> on [t_his] back![back.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_has] <b>\icon[back] \a [back]</b> on [t_his] back.[back.description_accessories()]\n"

	//hands
	for(var/obj/item/I in held_items)
		if(I.blood_DNA && I.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_is] holding <b>\icon[I] [I.gender==PLURAL?"some":"a"] blood-stained [I.name]</b> in [t_his] [get_index_limb_name(is_holding_item(I))]!</span>\n"
		else
			msg += "[t_He] [t_is] holding <b>\icon[I] \a [I]</b> in [t_his] [get_index_limb_name(is_holding_item(I))].\n"

	//gloves
	if(gloves && !(slot_gloves in obscured))
		if(gloves.blood_DNA && gloves.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_has] <b>\icon[gloves] [gloves.gender==PLURAL?"some":"a"] blood-stained [gloves.name]</b> on [t_his] hands![gloves.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_has] <b>\icon[gloves] \a [gloves]</b> on [t_his] hands.[gloves.description_accessories()]\n"
	else if(blood_DNA && blood_DNA.len && !(slot_gloves in obscured))
		msg += "<span class='warning'>[t_He] [t_has] <b>blood-stained hands</b>!</span>\n"

	//handcuffed?

	//handcuffed?
	if(handcuffed)
		if(istype(handcuffed, /obj/item/weapon/handcuffs/cable))
			msg += "<span class='warning'>[t_He] [t_is] \icon[handcuffed] restrained with cable!</span>\n"
		else
			msg += "<span class='warning'>[t_He] [t_is] \icon[handcuffed] handcuffed!</span>\n"

	//belt
	if(belt)
		if(belt.blood_DNA && belt.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_has] <b>\icon[belt] [belt.gender==PLURAL?"some":"a"] blood-stained [belt.name]</b> about [t_his] waist![belt.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_has] <b>\icon[belt] \a [belt]</b> about [t_his] waist.[belt.description_accessories()]\n"

	//shoes
	if(shoes && !(slot_shoes in obscured))
		if(shoes.blood_DNA && shoes.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_is] wearing <b>\icon[shoes] [shoes.gender==PLURAL?"some":"a"] blood-stained [shoes.name]</b> on [t_his] feet![shoes.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_is] wearing <b>\icon[shoes] \a [shoes]</b> on [t_his] feet.[shoes.description_accessories()]\n"

	//mask
	if(wear_mask && !(slot_wear_mask in obscured))
		if(wear_mask.blood_DNA && wear_mask.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_has] <b>\icon[wear_mask] [wear_mask.gender==PLURAL?"some":"a"] blood-stained [wear_mask.name]</b> on [t_his] face![wear_mask.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_has] <b>\icon[wear_mask] \a [wear_mask]</b> on [t_his] face.[wear_mask.description_accessories()]\n"

	//eyes
	if(glasses && !(slot_glasses in obscured))
		if(glasses.blood_DNA && glasses.blood_DNA.len)
			msg += "<span class='warning'>[t_He] [t_has] <b>\icon[glasses] [glasses.gender==PLURAL?"some":"a"] blood-stained [glasses]</b> covering [t_his] eyes![glasses.description_accessories()]</span>\n"
		else
			msg += "[t_He] [t_has] <b>\icon[glasses] \a [glasses]</b> covering [t_his] eyes.[glasses.description_accessories()]\n"

	//ears
	if(ears && !(slot_ears in obscured))
		msg += "[t_He] [t_has] <b>\icon[ears] \a [ears]</b> on [t_his] ears.[ears.description_accessories()]\n"

	//ID
	if(wear_id)
		/*var/id
		if(istype(wear_id, /obj/item/device/pda))
			var/obj/item/device/pda/pda = wear_id
			id = pda.owner
		else if(istype(wear_id, /obj/item/weapon/card/id)) //just in case something other than a PDA/ID card somehow gets in the ID slot :[
			var/obj/item/weapon/card/id/idcard = wear_id
			id = idcard.registered_name
		if(id && (id != real_name) && (get_dist(src, user) <= 1) && prob(10))
			msg += "<span class='warning'>[t_He] [t_is] wearing [bicon(wear_id)] \a [wear_id] yet something doesn't seem right...</span>\n"
		else
			*/
		msg += "[t_He] [t_is] wearing <b>\icon[wear_id] \a [wear_id]</b>.\n"

	switch(jitteriness)
		if(JITTER_HIGH to INFINITY)
			msg += "<span class='danger'>[t_He] [t_is] convulsing violently!</span>\n"
		if(JITTER_MEDIUM to JITTER_HIGH)
			msg += "<span class='warning'>[t_He] [t_is] extremely jittery.</span>\n"
		if(1 to JITTER_MEDIUM)
			msg += "<span class='warning'>[t_He] [t_is] twitching ever so slightly.</span>\n"

	if(getOxyLoss() > 30 && !skipface)
		msg += "<span class='warning'>[t_He] [t_has] a bluish discoloration to their skin.</span>\n"
	if(getToxLoss() > 30 && !skipface)
		msg += "<span class='warning'>[t_He] looks sickly.</span>\n"
	//splints
	for(var/organ in list(LIMB_LEFT_LEG,LIMB_RIGHT_LEG,LIMB_LEFT_ARM,LIMB_RIGHT_ARM))
		var/datum/organ/external/o = get_organ(organ)
		if(o && o.status & ORGAN_SPLINTED)
			msg += "<span class='warning'>[t_He] [t_has] a splint on [t_his] [o.display_name]!</span>\n"

	if(suiciding)
		msg += "<span class='deadsay'>[t_He] appears to have committed suicide... there is no hope of recovery.</span>\n"

	if(M_DWARF in mutations)
		msg += "[t_He] [t_is] a short, sturdy creature fond of drink and industry.\n"

	if (isUnconscious())
		msg += "<span class='warning'>[t_He] [t_is]n't responding to anything around [t_him] and seems to be asleep.</span>\n"
		if((isDead() || src.health < config.health_threshold_crit) && distance <= 3)
			msg += "<span class='warning'>[t_He] does not appear to be breathing.</span>\n"

		if(ishuman(user) && !user.isUnconscious() && distance <= 1)
			user.visible_message("<span class='info'><b>[user]</b> checks <b>[src]</b>'s pulse.</span>")
			if(user && distance <= 1 && !user.isUnconscious())
				if(pulse == PULSE_NONE || (status_flags & FAKEDEATH))
					to_chat(user, "<span class='deadsay'>[t_He] has no pulse[src.client ? "" : " and [t_his] soul has departed"]...</span>")
				else
					to_chat(user, "<span class='deadsay'>[t_He] has a pulse!</span>")

	msg += "<span class='warning'>"

	if(nutrition < 100)
		if(hardcore_mode_on && eligible_for_hardcore_mode(src))
			msg += "<span class='danger'>[t_He] [t_is] severely malnourished.</span>\n"
		else
			msg += "[t_He] [t_is] severely malnourished.\n"
	else if(nutrition >= 500)
		if(user.nutrition < 100)
			msg += "[t_He] [t_is] plump and delicious looking - Like a fat little piggy. A tasty piggy.\n"
		else
			msg += "[t_He] [t_is] quite chubby.\n"

	msg += "</span>"

	if(has_brain() && stat != DEAD)
		if(!key)
			msg += "<span class='deadsay'>[t_He] [t_is] totally catatonic. The stresses of life in deep space must have been too much for [t_him]. Any recovery is unlikely.</span>\n"
		else if(!client)
			msg += "<span class='deadsay'>[t_He] [t_has] a vacant, braindead stare...</span>\n"

	var/list/wound_flavor_text = list()
	var/list/is_destroyed = list()
	var/list/is_bleeding = list()
	for(var/datum/organ/external/temp in organs)
		if(temp)
			if(!temp.is_existing())
				is_destroyed["[temp.display_name]"] = 1
				wound_flavor_text["[temp.display_name]"] = "<span class='danger'>[t_He] is missing [t_his] [temp.display_name].</span>\n"
				continue
			if(temp.status & ORGAN_PEG)
				if(!(temp.brute_dam + temp.burn_dam))
					wound_flavor_text["[temp.display_name]"] = "<span class='warning'>[t_He] has a peg [temp.display_name]!</span>\n"
					continue
				else
					wound_flavor_text["[temp.display_name]"] = "<span class='warning'>[t_He] has a peg [temp.display_name], it has"
				if(temp.brute_dam)
					switch(temp.brute_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some marks"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of damage"," severe cracks and splintering")
				if(temp.brute_dam && temp.burn_dam)
					wound_flavor_text["[temp.display_name]"] += " and"
				if(temp.burn_dam)
					switch(temp.burn_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some burns"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of burns"," severe charring")
				wound_flavor_text["[temp.display_name]"] += "!</span>\n"
			else if(temp.status & ORGAN_ROBOT)
				if(!(temp.brute_dam + temp.burn_dam))
					wound_flavor_text["[temp.display_name]"] = "<span class='warning'>[t_He] has a robot [temp.display_name]!</span>\n"
					continue
				else
					wound_flavor_text["[temp.display_name]"] = "<span class='warning'>[t_He] has a robot [temp.display_name], it has"
				if(temp.brute_dam)
					switch(temp.brute_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some dents"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of dents"," severe denting")
				if(temp.brute_dam && temp.burn_dam)
					wound_flavor_text["[temp.display_name]"] += " and"
				if(temp.burn_dam)
					switch(temp.burn_dam)
						if(0 to 20)
							wound_flavor_text["[temp.display_name]"] += " some burns"
						if(21 to INFINITY)
							wound_flavor_text["[temp.display_name]"] += pick(" a lot of burns"," severe melting")
				wound_flavor_text["[temp.display_name]"] += "!</span>\n"
			else if(temp.wounds.len > 0)
				var/list/wound_descriptors = list()
				for(var/datum/wound/W in temp.wounds)
					if(W.internal && !temp.open)
						continue // can't see internal wounds
					var/this_wound_desc = W.desc
					if(W.bleeding())
						this_wound_desc = "bleeding [this_wound_desc]"
					else if(W.bandaged)
						this_wound_desc = "bandaged [this_wound_desc]"
					if(W.germ_level > 600)
						this_wound_desc = "badly infected [this_wound_desc]"
					else if(W.germ_level > 330)
						this_wound_desc = "lightly infected [this_wound_desc]"
					if(this_wound_desc in wound_descriptors)
						wound_descriptors[this_wound_desc] += W.amount
						continue
					wound_descriptors[this_wound_desc] = W.amount
				if(wound_descriptors.len)
					var/list/flavor_text = list()
					var/list/no_exclude = list("gaping wound", "big gaping wound", "massive wound", "large bruise",\
					"huge bruise", "massive bruise", "severe burn", "large burn", "deep burn", "carbonised area")
					for(var/wound in wound_descriptors)
						switch(wound_descriptors[wound])
							if(1)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] has[prob(10) && !(wound in no_exclude)  ? " what might be" : ""] a [wound]"
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a [wound]"
							if(2)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] has[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
								else
									flavor_text += "[prob(10) && !(wound in no_exclude) ? " what might be" : ""] a pair of [wound]s"
							if(3 to 5)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] has several [wound]s"
								else
									flavor_text += " several [wound]s"
							if(6 to INFINITY)
								if(!flavor_text.len)
									flavor_text += "<span class='warning'>[t_He] has a bunch of [wound]s"
								else
									flavor_text += " a ton of [wound]\s"
					var/flavor_text_string = ""
					for(var/text = 1, text <= flavor_text.len, text++)
						if(text == flavor_text.len && flavor_text.len > 1)
							flavor_text_string += ", and"
						else if(flavor_text.len > 1 && text > 1)
							flavor_text_string += ","
						flavor_text_string += flavor_text[text]
					flavor_text_string += " on [t_his] [temp.display_name].</span><br>"
					wound_flavor_text["[temp.display_name]"] = flavor_text_string
				else
					wound_flavor_text["[temp.display_name]"] = ""
				if(temp.status & ORGAN_BLEEDING)
					is_bleeding["[temp.display_name]"] = 1
			else
				wound_flavor_text["[temp.display_name]"] = ""

	//Handles the text strings being added to the actual description.
	//If they have something that covers the limb, and it is not missing, put flavortext.  If it is covered but bleeding, add other flavortext.
	var/display_chest = 0
	var/display_shoes = 0
	var/display_gloves = 0
	if(wound_flavor_text["head"] && (is_destroyed["head"] || (!skipmask && !(wear_mask && istype(wear_mask, /obj/item/clothing/mask/gas)))))
		msg += wound_flavor_text["head"]
	else if(is_bleeding["head"])
		msg += "<span class='warning'>[src] has blood running down [t_his] face!</span>\n"
	if(wound_flavor_text["chest"] && !w_uniform && !skipjumpsuit) //No need.  A missing chest gibs you.
		msg += wound_flavor_text["chest"]
	else if(is_bleeding["chest"])
		display_chest = 1
	if(wound_flavor_text["left arm"] && (is_destroyed["left arm"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left arm"]
	else if(is_bleeding["left arm"])
		display_chest = 1
	if(wound_flavor_text["left hand"] && (is_destroyed["left hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["left hand"]
	else if(is_bleeding["left hand"])
		display_gloves = 1
	if(wound_flavor_text["right arm"] && (is_destroyed["right arm"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right arm"]
	else if(is_bleeding["right arm"])
		display_chest = 1
	if(wound_flavor_text["right hand"] && (is_destroyed["right hand"] || (!gloves && !skipgloves)))
		msg += wound_flavor_text["right hand"]
	else if(is_bleeding["right hand"])
		display_gloves = 1
	if(wound_flavor_text["groin"] && (is_destroyed["groin"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["groin"]
	else if(is_bleeding["groin"])
		display_chest = 1
	if(wound_flavor_text["left leg"] && (is_destroyed["left leg"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["left leg"]
	else if(is_bleeding["left leg"])
		display_chest = 1
	if(wound_flavor_text["left foot"]&& (is_destroyed["left foot"] || (!shoes && !skipshoes)))
		msg += wound_flavor_text["left foot"]
	else if(is_bleeding["left foot"])
		display_shoes = 1
	if(wound_flavor_text["right leg"] && (is_destroyed["right leg"] || (!w_uniform && !skipjumpsuit)))
		msg += wound_flavor_text["right leg"]
	else if(is_bleeding["right leg"])
		display_chest = 1
	if(wound_flavor_text["right foot"]&& (is_destroyed["right foot"] || (!shoes  && !skipshoes)))
		msg += wound_flavor_text["right foot"]
	else if(is_bleeding["right foot"])
		display_shoes = 1
	if(display_chest)
		msg += "<span class='danger'>[src] has blood soaking through from under [t_his] clothing!</span>\n"
	if(display_shoes)
		msg += "<span class='danger'>[src] has blood running from [t_his] shoes!</span>\n"
	if(display_gloves)
		msg += "<span class='danger'>[src] has blood running from under [t_his] gloves!</span>\n"

	for(var/implant in get_visible_implants(1))
		msg += "<span class='warning'><b>[src] has \a [implant] sticking out of [t_his] flesh!</span>\n"
	if(digitalcamo)
		msg += "[t_He] [t_is] repulsively uncanny!\n"

	if(!is_destroyed["head"])
		if(getBrainLoss() >= 60)
			msg += "[t_He] [t_has] a stupid expression on [t_his] face.\n"

		if(distance <= 3)
			if(!has_brain())
				msg += "<font color='blue'><b>[t_He] has had [t_his] brain removed.</b></font>\n"

	var/butchery = "" //More information about butchering status, check out "code/datums/helper_datums/butchering.dm"
	if(butchering_drops && butchering_drops.len)
		for(var/datum/butchering_product/B in butchering_drops)
			butchery = "[butchery][B.desc_modifier(src, user)]"
	if(butchery)
		msg += "<span class='warning'>[butchery]</span>\n"

	if(hasHUD(user,"security"))
		var/perpname = "wot"
		var/criminal = "None"

		if(wear_id)
			var/obj/item/weapon/card/id/I = wear_id.GetID()
			if(I)
				perpname = I.registered_name
			else
				perpname = name
		else
			perpname = name

		if(perpname)
			for (var/datum/data/record/E in data_core.general)
				if(E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if(R.fields["id"] == E.fields["id"])
							criminal = R.fields["criminal"]


			msg += {"<span class = 'deptradio'>Criminal status:</span> <a href='?src=\ref[src];criminal=1'>\[[criminal]\]</a>
<span class = 'deptradio'>Security records:</span> <a href='?src=\ref[src];secrecord=`'>\[View\]</a>  <a href='?src=\ref[src];secrecordadd=`'>\[Add comment\]</a>\n"}
			msg += {"[wpermit(src) ? "<span class = 'deptradio'>Has weapon permit.</span>\n" : ""]"}

	if(hasHUD(user,"medical"))
		var/perpname = "wot"
		var/medical = "None"

		if(wear_id)
			if(istype(wear_id,/obj/item/weapon/card/id))
				perpname = wear_id:registered_name
			else if(istype(wear_id,/obj/item/device/pda))
				var/obj/item/device/pda/tempPda = wear_id
				perpname = tempPda.owner
		else
			perpname = src.name

		for (var/datum/data/record/E in data_core.general)
			if (E.fields["name"] == perpname)
				for (var/datum/data/record/R in data_core.general)
					if (R.fields["id"] == E.fields["id"])
						medical = R.fields["p_stat"]


		msg += {"<span class = 'deptradio'>Physical status:</span> <a href='?src=\ref[src];medical=1'>\[[medical]\]</a>\n
			<span class = 'deptradio'>Medical records:</span> <a href='?src=\ref[src];medrecord=`'>\[View\]</a> <a href='?src=\ref[src];medrecordadd=`'>\[Add comment\]</a>\n"}

	var/flavor_text = print_flavor_text(user)
	if(flavor_text)
		msg += "[flavor_text]\n"

	msg += "*---------*</span>"
	if (pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		msg += "\n[t_He] is [pose]"

	to_chat(user, msg)
	user.heard(src)

//Helper procedure. Called by /mob/living/carbon/human/examine() and /mob/living/carbon/human/Topic() to determine HUD access to security and medical records.
/proc/hasHUD(mob/M as mob, hudtype)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		switch(hudtype)
			if("security")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/security) || istype(H.glasses, /obj/item/clothing/glasses/sunglasses/sechud)
			if("medical")
				return istype(H.glasses, /obj/item/clothing/glasses/hud/health)
			else
				return 0
	else if(istype(M, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = M
		switch(hudtype)
			if("security")
				return R.sensor_mode == 1
			if("medical")
				return R.sensor_mode == 2
			else
				return 0
	else if(istype(M, /mob/living/silicon/pai))
		var/mob/living/silicon/pai/P = M
		switch(hudtype)
			if("security")
				return P.secHUD
			if("medical")
				return P.medHUD
	else
		return 0

#undef Jitter_Medium
#undef Jitter_High
