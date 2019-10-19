/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	if(length(newplayer_start))
		loc = pick(newplayer_start)
	else
		loc = locate(1,1,1)

	change_sight(adding = SEE_TURFS)
	player_list |= src

/*
	var/list/watch_locations = list()
	for(var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.tag == "landmark*new_player")
			watch_locations += landmark.loc

	if(watch_locations.len>0)
		loc = pick(watch_locations)
*/
	new_player_panel()
	if(ckey in deadmins)
		client.verbs += /client/proc/readmin
	spawn(0)
		if(client)
			//If the changelog has changed, show it to them
		/*	if(client.prefs.lastchangelog != changelog_hash)
				// Need to send them the CSS and images :V
				client.getFiles(
					'html/postcardsmall.jpg',
					'html/somerights20.png',
					'html/88x31.png',
					'html/bug-minus.png',
					'html/cross-circle.png',
					'html/hard-hat-exclamation.png',
					'html/image-minus.png',
					'html/image-plus.png',
					'html/music-minus.png',
					'html/music-plus.png',
					'html/tick-circle.png',
					'html/wrench-screwdriver.png',
					'html/spell-check.png',
					'html/burn-exclamation.png',
					'html/chevron.png',
					'html/chevron-expand.png',
					'html/changelog.css',
					'html/changelog.js',
					'html/changelog.html'
					)
				src << browse('html/changelog.html', "window=changes;size=675x650")
				client.prefs.lastchangelog = changelog_hash
				client.prefs.save_preferences()
				winset(client, "rpane.changelog", "background-color=none;font-style=;")
*/
			if(!client.prefs.viu_regras)
				client.rules()

			if(!client.check_whitelist())
				var/n = 0
				for (var/mob/M in player_list)
					if (M.client)
						n++
				to_chat(src, "<b>Sua conta não está na brancolista.</b>")
				if(n > 16)
					to_chat(src, "<b>Como sua conta não está na brancolista e o servidor tem 17 ou mais jogadores online, você foi desconectado.</b>")
					Logout()
					return
			else
				to_chat(src, "<b>Sua conta está na brancolista.</b>")

			client.playtitlemusic()



/client/proc/check_whitelist()
	if(ckey in global.ckey_whitelist)
		return TRUE
	return FALSE