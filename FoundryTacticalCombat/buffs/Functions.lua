
--[[----------------------------------------------------------
    BUFF TRACKING COMPONENT
  ]]----------------------------------------------------------
FTC.Buffs = {}
FTC.Buffs.Defaults = {

    -- Player Buffs
    ["FTC_PlayerBuffs"]         = {CENTER,CENTER,0,400},  
    ["PlayerBuffFormat"]        = "htiles",
    ["FTC_LongBuffs"]           = {BOTTOMRIGHT,BOTTOMRIGHT,-2,-2},
    ["LongBuffFormat"]          = "vtiles",

    -- Player Debuffs
    ["FTC_PlayerDebuffs"]       = {CENTER,CENTER,0,500},
    ["PlayerDebuffFormat"]      = "htiles",

    -- Target Buffs
    ["FTC_TargetBuffs"]         = {CENTER,CENTER,0,-500},
    ["TargetBuffFormat"]        = "htiles",

    -- Target Debuffs
    ["FTC_TargetDebuffs"]       = {CENTER,CENTER,0,-400},
    ["TargetDebuffFormat"]      = "htiles",

    -- Shared Settings  
    ["MaxBuffs"]                = 8,
    ["AnchorBuffs"]             = true,

    -- Fonts
    ["BuffsFont1"]              = 'esobold',
    ["BuffsFont2"]              = 'esobold',
    ["BuffsFontSize"]           = 18,

}
FTC:JoinTables(FTC.Defaults,FTC.Buffs.Defaults)

--[[----------------------------------------------------------
    BUFF TRACKING FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Initialize Buff Tracking Component
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--
function FTC.Buffs.Initialize()

    -- Setup displayed buff tables
    FTC.Buffs.Player = {}
    FTC.Buffs.Target = {}

    -- Saved effects
    FTC.Buffs.Saved  = {}
    
    -- Create the controls
    FTC.Buffs:Controls()

    -- Populate initial buffs
    FTC.Buffs:GetBuffs('player')

    -- Setup action bar hooks
    FTC.Buffs:SetupActionBar()
    
    -- Setup status flags
    FTC.Buffs.lastCast  = 0
    
    -- Register init status
    FTC.init.Buffs = true

    -- Activate updating
    EVENT_MANAGER:RegisterForUpdate( "FTC_PlayerBuffs"   , 100 , function() FTC.Buffs:Update('player') end )
    EVENT_MANAGER:RegisterForUpdate( "FTC_TargetDebuffs" , 100 , function() FTC.Buffs:Update('reticleover') end )
end

--[[ 
 * Setup Action Bar to Report Casts
 * --------------------------------
 * Called by FTC.Buffs:Initialize()
 * Credit goes to Spellbuilder for the clever idea!
 * --------------------------------
 ]]--
function FTC.Buffs:SetupActionBar()

    -- Store the original action button SetState function
    FTC.Buffs.SetStateOrig = ActionButton3Button.SetState

    -- Replace the SetState method for each action button with my custom function
    for i = 3 , 8 do
        local button    = _G["ActionButton"..i.."Button"]
        button.SetState = FTC.Buffs.SetStateCustom
    end
end

--[[ 
 * Custom Action Button SetState Function
 * --------------------------------
 * Called by FTC.Buffs:SetupActionBar()
 * --------------------------------
 ]]--
function FTC.Buffs.SetStateCustom( self , state , locked )

    -- Get the original function return
    local retval = FTC.Buffs.SetStateOrig( self , state , locked )

    -- Get the pressed slot
    local slot = self.slotNum

    -- Get the used ability
    local ability = FTC.Player.Abilities[slot]

    -- Bail if the ability is unrecognized
    if ( ability == nil ) then return retval end

    -- The button is being depressed
    if ( state == BSTATE_PRESSED ) then

        -- Clear any pending ground target
        if ( FTC.Buffs.pendingGT ~= nil and FTC.Buffs.pendingGT.name == ability.name ) then FTC.Buffs.pendingGT = nil end

    -- The button is being released
    elseif ( state == BSTATE_NORMAL ) then

        -- Get the time
        local time = GetGameTimeMilliseconds()

        -- Avoid skill failure and spamming
        if ( FTC.Buffs:HasFailure(slot) or ( time < ( FTC.Buffs.lastCast or 0 ) + 500 ) ) then return retval end

        -- Put ground target abilities into the pending queue
        if ( ability.ground ) then 
            FTC.Buffs.pendingGT = ability
            return retval
        end
        
        -- Fire a callback to hook extensions
        CALLBACK_MANAGER:FireCallbacks( "FTC_SpellCast" , ability )

        -- Register abilities with durations or custom effects
        if ( ( ability.effects ~= nil ) or ( ability.dur > 0 ) ) then FTC.Buffs:NewEffect( ability ) end

        -- Flag the last cast time  
        FTC.Buffs.lastCast = time
    end

    -- Return the original function
    return retval
end

--[[----------------------------------------------------------
    EVENT HANDLERS
  ]]----------------------------------------------------------

--[[ 
 * Get Unit Buffs
 * --------------------------------
 * Called by FTC.Buffs:Initialize()
 * Called by FTC.OnTargetChanged()
 * Called by FTC.OnEffectChanged()
 * --------------------------------
 ]]--
function FTC.Buffs:GetBuffs( unitTag )

    -- Only take action for player and target
    if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end

    -- Get the context
    local context = ( unitTag == 'player' ) and "Player" or "Target"
    
    -- Get the number of buffs currently affecting the target
    local nbuffs = GetNumBuffs( unitTag )
    
    -- Bail if the target has no buffs
    if ( nbuffs == 0 ) then return end
    
    -- Iterate through buffs, adding them to the active buffs table
    for i = 1 , nbuffs do
    
        -- Get the buff information
        local buffName , timeStarted , timeEnding , buffSlot , stackCount , iconFilename , buffType , effectType , abilityType , statusEffectType , abilityId , canClickOff = GetUnitBuffInfo( unitTag , i )
        
        -- Run the effect through a filter
        isValid, buffName, isType , iconFilename = FTC:FilterBuffInfo( unitTag , buffName , abilityType , iconFilename )
        if ( isValid ) then 

            -- Get the remaining duration
            local duration  = (timeEnding - GetFrameTimeSeconds()) * 1000

            -- Setup the ability object
            local ability = {
                ["owner"]   = GetUnitName( unitTag ),
                ["name"]    = buffName,
                ["dur"]     = duration, 
                ["cast"]    = 0,
                ["debuff"]  = effectType == BUFF_EFFECT_TYPE_DEBUFF,
                ["toggle"]  = isType,
                ["tex"]     = iconFilename,
            }

            -- Pass it to the buff handler
            FTC.Buffs:NewEffect( ability )  
        end
    end
end

--[[ 
 * Handle Effect Change Event
 * --------------------------------
 * Called by FTC.OnEffectChanged()
 * --------------------------------
 ]]--
function FTC.Buffs:EffectChanged( changeType , unitTag , effectName , endTime , abilityType , iconName )

    -- Only take action for player and target
    if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end

    -- Get the context
    local context = ( unitTag == 'player' ) and "Player" or "Target"
    
    -- Filter the buff
    isValid, effectName, isType , iconName = FTC:FilterBuffInfo( unitTag , effectName , abilityType , iconName )
        
    -- Remove an existing effect
    if ( changeType == 2 and isValid ) then
        FTC.Buffs[context][effectName] = nil 
        FTC.Buffs:ReleaseUnusedBuffs()
    else
        
        -- Get the remaining duration
        local duration  = (endTime - GetFrameTimeSeconds()) * 1000

        -- Add a new effect
        local ability = {
            ["owner"]   = GetUnitName( unitTag ),
            ["name"]    = effectName,
            ["dur"]     = duration,
            ["cast"]    = 0,
            ["debuff"]  = effectType == BUFF_EFFECT_TYPE_DEBUFF,
            ["toggle"]  = isType,
            ["tex"]     = iconName,
        }

        -- Pass it to the buff handler
        FTC.Buffs:NewEffect( ability )  
    end
end

--[[ 
 * Register New Buffs
 * --------------------------------
 * Called by FTC.Buffs.SetStateCustom()
 * Called by FTC.OnTargetChanged()
 * Called by FTC.OnEffectChanged()
 * --------------------------------
 ]]--
function FTC.Buffs:NewEffect( ability )

    -- Get the time
    local ms = GetGameTimeMilliseconds()

    -- Get ability info
    local effects   = ability.effects
    local castTime  = ( ability.cast ~= nil ) and ( ability.cast or 0 ) or ( effects[3] or 0 ) * 1000

    -- Setup buff object
    local buffTemplate = {
        ["owner"]   = ability.owner,
        ["name"]    = ability.name,
        ["stacks"]  = 0,
        ["debuff"]  = ability.debuff or false,
        ["area"]    = ability.area   or false,
        ["toggle"]  = ability.toggle,        
        ["icon"]    = ability.tex,
        ["begin"]   = ( ms + castTime ) / 1000,
    }

    -- Arbitrate context
    local context   = ( ability.owner == FTC.Player.name ) and "Player" or "Target"

    -- Custom tracked effects
    if ( effects ~= nil ) then

        -- Custom buffs
        if ( effects[1] > 0 ) then

            -- Add buff data
            local newBuff   = buffTemplate
            newBuff.ends    = ( ( ms + castTime ) / 1000 ) + effects[1]

            -- Assign buff to pooled control
            local control, objectKey = FTC.Buffs.Pool:AcquireObject()
            control.id      = objectKey
            control.icon:SetTexture(newBuff.icon)
            control.frame:SetDrawLayer(DL_BACKGROUND)
            control.backdrop:SetDrawLayer(DL_BACKGROUND)
            control.cooldown:SetDrawLayer(DL_CONTROLS)
            control.icon:SetDrawLayer(DL_CONTROLS) 
            newBuff.control = control

            -- Add buff to timed table
            FTC.Buffs[context][ability.name] = newBuff
        end

        -- Custom debuffs
        if ( effects[2] > 0 ) then

            -- Add buff data
            local newBuff   = buffTemplate
            newBuff.owner   = DoesUnitExist('reticleover') and GetUnitName('reticleover') or FTC.Target.name
            newBuff.ends    = ( ( ms + castTime ) / 1000 ) + effects[2]
            newBuff.debuff  = true

            -- Assign buff to pooled control
            local control, objectKey = FTC.Buffs.Pool:AcquireObject()
            control.id      = objectKey
            control.icon:SetTexture(newBuff.icon)
            control.frame:SetDrawLayer(DL_BACKGROUND)
            control.backdrop:SetDrawLayer(DL_BACKGROUND)
            control.cooldown:SetDrawLayer(DL_CONTROLS)
            control.icon:SetDrawLayer(DL_CONTROLS) 
            newBuff.control = control

            -- Add debuff to timed table
            FTC.Buffs.Target[ability.name] = newBuff
        end

    -- API timed effects
    elseif ( ability.dur > 0 ) then

        -- Add buff data
        local newBuff       = buffTemplate
        newBuff.ends        = ( ms + ability.cast + ability.dur ) / 1000

        -- Assign buff to pooled control
        local control, objectKey = FTC.Buffs.Pool:AcquireObject()
        control.id          = objectKey
        control.icon:SetTexture(newBuff.icon)
        control.frame:SetDrawLayer(DL_BACKGROUND)
        control.backdrop:SetDrawLayer(DL_BACKGROUND)
        control.cooldown:SetDrawLayer(DL_CONTROLS)
        control.icon:SetDrawLayer(DL_CONTROLS) 
        newBuff.control     = control

        -- Add buff to timed table
        FTC.Buffs[context][ability.name] = newBuff

    -- API tracked toggles
    elseif ( ability.toggle ~= nil ) then

        -- Add buff data
        local newBuff       = buffTemplate
        newBuff.ends        = 0
        
        -- Assign buff to pooled control
        local control, objectKey = FTC.Buffs.Pool:AcquireObject()
        control.id       = objectKey
        control.icon:SetTexture(newBuff.icon)
        control.frame:SetDrawLayer(DL_BACKGROUND)
        control.backdrop:SetDrawLayer(DL_BACKGROUND)
        control.cooldown:SetDrawLayer(DL_CONTROLS)
        control.icon:SetDrawLayer(DL_CONTROLS) 
        newBuff.control = control

        -- Add buff to timed table
        FTC.Buffs[context][ability.name] = newBuff
    end

    -- Release any unused objects
    FTC.Buffs:ReleaseUnusedBuffs()
end

 --[[ 
 * Wipe Out Buffs on Death
 * --------------------------------
 * Called by FTC:OnDeath()
 * --------------------------------
 ]]--
function FTC.Buffs:WipeBuffs( unitTag )

    -- Only proceed for player or target deaths
    if ( unitTag ~= 'player' and unitTag ~= 'reticleover' ) then return end
    local context = ( unitTag == 'player' ) and "Player" or "Target"
    
    -- Wipe out buffs that are specific to the deceased
    for name , buff in pairs( FTC.Buffs[context] ) do
        if ( buff.owner == GetUnitName( unitTag ) and buff.area == false ) then
            FTC.Buffs.Pool:ReleaseObject(buff.control.id)
            FTC.Buffs[context][name] = nil
        end 
    end
end

--[[----------------------------------------------------------
    UPDATING FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Buff Tracking Updating Function
 * --------------------------------
 * Called by FTC_PlayerBuffs:OnUpdate()
 * Called by FTC_TargetBuffs:OnUpdate()
 * --------------------------------
 ]]--
function FTC.Buffs:Update( unitTag )

    -- Get context
    local context       = ( unitTag == 'player' ) and "Player" or "Target"

    -- Hide target buffs if we have no target
    FTC_TargetBuffs:SetHidden( context == "Target" and FTC.init.Frames and FTC_TargetFrame:IsHidden() ) 
    
    -- Bail out if no buffs are present
    if ( next(FTC.Buffs[context]) == nil ) then return end

    -- Convert the buffs table to an indexed array
    local buffs = {}
    for k,v in pairs( FTC.Buffs[context] ) do table.insert( buffs , v ) end
    table.sort( buffs , FTC.Buffs.Sort )

    -- Track counters
    local gameTime      = GetGameTimeMilliseconds() / 1000
    local buffCount     = 0
    local debuffCount   = 0
    local longCount     = 0
        
    -- Loop through buffs
    for i = 1 , #buffs do
    
        -- Bail out if we have already rendered the maximum allowable buffs
        local isCapped  = ( buffCount > FTC.Vars.MaxBuffs ) and ( debuffCount > FTC.Vars.MaxBuffs ) and ( ( context == "Player" and longCount > FTC.Vars.MaxBuffs ) or context == "Target" )
        if ( isCapped ) then break end
    
        -- Gether data
        local name      = buffs[i].name
        local isLong    = ( context == "Player" and buffs[i].toggle ~= nil )
        local label     = buffs[i].toggle or ""
        local control   = buffs[i].control
        local render    = true
        local duration  = math.floor( ( buffs[i].ends - gameTime ) * 10 ) / 10 
        
        -- Skip abilities which have not begun yet
        if ( buffs[i].begin > gameTime ) then render = false end

        -- Purge expired abilities
        if ( duration <= 0 and buffs[i].toggle == nil ) then
            FTC.Buffs[context][name] = nil 
            FTC.Buffs.Pool:ReleaseObject(control.id)

        -- Handle single-target buffs belonging to others
        elseif ( buffs[i].owner ~= GetUnitName(unitTag) and not buffs[i].area ) then
        
            -- Purge non-timed abilities
            if ( buffs[i].toggle ~= nil ) then
                FTC.Buffs[context][name] = nil 
                FTC.Buffs.Pool:ReleaseObject(control.id)
           
            -- Ensure that single-target timed abilities are hidden
            else control:SetHidden(true) end

        -- Otherwise process away!
        else
            if ( duration > 0 ) then 

                -- Flag long buffs
                isLong = ( context == "Player" and duration >= 60 ) and true or isLong
                    
                -- Duration in hours
                if ( duration > 3600 ) then
                    local hours     = math.floor( duration / 3600 )
                    label           = string.format( "%dh" , hours )
                
                -- Duration in minutes
                elseif ( duration > 60 ) then   
                    local minutes   = math.floor( duration / 60 )
                    label           = string.format( "%dm" , minutes )
                
                -- Duration in seconds
                else label = string.format( "%.1f" , duration ) end
            end

            -- Update labels
            control:SetHidden(true)
            control.name:SetHidden(true)
            control.label:SetText(label)
            control.name:ClearAnchors()
            control.name:SetAnchor(LEFT,control,RIGHT,10,0)
            control.name:SetHorizontalAlignment(0)
            control.name:SetText(name)

            -- Long Buffs
            if ( context == "Player" and isLong and ( FTC.Vars.LongBuffFormat ~= "disabled" ) ) then
                local container =  _G["FTC_LongBuffs"]

                -- Determine the anchor
                local lbAnchor = {}
                if ( FTC.Vars.LongBuffFormat == "vtiles" ) then      lbAnchor = {BOTTOMRIGHT,container,BOTTOMRIGHT,0,(longCount*-50)}
                elseif ( FTC.Vars.LongBuffFormat == "htiles" ) then  lbAnchor = {BOTTOMRIGHT,container,BOTTOMRIGHT,(longCount*-50),0}
                elseif ( FTC.Vars.LongBuffFormat == "dlist" ) then   lbAnchor = {TOPRIGHT,container,TOPRIGHT,0,(longCount*50)}
                elseif ( FTC.Vars.LongBuffFormat == "alist" ) then   lbAnchor = {BOTTOMRIGHT,container,BOTTOMRIGHT,0,(longCount*-50)} end

                -- Move the control into the container and anchor it
                control:SetParent(container)
                control:ClearAnchors()
                control:SetAnchor(unpack(lbAnchor))
                control.frame:SetTexture('/esoui/art/actionbar/magechamber_firespelloverlay_down.dds')
                control.name:ClearAnchors()
                control.name:SetAnchor(RIGHT,control,LEFT,-10,0)
                control.name:SetHorizontalAlignment(2)
                control.name:SetHidden(string.match(FTC.Vars.LongBuffFormat,"list") == nil)
                control:SetHidden(false)

                -- Update the count
                longCount = longCount + 1

                -- Update the container height
                if ( FTC.Vars.LongBuffFormat ~= "htiles" ) then container:SetHeight(longCount*50) end

            -- Debuffs
            elseif ( buffs[i].debuff and ( FTC.Vars[context.."DebuffFormat"] ~= "disabled" ) ) then
                local container =  _G["FTC_"..context.."Debuffs"]

                -- Determine the anchor
                local dbAnchor = {}
                if ( FTC.Vars[context.."DebuffFormat"] == "htiles" ) then     dbAnchor = {TOPLEFT,container,TOPLEFT,(debuffCount*50),0}
                elseif ( FTC.Vars[context.."DebuffFormat"] == "vtiles" ) then dbAnchor = {TOPLEFT,container,TOPLEFT,0,(debuffCount*50)}
                elseif ( FTC.Vars[context.."DebuffFormat"] == "dlist" ) then  dbAnchor = {TOPLEFT,container,TOPLEFT,0,(debuffCount*50)}
                elseif ( FTC.Vars[context.."DebuffFormat"] == "alist" ) then  dbAnchor = {BOTTOMLEFT,container,BOTTOMLEFT,0,(debuffCount*-50)} end

                -- Move the control into the container and anchor it
                control:SetParent(container)
                control:ClearAnchors()
                control:SetAnchor(unpack(dbAnchor))
                control.frame:SetTexture('/esoui/art/actionbar/debuff_frame.dds')
                control.cooldown:StartCooldown( ( buffs[i].ends - gameTime ) * 1000 , ( buffs[i].ends - buffs[i].begin ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
                control.name:SetHidden(string.match(FTC.Vars[context.."DebuffFormat"],"list") == nil)
                control:SetHidden(false)

                -- Update the count
                debuffCount = debuffCount + 1

                -- Update the container height
                if ( FTC.Vars[context.."DebuffFormat"] ~= "htiles" ) then container:SetHeight(debuffCount*50) end

            -- Buffs
            elseif ( not isLong and ( FTC.Vars[context.."BuffFormat"] ~= "disabled" ) ) then
                local container =  _G["FTC_"..context.."Buffs"]

                -- Determine the anchor
                local bAnchor = {}
                if ( FTC.Vars[context.."BuffFormat"] == "htiles" ) then       bAnchor = {TOPLEFT,container,TOPLEFT,(buffCount*50),0}
                elseif ( FTC.Vars[context.."BuffFormat"] == "vtiles" ) then   bAnchor = {TOPLEFT,container,TOPLEFT,0,(buffCount*50)}
                elseif ( FTC.Vars[context.."BuffFormat"] == "dlist" ) then    bAnchor = {TOPLEFT,container,TOPLEFT,0,(buffCount*50)}
                elseif ( FTC.Vars[context.."BuffFormat"] == "alist" ) then    bAnchor = {BOTTOMLEFT,container,BOTTOMLEFT,0,(buffCount*-50)} end

                -- Move the control into the container and anchor it
                control:SetParent(container)
                control:ClearAnchors()
                control:SetAnchor(unpack(bAnchor))
                control.frame:SetTexture('/esoui/art/actionbar/buff_frame.dds')
                control.cooldown:StartCooldown( ( buffs[i].ends - gameTime ) * 1000 , ( buffs[i].ends - buffs[i].begin ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
                control.name:SetHidden(string.match(FTC.Vars[context.."BuffFormat"],"list") == nil)
                control:SetHidden(false)

                -- Update the count
                buffCount = buffCount + 1

                -- Update the container height
                if ( FTC.Vars[context.."BuffFormat"] ~= "htiles" ) then container:SetHeight(buffCount*50) end  
            end
        end
    end
end

--[[----------------------------------------------------------
    HELPER FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Sort Buffs Table by Duration
 * --------------------------------
 * Called by Buffs:Update()
 * --------------------------------
 ]]--
function FTC.Buffs.Sort(x,y)
    if ( x.toggle == "P" and y.toggle == "T" ) then return true
    elseif ( x.toggle ~= nil ) then return false 
    elseif ( y.toggle ~= nil ) then return true
    else return x.ends < y.ends end
end


--[[----------------------------------------------------------
    NEED WORK BELOW!
  ]]----------------------------------------------------------


--[[ 
 * Check the player's buffs for known damage shields, and purge them
 * Called by OnVisualRemoved()
 ]]--
function FTC.Buffs:RemoveVisuals( unitTag , unitAttributeVisual , powerType )

    -- For now, only do this stuff for the player
    if ( unitTag ~= 'player' ) then return end

    -- Check for damage shields
    if ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING ) then
        for name, buff in pairs( FTC.Buffs.Player ) do
            if ( FTC.Buffs:IsDamageShield( name ) ) then 
                FTC.Buffs.Player[name] = nil
            end     
        end     
    end
end

--[[ 
 * Check for whether a potion has been used
 * Runs OnUpdate - 50 ms buffer
 ]]--
function FTC.Buffs:CheckPotion()

    -- Get the current potion
    local current = GetCurrentQuickslot()

    -- Bail if there is no active potion
    if ( GetSlotName( current ) == "" ) then return end
    
    -- Get the cooldown
    local cd, dur , usable = GetSlotCooldownInfo(current)

    --local upgradeLevel = GetSkillAbilityUpgradeInfo(SKILL_TYPE_TRADESKILL, 1, 3)
    --g_potionMultiplier = 1.0 + 0.1*upgradeLevel
    
    -- Trigger an alert if the potion has just become available
    if ( usable and not FTC.Buffs.canPotion ) then
        if ( FTC.init.SCT ) then
            local newAlert = {
                ["type"]    = 'potionReady',
                ["name"]    = 'Potion Ready',
                ["value"]   = '',
                ["ms"]      = GetGameTimeMilliseconds(),
                ["color"]   = 'cffcc00',
                ["size"]    = 20
            }
            FTC.SCT:NewStatus( newAlert )
        end
    end

    -- If the potion goes on cooldown, display a new alert
    if ( FTC.Buffs.canPotion and cd > 5000 ) then
    
        -- Make sure it's a potion
        local name      = string.lower( GetSlotName(current) )
        local keys      = { "sip" , "tincture" , "dram" , "potion" , "solution" , "elixir" , "panacea" }
        local isPotion  = false
        for i = 1 , #keys do
            if ( string.find( name , keys[i] ) ) then 
                isPotion = true 
                break   
            end
        end
        if ( not isPotion ) then return end

        -- Translate the time to seconds
        local time = cd / 1000

        -- Get the current potion
        local potion        = {
            ["slot"]        = current,
            ["name"]        = name,
            ["type"]        = 'potion',
            ["tex"]         = GetSlotTexture( current ),
            ["effects"]     = { time , 0 , 0 },
        }
        
        -- Submit the effect
        --FTC.Buffs:NewEffects( potion )
    end

    -- Update the potion status
    FTC.Buffs.canPotion = usable

    -- Fire a callback when we know a spell was cast
    CALLBACK_MANAGER:FireCallbacks( "FTC_PotionUsed" , potion )
end
