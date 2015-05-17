 --[[----------------------------------------------------------
    ACTIVE BUFF EFFECTS
    * Get a custom buff/debuff effect when the player casts a spell
    * Effects are listed as [name] = { buff duration , debuff duration , cast time }
    * Only "exception" effects are stored here, as default cast times and durations are retrieved from the API
    ]]-----------------------------------------------------------
    
FTC.Buffs.Effects = {}
function FTC.Buffs:RegisterEffects()
    
    local effects = {

        --[[---------------------------------
            WEAPON SKILLS
        -----------------------------------]]
        
        -- Sword and Shield
        [3493]  = { 0, 15, 0 },         -- Puncture
        [38256] = { 0, 15, 0 },         -- Ransack
        [38250] = { 0, 15, 0 },         -- Pierce Armor
        [28304] = { 0, 9, 0 },          -- Low Slash
        [38268] = { 0, 12, 0 },         -- Deep Slash
        [38264] = { 0, 12, 0 },         -- Heroic Slash 
        [28719] = { 0, 2, 0.25 },       -- Shield Charge
        [38405] = { 0, 3, 0.25 },       -- Invasion
        [38401] = { 6, 2, 0.25 },       -- Shielded Assault
        [28365] = { 0, 15, 0 },         -- Power Bash
        [38452] = { 0, 15, 0 },         -- Power Slam
        [38455] = { 0, 10, 0 },         -- Reverberating Bash
                
        -- Dual Wield
        [28379] = { 0, 9, 0 },          -- Twin Slashes
        [10735] = { 9, 9, 0 },          -- Blood Craze
        [38839] = { 0, 9, 0 },          -- Rending Slashes
        [38857] = { 6, 0, 1.3 },        -- Rapid Strikes
        [38891] = { 10, 0, 0 },         -- Whirling Blades
        [21157] = { 0, 6, 0 },          -- Hidden Blade
        [38910] = { 0, 6, 0 },          -- Flying Blade
        [38914] = { 0, 6, 0 },          -- Shrouded Daggers

        -- Two Handed
        [20919] = { 0, 10, 0 },         -- Cleave
        [5798]  = { 8, 10, 0 },         -- Brawler
        [38745] = { 0, 10, 0 },         -- Carve
        [21055] = { 0, 8, 0.25 },       -- Stampede
        [24648] = { 0, 3.5, 0.8 },      -- Uppercut
        [38807] = { 0, 3.5, 0.8 },      -- Wrecking Blow
        [38814] = { 0, 7.5, 0.8 },      -- Dizzying Swing
        
        -- Bow
        [28869] = { 0, 10, 0 },         -- Poison Arrow
        [38645] = { 0, 10, 0 },         -- Venom Arrow
        [38660] = { 0, 10, 0 },         -- Poison Injection
        [28628] = { 0, 5, 1.5 },        -- Volley
        [20778] = { 0, 11, 1.5 },       -- Scorched Earth
        [38695] = { 0, 5, 1.5 },        -- Arrow Barrage
        [28879] = { 0, 5, 0 },          -- Scatter Shot
        [38672] = { 0, 5, 0 },          -- Magnum Shot
        [38669] = { 0, 6, 0 },          -- Draining Shot
        [31271] = { 0, 5, 0 },          -- Arrow Spray
        [38705] = { 0, 5, 0 },          -- Bombard
        [38701] = { 0, 5, 0 },          -- Acid Spray
        [38685] = { 0, 10, 1.25 },      -- Lethal Arrow
        [38687] = { 0, 10, 1.25 },      -- Focused Aim
        [37243] = { 8, 0, 0 },          -- Blessing of Protection
        [40103] = { 15 , 0 , 0 },       -- Blessing Of Restoration
        [40094] = { 8, 0, 0 },          -- Combat Prayer
        [31531] = { 0, 20, 1.5 },       -- Force Siphon
        [40109] = { 0, 20, 1.5 },       -- Siphon Spirit
        [40116] = { 0, 20, 0 },         -- Quick Siphon
        
        -- Destruction Staff
        [29173] = { 0, 18, 0 },         -- Weakness to Elements
        [39089] = { 0, 18, 0 },         -- Elemental Susceptibility
        [39095] = { 0, 18, 0 },         -- Elemental Drain
        [29091] = { 0, 5, 0 },          -- Destructive Touch
        [29089] = { 0, 5, 0 },          -- Shock Touch
        [29078] = { 0, 5, 0 },          -- Frost Touch
        [62648] = { 0, 5, 0 },          -- Fire Touch
        [46340] = { 0, 5, 0 },          -- Force Shock
        [46348] = { 0, 5, 0 },          -- Crushing Shock
        [46356] = { 0, 5, 0 },          -- Force Pulse
        [39161] = { 0, 10, 0 },         -- Pulsar
        [39162] = { 0 , 10 , 0 },       -- Flame Pulsar
        [39167] = { 0 , 10 , 0 },       -- Storm Pulsar
        [53301] = { 0 , 10 , 0 },       -- Icy Pulsar
        [42988] = { 0 , 10 , 0 },       -- Electric Pulsar
        [39143] = { 0 , 10 , 0 },       -- Elemental Ring
        [39145] = { 0 , 10 , 0 },       -- Fire Ring
        [39146] = { 0 , 10 , 0 },       -- Frost Ring
        [39147] = { 0 , 10 , 0 },       -- Shock Ring

        --[[---------------------------------
            SORCERER
        -----------------------------------]]
        
        -- Daedric Summoning
        [5420]  = { 0, 6, 0 },          -- Daedric Curse
        [24330] = { 0, 3.5, 0 },        -- Velocious Curse
        [56798] = { 0, 6, 0 },          -- Explosive Curse
        
        -- Storm Calling
        [18718] = { 0, 4, 0 },          -- Mages' Fury
        [19123] = { 0, 4, 0 },          -- Mages' Wrath
        [19109] = { 0, 4, 0 },          -- Endless Fury
        [23182] = { 0, 6, 0 },          -- Lightning Splash
        [23200] = { 0, 10, 0 },         -- Liquid Lightning
        [23205] = { 0, 6, 0 },          -- Lightning Flood
        [23234] = { 0, 2, 0 },          -- Bolt Escape
        [23236] = { 0, 2, 0 },          -- Streak
        [23277] = { 5, 2, 0 },          -- Ball of Lightning

        -- Dark Magic
        [43714] = { 0, 2.4, 1 },        -- Crystal Shard
        [46324] = { 0, 2.4, 1 },        -- Crystal Fragments
        [46331] = { 0, 2.4, 1 },        -- Crystal Blast
        [4737]  = { 0, 5.4, 0 },        -- Encase
        [28311] = { 0, 10.2, 0 },       -- Restraining Prison
        [28308] = { 0, 5.4, 0 },        -- Shattering Prison
        [24371] = { 0, 19.9, 0 },       -- Rune Prison
        [24578] = { 0 , 21.7 , 0 },     -- Rune Cage
        [24574] = { 144000, 19.9, 0 },  -- Defensive Rune
        [24828] = { 0, 36, 0, },        -- Daedric Mines
        [24834] = { 0, 36, 0 },         -- Daedric Minefield
        [24842] = { 0, 36, 0 },         -- Daedric Tomb
        [24584] = { 4, 0, 0 },          -- Dark Exchange
        [24589] = { 4, 0, 0 },          -- Dark Conversion
        [24595] = { 4, 0, 0 },          -- Dark Deal
        [27706] = { 0, 11.4, 0 },       -- Negate Magic
        [28341] = { 11.4, 11.4, 0 },    -- Suppression Field
        [28348] = { 12, 9.6, 0 },       -- Absorption Field
        
        --[[---------------------------------
            DRAGONKNIGHT
        -----------------------------------]]
        
        -- Ardent Flame 
        [20657] = { 0, 10.5, 0 },       -- Searing Strike
        [20668] = { 0, 10.5, 0 },       -- Unstable Flame
        [20660] = { 0, 10.5, 0 },       -- Burning Embers
        [4771]  = { 0, 10, 0 },         -- Fiery Breath
        [20944] = { 0, 10, 0 },         -- Burning Breath
        [20930] = { 0, 10, 0 },         -- Engulfing Flames
        
        -- Earthen Heart
        [29032] = { 0, 3.6, 0.25 },     -- Stonefist
        [31816] = { 15, 3.6, 0.25 },    -- Stone Giant
        [31820] = { 0, 3.6, 0.25 },     -- Obsidian Shard
        [29037] = { 0, 20, 0 },         -- Petrify
        [32685] = { 0, 20, 0 },         -- Fossilize
        [32678] = { 0, 20, 0 },         -- Shattering Rocks

        -- Draconic Power
        [20245] = { 0, 4, 0 },          -- Dark Talons
        [20252] = { 0, 4, 0 },          -- Burning Talons
        [20251] = { 0, 4, 0 },          -- Choking Talons
        [31837] = { 0, 2.5, 0 },        -- Inhale
        [18021] = { 0, 2.5, 0 },        -- Deep Breath
        [32785] = { 0, 2.5, 0 },        -- Draw Essence
        [32715] = { 6, 0, 0 },          -- Ferocious Leap
        
        --[[---------------------------------
            NIGHTBLADE
        -----------------------------------]]
        
        -- Assassination
        [34843] = { 2, 0, 0 },          -- Killer's Blade
        [18342] = { 0, 1.5, 0.25 },     -- Teleport Strike
        [7271]  = { 0, 1.5, 0.25 },      -- Ambush
        [25493] = { 0, 6, 0.25 },       -- Lotus Fan
        [33357] = { 0, 20, 0 },         -- Mark Target
        [36968] = { 0, 20, 0 },         -- Piercing Mark
        [36967] = { 0, 20, 0 },         -- Reaper's Mark    
        [33398] = { 0, 6, 0 },          -- Death Stroke
        [36508] = { 0, 6, 0 },          -- Incapacitating Strike
        [36514] = { 0, 6, 0 },          -- Soul Harvest
                                                                        
        -- Shadow   
        [25255] = { 0, 4.6, 0 },        -- Veiled Strike
        [25260] = { 0, 12, 0 },         -- Surprise Attack
        [25267] = { 0, 4.6, 0 },        -- Concealed Weapon 
        [33195] = { 11.5, 11.5, 0 },    -- Path of Darkness
        [36049] = { 11.5, 11.5, 0 },    -- Twisting Path
        [36028] = { 11.5, 11.5, 0 },    -- Refreshing Path
        [14350] = { 0, 4.5, 0 },        -- Aspect of Terror
        [37470] = { 0, 4.5, 0 },        -- Mass Hysteria
        [37475] = { 0, 4.5, 0 },        -- Manifestation of Terror
        
        -- Siphoning
        [33291] = { 10, 10, 0 },        -- Strife
        [34835] = { 10, 10, 0 },        -- Swallow Soul
        [34838] = { 10, 10, 0 },        -- Funnel Health
        [33308] = { 0, 30, 1.2 },       -- Agony
        [34721] = { 0, 30, 1.2 },       -- Prolonged Suffering
        [34727] = { 0, 30, 1.2 },       -- Malefic Wreath   
        [33326] = { 8, 8, 0 },          -- Cripple
        [36943] = { 8, 8, 0 },          -- Debilitate
        [36957] = { 8, 8, 0 },          -- Crippling Grasp
        [25091] = { 0, 3.5, 0 },        -- Soul Shred
        [35460] = { 8, 4.5, 0 },        -- Soul Tether
        [35508] = { 3.5, 3.5, 0 },      -- Soul Siphon

        --[[---------------------------------
            TEMPLAR
        -----------------------------------]]
        
        -- Aedric Spear
        [26804] = { 0, 3, 0.25 },       -- Binding Javelin
        [13538] = { 0, 3, 0.5 },        -- Focused Charge
        [22161] = { 0, 3, 0.5 },        -- Explosive Charge
        [15540] = { 0, 2.4, 0.5 },      -- Toppling Charge
        [22138] = { 0, 6, 0 },          -- Radial Sweep
        [22144] = { 0, 8, 0 },          -- Empowering Sweep
        [22139] = { 0, 6, 0 },          -- Crescent Sweep
        
        -- Dawn's Wrath
        [21726] = { 0, 6, 0.5 },        -- Sun Fire
        [21732] = { 0, 6, 0.5 },        -- Reflective Light
        [21729] = { 0, 8.4, 0.5 },      -- Vampire's Bane
        [22110] = { 0, 7.2, 1.25 },     -- Dark Flare
        [21776] = { 0, 6, 0 },          -- Eclipse
        [22006] = { 0, 6, 0 },          -- Total Dark
        [22004] = { 0, 6, 0 },          -- Unstable Core
        [21761] = { 0, 6, 0 },          -- Backlash
        [21763] = { 0, 6, 0 },          -- Power of the Light
        [21765] = { 7.2, 6, 0 },        -- Purifying Light
        [63029] = { 0, 3.6, 0 },        -- Radiant Destruction
        [63044] = { 0, 3.6, 0 },        -- Radiant Glory
        [63046] = { 0, 3.6, 0 },        -- Radiant Oppression
        [1293]  = { 9.6, 0, 0 },        -- Nova
        [21755] = { 9.6, 0, 0 },        -- Solar Prison
        [21758] = { 9.6, 0, 0 },        -- Solar Disturbance
        
        -- Restoring Light
        [22253] = { 8, 0, 0 },          -- Honor The Dead
        [22314] = { 8, 0, 0 },          -- Lingering Ritual
            
        --[[---------------------------------
            ARMOR
        -----------------------------------]]
        
        -- Medium Armor
        [18354] = { 20, 0, 0 },         -- Evasion
        [39192] = { 23, 0, 0 },         -- Elude
        [39195] = { 20, 0, 0 },         -- Shuffle

        --[[---------------------------------
            GUILDS
        -----------------------------------]]
        
        [35721] = { 0, 3.5, 0 },        -- Silver Bolts
        [40300] = { 0, 3.5, 0 },        -- Silver Shards
        [40336] = { 0, 3.5, 0 },        -- Silver Leash
        [35713] = { 0, 4, 0.5 },          -- Dawnbreaker
        [40161] = { 0, 6, 0.5 },          -- Flawless Dawnbreaker
        [40158] = { 0, 4, 0.5 },          -- Dawnbreaker of Smiting
        
        -- Mages Guild
        [8108]  = { 0, 15.6, 0 },       -- Entropy
        [40457] = { 0, 15.6, 0 },       -- Degeneration
        [40452] = { 14.4, 14.4, 0 },    -- Structured Entropy
        [40465] = { 0, 11.6, 0 },       -- Scalding Rune
        [16536] = { 0, 11.8, 0 },       -- Meteor
        [40489] = { 0, 11.8, 0 },       -- Ice Comet
        [40493] = { 0, 11.8, 0 },       -- Shooting Star

        -- Undaunted
        [39475] = { 0, 15, 0 },         -- Inner Fire
        [42056] = { 0, 15, 0 },         -- Inner Rage
        [42060] = { 0, 15, 0 },         -- Inner Beast
        [39425] = { 0, 8, 0 },          -- Trapping Webs
        [41990] = { 0, 8, 0 },          -- Shadow Silk
        [42012] = { 0, 8, 0 },          -- Tangling Webs
            
        --[[---------------------------------
            WORLD
        -----------------------------------]]
        
        -- Vampire
        [2632]  = { 3, 3, 0 },          -- Drain Essence
        [38949] = { 3, 3, 0 },          -- Invigorating Drain
        [38956] = { 20 , 3 , 0 },       -- Accelerating Drain
        [32986] = { 3.5, 0, 0 },        -- Mist Form
        [38963] = { 4, 0, 0 },          -- Elusive Mist
        [38965] = { 4, 4, 0 },          -- Poison Mist
        [32624] = { 0, 5, 0 },          -- Bat Swarm
        [38931] = { 0, 5, 0 },          -- Devouring Swarm
        [38932] = { 0, 5, 0 },          -- Clouding Swarm

        -- Werewolf
        [25402] = { 0, 4.3, 1 },        -- Roar
        [39113] = { 0, 4.3, 1 },        -- Ferocious Roar
        [39114] = { 0, 4.3, 1 },        -- Rousing Roar
        [58405] = { 0, 3, 0 },          -- Piercing Howl
        [58742] = { 0, 3, 0 },          -- Howl of Despair
        [58798] = { 0, 3, 0 },          -- Howl of Agony
        [58850] = { 0, 10, 0 },         -- Infectious Claws
        [58864] = { 0, 10, 0 },         -- Claws of Anguish
        [58879] = { 0, 10, 0 },         -- Claws of Life
        [58317] = { 17, 0, 0 },         -- Hircine's Rage
        [58325] = { 8, 0, 0 },          -- Hircine's Fortitude
        
        -- Soul Magic
        [3673]  = { 0, 10, 0 },         -- Soul Trap
        [40317] = { 0, 10, 0 },         -- Consuming Trap
        [40328] = { 0, 10, 0 },         -- Soul Splitting Trap
        [39270] = { 0, 2.8, 0 },        -- Soul Strike
        [40414] = { 0, 2.8, 0 },        -- Shatter Soul
        [40420] = { 0, 3.9, 0 },        -- Soul Assault

        
        --[[---------------------------------
            AVA
        -----------------------------------]]
        
        -- Support
        [38571] = { 6, 0, 0 },          -- Purge
        [40232] = { 6, 0, 0 },          -- Efficient Purge
        [34826] = { 6, 0, 0 },          -- Cleanse
        [18390] = { 0, 30, 1 },         -- Caltrops
        [40255] = { 0, 30, 1 },         -- Anti-Cavalry Caltrops
        [40242] = { 0, 30, 1 },         -- Razor Caltrops
        [61503] = { 20, 0, 0 },         -- Vigor
        [61505] = { 20, 0, 0 },         -- Echoing Vigor
        [61507] = { 20, 0, 0 },         -- Resolving Vigor
        [61487] = { 0, 4, 0 },          -- Magicka Detonation
        [61491] = { 0, 4, 0 },          -- Inevitable Detonation
        [61500] = { 0, 4, 0 },          -- Proximity Detonation
    }

    -- Apply the effects to the global table
    for k,v in pairs(effects) do

        -- If it's already an abilityId
        if ( tonumber(k) ~= nil ) then
            local name = GetAbilityName(k)
            FTC.Buffs.Effects[name] = v

        -- Otherwise just use the name directly
        else FTC.Buffs.Effects[k] = v end
    end
end

--[[ 
 * Checks whether an ability is a ground-targetted spell
 ]]--
function FTC.Buffs:IsGroundTarget()

    -- Manually maintain a list of ground targets
    local gts = { 

        -- Sorcerer
        27706,     -- Negate Magic
        28348,     -- Absorption Field
        28341,     -- Suppression Field
        23634,     -- Summon Storm Atronach
        23495,     -- Summon Charged Atronach
        23492,     -- Greater Storm Atronach
        23182,     -- Lightning Splash
        23200,     -- Liquid Lightning
        23205,     -- Lightning Flood

        -- Templar
        1293,      -- Nova
        21755,     -- Solar Prison
        21758,     -- Solar Disturbance
        26188,     -- Spear Shards
        26858,     -- Luminous Shards
        26869,     -- Blazing Spear

        -- Weapon
        28628,     -- Volley
        20778,     -- Scorched Earth
        38695,     -- Arrow Barrage
        28385,     -- Grand Healing
        40060,     -- Healing Springs
        40058,     -- Illustrious Healing

        -- Guild
        31632,     -- Fire Rune
        40470,     -- Volcanic Rune
        40465,     -- Scalding Rune

        -- AvA
        18390,     -- Caltrops
        40242,     -- Razor Caltrops
        40255,     -- Anti-Cavalry Caltrops
    }
    for i = 1 , #gts do
        FTC:GetAbilityId( gts[i] )
    end 
end

--[[ 
 * Checks whether an ability is a toggle
 ]]--
function FTC.Buffs:IsToggle( name )
    local Toggles = { 
        23304,          -- Unstable Familiar
        23319,          -- Unstable Clannfear
        23316,          -- Volatile Familiar
        24613,          -- Summon Winged Twilight
        24636,          -- Summon Restoring Twilight
        24639,          -- Summon Twilight Matriarch
        24158,          -- Bound Armor
        24165,          -- Bound Armaments
        24163,          -- Bound Aegis
        33319,          -- Siphoning Strikes
        36908,          -- Leeching Strikes
        36935,          -- Siphoning Attacks
        30920,          -- Magelight
        40478,          -- Inner Light
        40483,          -- Radiant Magelight
        25954,          -- Inferno
        23853,          -- Flames of Oblivion
        32881,          -- Sea of Flames
        3403,           -- Guard
        61536,          -- Mystic Guard
        61529,          -- Stalwart Guard
        14890,          -- Brace (Generic)
    }
    for i = 1 , #Toggles do
        if ( name == GetAbilityName(Toggles[i]) ) then return true end
    end 
    return false
end

--[[ 
 * Checks whether an ability incorporates a damage shield that should be purged when it expires
 ]]--
function FTC.Buffs:ClearShields()

    -- Manually maintain a list of shields
    local Shields = { 

        -- Dragonknight
        29071,      -- Obsidian Shield
        29224,      -- Igneous Shield
        32673,      -- Fragmented Shield
        20328,      -- Hardened Armor

        -- Sorcerer
        28418,      -- Conjured Ward
        29489,      -- Hardened Ward
        29482,      -- Empowered Ward

        -- Templar
        22178,      -- Sun Shield
        22182,      -- Radiant Ward
        22180,      -- Blazing Shield

        -- Weapons
        5798,       -- Brawler
        38401,      -- Shielded Assault
        40130,      -- Ward Ally
        40126,      -- Healing Ward
        31639,      -- Steadfast Ward

        -- AvA
        38175,      -- Barrier
        40237,      -- Reviving Barrier
        40239,      -- Replenishing Barrier

        -- Guilds
        29338,      -- Annulment
        39186,      -- Dampen Magic
        39182,      -- Harness Magicka
        39369,      -- Bone Shield
        42176,      -- Bone Surge
        42138,      -- Spiked Bone Shield
    }

    -- Compare each shield ability with the current buffs for purging
    for i = 1 , #Shields do

        -- Does the named buff exist?
        local name = GetAbilityName(Shields[i])
        if ( FTC.Buffs.Player[name] ~= nil ) then 
            local id = FTC.Buffs.Player[name].control.id
            FTC.Buffs.Player[name] = nil 
            FTC.Buffs.Pool:ReleaseObject(id)
        end 
    end
end


--[[ 
 * Filter abilities to override their displayed names or durations as necessary
 ]]--
function FTC:FilterBuffInfo( unitTag , name ,  abilityType , iconName )
    
    -- Default to no isType
    local isType    = nil
    local isValid   = true

    -- Toggles
    if ( FTC.Buffs:IsToggle(name) ) then 
        isType = "T" 
        return isValid, name, isType , iconName
    end

    -- Boons
    local Boons = {
        13940,          -- Boon: The Warrior
        13943,          -- Boon: The Mage
        13974,          -- Boon: The Serpent
        13975,          -- Boon: The Thief
        13976,          -- Boon: The Lady
        13977,          -- Boon: The Steed
        13978,          -- Boon: The Lord
        13979,          -- Boon: The Apprentice
        13980,          -- Boon: The Ritual
        13981,          -- Boon: The Lover
        13982,          -- Boon: The Atronach
        13984,          -- Boon: The Shadow
        13985,          -- Boon: The Tower
    }
    for i = 1 , #Boons do 
        if ( name == GetAbilityName(Boons[i]) ) then 
            isValid = ( unitTag == 'player' )
            isType  = "P"
            return isValid, name, isType , iconName 
        end
    end

    -- AvA Bonuses
    local AvA = {
        15058,          -- Offensive Scroll Bonus I
        16348,          -- Offensive Scroll Bonus II
        15060,          -- Defensive Scroll Bonus I
        16350,          -- Defensive Scroll Bonus I
        39671,          -- Emperorship Alliance Bonus
    }    
    for i = 1 , #AvA do 
        if ( name == GetAbilityName(AvA[i]) ) then 
            isValid = ( unitTag == 'player' )
            isType  = "P"
            return isValid, name, isType , iconName 
        end
    end

    -- Valid Passives
    local Passives = {
        35658,          -- Lycanthropy
        39472,          -- Vampirism
        61662,          -- Minor Brutality
        --23673,          -- Major Brutality
        64509,          -- Majory Savagery
        26795,          -- Major Savagery
        61666,          -- Minor Savagery
        45227,          -- Major Sorcery
        61685,          -- Minor Sorcery  
        --40479,          -- Major Prophecy
        61688,          -- Minor Prophecy  
    }
    for i = 1 , #Passives do 
        if ( name == GetAbilityName(Passives[i]) ) then 
            isType  = "P"
            return isValid, name, isType , iconName 
        end
    end

    -- Ignored Passives
    local Ignored = {
        29667,          -- Concentration
        40359,          -- Fed on ally
        45569,          -- Medicinal Use
        62760,          -- Spell Shield
        63601,          -- ESO Plus Member
        23673,          -- Major Brutality
        40479,          -- Major Prophecy
    }
    for i = 1 , #Ignored do 
        if ( name == GetAbilityName(Ignored[i]) ) then 
            isValid = false 
            return isValid, name, isType , iconName
        end
    end
        
    -- Return other buffs
    return isValid, name, isType , iconName 
end


--[[ 
 * Double check that the slot is actually eligible for use
 ]]--
function FTC.Buffs:HasFailure( slotIndex )
    if ( HasCostFailure( slotIndex ) ) then return true
    elseif ( HasRequirementFailure( slotIndex ) ) then return true
    elseif ( HasWeaponSlotFailure( slotIndex ) ) then return true
    elseif ( HasTargetFailure( slotIndex ) ) then return true
    elseif ( HasRangeFailure( slotIndex ) ) then return true
    elseif ( HasStatusEffectFailure( slotIndex )  ) then return true
    elseif ( HasFallingFailure( slotIndex ) ) then return true
    elseif ( HasSwimmingFailure( slotIndex ) ) then return true
    elseif ( HasMountedFailure( slotIndex ) ) then return true
    elseif ( HasReincarnatingFailure( slotIndex ) ) then return true end
    return false
end