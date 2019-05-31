//Makes sure we don't get any merchant antags as a balance concern. Can also be used for future Torch specific antag restrictions.
/datum/antagonist/changeling
	blacklisted_roles = list(/datum/role/ai, /datum/role/cyborg, /datum/role/merchant, /datum/role/captain, /datum/role/hop, /datum/role/submap)

/datum/antagonist/godcultist
	blacklisted_roles = list(/datum/role/ai, /datum/role/cyborg, /datum/role/chaplain, /datum/role/merchant, /datum/role/captain, /datum/role/hop, /datum/role/hos, /datum/role/submap)

/datum/antagonist/cultist
	blacklisted_roles = list(/datum/role/ai, /datum/role/cyborg, /datum/role/chaplain, /datum/role/psychiatrist, /datum/role/merchant, /datum/role/captain, /datum/role/hop, /datum/role/hos, /datum/role/submap)

/datum/antagonist/loyalists
	blacklisted_roles = list(/datum/role/ai, /datum/role/cyborg, /datum/role/merchant, /datum/role/submap)

/datum/antagonist/revolutionary
	blacklisted_roles = list(/datum/role/ai, /datum/role/cyborg, /datum/role/merchant, /datum/role/submap)

/datum/antagonist/traitor
	blacklisted_roles = list(/datum/role/merchant, /datum/role/captain, /datum/role/hop, /datum/role/ai, /datum/role/submap)

/datum/antagonist/ert
	var/sic //Second-In-Command
	leader_welcome_text = "As leader of the Emergency Response Team, you are part of the Sol Central Government Fleet, and are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should, to this effect, aid the Commanding Officer or ranking officer aboard in their endeavours to achieve this."

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	player.char_branch = mil_branches.get_branch("Fleet")
	if(player.mind == leader)
		player.char_rank = mil_branches.get_rank("Fleet", "Lieutenant")
	else if(!sic)
		sic = player.mind
		player.char_rank = mil_branches.get_rank("Fleet", "Chief Petty Officer")
	else if(prob(50))
		player.char_rank = mil_branches.get_rank("Fleet", "Petty Officer Second Class")
	else
		player.char_rank = mil_branches.get_rank("Fleet", "Petty Officer First Class")

	var/decl/hierarchy/outfit/ert_outfit = outfit_by_type((player.mind == leader) ? /decl/hierarchy/outfit/role/torch/ert/leader : /decl/hierarchy/outfit/role/torch/ert)
	ert_outfit.equip(player)

	if(player.char_rank && player.char_rank.accessory)
		for(var/accessory_path in player.char_rank.accessory)
			var/list/accessory_data = player.char_rank.accessory[accessory_path]
			if(islist(accessory_data))
				var/amt = accessory_data[1]
				var/list/accessory_args = accessory_data.Copy()
				accessory_args[1] = src
				for(var/i in 1 to amt)
					player.equip_to_slot_or_del(new accessory_path(arglist(accessory_args)), slot_tie)
			else
				for(var/i in 1 to (isnull(accessory_data)? 1 : accessory_data))
					player.equip_to_slot_or_del(new accessory_path(src), slot_tie)

	return 1
