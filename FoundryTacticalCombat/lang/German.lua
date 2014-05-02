
--[[----------------------------------------------------------
	GERMAN TRANSLATIONS
	-- 	Special thanks are due to MerlinGer, Rakke, Xianlung, and Rial for their assistance with German localization.
	--	ä 	\195\164
	--	Ä 	\195\132
	--	ö 	\195\182
	--	Ö 	\195\150
	--	ü 	\195\188
	--	Ü 	\195\156
	--	ß 	\195\159
	
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
	["Please use this menu to configure addon options."] = "",
	["Reloads UI"] = "",
	
	["Configure Components"] = "",
	["Enable Frames"] = "",
	["Enable custom unit frames component?"] = "",
	["Enable Buffs"] = "",
	["Enable active buff tracking component?"] = "",
	["Enable Damage Statistics"] = "",
	["Enable damage statistics?"] = "",
	["Enable Combat Text"] = "",
	["Enable scrolling combat text component?"] = "",
	
	["Unit Frames Settings"] = "",
	["Show Default Target Frame"] = "",
	["Show the default ESO target unit frame?"] = "",
	["Default Unit Frames Text"] = "",
	["Display text attribute values on default unit frames?"] = "",
	["Show Player Nameplate"] = "",
	["Show your own character's nameplate?"] = "",
	["Enable Mini Experience Bar"] = "",
	["Show a small experience bar on the player frame?"] = "",
	
	["Buff Tracker Settings"] = "",
	["Anchor Buffs"] = "",
	["Anchor buffs to unit frames?"] = "",
	["Display Long Buffs"] = "",
	["Track long duration player buffs?"] = "",
	
	["Scrolling Combat Text Settings"] = "",
	["Combat Text Scroll Speed"] = "",
	["Adjust combat text scroll speed."] = "",
	["Display Ability Names"] = "",
	["Display ability names in combat text?"] = "",
	["Scroll Path Animation"] = "",
	["Choose scroll animation."] = "",
	
	["Damage Tracker Settings"] = "",
	["Timeout Threshold"] = "",
	["Number of seconds without damage to signal encounter termination."] = "",
	
	["Reposition FTC Elements"] = "",
	["Lock Positions"] = "",
	["Modify FTC frame positions?"] = "",
	
	["Reset Settings"] = "",
	["Restore Defaults"] = "",
	["Restore FTC to default settings."] = "",
	
	--[[---------------------------------
		GAME TRANSLATIONS
	-----------------------------------]]
	--[""]								= "Dragonknight",
	--[""]								= "Nightblade",
	--[""]								= "Sorcerer",
	--[""]								= "Templar",

	
	--[[---------------------------------
		WEAPON ABILITIES
	-----------------------------------]]
	
	-- Sword and Shield
	["Durchsto\195\159^m"] 				= "Puncture",
	--[""] 								= "Ransack",
	["Durchschlag^m"] 					= "Pierce Armor",
	["niederer Schnitt^m"] 				= "Low Slash",
	--[""] 								= "Deep Slash",
	--[""] 								= "Crippling Slash",
	["Schildlauf^m"] 					= "Shield Charge",
	--[""]								= "Invasion",
	--[""]								= "Shielded Assault",
	["Schildsto\195\159^m"] 			= "Power Bash",
	--[""]								= "Power Slam",
	--[""]								= "Reverberating Bash",
	
	-- Dual Wield
	["Doppelschnitte^p"] 				= "Twin Slashes",
	--[""] 								= "Blood Craze",
	--[""] 								= "Rending Slashes",	
	["schnelle St\195\182\195\159e^p"] 	= "Rapid Strikes",
	--[""] 								= "Sparks",
	--[""] 								= "Heated Blades",
	--[""] 								= "Ember Explosion",
	--[""] 								= "Whirling Blades",
	--[""] 								= "Hidden Blade",
	--[""] 								= "Flying Blade",
	--[""] 								= "Shrouded Daggers",
	
	-- Two Handed
	["Trennen^n"] 						= "Cleave",
	--[""] 								= "Brawler",
	--[""] 								= "Carve",
	--[""] 								= "Stampede",
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
	--[""] 								= "Elemental Succeptibility",
	--[""] 								= "Elemental Drain",
	
	--[[---------------------------------
		CLASS ABILITIES
	-----------------------------------]]
	
	-- Sorcerer Daedric Summoning
	["daedrischer Fluch^m"] 			= "Daedric Curse",
	["b\195\182sartiger Fluch^m"] 		= "Velocious Curse",
	["explosiver Fluch^m"] 				= "Explosive Curse",
	["beschworener Schutz^m"] 			= "Conjured Ward",
	["Sturmatronachen beschw\195\182ren^N"]	= "Summon Storm Atronach",
	["gr\195\182\195\159erer Sturmatronach^N"]	= "Greater Storm Atronach",
	["geladenen Atronachen beschw\195\182ren^N"] = "Summon Charged Atronach",
	
	-- Sorcerer Storm Calling
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
	
	-- Sorcerer Dark Magic
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
		EFFECT FILTERS
	-----------------------------------]]
	--[""]								= "Boon:",
	["Vampirismus^m"]					= "Vampirisim",
	--[""]								= "Lycanthropy",
	--[""]								= "Spirit Armor",
	--[""]								= "Brace (Generic)",
	--[""]								= "Keep Bonus",
	--[""]								= "Scroll Bonus",
	--[""]								= "Emperorship",
}