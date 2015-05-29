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

        -- User Interface Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_PLAYER_ACTIVATED              , FTC.OnLoad )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_LAYER_POPPED           , FTC.OnLayerChange )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_LAYER_PUSHED           , FTC.OnLayerChange )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_SCREEN_RESIZED                , FTC.OnScreenResize )

        -- Target Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_RETICLE_TARGET_CHANGED        , FTC.OnTargetChanged )
            
        -- Attribute Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_POWER_UPDATE                  , FTC.OnPowerUpdate )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED   , FTC.OnVisualAdded ) 
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED , FTC.OnVisualUpdate )  
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED , FTC.OnVisualRemoved )

        -- Player State Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_PLAYER_COMBAT_STATE           , FTC.OnCombatState )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_STEALTH_STATE_CHANGED         , FTC.OnStealthState )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_DEATH_STATE_CHANGED      , FTC.OnDeath )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_WEREWOLF_STATE_CHANGED        , FTC.OnWerewolf )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_BEGIN_SIEGE_CONTROL           , FTC.OnSiege )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_END_SIEGE_CONTROL             , FTC.OnSiege )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_MOUNTED_STATE_CHANGED         , FTC.OnMount )
        
        -- Action Bar Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_SLOT_UPDATED           , FTC.OnSlotUpdate )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_SLOTS_FULL_UPDATE      , FTC.OnSwapWeapons )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTIVE_QUICKSLOT_CHANGED      , FTC.OnQuickslotChanged )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ACTION_UPDATE_COOLDOWNS       , FTC.OnUpdateCooldowns )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_INVENTORY_ITEM_USED           , FTC.OnItemUsed )

        -- Buff Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EFFECT_CHANGED                , FTC.OnEffectChanged )
        
        -- Combat Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_COMBAT_EVENT                  , FTC.OnCombatEvent )

        -- Group Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_UNIT_CREATED                  , FTC.OnUnitCreated )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_GROUP_MEMBER_LEFT             , FTC.OnGroupChanged )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_LEADER_UPDATE                 , FTC.OnGroupChanged )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_GROUP_MEMBER_CONNECTED_STATUS , FTC.OnGroupChanged )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_GROUP_MEMBER_ROLES_CHANGED    , FTC.OnGroupChanged )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_GROUP_SUPPORT_RANGE_UPDATE    , FTC.OnGroupRange )
        
        -- Experience Events
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_EXPERIENCE_UPDATE             , FTC.OnXPUpdate )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ALLIANCE_POINT_UPDATE         , FTC.OnAPUpdate )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_LEVEL_UPDATE                  , FTC.OnLevel )
        EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_VETERAN_RANK_UPDATE           , FTC.OnLevel )
    end


--[[----------------------------------------------------------
    USER INTERFACE EVENTS
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
     * Handles Interface Startup
     * --------------------------------
     * Called by EVENT_PLAYER_ACTIVATED
     * --------------------------------
     ]]--
    function FTC:OnLoad()
        EVENT_MANAGER:UnregisterForEvent( "FTC" , EVENT_PLAYER_ACTIVATED )

        -- Setup Combat Log
        if ( FTC.init.Log ) then
            CHAT_SYSTEM:Minimize()
            FTC.Log:Print( GetString(FTC_LongInfo) , {1,0.8,0} )

        -- Otherwie Print to Chat
        else d("[FTC] " .. GetString(FTC_LongInfo)) end
    end

    --[[ 
     * Handles UI Rescaling
     * --------------------------------
     * Called by EVENT_SCREEN_RESIZED
     * Called by EVENT_ACTION_LAYER_PUSHED
     * --------------------------------
     ]]--
    function FTC.OnScreenResize()
        FTC.UI:TopLevelWindow( "FTC_UI" , GuiRoot , {GuiRoot:GetWidth(),GuiRoot:GetHeight()} , {CENTER,CENTER,0,0} , false )
    end


--[[----------------------------------------------------------
    TARGET EVENTS
  ]]----------------------------------------------------------
 
    --[[ 
     * Handles Reticle Target Changes
     * --------------------------------
     * Called by EVENT_RETICLE_TARGET_CHANGED
     * --------------------------------
     ]]--
    function FTC.OnTargetChanged()
        FTC.Target:Update() 
    end


--[[----------------------------------------------------------
    ATTRIBUTE EVENTS
  ]]----------------------------------------------------------

    --[[ 
     * Handles Attribute Changes
     * --------------------------------
     * Called by EVENT_POWER_UPDATE
     * --------------------------------
     ]]--
    function FTC.OnPowerUpdate( eventCode , unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )
        
        -- Player Updates
        if ( unitTag == 'player' ) then
        
            -- Health, Magicka, and Stamina
            if ( powerType == POWERTYPE_HEALTH or powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) then
                if ( FTC.init.SCT ) then FTC.SCT:ResourceAlert( unitTag , powerType , powerValue , powerMax ) end
                FTC.Frames:UpdateAttribute( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
                
            -- Ultimate
            elseif ( powerType == POWERTYPE_ULTIMATE ) then
                FTC.Player:UpdateUltimate( powerValue , powerMax , powerEffectiveMax )
                
            -- Mount Stamina
            elseif ( powerType == POWERTYPE_MOUNT_STAMINA ) then
                if ( FTC.init.Frames ) then FTC.Frames:UpdateMount( powerValue , powerMax , powerEffectiveMax ) end 
            
            -- Werewolf
            elseif ( powerType == POWERTYPE_WEREWOLF ) then
                if ( FTC.init.Frames ) then FTC.Frames:UpdateWerewolf( powerValue, powerMax, powerEffectiveMax ) end
            end

        -- Target Updates
        elseif ( unitTag == 'reticleover' ) then
        
            -- Health
            if ( powerType == POWERTYPE_HEALTH ) then
                FTC.Frames:UpdateAttribute( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
            end
        
        -- Siege Updates
        elseif ( unitTag == 'controlledsiege' ) then
            
            -- Health
            if ( powerType == POWERTYPE_HEALTH ) then
                if ( FTC.init.Frames ) then FTC.Frames:UpdateSiege( powerValue , powerMax , powerEffectiveMax ) end
            end

        -- Group Updates
        elseif ( IsUnitGrouped('player') and string.find(unitTag,"group") ) then

            -- Health
            if ( powerType == POWERTYPE_HEALTH ) then
                if ( FTC.init.Frames ) then 
                    FTC.Frames:UpdateAttribute( unitTag , powerType , powerValue , powerMax , powerEffectiveMax )
                end
            end
        end
    end

    --[[ 
     * Handles New Visualizers
     * --------------------------------
     * Called by EVENT_UNIT_ATTRIBUTE_VISUAL_ADDED
     * --------------------------------
     ]]--
    function FTC.OnVisualAdded( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )

        -- Track Player, Target, and Group
        if ( unitTag ~= "player" and unitTag ~= "reticleover" and string.match(unitTag,"group") == nil ) then return end

        -- Health Regeneration
        if ( ( unitAttributeVisual == ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER ) and powerType == POWERTYPE_HEALTH ) then
            if ( FTC.init.Frames ) then FTC.Frames:Regen(unitTag,unitAttributeVisual,powerType,2000) end
            if ( FTC.init.SCT and unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER and unitTag == "player" ) then FTC.SCT:Cleanse() end
        
        -- Damage Shields 
        elseif ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH and value > 0) then
            if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , value , maxValue ) end
        end
    end

    --[[ 
     * Handles Updated Visualizers
     * --------------------------------
     * Called by EVENT_UNIT_ATTRIBUTE_VISUAL_UPDATED
     * --------------------------------
     ]]--             
    function FTC.OnVisualUpdate( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, oldValue, newValue, oldMaxValue, newMaxValue )

        -- Track Player, Target, and Group
        if ( unitTag ~= "player" and unitTag ~= "reticleover" and string.match(unitTag,"group") == nil ) then return end

        -- Attribute Regeneration
        if ( unitAttributeVisual == ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER ) then
            if ( FTC.init.Frames )  then FTC.Frames:Regen(unitTag,unitAttributeVisual,powerType,2000) end   

        -- Damage Shields
        elseif ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then
            if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , newValue , newMaxValue ) end
        end
    end


    --[[ 
     * Handles Removed Visualizers
     * --------------------------------
     * Called by EVENT_UNIT_ATTRIBUTE_VISUAL_REMOVED
     * --------------------------------
     ]]--  
    function FTC.OnVisualRemoved( eventCode , unitTag, unitAttributeVisual, statType, attributeType, powerType, value, maxValue )

        -- Track Player, Target, and Group
        if ( unitTag ~= "player" and unitTag ~= "reticleover" and string.match(unitTag,"group") == nil ) then return end
        
        -- Attribute Regeneration
        if ( unitAttributeVisual == ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER or unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER ) then
            if ( FTC.init.Frames )  then FTC.Frames:Regen(unitTag,unitAttributeVisual,powerType,0) end  

        -- Damage Shields
        elseif ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then

            -- Remove from Unit Frame
            if ( FTC.init.Frames ) then FTC.Frames:UpdateShield( unitTag , 0 , maxValue ) end

            -- Verify the shield was removed due to simultaneous damage
            if ( FTC.Damage.lastIn >= GetGameTimeMilliseconds() - 5 ) then
                if ( FTC.init.Buffs and unitTag == "player" ) then FTC.Buffs:ClearShields() end
            end
        end
    end 


--[[----------------------------------------------------------
    PLAYER STATE EVENTS
  ]]----------------------------------------------------------

    --[[ 
     * Handles Combat State Changes
     * --------------------------------
     * Called by EVENT_PLAYER_COMBAT_STATE
     * --------------------------------
     ]]--
    function FTC.OnCombatState( eventCode, inCombat )

        -- Control frame visibility
        if ( FTC.init.Frames ) then FTC.Frames:Fade('player',FTC_PlayerFrame) end

        -- Trigger an alert
        if ( FTC.init.SCT ) then FTC.SCT:Combat(inCombat) end
    end

    --[[ 
     * Handles Stealth State Changes
     * --------------------------------
     * Called by EVENT_STEALTH_STATE_CHANGED
     * --------------------------------
     ]]--
    function FTC.OnStealthState( eventCode, unitTag , stealthState )

        -- Stealth buff
        if ( FTC.init.Buffs and unitTag == 'player' ) then 

            -- Entered stealth
            local hidden        = GetAbilityName(20309)
            if ( stealthState == STEALTH_STATE_HIDDEN or stealthState == STEALTH_STATE_HIDDEN_ALMOST_DETECTED or stealthState == STEALTH_STATE_STEALTH or stealthState == STEALTH_STATE_STEALTH_ALMOST_DETECTED ) then

                -- Setup buff object
                local ability  = {
                    ["owner"]  = FTC.Player.name,
                    ["id"]     = 20309,
                    ["name"]   = hidden,
                    ["cast"]   = 0,
                    ["dur"]    = 0,
                    ["tex"]    = FTC.UI.Textures[hidden],
                    ["ground"] = false,
                    ["area"]   = false,
                    ["debuff"] = false,
                    ["toggle"] = "T"
                }
                FTC.Buffs:NewEffect( ability )

            -- Remove stealth buff
            elseif ( FTC.Buffs.Player[hidden] ~= nil ) then
                local buff = FTC.Buffs.Player[hidden]
                FTC.Buffs.Pool:ReleaseObject(buff.control.id)
                FTC.Buffs.Player[hidden] = nil 
            end
        end
    end

    --[[ 
     * Handles Death-Related Events
     * --------------------------------
     * Called by EVENT_UNIT_DEATH_STATE_CHANGED
     * --------------------------------
     ]]--
    function FTC:OnDeath( ... )

        -- Get the unitTag
        local unitTag = select( 2 , ... )

        -- Wipe player buffs
        if ( FTC.init.Buffs and unitTag == 'player' ) then FTC.Buffs:WipeBuffs(FTC.Player.name) end

        -- Reset the group frames
        if ( FTC.init.Frames ) then FTC.Frames:SetupGroup() end
        
        -- Display killspam alerts
       --if ( FTC.init.SCT ) then FTC.SCT:Deathspam( ... ) end
    end

    --[[ 
     * Handles Mounted State Changes
     * --------------------------------
     * Called by EVENT_MOUNTED_STATE_CHANGED
     * --------------------------------
     ]]--
    function FTC.OnMount()
        if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
    end

    --[[ 
     * Handles Siege Control State Changes
     * --------------------------------
     * Called by EVENT_BEGIN_SIEGE_CONTROL
     * Called by EVENT_END_SIEGE_CONTROL
     * --------------------------------
     ]]--
    function FTC.OnSiege()
        if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
    end

    --[[ 
     * Handles Werewolf State Changes
     * --------------------------------
     * Called by EVENT_WEREWOLF_STATE_CHANGED
     * --------------------------------
     ]]--
    function FTC.OnWerewolf()
        if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
    end


--[[----------------------------------------------------------
    ACTION BAR EVENTS
  ]]----------------------------------------------------------

    --[[ 
     * Handles Action Bar Changes
     * --------------------------------
     * Called by EVENT_ACTION_SLOT_UPDATED
     * --------------------------------
     ]]--
    function FTC.OnSlotUpdate( eventCode , slotNum )

        -- Fire callback
        CALLBACK_MANAGER:FireCallbacks( "FTC_CostChanged" )
        
        -- Update Action Bar if an ability was changed
        if ( slotNum >= 3 and slotNum <= 8 ) then FTC.Player:GetActionBar() end
    end

    --[[ 
     * Handles Action Bar Swap
     * --------------------------------
     * Called by EVENT_ACTION_SLOTS_FULL_UPDATE
     * --------------------------------
     ]]--
    function FTC:OnSwapWeapons( eventCode , isWeaponSwap )
        FTC.Player:GetActionBar()
    end

    --[[ 
     * Handles Changes to Active Quicslot
     * --------------------------------
     * Called by EVENT_ACTIVE_QUICKSLOT_CHANGED
     * --------------------------------
     ]]--
    function FTC:OnQuickslotChanged( eventCode , slotNum )
        FTC.Player:GetQuickslot(slotNum)
    end

    --[[ 
     * Handles Ability Usage Global Cooldown
     * --------------------------------
     * Called by EVENT_ACTION_UPDATE_COOLDOWNS
     * --------------------------------
     ]]--
    function FTC.OnUpdateCooldowns( ... )
        
        -- Process pending ground targets
        if ( FTC.init.Buffs ) then
            if ( FTC.Buffs.pendingGT ~= nil ) then

                -- Fire a callback to hook extensions
                CALLBACK_MANAGER:FireCallbacks( "FTC_SpellCast" , FTC.Buffs.pendingGT )
            
                -- Process the queued ground target spell
                FTC.Buffs:NewEffect( FTC.Buffs.pendingGT )
                
                -- Clear the queue
                FTC.Buffs.pendingGT = nil
            end
        end

        -- Maybe fire a potion alert
        if ( FTC.init.SCT ) then FTC.SCT:Potion() end
    end

    --[[ 
     * Handles Quickslot Item Usage
     * --------------------------------
     * Called by EVENT_INVENTORY_ITEM_USED
     * --------------------------------
     ]]--
    function FTC.OnItemUsed( eventCode , itemSoundCategory )

        -- Process potion consumption
        if( itemSoundCategory == ITEM_SOUND_CATEGORY_POTION ) then 
            if ( FTC.init.Buffs ) then 
                FTC.Buffs:NewEffect( FTC.Player.Quickslot ) 
                FTC.Player.canPotion = false
            end
        end
    end


--[[----------------------------------------------------------
    BUFF EVENTS
  ]]----------------------------------------------------------

    --[[ 
     * Handles Buff Effect Changes
     * --------------------------------
     * Called by EVENT_EFFECT_CHANGED
     * --------------------------------
     ]]--
    function FTC.OnEffectChanged( eventCode , changeType , effectSlot , effectName , unitTag , beginTime , endTime , stackCount , iconName , buffType , effectType , abilityType , statusEffectType )
        
        -- Pass information to buffs component
        if ( FTC.init.Buffs ) then FTC.Buffs:EffectChanged( changeType , unitTag , effectName , endTime , abilityType , iconName ) end
    end

--[[----------------------------------------------------------
    COMBAT EVENTS
  ]]----------------------------------------------------------
  
    --[[ 
     * Handles Combat Events
     * --------------------------------
     * Called by EVENT_COMBAT_EVENT
     * --------------------------------
     ]]--
    function FTC.OnCombatEvent( eventCode , result , isError , abilityName , abilityGraphic , abilityActionSlotType , sourceName , sourceType , targetName , targetType , hitValue , powerType , damageType , log )

        -- Ignore errors
        if ( isError ) then return end

        -- Pass damage event to handler
        FTC.Damage:New( result , abilityName , abilityGraphic , abilityActionSlotType , sourceName , sourceType , targetName , targetType , hitValue , powerType , damageType )
    end


--[[----------------------------------------------------------
    GROUP EVENTS
  ]]----------------------------------------------------------

    --[[ 
     * Handles Group Composition Changes
     * --------------------------------
     * Called by EVENT_GROUP_MEMBER_JOINED
     * Called by EVENT_GROUP_MEMBER_LEFT
     * --------------------------------
     ]]--
    function FTC:OnGroupChanged()
        if ( FTC.init.Frames ) then FTC.Frames:SetupGroup() end    end

    function FTC:OnUnitCreated( unitTag )
        if ( string.find(unitTag,"group") > 0 and FTC.init.Frames ) then FTC.Frames:SetupGroup() end
    end

    --[[ 
     * Handles Group Member Range Changes
     * --------------------------------
     * Called by EVENT_GROUP_SUPPORT_RANGE_UPDATE
     * --------------------------------
     ]]--
    function FTC.OnGroupRange( eventCode , unitTag , inRange )
        if ( FTC.init.Frames ) then FTC.Frames:GroupRange( unitTag , inRange ) end
    end


--[[----------------------------------------------------------
    EXPERIENCE EVENTS
  ]]----------------------------------------------------------

    --[[ 
     * Handles Experience Gain
     * --------------------------------
     * Called by EVENT_EXPERIENCE_UPDATE
     * --------------------------------
     ]]--
    function FTC.OnXPUpdate( eventCode , unitTag , currentExp , maxExp , reason )
        if ( unitTag ~= 'player' ) then return end

        -- Generate SCT Alert
        if ( FTC.init.SCT ) then FTC.SCT:NewExp( currentExp , maxExp , reason ) end

        -- Log experience gain
        if ( FTC.init.Log ) then FTC.Log:Exp( currentExp , reason ) end

        -- Update the data table
        FTC.Player:GetLevel()
        
        -- Update the experience bar
        if ( FTC.init.Frames ) then FTC.Frames:SetupAltBar() end
    end

    --[[ 
     * Handles Alliance Point Gain
     * --------------------------------
     * Called by EVENT_ALLIANCE_POINT_UPDATE
     * --------------------------------
     ]]--
    function FTC.OnAPUpdate( ... )
        if ( FTC.init.SCT ) then FTC.SCT:NewAP( ... ) end
        if ( FTC.init.Log ) then FTC.Log:AP( ... ) end
    end

    --[[ 
     * Handle Player Level-Up
     * --------------------------------
     * Called by EVENT_LEVEL_UPDATE
     * Called by EVENT_VETERAN_RANK_UPDATE
     * --------------------------------
     ]]--
    function FTC:OnLevel( ... )

        -- Update character level on unit frames
        if ( FTC.init.Frames ) then 
            FTC.Frames:SetupPlayer() 
            FTC.Frames:SetupGroup()
        end
    end

