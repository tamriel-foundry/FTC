--[[----------------------------------------------------------
	CHARACTER INFO COMPONENT
 ]]-----------------------------------------------------------
function FTC.InitializeCharacter()
	
	-- Gather character information
	FTC.character		= {
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
	
	-- Setup placeholders for target information
	FTC.target 				= {
		["name"] 			= "-999",
		["level"]			= 0,
		["vlevel"]			= 0,
		["health"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["magicka"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["stamina"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
	}
	
	-- Load starting attributes
	local stats = {
		{ ["name"] = "health" , ["id"] = POWERTYPE_HEALTH },
		{ ["name"] = "magicka" , ["id"] = POWERTYPE_MAGICKA },
		{ ["name"] = "stamina" , ["id"] = POWERTYPE_STAMINA }
	}
	for i = 1 , #stats , 1 do
		local current, maximum, effMax = GetUnitPower( "player" , stats[i].id )
		FTC.character[stats[i].name] = { ["current"] = current , ["max"] = effMax , ["pct"] = math.floor( ( current / effMax ) * 100 ) }
	end
end

function FTC.InitializeCharSheet()

	-- Setup mini character sheet
	local CS 	= FTC.UI.TopLevelWindow( "FTC_CharSheet" , GuiRoot , {600,170} , {TOPLEFT,TOPLEFT,5,5} , true )
	CS.backdrop = FTC.UI.Backdrop( "FTC_CharSheetBackdrop" , CS , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
		
	-- Loop through character sheet sections, setting them up iteratively
	local comps 	= { "Attributes" , "Offense" , "Defense" , "Resists" };
	local anchor	= CS
	for i = 1 , #comps , 1 do
	
		-- Set up the character sheet section
		local section 	= FTC.UI.Control( "FTC_CharSheet_"..comps[i] , CS , {CS:GetWidth()/4,CS:GetHeight()} , {TOPLEFT,TOPRIGHT,0,0,anchor} , false )		
		local title		= FTC.UI.Label( "FTC_CharSheet_"..comps[i].."Title" , section , {section:GetWidth(),16} , {TOP,TOP,0,5} , "ZoFontAnnounceSmall" , nil , {1,0} , false )
		local names 	= FTC.UI.Label( "FTC_CharSheet_"..comps[i].."Names" , section , {.75*section:GetWidth(),section:GetHeight()-20} , {TOPLEFT,BOTTOMLEFT,10,5,title} , "ZoFontBoss" , nil , {0,0} , false )	
		local values 	= FTC.UI.Label( "FTC_CharSheet_"..comps[i].."Values" , section , {.25*section:GetWidth(),section:GetHeight()-20} , {TOPRIGHT,BOTTOMRIGHT,-10,5,title} , "ZoFontBoss" , nil , {2,0} , false )
		title:SetText("--- "..comps[i].." ---")	
		
		-- Adjust the position of the first section
		if i == 1 then section:SetAnchor(TOPLEFT,anchor,TOPLEFT,0,0) end
		
		-- Hook the next section to the previous parent
		anchor = section
	end
	
	-- Experience Bar
	if ( FTC.character.vlevel < 10 ) then 		
		CS.exp 		= FTC.UI.Backdrop( "FTC_CharSheet_Exp" , CS , { CS:GetWidth() - 20 , 20 } , {BOTTOM,BOTTOM,0,-5} , {0,0.2,0.4,1} , {0,0,0,1} , false )
		CS.bar 		= FTC.UI.Statusbar( "FTC_CharSheet_ExpBar" , CS , { CS.exp:GetWidth() - 4 , 14 } , {LEFT,LEFT,2,0,CS.exp} , {0.4,0.6,0.8,1} , false )	
		CS.exp.label = FTC.UI.Label( "FTC_CharSheet_ExpLabel" , CS.exp , "inherit" , {CENTER,CENTER,0,-1,CS.exp} , "ZoFontAnnounceSmall" , nil , {1,1} , false )
	end
	
	-- Populate the character sheet
	FTC.UpdateCharSheet(nil,'player')
	
	-- Register Event Listeners
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_STATS_UPDATED , FTC.UpdateCharSheet )
	
	-- Register Keybinding
	ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_CHARACTER_SHEET", "Display Character Sheet")
end


function FTC.UpdateCharSheet( eventCode , unitTag )

	-- Make sure we're targetting the player
	if ( "player" ~= unitTag ) then return end
	
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


function FTC.DisplayCharSheet()

	-- Switch the visible elements
	FTC_DamageMeter:SetHidden( true )
	FTC_CharSheet:SetHidden( not FTC_CharSheet:IsHidden() )
end

