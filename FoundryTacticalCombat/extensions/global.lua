
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
		if ( FTC.init.Buffs and damage.out and damage.ability == burning ) then
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
		if ( FTC.init.Buffs and damage.out and damage.ability == poisoned ) then
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
			local Empowers = { 38807 , 45607 }
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






function IsFireDamageProc( damage )

	-- Bail if buff tracking is disabled
	if ( not FTC.init.Buffs ) then return end

	-- Look for burning
	if ( damage.name == "Burning" ) then

		-- Don't re-apply burning after the first tick
		if ( FTC.Buffs.Saved['Burning'] ~= nil ) then return end
		
		-- Trigger a debuff
		local ms = GetGameTimeMilliseconds()
		local newBuff = {
			["target"]	= FTC.Target.name,
			["name"]	= "Burning",
			["begin"]	= ms / 1000,
			["ends"]	= ( ms / 1000 ) + 4,
			["debuff"]	= true,
			["area"]	= true,
			["stacks"]	= 0,
			["icon"]	= '/esoui/art/icons/ability_dragonknight_004_b.dds',
		}
		FTC.Buffs.Target['Burning'] = newBuff
		FTC.Buffs.Saved['Burning'] = newBuff
	end

	-- Look for explosion
	if ( damage.name == "Explosion" ) then
		
		-- Trigger a debuff
		local ms = GetGameTimeMilliseconds()
		local newBuff = {
			["target"]	= FTC.Target.name,
			["name"]	= "Explosion",
			["begin"]	= ms / 1000,
			["ends"]	= ( ms / 1000 ) + 2,
			["debuff"]	= true,
			["area"]	= true,
			["stacks"]	= 0,
			["icon"]	= '/esoui/art/icons/ability_destructionstaff_010.dds',
		}
		FTC.Buffs.Target["Explosion"] = newBuff
		FTC.Buffs.Saved["Explosion"] = newBuff
	end
end