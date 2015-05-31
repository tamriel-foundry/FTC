
--[[----------------------------------------------------------
    CORE UI CONTROLS
  ]]----------------------------------------------------------

	--[[ 
	 * Create Common Controls
	 * --------------------------------
	 * Called by FTC.UI:Initialize()
	 * --------------------------------
	 ]]--
	function FTC.UI:Controls()

        -- Create a parent FTC window
        FTC.UI:TopLevelWindow( "FTC_UI" , GuiRoot , {GuiRoot:GetWidth(),GuiRoot:GetHeight()} , {CENTER,CENTER,0,0} , false )

		-- Load LibMsgWin Library
		LMW = LibStub("LibMsgWin-1.0")

		-- Create the welcome window
		welcome = LMW:CreateMsgWindow("FTC_Welcome", GetString(FTC_ShortInfo) , nil , nil )
		welcome:SetDimensions(1000,math.min(1000,GuiRoot:GetHeight()*0.8))
		welcome:ClearAnchors()
		welcome:SetAnchor(TOP,ZO_CompassFrame,BOTTOM,0,20)
		welcome:SetMouseEnabled(false)
		welcome:SetHidden(true)

		-- Create close button
		welcome.close = FTC.UI:Button( "FTC_WelcomeClose", welcome, {48,48}, {TOPRIGHT,TOPRIGHT,0,6}, BSTATE_NORMAL, nil, nil, nil, nil, nil, false )
		welcome.close:SetNormalTexture('/esoui/art/buttons/closebutton_up.dds')
		welcome.close:SetMouseOverTexture('/esoui/art/buttons/closebutton_mouseover.dds')
		welcome.close:SetHandler("OnClicked", FTC.Welcome )
		
		-- Change the styling
		welcome.buffer = _G["FTC_WelcomeBuffer"]
		welcome.buffer:SetFont(FTC.UI:Font("standard",18,true))
		welcome.buffer:SetMaxHistoryLines(1000)
		FTC_WelcomeLabel:SetFont(FTC.UI:Font("esobold",28,true))
		FTC_WelcomeSlider:SetHidden(false)
	end

	--[[ 
	 * Add Welcome Message
	 * --------------------------------
	 * Called by FTC.UI:Controls()
	 * --------------------------------
	 ]]--
	function FTC.UI:Welcome()

		-- Add welcome messages
		local welcome = _G["FTC_Welcome"]
		welcome:AddText(GetString(FTC_Welcome1))
		welcome:AddText("|c|r")
		welcome:AddText(GetString(FTC_Welcome2))
		welcome:AddText("|c|r")
		welcome:AddText(GetString(FTC_Welcome3))
		welcome:AddText("|c|r")

		-- Add changelog
		welcome:AddText(GetString(FTC_ChangesHeader))

		-- Register changes
		local Changes = {
			
			[1] = {
				"General Changes",
				"Thorough aesthetic overhaul of the entire addon.",
				"Complete performance sweep of every FTC component to ensure efficient memory usage.",
				"Complete French and German localization of FTC components thanks to the excellent work of Einherjar, Mooneh, and TehMagnus.",
				"Improved customization of FTC components with a far more useful addon settings menu.",
				"Switch to use account-wide saved variables, your FTC configurations will now apply to all the characters on your ESO account automatically.",
			},

			[2] = {
				"Unit Frames",
				"Added extensive aesthetic options for modifying the size, color, font, and style of unit frames.",
				"Added visualizations for healing and damage-over-time effects.",
				"Added configurable indicator on the target frame denoting execute range.",
				"Introduce optional small group frame.",
				"Introduce optional raid frame.",
			},

			[3] = {
				"Buff Tracking",
				"Added multiple buff format options for each buffs container allowing fine-tuning of buff tracking display.",
				"Added aesthetic options for customizing the apperance of tracked buffs.",
				"Include many new buffs and debuffs which were not previously tracked by the addon.",
			},

			[4] = {
				"Combat Log",
				"Introduce new FTC Combat Log component. This customizable window will retain a printed record of damage, healing, and other significant combat events.",
			},

			[5] = {
				"Scrolling Combat Text",
				"Significantly improve the aesthetics and efficiency of the scrolling combat text (SCT) component.",
				"Add optional icons for most of the recognized sources of damage in the game.",
				"Add many aesthetic options for configuring the appearance of scrolling combat text.",
				"Added a number of new SCT alerts for important combat conditions like crowd control effects and DoT cleansing.",
			},
			
			[6] = {
				"Combat Stats",
				"Introduce separate combat statistics component which tracks and details your character's performance in combat.",
				"Vastly improve the information content in the FTC Damage Report, breaking down combat events by target and providing insight into key abilities.",
				"Enable linking to chat for specific targets instead of the entire encounter.",
			},
		}

		-- Write to window
		for i = 1 , #Changes do 
			local list = Changes[i]
			welcome:AddText("|c|r")		
			welcome:AddText(list[1])		
			for i = 2 , #list do
				welcome:AddText("+ " .. list[i])	
			end
		end

		-- Add closing messages
		welcome:AddText("|c|r")	
		welcome:AddText("If you have any feedback, bug reports, or other questions about Foundry Tactical Combat please contact |cCC6600@Atropos|r on the North American PC megaserver or send an email to |cCC6600atropos@tamrielfoundry.com|r. Thank you for using the FTC addon and for your support!")
	end