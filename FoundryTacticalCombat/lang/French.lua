
--[[----------------------------------------------------------
	FRENCH TRANSLATIONS
	-- 	Special thanks are due to Rakke, and Zuhligan for their assistance with French localization.
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
	["FTC Settings"] = "",
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
	["Lame noire^f"]					= "Nightblade",
	["Sorcier^m"]						= "Sorcerer",
	--[""]								= "Templar",

	--[[---------------------------------
		WEAPON ABILITIES
	-----------------------------------]]
	
	-- Sword and Shield
	["Perforation^f"] 					= "Puncture",
	["Mise \195\160 sac^f"] 			= "Ransack",
	["Durchschlag^m"] 					= "Pierce Armor",	
	["Coup bas^f"] 						= "Low Slash",
	["Entaille profonde^f"] 			= "Deep Slash",
	["Coup incapacitant^m"] 			= "Crippling Slash",
	["Charge de bouclier^f"]			= "Shield Charge",
	["Invasion^f"]						= "Invasion",
	["Assaut prot\195\169g\195\169^m"]	= "Shielded Assault",
	["Coup de bouclier puissant^m"]		= "Power Bash",
	["Impact puissant^f"]				= "Power Slam",
	["Vibrations^f"]					= "Reverberating Bash",
	
	-- Dual Wield
	["Entailles jumelles^f"] 			= "Twin Slashes",
	["Fr\195\169n\195\169sie sanguinaire^f"] = "Blood Craze",
	["Entailles affaiblissantes^f"] 	= "Rending Slashes",	
	["Coups rapides^f"] 				= "Rapid Strikes",	
	["\195\137tincelles^f"] 			= "Sparks",
	["Lames chauff\195\169es^f"] 		= "Heated Blades",
	["\195\137clatement de braise^f"] 	= "Ember Explosion",
	["Larmes tourbillonnantes^f"] 		= "Whirling Blades",
	["Lame cach\195\169e^f"] 			= "Hidden Blade",
	["Lame volante^f"] 					= "Flying Blade",
	["Dagues voil\195\169es^f"] 		= "Shrouded Daggers",
	
	-- Two Handed
	["Fendoir^f"] 						= "Cleave",
	["Bagarre^f"] 						= "Brawler",
	["D\195\169coupe^f"] 				= "Carve",
	["Pi\195\169tinement^f"] 			= "Stampede",
	["Uppercut^f"] 						= "Uppercut",
	["Ravage^f"] 						= "Wrecking Blow",
	["Moulinet \195\169tourdissant^m"] 	= "Dizzying Swing",
	["\195\137lan^f"] 					= "Momentum",
	["\195\137lan frontal^f"] 			= "Forward Momentum",
	["Ralliement^f"] 					= "Rally",
	
	-- Bow	
	["Fl\195\168che empoisonn\195\169e^f"] = "Poison Arrow",
	["Fl\195\168che venimeuse^f"]		= "Venom Arrow",
	["Injection de poison^f"]			= "Poison Injection",
	["Vol\195\169e^f"]					= "Volley",
	["Terre br\195\187l\195\169e^f"]	= "Scorched Earth",
	["Tir de barrage^f"]				= "Arrow Barrage",
	["Tir group\195\169^f"]				= "Scatter Shot",
	["Gros calibre^f"]					= "Magnum Shot",
	["Tir de ponction^f"]				= "Draining Shot",
	["Fl\195\168ches dispers\195\169es^f"] = "Arrow Spray",
	["Bombarde^f"]						= "Bombard",
	["Dispersion acide^f"]				= "Acid Spray",
	["Fl\195\168che mortelle^f"]		= "Lethal Arrow",
	["Vis\195\169e pr\195\169cise^f"]	= "Focused Aim",
	
	-- Restoration Staff
	["Soins g\195\169n\195\169ralis\195\169s^pm"] = "Grand Healing",
	["Sources curatives^f"] 			= "Healing Springs",
	["Soins illustres^f"] 				= "Illustrious Healing",
	["R\195\169g\195\169n\195\169ration^f"] = "Regeneration",
	["Mutag\195\168ne^m"] 				= "Mutagen",
	["R\195\169g\195\169n\195\169ration rapide^f"] = "Rapid Regeneration",
	["B\195\169n\195\169diction de protection^f"] = "Blessing of Protection",
	["B\195\169n\195\169diction de r\195\169tablissement^f"] = "Blessing of Restoration",
	["Pri\195\168re de combat^f"] 		= "Combat Prayer",
	["D\195\169fense in\195\169branlable^f"] = "Steadfast Ward",
	["Protection d'un alli\195\169^f"] 	= "Ward Ally",
	["Protection curative^f"] 			= "Healing Ward",
	["Siphon de force^m"] 				= "Force Siphon",
	["Siphon d'esprit^m"] 				= "Siphon Spirit",
	["Siphon rapide^m"] 				= "Quick Siphon",
	
	-- Destruction Staff
	["Vuln\195\169rabilit\195\169 aux \195\169l\195\169ments^f"] = "Weakness to Elements",
	["Susceptibilit\195\169 aux \195\169l\195\169ments^f"] = "Elemental Succeptibility",
	["Ponction \195\169l\195\169mentaire^f"] = "Elemental Drain",
	
	--[[---------------------------------
		CLASS ABILITIES
	-----------------------------------]]
	
	--[[---------------------------------
		EFFECT FILTERS
	-----------------------------------]]
	--[""]								= "Boon:",
	--[""]								= "Vampirisim",
	--[""]								= "Lycanthropy",
	--[""]								= "Spirit Armor",
	--[""]								= "Brace (Generic)",
	--[""]								= "Keep Bonus",
	--[""]								= "Scroll Bonus",
	--[""]								= "Emperorship",
}