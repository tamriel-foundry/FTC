 
--[[----------------------------------------------------------
    OPTIONS MENU CONTROLS
  ]]----------------------------------------------------------
    
--[[ 
 * Initialize Unit Frames Component
 * --------------------------------
 * Sets up controls for the menu component of FTC
 * Depends on LibAddonMenu-2.0
 * Called by FTC.Menu:Initialize()
 * --------------------------------
 ]]--
function FTC.Menu:Controls()

    --[[----------------------------------------------------------
        SELECT CORE COMPONENTS
      ]]----------------------------------------------------------
    FTC.Menu.options = {

        -- Components Header
        {   type        = "header", 
            name        = GetString(FTC_Menu_Configure),
            width       = "full" 
        },

        -- Enable/Disable Unit Frames
        {   type        = "checkbox", 
            name        = GetString(FTC_Menu_Frames),
            tooltip     = GetString(FTC_Menu_FramesDesc),
            getFunc     = function() return FTC.Vars.EnableFrames end, 
            setFunc     = function() FTC.Menu:Toggle( 'EnableFrames' , true ) end, 
            default     = FTC.Defaults.EnableFrames, 
            warning     = GetString(FTC_Menu_Reload),
        },

        -- Enable/Disable Buff Tracking
        {   type        = "checkbox",
            name        = GetString(FTC_Menu_Buffs),
            tooltip     = GetString(FTC_Menu_BuffsDesc),
            getFunc     =  function() return FTC.Vars.EnableBuffs end,
            setFunc     = function() FTC.Menu:Toggle( 'EnableBuffs' , true ) end,
            default     = FTC.Defaults.EnableBuffs, 
            warning     = GetString(FTC_Menu_Reload),
        },

        -- Enable/Disable Damage Meter
        {   type        = "checkbox",
            name        = GetString(FTC_Menu_Damage),
            tooltip     = GetString(FTC_Menu_DamageDesc),
            getFunc     = function() return FTC.Vars.EnableDamage end, 
            setFunc     = function() FTC.Menu:Toggle( 'EnableDamage' , true ) end, 
            default     = FTC.Defaults.EnableDamage, 
            warning     = GetString(FTC_Menu_Reload),
        },

        -- Enable/Disable Scrolling Combat Text
        {   type        = "checkbox", 
            name        = GetString(FTC_Menu_SCT),
            tooltip     = GetString(FTC_Menu_SCTDesc),
            getFunc     = function() return FTC.Vars.EnableSCT end, 
            setFunc     = function() FTC.Menu:Toggle( 'EnableSCT' , true ) end, 
            default     = FTC.Defaults.EnableSCT, 
            warning     = GetString(FTC_Menu_Reload),
        },

        -- Enable/Disable Ultimate Tracking
        {   type        = "checkbox", 
            name        = GetString(FTC_Menu_Hotbar),
            tooltip     = GetString(FTC_Menu_HotbarDesc),
            getFunc     = function() return FTC.Vars.EnableHotbar end, 
            setFunc     = function() FTC.Menu:Toggle( 'EnableHotbar' , true ) end, 
            default     = FTC.Defaults.EnableHotbar, 
            warning     = GetString(FTC_Menu_Reload),
        }
    }

    --[[----------------------------------------------------------
        UNIT FRAMES
      ]]----------------------------------------------------------
    local Frames = {

        -- Unit Frames Header
        {   type        = "header", 
            name        = GetString(FTC_Menu_FHeader),
            width       = "full" 
        },

        -- Unit Frame Width
        {   type        = "slider", 
            name        = GetString(FTC_Menu_FWidth),
            tooltip     = GetString(FTC_Menu_FWidthDesc),
            min         = 200, 
            max         = 500, 
            step        = 50, 
            getFunc     = function() return FTC.Vars.FrameWidth end, 
            setFunc     = function( value ) FTC.Menu:UpdateFrames( "FrameWidth" , value ) end, 
            default     = FTC.Defaults.FrameWidth,
        },

        -- Unit Frame Height
        {   type        = "slider", 
            name        = GetString(FTC_Menu_FHeight),
            tooltip     = GetString(FTC_Menu_FHeightDesc),
            min         = 120, 
            max         = 360, 
            step        = 30, 
            getFunc     = function() return FTC.Vars.FrameHeight end, 
            setFunc     = function( value ) FTC.Menu:UpdateFrames( "FrameHeight" , value ) end, 
            default     = FTC.Defaults.FrameHeight,
        },

        -- In-Combat Opacity
        {   type        = "slider", 
            name        = GetString(FTC_Menu_FOpacIn),
            tooltip     = GetString(FTC_Menu_FOpacInDesc),
            min         = 0, 
            max         = 100, 
            step        = 10, 
            getFunc     = function() return FTC.Vars.FrameOpacityIn end, 
            setFunc     = function( value ) FTC.Menu:Update( "FrameOpacityIn" , value ) end, 
            default     = FTC.Defaults.OpacityIn
        },
           
        -- Non-Combat Opacity
        {   type        = "slider", 
            name        = GetString(FTC_Menu_FOpacOut),
            tooltip     = GetString(FTC_Menu_FOpacOutDesc),
            min         = 0, 
            max         = 100, 
            step        = 10,
            getFunc     = function() return FTC.Vars.FrameOpacityOut end, 
            setFunc     = function( value ) FTC.Menu:Update( "FrameOpacityOut" , value ) end, 
            default     = FTC.Defaults.OpacityOut
        },

        -- Primary Frame Font
        {   type        = "dropdown", 
            name        = GetString(FTC_Menu_FFont1),
            tooltip     = GetString(FTC_Menu_FFont1Desc),
            choices     = { "Metamorphous", "ESO Standard" , "ESO Bold" , "Prose Antique" , "Handwritten" , "Trajan Pro" , "Futura Standard" , "Futura Bold" }, 
            getFunc     = function() return FTC.UI:TranslateFont(FTC.Vars.FrameFont1) end, 
            setFunc     = function( value ) FTC.Menu:UpdateFrames( "FrameFont1" , FTC.UI:TranslateFont(value) ) end,
            default     = FTC.Defaults.FrameFont1, 
        },

        -- Secondary Frame Font
        {   type        = "dropdown", 
            name        = GetString(FTC_Menu_FFont2),
            tooltip     = GetString(FTC_Menu_FFont2Desc),
            choices     = { "Metamorphous", "ESO Standard" , "ESO Bold" , "Prose Antique" , "Handwritten" , "Trajan Pro" , "Futura Standard" , "Futura Bold" }, 
            getFunc     = function() return FTC.UI:TranslateFont(FTC.Vars.FrameFont2) end, 
            setFunc     = function( value ) FTC.Menu:UpdateFrames( "FrameFont2" , FTC.UI:TranslateFont(value) ) end,
            default     = FTC.Defaults.FrameFont2, 
        },

        -- Frame Font Size
        {   type        = "slider", 
            name        = GetString(FTC_Menu_FFontS),
            tooltip     = GetString(FTC_Menu_FFontSDesc),
            min         = 12,
            max         = 24, 
            step        = 1, 
            getFunc     = function() return FTC.Vars.FrameFontSize end, 
            setFunc     = function( value ) FTC.Menu:UpdateFrames( "FrameFontSize" , value ) end, 
            default     = FTC.Defaults.FrameFontSize
        },

        -- Execute Threshold
        {   type        = "slider", 
            name        = GetString(FTC_Menu_Exceute),
            tooltip     = GetString(FTC_Menu_ExecuteDesc),
            min         = 0,
            max         = 50, 
            step        = 5, 
            getFunc     = function() return FTC.Vars.ExecuteThreshold end, 
            setFunc     = function( value ) FTC.Menu:Update( "ExecuteThreshold" , value ) end, 
            default     = FTC.Defaults.ExecuteThreshold
        },
        
        -- Show Default Frames?
        {   type        = "checkbox", 
            name        = GetString(FTC_Menu_FShowDef),
            tooltip     = GetString(FTC_Menu_FShowDefDesc),
            getFunc     =  function() return FTC.Vars.DefaultTargetFrame end, 
            setFunc     = function() FTC.Menu:Toggle( 'DefaultTargetFrame' ) end,
            default     = FTC.Defaults.DefaultTargetFrame
        },

        -- Display Nameplate?
        {   type        = "checkbox", 
            name        = GetString(FTC_Menu_FShowName),
            tooltip     = GetString(FTC_Menu_FShowNameDesc),
            getFunc     = function() return FTC.Vars.EnableNameplate end, 
            setFunc     = function() FTC.Menu:Toggle( 'EnableNameplate' ) end,
            default     = FTC.Defaults.EnableNameplate
        },

        -- Display Experience Bar?
        {   type        = "checkbox", 
            name        = GetString(FTC_Menu_FShowXP),
            tooltip     = GetString(FTC_Menu_FShowXPDesc),
            getFunc     = function() return FTC.Vars.EnableXPBar end, 
            setFunc     = function() FTC.Menu:Toggle( 'EnableXPBar' ) end,
            default     = FTC.Defaults.EnableXPBar
        },

        -- Health Bar Color
        {   type        = "colorpicker", 
            name        = GetString(FTC_Menu_FHealthC),
            tooltip     = GetString(FTC_Menu_FHealthCDesc),
            getFunc     = function() return FTC.Vars.FrameHealthColor[1],FTC.Vars.FrameHealthColor[2],FTC.Vars.FrameHealthColor[3] end, 
            setFunc     = function(r,g,b,a) FTC.Menu:UpdateFrames('FrameHealthColor', { math.floor(r*100)/100 , math.floor(g*100)/100 , math.floor(b*100)/100 }) end,
            default     = FTC.Vars.FrameHealthColor,
        },

        -- Magicka Bar Color
        {   type        = "colorpicker", 
            name        = GetString(FTC_Menu_FMagickaC),
            tooltip     = GetString(FTC_Menu_FMagickaCDesc),
            getFunc     = function() return FTC.Vars.FrameMagickaColor[1],FTC.Vars.FrameMagickaColor[2],FTC.Vars.FrameMagickaColor[3] end, 
            setFunc     = function(r,g,b,a) FTC.Menu:UpdateFrames('FrameMagickaColor', { math.floor(r*100)/100 , math.floor(g*100)/100 , math.floor(b*100)/100 }) end,
            default     = FTC.Vars.FrameMagickaColor,
        },

        -- Stamina Bar Color
        {   type        = "colorpicker", 
            name        = GetString(FTC_Menu_FStaminaC),
            tooltip     = GetString(FTC_Menu_FStaminaCDesc),
            getFunc     = function() return FTC.Vars.FrameStaminaColor[1],FTC.Vars.FrameStaminaColor[2],FTC.Vars.FrameStaminaColor[3] end, 
            setFunc     = function(r,g,b,a) FTC.Menu:UpdateFrames('FrameStaminaColor', { math.floor(r*100)/100 , math.floor(g*100)/100 , math.floor(b*100)/100 }) end,
            default     = FTC.Vars.FrameStaminaColor,
        },

        -- Shield Bar Color
        {   type        = "colorpicker", 
            name        = GetString(FTC_Menu_FShieldC),
            tooltip     = GetString(FTC_Menu_FShieldCDesc),
            getFunc     = function() return FTC.Vars.FrameShieldColor[1],FTC.Vars.FrameShieldColor[2],FTC.Vars.FrameShieldColor[3] end, 
            setFunc     = function(r,g,b,a) FTC.Menu:UpdateFrames('FrameShieldColor', { math.floor(r*100)/100 , math.floor(g*100)/100 , math.floor(b*100)/100 }) end,
            default     = FTC.Vars.FrameShieldColor,
        },

        -- Reset Unit Frames
        { 
            type        = "button", 
            name        = GetString(FTC_Menu_FReset),
            tooltip     = GetString(FTC_Menu_FResetDesc),
            func        = function() FTC.Menu:Reset("Frames") end,
        }, 
    }
    if FTC.Vars.EnableFrames then
        for i = 1 , #Frames do table.insert( FTC.Menu.options , Frames[i] ) end
    end

    --[[----------------------------------------------------------
        BUFF TRACKING
      ]]----------------------------------------------------------
    local Extras = {

        -- Buffs Header
        { 
            type        = "header", 
            name        = FTC.L("Buff Tracker Settings"), 
            width       = "full"
        },

        -- Anchor Buffs?
        { 
            type        = "checkbox", 
            name        = FTC.L("Anchor Buffs"), 
            tooltip     = FTC.L("Anchor buffs to unit frames?"), 
            getFunc     = function() return FTC.Vars.AnchorBuffs end, 
            setFunc     = function() FTC.Menu:Toggle( 'AnchorBuffs' , true ) end, 
            default     = FTC.Defaults.AnchorBuffs
        },
        
        -- Display Long Buffs?
        { 
            type        = "checkbox", 
            name        = FTC.L("Display Long Buffs"), 
            tooltip     = FTC.L("Track long duration player buffs?"), 
            getFunc     = function() return FTC.Vars.EnableLongBuffs end, 
            setFunc     = function() FTC.Menu:Toggle( 'EnableLongBuffs' ) end, 
            default     = FTC.Defaults.EnableLongBuffs
        },
    }
    if FTC.Vars.EnableBuffs then
        for i = 1 , #Extras do table.insert( FTC.Menu.options , Extras[i] ) end
    end

    --[[----------------------------------------------------------
        SCROLLING COMBAT TEXT
      ]]----------------------------------------------------------
    local Extras = {

        -- SCT Header
        { 
            type        = "header", 
            name        = FTC.L("Scrolling Combat Text Settings"), 
            width       = "full", 
        },
        
        -- SCT Scroll Speed?
        { 
            type        = "slider",
            name        = FTC.L("Combat Text Scroll Speed"), 
            tooltip     = FTC.L("Adjust combat text scroll speed."), 
            min         = 1, 
            max         = 5, 
            step        = 1, 
            getFunc     = function() return FTC.Vars.SCTSpeed end, 
            setFunc     = function( value ) FTC.Menu:Update( "SCTSpeed" , value ) end, 
            default     = FTC.Defaults.SCTSpeed,
        },
        
        -- Display Ability Names?
        { 
            type        = "checkbox", 
            name        = FTC.L("Display Ability Names"), 
            tooltip     = FTC.L("Display ability names in combat text?"), 
            getFunc     = function() return FTC.Vars.SCTNames end, 
            setFunc     = function() FTC.Menu:Toggle( 'SCTNames' , true ) end, 
            warning     = FTC.L("Reloads UI"), 
            default     = FTC.Defaults.SCTNames,
        },

        -- Select Scroll Animation?
        { 
            type        = "dropdown", 
            name        = FTC.L("Scroll Path Animation"), 
            tooltip     = FTC.L("Choose scroll animation."), 
            choices     = { "Arc", "Line" }, 
            getFunc     = function() return FTC.Vars.SCTPath end, 
            setFunc     = function( value ) FTC.Menu:Update( "SCTPath" , value ) end,
            default     = FTC.Defaults.SCTPath, 
        },
    }
    if FTC.Vars.EnableSCT then
        for i = 1 , #Extras do table.insert( FTC.Menu.options , Extras[i] ) end
    end

    --[[----------------------------------------------------------
        DAMAGE METER
      ]]----------------------------------------------------------
    local Extras = {
        
        -- Damage Tracker Header
        { 
            type        = "header", 
            name        = FTC.L("Damage Tracker Settings"), 
            width       = "full"
        },

        -- Damage Tracker Threshold
        { 
            type        = "slider", 
            name        = FTC.L("Timeout Threshold"), 
            tooltip     = FTC.L("Number of seconds without damage to signal encounter termination."), 
            min         = 5, 
            max         = 60, 
            step        = 5, 
            getFunc     = function() return FTC.Vars.DamageTimeout end, 
            setFunc     = function( value ) FTC.Menu:Update( "DamageTimeout" , value ) end,
            default     = FTC.Defaults.DamageTimeout,
        }
    }
    if FTC.Vars.EnableDamage then
        for i = 1 , #Extras do table.insert( FTC.Menu.options , Extras[i] ) end
    end

    --[[----------------------------------------------------------
        REPOSITION ELEMENTS
      ]]----------------------------------------------------------
    local Core = {
        
        -- Reposition Header
        { 
            type        = "header", 
            name        = FTC.L("Reposition FTC Elements"),
            width       = "full" 
        },
    
        -- Augment Default Frames?
        { 
            type        = "button", 
            name        = FTC.L("Lock Positions"),
            tooltip     = FTC.L("Modify FTC frame positions?"), 
            func        = function() FTC.Menu:MoveFrames() end,
        }, 

        -- Restore Defaults?
        { 
            type        = "header", 
            name        = FTC.L("Reset Settings"),
            width       = "full" 
        },

        { 
            type        = "button", 
            name        = FTC.L("Restore Defaults"),
            tooltip     = FTC.L("Restore FTC to default settings."),
            func        = function() FTC.Menu:Reset() end,
            warning     = FTC.L("Reloads UI")
        }, 
    }
    for i = 1 , #Core do table.insert( FTC.Menu.options , Core[i] ) end

end
