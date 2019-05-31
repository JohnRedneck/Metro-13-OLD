//Torch ID Cards (they have to be here to make the outfits work, no way around it)

/obj/item/weapon/card/id/torch
	name = "identification card"
	desc = "An identification card issued to personnel aboard the SEV Torch."
	role_access_type = /datum/role/assistant

/obj/item/weapon/card/id/torch/silver
	desc = "A silver identification card belonging to heads of staff."
	item_state = "silver_id"
	role_access_type = /datum/role/hop
	extra_details = list("goldstripe")
	color = "#ccecff"

/obj/item/weapon/card/id/torch/gold
	desc = "A golden identification card belonging to the Commanding Officer."
	item_state = "gold_id"
	role_access_type = /datum/role/captain
	color = "#d4c780"
	extra_details = list("goldstripe")

// SolGov Crew and Contractors
/obj/item/weapon/card/id/torch/crew
	desc = "An identification card issued to SolGov crewmembers aboard the SEV Torch."
	color = "#d3e3e1"
	role_access_type = /datum/role/crew
	color = "#ccecff"


/obj/item/weapon/card/id/torch/contractor
	desc = "An identification card issued to private contractors aboard the SEV Torch."
	role_access_type = /datum/role/assistant
	color = COLOR_GRAY80


/obj/item/weapon/card/id/torch/silver/medical
	role_access_type = /datum/role/cmo
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/weapon/card/id/torch/crew/medical
	role_access_type = /datum/role/doctor
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/weapon/card/id/torch/crew/medical/senior
	role_access_type = /datum/role/senior_doctor

/obj/item/weapon/card/id/torch/contractor/medical
	role_access_type = /datum/role/doctor
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/weapon/card/id/torch/contractor/medical/senior
	role_access_type = /datum/role/senior_doctor

/obj/item/weapon/card/id/torch/contractor/chemist
	role_access_type = /datum/role/chemist
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/weapon/card/id/torch/contractor/biomech
	role_access_type = /datum/role/biomech
	detail_color = COLOR_PALE_BLUE_GRAY

/obj/item/weapon/card/id/torch/contractor/medical/counselor
	role_access_type = /datum/role/psychiatrist


/obj/item/weapon/card/id/torch/silver/security
	role_access_type = /datum/role/hos
	detail_color = "#e00000"

/obj/item/weapon/card/id/torch/crew/security
	role_access_type = /datum/role/officer
	detail_color = "#e00000"

/obj/item/weapon/card/id/torch/crew/security/brigofficer
	role_access_type = /datum/role/warden
	extra_details = list("onegoldstripe")

/obj/item/weapon/card/id/torch/crew/security/forensic
	role_access_type = /datum/role/detective


/obj/item/weapon/card/id/torch/silver/engineering
	role_access_type = /datum/role/chief_engineer
	detail_color = COLOR_SUN

/obj/item/weapon/card/id/torch/crew/engineering
	role_access_type = /datum/role/engineer
	detail_color = COLOR_SUN

/obj/item/weapon/card/id/torch/crew/engineering/senior
	role_access_type = /datum/role/senior_engineer
	extra_details = list("onegoldstripe")

/obj/item/weapon/card/id/torch/contractor/engineering
	role_access_type = /datum/role/engineer
	detail_color = COLOR_SUN

/obj/item/weapon/card/id/torch/contractor/engineering/roboticist
	role_access_type = /datum/role/roboticist


/obj/item/weapon/card/id/torch/crew/supply/deckofficer
	role_access_type = /datum/role/qm
	detail_color = COLOR_BROWN
	extra_details = list("onegoldstripe")

/obj/item/weapon/card/id/torch/crew/supply
	role_access_type = /datum/role/cargo_tech
	detail_color = COLOR_BROWN

/obj/item/weapon/card/id/torch/contractor/supply
	role_access_type = /datum/role/cargo_tech
	detail_color = COLOR_BROWN

/obj/item/weapon/card/id/torch/crew/service //unused
	role_access_type = /datum/role/assistant
	detail_color = COLOR_CIVIE_GREEN

/obj/item/weapon/card/id/torch/crew/service/janitor
	role_access_type = /datum/role/janitor

/obj/item/weapon/card/id/torch/crew/service/chef
	role_access_type = /datum/role/chef

/obj/item/weapon/card/id/torch/contractor/service //unused
	role_access_type = /datum/role/assistant
	detail_color = COLOR_CIVIE_GREEN

/obj/item/weapon/card/id/torch/contractor/service/bartender
	role_access_type = /datum/role/bartender


/obj/item/weapon/card/id/torch/crew/representative
	role_access_type = /datum/role/representative
	detail_color = COLOR_COMMAND_BLUE

/obj/item/weapon/card/id/torch/crew/sea
	role_access_type = /datum/role/sea
	detail_color = COLOR_COMMAND_BLUE
	extra_details = list("onegoldstripe")

/obj/item/weapon/card/id/torch/crew/bridgeofficer
	role_access_type = /datum/role/bridgeofficer
	detail_color = COLOR_COMMAND_BLUE

/obj/item/weapon/card/id/torch/crew/pathfinder
	role_access_type = /datum/role/pathfinder
	detail_color = COLOR_PURPLE
	extra_details = list("onegoldstripe")

/obj/item/weapon/card/id/torch/crew/explorer
	role_access_type = /datum/role/explorer
	detail_color = COLOR_PURPLE

/obj/item/weapon/card/id/torch/crew/pilot
	role_access_type = /datum/role/nt_pilot
	detail_color = COLOR_PURPLE

// EC Science
/obj/item/weapon/card/id/torch/silver/research
	role_access_type = /datum/role/rd
	detail_color = COLOR_RESEARCH
	color = COLOR_WHITE

/obj/item/weapon/card/id/torch/crew/research
	desc = "A card issued to science personnel aboard the SEV Torch."
	role_access_type = /datum/role/scientist_assistant
	detail_color = COLOR_RESEARCH

/obj/item/weapon/card/id/torch/crew/research/senior_scientist
	role_access_type = /datum/role/senior_scientist
	extra_details = list("onegoldstripe")

/obj/item/weapon/card/id/torch/crew/research/scientist
	role_access_type = /datum/role/scientist

//NanoTrasen and Passengers

/obj/item/weapon/card/id/torch/passenger
	desc = "A card issued to passengers aboard the SEV Torch."
	role_access_type = /datum/role/assistant
	detail_color = COLOR_PAKISTAN_GREEN

/obj/item/weapon/card/id/torch/passenger/research
	desc = "A card issued to corporate personnel aboard the SEV Torch."
	role_access_type = /datum/role/scientist_assistant
	detail_color = COLOR_BOTTLE_GREEN

/obj/item/weapon/card/id/torch/passenger/research/senior_scientist
	role_access_type = /datum/role/senior_scientist
	extra_details = list("onegoldstripe")

/obj/item/weapon/card/id/torch/passenger/research/nt_pilot
	role_access_type = /datum/role/nt_pilot

/obj/item/weapon/card/id/torch/passenger/research/scientist
	role_access_type = /datum/role/scientist

/obj/item/weapon/card/id/torch/passenger/research/mining
	role_access_type = /datum/role/mining

/obj/item/weapon/card/id/torch/passenger/corporate
	color = COLOR_BOTTLE_GREEN
	detail_color = COLOR_OFF_WHITE
	role_access_type = /datum/role/bodyguard

/obj/item/weapon/card/id/torch/passenger/corporate/liaison
	role_access_type = /datum/role/liaison
	extra_details = list("onegoldstripe")

//Merchant
/obj/item/weapon/card/id/torch/merchant
	desc = "An identification card issued to Merchants, indicating their right to sell and buy goods."
	role_access_type = /datum/role/merchant
	color = COLOR_OFF_WHITE
	detail_color = COLOR_BEIGE

//Stowaway
/obj/item/weapon/card/id/torch/stowaway
	desc = "An identification card issued to personnel aboard the SEV Torch. Looks like the photo fell off this one."
	role_access_type = /datum/role/crew
	color = "#b4cbd7"

/obj/item/weapon/card/id/torch/stowaway/New()
	..()
	var/species = SPECIES_HUMAN
	if(prob(10))
		species = pick(SPECIES_SKRELL,SPECIES_IPC)
	var/datum/species/S = all_species[species]
	var/decl/cultural_info/culture/C = SSculture.get_culture(S.default_cultural_info[TAG_CULTURE])
	var/gender = pick(MALE,FEMALE)
	registered_name = C.get_random_name(gender)
	sex = capitalize(gender)
	age = rand(19,25)
	fingerprint_hash = md5(registered_name)
	dna_hash = md5(fingerprint_hash)
	blood_type = RANDOM_BLOOD_TYPE
