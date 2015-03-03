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
		CALLBACK_MANAGER:RegisterCallback( "FTC_CostChanged" , function() ListenForFragments() end )
	end
end

-- Determine whether Crystal Fragments can proc?
function CanFragmentsProc( ability )

	-- Bail if no ability is passed
	if ( ability == nil ) then return end
	
	-- Clear any existing proc buff
	if ( ability.name == "Crystal Fragments" ) then
		FTC.Buffs.Player["Crystal Fragments"] = nil	
		FTC.Hotbar[ability.slot].effects = { { 2 , BUFF_EFFECT_TYPE_DEBUFF , 2.4 , true , 2 } }
		return
	end

	-- Is Crystal Fragments available?
	for i = 3 , #FTC.Hotbar do
		if ( FTC.Hotbar[i].name == "Crystal Fragments" ) then
		
			-- Get the button
			local button = _G["ActionButton"..i.."Button"]
			FTC.Sorcerer.fragSlot 	= i
			FTC.Sorcerer.fragButton = button
			
			-- Bail out of the loop
			break
		end
	end
end

-- If Crystal Fragments is eligible, listen for it proccing
function ListenForFragments()

	-- Get the data
	local slot 		= FTC.Sorcerer.fragSlot
	if ( slot == nil ) then return end;
	local button 	= FTC.Sorcerer.fragButton

	-- Get the new cost
	local newCost = GetSlotAbilityCost( slot )

	-- If the new cost is half the old cost or less, assume PROC!
	if ( newCost <= ( FTC.Hotbar[slot].cost / 2 ) and newCost ~= 0 ) then
	
		-- Reduce the buff cast time
		FTC.Hotbar[slot].effects 	= { 0 , 2.4 , 0.25 }
	
		-- Unset the handler
		button:SetHandler( "OnUpdate" , nil )
	
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
				["icon"]	= FTC.Hotbar[slot].tex,
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