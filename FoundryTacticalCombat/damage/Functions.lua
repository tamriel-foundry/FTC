 
 --[[----------------------------------------------------------
	DAMAGE METER FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the damage meter component of FTC
	* Runs during FTC:Initialize()
  ]]--
  
FTC.Damage = {}
function FTC.Damage:Initialize()

	-- Setup default meter values
	FTC.Damage.Meter = {
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
	local meter 	= FTC.Damage.Meter
	local damage	= newDamage.dam
	local name		= newDamage.name
	local gametime 	= newDamage.ms
	local heal		= newDamage.heal
	local target	= newDamage.target
	
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
	FTC.Damage.Meter = meter	

end


--[[ 
 * Loads updated combat meter data and displays it to the frame
 * Toggles the meter off if it is already shown and no update is ready
 ]]--
function FTC.Damage:DisplayMeter()
	
	-- Get the damage meter container
	local parent 	= _G["FTC_Meter"]
	local title 	= _G["FTC_MeterTitle"]
	
	-- Make sure it's not empty
	local meter 	= FTC.Damage.Meter
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
			--local lab = _G['FTC_Meter_' .. types[i] .. 'Label']
			--local val = _G['FTC_Meter_' .. types[i] .. 'Value']
			--lab:SetText(names)
			--val:SetText(values)
		end

	end
	
	-- If the new display is the same as the old one, just hide the meter
	if ( header == title:GetText() ) then
		FTC_MiniMeter:SetHidden( parent:IsHidden() )
		parent:SetHidden( not parent:IsHidden() )
	
	-- Otherwise , set the display to the element
	else
		title:SetText(header)
		parent:SetHidden(false)
		FTC_MiniMeter:SetHidden( true )
	end 
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

	-- Ignore zero damage
	if ( hitValue == 0 ) then return false
	
	-- Only count damage related to the player
	elseif ( string.match( targetName , FTC.Player.nicename ) == nil and string.match( sourceName , FTC.Player.nicename ) == nil ) then return false
		
	-- Ignore Self-Harm
	elseif ( sourceType == 1 ) and ( string.match( targetName , FTC.Player.nicename ) ~= nil ) and ( result ~= ACTION_RESULT_HEAL and result ~= ACTION_RESULT_HOT_TICK ) then return false

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
