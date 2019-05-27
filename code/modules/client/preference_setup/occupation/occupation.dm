//used for pref.alternate_option
#define ROLE_LEVEL_NEVER  4
#define ROLE_LEVEL_LOW    3
#define ROLE_LEVEL_MEDIUM 2
#define ROLE_LEVEL_HIGH   1

/datum/preferences
	//Since there can only be 1 high role.
	var/role_high = null
	var/list/role_medium        //List of all things selected for medium weight
	var/list/role_low           //List of all the things selected for low weight
	var/list/player_alt_titles  // the default name of a role like "Medical Doctor"
	var/list/branches
	var/list/ranks
	var/list/hiding_maps = list()

	//Keeps track of preferrence for not getting any wanted roles
	var/alternate_option = 2

/datum/category_item/player_setup_item/role
	name = "Role"
	sort_order = 1
	var/datum/browser/panel

/datum/category_item/player_setup_item/role/load_character(var/savefile/S)
	from_file(S["alternate_option"], 	pref.alternate_option)
	from_file(S["role_high"],			pref.role_high)
	from_file(S["role_medium"],			pref.role_medium)
	from_file(S["role_low"],			pref.role_low)
	from_file(S["player_alt_titles"],	pref.player_alt_titles)
	from_file(S["skills_saved"],		pref.skills_saved)
	from_file(S["branches"],			pref.branches)
	from_file(S["ranks"],				pref.ranks)
	from_file(S["hiding_maps"],			pref.hiding_maps)
	load_skills()

/datum/category_item/player_setup_item/role/save_character(var/savefile/S)
	save_skills()
	to_file(S["alternate_option"],		pref.alternate_option)
	to_file(S["role_high"],				pref.role_high)
	to_file(S["role_medium"],			pref.role_medium)
	to_file(S["role_low"],				pref.role_low)
	to_file(S["player_alt_titles"],		pref.player_alt_titles)
	to_file(S["skills_saved"],			pref.skills_saved)
	to_file(S["branches"],				pref.branches)
	to_file(S["ranks"],					pref.ranks)
	to_file(S["hiding_maps"],			pref.hiding_maps)

/datum/category_item/player_setup_item/role/sanitize_character()
	if(!istype(pref.role_medium))		pref.role_medium = list()
	if(!istype(pref.role_low))			pref.role_low = list()
	if(!istype(pref.skills_saved))		pref.skills_saved = list()
	if(!islist(pref.branches))			pref.branches = list()
	if(!islist(pref.ranks))				pref.ranks = list()
	if(!islist(pref.hiding_maps))		pref.hiding_maps = list()

	pref.alternate_option	= sanitize_integer(pref.alternate_option, 0, 2, initial(pref.alternate_option))
	pref.role_high	        = sanitize(pref.role_high, null)
	if(pref.role_medium && pref.role_medium.len)
		for(var/i in 1 to pref.role_medium.len)
			pref.role_medium[i]  = sanitize(pref.role_medium[i])
	if(pref.role_low && pref.role_low.len)
		for(var/i in 1 to pref.role_low.len)
			pref.role_low[i]  = sanitize(pref.role_low[i])
	if(!pref.player_alt_titles) pref.player_alt_titles = new()

	// We could have something like Captain set to high while on a non-rank map,
	// so we prune here to make sure we don't spawn as a PFC captain
	prune_occupation_prefs()

	pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		//this proc also automatically computes and updates points_by_role

	for(var/role_type in SSroles.types_to_datums)
		var/datum/role/role = SSroles.types_to_datums[role_type]
		var/alt_title = pref.player_alt_titles[role.title]
		if(alt_title && !(alt_title in role.alt_titles))
			pref.player_alt_titles -= role.title

/datum/category_item/player_setup_item/occupation/content(mob/user, limit = 16, list/splitRoles, splitLimit = 1)

	if(!SSmapping || !SSroles.role_lists_by_map_name)
		return

	var/datum/species/S = preference_species()
	. = list()
	. += "<style>.Points,a.Points{background: #cc5555;}</style>"
	. += "<style>a.Points:hover{background: #55cc55;}</style>"
	. += "<tt><center>"
	. += "<font size=3><b>Select and configure your occupation preferences. Unavailable occupations are crossed out.</b></font>"
	. += "<br>"

	// Display everything.
	for(var/role_map in SSroles.role_lists_by_map_name)

		var/list/map_data = SSroles.role_lists_by_map_name[role_map]
		if(isnull(pref.hiding_maps[role_map]))
			pref.hiding_maps[role_map] = map_data["default_to_hidden"]

		. += "<hr><table width = '100%''><tr>"
		. += "<td width = '50%' align = 'right'><font size = 3><b>[capitalize(role_map)]</b></td>"
		. += "<td width = '50%' align = 'left''><a href='?src=\ref[src];toggle_map=[role_map]'>[pref.hiding_maps[role_map] ? "Show" : "Hide"]</a></font></td>"
		. += "</tr></table>"

		if(!pref.hiding_maps[role_map])

			. += "<hr/>"
			. += "<table width='100%' cellpadding='1' cellspacing='0'><tr><td width='20%'>" // Table within a table for alignment, also allows you to easily add more columns.
			. += "<table width='100%' cellpadding='1' cellspacing='0'>"

			//The role before the current role. I only use this to get the previous roles color when I'm filling in blank rows.
			var/datum/role/lastRole
			var/list/map_role_list = map_data["roles"]
			var/index = -1
			if(splitLimit) limit = round((LAZYLEN(map_role_list)+1)/2)

			for(var/datum/role/role in map_role_list)

				var/datum/mil_rank/player_rank
				var/datum/mil_branch/player_branch
				var/branch_string = ""
				var/rank_branch_string = ""
				var/branch_rank = role.allowed_branches ? role.get_branch_rank(S) : mil_branches.spawn_branches(S)
				if(GLOB.using_map && (GLOB.using_map.flags & MAP_HAS_BRANCH) && LAZYLEN(branch_rank))
					player_branch = mil_branches.get_branch(pref.branches[role.title])
					if(player_branch)
						if(LAZYLEN(branch_rank) > 1)
							branch_string += "<td width='10%' align='left'><a href='?src=\ref[src];char_branch=1;checking_role=\ref[role]'>[player_branch.name_short || player_branch.name]</a></td>"
						else
							branch_string += "<td width='10%' align='left'>[player_branch.name_short || player_branch.name]</td>"
				if(!branch_string)
					branch_string = "<td>-</td>"
				if(player_branch)
					var/ranks = branch_rank[player_branch.name] || mil_branches.spawn_ranks(player_branch.name, S)
					if(LAZYLEN(ranks))
						player_rank = mil_branches.get_rank(player_branch.name, pref.ranks[role.title])
						if(player_rank)
							if(LAZYLEN(ranks) > 1)
								rank_branch_string += "<td width='10%' align='left'><a href='?src=\ref[src];char_rank=1;checking_role=\ref[role]'>[player_rank.name_short || player_rank.name]</a></td>"
							else
								rank_branch_string += "<td width='10%' align='left'>[player_rank.name_short || player_rank.name]</td>"
				if(!rank_branch_string)
					rank_branch_string = "<td>-</td>"
				rank_branch_string = "[branch_string][rank_branch_string]"

				var/title = role.title
				var/title_link = role.alt_titles ? "<a href='?src=\ref[src];select_alt_title=\ref[role]'>[pref.GetPlayerAltTitle(role)]</a>" : role.title
				var/help_link = "</td><td width = '10%' align = 'center'><a href='?src=\ref[src];role_info=[title]'>?</a></td>"
				lastRole = role

				var/bad_message = ""
				if(role.total_positions == 0 && role.spawn_positions == 0)
					bad_message = "<b>\[UNAVAILABLE]</b>"
				else if(roleban_isbanned(user, title))
					bad_message = "<b>\[BANNED]</b>"
				else if(!role.player_old_enough(user.client))
					var/available_in_days = role.available_in_days(user.client)
					bad_message = "\[IN [(available_in_days)] DAYS]"
				else if(role.minimum_character_age && user.client && (user.client.prefs.age < role.minimum_character_age))
					bad_message = "\[MINIMUM CHARACTER AGE: [role.minimum_character_age]]"
				else if(!role.is_species_allowed(S))
					bad_message = "<b>\[SPECIES RESTRICTED]</b>"
				else if(!S.check_background(role, user.client.prefs))
					bad_message = "<b>\[BACKGROUND RESTRICTED]</b>"

				var/current_level = ROLE_LEVEL_NEVER
				if(pref.role_high == role.title)
					current_level = ROLE_LEVEL_HIGH
				else if(role.title in pref.role_medium)
					current_level = ROLE_LEVEL_MEDIUM
				else if(role.title in pref.role_low)
					current_level = ROLE_LEVEL_LOW

				var/skill_link
				if(pref.points_by_role[role] && (!role.available_by_default || current_level != ROLE_LEVEL_NEVER))
					skill_link = "<a class = 'Points' href='?src=\ref[src];set_skills=[title]'>Set Skills</a>"
				else
					skill_link = "<a href='?src=\ref[src];set_skills=[title]'>View Skills</a>"
				skill_link = "<td>[skill_link]</td>"

				// Begin assembling the actual HTML.
				index += 1
				if((index >= limit) || (role.title in splitRoles))
					if((index < limit) && (lastRole != null))
						//If the cells were broken up by a role in the splitRole list then it will fill in the rest of the cells with
						//the last role's selection color. Creating a rather nice effect.
						for(var/i = 0, i < (limit - index), i += 1)
							. += "<tr bgcolor='[lastRole.selection_color]'><td width='40%' align='right'><a>&nbsp</a></td><td><a>&nbsp</a></td></tr>"
					. += "</table></td><td width='20%'><table width='100%' cellpadding='1' cellspacing='0'>"
					index = 0

				. += "<tr bgcolor='[role.selection_color]'>"
				if(rank_branch_string && rank_branch_string != "")
					. += "[rank_branch_string]"
				. += "<td width='30%' align='left'>"

				if(bad_message)
					. += "<del>[title_link]</del>[help_link][skill_link]<td>[bad_message]</td></tr>"
					continue
				else if((GLOB.using_map.default_assistant_title in pref.role_low) && (title != GLOB.using_map.default_assistant_title))
					. += "<font color=grey>[title_link]</font>[help_link][skill_link]<td></td></tr>"
					continue
				else
					. += "[title_link][help_link][skill_link]"

				. += "<td>"
				if(title == GLOB.using_map.default_assistant_title)//Assistant is special
					var/yes_link = "Yes"
					var/no_link = "No"
					if(title in pref.role_low)
						yes_link = "<font color='#55cc55'>[yes_link]</font>"
						no_link = "<font color='black'>[no_link]</font>"
					else
						yes_link = "<font color='black'>[yes_link]</font>"
						no_link = "<font color='#55cc55'>[no_link]</font>"
					. += "<a href='?src=\ref[src];set_role=[title];set_level=[ROLE_LEVEL_LOW]'>[yes_link]</a><a href='?src=\ref[src];set_role=[title];set_level=[ROLE_LEVEL_NEVER]'>[no_link]</a>"
				else if(!role.available_by_default)
					. += "<font color = '#cccccc'>Not available at roundstart.</font>"
				else
					var/level_link
					switch(current_level)
						if(ROLE_LEVEL_LOW)
							level_link = "<font color='#cc5555'>Low</font>"
						if(ROLE_LEVEL_MEDIUM)
							level_link = "<font color='#eecc22'>Medium</font>"
						if(ROLE_LEVEL_HIGH)
							level_link = "<font color='#55cc55'>High</font>"
						else
							level_link = "<font color=black>Never</font>"
					. += "<a href='?src=\ref[src];set_role=[title];inc_level=-1'>[level_link]</a>"
				. += "</td></tr>"
			. += "</td></tr></table>"
			. += "</center></table><center>"
	. += "<hr/>"
	switch(pref.alternate_option)
		if(GET_RANDOM_ROLE)
			. += "<u><a href='?src=\ref[src];role_alternative=1'>Get random role if preferences unavailable</a></u>"
		if(BE_ASSISTANT)
			. += "<u><a href='?src=\ref[src];role_alternative=1'>Be assistant if preference unavailable</a></u>"
		if(RETURN_TO_LOBBY)
			. += "<u><a href='?src=\ref[src];role_alternative=1'>Return to lobby if preference unavailable</a></u>"
	. += "<a href='?src=\ref[src];reset_roles=1'>\[Reset\]</a></center>"
	. += "<hr/>"
	. += "</tt><br>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/proc/validate_branch_and_rank()

	if(LAZYLEN(pref.branches))
		for(var/role_name in pref.branches)
			if(!(role_name in SSroles.titles_to_datums))
				pref.branches -= role_name

	if(LAZYLEN(pref.ranks))
		var/list/removing_ranks
		for(var/role_name in pref.ranks)
			var/datum/role/role = SSroles.get_by_title(role_name, TRUE)
			if(!role) LAZYADD(removing_ranks, role_name)
		if(LAZYLEN(removing_ranks))
			pref.ranks -= removing_ranks

	var/datum/species/S = preference_species()
	for(var/role_name in SSroles.titles_to_datums)

		var/datum/role/role = SSroles.get_by_title(role_name)

		var/datum/mil_branch/player_branch = pref.branches[role.title] ? mil_branches.get_branch(pref.branches[role.title]) : null
		var/branch_rank = role.allowed_branches ? role.get_branch_rank(S) : mil_branches.spawn_branches(S)
		if(!player_branch || !(player_branch.name in branch_rank))
			player_branch = LAZYLEN(branch_rank) ? mil_branches.get_branch(branch_rank[1]) : null

		if(player_branch)
			var/datum/mil_rank/player_rank = pref.ranks[role.title] ? mil_branches.get_rank(player_branch.name, pref.ranks[role.title]) : null
			var/ranks = branch_rank[player_branch.name] || mil_branches.spawn_ranks(player_branch.name, S)
			if(!player_rank || !(player_rank.name in ranks))
				player_rank = LAZYLEN(ranks) ? mil_branches.get_rank(player_branch.name, ranks[1]) : null

			// Now make the assignments
			pref.branches[role.title] = player_branch.name
			if(player_rank)
				pref.ranks[role.title] = player_rank.name
			else
				pref.ranks -= role.title
		else
			pref.branches -= role.title
			pref.ranks -= role.title

/datum/category_item/player_setup_item/occupation/OnTopic(href, href_list, user)
	if(href_list["reset_roles"])
		ResetRoles()
		return TOPIC_REFRESH

	else if(href_list["toggle_map"])
		var/mapname = href_list["toggle_map"]
		pref.hiding_maps[mapname] = !pref.hiding_maps[mapname]
		return TOPIC_REFRESH

	else if(href_list["role_alternative"])
		if(pref.alternate_option == GET_RANDOM_ROLE || pref.alternate_option == BE_ASSISTANT)
			pref.alternate_option += 1
		else if(pref.alternate_option == RETURN_TO_LOBBY)
			pref.alternate_option = 0
		return TOPIC_REFRESH

	else if(href_list["select_alt_title"])
		var/datum/role/role = locate(href_list["select_alt_title"])
		if (role)
			var/choices = list(role.title) + role.alt_titles
			var/choice = input("Choose an title for [role.title].", "Choose Title", pref.GetPlayerAltTitle(role)) as anything in choices|null
			if(choice && CanUseTopic(user))
				SetPlayerAltTitle(role, choice)
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["set_role"])
		var/set_role = href_list["set_role"]
		var/set_to
		if(href_list["set_level"])
			set_to = text2num(href_list["set_level"])
		if(href_list["inc_level"])
			set_to = GetCurrentRoleLevel(set_role) + text2num(href_list["inc_level"])
			if(set_to < ROLE_LEVEL_HIGH)
				set_to = ROLE_LEVEL_NEVER
			else if(set_to > ROLE_LEVEL_NEVER)
				set_to = ROLE_LEVEL_HIGH
		if(SetRole(user, set_role, set_to))
			return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)

	else if(href_list["char_branch"])
		var/datum/role/role = locate(href_list["checking_role"])
		if(istype(role))
			var/datum/species/S = preference_species()
			var/list/options = role.allowed_branches ? role.get_branch_rank(S) : mil_branches.spawn_branches(S)
			var/choice = input(user, "Choose your branch of service.", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in options
			if(choice && CanUseTopic(user) && mil_branches.is_spawn_branch(choice, S))
				pref.branches[role.title] = choice
				pref.ranks -= role.title
				pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// Check our skillset is still valid
				validate_branch_and_rank()
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)
			return TOPIC_REFRESH

	else if(href_list["char_rank"])
		var/datum/role/role = locate(href_list["checking_role"])
		if(istype(role))
			var/datum/mil_branch/branch = mil_branches.get_branch(pref.branches[role.title])
			var/datum/species/S = preference_species()
			var/list/branch_rank = role.allowed_branches ? role.get_branch_rank(S) : mil_branches.spawn_branches(S)
			var/list/options = branch_rank[branch.name] || mil_branches.spawn_ranks(branch.name, S)
			var/choice = input(user, "Choose your rank.", CHARACTER_PREFERENCE_INPUT_TITLE) as null|anything in options
			if(choice && CanUseTopic(user) && mil_branches.is_spawn_rank(branch.name, choice, preference_species()))
				pref.ranks[role.title] = choice
				pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)		// Check our skillset is still valid
				validate_branch_and_rank()
				return (pref.equip_preview_mob ? TOPIC_REFRESH_UPDATE_PREVIEW : TOPIC_REFRESH)
			return TOPIC_REFRESH
	else if(href_list["set_skills"])
		var/rank = href_list["set_skills"]
		var/datum/role/role = SSroles.get_by_title(rank, TRUE)
		if(role)
			open_skill_setup(user, role)

	//From the skills popup

	else if(href_list["hit_skill_button"])
		var/decl/hierarchy/skill/S = locate(href_list["hit_skill_button"])
		var/datum/role/R= locate(href_list["at_role"])
		if(!istype(S) || !istype(J))
			return
		var/value = text2num(href_list["newvalue"])
		update_skill_value(J, S, value)
		pref.ShowChoices(user) //Manual refresh to allow us to focus the panel, not the main window.
		panel.set_content(generate_skill_content(J))
		panel.open()
		winset(user, panel.window_id, "focus=1") //Focuses the panel.

	else if(href_list["skillinfo"])
		var/decl/hierarchy/skill/S = locate(href_list["skillinfo"])
		if(!istype(S))
			return
		var/HTML = list()
		HTML += "<h2>[S.name]</h2>"
		HTML += "[S.desc]<br>"
		var/i
		for(i=1, i <= length(S.levels), i++)
			var/level_name = S.levels[i]
			HTML +=	"<br><b>[level_name]</b>: [S.levels[level_name]]<br>"
		show_browser(user, jointext(HTML, null), "window=\ref[user]skillinfo")

	else if(href_list["role_info"])

		var/rank = href_list["role_info"]
		var/datum/role/role = SSroles.get_by_title(rank)

		var/dat = list()

		dat += "<p style='background-color: [role.selection_color]'><br><br><p>"
		if(role.alt_titles)
			dat += "<i><b>Alternative titles:</b> [english_list(role.alt_titles)].</i>"
		send_rsc(user, role.get_role_icon(), "role[ckey(rank)].png")
		dat += "<img src=role[ckey(rank)].png width=96 height=96 style='float:left;'>"
		if(role.department)
			dat += "<b>Department:</b> [role.department]."
			if(role.head_position)
				dat += "You are in charge of this department."

		dat += "You answer <b>[role.supervisors]</b>."

		if(role.allowed_branches)
			dat += "You can be of following ranks:"
			for(var/T in role.allowed_branches)
				var/datum/mil_branch/B = mil_branches.get_branch_by_type(T)
				dat += "<li>[B.name]: [role.get_ranks(B.name)]"
		dat += "<hr style='clear:left;'>"
		if(config.wikiurl)
			dat += "<a href='?src=\ref[src];role_wiki=[rank]'>Open wiki page in browser</a>"

		var/description = role.get_description_blurb()
		if(description)
			dat += html_encode(description)
		var/datum/browser/popup = new(user, "Role Info", "[capitalize(rank)]", 430, 520, src)
		popup.set_content(jointext(dat,"<br>"))
		popup.open()

	else if(href_list["role_wiki"])
		var/rank = href_list["role_wiki"]
		open_link(user,"[config.wikiurl][rank]")

	return ..()

/datum/category_item/player_setup_item/occupation/proc/SetPlayerAltTitle(datum/role/role, new_title)
	// remove existing entry
	pref.player_alt_titles -= role.title
	// add one if it's not default
	if(role.title != new_title)
		pref.player_alt_titles[role.title] = new_title

/datum/category_item/player_setup_item/occupation/proc/SetRole(mob/user, role, level)

	level = Clamp(level, ROLE_LEVEL_HIGH, ROLE_LEVEL_NEVER)
	var/datum/role/role = SSroles.get_by_title(role, TRUE)
	if(!role)
		return 0

	if(role == GLOB.using_map.default_assistant_title)
		if(level == ROLE_LEVEL_NEVER)
			pref.role_low -= role.title
		else
			pref.role_low |= role.title
		return 1

	SetRoleDepartment(role, level)

	return 1

/datum/category_item/player_setup_item/occupation/proc/GetCurrentRoleLevel(var/role_title)
	if(pref.role_high == role_title)
		. = ROLE_LEVEL_HIGH
	else if(role_title in pref.role_medium)
		. = ROLE_LEVEL_MEDIUM
	else if(role_title in pref.role_low)
		. = ROLE_LEVEL_LOW
	else
		. = ROLE_LEVEL_NEVER

/datum/category_item/player_setup_item/occupation/proc/SetRoleDepartment(var/datum/role/role, var/level)
	if(!role || !level)	return 0

	var/current_level = GetCurrentRoleLevel(role.title)

	switch(current_level)
		if(ROLE_LEVEL_HIGH)
			pref.role_high = null
		if(ROLE_LEVEL_MEDIUM)
			pref.role_medium -= role.title
		if(ROLE_LEVEL_LOW)
			pref.role_low -= role.title

	switch(level)
		if(ROLE_LEVEL_HIGH)
			if(pref.role_high)
				pref.role_medium |= pref.role_high
			pref.role_high = role.title
		if(ROLE_LEVEL_MEDIUM)
			pref.role_medium |= role.title
		if(ROLE_LEVEL_LOW)
			pref.role_low |= role.title

	return 1

/datum/preferences/proc/CorrectLevel(var/datum/role/role, var/level)
	if(!role || !level)	return 0
	switch(level)
		if(1)
			return role_high == role.title
		if(2)
			return !!(role.title in role_medium)
		if(3)
			return !!(role.title in role_low)
	return 0

/**
 *  Prune a player's role preferences based on current branch, rank and species
 *
 *  This proc goes through all the preferred roles, and removes the ones incompatible with current rank or branch.
 */
/datum/category_item/player_setup_item/proc/prune_role_prefs()
	var/allowed_titles = list()

	for(var/role_type in SSroles.types_to_datums)
		var/datum/role/role = SSroles.types_to_datums[role_type]
		allowed_titles += role.title

		if(role.title == pref.role_high)
			if(role.is_restricted(pref))
				pref.role_high = null

		else if(role.title in pref.role_medium)
			if(role.is_restricted(pref))
				pref.role_medium.Remove(role.title)

		else if(role.title in pref.role_low)
			if(role.is_restricted(pref))
				pref.role_low.Remove(role.title)

	if(pref.role_high && !(pref.role_high in allowed_titles))
		pref.role_high = null

	for(var/role_title in pref.role_medium)
		if(!(role_title in allowed_titles))
			pref.role_medium -= role_title

	for(var/role_title in pref.role_low)
		if(!(role_title in allowed_titles))
			pref.role_low -= role_title

datum/category_item/player_setup_item/proc/prune_occupation_prefs()
	prune_role_prefs()
	validate_branch_and_rank()

/datum/category_item/player_setup_item/occupation/proc/ResetRoles()
	pref.role_high = null
	pref.role_medium = list()
	pref.role_low = list()
	pref.player_alt_titles.Cut()
	pref.branches = list()
	pref.ranks = list()
	validate_branch_and_rank()

/datum/preferences/proc/GetPlayerAltTitle(datum/role/role)
	return (role.title in player_alt_titles) ? player_alt_titles[role.title] : role.title

#undef ROLE_LEVEL_NEVER
#undef ROLE_LEVEL_LOW
#undef ROLE_LEVEL_MEDIUM
#undef ROLE_LEVEL_HIGH
