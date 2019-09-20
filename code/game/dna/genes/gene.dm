/**
* Gene Datum
*
* domutcheck was getting pretty hairy.  This is the solution.
*
* All genes are stored in a global variable to cut down on memory
* usage.
*
* @author N3X15 <nexisentertainment@gmail.com>
*/

/datum/dna/gene
	// Display name
	var/name="BASE GENE"

	// Probably won't get used but why the fuck not
	var/desc="Oh god who knows what this does."

	// Set in initialize()!
	//  What gene activates this?
	var/block=0

	// Any of a number of GENE_ flags.
	var/flags=0

	var/genetype = GENETYPE_BAD

/**
* Is the gene active in this mob's DNA?
*/
// Return 1 if we can activate.
// HANDLE MUTCHK_FORCED HERE!
/datum/dna/gene/proc/can_activate(var/mob/M, var/flags)
	return 0

// Called when the gene activates.  Do my magic here.
/datum/dna/gene/proc/activate(var/mob/M, var/connected, var/flags)
	return

/**
* Called when the gene deactivates.  Undo my magic here.
* Only called when the block is deactivated.
*/

/datum/dna/gene/proc/can_deactivate(var/mob/M, var/flags)
	if(flags & GENE_NATURAL)
		//testing("[name]([type]) has natural flag.")
		return 0
	return 1

/datum/dna/gene/proc/deactivate(var/mob/M, var/connected, var/flags)
	M.active_genes.Remove(src.type)
	return 1

// This section inspired by goone's bioEffects.

/**
* Called in each life() tick.
*/
/datum/dna/gene/proc/OnMobLife(var/mob/M)
	return

/**
* Called when the mob dies
*/
/datum/dna/gene/proc/OnMobDeath(var/mob/M)
	return

/**
* Called when the mob says shit
*/
/datum/dna/gene/proc/OnSay(var/mob/M, var/message)
	return message

/**
* Called after the mob runs update_icons.
*
* @params M The subject.
* @params g Gender (m or f)
* @params fat Fat? (0 or 1)
*/
/datum/dna/gene/proc/OnDrawUnderlays(var/mob/M, var/g, var/fat)
	return 0


/////////////////////
// BASIC GENES
//
// These just chuck in a mutation and display a message.
//
// Gene is activated:
//  1. If mutation already exists in mob
//  2. If the probability roll succeeds
//  3. Activation is forced (done in domutcheck)
/////////////////////


/datum/dna/gene/basic
	name = "BASIC GENE"
	genetype = GENETYPE_GOOD

	// Mutation to give
	var/mutation=0

	// Activation probability
	var/activation_prob=45

	// Possible activation messages
	var/list/activation_messages=list()

	// Possible deactivation messages
	var/list/deactivation_messages=list()

	// Activation messages which are shown when drugged
	var/list/drug_activation_messages=list("I feel different.","I feel wonky.","I feel new!","I feel amazing.","I feel wobbly.","I feel goofy.",\
		"I feel strong!","I feel weak.","I think you can speak vox pidgin now.","I feel like killing a space bear!","You are no longer afraid of carps.")

	// Deactivation messages which are shown when drugged
	var/list/drug_deactivation_messages=list("I feel like you've lost a friend.","I get a feeling of loss.","My mind feels less burdened.","I feel old.",\
		"You are not sure what's going on.","I feel concerned.","I feel like you forgot something important.","I feel trippy.","My brain hurts.")

/datum/dna/gene/basic/can_activate(var/mob/M,var/flags)
	if(flags & MUTCHK_FORCED)
		return 1
	// Probability check
	return probinj(activation_prob,(flags&MUTCHK_FORCED))

/datum/dna/gene/basic/activate(var/mob/M)
	M.mutations.Add(mutation)
	var/msg1
	var/msg2
	if(activation_messages.len)
		msg1 = pick(activation_messages)
	if(drug_activation_messages.len)
		msg2 = pick(drug_activation_messages)

	if(msg2)
		msg2="<span class='notice'>[msg2]</span>" //Workaround to prevent simple_message from considering "<span class='notice'></span>" an actual message
	M.simple_message("<span class='notice'>[msg1]</span>", msg2 )

/datum/dna/gene/basic/can_deactivate(var/mob/M, var/flags)
	if(flags & GENE_NATURAL)
		//testing("[name]([type]) has natural flag.")
		return 0
	return 1

/datum/dna/gene/basic/deactivate(var/mob/M, var/connected, var/flags)
	if(..())
		M.mutations.Remove(mutation)
		var/msg1
		var/msg2
		if(deactivation_messages.len)
			msg1 = pick(deactivation_messages)
		if(drug_deactivation_messages.len)
			msg2 = pick(drug_deactivation_messages)

		if(msg2)
			msg2="<span class='notice'>[msg2]</span>" //Workaround to prevent simple_message from considering "<span class='notice'></span>" an actual message
		M.simple_message("<span class='notice'>[msg1]</span>", msg2 )
		return 1