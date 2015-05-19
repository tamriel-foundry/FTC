 
--[[----------------------------------------------------------
    PLAYER DATA COMPONENT
  ]]----------------------------------------------------------
FTC.Player = {} 

--[[ 
 * Initialize Player Data Table
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--  
function FTC.Player:Initialize()

    -- Setup initial character information
    FTC.Player.name     = GetUnitName( 'player' )
    FTC.Player.race     = GetUnitRace( 'player' )
    FTC.Player.class    = FTC.Player:GetClass(GetUnitClassId( 'player' ))
    FTC.Player:GetLevel()
    
    -- Load starting attributes
    local stats = {
        { ["name"] = "health"   , ["id"] = POWERTYPE_HEALTH },
        { ["name"] = "magicka"  , ["id"] = POWERTYPE_MAGICKA },
        { ["name"] = "stamina"  , ["id"] = POWERTYPE_STAMINA },
        { ["name"] = "ultimate" , ["id"] = POWERTYPE_ULTIMATE }
    }
    for i = 1 , #stats , 1 do
        local current, maximum, effMax = GetUnitPower( "player" , stats[i].id )
        FTC.Player[stats[i].name] = { ["current"] = current , ["max"] = maximum , ["pct"] = zo_roundToNearest(current/maximum,0.01) }
    end

    -- Load starting shield
    local value, maxValue = GetUnitAttributeVisualizerEffectInfo('player',ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH)
    FTC.Player.shield = { ["current"] = value or 0 , ["max"] = maxValue or 0 , ["pct"] = zo_roundToNearest((value or 0)/(maxValue or 0),0.01) }

    -- Load action bar abilities
    FTC.Player.Abilities = {}
    FTC.Player:GetActionBar()

    -- Load quickslot ability
    FTC.Player:GetQuickslot()
end

--[[----------------------------------------------------------
    TARGET DATA COMPONENT
  ]]----------------------------------------------------------
FTC.Target = {}

--[[ 
 * Initialize Target Data Table
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--  
function FTC.Target:Initialize()

    -- Setup initial target information
    local target            = {
        ["name"]            = "-999",
        ["level"]           = 0,
        ["class"]           = "",
        ["vlevel"]          = 0,
        ["health"]          = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
        ["magicka"]         = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
        ["stamina"]         = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
        ["shield"]          = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
    }   
    
    -- Populate the target object
    for attr , value in pairs( target ) do FTC.Target[attr] = value end
    
    -- Get target data
    FTC.Target:Update()
end

--[[ 
 * Update the Target Object
 * --------------------------------
 * Called by FTC.Target:Initialize()
 * Called by FTC:OnTargetChanged()
 * --------------------------------
 ]]--  
function FTC.Target:Update()

    -- Hide default frame
    if ( FTC.init.Frames and not FTC.Vars.DefaultTargetFrame ) then ZO_TargetUnitFramereticleover:SetHidden(true) end
        
    -- Get the target name
    local name = GetUnitName('reticleover')

    -- Ignore empty and critters, but not during move mode
    local ignore = ( ( not DoesUnitExist('reticleover') ) or FTC:IsCritter('reticleover') ) and not FTC.move

    -- Update valid targets
    if ( not ignore ) then

        -- Update the target data object
        FTC.Target.name     = GetUnitName('reticleover')
        FTC.Target.class    = FTC.Player:GetClass(GetUnitClassId('reticleover'))
        FTC.Target.level    = GetUnitLevel('reticleover')
        FTC.Target.vlevel   = GetUnitVeteranRank('reticleover') 

        -- Update target frame
        if ( FTC.init.Frames ) then FTC.Frames:SetupTarget() end

        -- Update target buffs
        if ( FTC.init.Buffs ) then FTC.Buffs:GetBuffs( 'reticleover' ) end
    end

    -- Hide invalid targets
    if ( FTC.init.Frames ) then FTC_TargetFrame:SetHidden( ignore ) end
end

--[[----------------------------------------------------------
    GROUP DATA COMPONENT
  ]]----------------------------------------------------------
FTC.Group = {}
function FTC.Group:Initialize()
    for i = 1 , 24 do 
        FTC.Group[i] = {
            ["health"]          = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
            ["magicka"]         = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
            ["stamina"]         = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
            ["shield"]          = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
        }
    end
end

--[[----------------------------------------------------------
    HELPER FUNCTIONS
  ]]-----------------------------------------------------------

--[[ 
 * Filters Targets for "Critters"
 * --------------------------------
 * Called by FTC.Target:Update()
 * --------------------------------
 ]]-- 
function FTC:IsCritter( unitTag )
    -- Critters meet all the following criteria: Level 1, Difficulty = NONE, and Neutral or Friendly reaction
    return (( GetUnitLevel(unitTag) == 1 ) and ( GetUnitDifficulty(unitTag) == MONSTER_DIFFICULTY_NONE ) and ( GetUnitReaction(unitTag) == UNIT_REACTION_NEUTRAL or GetUnitReaction(unitTag) == UNIT_REACTION_FRIENDLY ) )
end

--[[ 
 * Re-populates Player Experience
 * --------------------------------
 * Called by FTC.Player:Initialize()
 * Called by FTC:OnXPUpdate()
 * Called by FTC:OnVPUpdate()
 * --------------------------------
 ]]--  
function FTC.Player:GetLevel()
    FTC.Player.level    = GetUnitLevel('player')
    FTC.Player.vlevel   = GetUnitVeteranRank('player')
    FTC.Player.alevel   = GetUnitAvARank('player')
    FTC.Player.clevel   = GetPlayerChampionPointsEarned()
    FTC.Player.exp      = GetUnitXP('player')
    FTC.Player.vet      = GetUnitVeteranPoints('player')
    FTC.Player.cxp      = GetPlayerChampionXP()
end

--[[ 
 * Translate Class-ID to English Name
 * --------------------------------
 * Called by FTC.Player:Initialize()
 * --------------------------------
 ]]-- 
function FTC.Player:GetClass(classId)
    if ( classId == 1 ) then return "Dragonknight"
    elseif ( classId == 2 ) then return "Sorcerer"
    elseif ( classId == 3 ) then return "Nightblade"
    elseif ( classId == 6 ) then return "Templar" end
end

--[[ 
 * Get Current Action Bar Loadout
 * --------------------------------
 * Called by FTC.Player:Initialize()
 * Called by FTC:OnSwapWeapons()
 * Called by FTC:OnSlotUpdate()
 * --------------------------------
 ]]-- 
function FTC.Player:GetActionBar()

    -- Get the current loadout
    for i = 3, 8 do

        -- Is the slot in use?
        local slot = {}
        if ( IsSlotUsed(i) ) then

            -- Get the slotted ability ID
            local ability_id    = GetSlotBoundId(i)

            -- Get additional ability information
            local name          = GetAbilityName(ability_id)
            local cost, cType   = GetSlotAbilityCost(i)
            local channeled, castTime, channelTime = GetAbilityCastInfo(ability_id)
            local target        = GetAbilityTargetDescription(ability_id)

            -- Populate the slot object
            slot = {
                ["owner"]       = FTC.Player.name,
                ["slot"]        = i,
                ["id"]          = ability_id,
                ["name"]        = name,
                ["type"]        = cType,
                ["cost"]        = cost,
                ["cast"]        = castTime,
                ["chan"]        = channeled and channelTime or 0,
                ["dur"]         = GetAbilityDuration(ability_id),
                ["tex"]         = GetSlotTexture(i),
                ["ground"]      = target == GetAbilityTargetDescription(23182),
                ["area"]        = ( target == GetAbilityTargetDescription(23182) ) or ( target == GetAbilityTargetDescription(22784) ),
                ["debuff"]      = ( ( target == GetAbilityTargetDescription(3493) ) or ( target == GetAbilityTargetDescription(20919) ) ),
                ["effects"]     = FTC.Buffs.Effects[name],
                ["pending"]     = ( FTC.Buffs.Effects[name] ~= nil ) and FTC.Buffs.Effects[name][4] or false
            }
        end

        -- Save the slot
        FTC.Player.Abilities[i] = slot
    end
end


--[[ 
 * Get Currently Active Quickslot
 * --------------------------------
 * Called by FTC:OnQuickslotChanged
 * --------------------------------
 ]]-- 
function FTC.Player:GetQuickslot(slotNum)

    -- Get the current slot
    local slotNum       = slotNum or GetCurrentQuickslot()

    -- Populate the quickslot object
    if ( IsSlotUsed(slotNum) ) then
        local abilityId     = GetSlotBoundId(slotNum)

        -- Get potion base duration
        local baseDur       = tonumber(zo_strformat("<<x:1>>",string.match(GetAbilityDescription(abilityId),'for (.*) seconds'))) or 0

        -- Get potion level
        local itemLevel     = ( GetItemLinkRequiredLevel(GetSlotItemLink(slotNum)) or 0 ) + ( GetItemLinkRequiredVeteranRank(GetSlotItemLink(slotNum)) or 0 )

        -- Get Medicinal Use multiplier
        local multiplier    = GetSkillAbilityUpgradeInfo(SKILL_TYPE_TRADESKILL, 1, 3)
        multiplier          = 1.0 + (0.1*multiplier)

        -- Approximate potion duration with a close (but incorrect) formula
        local duration      = ( baseDur + ( itemLevel * .325 ) ) * multiplier * 1000

        -- Setup object
        local ability = {
            ["owner"]       = FTC.Player.name,
            ["slot"]        = slotNum,
            ["id"]          = abilityId,
            ["name"]        = zo_strformat("<<t:1>>",GetSlotName(slotNum)),
            ["cast"]        = 0,
            ["chan"]        = 0,
            ["dur"]         = duration,
            ["tex"]         = GetSlotTexture(slotNum),
        }

        -- Save the slot
        FTC.Player.Quickslot = ability

    -- Otherwise empty the object
    else FTC.Player.Quickslot = {} end 
end


--[[ 
 * Get abilityID from abilityName
 * --------------------------------
 * UNUSED / DEBUGGING
 * --------------------------------
 ]]--
function FTC:GetAbilityId( abilityName )

    -- Loop over all ability IDs until we find it
    for i = 1, 70000 do
       if ( DoesAbilityExist(i) and ( GetAbilityName(i) == abilityName ) ) then
            d(i .. " -- " .. abilityName)
            return i
       end
    end
end
