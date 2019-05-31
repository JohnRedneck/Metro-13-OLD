//The following is a list of defs to be used for the Torch loadout.

//For roles that allow for decorative or ceremonial clothing
#define FORMAL_ROLES list(/datum/role/liaison, /datum/role/bodyguard, /datum/role/rd, /datum/role/senior_scientist, /datum/role/scientist, /datum/role/scientist_assistant, /datum/role/psychiatrist, /datum/role/representative, /datum/role/assistant, /datum/role/bartender, /datum/role/merchant, /datum/role/stowaway, /datum/role/detective)

//For civilian roles that may have a uniform, but not a strict one
#define SEMIFORMAL_ROLES list(/datum/role/assistant,/datum/role/mining, /datum/role/scientist_assistant, /datum/role/psychiatrist, /datum/role/bartender, /datum/role/merchant, /datum/role/nt_pilot, /datum/role/stowaway, /datum/role/scientist, /datum/role/senior_scientist, /datum/role/detective)

//For civilian roles that may have a strict uniform.
#define SEMIANDFORMAL_ROLES list(/datum/role/assistant,/datum/role/mining, /datum/role/scientist_assistant, /datum/role/psychiatrist, /datum/role/bartender, /datum/role/merchant, /datum/role/nt_pilot, /datum/role/liaison, /datum/role/bodyguard, /datum/role/rd, /datum/role/senior_scientist, /datum/role/scientist, /datum/role/representative,/datum/role/stowaway, /datum/role/detective)

//For roles with no uniform or formal clothing requirements
#define RESTRICTED_ROLES list(/datum/role/assistant, /datum/role/bartender, /datum/role/merchant, /datum/role/stowaway)

//For members of the medical department
#define MEDICAL_ROLES list(/datum/role/cmo, /datum/role/senior_doctor, /datum/role/doctor, /datum/role/psychiatrist, /datum/role/chemist, /datum/role/roboticist, /datum/role/medical_trainee, /datum/role/biomech)

//For members of the medical department, roboticists, and some Research
#define STERILE_ROLES list(/datum/role/cmo, /datum/role/senior_doctor, /datum/role/doctor, /datum/role/chemist, /datum/role/psychiatrist, /datum/role/roboticist, /datum/role/rd, /datum/role/senior_scientist, /datum/role/scientist, /datum/role/scientist_assistant, /datum/role/medical_trainee, /datum/role/biomech)

//For members of the engineering department
#define ENGINEERING_ROLES list(/datum/role/chief_engineer, /datum/role/senior_engineer, /datum/role/engineer, /datum/role/roboticist, /datum/role/engineer_trainee)

//For members of Engineering, Cargo, and Research
#define TECHNICAL_ROLES list(/datum/role/senior_engineer, /datum/role/engineer, /datum/role/roboticist, /datum/role/qm, /datum/role/cargo_tech, /datum/role/mining, /datum/role/scientist_assistant, /datum/role/merchant, /datum/role/rd, /datum/role/senior_scientist, /datum/role/scientist, /datum/role/chief_engineer, /datum/role/janitor, /datum/role/engineer_trainee, /datum/role/biomech)

//For members of the security department
#define SECURITY_ROLES list(/datum/role/hos, /datum/role/warden, /datum/role/detective, /datum/role/officer)

//For members of the supply department
#define SUPPLY_ROLES list(/datum/role/qm, /datum/role/cargo_tech)

//For members of the service department
#define SERVICE_ROLES list(/datum/role/janitor, /datum/role/chef, /datum/role/crew, /datum/role/bartender)

//For members of the research department and roles that are scientific
#define RESEARCH_ROLES list(/datum/role/rd, /datum/role/scientist, /datum/role/mining, /datum/role/scientist_assistant, /datum/role/assistant, /datum/role/nt_pilot, /datum/role/senior_scientist, /datum/role/roboticist, /datum/role/biomech)

//For roles that spawn with weapons in their lockers
#define ARMED_ROLES list(/datum/role/captain, /datum/role/hop, /datum/role/hos, /datum/role/sea, /datum/role/officer, /datum/role/warden, /datum/role/detective, /datum/role/merchant, /datum/role/bodyguard)

//For roles that spawn with armor in their lockers
#define ARMORED_ROLES list(/datum/role/captain, /datum/role/hop, /datum/role/rd, /datum/role/cmo, /datum/role/chief_engineer, /datum/role/hos, /datum/role/qm, /datum/role/sea, /datum/role/bridgeofficer, /datum/role/officer, /datum/role/warden, /datum/role/detective, /datum/role/merchant, /datum/role/bodyguard)

#define UNIFORMED_BRANCHES list(/datum/mil_branch/expeditionary_corps, /datum/mil_branch/fleet)

#define CIVILIAN_BRANCHES list(/datum/mil_branch/civilian, /datum/mil_branch/solgov)

#define SOLGOV_BRANCHES list(/datum/mil_branch/expeditionary_corps, /datum/mil_branch/fleet, /datum/mil_branch/solgov)
