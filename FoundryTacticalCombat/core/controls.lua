
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
		welcome:SetAnchor(TOP,GuiRoot,TOP,0,100)
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
		welcome:AddText("Hello ESO friends, thank you for downloading the newest version of Foundry Tactical Combat, a combat enhancement addon designed to give players access to relevant combat data in an easy to process framework which allows them to respond quickly and effectively to evolving combat situations.")
		welcome:AddText("|c|r")
		welcome:AddText("It has been a while since there was a major update to this addon, and a number of things have changed. Please take a few minutes to read over the list of major changes. This message will not be displayed again once you close it unless you completely reset FTC settings in the options menu.")
		welcome:AddText("|c|r")
		welcome:AddText("To get straight into the action you can access the addon's configuration options by navigating to |cCC6600Settings -> Addon Settings -> FTC|r or by typing |cCC6600/ftc|r in chat. From this menu you can enable or disable FTC components, customize appearance and other component settings, and reposition UI elements added by the FTC addon.")
		welcome:AddText("|c|r")
		welcome:AddText("Additionaly, FTC adds several optional hotkeys which you may bind to make using certain addon features more convenient. These hotkeys can be mapped by navigating to |cCC6600Controls -> Foundry Tactical Combat|r. The next section briefly details the changes included in this version of the addon.")
		welcome:AddText("|c|r")       

		-- Add changelog
		welcome:AddText("|cCC6600Version 0.62 Updates|r")

		-- Register changes
		local Changes = {
			
			[1] = {
				"General Changes",
				"Thorough aesthetic overhaul of the entire addon.",
				"Complete performance sweep of every FTC component to ensure efficient memory usage.",
				"Complete French and German localization of FTC components thanks to the excellent work of Einherjar, Mooneh, TehMagnus, and Rial.",
				"Significantly improved customization of FTC components with a far more flexible addon settings menu.",
				"Switched to use account-wide saved variables; your FTC configurations will now apply to all the characters on your ESO account automatically.",
			},

			[2] = {
				"Unit Frames",
				"Added extensive aesthetic options for modifying the size, color, font, and style of unit frames.",
				"Added visualizations for healing and damage-over-time effects.",
				"Added configurable indicator on the target frame denoting execute range.",
				"Improved detection rules for damage shielding to provide as accurate as possible an assessment of your character's defenses. Certain fundamental bugs in the ESO API will still cause shielding to be incorrectly reported.",
				"Introduce optional small group frame for groups of four or fewer members.",
				"Introduce optional raid frame for large groups, this raid frame can also be used for small groups by disabling the small group frame but keeping raid frames enabled.",
			},

			[3] = {
				"Buff Tracking",
				"Added multiple buff format options for each buffs container allowing fine-tuning of buff tracking display.",
				"Added options for rendering buffs in list format, displaying buff names in addition to tiled icons.",
				"New customization options for modifying the apperance of tracked buffs.",
				"Include many new buffs and debuffs which were not previously tracked by the addon.",
			},

			[4] = {
				"Combat Log",
				"Introduce new FTC Combat Log component. This customizable window will retain a printed record of damage, healing, and other significant combat events.",
				"Allow FTC Combat Log to alternate with ESO chat or be detached independently.",
				"Add optional keybinding for quickly toggling display of the FTC Combat Log.",
			},

			[5] = {
				"Scrolling Combat Text",
				"Significantly improve the aesthetics and efficiency of the scrolling combat text (SCT) component.",
				"Add optional icons for most of the recognized sources of damage in the game.",
				"Add many customization options for configuring the appearance of scrolling combat text.",
				"Added a number of new SCT alerts for important combat conditions like crowd control effects and DoT cleansing.",
			},
			
			[6] = {
				"Combat Stats",
				"Introduce separate combat statistics component which tracks and details your character's performance in combat.",
				"Vastly improve the information content in the FTC Damage Report, breaking down combat events by target and providing insight into key abilities.",
				"Enable linking to chat for specific targets instead of the entire encounter.",
			},

			[7] = {
				"Advanced Hotbar",
				"Improve accuracy of current consumable (potion) cooldown timer.",
				"Add a visual glow behind your Ultimate ability indicating when you are currently gaining Ultimate through combat.",
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