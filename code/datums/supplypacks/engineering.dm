/decl/hierarchy/supply_pack/engineering
	name = "Engineering"

/decl/hierarchy/supply_pack/engineering/smes_circuit
	name = "Electronics - Superconducting magnetic energy storage unit circuitry"
	contains = list(/obj/item/weapon/circuitboard/smes)
	cost = 20
	containername = "superconducting magnetic energy storage unit circuitry crate"

/decl/hierarchy/supply_pack/engineering/smescoil
	name = "Parts - Superconductive magnetic coil"
	contains = list(/obj/item/weapon/smes_coil)
	cost = 35
	containername = "superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_weak
	name = "Parts - Basic superconductive magnetic coil"
	contains = list(/obj/item/weapon/smes_coil/weak)
	cost = 25
	containername = "basic superconductive magnetic coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_capacity
	name = "Parts - Superconductive capacitance coil"
	contains = list(/obj/item/weapon/smes_coil/super_capacity)
	cost = 45
	containername = "superconductive capacitance coil crate"

/decl/hierarchy/supply_pack/engineering/smescoil_super_io
	name = "Parts- Superconductive Transmission Coil"
	contains = list(/obj/item/weapon/smes_coil/super_io)
	cost = 45
	containername = "Superconductive Transmission Coil crate"

/decl/hierarchy/supply_pack/engineering/electrical
	name = "Gear - Electrical maintenance"
	contains = list(/obj/item/weapon/storage/toolbox/electrical = 2,
					/obj/item/clothing/gloves/insulated = 2,
					/obj/item/weapon/cell = 2,
					/obj/item/weapon/cell/high = 2)
	cost = 15
	containername = "electrical maintenance crate"

/decl/hierarchy/supply_pack/engineering/mechanical
	name = "Gear - Mechanical maintenance"
	contains = list(/obj/item/weapon/storage/belt/utility/full = 3,
					/obj/item/clothing/suit/storage/hazardvest = 3,
					/obj/item/clothing/head/welding = 2,
					/obj/item/clothing/head/hardhat)
	cost = 10
	containername = "mechanical maintenance crate"

/decl/hierarchy/supply_pack/engineering/solar
	name = "Power - Solar pack"
	contains  = list(/obj/item/solar_assembly = 14,
					/obj/item/weapon/circuitboard/solar_control,
					/obj/item/weapon/tracker_electronics,
					/obj/item/weapon/paper/solar
					)
	cost = 15
	containername = "solar pack crate"

/decl/hierarchy/supply_pack/engineering/solar_assembly
	name = "Power - Solar assembly"
	contains  = list(/obj/item/solar_assembly = 16)
	cost = 10
	containername = "solar assembly crate"
/*
/decl/hierarchy/supply_pack/engineering/collector
	name = "Power - Collector"
	contains = list(/obj/machinery/power/rad_collector = 2)
	cost = 8
	containertype = /obj/structure/closet/crate/secure/large
	containername = "collector crate"
	access = null
*/
/decl/hierarchy/supply_pack/engineering/pacman_parts
	name = "Power - P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/matter_bin,
					/obj/item/weapon/circuitboard/pacman)
	cost = 45
	containername = "\improper P.A.C.M.A.N. Portable Generator Construction Kit"
	containertype = /obj/structure/closet/crate/secure
	access = null

/decl/hierarchy/supply_pack/engineering/super_pacman_parts
	name = "Power - Super P.A.C.M.A.N. portable generator parts"
	contains = list(/obj/item/weapon/stock_parts/micro_laser,
					/obj/item/weapon/stock_parts/capacitor,
					/obj/item/weapon/stock_parts/matter_bin,
					/obj/item/weapon/circuitboard/pacman/super)
	cost = 55
	containername = "\improper Super P.A.C.M.A.N. portable generator construction kit"
	containertype = /obj/structure/closet/crate/secure
	access = null

/decl/hierarchy/supply_pack/engineering/teg
	name = "Power - Mark I Thermoelectric Generator"
	contains = list(/obj/machinery/power/generator)
	cost = 75
	containertype = /obj/structure/closet/crate/secure/large
	containername = "\improper Mk1 TEG crate"
	access = null

/decl/hierarchy/supply_pack/engineering/circulator
	name = "Equipment - Binary atmospheric circulator"
	contains = list(/obj/machinery/atmospherics/binary/circulator)
	cost = 60
	containertype = /obj/structure/closet/crate/secure/large
	containername = "atmospheric circulator crate"
	access = null

/decl/hierarchy/supply_pack/engineering/air_dispenser
	name = "Equipment - Pipe Dispenser"
	contains = list(/obj/machinery/pipedispenser/orderable)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "pipe dispenser crate"
	access = null

/decl/hierarchy/supply_pack/engineering/disposals_dispenser
	name = "Equipment - Disposals pipe dispenser"
	contains = list(/obj/machinery/pipedispenser/disposal/orderable)
	cost = 35
	containertype = /obj/structure/closet/crate/secure/large
	containername = "disposal dispenser crate"
	access = null

/decl/hierarchy/supply_pack/engineering/fueltank
	name = "Liquid - Fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"

/decl/hierarchy/supply_pack/engineering/robotics
	name = "Parts - Robotics assembly"
	contains = list(/obj/item/device/assembly/prox_sensor = 3,
					/obj/item/weapon/storage/toolbox/electrical,
					/obj/item/device/flash = 4,
					/obj/item/weapon/cell/high = 2)
	cost = 10
	containertype = /obj/structure/closet/crate/secure/gear
	containername = "robotics assembly crate"
	access = null

/decl/hierarchy/supply_pack/engineering/radsuit
	name = "Gear - Radiation protection gear"
	contains = list(/obj/item/clothing/suit/radiation = 6,
			/obj/item/clothing/head/radiation = 6)
	cost = 20
	containertype = /obj/structure/closet/radiation
	containername = "radiation suit locker"

/decl/hierarchy/supply_pack/engineering/firefighter
	name = "Gear - Firefighting equipment"
	contains = list(/obj/item/clothing/suit/fire/firefighter,
			/obj/item/clothing/mask/gas,
			/obj/item/weapon/tank/oxygen/red,
			/obj/item/weapon/extinguisher,
			/obj/item/clothing/head/hardhat/red)
	cost = 20
	containertype = /obj/structure/closet/firecloset
	containername = "fire-safety closet"
