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
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_SLOTS_FULL_UPDATE		, FTC.OnSlotUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_SLOT_ABILITY_SLOTTED	, FTC.OnSlotUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_UPDATE_COOLDOWNS		, FTC.OnUpdateCooldowns )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EFFECT_CHANGED 				, FTC.OnEffectChanged )
	
	-- Combat Events
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_COMBAT_EVENT 					, FTC.OnCombatEvent )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_DEATH_STATE_CHANGED		, FTC.OnDeath )
	
	-- Experience Events
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EXPERIENCE_UPDATE 			, FTC.OnXPUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_VETERAN_POINTS_UPDATE 		, FTC.OnXPUpdate )
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ALLIANCE_POINT_UPDATE  		, FTC.OnAPUpdate )
	
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
	EVENT_MANAGER:UnregisterForEvent( "FTC" , EVENT_ADD_ON_LOADED )
end

--[[----------------------------------------------------------
	TARGET EVENTS
  ]]----------------------------------------------------------
 
--[[ 
 * Runs on the EVENT_RETICLE_TARGET_CHANGED listener.
 * This handler fires every time the player's reticle target changes
 ]]--
function FTC.OnTargetChanged()
		
	-- Update the target
	FTC:UpdateTarget()
	
end

--[[----------------------------------------------------------
	INTERFACE EVENTS
  ]]----------------------------------------------------------

--[[ 
 * Runs on the EVENT_RETICLE_HIDDEN_UPDATE listener.
 * This handler fires every time the interface mode is changed from reticle to cursor
 ]]--
function FTC.OnReticleHidden( ... )

	-- Toggle element visibility
	FTC:ToggleVisibility( ... )
	
end

--[[----------------------------------------------------------
	BUFF EVENTS
  ]]----------------------------------------------------------

--[[ 
 * Runs on the EVENT_ACTION_SLOTS_FULL_UPDATE listener.
 * Runs on the EVENT_ACTION_SLOT_ABILITY_SLOTTED listener.
 * Runs on the EVENT_STATS_UPDATED listener.
 * This handler fires every time the player changes the contents of their action bar
 ]]--
function FTC.OnSlotUpdate( eventCode , ... )
	
	-- Hotbars swappped
	if ( eventCode == EVENT_ACTION_SLOTS_FULL_UPDATE ) then
		FTC.Buffs:GetHotbar()
	
	-- Hotbar ability changed
	elseif ( eventCode == EVENT_ACTION_SLOT_ABILITY_SLOTTED ) then
		local isNew = select( 1 , ... )
		if ( isNew ) then FTC.Buffs:GetHotbar() end
	end		
end

--[[ 
 * Runs on the EVENT_ACTION_UPDATE_COOLDOWNS listener.
 * This handler fires every time the player uses an active ability
 ]]--
function FTC.OnUpdateCooldowns( ... )
	
	-- Maybe process a ground-target spell
	if ( FTC.init.Buffs ) then
		if ( FTC.Buffs.ground ~= nil ) then
			FTC.Buffs:NewEffects( FTC.Buffs.ground )
			FTC.Buffs.ground = nil
		end
	end
end

--[[ 
 * Runs on the EVENT_EFFECT_CHANGED listener.
 * This handler fires every time a buff effect on a valid unitTag is changed
 ]]--
function FTC.OnEffectChanged( ... )
	
	-- Otherwise retrieve current buffs if the buffs component is active
	if ( FTC.init.Buffs ) then 
	
		-- Grab relevant arguments
		local changeType 	= select( 2 , ... )
		local unitTag 		= select( 5 , ... )	

		-- Remove expired buffs
		if ( changeType == 2 ) then FTC.Buffs:Remove( ... )
		
		-- Otherwise get new buffs
		else FTC.Buffs:GetBuffs( unitTag ) end
	end
end

--[[----------------------------------------------------------
	COMBAT EVENTS
  ]]----------------------------------------------------------

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
		["result"]	= result,
		["dam"]		= hitValue,
		["power"]	= powerType,
		["type"]	= damageType,
		["ms"]		= GetGameTimeMilliseconds(),
		["crit"]	= ( result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_DOT_TICK_CRITICAL or result == ACTION_RESULT_HOT_TICK_CRITICAL ) and true or false,
		["heal"]	= ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) and true or false,
		["multi"]	= 1,
	}
	
	-- Pass damage to scrolling combat text
	if ( FTC.init.SCT ) then FTC.SCT:NewSCT( damage , context ) end
	
	-- Pass damage to damage meter tracking
	if ( FTC.init.Damage ) then	FTC.Damage:UpdateMeter( damage , context ) end
	
	-- Pass damage to a callback for extensions to use
	CALLBACK_MANAGER:FireCallbacks( "FTC_NewDamage" , damage )
end


--[[ 
 * Runs on the EVENT_UNIT_DEATH_STATE_CHANGED listener.
 * This handler fires every time a valid unitTag dies or is resurrected
 ]]--
function FTC.OnDeath( ... )

	-- Get the unitTag
	local unitTag = select( 2 , ... )
	
	-- Wipe target buffs and debuffs
	if ( FTC.init.Buffs and unitTag == 'reticleover' ) then 
		FTC.Buffs:WipeBuffs( unitTag ) 
	end
	
	-- Display killspam alerts
	if ( FTC.init.SCT ) then
		FTC.SCT:Deathspam( ... )
	end
end


--[[----------------------------------------------------------
	EXPERIENCE EVENTS
  ]]----------------------------------------------------------

--[[ 
 * Runs on the EVENT_EXPERIENCE_UPDATE listener.
 * Runs on the EVENT_VETERAN_POINTS_UPDATE listener.
 * This handler fires every time the player earns experience
 ]]--
function FTC.OnXPUpdate( ... )

	-- Pass experience to scrolling combat text component
	if ( FTC.init.SCT ) then 
		FTC.SCT:NewExp( ... )
	end
	
	-- Update the player level
	FTC.Player:GetLevel()
	
	-- Update the player frame
	if ( FTC.init.Frames ) then
		FTC.Frames:SetupPlayer( ... )
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

--[[----------------------------------------------------------
	ATTRIBUTE CHANGES
  ]]----------------------------------------------------------

--[[ 
 * Runs on the EVENT_POWER_UPDATE listener.
 * This handler fires every time a player's attribute changes
 ]]--
function FTC.OnPowerUpdate( eventCode , unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )
	
	-- Player Updates
	if ( unitTag == 'player' ) then
	
		-- Combat resources
		if ( powerType == POWERTYPE_HEALTH or powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) then
		
			-- Maybe trigger a resource alert
			if ( FTC.init.SCT ) then FTC.SCT:ResourceAlert( unitTag , powerType , powerValue , powerMax ) end
			
			-- Update the player frame
			FTC.Frames:UpdateFrame( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
			
		-- Ultimate
		elseif ( powerType == POWERTYPE_ULTIMATE ) then
			FTC.Frames:UpdateUltimate( powerValue , powerMax , powerEffectiveMax )
			
		-- Mount Stamina
		elseif ( powerType == POWERTYPE_MOUNT_STAMINA ) then
			if ( FTC.init.Frames ) then	FTC.Frames:UpdateMount( powerValue , powerMax , powerEffectiveMax )	end	
		end

	-- Target updates
	elseif ( unitTag == 'reticleover' ) then
	
		-- Target health
		if ( powerType == POWERTYPE_HEALTH ) then
		
			-- Maybe trigger a resource alert
			if ( FTC.init.SCT ) then FTC.SCT:ResourceAlert( unitTag , powerType , powerValue , powerMax ) end
			
			-- Update the target frame
			FTC.Frames:UpdateFrame( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
		end
	end
end

--[[ 
 * Runs on the EVENT_STATS_UPDATED listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnStatsUpdated( ... )

	-- Update the hotbar to account for spell cost reduction
	if ( FTC.init.Buffs ) then
		FTC.Buffs:GetHotbar()
	end
end

--[[ 
 * Runs on the EVENT_MOUNTED_STATE_CHANGED listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnMount( ... )

	-- Display the custom horse stamina bar
	if ( FTC.init.Frames ) then 
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
		if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , value , maxValue ) end
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
		if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , newValue , newMaxValue ) end
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
		if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , 0 , maxValue ) end
	end
	
	-- Purge any buffs related to damage shielding
	if ( FTC.init.Buffs ) then FTC.Buffs:RemoveVisuals( unitTag , unitAttributeVisual , powerType ) end
end