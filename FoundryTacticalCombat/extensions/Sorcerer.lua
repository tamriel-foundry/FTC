
--[[----------------------------------------------------------
    FTC SORCERER EXTENSION
  ]]----------------------------------------------------------

	FTC.Sorcerer = {}
	CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() FTC.Sorcerer:Initialize()  end )

    --[[ 
     * Initialize Sorcerer Extension
     * --------------------------------
     * Called by FTC_Ready
     * --------------------------------
     ]]--
	function FTC.Sorcerer:Initialize()
		if ( GetUnitClassId( 'player' ) == 2 ) then
			
			-- Setup data
			FTC.Sorcerer.fragSlot	= nil
			
			-- Register callback
			CALLBACK_MANAGER:RegisterCallback( "FTC_SpellCast", 	function( ability ) FTC.Sorcerer.SpellCast( ability ) end )
			CALLBACK_MANAGER:RegisterCallback( "FTC_NewDamage", 	function( damage )  FTC.Sorcerer.NewDamage( damage ) end )

	        -- Register events
	        EVENT_MANAGER:RegisterForEvent( "FTC_Sorcerer", 		EVENT_EFFECT_CHANGED , FTC.Sorcerer.EffectChanged )
		end
	end

    --[[ 
     * Handle Custom Sorcerer Effects
     * --------------------------------
     * Called by FTC_SpellCast
     * --------------------------------
     ]]--
	function FTC.Sorcerer.SpellCast( ability )
		
		-- Clear any existing proc buff
		local fragments = GetAbilityName(46324)
		if ( ability.name == fragments ) then 
			FTC.Buffs.Player[fragments] = nil
		end

		-- Check if Crystal Fragments is available?
		for i = 3 , 7 do
			if ( FTC.Player.Abilities[i].name == fragments ) then
			
				-- Get the button
				local button = _G["ActionButton"..i.."Button"]
				FTC.Sorcerer.fragSlot = i
				
				-- Bail out of the loop
				break
			end
		end

		-- Debuff Bolt Escape Cost
		if ( FTC.init.Buffs and ability.name == GetAbilityName(23234) or ability.name == GetAbilityName(23236) or ability.name == GetAbilityName(23277) ) then        
            local ability  = {
                ["owner"]  = FTC.Player.name,
                ["id"]     = ability.id,
                ["name"]   = ability.name .. " Cost",
                ["cast"]   = 0,
                ["dur"]    = 4000,
                ["tex"]    = ability.tex,
                ["ground"] = false,
                ["area"]   = true,
                ["debuff"] = true,
                ["toggle"] = nil,
            }
            FTC.Buffs:NewEffect( ability ) 
		end

		-- Trigger Exploitation Minor Prophecy
		local exploitation = GetSkillAbilityUpgradeInfo(SKILL_TYPE_CLASS,1,10) or 0
		if ( FTC.init.Buffs and exploitation > 0 ) then

			-- Determine whether the ability used was a Dark Magic ability
			for i = 1 , 6 do
				if ( ability.id == GetSkillAbilityId(SKILL_TYPE_CLASS,1,i,false) ) then 

					-- Fire a buff
		            local ability  = {
		                ["owner"]  = FTC.Player.name,
		                ["id"]     = 31389,
		                ["name"]   = GetAbilityName(31389),
		                ["cast"]   = 0,
		                ["dur"]    = (10000 * exploitation),
		                ["tex"]    = FTC.UI.Textures[GetAbilityName(31389)],
		                ["ground"] = false,
		                ["area"]   = false,
		                ["debuff"] = false,
		                ["toggle"] = nil,
		            }
		            FTC.Buffs:NewEffect( ability )

					-- Break out of the loop
					break
				end
			end
		end
	end

    --[[ 
     * Handle Custom Sorcerer Effects
     * --------------------------------
     * Called by FTC_NewDamage
     * --------------------------------
     ]]--
	function FTC.Sorcerer.NewDamage( damage )

		-- Check if the player has defensive rune up
		local defRune = GetAbilityName(24574)
		if ( FTC.init.Buffs and FTC.Buffs.Player[defRune] ~= nil and damage.result == ACTION_RESULT_DISORIENTED and damage.ability == defRune ) then

			-- Expire the existing buff
            local control = FTC.Buffs.Player[defRune].control
            FTC.Buffs.Player[defRune] = nil 
			FTC.Buffs.Pool:ReleaseObject(control.id)

			-- Trigger a debuff on the target
            local ability  = {
                ["owner"]  = damage.target,
                ["id"]     = 24574,
                ["name"]   = defRune,
                ["cast"]   = 0,
                ["dur"]    = 16600,
                ["tex"]    = damage.icon,
                ["ground"] = false,
                ["area"]   = false,
                ["debuff"] = true,
                ["toggle"] = nil,
            }
            FTC.Buffs:NewEffect( ability ) 

        -- Check if the target has a rune to purge
        elseif ( FTC.init.Buffs and damage.out and ( damage.result == ACTION_RESULT_DAMAGE or damage.result == ACTION_RESULT_CRITICAL_DAMAGE or damage.result == ACTION_RESULT_BLOCKED_DAMAGE or damage.result == ACTION_RESULT_DOT_TICK or damage.result == ACTION_RESULT_DOT_TICK_CRITICAL ) ) then

        	-- Define runes
        	local Runes = { GetAbilityName(24371) , GetAbilityName(24578) , GetAbilityName(24574) }
        	for _ , name in pairs(Runes) do
        		if ( FTC.Buffs.Target[name] ~= nil and damage.target == FTC.Buffs.Target[name].owner ) then
		            local control = FTC.Buffs.Target[name].control
		            FTC.Buffs.Target[name] = nil 
					FTC.Buffs.Pool:ReleaseObject(control.id)
					break
				end
        	end
		end 
	end

  	--[[ 
     * Handle Custom Sorcerer Effects
     * --------------------------------
     * Called by FTC_EffectChanged
     * --------------------------------
     ]]--
	function FTC.Sorcerer.EffectChanged( eventCode , changeType , effectSlot , effectName , unitTag , beginTime , endTime , stackCount , iconName , buffType , effectType , abilityType , statusEffectType )

		-- Trigger Crystal Fragments
		if ( changeType == 1 and effectName == GetAbilityName(46326)) then

			-- Fire if eligible
			local slot = FTC.Sorcerer.fragSlot
			if slot ~= nil and ( GetFrameTimeSeconds() - beginTime <= 0.1 ) then

				-- Trigger a buff
				if ( FTC.init.Buffs ) then
	                local ability  = {
	                    ["owner"]  = FTC.Player.name,
	                    ["id"]     = 46324,
	                    ["name"]   = effectName,
	                    ["cast"]   = 0,
	                    ["dur"]    = 8000,
	                    ["tex"]    = FTC.Player.Abilities[slot].tex,
	                    ["ground"] = false,
	                    ["area"]   = false,
	                    ["debuff"] = false,
	                    ["toggle"] = nil,
	                }
	                FTC.Buffs:NewEffect( ability ) 
				end
						
				-- Trigger an alert
				if ( FTC.init.SCT ) then
					local newAlert = {
						["name"]	= 'crystalFragments',
						["label"]	= effectName,
						["color"]	= {0,0.5,1},
						["size"]	= FTC.Vars.SCTFontSize + 8,
						["buffer"]	= 0,
					}
					FTC.SCT:NewAlert( newAlert )
				end
			end
		end
	end
