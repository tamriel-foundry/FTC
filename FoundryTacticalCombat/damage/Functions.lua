 
--[[----------------------------------------------------------
    DAMAGE MANAGEMENT COMPONENT
  ]]----------------------------------------------------------
    local FTC = FTC
    FTC.Damage  = {}

    --[[ 
     * Initialize Damage Management
     * --------------------------------
     * Called by FTC:Initialize()
     * --------------------------------
     ]]--

    function FTC.Damage:Initialize()

        -- Set up initial timestamps
        FTC.Damage.lastIn   = 0
        FTC.Damage.lastOut  = 0
    end

--[[----------------------------------------------------------
    EVENT HANDLERS
 ]]-----------------------------------------------------------
    
    --[[ 
     * Validate and Process New Damages
     * --------------------------------
     * Called by FTC:OnCombatEvent()
     * --------------------------------
     ]]--
    function FTC.Damage:New( result , abilityName , abilityGraphic , abilityActionSlotType , sourceName , sourceType , targetName , targetType , hitValue , powerType , damageType )

        -- Determine context
        local target = zo_strformat("<<!aC:1>>",targetName)
        local player = zo_strformat("<<!aC:1>>",FTC.Player.name)
        local damageOut = false
        if ( sourceType == COMBAT_UNIT_TYPE_PLAYER or sourceType == COMBAT_UNIT_TYPE_PLAYER_PET ) then damageOut = true
        elseif ( target == player ) then damageOut = false
        else return end

        -- Debugging
       --d( result .. " || " .. sourceType .. " || " .. sourceName .. " || " .. targetName .. " || " .. abilityName .. " || " .. hitValue  )

        -- Reflag self-targetted as incoming
        if ( damageOut and ( target == player ) ) then damageOut = false end

        -- Ignore certain results
        if ( FTC.Damage:Filter( result , abilityName ) ) then return end

        -- Compute some flags
        local isCrit    = result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_DOT_TICK_CRITICAL or result == ACTION_RESULT_HOT_TICK_CRITICAL
        local isHeal    = result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL

        -- Get the icon
        local icon = FTC.UI.Textures[abilityName] or '/esoui/art/icons/death_recap_ranged_basic.dds'
        if ( abilityName == "" and ( not damageOut ) and isHeal ) then icon = '/esoui/art/icons/ability_healer_017.dds'
        elseif ( abilityName == "" and not damageOut ) then icon = '/esoui/art/icons/death_recap_ranged_heavy.dds' end

        -- Setup the damage object
        local damage    = {
            ["out"]     = damageOut,
            ["result"]  = result,
            ["target"]  = targetName,
            ["source"]  = sourceName,
            ["ability"] = abilityName,
            ["type"]    = damageType,
            ["value"]   = hitValue,
            ["power"]   = powerType,
            ["ms"]      = GetGameTimeMilliseconds(),
            ["crit"]    = isCrit,
            ["heal"]    = isHeal,
            ["icon"]    = icon,
            ["mult"]    = 1, 
            ["weapon"]  = FTC.Damage:IsWeaponAttack(abilityName),
        }

        -- ACTION_RESULT_IMMUNE
        -- ACTION_RESULT_BLOCKED
        -- ACTION_RESULT_POWER_DRAIN
        -- ACTION_RESULT_POWER_ENERGIZE

        -- Damage Dealt
        if ( hitValue > 0 and ( result == ACTION_RESULT_DAMAGE or result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_BLOCKED_DAMAGE or result == ACTION_RESULT_DOT_TICK or result == ACTION_RESULT_DOT_TICK_CRITICAL ) ) then 
                
            -- Flag timestamps
            if ( damageOut ) then FTC.Damage.lastOut = GetGameTimeMilliseconds()
            else FTC.Damage.lastIn  = GetGameTimeMilliseconds() end

            -- Log and SCT
            if ( FTC.init.Log ) then FTC.Log:CombatEvent(damage) end
            if ( FTC.init.SCT ) then FTC.SCT:Damage(damage) end

            -- Statistics
            if ( FTC.init.Stats and damageOut ) then FTC.Stats:RegisterDamage(damage) end

            -- Trigger Ulti Buff
            if ( FTC.init.Hotbar ) then FTC.Hotbar:UltimateBuff(damage) end

        -- Falling damage
        elseif ( result == ACTION_RESULT_FALL_DAMAGE ) then
            damage.ability  = GetString(FTC_Falling)
            damage.icon     = '/esoui/art/icons/death_recap_fall_damage.dds'

            -- Log and SCT
            if ( FTC.init.Log ) then FTC.Log:CombatEvent(damage) end
            if ( FTC.init.SCT ) then FTC.SCT:Damage(damage) end

        -- Shielded Damage
        elseif ( result == ACTION_RESULT_DAMAGE_SHIELDED ) then

            -- Log and SCT
            if ( FTC.init.Log ) then FTC.Log:CombatEvent(damage) end
            if ( FTC.init.SCT ) then FTC.SCT:Damage(damage) end

            -- Statistics
            if ( FTC.init.Stats and damageOut ) then FTC.Stats:RegisterDamage(damage) end

        -- Misses and  Dodges
        elseif ( result == ACTION_RESULT_DODGED or result == ACTION_RESULT_MISS ) then

            -- Log and SCT
            if ( FTC.init.Log ) then FTC.Log:CombatEvent(damage) end
            if ( FTC.init.SCT ) then FTC.SCT:Damage(damage) end

        -- Crowd Controls
        elseif ( result == ACTION_RESULT_INTERRUPT or result == ACTION_RESULT_STUNNED or result == ACTION_RESULT_OFFBALANCE or result == ACTION_RESULT_DISORIENTED or result == ACTION_RESULT_STAGGERED or result == ACTION_RESULT_FEARED or result == ACTION_RESULT_SILENCED or result == ACTION_RESULT_ROOTED ) then

            -- Trigger Break Free buff
            if ( FTC.init.Buffs and damage.ability == GetAbilityName(16565) ) then
                local ability  = {
                    ["owner"]  = FTC.Player.name,
                    ["id"]     = 16565,
                    ["name"]   = GetString(FTC_BreakFree),
                    ["dur"]    = 8000,
                    ["icon"]   = FTC.UI.Textures[GetAbilityName(16565)],
                    ["ground"] = false,
                    ["area"]   = false,
                    ["debuff"] = false,
                    ["toggle"] = nil,
                }
                FTC.Buffs:NewEffect( ability , "Player" ) 
            end

            -- Fire SCT Alert
            if ( FTC.init.SCT ) then FTC.SCT:NewCC( result , abilityName , damageOut ) end

        -- Healing Dealt
        elseif ( hitValue > 0 and ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_HOT_TICK or result == ACTION_RESULT_HOT_TICK_CRITICAL ) ) then 

            -- Log and SCT
            if ( FTC.init.Log ) then FTC.Log:CombatEvent(damage) end
            if ( FTC.init.SCT ) then FTC.SCT:Damage(damage) end

            -- Statistics
            if ( FTC.init.Stats and sourceType == COMBAT_UNIT_TYPE_PLAYER ) then FTC.Stats:RegisterDamage(damage) end 

        -- Target Death
        elseif ( result == ACTION_RESULD_DIED or result == ACTION_RESULT_DIED_XP ) then

            -- Wipe Buffs
            if ( FTC.init.Buffs ) then FTC.Buffs:WipeBuffs(targetName) end

            -- Log and SCT
            if ( FTC.init.Log ) then FTC.Log:CombatEvent(damage) end

        -- DEBUG NEW EVENTS
        elseif ( hitValue > 0 ) then

            -- Prompt other unrecognized
            --local direction = damageIn and "Incoming" or "Outgoing"
            -- FTC.Log:Print( direction .. " result " .. result .. " not recognized! Target: " .. targetName .. " Value: " .. hitValue , {1,1,0} )
        end

        -- Fire a callback for extensions to use
       CALLBACK_MANAGER:FireCallbacks( "FTC_NewDamage" , damage )
    end


--[[----------------------------------------------------------
    HELPER FUNCTIONS
 ]]-----------------------------------------------------------
    
    --[[ 
     * Filter Out Unwanted Combat Events
     * --------------------------------
     * Called by FTC.Damage:New()
     * --------------------------------
     ]]--
    function FTC.Damage:Filter( result , abilityName )

        -- Keep a list of ignored actions
        local results = {
            ACTION_RESULT_QUEUED,
        }

        -- Check actions
        for i = 1 , #results do
            if ( result == results[i] ) then return true end
        end

        -- Keep a list of ignored abilities
        local abilities = {
            31221,          -- Skyshard Collect
            36010,          -- Mount Up
            41467,          -- Regeneration Dummy
            57466,          -- Rapid Regeneration Dummy
            57468,          -- Mutagen Dummy
        }
        for i = 1 , #abilities do
            if ( abilityName == GetAbilityName(abilities[i]) ) then return true end
        end
    end

    --[[ 
     * Track Whether a Damage Source is a Weapon ATtack
     * --------------------------------
     * Called by FTC.Damage:New()
     * --------------------------------
     ]]--
    function FTC.Damage:IsWeaponAttack( abilityName )

        local attacks = {
            4858,      -- Bash
            7880,      -- Light Attack
            7095,      -- Heavy Attack
            16420,     -- Heavy Attack (Dual Wield)
            16691,     -- Heavy Attack (Bow)
            32480,     -- Heavy Attack Werewolf
        }

        -- Compare each ability with the damage name
        for i = 1 , #attacks do
            local name = GetAbilityName(attacks[i])
            if ( abilityName == name ) then return true end 
        end

    end


