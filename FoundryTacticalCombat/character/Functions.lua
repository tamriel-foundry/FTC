 
 --[[----------------------------------------------------------
    CHARACTER FUNCTIONS
    -----------------------------------------------------------
    * Relevant functions for the player character components of FTC
    * Runs during FTC:Initialize()
  ]]--
 
FTC.Player = {}     
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

FTC.Target = {}
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

--[[----------------------------------------------------------
    HELPER FUNCTIONS
 ]]-----------------------------------------------------------
 
  --[[ 
 * Populates the character level
 * Called by Initialize()
 * Called by OnXPUpdate()
 * Called by OnVPUpdate()
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
 * Translates global classId into English class name
 * Called by Initialize()
 ]]-- 
function FTC.Player:GetClass(classId)
    if ( classId == 1 ) then return "Dragonknight"
    elseif ( classId == 2 ) then return "Sorcerer"
    elseif ( classId == 3 ) then return "Nightblade"
    elseif ( classId == 6 ) then return "Templar" end
end

--[[ 
 * Get the player's current and active hotbar loadout
 * Called by FTC.Player:Initialize()
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
 * Updates the stored target object
 ]]-- 
function FTC.Target:Update()
    FTC.Target.name     = GetUnitName('reticleover')
    FTC.Target.class    = FTC.Player:GetClass(GetUnitClassId('reticleover'))
    FTC.Target.level    = GetUnitLevel('reticleover')
    FTC.Target.vlevel   = GetUnitVeteranRank('reticleover') 
end