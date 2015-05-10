 
 --[[----------------------------------------------------------
	DAMAGE METER FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the damage meter component of FTC
	* Runs during FTC:Initialize()
  ]]--
  
FTC.Damage 	= {}
function FTC.Damage:Initialize()

	-- Set up initial timestamps
	FTC.Damage.lastIn 	= 0
	FTC.Damage.lastOut	= 0
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

		-- Reflag Self-Harm
		if ( ( zo_strformat("<<C:1>>",targetName) == FTC.Player.name ) and ( result ~= ACTION_RESULT_HEAL and result ~= ACTION_RESULT_HOT_TICK and result ~= ACTION_RESULT_HOT_TICK_CRITICAL ) ) then 
 			isValid 	= true
 			sourceType 	= COMBAT_UNIT_TYPE_NONE 

		-- Ignore Queue
		elseif ( result == ACTION_RESULT_QUEUED ) then isValid = false
	
		-- Misses
		elseif ( result == ACTION_RESULT_DODGED or result == ACTION_RESULT_MISS ) then isValid = true

		-- Immunities
		elseif ( result == ACTION_RESULT_IMMUNE ) then isValid = true

		-- Active Avoidance
		elseif ( result == ACTION_RESULT_INTERRUPT or result == ACTION_RESULT_BLOCKED ) then isValid = true

		-- Crowd Control States
		elseif ( result == ACTION_RESULT_STUNNED or result == ACTION_RESULT_OFFBALANCE ) then isValid = true

		-- Target Death
		elseif ( result == ACTION_RESULT_DIED_XP ) then isValid = true

		-- Shielded Damage
		elseif ( result == ACTION_RESULT_DAMAGE_SHIELDED ) then isValid = true
			
		-- Damage Dealt
		elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_BLOCKED_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then 
			if ( hitValue > 0 ) then
				isValid = true
				FTC.Damage.lastOut = GetGameTimeMilliseconds()
			end
		
		-- Healing Dealt
		elseif ( hitValue > 0 and ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) ) then isValid = true

		-- Prompt other unrecognized
		else FTC.Log:Print( "Outgoing result " .. result .. " not recognized! Target: " .. targetName .. " Value: " .. hitValue , {1,1,0} ) end
	
	-- Incoming Actions
	elseif ( sourceType == COMBAT_UNIT_TYPE_NONE and ( zo_strformat("<<C:1>>",targetName) == FTC.Player.name ) ) then 

		-- Misses
		if ( result == ACTION_RESULT_DODGED or result == ACTION_RESULT_MISS ) then isValid = true

		-- Immunities
		elseif ( result == ACTION_RESULT_IMMUNE ) then isValid = true

		-- Shielded Damage
		elseif ( result == ACTION_RESULT_DAMAGE_SHIELDED ) then isValid = true
			
		-- Taken Damage
		elseif ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_BLOCKED_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) then 
			if ( hitValue > 0 ) then
				isValid = true
				FTC.Damage.lastIn = GetGameTimeMilliseconds()
			end
		
		-- Taken Healing
		elseif ( hitValue > 0 and ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) ) then isValid = true

		-- Falling damage
		elseif ( result == ACTION_RESULT_FALL_DAMAGE ) then isValid = true

		-- Resource Drains
		elseif ( result == ACTION_RESULT_POWER_DRAIN or result == ACTION_RESULT_POWER_ENERGIZE ) then isValid = false

		-- Prompt other unrecognized
		else FTC.Log:Print( "Incoming result " .. result .. " not recognized! Target: " .. targetName .. " Value: " .. hitValue , {1,1,0} ) end
	end
	
	-- Return results
	return isValid, result , sourceType , targetName , hitValue
end



