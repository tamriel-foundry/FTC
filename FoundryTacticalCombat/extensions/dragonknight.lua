
--[[----------------------------------------------------------
    FTC DRAGONKNIGHT EXTENSION
  ]]----------------------------------------------------------

	FTC.Dragonknight = {}
	CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() FTC.Dragonknight:Initialize()  end )

    --[[ 
     * Initialize Dragonknight Extension
     * --------------------------------
     * Called by FTC_Ready
     * --------------------------------
     ]]--
	function FTC.Dragonknight:Initialize()
		if ( GetUnitClassId( 'player' ) == 1 ) then
		
			-- Register callback
			CALLBACK_MANAGER:RegisterCallback( "FTC_SpellCast", function( ability ) FTC.Dragonknight.SpellCast( ability ) end )
			CALLBACK_MANAGER:RegisterCallback( "FTC_NewDamage", function( damage )  FTC.Dragonknight.NewDamage( damage ) end )
		end
	end

    --[[ 
     * Handle Custom Dragonknight Casts
     * --------------------------------
     * Called by FTC_SpellCast
     * --------------------------------
     ]]--
	function FTC.Dragonknight.SpellCast( ability )

		-- Trigger Mountain's Blessing Minor Brutality
		local mblessing = GetSkillAbilityUpgradeInfo(SKILL_TYPE_CLASS,3,9) or 0
		if ( FTC.init.Buffs and mblessing > 0 ) then

			-- Determine whether the ability used was an Earthen Heart ability
			for i = 1 , 6 do
				if ( ability.id == GetSkillAbilityId(SKILL_TYPE_CLASS,3,i,false) ) then 

					-- Fire a buff
		            local ability  = {
		                ["owner"]  = FTC.Player.name,
		                ["id"]     = 29473,
		                ["name"]   = GetAbilityName(29473),
		                ["cast"]   = 0,
		                ["dur"]    = (10000 * mblessing),
		                ["tex"]    = FTC.UI.Textures[GetAbilityName(29473)],
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
     * Handle Custom Dragonknight Damage
     * --------------------------------
     * Called by FTC_NewDamage
     * --------------------------------
     ]]--
	function FTC.Dragonknight.NewDamage( damage )

		-- Trigger Warmth on Damage
		local warmth = GetSkillAbilityUpgradeInfo(SKILL_TYPE_CLASS,1,8) or 0
		if ( FTC.init.Buffs and damage.out and warmth > 0 and ( damage.result == ACTION_RESULT_DAMAGE or damage.result == ACTION_RESULT_CRITICAL_DAMAGE or damage.result == ACTION_RESULT_BLOCKED_DAMAGE or damage.result == ACTION_RESULT_DOT_TICK or damage.result == ACTION_RESULT_DOT_TICK_CRITICAL ) ) then

			-- Determine whether the ability used was an Earthen Heart ability
			for i = 1 , 6 do
				if ( damage.ability == GetAbilityName(GetSkillAbilityId(SKILL_TYPE_CLASS,1,i,false)) ) then 

					-- Fire a buff
		            local ability  = {
		                ["owner"]  = damage.target,
		                ["id"]     = 18047,
		                ["name"]   = GetAbilityName(18047),
		                ["cast"]   = 0,
		                ["dur"]    = (2 * warmth),
		                ["tex"]    = FTC.UI.Textures[GetAbilityName(18047)],
		                ["ground"] = false,
		                ["area"]   = false,
		                ["debuff"] = true,
		                ["toggle"] = nil,
		            }
		            FTC.Buffs:NewEffect( ability )

					-- Break out of the loop
					break
				end
			end
		end

        -- Check if the target has petrify to purge
        if ( FTC.init.Buffs and damage.out and ( damage.result == ACTION_RESULT_DAMAGE or damage.result == ACTION_RESULT_CRITICAL_DAMAGE or damage.result == ACTION_RESULT_BLOCKED_DAMAGE or damage.result == ACTION_RESULT_DOT_TICK or damage.result == ACTION_RESULT_DOT_TICK_CRITICAL ) ) then

        	-- Define abilities
        	local Petrify = { GetAbilityName(29037) , GetAbilityName(32685) , GetAbilityName(32678) }
        	for _ , name in pairs(Petrify) do
        		if ( FTC.Buffs.Target[name] ~= nil and damage.target == FTC.Buffs.Target[name].owner ) then
		            local control = FTC.Buffs.Target[name].control
		            FTC.Buffs.Target[name] = nil 
					FTC.Buffs.Pool:ReleaseObject(control.id)
					break
				end
        	end
		end 
	end