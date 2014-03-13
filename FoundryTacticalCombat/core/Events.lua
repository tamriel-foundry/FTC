--[[----------------------------------------------------------
	EVENTS COMPONENT
	----------------------------------------------------------
	* Registers event handlers for various components used by FTC.
	* Some events are conditionally applied depending on the configuration options used.
	* Listeners are registered after controls are created.
	* Includes wrappers that delegate tasks to run on each event.
	* The worker functions that are called live within the specific component function files.
  ]]--
 
function FTC:RegisterEvents()

	-- Target Events
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_RETICLE_TARGET_CHANGED  , FTC.OnTargetChanged )
	
	-- Interface Events
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_RETICLE_HIDDEN_UPDATE  	, FTC.OnReticleHidden )
	
	-- Buff Events
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_EFFECT_CHANGED 			, FTC.OnEffectChanged )
	
	-- Combat Events
	EVENT_MANAGER:RegisterForEvent( "FTC"	, EVENT_COMBAT_EVENT 			, FTC.OnCombatEvent )
	
	-- Experience Events
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_EXPERIENCE_UPDATE 		, FTC.OnXPUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_VETERAN_POINTS_UPDATE 	, FTC.OnVPUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_ALLIANCE_POINT_UPDATE  	, FTC.OnAPUpdate )
	
	-- Attribute Changes
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_POWER_UPDATE 			, FTC.OnPowerUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" 	, EVENT_STATS_UPDATED 			, FTC.OnStatsUpdated )
	
end




--[[----------------------------------------------------------
	EVENT HANDLERS
  ]]----------------------------------------------------------
 
--[[ 
 * Runs on the EVENT_RETICLE_TARGET_CHANGED listener.
 * This handler fires every time the player's reticle target changes
 ]]--
function FTC.OnTargetChanged()
		
	-- Update the target
	FTC:UpdateTarget()
	
end

--[[ 
 * Runs on the EVENT_RETICLE_HIDDEN_UPDATE listener.
 * This handler fires every time the interface mode is changed from reticle to cursor
 ]]--
function FTC.OnReticleHidden( ... )

	-- Toggle element visibility
	FTC:ToggleVisibility( ... )
	
end

--[[ 
 * Runs on the EVENT_EFFECT_CHANGED listener.
 * This handler fires every time a buff effect on a valid unitTag is changed
 ]]--
function FTC.OnEffectChanged( ... )
	
	-- Grab relevant arguments
	local params 	= { ... }
	local unitTag 	= params[5]

	-- Retrieve current buffs if the buffs component is active
	if ( FTC.Buffs.init ) then 
		FTC.Buffs:GetBuffs( unitTag ) 
	end
	
end

--[[ 
 * Runs on the EVENT_COMBAT_EVENT listener.
 * This handler fires every time a combat effect is registered on a valid unitTag
 ]]--
function FTC.OnCombatEvent( eventCode , result , isError , abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log )

	-- Verify it's a valid result type
	if ( not FTC.Damage:Filter( result , abilityName , sourceType , sourceName , targetName , hitValue ) ) then return end
	
	-- Determine the context
	local context 	= ( sourceType == 0 ) and "In" or "Out"

	-- Modify the name
	abilityName = string.gsub ( abilityName , ' %(.*%)' , "" )
	
	-- Setup a new damage object
	local damage = {
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
	
	-- Pass the damage object to SCT if it is enabled
	if ( FTC.SCT.init ) then FTC.SCT:NewCombat( damage , context ) end
	
	-- Pass damage to damage meter tracking
	if ( FTC.Damage.init ) then	FTC.Damage:UpdateMeter( damage , context ) end
end

--[[ 
 * Runs on the EVENT_EXPERIENCE_UPDATE listener.
 * This handler fires every time the player earns experience
 ]]--
function FTC.OnXPUpdate( ... )

	-- Pass experience to scrolling combat text component
	if ( FTC.SCT.init ) then 
		FTC.SCT:NewExp( ... )
	end

end

--[[ 
 * Runs on the EVENT_VETERAN_POINTS_UPDATE listener.
 * This handler fires every time the player earns veteran points
 ]]--
function FTC.OnVPUpdate( ... )

	-- Pass experience to scrolling combat text component
	if ( FTC.SCT.init ) then 
		FTC.SCT:NewExp( ... )
	end

end

--[[ 
 * Runs on the EVENT_ALLIANCE_POINT_UPDATE listener.
 * This handler fires every time the player earns experience
 ]]--
function FTC.OnAPUpdate( ... )

	-- Pass alliance points to scrolling combat text component
	if ( FTC.SCT.init ) then 
		FTC.SCT:NewAP( ... )
	end

end


--[[ 
 * Runs on the EVENT_POWER_UPDATE listener.
 * This handler fires every time a player's attribute changes
 ]]--
function FTC.OnPowerUpdate( ... )

	-- Pass updated attributes to unit frames
	if ( FTC.Frames.init ) then 
		FTC.Frames:UpdateFrame( ... )
	end

end

--[[ 
 * Runs on the EVENT_STATS_UPDATED listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnStatsUpdated( ... )

	-- Pass updated attributes to unit frames
	if ( FTC.Character.init ) then 
		FTC.Character:Update( ... )
	end

end