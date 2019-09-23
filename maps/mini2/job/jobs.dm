/datum/job/captain/New()
	..()
	supervisors = "Nanotrasen and Central Command"

/datum/job/hop/New()
	..()
	supervisors = "the captain and Central Command"

/datum/job/hop/get_access()
	return get_all_accesses()

// Cargo

/datum/job/cargo_tech/New()
	..()
	total_positions = 1
	spawn_positions = 1
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mining, access_mint, access_mining_station, access_mailsorting)

/datum/job/mining/New()
	..()
	total_positions = 2
	spawn_positions = 2
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mint, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mining, access_mint, access_mining_station, access_mailsorting)

// Engineering

/datum/job/engineer/New()
	..()
	total_positions = 3
	spawn_positions = 2
	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics, access_tcomsat)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_tcomsat, access_atmospherics)

// Medical

/datum/job/doctor/New()
	..()
	total_positions = 2
	spawn_positions = 2
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)

/datum/job/doctor/get_access()
	var/datum/job/chemist = job_master.GetJob("Chemist")

	if(chemist.current_positions > 0)
		access = list(access_medical, access_morgue, access_surgery, access_virology, access_genetics)
		minimal_access = list(access_medical, access_morgue, access_surgery, access_virology, access_genetics)

	return ..()

/datum/job/chemist/New()
	..()
	total_positions = 1
	spawn_positions = 1
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)

/datum/job/geneticist/New()
	..()
	total_positions = 1
	spawn_positions = 1
	access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)
	minimal_access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology, access_genetics)

/datum/job/geneticist/get_access()
	var/datum/job/chemist = job_master.GetJob("Chemist")

	if(chemist.current_positions > 0)
		access = list(access_medical, access_morgue, access_surgery, access_virology, access_genetics)
		minimal_access = list(access_medical, access_morgue, access_surgery, access_virology, access_genetics)

	return ..()

// Science

/datum/job/scientist/New()
	..()
	total_positions = 4
	spawn_positions = 4
	access = list(access_robotics, access_rnd, access_tox_storage, access_science, access_xenobiology)
	minimal_access = list(access_rnd, access_tox_storage, access_science, access_xenobiology, access_robotics)

/datum/job/roboticist/New()
	..()
	total_positions = 1
	spawn_positions = 1

// Security

/datum/job/officer/New()
	..()
	total_positions = 3
	spawn_positions = 3
	var/datum/job/cap = job_master.GetJob("Captain")
	if(!(cap.current_positions > 0))
		access = list(access_weapons, access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_morgue, access_eva, access_heads, access_hop, access_RC_announce, access_keycard_auth)
		minimal_access = list(access_weapons, access_security, access_sec_doors, access_brig, access_court, access_maint_tunnels, access_morgue, access_eva, access_heads, access_hop, access_RC_announce, access_keycard_auth)

/datum/job/detective/New()
	..()
	var/datum/job/cap = job_master.GetJob("Captain")
	if(!(cap.current_positions > 0))
		access = list(access_weapons, access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court, access_eva, access_heads, access_hop, access_RC_announce, access_keycard_auth)
		minimal_access = list(access_weapons, access_security, access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels, access_court, access_eva, access_heads, access_hop, access_RC_announce, access_keycard_auth)
// Civilian

/datum/job/hydro/New()
	..()
	total_positions = 2
	spawn_positions = 2
// Silicon

/datum/job/cyborg/New()
	..()
	total_positions = 0
	spawn_positions = 0
