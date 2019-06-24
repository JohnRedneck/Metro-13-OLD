var/const/LEAD              =(1<<0)
var/const/MIL               =(1<<1)
var/const/CIV               =(1<<2)
var/const/VAG               =(1<<3)
var/const/REDLINE           =(1<<4)
var/const/VDNK              =(1<<5)
var/const/REICH             =(1<<6)
var/const/NEUTRAL           =(1<<7)

var/list/archetype_role_datums =    list()
var/list/role_lists_by_map_name =   list()
var/list/titles_to_datums =         list()
var/list/types_to_datums =          list()
var/list/primary_role_datums =      list()
var/list/unassigned_roundstart =    list()
var/list/positions_by_role =        list()
var/list/role_icons =               list()

SUBSYSTEM_DEF(roles)
	name = "Factions and Roles"
	init_order = SS_INIT_ROLES
	flags = SS_NO_FIRE

	var/list/archetype_role_datums =    list()
	var/list/role_lists_by_map_name =   list()
	var/list/titles_to_datums =         list()
	var/list/types_to_datums =          list()
	var/list/primary_role_datums =      list()
	var/list/unassigned_roundstart =    list()
	var/list/positions_by_role =        list()
	var/list/role_icons =               list()
	var/role_config_file = "config/roles.txt"

/datum/controller/subsystem/roles/Initialize(timeofday)

	// Create main map roles.
	primary_role_datums.Cut()
	//If a role is present we'll add the faction it belongs to to the list of
	for(var/roletype in (list(/datum/role/neutral/vagrant) | GLOB.using_map.allowed_roles))
		var/datum/role/role = get_by_path(roletype)
		if(!role)
			role = new roletype
		primary_role_datums += role
	// Create abstract submap archetype roles for use in prefs, etc.
	archetype_role_datums.Cut()
	for(var/atype in SSmapping.submap_archetypes)
		var/decl/submap_archetype/arch = SSmapping.submap_archetypes[atype]
		for(var/roletype in arch.crew_roles)
			var/datum/role/role = get_by_path(roletype)
			if(!role && ispath(roletype, /datum/role/submap))
				// Set this here so that we don't create multiples of the same title
				// before getting to the cache updating proc below.
				types_to_datums[roletype] = new roletype(abstract_role = TRUE)
				role = get_by_path(roletype)
			if(role)
				archetype_role_datums |= role
				
	// Load role configuration (is this even used anymore?)
	if(role_config_file && config.load_roles_from_txt)
		var/list/roleEntries = file2list(role_config_file)
		for(var/role in roleEntries)
			if(!role)
				continue
			role = trim(role)
			if(!length(role))
				continue
			var/pos = findtext(role, "=")
			if(pos)
				continue
			var/name = copytext(role, 1, pos)
			var/value = copytext(role, pos + 1)
			if(name && value)
				var/datum/role/R = get_by_title(name)
				if(R)
					R.total_positions = text2num(value)
					R.spawn_positions = text2num(value)

	// Init skills.
	if(!GLOB.skills.len)
		decls_repository.get_decl(/decl/hierarchy/skill)
	if(!GLOB.skills.len)
		log_error("<span class='warning'>Error setting up role skill requirements, no skill datums found!</span>")

	// Update title and path tracking, submap list, etc.
	// Populate/set up map role lists.
	role_lists_by_map_name = list("[GLOB.using_map.full_name]" = list("roles" = primary_role_datums, "default_to_hidden" = FALSE))

	for(var/atype in SSmapping.submap_archetypes)
		var/list/submap_role_datums
		var/decl/submap_archetype/arch = SSmapping.submap_archetypes[atype]
		for(var/roletype in arch.crew_roles)
			var/datum/role/role = get_by_path(roletype)
			if(role)
				LAZYADD(submap_role_datums, role)
		if(LAZYLEN(submap_role_datums))
			role_lists_by_map_name[arch.descriptor] = list("roles" = submap_role_datums, "default_to_hidden" = TRUE)

	// Update global map blacklists and whitelists.
	for(var/mappath in GLOB.all_maps)
		var/datum/map/M = GLOB.all_maps[mappath]
		M.setup_role_lists()

	// Update valid role titles.
	titles_to_datums = list()
	types_to_datums = list()
	positions_by_role = list()
	for(var/map_name in role_lists_by_map_name)
		var/list/map_data = role_lists_by_map_name[map_name]
		for(var/datum/role/role in map_data["roles"])
			types_to_datums[role.type] = role

			titles_to_datums[role.title] = role
			/* //This likely will not have as much of a purpose due to the lack of ID cards - Bennett
			for(var/alt_title in role.alt_titles)
				titles_to_datums[alt_title] = role
			*/
			if(role.role_flag)
				for (var/I in 1 to GLOB.bitflags.len)
					if(role.faction_flag & GLOB.bitflags[I])
						LAZYDISTINCTADD(positions_by_role["[GLOB.bitflags[I]]"], role.title)

	. = ..()

/datum/controller/subsystem/roles/proc/guest_rolebans(var/role)
	for(var/role_type in list(LEAD))
		if(role in titles_by_role(role_type))
			return TRUE
	return FALSE

/datum/controller/subsystem/roles/proc/reset_occupations()
	for(var/mob/new_player/player in GLOB.player_list)
		if((player) && (player.mind))
			player.mind.assigned_role = null
			player.mind.assigned_rank = null
			player.mind.special_rank = null
	for(var/datum/role/role in primary_role_datums)
		role.current_positions = 0
	unassigned_roundstart = list()

/datum/controller/subsystem/roles/proc/get_by_title(var/rank)
	return titles_to_datums[rank]

/datum/controller/subsystem/roles/proc/get_by_path(var/path)
	return types_to_datums[path]

/datum/controller/subsystem/roles/proc/check_general_join_blockers(var/mob/new_player/joining, var/datum/role/role)
	if(!istype(joining) || !joining.client || !joining.client.prefs)
		return FALSE
	if(!istype(role))
		log_debug("Role assignment error for [joining] - role does not exist or is of the incorrect type.")
		return FALSE
	if(!role.is_position_available())
		to_chat(joining, "<span class='warning'>Unfortunately, that role is no longer available.</span>")
		return FALSE
	if(!config.enter_allowed)
		to_chat(joining, "<span class='warning'>There is an administrative lock on entering the game!</span>")
		return FALSE
	if(SSticker.mode && SSticker.mode.explosion_in_progress)
		to_chat(joining, "<span class='warning'>The [station_name()] is currently exploding. Joining would go poorly.</span>")
		return FALSE
	return TRUE

/datum/controller/subsystem/roles/proc/check_latejoin_blockers(var/mob/new_player/joining, var/datum/role/role)
	if(!check_general_join_blockers(joining, role))
		return FALSE
	if(role.minimum_character_age && (joining.client.prefs.age < role.minimum_character_age))
		to_chat(joining, "<span class='warning'>Your character's in-game age is too low for this role.</span>")
		return FALSE
	if(!role.player_old_enough(joining.client))
		to_chat(joining, "<span class='warning'>Your player age (days since first seen on the server) is too low for this role.</span>")
		return FALSE
	if(GAME_STATE != RUNLEVEL_GAME)
		to_chat(joining, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return FALSE
	return TRUE
//Really we should automate the lower block depending on how we do spawns. \
//Easiest case is just to throw spawnees kind of to their faction bases but still around uninhabited places of the map, \
//then we can just move the spawn around until we get a safe place - Bennett
/datum/controller/subsystem/roles/proc/check_unsafe_spawn(var/mob/living/spawner, var/turf/spawn_turf)
	var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	if(airstatus || radlevel > 0)
		var/reply = alert(spawner, "Warning. Your selected spawn location seems to have unfavorable conditions. \
		You may die shortly after spawning. \
		Spawn anyway? More information: [airstatus] Radiation: [radlevel] Bq", "Atmosphere warning", "Abort", "Spawn anyway")
		if(reply == "Abort")
			return FALSE
		else
			// Let the staff know, in case the person complains about dying due to this later. They've been warned.
			log_and_message_admins("User [spawner] spawned at spawn point with dangerous atmosphere.")
	return TRUE


/datum/controller/subsystem/roles/proc/assign_rank(var/mob/new_player/player, var/rank, var/latejoin = 0)
	if(player && player.mind && rank)
		var/datum/role/role = get_by_title(rank)
		if(!role)
			return 0
		if(role.minimum_character_age && (player.client.prefs.age < role.minimum_character_age))
			return 0
		//We should add a factionbanned function/check also - Bennett
		if(roleban_isbanned(player, rank))
			return 0
		if(!role.player_old_enough(player.client))
			return 0
		if(role.is_restricted(player.client.prefs))
			return 0

		var/position_limit = role.total_positions
		if(!latejoin)
			position_limit = role.spawn_positions
		if((role.current_positions < position_limit) || position_limit == -1)
			player.mind.assigned_role = role
			player.mind.assigned_rank = rank
			player.mind.rank_alt_title = role.get_alt_title_for(player.client)
			unassigned_roundstart -= player
			role.current_positions++
			return 1
	return 0

/datum/controller/subsystem/roles/proc/find_occupation_candidates(datum/role/role, level, flag)
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned_roundstart)
		if(roleban_isbanned(player, role.title))
			continue
		//Add factionban check when that function is implemented
		if(!role.player_old_enough(player.client))
			continue
		if(role.minimum_character_age && (player.client.prefs.age < role.minimum_character_age))
			continue
		if(flag && !(flag in player.client.prefs.be_special_rank))
			continue
		if(player.client.prefs.CorrectLevel(role,level))
			candidates += player
	return candidates

/datum/controller/subsystem/roles/proc/give_random_role(var/mob/new_player/player)
	for(var/datum/role/role in shuffle(primary_role_datums))
		if(!role)
			continue
		if(role.minimum_character_age && (player.client.prefs.age < role.minimum_character_age))
			continue
		if(role.is_restricted(player.client.prefs))
			continue
		if(role.title in titles_by_role(LEAD)) //If you want a command position, select it!
			continue
		if(roleban_isbanned(player, role.title))
			continue
		//Add the factionban check here when implemented - Bennett
		if(!role.player_old_enough(player.client))
			continue
		if((role.current_positions < role.spawn_positions) || role.spawn_positions == -1)
			assign_rank(player, role.title)
			unassigned_roundstart -= player
			break

///This proc is called before the level loop of divide_occupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/subsystem/roles/proc/fill_leader_position()
	for(var/level = 1 to 3)
		for(var/leader_role in titles_by_role(LEAD))
			var/datum/role/role = get_by_title(leader_role)
			if(!role)	continue
			var/list/candidates = find_occupation_candidates(role, level)
			if(!candidates.len)	continue
			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!V.client) continue
				var/age = V.client.prefs.age
				if(age < role.minimum_character_age) // Nope.
					continue
				switch(age)
					if(role.minimum_character_age to (role.minimum_character_age+10))
						weightedCandidates[V] = 3 // Still a bit young.
					if((role.minimum_character_age+10) to (role.ideal_character_age-10))
						weightedCandidates[V] = 6 // Better.
					if((role.ideal_character_age-10) to (role.ideal_character_age+10))
						weightedCandidates[V] = 10 // Great.
					if((role.ideal_character_age+10) to (role.ideal_character_age+20))
						weightedCandidates[V] = 6 // Still good.
					if((role.ideal_character_age+20) to INFINITY)
						weightedCandidates[V] = 3 // Geezer.
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(candidates.len == 1) weightedCandidates[V] = 1
			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(assign_rank(candidate, leader_role))
				return 1
	return 0

///This proc is called at the start of the level loop of divide_occupations() and will cause head roles to be checked before any other roles of the same level
/datum/controller/subsystem/roles/proc/CheckLeaderPositions(var/level)
	for(var/leader_role in titles_by_role(LEAD))
		var/datum/role/role = get_by_title(leader_role)
		if(!role)	continue
		var/list/candidates = find_occupation_candidates(role, level)
		if(!candidates.len)	continue
		var/mob/new_player/candidate = pick(candidates)
		assign_rank(candidate, leader_role)

/** Proc divide_occupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/roles/proc/divide_occupations(datum/game_mode/mode)
	//Get the players who are ready
	for(var/mob/new_player/player in GLOB.player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned_roundstart += player
	if(unassigned_roundstart.len == 0)	return 0
	//Shuffle players and roles
	unassigned_roundstart = shuffle(unassigned_roundstart)
	//People who wants to be assistants, sure, go on.
	var/datum/role/neutral/vagrant = new DEFAULT_ROLE_TYPE ()
	var/list/vagrant_candidates = find_occupation_candidates(vagrant, 3)
	for(var/mob/new_player/player in vagrant_candidates)
		assign_rank(player, GLOB.using_map.default_vagrant_title)
		vagrant_candidates -= player

	//Select one leader
	fill_leader_position()

	//Other roles are now checked
	// New role giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to role giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(primary_role_datums)
	for(var/level = 1 to 3)
		//Check the head roles first each level
		CheckLeaderPositions(level)

		// Loop through all unassigned players
		var/list/deferred_roles = list()
		for(var/mob/new_player/player in unassigned_roundstart)
			// Loop through all roles
			for(var/datum/role/role in shuffledoccupations) // SHUFFLE ME BABY
				if(role && !mode.disabled_roles.Find(role.title) )
					if(role.defer_roundstart_spawn)
						deferred_roles[role] = TRUE
					else if(attempt_role_assignment(player, role, level))
						unassigned_roundstart -= player
						break

		if(LAZYLEN(deferred_roles))
			for(var/mob/new_player/player in unassigned_roundstart)
				for(var/datum/role/role in deferred_roles)
					if(attempt_role_assignment(player, role, level))
						unassigned_roundstart -= player
						break
			deferred_roles.Cut()

	// Hand out random roles to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == GET_RANDOM_ROLE)
			give_random_role(player)
	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == BE_VAGRANT)
			var/datum/role/vag = /datum/role/neutral/vagrant
			if((GLOB.using_map.flags & MAP_HAS_BRANCH) && player.client.prefs.branches[initial(vag.title)])
				var/datum/mil_branch/branch = mil_branches.get_branch(player.client.prefs.branches[initial(vag.title)])
				vag = branch.vagrant_role
			assign_rank(player, initial(vag.title))
	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned_roundstart)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.new_player_panel()
			unassigned_roundstart -= player
	return TRUE

/datum/controller/subsystem/roles/proc/attempt_role_assignment(var/mob/new_player/player, var/datum/role/role, var/level)
	if(!roleban_isbanned(player, role.title) && \
	 role.player_old_enough(player.client) && \
	 player.client.prefs.CorrectLevel(role, level) && \
	 role.is_position_available())
		assign_rank(player, role.title)
		return TRUE
	return FALSE

/datum/controller/subsystem/roles/proc/equip_custom_loadout(var/mob/living/carbon/human/H, var/datum/role/role)

	if(!H || !H.client)
		return

	// Equip custom gear loadout, replacing any role items
	var/list/spawn_in_storage = list()
	var/list/loadout_taken_slots = list()
	//Need to add a check here and corresponding code in loadout.dm to restrict loadout items based on faction.
	if(H.client.prefs.Gear() && role.loadout_allowed)
		for(var/thing in H.client.prefs.Gear())
			var/datum/gear/G = gear_datums[thing]
			if(G)
				var/permitted = 0
				if(G.allowed_branches)
					if(H.char_branch && H.char_branch.type in G.allowed_branches)
						permitted = 1
				else
					permitted = 1

				if(permitted)
					if(G.allowed_roles)
						if(role.type in G.allowed_roles)
							permitted = 1
						else
							permitted = 0
					else
						permitted = 1

				if(G.whitelisted && (!(H.species.name in G.whitelisted)))
					permitted = 0

				if(!permitted)
					to_chat(H, "<span class='warning'>Your current role, faction, or whitelist status does not permit you to spawn with [thing]!</span>")
					continue

				if(!G.slot || G.slot == slot_tie || (G.slot in loadout_taken_slots) || !G.spawn_on_mob(H, H.client.prefs.Gear()[G.display_name]))
					spawn_in_storage.Add(G)
				else
					loadout_taken_slots.Add(G.slot)

	// do accessories last so they don't attach to a suit that will be replaced
	if(H.char_rank && H.char_rank.accessory)
		for(var/accessory_path in H.char_rank.accessory)
			var/list/accessory_data = H.char_rank.accessory[accessory_path]
			if(islist(accessory_data))
				var/amt = accessory_data[1]
				var/list/accessory_args = accessory_data.Copy()
				accessory_args[1] = src
				for(var/i in 1 to amt)
					H.equip_to_slot_or_del(new accessory_path(arglist(accessory_args)), slot_tie)
			else
				for(var/i in 1 to (isnull(accessory_data)? 1 : accessory_data))
					H.equip_to_slot_or_del(new accessory_path(src), slot_tie)

	return spawn_in_storage

/datum/controller/subsystem/roles/proc/equip_rank(var/mob/living/carbon/human/H, var/rank, var/joined_late = 0)
	if(!H)
		return

	var/datum/role/role = get_by_title(rank)
	var/list/spawn_in_storage

	if(role)
		if(H.client)
			if(GLOB.using_map.flags & MAP_HAS_BRANCH)
				H.char_branch = mil_branches.get_branch(H.client.prefs.branches[rank])
			if(GLOB.using_map.flags & MAP_HAS_RANK)
				H.char_rank = mil_branches.get_rank(H.client.prefs.branches[rank], H.client.prefs.ranks[rank])

		// Transfers the skill settings for the role to the mob
		H.skillset.obtain_from_client(role, H.client)

		//Equip role items.
		//role.setup_account(H) //This proc manages economics stuff which hasn't been reworked yet - Bennett

		role.equip(H, H.mind ? H.mind.rank_alt_title : "", H.char_branch, H.char_rank)
		role.apply_fingerprints(H)
		spawn_in_storage = equip_custom_loadout(H, role)
	else
		to_chat(H, "Your role is [rank] and the game just can't handle it! Please report this bug to an administrator.")

	H.role = rank

	if(!joined_late || role.latejoin_at_spawnpoints)
		var/obj/S = role.get_roundstart_spawnpoint()

		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.forceMove(S.loc)
		else
			var/datum/spawnpoint/spawnpoint = role.get_spawnpoint(H.client)
			H.forceMove(pick(spawnpoint.turfs))
			spawnpoint.after_join(H)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	// If they're head, give them the account info for their department
	/*
	if(H.mind && role.head_position)
		var/remembered_info = ""
		//var/datum/money_account/department_account = department_accounts[role.department]

		if(department_account)
			remembered_info += "<b>Your department's account number is:</b> #[department_account.account_number]<br>"
			remembered_info += "<b>Your department's account pin is:</b> [department_account.remote_access_pin]<br>"
			remembered_info += "<b>Your department's account funds are:</b> T[department_account.money]<br>"

		H.mind.store_memory(remembered_info)
	*/
	var/alt_title = null
	if(H.mind)
		H.mind.assigned_role = role
		H.mind.assigned_rank = rank
		alt_title = H.mind.rank_alt_title
		/*
		switch(rank)

			if("Robot")
				return H.Robotize(SSrobots.get_mob_type_by_title(alt_title ? alt_title : role.title))
			if("AI")
				return H
			if("Captain")
				var/sound/announce_sound = (GAME_STATE <= RUNLEVEL_SETUP)? null : sound('sound/misc/boatswain.ogg', volume=20)
				captain_announcement.Announce("All hands, Captain [H.real_name] on deck!", new_sound=announce_sound)
		*/
	if(spawn_in_storage)
		for(var/datum/gear/G in spawn_in_storage)
			G.spawn_in_storage_or_drop(H, H.client.prefs.Gear()[G.display_name])

	//Might want to shove wheelchair code this off to some function which equips starting gear based on role/loadout starting gear flags, \
	//so you can choose to invest heavily into skills/traits/gear and choose to not take a wheelchair and just be the crawling maestro roundstart, \
	//also would be useful for a "screwed over" roundstart scenario involving having to crawl to safety and splint your own broken legs. - Bennett
	if(istype(H)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ(BP_L_FOOT)
		var/obj/item/organ/external/r_foot = H.get_organ(BP_R_FOOT)
		if(!l_foot || !r_foot)
			var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(H.loc)
			H.buckled = W
			H.UpdateLyingBuckledAndVerbStatus()
			W.set_dir(H.dir)
			W.buckled_mob = H
			W.add_fingerprint(H)

	to_chat(H, "<B>You are [role.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B>")

	if(role.supervisors)
		to_chat(H, "<b>As the [alt_title ? alt_title : rank] you answer [role.supervisors].</b>")

	//Lower statement might be less useful because of the whole "leadership being fluid" idea and also the "multiple major events" deal, \
	//but it might be useful for some antagonist leader role that has special abilities, \
	//so an admin can switch one of their follower antagonists to the leader role. - Bennett
	if(role.req_admin_notify)
		to_chat(H, "<b>You are playing a role that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>")

	//Might remove the lower block when we get to trait changes, \
	//as giving everyone with a visual impairment glasses that correct it at roundstart perfectly might make the trait less meaningfull - Bennett

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
		if(equipped)
			var/obj/item/clothing/glasses/G = H.glasses
			G.prescription = 7

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)

	role.post_equip_role(H)

	return H

//This returns a bunch of roles based on role.title, we might want to make another function based on roletype instead of role - Bennett
/datum/controller/subsystem/roles/proc/titles_by_role(var/role)
	return positions_by_role["[role]"] || list()