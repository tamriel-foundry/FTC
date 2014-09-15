
 --[[----------------------------------------------------------
	SCROLLING COMBAT ALERT FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the scrolling combat text alerts
  ]]--
  
--[[ 
 * Process new status events passed as status object tables
 * Statuses come in with arguments type, name, value, ms, color, font
 ]]--
function FTC.SCT:NewStatus( newStatus )
	
	-- Get the existing statuses
	local statuses	= FTC.SCT.Status
	local isNew		= true
	local oldest 	= 1
	
	-- Loop through each existing status, flag the oldest status for recycling
	if ( #statuses > 0 ) then 
		for i = 1, #statuses do
		
			-- If an identical entry already exists, bail
			if ( ( statuses[i].name == newStatus.name ) and ( newStatus.ms - statuses[i].ms ) < 1000 ) then
				isNew = false
				break
			
			-- Otherwise flag the oldest entry for recycling
			else oldest = FTC.SCT.Status[i].ms < FTC.SCT.Status[oldest].ms and i or oldest end
		end
	end
	
	-- Process new statuses
	if ( isNew ) then
	
		-- If there are fewer than the maximum number of events recorded, insert it directly
		if ( #statuses < FTC.vars.SCTCount ) then table.insert( FTC.SCT.Status , newStatus )
		
		-- Otherwise, recycle the oldest entry
		else FTC.SCT.Status[oldest] = newStatus end
	end

	-- Allocate status entries to controls
	for i = 1, FTC.vars.SCTCount do
		local container = _G["FTC_SCTStatus"..i]
		if ( FTC.SCT.Status[i] ~= nil ) then
			container.status = FTC.SCT.Status[i]
		
		-- Purge unused controls
		else container.status = {} end
	end	
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------

 --[[ 
  * Handles experience events and adds them to the combat damage table.
  * Runs OnXPUpdate()
 ]]--
function FTC.SCT:NewExp( eventCode, unitTag, currentExp, maxExp, reason )

	-- Bail if it's not earned by the player
	if ( unitTag ~= "player" ) then return end
	
	-- Experience gains for non-veteran players
	local base		= 0
	if ( FTC.Player.level < 50 ) then
		currentExp 	= GetUnitXP('player')
		base 		= FTC.Player.exp
	
	-- Experience gains for veteran players
	elseif ( eventCode == EVENT_EXPERIENCE_UPDATE and FTC.Player.level == 50 ) then
		currentExp 	= GetUnitVeteranPoints('player')
		base 		= FTC.Player.vet
		maxExp		= GetUnitVeteranPointsMax('player')
	
	-- Veteran point rewards for quest turn-ins
	elseif ( eventCode == EVENT_VETERAN_POINTS_UPDATE ) then	
		base 		= FTC.Player.vet
	end
	
	-- Calculate the difference, and ignore zeroes
	local diff 		= currentExp - base
	if ( diff == 0 ) then return end
	
	-- Calculate percentage to level
	local pct		= math.floor( 100 * ( currentExp / maxExp ) )
	
	-- Setup the name
	local name 		= ( FTC.Player.level == 50 ) and "Veteran Points (" .. pct .. "%)" or "Experience (" .. pct .. "%)"

	-- Setup a new Alert object
	local newAlert = {
		["type"]	= 'exp',
		["name"]	= name,
		["value"]	= "+" .. diff,
		["ms"]		= GetGameTimeMilliseconds(),
		["color"]	= 'c99FFFF',
	}
	
	-- Submit the new status
	FTC.SCT:NewStatus( newAlert )
end

 --[[ 
  * Handles alliance point gains.
  * Runs OnAPUpdate()
 ]]--
function FTC.SCT:NewAP( eventCode, alliancePoints, playSound, difference )

	-- Save tiny AP rewards for later
	if ( difference  < 5 ) then 
		FTC.SCT.backAP = FTC.SCT.backAP + difference
		return
	end
	
	-- Get AvA progress
	local subStart, nextSub, rankStart, nextRank = GetAvARankProgress( alliancePoints )
	
	-- Calculate percentage to level
	local pct	= math.floor( 100 * ( alliancePoints - rankStart ) / ( nextRank - rankStart ) )
	
	-- Setup the name
	local name = "Alliance Points ("..pct.."%)"
	
	-- Setup a new Alert object
	local newAlert = {
		["type"]	= 'ap',
		["name"]	= name,
		["value"]	= difference + FTC.SCT.backAP,
		["ms"]		= GetGameTimeMilliseconds(),
		["color"]	= 'c99FFFF',
	}
	
	-- Submit the new status
	FTC.SCT:NewStatus( newAlert )
	
	-- Reset the backlogged AP
	FTC.SCT.backAP = 0
end


 --[[ 
  * Handles resource depletion alerts.
  * Runs OnPowerUpdate()
 ]]--
function FTC.SCT:ResourceAlert( unitTag , powerType , powerValue , powerMax )

	-- Get the context
	local context 	= ( unitTag == 'player' ) and "Player" or "Target"
	
	-- Get the attribute name and color
	local attr		= ''
	if ( powerType == POWERTYPE_HEALTH ) then
		attr 	= 'Health'
		color 	= 'c990000'
	elseif ( powerType == POWERTYPE_STAMINA ) then 
		attr 	= 'Stamina'
		color	= 'c33cc66'
	elseif ( powerType == POWERTYPE_MAGICKA ) then 
		attr 	= 'Magicka'
		color	= 'c6699cc'
	end
	
	-- Get the percentage
	local pct = math.floor( ( powerValue / powerMax ) * 100 )
	
	-- Get the prior attribute level
	local prior 	= FTC[context][string.lower(attr)].pct
	
	-- Bail if we're above the threshold or were already below
	if ( pct > 25 or prior <= 25 ) then return end
	
	-- Get the game time
	local ms		= GetGameTimeMilliseconds()
	
	-- Make sure there hasn't been a recent alert for this resource already
	for i = 1 , #FTC.SCT.Status do
		if ( FTC.SCT.Status[i].type == unitTag .. attr and FTC.SCT.Status[i].ms > ms - 5000 ) then return end		
	end
	
	-- Set up the alert name
	local name = ( context == "Player" ) and "Low " .. attr or "Target Low " .. attr
	
	-- Otherwise submit an object
	local newAlert = {
		["type"]	= unitTag .. attr,
		["name"]	= name,
		["value"]	= '('..pct..'%)',
		["ms"]		= ms,
		["color"]	= color,
		["size"]	= 20
	}
	
	-- Submit the new status
	FTC.SCT:NewStatus( newAlert )
end


 --[[ 
  * Handles resource depletion alerts.
  * Runs OnDeath()
 ]]--
function FTC.SCT:Deathspam( eventCode , unitTag , isDead )

	-- Bail if it's not a target death
	if ( unitTag ~= 'reticleover' or not isDead ) then return end
	
	-- Bail if it's not a player
	if ( not IsUnitPlayer( unitTag ) ) then return end
	
	-- Ignore friendlies
	if ( GetUnitAlliance( 'reticleover' ) == GetUnitAlliance( 'player' ) ) then return end

	-- Switch by context
	local label = "You Killed " .. GetUnitName( unitTag )
		
	-- Otherwise submit an object
	local newAlert = {
		["type"]	= 'killspam',
		["name"]	= label,
		["value"]	= '',
		["ms"]		= GetGameTimeMilliseconds(),
		["color"]	= 'c990000',
		["size"]	= 20
	}
	
	-- Submit the new status
	FTC.SCT:NewStatus( newAlert )
end

 --[[ 
  * Handles combat status changes.
  * Runs OnCombatState()
 ]]--
function FTC.SCT:CombatStatus( inCombat )

	-- Get the context
	local context 	= inCombat and "combatIn" or "combatOut"
	local label		= inCombat and "In Combat" or "Left Combat"
	
	-- Create an alert object
	local newAlert = {
		["type"]	= context,
		["name"]	= label,
		["value"]	= '',
		["ms"]		= GetGameTimeMilliseconds(),
		["color"]	= 'cffcc00',
		["size"]	= 16
	}
	
	-- Submit the new status
	FTC.SCT:NewStatus( newAlert )		
end


--[[----------------------------------------------------------
	UPDATING FUNCTIONS
 ]]-----------------------------------------------------------
 
--[[ 
 * Updates Scrolling Combat Text alerts component
 * Runs every frame OnUpdate
 ]]--
function FTC.SCT:UpdateAlerts()

	-- Get saved variables
	local speed		= FTC.vars.SCTSpeed
	local num		= FTC.vars.SCTCount

	-- Get the alert UI element
	local parent 	= _G["FTC_CombatTextStatus"]

	-- Get the statuses
	local statuses 	= FTC.SCT.Status

	-- Bail if no statuses is present
	if ( #statuses == 0 ) then return end
	
	-- Get the game time
	local gameTime = GetGameTimeMilliseconds()
	
	-- Loop through status controls, modifying the display
	for i = 1 , FTC.vars.SCTCount do
	
		-- Get the control and it's damage value
		local container = _G["FTC_SCTStatus"..i]
		local status 	= container.status
		
		-- If there's damage, proceed
		if ( status.name ~= nil ) then 	
		
			-- Get the animation duration ( speed = 10 -> 0.5 second, speed = 1 -> 5 seconds )
			local lifespan	= ( gameTime - status.ms ) / 1000
			local duration	= ( 11 - speed ) / 2
			
			-- If the animation has finished, hide the container
			if ( lifespan > duration ) then 
				container:SetHidden( true )
			
			-- Otherwise, we're good to go!
			else
				-- Get the name
				local value	= status.value .. "   " .. status.name
				
				-- Set default appearance
				local size 	= ( status.size == nil ) and 16 or status.size
				local font	= FTC.Fonts.meta( size )
				local alpha = 1
				local color = ( status.color == nil ) and "cFFFFFF" or status.color
			
				-- Add custom color
				value	= "|" .. color .. value .. "|"
							
				-- Update the damage
				container:SetHidden(false)
				container:SetFont( font )
				container:SetAlpha( alpha )
				container:SetText( value )

				-- Get the starting offsets
				local offsetX 	= container.offsetX
				local offsetY 	= container.offsetY
				local height	= parent:GetHeight()
				local width		= parent:GetWidth()
				
				-- Scroll the vertical position
				offsetY			= offsetY - height * ( lifespan / duration )
		
				-- Adjust the position
				container:SetAnchor(BOTTOM,parent,BOTTOM,offsetX,offsetY)
			end
		end
	end
end