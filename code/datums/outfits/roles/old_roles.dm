/decl/hierarchy/outfit/role/assistant
    name = OUTFIT_ROLE_NAME("Assistant")

/decl/hierarchy/outfit/role/service
    l_ear = /obj/item/device/radio/headset/headset_service
    hierarchy_type = /decl/hierarchy/outfit/role/service

/decl/hierarchy/outfit/role/service/bartender
    name = OUTFIT_ROLE_NAME("Bartender")
    uniform = /obj/item/clothing/under/rank/bartender

/decl/hierarchy/outfit/role/service/chef
    name = OUTFIT_ROLE_NAME("Chef")
    uniform = /obj/item/clothing/under/rank/chef
    suit = /obj/item/clothing/suit/chef
    head = /obj/item/clothing/head/chefhat

/decl/hierarchy/outfit/role/service/gardener
    name = OUTFIT_ROLE_NAME("Gardener")
    uniform = /obj/item/clothing/under/rank/hydroponics
    suit = /obj/item/clothing/suit/apron
    gloves = /obj/item/clothing/gloves/thick/botany
    r_pocket = /obj/item/device/analyzer/plant_analyzer

/decl/hierarchy/outfit/role/service/gardener/New()
    ..()
    backpack_overrides[/decl/backpack_outfit/backpack]      = /obj/item/weapon/storage/backpack/hydroponics
    backpack_overrides[/decl/backpack_outfit/satchel]       = /obj/item/weapon/storage/backpack/satchel/hyd
    backpack_overrides[/decl/backpack_outfit/messenger_bag] = /obj/item/weapon/storage/backpack/messenger/hyd

/decl/hierarchy/outfit/role/service/janitor
    name = OUTFIT_ROLE_NAME("Janitor")
    uniform = /obj/item/clothing/under/rank/janitor

/decl/hierarchy/outfit/role/librarian
    name = OUTFIT_ROLE_NAME("Librarian")
    uniform = /obj/item/clothing/under/suit_jacket/red
    id_type = /obj/item/weapon/card/id/civilian/librarian
    pda_type = /obj/item/modular_computer/pda

/decl/hierarchy/outfit/role/internal_affairs_agent
    name = OUTFIT_ROLE_NAME("Internal affairs agent")
    l_ear = /obj/item/device/radio/headset/ia
    uniform = /obj/item/clothing/under/rank/internalaffairs
    suit = /obj/item/clothing/suit/storage/toggle/suit/black
    shoes = /obj/item/clothing/shoes/brown
    glasses = /obj/item/clothing/glasses/sunglasses/big
    l_hand = /obj/item/weapon/storage/briefcase

/decl/hierarchy/outfit/role/chaplain
    name = OUTFIT_ROLE_NAME("Chaplain")
    uniform = /obj/item/clothing/under/rank/chaplain
    l_hand = /obj/item/weapon/storage/bible

/decl/hierarchy/outfit/role/medical
    hierarchy_type = /decl/hierarchy/outfit/role/medical
    l_ear = /obj/item/device/radio/headset/headset_med
    shoes = /obj/item/clothing/shoes/white

/decl/hierarchy/outfit/role/medical/doctor
    name = OUTFIT_ROLE_NAME("Medical Doctor")
    uniform = /obj/item/clothing/under/rank/medical
    suit = /obj/item/clothing/suit/storage/toggle/labcoat
    l_hand = /obj/item/weapon/storage/firstaid/adv
    r_pocket = /obj/item/device/flashlight/pen
    id_type = /obj/item/weapon/card/id/medical

/decl/hierarchy/outfit/role/medical/doctor/nurse
    name = OUTFIT_ROLE_NAME("Nurse")
    suit = null

/decl/hierarchy/outfit/role/medical/paramedic
    name = OUTFIT_ROLE_NAME("Paramedic")
    uniform = /obj/item/clothing/under/rank/medical/scrubs/black
    suit = /obj/item/clothing/suit/storage/toggle/fr_jacket
    shoes = /obj/item/clothing/shoes/jackboots
    l_hand = /obj/item/weapon/storage/firstaid/adv
    belt = /obj/item/weapon/storage/belt/medical/emt
    flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/role/science
    hierarchy_type = /decl/hierarchy/outfit/role/science
    l_ear = /obj/item/device/radio/headset/headset_sci
    suit = /obj/item/clothing/suit/storage/toggle/labcoat
    shoes = /obj/item/clothing/shoes/white

/decl/hierarchy/outfit/role/science/scientist
    name = OUTFIT_ROLE_NAME("Scientist")
    uniform = /obj/item/clothing/under/rank/scientist
    suit = /obj/item/clothing/suit/storage/toggle/labcoat/science

/decl/hierarchy/outfit/role/engineering
    hierarchy_type = /decl/hierarchy/outfit/role/engineering
    belt = /obj/item/weapon/storage/belt/utility/full
    l_ear = /obj/item/device/radio/headset/headset_eng
    shoes = /obj/item/clothing/shoes/workboots
    flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/role/engineering/engineer
    name = OUTFIT_ROLE_NAME("Engineer")
    head = /obj/item/clothing/head/hardhat
    uniform = /obj/item/clothing/under/rank/engineer
    r_pocket = /obj/item/device/t_scanner

/decl/hierarchy/outfit/role/cargo
    l_ear = /obj/item/device/radio/headset/headset_cargo
    hierarchy_type = /decl/hierarchy/outfit/role/cargo

/decl/hierarchy/outfit/role/cargo/mining
    name = OUTFIT_ROLE_NAME("Shaft miner")
    uniform = /obj/item/clothing/under/rank/miner
    backpack_contents = list(/obj/item/weapon/crowbar = 1, /obj/item/weapon/storage/ore = 1)
    flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/pirate
    hierarchy_type = /decl/hierarchy/outfit/pirate
    name = "Pirate"
    uniform = /obj/item/clothing/under/pirate
    shoes = /obj/item/clothing/shoes/jackboots
    glasses = /obj/item/clothing/glasses/eyepatch
    l_hand = /obj/item/weapon/melee/energy/sword/pirate

/decl/hierarchy/outfit/pirate/norm
    name = "Pirate - Normal"
    head = /obj/item/clothing/mask/bandana/red