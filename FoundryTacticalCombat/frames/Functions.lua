 
--[[----------------------------------------------------------
    UNIT FRAMES COMPONENT
  ]]----------------------------------------------------------

    FTC.Frames = {}
    FTC.Frames.Defaults = {
        
        -- Player Frame
        ["FTC_PlayerFrame"]         = {TOPRIGHT,CENTER,-250,180},
        ["EnableNameplate"]         = true,
        ["EnableXPBar"]             = true,
        ["FrameWidth"]              = 350,
        ["FrameHeight"]             = 180,  

        -- Target Frame
        ["FTC_TargetFrame"]         = {TOPLEFT,CENTER,250,180},
        ["ExecuteThreshold"]        = 25,
        ["DefaultTargetFrame"]      = false,

        ["FrameFontSize"]           = 18,
        ["FrameHealthColor"]        = {133/255,018/255,013/255},
        ["FrameMagickaColor"]       = {064/255,064/255,128/255},
        ["FrameStaminaColor"]       = {038/255,077/255,033/255},
        ["FrameShieldColor"]        = {255/255,100/255,000/255},

        -- Group Frame
        ["EnableGroupFrames"]       = true,
        ["FTC_GroupFrame"]          = {TOPLEFT,TOPLEFT,6,50},
        ["GroupWidth"]              = 200,
        ["GroupHeight"]             = 350,  
        ["GroupHidePlayer"]         = false,
        ["GroupFontSize"]           = 18,
        ["ColorRoles"]              = true,
        ["FrameTankColor"]          = {133/255,018/255,013/255},
        ["FrameHealerColor"]        = {117/255,077/255,135/255},
        ["FrameDamageColor"]        = {255/255,196/255,128/255},

        -- Raid Frame
        ["EnableRaidFrames"]        = true,
        ["FTC_RaidFrame"]           = {TOPLEFT,TOPLEFT,6,50},
        ["RaidWidth"]               = 120,
        ["RaidHeight"]              = 50,  
        ["RaidColumnSize"]          = 12,
        ["RaidFontSize"]            = 14,

        -- Shared Settings
        ["FrameOpacityIn"]          = 100,
        ["FrameOpacityOut"]         = 60,    
        ["FrameFont1"]              = 'esobold',
        ["FrameFont2"]              = 'esobold',
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

        -- Create unit frame UI elements
        FTC.Frames:Controls()

        -- Register init status
        FTC.init.Frames = true

        -- Populate initial frames
        FTC.Frames:SetupPlayer()
        FTC.Frames:SetupTarget()
        FTC.Frames:SetupGroup()

        -- Activate safety check
        EVENT_MANAGER:RegisterForUpdate( "FTC_PlayerFrame" , 5000 , function() FTC.Frames:SafetyCheck() end )
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
        FTC.Frames:UpdateAttribute( 'player', POWERTYPE_HEALTH, nil )
        FTC.Frames:UpdateAttribute( 'player', POWERTYPE_MAGICKA, nil )
        FTC.Frames:UpdateAttribute( 'player', POWERTYPE_STAMINA, nil )

        -- Populate shield
        FTC.Frames:UpdateShield(    'player' , nil , nil )
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

        -- Ensure the default frame stays hidden
        if ( not FTC.Vars.DefaultTargetFrame ) then ZO_TargetUnitFramereticleover:SetHidden(true) end

        -- Bail out if we don't have a target and we are not in move mode
        if ( not DoesUnitExist('reticleover') ) then 
            if ( FTC.init.Frames ) then FTC_TargetFrame:SetHidden(true) end
            return 
        end
        
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
                icon  = "/esoui/art/lfg/lfg_normaldungeon_down.dds"
                title = GetUnitCaption( 'reticleover' )

            -- Boss Mobs
            elseif ( GetUnitDifficulty('reticleover') >= 3 ) then 
                icon  = "/esoui/art/unitframes/target_veteranrank_icon.dds"
                title = GetUnitCaption( 'reticleover' )

            -- Normal NPCs
            else
                title = GetUnitCaption( 'reticleover' )
            end

            -- Populate name plate
            frame.plate.name:SetText( name .. " (" .. level .. ")" )
            frame.plate.class:SetTexture( icon )
            frame.plate.class:SetHidden( icon == nil )
            frame.lplate.title:SetText(title)
            
            -- Populate rank icon
            frame.lplate.rank:SetTexture( rank )
            frame.lplate.rank:SetHidden( rank == nil )

            -- Populate health
            FTC.Frames:UpdateAttribute( 'reticleover', POWERTYPE_HEALTH , nil )
            
            -- Populate shield
            FTC.Frames:UpdateShield( 'reticleover' , nil )

            -- Display the frame
            frame:SetHidden(false)
        end
    end

 
     --[[ 
     * Set Up Group Frame
     * --------------------------------
     * Called by FTC.Frames:Initialize()
     * --------------------------------
     ]]--
    function FTC.Frames:SetupGroup()

        -- Bail out if the player is not grouped
        if ( not IsUnitGrouped('player') ) then
            FTC_GroupFrame:SetHidden(true) 
            FTC_RaidFrame:SetHidden(true) 
            return
        end

        -- Using group frame
        local context   = nil
        if ( GetGroupSize() <= 4 and FTC.Vars.EnableGroupFrames ) then 
            context = "Group"
            FTC_RaidFrame:SetHidden(true) 

        -- Using raid frames
        elseif ( FTC.Vars.EnableRaidFrames ) then
            context = "Raid"
            FTC_GroupFrame:SetHidden(true) 

        -- Using default frames
        else
            FTC_GroupFrame:SetHidden(true) 
            FTC_RaidFrame:SetHidden(true) 
            ZO_UnitFramesGroups:SetHidden(false)
            return 
        end

        -- Get the parent container
        local container = _G["FTC_"..context.."Frame"]

        -- Iterate over members
        local max = ( context == "Group" ) and 4 or 24
        for i = 1 , max do
            local frame   = container["member"..i]
            local unitTag = GetGroupUnitTagByIndex(i)

            -- Only proceed for members which exist
            if ( DoesUnitExist(unitTag) ) then

                -- Display the frame
                frame:SetHidden(false)

                -- Configure the nameplate
                local name      = zo_strformat("<<!aC:1>>",GetUnitName(unitTag))
                local level     = GetUnitVeteranRank(unitTag) > 0 and "v" .. GetUnitVeteranRank(unitTag) or GetUnitLevel(unitTag)

                -- Get player roles
                local isDps , isHealer , isTank = GetGroupMemberRoles(unitTag)
                local role      = "Damage"
                if isTank       then role = "Tank"
                elseif isHealer then role = "Healer" end
                FTC.Group[i].role = role

                -- Determine bar color
                local color =( FTC.Vars.ColorRoles ) and FTC.Vars["Frame"..role.."Color"] or FTC.Vars.FrameHealthColor

                -- Color bar by role
                frame.health:SetCenterColor(color[1]/5,color[2]/5,color[3]/5,1)
                frame.health.bar:SetColor(color[1],color[2],color[3] ,1)

                -- Populate nameplate
                local label = ( context == "Group" ) and name .. " (" .. level .. ")" or name
                frame.plate.name:SetText(label)

                -- Populate leader icon
                frame.plate.icon:SetWidth(IsUnitGroupLeader(unitTag) and 24 or 0)

                -- Maybe populate class icon
                if ( context == "Group" ) then
                    local classIcon = GetClassIcon(GetUnitClassId(unitTag)) or nil
                    frame.plate.class:SetTexture(classIcon)
                    frame.plate.class:SetHidden(classIcon==nil)
                end

                -- Populate health bar
                FTC.Frames:UpdateAttribute( unitTag , POWERTYPE_HEALTH , nil )

                -- Override for offline members
                if ( not IsUnitOnline(unitTag) ) then 
                    frame.health.current:SetText(GetString(FTC_Offline))
                    frame.health.pct:SetText("")
                    frame.health.bar:SetWidth(0)
                end

                -- Change the bar color
                FTC.Frames:GroupRange( 'group'..i , nil )

                -- Maybe hide the player
                if ( context == "Group" ) then
                    if ( FTC.Vars.GroupHidePlayer and i == GetGroupIndexByUnitTag('player') ) then
                        frame:SetHidden(true) 
                        frame:SetHeight(0)
                    else frame:SetHeight(FTC.Vars.GroupHeight/4) end
                end

            -- Otherwise hide the frame
            else frame:SetHidden(true) end
        end

        -- Display custom frames
        container:SetHidden(false)
        ZO_UnitFramesGroups:SetHidden(true)
    end


     --[[ 
     * Handle Group Member Visibility
     * --------------------------------
     * Called by FTC.Frames:Initialize()
     * --------------------------------
     ]]--
    function FTC.Frames:GroupRange( unitTag , inRange )

        -- Bail out if group frames are disabled
        if ( not FTC.Vars.EnableGroupFrames or GetGroupSize() > 4 ) then 
            ZO_UnitFramesGroups:SetHidden(false)
            return 
        end

        -- Otherwise make sure the defaults stay hidden
        ZO_UnitFramesGroups:SetHidden(true)

        -- Retrieve the frame
        local i = GetGroupIndexByUnitTag(unitTag)
        local frame = _G["FTC_GroupFrame"..i]

        -- Bail if the group member has not yet been set up
        if ( FTC.Group[i] == nil ) then return end

        -- If a range status was not passed, retrieve it
        if ( inRange == nil ) then inRange = IsUnitInGroupSupportRange(unitTag) end

        -- Get player roles
        local role  = FTC.Group[i].role
        local color = ( FTC.Vars.ColorRoles and role ~= nil ) and FTC.Vars["Frame"..role.."Color"] or FTC.Vars.FrameHealthColor

        -- Darken the color of the bar
        local newColor  = inRange and color or { color[1]/2 , color[2]/2 , color[3]/2 }
        frame.health.bar:SetColor(unpack(newColor))
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
     
        -- Setup placeholders
        local data  = nil
        local frame = nil
        local round = false

        -- Player Frame
        if ( unitTag == 'player' ) then
            data    = FTC.Player
            frame   = _G["FTC_PlayerFrame"]
        
        -- Target Frame
        elseif ( unitTag == 'reticleover' ) then
            data    = FTC.Target
            frame   = _G["FTC_TargetFrame"]

        -- Group Frames
        elseif ( string.find(unitTag,"group") > 0 and ( FTC.Vars.EnableGroupFrames or FTC.Vars.EnableRaidFrames ) ) then

            -- Get the group member
            local i = GetGroupIndexByUnitTag(unitTag)
            data    = FTC.Group[i]

            -- Get the frame
            if ( GetGroupSize() <= 4 and FTC.Vars.EnableGroupFrames ) then 
                frame = _G["FTC_GroupFrame" .. i]
                ZO_UnitFramesGroups:SetHidden(true)
            elseif ( FTC.Vars.EnableRaidFrames ) then 
                frame = _G["FTC_RaidFrame" .. i]  
                round = true
                ZO_UnitFramesGroups:SetHidden(true)
            end

            -- Run fade animation
            FTC.Frames:Fade(unitTag,frame) 

        -- Otherwise bail out
        else return end
        
        -- Translate the attribute
        local attrs = { [POWERTYPE_HEALTH] = "health", [POWERTYPE_MAGICKA] = "magicka", [POWERTYPE_STAMINA] = "stamina" }
        local power = attrs[powerType]

        -- Get the value if it was not provided
        if ( powerValue == nil ) then
            powerValue, powerMax, powerEffectiveMax = GetUnitPower( unitTag , powerType )
        end
        
        -- Get the percentage
        local pct = math.max(zo_roundToNearest((powerValue or 0)/powerMax,0.01),0)
        
        -- Update custom frames
        if ( FTC.init.Frames ) then
        
            -- Update bar width
            local attr = frame[power]
            attr.bar:SetWidth( pct * (attr:GetWidth()-4) )

            -- Update bar labels
            local label = ( powerValue > 100000 or round ) and FTC.DisplayNumber(powerValue/1000,1) .. "k" or FTC.DisplayNumber(powerValue)
            local pctLabel = (pct*100) .. "%"
            
            -- Maybe add shielding
            if ( powerType == POWERTYPE_HEALTH ) then
                local slabel = ( round ) and FTC.DisplayNumber(data.shield.current/1000,1).."k" or FTC.DisplayNumber(data.shield.current)
                label = ( data.shield.current ~= nil and data.shield.current > 0 ) and label .. " [" .. slabel .. "]" or label
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
            if ( unitTag == 'reticleover' ) then 
                frame.execute:SetHidden( not ( pct < FTC.Vars.ExecuteThreshold/100 ) )
                if ( ( not IsUnitDead(unitTag) ) and ( pct < FTC.Vars.ExecuteThreshold/100 ) and ( FTC.Target.health.pct > FTC.Vars.ExecuteThreshold/100 ) ) then FTC.Frames:Execute() end
            end
        end
        
        -- Update the database object
        data[power] = { ["current"] = powerValue , ["max"] = powerMax , ["pct"] = pct }
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

        -- Setup placeholders
        local data  = nil
        local frame = nil
        local round = false

        -- Player Frame
        if ( unitTag == 'player' ) then
            data    = FTC.Player
            frame   = _G["FTC_PlayerFrame"]
        
        -- Target Frame
        elseif ( unitTag == 'reticleover' ) then
            data    = FTC.Target
            frame   = _G["FTC_TargetFrame"]

        -- Group Frames
        elseif ( string.find(unitTag,"group") > 0 and ( FTC.Vars.EnableGroupFrames or FTC.Vars.EnableRaidFrames ) ) then

            -- Get the group member
            local i = GetGroupIndexByUnitTag(unitTag)
            data    = FTC.Group[i]

            -- Get the frame
            if ( GetGroupSize() <= 4 and FTC.Vars.EnableGroupFrames ) then frame = _G["FTC_GroupFrame" .. i]
            elseif ( FTC.Vars.EnableRaidFrames ) then 
                frame = _G["FTC_RaidFrame" .. i]
                round = true  
            end

            -- Run fade animation
            FTC.Frames:Fade(unitTag,frame) 

        -- Otherwise bail out
        else return end

        -- If no data was passed, get new data
        if ( value == nil ) then 
            value = GetUnitAttributeVisualizerEffectInfo(unitTag,ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH) or 0
        end
        
        -- Get the unit's maximum health
        local shieldPct = zo_roundToNearest(value/data["health"]["max"],0.01)

        -- Strip any existing tooltip
        local tooltip = string.gsub( frame.health.current:GetText() , " %[(.*)%]" , "")
        
        -- Display shield
        if ( value > 0 ) then
            frame.shield:SetWidth( math.min(shieldPct,1) * frame.health:GetWidth())
            frame.shield.bar:SetWidth(frame.shield:GetWidth()-4)

            -- Update the health text
            local displayText = round and tooltip.." ["..FTC.DisplayNumber(value/1000,1).."k]" or tooltip.." ["..FTC.DisplayNumber(value).."]"
            frame.health.current:SetText(displayText)

            -- Ensure visibility
            frame.shield:SetHidden(false)   

        -- Hide shield
        else
            frame.health.current:SetText(tooltip)
            frame.shield:SetHidden(true)
        end
        
        -- Update the database object
        data.shield = { ["current"] = value , ["max"] = maxValue , ["pct"] = shieldPct }
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


--[[----------------------------------------------------------
    UPDATING
  ]]----------------------------------------------------------

     --[[ 
     * Safety Check Function to Ensure Accuracy
     * --------------------------------
     * Called by FTC.Frames:Initialize()
     * --------------------------------
     ]]--
    function FTC.Frames:SafetyCheck()

        -- Don't update the player in combat
        if ( not IsUnitInCombat('player') ) then

            -- Make sure attributes are up to date
            if ( not FTC.inMenu ) then
                FTC.Frames:UpdateAttribute( 'player',POWERTYPE_HEALTH,nil,nil,nil  )
                FTC.Frames:UpdateAttribute( 'player',POWERTYPE_MAGICKA,nil,nil,nil )
                FTC.Frames:UpdateAttribute( 'player',POWERTYPE_STAMINA,nil,nil,nil )
                FTC.Frames:UpdateShield( 'player',nil,nil )
            end

            -- Make sure fade is correct
            FTC.Frames:Fade('player',FTC_PlayerFrame)
        end

        -- Group frames
        if ( IsUnitGrouped('player') ) then

            -- Update attributes out of combat
            if ( not IsUnitInCombat('player') ) then 
                for i = 1 , GetGroupSize() do
                    FTC.Frames:UpdateAttribute( GetGroupUnitTagByIndex(i),POWERTYPE_HEALTH,nil,nil,nil  )
                end
            end

            -- Ensure correct fade
            local context = GetGroupSize() <= 4 and "Group" or "Raid"
            for i = 1 , GetGroupSize() do FTC.Frames:Fade('group'..i,_G["FTC_"..context.."Frame"..i]) end
        end
    end