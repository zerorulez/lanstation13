/area
	luminosity           = TRUE
	var/lighting_use_dynamic = TRUE

/area/New()
	. = ..()

	if (lighting_use_dynamic)
		luminosity = FALSE

/area/proc/set_lighting_use_dynamic(var/new_lighting_use_dynamic = TRUE)
	if (new_lighting_use_dynamic == lighting_use_dynamic)
		return FALSE

	lighting_use_dynamic = new_lighting_use_dynamic

	if (new_lighting_use_dynamic)
		for (var/turf/T in world)
			if (T.lighting_use_dynamic)
				T.lighting_build_overlay()

	else
		for (var/turf/T in world)
			if (T.lighting_overlay)
				T.lighting_clear_overlay()

	return TRUE
