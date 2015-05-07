
--[[----------------------------------------------------------
    BUFF TRACKING COMPONENT
  ]]----------------------------------------------------------
FTC.Buffs = {}
FTC.Buffs.Defaults = {

    -- Player Buffs
    ["FTC_PlayerBuffs"]         = {CENTER,CENTER,0,400},
    ["EnableLongBuffs"]         = true,
    ["FTC_LongBuffs"]           = {BOTTOMRIGHT,BOTTOMRIGHT,-2,-2},

    -- Player Debuffs
    ["FTC_PlayerDebuffs"]       = {CENTER,CENTER,0,500},

    -- Target Buffs
    ["FTC_TargetBuffs"]         = {CENTER,CENTER,0,-500},

    -- Target Debuffs
    ["FTC_TargetDebuffs"]       = {CENTER,CENTER,0,-400},

    -- Shared Settings  
    ["AnchorBuffs"]             = true, 
    ["MaxBuffs"]                = 10,
}
FTC.JoinTables(FTC.Defaults,FTC.Buffs.Defaults)

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
    FTC.Buffs.canPotion = true
    
    -- Register init status
    FTC.init.Buffs = true

    -- Activate uldating
    EVENT_MANAGER:RegisterForUpdate( "FTC_PlayerBuffs" , 100 , function() FTC.Buffs:Update("Player") end )
    EVENT_MANAGER:RegisterForUpdate( "FTC_TargetBuffs" , 100 , function() FTC.Buffs:Update("Target") end )
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

        -- Store the pressed status
        FTC.Player.Abilities[slot].isPressed = true

        -- Clear any pending ground target
        if ( FTC.Buffs.pendingGT ~= nil and FTC.Buffs.pendingGT.name == ability.name ) then FTC.Buffs.pendingGT = nil end

    -- The button is being released
    elseif ( state == BSTATE_NORMAL ) then

        -- Get the time
        local time = GetGameTimeMilliseconds()

        -- Avoid erroneous detection, skill failure, and spamming
        if ( FTC.Buffs:HasFailure(slot) or ( not FTC.Player.Abilities[slot].isPressed ) or ( time < ( FTC.Player.Abilities[slot].lastCast or 0 ) + 500 ) ) then return retval end

        -- Put ground target abilities into the pending queue
        if ( ability.ground ) then 
            FTC.Buffs.pendingGT = ability
            return retval
        end
        
        -- Fire a callback to hook extensions
        CALLBACK_MANAGER:FireCallbacks( "FTC_SpellCast" , ability )

        -- Register the new effect
        FTC.Buffs:NewEffect( ability )

        -- Flag the last cast time
        FTC.Player.Abilities[slot].lastCast = time  
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
    local context   = ( unitTag == 'player' ) and "Player" or "Target"
    
    -- Get the number of buffs currently affecting the target
    local nbuffs = GetNumBuffs( unitTag )
    
    -- Bail if the target has no buffs
    if ( nbuffs == 0 ) then return end
    
    -- Iterate through buffs, adding them to the active buffs table
    for i = 1 , nbuffs do
    
        -- Get the buff information
        local effectName, beginTime, endTime, effectSlot, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, longTerm = GetUnitBuffInfo( unitTag , i )
        
        -- Run the effect through a filter
        isValid, effectName, isType , iconName = FTC:FilterBuffInfo( unitTag , effectName , abilityType , iconName )
        if ( isValid ) then 

            -- Setup the ability object
            local ability = {
                ["target"]  = GetUnitName( unitTag ),
                ["name"]    = effectName,
                ["dur"]     = endTime - GetGameTimeMilliseconds(),
                ["debuff"]  = effectType == BUFF_EFFECT_TYPE_DEBUFF,
                ["tex"]     = iconName,
                ["type"]    = isType,
                ["cast"]    = 0
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

    -- Get the context
    local context = ( unitTag == 'player' ) and "Player" or "Target"
    
    -- Filter the buff
    isValid, effectName, isType , iconName = FTC:FilterBuffInfo( unitTag , effectName , abilityType , iconName )
        
    -- Remove an existing effect
    if ( changeType == 2 and isValid ) then
        FTC.Buffs[context][effectName] = nil 
        FTC.Buffs:ReleaseUnusedBuffs()

    -- Add a new effect
    else
        local ability = {
            ["target"]  = GetUnitName( unitTag ),
            ["name"]    = effectName,
            ["dur"]     = endTime - GetGameTimeMilliseconds(),
            ["debuff"]  = effectType == BUFF_EFFECT_TYPE_DEBUFF,
            ["tex"]     = iconName,
            ["type"]    = isType,
            ["cast"]    = 0
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
    
    -- Only proceed for abilities with an explicit duration or custom effects
    if ( ability.effects == nil and ( ability.type == nil ) and not ( ability.dur > 0 ) ) then return end

    -- Get ability info
    local effects   = ability.effects
    local castTime  = ( ability.cast ~= nil ) and ( ability.cast or 0 ) or ( effects[3] or 0 ) * 1000

    -- Setup buff object
    local buffTemplate = {
        ["target"]  = ability.target,
        ["name"]    = ability.name,
        ["stacks"]  = 0,
        ["debuff"]  = false,
        ["icon"]    = ability.tex,
        ["begin"]   = ( ms + castTime ) / 1000,
    }

    -- Custom tracked effects
    if ( effects ~= nil ) then

        -- Custom buffs
        if ( effects[1] > 0 ) then

            -- Add buff data
            local newBuff   = buffTemplate
            newBuff.ends    = ( ( ms + castTime ) / 1000 ) + effects[1]

            -- Assign buff to pooled control
            local object, objectKey = FTC.Buffs.Pool:AcquireObject()
            object.id       = objectKey
            newBuff.control = object

            -- Add buff to active table
            FTC.Buffs.Player[ability.name] = newBuff
        end

        -- Custom debuffs
        if ( effects[2] > 0 ) then

            -- Add buff data
            local newBuff   = buffTemplate
            newBuff.ends    = ( ( ms + castTime ) / 1000 ) + effects[2]
            newBuff.debuff  = true

            -- Assign buff to pooled control
            local object, objectKey = FTC.Buffs.Pool:AcquireObject()
            object.id       = objectKey
            newBuff.control = object

            -- Add buff to active table
            FTC.Buffs.Target[ability.name] = newBuff
        end

    -- API timed effects
    elseif ( ability.dur > 0 ) then

        -- Add buff data
        local newBuff       = buffTemplate
        newBuff.ends        = ( ms + ability.cast + ability.dur ) / 1000

        -- Assign buff to pooled control
        local object, objectKey = FTC.Buffs.Pool:AcquireObject()
        object.id       = objectKey
        newBuff.control = object

        -- Add buff to active table
        FTC.Buffs.Player[ability.name] = newBuff


    -- API tracked toggles
    elseif ( tonumber(ability.type) == nil  ) then

        -- Add buff data
        local newBuff       = buffTemplate
        newBuff.ends        = 0
        newBuff.toggle      = ability.type
        
        -- Assign buff to pooled control
        local object, objectKey = FTC.Buffs.Pool:AcquireObject()
        object.id       = objectKey
        newBuff.control = object

        -- Add buff to active table
        FTC.Buffs.Player[ability.name] = newBuff
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
        if ( buff.target == GetUnitName( unitTag ) and buff.area == false ) then
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
function FTC.Buffs:Update( context )

    -- Get data
    local buffs         = ( context == "Player" ) and FTC.Buffs.Player or FTC.Buffs.Target
        
    -- Hide target buffs if the target frame isn't shown
    if ( context == "Target" and FTC.init.Frames and FTC_TargetFrame:IsHidden() ) then FTC_TargetBuffs:SetHidden(true) end
    
    -- Bail out if no buffs are present
    if ( next(buffs) == nil ) then return end

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
        local label     = buffs[i].toggle
        local control   = buffs[i].control
        local render    = true
        local duration  = math.floor( ( buffs[i].ends - gameTime ) * 10 ) / 10 
        
        -- Skip abilities which have not begun yet
        if ( buffs[i].begin > gameTime ) then render = false end

        -- Purge expired abilities
        if ( duration <= 0 and buffs[i].toggle == nil ) then
            FTC.Buffs[context][name] = nil 
            FTC.Buffs.Pool:ReleaseObject(control.id)

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

            -- Update the display
            control.label:SetText(label)
            control.icon:SetTexture(buffs[i].icon)
            control.cooldown:StartCooldown( ( buffs[i].ends - gameTime ) * 1000 , ( buffs[i].ends - buffs[i].begin ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )

            -- Long Buffs
            if ( context == "Player" and isLong ) then
                local container =  _G["FTC_LongBuffs"]

                -- Move the control into the container and anchor it
                control:SetParent(container)
                control:ClearAnchors()
                control:SetAnchor(BOTTOMRIGHT,container,BOTTOMRIGHT,0,(longCount*-50))
                control.frame:SetTexture('/esoui/art/actionbar/magechamber_firespelloverlay_down.dds')
                control:SetHidden(false)

                -- Update the count
                longCount = longCount + 1

            -- Debuffs
            elseif buffs[i].debuff then
                local container =  _G["FTC_"..context.."Debuffs"]

                -- Move the control into the container and anchor it
                control:SetParent(container)
                control:ClearAnchors()
                control:SetAnchor(BOTTOMLEFT,container,BOTTOMLEFT,(debuffCount*50),0)
                control.frame:SetTexture('/esoui/art/actionbar/debuff_frame.dds')
                control:SetHidden(false)

                -- Update the count
                debuffCount = debuffCount + 1       

            -- Buffs
            else
                local container =  _G["FTC_"..context.."Buffs"]

                -- Move the control into the container and anchor it
                control:SetParent(container)
                control:ClearAnchors()
                control:SetAnchor(TOPLEFT,container,TOPLEFT,(buffCount*50),0)
                control.frame:SetTexture('/esoui/art/actionbar/buff_frame.dds')
                control:SetHidden(false)

                -- Update the count
                buffCount = buffCount + 1       
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

