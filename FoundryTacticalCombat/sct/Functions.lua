 
 --[[----------------------------------------------------------
	SCROLLING COMBAT TEXT FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the scrolling combat text component
	* Runs during FTC:Initialize()
  ]]--

FTC.SCT = {}
function FTC.SCT:Initialize()

	-- Setup tables
	FTC.SCTIn	= {}
	FTC.SCTOut	= {}
	FTC.SCTStat	= {}
	
	-- Create controls
	FTC.SCT:Controls()
	
	-- Register init status
	FTC.SCT.init = true
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------

--[[ 
 * Process new combat events passed from the combat event handler
 * Called by FTC.Damage:New() if the damage is approved
 ]]--
function FTC.SCT:NewCombat( newSCT , context )
	
	-- Check if the damage entry already exists
	local isNew 	= true
	for i = 1, #FTC["SCT"..context] do
		if ( ( FTC["SCT"..context][i].name == newSCT.name ) and ( math.abs( FTC["SCT"..context][i].ms - newSCT.ms ) < 500 ) ) then
			
			-- If the damage is higher, replace it
			if ( newSCT.dam > FTC["SCT"..context][i].dam ) then 
				FTC["SCT"..context][i] = newSCT
			end
			
			-- Tag a multiplier
			FTC["SCT"..context][i].multi = FTC["SCT"..context][i].multi + 1
			isNew = false
		end
	end

	-- Add the SCT object to the relevant damage table
	if ( isNew ) then table.insert( FTC["SCT"..context] , newSCT) end
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

	-- Get SCT arguments
	local speed		= ( FTC.vars.SCTSpeed >= 1 and FTC.vars.SCTSpeed <= 10 ) and FTC.vars.SCTSpeed or FTC.defaults.SCTSpeed

	-- Get the SCT UI element
	local 	Parent = _G["FTC_CombatText"..context]
	
	-- Get the damage table based on context
	local 	Damage = {}
	if ( context == "Out" ) then 
		Damage = FTC.SCTOut
	elseif ( context == "In" ) then
		Damage = FTC.SCTIn
	elseif (context == "Stat" ) then
		Damage = FTC.SCTStat
	end
	
	-- Bail if no damage is present
	if ( #Damage == 0 ) then return	end
	
	-- Get the game time
	local gameTime = GetGameTimeMilliseconds()
	
	-- If we have been out of combat for 5 seconds, clear everything
	if ( IsUnitInCombat('player') == false ) and (( gameTime - Damage[#Damage].ms ) > 5000 ) then
		if ( context == "Out" ) then
			FTC.SCTOut 	= {}
		elseif ( context == "In" ) then
			FTC.SCTIn 	= {}
		elseif (context == "Stat" ) then
			FTC.SCTStat	= {}
		end
	end
	
	-- Now loop through damage values, displaying
	for i = 1 , #Damage , 1 do
	
		-- Get the damage container, start recycling at 10
		local container = _G["FTC_SCT"..context..i]
		if ( i > 10 ) then
			local cnum 		= ( i % 10 ) + 1
			container = _G["FTC_SCT"..context..cnum]
		end
		
		-- Hide damage more than 3 seconds old
		local lifespan	= gameTime - Damage[i].ms
		if ( lifespan > 3000 ) then
			container:SetHidden(true)
		
		-- Otherwise show it, and scroll it
		else
		
			-- Setup defaults
			local damage 	= Damage[i].dam
			local name		= Damage[i].name
			local alpha  	= 1
			container:SetFont("ZoFontHeader2")
			
			-- Flag critical hits
			if ( Damage[i].crit == true ) then
				damage 	= "*" .. damage .. "*"
				container:SetFont("ZoFontHeader3")
			end
			
			-- Flag blocked damage
			if ( Damage[i].blocked == true ) then
				damage	= "(" .. damage .. ")"
			end
			
			-- Flag damage immunity
			if ( Damage[i].immune == true ) then
				damage	= "(Immune)"
			end
			
			-- Resource Alerts (Health = 998 , Stamina = 1006 , Magicka = 1000, Execute = 1001 )
			if ( Damage[i].type == 998 or Damage[i].type == 999 ) then
				container:SetColor(0.8,0,0,1)
				container:SetFont("ZoFontBookTablet")
			elseif ( Damage[i].type == 1006 or Damage[i].type == 1007 ) then
				container:SetColor(0.4,0.8,0.4,1)
				container:SetFont("ZoFontBookTablet")
			elseif ( Damage[i].type == 1000 or Damage[i].type == 1001 ) then
				container:SetColor(0.2,0.6,0.8,1)
				container:SetFont("ZoFontBookTablet")
		
			-- Experience
			elseif ( Damage[i].type == 2000 or Damage[i].type == 2001 ) then
				damage	= "|c99FFFF+" .. damage .. "|"				
			
			-- Flag heals
			elseif( Damage[i].heal == true ) then
				damage = "|c99DD93" .. damage .. "|"
				if string.match( Damage[i].name , "Potion" ) then Damage[i].name = "Health Potion" end
			
			-- Magic damage
			elseif ( Damage[i].type ~= DAMAGE_TYPE_PHYSICAL	) then
				damage = ( context == "Out" ) and "|c336699" .. damage .. "|" or "|c990000" .. damage .. "|"
			
			-- Standard hits
			else
				damage = ( context == "Out" ) and "|cAA9F83" .. damage .. "|" or "|c990000" .. damage .. "|"
			end
			
			-- Maybe add the ability name
			if ( FTC.vars.SCTNames ) then
				damage = damage .. "   " .. name
			end
			
			-- Add the multiplier
			if ( Damage[i].multi and Damage[i].multi > 1 ) then
				damage = damage .. " (x" .. Damage[i].multi .. ")"
			end
			
			-- Update the damage
			container:SetHidden(false)
			container:SetText( damage )	
			
			-- Scroll the position
			local offsety = 25
			if ( i % 2 == 0 ) then
				offsety = 0
			elseif ( i % 3 == 0 ) then
				offsety = -25
			end
			offsety	= offsety -( lifespan / ( 11 - speed ) )

			-- Adjust the position
			container:SetAnchor(BOTTOM,Parent,BOTTOM,0,offsety)
		end
	end
end

--[[ 
 * Adds the new SCT damage to the combat meter for processing
 ]]--
function FTC:UpdateMeter( context , target , name , damage , gametime , heal )
	
	-- Retrieve the data
	local meter = FTC.Damage.Meter
	
	-- If the meter has been inactive for over 5 seconds, restart the timer
	if ( meter == nil ) then
		meter.endTime 	= 0
		meter.startTime = 0
	end
	
	-- If the meter has been inactive for over 5 seconds, reset the data
	if( ( ( gametime - meter.endTime ) / 1000 ) >= 5 ) then
		meter.startTime = gametime
		meter.damage	= 0
		meter.maxDamage	= 0
		meter.healing	= 0
		meter.maxHeal	= 0
		meter.incoming	= 0
		meter.maxInc	= 0
		meter.targets	= {}
	end
	
	-- Track the target (only enemies)
	if ( context == "Out" and heal == false ) then
		meter.targets[target] = ( meter.targets[target] ~= nil ) and meter.targets[target] + damage or damage
	end
	
	-- Incoming Damage
	if ( context == 'In' and heal == false ) then
		meter.incoming 			= meter.incoming + damage
		if ( damage > meter.maxInc ) then
			meter.maxInc		= damage
			meter.maxIncName	= name
		end
	
	-- Outgoing Healing
	elseif ( context == 'Out' and heal == true ) then 
		meter.healing 			= meter.healing + damage
		if ( damage > meter.maxHeal ) then
			meter.maxHeal 		= damage
			meter.maxHealName 	= name
		end
	elseif ( context == 'Out' ) then
		meter.damage = meter.damage + damage
		if ( damage > meter.maxDamage ) then
			meter.maxDamage 	= damage
			meter.maxDamageName = name
		end
	end
	
	-- Stamp the time
	meter.endTime = gametime
	
	-- Send data back to the FTC object
	FTC.Damage.Meter = meter
end
