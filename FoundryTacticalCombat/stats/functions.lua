 
--[[----------------------------------------------------------
    DAMAGE STATISTICS COMPONENT
  ]]----------------------------------------------------------
    FTC.Stats = {}
    FTC.Stats.Defaults = {
		["FTC_MiniMeter"]           = {BOTTOM,TOP,0,-10,ZO_ActionBar1},
		["DamageTimeout"]           = 5,
		["StatTriggerHeals"]        = false,
	}
    FTC:JoinTables(FTC.Defaults,FTC.Stats.Defaults)

--[[----------------------------------------------------------
    DAMAGE STATISTICS FUNCTIONS
  ]]----------------------------------------------------------

    --[[ 
     * Initialize FTC Damage Statistics Component
     * --------------------------------
     * Called by FTC:Initialize()
     * --------------------------------
     ]]--
	function FTC.Stats:Initialize()

        -- Create the controls
        FTC.Stats:Controls()

        -- Setup tables
        FTC.Stats:Reset()
		FTC.Stats.endTime = 0

	    -- Register init status
	    FTC.init.Stats = true

	    -- Activate updating
       EVENT_MANAGER:RegisterForUpdate( "FTC_MiniMeter" , 500 , function() FTC.Stats:Update() end )
	end

    --[[ 
     * Setup a Fresh Encounter
     * --------------------------------
     * Called by FTC.Stats:Initialize()
     * Called by FTC.Stats:RegisterDamage()
     * --------------------------------
     ]]--
	function FTC.Stats:Reset()

		-- Setup tables
		FTC.Stats.Current				= {}
		FTC.Stats.Current.Damage 		= {}
		FTC.Stats.Current.Damage.Total 	= {}
		FTC.Stats.Current.Healing 		= {}
		FTC.Stats.Current.Healing.Total = {}
		FTC.Stats.Current.Incoming 		= {}

		-- Setup flags
		FTC.Stats.damage	= 0
		FTC.Stats.healing	= 0
		FTC.Stats.startTime = GetGameTimeMilliseconds()
		FTC.Stats.endTime 	= GetGameTimeMilliseconds()
	end

--[[----------------------------------------------------------
    EVENT HANDLERS
  ]]----------------------------------------------------------


    --[[ 
     * Store New Damage to Table
     * --------------------------------
     * Called by FTC.Damage:New()
     * --------------------------------
     ]]--
	function FTC.Stats:RegisterDamage(damage)

		-- Get the tables
		local data = FTC.Stats.Current

		-- If we are past the timeout threshold, reset the tables
		if( ( ( damage.ms - FTC.Stats.endTime ) / 1000 ) >= FTC.Vars.DamageTimeout ) then
			FTC.Stats:Reset()
		end

		-- Outgoing damage
		if ( damage.out ) then

			-- Get the target
			local target = damage.target

			-- Maybe set up new target
			if ( data.Damage[target] == nil ) then data.Damage[target] = {} end

			-- Add data to tables
			table.insert(data.Damage.Total,damage)
			table.insert(data.Damage[target],damage)

			-- Add damage value to tracker
			FTC.Stats.damage = FTC.Stats.damage + damage.value

		-- Incoming damage
		else 
			table.insert(data.Incoming,damage)
		end

		-- Flag the time
		FTC.Stats.endTime = damage.ms
	end

    --[[ 
     * Store New Healing
     * --------------------------------
     * Called by FTC.Damage:New()
     * --------------------------------
     ]]--
	function FTC.Stats:RegisterHealing(damage)

		-- Get the tables
		local data = FTC.Stats.Current

		-- Ignore healing outside of the active threshold
		if( ( ( damage.ms - FTC.Stats.endTime ) / 1000 ) >= FTC.Vars.DamageTimeout ) then 
			if ( FTC.Vars.StatTriggerHeals ) then FTC.Stats:Reset()
			else return end
		end

		-- Maybe set up new target
		local target = damage.target
		if ( data.Healing[target] == nil ) then data.Healing[target] = {} end

		-- Add data to tables
		table.insert(data.Healing.Total,damage)
		table.insert(data.Healing[target],damage)

		-- Add healing value to tracker
		FTC.Stats.healing = FTC.Stats.healing + damage.value

		-- Maybe flag the time
		if ( FTC.Vars.StatTriggerHeals ) then FTC.Stats.endTime = damage.ms end
	end

--[[----------------------------------------------------------
    UPDATING FUNCTIONS
  ]]----------------------------------------------------------



    --[[ 
     * Update the mini DPS meter
     * --------------------------------
     * Called by FTC.Stats:Initialize()
     * --------------------------------
     ]]--
	function FTC.Stats:Update()

		-- Bail out if there is no damage to report
		if ( FTC.Stats.damage == 0 and FTC.Stats.healing == 0 ) then return end

		-- Retrieve data
		local mini	= _G["FTC_MiniMeter"]

		-- Compute the fight time
		local time  = ( FTC.Stats.endTime - FTC.Stats.startTime ) / 1000

		-- Determine the correct time label
		local dtime	= (( not IsUnitInCombat('player') ) or ((( GetGameTimeMilliseconds() - FTC.Stats.endTime ) / 1000 ) >= FTC.Vars.DamageTimeout )) and time or ( GetGameTimeMilliseconds() - FTC.Stats.startTime )  / 1000
		local secs	= ZO_FormatTime( dtime , SI_TIME_FORMAT_TIMESTAMP)

		-- Compute player statistics
		local dps 	= CommaValue( zo_round( FTC.Stats.damage / math.max(time,1) ) )
		local hps 	= CommaValue( zo_round( FTC.Stats.healing / math.max(time,1) ) )
		
		-- Update the labels
		mini.damage.label:SetText( dps )
		mini.healing.label:SetText( hps )
		mini.time.label:SetText( secs )
	end






























































	 --[[ 
	 * Process new combat events passed from the combat event handler
	 * Called by OnCombatEvent()
	 ]]--
	function FTC.Damage:UpdateMeter( newDamage , context )

		-- Retrieve the data
		local meter		= FTC.Damage.Meter
		local damage	= newDamage.dam
		local name		= newDamage.name
		local target	= newDamage.target
		local source	= newDamage.source
		
		-- If the meter is inactive, don't start it for heals
		if ( meter.endTime == 0 and newDamage.heal ) then return end
		
		-- If the meter has been inactive for over X seconds
		if( ( ( newDamage.ms - meter.endTime ) / 1000 ) >= FTC.vars.DamageTimeout ) then
			
			-- If it's a new source of damage, reset the meter
			if ( not newDamage.heal ) then
				FTC.Damage:Reset()
				meter				= FTC.Damage.Meter
				meter.startTime 	= newDamage.ms
				
			-- Otherwise, bail out
			else return end
		end
		
		-- Process outgoing healing events
		if ( newDamage.heal and context == "Out") then
			
			-- Update meter
			meter.healing			= meter.healing + damage
			if ( damage > meter.maxHeal ) then
				meter.maxHeal		= damage
				meter.maxHealName 	= name			
			end
			
			-- Track ability
			if ( FTC.Damage.Heals[name] ~= nil ) then
				FTC.Damage.Heals[name].total 	= FTC.Damage.Heals[name].total + damage
				FTC.Damage.Heals[name].count 	= FTC.Damage.Heals[name].count + 1
				FTC.Damage.Heals[name].crit		= newDamage.crit and FTC.Damage.Heals[name].crit + 1 or FTC.Damage.Heals[name].crit
			else
				FTC.Damage.Heals[name] 	= {
					["total"]			= damage,
					["count"]			= 1,
					["crit"]			= newDamage.crit and 1 or 0,			
				}
			end
		
		-- Process outgoing damage events
		elseif ( context == "Out" ) then
				
			-- Update meter
			meter.damage			= meter.damage + damage
			if ( damage > meter.maxDam ) then
				meter.maxDam		= damage
				meter.maxDamName 	= name			
			end

			-- Track ability
			if ( FTC.Damage.Damages[name] ~= nil ) then
				FTC.Damage.Damages[name].total 	= FTC.Damage.Damages[name].total + damage
				FTC.Damage.Damages[name].count 	= FTC.Damage.Damages[name].count + 1
				FTC.Damage.Damages[name].crit	= newDamage.crit and FTC.Damage.Damages[name].crit + 1 or FTC.Damage.Damages[name].crit
			else
				FTC.Damage.Damages[name] 	= {
					["total"]			= damage,
					["count"]			= 1,
					["crit"]			= newDamage.crit and 1 or 0,			
				}
			end
			
			-- Track target
			FTC.Damage.Targets[target]	= ( FTC.Damage.Targets[target] ~= nil ) and FTC.Damage.Targets[target] + damage or damage
		
		-- Process incoming damage events
		elseif ( context == "In" ) then
		
			-- Update meter
			meter.incoming					= meter.incoming + damage
			if ( damage > meter.maxInc ) then
				meter.maxInc				= damage		
			end	
		end
		
		-- Stamp the time (but not for heals)
		if ( not newDamage.heal ) then meter.endTime = newDamage.ms end
		
		-- Return data back to the meter
		FTC.Damage.Meter = meter	
	end


--[[ 
 * Loads updated combat meter data and displays it to the frame
 * Toggles the meter off if it is already shown and no update is ready
 ]]--
function FTC.Damage:Display()
	
	-- Get the damage meter container
	local parent 	= _G["FTC_Meter"]
	local title 	= _G["FTC_MeterTitle"]
	
	-- Grab elements
	local meter 	= FTC.Damage.Meter
	local header 	= "FTC Damage Meter"
	
	-- Compute the most damaged target
	local most_damaged_target = ""
	local most_damage = 0
	for k,v in pairs( FTC.Damage.Targets ) do
		if ( v > most_damage ) then
			most_damage = v
			most_damaged_target = k
		end
	end
	
	-- Compute the fight time
	local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )
	
	-- Generate a title
	if ( meter.damage + meter.healing == 0 ) then
		header = header ..  " - No Combat Recorded"
	else
		header = header .. " - " .. most_damaged_target .. " (" .. string.format( "%.1f" , fight_time ) .. " seconds)"
	end
	
	--[[----------------------------------
		OUTGOING DAMAGE
	  ]]----------------------------------
	local dps = string.format( "%.2f" , meter.damage/fight_time )
	
	-- Set Header
	local head	= ( meter.damage > 0 ) and CommaValue( meter.damage ) .. " Total Damage (" .. dps .. " DPS)" or "No Outgoing Damage"
	FTC_MeterDamage_Title:SetText( head )
	
	-- Sort damaging abilities
	local damages = {}
	for k,v in pairs( FTC.Damage.Damages ) do
		v.name = k
		table.insert( damages , v ) 
	end
	table.sort( damages , function(x,y) return x.total > y.total end )

	local ndamage = math.min( #damages , 10 )
	for i = 1 , ndamage do
		
		-- Get elements
		local line	= _G["FTC_MeterDamage_"..i]
		local left	= _G["FTC_MeterDamage_"..i.."Left"]
		local right	= _G["FTC_MeterDamage_"..i.."Right"]
		
		-- Get data
		local total	= CommaValue( damages[i].total )
		local count	= damages[i].count
		local crit	= math.floor( ( damages[i].crit / count ) * 100 )
		local adps	= string.format( "%.2f" , damages[i].total/fight_time )
		local pdps	= math.floor( ( adps / dps ) * 100 )
		
		-- Add data
		line:SetHidden(false)
		left:SetText( damages[i].name .. " - " .. total .. " Damage || " .. count .. " Hits || " .. crit .. "% Crit" )
		right:SetText( "(" .. pdps .. "%) " .. adps .. " DPS" )
	end
	
	-- Hide unused lines
	for i = ndamage + 1 , 10 do
		local line 	= _G["FTC_MeterDamage_"..i]
		line:SetHidden(true)
	end
	
	-- Change the element height
	FTC_MeterDamage:SetHeight( 50 + ( math.min(#damages,10) * 24 ) )
	
	--[[----------------------------------
		OUTGOING HEALING
	  ]]----------------------------------		
	local hps = string.format( "%.2f" , meter.healing/fight_time )
	
	-- Set Header
	local head	= ( meter.healing > 0 ) and CommaValue( meter.healing ) .. " Total Healing (" .. hps .. " HPS)" or "No Outgoing Healing"
	FTC_MeterHealing_Title:SetText( head )
	
	-- Sort damaging abilities
	local heals = {}
	for k,v in pairs( FTC.Damage.Heals ) do
		v.name = k
		table.insert( heals , v ) 
	end
	table.sort( heals , function(x,y) return x.total > y.total end )	

	local nheals = math.min( #heals , 10 )
	for i = 1 , nheals do
		
		-- Get elements
		local line	= _G["FTC_MeterHealing_"..i]
		local left	= _G["FTC_MeterHealing_"..i.."Left"]
		local right	= _G["FTC_MeterHealing_"..i.."Right"]
		
		-- Get data
		local total	= CommaValue( heals[i].total )
		local count	= damages[i].count
		local crit	= math.floor( ( heals[i].crit / count ) * 100 )
		local ahps	= string.format( "%.2f" , heals[i].total/fight_time )
		local phps	= math.floor( ( ahps / hps ) * 100 )
		
		-- Add data
		line:SetHidden(false)
		left:SetText( heals[i].name .. " - " .. total .. " Healing || " .. count .. " Hits || " .. crit .. "% Crit")
		right:SetText( "(" .. phps .. "%) " .. ahps .. " HPS" )
	end
	
	-- Hide unused lines
	for i = nheals + 1 , 10 do
		local line 	= _G["FTC_MeterHealing_"..i]
		line:SetHidden(true)	
	end	

	-- Change the element height
	FTC_MeterHealing:SetHeight( 50 + ( #heals * 24 ) )		
	
	--[[----------------------------------
		INCOMING DAMAGE
	  ]]----------------------------------			
	local ips = string.format( "%.2f" , meter.incoming/fight_time )
	
	-- Set Header
	local head	= ( meter.incoming > 0 ) and CommaValue( meter.incoming ) .. " Incoming Damage (" .. ips .. " IPS)" or "No Incoming Damage"
	FTC_MeterIncoming_Title:SetText( head )
	
	--[[----------------------------------
		ADJUST DISPLAY
	  ]]----------------------------------		 
	local height = 60 + FTC_MeterDamage:GetHeight() + FTC_MeterHealing:GetHeight() + 60 
	parent:SetHeight( height )
	parent.backdrop:SetHeight( height )
	title:SetText(header)
end







--[[ 
 * Reset the damage meter
 ]]--
function FTC.Damage:Reset()

	-- Setup damage overview
	FTC.Damage.Meter 	= {
		['damage']		= 0,
		['maxDam']		= 0,
		['maxDamName']	= "",
		['healing']		= 0,
		['maxHeal']		= 0,
		['maxHealName']	= "",
		['incoming']	= 0,
		['maxInc']		= 0,
		['startTime']	= 0,
		['endTime']		= 0,
	}
	
	-- Setup damaged target tracking
	FTC.Damage.Targets 	= {}
	
	-- Setup damage ability tracking
	FTC.Damage.Damages	= {}
	
	-- Setup healing ability tracking
	FTC.Damage.Heals	= {}
end




--[[ 
 * Reset the damage meter
 ]]--
function FTC.Damage:ToggleMeter()

	-- Bail if damage is disabled
	if ( not FTC.vars.EnableDamage ) then return end
	
	-- Get the elements
	local mini 	= _G["FTC_MiniMeter"]
	local full	= _G["FTC_Meter"]
	
	-- Maybe update
	if ( full:IsHidden() ) then FTC.Damage:Display() end
	
	-- Toggle visibility
	mini:SetHidden( full:IsHidden() )
	full:SetHidden( not full:IsHidden() )

end

--[[ 
 * Print damage output to chat
 ]]--
function FTC.Damage:Post( context )

	-- Retrieve the data
	local meter = FTC.Damage.Meter
	
	-- Make sure there's something to report
	if ( meter.damage + meter.healing == 0 ) then 
		d( "No damage to report!" ) 
		return
	end

	-- Compute the most damaged target
	local most_damaged_target = ""
	local most_damage = 0
	for k,v in pairs( FTC.Damage.Targets ) do
		if ( v > most_damage ) then
			most_damage = v
			most_damaged_target = k
		end
	end
	
	-- Sanitize the name
	local name = SanitizeLocalization( most_damaged_target )
	
	-- Compute the fight time
	local total = 0
	local metric = 0
	local fight_time = math.max( ( meter.endTime - meter.startTime ) / 1000 , 1 )
	local label = ""

	-- Generate output
	if ( 'damage' == context ) then
		total 	= meter.damage
		metric	= string.format( "%.1f" , total / fight_time )
		label 	= name .. " (" .. string.format( "%.1f" , fight_time ) .. "s) || " .. CommaValue(total) .. " Total Damage " .. " (" .. metric .. " DPS)"

	elseif ( 'healing' == context ) then
		total 	= meter.healing
		metric	= string.format( "%.1f" , total / fight_time )
		label 	= name .. " (" .. string.format( "%.1f" , fight_time ) .. "s) || " .. CommaValue(total) .. " Total Healing " .. " (" .. metric .. " HPS)"
	end
	
	-- Determine appropriate channel
	local channel = IsUnitGrouped('player') and "/p " or "/say "

	-- Print output to chat
	CHAT_SYSTEM.textEntry:SetText( channel .. label )
end