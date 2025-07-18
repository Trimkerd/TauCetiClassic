var/global/list/list/landmarks_list = list() // assoc list of all landmarks created (name -> list of landmarks)

// todo:
// 	instead of list by name, make list by type. Type is better, compilator and map editor can report any errors with types
// 	replace all landmarks with default type on map for special types
// 	remove all landmarks that not actually landmarks, like /obj/effect/landmark/loot_spawn (we have spawners for this)
// 	landmark pick:
// 		pick_landmarked_location(/obj/effect/landmark/blobstart)
// 	remove all INITIALIZE_HINT_QDEL from landmarks, we can keep them for reuse and spawn_counter
// 		this can hit maptick a little, less problem with mapthreads and bother lummox with https://www.byond.com/forum/post/2778883

/proc/pick_landmarked_location(name, least_used = TRUE)
	if(!length(landmarks_list[name]))
		CRASH("Can't find landmark \"[name]\"!")

	var/obj/effect/landmark/L

	if(least_used)
		var/list/candidates = list()
		var/min = INFINITY

		for(var/obj/effect/landmark/LM in landmarks_list[name])
			if(LM.spawn_counter > min)
				continue

			if(LM.spawn_counter == min)
				candidates += LM
			else
				min = LM.spawn_counter
				candidates.Cut()
				candidates += LM

		L = pick(candidates)
	else
		L = pick(landmarks_list[name])

	L.spawn_counter++

	return get_turf(L)

/obj/effect/landmark
	name = "landmark"
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x2"
	anchored = TRUE
	layer = TURF_LAYER
	plane = GAME_PLANE
	unacidable = TRUE
	invisibility = INVISIBILITY_ABSTRACT

	var/spawn_counter = 0 // incremented and used by spawners, ignored by most other things
	var/spawner_type
	var/spawner_positions

/obj/effect/landmark/New()
	..()
	if(name == "landmark") // skip landmarks without unique name
		return
	tag = "landmark*[name]"
	var/list/landmarks = landmarks_list[name]
	if(landmarks)
		landmarks += src
	else
		landmarks_list[name] = landmarks = list(src)

/obj/effect/landmark/Destroy()
	if(name != "landmark")
		landmarks_list[name]-= src
	return ..()

/obj/effect/landmark/atom_init()
	. = ..()

	// todo: move them all to own landmark types
	switch(name)
		if ("awaystart")
			awaydestinations += src
		/*if("Wizard")
			wizardstart += loc
			return INITIALIZE_HINT_QDEL*/
		//prisoners
		if("prisonwarp")
			prisonwarp += loc
			return INITIALIZE_HINT_QDEL
		if("tdome1")
			tdome1 += loc
		if("tdome2")
			tdome2 += loc
		if("tdomeadmin")
			tdomeadmin += loc
		if("tdomeobserve")
			tdomeobserve += loc
		//not prisoners
		if("prisonsecuritywarp")
			prisonsecuritywarp += loc
			return INITIALIZE_HINT_QDEL
		//if("blobstart") // also nuclear disk spawn loc
		//	blobstart += src
		if("xeno_spawn")
			xeno_spawn += loc
			return INITIALIZE_HINT_QDEL
		//if("ninjastart") // "ninja", not "ninjastart"
		//	ninjastart += src
		//	return INITIALIZE_HINT_QDEL
		//if("Gladiator")
		//	Gladiator += loc
		//	return INITIALIZE_HINT_QDEL
		if("prisonerstart")
			prisonerstart += loc
			return INITIALIZE_HINT_QDEL

/obj/effect/landmark/sound_source
	name = "Sound Source"

/obj/effect/landmark/sound_source/shuttle_docking
	name = "Shuttle Docking"

/obj/effect/landmark/start
	name = "start"
	icon = 'icons/mob/landmarks.dmi'
	icon_state = "x"
	anchored = TRUE
	layer = MOB_LAYER
	var/delete_after_roundstart = TRUE

/obj/effect/landmark/start/New()
	..()
	if(name != "start")
		tag = "start*[name]"

/obj/effect/landmark/start/proc/after_round_start()
	if(delete_after_roundstart)
		qdel(src)

/obj/effect/landmark/start/new_player
	name = "New Player"

// Must be on New() rather than Initialize, because players will
// join before SSatom initializes everything.
/obj/effect/landmark/start/new_player/New(loc)
	..()
	newplayer_start += loc

/obj/effect/landmark/start/new_player/atom_init(mapload)
	..()
	return INITIALIZE_HINT_QDEL

// Assistats
/obj/effect/landmark/start/assistant
	name = "Assistant"
	icon_state = "Assistant"

/obj/effect/landmark/start/assistant/waiter
	name = "Waiter"

//Civilians
/obj/effect/landmark/start/captain
	name = "Captain"
	icon_state = "Captain"

/obj/effect/landmark/start/head_of_personnel
	name = "Head of Personnel"
	icon_state = "Head of Personnel"

/obj/effect/landmark/start/bartender
	name = "Bartender"
	icon_state = "Bartender"

/obj/effect/landmark/start/chef
	name = "Chef"
	icon_state = "Chef"

/obj/effect/landmark/start/botanist
	name = "Botanist"
	icon_state = "Botanist"

/obj/effect/landmark/start/barber
	name = "Barber"
	icon_state = "Barber"

/obj/effect/landmark/start/janitor
	name = "Janitor"
	icon_state = "Janitor"

/obj/effect/landmark/start/librarian
	name = "Librarian"
	icon_state = "Librarian"

/obj/effect/landmark/start/chaplain
	name = "Chaplain"
	icon_state = "Chaplain"

/obj/effect/landmark/start/internal_affairs_agent
	name = "Internal Affairs Agent"
	icon_state = "Internal Affairs Agent"

/obj/effect/landmark/start/clown
	name = "Clown"
	icon_state = "Clown"

/obj/effect/landmark/start/mime
	name = "Mime"
	icon_state = "Mime"

// Cargo
/obj/effect/landmark/start/quartermaster
	name = "Quartermaster"
	icon_state = "Quartermaster"

/obj/effect/landmark/start/cargo_technician
	name = "Cargo Technician"
	icon_state = "Cargo Technician"

/obj/effect/landmark/start/shaft_miner
	name = "Shaft Miner"
	icon_state = "Shaft Miner"

/obj/effect/landmark/start/recycler
	name = "Recycler"
	icon_state = "Recycler"

// Security
/obj/effect/landmark/start/head_of_security
	name = "Head of Security"
	icon_state = "Head of Security"

/obj/effect/landmark/start/warden
	name = "Warden"
	icon_state = "Warden"

/obj/effect/landmark/start/detective
	name = "Detective"
	icon_state = "Detective"

/obj/effect/landmark/start/security_officer
	name = "Security Officer"
	icon_state = "Security Officer"

/obj/effect/landmark/start/forensic_technician
	name = "Forensic Technician"
	icon_state = "Forensic Technician"

/obj/effect/landmark/start/security_cadet
	name = "Security Cadet"
	icon_state = "Security Cadet"

/obj/effect/landmark/start/blueshield_officer
	name = "Blueshield Officer"
	icon_state = "Blueshield Officer"

// Engineering
/obj/effect/landmark/start/chief_engineer
	name = "Chief Engineer"
	icon_state = "Chief Engineer"

/obj/effect/landmark/start/station_engineer
	name = "Station Engineer"
	icon_state = "Station Engineer"

/obj/effect/landmark/start/atmospheric_technician
	name = "Atmospheric Technician"
	icon_state = "Atmospheric Technician"

/obj/effect/landmark/start/technical_assistant
	name = "Technical Assistant"
	icon_state = "Technical Assistant"


//Medical
/obj/effect/landmark/start/chief_medical_officer
	name = "Chief Medical Officer"
	icon_state = "Chief Medical Officer"

/obj/effect/landmark/start/medical_doctor
	name = "Medical Doctor"
	icon_state = "Medical Doctor"

/obj/effect/landmark/start/paramedic
	name = "Paramedic"
	icon_state = "Paramedic"

/obj/effect/landmark/start/chemist
	name = "Chemist"
	icon_state = "Chemist"

/obj/effect/landmark/start/virologist
	name = "Virologist"
	icon_state = "Virologist"

/obj/effect/landmark/start/psychiatrist
	name = "Psychiatrist"
	icon_state = "Psychiatrist"

/obj/effect/landmark/start/medical_intern
	name = "Medical Intern"
	icon_state = "Medical Intern"

// Both is good
/obj/effect/landmark/start/geneticist
	name = "Geneticist"
	icon_state = "Geneticist"

// RnD
/obj/effect/landmark/start/research_director
	name = "Research Director"
	icon_state = "Research Director"

/obj/effect/landmark/start/scientist
	name = "Scientist"
	icon_state = "Scientist"

/obj/effect/landmark/start/xenoarchaeologist
	name = "Xenoarchaeologist"
	icon_state = "Xenoarchaeologist"

/obj/effect/landmark/start/xenobiologist
	name = "Xenobiologist"
	icon_state = "Xenobiologist"

/obj/effect/landmark/start/roboticist
	name = "Roboticist"
	icon_state = "Roboticist"

/obj/effect/landmark/start/research_assistant
	name = "Research Assistant"
	icon_state = "Research Assistant"

// Silicons
/obj/effect/landmark/start/ai
	name = "AI"
	icon_state = "AI"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/cyborg
	name = "Cyborg"
	icon_state = "Cyborg"


// Roles
/obj/effect/landmark/start/wizard
	name = "Wizard"
	icon = 'icons/effects/landmarks_static.dmi'
	icon_state = "wiznerd_spawn"
	delete_after_roundstart = FALSE

/obj/effect/landmark/start/velocity_officer
	name = "Velocity Officer"


/obj/effect/landmark/cops_spawn
	name = "Space Cops"

/obj/effect/landmark/dealer_spawn
	name = "Dealer"

/obj/effect/landmark/heist_spawn
	name = "Heist"

/obj/effect/landmark/latejoin
	name = "JoinLate"

/obj/effect/landmark/latejoin/New(loc)
	..()
	latejoin += loc

/obj/effect/landmark/latejoin/atom_init(mapload)
	..()
	return INITIALIZE_HINT_QDEL

//Costume spawner landmarks

/obj/effect/landmark/costume/atom_init() // costume spawner, selects a random subclass and disappears
	..()
	var/list/options = typesof(/obj/effect/landmark/costume)
	var/PICK = options[rand(1, options.len)]
	new PICK(loc)
	return INITIALIZE_HINT_QDEL

//SUBCLASSES.  Spawn a bunch of items and disappear likewise
/obj/effect/landmark/costume/chicken/atom_init()
	..()
	new /obj/item/clothing/suit/chickensuit(loc)
	new /obj/item/clothing/head/chicken(loc)
	new /obj/item/weapon/reagent_containers/food/snacks/egg(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/gladiator/atom_init()
	..()
	new /obj/item/clothing/under/gladiator(loc)
	new /obj/item/clothing/head/helmet/gladiator(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/madscientist/atom_init()
	..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/suit/storage/labcoat/mad(loc)
	new /obj/item/clothing/glasses/gglasses(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/elpresidente/atom_init()
	..()
	new /obj/item/clothing/under/gimmick/rank/captain/suit(loc)
	new /obj/item/clothing/head/flatcap(loc)
	new /obj/item/clothing/mask/cigarette/cigar/havana(loc)
	new /obj/item/clothing/shoes/boots(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/nyangirl/atom_init()
	..()
	new /obj/item/clothing/under/schoolgirl(loc)
	new /obj/item/clothing/head/kitty(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/maid/atom_init()
	..()
	new /obj/item/clothing/under/blackskirt(loc)
	var/CHOICE = pick(/obj/item/clothing/head/chep, /obj/item/clothing/head/rabbitears)
	new CHOICE(loc)
	new /obj/item/clothing/glasses/sunglasses/blindfold(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/butler/atom_init()
	..()
	new /obj/item/clothing/accessory/tie/waistcoat(loc)
	new /obj/item/clothing/under/suit_jacket(loc)
	new /obj/item/clothing/head/that(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/scratch/atom_init()
	..()
	new /obj/item/clothing/gloves/white(loc)
	new /obj/item/clothing/shoes/white(loc)
	new /obj/item/clothing/under/scratch(loc)
	if (prob(30))
		new /obj/item/clothing/head/cueball(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/highlander/atom_init()
	..()
	new /obj/item/clothing/under/kilt(loc)
	new /obj/item/clothing/head/beret/red(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/prig/atom_init()
	..()
	new /obj/item/clothing/accessory/tie/waistcoat(loc)
	new /obj/item/clothing/glasses/monocle(loc)
	var/CHOICE = pick( /obj/item/clothing/head/bowler, /obj/item/clothing/head/that)
	new CHOICE(loc)
	new /obj/item/clothing/shoes/black(loc)
	new /obj/item/weapon/cane(loc)
	new /obj/item/clothing/under/sl_suit(loc)
	new /obj/item/clothing/mask/fakemoustache(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/plaguedoctor/atom_init()
	..()
	new /obj/item/clothing/suit/bio_suit/plaguedoctorsuit(loc)
	new /obj/item/clothing/head/plaguedoctorhat(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/nightowl/atom_init()
	..()
	new /obj/item/clothing/under/owl(loc)
	new /obj/item/clothing/mask/gas/owl_mask(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/waiter/atom_init()
	..()
	new /obj/item/clothing/under/waiter(loc)
	var/CHOICE = pick( /obj/item/clothing/head/kitty, /obj/item/clothing/head/rabbitears)
	new CHOICE(loc)
	new /obj/item/clothing/suit/apron(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/pirate/atom_init()
	..()
	new /obj/item/clothing/under/pirate(loc)
	new /obj/item/clothing/suit/pirate(loc)
	var/CHOICE = pick( /obj/item/clothing/head/pirate , /obj/item/clothing/head/bandana )
	new CHOICE(loc)
	new /obj/item/clothing/glasses/eyepatch(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/commie/atom_init()
	..()
	new /obj/item/clothing/under/soviet(loc)
	new /obj/item/clothing/head/ushanka(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/imperium_monk/atom_init()
	..()
	new /obj/item/clothing/suit/imperium_monk(loc)
	if (prob(25))
		new /obj/item/clothing/mask/gas/cyborg(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/holiday_priest/atom_init()
	..()
	new /obj/item/clothing/suit/holidaypriest(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/marisawizard/fake/atom_init()
	..()
	new /obj/item/clothing/head/wizard/marisa/fake(loc)
	new/obj/item/clothing/suit/wizrobe/marisa/fake(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/cutewitch/atom_init()
	..()
	new /obj/item/clothing/under/sundress(loc)
	new /obj/item/clothing/head/witchwig(loc)
	new /obj/item/weapon/staff/broom(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/fakewizard/atom_init()
	..()
	new /obj/item/clothing/suit/wizrobe/fake(loc)
	new /obj/item/clothing/head/wizard/fake(loc)
	new /obj/item/weapon/staff(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/sexyclown/atom_init()
	..()
	new /obj/item/clothing/mask/gas/sexyclown(loc)
	new /obj/item/clothing/under/sexyclown(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/costume/sexymime/atom_init()
	..()
	new /obj/item/clothing/mask/gas/sexymime(loc)
	new /obj/item/clothing/under/sexymime(loc)
	return INITIALIZE_HINT_QDEL

/obj/effect/landmark/blockway
	density = TRUE

/obj/effect/landmark/espionage_start
	name = "Espionage Agent Start"

/obj/effect/landmark/espionage_start/atom_init(mapload)
	. = ..()
	create_spawner(/datum/spawner/spy)

/obj/effect/landmark/survival_start
	name = "Survivalist Start"
	var/spawnertype = /datum/spawner/survival

/obj/effect/landmark/survival_start/atom_init(mapload)
	. = ..()
	create_spawner(spawnertype)

/obj/effect/landmark/survival_start/medic
	spawnertype = /datum/spawner/survival/med

/obj/effect/landmark/lone_op_spawn
	name = "Solo operative"

/obj/effect/landmark/junkyard_bum // don't exists on map, randomly spawned by junkyard generator
	name = "Junkyard Bum"

// generic event map landmarks
/obj/effect/landmark/blue_team
	name = "Blue Team"
	icon_state = "x2"

/obj/effect/landmark/red_team
	name = "Red Team"
	icon_state = "x"
