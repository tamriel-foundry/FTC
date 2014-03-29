-- Watch for FTC initialization
CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() InitializeFireWatcher()  end )

-- Register the callback to fire whenever a spell is cast
function InitializeFireWatcher()
	CALLBACK_MANAGER:RegisterCallback("FTC_NewDamage" , function( damage ) IsFireDamageProc( damage ) end )
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