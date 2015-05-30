
--[[----------------------------------------------------------
    FTC GLOBAL EXTENSIONS
  ]]----------------------------------------------------------
	
	FTC.Extensions = {}
	CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() FTC.Extensions:Initialize()  end )

	--[[ 
     * Initialize Global Extensions
     * --------------------------------
     * Called by FTC_Ready
     * --------------------------------
     ]]--
	function FTC.Extensions:Initialize()
	
		-- Register callbacks
		CALLBACK_MANAGER:RegisterCallback( "FTC_SpellCast", 	function( ability ) FTC.Extensions.SpellCast( ability ) end )
		CALLBACK_MANAGER:RegisterCallback( "FTC_NewDamage", 	function( damage )  FTC.Extensions.NewDamage( damage )  end )
	end


    --[[ 
     * Handle Ability Triggers
     * --------------------------------
     * Called by FTC_NewDamage
     * --------------------------------
     ]]--
	function FTC.Extensions.SpellCast( ability )

		-- Might of the Guild
		local motg = GetSkillAbilityUpgradeInfo(SKILL_TYPE_GUILD,2,10)
		if ( FTC.init.Buffs and motg > 0 ) then

			-- Determine whether the ability used was a Mages' Guild ability
			for i = 1 , 5 do
				if ( ability.id == GetSkillAbilityId(SKILL_TYPE_GUILD,2,i,false) ) then 

					-- Don't count deactivating Mage Light
					if ( FTC.Buffs.Player[ability.name] ~= nil and FTC.Buffs.Player[ability.name].toggle == "T" ) then break end

					-- Fire a buff
		            local ability  = {
		                ["owner"]  = FTC.Player.name,
		                ["id"]     = 45607,
		                ["name"]   = GetAbilityName(45607),
		                ["cast"]   = 0,
		                ["dur"]    = 5000,
		                ["tex"]    = FTC.UI.Textures[GetAbilityName(45607)],
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
     * Handle Damage Triggers
     * --------------------------------
     * Called by FTC_NewDamage
     * --------------------------------
     ]]--
	function FTC.Extensions.NewDamage( damage )

		-- Burning
		local burning = GetAbilityName(1339)
		if ( FTC.init.Buffs and damage.out and damage.ability == burning and FTC.Buffs.Target[burning] == nil ) then
            local ability  = {
                ["owner"]  = damage.target,
                ["id"]     = 1339,
                ["name"]   = burning,
                ["cast"]   = 0,
                ["dur"]    = 3000,
                ["tex"]    = FTC.UI.Textures[burning],
                ["ground"] = false,
                ["area"]   = false,
                ["debuff"] = true,
                ["toggle"] = nil,
            }
            FTC.Buffs:NewEffect( ability )
            return
		end

		-- Poisoned
		local poisoned = GetAbilityName(776)
		if ( FTC.init.Buffs and damage.out and damage.ability == poisoned and FTC.Buffs.Target[poisoned] == nil) then
            local ability  = {
                ["owner"]  = damage.target,
                ["id"]     = 776,
                ["name"]   = poisoned,
                ["cast"]   = 0,
                ["dur"]    = 10000,
                ["tex"]    = FTC.UI.Textures[poisoned],
                ["ground"] = false,
                ["area"]   = false,
                ["debuff"] = true,
                ["toggle"] = nil,
            }
            FTC.Buffs:NewEffect( ability )
		end

		-- Purge Empower Buffs on damage
		if ( FTC.init.Buffs and damage.out and ( damage.result == ACTION_RESULT_DAMAGE or damage.result == ACTION_RESULT_CRITICAL_DAMAGE or damage.result == ACTION_RESULT_BLOCKED_DAMAGE or damage.result == ACTION_RESULT_DOT_TICK or damage.result == ACTION_RESULT_DOT_TICK_CRITICAL ) ) then
			local Empowers = { 38807 , 45607 , 22057 , 22110 , 22095 }
			for i = 1 , #Empowers do
				local name = GetAbilityName(Empowers[i])
				if ( FTC.Buffs.Player[name] ~= nil and FTC.Buffs.Player[name].begin < GetFrameTimeSeconds() ) then
		            local control = FTC.Buffs.Player[name].control
		            FTC.Buffs.Player[name] = nil 
					FTC.Buffs.Pool:ReleaseObject(control.id)
				end
			end
		end
	end