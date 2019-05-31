//army outfits
/decl/hierarchy/outfit/role/torch/army
	name = OUTFIT_ROLE_NAME("SCGA Soldier - Torch")
	uniform = /obj/item/clothing/under/solgov/utility/army
	head = /obj/item/clothing/head/solgov/utility/army
	back = /obj/item/weapon/storage/backpack/rucksack/green
	shoes = /obj/item/clothing/shoes/jungleboots

/decl/hierarchy/outfit/role/torch/armyservice
	name = OUTFIT_ROLE_NAME("SCGA Service - Torch")
	uniform = /obj/item/clothing/under/solgov/service/army
	head = /obj/item/clothing/head/solgov/service/army
	suit = /obj/item/clothing/suit/storage/solgov/service/army
	back = null
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/role/torch/armyservice/skirt
	name = OUTFIT_ROLE_NAME("SCGA Service - Skirt")
	uniform = /obj/item/clothing/under/solgov/service/army/skirt

/decl/hierarchy/outfit/role/torch/armyservice/officer
	name = OUTFIT_ROLE_NAME("SCGA Service - Officer")
	uniform = /obj/item/clothing/under/solgov/service/army/command
	head = /obj/item/clothing/head/solgov/service/army/command
	suit = /obj/item/clothing/suit/storage/solgov/service/army/command

/decl/hierarchy/outfit/role/torch/armyservice/officer/skirt
	name = OUTFIT_ROLE_NAME("SCGA Service - Officer Skirt")
	uniform = /obj/item/clothing/under/solgov/service/army/command/skirt

/decl/hierarchy/outfit/role/torch/armydress
	name = OUTFIT_ROLE_NAME("SCGA Dress - Torch")
	uniform = /obj/item/clothing/under/solgov/mildress/army
	head = /obj/item/clothing/head/solgov/dress/army
	suit = /obj/item/clothing/suit/dress/solgov/army
	back = null
	shoes = /obj/item/clothing/shoes/dress

/decl/hierarchy/outfit/role/torch/armydress/skirt
	name = OUTFIT_ROLE_NAME("SCGA Dress - Skirt")
	uniform = /obj/item/clothing/under/solgov/mildress/army/skirt

/decl/hierarchy/outfit/role/torch/armydress/officer
	name = OUTFIT_ROLE_NAME("SCGA Dress - Officer")
	uniform = /obj/item/clothing/under/solgov/mildress/army/command
	head = /obj/item/clothing/head/solgov/dress/army/command
	suit = /obj/item/clothing/suit/dress/solgov/army/command

/decl/hierarchy/outfit/role/torch/armydress/officer/skirt
	name = OUTFIT_ROLE_NAME("SCGA Dress - Officer Skirt")
	uniform = /obj/item/clothing/under/solgov/mildress/army/command/skirt

//other army outfits
/decl/hierarchy/outfit/role/terran/crew
	name = OUTFIT_ROLE_NAME("Independent Navy - Utility")
	hierarchy_type = /decl/hierarchy/outfit/role/terran/crew
	uniform = /obj/item/clothing/under/terran/navy/utility
	l_ear = /obj/item/device/radio/headset
	shoes = /obj/item/clothing/shoes/terran
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store

/decl/hierarchy/outfit/role/terran/crew/service
	name = OUTFIT_ROLE_NAME("Independent Navy - Service")
	head = /obj/item/clothing/head/terran/navy/service
	uniform = /obj/item/clothing/under/terran/navy/service
	suit = /obj/item/clothing/suit/storage/terran/service/navy
	shoes = /obj/item/clothing/shoes/terran/service
	gloves = /obj/item/clothing/gloves/terran

/decl/hierarchy/outfit/role/terran/crew/service/command
	name = OUTFIT_ROLE_NAME("Independent Navy - Service Command")
	head = /obj/item/clothing/head/terran/navy/service/command
	uniform = /obj/item/clothing/under/terran/navy/service/command
	suit = /obj/item/clothing/suit/storage/terran/service/navy/command

/decl/hierarchy/outfit/role/terran/crew/dress
	name = OUTFIT_ROLE_NAME("Independent Navy - Dress")
	head = /obj/item/clothing/head/terran/navy/service
	uniform = /obj/item/clothing/under/terran/navy/service
	suit = /obj/item/clothing/suit/dress/terran/navy
	shoes = /obj/item/clothing/shoes/terran/service
	gloves = /obj/item/clothing/gloves/terran

/decl/hierarchy/outfit/role/terran/crew/dress/officer
	name = OUTFIT_ROLE_NAME("Independent Navy - Officer")
	uniform = /obj/item/clothing/under/terran/navy/service
	suit = /obj/item/clothing/suit/dress/terran/navy/officer

/decl/hierarchy/outfit/role/terran/crew/dress/command
	name = OUTFIT_ROLE_NAME("Independent Navy - Dress Command")
	head = /obj/item/clothing/head/terran/navy/service/command
	uniform = /obj/item/clothing/under/terran/navy/service/command
	suit = /obj/item/clothing/suit/dress/terran/navy/command