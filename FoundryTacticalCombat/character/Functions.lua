 
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
    FTC.Player.nicename = string.gsub( GetUnitName( 'player' ) , "%-", "%%%-")
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
        FTC.Player[stats[i].name] = { ["current"] = current , ["max"] = maximum , ["pct"] = math.floor( ( current / maximum ) * 100 ) }
    end

    -- Load starting shield
    local value, maxValue = GetUnitAttributeVisualizerEffectInfo('player',ATTRIBUTE_VISUAL_POWER_SHIELDING,STAT_MITIGATION,ATTRIBUTE_HEALTH,POWERTYPE_HEALTH)
    FTC.Player.shield = { ["current"] = value or 0 , ["max"] = maxValue or 0 , ["pct"] = math.floor( ( value or 0 / FTC.Player.health.max ) * 100 ) }

    -- Load action bar abilities
    FTC.Player.Abilities = {}
    FTC.Player:GetActionBar()
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
        ["clevel"]          = 0,
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
                ["ground"]      = FTC.Buffs:IsGroundTarget( name ),
                ["effects"]     = FTC.Buffs.Effects[name]
            }
        end

        -- Save the slot
        FTC.Player.Abilities[i] = slot
    end
end


--[[ 
 * Get abilityID from abilityName
 * --------------------------------
 * UNUSED
 * --------------------------------

FTC.Abilities = {}
function FTC:GetAbilityId( abilityName )

    -- Do we already know it?
    if ( FTC.Abilities[abilityName] == nil ) then

        -- Loop over all ability IDs until we find it
        for i = 1, 70000 do
           if ( DoesAbilityExist(i) and ( GetAbilityName(i) == abilityName ) ) then
                FTC.Abilities[abilityName] = i
           end
        end
    end

    -- Return the ID
    return FTC.Abilities[abilityName]
end
]]-- 
