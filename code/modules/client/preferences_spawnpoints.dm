GLOBAL_VAR(spawntypes)

/proc/spawntypes()
	if(!GLOB.spawntypes)
		GLOB.spawntypes = list()
		for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
			var/datum/spawnpoint/S = type
			var/display_name = initial(S.display_name)
			if((display_name in GLOB.using_map.allowed_spawns) || initial(S.always_visible))
				GLOB.spawntypes[display_name] = new S
	return GLOB.spawntypes

/datum/spawnpoint
	var/msg		  //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/always_visible = FALSE	// Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/list/restrict_faction = null
	var/list/restrict_role = null
	var/list/disallow_role = null

/datum/spawnpoint/proc/check_role_spawning(role, faction)
	if(restrict_faction && !(faction in restrict_faction))
		return 0

	if(restrict_role && !(role in restrict_role))
		return 0

	if(disallow_role && (role in disallow_role))
		return 0

	return 1

//Called after mob is created, moved to a turf and equipped.
/datum/spawnpoint/proc/after_join(mob/victim)
	return

#ifdef UNIT_TEST
/datum/spawnpoint/Del()
	crash_with("Spawn deleted: [log_info_line(src)]")
	..()

/datum/spawnpoint/Destroy()
	crash_with("Spawn destroyed: [log_info_line(src)]")
	. = ..()
#endif

/datum/spawnpoint/reichspawn
	display_name = "The Fourth Reich"
	restrict_faction = list("The Fourth Reich")
/datum/spawnpoint/reichspawn/New()
	..()
	turfs = GLOB.reichspawn

/datum/spawnpoint/vdnkhspawn
	display_name = "The VDNKh"
	restrict_faction = list("The VDNKh")
/datum/spawnpoint/vdnkhspawn/New()
	..()
	turfs = GLOB.vdnkhspawn

/datum/spawnpoint/redlinespawn
	display_name = "The Red Line"
	restrict_faction = list("The Red Line")
/datum/spawnpoint/redlinespawn/New()
	..()
	turfs = GLOB.redlinespawn

/datum/spawnpoint/vagrantspawn
	display_name = "vagrantspawn"
	restrict_role = list("Vagrant")
	always_visible = 1
/datum/spawnpoint/vagrantspawn/New()
	..()
	for(var/area/A in world)
		if(istype(A, /area/unowned/metrotunnels))
			turfs += A
