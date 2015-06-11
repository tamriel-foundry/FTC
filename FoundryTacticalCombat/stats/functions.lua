 
--[[----------------------------------------------------------
    DAMAGE STATISTICS COMPONENT
  ]]----------------------------------------------------------
    local FTC = FTC
    FTC.Stats = {}
    FTC.Stats.Defaults = {
		["FTC_MiniMeter"]           = {BOTTOM,BOTTOM,0,-80},
		["FTC_GroupDPS"]            = {TOPLEFT,TOPLEFT,300,10},
		["DamageTimeout"]           = 5,
		["StatTriggerHeals"]        = false,
		["StatsShareDPS"]			= false,
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
   		FTC.Stats.lastPing = 0
		FTC.Stats.groupDPS = {}

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
   		FTC.Stats.lastPing  = 0
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

		-- Don't register anything if the player is out of combat
		if ( damage.heal and not IsUnitInCombat('player') ) then return end

		-- If we are past the timeout threshold, reset the tables
		if( ( ( damage.ms - FTC.Stats.endTime ) / 1000 ) >= FTC.Vars.DamageTimeout ) then
			if ( damage.heal and FTC.Vars.StatTriggerHeals == false ) then return end
			FTC.Stats:Reset()
		end

		-- Add damage value to tracker
		if ( damage.heal ) then FTC.Stats.healing = FTC.Stats.healing + damage.value
		else FTC.Stats.damage = FTC.Stats.damage + damage.value end

		-- Flag the time
		if ( ( not damage.heal ) or FTC.Vars.StatTriggerHeals ) then FTC.Stats.endTime = damage.ms end

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
		local dps 	= FTC.DisplayNumber( FTC.Stats.damage  / math.max(time,1) )
		local hps 	= FTC.DisplayNumber( FTC.Stats.healing / math.max(time,1) )
		
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
			SetGameCameraUIMode(true)
		end

		-- Toggle visibility
		FTC_UI:SetHidden(hide)
		FTC_Report:SetHidden(not hide)
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
		local time = math.max(( FTC.Stats.endTime - FTC.Stats.startTime ) / 1000 , 1)
		local anchor = _G["FTC_Report_"..context.."Title"]
		for i = 1 , math.min(#targets,5) do

			-- Get a control from the pool
			local control, objectKey = FTC.Stats.TargetPool:AcquireObject()
			control.id = objectKey
			
			-- Assign data
			local target = targets[i]
			control.target = target.name
			control.context = context

			-- Compute data
			local pct  = FTC.DisplayNumber( target.damage * 100 / FTC.Stats[string.lower(context)] , 1 )

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
				control.total:SetText(FTC.DisplayNumber(target.damage) .. " " .. damname .. " |cAAAAAA(" .. pct .. "%)|r")
				local dpsname = ( context == "Damage" ) and GetString(FTC_DPS) or GetString(FTC_HPS)
				control.dps:SetText(FTC.DisplayNumber(target.damage / time , 2) .. " " .. dpsname)
				control.expand:SetState(BSTATE_ENABLED)
			end

			-- Reset Button
			control.expand:SetState( nodamage and BSTATE_DISABLED or BSTATE_NORMAL )
			control.state = "collapsed"

			-- Post Button
			control.post:SetState( target.damage == 0 and BSTATE_DISABLED or BSTATE_NORMAL)

			-- Set Anchors
			control:SetHeight(50)
			control:ClearAnchors()
			control:SetAnchor(TOP,anchor,BOTTOM,0,25)
			anchor = control

			-- Display
			control:SetHidden(false)
		end

		-- Modify headers
		local targetName = ( #targets > 1 ) and targets[2].name or targets[1].name
		local title	= context == "Damage" and GetString(FTC_DReport) or GetString(FTC_HReport)
		title = ( nodamage ) and title or title .. " - " .. zo_strformat("<<!aC:1>>",targetName) .. " (" .. ZO_FormatTime( time , SI_TIME_FORMAT_TIMESTAMP) .. ")"
		_G["FTC_Report_"..context.."Title"]:SetText(title)
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
				local crit	= FTC.DisplayNumber( math.max((ability.crit * 100 / ability.count ),0),1)
				local pct	= FTC.DisplayNumber( ability.total * 100 / tarTotal , 1 )

				-- Set data
				control.icon:SetTexture(ability.icon)
				control.name:SetText(zo_strformat("<<!aC:1>>",name))
				control.count:SetText(ability.count)
				control.total:SetText(FTC.DisplayNumber(ability.total) .. " |cAAAAAA(" .. pct .. "%)|r")
				control.dps:SetText(FTC.DisplayNumber(ability.total / time,2))
				control.crit:SetText(crit.."%")
				control.avg:SetText(FTC.DisplayNumber(ability.total/ability.count))
				control.max:SetText(FTC.DisplayNumber(ability.max))

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
     * Print Encounter Report to Chat
     * --------------------------------
     * Called by SI_BINDING_NAME_POST_DAMAGE_RESULTS
     * --------------------------------
     ]]--
	function FTC.Stats:Post( button )

		-- Flag if there is no damage to display
		if ( FTC.Stats.damage + FTC.Stats.healing == 0 ) then
			d( "No damage or healing to report!" )
			return
		end 

		-- Setup placeholders
		local tarName 	= nil
		local damage 	= 0
		local time		= math.max(( FTC.Stats.endTime - FTC.Stats.startTime ) / 1000 , 1)
		local context	= "Damage"

		-- Was a specific target requested?
		if ( button ~= nil ) then

			-- Get data
			local parent 	= self:GetParent()
			context			= parent.context
			local Targets	= FTC.Stats[context.."Targets"]
			for i = 1 , #Targets do
				if ( Targets[i].name == parent.target ) then 
					damage = Targets[i].damage 
					break
				end
			end
			tarName 		= ( parent.target ~= "Total" ) and parent.target or nil

		-- Otherwise assume total
		else damage	= FTC.Stats.damage end

		-- Maybe compute the most damaged target
		if ( tarName == nil ) then 
			local targets = {}
			for target , abilities in pairs(FTC.Stats.Current.Damage) do
				
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
			tarName = ( #targets > 2 ) and targets[2].name .. " (+" .. (#targets-2) .. ")" or targets[2].name
		end

		-- Minimize the report if it is shown
		if ( not FTC_Report:IsHidden() ) then FTC.Stats:Toggle() end

		local totalLabel = ( context == "Damage" ) and GetString(FTC_Damage) or GetString(FTC_Healing)
		local dpsLabel   = ( context == "Damage" ) and GetString(FTC_DPS) or GetString(FTC_HPS)

		-- Generate output
		local output 	= "[FTC] " .. zo_strformat("<<!aC:1>>", tarName ) .. " - " .. ZO_FormatTime( time , SI_TIME_FORMAT_TIMESTAMP) .. " - "
		output		 	= output .. FTC.DisplayNumber(damage) .. " " .. totalLabel .. " (" .. FTC.DisplayNumber(damage/time,2) .. " " .. dpsLabel .. ")"
		
		-- Determine appropriate channel
		local channel = IsUnitGrouped('player') and "/p " or "/say "

		-- Print output to chat
		CHAT_SYSTEM.textEntry:SetText( channel .. output )
		CHAT_SYSTEM:Maximize()
		CHAT_SYSTEM.textEntry:Open()
		CHAT_SYSTEM.textEntry:FadeIn()
	end


    --[[ 
     * Send DPS information to group
     * --------------------------------
     * Called by FTC.OnCombatState()
     * --------------------------------
     ]]--
	function FTC.Stats:SendPing()

		-- Bail out if this feature is disabled
		if ( not FTC.Vars.StatsShareDPS ) then return end

		-- Don't ping without damage
		if ( FTC.Stats.damage == 0 ) then return end

		-- Don't spam ping
		if ( math.abs(FTC.Stats.lastPing - FTC.Stats.endTime ) < 250 ) then return end

		-- Compute player statistics
		local time  = math.max( ( FTC.Stats.endTime - FTC.Stats.startTime ) / 1000 , 1 ) 
		local dps 	= FTC.Stats.damage  / time

		-- Don't ping fights less than 10 seconds
		if ( time < 10 ) then return end

		-- Compute map ping offsets
		local timeCoord 	= time/10000
		local dpsCoord		= dps/200000

		-- Send the ping
		PingMap( MAP_PIN_TYPE_PING , MAP_TYPE_LOCATION_CENTERED , timeCoord , dpsCoord )
		FTC.Stats.lastPing = FTC.Stats.endTime
	end

    --[[ 
     * Process recieved DPS information
     * --------------------------------
     * Called by FTC.OnPing()
     * --------------------------------
     ]]--
	function FTC.Stats:AddPing( offsetX, offsetY , pingTag , isOwner )

		-- Bail out if this feature is disabled
		if ( not FTC.Vars.StatsShareDPS ) then return end

		-- Ignore ping terminations
		if ( offsetX == 0 and offsetY == 0 ) then return end

		-- Get data
		local name		= GetUnitName( pingTag )
		local time 		= offsetX * 10000
		local dps 		= offsetY * 200000
		local damage	= dps * time

		-- Only accept pings within a reasonable range
		if ( ( dps < 0 or dps > 100000 ) or ( time < 10 or time > 1200 ) ) then return end

		-- Construct object
		local data = {
			["name"]	= name,
			["damage"] 	= damage,
			["dps"]		= dps,
			["time"]	= time,
			["ms"]		= GetGameTimeMilliseconds(),
		}

		-- Populate data
		FTC.Stats.groupDPS[name] = data

		-- Display control
		FTC.Stats:DisplayGroupDPS()
	end

    --[[ 
     * Render group DPS list
     * --------------------------------
     * Called by FTC.Stats:AddPing()
     * --------------------------------
     ]]--
	function FTC.Stats:DisplayGroupDPS()

		-- Get data
		local data = {}
		local parent = FTC_GroupDPS

		-- Sort in descending order
		for player , damage in pairs(FTC.Stats.groupDPS) do

			-- Throw out any entries from previous fights
			if ( damage.ms < FTC.Stats.startTime ) then FTC.Stats.groupDPS[player] = nil end
			table.insert(data,damage)		
		end	
		table.sort( data , FTC.Stats.SortDamage )

		-- Maybe hide the window
		if ( #data == 0 ) then parent:SetHidden(true) end

		-- Setup labels
		local names 	= ""
		local time 		= ""
		local damage 	= ""
		local dps 		= ""

		-- Print to the group dps window
		for i = 1 , #data do
			names 	= names .. zo_strformat("<<!aC:1>>",data[i].name) .. "\n"
			time 	= time .. ZO_FormatTime(data[i].time,SI_TIME_FORMAT_TIMESTAMP) .. "\n"
			damage 	= damage .. FTC.DisplayNumber( data[i].damage ) .. "\n"
			dps		= dps .. FTC.DisplayNumber( data[i].dps , 2 ) .. "\n"
		end

		-- Apply labels
		parent.names:SetText(names)
		parent.time:SetText(time)
		parent.damage:SetText(damage)
		parent.dps:SetText(dps)

		-- Update height
		local height = 50 + ( #data * 20 )
		parent:SetHeight( height )
		parent.backdrop:SetHeight( height )
		parent:SetHidden(false)

		-- Fade animation
		FTC.Stats:DPSFade()
	end