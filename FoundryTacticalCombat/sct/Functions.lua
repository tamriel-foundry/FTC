 
 --[[----------------------------------------------------------
	SCROLLING COMBAT TEXT FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the scrolling combat text component
	* Runs during FTC:Initialize()
  ]]--

FTC.SCT = {}
function FTC.SCT:Initialize()

	-- Setup tables
	FTC.SCT.In		= {}
	FTC.SCT.Out		= {}
	FTC.SCT.Stat	= {}
	
	-- Create controls
	FTC.SCT:Controls()
	
	-- Register init status
	FTC.init.SCT = true
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------

--[[ 
 * Process new combat events passed from the combat event handler
 * Called by FTC.Damage:New() if the damage is approved
 ]]--
function FTC.SCT:NewCombat( newSCT , context )
	
	-- Get the existing entries
	local damages	= FTC.SCT[context]
	if ( #damages == 0 ) then table.insert( FTC.SCT[context] , newSCT) end
	
	-- Loop through each existing combat entry
	local oldest 	= 1
	local isNew		= true
	for i = 1, #damages do
	
		-- If an identical entry already exists, do a multiplier instead of a new entry
		if ( ( damages[i].name == newSCT.name ) and ( damages[i].heal == newSCT.heal ) and ( math.abs( damages[i].ms - newSCT.ms ) < 500 ) ) then
			
			-- If the damage is higher, replace it
			if ( newSCT.dam > damages[i].dam ) then 
				FTC.SCT[context][i] = newSCT
			end
			
			-- Increment the multiplier, and bail
			FTC.SCT[context][i].multi = FTC.SCT[context][i].multi + 1
			isNew = false
			break
		
		-- Otherwise flag the oldest entry for recycling
		else oldest = FTC.SCT[context][i].ms < FTC.SCT[context][oldest].ms and i or oldest	end
	end
	
	-- Process new damage entries
	if ( isNew ) then
	
		-- If there are fewer than the maximum number of events recorded, insert it directly
		if ( #damages < FTC.vars.SCTCount ) then table.insert( FTC.SCT[context] , newSCT)
		
		-- Otherwise, recycle the oldest entry
		else FTC.SCT[context][oldest] = newSCT end
	end
	
	-- Next, allocate combat entries to controls
	for i = 1, FTC.vars.SCTCount do
		
		-- Add the damage to controls
		local container = _G["FTC_SCT"..context..i]
		if ( FTC.SCT[context][i] ~= nil ) then
			container.damage = FTC.SCT[context][i]
		
		-- Purge unused controls
		else container.damage = {}	end
	end	
end


 --[[ 
  * Handles experience events and adds them to the combat damage table.
  * Runs on the EVENT_EXPERIENCE_UPDATE and EVENT_VETERAN_POINTS_UPDATE listeners.
 ]]--
function FTC.SCT:NewExp( eventCode, unitTag, currentExp, maxExp, reason )
	
	-- Bail if it's not earned by the player
	if ( unitTag ~= "player" ) then return end
	
	-- Don't display experience for level 50 characters
	if ( eventCode == EVENT_EXPERIENCE_UPDATE and FTC.Player.level == 50 ) then return end
	
	-- Check whether it's VP or EXP
	local isveteran = ( eventCode == EVENT_VETERAN_POINTS_UPDATE ) and true or false
	
	-- Ignore finesse bonuses, they will get rolled into the next reward
	if ( reason == XP_REASON_FINESSE ) then return end
	
	-- Get the base experience
	local base 	= isveteran and FTC.Player.vet or FTC.Player.exp
	
	-- Calculate the difference
	local diff 	= currentExp - base
	
	-- Calculate percentage to level
	local pct	= math.floor( 100 * ( currentExp / maxExp ) )
	
	-- Setup the name
	local name = isveteran and "Veteran Points (" .. pct .. "%)" or "Experience (" .. pct .. "%)"
	
	-- Ignore zero experience rewards
	if ( diff == 0 ) then return end
	
	-- Update the base experience
	if ( isveteran ) then
		FTC.Player.vet = currentExp
	else
		FTC.Player.exp = currentExp
	end
	
	-- Update the character sheet exp bar
	FTC.Player:Update( nil , 'player' )
	
	-- Setup a new SCT object
	local newSCT = {
		["name"]	= name,
		["name"]	= name,
		["dam"]		= diff,
		["power"]	= 0,
		["type"]	= 2000,
		["ms"]		= GetGameTimeMilliseconds(),
		["crit"]	= false,
		["heal"]	= false,
		["blocked"]	= false,
		["immune"]	= false
	}
	table.insert( FTC.SCTStat, newSCT )
end

 --[[ 
  * Handles alliance point gains.
  * Runs on the EVENT_ALLIANCE_POINT_UPDATE listener.
 ]]--
function FTC.SCT:NewAP( eventCode, alliancePoints, playSound, difference )

	-- Ignore tiny AP rewards
	if ( difference  < 5 ) then return end
	
	-- Get AvA progress
	local subStart, nextSub, rankStart, nextRank = GetAvARankProgress(alliancePoints)
	
	-- Calculate percentage to level
	local pct	= math.floor( 100 * ( difference / ( nextSub - subStart ) ) )
	
	-- Setup the name
	local name = "Alliance Points (" .. pct .. "%)"
	
	-- Setup a new SCT object
	local newSCT = {
		["name"]	= name,
		["dam"]		= difference,
		["power"]	= 0,
		["type"]	= 2001,
		["ms"]		= GetGameTimeMilliseconds(),
		["crit"]	= false,
		["heal"]	= false,
		["blocked"]	= false,
		["immune"]	= false
	}
	table.insert( FTC.SCTStat, newSCT )	
end


--[[----------------------------------------------------------
	UPDATING FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Updates Scrolling Combat Text for both incoming and outgoing damage
 * Runs every frame OnUpdate
 ]]--
function FTC.SCT:Update(context)

	-- Get saved variables
	local speed		= FTC.vars.SCTSpeed
	local num		= FTC.vars.SCTCount

	-- Get the SCT UI element
	local parent = _G["FTC_CombatText"..context]

	-- Get the damage table based on context
	local damages = FTC.SCT[context]

	-- Bail if no damage is present
	if ( #damages == 0 ) then return end
	
	-- Get the game time
	local gameTime = GetGameTimeMilliseconds()
	
	-- Loop through damage controls, modifying the display
	for i = 1 , FTC.vars.SCTCount do
	
		-- Get the control and it's damage value
		local container = _G["FTC_SCT"..context..i]
		local damage 	= container.damage
		
		-- If there's damage, proceed
		if ( damage.name ~= nil ) then 	
		
			-- Get the animation duration ( speed = 10 -> 0.5 second, speed = 1 -> 5 seconds )
			local lifespan	= ( gameTime - damage.ms ) / 1000
			local duration	= ( 11 - speed ) / 2
			
			-- If the animation has finished, hide the container
			if ( lifespan > duration ) then 
				container:SetHidden( true )
			
			-- Otherwise, we're good to go!
			else
			
				-- Get some values
				local dam	= damage.dam
				local name	= damage.name

				-- Set default appearance
				local font	= 'FoundryTacticalCombat/lib/Metamorphous.otf|20|soft-shadow-thick'
				local alpha = 0.8

				-- Flag critical hits
				if ( damage.crit == true ) then
					dam 	= "*" .. dam .. "*"
					font	= 'FoundryTacticalCombat/lib/Metamorphous.otf|24|soft-shadow-thick'
					alpha	= 1
				end
				
				-- Flag blocked damage
				if ( damage.blocked == true ) then
					dam		= "(" .. dam .. ")"
				end
				
				-- Flag damage immunity
				if ( damage.immune == true ) then
					dam		= "(Immune)"
				end
				
				-- Resource Alerts (Health = 998 , Stamina = 1006 , Magicka = 1000, Execute = 1001 )
				if ( damage.type == 998 or damage.type == 999 ) then
					container:SetColor(0.8,0,0,1)
					font = "ZoFontBookTablet"
				elseif ( damage.type == 1006 or damage.type == 1007 ) then
					container:SetColor(0.4,0.8,0.4,1)
					font = "ZoFontBookTablet"
				elseif ( damage.type == 1000 or damage.type == 1001 ) then
					container:SetColor(0.2,0.6,0.8,1)
					font = "ZoFontBookTablet"
			
				-- Experience
				elseif ( damage.type == 2000 or damage.type == 2001 ) then
					dam	= "|c99FFFF+" .. dam .. "|"				
				
				-- Flag heals
				elseif( damage.heal == true ) then
					dam = "|c99DD93" .. dam .. "|"
					if string.match( damage.name , "Potion" ) then damage.name = "Health Potion" end
				
				-- Magic damage
				elseif ( damage.type ~= DAMAGE_TYPE_PHYSICAL	) then
					dam = ( context == "Out" ) and "|c336699" .. dam .. "|" or "|c990000" .. dam .. "|"
				
				-- Standard hits
				else
					dam = ( context == "Out" ) and "|cAA9F83" .. dam .. "|" or "|c990000" .. dam .. "|"
				end
				
				-- Maybe add the ability name
				if ( FTC.vars.SCTNames ) then
					dam = dam .. "   " .. name
				end
				
				-- Add the multiplier
				if ( damage.multi and damage.multi > 1 ) then
					dam = dam .. " (x" .. damage.multi .. ")"
				end
				
				-- Update the damage
				container:SetHidden(false)
				container:SetFont( font )
				container:SetAlpha( alpha )
				container:SetText( dam )

				-- Get the starting offsets
				local offsetX 	= container.offsetX
				local offsetY 	= container.offsetY
				local height	= parent:GetHeight()
				local width		= parent:GetWidth()
				
				-- Scroll the vertical position
				offsetY			= offsetY - height * ( lifespan / duration )
				
				-- Ease the horizontal ( f(x) = 4x^2 - 4x + 1 )
				local ease		= lifespan / duration
				offsetX			= 100 * ( ( 4 * ease * ease ) - ( 4 * ease ) + 1 )
				offsetX			= ( context == "Out" ) and offsetX or -1 * offsetX

				-- Adjust the position
				container:SetAnchor(BOTTOM,parent,BOTTOM,offsetX,offsetY)
			end
		end
	end
end