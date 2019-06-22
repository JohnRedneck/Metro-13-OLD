SUBSYSTEM_DEF(goals)
	name = "Goals"
	init_order = SS_INIT_MISC_LATE
	flags = SS_NO_FIRE
	var/list/global_personal_goals = list(
		/datum/goal/achievement/specific_object/food,
		/datum/goal/achievement/specific_object/drink,
		/datum/goal/achievement/specific_object/pet,
		/datum/goal/achievement/fistfight,
		/datum/goal/achievement/graffiti,
		/datum/goal/achievement/newshound,
		/datum/goal/achievement/givehug,
		/datum/goal/achievement/gethug,
		/datum/goal/movement/walk,
		/datum/goal/movement/walk/eva,
		/datum/goal/clean,
		// /datum/goal/money,
		/datum/goal/sickness
	)
	var/list/factions = list()
	var/list/ambitions =   list()

/datum/controller/subsystem/goals/Initialize()
	var/list/all_factions = subtypesof(/datum/faction)
	//See if map is very particular about what depts it has
	if(LAZYLEN(GLOB.using_map.factions))
		all_factions = GLOB.using_map.factions
	for(var/dtype in all_factions)
		var/datum/faction/faction = dtype
		var/faction_flag = initial(faction.flag)
		if(faction_flag)
			factions["[faction_flag]"] = new dtype
	for(var/thing in factions)
		var/datum/faction/faction = factions[thing]
		faction.Initialize()
	. = ..()

/datum/controller/subsystem/goals/proc/update_faction_goal(var/faction_flag, var/goal_type, var/progress)
	var/datum/faction/faction = factions["[faction_flag]"]
	if(faction)
		faction.update_progress(goal_type, progress)

/datum/controller/subsystem/goals/proc/get_roundend_summary()
	. = list()
	for(var/thing in factions)
		var/datum/faction/faction = factions[thing]
		. += "<b>[faction.name] had the following shift goals:</b>"
		. += faction.summarize_goals(show_success = TRUE)
	if(LAZYLEN(.))
		. = "<br>[jointext(., "<br>")]"
	else
		. = "<br><b>There were no faction goals this round.</b>"
