// A lot of this is boilerplate from the standard role controller, but it's different enough and
// requires enough shit skipped or removed that I think the boilerplate is justified. The offsite
// roles do not require rank or branch checks, they don't require latejoin vs. initial spawn checks
// and they handle their spawn points on a ship by ship, archetype by archetype, overmap-aware
// manner. This is mostly being written here so I don't feel like a fool when I open the PR.

/datum/submap/Topic(href, href_list)
	. = ..()
	if(!.)
		var/join_as = href_list["join_as"]
		if(join_as && roles[join_as])
			join_as(locate(href_list["joining"]), roles[join_as])
			return TRUE

/datum/submap/proc/check_general_join_blockers(var/mob/new_player/joining, var/datum/role/submap/role)

	if(!istype(role)) // This proc uses a specific type that check_latejoin_blockers() does not.
		log_debug("Role assignment error for [name] - role does not exist or is of the incorrect type.")
		return FALSE

	if(!SSroles.check_latejoin_blockers(joining, role))
		return FALSE

	if(!available())
		to_chat(joining, "<span class='warning'>Unfortunately, that role is no longer available.</span>")
		return FALSE

	if(roleban_isbanned(joining, "Offstation Roles"))
		to_chat(joining, "<span class='warning'>You are banned from playing offstation roles.</span>")
		return FALSE

	if(role.is_restricted(joining.client.prefs, joining))
		return FALSE

	return TRUE

/datum/submap/proc/join_as(var/mob/new_player/joining, var/datum/role/submap/role)

	if(!check_general_join_blockers(joining, role))
		return

	if(!LAZYLEN(role.spawnpoints))
		to_chat(joining, "<span class='warning'>There are no available spawn points for that role.</span>")

	var/turf/spawn_turf = get_turf(pick(role.spawnpoints))
	if(!SSroles.check_unsafe_spawn(joining, spawn_turf))
		return

	// check_unsafe_spawn() has an input() call, check blockers again.
	if(!check_general_join_blockers(joining, role))
		return

	log_debug("Player: [joining] is now offsite rank: [role.title] ([name]), JCP:[role.current_positions], JPL:[role.total_positions]")
	joining.mind.assigned_role = role
	joining.mind.assigned_role = role.title
	joining.faction = name
	role.current_positions++

	var/mob/living/character = joining.create_character(spawn_turf)
	if(istype(character))

		var/mob/living/carbon/human/user_human
		if(ishuman(character))
			user_human = character
			if(role.branch && mil_branches)
				user_human.char_branch = mil_branches.get_branch(role.branch)
				user_human.char_rank =   mil_branches.get_rank(role.branch, role.rank)

			// We need to make sure to use the abstract instance here; it's not the same as the one we were passed.
			character.skillset.obtain_from_client(SSroles.get_by_path(role.type), character.client)
			role.equip(character, "")
			role.apply_fingerprints(character)
			var/list/spawn_in_storage = SSroles.equip_custom_loadout(character, role)
			if(spawn_in_storage)
				for(var/datum/gear/G in spawn_in_storage)
					G.spawn_in_storage_or_drop(user_human, user_human.client.prefs.Gear()[G.display_name])
			equip_custom_items(user_human)

		character.role = role.title
		if(character.mind)
			character.mind.assigned_role = role
			character.mind.assigned_role = character.role

		to_chat(character, "<B>You are [role.total_positions == 1 ? "the" : "a"] [role.title] of the [name].</B>")

		if(role.supervisors)
			to_chat(character, "<b>As a [role.title] you answer directly to [role.supervisors].</b>")
		var/datum/role/submap/orole = role
		if(istype(orole) && orole.info)
			to_chat(character, orole.info)

		if(user_human && user_human.disabilities & NEARSIGHTED)
			var/equipped = user_human.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(user_human), slot_glasses)
			if(equipped)
				var/obj/item/clothing/glasses/G = user_human.glasses
				G.prescription = 7

		BITSET(character.hud_updateflag, ID_HUD)
		BITSET(character.hud_updateflag, IMPLOYAL_HUD)
		BITSET(character.hud_updateflag, SPECIALROLE_HUD)

		SSticker.mode.handle_offsite_latejoin(character)
		GLOB.universe.OnPlayerLatejoin(character)
		log_and_message_admins("has joined the round as offsite role [character.mind.assigned_role].", character)
		if(character.cannot_stand()) equip_wheelchair(character)
		qdel(joining)

	return character
