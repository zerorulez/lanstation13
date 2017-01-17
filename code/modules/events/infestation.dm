#define LOC_BAR 0
#define LOC_ENGINEERING 1
#define LOC_CHAPEL 2
#define LOC_BRIDGE 3
#define LOC_HYDRO 5
#define LOC_SEC 6
#define LOC_SCIENCE 7

#define VERM_MICE    0
#define VERM_LIZARDS 1
#define VERM_SPIDERS 2
#define VERM_SLIMES  3
#define VERM_BATS    4
#define VERM_BORERS  5
#define VERM_MIMICS  6
#define VERM_ROACHES 7

/datum/event/infestation
	announceWhen = 15
	endWhen = 20
	var/locstring
	var/vermstring

/datum/event/infestation/start()

	var/location = pick(LOC_BAR, LOC_ENGINEERING, LOC_CHAPEL, LOC_BRIDGE, LOC_HYDRO, LOC_SEC, LOC_SCIENCE)
	var/spawn_area_type

	//TODO:  These locations should be specified by the map datum or by the area. //Area datums, any day now
	//Something like area.is_quiet=1 or map.quiet_areas=list()
	switch(location)
		if(LOC_BAR)
			spawn_area_type = /area/crew_quarters/bar
			locstring = "no Bar"
		if(LOC_ENGINEERING)
			spawn_area_type = /area/engineering
			locstring = "na Engenharia"
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel/office
			locstring = "na Igreja"
		if(LOC_BRIDGE)
			spawn_area_type = /area/bridge
			locstring = "na Bridge"
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "na Hydroponics"
		if(LOC_SEC)
			spawn_area_type = /area/security/brig
			locstring = "na Segurança"
		if(LOC_SCIENCE)
			spawn_area_type = /area/science/lab
			locstring = "na Ciência"

	var/list/spawn_types = list()
	var/max_number = 4
	var/vermin = pick(VERM_MICE, VERM_LIZARDS, VERM_SPIDERS, VERM_SLIMES, VERM_BATS, VERM_BORERS, VERM_MIMICS)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple_animal/mouse/gray, /mob/living/simple_animal/mouse/brown, /mob/living/simple_animal/mouse/white)
			max_number = 12
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple_animal/lizard)
			max_number = 6
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/mob/living/simple_animal/hostile/giant_spider/spiderling)
			vermstring = "spiderlings"
		if(VERM_SLIMES)
			spawn_types = typesof(/mob/living/carbon/slime) - /mob/living/carbon/slime - typesof(/mob/living/carbon/slime/adult)
			vermstring = "slimes"
		if(VERM_BATS)
			spawn_types = /mob/living/simple_animal/hostile/scarybat
			vermstring = "space bats"
		if(VERM_BORERS)
			spawn_types = /mob/living/simple_animal/borer
			vermstring = "borers"
			max_number = 5
		if(VERM_MIMICS)
			spawn_types = /mob/living/simple_animal/hostile/mimic/crate/item
			vermstring = "mimics"
			max_number = 1 //1 to 2
		if(VERM_ROACHES)
			spawn_types = /mob/living/simple_animal/cockroach
			vermstring = "roaches"
			max_number = 30 //Thanks obama

	var/number = rand(2, max_number)

	for(var/i = 0, i <= number, i++)
		var/area/A = locate(spawn_area_type)
		var/list/turf/simulated/floor/valid = list()
		//Loop through each floor in the supply drop area
		for(var/turf/simulated/floor/F in A)
			if(!F.has_dense_content())
				valid.Add(F)

		var/picked = pick(valid)
		if(vermin == VERM_SPIDERS)
			var/mob/living/simple_animal/hostile/giant_spider/spiderling/S = new(picked)
			S.amount_grown = 0
		else
			var/spawn_type = pick(spawn_types)
			new spawn_type(picked)

/datum/event/infestation/announce()
	command_alert(new /datum/command_alert/vermin(vermstring, locstring))

#undef LOC_BAR
#undef LOC_ENGINEERING
#undef LOC_CHAPEL
#undef LOC_BRIDGE
#undef LOC_HYDRO
#undef LOC_SEC
#undef LOC_SCIENCE

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS
#undef VERM_SLIMES
#undef VERM_BATS
#undef VERB_MIMICS
