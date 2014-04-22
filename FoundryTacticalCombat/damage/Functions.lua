 
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
	
	-- If the meter has been inactive for over X seconds, restart tracking
	if( ( ( newDamage.ms - meter.endTime ) / 1000 ) >= FTC.vars.DamageTimeout ) then
		FTC.Damage:Reset()
		meter				= FTC.Damage.Meter
		meter.startTime 	= newDamage.ms
	end
	
	-- Process outgoing events
	if ( context == "Out" ) then
	
		-- Outgoing healing
		if ( newDamage.heal ) then
		
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
					["tex"]				= newDamage.tex,				
				}
			end
		
		-- Outgoing damage
		else 
		
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
					["tex"]				= newDamage.tex,				
				}
			end
			
			-- Track target
			FTC.Damage.Targets[target] = ( FTC.Damage.Targets[target] ~= nil ) and FTC.Damage.Targets[target] + damage or damage
		end
		
	-- Incoming events
	elseif ( context == "In" and not newDamage.heal ) then
	
		-- Update meter
		meter.incoming			= meter.incoming + damage
		if ( damage > meter.maxInc ) then
			meter.maxInc		= damage		
		end	
	end
	
	-- Stamp the time
	meter.endTime = newDamage.ms
	
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
	
	-- Handle cases of no data
	if ( ( meter.damage + meter.healing + meter.incoming ) == 0 ) then
		header = header ..  " - No Combat Recorded"
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
	
	-- Compute the fight time
	local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )
	
	-- Generate a title
	if ( ( meter.damage + meter.healing + meter.incoming ) ~= 0 ) then
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
	for i = 1 , math.min( ndamage , 10 ) do
		
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
	for i = 1 , #heals do
		
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
	FTC_MeterBackdrop:SetHeight( height )
	title:SetText(header)
end


function FTC.Damage:UpdateMini() 

	-- Retrieve the data
	local meter = FTC.Damage.Meter

	-- Compute the fight time
	local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )

	-- Compute simple statistics
	local dps = string.format( "%.1f" , meter.damage/fight_time  	)
	local hps = string.format( "%.1f" , meter.healing/fight_time  	)
	local ips = string.format( "%.1f" , meter.incoming/fight_time 	)
	
	-- Update the labels
	FTC_MiniMeter_DamageLabel:SetText( dps )
	FTC_MiniMeter_HealLabel:SetText( hps )
	FTC_MiniMeter_IncLabel:SetText( ips )
end


--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Filter combat events to validate including them in SCT
 ]]--
function FTC.Damage:Filter( result , abilityName , sourceType , sourceName , targetName , hitValue )
	
	-- Only count damage related to the player
	if ( string.match( targetName , FTC.Player.nicename ) == nil and string.match( sourceName , FTC.Player.nicename ) == nil ) then return false
	
	-- Display Certain Damage Immunities
	elseif ( result == ACTION_RESULT_IMMUNE or result == ACTION_RESULT_DODGED or result == ACTION_RESULT_BLOCKED_DAMAGE ) then return true
	
	-- Otherwise ignore zero damage
	elseif ( hitValue == 0 ) then return false
		
	-- Ignore Self-Harm
	elseif ( sourceType == 1 ) and ( string.match( targetName , FTC.Player.nicename ) ~= nil ) and ( result ~= ACTION_RESULT_HEAL and result ~= ACTION_RESULT_HOT_TICK and result ~= ACTION_RESULT_HOT_TICK_CRITICAL ) then return false

	-- Direct Damage
	elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_FALL_DAMAGE ) then return true
	
	-- Damage Over Time
	elseif ( result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then return true
	
	-- Heals
	elseif ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) then return true

	-- Otherwise, ignore it
	else return false end	
end


--[[ 
 * Reset the damage meter
 ]]--
function FTC.Damage:Reset()

	-- Setup damage totals
	FTC.Damage.Meter 	= {
		['damage']		= 0,
		['maxDam']		= 0,
		['maxDamName']	= "",
		['healing']		= 0,
		['maxHeal']		= 0,
		['maxHealName']	= "",
		['incoming']	= 0,
		['maxInc']		= 0,
		['startTime']	= 0,
		['endTime']		= 0,
	}
	
	-- Setup damage target tracking
	FTC.Damage.Targets 	= {}
	
	-- Setup damage ability tracking
	FTC.Damage.Damages	= {}
	
	-- Setup healing ability tracking
	FTC.Damage.Heals	= {}

end

--[[ 
 * Returns a formatted number with commas
 ]]--
function CommaValue(number)
	local left,num,right = string.match(number,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
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