#define STAGE_SOURCES  1
#define STAGE_OVERLAYS 2

/var/list/lighting_update_lights	= list()	// List of light sources queued for update.
/var/list/lighting_update_overlays	= list()	// List of ligting overlays queued for update.

var/datum/subsystem/lighting/SSlighting

/datum/subsystem/lighting
	name          = "Lighting"
	init_order    = SS_INIT_LIGHTING
	display_order = SS_DISPLAY_LIGHTING
	wait          = 2
	priority      = SS_PRIORITY_LIGHTING
	flags         = SS_TICKER

	var/list/currentrun_lights
	var/list/currentrun_overlays

	var/resuming_stage = 0

/datum/subsystem/lighting/New()
	NEW_SS_GLOBAL(SSlighting)


/datum/subsystem/lighting/Initialize(timeofday)
	create_all_lighting_overlays()
	..()

/datum/subsystem/machinery/stat_entry()
	..("L:[lighting_update_lights.len]|O:[lighting_update_overlays.len]")

/datum/subsystem/lighting/fire(resumed=FALSE)
	if(resuming_stage == 0 || !resumed)
		currentrun_lights   = lighting_update_lights
		lighting_update_lights   = list()

		resuming_stage = STAGE_SOURCES

	while(currentrun_lights.len)
		var/datum/light_source/L = currentrun_lights[currentrun_lights.len]
		currentrun_lights.len--

		if(L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		if (MC_TICK_CHECK)
			return

	if(resuming_stage == STAGE_SOURCES || !resumed)
		currentrun_overlays = lighting_update_overlays
		lighting_update_overlays = list()

		resuming_stage = STAGE_OVERLAYS

	while(currentrun_overlays.len)
		var/atom/movable/lighting_overlay/O = currentrun_overlays[currentrun_overlays.len]
		currentrun_overlays.len--
		O.update_overlay()
		O.needs_update = FALSE
		if (MC_TICK_CHECK)
			return

	resuming_stage = 0

#undef STAGE_SOURCES
#undef STAGE_OVERLAYS