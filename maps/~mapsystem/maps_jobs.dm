/datum/map
	//var/species_to_role_whitelist = list(/datum/species/vox = list(/datum/role/ai, /datum/role/cyborg))
	var/species_to_role_blacklist = list()

	var/role_to_species_whitelist = list()
	var/role_to_species_blacklist = list()

	var/default_assistant_title = "Vagrant"

// The white, and blacklist are type specific, any subtypes (of both species and roles) have to be added explicitly
/datum/map/proc/is_species_role_restricted(var/datum/species/S, var/datum/role/J)
	if(!istype(S) || !istype(J))
		return TRUE

	var/list/whitelist = species_to_role_whitelist[S.type]
	if(whitelist)
		return !(J.type in whitelist)

	whitelist = role_to_species_whitelist[J.type]
	if(whitelist)
		return !(S.type in whitelist)

	var/list/blacklist = species_to_role_blacklist[S.type]
	if(blacklist)
		return (J.type in blacklist)

	blacklist = role_to_species_blacklist[J.type]
	if(blacklist)
		return (S.type in blacklist)

	return FALSE
