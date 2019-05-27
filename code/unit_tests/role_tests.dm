/datum/unit_test/roles_shall_have_a_valid_outfit_type
	name = "ROLES: Shall have a valid outfit type"

/datum/unit_test/roles_shall_have_a_valid_outfit_type/start_test()
	var/failed_roles = 0

	for (var/occ in SSroles.titles_to_datums)
		var/datum/role/occupation = SSroles.titles_to_datums[occ]
		var/decl/hierarchy/outfit/role/outfit = outfit_by_type(occupation.outfit_type)
		if(!istype(outfit))
			log_bad("[occupation.title] - [occupation.type]: Invalid outfit type [outfit ? outfit.type : "NULL"].")
			failed_roles++

	if(failed_roles)
		fail("[failed_roles] role\s with invalid outfit type.")
	else
		pass("All roles had outfit types.")
	return 1

/datum/unit_test/roles_shall_have_a_HUD_icon
	name = "ROLE: Shall have a HUD icon"

/datum/unit_test/roles_shall_have_a_HUD_icon/start_test()
	var/failed_roles = 0
	var/failed_sanity_checks = 0

	var/role_huds = icon_states(GLOB.using_map.id_hud_icons)

	if(!("" in role_huds))
		log_bad("Sanity Check - Missing default/unnamed HUD icon")
		failed_sanity_checks++

	if(!("hudunknown" in role_huds))
		log_bad("Sanity Check - Missing HUD icon: hudunknown")
		failed_sanity_checks++

	if(!("hudcentcom" in role_huds))
		log_bad("Sanity Check - Missing HUD icon: hudcentcom")
		failed_sanity_checks++

	for(var/role_name in SSroles.titles_to_datums)
		var/datum/role/R= SSroles.titles_to_datums[role_name]
		var/hud_icon_state = J.hud_icon
		if(!(hud_icon_state in role_huds))
			log_bad("[J.title] - Missing HUD icon: [hud_icon_state]")
			failed_roles++

	if(failed_sanity_checks || failed_roles)
		fail("[GLOB.using_map.id_hud_icons] - [failed_sanity_checks] failed sanity check\s, [failed_roles] role\s with missing HUD icon.")
	else
		pass("All roles have a HUD icon.")
	return 1

/datum/unit_test/roles_shall_have_a_unique_title
	name = "ROLES: All Role Datums Shall Have A Unique Title"

/datum/unit_test/roles_shall_have_a_unique_title/start_test()
	var/list/checked_titles = list()
	var/list/non_unique_titles = list()
	for(var/role_type in SSroles.types_to_datums)
		var/datum/role/role = SSroles.types_to_datums[role_type]
		var/list/titles_to_check = role.alt_titles ? role.alt_titles.Copy() : list()
		titles_to_check += role.title
		for(var/role_title in titles_to_check)
			if(checked_titles[role_title])
				non_unique_titles += "[role_title] ([role_type])"
				non_unique_titles |= "[role_title] ([checked_titles[role_title]])"
			else
				checked_titles[role_title] = role_type

	if(LAZYLEN(non_unique_titles))
		fail("Some roles share a title:\n[jointext(non_unique_titles, "\n")]")
	else
		pass("All roles have a unique title.")
	return 1