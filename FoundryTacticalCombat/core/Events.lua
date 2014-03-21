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
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_RETICLE_TARGET_CHANGED  		, FTC.OnTargetChanged )
	
	-- Interface Events
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_RETICLE_HIDDEN_UPDATE  		, FTC.OnReticleHidden )
	
	-- Buff Events
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EFFECT_CHANGED 				, FTC.OnEffectChanged )
	
	-- Combat Events
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_COMBAT_EVENT 					, FTC.OnCombatEvent )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_DEATH_STATE_CHANGED		, FTC.OnDeath )
	
	-- Experience Events
	--EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EXPERIENCE_UPDATE 			, FTC.OnXPUpdate )
	--EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_VETERAN_POINTS_UPDATE 		, FTC.OnVPUpdate )
	--EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ALLIANCE_POINT_UPDATE  		, FTC.OnAPUpdate )
	
	-- Attribute Changes
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_POWER_UPDATE 					, FTC.OnPowerUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_STATS_UPDATED 				, FTC.OnStatsUpdated )
	
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED  	, FTC.OnVisualAdded ) 
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED , FTC.OnVisualRemoved )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED , FTC.OnVisualUpdate )
	
	-- Mount Events
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_MOUNTED_STATE_CHANGED			, FTC.OnMount )
end

--[[ 
 * Unregisters event listeners that are no longer needed due to FTC overrides
 * Runs during FTC:Initialize()
 ]]--
function FTC:UnregisterEvents()

	-- We no longer need to initialize
	EVENT_MANAGER:UnregisterForEvent( "FTC" , EVENT_ADD_ON_LOADED )

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
	local unitTag 	= select( 5 , ... )

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
		["target"]	= targetName,
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
	if ( FTC.init.SCT ) then FTC.SCT:NewCombat( damage , context ) end
	
	-- Pass damage to damage meter tracking
	if ( FTC.Damage.init ) then	FTC.Damage:UpdateMeter( damage , context ) end
end


--[[ 
 * Runs on the EVENT_UNIT_DEATH_STATE_CHANGED listener.
 * This handler fires every time a valid unitTag dies or is resurrected
 ]]--
function FTC.OnDeath( ... )
	
	-- Do stuff to the player frame
	
	-- Do stuff to the target frame
	
	-- Display killspam alerts
	
	--d( 'something died!' )
	
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
		FTC.SCT:NewAP( ... )
	end

end


--[[ 
 * Runs on the EVENT_POWER_UPDATE listener.
 * This handler fires every time a player's attribute changes
 ]]--
function FTC.OnPowerUpdate( eventCode , unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )
	
	-- Update Health/Stamina/Magicka
	if ( ( unitTag == 'player' or unitTag == 'reticleover' ) and ( powerType == POWERTYPE_HEALTH or powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) ) then 
		FTC.Frames:UpdateFrame( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
	
	-- Update Ultimate	
	elseif ( unitTag == 'player' and powerType == POWERTYPE_ULTIMATE ) then
		FTC.Frames:UpdateUltimate( powerValue , powerMax , powerEffectiveMax )
	
	-- Update Mount Stamina
	elseif ( FTC.Frames.init and unitTag == 'player' and powerType == POWERTYPE_MOUNT_STAMINA ) then
		FTC.Frames:UpdateMount( powerValue , powerMax , powerEffectiveMax )

	-- Update Target-of-Target Health
	elseif ( FTC.Frames.init and unitTag == "reticleovertarget" and powerType == POWERTYPE_HEALTH ) then
		FTC.Frames:UpdateTarTar( powerValue , powerMax , powerEffectiveMax )
	end

end

--[[ 
 * Runs on the EVENT_STATS_UPDATED listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnStatsUpdated( ... )

	-- Pass updated attributes to unit frames
	if ( FTC.Player.init ) then 
		FTC.Player:Update( ... )
	end

end

--[[ 
 * Runs on the EVENT_MOUNTED_STATE_CHANGED listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnMount( ... )

	-- Display the custom horse stamina bar
	if ( FTC.Frames.init ) then 
		FTC.Frames:DisplayMount( ... )
	end

end


--[[ 
 * Runs on the EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED listener.
 * This handler fires every time a damage shield, buff, or other "visual" effect occurs
 ]]--
function FTC.OnVisualAdded( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )

	-- We only care about player and reticletarget
	if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end

	-- Damage Shields
	if ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then
		FTC.Frames:UpdateShield( unitTag , value , maxValue )
	end
end


--[[ 
 * Runs on the EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED listener.
 * This handler fires every time a damage shield, buff, or other "visual" effect occurs
 ]]--				
function FTC.OnVisualUpdate( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, oldValue, newValue, oldMaxValue, newMaxValue )

	-- We only care about player and reticletarget
	if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end
	
	-- Damage Shields
	if ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then
		FTC.Frames:UpdateShield( unitTag , newValue , newMaxValue )
	end
end


--[[ 
 * Runs on the EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED listener.
 * This handler fires every time a damage shield, buff, or other "visual" effect occurs
 ]]--				
function FTC.OnVisualRemoved( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )

	-- We only care about player and reticletarget
	if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end
	
	-- Damage Shields
	if ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then
		FTC.Frames:UpdateShield( unitTag , 0 , maxValue )
	end
end