
--[[----------------------------------------------------------
    BUFF TRACKING COMPONENT
  ]]----------------------------------------------------------
    FTC.Buffs = {}
    FTC.Buffs.Defaults = {

        -- Player Debuffs
        ["FTC_PlayerDebuffs"]       = {BOTTOMRIGHT,CENTER,-250,174}, 
        ["PlayerDebuffFormat"]      = "htiles",

        -- Player Buffs
        ["FTC_PlayerBuffs"]         = {TOPRIGHT,CENTER,-250,366},  
        ["PlayerBuffFormat"]        = "ldlist",

        -- Long Buffs
        ["FTC_LongBuffs"]           = {BOTTOMRIGHT,BOTTOMRIGHT,-1,-2},
        ["LongBuffFormat"]          = "vtiles",

        -- Target Buffs
        ["FTC_TargetBuffs"]         = {BOTTOMLEFT,CENTER,250,174}, 
        ["TargetBuffFormat"]        = "htiles",

        -- Target Debuffs
        ["FTC_TargetDebuffs"]       = {TOPLEFT,CENTER,250,306},  
        ["TargetDebuffFormat"]      = "ldlist",

        -- Shared Settings  
        ["MaxBuffs"]                = 7,

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
        
        -- Create the controls
        FTC.Buffs:Controls()

        -- Populate initial buffs
        FTC.Buffs:GetBuffs('player')

        -- Setup action bar hooks
        FTC.Buffs:SetupActionBar()
        
        -- Setup status flags
        FTC.Buffs.lastCast  = 0
        FTC.Buffs.pending = {}
        
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

        -- Bail if the slot is unused
        if ( not IsSlotUsed(slot) ) then return retval end

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

            -- Send debuffs which require damage confirmation to the pending queue
            if ( ability.effects ~= nil and ability.effects[4] == true ) then 
                ability.owner       = GetUnitName('reticleover')
                FTC.Buffs.pending   = ability

            -- Put ground target abilities into the pending queue
            elseif ( ability.ground ) then FTC.Buffs.pendingGT = ability

            -- Register abilities with durations or custom effects
            elseif ( ( ability.effects ~= nil ) or ( ability.dur > 0 ) ) then 
                FTC.Buffs:NewEffect( ability ) 
                FTC.Buffs.pending = nil
                FTC.Buffs.pendingGT = nil
            end
            
            -- Fire a callback to hook extensions
            if ( not ability.ground ) then CALLBACK_MANAGER:FireCallbacks( "FTC_SpellCast" , ability ) end

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
                local duration = (timeEnding - GetFrameTimeSeconds()) * 1000
                local target   = GetAbilityTargetDescription(ability_id)

                -- Populate the slot object
                local ability  = {
                    ["owner"]  = GetUnitName( unitTag ),
                    ["id"]     = ability_id,
                    ["name"]   = buffName,
                    ["cast"]   = 0,
                    ["dur"]    = duration,
                    ["tex"]    = iconFilename,
                    ["ground"] = ( target == GetAbilityTargetDescription(23182) ),
                    ["area"]   = ( ( target == GetAbilityTargetDescription(23182) ) or ( target == GetAbilityTargetDescription(20919) ) or ( target == GetAbilityTargetDescription(22784) ) ),
                    ["debuff"] = effectType == BUFF_EFFECT_TYPE_DEBUFF,
                    ["toggle"] = isType,
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

        -- Remove existing effects
        if ( changeType == 2 ) then

            -- Get the context
            local context = ( unitTag == 'player' ) and "Player" or "Target"
            
            -- Filter the buff
            isValid, effectName, isType , iconName = FTC:FilterBuffInfo( unitTag , effectName , abilityType , iconName )

            -- Remove the buff
            FTC.Buffs[context][effectName] = nil 
            FTC.Buffs:ReleaseUnusedBuffs()
        else

            -- Otherwise refresh all buffs from API
            FTC.Buffs:GetBuffs( unitTag )   
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
        local castTime  = ( effects ~= nil ) and ( effects[3]*1000 ) or ability.cast

        -- Setup buff object
        local newBuff = {
            ["owner"]   = ability.owner,
            ["name"]    = ability.name,
            ["id"]      = ability.id,
            ["stacks"]  = 0,
            ["debuff"]  = ability.debuff or false,
            ["area"]    = ability.area   or false,
            ["toggle"]  = ability.toggle,        
            ["icon"]    = ability.tex,
            ["begin"]   = ( ms + castTime ) / 1000,
            ["pending"] = ability.pending or false,
        }

        -- Arbitrate context
        local context   = ( ability.owner == FTC.Player.name ) and "Player" or "Target"

        -- Custom tracked effects
        if ( effects ~= nil ) then

            -- Custom debuffs
            if ( effects[2] > 0 ) then

                -- Make a copy of the table
                local newDebuff = {}
                for k,v in pairs(newBuff) do newDebuff[k] = v end

                -- Add buff data
                newDebuff.owner   = ( newBuff.pending ) and newDebuff.owner or ( DoesUnitExist('reticleover') and GetUnitName('reticleover') or FTC.Target.name ) 
                newDebuff.ends    = ( ( ms + castTime ) / 1000 ) + effects[2]
                newDebuff.debuff  = true

                -- Assign buff to pooled control
                local control, objectKey = FTC.Buffs.Pool:AcquireObject()
                control.id = objectKey
                control.icon:SetTexture(newBuff.icon)
                newDebuff.control = control
                
                -- Add debuff to timed table
                FTC.Buffs.Target[ability.name] = newDebuff
            end

            -- Custom buffs
            if ( effects[1] > 0 ) then

                -- Add buff data
                newBuff.ends    = ( ( ms + castTime ) / 1000 ) + effects[1]
                newBuff.owner   = FTC.Player.name
                newBuff.debuff  = false

                -- Assign buff to pooled control
                local control, objectKey = FTC.Buffs.Pool:AcquireObject()
                control.id = objectKey
                control.icon:SetTexture(newBuff.icon)
                newBuff.control = control

                -- Add buff to timed table
                FTC.Buffs.Player[ability.name] = newBuff
            end

        -- API timed effects
        elseif ( ability.dur > 0 ) then

            -- Add buff data
            newBuff.ends = ( ms + ability.cast + ability.dur ) / 1000

            -- Assign buff to pooled control
            local control, objectKey = FTC.Buffs.Pool:AcquireObject()
            control.id = objectKey
            control.icon:SetTexture(newBuff.icon)
            newBuff.control = control

            -- Add buff to timed table
            FTC.Buffs[context][ability.name] = newBuff

        -- API tracked toggles
        elseif ( ability.toggle ~= nil ) then

            -- Add buff data
            newBuff.ends = 0
            
            -- Assign buff to pooled control
            local control, objectKey = FTC.Buffs.Pool:AcquireObject()
            control.id = objectKey
            control.icon:SetTexture(newBuff.icon) 
            newBuff.control = control

            -- Add buff to timed table
            FTC.Buffs[context][ability.name] = newBuff
        end

        -- Release any unused objects
        FTC.Buffs:ReleaseUnusedBuffs()
    end

    --[[ 
     * Handle Buff Changes on Damage
     * --------------------------------
     * Called by FTC.Damage:New()
     * --------------------------------
     ]]--
    function FTC.Buffs:Damage( damage ) 

        -- Activate buffs and debuffs from the pending queue
        local pending = FTC.Buffs.pending
        if ( pending ~= nil and pending.name == damage.ability ) then 
            FTC.Buffs:NewEffect( pending ) 
            FTC.Buffs.pending = nil
        end

        -- Modify buffs that change on damage
        FTC.Buffs:DamageEffect( damage.ability )

    end

     --[[ 
     * Wipe Out Buffs on Death
     * --------------------------------
     * Called by FTC:OnDeath()
     * --------------------------------
     ]]--
    function FTC.Buffs:WipeBuffs( owner )

        -- Determine context
        local owner   = zo_strformat("<<!aC:1>>",owner)  
        local context = ( owner ~= FTC.Player.name ) and "Target" or "Player"
        
        -- Wipe out buffs that are specific to the deceased
        for name , buff in pairs( FTC.Buffs[context] ) do
            if ( buff.owner == owner and ( buff.area == false or buff.pending == true ) ) then
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
        
            -- Gather data
            local render    = true
            local name      = buffs[i].name
            local isLong    = buffs[i].toggle ~= nil
            local label     = buffs[i].toggle or ""
            local control   = buffs[i].control
            local duration  = zo_roundToNearest( buffs[i].ends - gameTime , 0.1 )
            
            -- Skip abilities which have not begun yet
            if ( buffs[i].begin > gameTime ) then render = false end

            -- Purge expired abilities
            if ( duration <= 0 and buffs[i].toggle == nil ) then
                FTC.Buffs[context][name] = nil 
                FTC.Buffs.Pool:ReleaseObject(control.id)
                render = false

            -- Handle single-target buffs belonging to others
            elseif ( buffs[i].owner ~= GetUnitName(unitTag) and not buffs[i].area ) then
                render = false
            
                -- Purge non-timed abilities
                if ( buffs[i].toggle ~= nil ) then
                    FTC.Buffs[context][name] = nil 
                    FTC.Buffs.Pool:ReleaseObject(control.id)
               
                -- Ensure that single-target timed abilities are hidden
                else control:SetHidden(true) end

            -- Otherwise process away!
            elseif ( render ) then
                if ( duration > 0 ) then 

                    -- Flag long buffs
                    isLong = ( duration >= 60 ) and true or isLong
                        
                    -- Format displayed duration
                    if ( duration > 3600 ) then
                        local hours     = math.floor( duration / 3600 )
                        label           = string.format( "%dh" , hours )
                    elseif ( duration > 60 ) then   
                        local minutes   = math.floor( duration / 60 )
                        label           = string.format( "%dm" , minutes )
                    else label = FTC.DisplayNumber( duration , 1 ) end
                end

                -- Reset Controls
                control:ClearAnchors()
                control:SetHidden(true)
                control.cooldown:SetHidden(true)
                control.cooldown:SetAlpha(0.7)
                control.label:SetText(label)
                control.name:ClearAnchors()    
                control.name:SetText(zo_strformat("<<!aC:1>>",name))
                control.name:SetHidden(true)      
                
                -- Setup placeholders
                local format    = "disabled"
                local container = nil
                local count     = 0

                -- Long Buffs
                if ( context == "Player" and isLong ) then
                    format      = FTC.Vars.LongBuffFormat
                    container   =  _G["FTC_LongBuffs"]
                    longCount   = longCount + 1
                    count       = longCount

                    -- Set display options
                    control.frame:SetTexture('/esoui/art/actionbar/magechamber_firespelloverlay_down.dds')

                -- Debuffs
                elseif ( buffs[i].debuff ) then
                    format      = FTC.Vars[context.."DebuffFormat"]
                    container   =  _G["FTC_"..context.."Debuffs"]
                    debuffCount = debuffCount + 1
                    count       = debuffCount

                    -- Set display options
                    control.frame:SetTexture('/esoui/art/actionbar/debuff_frame.dds')
                    control.cooldown:StartCooldown( ( buffs[i].ends - gameTime ) * 1000 , ( buffs[i].ends - buffs[i].begin ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
                    control.cooldown:SetHidden(false)    

                -- Buffs
                else
                    format      = FTC.Vars[context.."BuffFormat"]
                    container   =  _G["FTC_"..context.."Buffs"]
                    buffCount   = buffCount + 1
                    count       = buffCount
                   
                    -- Set display options
                    control.frame:SetTexture('/esoui/art/actionbar/buff_frame.dds')
                    control.cooldown:StartCooldown( ( buffs[i].ends - gameTime ) * 1000 , ( buffs[i].ends - buffs[i].begin ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
                    control.cooldown:SetHidden(isLong)
                end

                -- Update display if not disabled
                if ( format ~= "disabled" ) then 

                    -- Set anchors
                    local anchor = {}
                    if (     format == "vtiles" ) then anchor = {BOTTOMRIGHT,container,BOTTOMRIGHT,0,((count-1)*-50)}
                    elseif ( format == "htiles" ) then anchor = {BOTTOMLEFT,container,BOTTOMLEFT,((count-1)*50),0}
                    elseif ( format == "ldlist" ) then anchor = {TOPLEFT,container,TOPLEFT,0,((count-1)*50)}
                    elseif ( format == "lalist" ) then anchor = {BOTTOMLEFT,container,BOTTOMLEFT,0,((count-1)*-50)}
                    elseif ( format == "rdlist" ) then anchor = {TOPRIGHT,container,TOPRIGHT,0,((count-1)*50)}
                    elseif ( format == "ralist" ) then anchor = {BOTTOMRIGHT,container,BOTTOMRIGHT,0,((count-1)*-50)} end
                    control:SetParent(container)
                    control:SetAnchor(unpack(anchor))

                    -- Set alignment
                    local alignRight = ( format == "rdlist" or format == "ralist" )
                    local alignText  = alignRight and {RIGHT,control,LEFT,-10,0} or {LEFT,control,RIGHT,10,0}
                    control.name:SetAnchor(unpack(alignText))
                    control.name:SetHorizontalAlignment( alignRight and 2 or 0)
                    control.name:SetHidden(string.match(format,"list") == nil)

                    -- Display the buff
                    control:SetHidden(false)
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
