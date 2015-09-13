
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

	        -- Register events
	        EVENT_MANAGER:RegisterForEvent( "FTC_Sorcerer", EVENT_EFFECT_CHANGED , FTC.Sorcerer.EffectChanged )
		end
	end

  	--[[ 
     * Handle Custom Sorcerer Effects
     * --------------------------------
     * Called by FTC_EffectChanged
     * --------------------------------
     ]]--
	function FTC.Sorcerer.EffectChanged( eventCode , changeType , effectSlot , effectName , unitTag , beginTime , endTime , stackCount , iconName , buffType , effectType , abilityType , statusEffectType , unitName , unitId , abilityId )

		-- Trigger Crystal Fragments
		if ( changeType == 1 and ( abilityId == 46326 or abilityId == 46327 ) ) then
				
			-- Trigger an alert
			if ( FTC.init.SCT ) then
				local newAlert = {
					["name"]	= 'crystalFragments',
					["label"]	= zo_strformat("<<!aC:1>>",effectName),
					["color"]	= {0,0.5,1},
					["size"]	= FTC.Vars.SCTFontSize + 8,
					["buffer"]	= 1,
				}
				FTC.SCT:NewAlert( newAlert )
			end
		end
	end