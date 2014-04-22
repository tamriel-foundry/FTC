-- Watch for FTC initialization
CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() InitializeNightblade()  end )

-- Register the callback to fire whenever a spell is cast
function InitializeNightblade()
	if ( FTC.Player.class == "Nightblade" ) then
	
		-- Shadow Barrier
		FTC.Nightblade = { ["stealth"]		= GetUnitStealthState('player') }
		EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_STEALTH_STATE_CHANGED , FTC.NightbladeStealth )
		
		-- Refreshing Shadows
		CALLBACK_MANAGER:RegisterCallback("FTC_SpellCast" , function( ability ) FTC.NightbladeRefreshing( ability ) end )
	end
end

--[[ 
 * Runs on the EVENT_STEALTH_STATE_CHANGED listener.
 * Watches for changes in a Nightblade's stealth state to trigger Shadow Barrier
 ]]--
function FTC.NightbladeStealth( eventCode , unitTag , stealthState )

	-- Are we coming out of stealth?
	if ( ( FTC.Nightblade.stealth == STEALTH_STATE_HIDDEN or FTC.Nightblade.stealth == STEALTH_STATE_STEALTH or FTC.Nightblade.stealth == STEALTH_STATE_HIDDEN_ALMOST_DETECTED or FTC.Nightblade.stealth == STEALTH_STATE_STEALTH_ALMOST_DETECTED ) and ( stealthState == STEALTH_STATE_DETECTED or stealthState == STEALTH_STATE_NONE ) ) then
		
		-- Trigger a buff
		if ( FTC.init.Buffs ) then
			local ms = GetGameTimeMilliseconds()
			local newBuff = {
				["name"]	= "Shadow Barrier",
				["begin"]	= ms / 1000,
				["ends"]	= ( ms / 1000 ) + 4.6,
				["debuff"]	= false,
				["stacks"]	= 0,
				["tag"]		= 'player',
				["icon"]	= '/esoui/art/icons/ability_rogue_052.dds',
			}
			FTC.Buffs.Player["Shadow Barrier"] = newBuff
		end
	end
	
	
	-- Save the previous stealthed state
	FTC.Nightblade.stealth = stealthState
end


--[[ 
 * Runs on FTC_SpellCast callback
 * Triggers the Refreshing Shadows passive when a nightblade uses a Shadow ability
 ]]--
function FTC.NightbladeRefreshing( ability )

	-- Bail if no ability is passed
	if ( ability == nil ) then return end
	
	-- Is it a 
	local shadows = { "Shadow Cloak", "Shadowy Disguise", "Dark Cloak", "Veiled Strike", "Surprise Attack", "Concealed Weapon", "Path of Darkness", "Twisting Path", "Refreshing Path", "Aspect of Terror", "Mass Hysteria", "Manifestation of Terror", "Summon Shade", "Dark Shades", "Shadow Image", "Consuming Darkness", "Bolstering Darkness", "Veil of Blades" }
	for i = 1 , #shadows do
		if ( shadows[i] == ability.name ) then
			local ms = GetGameTimeMilliseconds()
			local newBuff = {
				["name"]	= "Refreshing Shadows",
				["begin"]	= ms / 1000,
				["ends"]	= ( ms / 1000 ) + 6,
				["debuff"]	= false,
				["stacks"]	= 0,
				["tag"]		= 'player',
				["icon"]	= '/esoui/art/icons/ability_rogue_050.dds',
			}
			FTC.Buffs.Player["Refreshing Shadows"] = newBuff
			break
		end
	end
end