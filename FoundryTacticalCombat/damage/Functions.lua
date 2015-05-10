 
 --[[----------------------------------------------------------
	DAMAGE METER FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the damage meter component of FTC
	* Runs during FTC:Initialize()
  ]]--
  
FTC.Damage 	= {}
FTC.Log		= {}
function FTC.Damage:Initialize()

	-- Reset the meter
	--FTC.Damage:Reset()
	
	-- Create controls
	--FTC.Damage:Controls()
	
	-- Register keybinding
	--ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_DAMAGE_METER", "Display Damage Meter")
	--ZO_CreateStringId("SI_BINDING_NAME_POST_DAMAGE_RESULTS", "Post Damage Results")
	--ZO_CreateStringId("SI_BINDING_NAME_POST_HEALING_RESULTS", "Post Healing Results")

	-- Register init status
	--FTC.init.Damage = true

end

--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Filter combat events to validate including them in SCT
 ]]--
function FTC.Damage:Filter( result , sourceType , targetName , hitValue )
	
	-- Ignore by default
	local isValid = false
	
	-- Miscellaneous Player Damage
	if ( sourceType == COMBAT_UNIT_TYPE_OTHER ) then 
		d("OTHER SOURCE")
		isValid = false

	-- Outgoing Actions
	elseif ( sourceType == COMBAT_UNIT_TYPE_PLAYER or sourceType == COMBAT_UNIT_TYPE_PLAYER_PET ) then

		-- Self-Harm
		if ( ( zo_strformat("<<C:1>>",targetName) == FTC.Player.name ) and ( result ~= ACTION_RESULT_HEAL and result ~= ACTION_RESULT_HOT_TICK and result ~= ACTION_RESULT_HOT_TICK_CRITICAL ) ) then 
 			isValid 	= true
 			sourceType 	= COMBAT_UNIT_TYPE_NONE 

		-- Reduced Damage
		elseif ( result == ACTION_RESULT_BLOCKED_DAMAGE ) then isValid = true
	
		-- Misses
		elseif ( result == ACTION_RESULT_DODGED or result == ACTION_RESULT_MISS ) then isValid = true

		-- Immunities
		elseif ( result == ACTION_RESULT_IMMUNE ) then isValid = true

		-- Interrupts
		elseif ( result == ACTION_RESULT_INTERRUPT ) then isValid = true

		-- Target Death
		elseif ( result == ACTION_RESULT_DIED_XP ) then isValid = true
		
		-- Ignore zeroes
		elseif ( hitValue == 0 ) then isValid = false
		
		-- Damage
		elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then isValid = true
		
		-- Healing
		elseif ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) then isValid = true

		-- Prompt others
		else d( "Outgoing result " .. result .. " not recognized!") end
	
	-- Incoming Actions
	elseif ( sourceType == COMBAT_UNIT_TYPE_NONE and ( zo_strformat("<<C:1>>",targetName) == FTC.Player.name ) ) then 

		-- Reduced Damage
		if ( result == ACTION_RESULT_BLOCKED_DAMAGE ) then isValid = true
	
		-- Misses
		elseif ( result == ACTION_RESULT_DODGED or result == ACTION_RESULT_MISS ) then isValid = true

		-- Immunities (ALLOW FOR NOW)
		elseif ( result == ACTION_RESULT_IMMUNE ) then isValid = true
		
		-- Ignore zeroes
		elseif ( hitValue == 0 ) then isValid = false
			
		-- Damage
		elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then isValid = true
			
		-- Falling damage
		elseif ( result == ACTION_RESULT_FALL_DAMAGE ) then isValid = true
		
		-- Healing
		elseif ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) then isValid = true

		-- Track stuff not to prompt for TEMPORARY
		elseif ( result == ACTION_RESULT_POWER_DRAIN or result == ACTION_RESULT_POWER_ENERGIZE ) then isValid = false

		-- Prompt others
		else d( "Incoming result " .. result .. " not recognized!") end
	end
	
	-- Return results
	return isValid, result , sourceType , targetName , hitValue
end



