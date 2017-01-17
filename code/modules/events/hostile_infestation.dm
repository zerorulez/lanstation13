//Hostile Infestation: A variant of the infestation event that spawns small numbers of hostile mobs.
//Currently only fires if there are 2 or more security officers

#define LOC_BAR 0
#define LOC_ENGINEERING 1
#define LOC_CHAPEL 2
#define LOC_BRIDGE 3
#define LOC_HYDRO 5
#define LOC_SEC 6
#define LOC_SCIENCE 7

#define MONSTER_BEAR    0
#define MONSTER_CREATURE 1
#define MONSTER_XENO 2
#define MONSTER_HIVEBOT  3
#define MONSTER_ZOMBIE    4
#define MONSTER_SKRITE  5
#define MONSTER_SQUEEN  6
#define MONSTER_FROG 7

/datum/event/hostile_infestation
	announceWhen = 2  //Should notify crew much quicker than normal infestation event because of the danger posed by these mobs
	endWhen = 10
	var/localestring
	var/monsterstring

/datum/event/hostile_infestation/start()
	var/z_level = 1
	for(var/mob/M in player_list)
		if(M.client)
			var/turf/T = get_turf(M)
			if(T.z == z_level)
				M << 'sound/effects/bumpinthenight.ogg'

	var/location = pick(LOC_BAR, LOC_ENGINEERING, LOC_CHAPEL, LOC_BRIDGE, LOC_HYDRO, LOC_SEC, LOC_SCIENCE)
	var/spawn_area_type

	switch(location)
		if(LOC_BAR)
			spawn_area_type = /area/crew_quarters/bar
			localestring = "no Bar"
		if(LOC_ENGINEERING)
			spawn_area_type = /area/engineering
			localestring = "na Engenharia"
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel/office
			localestring = "na Igreja"
		if(LOC_BRIDGE)
			spawn_area_type = /area/bridge
			localestring = "na Bridge"
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			localestring = "na Hydroponics"
		if(LOC_SEC)
			spawn_area_type = /area/security/brig
			localestring = "na Segurança"
		if(LOC_SCIENCE)
			spawn_area_type = /area/science/lab
			localestring = "na Ciência"

	var/spawn_monster_type
	var/max_number
	var/monster = pick(MONSTER_BEAR, MONSTER_CREATURE, MONSTER_XENO, MONSTER_HIVEBOT, MONSTER_ZOMBIE, MONSTER_SKRITE, MONSTER_SQUEEN, MONSTER_FROG)
	switch(monster)
		if(MONSTER_BEAR)
			spawn_monster_type = pick(/mob/living/simple_animal/hostile/bear, /mob/living/simple_animal/hostile/bear/panda, /mob/living/simple_animal/hostile/bear/polarbear)
			max_number = 2
			monsterstring = "fur"
		if(MONSTER_CREATURE)
			spawn_monster_type = /mob/living/simple_animal/hostile/creature
			max_number = 2
			monsterstring = "slime"
		if(MONSTER_XENO)
			spawn_monster_type = pick(/mob/living/simple_animal/hostile/alien, /mob/living/simple_animal/hostile/alien/drone, /mob/living/simple_animal/hostile/alien/sentinel, /mob/living/simple_animal/hostile/alien/queen, /mob/living/simple_animal/hostile/alien/queen/large)
			max_number = 1
			monsterstring = "a cuticle"
		if(MONSTER_HIVEBOT)
			spawn_monster_type = pick(/mob/living/simple_animal/hostile/hivebot, /mob/living/simple_animal/hostile/hivebot/range, /mob/living/simple_animal/hostile/hivebot/rapid, /mob/living/simple_animal/hostile/hivebot/tele)
			max_number = 6
			monsterstring = "a synthetic covering"
		if(MONSTER_ZOMBIE)
			spawn_monster_type = pick(/mob/living/simple_animal/hostile/necro/zombie, /mob/living/simple_animal/hostile/monster/necromorph)
			max_number = 3
			monsterstring = "extreme decay"
		if(MONSTER_SKRITE)
			spawn_monster_type = /mob/living/simple_animal/hostile/monster/skrite
			monsterstring = "fleshy bare skin"
			max_number = 2
		if(MONSTER_SQUEEN)
			spawn_monster_type = /mob/living/simple_animal/hostile/giant_spider/nurse/queen_spider
			monsterstring = "monstrous size"
			max_number = 1
		if(MONSTER_FROG)
			spawn_monster_type = /mob/living/simple_animal/hostile/frog
			monsterstring = "slimey skin"
			max_number = 8

	var/number = rand(1, max_number)

	spawn(300)	// should be plenty for everyone in those areas to leave
		for(var/i = 1, i <= number, i++)
			var/area/A = locate(spawn_area_type)
			var/list/turf/simulated/floor/valid = list()
			//Loop through each floor in the supply drop area
			for(var/turf/simulated/floor/F in A)
				if(!F.has_dense_content())
					valid.Add(F)

			var/chosen = pick(valid)
			var/monster_spawn = pick(spawn_monster_type)
			new monster_spawn(chosen)


/datum/event/hostile_infestation/announce()
	command_alert(new /datum/command_alert/hostile_creatures(localestring, monsterstring))


#undef LOC_BAR
#undef LOC_ENGINEERING
#undef LOC_CHAPEL
#undef LOC_BRIDGE
#undef LOC_HYDRO
#undef LOC_SEC
#undef LOC_SCIENCE

#undef MONSTER_BEAR
#undef MONSTER_CREATURE
#undef MONSTER_XENO
#undef MONSTER_HIVEBOT
#undef MONSTER_ZOMBIE
#undef MONSTER_SKRITE
#undef MONSTER_FROG
