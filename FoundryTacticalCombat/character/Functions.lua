 
 --[[----------------------------------------------------------
	CHARACTER FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the player character components of FTC
	* Runs during FTC:Initialize()
  ]]--
 
FTC.Character = {}
function FTC.Character:Initialize()

	-- Setup initial character information
	local character		= {
		["name"] 		= GetUnitName( 'player' ),
		["race"]		= GetUnitRace( 'player' ),
		["class"]		= GetUnitClass( 'player' ),
		["nicename"]	= string.gsub( GetUnitName( 'player' ) , "%-", "%%%-"),
		["level"]		= GetUnitLevel('player'),
		["vlevel"]		= GetUnitVeteranRank('player'),
		["alevel"]		= GetUnitAvARank('player'),
		["exp"]			= GetUnitXP('player'),
		["vet"]			= GetUnitVeteranPoints('player'),
		["health"]		= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["magicka"]		= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["stamina"]		= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 }
	}
	
	-- Load starting attributes
	local stats = {
		{ ["name"] = "health" , ["id"] = POWERTYPE_HEALTH },
		{ ["name"] = "magicka" , ["id"] = POWERTYPE_MAGICKA },
		{ ["name"] = "stamina" , ["id"] = POWERTYPE_STAMINA }
	}
	for i = 1 , #stats , 1 do
		local current, maximum, effMax = GetUnitPower( "player" , stats[i].id )
		character[stats[i].name] = { ["current"] = current , ["max"] = effMax , ["pct"] = math.floor( ( current / effMax ) * 100 ) }
	end
	
	-- Populate the character object
	for attr , value in pairs( character ) do FTC.Character[attr] = value end
	
	-- Create character sheet controls
	FTC.Character:Controls()
	
	-- Populate the character sheet
	FTC.UpdateCharSheet( nil , 'player' )
	
	-- Register Keybinding
	ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_CHARACTER_SHEET", "Display Character Sheet")
	
	-- Register init status
	FTC.Character.init = true
	
end

FTC.Target = {}
function FTC.Target:Initialize()

	-- Setup initial target information
	local target 			= {
		["name"] 			= "-999",
		["level"]			= 0,
		["vlevel"]			= 0,
		["health"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["magicka"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["stamina"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
	}	
	
	-- Populate the target object
	for attr , value in pairs( target ) do FTC.Target[attr] = value end	
	
	-- Register post-initialization callbacks
	CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , FTC:UpdateTarget() )
	
	-- Register init status
	FTC.Target.init = true
end

--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------
 
 
  --[[ 
 * Updates the character sheet and character attributes
 * Called by OnStatsUpdated()
 ]]--
FTC.Character:Update( eventCode , unitTag )

	-- Make sure we're targetting the player
	if ( "player" ~= unitTag ) then return end
	
	-- No need to update unless the character sheet is displayed
	if ( FTC_CharSheet:IsHidden() ) then return end
	
	-- Loop through the relevant stats
	local stats	= {
		["Attributes"]	= {
			{ ["name"] = "Maximum Health",			["id"] = STAT_HEALTH_MAX 			, ["fmt"] = "value" },
			{ ["name"] = "Healing Recieved",		["id"] = STAT_HEALING_TAKEN 		, ["fmt"] = "value" },
			{ ["name"] = "Health Regen",			["id"] = STAT_HEALTH_REGEN_COMBAT	, ["fmt"] = "value" },
			{ ["name"] = "Maximum Stamina",			["id"] = STAT_STAMINA_MAX 			, ["fmt"] = "value" },
			{ ["name"] = "Stamina Regen",			["id"] = STAT_STAMINA_REGEN_COMBAT	, ["fmt"] = "value" },
			{ ["name"] = "Maximum Magicka",			["id"] = STAT_MAGICKA_MAX 			, ["fmt"] = "value" },
			{ ["name"] = "Magicka Regen",			["id"] = STAT_MAGICKA_REGEN_COMBAT	, ["fmt"] = "value" },
		},
		["Offense"] = {
			{ ["name"] = "Weapon Damage", 			["id"] = STAT_POWER					, ["fmt"] = "value" },
			{ ["name"] = "Weapon Critical", 		["id"] = STAT_CRITICAL_STRIKE 		, ["fmt"] = "pct" 	},
			{ ["name"] = "Physical Penetration", 	["id"] = STAT_PHYSICAL_PENETRATION	, ["fmt"] = "value" },
			{ ["name"] = "Spell Damage", 			["id"] = STAT_SPELL_POWER 			, ["fmt"] = "value" },
			{ ["name"] = "Spell Critical", 			["id"] = STAT_SPELL_CRITICAL 		, ["fmt"] = "pct" 	},
			{ ["name"] = "Magic Penetration", 		["id"] = STAT_SPELL_PENETRATION		, ["fmt"] = "value" }
		},
		["Defense"]	= {
			{ ["name"] = "Armor Rating",			["id"] = STAT_ARMOR_RATING			, ["fmt"] = "value" },
			{ ["name"] = "Percent Block", 			["id"] = STAT_BLOCK 				, ["fmt"] = "pct" 	},
			{ ["name"] = "Percent Dodge",			["id"] = STAT_DODGE					, ["fmt"] = "pct" 	},
			{ ["name"] = "Miss Chance",				["id"] = STAT_MISS 					, ["fmt"] = "pct" 	},
			{ ["name"] = "Physical Mitigation",		["id"] = STAT_MITIGATION 			, ["fmt"] = "value" },
			{ ["name"] = "Spell Mitigation",		["id"] = STAT_SPELL_MITIGATION 		, ["fmt"] = "value" },
			{ ["name"] = "Parry Chance",			["id"] = STAT_PARRY 				, ["fmt"] = "pct" 	}
		},
		["Resists"]	= {
			{ ["name"] = "Physical Resist",			["id"] = STAT_PHYSICAL_RESIST 		, ["fmt"] = "value" },
			{ ["name"] = "Magic Resist",			["id"] = STAT_SPELL_RESIST 			, ["fmt"] = "value" },
			{ ["name"] = "Cold Resist",				["id"] = STAT_DAMAGE_RESIST_COLD 	, ["fmt"] = "value" },
			{ ["name"] = "Fire Resist",				["id"] = STAT_DAMAGE_RESIST_FIRE 	, ["fmt"] = "value" },
			{ ["name"] = "Shock Resist",			["id"] = STAT_DAMAGE_RESIST_SHOCK 	, ["fmt"] = "value" },
			{ ["name"] = "Disease Resist",			["id"] = STAT_DAMAGE_RESIST_DISEASE , ["fmt"] = "value" },
			{ ["name"] = "Poison Resist",			["id"] = STAT_DAMAGE_RESIST_POISON 	, ["fmt"] = "value" }
		}
	}

	-- Loop through each category, populating the form
	local types = { "Attributes" , "Offense" , "Defense" , "Resists" }
	for i = 1 , #types , 1 do
		local names 	= ""
		local values	= ""
		for j = 1 , #stats[types[i]] , 1 do
			stat	= ( stats[types[i]][j].fmt == "pct" ) and string.format( "%.1f" , GetPlayerStat( stats[types[i]][j].id ) / 10 ) or GetPlayerStat( stats[types[i]][j].id )
			names 	= names .. stats[types[i]][j].name .. "\r\n"
			values 	= values .. stat .. "\r\n"
		end
		_G["FTC_CharSheet_" .. types[i] .. "Names"]:SetText(names)
		_G["FTC_CharSheet_" .. types[i] .. "Values"]:SetText(values)
	end
	
	-- Experience
	if ( FTC.character.vlevel < 10 ) then 
		local maxExp	= ( FTC.character.level == 50 ) and GetUnitVeteranPointsMax('player') or GetUnitXPMax('player')
		local currExp	= ( FTC.character.level == 50 ) and FTC.character.vet or FTC.character.exp
		local pct		= math.floor( 100 * ( currExp / maxExp ) )
		local xpLabel 	= currExp .. "/" .. maxExp .. " (" .. pct .. "%)"
		FTC_CharSheet_ExpLabel:SetText(xpLabel)
		FTC_CharSheet_ExpBar:SetWidth( ( pct / 100 ) * FTC_CharSheet_Exp:GetWidth() )
	end
	
end

  --[[ 
 * Toggles the display of the character sheet
 * Called by hotkey activation
 ]]--
function FTC.DisplayCharSheet()

	-- Get the current visibility
	local isHidden = FTC_CharSheet:IsHidden()

	-- Maybe update the sheet
	if isHidden then FTC.Character:Update( nil , 'player' ) end
	
	-- Switch the visible elements
	FTC_DamageMeter:SetHidden( true )
	FTC_CharSheet:SetHidden( not isHidden )
end