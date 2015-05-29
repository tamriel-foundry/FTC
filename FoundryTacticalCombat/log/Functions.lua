
--[[----------------------------------------------------------
    COMBAT LOG COMPONENT
  ]]----------------------------------------------------------

	FTC.Log		= {}
	FTC.Log.Defaults = {
	    ["FTC_CombatLog"]         	= {BOTTOMLEFT,FTC_UI,BOTTOMLEFT,24,-6},
	    ["LogWidth"]         		= 450,
	    ["LogHeight"]         		= 300,
	    ["AlternateChat"]         	= true,
	    ["LogFont"]         		= "standard",
	    ["LogFontSize"]         	= 16,
	    ["LogOpacity"]         		= 100,
	}
	FTC:JoinTables(FTC.Defaults,FTC.Log.Defaults)

--[[----------------------------------------------------------
    COMBAT LOG FUNCTIONS
  ]]----------------------------------------------------------

	--[[ 
	 * Initialize Combat Log Component
	 * --------------------------------
	 * Called by FTC:Initialize()
	 * --------------------------------
	 ]]--
	function FTC.Log:Initialize()

		-- Load LibMsgWin Library
		LMW = LibStub("LibMsgWin-1.0")

		-- Maybe create the log
		if ( FTC_CombatLog == nil ) then FCL = LMW:CreateMsgWindow("FTC_CombatLog", GetString(FTC_CL_Label) , nil , nil ) end
		FCL:SetDimensions(FTC.Vars.LogWidth,FTC.Vars.LogHeight)
		FCL:SetParent(FTC_UI)
		FCL:ClearAnchors()
		FCL:SetAnchor(unpack(FTC.Vars.FTC_CombatLog))
		FCL:SetClampedToScreen(false)
	    FCL:SetHandler( "OnMouseUp", function() FTC.Menu:MoveLog() end )
		
		-- Change the styling
		FCL.buffer = _G["FTC_CombatLogBuffer"]
		FCL.buffer:SetFont(FTC.UI:Font(FTC.Vars.LogFont,FTC.Vars.LogFontSize,true))
		FCL.buffer:SetMaxHistoryLines(1000)
		FTC_CombatLogLabel:SetFont(FTC.UI:Font(FTC.Vars.LogFont,FTC.Vars.LogFontSize+2,true))
		FTC_CombatLogBg:SetAlpha(FTC.Vars.LogOpacity/100)

		-- Save initialization status
		FTC.init.Log = true

		-- Hook into chat system
		ZO_PreHook(CHAT_SYSTEM, "Minimize", function() FTC.Log:SetupChat( false ) end)
		ZO_PreHook(CHAT_SYSTEM, "Maximize", function() FTC.Log:SetupChat( true ) end)
		
	end

	--[[ 
	 * Setup Combat Log Interaction with Chat
	 * --------------------------------
	 * Called by FTC.Log:Initialize()
	 * --------------------------------
	 ]]--
	function FTC.Log:SetupChat( chatShown )

		-- Toggle visibility with chat
		if ( FTC.Vars.AlternateChat ) then FTC_CombatLog:SetHidden( chatShown ) end

		-- Always show in move mode
		if ( FTC.move ) then FTC_CombatLog:SetHidden(false) end
	end


	--[[ 
	 * Setup Combat Log Interaction with Chat
	 * --------------------------------
	 * Called by FTC.Log:Initialize()
	 * --------------------------------
	 ]]--
	function FTC.Log:Toggle()

		-- Toggle alternating with chat
		if ( FTC.Vars.AlternateChat ) then 
			if ( CHAT_SYSTEM:IsMinimized() ) then CHAT_SYSTEM:Maximize()
			else CHAT_SYSTEM:Minimize() end
		
		-- Toggle normally
		else FTC_CombatLog:SetHidden(not FTC_CombatLog:IsHidden()) end
	end

	--[[ 
	 * Print Message to Log
	 * --------------------------------
	 * Called by FTC.Log:Damage()
	 * --------------------------------
	 ]]--
	function FTC.Log:Print( message , color )

		-- Get the log
		local log 	= _G["FTC_CombatLog"]

		-- Validate args
		if ( message == nil ) then return end
		local color = color or {0.6,0.6,0.6}

		-- Get the timestamp
		local time	= "|c666666["..GetTimeString().."]|r "

		-- Write to the log
		log:AddText( time .. message , unpack(color) )
	end

	--[[ 
	 * Write Combat Log Damage Events
	 * --------------------------------
	 * Called by FTC:OnCombatEvent()
	 * --------------------------------
	 ]]--
	function FTC.Log:CombatEvent( damage )

		-- Death
		if ( damage.result == ACTION_RESULT_DIED or damage.result == ACTION_RESULT_DIED_XP ) then
			FTC.Log:Print( "You killed " .. zo_strformat("<<!aC:1>>",damage.target) , {0.6,0.6,0.6} )

		-- Shielding
		elseif ( damage.result == ACTION_RESULT_DAMAGE_SHIELDED ) then
			local subject = damage.out and zo_strformat("<<!aCg:1>>",damage.target) or "Your"
			FTC.Log:Print(subject .. " shield absorbed  |cEEEEEE" .. FTC.DisplayNumber(damage.value) .. "|r damage." , {0.6,0.2,0.6} )

	    -- Blocks
	    elseif ( damage.result == ACTION_RESULT_BLOCKED_DAMAGE ) then
	        local subject = damage.out and zo_strformat("<<!aCg:1>>",damage.target) or "You"
			local ability = damage.out and zo_strformat("<<!aC:1>> ",damage.ability) or ""
	        FTC.Log:Print(subject .. " blocked " .. ability .. "taking |cEEEEEE" .. FTC.DisplayNumber(damage.value) .. "|r damage." , {0.6,0.1,0} )

	    -- Dodges
	    elseif ( damage.result == ACTION_RESULT_DODGED or damage.result == ACTION_RESULT_MISS ) then
	        local subject = damage.out and zo_strformat("<<!aCg:1>>",damage.target) or "You"
			local ability = damage.out and zo_strformat("<<!aC:1>> ",damage.ability) or ""
	        FTC.Log:Print(subject .. " dodged " .. ability .. "taking no damage." , {0.4,0.4,1.0} )

		-- Damage
		elseif ( damage.value ~= 0 ) then

			-- Determine the action
			local subject 	= "You "
			local verb		= damage.heal and "healed" or "hit"
			verb			= damage.crit and "critically " .. verb or verb
			verb			= ( not damage.out ) and "were " .. verb or verb

			-- Determine the target
			local target	= ( damage.out and damage.target ~= "" ) and zo_strformat(" <<!aC:1>>",damage.target) or ""
			target 			= ( damage.out and ( target == FTC.Player.name ) ) and " yourself" or target

			-- Determine the ability used
			local ability	= ""
			if ( damage.ability ~= "" ) then
				ability = ( damage.out ) and zo_strformat(" with <<!aC:1>>",damage.ability) or zo_strformat(" by <<!aC:1>>",damage.ability)
			end

			-- Determine the damage done
			local dtype		= damage.heal and " health" or " damage"
			local amount	= " for |cEEEEEE" .. FTC.DisplayNumber(damage.value) .. "|r" .. dtype .. "."

			-- Ignore Sprinting and Crouching
			if ( ability == GetAbilityName(15356) or ability == GetAbilityName(20301) ) then return end

			-- Outgoing damage
			local color = {1,1,1}
			if ( damage.out ) then color = {0.8,0.6,0.2} end
			if ( damage.out and damage.crit ) then color = {0.9,0.7,0.4} end

			-- Incoming damage
			if ( not damage.out ) then color = {0.8,0,0} end
			if ( ( not damage.out ) and damage.crit ) then color = {0.9,0,0} end

			-- Healing
			if ( damage.heal ) then color = {0.6,0.8,0.2} end
			if ( damage.heal and damage.crit ) then color = {0.7,0.9,0.4} end

			-- Construct the message
			FTC.Log:Print( subject .. verb .. target .. ability .. amount , color )
		end
	end

	--[[ 
	 * Write Combat Log Experience
	 * --------------------------------
	 * Called by FTC.OnXPUpdate()
	 * --------------------------------
	 ]]--
	function FTC.Log:Exp( currentExp , reason )

		-- Get the new experience amount
		local diff = math.max( currentExp - FTC.Player.exp , 0 ) 
		if ( diff <= 0 ) then return end

		-- Determine label
		local label = ""
		if ( reason == PROGRESS_REASON_KILL ) then label = " kill "
		elseif ( reason == PROGRESS_REASON_QUEST ) then label = " quest "
		else label = " bonus " end

		-- Print to log
		FTC.Log:Print( "You earned " .. FTC.DisplayNumber(diff) .. label .. "experience." , {0,0.6,0.6} )	
	end