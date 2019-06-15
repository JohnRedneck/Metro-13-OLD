// Generates a simple HTML crew manifest for use in various places
/proc/html_crew_manifest(var/monochrome, var/OOC)
	var/list/faction_data = list(
		list("names" = list(), "header" = "Red Line Members", "flag" = REDLINE),
		list("names" = list(), "header" = "VDNKh Members", "flag" = VDNK),
		list("names" = list(), "header" = "Fourth Reich Members", "flag" = REICH),
		list("names" = list(), "header" = "Neutrals", "flag" = NEUTRAL),
	)

	var/list/isactive = new()
	var/list/mil_ranks = list() // HTML to prepend to name
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;width:100%;}
		.manifest td, th {border:1px solid [monochrome?"black":"[OOC?"black; background-color:#272727; color:white":"#DEF; background-color:white; color:black"]"]; padding:.25em}
		.manifest th {height: 2em; [monochrome?"border-top-width: 3px":"background-color: [OOC?"#40628a":"#48C"]; color:white"]}
		.manifest tr.head th { [monochrome?"border-top-width: 1px":"background-color: [OOC?"#013D3B;":"#488;"]"] }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {[monochrome?"border-top-width: 2px":"background-color: [OOC?"#373737; color:white":"#DEF"]"]}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Position</th><th>Activity</th></tr>
	"}
	// sort mobs
	for(var/datum/computer_file/report/crew_record/CR in GLOB.all_crew_records)
		var/name = CR.get_formal_name()
		var/rank = CR.get_role()
		mil_ranks[name] = ""

		if(GLOB.using_map.flags & MAP_HAS_RANK)
			var/datum/mil_branch/branch_obj = mil_branches.get_branch(CR.get_branch())
			var/datum/mil_rank/rank_obj = mil_branches.get_rank(CR.get_branch(), CR.get_rank())

			if(branch_obj && rank_obj)
				mil_ranks[name] = "<abbr title=\"[rank_obj.name], [branch_obj.name]\">[rank_obj.name_short]</abbr> "

		if(OOC)
			var/active = 0
			for(var/mob/M in GLOB.player_list)
				var/mob_real_name = M.real_name
				if(sanitize(mob_real_name) == CR.get_name() && M.client && M.client.inactivity <= 10 MINUTES)
					active = 1
					break
			isactive[name] = active ? "Active" : "Inactive"
		else
			isactive[name] = CR.get_status()

		var/datum/role/role = SSroles.get_by_title(rank)
		var/found_place = 0
		if(role)
			for(var/list/faction in faction_data)
				var/list/names = faction["names"]
				if(role.faction_flag & faction["flag"])
					names[name] = rank
					found_place = 1
		/*
		if(!found_place)
			misc[name] = rank
		*/
	for(var/list/faction in faction_data)
		var/list/names = faction["names"]
		if(names.len > 0)
			dat += "<tr><th colspan=3>[faction["header"]]</th></tr>"
			for(var/name in names)
				dat += "<tr class='candystripe'><td>[mil_ranks[name]][name]</td><td>[names[name]]</td><td>[isactive[name]]</td></tr>"

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/proc/filtered_nano_crew_manifest(var/list/filter, var/blacklist = FALSE)
	var/list/filtered_entries = list()
	for(var/datum/computer_file/report/crew_record/CR in faction_crew_manifest(filter, blacklist))
		filtered_entries.Add(list(list(
			"name" = CR.get_name(),
			"rank" = CR.get_role(),
			"status" = CR.get_status(),
			"branch" = CR.get_branch(),
			"milrank" = CR.get_rank()
		)))
	return filtered_entries

/proc/nano_crew_manifest()
	return list(
		"redline" = filtered_nano_crew_manifest(SSroles.titles_by_role(REDLINE)),
		"vdnkh" =   filtered_nano_crew_manifest(SSroles.titles_by_role(VDNK)),
		"reich" =   filtered_nano_crew_manifest(SSroles.titles_by_role(REICH)),
		"neutrals" =   filtered_nano_crew_manifest(SSroles.titles_by_role(NEUTRAL))
	)


/proc/flat_nano_crew_manifest()
	. = list()
	. += filtered_nano_crew_manifest(null, TRUE)
