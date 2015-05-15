 
--[[----------------------------------------------------------
    UNIT FRAMES COMPONENT
  ]]----------------------------------------------------------

FTC.Frames = {}
FTC.Frames.Defaults = {
    
    -- Player Frame
    ["FTC_PlayerFrame"]         = {CENTER,CENTER,-400,300},
    ["EnableNameplate"]         = true,
    ["EnableXPBar"]             = true,

    -- Target Frame
    ["FTC_TargetFrame"]         = {CENTER,CENTER,400,300},
    ["ExecuteThreshold"]        = 25,
    ["DefaultTargetFrame"]      = false,

    -- Shared Settings
    ["FrameWidth"]              = 350,
    ["FrameHeight"]             = 180,  
    ["FrameOpacityIn"]          = 100,
    ["FrameOpacityOut"]         = 80,    
    ["FrameFont1"]              = 'esobold',
    ["FrameFont2"]              = 'esobold',
    ["FrameFontSize"]           = 18,
    ["FrameHealthColor"]        = {133/255,018/255,013/255},
    ["FrameMagickaColor"]       = {064/255,064/255,128/255},
    ["FrameStaminaColor"]       = {038/255,077/255,033/255},
    ["FrameShieldColor"]        = {255/255,100/255,000/255},
}
FTC:JoinTables(FTC.Defaults,FTC.Frames.Defaults)

--[[----------------------------------------------------------
    UNIT FRAMES FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Initialize Unit Frames Component
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--
function FTC.Frames:Initialize()

    -- Unregister events to disable default frames
    local frames = { 'Health' , 'Stamina' , 'Magicka' , 'MountStamina' , 'SiegeHealth' , 'Werewolf' }
    for i = 1 , #frames do
        local frame = _G["ZO_PlayerAttribute"..frames[i]]
        frame:UnregisterForEvent(EVENT_POWER_UPDATE)
        frame:UnregisterForEvent(EVENT_INTERFACE_SETTING_CHANGED)
        frame:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
        EVENT_MANAGER:UnregisterForUpdate("ZO_PlayerAttribute"..frames[i].."FadeUpdate")
        frame:SetHidden(true)       
    end
    
    -- Hide the default target frame
    if ( not FTC.Vars.DefaultTargetFrame ) then ZO_TargetUnitFramereticleover:SetHidden(true) end

    -- Create unit frame UI elements
    FTC.Frames:Controls()

    -- Register init status
    FTC.init.Frames = true

    -- Populate initial frames
    FTC.Frames:SetupPlayer()
    FTC.Frames:SetupTarget()
end

  --[[ 
 * Set Up Player Frame
 * --------------------------------
 * Called by FTC.Frames:Initialize()
 * Called by FTC.Frames:OnLevel()
 * --------------------------------
 ]]--
function FTC.Frames:SetupPlayer()

    -- Setup custom frames
    if ( FTC.init.Frames ) then
    
        -- Configure the nameplate
        if ( FTC.Vars.EnableNameplate ) then
            local name      = zo_strformat("<<!aC:1>>",FTC.Player.name)
            local level     = FTC.Player.vlevel > 0 and "v" .. FTC.Player.vlevel or FTC.Player.level
            FTC_PlayerFrame_PlateName:SetText( name .. " (" .. level .. ")" )
        end
        FTC_PlayerFrame_Plate:SetHidden( not FTC.Vars.EnableNameplate )
        
        -- Setup alternate bar
        FTC.Frames:SetupAltBar()
    end

    -- Populate attributes
    FTC.Frames:UpdateAttribute( 'player', POWERTYPE_HEALTH,     FTC.Player.health.current,  FTC.Player.health.max,  FTC.Player.health.max )
    FTC.Frames:UpdateAttribute( 'player', POWERTYPE_MAGICKA,    FTC.Player.magicka.current, FTC.Player.magicka.max, FTC.Player.magicka.max )
    FTC.Frames:UpdateAttribute( 'player', POWERTYPE_STAMINA,    FTC.Player.stamina.current, FTC.Player.stamina.max, FTC.Player.stamina.max )

    -- Populate shield
    FTC.Frames:UpdateShield( 'player', FTC.Player.shield.current , FTC.Player.shield.max )
end
 
 --[[ 
 * Set Up Target Frame
 * --------------------------------
 * Called by FTC.Frames:Initialize()
 * Called by FTC.Target:Update()
 * Called by FTC.Menu:Reposition()
 * --------------------------------
 ]]--
 function FTC.Frames:SetupTarget()

    -- Bail out if we don't have a target
    if ( not DoesUnitExist('reticleover') ) then 
        if ( FTC.init.Frames ) then FTC_TargetFrame:SetHidden(true) end
        return 
    end
                    
    -- Load the target's health 
    local current, maximum, effectiveMax = GetUnitPower( 'reticleover' , POWERTYPE_HEALTH )
    FTC.Target.health = { ["current"] = current , ["max"] = maximum , ["pct"] = zo_roundToNearest(current/maximum,0.01) }
    FTC.Frames:UpdateAttribute( 'reticleover', POWERTYPE_HEALTH , current, maximum, effectiveMax )
    
    -- Populate custom frames
    if ( FTC.init.Frames ) then 

        -- Get the frame
        local frame     = _G['FTC_TargetFrame']
    
        -- Get data
        local name      = zo_strformat("<<!aC:1>>",FTC.Target.name)
        local level     = FTC.Target.vlevel > 0 and "v" .. FTC.Target.vlevel or FTC.Target.level
        local icon      = nil
        local title     = nil
        local rank      = nil

        -- Players
        if ( IsUnitPlayer('reticleover') ) then 
            icon  = GetClassIcon(GetUnitClassId('reticleover'))
            title = GetUnitTitle( 'reticleover' ) == "" and GetAvARankName( GetUnitGender('reticleover') , GetUnitAvARank('reticleover') ) or GetUnitTitle( 'reticleover' )
            rank  = GetAvARankIcon(GetUnitAvARank('reticleover'))
        
        -- Champion Mobs
        elseif ( GetUnitDifficulty('reticleover') == 2) then 
            icon  = "/esoui/art/unitframes/target_veteranrank_icon.dds"
            title = GetUnitCaption( 'reticleover' )

        -- Boss Mobs
        elseif ( GetUnitDifficulty('reticleover') >= 3 ) then 
            icon  = "/esoui/art/lfg/lfg_veterandungeon_down.dds"
            title = GetUnitCaption( 'reticleover' )

        -- Normal NPCs
        else
            title = GetUnitCaption( 'reticleover' )
        end

        -- Populate name
        frame.plate.name:SetText( name .. " (" .. level .. ")" )

        -- Populate class icon
        frame.plate.class:SetTexture( icon )
        frame.plate.class:SetHidden( icon == nil )

        -- Populate title
        frame.lplate.title:SetText(title)
        
        -- Populate rank icon
        frame.lplate.rank:SetTexture( rank )
        frame.lplate.rank:SetHidden( rank == nil )
        
        -- Populate shield
        local value, maxValue = GetUnitAttributeVisualizerEffectInfo('reticleover',ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH)
        FTC.Frames:UpdateShield( 'reticleover' , ( value ~= nil and value > 0 ) and value or 0 , FTC.Target.health.max )

        -- Display the frame
        frame:SetHidden(false)
    end
end

--[[----------------------------------------------------------
    ATTRIBUTES
  ]]----------------------------------------------------------
 
 --[[ 
 * Process Updates to Attributes
 * --------------------------------
 * Called by FTC.OnPowerUpdate()
 * Called by FTC.Frames:SetupPlayer()
 * Called by FTC.Frames:SetupTarget()
 * --------------------------------
 ]]--
 function FTC.Frames:UpdateAttribute( unitTag , powerType ,  powerValue , powerMax , powerEffectiveMax )
 
    -- Get the context
    local context = ( unitTag == 'player' ) and "Player" or "Target"
    
    -- Get the attribute
    local attrs = { [POWERTYPE_HEALTH] = "Health", [POWERTYPE_MAGICKA] = "Magicka", [POWERTYPE_STAMINA] = "Stamina" }
    local name  = attrs[powerType]
    
    -- Get the percentage
    local pct = math.max(zo_roundToNearest((powerValue or 0)/powerMax,0.01),0)
    
    -- Update custom frames
    if ( FTC.init.Frames ) then
    
        -- Get the unit frame container
        local frame  = _G["FTC_" .. context .. "Frame"]
        local attr   = frame[string.lower(name)]
        
        -- Update bar width
        attr.bar:SetWidth( pct * ( attr:GetWidth() - 6 ) )

        -- Update bar labels
        local label = ( powerValue > 100000 ) and zo_roundToNearest(powerValue,1000)/1000 .. "k" or CommaValue(powerValue)
        local pctLabel = (pct*100) .. "%"
        
        -- Maybe add shielding
        if ( powerType == POWERTYPE_HEALTH ) then
            label = ( FTC[context]["shield"]["current"] ~= nil and FTC[context]["shield"]["current"] > 0 ) and label .. " [" .. CommaValue(FTC[context]["shield"]["current"]) .. "]" or label
        end

        -- Override for dead things
        if ( powerType == POWERTYPE_HEALTH and ( IsUnitDead(unitTag) or powerValue == 0 ) ) then 
            label = GetString(FTC_Dead)
            pctLabel = ""
        end

        -- Set the label
        attr.current:SetText(label)
        attr.pct:SetText(pctLabel)

        -- Maybe prompt for execute
        if ( context == "Target" ) then 
            frame.execute:SetHidden( not ( pct < FTC.Vars.ExecuteThreshold/100 ) )
            if ( ( not IsUnitDead(unitTag) ) and ( pct < FTC.Vars.ExecuteThreshold/100 ) and ( FTC.Target.health.pct > FTC.Vars.ExecuteThreshold/100 ) ) then FTC.Frames:Execute() end
        end

        -- Control frame visibility
        FTC.Frames:Fade(unitTag)
    end
    
    -- Update the database object
    FTC[context][string.lower(name)] = { ["current"] = powerValue , ["max"] = powerMax , ["pct"] = pct }
 end
 
--[[----------------------------------------------------------
    SHIELDS
  ]]----------------------------------------------------------

 --[[ 
 * Update Shield Bars
 * --------------------------------
 * Called by FTC.OnVisualAdded()
 * Called by FTC.OnVisualUpdate()
 * Called by FTC.OnVisualRemoved()
 * Called by FTC.Frames:SetupPlayer()
 * Called by FTC.Frames:SetupTarget()
 * --------------------------------
 ]]--
function FTC.Frames:UpdateShield( unitTag , value , maxValue )

    -- Get the context
    local context   = ( unitTag == 'player' ) and "Player" or "Target"
    local frame     = _G['FTC_'..context..'Frame']
    
    -- Get the unit's maximum health
    local shieldPct = zo_roundToNearest(value/FTC[context]["health"]["max"],0.01)

    -- Strip any existing tooltip
    local tooltip = string.gsub( frame.health.current:GetText() , " %[(.*)%]" , "")
    
    -- Display shield
    if ( value > 0 ) then
        frame.shield:SetWidth( math.min(shieldPct,1) * frame.health:GetWidth())
        frame.shield.bar:SetWidth(frame.shield:GetWidth()-4)

        -- Update the health text
        frame.health.current:SetText(tooltip .. " [" .. CommaValue(value) .. "]")

        -- Ensure visibility
        frame.shield:SetHidden(false)   

    -- Hide shield
    else
        frame.health.current:SetText(tooltip)
        frame.shield:SetHidden(true)
    end
    
    -- Update the database object
    FTC[context].shield = { ["current"] = value , ["max"] = maxValue , ["pct"] = shieldPct }
end


--[[----------------------------------------------------------
    ALTERNATE BAR
  ]]-----------------------------------------------------------

 --[[ 
 * Set Up Alternate Experience/Mount/Werewolf/Siege Bar
 * --------------------------------
 * Called by FTC.Frames:SetupPlayer()
 * Called by FTC.OnMount()
 * Called by FTC.OnSiege()
 * Called by FTC.OnWerewolf()
 * --------------------------------
 ]]--
function FTC.Frames:SetupAltBar()

    -- Retrieve the bar
    local parent = _G["FTC_PlayerFrame_Alt"]

    -- Bail if the bar is disabled
    if ( not FTC.Vars.EnableXPBar ) then 
        parent:SetHidden(true)  
    return end
    
    -- Player is mounted
    if ( IsMounted() and parent.context ~= "mount" ) then 

        -- Change the icon and color
        parent.icon:SetTexture("/esoui/art/icons/mapkey/mapkey_stables.dds")
        parent.bg:SetCenterColor(FTC.Vars.FrameStaminaColor[1]/5,FTC.Vars.FrameStaminaColor[2]/5,FTC.Vars.FrameStaminaColor[3]/5,1)
        parent.bar:SetColor(FTC.Vars.FrameStaminaColor[1],FTC.Vars.FrameStaminaColor[2],FTC.Vars.FrameStaminaColor[3],1)

        -- Fetch the current mount stamina level
        local current, maximum, effectiveMax = GetUnitPower( 'player' , POWERTYPE_MOUNT_STAMINA )
        parent.bar:SetWidth( ( current / effectiveMax ) * ( parent.bg:GetWidth()-6 ) )

        -- Set the context
        parent.context = "mount"

    -- Player is transformed into a werewolf
    elseif ( IsWerewolf() and parent.context ~= "werewolf" ) then

        -- Change the icon and color
        parent.icon:SetTexture("/esoui/art/icons/mapkey/mapkey_undaunted.dds")
        parent.bg:SetCenterColor(0.2,0,0,1)
        parent.bar:SetColor(0.8,0,0,1)

        -- Fetch the current werewolf time remaining
        local current, maximum, effectiveMax = GetUnitPower( 'player' , POWERTYPE_WEREWOLF )
        parent.bar:SetWidth( ( current / effectiveMax ) * parent.bg:GetWidth()-6 )

        -- Set the context
        parent.context = "werewolf"

    -- Player is controlling a siege weapon
    elseif ( ( IsPlayerControllingSiegeWeapon() or IsPlayerEscortingRam() ) and parent.context ~= "siege" ) then

        -- Change the icon and color
        parent.icon:SetTexture("/esoui/art/icons/mapkey/mapkey_borderkeep.dds")
        parent.bg:SetCenterColor(0.2,0,0,1)
        parent.bar:SetColor(0.8,0,0,1)

        -- Fetch the current siege health level
        local current, maximum, effectiveMax = GetUnitPower( 'controlledsiege' , POWERTYPE_HEALTH )
        parent.bar:SetWidth( ( current / effectiveMax ) * parent.bg:GetWidth()-6 )

        -- Set the context
        parent.context = "siege"

    -- Player is above level 50
    elseif ( FTC.Player.level >= 50 ) then

        -- Change the icon and color
        parent.icon:SetTexture("/esoui/art/champion/champion_points_magicka_icon-hud-32.dds")
        parent.bg:SetCenterColor(0,0.1,0.2,1)
        parent.bar:SetColor(0,0.6,1,1)  
        
        -- Fetch the current experience level
        maxExp = 400000
        currExp = GetPlayerChampionXP()
        parent.bar:SetWidth( (currExp/maxExp) * (parent.bg:GetWidth()-6) )

        -- Set the context
        parent.context = "exp"

    -- Player is below level 50
    else

        -- Change the icon and color
        parent.icon:SetTexture("/esoui/art/inventory/journal_tabicon_quest_down.dds")
        parent.bg:SetCenterColor(0,0.1,0.1,1)
        parent.bar:SetColor(0,1,1,1)

        -- Fetch the current experience level
        maxExp = GetUnitXPMax('player')
        currExp = FTC.Player.exp
        parent.bar:SetWidth( (currExp/maxExp) * (parent.bg:GetWidth()-6) )

        -- Set the context
        parent.context = "exp"
    end

    -- Ensure bar visibility
    parent:SetHidden(false)     
end
 
 --[[ 
 * Update Mount Stamina Bar
 * --------------------------------
 * Called by FTC.OnPowerUpdate()
 * --------------------------------
 ]]--
function FTC.Frames:UpdateMount( powerValue , powerMax , powerEffectiveMax )

    -- Get the alternate bar
    local parent    = _G["FTC_PlayerFrame_Alt"]
    
    -- Bail if the bar is currently used for something else
    if ( parent.context ~= "mount" ) then return end
    
    -- Change the bar width
    parent.bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( parent.bg:GetWidth()-6 ) )
end

 --[[ 
 * Update Siege Health Bar
 * --------------------------------
 * Called by FTC.OnPowerUpdate()
 * --------------------------------
 ]]--
 function FTC.Frames:UpdateSiege( powerValue , powerMax , powerEffectiveMax )
 
    -- Get the alternate bar
    local parent    = _G["FTC_PlayerFrame_Alt"]
    
    -- Bail if the bar is currently used for something else
    if ( parent.context ~= "siege" ) then return end
    
    -- Change the bar width
    parent.bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( parent:GetWidth() - 2 ) )
end
 
 --[[ 
 * Update Werewolf Remaining Timer
 * --------------------------------
 * Called by FTC.OnPowerUpdate()
 * --------------------------------
 ]]--
function FTC.Frames:UpdateWerewolf( powerValue , powerMax , powerEffectiveMax )

    -- Get the alternate bar
    local parent    = _G["FTC_PlayerFrame_Alt"]
    
    -- Bail if the bar is currently used for something else
    if ( parent.context ~= "werewolf" ) then return end
    
    -- Change the bar width
    parent.bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( parent:GetWidth() - 2 ) )
end
