/datum/map/torch
	species_to_role_whitelist = list(
		/datum/species/adherent = list(/datum/role/ai, /datum/role/cyborg, /datum/role/assistant, /datum/role/janitor, /datum/role/chef, /datum/role/bartender, /datum/role/cargo_tech,
										/datum/role/engineer, /datum/role/roboticist, /datum/role/chemist, /datum/role/scientist_assistant, /datum/role/scientist, /datum/role/nt_pilot),
		/datum/species/nabber = list(/datum/role/ai, /datum/role/cyborg, /datum/role/janitor, /datum/role/scientist_assistant, /datum/role/chemist,
									 /datum/role/roboticist, /datum/role/biomech, /datum/role/cargo_tech, /datum/role/chef, /datum/role/engineer, /datum/role/doctor, /datum/role/bartender),
		/datum/species/vox = list(/datum/role/ai, /datum/role/cyborg, /datum/role/merchant, /datum/role/stowaway)
	)

#define HUMAN_ONLY_ROLES /datum/role/captain, /datum/role/hop, /datum/role/cmo, /datum/role/chief_engineer, /datum/role/hos, /datum/role/representative, /datum/role/sea, /datum/role/pathfinder
	species_to_role_blacklist = list(
		/datum/species/unathi  = list(HUMAN_ONLY_ROLES, /datum/role/liaison, /datum/role/warden), //Other roles unavailable via branch restrictions,
		/datum/species/skrell  = list(HUMAN_ONLY_ROLES),
		/datum/species/machine = list(HUMAN_ONLY_ROLES),
		/datum/species/diona   = list(HUMAN_ONLY_ROLES, /datum/role/officer, /datum/role/bodyguard, /datum/role/rd, /datum/role/liaison, /datum/role/warden),	//Other roles unavailable via branch restrictions,
	)
#undef HUMAN_ONLY_ROLES

	allowed_roles = list(/datum/role/captain, /datum/role/hop, /datum/role/rd, /datum/role/cmo, /datum/role/chief_engineer, /datum/role/hos,
						/datum/role/liaison, /datum/role/bodyguard, /datum/role/representative, /datum/role/sea,
						/datum/role/bridgeofficer, /datum/role/pathfinder, /datum/role/nt_pilot, /datum/role/explorer,
						/datum/role/senior_engineer, /datum/role/engineer, /datum/role/roboticist, /datum/role/engineer_trainee,
						/datum/role/officer, /datum/role/warden, /datum/role/detective,
						/datum/role/senior_doctor, /datum/role/doctor, /datum/role/biomech, /datum/role/chemist, /datum/role/medical_trainee,
						/datum/role/psychiatrist,
						/datum/role/qm, /datum/role/cargo_tech, /datum/role/mining,
						/datum/role/janitor, /datum/role/chef, /datum/role/bartender,
						/datum/role/senior_scientist, /datum/role/scientist, /datum/role/scientist_assistant,
						/datum/role/ai, /datum/role/cyborg,
						/datum/role/crew, /datum/role/assistant,
						/datum/role/merchant, /datum/role/stowaway
						)

	access_modify_region = list(
		ACCESS_REGION_SECURITY = list(access_change_ids),
		ACCESS_REGION_MEDBAY = list(access_change_ids),
		ACCESS_REGION_RESEARCH = list(access_change_ids),
		ACCESS_REGION_ENGINEERING = list(access_change_ids),
		ACCESS_REGION_COMMAND = list(access_change_ids),
		ACCESS_REGION_GENERAL = list(access_change_ids),
		ACCESS_REGION_SUPPLY = list(access_change_ids),
		ACCESS_REGION_NT = list(access_change_ids)
	)

/datum/map/torch/setup_role_lists()
	for(var/role_type in allowed_roles)
		var/datum/role/role = SSroles.get_by_path(role_type)
		// Most species are restricted from SCG security and command roles
		if(role && (role.department_flag & COM) && role.allowed_branches.len && !(/datum/mil_branch/civilian in role.allowed_branches))
			for(var/species_name in list(SPECIES_IPC, SPECIES_SKRELL, SPECIES_UNATHI))
				var/datum/species/S = all_species[species_name]
				var/species_blacklist = species_to_role_blacklist[S.type]
				if(!species_blacklist)
					species_blacklist = list()
					species_to_role_blacklist[S.type] = species_blacklist
				species_blacklist |= role.type

// Some roles for nabber grades defined here due to map-specific role datums.
/decl/cultural_info/culture/nabber/New()
	LAZYADD(valid_roles, /datum/role/scientist_assistant)
	..()

/decl/cultural_info/culture/nabber/b/New()
	LAZYADD(valid_roles, /datum/role/cargo_tech)
	..()

/decl/cultural_info/culture/nabber/a/New()
	LAZYADD(valid_roles, /datum/role/engineer)
	..()

/decl/cultural_info/culture/nabber/a/plus/New()
	LAZYADD(valid_roles, /datum/role/doctor)
	..()

/datum/role
	allowed_branches = list(
		/datum/mil_branch/civilian
	)
	allowed_ranks = list(
		/datum/mil_rank/civ/civ
	)

/datum/map/torch
	default_assistant_title = "Passenger"