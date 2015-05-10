
--[[----------------------------------------------------------
    FOUNDRY TACTICAL COMBAT
    ----------------------------------------------------------
    A robust addon designed to overhaul the Elder Scrolls Online interface to provide 
    useful and time-sensitive information about combat events. The add-on features
    several components:
    
     (1) Custom Combat-Friendly Unit Frames
     (2) Active Buff Tracking
     (3) Scrolling Combat Text
     (4) Combat Status Alerts
     (5) Damage Tracking and Data
     
    * Version 0.39
    * atropos@tamrielfoundry.com
    * 5-4-2015
  ]]--

--[[----------------------------------------------------------
    INITIALIZATION
  ]]----------------------------------------------------------

-- Core FTC Settings
FTC                     = {}
FTC.name                = "FoundryTacticalCombat"
FTC.tag                 = "FTC"
FTC.version             = 0.39
FTC.settings            = 0.39
FTC.language            = GetCVar("language.2")
FTC.UI                  = WINDOW_MANAGER:CreateTopLevelWindow( "FTC_UI" )

-- Default Components
FTC.Defaults            = {
    ["EnableFrames"]    = true,
    ["EnableBuffs"]     = true,
    ["EnableLog"]       = true,
    ["EnableSCT"]       = false,
    ["EnableHotbar"]    = false,
    ["EnableStats"]     = false,
}

--[[ Default Saved Variables
	-- Scrolling Combat Text
	["SCTCount"]                = 20,
	["SCTSpeed"]                = 3,
	["SCTNames"]                = true,
	["SCTPath"]                 = 'Arc',
	["FTC_CombatTextOut"]       = {TOP,TOP,-450,80},
	["FTC_CombatTextIn"]        = {TOP,TOP,450,80},
	["FTC_CombatTextStatus"]    = {TOP,TOP,0,80},

	-- Damage
	["FTC_MiniMeter"]           = {TOPLEFT,TOPLEFT,10,10},
	["DamageTimeout"]           = 5,
]] --

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
    FTC.Vars = ZO_SavedVars:NewAccountWide( 'FTC_VARS' , math.floor( FTC.settings * 100 ) , nil , FTC.Defaults )
    --FTC.Vars = FTC.Defaults

    -- Initialize UI Layer
    FTC.UI:Initialize()
    
    -- Setup Character Management
    FTC.Player:Initialize()
    FTC.Target:Initialize()

    -- Setup Damage Management
    FTC.Damage:Initialize()

    -- Unit Frames Component
    if ( FTC.Vars.EnableFrames )    then FTC.Frames:Initialize() end

    -- Combat Log Component
    if ( FTC.Vars.EnableLog )       then FTC.Log:Initialize() end

    -- Advanced Hotbar Component
    if ( FTC.Vars.EnableHotbar )    then FTC.Hotbar:Initialize() end
    
    -- Combat Statistics
    if ( FTC.Vars.EnableStats )     then FTC.Stats:Initialize() end
    
    -- Active Buffs Component
    if ( FTC.Vars.EnableBuffs )     then FTC.Buffs:Initialize() end

    -- Combat Text Component
    if ( FTC.Vars.EnableSCT )       then FTC.SCT:Initialize() end
    
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
