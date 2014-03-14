
 --[[----------------------------------------------------------
	MENU FUNCTIONS
	-----------------------------------------------------------
	* Initializes and handles menu actions
	* Runs last in the initialization order
  ]]--

FTC.Menu = {
			["id"] 		= "FTC_SETTINGS",
			["name"] 	= "FTC Settings",
			}
			
function FTC.Menu.Initialize()

	-- Register the options panel
	ZO_OptionsWindow_AddUserPanel( FTC.Menu.id , FTC.Menu.name )
	
	-- Enable settings hotkeys when the panel is shown
	panelID = _G[controlPanelID]
	ZO_PreHook("ZO_OptionsWindow_ChangePanels", function( panel )
			local enabled = (panel ~= panelID)
			ZO_OptionsWindowResetToDefaultButton:SetEnabled(enable)
			ZO_OptionsWindowResetToDefaultButton:SetKeybindEnabled(enable)
		end
	)
	
	-- Setup menu controls
	FTC.Menu.Controls()
	
end