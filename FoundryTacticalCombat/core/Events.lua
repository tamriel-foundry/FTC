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
function FTC.OnReticleHidden( eventCode , isHidden )

	-- Toggle element visibility
	FTC:ToggleVisibility()
	
end

--[[ 
 * Runs on the EVENT_EFFECT_CHANGED listener.
 * This handler fires every time a buff effect on a valid unitTag is changed
 ]]--
function FTC.OnEffectChanged( eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType )

	-- Retrieve current buffs if the buffs component is active
	if ( FTC.init.Buffs ) then 
		FTC.Buffs:GetBuffs( unitTag ) 
	end
	
end

--[[ 
 * Runs on the EVENT_COMBAT_EVENT listener.
 * This handler fires every time a combat effect is registered on a valid unitTag
 ]]--
function FTC.OnCombatEvent( ... )

	-- Pass damage to scrolling combat text component
	if ( FTC.init.SCT ) then 
		FTC.SCT:NewCombat( ... )
	end
	
	-- TODO: Pass damage to damage meter tracking	
end

--[[ 
 * Runs on the EVENT_EXPERIENCE_UPDATE listener.
 * This handler fires every time the player earns experience
 ]]--
function FTC.OnXPUpdate( ... )

	-- Pass experience to scrolling combat text component
	if ( FTC.init.SCT ) then 
		FTC.SCT:NewExp( ... )
	end

end

--[[ 
 * Runs on the EVENT_VETERAN_POINTS_UPDATE listener.
 * This handler fires every time the player earns veteran points
 ]]--
function FTC.OnVPUpdate( ... )

	-- Pass experience to scrolling combat text component
	if ( FTC.init.SCT ) then 
		FTC.SCT:NewExp( ... )
	end

end

--[[ 
 * Runs on the EVENT_ALLIANCE_POINT_UPDATE listener.
 * This handler fires every time the player earns experience
 ]]--
function FTC.OnAPUpdate( ... )

	-- Pass alliance points to scrolling combat text component
	if ( FTC.init.SCT ) then 
		FTC:NewAP( ... )
	end

end