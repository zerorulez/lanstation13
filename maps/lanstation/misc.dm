// Override global variables here!

// Enable all headsets by default in MiniStation/LanStation, we don't worry about spam here.
// Also both heads are in charge of everything, give them all department channels.

/obj/item/device/encryptionkey/heads/New()
	..()
	// Give all channels and turn everything on
	channels = list("Command" = 1, "Security" = 1, "Engineering" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1)