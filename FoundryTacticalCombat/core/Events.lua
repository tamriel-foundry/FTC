--[[----------------------------------------------------------
    EVENTS COMPONENT
  ]]----------------------------------------------------------

--[[ 
 * Register Event Listeners
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--
function FTC:RegisterEvents()

    -- Interface Events
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_PLAYER_ACTIVATED              , FTC.OnLoad )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_LAYER_POPPED           , FTC.OnLayerChange )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_LAYER_PUSHED           , FTC.OnLayerChange )

    -- Target Events
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_RETICLE_TARGET_CHANGED        , FTC.OnTargetChanged )
        
    -- Unit Frames
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_POWER_UPDATE                  , FTC.OnPowerUpdate )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED   , FTC.OnVisualAdded ) 
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED , FTC.OnVisualRemoved )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED , FTC.OnVisualUpdate )  
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_WEREWOLF_STATE_CHANGED        , FTC.OnWerewolf )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_BEGIN_SIEGE_CONTROL           , FTC.OnSiege )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_END_SIEGE_CONTROL             , FTC.OnSiege )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_MOUNTED_STATE_CHANGED         , FTC.OnMount )
    
    -- Buff Events
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_SLOT_UPDATED           , FTC.OnSlotUpdate )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_UPDATE_COOLDOWNS       , FTC.OnUpdateCooldowns )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTIVE_WEAPON_PAIR_CHANGED    , FTC.OnSwapWeapons )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EFFECT_CHANGED                , FTC.OnEffectChanged )
    
    -- Combat Events
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_PLAYER_COMBAT_STATE           , FTC.OnCombatState )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_COMBAT_EVENT                  , FTC.OnCombatEvent )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_DEATH_STATE_CHANGED      , FTC.OnDeath )
    
    -- Experience Events
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EXPERIENCE_UPDATE             , FTC.OnXPUpdate )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_VETERAN_POINTS_UPDATE         , FTC.OnXPUpdate )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ALLIANCE_POINT_UPDATE         , FTC.OnAPUpdate )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_LEVEL_UPDATE                  , FTC.OnLevel )
    EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_VETERAN_RANK_UPDATE           , FTC.OnLevel )
end

--[[----------------------------------------------------------
    INTERFACE EVENTS
  ]]----------------------------------------------------------

--[[ 
 * Handles UI Layer Changes
 * --------------------------------
 * Called by EVENT_ACTION_LAYER_POPPED
 * Called by EVENT_ACTION_LAYER_PUSHED
 * --------------------------------
 ]]--
function FTC.OnLayerChange( eventCode, layerIndex, activeLayerIndex )
    FTC:ToggleVisibility( activeLayerIndex )
end

--[[ 
 * Displays Addon Info at Startup
 * --------------------------------
 * Called by EVENT_PLAYER_ACTIVATED
 * --------------------------------
 ]]--

function FTC:OnLoad()
    EVENT_MANAGER:UnregisterForEvent( "FTC" , EVENT_PLAYER_ACTIVATED )
    d("[FTC] " .. GetString(FTC_LongInfo))
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
    FTC.Target:Update()
    
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
function FTC.OnSlotUpdate( eventCode , slotNum )

    -- Fire callback
    CALLBACK_MANAGER:FireCallbacks( "FTC_CostChanged" )

    -- Bail if nothing was updated
    if slotNum > 8 then return end
    
    -- Update Hotbars
    FTC.Player:GetActionBar()
end


--[[ 
 * Updates Action Bar on Weapon Swap
 * --------------------------------
 * Called by EVENT_ACTIVE_WEAPON_PAIR_CHANGED
 * --------------------------------
 ]]--
function FTC:OnSwapWeapons( eventCode , activeWeaponPair , locked )
    if ( FTC.init.Buffs and not locked ) then FTC.Player:GetActionBar() end
end



--[[ 
 * Runs on the EVENT_ACTION_UPDATE_COOLDOWNS listener.
 * This handler fires every time the player uses an active ability
 ]]--
function FTC.OnUpdateCooldowns( ... )
    
    -- Maybe process a ground-target spell
    if ( FTC.init.Buffs ) then
        if ( FTC.Buffs.ground ~= nil ) then
        
            -- Process the queued ground target spell
            FTC.Buffs:NewEffects( FTC.Buffs.ground )
            
            -- Fire a callback when we know a spell was cast
            CALLBACK_MANAGER:FireCallbacks( "FTC_SpellCast" , FTC.Buffs.ground )
            
            -- Clear the queue
            FTC.Buffs.ground = nil
        end
    end
end





--[[ 
 * Runs on the EVENT_EFFECT_CHANGED listener.
 * This handler fires every time a buff effect on a valid unitTag is changed
 ]]--
function FTC.OnEffectChanged( eventCode , changeType , effectSlot , effectName , unitTag , beginTime , endTime , stackCount , iconName , buffType , effectType , abilityType , statusEffectType )

    -- Fire callback
    CALLBACK_MANAGER:FireCallbacks( "FTC_EffectChanged" ,  eventCode , changeType , effectSlot , effectName , unitTag , beginTime , endTime , stackCount , iconName , buffType , effectType , abilityType , statusEffectType )
    
    -- Otherwise retrieve current buffs if the buffs component is active
    if ( FTC.init.Buffs ) then 
        FTC.Buffs:EffectChanged( changeType , unitTag , effectName , endTime , abilityType , iconName )
    end
end

--[[----------------------------------------------------------
    COMBAT EVENTS
  ]]----------------------------------------------------------
  
--[[ 
 * Runs on the EVENT_PLAYER_COMBAT_STATE listener.
 * This handler fires every time the player's combat state changes
 ]]--
function FTC.OnCombatState( eventCode, inCombat )

    -- Maybe trigger a combat status alert
    if ( FTC.init.SCT ) then FTC.SCT:CombatStatus( inCombat ) end
end

--[[ 
 * Runs on the EVENT_COMBAT_EVENT listener.
 * This handler fires every time a combat effect is registered on a valid unitTag
 ]]--
function FTC.OnCombatEvent( eventCode , result , isError , abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log )

    -- Verify it's a valid result type
    isValid, result , abilityName , sourceType , sourceName , targetName , hitValue = FTC.Damage:Filter( result , abilityName , sourceType , sourceName , targetName , hitValue )
    if not isValid then return end

    -- Debugging
    -- d( result .. "||" ..  abilityName  .. "||" .. sourceType  .. "||" .. sourceName  .. "||" .. targetName  .. "||" .. hitValue )
    
    -- Determine the context
    local context = ( sourceType == COMBAT_UNIT_TYPE_PLAYER or sourceType == COMBAT_UNIT_TYPE_PLAYER_PET ) and "Out" or ""
    if ( sourceType == COMBAT_UNIT_TYPE_NONE ) then context = "In"
    elseif ( sourceType == COMBAT_UNIT_TYPE_GROUP ) then context = "Group" end

    -- Strip parentheses from name
    abilityName = string.gsub ( abilityName , ' %(.*%)' , "" )
    
    -- Localize damage sources
    abilityName = SanitizeLocalization(abilityName)
    
    -- Setup a new damage object
    local damage = {
        ["target"]  = targetName,
        ["source"]  = sourceName,
        ["name"]    = abilityName,
        ["result"]  = result,
        ["dam"]     = hitValue,
        ["power"]   = powerType,
        ["type"]    = damageType,
        ["ms"]      = GetGameTimeMilliseconds(),
        ["crit"]    = ( result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_DOT_TICK_CRITICAL or result == ACTION_RESULT_HOT_TICK_CRITICAL ) and true or false,
        ["heal"]    = ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) and true or false,
        ["multi"]   = 1,
    }
    
    -- Pass damage to scrolling combat text
    if ( FTC.init.SCT and context ~= "Group" ) then FTC.SCT:NewSCT( damage , context ) end
    
    -- Pass damage to damage meter tracking
    if ( FTC.init.Damage ) then FTC.Damage:UpdateMeter( damage , context ) end
    
    -- Pass damage to a callback for extensions to use
    CALLBACK_MANAGER:FireCallbacks( "FTC_NewDamage" , damage )
end

--[[ 
 * Allocates Death-Related Events
 * --------------------------------
 * Called by EVENT_UNIT_DEATH_STATE_CHANGED
 * --------------------------------
 ]]--
function FTC:OnDeath( ... )

    -- Get the unitTag
    local unitTag = select( 2 , ... )
    
    -- Wipe target buffs and debuffs
    if ( FTC.init.Buffs ) then FTC.Buffs:WipeBuffs( unitTag ) end
    
    -- Display killspam alerts
    if ( FTC.init.SCT ) then FTC.SCT:Deathspam( ... ) end
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
    if ( FTC.init.SCT ) then FTC.SCT:NewExp( ... ) end

    -- Update the data table
    FTC.Player:GetLevel()
    
    -- Update the experience bar
    if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
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
 * Handle Level-Up Events
 * --------------------------------
 * Called by EVENT_LEVEL_UPDATE
 * Called by EVENT_VETERAN_RANK_UPDATE
 * --------------------------------
 ]]--
function FTC:OnLevel( ... )

    -- Update character level on unit frames
    if ( FTC.init.Frames ) then FTC.Frames:SetupPlayer() end
end

--[[----------------------------------------------------------
    UNIT FRAME EVENTS
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
            FTC.Frames:UpdateAttribute( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
            
        -- Ultimate
        elseif ( powerType == POWERTYPE_ULTIMATE ) then
            if ( FTC.init.Hotbar ) then FTC.Hotbar:UpdateUltimate( powerValue , powerMax , powerEffectiveMax ) end
            
        -- Mount Stamina
        elseif ( powerType == POWERTYPE_MOUNT_STAMINA ) then
            if ( FTC.init.Frames ) then FTC.Frames:UpdateMount( powerValue , powerMax , powerEffectiveMax ) end 
        
        -- Werewolf
        elseif ( powerType == POWERTYPE_WEREWOLF ) then
            --if ( FTC.init.Frames ) then FTC.Frames:UpdateWerewolf( powerValue, powerMax, powerEffectiveMax ) end
        end

    -- Target updates
    elseif ( unitTag == 'reticleover' ) then
    
        -- Target health
        if ( powerType == POWERTYPE_HEALTH ) then
        
            -- Maybe trigger a resource alert
            if ( FTC.init.SCT ) then FTC.SCT:ResourceAlert( unitTag , powerType , powerValue , powerMax ) end
            
            -- Update the target frame
            FTC.Frames:UpdateAttribute( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
        end
    
    -- Siege updates
    elseif ( unitTag == 'controlledsiege' ) then
        
        -- Siege health
        if ( powerType == POWERTYPE_HEALTH ) then
            if ( FTC.init.Frames ) then FTC.Frames:UpdateSiege( powerValue , powerMax , powerEffectiveMax ) end
        end
    end
    
end

--[[ 
 * Runs on the EVENT_MOUNTED_STATE_CHANGED listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnMount()
    if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
end

--[[ 
 * Runs on the EVENT_BEGIN_SIEGE_CONTROL and EVENT_END_SIEGE_CONTROL listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnSiege()
    if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
end

--[[ 
 * Runs on the EVENT_WEREWOLF_STATE_CHANGED listener.
 * This handler fires every time the player has a change to a derived stat
 ]]--
function FTC.OnWerewolf()
    if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
end


--[[ 
 * Runs on the EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED listener.
 * This handler fires every time a damage shield, buff, or other "visual" effect occurs
 ]]--
function FTC.OnVisualAdded( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )

    -- We only care about player and reticletarget
    if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end

    -- Attribute Regeneration
    if ( unitAttributeVisual == ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER ) then
        if ( FTC.init.Frames )  then FTC.Frames:Regen(unitTag,unitAttributeVisual,powerType,2000) end   
    
    -- Damage Shields 
    elseif ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH and value > 0) then
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

    -- Attribute Regeneration
    if ( unitAttributeVisual == ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER ) then
        if ( FTC.init.Frames )  then FTC.Frames:Regen(unitTag,unitAttributeVisual,powerType,2000) end   

    -- Damage Shields
    elseif ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then
        if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , newValue , newMaxValue ) end
    end
end


--[[ 
 * Runs on the EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED listener.
 * This handler fires every time a damage shield, buff, or other "visual" effect is removed
--]]
function FTC.OnVisualRemoved( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )

    -- We only care about player and reticletarget
    if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end
    
    -- Attribute Regeneration
    if ( unitAttributeVisual == ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER ) then
        if ( FTC.init.Frames )  then FTC.Frames:Regen(unitTag,unitAttributeVisual,powerType,0) end  

    -- Damage Shields
    elseif ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then
        if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , 0 , maxValue ) end
    end
    
    -- Purge any buffs related to damage shielding
    -- if ( FTC.init.Buffs ) then FTC.Buffs:RemoveVisuals( unitTag , unitAttributeVisual , powerType ) end
end 