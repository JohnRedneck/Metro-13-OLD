/datum/preferences
	var/list/skills_saved	 	= list()	   //List of /datum/role paths, with values (lists of "/decl/hierarchy/skill" , with values saved skill points spent). Should only include entries with nonzero spending.
	var/list/skills_allocated	= list()	   //Same as above, but using instances rather than path strings for both roles and skills.
	var/list/points_by_role		= list()	   //List of roles, with value the number of free skill points remaining

/datum/preferences/proc/get_max_skill(datum/role/role, decl/hierarchy/skill/S)
	var/min = get_min_skill(role, S)
	if(role && role.max_skill)
		. = role.max_skill[S.type]
	if(!.)
		. = S.default_max
	if(!.)
		. = SKILL_MAX
	. = max(min, .)

/datum/preferences/proc/get_min_skill(datum/role/role, decl/hierarchy/skill/S)
	if(role && role.min_skill)
		. = role.min_skill[S.type]
	if(!.)
		var/datum/mil_branch/branch = mil_branches.get_branch(branches[role.title])
		if(branch && branch.min_skill)
			. = branch.min_skill[S.type]
	if(!.)
		. = SKILL_MIN

/datum/preferences/proc/get_spent_points(datum/role/role, decl/hierarchy/skill/S)
	if(!(role in skills_allocated))
		return 0
	var/allocated = skills_allocated[role]
	if(!(S in allocated))
		return 0
	var/min = get_min_skill(role, S)
	return get_level_cost(role, S, min + allocated[S])

/datum/preferences/proc/get_level_cost(datum/role/role, decl/hierarchy/skill/S, level)
	var/min = get_min_skill(role, S)
	. = 0
	for(var/i=min+1, i <= level, i++)
		. += S.get_cost(i)

/datum/preferences/proc/get_max_affordable(datum/role/role, decl/hierarchy/skill/S)
	var/current_level = get_min_skill(role, S)
	var/allocation = skills_allocated[role]
	if(allocation && allocation[S])
		current_level += allocation[S]
	var/max = get_max_skill(role, S)
	var/budget = points_by_role[role]
	. = max
	for(var/i=current_level+1, i <= max, i++)
		if(budget - S.get_cost(i) < 0)
			return i-1
		budget -= S.get_cost(i)

//These procs convert to/from static save-data formats.
/datum/category_item/player_setup_item/role/proc/load_skills()
	if(!length(GLOB.skills))
		decls_repository.get_decl(/decl/hierarchy/skill)

	pref.skills_allocated = list()
	for(var/role_type in SSroles.types_to_datums)
		var/datum/role/role = SSroles.get_by_path(role_type)
		if("[role.type]" in pref.skills_saved)
			var/S = pref.skills_saved["[role.type]"]
			var/L = list()
			for(var/decl/hierarchy/skill/skill in GLOB.skills)
				if("[skill.type]" in S)
					L[skill] = S["[skill.type]"]
			if(length(L))
				pref.skills_allocated[role] = L

/datum/category_item/player_setup_item/role/proc/save_skills()
	pref.skills_saved = list()
	for(var/datum/role/role in pref.skills_allocated)
		var/S = pref.skills_allocated[role]
		var/L = list()
		for(var/decl/hierarchy/skill/skill in S)
			L["[skill.type]"] = S[skill]
		if(length(L))
			pref.skills_saved["[role.type]"] = L

//Sets up skills_allocated
/datum/preferences/proc/sanitize_skills(var/list/input)
	. = list()
	var/datum/species/S = all_species[species]
	for(var/role_name in SSroles.titles_to_datums)
		var/datum/role/role = SSroles.get_by_title(role_name)
		var/input_skills = list()
		if((role in input) && istype(input[role], /list))
			input_skills = input[role]

		var/L = list()
		var/sum = 0

		for(var/decl/hierarchy/skill/skill in GLOB.skills)
			if(skill in input_skills)
				var/min = get_min_skill(role, skill)
				var/max = get_max_skill(role, skill)
				var/level = sanitize_integer(input_skills[skill], 0, max - min, 0)
				var/spent = get_level_cost(role, skill, min + level)
				if(spent)						//Only include entries with nonzero spent points
					L[skill] = level
					sum += spent

		points_by_role[role] = role.skill_points							//We compute how many points we had.
		if(!role.no_skill_buffs)
			points_by_role[role] += S.skills_from_age(age)				//Applies the species-appropriate age modifier.
			points_by_role[role] += S.role_skill_buffs[role.type]			//Applies the per-role species modifier, if any.

		if((points_by_role[role] >= sum) && sum)				//we didn't overspend, so use sanitized imported data
			.[role] = L
			points_by_role[role] -= sum						//if we overspent, or did no spending, default to not including the role at all
		purge_skills_missing_prerequisites(role)

/datum/preferences/proc/check_skill_prerequisites(datum/role/role, decl/hierarchy/skill/S)
	if(!S.prerequisites)
		return TRUE
	for(var/skill_type in S.prerequisites)
		var/decl/hierarchy/skill/prereq = decls_repository.get_decl(skill_type)
		var/value = get_min_skill(role, prereq) + LAZYACCESS(skills_allocated[role], prereq)
		if(value < S.prerequisites[skill_type])
			return FALSE
	return TRUE

/datum/preferences/proc/purge_skills_missing_prerequisites(datum/role/role)
	var/allocation = skills_allocated[role]
	if(!allocation)
		return
	for(var/decl/hierarchy/skill/S in allocation)
		if(!check_skill_prerequisites(role, S))
			clear_skill(role, S)
			.() // restart checking from the beginning, as after doing this we don't know whether what we've already checked is still fine.
			return

/datum/preferences/proc/clear_skill(datum/role/role, decl/hierarchy/skill/S)
	if(role in skills_allocated)
		var/min = get_min_skill(role,S)
		var/T = skills_allocated[role]
		var/freed_points = get_level_cost(role, S, min+T[S])
		points_by_role[role] += freed_points
		T -= S								  //And we no longer need this entry
		if(!length(T))
			skills_allocated -= role		  //Don't keep track of a role with no allocation

/datum/category_item/player_setup_item/role/proc/update_skill_value(datum/role/role, decl/hierarchy/skill/S, new_level)
	if(!isnum(new_level) || (round(new_level) != new_level))
		return											//Checks to make sure we were fed an integer.
	if(!pref.check_skill_prerequisites(role, S))
		return
	var/min = pref.get_min_skill(role,S)

	if(new_level == min)
		pref.clear_skill(role, S)
		pref.purge_skills_missing_prerequisites(role)
		return

	var/max = pref.get_max_skill(role,S)
	if(!(role in pref.skills_allocated))
		pref.skills_allocated[role] = list()
	var/list/T = pref.skills_allocated[role]
	var/current_value = pref.get_level_cost(role, S, min+T[S])
	var/new_value = pref.get_level_cost(role, S, new_level)

	if((new_level < min) || (new_level > max) || (pref.points_by_role[role] + current_value - new_value < 0))
		return											//Checks if the new value is actually allowed.
														//None of this should happen normally, but this avoids client attacks.
	pref.points_by_role[role] += (current_value - new_value)
	T[S] = new_level - min								//skills_allocated stores the difference from role minimum
	pref.purge_skills_missing_prerequisites(role)

/datum/category_item/player_setup_item/role/proc/generate_skill_content(datum/role/role)
	var/dat  = list()
	dat += "<body>"
	dat += "<style>.Selectable,.Current,.Unavailable,.Toohigh{border: 1px solid #161616;padding: 1px 4px 1px 4px;margin: 0 2px 0 0}</style>"
	dat += "<style>.Selectable,a.Selectable{background: #40628a}</style>"
	dat += "<style>.Current,a.Current{background: #2f943c}</style>"
	dat += "<style>.Unavailable{background: #d09000}</style>"
	dat += "<tt><center>"
	dat += "<b>Skill points remaining: [pref.points_by_role[role]].</b><hr>"
	dat += "<hr>"
	dat += "</center></tt>"

	dat += "<table>"
	var/decl/hierarchy/skill/skill = decls_repository.get_decl(/decl/hierarchy/skill)
	for(var/decl/hierarchy/skill/cat in skill.children)
		dat += "<tr><th colspan = 4><b>[cat.name]</b>"
		dat += "</th></tr>"
		for(var/decl/hierarchy/skill/S in cat.children)
			dat += get_skill_row(role, S)
			for(var/decl/hierarchy/skill/perk in S.children)
				dat += get_skill_row(role, perk)
	dat += "</table>"
	return JOINTEXT(dat)

/datum/category_item/player_setup_item/role/proc/get_skill_row(datum/role/role, decl/hierarchy/skill/S)
	var/list/dat = list()
	var/min = pref.get_min_skill(role,S)
	var/level = min + (pref.skills_allocated[role] ? pref.skills_allocated[role][S] : 0)				//the current skill level
	var/cap = pref.get_max_affordable(role, S) //if selecting the skill would make you overspend, it won't be shown
	dat += "<tr style='text-align:left;'>"
	dat += "<th><a href='?src=\ref[src];skillinfo=\ref[S]'>[S.name] ([pref.get_spent_points(role, S)])</a></th>"
	for(var/i = SKILL_MIN, i <= SKILL_MAX, i++)
		dat += skill_to_button(S, role, level, i, min, cap)
	dat += "</tr>"
	return JOINTEXT(dat)

/datum/category_item/player_setup_item/role/proc/open_skill_setup(mob/user, datum/role/role)
	panel = new(user, "Skill Selection: [role.title]", "Skill Selection: [role.title]", 770, 850, src)
	panel.set_content(generate_skill_content(role))
	panel.open()

/datum/category_item/player_setup_item/role/proc/skill_to_button(decl/hierarchy/skill/skill, datum/role/role, current_level, selection_level, min, max)
	var/offset = skill.prerequisites ? skill.prerequisites[skill.parent.type] - 1 : 0
	var/effective_level = selection_level - offset
	if(effective_level <= 0 || effective_level > length(skill.levels))
		return "<th></th>"
	var/level_name = skill.levels[effective_level]
	var/cost = skill.get_cost(effective_level)
	var/button_label = "[level_name] ([cost])"
	if(effective_level < min)
		return "<th><span class='Unavailable'>[button_label]</span></th>"
	else if(effective_level < current_level)
		return "<th>[add_link(skill, role, button_label, "'Current'", effective_level)]</th>"
	else if(effective_level == current_level)
		return "<th><span class='Current'>[button_label]</span></th>"
	else if(effective_level <= max)
		return "<th>[add_link(skill, role, button_label, "'Selectable'", effective_level)]</th>"
	else
		return "<th><span class='Toohigh'>[button_label]</span></th>"

/datum/category_item/player_setup_item/role/proc/add_link(decl/hierarchy/skill/skill, datum/role/role, text, style, value)
	if(pref.check_skill_prerequisites(role, skill))
		return "<a class=[style] href='?src=\ref[src];hit_skill_button=\ref[skill];at_role=\ref[role];newvalue=[value]'>[text]</a>"
	return text