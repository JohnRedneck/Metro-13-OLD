/datum/map
	//var/species_to_role_whitelist = list(/datum/species/vox = list(/datum/role/ai, /datum/role/cyborg))
	var/species_to_role_blacklist = list()

	var/role_to_species_whitelist = list()
	var/role_to_species_blacklist = list()

	var/default_vagrant_title = "Vagrant"

// The white, and blacklist are type specific, any subtypes (of both species and roles) have to be added explicitly
/datum/map/proc/is_species_role_restricted(var/datum/species/S, var/datum/role/R)
	return FALSE
	if(!istype(S) || !istype(R))
		return TRUE

	var/list/whitelist = list()//species_to_role_whitelist[S.type]
	if(whitelist)
		return !(R.type in whitelist)

	whitelist = role_to_species_whitelist[R.type]
	if(whitelist)
		return !(S.type in whitelist)

	var/list/blacklist = species_to_role_blacklist[S.type]
	if(blacklist)
		return (R.type in blacklist)

	blacklist = role_to_species_blacklist[R.type]
	if(blacklist)
		return (S.type in blacklist)

	return FALSE
