 --[[----------------------------------------------------------
	ACTIVE BUFF EFFECTS
	* Get a custom buff/debuff effect when the player casts a spell
	* Effects are listed as [name] = { target ( 1 == player , 2 == target ) , type ( 1 == buff, 2 == debuff ) , duration (in seconds) , reqTarget , delay or cast time
	* List multiple effects as sub-tables
	]]-----------------------------------------------------------
	
FTC.Buffs.Effects = {
		
	--[[---------------------------------
		WEAPON SKILLS
	-----------------------------------]]
	
	-- Sword and Shield
	["Puncture"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15 , true , nil } },
	["Ransack"]					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15 , true , nil } },
	["Pierce Armor"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15 , true , nil } },
	
	["Low Slash"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 12 , true , nil } },
	["Deep Slash"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 12 , true , nil } },
	["Crippling Slash"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 9 , true , nil } },
	
	["Shield Charge"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2 , true , 0.5 } },
	["Invasion"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , 0.5 } },
	["Shielded Assault"]		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2 , true , 0.5 }, { 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , 0.5 } },
	
	["Power Bash"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , true , 0 } },
	["Power Slam"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15 , true , 0 } },
	["Reverberating Bash"]		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , true , 0 } },
	
	-- Dual Wield
	["Twin Slashes"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 9 , true , nil } },
	["Blood Craze"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 9 , true , nil } , { 1 , BUFF_EFFECT_TYPE_BUFF , 9 , true , nil } },
	["Rending Slashes"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 9 , true , nil } },	
	
	["Rapid Strikes"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , 1.5 } },
	
	["Sparks"] 					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , true , nil } },
	["Heated Blades"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , true , nil } },
	["Ember Explosion"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , false , nil } },
	
	["Whirling Blades"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , false , nil } },
	
	["Hidden Blade"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , true , nil } },
	["Flying Blade"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , true , nil } },
	["Shrouded Daggers"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , false , nil } },
	
	-- Two Handed
	["Cleave"] 					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , false , nil } },
	["Brawler"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , false , nil } , { 1 , BUFF_EFFECT_TYPE_BUFF , 8 , true , nil } },
	["Carve"] 					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , false , nil } },
	
	["Stampede"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3.5 , true , 0.5 } },
	
	["Uppercut"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3.5 , true , 1.5 } },
	["Wrecking Blow"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3.5 , true , 1.5 } },
	["Dizzying Swing"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 7.5 , true , 1.5 } },
	
	["Momentum"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 23 , false , nil } },
	["Forward Momentum"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 23 , false , nil } },
	["Rally"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 23 , false , nil } },
	
	-- Bow
	["Poison Arrow"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , nil } },
	["Venom Arrow"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , nil } },
	["Poison Injection"]		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , nil } },
	
	["Volley"]					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , false , nil } },
	["Scorched Earth"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , false , nil } },
	["Arrow Barrage"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , false , nil } },
	
	["Scatter Shot"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , true , nil } },
	["Magnum Shot"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , true , nil } },
	["Draining Shot"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , true , nil } },
	
	["Arrow Spray"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , false , nil } },
	["Bombard"]					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , false , nil } },
	["Acid Spray"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , false , nil } },
	
	["Lethal Arrow"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , 3.5 } },
	["Focused Aim"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , 3.5 } },
	
	-- Restoration Staff
	["Grand Healing"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3 , false , nil } },
	["Healing Springs"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3 , false , nil } },
	["Illustrious Healing"] 	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	
	["Regeneration"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Mutagen"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Rapid Regeneration"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 16.5 , false , nil } },
	
	["Blessing of Protection"] 	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },
	["Blessing of Restoration"] = {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },
	["Combat Prayer"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },
	
	["Steadfast Ward"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	["Ward Ally"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	["Healing Ward"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	
	["Force Siphon"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 20 , true , nil } },
	["Siphon Spirit"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 20 , true , nil } },
	["Quick Siphon"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 20 , true , nil } },
	
	-- Destruction Staff
	["Weakness to Elements"] 	= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , true , nil } },
	["Elemental Susceptibility"]= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , true , nil } },
	["Elemental Drain"] 	    = {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , true , nil } },
	
	--[[---------------------------------
		SORCERER
	-----------------------------------]]
	
	-- Daedric Summoning
	["Daedric Curse"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , true , nil } },
	["Velocious Curse"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3.5 , true , nil } },
	["Explosive Curse"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , true , nil } },
	
	["Conjured Ward"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Empowered Ward"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Hardened Ward"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	["Summon Storm Atronach"] 	= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , false , nil } },
	["Greater Storm Atronach"]  = {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 28 , false , nil } },
	["Summon Charged Atronach"] = {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , false , nil } },	
	
	-- Storm Calling
	["Mages Fury"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , true , nil } },
	["Mages Wrath"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , true , nil } },
	["Endless Fury"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , true , nil } },	
	
	["Lightning Form"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	["Boundless Storm"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	["Thundering Presence"] 	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },
	
	["Lightning Splash"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , false , nil } },
	["Liquid Lightning"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , false , nil } },
	["Lightning Flood"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , false , nil } },	
	
	["Surge"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Critical Surge"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Power Surge"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 40 , false , nil } },	
	
	["Bolt Escape"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2 , false , nil } },
	["Streak"] 					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2 , false , nil } },
	["Ball of Lightning"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2 , false , nil }, { 1 , BUFF_EFFECT_TYPE_BUFF , 5 , false , nil } },	

	-- Dark Magic
	["Crystal Shard"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2.4 , true , 2 } },
	["Crystal Fragments"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2.4 , true , 2 } },
	["Crystal Blast"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 2.4 , true , 2 } },
	
	["Encase"] 					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6.4 , false , nil } },
	["Restraining Prison"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 12.4 , false , nil } },
	["Shattering Prison"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5.4 , false , nil } },
	
	["Rune Prison"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 19.9 , true , 1.5 } },
	["Weakening Prison"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 19.9 , true , 1.5 } },
	["Rune Cage"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 19.9 , true , 1.5 } },
	
	["Daedric Mines"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 36 , false , nil } },
	["Daedric Minefield"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 36 , false , nil } },
	["Daedric Tomb"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 36 , false , nil } },
	
	["Dark Exchange"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	["Dark Conversion"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	["Dark Deal"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	
	["Negate Magic"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 11.4 , false , nil } },
	["Suppression Field"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 11.4 , false , nil } },
	["Absorption Field"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 11.4 , false , nil } },
	
	--[[---------------------------------
		DRAGONKNIGHT
	-----------------------------------]]
	
	-- Ardent Flame
	["Empowering Chain"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 24 , false , nil } },
	
	["Searing Strike"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10.5 , true , nil } },
	["Unstable Flame"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10.5 , true , nil } },
	["Burning Embers"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 10.5 , true , nil } },
	
	["Fiery Breath"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , false , nil } },
	["Burning Breath"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , false , nil } },
	["Engulfing Flames"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , false , nil } },
	
	["Dragonknight Standard"] 	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 17 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 17 , false , nil } },
	["Standard of Might"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 17 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 17 , false , nil } },
	["Shifting Standard"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 17 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 17 , false , nil } },
	
	-- Earthen Heart
	["Stonefist"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3.6 , true , 0.5 } },
	["Stone Giant"]				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3.6 , true , 0.5 }, { 1 , BUFF_EFFECT_TYPE_BUFF , 4.8 , true , nil } },
	["Obsidian Shard"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3.6 , true , 0.5 } },
	
	["Obsidian Shield"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 24 , false , nil } },
	["Igneous Shield"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 24 , false , nil } },
	["Fragmented Shield"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 24 , false , nil } },
	
	["Petrify"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 14.4 , true , nil } },
	["Fossilize"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 14.4 , true , nil } },
	["Shattering Rocks"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 14.4 , true , nil } },
	
	["Ash Cloud"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , false , nil } },
	["Cinder Storm"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , false , nil } },
	["Eruption"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 18 , false , nil } },
	
	["Magma Armor"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 14.4 , false , nil } },
	["Magma Shell"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 14.4 , false , nil } },
	["Corrosive Armor"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 14.4 , false , nil } },

	-- Draconic Power
	["Spiked Armor"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Razor Armor"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Volatile Armor"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	["Dark Talons"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , false , nil } },
	["Burning Talons"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , false , nil } },
	["Choking Talons"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , false , nil } },
	
	["Dragon Blood"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Green Dragon Blood"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Coagulating Blood"]		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	["Reflective Scale"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	["Dragon Fire Scale"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	["Reflective Plate"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	
	--[[---------------------------------
		NIGHTBLADE
	-----------------------------------]]
	
	-- Assassination
	["Teleport Strike"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 1.5 , true , 0.8 } },
	["Ambush"] 					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 1.5 , true , 0.8 } },
	["Lotus Fan"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , false , 0.8 } },	
	
	["Blur"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 26 , false , nil } },
	["Mirage"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 26 , false , nil } },
	["Double Take"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 26 , false , nil } },
	
	["Mark Target"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 60 , true , nil } },
	["Piercing Mark"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 60 , true , nil } },
	["Reaper's Mark"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 60 , true , nil } },
	
	["Haste"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Focused Attacks"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Incapacitate"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	["Death Stroke"] 			= {	{ 1 , BUFF_EFFECT_TYPE_DEBUFF , 5 , true , nil } },
	["Incapacitating Strike"] 	= {	{ 1 , BUFF_EFFECT_TYPE_DEBUFF , 5 , true , nil } },
	["Soul Harvest"] 			= {	{ 1 , BUFF_EFFECT_TYPE_DEBUFF , 5 , true , nil } },	

	-- Siphoning
	["Strife"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , true , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , nil } },
	["Swallow Soul"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , true , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , nil } },
	["Funnel Health"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , true , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , true , nil } },
	
	["Agony"] 					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 12 , true , 1.5 } },
	["Prolonged Suffering"]		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 12 , true , 1.5 } },
	["Malefic Wreath"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 12 , false , 1.5 } },	
	
	["Cripple"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , true , nil } },
	["Debilitate"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , true , nil } },
	["Crippling Grasp"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 8 , true , nil } },
	
	["Drain Power"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Power Extraction"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Sap Essence"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	["Soul Shred"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.5 , false , nil } },
	["Soul Tether"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.5 , false , nil }, { 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },
	["Soul Siphon"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.5 , false , nil }, { 1 , BUFF_EFFECT_TYPE_BUFF , 3 , false , nil } },
																	
	-- Shadow
	["Shadow Cloak"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 2.9 , false , nil } },
	["Shadowy Disguise"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 2.9 , false , nil } },
	["Dark Cloak"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 2.9 , false , nil } },
	
	["Veiled Strike"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.6 , true , nil } },
	["Surprise Attack"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 12 , true , nil } },
	["Concealed Weapon"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.6 , true , nil } },
	
	["Path of Darkness"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , false , nil } },
	["Twisting Path"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , false , nil } },
	["Refreshing Path"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 10 , false , nil } },
	
	["Aspect of Terror"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.5 , false , nil } },
	["Mass Hysteria"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.5 , false , nil } },
	["Manifestation of Terror"] = {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 4.5 , false , nil } },
	
	["Summon Shade"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 23 , false , nil } },
	["Dark Shades"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 23 , false , nil } },
	["Shadow Image"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 23 , false , nil } },
	
	["Consuming Darkness"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 17.3 , false , nil } },
	["Bolstering Darkness"] 	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 17.3 , false , nil } },
	["Veil of Blades"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 17.3 , false , nil }, { 2 , BUFF_EFFECT_TYPE_DEBUFF , 17.3 , false , nil } },
	
	--[[---------------------------------
		TEMPLAR
	-----------------------------------]]
	
	-- Aedric Spear
	["Piercing Javelin"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	["Aurora Javelin"]      	= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	["Binding Javelin"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	
	["Empowering Sweep"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , false , nil } },
	
	["Focused Charge"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	["Explosive Charge"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	["Toppling Charge"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 1.5 , true , nil } },
	
	["Sun Shield"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	["Radiant Ward"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	["Blazing Shield"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	
	-- Dawn's Wrath
	["Sun Fire"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5.3 , true , 0.5 } },
	["Reflective Light"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5.3 , true , 0.5 } },
	["Vampire's Bane"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 7.8 , true , 0.5 } },
	
	["Dark Flare"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 7.2 , true , 1.5 } },
	
	["Eclipse"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , true , nil } },
	["Total Dark"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 13.2 , true , nil } },
	["Unstable Core"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 6 , true , nil } },

	["Backlash"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 7.2 , true , 1.5 } },
	["Power of the Light"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 7.2 , true , 1.5 } },
	["Purifying Light"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 7.2 , true , 1.5 }, { 1 , BUFF_EFFECT_TYPE_BUFF , 8.4 , true , 1.5 } },
	
	-- Restoring Light
	["Honor The Dead"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },	
	
	["Lingering Ritual"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , 2 } },	

	["Rite of Passage"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	["Remembrance"]				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	["Practiced Incarnation"]   = {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	
	["Restoring Aura"]			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 9 , false , nil } },	
	["Radiant Aura"]    		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 9 , false , nil } },	

	["Cleansing Ritual"]    	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 12 , false , nil } },	
	["Purifying Ritual"]    	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 12 , false , nil } },	
	["Extended Ritual"]    		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 22 , false , nil } },		

	["Rune Focus"]    			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 15 , false , nil } },	
	["Channeled Focus"]    		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 18 , false , nil } },	
	["Restoring Focus"]    		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 18 , false , nil } },		
		
	--[[---------------------------------
		ARMOR
	-----------------------------------]]

	-- Heavy Armour
	["Immovable"]				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },
	["Immovable Brute"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 8 , false , nil } },
	["Unstoppable"]				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10.8 , false , nil } },	
	
	-- Medium Armor
	["Evasion"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Elude"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 25 , false , nil } },
	["Shuffle"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	-- Light Armour
	["Annulment"]				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Dampen Magic"]			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Harness Magicka"]			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },	

	--[[---------------------------------
		GUILDS
	-----------------------------------]]
	
	-- Fighters Guild
	["Expert Hunter"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 15 , false , nil } },
	
	-- Mages Guild
	["Entropy"]					= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15.6 , true , nil } },
	["Degeneration"]			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15.6 , true , nil } , { 1 , BUFF_EFFECT_TYPE_BUFF , 15.6 , true , nil } },
	["Structured Entropy"]		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15.6 , true , nil } },
	
	-- Undaunted
	["Inner Fire"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15 , true , nil } },
	["Inner Rage"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15 , true , nil } },
	["Inner Beast"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 15 , true , nil } },
	
	--[[---------------------------------
		WORLD
	-----------------------------------]]
	
	-- Vampire
	["Drain Essence"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3 , true , nil } , { 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	["Invigorating Drain"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3 , true , nil } , { 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	["Midnight Drain"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3 , true , nil } , { 2 , BUFF_EFFECT_TYPE_DEBUFF , 3 , true , nil } },
	
	["Mist Form"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3.5 , false , nil } },
	["Elusive Mist"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } },
	["Poison Mist"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 4 , false , nil } , { 2 , BUFF_EFFECT_TYPE_DEBUFF , 4 , false , nil } },
	
	["Bat Swarm"] 				= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , false , nil } },
	["Devouring Swarm"] 		= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , false , nil } },
	["Clouding Swarm"] 			= {	{ 2 , BUFF_EFFECT_TYPE_DEBUFF , 5 , false , nil } },
	
	--[[---------------------------------
		AVA
	-----------------------------------]]
	
	-- Support
	["Purge"] 					= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3 , false , nil } },
	["Efficient Purge"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 3 , false , nil } },
	["Cleanse"] 				= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 6 , false , nil } },
	
	["Siege Shield"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 17 , false , nil } },
	["Siege Weapon Shield"] 	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Propelling Shield"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	["Barrier"] 				= { { 1 , BUFF_EFFECT_TYPE_BUFF , 30 , false , nil } },
	["Reviving Barrier"] 		= { { 1 , BUFF_EFFECT_TYPE_BUFF , 30 , false , nil } },
	["Replenishing Barrier"] 	= { { 1 , BUFF_EFFECT_TYPE_BUFF , 30 , false , nil } },
	
	-- Assault
	["Rapid Maneuver"] 			= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Retreating Maneuver"] 	= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	["Charging Maneuver"] 		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 20 , false , nil } },
	
	["Caltrops"] 				= { { 2 , BUFF_EFFECT_TYPE_DEBUFF , 30 , false , nil } },
	["Anti-Cavalry Caltrops"] 	= { { 2 , BUFF_EFFECT_TYPE_DEBUFF , 30 , false , nil } },
	["Razor Caltrops"] 			= { { 2 , BUFF_EFFECT_TYPE_DEBUFF , 30 , false , nil } },
	
	["War Horn"] 				= { { 1 , BUFF_EFFECT_TYPE_BUFF , 30 , false , nil } },
	["Aggressive Horn"] 		= { { 1 , BUFF_EFFECT_TYPE_BUFF , 30 , false , nil } },
	["Sturdy Horn"] 			= { { 1 , BUFF_EFFECT_TYPE_BUFF , 30 , false , nil } },
}

--[[ 
 * Checks whether an ability is a ground-targetted spell
 ]]--
function FTC.Buffs:IsGroundTarget( name )
	local gts = { 
		'Negate Magic',
		'Absorption Field',
		'Suppression Field',
		'Summon Storm Atronach',
		'Summon Charged Atronach',
		'Greater Storm Atronach',
		'Lightning Splash',
		'Liquid Lightning',
		'Lightning Flood',
		'Nova',
		'Solar Prison',
		'Solar Disturbance',
		'Spear Shards',
		'Luminous Shards',
		'Blazing Spear',
		'Volley',
		'Scorched Earth',
		'Arrow Barrage',
		'Grand Healing',
		'Healing Springs',
		'Illustrious Healing',
		'Fire Rune',
		'Volcanic Rune',
		'Scalding Rune',
		'Caltrops',
		'Razor Caltrops',
		'Anti-Cavalry Caltrops'
	}
	for i = 1 , #gts do
		if ( name == gts[i] ) then return true end
	end	
	return false
end

--[[ 
 * Checks whether an ability is a toggle
 ]]--
function FTC.Buffs:IsToggle( name )
	local toggles = { 
		'Unstable Familiar',
		'Unstable Clannfear',
		'Volatile Familiar',
		'Summon Winged Twilight',
		'Summon Restoring Twilight',
		'Summon Twilight Matriarch',
		'Siphoning Strikes',
		'Leeching Strikes',
		'Siphoning Attacks',
		'Magelight',
		'Inner Light',
		'Radiant Magelight',
		'Bound Armor',
		'Bound Armaments',
		'Bound Aegis',
		'Inferno',
		'Flames Of Oblivion',
		'Sea Of Flames'
	}
	for i = 1 , #toggles do
		if ( name == toggles[i] ) then return true end
	end	
	return false
end

--[[ 
 * Checks whether an ability incorporates a damage shield that should be purged when it expires
 ]]--
function FTC.Buffs:IsDamageShield( name )
	local shields = { 
		'Obsidian Shield',
		'Igneous Shield',
		'Fragmented Shield',
		'Conjured Ward',
		'Hardened Ward',
		'Empowered Ward',
		'Sun Shield',
		'Radiant Ward',
		'Blazing Shield',
		'Brawler',
		'Barrier',
		'Reviving Barrier',
		'Replenishing Barrier',
		'Steadfast Ward',
		'Ward Ally',
		'Healing Ward',
		'Annulment',
		'Dampen Magic',
		'Harness Magicka',
	}
	for i = 1 , #shields do
		if ( name == shields[i] ) then return true end
	end	
	return false
end


--[[ 
 * Filter abilities to override their displayed names or durations as necessary
 ]]--
function FTC:FilterBuffInfo( changeType , unitTag , name , buffType , beginTime , endTime )
	
	-- Default to no duration
	local duration 	= nil
	local isValid	= true
	
	-- Untyped Abilities (0)
	if ( buffType == ABILITY_TYPE_NONE ) then
	
		-- Summons and Toggles
		if ( FTC.Buffs:IsToggle( name ) ) then duration = "T" end
		
	-- "Bonus" Abilities (5)
	elseif ( buffType == ABILITY_TYPE_BONUS ) then
	
		-- Mundus Stones
		if ( string.match( name , "Boon: " ) ) then
			if ( unitTag == 'player' ) then	duration = "P"
			else isValid = false end
		
		-- Ignore Cyrodiil Bonuses
		elseif ( string.match( name , "Keep Bonus" ) or string.match( name , "Scroll Bonus" ) or string.match( name , "Emperorship" ) ) then
			if ( unitTag == 'player' ) then	duration = "P"
			else isValid = false end
			
		-- Lycanthropy
		elseif ( name == "Lycanthropy" ) then duration = "P" end
		
	-- Blocking (52)
	elseif ( ( buffType == ABILITY_TYPE_BLOCK ) or ( name == "Brace (Generic)" ) ) then
		name		= "Blocking"
		duration 	= "T"

	-- Change Appearance ( 64 )
	elseif ( ( buffType == ABILITY_TYPE_CHANGEAPPEARANCE ) ) then duration	= "T" end
		
	-- Return the filtered info
	return isValid, name, duration , beginTime , endTime
end


--[[ 
 * Double check that the slot is actually eligible for use
 ]]--
function FTC.Buffs:HasFailure( slotIndex )
	if ( HasCostFailure( slotIndex ) ) then return true
	elseif ( HasRequirementFailure( slotIndex ) ) then return true
	elseif ( HasWeaponSlotFailure( slotIndex ) ) then return true
	elseif ( HasTargetFailure( slotIndex ) ) then return true
	elseif ( HasRangeFailure( slotIndex ) ) then return true
	elseif ( HasStatusEffectFailure( slotIndex )  ) then return true
	elseif ( HasFallingFailure( slotIndex ) ) then return true
	elseif ( HasSwimmingFailure( slotIndex ) ) then return true
	elseif ( HasMountedFailure( slotIndex ) ) then return true
	elseif ( HasReincarnatingFailure( slotIndex ) ) then return true end
	return false
end