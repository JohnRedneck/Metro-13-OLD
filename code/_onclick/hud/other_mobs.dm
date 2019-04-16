/mob/living/carbon/slime
	hud_type = /datum/hud/slime

/datum/hud/slime/FinalizeInstantiation(ui_style = 'icons/mob/screen1_Midnight.dmi')
	src.adding = list()

	var/obj/screen/using

	using = new /obj/screen/intent()
	src.adding += using
	action_intent = using

	mymob.client.screen = list()
	mymob.client.screen += src.adding

	mymob.client.screen = list()
	mymob.client.screen += list(mymob.fire, mymob.healths, mymob.pullin, mymob.zone_sel, mymob.purged)
