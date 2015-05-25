 
--[[----------------------------------------------------------
    DAMAGE STATISTICS COMPONENT
  ]]----------------------------------------------------------
    FTC.Stats = {}
    FTC.Stats.Defaults = {
		["FTC_MiniMeter"]           = {BOTTOM,BOTTOM,0,-80},
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
		FTC.Stats.DamageTargets			= {}
		FTC.Stats.HealingTargets		= {}

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

		-- If we are past the timeout threshold, reset the tables
		if( ( ( damage.ms - FTC.Stats.endTime ) / 1000 ) >= FTC.Vars.DamageTimeout ) then
			if ( damage.heal and not FTC.Vars.StatTriggerHeals ) then return end
			FTC.Stats:Reset()
		end

		-- Add damage value to tracker
		if ( damage.heal ) then FTC.Stats.healing = FTC.Stats.healing + damage.value
		else FTC.Stats.damage = FTC.Stats.damage + damage.value end

		-- Flag the time
		FTC.Stats.endTime = damage.ms

		-- Get the tables
		local data = ( damage.heal ) and FTC.Stats.Current.Healing or FTC.Stats.Current.Damage 

		-- Setup some placeholder data
		local ability	= damage.ability

		-- Add data to total
		if ( data.Total[ability] == nil ) then 
			data.Total[ability] = {
				['total']	= damage.value,
				['count']	= 1,
				['crit']	= damage.crit and 1 or 0,
				['max']		= damage.value,
				['icon']	= damage.icon,
			}

		-- Update existing ability
		else
			data.Total[ability].total = data.Total[ability].total + damage.value
			data.Total[ability].count = data.Total[ability].count + 1
			data.Total[ability].crit  = data.Total[ability].crit  + ( damage.crit and 1 or 0 )
			data.Total[ability].max   = math.max(damage.value,data.Total[ability].max)
		end

		-- Maybe set up new target
		local target = damage.target
		if ( data[target] == nil ) then data[target] = {} end

		-- Add new ability to target
		if ( data[target][ability] == nil ) then 
			data[target][ability] = {
				['total']	= damage.value,
				['count']	= 1,
				['crit']	= damage.crit and 1 or 0,
				['max']		= damage.value,
				['icon']	= damage.icon,
			}

		-- Update existing ability
		else
			data[target][ability].total = data[target][ability].total + damage.value
			data[target][ability].count = data[target][ability].count + 1
			data[target][ability].crit  = data[target][ability].crit  + ( damage.crit and 1 or 0 )
			data[target][ability].max   = math.max(damage.value,data[target][ability].max)
		end
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

--[[----------------------------------------------------------
    REPORT FUNCTIONS
  ]]----------------------------------------------------------


    --[[ 
     * Toggle Visibility of Report
     * --------------------------------
     * Called by 
     * --------------------------------
     ]]--
	function FTC.Stats:Toggle()

		-- Bail if damage is disabled
		if ( not FTC.Vars.EnableStats ) then return end
		
		-- Determine wether the report is currently shown
		local hide = FTC_Report:IsHidden()

		-- Maybe setup the report
		if ( hide ) then 
			FTC.Stats.TargetPool:ReleaseAllObjects()
			FTC.Stats.AbilityPool:ReleaseAllObjects()
			FTC.Stats:SetupReport("Damage") 
			FTC.Stats:SetupReport("Healing") 
		end

		-- Toggle visibility
		FTC_UI:SetHidden(hide)
		FTC_Report:SetHidden(not hide)
		SetGameCameraUIMode(hide)
	end

    --[[ 
     * Setup Damage Report
     * --------------------------------
     * Called by FTC.Stats:Toggle()
     * --------------------------------
     ]]--
	function FTC.Stats:SetupReport( context )

		-- Hide expanded abilities
		FTC_Report_Ability:SetHidden(true)

		-- Flag if there is no damage to display
		local nodamage  = ( FTC.Stats[string.lower(context)] == 0 ) 

		-- Compute index of targets
		local targets = {}
		for target , abilities in pairs(FTC.Stats.Current[context]) do
			
			-- Calculate total damage dealt to target
			local damage = 0
			for ability , stats in pairs(abilities) do
				damage = damage + stats.total
			end

			-- Setup some data
			local data = {
				["name"]	= target,
				["damage"] 	= damage,
			}

			-- Add the target to an index table
			table.insert(targets,data)
		end

		-- Sort targets based on total damage
		table.sort( targets , FTC.Stats.SortDamage )

		-- Remove total if there is only one target
		if ( #targets == 2 ) then table.remove(targets,1) end
		FTC.Stats[context.."Targets"] = targets

		-- Loop over targets, setting up controls
		local anchor = _G["FTC_Report_"..context.."Title"]
		for i = 1 , math.min(#targets,5) do

			-- Get a control from the pool
			local control, objectKey = FTC.Stats.TargetPool:AcquireObject()
			control.id = objectKey
			
			-- Assign data
			local target = targets[i]
			control.target = target.name
			control.context = context

			-- Compute DPS
			local time = math.max(( FTC.Stats.endTime - FTC.Stats.startTime ) / 1000 , 1)
			local dps  = zo_roundToNearest( target.damage / time , 0.01 )
			local pct  = zo_roundToNearest( target.damage * 100 / FTC.Stats[string.lower(context)] , 0.1 )

			-- Set Labels
			if ( nodamage ) then 
				local name = ( context == "Damage" ) and GetString(FTC_NoDamage) or GetString(FTC_NoHealing)
				control.name:SetText(name)
				control.total:SetText()
				control.dps:SetText()
				control.expand:SetState(BSTATE_DISABLED)
			else
				local name = target.name == "Total" and GetString(FTC_AllTargets) or zo_strformat("<<!aC:1>>",target.name)
				control.name:SetText(name)
				local damname = ( context == "Damage" ) and GetString(FTC_Damage) or GetString(FTC_Healing)
				control.total:SetText(CommaValue(target.damage) .. " " .. damname .. " |cAAAAAA(" .. pct .. "%)|r")
				local dpsname = ( context == "Damage" ) and GetString(FTC_DPS) or GetString(FTC_HPS)
				control.dps:SetText(CommaValue(string.format("%.2f",dps)) .. " " .. dpsname)
				control.expand:SetState(BSTATE_ENABLED)
			end

			-- Reset Button
			control.expand:SetState(BSTATE_NORMAL)
			control.state = "collapsed"

			-- Set Anchors
			control:SetHeight(50)
			control:ClearAnchors()
			control:SetAnchor(TOP,anchor,BOTTOM,0,25)
			anchor = control

			-- Display
			control:SetHidden(false)
		end

		-- Maybe move healing header
		if ( context == "Damage" ) then 
			FTC_Report_HealingTitle:ClearAnchors()
			FTC_Report_HealingTitle:SetAnchor(TOP,anchor,BOTTOM,0,25)
		end
	end


	--[[ 
	 * Expand Target Abilities
	 * --------------------------------
	 * Called by FTC.Stats.CreateTarget()
	 * --------------------------------
	 ]]--
	function FTC.Stats.ExpandTarget( self ) 

		-- Get data
		local parent 	= self:GetParent()
		local state 	= parent.state
		local target 	= parent.target
		local context	= parent.context
		local container	= FTC_Report_Ability

		-- Release existing objects
		FTC.Stats.AbilityPool:ReleaseAllObjects()

		-- Maybe Collapse
		local isExpanded = not container:IsHidden()
		local oldButton  = nil
		if ( isExpanded ) then

			-- Get the old parent
			local _ , _ , oldParent = FTC_Report_Ability:GetAnchor()
			oldButton = oldParent.expand

			-- Set the button state 
			oldButton:SetState(BSTATE_DISABLED)

			-- Expand the parent container
			oldParent:SetHeight(50)
			container:SetHidden(true)

			-- Restore the button state
			oldButton:SetState(BSTATE_NORMAL)
			oldParent.state = "collapsed"
		end

		-- Maybe Expand
		if ( self ~= oldButton and parent.state == "collapsed" ) then 

			-- Set the button state
			self:SetState(BSTATE_DISABLED_PRESSED)
			parent.state = "disabled"

			-- Compute index of abilities
			local abilities = {}
			for ability , stats in pairs(FTC.Stats.Current[context][target]) do
				
				-- Setup some data
				local data = {
					["name"]	= ability,
					["damage"] 	= stats.total,
				}

				-- Add the target to an index table
				table.insert(abilities,data)
			end

			-- Sort targets based on total damage
			table.sort( abilities , FTC.Stats.SortDamage )

			-- Get total damage for the target
			local tarTotal = 0
			local targets = FTC.Stats[context.."Targets"]
			for i = 1 , #targets do 
				if ( targets[i].name == target ) then tarTotal = targets[i].damage end
			end

			-- Setup the display of abilities
			local anchor = {TOP,FTC_Report_Ability_Header,BOTTOM,0,0}
			for i = 1 , math.min(#abilities,10) do

				-- Get the ability
				local name		= abilities[i].name
				local ability 	= FTC.Stats.Current[context][target][name]

				-- Get a control from the pool
				local control, objectKey = FTC.Stats.AbilityPool:AcquireObject()
				control.id = objectKey

				-- Compute data
				local time 	= math.max(( FTC.Stats.endTime - FTC.Stats.startTime ) / 1000 , 1)
				local dps 	= zo_roundToNearest( ability.total / time , 0.01 )
				local crit	= math.max(zo_roundToNearest( ( ability.crit * 100 / ability.count ) , 0.1 ),0)
				local pct	= zo_roundToNearest( ability.total * 100 / tarTotal , 0.1 )

				-- Set data
				control.icon:SetTexture(ability.icon)
				control.name:SetText(zo_strformat("<<!aC:1>>",name))
				control.count:SetText(ability.count)
				control.total:SetText(CommaValue(ability.total) .. " |cAAAAAA(" .. pct .. "%)|r")
				control.dps:SetText(CommaValue(dps))
				control.crit:SetText(crit.."%")
				control.max:SetText(CommaValue(ability.max))

				-- Set Anchors
				control:ClearAnchors()
				control:SetAnchor(unpack(anchor))
				anchor = {TOP,control,BOTTOM,0,10}

				-- Display
				control:SetHidden(false)
			end			

			-- Modify header labels
			container.header.total:SetText( ( context == "Damage" ) and GetString(FTC_Damage) or GetString(FTC_Healing) )
			container.header.dps:SetText( ( context == "Damage" ) and GetString(FTC_DPS) or GetString(FTC_HPS) )

			-- Expand the parent container
			parent:SetHeight((math.min(#abilities,10)+2)*60)
			container:ClearAnchors()
			container:SetAnchor(TOP,parent,TOP,0,60)
			container:SetHidden(false)

			-- Restore the button state
			self:SetState(BSTATE_PRESSED)
			parent.state = "expanded"
		end

		-- Maybe hide some elements
		for _ , control in pairs(FTC.Stats.TargetPool.m_Active) do
			control:SetHidden( control ~= parent and control:GetBottom() > FTC_Report:GetBottom() )
		end
		FTC_Report_HealingTitle:SetHidden( FTC_Report_HealingTitle:GetBottom() > FTC_Report:GetBottom() )
	end

    --[[ 
     * Sort By Damage
     * --------------------------------
     * Called by FTC.Stats:SetupReport()
     * --------------------------------
     ]]--
	function FTC.Stats.SortDamage(x,y)

        if ( x.name == "Total" ) then return true
        elseif ( y.name == "Total" ) then return false 
        else return x.damage > y.damage end
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