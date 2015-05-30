
--[[----------------------------------------------------------
    FTC TEMPLAR EXTENSION
  ]]----------------------------------------------------------

	FTC.Templar = {}
	CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() FTC.Templar:Initialize()  end )

    --[[ 
     * Initialize Templar Extension
     * --------------------------------
     * Called by FTC_Ready
     * --------------------------------
     ]]--
	function FTC.Templar:Initialize()
		if ( GetUnitClassId( 'player' ) == 6 ) then
		
			-- Register callback
			CALLBACK_MANAGER:RegisterCallback( "FTC_SpellCast", function( ability ) FTC.Templar.SpellCast( ability ) end )
		end
	end

    --[[ 
     * Handle Custom Sorcerer Effects
     * --------------------------------
     * Called by FTC_SpellCast
     * --------------------------------
     ]]--
	function FTC.Templar.SpellCast( ability )

		-- Trigger Illuminate Minor Sorcery
		local illuminate = GetSkillAbilityUpgradeInfo(SKILL_TYPE_CLASS,2,9)
		if ( FTC.init.Buffs and illuminate > 0 ) then

			-- Determine whether the ability used was a Dawn's Wrath ability
			for i = 1 , 6 do
				if ( ability.id == GetSkillAbilityId(SKILL_TYPE_CLASS,2,i,false) ) then 

					-- Fire a buff
		            local ability  = {
		                ["owner"]  = FTC.Player.name,
		                ["id"]     = 31743,
		                ["name"]   = GetAbilityName(31743),
		                ["cast"]   = 0,
		                ["dur"]    = (10000 * illuminate),
		                ["tex"]    = FTC.UI.Textures[GetAbilityName(31743)],
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