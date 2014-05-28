
--[[----------------------------------------------------------
	FRENCH TRANSLATIONS
	-- 	Special thanks are due to Rakke, and Zuhligan for their assistance with French localization.
		à : \195\160	è : \195\168	ì : \195\172	ò : \195\178	ù : \195\185
		á : \195\161	é : \195\169	í : \195\173	ó : \195\179	ú : \195\186
		â : \195\162	ê : \195\170	î : \195\174	ô : \195\180	û : \195\187
		ã : \195\163	ë : \195\171	ï : \195\175	õ : \195\181	ü : \195\188
		ä : \195\164					ñ : \195\177	ö : \195\182
		æ : \195\166									ø : \195\184
		ç : \195\167									œ : \197\147
		Ä : \195\132	Ö : \195\150	Ü : \195\156	ß : \195\159
	
	-- TODO: FTC configuration settings in French
	-- TODO: remainder of skill names in French translation
  ]]----------------------------------------------------------
  
FTC.French = { 

	--[[---------------------------------
		CONFIGURATION NOTICES
	-----------------------------------]]
	["You are using Foundry Tactical Combat version"] = "",
	["FTC configuration settings have moved to the normal game settings interface!"] = "",

	--[[---------------------------------
		SETTINGS MENU
	-----------------------------------]]
	["FTC Settings"] = "Configuration de FTC",
	["Please use this menu to configure addon options."] = "Utilisez ce menu pour configurer l'addon.",
	["Reloads UI"] = "Modifier ce r\195\169glage recharge l'interface",
	
	["Configure Components"] = "Options des elements",
	["Enable Frames"] = "Activer les cadres",
	["Enable custom unit frames component?"] = "Afficher les cadres?",
	["Enable Buffs"] = "Activer les buffs",
	["Enable active buff tracking component?"] = "Afficher les buffs?",
	["Enable Damage Statistics"] = "Activer les statistiques de combats",
	["Enable damage statistics?"] = "Afficher les statistiques de combats?",
	["Enable Combat Text"] = "Activer les textes de combats",
	["Enable scrolling combat text component?"] = "Afficher les textes de combats flottants?",
	
	["Unit Frames Settings"] = "Options des cadres",
	["Show Default Target Frame"] = "Afficher le cadre original de la cible",
	["Show the default ESO target unit frame?"] = "Afficher le cadre par d\195\169faut de la cible?",
	["Default Unit Frames Text"] = "Texte par d\195\169faut du cadre",
	["Display text attribute values on default unit frames?"] = "Afficher les valeur text des ressources sur le cadre pas d\195\169faut?",
	["Show Player Nameplate"] = "Afficher le nameplate du joueur",
	["Show your own character's nameplate?"] = "Afficher votre nameplate?",
	["Enable Mini Experience Bar"] = "Activer la mini barre d'exp\195\169rience",
	["Show a small experience bar on the player frame?"] = "Afficher la mini barre d'exp\195\169rience sous le cadre du joueur?",
	--["In Combat Opacity"] = "",
	--["Adjust the in-combat transparency of unit frames."] = "",
	--["Non-Combat Opacity"] = "",
	--["Adjust the out-of-combat transparency of unit frames."] = "",
	
	["Buff Tracker Settings"] = "Options du traqueur de buffs",
	["Anchor Buffs"] = "Ancrage des buffs",
	["Anchor buffs to unit frames?"] = "Ancrer les buffs au cadre?",
	["Display Long Buffs"] = "Afficher les buffs long",
	["Track long duration player buffs?"] = "Traquer les buffs du joueur de longue dur\195\169e?",
	
	["Scrolling Combat Text Settings"] = "Options des textes de combat flottants",
	["Combat Text Scroll Speed"] = "Vitesse de d\195\169filement des textes de combat",
	["Adjust combat text scroll speed."] = "Ajustez la vitesse des textes de combat",
	["Display Ability Names"] = "Afficher le nom des comp\195\169tences",
	["Display ability names in combat text?"] = "Afficher le nom des comp\195\169tences dans les textes de combat?",
	["Scroll Path Animation"] = "Animation de d\195\169filement",
	["Choose scroll animation."] = "Choisissez l'animation de d\195\169filement",
	
	["Damage Tracker Settings"] = "Options du compteur de d\195\169g\195\162t",
	["Timeout Threshold"] = "Seuil d'arr\195\170t",
	["Number of seconds without damage to signal encounter termination."] = "Nombre de secondes sans dommages signalant la fin de la rencontre",
	
	["Reposition FTC Elements"] = "D\195\169placements des \195\169l\195\169ments FTC",
	["Lock Positions"] = "Verrouiller la position",
	["Modify FTC frame positions?"] = "Modifier la position des cadres FTC?",
	
	["Reset Settings"] = "R\195\169initialiser les param\195\168tres",
	["Restore Defaults"] = "Restauration par d\195\169faut",
	["Restore FTC to default settings."] = "Restaure FTC aux valeurs par d\195\169faut",
	
	--[[---------------------------------
		GAME TRANSLATIONS
	-----------------------------------]]
	["Chevalier-dragon^m"]								= "Dragonknight",
	["Chevalier-dragon^fm"]								= "Dragonknight",
	["Lame noire^mf"]									= "Nightblade",
	["Lame noire^f"]									= "Nightblade",
	["Sorcier^m"]										= "Sorcerer",
	["Sorci\195\168re^f"]								= "Sorcerer",
	["Templier^m"]										= "Templar",
	["Templi\195\168re^f"]								= "Templar",

	--[[---------------------------------
		WEAPON ABILITIES
	-----------------------------------]]
	
	-- Sword and Shield
	["Perforation^f"] 									= "Puncture",
	["Mise \195\160 sac^f"] 							= "Ransack",
	["Durchschlag^m"] 									= "Pierce Armor",	
	["Coup bas^f"] 										= "Low Slash",
	["Entaille profonde^f"] 							= "Deep Slash",
	["Coup incapacitant^m"] 							= "Crippling Slash",
	["Charge de bouclier^f"]							= "Shield Charge",
	["Invasion^f"]										= "Invasion",
	["Assaut prot\195\169g\195\169^m"]					= "Shielded Assault",
	["Coup de bouclier puissant^m"]						= "Power Bash",
	["Impact puissant^f"]								= "Power Slam",
	["Vibrations^f"]									= "Reverberating Bash",
	
	-- Dual Wield
	["Entailles jumelles^f"] 							= "Twin Slashes",
	["Fr\195\169n\195\169sie sanguinaire^f"] 				= "Blood Craze",
	["Entailles affaiblissantes^f"] 					= "Rending Slashes",	
	["Coups rapides^f"] 								= "Rapid Strikes",	
	["\195\137tincelles^f"] 							= "Sparks",
	["Lames chauff\195\169es^f"] 						= "Heated Blades",
	["\195\137clatement de braise^f"] 					= "Ember Explosion",
	["Larmes tourbillonnantes^f"] 						= "Whirling Blades",
	["Lame cach\195\169e^f"] 							= "Hidden Blade",
	["Lame volante^f"] 									= "Flying Blade",
	["Dagues voil\195\169es^f"] 						= "Shrouded Daggers",
	
	-- Two Handed
	["Fendoir^f"] 										= "Cleave",
	["Bagarre^f"] 										= "Brawler",
	["D\195\169coupe^f"] 								= "Carve",
	["Pi\195\169tinement^f"] 							= "Stampede",
	["Uppercut^f"] 										= "Uppercut",
	["Ravage^f"] 										= "Wrecking Blow",
	["Moulinet \195\169tourdissant^m"] 					= "Dizzying Swing",
	["\195\137lan^f"] 									= "Momentum",
	["\195\137lan frontal^f"] 							= "Forward Momentum",
	["Ralliement^f"] 									= "Rally",
	
	-- Bow	
	["Fl\195\168che empoisonn\195\169e^f"] 				= "Poison Arrow",
	["Fl\195\168che venimeuse^f"]						= "Venom Arrow",
	["Injection de poison^f"]							= "Poison Injection",
	["Vol\195\169e^f"]									= "Volley",
	["Terre br\195\187l\195\169e^f"]					= "Scorched Earth",
	["Tir de barrage^f"]								= "Arrow Barrage",
	["Tir group\195\169^f"]								= "Scatter Shot",
	["Gros calibre^f"]									= "Magnum Shot",
	["Tir de ponction^f"]								= "Draining Shot",
	["Fl\195\168ches dispers\195\169es^f"] 				= "Arrow Spray",
	["Bombarde^f"]										= "Bombard",
	["Dispersion acide^f"]								= "Acid Spray",
	["Fl\195\168che mortelle^f"]						= "Lethal Arrow",
	["Vis\195\169e pr\195\169cise^f"]					= "Focused Aim",
	
	-- Restoration Staff
	["Soins g\195\169n\195\169ralis\195\169s^pm"] 		= "Grand Healing",
	["Sources curatives^f"] 							= "Healing Springs",
	["Soins illustres^f"] 								= "Illustrious Healing",
	["R\195\169g\195\169n\195\169ration^f"] 			= "Regeneration",
	["Mutag\195\168ne^m"] 								= "Mutagen",
	["R\195\169g\195\169n\195\169ration rapide^f"] 		= "Rapid Regeneration",
	["B\195\169n\195\169diction de protection^f"] 		= "Blessing of Protection",
	["B\195\169n\195\169diction de r\195\169tablissement^f"] = "Blessing of Restoration",
	["Pri\195\168re de combat^f"] 						= "Combat Prayer",
	["D\195\169fense in\195\169branlable^f"] 			= "Steadfast Ward",
	["Protection d'un alli\195\169^f"] 					= "Ward Ally",
	["Protection curative^f"] 							= "Healing Ward",
	["Siphon de force^m"] 								= "Force Siphon",
	["Siphon d'esprit^m"] 								= "Siphon Spirit",
	["Siphon rapide^m"] 								= "Quick Siphon",
	
	-- Destruction Staff
	["Vuln\195\169rabilit\195\169 aux \195\169l\195\169ments^f"] = "Weakness to Elements",
	["Susceptibilit\195\169 aux \195\169l\195\169ments^f"] = "Elemental Succeptibility",
	["Ponction \195\169l\195\169mentaire^f"] 			= "Elemental Drain",
	--[""]												= "Destructive Touch",
	--[""]												= "Force Shock",
	
	--[[---------------------------------
		SORCERER
	-----------------------------------]]
	
	-- Daedric Summoning
	["Mal\195\169diction daedrique^f"]					= "Daedric Curse",
	["Mal\195\169diction v\195\169loce^f"] 				= "Velocious Curse",
	["Mal\195\169diction explosive^f"]					= "Explosive Curse",
	["Protection invoqu\195\169e^f"]					= "Conjured Ward",
	["Protection renforc\195\169e^f"]					= "Empowered Ward",
	["Protection durcie^f"]								= "Hardened Ward",
	["Invocation d'atronach de foudre"]					= "Summon Storm Atronach",
	["Atronach de foudre sup\195\169rieur^m"]			= "Greater Storm Atronach",
	["Invocation d'atronach charg\195\169^f"] 			= "Summon Charged Atronach",
	
	-- Storm Calling
	["Furie du mage^f"]									= "Mages Fury",
	["Rage de mage^f"]									= "Mages Wrath",
	["Furie infinie^f"]									= "Endless Fury",	
	["Forme de foudre"]									= "Lightning Form",
	["Temp\195\170te d\195\169cha\195\174n\195\169e^f"]	= "Boundless Storm",
	["Pr\195\169sente foudroyante^f"]					= "Thundering Presence",
	["Disque de foudre"]								= "Lightning Splash",
	["Foudre liquide^f"]								= "Liquid Lightning",
	["D\195\169ferlante de foudre^f"]					= "Lightning Flood",
	["Surtension"]										= "Surge",
	["Surtension critique^f"]							= "Critical Surge",
	["Surpuissance^f"]									= "Power Surge",
	["Vivacit\195\169 de l'\195\169clair^f"]			= "Bolt Escape",
	["Vivacit\195\169 foudroyante^f"]					= "Streak",
	["Boule de foudre^f"]								= "Ball of Lightning",

	-- Dark Magic
	["\195\137clat de cristal^m"]						= "Crystal Shard",
	["Fragments de cristal^pm"]							= "Crystal Fragments",
	["Explosion de cristal^f"]							= "Crystal Blast",	
	["Occlusion"]										= "Encase",
	["Prison enserrante^f"]								= "Restraining Prison",
	["Prison \195\169crasante^f"]						= "Shattering Prison",
	["Prison runique^f"]								= "Rune Prison",
	["Prison affaiblissante^f"]							= "Weakening Prison",
	["Cage runique^f"]									= "Rune Cage",	
	["Mines daedriques"]								= "Daedric Mines",
	["Champ de mines daedriques^pf"]					= "Daedric Minefield",
	["Tombe daedrique^f"]								= "Daedric Tomb",
	["\195\137change noir^m"]							= "Dark Exchange",
	["Conversion noire^f"]								= "Dark Conversion",
	["Pacte noir^m"]									= "Dark Deal",	
	["N\195\169gation de la magie^f"]					= "Negate Magic",
	["Champ de suppression^m"]							= "Suppression Field",
	["Champ d'absorption^m"]							= "Absorption Field",
	
	--[[---------------------------------
		DRAGONKNIGHT
	-----------------------------------]]
	
	-- Ardent Flame
	["Cha\195\174nes \195\169nergisantes^f"]			= "Empowering Chain", 
	["Frappe incendiaire^f"]							= "Searing Strike",
	["Flamme instable^f"]								= "Unstable Flame",
	["Braises enflamm\195\169es^pf"]					= "Burning Embers",
	["Souffle ardent^m"]								= "Fiery Breath",
	["Souffle br\195\187lant^p"]						= "Burning Breath",
	["Flammes d\195\169vorantes^pf"]					= "Engulfing Flames",	
	["\195\137tendard des Chevaliers-dragons^m"]		= "Dragonknight Standard",
	["\195\137tendard de puissance^m"]					= "Standard of Might",
	["\195\137tendard mouvant^m"]						= "Shifting Standard",
	
	-- Earthen Heart
	["Poing de pierre^m"]								= "Stonefist",
	["G\195\169ant de pierre^m"]						= "Stone Giant",
	["\195\137clat d'obsidienne^m"]						= "Obsidian Shard",
	["Bouclier d'obsidienne^m"]							= "Obsidian Shield",
	["Bouclier ign\195\169^m"]							= "Igneous Shield",
	["Bouclier fragment\195\169^m"]						= "Fragmented Shield",
	["P\195\169trification^f"]							= "Petrify",
	["Fossilisation^f"]									= "Fossilize",
	["Rochers \195\169crasants^pm"]						= "Shattering Rocks",
	["Nuage de cendres^m"]								= "Ash Cloud",
	["Temp\195\170te de cendres^f"]						= "Cinder Storm",
	["\195\137ruption^f"]								= "Eruption",
	["Armure de magma^f"]								= "Magma Armor",
	["Carapace de magma^f"]								= "Magma Shell",
	["Armure corrosive^f"]								= "Corrosive Armor",

	-- Draconic Power
	["Armure h\195\169riss\195\169e^f"]					= "Spiked Armor",
	["Armure effil\195\169e^f"]							= "Razor Armor",
	["Armure volatile^f"]								= "Volatile Armor",
	["Serres noires^pf"]								= "Dark Talons",
	["Serres br\195\187lantes^pf"]						= "Burning Talons",
	["Serres \195\169touffantes^pf"]					= "Choking Talons",	
	["Sang de dragon^m"]								= "Dragon Blood",
	["Sang de dragon vert^m"]							= "Green Dragon Blood",
	["Sang coagul\195\169^m"]							= "Coagulating Blood",
	["\195\137cailles r\195\169fractaires^pf"]			= "Reflective Scale",
	["\195\137cailles de dragon de feu^pf"]				= "Dragon Fire Scale",
	["Plates r\195\169fractaires^pf"]					= "Reflective Plate",
	
	--[[---------------------------------
		NIGHTBLADE
	-----------------------------------]]
	
	-- Assassination
	["Frappe translatoire^f"]							= "Teleport Strike",
	["Embuscade^f"]										= "Ambush",
	["\195\137ventail du lotus^m"]						= "Lotus Fan",	
	["Flou"]											= "Blur",
	["Mirage^m"]										= "Mirage",
	["Berlue^f"]										= "Double Take",
	["Cible marqu\195\169e^f"]							= "Mark Target",
	["Marque perforante^f"]								= "Piercing Mark",
	["Marque de la faucheuse^f"]						= "Reaper's Mark",	
	["H\195\162te^f"]									= "Haste",
	["Attaques concentr\195\169es^pf"]					= "Focused Attacks",
	["Incapacitation^f"]								= "Incapacitate",
	["Coup fatal^m"]									= "Death Stroke",
	["Frappe d\195\169bilitante^f"]						= "Incapacitating Strike",
	["Moisson d'\195\162mes^f"]							= "Soul Harvest",

	-- Siphoning
	["Discorde^f"]										= "Strife",
	["Engloutissement de l'\195\162me^m"]				= "Swallow Soul",
	["Captation de vie^f"]								= "Funnel Health",	
	["Agonie^f"]										= "Agony",
	["Souffrance prolong\195\169e^f"]					= "Prolonged Suffering",
	["Couronne mal\195\169fique^f"]						= "Malefic Wreath",	
	["Mutilation^f"]									= "Cripple",
	["D\195\169bilitation^f"]							= "Debilitate",
	["\195\137treinte d\195\169bilitante^f"]			= "Crippling Grasp",
	["Drain de puissance^m"]							= "Drain Power",
	["Extraction de puissance^f"]						= "Power Extraction",
	["Sape d'essence^f"]								= "Sap Essence",
	["Lac\195\169ration d'\195\162me^f"]				= "Soul Shred",
	["Amarre spirituelle^f"]							= "Soul Tether",
	["Siphon d'\195\162me^m"]							= "Soul Siphon",
																	
	-- Shadow
	["Cape d'ombres^f"]									= "Shadow Cloak",
	["D\195\169guisement d'ombres^m"]					= "Shadowy Disguise",
	["Cape sombre^f"]									= "Dark Cloak",
	["Frappe voil\195\169e^f"]							= "Veiled Strike",
	["Attaque surprise^f"]								= "Surprise Attack",
	["Arme dissimul\195\169e^f"]						= "Concealed Weapon",
	["Sentier d'ombres"]								= "Path of Darkness",
	["Sentier tortueux^m"]								= "Twisting Path",
	["Sentier rafra\195\174chissant^m"]					= "Refreshing Path",
	["Aspect de terreur^m"]								= "Aspect of Terror",
	["Hyst\195\169rie collective^f"]					= "Mass Hysteria",
	["Manifestation de terreur^f"]						= "Manifestation of Terror",
	["Invocation d'ombre"]								= "Summon Shade",
	["Ombres obscures^pf"]								= "Dark Shades",
	["Image d'ombre^f"]									= "Shadow Image",
	["T\195\169n\195\168bres d\195\169vorantes^pf"]		= "Consuming Darkness",
	["T\195\169n\195\168bres rassurantes^pf"]			= "Bolstering Darkness",
	["Voile de lame^m"]									= "Veil of Blades",
	
	--[[---------------------------------
		TEMPLAR
	-----------------------------------]]
	
	-- Aedric Spear
	["Javelot effil\195\169^m"]							= "Piercing Javelin",
	["Javelot de l'aurore^m"]							= "Aurora Javelin",
	["Javelot entravant^m"]								= "Binding Javelin",
	["Balayage fortifiant^m"]							= "Empowering Sweep",
	["Charge concentr\195\169e^f"]						= "Focused Charge",
	["Charge explosive^f"]								= "Explosive Charge",
	["Charge renversante^f"]							= "Toppling Charge",
	["Bouclier solaire"]								= "Sun Shield",
	["Protection radieuse^f"]							= "Radiant Ward",
	["Bouclier ardent^m"]								= "Blazing Shield",
	
	-- Dawn's Wrath
	["Feu du soleil^m"]									= "Sun Fire",
	["Lumi\195\168re r\195\169flechie^f"]				= "Reflective Light",
	["Fl\195\169au des vampires^m"]						= "Vampire's Bane",
	["\195\137ruption noire^f"]							= "Dark Flare",
	["\195\137clipse^f"]								= "Eclipse",
	["Obscurit\195\169 totale^f"]						= "Total Dark",
	["Noyau instable^m"]								= "Unstable Core",
	["Retour de flamme^m"]								= "Backlash",
	["Pouvoir de la lumi\195\168re^m"]					= "Power of the Light",
	["Lumi\195\168re purificatrice^f"]					= "Purifying Light",
	
	-- Restoring Light
	["Hommage aux d\195\169funts^m"]					= "Honor The Dead",
	["Rituel r\195\169manent^m"]						= "Lingering Ritual",
	["Rite de passage"]									= "Rite of Passage",
	["Remembrance^f"]									= "Remembrance",
	["Incantation r\195\169p\195\169t\195\169e^f"]		= "Practiced Incarnation",
	["Aura de r\195\169tablissement^f"]					= "Restoring Aura",
	["Aura radieuse^f"]									= "Radiant Aura",
	["Rituel purificateur^m"]							= "Cleansing Ritual",
	["Purifying Ritual^m"]								= "Purifying Ritual",
	["Rituel \195\169tendu^m"]							= "Extended Ritual",
	["Focalisation runique"]							= "Rune Focus",
	["Focalisation canalis\195\169e^f"]					= "Channeled Focus",
	["Focalisation de r\195\169tablisssement^f"]		= "Restoring Focus",
		
	--[[---------------------------------
		ARMOR
	-----------------------------------]]

	-- Heavy Armour
	["Inamovible^M"]									= "Immovable",
	["Brute inamovible^f"]								= "Immovable Brute",
	["Implacable^m"]									= "Unstoppable",
	
	-- Medium Armor
	["Esquive"]											= "Evasion",
	["\195\137chapp\195\169e belle^f"]					= "Elude",
	["Jeu de jambes^m"]									= "Shuffle",
	
	-- Light Armour
	["Annulation^f"]									= "Annulment",
	["Inertie magique^f"]								= "Dampen Magic",
	["Ma\195\174trise de la magie^f"]					= "Harness Magicka",

	--[[---------------------------------
		GUILDS
	-----------------------------------]]
	
	-- Fighters Guild
	["Expertise de la chasse^f"]						= "Expert Hunter",
	["Chasse aux mal\195\169fices^f"]					= "Evil Hunter",
	["Chasseur camoufl\195\169^m"]						= "Camouflaged Hunter",
	--[""] 												= "Silver Bolts",
	--[""] 												= "Silver Shards",
	--[""] 												= "Silver Leash",
	
	-- Mages Guild
	["Entropie^f"]										= "Entropy",
	["D\195\169g\195\169n\195\169rescence^f"]			= "Degeneration",
	["Entropie structur\195\169e^f"]					= "Structured Entropy",
	
	-- Undaunted
	["Feu int\195\169rieur^m"]							= "Inner Fire",
	["Rage int\195\169rieure^f"]						= "Inner Rage",
	["B\195\170te int\195\169rieure^f"]					= "Inner Beast",
	
	--[[---------------------------------
		WORLD
	-----------------------------------]]
	
	-- Vampire
	["Drain d'essence^m"]								= "Drain Essence",
	["Drain revigorant^m"]								= "Invigorating Drain",
	["Drain de minuit^m"]								= "Midnight Drain",	
	["Forme de brume^f"]								= "Mist Form",
	["Brume fluide^f"]									= "Elusive Mist",
	["Brume toxique^f"]									= "Poison Mist",
	["Nu\195\169e de chauves-souris^f"]					= "Bat Swarm",
	["Nu\195\169e d\195\169vorante^f"]					= "Devouring Swarm",
	["Nu\195\169e imp\195\169n\195\169trable^f"]		= "Clouding Swarm",
	
	-- Soul Magic
	["Pi\195\168ge d'\195\162me^m"]						= "Soul Trap",
	["Pi\195\168ge d\195\169vorant^m"]					= "Consuming Trap",
	["Pi\195\168ge de scission d'\195\162me^m"]			= "Soul Splitting Trap",
	["Frappe \195\160 l'\195\162me^f"]					= "Soul Strike",
	["Brisure d'\195\162me^f"]							= "Shatter Soul",
	["Assaut d'\195\162me^m"]							= "Soul Assault",

	
	--[[---------------------------------
		AVA
	-----------------------------------]]
	
	-- Support
	["Purge^f"]											= "Purge",
	["Purge efficiente^f"]								= "Efficient Purge",
	["Purification^f"]									= "Cleanse",
	["Bouclier de si\195\168ge^m"]						= "Siege Shield",
	["Bouclier d'arme de si\195\168ge^m"]				= "Siege Weapon Shield",
	["Bouclier propulseur^m"]							= "Propelling Shield",
	["Barri\195\168re^f"]								= "Barrier",
	["Barri\195\168re revitalisante^f"]					= "Reviving Barrier",
	["Barri\195\168re rafra\195\174chissante^f"]		= "Replenishing Barrier",
	
	-- Assault
	["Man\197\147uvre rapide^f"]						= "Rapid Maneuver",
	["Ma\197\147uvre de repli^f"]						= "Retreating Maneuver",
	["Man\197\147uvre de charge^f"]						= "Charging Maneuver",
	["Pointes^pf"]										= "Caltrops",
	["Pointes anti-cavalerie^pf"]						= "Anti-Cavalry Caltrops",
	["Pointes ac\195\169r\195\169es^pf"]				= "Razor Caltrops",
	["Cor de guerre^m"]									= "War Horn",
	["Cor agressif^f"]									= "Aggressive Horn",
	["Cor de r\195\169sistance^f"]						= "Sturdy Horn",
	
	--[[---------------------------------
		EFFECT FILTERS
	-----------------------------------]]
	["B\195\169n\195\169dictions:"]						= "Boon:",
	["B\195\169n\195\169diction^f:"]					= "Boon:",
	--[""]												= "Vampirisim",
	["R\195\169cup\195\169ration surnaturelle^f"] 		= "Supernatural Recovery",
	--[""]												= "Lycanthropy",
	["Spirit Armor"]									= "Spirit Armor",
	--[""]												= "Brace (Generic)",
	["Bonus de fort"]									= "Keep Bonus",
	["Bonus de Parchemin^m"]							= "Scroll Bonus",
	["Bonus d'all\195\169geance \195\160 l'empereur"] 	= "Emperorship",
	["Vigueur maximale augment\195\169e"]				= "Increase Max",
	["Magie maximale augment\195\169e"]					= "Increase Max",
	["Sant\195\169 maximale augment\195\169e"]			= "Increase Max",
}