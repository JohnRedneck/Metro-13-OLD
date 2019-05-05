/datum/map
	var/const/NO_APC = 1
	var/const/NO_VENT = 2
	var/const/NO_SCRUBBER = 4

	// Unit test vars
	var/list/apc_test_exempt_areas = list(
		/*
		/area/exoplanet             = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/desert      = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/grass       = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/snow        = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/garbage     = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/shrouded    = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/chlorine    = NO_SCRUBBER|NO_VENT|NO_APC
		*/
	)

	var/list/area_coherency_test_exempt_areas = list(
		/*
		/area/space,
		/area/exoplanet,
		/area/exoplanet/desert,
		/area/exoplanet/grass,
		/area/exoplanet/snow,
		/area/exoplanet/garbage,
		/area/exoplanet/shrouded,
		/area/exoplanet/chlorine
		*/
	)
	var/list/area_coherency_test_subarea_count = list()

	// These areas are used specifically by code and need to be broken out somehow
	var/list/area_usage_test_exempted_areas = list(
		/area/overmap,
		/area/shuttle,
		/area/shuttle/escape,
		/area/shuttle/escape/centcom
	)

	var/list/area_usage_test_exempted_root_areas = list(
		/area/map_template,
		///area/exoplanet
	)

	var/list/area_purity_test_exempt_areas = list()