/mob/dead/observer/Login()
	..()

/mob/dead/observer/MouseDrop(atom/over)
	if(!usr || !over)
		return

	if (isobserver(usr) && usr.client.holder && isliving(over))
		if (usr.client.holder.cmd_ghost_drag(src,over))
			return

	return ..()
