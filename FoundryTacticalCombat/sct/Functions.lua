 
 --[[----------------------------------------------------------
	SCROLLING COMBAT TEXT FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the scrolling combat text component
	* Runs during FTC:Initialize()
  ]]--

FTC.SCT = {}
function FTC.SCT:Initialize()

	-- Setup tables
	FTC.SCTIn	= {}
	FTC.SCTOut	= {}
	FTC.SCTStat	= {}
	FTC.Meter	= {
		['startTime']		= 0,
		['endTime']			= 0,
		['damage']			= 0,
		['maxDamage']		= 0,
		['maxDamageName']	= '',
		['healing']			= 0,
		['maxHeal']			= 0,
		['maxHealName']		= '',
		['incoming']		= 0,
		['maxInc']			= 0,
		['maxIncName']		= '',
		['targets']			= {}
	}
	
	-- Create controls
	FTC.SCT:Controls()
	
	-- Register keybinding
	ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_DAMAGE_METER", "Display Damage Meter")
	
	-- Register init status
	FTC.init.SCT = true
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------

--[[ 
 * Process new combat events passed from the combat event handler
 * Called by OnCombatEvent()
 ]]--
function FTC.SCT:NewCombat( eventCode , result , isError , abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log )
	
	-- Verify it's a valid result type
	if ( not FTC.FilterSCT( result , abilityName , sourceType , sourceName , targetName , hitValue ) ) then return end
	
	-- Display approved combat events
	if ( FTC.debug.sct ) then
		d( result .. "/" .. abilityName .."/".. sourceName .."/".. targetName .."/".. hitValue .."/" .. abilityActionSlotType .."/" .. powerType .."/" .. damageType )
	end
	
	-- Determine the context
	local context 	= ( sourceType == 0 ) and "In" or "Out"

	-- Modify the name
	abilityName = string.gsub ( abilityName , ' %(.*%)' , "" )

	-- Setup a new SCT object
	local newSCT = {
		["name"]	= abilityName,
		["dam"]		= hitValue,
		["power"]	= powerType,
		["type"]	= damageType,
		["ms"]		= GetGameTimeMilliseconds(),
		["crit"]	= ( result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_DOT_TICK_CRITICAL ) and true or false,
		["heal"]	= ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_HOT_TICK ) and true or false,
		["blocked"]	= ( result == ACTION_RESULT_BLOCKED_DAMAGE ) and true or false,
		["immune"]	= ( result == ACTION_RESULT_IMMUNE ) and true or false,
		["multi"]	= 1
	}
	
	-- Check if the damage entry already exists
	local isNew 	= true
	for i = 1, #FTC["SCT"..context] do
		if ( ( FTC["SCT"..context][i].name == newSCT.name ) and ( math.abs( FTC["SCT"..context][i].ms - newSCT.ms ) < 500 ) ) then
			
			-- If the damage is higher, replace it
			if ( newSCT.dam > FTC["SCT"..context][i].dam ) then 
				FTC["SCT"..context][i] = newSCT
			end
			
			-- Tag a multiplier
			FTC["SCT"..context][i].multi = FTC["SCT"..context][i].multi + 1
			isNew = false
		end
	end

	-- Add the SCT object to the relevant damage table
	if ( isNew ) then table.insert( FTC["SCT"..context] , newSCT) end
	
	-- Update the DPS meter
	FTC.UpdateMeter( context , targetName , newSCT.name , newSCT.dam , newSCT.ms , newSCT.heal )
end


 --[[ 
  * Handles experience events and adds them to the combat damage table.
  * Runs on the EVENT_EXPERIENCE_UPDATE and EVENT_VETERAN_POINTS_UPDATE listeners.
 ]]--
function FTC.SCT:NewExp( eventCode, unitTag, currentExp, maxExp, reason )
	
	-- Bail if it's not earned by the player
	if ( unitTag ~= "player" ) then return end
	
	-- Don't display experience for level 50 characters
	if ( eventCode == EVENT_EXPERIENCE_UPDATE and FTC.character.level == 50 ) then return end
	
	-- Check whether it's VP or EXP
	local isveteran = ( eventCode == EVENT_VETERAN_POINTS_UPDATE ) and true or false
	
	-- Ignore finesse bonuses, they will get rolled into the next reward
	if ( reason == XP_REASON_FINESSE ) then return end
	
	-- Get the base experience
	local base 	= isveteran and FTC.character.vet or FTC.character.exp
	
	-- Calculate the difference
	local diff 	= currentExp - base
	
	-- Calculate percentage to level
	local pct	= math.floor( 100 * ( currentExp / maxExp ) )
	
	-- Setup the name
	local name = isveteran and "Veteran Points (" .. pct .. "%)" or "Experience (" .. pct .. "%)"
	
	-- Ignore zero experience rewards
	if ( diff == 0 ) then return end
	
	-- Update the base experience
	if ( isveteran ) then
		FTC.character.vet = currentExp
	else
		FTC.character.exp = currentExp
	end
	
	-- Update the character sheet exp bar
	FTC.UpdateCharSheet(nil,'player')
	
	-- Setup a new SCT object
	local newSCT = {
		["name"]	= name,
		["name"]	= name,
		["dam"]		= diff,
		["power"]	= 0,
		["type"]	= 2000,
		["ms"]		= GetGameTimeMilliseconds(),
		["crit"]	= false,
		["heal"]	= false,
		["blocked"]	= false,
		["immune"]	= false
	}
	table.insert( FTC.SCTStat, newSCT )
end

 --[[ 
  * Handles alliance point gains.
  * Runs on the EVENT_ALLIANCE_POINT_UPDATE listener.
 ]]--
function FTC.SCT.NewAP( eventCode, alliancePoints, playSound, difference )

	-- Ignore tiny AP rewards
	if ( difference  < 5 ) then return end
	
	-- Get AvA progress
	local subStart, nextSub, rankStart, nextRank = GetAvARankProgress(alliancePoints)
	
	-- Calculate percentage to level
	local pct	= math.floor( 100 * ( difference / ( nextSub - subStart ) ) )
	
	-- Setup the name
	local name = "Alliance Points (" .. pct .. "%)"
	
	-- Setup a new SCT object
	local newSCT = {
		["name"]	= name,
		["dam"]		= difference,
		["power"]	= 0,
		["type"]	= 2001,
		["ms"]		= GetGameTimeMilliseconds(),
		["crit"]	= false,
		["heal"]	= false,
		["blocked"]	= false,
		["immune"]	= false
	}
	table.insert( FTC.SCTStat, newSCT )	
end


--[[ 
 * Loads updated combat meter data and displays it to the frame
 * Toggles the meter off if it is already shown and no update is ready
 ]]--
function FTC.DisplayMeter()
	
	-- Get the damage meter container
	local parent 	= _G["FTC_DamageMeter"]
	local title 	= _G["FTC_DamageMeterTitle"]

	-- Retrieve the data and bail if it's empty
	local meter = FTC.Meter	
	if ( meter == nil ) then return end
	
	-- Make sure it's not empty
	local header 	= "FTC Damage Meter"
	if ( ( meter.damage + meter.healing + meter.incoming ) == 0 ) then
		header = header ..  " - No Combat Recorded"
	
	-- Otherwise, generate an in-depth tooltip
	else
	
		-- Start by computing the most damaged target
		local most_damaged_target = ""
		local most_damage = 0
		for k,v in pairs( meter.targets ) do
			if ( v > most_damage ) then
				most_damage = v
				most_damaged_target = k
			end
		end
		
		-- Compute the fight time
		local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )
		
		-- Generate a meter header
		header = header .. " - " .. most_damaged_target .. " (" .. string.format( "%.1f" , fight_time ) .. " seconds)"
		title:SetText(header)
		
		-- Compute the statistics
		local dps = string.format( "%.2f" , meter.damage/fight_time  	)
		local hps = string.format( "%.2f" , meter.healing/fight_time  	)
		local ips = string.format( "%.2f" , meter.incoming/fight_time 	)
		local items = {
			{ ["type"] = "Damage",	["tag"] = "Total Damage: ", 	["amt"] = ( meter.damage 	> 0 ) 	and meter.damage	or "" , ["val"] = ( meter.damage > 0 ) and dps .. " DPS" or "" },
			{ ["type"] = "Damage",	["tag"] = "Largest Hit: ",	 	["amt"] = ( meter.maxDamage > 0 ) 	and meter.maxDamageName .. " for " .. meter.maxDamage 	or "" , ["val"] = "" },
			{ ["type"] = "Healing",	["tag"] = "Total Healing: ", 	["amt"] = ( meter.healing 	> 0 ) 	and meter.healing   or "" , ["val"] = (meter.healing > 0 ) and hps .. " HPS" or "" },
			{ ["type"] = "Healing",	["tag"] = "Largest Heal: ", 	["amt"] = ( meter.maxHeal 	> 0 ) 	and meter.maxHealName .. " for " .. meter.maxHeal 		or "" , ["val"] = "" },
			{ ["type"] = "Incoming",["tag"] = "Incoming Damage: ",	["amt"] = ( meter.incoming 	> 0 )	and meter.incoming	or "" , ["val"] = ( meter.incoming > 0 )and ips .. " DPS" or "" },
			{ ["type"] = "Incoming",["tag"] = "Hardest Hit: ", 		["amt"] = ( meter.maxInc 	> 0 )	and meter.maxIncName .. " for " .. meter.maxInc 		or "" , ["val"] = "" }
		}
		
		-- Generate the label
		local types = { "Damage" , "Healing" , "Incoming" }
		for i = 1 , #types , 1 do
			local names 	= ""
			local values 	= ""
			for j = 1 , #items , 1 do
				if ( items[j].type == types[i] ) then
					names 	= names .. items[j].tag .. items[j].amt .. "\r\n"
					values 	= values .. items[j].val
				end
			end
			
			-- Add the label
			local lab = _G['FTC_DamageMeter_' .. types[i] .. 'Label']
			local val = _G['FTC_DamageMeter_' .. types[i] .. 'Value']
			lab:SetText(names)
			val:SetText(values)
		end

	end
	
	-- If the new display is the same as the old one, just hide the meter
	if ( header == title:GetText() ) then
		FTC_CharSheet:SetHidden(true)
		parent:SetHidden( not parent:IsHidden() )
	
	-- Otherwise , set the display to the element
	else
		title:SetText(header)
		FTC_CharSheet:SetHidden(true)
		parent:SetHidden(false)
	end 
end


--[[----------------------------------------------------------
	UPDATING FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Updates Scrolling Combat Text for both incoming and outgoing damage
 * Runs every frame OnUpdate
 ]]--
function FTC.UpdateSCT(context)

	-- Get SCT arguments
	local speed		= ( FTC.vars.SCTSpeed >= 1 and FTC.vars.SCTSpeed <= 10 ) and FTC.vars.SCTSpeed or FTC.defaults.SCTSpeed

	-- Get the SCT UI element
	local 	Parent = _G["FTC_CombatText"..context]
	
	-- Get the damage table based on context
	local 	Damage = {}
	if ( context == "Out" ) then 
		Damage = FTC.SCTOut
	elseif ( context == "In" ) then
		Damage = FTC.SCTIn
	elseif (context == "Stat" ) then
		Damage = FTC.SCTStat
	end
	
	-- Bail if no damage is present
	if ( #Damage == 0 ) then return	end
	
	-- Get the game time
	local gameTime = GetGameTimeMilliseconds()
	
	-- If we have been out of combat for 5 seconds, clear everything
	if ( IsUnitInCombat('player') == false ) and (( gameTime - Damage[#Damage].ms ) > 5000 ) then
		if ( context == "Out" ) then
			FTC.SCTOut 	= {}
		elseif ( context == "In" ) then
			FTC.SCTIn 	= {}
		elseif (context == "Stat" ) then
			FTC.SCTStat	= {}
		end
	end
	
	-- Now loop through damage values, displaying
	for i = 1 , #Damage , 1 do
	
		-- Get the damage container, start recycling at 10
		local container = _G["FTC_SCT"..context..i]
		if ( i > 10 ) then
			local cnum 		= ( i % 10 ) + 1
			container = _G["FTC_SCT"..context..cnum]
		end
		
		-- Hide damage more than 3 seconds old
		local lifespan	= gameTime - Damage[i].ms
		if ( lifespan > 3000 ) then
			container:SetHidden(true)
		
		-- Otherwise show it, and scroll it
		else
		
			-- Setup defaults
			local damage 	= Damage[i].dam
			local name		= Damage[i].name
			local alpha  	= 1
			container:SetFont("ZoFontHeader2")
			
			-- Flag critical hits
			if ( Damage[i].crit == true ) then
				damage 	= "*" .. damage .. "*"
				container:SetFont("ZoFontHeader3")
			end
			
			-- Flag blocked damage
			if ( Damage[i].blocked == true ) then
				damage	= "(" .. damage .. ")"
			end
			
			-- Flag damage immunity
			if ( Damage[i].immune == true ) then
				damage	= "(Immune)"
			end
			
			-- Resource Alerts (Health = 998 , Stamina = 1006 , Magicka = 1000, Execute = 1001 )
			if ( Damage[i].type == 998 or Damage[i].type == 999 ) then
				container:SetColor(0.8,0,0,1)
				container:SetFont("ZoFontBookTablet")
			elseif ( Damage[i].type == 1006 or Damage[i].type == 1007 ) then
				container:SetColor(0.4,0.8,0.4,1)
				container:SetFont("ZoFontBookTablet")
			elseif ( Damage[i].type == 1000 or Damage[i].type == 1001 ) then
				container:SetColor(0.2,0.6,0.8,1)
				container:SetFont("ZoFontBookTablet")
		
			-- Experience
			elseif ( Damage[i].type == 2000 or Damage[i].type == 2001 ) then
				damage	= "|c99FFFF+" .. damage .. "|"				
			
			-- Flag heals
			elseif( Damage[i].heal == true ) then
				damage = "|c99DD93" .. damage .. "|"
				if string.match( Damage[i].name , "Potion" ) then Damage[i].name = "Health Potion" end
			
			-- Magic damage
			elseif ( Damage[i].type ~= DAMAGE_TYPE_PHYSICAL	) then
				damage = ( context == "Out" ) and "|c336699" .. damage .. "|" or "|c990000" .. damage .. "|"
			
			-- Standard hits
			else
				damage = ( context == "Out" ) and "|cAA9F83" .. damage .. "|" or "|c990000" .. damage .. "|"
			end
			
			-- Maybe add the ability name
			if ( FTC.vars.SCTNames ) then
				damage = damage .. "   " .. name
			end
			
			-- Add the multiplier
			if ( Damage[i].multi and Damage[i].multi > 1 ) then
				damage = damage .. " (x" .. Damage[i].multi .. ")"
			end
			
			-- Update the damage
			container:SetHidden(false)
			container:SetText( damage )	
			
			-- Scroll the position
			local offsety = 25
			if ( i % 2 == 0 ) then
				offsety = 0
			elseif ( i % 3 == 0 ) then
				offsety = -25
			end
			offsety	= offsety -( lifespan / ( 11 - speed ) )

			-- Adjust the position
			container:SetAnchor(BOTTOM,Parent,BOTTOM,0,offsety)
		end
	end
end

--[[ 
 * Adds the new SCT damage to the combat meter for processing
 ]]--
function FTC.UpdateMeter( context , target , name , damage , gametime , heal )
	
	-- Retrieve the data
	local meter = FTC.Meter
	
	-- If the meter has been inactive for over 5 seconds, restart the timer
	if ( meter == nil ) then
		meter.endTime 	= 0
		meter.startTime = 0
	end
	
	-- If the meter has been inactive for over 5 seconds, reset the data
	if( ( ( gametime - meter.endTime ) / 1000 ) >= 5 ) then
		meter.startTime = gametime
		meter.damage	= 0
		meter.maxDamage	= 0
		meter.healing	= 0
		meter.maxHeal	= 0
		meter.incoming	= 0
		meter.maxInc	= 0
		meter.targets	= {}
	end
	
	-- Track the target (only enemies)
	if ( context == "Out" and heal == false ) then
		meter.targets[target] = ( meter.targets[target] ~= nil ) and meter.targets[target] + damage or damage
	end
	
	-- Incoming Damage
	if ( context == 'In' and heal == false ) then
		meter.incoming 			= meter.incoming + damage
		if ( damage > meter.maxInc ) then
			meter.maxInc		= damage
			meter.maxIncName	= name
		end
	
	-- Outgoing Healing
	elseif ( context == 'Out' and heal == true ) then 
		meter.healing 			= meter.healing + damage
		if ( damage > meter.maxHeal ) then
			meter.maxHeal 		= damage
			meter.maxHealName 	= name
		end
	elseif ( context == 'Out' ) then
		meter.damage = meter.damage + damage
		if ( damage > meter.maxDamage ) then
			meter.maxDamage 	= damage
			meter.maxDamageName = name
		end
	end
	
	-- Stamp the time
	meter.endTime = gametime
	
	-- Send data back to the FTC object
	FTC.Meter = meter
end

--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Filter combat events to validate including them in SCT
 ]]--
function FTC.FilterSCT( result , abilityName , sourceType , sourceName , targetName , hitValue )

	-- Ignore zero damage
	if ( hitValue == 0 ) then return false
	
	-- Only count damage related to the player
	elseif ( string.match( targetName , FTC.character.nicename ) == nil and string.match( sourceName , FTC.character.nicename ) == nil ) then return false
		
	-- Ignore Self-Harm
	elseif ( sourceType == 1 ) and ( string.match( targetName , FTC.character.nicename ) ~= nil ) and ( result ~= ACTION_RESULT_HEAL and result ~= ACTION_RESULT_HOT_TICK ) then return false

	-- Direct Damage
	elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_BLOCKED_DAMAGE or result == ACTION_RESULT_FALL_DAMAGE ) then return true
	
	-- Damage Over Time
	elseif ( result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then return true
	
	-- Heals
	elseif ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK ) then return true
		
	-- Damage Immunity
	elseif ( result == ACTION_RESULT_IMMUNE ) then return true

	-- Otherwise, ignore it
	else return false end	
end
