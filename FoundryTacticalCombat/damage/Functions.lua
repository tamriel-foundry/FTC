 
 --[[----------------------------------------------------------
	DAMAGE METER FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the damage meter component of FTC
	* Runs during FTC:Initialize()
  ]]--
  
FTC.Damage = {}
function FTC.Damage:Initialize()

	-- Reset the meter
	FTC.Damage:Reset()
	
	-- Create controls
	FTC.Damage:Controls()
	
	-- Register keybinding
	ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_DAMAGE_METER", "Display Damage Meter")
	ZO_CreateStringId("SI_BINDING_NAME_POST_DAMAGE_RESULTS", "Post Damage Results")
	ZO_CreateStringId("SI_BINDING_NAME_POST_HEALING_RESULTS", "Post Healing Results")

	-- Register init status
	FTC.init.Damage = true

end

--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------
 
 --[[ 
 * Process new combat events passed from the combat event handler
 * Called by OnCombatEvent()
 ]]--
function FTC.Damage:UpdateMeter( newDamage , context )

	-- Retrieve the data
	local meter		= FTC.Damage.Meter
	local damage	= newDamage.dam
	local name		= newDamage.name
	local target	= newDamage.target
	local source	= newDamage.source
	
	-- If the meter is inactive, don't start it for heals
	if ( meter.endTime == 0 and newDamage.heal ) then return end
	
	-- If the meter has been inactive for over X seconds
	if( ( ( newDamage.ms - meter.endTime ) / 1000 ) >= FTC.vars.DamageTimeout ) then
		
		-- If it's a new source of damage, reset the meter
		if ( not newDamage.heal ) then
			FTC.Damage:Reset()
			meter				= FTC.Damage.Meter
			meter.startTime 	= newDamage.ms
			
		-- Otherwise, bail out
		else return end
	end
	
	-- Process outgoing healing events
	if ( newDamage.heal and context == "Out") then
		
		-- Update meter
		meter.healing			= meter.healing + damage
		if ( damage > meter.maxHeal ) then
			meter.maxHeal		= damage
			meter.maxHealName 	= name			
		end
		
		-- Track ability
		if ( FTC.Damage.Heals[name] ~= nil ) then
			FTC.Damage.Heals[name].total 	= FTC.Damage.Heals[name].total + damage
			FTC.Damage.Heals[name].count 	= FTC.Damage.Heals[name].count + 1
			FTC.Damage.Heals[name].crit		= newDamage.crit and FTC.Damage.Heals[name].crit + 1 or FTC.Damage.Heals[name].crit
		else
			FTC.Damage.Heals[name] 	= {
				["total"]			= damage,
				["count"]			= 1,
				["crit"]			= newDamage.crit and 1 or 0,			
			}
		end
	
	-- Process outgoing damage events
	elseif ( context == "Out" ) then
			
		-- Update meter
		meter.damage			= meter.damage + damage
		if ( damage > meter.maxDam ) then
			meter.maxDam		= damage
			meter.maxDamName 	= name			
		end

		-- Track ability
		if ( FTC.Damage.Damages[name] ~= nil ) then
			FTC.Damage.Damages[name].total 	= FTC.Damage.Damages[name].total + damage
			FTC.Damage.Damages[name].count 	= FTC.Damage.Damages[name].count + 1
			FTC.Damage.Damages[name].crit	= newDamage.crit and FTC.Damage.Damages[name].crit + 1 or FTC.Damage.Damages[name].crit
		else
			FTC.Damage.Damages[name] 	= {
				["total"]			= damage,
				["count"]			= 1,
				["crit"]			= newDamage.crit and 1 or 0,			
			}
		end
		
		-- Track target
		FTC.Damage.Targets[target]	= ( FTC.Damage.Targets[target] ~= nil ) and FTC.Damage.Targets[target] + damage or damage
	
	-- Process incoming damage events
	elseif ( context == "In" ) then
	
		-- Update meter
		meter.incoming					= meter.incoming + damage
		if ( damage > meter.maxInc ) then
			meter.maxInc				= damage		
		end	
	end
	
	-- Stamp the time (but not for heals)
	if ( not newDamage.heal ) then meter.endTime = newDamage.ms end
	
	-- Return data back to the meter
	FTC.Damage.Meter = meter	
end


--[[ 
 * Loads updated combat meter data and displays it to the frame
 * Toggles the meter off if it is already shown and no update is ready
 ]]--
function FTC.Damage:Display()
	
	-- Get the damage meter container
	local parent 	= _G["FTC_Meter"]
	local title 	= _G["FTC_MeterTitle"]
	
	-- Grab elements
	local meter 	= FTC.Damage.Meter
	local header 	= "FTC Damage Meter"
	
	-- Compute the most damaged target
	local most_damaged_target = ""
	local most_damage = 0
	for k,v in pairs( FTC.Damage.Targets ) do
		if ( v > most_damage ) then
			most_damage = v
			most_damaged_target = k
		end
	end
	
	-- Compute the fight time
	local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )
	
	-- Generate a title
	if ( meter.damage + meter.healing == 0 ) then
		header = header ..  " - No Combat Recorded"
	else
		header = header .. " - " .. most_damaged_target .. " (" .. string.format( "%.1f" , fight_time ) .. " seconds)"
	end
	
	--[[----------------------------------
		OUTGOING DAMAGE
	  ]]----------------------------------
	local dps = string.format( "%.2f" , meter.damage/fight_time )
	
	-- Set Header
	local head	= ( meter.damage > 0 ) and CommaValue( meter.damage ) .. " Total Damage (" .. dps .. " DPS)" or "No Outgoing Damage"
	FTC_MeterDamage_Title:SetText( head )
	
	-- Sort damaging abilities
	local damages = {}
	for k,v in pairs( FTC.Damage.Damages ) do
		v.name = k
		table.insert( damages , v ) 
	end
	table.sort( damages , function(x,y) return x.total > y.total end )

	local ndamage = math.min( #damages , 10 )
	for i = 1 , ndamage do
		
		-- Get elements
		local line	= _G["FTC_MeterDamage_"..i]
		local left	= _G["FTC_MeterDamage_"..i.."Left"]
		local right	= _G["FTC_MeterDamage_"..i.."Right"]
		
		-- Get data
		local total	= CommaValue( damages[i].total )
		local crit	= math.floor( ( damages[i].crit / damages[i].count ) * 100 )
		local adps	= string.format( "%.2f" , damages[i].total/fight_time )
		local pdps	= math.floor( ( adps / dps ) * 100 )
		
		-- Add data
		line:SetHidden(false)
		left:SetText( damages[i].name .. " - " .. total .. " Damage (" .. crit .. "% Crit)")
		right:SetText( "(" .. pdps .. "%) " .. adps .. " DPS" )
	end
	
	-- Hide unused lines
	for i = ndamage + 1 , 10 do
		local line 	= _G["FTC_MeterDamage_"..i]
		line:SetHidden(true)	
	end
	
	-- Change the element height
	FTC_MeterDamage:SetHeight( 50 + ( #damages * 24 ) )
	
	--[[----------------------------------
		OUTGOING HEALING
	  ]]----------------------------------		
	local hps = string.format( "%.2f" , meter.healing/fight_time )
	
	-- Set Header
	local head	= ( meter.healing > 0 ) and CommaValue( meter.healing ) .. " Total Healing (" .. hps .. " HPS)" or "No Outgoing Healing"
	FTC_MeterHealing_Title:SetText( head )
	
	-- Sort damaging abilities
	local heals = {}
	for k,v in pairs( FTC.Damage.Heals ) do
		v.name = k
		table.insert( heals , v ) 
	end
	table.sort( heals , function(x,y) return x.total > y.total end )	

	local nheals = math.min( #heals , 10 )
	for i = 1 , nheals do
		
		-- Get elements
		local line	= _G["FTC_MeterHealing_"..i]
		local left	= _G["FTC_MeterHealing_"..i.."Left"]
		local right	= _G["FTC_MeterHealing_"..i.."Right"]
		
		-- Get data
		local total	= CommaValue( heals[i].total )
		local crit	= math.floor( ( heals[i].crit / heals[i].count ) * 100 )
		local ahps	= string.format( "%.2f" , heals[i].total/fight_time )
		local phps	= math.floor( ( ahps / hps ) * 100 )
		
		-- Add data
		line:SetHidden(false)
		left:SetText( heals[i].name .. " - " .. total .. " (" .. crit .. "% Crit)")
		right:SetText( "(" .. phps .. "%) " .. ahps .. " HPS" )
	end
	
	-- Hide unused lines
	for i = nheals + 1 , 10 do
		local line 	= _G["FTC_MeterHealing_"..i]
		line:SetHidden(true)	
	end	

	-- Change the element height
	FTC_MeterHealing:SetHeight( 50 + ( #heals * 24 ) )		
	
	--[[----------------------------------
		INCOMING DAMAGE
	  ]]----------------------------------			
	local ips = string.format( "%.2f" , meter.incoming/fight_time )
	
	-- Set Header
	local head	= ( meter.incoming > 0 ) and CommaValue( meter.incoming ) .. " Incoming Damage (" .. ips .. " IPS)" or "No Incoming Damage"
	FTC_MeterIncoming_Title:SetText( head )
	
	--[[----------------------------------
		ADJUST DISPLAY
	  ]]----------------------------------		 
	local height = 60 + FTC_MeterDamage:GetHeight() + FTC_MeterHealing:GetHeight() + 60 
	parent:SetHeight( height )
	parent.backdrop:SetHeight( height )
	title:SetText(header)
end


function FTC.Damage:UpdateMini() 

	-- Retrieve the data
	local meter = FTC.Damage.Meter
	local mini	= _G["FTC_MiniMeter"]

	-- Compute the fight time
	local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )

	-- Compute player statistics
	local dps = string.format( "%d" , meter.damage/fight_time  	)
	local hps = string.format( "%d" , meter.healing/fight_time  	)
	local ips = string.format( "%d" , meter.incoming/fight_time 	)
	
	-- Update the labels
	mini.dam.label:SetText( dps )
	mini.heal.label:SetText( hps )
	mini.inc.label:SetText( ips )
end


--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Filter combat events to validate including them in SCT
 * sourceType
 * COMBAT_UNIT_TYPE_NONE = 0
 * COMBAT_UNIT_TYPE_PLAYER = 1
 * COMBAT_UNIT_TYPE_PLAYER_PET = 2
 * COMBAT_UNIT_TYPE_PLAYER_GROUP = 3
 * COMBAT_UNIT_TYPE_PLAYER_OTHER = 4
 ]]--
function FTC.Damage:Filter( result , abilityName , sourceType , sourceName , targetName , hitValue )

	-- Debugging
	-- d( sourceName .. "/" .. sourceType .. "/" .. abilityName .. "/" .. targetName .. "/" .. result .. "/" ..  hitValue )
	
	-- Ignore by default
	local isValid = false
	
	-- Ignore miscellaneous player damage
	if ( sourceType == COMBAT_UNIT_TYPE_OTHER ) then isValid = false
	
	-- Outgoing player actions
	elseif ( sourceType == COMBAT_UNIT_TYPE_PLAYER or sourceType == COMBAT_UNIT_TYPE_PLAYER_PET ) then
	
		-- Reflag self-harm
		if ( string.match( targetName , FTC.Player.nicename ) and ( result ~= ACTION_RESULT_HEAL and result ~= ACTION_RESULT_HOT_TICK and result ~= ACTION_RESULT_HOT_TICK_CRITICAL ) ) then sourceType = COMBAT_UNIT_TYPE_NONE end
	
		-- Immunities
		if ( result == ACTION_RESULT_IMMUNE or result == ACTION_RESULT_DODGED or result == ACTION_RESULT_BLOCKED_DAMAGE or result == ACTION_RESULT_MISS ) then isValid = true
		
		-- Ignore zeroes
		elseif ( hitValue == 0 ) then isValid = false
		
		-- Damage
		elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then isValid = true
		
		-- Healing
		elseif ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) then isValid = true end
	
	
	-- Incoming actions
	elseif ( sourceType == COMBAT_UNIT_TYPE_NONE and string.match( targetName , FTC.Player.nicename ) ) then 
	
		-- Immunities
		if ( result == ACTION_RESULT_IMMUNE or result == ACTION_RESULT_DODGED or result == ACTION_RESULT_BLOCKED_DAMAGE or result == ACTION_RESULT_MISS ) then isValid = true
		
		-- Ignore zeroes
		elseif ( hitValue == 0 ) then isValid = false
			
		-- Damage
		elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then isValid = true
			
		-- Falling damage
		elseif ( result == ACTION_RESULT_FALL_DAMAGE ) then isValid = true
		
		-- Healing
		elseif ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) then isValid = true end

	-- Group actions
	elseif ( sourceType == COMBAT_UNIT_TYPE_GROUP ) then
	
		-- Damage
		if ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then isValid = true end	
	end
	
	-- Return results
	return isValid, result , abilityName , sourceType , sourceName , targetName , hitValue
end


--[[ 
 * Reset the damage meter
 ]]--
function FTC.Damage:Reset()

	-- Setup damage overview
	FTC.Damage.Meter 	= {
		['damage']		= 0,
		['maxDam']		= 0,
		['maxDamName']	= "",
		['healing']		= 0,
		['maxHeal']		= 0,
		['maxHealName']	= "",
		['incoming']	= 0,
		['maxInc']		= 0,
		['group']		= 0,
		['startTime']	= 0,
		['endTime']		= 0,
	}
	
	-- Setup damaged target tracking
	FTC.Damage.Targets 	= {}
	
	-- Setup damage ability tracking
	FTC.Damage.Damages	= {}
	
	-- Setup healing ability tracking
	FTC.Damage.Heals	= {}
	
	-- Setup group tracking
	FTC.Damage.Group	= {}

end


--[[ 
 * Reset the damage meter
 ]]--
function FTC.Damage:ToggleMeter()

	-- Bail if damage is disabled
	if ( not FTC.vars.EnableDamage ) then return end
	
	-- Get the elements
	local mini 	= _G["FTC_MiniMeter"]
	local full	= _G["FTC_Meter"]
	
	-- Maybe update
	if ( full:IsHidden() ) then FTC.Damage:Display() end
	
	-- Toggle visibility
	mini:SetHidden( full:IsHidden() )
	full:SetHidden( not full:IsHidden() )

end

--[[ 
 * Print damage output to chat
 ]]--
function FTC.Damage:Post( context )

	-- Retrieve the data
	local meter = FTC.Damage.Meter
	
	-- Make sure there's something to report
	if ( meter.damage + meter.healing == 0 ) then 
		d( "No damage to report!" ) 
		return
	end

	-- Compute the most damaged target
	local most_damaged_target = ""
	local most_damage = 0
	for k,v in pairs( FTC.Damage.Targets ) do
		if ( v > most_damage ) then
			most_damage = v
			most_damaged_target = k
		end
	end
	
	-- Sanitize the name
	local name = SanitizeLocalization( most_damaged_target )
	
	-- Compute the fight time
	local total = 0
	local metric = 0
	local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )
	local label = ""

	-- Generate output
	if ( 'damage' == context ) then
		total 	= meter.damage
		metric	= string.format( "%.1f" , total / fight_time )
		label 	= name .. " (" .. string.format( "%.1f" , fight_time ) .. "s) - " .. CommaValue(total) .. " Total Damage " .. " (" .. metric .. " DPS)"

	elseif ( 'healing' == context ) then
		total 	= meter.healing
		metric	= string.format( "%.1f" , total / fight_time )
		label 	= name .. " (" .. string.format( "%.1f" , fight_time ) .. "s) - " .. CommaValue(total) .. " Total Healing " .. " (" .. metric .. " HPS)"
	end
	
	-- Determine appropriate channel
	local channel = IsUnitGrouped('player') and "/p " or "/say "

	-- Print output to chat
	CHAT_SYSTEM.textEntry:SetText( channel .. label )
end