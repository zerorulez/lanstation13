/*Typing indicators, when a mob uses the F3/F4 keys to bring the say/emote input boxes up this little buddy is
made and follows them around until they are done (or something bad happens), helps tell nearby people that 'hey!
I IS TYPIN'!'
*/

/atom/proc/set_invisibility(var/new_invisibility = 0)
	var/old_invisibility = invisibility
	if(old_invisibility != new_invisibility)
		invisibility = new_invisibility

/atom/movable/overlay/typing_indicator
	icon = 'icons/mob/talk.dmi'
	icon_state = "typing"
	mouse_opacity	= 0
	plane = MOB_PLANE
	layer = 6

/atom/movable/overlay/typing_indicator/New()
	. = ..()
	if(!istype(master, /mob))
		return

/mob/proc/create_typing_indicator()
	if(client && !stat && isturf(src.loc))
		if(!typing_indicator)
			typing_indicator = new(src)
			typing_indicator.master = src
			lock_atom(typing_indicator, /datum/locking_category)
		typing_indicator.forceMove(get_turf(src))
		typing_indicator.set_invisibility(0)

/mob/proc/remove_typing_indicator() // A bit excessive, but goes with the creation of the indicator I suppose
	if(typing_indicator)
		typing_indicator.set_invisibility(INVISIBILITY_MAXIMUM)

/mob/Logout()
	remove_typing_indicator()
	. = ..()

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","say (text)") as text
	remove_typing_indicator()
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	create_typing_indicator()
	var/message = input("","me (text)") as text
	remove_typing_indicator()
	if(message)
		me_verb(message)
