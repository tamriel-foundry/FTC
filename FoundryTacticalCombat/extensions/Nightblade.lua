
--[[----------------------------------------------------------
    FTC NIGHTBLADE EXTENSION
  ]]----------------------------------------------------------

	FTC.Nightblade = {}
	CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() FTC.Nightblade:Initialize()  end )

    --[[ 
     * Initialize Sorcerer Extension
     * --------------------------------
     * Called by FTC_Ready
     * --------------------------------
     ]]--
	function FTC.Nightblade:Initialize()
		if ( GetUnitClassId( 'player' ) == 3 ) then

			-- Setup data
			FTC.Nightblade.focusSlot = nil
			FTC.Nightblade.canProc	 = false
			
			-- Register callback
			CALLBACK_MANAGER:RegisterCallback( "FTC_SpellCast", 	function( ability ) FTC.Nightblade.SpellCast( ability ) end )
			CALLBACK_MANAGER:RegisterCallback( "FTC_NewDamage", 	function( damage )  FTC.Nightblade.NewDamage( damage ) end )
		end
	end

    --[[ 
     * Handle Custom Nightblade Casts
     * --------------------------------
     * Called by FTC_SpellCast
     * --------------------------------
     ]]--
	function FTC.Nightblade.SpellCast( ability )

		-- Check if Grim Focus is available?
		FTC.Nightblade.focusSlot = nil
		for i = 3 , 7 do
			if ( FTC.Player.Abilities[i].name == GetAbilityName(61902) or FTC.Player.Abilities[i].name == GetAbilityName(61927) or FTC.Player.Abilities[i].name == GetAbilityName(61919) ) then
			
				-- Get the button
				local button = _G["ActionButton"..i.."Button"]
				FTC.Nightblade.focusSlot = i
				FTC.Nightblade.canProc	 = true
				
				-- Bail out of the loop
				break
			end
		end

		-- Trigger Exploitation Minor Prophecy
		local sbarrier = GetSkillAbilityUpgradeInfo(SKILL_TYPE_CLASS,2,8) or 0
		if ( FTC.init.Buffs and sbarrier >= 0 ) then

			-- Determine whether the ability used was a Shadow ability
			for i = 1 , 6 do
				if ( ability.id == GetSkillAbilityId(SKILL_TYPE_CLASS,2,i,false) ) then 

					-- Determine how many pieces of heavy armor are worn
					local nHeavy = 0
					for i = 0 , 11 do
						nHeavy = ( GetItemArmorType(BAG_WORN,i) == ARMORTYPE_HEAVY ) and nHeavy + 1 or nHeavy
					end

					-- Fire a buff
		            local ability  = {
		                ["owner"]  = FTC.Player.name,
		                ["id"]     = 18866,
		                ["name"]   = GetAbilityName(18866),
		                ["cast"]   = 0,
		                ["dur"]    = (2000 * sbarrier ) * ( 1 + (nHeavy * 0.25)),
		                ["tex"]    = FTC.UI.Textures[GetAbilityName(18866)],
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
     * Handle Custom Nightblade Damage
     * --------------------------------
     * Called by FTC_NewDamage
     * --------------------------------
     ]]--
	function FTC.Nightblade.NewDamage( damage )

		-- Trigger Hemorrhage on critical hits
		local hemorrhage = GetSkillAbilityUpgradeInfo(SKILL_TYPE_CLASS,1,10) or 0
		if ( FTC.init.Buffs and hemorrhage > 0 and damage.out and damage.result == ACTION_RESULT_CRITICAL_DAMAGE or damage.result == ACTION_RESULT_DOT_TICK_CRITICAL ) then

			-- Fire a buff
            local ability  = {
                ["owner"]  = FTC.Player.name,
                ["id"]     = 26038,
                ["name"]   = GetAbilityName(26038),
                ["cast"]   = 0,
                ["dur"]    = (10000 * hemorrhage),
                ["tex"]    = FTC.UI.Textures[GetAbilityName(26038)],
                ["ground"] = false,
                ["area"]   = false,
                ["debuff"] = false,
                ["toggle"] = nil,
            }
            FTC.Buffs:NewEffect( ability )
		end

		-- Check if Assassin's Will is available
		if ( FTC.Nightblade.focusSlot ~= nil and GetSlotBoundId(FTC.Nightblade.focusSlot) == 61932 or GetSlotBoundId(FTC.Nightblade.focusSlot) == 61907 and FTC.Nightblade.canProc) then

			-- Trigger an alert
			if ( FTC.init.SCT ) then
				local newAlert = {
					["name"]	= 'grimFocus',
					["label"]	= zo_strformat("<<!aC:1>>",GetAbilityName(61907)),
					["color"]	= {0.5,0.4,0.8},
					["size"]	= FTC.Vars.SCTFontSize + 8,
					["buffer"]	= 10000,
				}
				FTC.SCT:NewAlert( newAlert )
			end
			FTC.Nightblade.canProc	 = false
		end
	end