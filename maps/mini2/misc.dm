// Override global variables here!

// Enable all headsets by default in MiniStation, we don't worry about spam here.
// Also both heads are in charge of everything, give them all department channels.

/obj/item/device/encryptionkey/heads/New()
	..()
	// Give all channels and turn everything on
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1)


// Blue medbay cross, icon taken from NTstation - LanStation

/obj/structure/sign/bluecross_2
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon = 'maps/mini2/icons/decals.dmi'
	icon_state = "bluecross"

// Medbay airlocks are now blue, icons taken from NTstation - LanStation

/obj/machinery/door/airlock/medical
	name = "Airlock"
	icon = 'maps/mini2/icons/doormed.dmi'
	assembly_type = /obj/structure/door_assembly/door_assembly_med


/obj/machinery/door/airlock/glass_medical
	name = "Maintenance Hatch"
	icon = 'maps/mini2/icons/doormedglass.dmi'
	opacity = 0
	assembly_type = /obj/structure/door_assembly/door_assembly_med
	glass = 1