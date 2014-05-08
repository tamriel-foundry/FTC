
--[[----------------------------------------------------------
	GERMAN TRANSLATIONS
	-- 	Special thanks are due to MerlinGer, Rakke, Xianlung, and Rial for their assistance with German localization.
		à : \195\160	è : \195\168	ì : \195\172	ò : \195\178	ù : \195\185
		á : \195\161	é : \195\169	í : \195\173	ó : \195\179	ú : \195\186
		â : \195\162	ê : \195\170	î : \195\174	ô : \195\180	û : \195\187
		ã : \195\163	ë : \195\171	ï : \195\175	õ : \195\181	ü : \195\188
		ä : \195\164					ñ : \195\177	ö : \195\182
		æ : \195\166									ø : \195\184
		ç : \195\167									œ : \197\147
		Ä : \195\132	Ö : \195\150	Ü : \195\156	ß : \195\159
	
	-- TODO: FTC configuration settings in German
	-- TODO: remainder of skill names in German translation
  ]]----------------------------------------------------------
  
FTC.German = { 

	--[[---------------------------------
		CONFIGURATION NOTICES
	-----------------------------------]]
	["You are using Foundry Tactical Combat version"] = "Du benutzt die Foundry Tactical Combat version",
	["FTC configuration settings have moved to the normal game settings interface!"] = "FTC Konfigurationseinstellungen sind nun im Einstellungsmen\195\188 des Spiels!",

	--[[---------------------------------
		SETTINGS MENU
	-----------------------------------]]
	["FTC Settings"] = "FTC Einstellungen",
	["Please use this menu to configure addon options."] = "Bitte benutze dieses Men\195\188 um die optionen zu konfigurieren.",
	["Reloads UI"] = "Oberfl\195\164che neu laden",
	
	["Configure Components"] = "Allgemeine Konfiguration",
	["Enable Frames"] = "Anzeigeelemente aktivieren",
	["Enable custom unit frames component?"] = "Aktiviert die FTC Anzeigeelemente",
	["Enable Buffs"] = "Buffs aktivieren",
	["Enable active buff tracking component?"] = "Aktiviert die Anzeige der aktiven Buffs",
	["Enable Damage Statistics"] = "Schadensstatistik aktivieren",
	["Enable damage statistics?"] = "Aktiviert die Anzeige der Schadensstatistik",
	["Enable Combat Text"] = "Schadenswerte aktivieren",
	["Enable scrolling combat text component?"] = "Aktiviert die Anzeige der Schadenswerte",
	
	["Unit Frames Settings"] = "Anzeigeeinstellungen",
	["Show Default Target Frame"] = "Standard Zielanzeige anzeigen",
	["Show the default ESO target unit frame?"] = "Standard ESO Zielanzeige anzeigen",
	["Default Unit Frames Text"] = "Text in Standard Anzeigeelementen anzeigen",
	["Display text attribute values on default unit frames?"] = "Attribut-Werte in Standard Anzeigeelementen anzeigen",
	["Show Player Nameplate"] = "Spieler Namen anzeigen",
	["Show your own character's nameplate?"] = "Eigenen Namen anzeigen",
	["Enable Mini Experience Bar"] = "Mini Erfahrungsleiste aktivieren",
	["Show a small experience bar on the player frame?"] = "Zeigt eine kleine Erfahrungsleiste unter dem Spielerelement an",
	
	["Buff Tracker Settings"] = "Buff Anzeigeeinstellungen",
	["Anchor Buffs"] = "Buff-Anzeige ausrichten",
	["Anchor buffs to unit frames?"] = "Richtet die Buff-Anzeige an den Anzeigeelementen aus",
	["Display Long Buffs"] = "Lang anhaltende Buffs anzeigen",
	["Track long duration player buffs?"] = "Zeigt lang anhaltende Spieler Buffs an",
	
	["Scrolling Combat Text Settings"] = "Einstellungen zur Anzeige der Schadenswerte",
	["Combat Text Scroll Speed"] = "Scroll Geschwindigkeit der Schadenswerte",
	["Adjust combat text scroll speed."] = "Ver\195\164nderung der Scroll Geschwindigkeit der Schadenswerte",
	["Display Ability Names"] = "Namen der F\195\164higkeiten anzeigen",
	["Display ability names in combat text?"] = "Zeigt die Namen der F\195\164higkeiten an",
	["Scroll Path Animation"] = "Scroll Animation",
	["Choose scroll animation."] = "Scroll Animation ausw\195\164hlen",
	
	["Damage Tracker Settings"] = "Einstellungen zur Schadensermittlung",
	["Timeout Threshold"] = "Zeit\195\188berschreitung in Sekunden",
	["Number of seconds without damage to signal encounter termination."] = "Anzahl von Sekunden ohne Schaden bevor ein Ende des Kampfes festgestellt wird",
	
	["Reposition FTC Elements"] = "FTC Elemente neu positionieren",
	["Lock Positions"] = "Positionen sperren",
	["Modify FTC frame positions?"] = "FTC Anzeigepositionen ver\195\164ndern",
	
	["Reset Settings"] = "Einstellungen zur\195\188cksetzen",
	["Restore Defaults"] = "Standard wiederherstellen",
	["Restore FTC to default settings."] = "Stellt die FTC Standardeinstellungen wieder her",
	
	--[[---------------------------------
		GAME TRANSLATIONS
	-----------------------------------]]	
	["Drachenritter^m"]					= "Dragonknight",
	["Drachenritterin^f"]				= "Dragonknight",
	["Nachtklinge^m"]					= "Nightblade",
	["Nachtklinge^f"]					= "Nightblade",
	["Zauberer^m"]						= "Sorcerer",
	["Zauberin^f"]						= "Sorcerer",
	["Templer^m"]						= "Templar",
	["Templerin^f"]						= "Templar",

	--[[---------------------------------
		WEAPON ABILITIES
	-----------------------------------]]
	
	-- Sword and Shield
	["Durchsto\195\159^m"] 				= "Puncture",
	["Durchw\195\188hlen^n"] 			= "Ransack",
	["Durchschlag^m"] 					= "Pierce Armor",
	["niederer Schnitt^m"] 				= "Low Slash",
	--[""] 								= "Deep Slash",
	--[""] 								= "Crippling Slash",
	["Schildlauf^m"] 					= "Shield Charge",
	["Invasion^f"]						= "Invasion",
	["Schildsturm^m"]					= "Shielded Assault",
	["Schildsto\195\159^m"] 			= "Power Bash",
	["Schildschlag^m"]					= "Power Slam",
	["widerhallender Schlag^m"]			= "Reverberating Bash",
	
	-- Dual Wield
	["Doppelschnitte^p"] 				= "Twin Slashes",
	["Blutwahn^m"] 						= "Blood Craze",
	["Trennschnitte^p"] 				= "Rending Slashes",	
	["schnelle St\195\182\195\159e^p"] 	= "Rapid Strikes",
	--[""] 								= "Sparks",
	--[""] 								= "Heated Blades",
	--[""] 								= "Ember Explosion",
	--[""] 								= "Whirling Blades",
	["verborgene Klinge^f"] 			= "Hidden Blade",
	--[""] 								= "Flying Blade",
	--[""] 								= "Shrouded Daggers",
	
	-- Two Handed
	["Trennen^n"] 						= "Cleave",
	["Schl\195\164ger^m"] 				= "Brawler",
	["Schnitzen^n"] 					= "Carve",
	["kritisches Toben^n"] 				= "Stampede",
	["Aufw\195\164rtsschnitt^m"] 		= "Uppercut",
	--[""] 								= "Wrecking Blow",
	--[""] 								= "Dizzying Swing",
	["Momentum^n"] 						= "Momentum",
	--[""] 								= "Forward Momentum",
	--[""] 								= "Rally",
	
	-- Bow
	["Giftpfeil^m"] 					= "Poison Arrow",
	--[""] 								= "Venom Arrow",
	--[""] 								= "Poison Injection",
	["Pfeilsalve^f"] 					= "Volley",
	--[""] 								= "Scorched Earth",
	--[""] 								= "Arrow Barrage",
	["Trennschuss^m"] 					= "Scatter Shot",
	--[""] 								= "Magnum Shot",
	--[""] 								= "Draining Shot",
	["Pfeilf\195\164cher^m"] 			= "Arrow Spray",
	--[""] 								= "Bombard",
	--[""] 								= "Acid Spray",
	--[""] 								= "Lethal Arrow",
	--[""] 								= "Focused Aim",
	
	-- Restoration Staff
	["gro\195\159e Heilung^f"] 			= "Grand Healing",
	["heilende Quellen^f"]				= "Healing Springs",
	["erhabene Heilung^f"] 				= "Illustrious Healing",
	["Regeneration^f"] 					= "Regeneration",
	["Mutagen^n"] 						= "Mutagen",
	["rasche Regeneration^f"] 			= "Rapid Regeneration",
	["Segen des Schutzes^m"] 			= "Blessing of Protection",
	["Segen der Wiederherstellung^m"]	= "Blessing of Restoration",
	["Kampfgebet^m"] 					= "Combat Prayer",
	["standhafter Schutz^m"] 			= "Steadfast Ward",
	["verb\195\188ndeten sch\195\188tzen^m"] = "Ward Ally",
	["heilender Schutz^m"] 				= "Healing Ward",
	["Kraftabsaugung^f"] 				= "Force Siphon",
	--[""] 								= "Siphon Spirit",
	--[""] 								= "Quick Siphon",
	
	-- Destruction Staff
	["Schw\195\164che gegen die Elemente^f"] = "Weakness to Elements",
	["elementare Anf\195\164lligkeit^f"] = "Elemental Succeptibility",
	["elementarer Entzug^m"] 			= "Elemental Drain",
	
	--[[---------------------------------
		SORCERER
	-----------------------------------]]
	
	-- Daedric Summoning
	["daedrischer Fluch^m"] 			= "Daedric Curse",
	["b\195\182sartiger Fluch^m"] 		= "Velocious Curse",
	["explosiver Fluch^m"] 				= "Explosive Curse",
	["beschworener Schutz^m"] 			= "Conjured Ward",
	["Sturmatronachen beschw\195\182ren^N"]	= "Summon Storm Atronach",
	["gr\195\182\195\159erer Sturmatronach^N"]	= "Greater Storm Atronach",
	["geladenen Atronachen beschw\195\182ren^N"] = "Summon Charged Atronach",
	
	-- Storm Calling
	["Magierzorn^m"] 					= "Mages Fury",
	["Magierrage^m"] 					= "Mages Wrath",
	["endloser Zorn^m"] 				= "Endless Fury",
	["Blitzgestalt^f"] 					= "Lightning Form",
	["donnernde Pr\195\164senz^m"] 		= "Boundless Storm",
	["grenzenloser Sturm^m"] 			= "Thundering Presence",
	["Blitzfeld^n"] 					= "Lightning Splash",
	["Blitzflut^f"] 					= "Lightning Flood",
	["Woge^f"] 							= "Surge",
	["Funkenschlag^m"]					= "Bolt Escape",
	["Blitzschlag^m"] 					= "Streak",
	["Funkenzug^m"] 					= "Ball of Lightning",
	
	-- Dark Magic
	["Kristallscherbe^f"] 				= "Crystal Shard",
	["Kristallfragmente^p"] 			= "Crystal Fragments",
	["Kristallexplosion^p"] 			= "Crystal Blast",
	["Einh\195\188llen^n"]				= "Encase",
	["zersplitterndes Gef\195\164ngnis^n"] 	= "Restraining Prison",
	["zur\195\188ckhaltendes Gef\195\164ngnis^n"]	= "Shattering Prison",
	["Runengef\195\164ngnis^n"] 		= "Rune Prison",	
	["daedrische Minen^p"] 				= "Daedric Mines",
	["daedrisches Minenfeld^p"]			= "Daedric Minefield",
	["dunkler Austausch^m"] 			= "Daedric Tomb",
	["Magienegation^f"]					= "Negate Magic",
	["Unterdr\195\188ckungsfeld^n"] 	= "Suppression Field",
	["Absorbtionsfeld^n"] 				= "Absorption Field",	
	
	--[[---------------------------------
		DRAGONKNIGHT
	-----------------------------------]]
	
	-- Ardent Flame
	["st\195\164rkende Ketten^p"]		= "Empowering Chains",	
	["versengender Schlag^m"] 			= "Searing Strike", 			
	["instabile Flamme^f"] 				= "Unstable Flame", 			
	["brennende Glut^f"] 				= "Burning Embers",				
	["feuriger Odem^m"] 				= "Fiery Breath",			
	["brennender Odem^m"] 				= "Burning Breath",			
	["einh\195\188llende Flammen^p"] 	= "Engulfing Flames",			
	["Drachenritter-Standarte^f"]		= "Dragonknight Standard",	
	["Standarte der Macht^f"] 			= "Standard of Might",		
	["bewegliche Standarte^f"]			= "Shifting Standard",		
	
	-- Earthen Heart
	["Steinfaust^f"]					= "Stonefist",			
	["Steinriese^m"]					= "Stone Giant",				
	["Obsidianscherbe^f"]				= "Obsidian Shard",				
	["Obsidianschild^m"]				= "Obsidian Shield", 		
	--[""]								= "Igneous Shield", 			
	--[""]								= "Fragmented Shield", 		
	["Versteinern^n"]					= "Petrify", 				
	-- [""]								= "Fossilize",				
	-- [""]								= "Shattering Rocks",			
	["Aschenwolke^f"]					= "Ash Cloud", 				
	["Schlackensturm^m"]				= "Cinder Storm", 			
	-- [""]								= "Eruption", 					
	["Magmar\195\188stung"]				= "Magma Armor", 			
	["Magmaschale^f"]					= "Magma Shell", 			
	["korrosive R\195\188stung^f"]		= "Corrosive Armor", 		

	-- Draconic Power
	["gespickte R\195\188stung^f"]		= "Spiked Armor",			
	["Klingenr\195\188stung^f"]			= "Razor Armor", 			
	["explosive R\195\188stung^f"]		= "Volatile Armor", 			
	["dunkle Krallen^p"]				= "Dark Talons", 			
	["brennende Krallen^p"]				= "Burning Talons", 			
	["w\195\188rgende Krallen^p"]		= "Choking Talons",			
	["Drachenblut^n"]					= "Dragon Blood", 			
	["gr\195\188nes Drachenblut^n"]		= "Green Dragon Blood",		
	["gerinnendes Blut^n"]				= "Coagulating Blood",		
	["reflektierende Schuppe^f"]		= "Reflective Scale", 		
	--[""]								= "Dragon Fire Scale", 		
	--[""]								= "Reflective Plate", 	

	--[[---------------------------------
		NIGHTBLADE
	-----------------------------------]]
	
	--[[---------------------------------
		TEMPLAR
	-----------------------------------]]
	
	--[[---------------------------------
		ARMOR
	-----------------------------------]]
	
	--[[---------------------------------
		GUILDS
	-----------------------------------]]
	
	--[[---------------------------------
		WORLD
	-----------------------------------]]
	
	--[[---------------------------------
		AVA
	-----------------------------------]]
	
	--[[---------------------------------
		EFFECT FILTERS
	-----------------------------------]]
	["Segen:"]							= "Boon:",
	["Vampirismus^m"]					= "Vampirisim",
	["Lykanthropie^f"]					= "Lycanthropy",
	--[""]								= "Spirit Armor",
	--[""]								= "Brace (Generic)",
	["Kampfgeist^m"]					= "Keep Bonus",
	["Schriften"]						= "Scroll Bonus",
	["Kaiserlich"]						= "Emperorship",
	--[""]								= "Increase Max",
}