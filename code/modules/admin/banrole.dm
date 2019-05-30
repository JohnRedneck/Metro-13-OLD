//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

var/roleban_runonce			// Updates legacy bans with new info
var/roleban_keylist[0]		//to store the keys & ranks

/proc/roleban_fullban(mob/M, rank, reason)
	if (!M || !M.key) return
	roleban_keylist.Add(text("[M.ckey] - [rank] ## [reason]"))
	roleban_savebanfile()

/proc/roleban_client_fullban(ckey, rank)
	if (!ckey || !rank) return
	roleban_keylist.Add(text("[ckey] - [rank]"))
	roleban_savebanfile()

//returns a reason if M is banned from rank, returns 0 otherwise
/proc/roleban_isbanned(mob/M, rank)
	if(M && rank)
		if (SSroles.guest_rolebans(rank))
			if(config.guest_roleban && IsGuestKey(M.key))
				return "Guest Role-ban"
			if(config.usewhitelist && !check_whitelist(M))
				return "Whitelisted Role"
		return ckey_is_rolebanned(M.ckey, rank)
	return 0

/proc/ckey_is_rolebanned(var/check_key, var/rank)
	for(var/s in roleban_keylist)
		if(findtext(s,"[check_key] - [rank]") == 1 )
			var/startpos = findtext(s, "## ")+3
			if(startpos && startpos<length(s))
				var/text = copytext(s, startpos, 0)
				if(text)
					return text
			return "Reason Unspecified"
	return 0

/hook/startup/proc/loadRoleBans()
	roleban_loadbanfile()
	return 1

/proc/roleban_loadbanfile()
	if(config.ban_legacy_system)
		var/savefile/S=new("data/role_full.ban")
		S["keys[0]"] >> roleban_keylist
		log_admin("Loading roleban_rank")
		S["runonce"] >> roleban_runonce

		if (!length(roleban_keylist))
			roleban_keylist=list()
			log_admin("roleban_keylist was empty")
	else
		if(!establish_db_connection())
			error("Database connection failed. Reverting to the legacy ban system.")
			log_misc("Database connection failed. Reverting to the legacy ban system.")
			config.ban_legacy_system = 1
			roleban_loadbanfile()
			return

		//Role permabans
		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, role FROM erro_ban WHERE bantype = 'ROLE_PERMABAN' AND isnull(unbanned)")
		query.Execute()

		while(query.NextRow())
			var/ckey = query.item[1]
			var/role = query.item[2]

			roleban_keylist.Add("[ckey] - [role]")

		//Role tempbans
		var/DBQuery/query1 = dbcon.NewQuery("SELECT ckey, role FROM erro_ban WHERE bantype = 'ROLE_TEMPBAN' AND isnull(unbanned) AND expiration_time > Now()")
		query1.Execute()

		while(query1.NextRow())
			var/ckey = query1.item[1]
			var/role = query1.item[2]

			roleban_keylist.Add("[ckey] - [role]")

/proc/roleban_savebanfile()
	var/savefile/S=new("data/role_full.ban")
	S["keys[0]"] << roleban_keylist

/proc/roleban_unban(mob/M, rank)
	roleban_remove("[M.ckey] - [rank]")
	roleban_savebanfile()


/proc/ban_unban_log_save(var/formatted_log)
	text2file(formatted_log,"data/ban_unban_log.txt")


/proc/roleban_remove(X)
	for (var/i = 1; i <= length(roleban_keylist); i++)
		if( findtext(roleban_keylist[i], "[X]") )
			roleban_keylist.Remove(roleban_keylist[i])
			roleban_savebanfile()
			return 1
	return 0
