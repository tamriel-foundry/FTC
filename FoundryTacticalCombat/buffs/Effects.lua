 --[[----------------------------------------------------------
	ACTIVE BUFF EFFECTS
	* Get a custom buff/debuff effect when the player casts a spell
	* Effects are listed as [name] = { buff duration , debuff duration , cast time }
	* Only "exception" effects are stored here, as default cast times and durations are retrieved from the API
	]]-----------------------------------------------------------
	
FTC.Buffs.Effects = {
		
	--[[---------------------------------
		WEAPON SKILLS
	-----------------------------------]]
	
	-- Sword and Shield
	["Puncture"]				= {	0 , 15 , 0 },
	["Ransack"]					= {	0 , 15 , 0 },
	["Pierce Armor"]			= {	0 , 15 , 0 },
	
	["Low Slash"]				= {	0 , 9 , 0 },
	["Deep Slash"]				= {	0 , 12 , 0 },
	["Heroic Slash"]			= {	0 , 12 , 0 },
	
	["Shield Charge"]			= {	0 , 2 , 0.25 },
	["Invasion"]				= {	0 , 3 , 0.25 },
	["Shielded Assault"]		= {	6 , 2 , 0.25 },
	
	["Power Bash"]				= {	0 , 15 , 0 },
	["Power Slam"]				= {	0 , 15 , 0 },
	["Reverberating Bash"]		= {	0 , 10 , 0 },
	
	-- Dual Wield
	["Twin Slashes"] 			= {	0 , 9 , 0 },
	["Blood Craze"] 			= {	9 , 9 , 0 },
	["Rending Slashes"] 		= {	0 , 9 , 0 },
	
	["Rapid Strikes"] 			= {	6 , 0 , 1.3 },
	
	["Whirling Blades"] 		= {	10 , 0 , 0 },
	
	["Hidden Blade"] 			= {	0 , 6 , 0 },
	["Flying Blade"] 			= {	0 , 6 , 0 },
	["Shrouded Daggers"] 		= {	0 , 6 , 0 },

	-- Two Handed
	["Cleave"] 					= { 0 , 10 , 0 },
	["Brawler"] 				= { 8 , 10 , 0 },
	["Carve"] 					= { 0 , 10 , 0 },
	
	["Stampede"] 				= { 0 , 8 , 0.25 },
	
	["Uppercut"] 				= { 0 , 3.5 , 0.8 },
	["Wrecking Blow"] 			= { 0 , 3.5 , 0.8 },
	["Dizzying Swing"] 			= { 0 , 7.5 , 0.8 },
	
	-- Bow
	["Poison Arrow"]			= { 0 , 10 , 0 },
	["Venom Arrow"]				= { 0 , 10 , 0 },
	["Poison Injection"]		= { 0 , 10 , 0 },
	
	["Volley"]					= { 0 , 5 , 1.5 },
	["Scorched Earth"]			= { 0 , 11 , 1.5 },
	["Arrow Barrage"]			= { 0 , 5 , 1.5 },
	
	["Scatter Shot"]			= { 0 , 5 , 0 },
	["Magnum Shot"]				= { 0 , 5 , 0 },
	["Draining Shot"]			= { 0 , 6 , 0 },
	
	["Arrow Spray"]				= { 0 , 5 , 0 },
	["Bombard"]					= { 0 , 5 , 0 },
	["Acid Spray"]				= { 0 , 5 , 0 },
	
	["Lethal Arrow"]			= { 0 , 10 , 1.25 },
	["Focused Aim"]				= { 0 , 10 , 1.25 },
	
	["Blessing of Protection"] 	= { 8 , 0 , 0 },
	["Blessing of Restoration"] = { 15 , 0 , 0 },
	["Combat Prayer"] 			= { 8 , 0 , 0 },
	
	["Force Siphon"] 			= { 0 , 20 , 1.5 },
	["Siphon Spirit"] 			= { 0 , 20 , 1.5 },
	["Quick Siphon"] 			= { 0 , 20 , 0 },
	
	-- Destruction Staff
	["Weakness to Elements"] 	= {	0 , 18 , 0 },
	["Elemental Susceptibility"]= {	0 , 18 , 0 },
	["Elemental Drain"] 	    = {	0 , 18 , 0 },
	
	["Destructive Touch"]		= {	0 , 5 , 0 },
	["Shock Touch"]				= {	0 , 5 , 0 },
	["Frost Touch"]				= {	0 , 5 , 0 },
	["Fire Touch"]				= {	0 , 5 , 0 },

	["Force Shock"]				= {	0 , 5 , 0 },
	["Crushing Shock"]			= {	0 , 5 , 0 },
	["Force Pulse"]				= {	0 , 5 , 0 },

    ["Elemental_Ring"]			= { 0 , 10 , 0 },
    ["Fire_Ring"]				= { 0 , 10 , 0 },
    ["Frost_Ring"]				= { 0 , 10 , 0 },
    ["Shock_Ring"]				= { 0 , 10 , 0 },
    ["Pulsar"] 					= { 0 , 10 , 0 },
    ["Fiery_Pulsar"]			= { 0 , 10 , 0 },
    ["Icy_Pulsar"] 				= { 0 , 10 , 0 },
    ["Electric_Pulsar"] 		= { 0 , 10 , 0 },
	
	--[[---------------------------------
		SORCERER
	-----------------------------------]]
	
	-- Daedric Summoning
	["Daedric Curse"] 			= { 0 , 6 , 0 },
	["Velocious Curse"] 		= { 0 , 3.5 , 0 },
	["Explosive Curse"] 		= { 0 , 6 , 0 },
	
	-- Storm Calling
	["Mages' Fury"] 			= { 0 , 4 , 0 },
	["Mages' Wrath"] 			= { 0 , 4 , 0 },
	["Endless Fury"] 			= { 0 , 4 , 0 },
	
	["Lightning Splash"] 		= { 0 , 6 , 0 },
	["Liquid Lightning"] 		= { 0 , 10 , 0 },
	["Lightning Flood"] 		= { 0 , 6 , 0 },
	
	["Bolt Escape"] 			= { 0 , 2 , 0 },
	["Streak"] 					= { 0 , 2 , 0 },
	["Ball of Lightning"] 		= { 5 , 2 , 0 },

	-- Dark Magic
	["Crystal Shard"] 			= { 0 , 2.4 , 1.3 },
	["Crystal Fragments"] 		= { 0 , 2.4 , 1.3 },
	["Crystal Blast"] 			= { 0 , 2.4 , 1.3 },
	
	["Encase"] 					= { 0 , 5.4 , 0 },
	["Restraining Prison"] 		= { 0 , 10.2 , 0 },
	["Shattering Prison"] 		= { 0 , 5.4 , 0 },
	
	["Rune Prison"] 			= { 0 , 19.9 , 0 },
	["Weakening Prison"] 		= { 0 , 19.9 , 0 },
	["Defensive Rune"] 			= { 144000 , 19.9 , 0 },
	
	["Daedric Mines"] 			= { 0 , 36 , 0 },
	["Daedric Minefield"] 		= { 0 , 36 , 0 },
	["Daedric Tomb"] 			= { 0 , 36 , 0 },
	
	["Dark Exchange"] 			= { 4 , 0 , 0 },
	["Dark Conversion"] 		= { 4 , 0 , 0 },
	["Dark Deal"] 				= { 4 , 0 , 0 },
	
	["Negate Magic"] 			= { 0 , 11.4 , 0 },
	["Suppression Field"] 		= { 11.4 , 11.4 , 0 },
	["Absorption Field"] 		= { 12 , 9.6 , 0 },
	
	--[[---------------------------------
		DRAGONKNIGHT
	-----------------------------------]]
	
	-- Ardent Flame	
	["Searing Strike"] 			= {	0 , 10.5 , 0 },
	["Unstable Flame"] 			= {	0 , 10.5 , 0 },
	["Burning Embers"] 			= {	0 , 10.5 , 0 },
	
	["Fiery Breath"] 			= {	0 , 10 , 0 },
	["Burning Breath"] 			= {	0 , 10 , 0 },
	["Engulfing Flames"] 		= {	0 , 10 , 0 },
	
	-- Earthen Heart
	["Stonefist"]				= {	0 , 3.6 , 0.25 },
	["Stone Giant"]				= {	15 , 3.6 , 0.25 },
	["Obsidian Shard"]			= {	0 , 3.6 , 0.25 },
	
	["Petrify"] 				= {	0 , 20 , 0 },
	["Fossilize"] 				= {	0 , 20 , 0 },
	["Shattering Rocks"] 		= {	0 , 20 , 0 },

	-- Draconic Power
	["Dark Talons"] 			= { 0 , 4 , 0 },
	["Burning Talons"] 			= { 0 , 4 , 0 },
	["Choking Talons"]			= { 0 , 4 , 0 },

	["Inhale"] 					= { 0 , 2.5 , 0 },
	["Deep Breath"] 			= { 0 , 2.5 , 0 },
	["Draw Essence"]			= { 0 , 2.5 , 0 },

	["Ferocious Leap"] 			= { 6 , 0 , 0 },
	
	--[[---------------------------------
		NIGHTBLADE
	-----------------------------------]]
	
	-- Assassination
	["Killer's Blade"] 			= { 2 , 0 , 0 },

	["Teleport Strike"] 		= { 0 , 1.5 , 0.25 },
	["Ambush"] 					= { 0 , 1.5 , 0.25 },
	["Lotus Fan"] 				= { 0 , 6 , 0.25 },

	["Mark Target"] 			= { 0 , 20 , 0 },
	["Piercing Mark"] 			= { 0 , 20 , 0 },
	["Reaper's Mark"] 			= { 0 , 20 , 0 },
	
	["Death Stroke"] 			= { 0 , 6 , 0 },
	["Incapacitating Strike"] 	= { 0 , 6 , 0 },
	["Soul Harvest"] 			= { 0 , 6 , 0 },
																	
	-- Shadow	
	["Veiled Strike"] 			= {	0 , 4.6 , 0 },
	["Surprise Attack"] 		= {	0 , 12 , 0 },
	["Concealed Weapon"] 		= {	0 , 4.6 , 0 },
	
	["Path of Darkness"] 		= {	11.5 , 11.5 , 0 },
	["Twisting Path"] 			= {	11.5 , 11.5 , 0 },
	["Refreshing Path"] 		= {	11.5 , 11.5 , 0 },
	
	["Aspect of Terror"] 		= {	0 , 4.5 , 0 },
	["Mass Hysteria"] 			= {	0 , 4.5 , 0 },
	["Manifestation of Terror"] = {	0 , 4.5 , 0 },
	
	-- Siphoning
	["Strife"] 					= { 10 , 10 , 0 },
	["Swallow Soul"] 			= { 10 , 10 , 0 },
	["Funnel Health"] 			= { 10 , 10 , 0 },
	
	["Agony"] 					= { 0 , 30 , 1.2 },
	["Prolonged Suffering"]		= { 0 , 30 , 1.2 },
	["Malefic Wreath"] 			= { 0 , 30 , 1.2 },
	
	["Cripple"] 				= { 8 , 8 , 0 },
	["Debilitate"] 				= { 8 , 8 , 0 },
	["Crippling Grasp"] 		= { 8 , 8 , 0 },
	
	["Soul Shred"] 				= { 0 , 3.5 , 0 },
	["Soul Tether"] 			= { 8 , 4.5 , 0 },
	["Soul Siphon"] 			= { 3.5 , 3.5 , 0 },

	--[[---------------------------------
		TEMPLAR
	-----------------------------------]]
	
	-- Aedric Spear
	["Binding Javelin"] 		= {	0 , 3 , 0.25 },
	
	["Focused Charge"] 			= {	0 , 3 , 0.5 },
	["Explosive Charge"] 		= {	0 , 3 , 0.5 },
	["Toppling Charge"] 		= {	0 , 2.4 , 0.5 },

	["Radial Sweep"] 			= {	0 , 6 , 0 },
	["Empowering Sweep"] 		= {	0 , 8 , 0 },
	["Crescent Sweep"] 			= {	0 , 6 , 0 },
	
	-- Dawn's Wrath
	["Sun Fire"] 				= {	0 , 6 , 0.5 },
	["Reflective Light"] 		= {	0 , 6 , 0.5 },
	["Vampire's Bane"] 			= {	0 , 8.4 , 0.5 },
	
	["Dark Flare"] 				= {	0 , 7.2 , 1.25 },
	
	["Eclipse"] 				= {	0 , 6 , 0 },
	["Total Dark"] 				= {	0 , 6 , 0 },
	["Unstable Core"] 			= {	0 , 6 , 0 },

	["Backlash"] 				= {	0 , 6 , 0 },
	["Power of the Light"] 		= {	0 , 6 , 0 },
	["Purifying Light"] 		= {	7.2 , 6 , 0 },
	
	["Radiant Destruction"] 	= {	0 , 3.6 , 0 },
	["Radiant Glory"] 			= {	0 , 3.6 , 0 },
	["Radiant Oppression"] 		= {	0 , 3.6 , 0 },

    ["Nova"]                    = {	9.6 , 0 , 0 },
    ["Solar Prison"]            = {	9.6 , 0 , 0 },
    ["Solar Disturbance"]       = {	9.6 , 0 , 0 },
	
	-- Restoring Light
	["Honor The Dead"] 			= {	8 , 0 , 0 },	
	
	["Lingering Ritual"] 		= { 8 , 0 , 0 },
		
	--[[---------------------------------
		ARMOR
	-----------------------------------]]
	
	-- Medium Armor
	["Evasion"] 				= { 20 , 0 , 0 },
	["Elude"] 					= { 23 , 0 , 0 },
	["Shuffle"] 				= { 20 , 0 , 0 },

	--[[---------------------------------
		GUILDS
	-----------------------------------]]
	
	["Silver Bolts"] 			= { 0 , 3.5 , 0 },
	["Silver Shards"] 			= { 0 , 3.5 , 0 },
	["Silver Leash"] 			= { 0 , 3.5 , 0 },

	["Dawnbreaker"] 			= { 0 , 4 , 0 },
	["Flawless Dawnbreaker"] 	= { 0 , 6 , 0 },
	["Dawnbreaker of Smiting"] 	= { 0 , 4 , 0 },
	
	-- Mages Guild
	["Entropy"]					= { 0 , 15.6 , 0 },
	["Degeneration"]			= { 0 , 15.6 , 0 },
	["Structured Entropy"]		= { 15.6 , 15.6 , 0 },

	["Scalding Rune"] 			= { 0 , 11.6 , 0 },
	
	["Meteor"] 					= { 0 , 11.8 , 0 },
	["Ice Comet"] 				= { 0 , 11.8 , 0 },
	["Shooting Star"] 			= { 0 , 11.8 , 0 },
	
	-- Undaunted
	["Inner Fire"] 				= { 0 , 15 , 0 },
	["Inner Rage"] 				= { 0 , 15 , 0 },
	["Inner Beast"] 			= { 0 , 15 , 0 },

	["Trapping Webs"] 			= { 0 , 8 , 0 },
	["Shadow Silk"] 			= { 0 , 8 , 0 },
	["Tangling Webs"] 			= { 0 , 8 , 0 },
		
	--[[---------------------------------
		WORLD
	-----------------------------------]]
	
	-- Vampire
	["Drain Essence"] 			= { 3 , 3 , 0 },
	["Invigorating Drain"] 		= { 3 , 3 , 0 },
	["Midnight Drain"] 			= { 3 , 3 , 0 },
	
	["Mist Form"] 				= { 3.5 , 0 , 0 },
	["Elusive Mist"] 			= { 4 , 0 , 0 },
	["Poison Mist"] 			= { 4 , 4 , 0 },
	
	["Bat Swarm"] 				= { 0 , 5 , 0 },
	["Devouring Swarm"] 		= { 0 , 5 , 0 },
	["Clouding Swarm"] 			= { 0 , 5 , 0 },

	-- Werewolf
	["Roar"]					= { 0 , 4.3 , 1 },
	["Ferocious Roar"]			= { 0 , 4.3 , 1 },
	["Rousing Roar"]			= { 0 , 4.3 , 1 },

	["Piercing Howl"]			= { 0 , 3 , 0 },
	["Howl of Despair"]			= { 0 , 3 , 0 },
	["Howl of Agony"]			= { 0 , 3 , 0 },

	["Infectious Claws"]		= { 0 , 10 , 0 },
	["Claws of Anguish"]		= { 0 , 10 , 0 },
	["Claws of Life"]			= { 0 , 10 , 0 },

	["Hircine's Rage"]			= { 17 , 0 , 0 },
	["Hircine's Fortitude"]		= { 8 , 0 , 0 },
	
	-- Soul Magic
	["Soul Trap"] 				= { 0 , 10 , 0 },
	["Consuming Trap"] 			= { 0 , 10 , 0 },
	["Soul Splitting Trap"] 	= { 0 , 10 , 0 },
	
	["Soul Strike"] 			= { 0 , 2.8 , 0 },
	["Shatter Soul"] 			= { 0 , 2.8 , 0 },
	["Soul Assault"] 			= { 0 , 3.9 , 0 },

	
	--[[---------------------------------
		AVA
	-----------------------------------]]
	
	-- Support
	["Purge"] 					= { 6 , 0 , 0 },
	["Efficient Purge"] 		= { 6 , 0 , 0 },
	["Cleanse"] 				= { 6 , 0 , 0 },

	["Caltrops"] 				= { 0 , 30 , 1 },
	["Anti-Cavalry Caltrops"] 	= { 0 , 30 , 1 },
	["Razor Caltrops"] 			= { 0 , 30 , 1 },

	["Vigor"] 					= { 20 , 0 , 0 },
	["Echoing Vigor"] 			= { 20 , 0 , 0 },
	["Resolving Vigor"] 		= { 20 , 0 , 0 },

	["Magicka Detonation"] 		= { 0 , 4 , 0 },
	["Inevitable Detonation"] 	= { 0 , 4 , 0 },
	["Proximity Detonation"] 	= { 0 , 4 , 0 },
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
		'Sea Of Flames',
		'Repentance',
		'Guard',
		'Mystic Guard',
		'Stalwart Guard'
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
function FTC:FilterBuffInfo( unitTag , name , abilityType , iconName )
	
	-- Default to no isType
	local isType	= nil
	local isValid	= true
	
	-- Untyped Abilities (0)
	if ( abilityType == ABILITY_TYPE_NONE ) then
	
		-- Summons and Toggles
		if ( FTC.Buffs:IsToggle( name ) ) then isType = "T" end
		
	-- "Bonus" Abilities (5)
	elseif ( abilityType == ABILITY_TYPE_BONUS ) then
	
		-- Mundus Stones
		if ( string.match( name , "Boon:" ) ) then
			if ( unitTag == 'player' ) then	isType = "P"
			else isValid = false end
		
		-- Exclude Cyrodiil Bonuses on Targets
		elseif ( string.match( name , "Keep Bonus" ) or string.match( name , "Scroll Bonus" ) or string.match( name , "Emperorship" ) ) then
			if ( unitTag ~= 'player' ) then isValid = false end

		-- Exclude Medicinal Use
		elseif ( string.match( name , "Medicinal Use" ) ) then
			isValid = false

		-- Catch Defaults
		else isType = "P" end
		
	-- Blocking (52)
	elseif ( ( abilityType == ABILITY_TYPE_BLOCK ) or ( name == "Brace (Generic)" ) ) then
		name		= "Blocking"
		isType 		= "T"

	-- Change Appearance ( 64 )
	elseif ( ( abilityType == ABILITY_TYPE_CHANGEAPPEARANCE ) ) then isType	= "T" end
		
	-- Return the filtered info
	return isValid, name, isType , iconName 
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