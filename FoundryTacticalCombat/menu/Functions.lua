
--[[----------------------------------------------------------
    MENU OPTIONS COMPONENT
  ]]----------------------------------------------------------

    --[[ 
     * Initialize Menu Component
     * --------------------------------
     * Called by FTC:Initialize()
     * --------------------------------
     ]]--
    FTC.Menu = {}
    LAM2     = LibStub("LibAddonMenu-2.0")      
    function FTC.Menu:Initialize()

        -- Configure the master panel
        FTC.Menu.panel = { 
            type                = "panel", 
            name                = FTC.tag, 
            displayName         = GetString(FTC_ShortInfo),
            author              = "Atropos", 
            version             = FTC.version, 
            registerForRefresh  = true,
            registerForDefaults = true,
        }

        -- Setup the initial panel
        LAM2:RegisterAddonPanel( "FTC_Menu" , FTC.Menu.panel )

        -- Configure menu control options
        FTC.Menu:Controls()

        -- Setup the menus
        LAM2:RegisterOptionControls( "FTC_Menu", FTC.Menu.options )

        -- Register callback to detect when the menu is open
        CALLBACK_MANAGER:RegisterCallback("LAM-RefreshPanel" , function(panel) FTC.Menu:Reposition(panel) end )

        -- Register a callback to detect when the menu closes
        FTC_Menu:SetHandler( "OnHide", function(panel) FTC.Menu:Reposition(panel) end)
    end

    --[[ 
     * Reposition Elements During Menu
     * --------------------------------
     * Called by callback LAM-RefreshPanel
     * Called by handler FTC_Menu:OnHide()
     * --------------------------------
     ]]--
    function FTC.Menu:Reposition(panel)
        
        -- Bail if it's some other panel
        if ( panel ~= FTC_Menu ) then return end

        -- If the menu is shown, move some objects to the right side of the screen
        if ( not panel:IsHidden() ) then

            -- Unit Frames Display
            if ( FTC.init.Frames ) then 

                -- Show the player frame
                FTC_PlayerFrame:ClearAnchors()
                FTC_PlayerFrame:SetAnchor(BOTTOMLEFT,FTC_UI,CENTER,25,-200)
                FTC_PlayerFrame:SetHidden(false)
                FTC_PlayerFrame:SetAlpha(1)

                -- Show the target frame
                FTC_TargetFrame:ClearAnchors()
                FTC_TargetFrame:SetAnchor(TOPLEFT,FTC_UI,CENTER,25,200)
                FTC_TargetFrame:SetHidden(false)
                FTC_TargetFrame:SetAlpha(1)

                -- Spoof a shield on the player frame
                FTC.Frames:UpdateShield( 'player', math.floor(FTC.Player.health.max*.75) ,  FTC.Player.health.max )
            end

            -- Buff Tracking Display
            if ( FTC.init.Buffs ) then 

                -- Spoof buffs for player and target
                FTC.Buffs.Target = {}
                EVENT_MANAGER:RegisterForUpdate( "FTC_MenuBuffs" , 100 , function() FTC.Menu:FakeBuffs() end )
            end

            -- Combat Log Display
            if ( FTC.init.Log ) then FTC_CombatLog:SetHidden(true) end

            -- Toggle visibility
            FTC.inMenu = true
            FTC:ToggleVisibility()

        -- Otherwise, restore their positions
        else

            -- Unit Frames Display
            if ( FTC.init.Frames ) then 

                -- Reset the player frame
                FTC_PlayerFrame:ClearAnchors()
                local anchor = FTC.Vars.FTC_PlayerFrame
                FTC_PlayerFrame:SetAnchor(anchor[1],FTC_UI,anchor[2],anchor[3],anchor[4])

                -- Restore the correct shield
                local value, maxValue = GetUnitAttributeVisualizerEffectInfo('player',ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH)
                FTC.Frames:UpdateShield( 'player', value or 0 , maxValue or 0)

                -- Reset the target frame
                FTC_TargetFrame:ClearAnchors()
                local anchor = FTC.Vars.FTC_TargetFrame
                FTC_TargetFrame:SetAnchor(anchor[1],FTC_UI,anchor[2],anchor[3],anchor[4])
                FTC.Frames:SetupTarget()
            end

            -- Buff Tracking Display
            if ( FTC.init.Buffs ) then 

                -- Restore buffs for player
                FTC.Buffs.Target = {}
                FTC.Buffs.Player = {}
                EVENT_MANAGER:UnregisterForUpdate( "FTC_MenuBuffs" )
                FTC.Buffs:GetBuffs('player')
            end

            -- Combat Log Display
            if ( FTC.init.Log and not FTC.Vars.AlternateChat ) then FTC_CombatLog:SetHidden( false ) end

            -- Toggle visibility
            FTC.inMenu = false
            FTC:ToggleVisibility()
        end
    end

    --[[ 
     * Toggle Binary Variable
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:Toggle( setting , reload )
        
        -- Update the database
        FTC.Vars[setting] = not FTC.Vars[setting]
        
        -- Re-configure some things
        if ( FTC.init.Frames ) then FTC.Frames:SetupPlayer() end
        
        -- Maybe reload
        if reload then ReloadUI() end
    end

    --[[ 
     * Update Saved Variable
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:Update( setting , value , reload )
        FTC.Vars[setting] = value
        
        -- Maybe reload
        if reload then ReloadUI() end
    end

    --[[ 
     * Update Saved Element Position
     * --------------------------------
     * Called by OnMouseUp() on movable elements
     * --------------------------------
     ]]--
    function FTC.Menu:SaveAnchor( control )
        
        -- Get the new position
        local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = control:GetAnchor()
        
        -- Save the anchors
        if ( isValidAnchor ) then FTC.Vars[control:GetName()] = {point,relativeTo,relativePoint,offsetX,offsetY} end
    end

    --[[ 
     * Reset Settings to Default
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:Reset(context)

        -- Reset everything
        if ( context == nil ) then
            for var , value in pairs( FTC.Defaults ) do
                FTC.Vars[var] = value   
            end
            ReloadUI()

        -- Reset unit frames
        elseif ( context == "Frames" ) then
            for var , value in pairs( FTC.Frames.Defaults ) do
                FTC.Vars[var] = value   
            end
            FTC.Menu:UpdateFrames()

        -- Reset buff tracking
        elseif ( context == "Buffs" ) then
            for var , value in pairs( FTC.Buffs.Defaults ) do
                FTC.Vars[var] = value   
            end
            FTC.Menu:UpdateBuffs()


        -- Reset combat log
        elseif ( context == "Log" ) then
            for var , value in pairs( FTC.Log.Defaults ) do
                FTC.Vars[var] = value   
            end
            FTC.Menu:UpdateLog()            

        -- Reset combat text

        -- Reset hotbar

        -- Reset damage statistics
        end
    end


--[[----------------------------------------------------------
     UNIT FRAMES
  ]]----------------------------------------------------------

    --[[ 
     * Live Update Unit Frames
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:UpdateFrames(setting,value,...)

        -- Maybe apply a new setting
        if ( setting ~= nil and value ~= nil ) then
            FTC.Vars[setting] = value
        end

        -- Rebuild the frames dynamically
        FTC.Frames:Controls()

        -- Re-populate the frames
        FTC.Frames:SetupPlayer()

        -- Position the frame for menu display
        FTC.Menu:Reposition(FTC_Menu)
    end



--[[----------------------------------------------------------
    BUFF TRACKING
  ]]----------------------------------------------------------

    --[[ 
     * Live Update Buff Tracking
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:UpdateBuffs(setting,value,...)

        -- Maybe apply a new setting
        if ( setting ~= nil and value ~= nil ) then
            FTC.Vars[setting] = value
        end

        -- Rebuild the frames dynamically
        FTC.Buffs:Controls()

        -- Change fonts for active buffs
        for _ , buff in pairs(FTC.Buffs.Pool.m_Active) do 
            buff.label = FTC.UI:Label( "FTC_Buff"..buff.id.."_Label", buff, {50,20},  {BOTTOM,BOTTOM,-1,-4}, FTC.UI:Font(FTC.Vars.BuffsFont1,FTC.Vars.BuffsFontSize,true) , {0.8,1,1,1}, {1,1}, nil, false )
            buff.name  = FTC.UI:Label( "FTC_Buff"..buff.id.."_Name",  buff, {450,20}, {LEFT,RIGHT,10,0},     FTC.UI:Font(FTC.Vars.BuffsFont2,FTC.Vars.BuffsFontSize,true) , {1,1,1,1}, {0,1}, "Buff Name", false )
        end

        -- Change fonts for free buffs
        for _ , buff in pairs(FTC.Buffs.Pool.m_Free) do 
            buff.label = FTC.UI:Label( "FTC_Buff"..buff.id.."_Label", buff, {50,20},  {BOTTOM,BOTTOM,-1,-4}, FTC.UI:Font(FTC.Vars.BuffsFont1,FTC.Vars.BuffsFontSize,true) , {0.8,1,1,1}, {1,1}, nil, false )
            buff.name  = FTC.UI:Label( "FTC_Buff"..buff.id.."_Name",  buff, {450,20}, {LEFT,RIGHT,10,0},     FTC.UI:Font(FTC.Vars.BuffsFont2,FTC.Vars.BuffsFontSize,true) , {1,1,1,1}, {0,1}, "Buff Name", false )
        end

        -- Position the frame for menu display
        FTC.Menu:Reposition(FTC_Menu)
    end

    --[[ 
     * Translate Buff Format Into Nicename
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:GetBuffFormat(setting)

        -- Get the stored value
        local value = FTC.Vars[setting]

        -- Return the translated string
        if ( value == "disabled" )   then return GetString(FTC_BuffFormat0)
        elseif ( value == "htiles" ) then return GetString(FTC_BuffFormat1)
        elseif ( value == "vtiles" ) then return GetString(FTC_BuffFormat2)
        elseif ( value == "dlist" )  then return GetString(FTC_BuffFormat3)
        elseif ( value == "alist" )  then return GetString(FTC_BuffFormat4) end
    end

    --[[ 
     * Update Saved Buff Format
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:UpdateBuffFormat(setting,value)

        -- Assign the new variable setting
        if ( value == GetString(FTC_BuffFormat0) )     then FTC.Vars[setting] = "disabled"
        elseif ( value == GetString(FTC_BuffFormat1) ) then FTC.Vars[setting] = "htiles"
        elseif ( value == GetString(FTC_BuffFormat2) ) then FTC.Vars[setting] = "vtiles"
        elseif ( value == GetString(FTC_BuffFormat3) ) then FTC.Vars[setting] = "dlist"
        elseif ( value == GetString(FTC_BuffFormat4) ) then FTC.Vars[setting] = "alist" end

        -- Reconstruct the buff tracking component
        FTC.Menu:UpdateBuffs()
    end

    --[[ 
     * Fake Buffs and Debuffs for Examples
     * --------------------------------
     * Called by FTC.Menu:Reposition()
     * --------------------------------
     ]]--
    function FTC.Menu:FakeBuffs() 

        -- Get the time
        local time = GetFrameTimeSeconds()

        -- Fake Player Buff 1
        if ( FTC.Buffs.Player["Player Buff 1"] == nil ) then
            local ability = {
                ["owner"]   = FTC.Player.name,
                ["name"]    = "Player Buff 1",
                ["dur"]     = 8000, 
                ["cast"]    = 0,
                ["debuff"]  = false,
                ["tex"]     = '/esoui/art/icons/ability_rogue_006.dds',
            }
            FTC.Buffs:NewEffect( ability )
        elseif ( FTC.Buffs.Player["Player Buff 1"]["ends"] <= time + 0.2 ) then FTC.Buffs.Player["Player Buff 1"]["ends"] = time + 8 end

        -- Fake Player Buff 2
        if ( FTC.Buffs.Player["Player Buff 2"] == nil ) then
            local ability = {
                ["owner"]   = FTC.Player.name,
                ["name"]    = "Player Buff 2",
                ["dur"]     = 12000, 
                ["cast"]    = 0,
                ["debuff"]  = false,
                ["tex"]     = '/esoui/art/icons/ability_rogue_048.dds',
            }
            FTC.Buffs:NewEffect( ability )
        elseif ( FTC.Buffs.Player["Player Buff 2"]["ends"] <= time + 0.2) then FTC.Buffs.Player["Player Buff 2"]["ends"] = time + 12 end

        -- Fake Player Debuff 1
        if ( FTC.Buffs.Player["Player Debuff 1"] == nil ) then
            local ability = {
                ["owner"]   = FTC.Player.name,
                ["name"]    = "Player Debuff 1",
                ["dur"]     = 4000, 
                ["cast"]    = 0,
                ["debuff"]  = true,
                ["tex"]     = '/esoui/art/icons/ability_rogue_007.dds',
            }
            FTC.Buffs:NewEffect( ability )
        elseif ( FTC.Buffs.Player["Player Debuff 1"]["ends"] <= time + 0.2 ) then FTC.Buffs.Player["Player Debuff 1"]["ends"] = time + 4 end

        -- Fake Player Debuff 2
        if ( FTC.Buffs.Player["Player Debuff 2"] == nil ) then
            local ability = {
                ["owner"]   = FTC.Player.name,
                ["name"]    = "Player Debuff 2",
                ["dur"]     = 6000, 
                ["cast"]    = 0,
                ["debuff"]  = true,
                ["tex"]     = '/esoui/art/icons/ability_rogue_018.dds',
            }
            FTC.Buffs:NewEffect( ability )
        elseif ( FTC.Buffs.Player["Player Debuff 2"]["ends"] <= time + 0.2 ) then FTC.Buffs.Player["Player Debuff 2"]["ends"] = time + 6 end

        -- Fake Target Buff 1
        if ( FTC.Buffs.Target["Target Buff 1"] == nil ) then
            local ability = {
                ["owner"]   = "",
                ["name"]    = "Target Buff 1",
                ["dur"]     = 8000, 
                ["cast"]    = 0,
                ["debuff"]  = false,
                ["tex"]     = '/esoui/art/icons/ability_rogue_001.dds',
            }
            FTC.Buffs:NewEffect( ability )
        elseif ( FTC.Buffs.Target["Target Buff 1"]["ends"] <= time + 0.2 ) then FTC.Buffs.Target["Target Buff 1"]["ends"] = time + 8 end

        -- Fake Target Buff 2
        if ( FTC.Buffs.Target["Target Buff 2"] == nil ) then
            local ability = {
                ["owner"]   = "",
                ["name"]    = "Target Buff 2",
                ["dur"]     = 12000, 
                ["cast"]    = 0,
                ["debuff"]  = false,
                ["tex"]     = '/esoui/art/icons/ability_rogue_019.dds',
            }
            FTC.Buffs:NewEffect( ability )
        elseif ( FTC.Buffs.Target["Target Buff 2"]["ends"] <= time + 0.2 ) then FTC.Buffs.Target["Target Buff 2"]["ends"] = time + 12 end

        -- Fake Target Debuff 1
        if ( FTC.Buffs.Target["Target Debuff 1"] == nil ) then
            local ability = {
                ["owner"]   = "",
                ["name"]    = "Target Debuff 1",
                ["dur"]     = 4000, 
                ["cast"]    = 0,
                ["debuff"]  = true,
                ["tex"]     = '/esoui/art/icons/ability_rogue_029.dds',
            }
            FTC.Buffs:NewEffect( ability )
        elseif ( FTC.Buffs.Target["Target Debuff 1"]["ends"] <= time + 0.2 ) then FTC.Buffs.Target["Target Debuff 1"]["ends"] = time + 4 end

        -- Fake Target Debuff 2
        if ( FTC.Buffs.Target["Target Debuff 2"] == nil ) then
            local ability = {
                ["owner"]   = "",
                ["name"]    = "Target Debuff 2",
                ["dur"]     = 9000, 
                ["cast"]    = 0,
                ["debuff"]  = true,
                ["tex"]     = '/esoui/art/icons/ability_rogue_022.dds',
            }
            FTC.Buffs:NewEffect( ability ) 
        elseif ( FTC.Buffs.Target["Target Debuff 2"]["ends"] <= time + 0.2 ) then FTC.Buffs.Target["Target Debuff 2"]["ends"] = time + 9 end
    end


--[[----------------------------------------------------------
     COMBAT LOG
  ]]----------------------------------------------------------

    --[[ 
     * Live Combat Log
     * --------------------------------
     * Called by FTC.Menu:Controls()
     * --------------------------------
     ]]--
    function FTC.Menu:UpdateLog(setting,value)

        -- Maybe apply a new setting
        if ( setting ~= nil and value ~= nil ) then
            FTC.Vars[setting] = value
        end

        -- Rebuild the log dynamically
        FTC.Log:Initialize()
    end












--[[ 
 * Enable Re-Positioning Unit Frames
 * --------------------------------
 * Called by FTC.Menu:Controls()
 * --------------------------------
 ]]--
function FTC.Menu:MoveFrames()

    -- Get the current move status
    local move = not FTC.move
    
    -- Display frames
    if ( FTC.init.Frames ) then
        FTC_PlayerFrame:SetHidden( false )
        FTC_PlayerFrame:SetMouseEnabled( move )
        FTC_PlayerFrame:SetMovable( move )
        
        FTC_TargetFrame:SetHidden( not move )
        FTC_TargetFrame:SetMouseEnabled( move )
        FTC_TargetFrame:SetMovable( move )
    end
    
    -- Display buffs
    if ( FTC.init.Buffs ) then
        FTC_PlayerBuffsBackdrop:SetHidden( not move )
        FTC_PlayerBuffsLabel:SetHidden( not move )
        
        FTC_PlayerDebuffsBackdrop:SetHidden( not move )
        FTC_PlayerDebuffsLabel:SetHidden( not move )
    
        FTC_TargetBuffsBackdrop:SetHidden( not move )
        FTC_TargetBuffsLabel:SetHidden( not move )
        
        FTC_TargetDebuffsBackdrop:SetHidden( not move )
        FTC_TargetDebuffsLabel:SetHidden( not move )
    
        FTC_LongBuffs:SetHidden( false )
        FTC_LongBuffs:SetMouseEnabled( move )
        FTC_LongBuffs:SetMovable( move )
        
        if ( not FTC.Vars.AnchorBuffs ) then
            FTC_PlayerBuffs:SetMouseEnabled( move )
            FTC_PlayerBuffs:SetMovable( move )      
            FTC_PlayerDebuffs:SetMouseEnabled( move )
            FTC_PlayerDebuffs:SetMovable( move )
        
            FTC_TargetBuffs:SetMouseEnabled( move )
            FTC_TargetBuffs:SetMovable( move )
            FTC_TargetDebuffs:SetMouseEnabled( move )
            FTC_TargetDebuffs:SetMovable( move )
        end
    end
    
    -- Display SCT
    if ( FTC.init.SCT ) then
        FTC_CombatTextOut:SetHidden(false)
        FTC_CombatTextOut:SetMouseEnabled( move )
        FTC_CombatTextOut:SetMovable( move )
        FTC_CombatTextOut_Backdrop:SetHidden( not move )
        FTC_CombatTextOut_Label:SetHidden( not move )

        FTC_CombatTextIn:SetHidden(false)
        FTC_CombatTextIn:SetMouseEnabled( move )
        FTC_CombatTextIn:SetMovable( move )     
        FTC_CombatTextIn_Backdrop:SetHidden( not move )
        FTC_CombatTextIn_Label:SetHidden( not move )    

        FTC_CombatTextStatus:SetHidden(false)       
        FTC_CombatTextStatus:SetMouseEnabled( move )
        FTC_CombatTextStatus:SetMovable( move )
        FTC_CombatTextStatus_Backdrop:SetHidden( not move )
        FTC_CombatTextStatus_Label:SetHidden( not move )    
    end
    
    -- Toggle the move status
    FTC.move = move
    
    -- Display a message
    local message = move and "FTC frames are now movable, drag them to re-position!" or "FTC frames are now locked!"
end