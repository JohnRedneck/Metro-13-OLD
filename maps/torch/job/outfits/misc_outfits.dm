/decl/hierarchy/outfit/role/torch/passenger/passenger
	name = OUTFIT_ROLE_NAME("Passenger - Torch")
	uniform = /obj/item/clothing/under/color/grey
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda
	id_type = /obj/item/weapon/card/id/torch/passenger

/decl/hierarchy/outfit/role/torch/passenger/passenger/journalist
	name = OUTFIT_ROLE_NAME("Journalist - Torch")
	backpack_contents = list(/obj/item/device/camera/tvcamera = 1,
	/obj/item/clothing/accessory/badge/press = 1)

/decl/hierarchy/outfit/role/torch/passenger/passenger/investor
	name = OUTFIT_ROLE_NAME("Investor - Torch")

/decl/hierarchy/outfit/role/torch/passenger/passenger/investor/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/storage/secure/briefcase/money/case = new(H.loc)
	H.put_in_hands(case)

/decl/hierarchy/outfit/role/torch/merchant
	name = OUTFIT_ROLE_NAME("Merchant - Torch")
	uniform = /obj/item/clothing/under/color/black
	l_ear = null
	shoes = /obj/item/clothing/shoes/black
	pda_type = /obj/item/modular_computer/pda
	id_type = /obj/item/weapon/card/id/torch/merchant

/decl/hierarchy/outfit/role/torch/stowaway
	name = OUTFIT_ROLE_NAME("Stowaway - Torch")
	id_type = null
	pda_type = null
	l_ear = null
	l_pocket = /obj/item/weapon/wrench
	r_pocket = /obj/item/weapon/crowbar

/decl/hierarchy/outfit/role/torch/stowaway/post_equip(var/mob/living/carbon/human/H)
	..()
	var/obj/item/weapon/card/id/torch/stowaway/ID = new(H.loc)
	H.put_in_hands(ID)

/decl/hierarchy/outfit/role/torch/ert
	name = OUTFIT_ROLE_NAME("ERT - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat
	head = /obj/item/clothing/head/beret/solgov/fleet
	gloves = /obj/item/clothing/gloves/thick
	id_type = /obj/item/weapon/card/id/centcom/ERT
	pda_type = /obj/item/modular_computer/pda/ert
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/dutyboots

/decl/hierarchy/outfit/role/torch/ert/leader
	name = OUTFIT_ROLE_NAME("ERT Leader - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/fleet/combat/command
	head = /obj/item/clothing/head/beret/solgov/fleet/command