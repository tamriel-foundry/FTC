
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

        -- Show the player frame
        FTC_PlayerFrame:ClearAnchors()
        FTC_PlayerFrame:SetAnchor(BOTTOMLEFT,FTC_UI,CENTER,50,-20)
        FTC_PlayerFrame:SetHidden(false)
        FTC_PlayerFrame:SetAlpha(1)

        -- Show the target frame
        FTC_TargetFrame:ClearAnchors()
        FTC_TargetFrame:SetAnchor(TOPLEFT,FTC_UI,CENTER,50,20)
        FTC_TargetFrame:SetHidden(false)
        FTC_TargetFrame:SetAlpha(1)

        -- Spoof a shield on the player frame
        FTC.Frames:UpdateShield( 'player', math.floor(FTC.Player.health.max*.75) ,  FTC.Player.health.max )

        -- Toggle visibility
        FTC.inMenu = true
        FTC:ToggleVisibility()

    -- Otherwise, restore their positions
    else

        -- Reset the player frame
        FTC_PlayerFrame:ClearAnchors()
        local anchor = FTC.Vars.FTC_PlayerFrame
        FTC_PlayerFrame:SetAnchor(anchor[1],FTC_UI,anchor[2],anchor[3],anchor[4])
        FTC.Frames:SetupPlayer()

        -- Reset the target frame
        FTC_TargetFrame:ClearAnchors()
        local anchor = FTC.Vars.FTC_TargetFrame
        FTC_TargetFrame:SetAnchor(anchor[1],FTC_UI,anchor[2],anchor[3],anchor[4])
        FTC.Frames:SetupTarget()

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
    if ( isValidAnchor ) then
        FTC.Vars[control:GetName()] = {point,relativePoint,offsetX,offsetY}
    end
end

--[[ 
 * Reset Settings to Default
 * --------------------------------
 * Called by FTC.Menu:Controls()
 * --------------------------------
 ]]--
function FTC.Menu:Reset(context)

    -- Reset unit frames
    if ( context == "Frames" or context == nil ) then
        for var , value in pairs( FTC.Frames.Defaults ) do
            FTC.Vars[var] = value   
        end
        FTC.Menu:UpdateFrames()
    end

    -- Reset buffs

    -- Reset combat text

    -- Reset hotbar

    -- Reset damage statistics
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