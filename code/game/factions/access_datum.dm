/datum/access
	var/id = ""
	var/desc = ""
	var/region = ACCESS_REGION_NONE
	var/access_type = ACCESS_TYPE_STATION

/datum/access/dd_SortValue()
	return "[access_type][desc]"

/*****************
* Station access *
*****************/
/var/const/access_D6 = "ACCESS_D6" //1
/datum/access/D6
	id = access_D6
	desc = "Base D6"
	region = ACCESS_REGION_D6
