/datum/preferences
	var/list/never_be_special_rank
	var/list/be_special_rank

/datum/category_item/player_setup_item/antagonism/candidacy
	name = "Candidacy"
	sort_order = 1

/datum/category_item/player_setup_item/antagonism/candidacy/load_character(var/savefile/S)
	from_file(S["be_special"],           pref.be_special_rank)
	from_file(S["never_be_special"],     pref.never_be_special_rank)

/datum/category_item/player_setup_item/antagonism/candidacy/save_character(var/savefile/S)
	to_file(S["be_special"],             pref.be_special_rank)
	to_file(S["never_be_special"],       pref.never_be_special_rank)

/datum/category_item/player_setup_item/antagonism/candidacy/sanitize_character()
	if(!istype(pref.be_special_rank))
		pref.be_special_rank = list()
	if(!istype(pref.never_be_special_rank))
		pref.never_be_special_rank = list()

	var/special_ranks = valid_special_ranks()
	var/old_be_special_rank = pref.be_special_rank.Copy()
	var/old_never_be_special_rank = pref.never_be_special_rank.Copy()
	for(var/role in old_be_special_rank)
		if(!(role in special_ranks))
			pref.be_special_rank -= role
	for(var/role in old_never_be_special_rank)
		if(!(role in special_ranks))
			pref.never_be_special_rank -= role

/datum/category_item/player_setup_item/antagonism/candidacy/content(var/mob/user)
	. = list()
	. += "<b>Special Role Availability:</b><br>"
	. += "<table>"
	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		. += "<tr><td>[antag.rank_text]: </td><td>"
		if(roleban_isbanned(preference_mob(), antag.id) || (antag.id == MODE_MALFUNCTION && roleban_isbanned(preference_mob(), "AI")))
			. += "<span class='danger'>\[BANNED\]</span><br>"
		else if(antag.id in pref.be_special_rank)
			. += "<span class='linkOn'>High</span> <a href='?src=\ref[src];del_special=[antag.id]'>Low</a> <a href='?src=\ref[src];add_never=[antag.id]'>Never</a></br>"
		else if(antag.id in pref.never_be_special_rank)
			. += "<a href='?src=\ref[src];add_special=[antag.id]'>High</a> <a href='?src=\ref[src];del_special=[antag.id]'>Low</a> <span class='linkOn'>Never</span></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[antag.id]'>High</a> <span class='linkOn'>Low</span> <a href='?src=\ref[src];add_never=[antag.id]'>Never</a></br>"
		. += "</td></tr>"

	var/list/ghost_traps = get_ghost_traps()
	for(var/ghost_trap_key in ghost_traps)
		var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
		if(!ghost_trap.list_as_special_rank)
			continue

		. += "<tr><td>[(ghost_trap.ghost_trap_role)]: </td><td>"
		if(banned_from_ghost_role(preference_mob(), ghost_trap))
			. += "<span class='danger'>\[BANNED\]</span><br>"
		else if(ghost_trap.pref_check in pref.be_special_rank)
			. += "<span class='linkOn'>High</span> <a href='?src=\ref[src];del_special=[ghost_trap.pref_check]'>Low</a> <a href='?src=\ref[src];add_never=[ghost_trap.pref_check]'>Never</a></br>"
		else if(ghost_trap.pref_check in pref.never_be_special_rank)
			. += "<a href='?src=\ref[src];add_special=[ghost_trap.pref_check]'>High</a> <a href='?src=\ref[src];del_special=[ghost_trap.pref_check]'>Low</a> <span class='linkOn'>Never</span></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[ghost_trap.pref_check]'>High</a> <span class='linkOn'>Low</span> <a href='?src=\ref[src];add_never=[ghost_trap.pref_check]'>Never</a></br>"
		. += "</td></tr>"
	. += "<tr><td>Select All: </td><td><a href='?src=\ref[src];select_all=2'>High</a> <a href='?src=\ref[src];select_all=1'>Low</a> <a href='?src=\ref[src];select_all=0'>Never</a></td></tr>"
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/proc/banned_from_ghost_role(var/mob, var/datum/ghosttrap/ghost_trap)
	for(var/ban_type in ghost_trap.ban_checks)
		if(roleban_isbanned(mob, ban_type))
			return 1
	return 0

/datum/category_item/player_setup_item/antagonism/candidacy/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["add_special"])
		if(!(href_list["add_special"] in valid_special_ranks(FALSE)))
			return TOPIC_HANDLED
		pref.be_special_rank |= href_list["add_special"]
		pref.never_be_special_rank -= href_list["add_special"]
		return TOPIC_REFRESH

	if(href_list["del_special"])
		if(!(href_list["del_special"] in valid_special_ranks(FALSE)))
			return TOPIC_HANDLED
		pref.be_special_rank -= href_list["del_special"]
		pref.never_be_special_rank -= href_list["del_special"]
		return TOPIC_REFRESH

	if(href_list["add_never"])
		pref.be_special_rank -= href_list["add_never"]
		pref.never_be_special_rank |= href_list["add_never"]
		return TOPIC_REFRESH

	if(href_list["select_all"])		
		var/selection = text2num(href_list["select_all"])
		var/list/roles = valid_special_ranks(FALSE)

		for(var/id in roles)
			switch(selection)
				if(0)
					pref.be_special_rank -= id
					pref.never_be_special_rank |= id					
				if(1)
					pref.be_special_rank -= id
					pref.never_be_special_rank -= id					
				if(2)					
					pref.be_special_rank |= id
					pref.never_be_special_rank -= id
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/antagonism/candidacy/proc/valid_special_ranks(var/include_bans = TRUE)
	var/list/private_valid_special_ranks = list()

	for(var/antag_type in GLOB.all_antag_types_)
		if(!include_bans)
			if(roleban_isbanned(preference_mob(), antag_type))
				continue
			if(((antag_type  == MODE_MALFUNCTION) && roleban_isbanned(preference_mob(), "AI")))
				continue
		private_valid_special_ranks += antag_type

	var/list/ghost_traps = get_ghost_traps()
	for(var/ghost_trap_key in ghost_traps)
		var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
		if(!ghost_trap.list_as_special_rank)
			continue
		if(!include_bans)
			if(banned_from_ghost_role(preference_mob(), ghost_trap))		
				continue
		private_valid_special_ranks += ghost_trap.pref_check


	return private_valid_special_ranks

/client/proc/wishes_to_be_role(var/role)
	if(!prefs)
		return FALSE
	if(role in prefs.be_special_rank)
		return 2
	if(role in prefs.never_be_special_rank)
		return FALSE
	return 1	//Default to "sometimes" if they don't opt-out.
