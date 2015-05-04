
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
FTC = {}
FTC.name                = "FoundryTacticalCombat"
FTC.tag                 = "FTC"
FTC.version             = 0.39
FTC.settings            = 0.39
FTC.language            = GetCVar("language.2")

-- Declare default components
FTC.Defaults            = {
    ["EnableFrames"]            = true,
    ["EnableBuffs"]             = false,
    ["EnableSCT"]               = false,
    ["EnableHotbar"]            = true,
    ["EnableDamage"]            = false,
}

--[[ Default Saved Variables
FTC.defaults            = {

    -- Scrolling Combat Text
    ["SCTCount"]                = 20,
    ["SCTSpeed"]                = 3,
    ["SCTNames"]                = true,
    ["SCTPath"]                 = 'Arc',
    ["FTC_CombatTextOut"]       = {TOP,TOP,-450,80},
    ["FTC_CombatTextIn"]        = {TOP,TOP,450,80},
    ["FTC_CombatTextStatus"]    = {TOP,TOP,0,80},
    
    -- Buffs
    ["AnchorBuffs"]             = true,
    ["NumBuffs"]                = 8,
    ["EnableLongBuffs"]         = true,
    ["FTC_LongBuffs"]           = {BOTTOMRIGHT,BOTTOMRIGHT,-5,-5},
    ["FTC_PlayerBuffs"]         = {CENTER,CENTER,0,400},
    ["FTC_PlayerDebuffs"]       = {CENTER,CENTER,0,500},
    ["FTC_TargetBuffs"]         = {CENTER,CENTER,0,-500},
    ["FTC_TargetDebuffs"]       = {CENTER,CENTER,0,-400},
    
    -- Damage
    ["FTC_MiniMeter"]           = {TOPLEFT,TOPLEFT,10,10},
    ["DamageTimeout"]           = 5,

]] --

-- Track component initialization
FTC.init                = {}

-- Track custom display conditions
FTC.inMenu              = false
FTC.move                = false

 -- Hook initialization to EVENT_ADD_ON_LOADED
EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ADD_ON_LOADED , FTC.Initialize )

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

    -- Pull defaults from sub-components
    FTC.JoinTables(FTC.Defaults,FTC.Frames.Defaults)
    
    -- Load saved variables
    FTC.Vars = ZO_SavedVars:NewAccountWide( 'FTC_VARS' , math.floor( FTC.settings * 100 ) , nil , FTC.Defaults )
    FTC.Vars = FTC.Defaults
    
    -- Setup Localization
    FTC.Localize()
    
    -- Setup Character Information
    FTC.Player:Initialize()
    FTC.Target:Initialize()

    -- Unit Frames Component
    if ( FTC.Vars.EnableFrames )    then FTC.Frames:Initialize() end

    -- Advanced Hotbar Component
    if ( FTC.Vars.EnableHotbar )    then FTC.Hotbar:Initialize() end
    
    -- Damage Tracking Component
    if ( FTC.Vars.EnableDamage )    then FTC.Damage:Initialize() end
    
    -- Active Buffs Component
    if ( FTC.Vars.EnableBuffs )     then FTC.Buffs:Initialize() end

    -- Scrolling Combat Text Component
    if ( FTC.Vars.EnableSCT )       then FTC.SCT:Initialize() end
    
    -- Setup settings component
    FTC.Menu:Initialize()
    
    -- Register event listeners
    FTC:RegisterEvents()
    
    -- Register slash command handlers
    SLASH_COMMANDS["/"..FTC.tag] = FTC.Slash
    SLASH_COMMANDS["/"..string.lower(FTC.tag)] = FTC.Slash
    
    -- Fire a callback after setup
    CALLBACK_MANAGER:FireCallbacks("FTC_Ready")
end

--[[----------------------------------------------------------
    UPDATING
  ]]----------------------------------------------------------

--[[ 
 * Updating Function
 * --------------------------------
 * Triggered every frame by :OnUpdate()
 * --------------------------------
 ]]-- 
function FTC:Update()

    -- Active Buffs Component
    if ( FTC.init.Buffs ) then
    
        -- Update buff timers
        if ( FTC:BufferScript( 'FTCBuffs' , 10 ) ) then
            FTC.Buffs:Update( 'Player' )
            FTC.Buffs:Update( 'Target' )
        end
        
        -- Check for ability casts
        if ( FTC:BufferScript( 'FTCCast' , 50 ) ) then
            FTC.Buffs:CheckCast()
        end
        
        -- Check for potion usage
        if ( FTC:BufferScript( 'FTCPotion' , 250 ) ) then
            FTC.Buffs:CheckPotion()
        end
    end
    
    -- Scrolling Combat Text Component
    if ( FTC.init.SCT ) then
        FTC.SCT:Update('In')
        FTC.SCT:Update('Out')
        FTC.SCT:UpdateAlerts()
    end
    
    -- Damage Tracking Component
    if ( FTC.init.Damage ) then
    
        -- Update the mini meter
        if ( FTC:BufferScript( 'FTCMeter' , 1000 ) ) then FTC.Damage:UpdateMini() end
    end
    
end

--[[----------------------------------------------------------
    INFO FUNCTIONS
  ]]-----------------------------------------------------------

--[[ 
 * Slash Function
 * --------------------------------
 * Triggered by /ftc or /FTC
 * --------------------------------
 ]]--  
function FTC.Slash( text )

    -- Display info to chat
    d( GetString(FTC_LongInfo) )

    -- Open the settings panel
    LAM2:OpenToPanel(FTC_Menu)
end

--[[----------------------------------------------------------
    DEBUGGING
  ]]-----------------------------------------------------------
function checkabilitytype( id )
    local types = {
        'ABILITY_TYPE_ACTIONLIST',
        'ABILITY_TYPE_AREAEFFECT',
        'ABILITY_TYPE_AREATELEPORT',
        'ABILITY_TYPE_ATTACKERINTERCEPT',
        'ABILITY_TYPE_ATTACKERREFLECT',
        'ABILITY_TYPE_AVOIDDEATH',
        'ABILITY_TYPE_BLADETURN',
        'ABILITY_TYPE_BLINK',
        'ABILITY_TYPE_BLOCK',
        'ABILITY_TYPE_BONUS',
        'ABILITY_TYPE_CHANGEAPPEARANCE',
        'ABILITY_TYPE_CHARGE',
        'ABILITY_TYPE_CHARM',
        'ABILITY_TYPE_CLAIRVOYANCE',
        'ABILITY_TYPE_CLIENTFX',
        'ABILITY_TYPE_COMBATRESOURCE',
        'ABILITY_TYPE_CREATEINTERACTABLE',
        'ABILITY_TYPE_CREATEINVENTORYITEM',
        'ABILITY_TYPE_DAMAGE',
        'ABILITY_TYPE_DAMAGELIMIT',
        'ABILITY_TYPE_DAMAGESHIELD',
        'ABILITY_TYPE_DEFEND',
        'ABILITY_TYPE_DESPAWNOVERRIDE',
        'ABILITY_TYPE_DISARM',
        'ABILITY_TYPE_DISORIENT',
        'ABILITY_TYPE_DISPEL',
        'ABILITY_TYPE_DODGE',
        'ABILITY_TYPE_DOUBLEFIRE',
        'ABILITY_TYPE_EXHAUSTED',
        'ABILITY_TYPE_FEAR',
        'ABILITY_TYPE_FILLSOULGEM',
        'ABILITY_TYPE_FIREPROC',
        'ABILITY_TYPE_FLIGHT',
        'ABILITY_TYPE_FREECAST',
        'ABILITY_TYPE_FREEINTERACT',
        'ABILITY_TYPE_GRANTABILITY',
        'ABILITY_TYPE_HEAL',
        'ABILITY_TYPE_HIDE',
        'ABILITY_TYPE_IMMUNITY',
        'ABILITY_TYPE_INTERCEPT',
        'ABILITY_TYPE_INTERRUPT',
        'ABILITY_TYPE_JUMP',
        'ABILITY_TYPE_KNOCKBACK',
        'ABILITY_TYPE_LEAP',
        'ABILITY_TYPE_LEVITATE',
        'ABILITY_TYPE_MISDIRECT',
        'ABILITY_TYPE_MODIFYCOOLDOWN',
        'ABILITY_TYPE_MODIFYDURATION',
        'ABILITY_TYPE_MOUNT',
        'ABILITY_TYPE_MOVEPOSITION',
        'ABILITY_TYPE_NOAGGRO',
        'ABILITY_TYPE_NOKILL',
        'ABILITY_TYPE_NOLOCKPICK',
        'ABILITY_TYPE_NONEXISTENT',
        'ABILITY_TYPE_NONE',
        'ABILITY_TYPE_OFFBALANCE',
        'ABILITY_TYPE_PACIFY',
        'ABILITY_TYPE_PARRY',
        'ABILITY_TYPE_PATHLINE',
        'ABILITY_TYPE_RECALL',
        'ABILITY_TYPE_REFLECTION',
        'ABILITY_TYPE_REGISTERTRIGGER',
        'ABILITY_TYPE_REMOVETYPE',
        'ABILITY_TYPE_RESURRECT',
        'ABILITY_TYPE_REVEAL',
        'ABILITY_TYPE_SEESTEALTH',
        'ABILITY_TYPE_SETCOOLDOWN',
        'ABILITY_TYPE_SETHOTBAR',
        'ABILITY_TYPE_SETTARGET',
        'ABILITY_TYPE_SHOWNON',
        'ABILITY_TYPE_SIEGEAREAEFFECT',
        'ABILITY_TYPE_SIEGECREATE',
        'ABILITY_TYPE_SIEGEPACKUP',
        'ABILITY_TYPE_SILENCE',
        'ABILITY_TYPE_SLOWFALL',
        'ABILITY_TYPE_SNARE',
        'ABILITY_TYPE_SOULGEMRESURRECT',
        'ABILITY_TYPE_SPELLSTEAL',
        'ABILITY_TYPE_STAGGER',
        'ABILITY_TYPE_STEALTH',
        'ABILITY_TYPE_STUN',
        'ABILITY_TYPE_SUMMON',
        'ABILITY_TYPE_THREAT',
        'ABILITY_TYPE_TRAUMA',
        'ABILITY_TYPE_UPDATEDEATHDIALOG',
        'ABILITY_TYPE_VAMPIRE',
        'ABILITY_TYPE_WIND'
    }
    
    -- If no type was passed, display everything
    if ( id == nil ) then
        for k,v in pairs(types) do
            d(v .. ' - ' .. _G[v])
        end
    
    
    -- If a type was passed, return the string
    else
        for k,v in pairs(types) do
            if ( id == _G[v] ) then 
                return v
            end
        end
    end
end

function checkactiontype( id )
    local results = {
        'ACTION_RESULT_ABILITY_ON_COOLDOWN',
        'ACTION_RESULT_ABSORBED',
        'ACTION_RESULT_BAD_TARGET',
        'ACTION_RESULT_BATTLE_STANDARDS_DISABLED',
        'ACTION_RESULT_BATTLE_STANDARD_ALREADY_EXISTS_FOR_GUILD',
        'ACTION_RESULT_BATTLE_STANDARD_LIMIT',
        'ACTION_RESULT_BATTLE_STANDARD_NO_PERMISSION',
        'ACTION_RESULT_BATTLE_STANDARD_TABARD_MISMATCH',
        'ACTION_RESULT_BATTLE_STANDARD_TOO_CLOSE_TO_CAPTURABLE',
        'ACTION_RESULT_BLADETURN',
        'ACTION_RESULT_BLOCKED',
        'ACTION_RESULT_BLOCKED_DAMAGE',
        'ACTION_RESULT_BUSY',
        'ACTION_RESULT_CANNOT_USE',
        'ACTION_RESULT_CANT_SEE_TARGET',
        'ACTION_RESULT_CANT_SWAP_WHILE_CHANGING_GEAR',
        'ACTION_RESULT_CASTER_DEAD',
        'ACTION_RESULT_CRITICAL_DAMAGE',
        'ACTION_RESULT_CRITICAL_HEAL',
        'ACTION_RESULT_DAMAGE',
        'ACTION_RESULT_DAMAGE_SHIELDED',
        'ACTION_RESULT_DEFENDED',
        'ACTION_RESULT_DIED',
        'ACTION_RESULT_DIED_XP',
        'ACTION_RESULT_DISARMED',
        'ACTION_RESULT_DISORIENTED',
        'ACTION_RESULT_DODGED',
        'ACTION_RESULT_DOT_TICK',
        'ACTION_RESULT_DOT_TICK_CRITICAL',
        'ACTION_RESULT_FAILED',
        'ACTION_RESULT_FAILED_REQUIREMENTS',
        'ACTION_RESULT_FAILED_SIEGE_CREATION_REQUIREMENTS',
        'ACTION_RESULT_FALLING',
        'ACTION_RESULT_FALL_DAMAGE',
        'ACTION_RESULT_FEARED',
        'ACTION_RESULT_FORWARD_CAMP_ALREADY_EXISTS_FOR_GUILD',
        'ACTION_RESULT_FORWARD_CAMP_NO_PERMISSION',
        'ACTION_RESULT_FORWARD_CAMP_TABARD_MISMATCH',
        'ACTION_RESULT_GRAVEYARD_DISALLOWED_IN_INSTANCE',
        'ACTION_RESULT_GRAVEYARD_TOO_CLOSE',
        'ACTION_RESULT_HEAL',
        'ACTION_RESULT_HOT_TICK',
        'ACTION_RESULT_HOT_TICK_CRITICAL',
        'ACTION_RESULT_IMMUNE',
        'ACTION_RESULT_INSUFFICIENT_RESOURCE',
        'ACTION_RESULT_INTERCEPTED',
        'ACTION_RESULT_INTERRUPT',
        'ACTION_RESULT_INVALID',
        'ACTION_RESULT_INVALID_FIXTURE',
        'ACTION_RESULT_INVALID_JUSTICE_TARGET',
        'ACTION_RESULT_INVALID_TERRAIN',
        'ACTION_RESULT_IN_AIR',
        'ACTION_RESULT_IN_COMBAT',
        'ACTION_RESULT_IN_ENEMY_KEEP',
        'ACTION_RESULT_KILLED_BY_SUBZONE',
        'ACTION_RESULT_KILLING_BLOW',
        'ACTION_RESULT_KNOCKBACK',
        'ACTION_RESULT_LEVITATED',
        'ACTION_RESULT_MERCENARY_LIMIT',
        'ACTION_RESULT_MISS',
        'ACTION_RESULT_MISSING_EMPTY_SOUL_GEM',
        'ACTION_RESULT_MISSING_FILLED_SOUL_GEM',
        'ACTION_RESULT_MOBILE_GRAVEYARD_LIMIT',
        'ACTION_RESULT_MOUNTED',
        'ACTION_RESULT_MUST_BE_IN_OWN_KEEP',
        'ACTION_RESULT_NOT_ENOUGH_INVENTORY_SPACE',
        'ACTION_RESULT_NOT_ENOUGH_SPACE_FOR_SIEGE',
        'ACTION_RESULT_NO_LOCATION_FOUND',
        'ACTION_RESULT_NO_RAM_ATTACKABLE_TARGET_WITHIN_RANGE',
        'ACTION_RESULT_NO_WEAPONS_TO_SWAP_TO',
        'ACTION_RESULT_NPC_TOO_CLOSE',
        'ACTION_RESULT_OFFBALANCE',
        'ACTION_RESULT_PACIFIED',
        'ACTION_RESULT_PARRIED',
        'ACTION_RESULT_PARTIAL_RESIST',
        'ACTION_RESULT_POWER_DRAIN',
        'ACTION_RESULT_POWER_ENERGIZE',
        'ACTION_RESULT_PRECISE_DAMAGE',
        'ACTION_RESULT_QUEUED',
        'ACTION_RESULT_RAM_ATTACKABLE_TARGETS_ALL_DESTROYED',
        'ACTION_RESULT_RAM_ATTACKABLE_TARGETS_ALL_OCCUPIED',
        'ACTION_RESULT_RECALLING',
        'ACTION_RESULT_REFLECTED',
        'ACTION_RESULT_REINCARNATING',
        'ACTION_RESULT_RESIST',
        'ACTION_RESULT_RESURRECT',
        'ACTION_RESULT_ROOTED',
        'ACTION_RESULT_SIEGE_LIMIT',
        'ACTION_RESULT_SIEGE_NOT_ALLOWED_IN_ZONE',
        'ACTION_RESULT_SIEGE_TOO_CLOSE',
        'ACTION_RESULT_SILENCED',
        'ACTION_RESULT_SPRINTING',
        'ACTION_RESULT_STAGGERED',
        'ACTION_RESULT_STUNNED',
        'ACTION_RESULT_SWIMMING',
        'ACTION_RESULT_TARGET_DEAD',
        'ACTION_RESULT_TARGET_NOT_IN_VIEW',
        'ACTION_RESULT_TARGET_NOT_PVP_FLAGGED',
        'ACTION_RESULT_TARGET_OUT_OF_RANGE',
        'ACTION_RESULT_TARGET_TOO_CLOSE',
        'ACTION_RESULT_UNEVEN_TERRAIN',
        'ACTION_RESULT_WEAPONSWAP',
        'ACTION_RESULT_WRECKING_DAMAGE',
        'ACTION_RESULT_WRONG_WEAPON',
    }
    
    -- If no type was passed, display everything
    if ( id == nil ) then
        for k,v in pairs(results) do
            d(v .. ' - ' .. _G[v])
        end
    
    
    -- If a type was passed, return the string
    else
        for k,v in pairs(results) do
            if ( id == _G[v] ) then 
                return v
            end
        end
    end
end
