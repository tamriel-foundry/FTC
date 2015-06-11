 --[[----------------------------------------------------------
    ACTIVE BUFF EFFECTS
    * Get a custom buff/debuff effect when the player casts a spell
    * Effects are listed as [name] = { buff duration , debuff duration , cast time , confirm damage }
    * Only "exception" effects are stored here, as default cast times and durations are retrieved from the API
    ]]-----------------------------------------------------------
    
FTC.Buffs.Effects = {}
function FTC.Buffs:RegisterEffects()
    
    local effects = {

        --[[---------------------------------
            WEAPON SKILLS
        -----------------------------------]]
        
        -- Sword and Shield
        [3493]  = { 0,    15,   0,    true },       -- Puncture
        [38256] = { 0,    15,   0,    true },       -- Ransack
        [38250] = { 0,    15,   0,    true },       -- Pierce Armor
        [28304] = { 0,    9,    0,    true },       -- Low Slash
        [38268] = { 0,    12,   0,    true },       -- Deep Slash
        [38264] = { 0,    12,   0,    true },       -- Heroic Slash 
        [28719] = { 0,    2,    0,    true },       -- Shield Charge
        [38405] = { 0,    3,    0,    true },       -- Invasion
        [38401] = { 6,    2,    0,    true },       -- Shielded Assault
        [28365] = { 0,    15,   0,    true },       -- Power Bash
        [38452] = { 0,    15,   0,    true },       -- Power Slam
        [38455] = { 0,    10,   0,    true },       -- Reverberating Bash
                
        -- Dual Wield
        [28379] = { 0,    9,    0,    true },       -- Twin Slashes
        [10735] = { 9,    9,    0,    true },       -- Blood Craze
        [38839] = { 0,    9,    0,    true },       -- Rending Slashes
        [38857] = { 6,    0,    0,    true },       -- Rapid Strikes
        [38891] = { 10,   0,    0,    true },       -- Whirling Blades
        [21157] = { 0,    6,    0,    true },       -- Hidden Blade
        [38910] = { 0,    6,    0,    true },       -- Flying Blade
        [38914] = { 0,    6,    0,    true },       -- Shrouded Daggers

        -- Two Handed
        [20919] = { 0,    10,   0,    true },       -- Cleave
        [5798]  = { 8,    10,   0,    true },       -- Brawler
        [38745] = { 0,    10,   0,    true },       -- Carve
        [21055] = { 0,    8,    0,    true },       -- Stampede
        [24648] = { 0,    3.5,  0,    true },       -- Uppercut
        [38807] = { 5,    3.5,  0,    true },       -- Wrecking Blow
        [38814] = { 0,    7.5,  0,    true },       -- Dizzying Swing
        
        -- Bow
        [28869] = { 0,    10,   0,    true },       -- Poison Arrow
        [38645] = { 0,    10,   0,    true },       -- Venom Arrow
        [38660] = { 0,    10,   0,    true },       -- Poison Injection
        [28628] = { 0,    5,    1.5,  false },      -- Volley
        [38689] = { 0,    11,   1.5,  false },      -- Scorched Earth
        [5262]  = { 0,    11,   1.5,  false },      -- Burning Ground (French)
        [38695] = { 0,    5,    1.5,  false },      -- Arrow Barrage
        [28879] = { 0,    5,    0,    true },       -- Scatter Shot
        [38672] = { 0,    5,    0,    true },       -- Magnum Shot
        [38669] = { 0,    6,    0,    true },       -- Draining Shot
        [31271] = { 0,    5,    0,    true },       -- Arrow Spray
        [38705] = { 0,    5,    0,    true },       -- Bombard
        [38701] = { 0,    5,    0,    true },       -- Acid Spray
        [38685] = { 0,    10,   0,    true },       -- Lethal Arrow
        [38687] = { 0,    10,   0,    true },       -- Focused Aim

        -- Restoration Staff
        [37243] = { 8,    0,    0,    false },      -- Blessing of Protection
        [40103] = { 15,   0,    0,    false },      -- Blessing Of Restoration
        [40094] = { 8,    0,    0,    false },      -- Combat Prayer
        [31531] = { 0,    20,   1.5,  false },      -- Force Siphon
        [40109] = { 0,    20,   1.5,  false },      -- Siphon Spirit
        [40116] = { 0,    20,   0,    false },      -- Quick Siphon
        
        -- Destruction Staff
        [29173] = { 0,    18,   0,    false },      -- Weakness to Elements
        [39089] = { 0,    18,   0,    false },      -- Elemental Susceptibility
        [39095] = { 0,    18,   0,    false },      -- Elemental Drain
        [29089] = { 0,    8,    0,    true },       -- Shock Touch
        [29078] = { 0,    8,    0,    true },       -- Frost Touch
        [62648] = { 0,    8,    0,    true },       -- Fire Touch
        [38944] = { 0,    8,    0,    true },       -- Fire Reach
        [38970] = { 0,    8,    0,    true },       -- Frost Reach
        [38978] = { 0,    8,    0,    true },       -- Shock Reach
        [38985] = { 0,    8,    0,    true },       -- Flame Clench
        [38989] = { 0,    8,    0,    true },       -- Frost Clench
        [38993] = { 0,    8,    0,    true },       -- Shock Clench
        [46340] = { 0,    5,    0,    true },       -- Force Shock
        [46348] = { 0,    5,    0,    true },       -- Crushing Shock
        [46356] = { 0,    5,    0,    true },       -- Force Pulse

        [39161] = { 0,    10,   0,    true },       -- Pulsar
        [39162] = { 0 ,   10 ,  0,    true },       -- Flame Pulsar
        [39167] = { 0 ,   10 ,  0,    true },       -- Storm Pulsar
        [53301] = { 0 ,   10 ,  0,    true },       -- Icy Pulsar
        [42988] = { 0 ,   10 ,  0,    true },       -- Electric Pulsar
        [39143] = { 0 ,   10 ,  0,    true },       -- Elemental Ring
        [39145] = { 0 ,   10 ,  0,    true },       -- Fire Ring
        [39146] = { 0 ,   10 ,  0,    true },       -- Frost Ring
        [39147] = { 0 ,   10 ,  0,    true },       -- Shock Ring

        --[[---------------------------------
            SORCERER
        -----------------------------------]]
        
        -- Daedric Summoning
        [5420]  = { 0,    6,    0,    false },      -- Daedric Curse
        [24330] = { 0,    3.5,  0,    false },      -- Velocious Curse
        [56798] = { 0,    6,    0,    false },      -- Explosive Curse
        
        -- Storm Calling
        [18718] = { 0,    4,    0,    true },       -- Mages' Fury
        [19123] = { 0,    4,    0,    true },       -- Mages' Wrath
        [19109] = { 0,    4,    0,    true },       -- Endless Fury
        [23182] = { 0,    6,    0,    false },      -- Lightning Splash
        [23200] = { 0,    10,   0,    false },      -- Liquid Lightning
        [23205] = { 0,    6,    0,    false },      -- Lightning Flood
        [23234] = { 0,    2,    0,    false },      -- Bolt Escape
        [23236] = { 0,    2,    0,    false },      -- Streak
        [23277] = { 5,    2,    0,    false },      -- Ball of Lightning

        -- Dark Magic
        [43714] = { 0,    2.4,  0,    true },       -- Crystal Shard
        [46324] = { 0,    2.4,  0,    true },       -- Crystal Fragments
        [46331] = { 0,    2.4,  0,    true },       -- Crystal Blast
        [4737]  = { 0,    5.4,  0,    false },      -- Encase
        [28311] = { 0,    10.2, 0,    false },      -- Restraining Prison
        [28308] = { 0,    5.4,  0,    false },      -- Shattering Prison
        [24371] = { 0,    19.9, 1.5,  false },      -- Rune Prison
        [24578] = { 0 ,   21.7, 1.5,  false },      -- Rune Cage
        [24574] = { 60,   0,    1.5,  false },      -- Defensive Rune
        [24828] = { 0,    36,   0,    false },      -- Daedric Mines
        [24834] = { 0,    36,   0,    false },      -- Daedric Minefield
        [24842] = { 0,    36,   0,    false },      -- Daedric Tomb
        [24584] = { 4,    0,    0,    false },      -- Dark Exchange
        [24589] = { 4,    0,    0,    false },      -- Dark Conversion
        [24595] = { 4,    0,    0,    false },      -- Dark Deal
        [27706] = { 0,    11.4, 0,    false },      -- Negate Magic
        [28341] = { 11.4, 11.4, 0,    false },      -- Suppression Field
        [28348] = { 12,   9.6,  0,    false },      -- Absorption Field
        
        --[[---------------------------------
            DRAGONKNIGHT
        -----------------------------------]]
        
        -- Ardent Flame 
        [20657] = { 0,    10.5, 0,    true },       -- Searing Strike
        [20668] = { 0,    10.5, 0,    true },       -- Unstable Flame
        [20660] = { 0,    10.5, 0,    true },       -- Burning Embers
        [4771]  = { 0,    10,   0,    true },       -- Fiery Breath
        [20944] = { 0,    10,   0,    true },       -- Burning Breath
        [20930] = { 0,    10,   0,    true },       -- Engulfing Flames
        
        -- Earthen Heart
        [29032] = { 0,    3.6,  0,    true },       -- Stonefist
        [31816] = { 15,   3.6,  0,    true },       -- Stone Giant
        [31820] = { 0,    3.6,  0,    true },       -- Obsidian Shard
        [29037] = { 0,    20,   0,    true },       -- Petrify
        [32685] = { 0,    20,   0,    true },       -- Fossilize
        [32678] = { 0,    20,   0,    true },       -- Shattering Rocks
        [29059] = { 0,    14.4, 0,    false },      -- Ash Cloud
        [20779] = { 0,    18,   0,    false },      -- Cinder Storm
        [20789] = { 0,    18,   0,    false },      -- Eruption

        -- Draconic Power
        [20245] = { 0,    4,    0,    true },       -- Dark Talons
        [20252] = { 0,    4,    0,    true },       -- Burning Talons
        [20251] = { 0,    4,    0,    true },       -- Choking Talons
        [31837] = { 0,    2.5,  0,    true },       -- Inhale
        [18021] = { 0,    2.5,  0,    true },       -- Deep Breath
        [32785] = { 0,    2.5,  0,    true },       -- Draw Essence
        [32715] = { 6,    0,    0,    true },       -- Ferocious Leap
        
        --[[---------------------------------
            NIGHTBLADE
        -----------------------------------]]
        
        -- Assassination
        [34843] = { 2,    0,    0,    true },       -- Killer's Blade
        [18342] = { 0,    1.5,  0,    true },       -- Teleport Strike
        [7271]  = { 0,    1.5,  0,    true },       -- Ambush
        [25493] = { 0,    6,    0,    true },       -- Lotus Fan
        [33357] = { 0,    20,   0,    false },      -- Mark Target
        [36968] = { 0,    20,   0,    false },      -- Piercing Mark
        [36967] = { 0,    20,   0,    false },      -- Reaper's Mark    
        [33398] = { 0,    6,    0,    true },       -- Death Stroke
        [36508] = { 0,    6,    0,    true },       -- Incapacitating Strike
        [36514] = { 0,    6,    0,    true },       -- Soul Harvest
                                                                        
        -- Shadow   
        [25255] = { 0,    4.6,  0,    true },       -- Veiled Strike
        [25260] = { 0,    12,   0,    true },       -- Surprise Attack
        [25267] = { 0,    4.6,  0,    true },       -- Concealed Weapon 
        [33195] = { 11.5, 11.5, 0,    false },      -- Path of Darkness
        [36049] = { 11.5, 11.5, 0,    false },      -- Twisting Path
        [36028] = { 11.5, 11.5, 0,    false },      -- Refreshing Path
        [14350] = { 0,    4.5,  0,    false },      -- Aspect of Terror
        [37470] = { 0,    4.5,  0,    false },      -- Mass Hysteria
        [37475] = { 0,    4.5,  0,    false },      -- Manifestation of Terror
        [33211] = { 0,    20.7,  0,    false },     -- Summon Shades
        [35434] = { 0,    20.7,  0,    false },     -- Dark Shades
        [35411] = { 0,    20.7,  0,    false },     -- Shadow Image
        
        -- Siphoning
        [33291] = { 10,   10,   0,    true },       -- Strife
        [34835] = { 10,   10,   0,    true },       -- Swallow Soul
        [34838] = { 10,   10,   0,    true },       -- Funnel Health
        [33308] = { 0,    30,   1.2,  false },      -- Agony
        [34721] = { 0,    30,   1.2,  false },      -- Prolonged Suffering
        [34727] = { 0,    30,   1.2,  false },      -- Malefic Wreath   
        [33326] = { 8,    8,    0,    true },       -- Cripple
        [36943] = { 8,    8,    0,    true },       -- Debilitate
        [36957] = { 8,    8,    0,    true },       -- Crippling Grasp
        [25091] = { 0,    3.5,  0,    true },       -- Soul Shred
        [35460] = { 8,    4.5,  0,    true },       -- Soul Tether
        [35508] = { 3.5,  3.5,  0,    true },       -- Soul Siphon

        --[[---------------------------------
            TEMPLAR
        -----------------------------------]]
        
        -- Aedric Spear
        [26804] = { 0,    3,    0,    true },       -- Binding Javelin
        [13538] = { 0,    3,    0,    true },       -- Focused Charge
        [22161] = { 0,    3,    0,    true },       -- Explosive Charge
        [15540] = { 0,    2.4,  0,    true },       -- Toppling Charge
        [22138] = { 0,    6,    0,    true },       -- Radial Sweep
        [22144] = { 6,    8,    0,    true },       -- Empowering Sweep
        [22139] = { 0,    6,    0,    true },       -- Crescent Sweep
        
        -- Dawn's Wrath
        [21726] = { 6,    6,    0,    true },       -- Sun Fire
        [21732] = { 6,    6,    0,    true },       -- Reflective Light
        [21729] = { 8.4,  8.4,  0,    true },       -- Vampire's Bane
        [22057] = { 5,    0,    0,    true },       -- Solar Flare
        [22110] = { 5,    7.2,  0,    true },       -- Dark Flare
        [22095] = { 5,    0,    0,    true },       -- Solar Barrage
        [21776] = { 0,    6,    0,    false },      -- Eclipse
        [22006] = { 0,    6,    0,    false },      -- Total Dark
        [22004] = { 0,    6,    0,    false },      -- Unstable Core
        [21761] = { 0,    6,    0,    false },      -- Backlash
        [21763] = { 0,    6,    0,    false },      -- Power of the Light
        [21765] = { 7.2,  6,    0,    false },      -- Purifying Light
        [63029] = { 0,    3.6,  0,    true },       -- Radiant Destruction
        [63044] = { 0,    3.6,  0,    true },       -- Radiant Glory
        [63046] = { 0,    3.6,  0,    true },       -- Radiant Oppression
        [1293]  = { 9.6,  0,    0,    false },      -- Nova
        [21755] = { 9.6,  0,    0,    false },      -- Solar Prison
        [21758] = { 9.6,  0,    0,    false },      -- Solar Disturbance
        
        -- Restoring Light
        [22253] = { 8,    0,    0,    false },      -- Honor The Dead
        [22314] = { 8,    0,    0,    false },      -- Lingering Ritual
        [22265] = { 12,   0,    0,    false },      -- Cleansing Ritual
        [22259] = { 12,   0,    0,    false },      -- Purifying Ritual
        [22262] = { 22,   0,    0,    false },      -- Extended Ritual
            
        --[[---------------------------------
            ARMOR
        -----------------------------------]]
        
        -- Medium Armor
        [18354] = { 20,   0,    0,    false },      -- Evasion
        [39192] = { 23,   0,    0,    false },      -- Elude
        [39195] = { 20,   0,    0,    false },      -- Shuffle

        --[[---------------------------------
            GUILDS
        -----------------------------------]]
        
        -- Fighter's Guild
        [35721] = { 0,    3.5,  0,    true },       -- Silver Bolts
        [40300] = { 0,    3.5,  0,    true },       -- Silver Shards
        [40336] = { 0,    3.5,  0,    true },       -- Silver Leash
        [35750] = { 0,    30,   3,    false },      -- Trap Beast
        [40372] = { 0,    30,   3,    false },      -- Lightweight Beast Trap
        [40382] = { 0,    30,   3,    false },      -- Rearming Trap
        [35713] = { 0,    4,    0,    true },       -- Dawnbreaker
        [40161] = { 0,    6,    0,    true },       -- Flawless Dawnbreaker
        [40158] = { 0,    4,    0,    true },       -- Dawnbreaker of Smiting
        
        -- Mages Guild
        [8108]  = { 14.4, 14.4, 0,    true },       -- Entropy
        [40457] = { 14.4, 14.4, 0,    true },       -- Degeneration
        [40452] = { 14.4, 14.4, 0,    true },       -- Structured Entropy
        [31632] = { 0,    30,   0,    false },      -- Fire Rune
        [40470] = { 0,    30,   0,    false },      -- Volcanic Rune
        [40465] = { 0,    30,   0,    false },      -- Scalding Rune
        [16536] = { 0,    11.8, 0,    false },      -- Meteor
        [40489] = { 0,    11.8, 0,    false },      -- Ice Comet
        [40493] = { 0,    11.8, 0,    false },      -- Shooting Star

        -- Undaunted
        [39475] = { 0,    15,   0,    true },       -- Inner Fire
        [42056] = { 0,    15,   0,    true },       -- Inner Rage
        [42060] = { 0,    15,   0,    true },       -- Inner Beast
        [39425] = { 0,    8,    0,    true },       -- Trapping Webs
        [41990] = { 0,    8,    0,    true },       -- Shadow Silk
        [42012] = { 0,    8,    0,    true },       -- Tangling Webs
            
        --[[---------------------------------
            WORLD
        -----------------------------------]]
        
        -- Vampire
        [2632]  = { 3,    3,    0,    true },       -- Drain Essence
        [38949] = { 3,    3,    0,    true },       -- Invigorating Drain
        [38956] = { 20,   3,    0,    true },       -- Accelerating Drain
        [32986] = { 3.5,  0,    0,    false },      -- Mist Form
        [38963] = { 4,    0,    0,    false },      -- Elusive Mist
        [38965] = { 4,    4,    0,    false },      -- Poison Mist
        [32624] = { 0,    5,    0,    false },      -- Bat Swarm
        [38931] = { 0,    5,    0,    false },      -- Devouring Swarm
        [38932] = { 0,    5,    0,    false },      -- Clouding Swarm

        -- Werewolf
        [25402] = { 0,    4.3,  1,    false },      -- Roar
        [39113] = { 0,    4.3,  1,    false },      -- Ferocious Roar
        [39114] = { 0,    4.3,  1,    false },      -- Rousing Roar
        [58405] = { 0,    3,    0,    false },      -- Piercing Howl
        [58742] = { 0,    3,    0,    false },      -- Howl of Despair
        [58798] = { 0,    3,    0,    false },      -- Howl of Agony
        [58850] = { 0,    10,   0,    true },       -- Infectious Claws
        [58864] = { 0,    10,   0,    true },       -- Claws of Anguish
        [58879] = { 10,   10,   0,    true },       -- Claws of Life
        [58317] = { 17,   0,    0,    false },      -- Hircine's Rage
        [58325] = { 8,    0,    0,    false },      -- Hircine's Fortitude
        
        -- Soul Magic
        [3673]  = { 0,    10,   0,    true },       -- Soul Trap
        [40317] = { 0,    10,   0,    true },       -- Consuming Trap
        [40328] = { 0,    10,   0,    true },       -- Soul Splitting Trap
        [39270] = { 0,    2.8,  0,    true },       -- Soul Strike
        [40414] = { 0,    2.8,  0,    true },       -- Shatter Soul
        [40420] = { 0,    3.9,  0,    true },       -- Soul Assault

        --[[---------------------------------
            AVA
        -----------------------------------]]
       
        -- Assault
        [18390] = { 0,    30,   1,    false },      -- Caltrops
        [40255] = { 0,    30,   1,    false },      -- Anti-Cavalry Caltrops
        [40242] = { 0,    30,   1,    false },      -- Razor Caltrops
        [61487] = { 0,    4,    1.8,    false },    -- Magicka Detonation
        [61491] = { 0,    4,    1.8,    false },    -- Inevitable Detonation
        [61500] = { 0,    4,    1.8,    false },    -- Proximity Detonation
        
        -- Support
        [38571] = { 6,    0,    0,    false },      -- Purge
        [40232] = { 6,    0,    0,    false },      -- Efficient Purge
        [34826] = { 6,    0,    0,    false },      -- Cleanse
        [61503] = { 5,    0,    0,    false },      -- Vigor
        [61505] = { 5,    0,    0,    false },      -- Echoing Vigor
        [61507] = { 5,    0,    0,    false },      -- Resolving Vigor
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


--[[----------------------------------------------------------
    ADDITIONAL EFFECTS
  ]]----------------------------------------------------------

    --[[ 
     * Tracks Toggled Abilities
     * --------------------------------
     * Called by FTC:FilterBuffInfo()
     * --------------------------------
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
     * Clears Damage Shield Buffs
     * --------------------------------
     * Called by FTC.OnVisualRemoved()
     * --------------------------------
     ]]--
    function FTC.Buffs:ClearShields()

        -- Manually maintain a list of shields
        local Shields = { 

            -- Dragonknight
            29071,      -- Obsidian Shield
            29224,      -- Igneous Shield
            32673,      -- Fragmented Shield

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
     * Modify Effects when Damage Occurs
     * --------------------------------
     * Called by FTC.Buffs:Damage()
     * --------------------------------
     ]]--
    function FTC.Buffs:DamageEffect( name )

        -- Bail if no buff or debuff exists
        if ( FTC.Buffs.Target[name] == nil ) then return end

        -- Maintain a list of mines
        local Mines = { 
            [GetAbilityName(24828)] = { 0,    1.5,  0,    false },      -- Daedric Mines
            [GetAbilityName(24834)] = { 0,    1.5,  0,    false },      -- Daedric Minefield
            [GetAbilityName(24842)] = { 0,    2,    0,    false },      -- Daedric Tomb
            [GetAbilityName(35750)] = { 0,    6,    0,    false },      -- Trap Beast
            [GetAbilityName(40372)] = { 0,    6,    0,    false },      -- Lightweight Beast Trap
            [GetAbilityName(40382)] = { 0,    6,    0,    false },      -- Rearming Trap
            [GetAbilityName(31632)] = { 0,    0,    0,    false },      -- Fire Rune
            [GetAbilityName(40470)] = { 0,    3,    0,    false },      -- Volcanic Rune
            [GetAbilityName(40465)] = { 0,    10,   0,    false },      -- Scalding Rune
        }

        -- Update mine debuff durations
        if ( Mines[name] ~= nil ) then
            local debuff = FTC.Buffs.Target[name]
            local time   = GetGameTimeMilliseconds() / 1000
            debuff.begin = time
            debuff.ends  = time + Mines[name][2]
        end
    end

    --[[ 
     * Identify Taunt Abilities
     * --------------------------------
     * Called by FTC.Player:GetActionBar()
     * --------------------------------
     ]]--
    function FTC.Buffs:IsTaunt( name )
        local Taunts = {
            3493,     -- Puncture
            38256,    -- Ransack
            38250,    -- Pierce Armor
            39475,    -- Inner Fire
            42056,    -- Inner Rage
            42060,    -- Inner Beast
        }
        for i = 1 , #Taunts do
            if ( name == GetAbilityName(Taunts[i]) ) then return true end
        end
    end

    --[[ 
     * Filter Valid Buff Effects
     * --------------------------------
     * Called by FTC.Buffs:GetBuffs()
     * Called by FTC.Buffs:EffectChanged()
     * --------------------------------
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

        -- Vampirism
        local Vamp = {
            35771,          -- Stage 1 Vampirism
            35773,          -- Stage 2 Vampirism
            35780,          -- Stage 3 Vampirism
            35786,          -- Stage 4 Vampirism
        }
        for i = 1 , #Vamp do
            if ( name == GetAbilityName(Vamp[i] ) ) then 
                isValid = true
                isType  = "V"..i
                return isValid, name, isType , iconName
            end
        end

        -- Lycanthropy
        if ( name == GetAbilityName( 35658 ) ) then
            isValid = true
            isType = "W"
            return isValid, name, isType , iconName
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
            39472,          -- Vampirism
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
     * Verify an Ability is Eligible for Use
     * --------------------------------
     * Called by FTC.Buffs.SetStateCustom()
     * --------------------------------
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
    