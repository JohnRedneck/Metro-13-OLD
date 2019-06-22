/datum/faction
	var/name
	var/flag
	var/list/goals
	var/min_goals = 1
	var/max_goals = 2

/datum/faction/proc/Initialize()
	if(!name || !flag || LAZYLEN(goals) <= 0)
		return
	var/list/possible_goals = goals.Copy()
	goals.Cut()
	for(var/i = 1 to min(LAZYLEN(possible_goals), rand(min_goals, max_goals)))
		var/goal = pick_n_take(possible_goals)
		LAZYADD(goals, new goal(src))

/datum/faction/proc/summarize_goals(var/show_success = FALSE)
	. = list()
	for(var/i = 1 to LAZYLEN(goals))
		var/datum/goal/goal = goals[i]
		. += "[i]. [goal.summarize(show_success, position = i)]"

/datum/faction/proc/update_progress(var/goal_type, var/progress)
	var/datum/goal/goal = locate(goal_type) in goals
	if(goal)
		goal.update_progress(progress)
