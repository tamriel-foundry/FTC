
--[[----------------------------------------------------------
    BUFF TRACKING COMPONENT
  ]]----------------------------------------------------------
    local FTC = FTC
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
        
        -- Setup status flags
        FTC.Buffs.lastCast  = 0
        FTC.Buffs.pending = {}
        
        -- Register init status
        FTC.init.Buffs = true

        -- Activate updating
        EVENT_MANAGER:RegisterForUpdate( "FTC_PlayerBuffs"   , 100 , function() FTC.Buffs:Update('player') end )
        EVENT_MANAGER:RegisterForUpdate( "FTC_TargetDebuffs" , 100 , function() FTC.Buffs:Update('reticleover') end )
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

        -- Iterate through buffs, translating them to into the correct format
        for i = 1 , GetNumBuffs( unitTag ) do
        
            -- Get the buff information
            local buffName , timeStarted , timeEnding , buffSlot , stackCount , iconFilename , buffType , effectType , abilityType , statusEffectType , abilityId , canClickOff = GetUnitBuffInfo( unitTag , i )
            FTC.Buffs:EffectChanged( 1 , unitTag , GetUnitName(unitTag) , 0 , effectType , buffName , abilityType , abilityId , buffType , statusEffectType , timeStarted , timeEnding , iconFilename )
        end
    end

    --[[ 
     * Handle Effect Change Event
     * --------------------------------
     * Called by FTC.OnEffectChanged()
     * --------------------------------
     ]]--
    function FTC.Buffs:EffectChanged( changeType , unitTag , unitName , unitId , effectType , effectName , abilityType , abilityId , buffType , statusEffectType , beginTime , endTime , iconName )

        -- Only take action for player and target
        if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end

        -- Get the context
        local context = ( unitTag == 'player' ) and "Player" or "Target"

        -- Debugging
        --d( changeType .. " [" .. abilityId .. "] " .. effectName .. " || [" .. unitTag .. "] " .. unitName .. " (" .. unitId .. ") || " .. ( endTime - beginTime ) .. "s || " .. iconName )

        -- Remove existing effects
        if ( changeType == 2 ) then
            FTC.Buffs[context][effectName] = nil 
            FTC.Buffs:ReleaseUnusedBuffs()
       
        -- Otherwise register a new effect
        else

            -- Run the effects through a global filter
            isValid, effectName, isType = FTC:FilterBuffInfo( unitTag , abilityId , effectName )

            -- Consider effects that are exactly zero seconds as permanent
            if ( endTime - beginTime == 0 ) then isType = "P" end
            
            -- Suppress effects that are less than 2 seconds in duration
            if ( isType == nil ) and ( endTime - beginTime <= 2 ) then isValid = false end

            -- Suppress effects which already exist for the same icon with the same duration
            for k, v in pairs(FTC.Buffs[context]) do
                if ( iconName == v.icon ) and ( math.abs( endTime - v.ends ) <= 0.1 ) and ( math.abs( beginTime - v.begin ) <= 0.1 ) then isValid = false end
            end

            -- Process valid buffs
            if ( isValid ) then 

                -- Populate the slot object
                local target   = GetAbilityTargetDescription(ability_id)
                local ability  = {
                    ["owner"]  = GetUnitName( unitTag ),
                    ["id"]     = abilityId,
                    ["name"]   = effectName,
                    ["begin"]  = beginTime,
                    ["ends"]   = endTime,
                    ["icon"]   = iconName,
                    ["ground"] = ( target == GetAbilityTargetDescription(23182) ),
                    ["area"]   = ( ( target == GetAbilityTargetDescription(23182) ) or ( target == GetAbilityTargetDescription(20919) ) or ( target == GetAbilityTargetDescription(22784) ) ),
                    ["debuff"] = effectType == BUFF_EFFECT_TYPE_DEBUFF,
                    ["toggle"] = isType,
                }

                -- Pass it to the buff handler
                FTC.Buffs:NewEffect( ability , context )  
            end
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
    function FTC.Buffs:NewEffect( ability , context )

        -- Provide backward compatibility for buff extensions
        if ( context == nil ) then context = 'Player' end
        if ( ability.icon == nil and ability.tex ~= nil ) then
            ability.icon = ability.tex
        end

        -- Maybe translate durations into begin and end times
        if ( ability.ends == nil and ability.dur ~= nil ) then
            ability.begin = GetFrameTimeSeconds()
            ability.ends = ability.begin + ability.dur
        end

        -- API tracked toggles
        if ( ability.toggle ~= nil ) then

            -- Add buff data
            ability.ends = 0
            
            -- Assign buff to pooled control
            local control, objectKey = FTC.Buffs.Pool:AcquireObject()
            control.id = objectKey
            control.icon:SetTexture(ability.icon) 
            ability.control = control

            -- Add buff to timed table
            FTC.Buffs[context][ability.name] = ability

        -- API timed effects
        else

            -- Assign buff to pooled control
            local control, objectKey = FTC.Buffs.Pool:AcquireObject()
            control.id = objectKey
            control.icon:SetTexture(ability.icon)
            ability.control = control

            -- Add buff to timed table
            FTC.Buffs[context][ability.name] = ability
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

            -- Remove buffs belonging to old owners
            elseif ( buffs[i].owner ~= GetUnitName(unitTag) ) then
                render = false
            
                -- Purge long duration buffs
                if ( buffs[i].toggle ~= nil or ( duration >= 60 ) ) then
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
                    elseif ( format == "htiles" ) then anchor = ( container == _G["FTC_LongBuffs"]) and {BOTTOMRIGHT,container,BOTTOMRIGHT,((count-1)*(-1*50)),0} or {BOTTOMLEFT,container,BOTTOMLEFT,((count-1)*50),0}
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
