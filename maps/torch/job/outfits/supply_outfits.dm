/decl/hierarchy/outfit/role/torch/crew/supply
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/role/torch/crew/supply

/decl/hierarchy/outfit/role/torch/crew/supply/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/role/torch/crew/supply/deckofficer
	name = OUTFIT_ROLE_NAME("Deck Chief")
	l_ear = /obj/item/device/radio/headset/headset_deckofficer
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/supply/deckofficer
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/role/torch/crew/supply/deckofficer/fleet
	name = OUTFIT_ROLE_NAME("Deck Chief - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/role/torch/crew/supply/tech
	name = OUTFIT_ROLE_NAME("Deck Technician")
	uniform = /obj/item/clothing/under/solgov/utility/expeditionary/supply
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/torch/crew/supply
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/role/torch/crew/supply/tech/fleet
	name = OUTFIT_ROLE_NAME("Deck Technician - Fleet")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/supply
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/role/torch/crew/supply/contractor
	name = OUTFIT_ROLE_NAME("Supply Assistant")
	uniform = /obj/item/clothing/under/rank/cargotech
	shoes = /obj/item/clothing/shoes/brown
	id_type = /obj/item/weapon/card/id/torch/contractor/supply
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/role/torch/passenger/research/prospector
	name = OUTFIT_ROLE_NAME("Prospector")
	uniform = /obj/item/clothing/under/rank/ntwork
	shoes = /obj/item/clothing/shoes/workboots
	id_type = /obj/item/weapon/card/id/torch/passenger/research/mining
	pda_type = /obj/item/modular_computer/pda/mining
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL
	l_ear = /obj/item/device/radio/headset/headset_mining

/decl/hierarchy/outfit/role/torch/passenger/research/prospector/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING