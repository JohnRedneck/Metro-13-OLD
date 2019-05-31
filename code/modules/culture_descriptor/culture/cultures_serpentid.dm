// See specific map role files for valid roles. They use types so cannot be compiled at this level.
/decl/cultural_info/culture/nabber
	name = CULTURE_NABBER_CMINUS
	language = LANGUAGE_NABBER
	name_language = LANGUAGE_NABBER
	additional_langs = list(LANGUAGE_GALCOM)
	description = "You have been trained to Xynergy Grade PLACEHOLDER."
	var/list/valid_roles = list()
	var/list/hidden_valid_roles = list(/datum/role/ai, /datum/role/cyborg)
	var/title_suffix

/decl/cultural_info/culture/nabber/get_formal_name_suffix()
	return title_suffix

/decl/cultural_info/culture/nabber/New()
	..()

	// Make sure this will show up in the manifest and on IDs.
	title_suffix = " ([name])"

	// Update our desc based on available roles for this rank.
	var/list/role_titles = list()
	for(var/roletype in valid_roles)
		var/datum/role/role = roletype
		LAZYADD(role_titles, initial(role.title))
	if(!LAZYLEN(role_titles))
		LAZYADD(role_titles, "none")
	description = "You have been trained by Xynergy to [name]. This makes you suitable for the following roles: [english_list(role_titles)]."

	// Set up our qualifications.
	LAZYADD(qualifications, "<b>[name]</b>")
	for(var/role in role_titles)
		LAZYADD(qualifications, "Safe for [role].")

	// Add our hidden roles since we're done building the desc.
	if(LAZYLEN(hidden_valid_roles))
		LAZYADD(valid_roles, hidden_valid_roles)

/decl/cultural_info/culture/nabber/c
	name = CULTURE_NABBER_C
	valid_roles = list(/datum/role/janitor)

/decl/cultural_info/culture/nabber/c/plus
	name = CULTURE_NABBER_CPLUS

/decl/cultural_info/culture/nabber/b
	name = CULTURE_NABBER_B
	valid_roles = list(/datum/role/bartender, /datum/role/chef)

/decl/cultural_info/culture/nabber/b/minus
	name = CULTURE_NABBER_BMINUS

/decl/cultural_info/culture/nabber/b/plus
	name = CULTURE_NABBER_BPLUS

/decl/cultural_info/culture/nabber/a
	name = CULTURE_NABBER_A
	valid_roles = list(/datum/role/chemist, /datum/role/roboticist)

/decl/cultural_info/culture/nabber/a/minus
	name = CULTURE_NABBER_AMINUS

/decl/cultural_info/culture/nabber/a/plus
	name = CULTURE_NABBER_APLUS
