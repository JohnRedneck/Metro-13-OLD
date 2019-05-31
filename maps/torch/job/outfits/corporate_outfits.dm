/decl/hierarchy/outfit/role/torch/passenger/research
	hierarchy_type = /decl/hierarchy/outfit/role/torch/passenger/research
	l_ear = /obj/item/device/radio/headset/torchnanotrasen

/decl/hierarchy/outfit/role/torch/passenger/research/nt_pilot //pending better uniform
	name = OUTFIT_ROLE_NAME("Corporate Pilot")
	uniform = /obj/item/clothing/under/rank/ntpilot
	suit = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	shoes = /obj/item/clothing/shoes/workboots
	l_ear = /obj/item/device/radio/headset/headset_pilot
	id_type = /obj/item/weapon/card/id/torch/passenger/research/nt_pilot

/decl/hierarchy/outfit/role/torch/passenger/research/scientist
	name = OUTFIT_ROLE_NAME("Scientist - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_type = /obj/item/weapon/card/id/torch/passenger/research/scientist

/decl/hierarchy/outfit/role/torch/passenger/research/scientist/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/decl/hierarchy/outfit/role/torch/passenger/research/scientist/psych
	name = OUTFIT_ROLE_NAME("Psychologist - Torch")
	uniform = /obj/item/clothing/under/rank/psych

/decl/hierarchy/outfit/role/torch/passenger/research/assist
	name = OUTFIT_ROLE_NAME("Research Assistant - Torch")
	uniform = /obj/item/clothing/under/rank/scientist
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/science
	id_type = /obj/item/weapon/card/id/torch/passenger/research

/decl/hierarchy/outfit/role/torch/passenger/research/assist/testsubject
	name = OUTFIT_ROLE_NAME("Testing Assistant")
	uniform = /obj/item/clothing/under/rank/ntwork