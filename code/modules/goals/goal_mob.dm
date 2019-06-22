/mob/proc/has_personal_goal(var/goal_type)
	if(mind) return locate(goal_type) in mind.goals

/mob/proc/update_personal_goal(var/goal_type, var/progress)
	var/datum/goal/goal = has_personal_goal(goal_type)
	if(goal)
		goal.update_progress(progress)

/mob/verb/show_goals_verb()

	set name = "Show Goals"
	set desc = "Shows your round goals."
	set category = "IC"

	show_goals(TRUE, TRUE)

/mob/proc/show_goals(var/show_success = FALSE, var/allow_modification = FALSE)

	if(!mind)
		to_chat(src, SPAN_WARNING("You are mindless and cannot have goals."))
		return

	var/datum/faction/faction
	if(mind.assigned_role && mind.assigned_role.faction_flag && SSgoals.factions["[mind.assigned_role.faction_flag]"])
		faction = SSgoals.factions["[mind.assigned_role.faction_flag]"]

	//No goals to display
	if(!(allow_modification || LAZYLEN(mind.goals)) && !(faction && LAZYLEN(faction.goals)))
		return

	to_chat(src, "<hr>")
	if(LAZYLEN(mind.goals))
		to_chat(src, SPAN_NOTICE("<b>This round, you have the following personal goals:</b><br>[jointext(mind.summarize_goals(show_success, allow_modification), "<br>")]"))
	else
		to_chat(src, SPAN_NOTICE("<b>You have no personal goals this round.</b>"))
	if(allow_modification && LAZYLEN(mind.goals) < 5)
		to_chat(src, SPAN_NOTICE("<a href='?src=\ref[mind];add_goal=1;add_goal_caller=\ref[mind.current]'>Add Random Goal</a>"))

	if(LAZYLEN(faction.goals))
		to_chat(src, SPAN_NOTICE("<br><b>This round, [faction.name] has the following faction goals:</b><br>[jointext(faction.summarize_goals(show_success), "<br>")]"))
	else
		to_chat(src, SPAN_NOTICE("<br><b>[faction.name] has no faction goals this round.</b>"))

	if(LAZYLEN(mind.goals))
		to_chat(mind.current, SPAN_NOTICE("<br><br>You can check your round goals with the <b>Show Goals</b> verb."))

	to_chat(src, "<hr>")
