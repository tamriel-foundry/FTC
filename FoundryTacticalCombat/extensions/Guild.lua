-- Watch for FTC initialization
CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() InitializeMightGuild()  end )

-- Register the callback to fire whenever a spell is cast
function InitializeMightGuild()
	CALLBACK_MANAGER:RegisterCallback("FTC_SpellCast" , function( ability ) IsMightGuild( ability ) end )
end

function IsMightGuild( ability )

	-- Bail if buff tracking is disabled
	if ( not FTC.init.Buffs ) then return end
	
	-- Is Might of the Guild already procced?
	if ( FTC.Buffs.Player["Might of the Guild"] ~= nil ) then
		d( 'Might of the Guild already exists!' )
	end

	-- Look for mages' guild abilities
	local mages = {
		'Meteor',
		'Ice Comet',
		'Shooting Star',
		'Entropy',
		'Degeneration',
		'Structured Entropy',
		'Fire Rune',
		'Volcanic Rune',
		'Scalding Rune',
		'Equilibrium',
		'Balance',
		'Spell Symmetry'	
	}
	
	-- Check if it was a mage ability
	for i = 1 , #mages do
		if ( ability.name == mages[i] ) then	
			d( 'Might of the Guild procced!' )

		end	
	end
end