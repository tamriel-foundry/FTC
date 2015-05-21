
--[[----------------------------------------------------------
    FOUNDRY TACTICAL COMBAT
    ----------------------------------------------------------
    FTC is a user interface overhaul designed the replace the Elder Scrolls Online 
    interface and provide useful and time-sensitive information about combat events
    allowing players to better respond and react to evolving game situations.

    The add-on features several components:
    (1) Unit Frames
    (2) Buff Tracking
    (3) Combat Log
    (4) Scrolling Combat Text
    (5) Advanced Hotbar
    (6) Damage Statistics
    (7) Group Frames

    Author:   Atropos
    Email:    atropos@tamrielfoundry.com
    Version:  0.39
    Updated:  5-10-2015
  ]]--

--[[----------------------------------------------------------
    INITIALIZATION
  ]]----------------------------------------------------------

-- Core FTC Settings
FTC                     = {}
FTC.name                = "FoundryTacticalCombat"
FTC.tag                 = "FTC"
FTC.version             = 0.40
FTC.settings            = 0.40
FTC.language            = GetCVar("language.2")
FTC.UI                  = WINDOW_MANAGER:CreateTopLevelWindow( "FTC_UI" )

-- Default Components
FTC.Defaults            = {
    ["EnableFrames"]    = true,
    ["EnableBuffs"]     = true,
    ["EnableLog"]       = true,
    ["EnableSCT"]       = true,
    ["EnableHotbar"]    = false,
    ["EnableStats"]     = false,
}

-- Track component initialization
FTC.init                = {}

-- Track custom display conditions
FTC.inMenu              = false
FTC.move                = false

--[[ 
 * Master Initialization Function
 * --------------------------------
 * Triggered by EVENT_ADD_ON_LOADED
 * --------------------------------
 ]]-- 
function FTC.Initialize( eventCode, addOnName )

    -- Only set up for FTC
    if ( addOnName ~= FTC.name ) then return end

    -- Unregister setup event
    EVENT_MANAGER:UnregisterForEvent( "FTC" , EVENT_ADD_ON_LOADED )
    
    -- Load Saved Variables
    FTC.Vars = ZO_SavedVars:NewAccountWide( 'FTC_VARS' , (FTC.settings*100) , nil , FTC.Defaults )
    --FTC.Vars = FTC.Defaults

    -- Initialize UI Layer
    FTC.UI:Initialize()

    -- Register custom effects
    FTC.Buffs:RegisterEffects()
    
    -- Setup Character Management
    FTC.Player:Initialize()
    FTC.Target:Initialize()
    FTC.Group:Initialize()

    -- Setup Damage Management
    FTC.Damage:Initialize()

    -- Unit Frames Component
    if ( FTC.Vars.EnableFrames )    then FTC.Frames:Initialize() end

    -- Active Buffs Component
    if ( FTC.Vars.EnableBuffs )     then FTC.Buffs:Initialize() end

    -- Combat Log Component
    if ( FTC.Vars.EnableLog )       then FTC.Log:Initialize() end

    -- Combat Text Component
    if ( FTC.Vars.EnableSCT )       then FTC.SCT:Initialize() end

    -- Advanced Hotbar Component
    --if ( FTC.Vars.EnableHotbar )    then FTC.Hotbar:Initialize() end
    
    -- Combat Statistics
    --if ( FTC.Vars.EnableStats )     then FTC.Stats:Initialize() end
    
    -- Menu Component
    FTC.Menu:Initialize()
    
    -- Register Event Handlers
    FTC:RegisterEvents()
    
    -- Register Slash Command
    SLASH_COMMANDS["/"..FTC.tag] = FTC.Slash
    SLASH_COMMANDS["/"..string.lower(FTC.tag)] = FTC.Slash
    
    -- Fire Setup Callback
    CALLBACK_MANAGER:FireCallbacks("FTC_Ready")
end

 -- Hook initialization to EVENT_ADD_ON_LOADED
EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ADD_ON_LOADED , FTC.Initialize )
