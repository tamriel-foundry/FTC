-- Watch for FTC initialization
CALLBACK_MANAGER:RegisterCallback( "FTC_Ready" , function() InitializeFragmentsWatcher()  end )

-- Register the callback to fire whenever a spell is cast
function InitializeFragmentsWatcher()
	if ( FTC.Player.class == "Sorcerer" ) then
		
		-- Setup defaults 
		FTC.Sorcerer = {
			["fragSlot"]	= nil,
			["fragButton"]	= nil,
		}		
		
		-- Register callbacks
		CALLBACK_MANAGER:RegisterCallback( "FTC_SpellCast" , function( ability ) CanFragmentsProc( ability ) end )
		CALLBACK_MANAGER:RegisterCallback( "FTC_EffectChanged" , function( ... ) FTC.ProcFragments( ... ) end )
	end
end

-- If Crystal Fragments is eligible, listen for it proccing
function FTC.ProcFragments( ... )

	-- Grab relevant arguments
	local changeType 	= select( 2 , ... )
	local effectName	= select( 4 , ... )

	-- Trigger Crystal Fragments
	if ( changeType == 1 and "Crystal Fragments Passive" == effectName ) then

		-- Get the slot
		local slot = FTC.Sorcerer.fragSlot
		if slot == nil then return end

		-- Get the time
		local ms = GetGameTimeMilliseconds()

		-- Trigger a buff
		if ( FTC.init.Buffs ) then
			local newBuff = {
				["name"]	= "Crystal Fragments",
				["begin"]	= ms / 1000,
				["ends"]	= ( ms / 1000 ) + 8,
				["debuff"]	= false,
				["stacks"]	= 0,
				["tag"]		= 'player',
				["icon"]	= FTC.Hotbar.Abilities[slot].tex,
			}
			FTC.Buffs.Player["Crystal Fragments"] = newBuff
		end
				
		-- Trigger an alert
		if ( FTC.init.SCT ) then
			local newAlert = {
				["type"]	= 'crystalFragments',
				["name"]	= 'Crystal Fragments',
				["value"]	= '',
				["ms"]		= ms,
				["color"]	= 'c6699cc',
				["size"]	= 20
			}
			FTC.SCT:NewStatus( newAlert )
		end
	end
end

-- Determine whether Crystal Fragments can proc?
function CanFragmentsProc( ability )

	-- Bail if no ability is passed
	if ( ability == nil ) then return end
	
	-- Clear any existing proc buff
	if ( ability.name == "Crystal Fragments" ) then
		FTC.Buffs.Player["Crystal Fragments"] = nil	
		FTC.Hotbar.Abilities[ability.slot].effects = FTC.Buffs.Effects["Crystal Fragments"]
		return
	end

	-- Is Crystal Fragments (47569) available?
	for i = 3 , #FTC.Hotbar do
		if ( FTC.Hotbar.Abilities[i].id == 47569 ) then
		
			-- Get the button
			local button = _G["ActionButton"..i.."Button"]
			FTC.Sorcerer.fragSlot 	= i
			FTC.Sorcerer.fragButton = button
			
			-- Bail out of the loop
			break
		end
	end
end
