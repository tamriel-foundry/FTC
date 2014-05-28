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
	
		-- Clear the buff a spell was cast (costs Magicka)
		if ( ability.type == POWERTYPE_MAGICKA ) then FTC.Buffs.Player["Might of the Guild"] = nil end
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
		'Spell Symmetry',
		'Magelight',
		'Inner Light',
		'Radiant Magelight'
	}
	
	-- Check if it was a mage ability
	for i = 1 , #mages do
		if ( ability.name == mages[i] ) then	
		
			-- Get the time
			local ms = GetGameTimeMilliseconds()
			
			-- Trigger a buff
			local newBuff = {
				["name"]	= "Might of the Guild",
				["begin"]	= ms / 1000,
				["ends"]	= ( ms / 1000 ) + 8,
				["debuff"]	= false,
				["stacks"]	= 0,
				["tag"]		= 'player',
				["icon"]	= '/esoui/art/icons/ability_mage_038.dds',
			}
			FTC.Buffs.Player["Might of the Guild"] = newBuff
		end	
	end
end