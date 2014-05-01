 
 --[[----------------------------------------------------------
	MENU CONTROLS
	-----------------------------------------------------------
	* Set up controls for the menu component of FTC
	* Uses ZeniMax own virtual controls to create elements
	* Modifies addon saved variables
  ]]--
local LAM = LibStub("LibAddonMenu-1.0")		
function FTC.Menu:Controls()
	
	-- Addon heading
	LAM:AddHeader( FTC.Menu.id , "FTC_Settings_Subtitle", "Foundry Tactical Combat - Version "  .. FTC.version )
	FTC_Settings_SubtitleLabel:SetHeight( 32 )
	FTC_Settings_SubtitleLabel:SetVerticalAlignment(1)
	FTC_Settings_SubtitleLabel:SetHorizontalAlignment(1)
	
	local desc = FTC.L("Please use this menu to configure addon options.")
	local label	= FTC.UI.Label( "FTC_Settings_SubtitleDescription" , FTC_Settings_Subtitle , { FTC_Settings_Subtitle:GetWidth() , 24} , {TOP,BOTTOM,0,0,FTC_Settings_SubtitleLabel} , "ZoFontGame" , nil , {1,1} , desc , false )	
	
	-- Toggle components
	LAM:AddHeader( FTC.Menu.id , "FTC_Settings_ComponentsHeader", "Configure Components")
	LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_ComponentsFrames", FTC.L("Enable Frames"), FTC.L("Enable custom unit frames component?"), function() return FTC.vars.EnableFrames end , function() FTC.Menu:Toggle( 'EnableFrames' , true ) end , true , FTC.L("Reloads UI") )
	LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_ComponentsBuffs", FTC.L("Enable Buffs"), FTC.L("Enable active buff tracking component?"), function() return FTC.vars.EnableBuffs end , function() FTC.Menu:Toggle( 'EnableBuffs' , true ) end , true , FTC.L("Reloads UI") )	
	LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_ComponentsDamage", FTC.L("Enable Damage Statistics"), FTC.L("Enable damage statistics?"), function() return FTC.vars.EnableDamage end , function() FTC.Menu:Toggle( 'EnableDamage' , true ) end , true , FTC.L("Reloads UI") )
	LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_ComponentsSCT", FTC.L("Enable Combat Text"), FTC.L("Enable scrolling combat text component?"), function() return FTC.vars.EnableSCT end , function() FTC.Menu:Toggle( 'EnableSCT' , true ) end , true , FTC.L("Reloads UI") )

	-- Unit frames settings
	LAM:AddHeader( FTC.Menu.id , "FTC_Settings_FramesHeader", FTC.L("Unit Frames Settings") )	
	LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_TargetFrame", FTC.L("Show Default Target Frame"), FTC.L("Show the default ESO target unit frame?"), function() return FTC.vars.TargetFrame end , function() FTC.Menu:Toggle( 'TargetFrame' ) end )	
	LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_FrameText", FTC.L("Default Unit Frames Text"), FTC.L("Display text attribute values on default unit frames?"), function() return FTC.vars.FrameText end , function() FTC.Menu:Toggle( 'FrameText' ) end )	
	if ( FTC.vars.EnableFrames ) then
		LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_EnableNameplate", FTC.L("Show Player Nameplate"), FTC.L("Show your own character's nameplate?"), function() return FTC.vars.EnableNameplate end , function() FTC.Menu:Toggle( 'EnableNameplate' ) end )	
		LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_EnableXPBar", FTC.L("Enable Mini Experience Bar"), FTC.L("Show a small experience bar on the player frame?"), function() return FTC.vars.EnableXPBar end , function() FTC.Menu:Toggle( 'EnableXPBar' ) end )	
	end

	-- Buffs settings
	if ( FTC.vars.EnableBuffs ) then 
		LAM:AddHeader( FTC.Menu.id , "FTC_Settings_BuffsHeader", FTC.L("Buff Tracker Settings") )		
		LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_AnchorBuffs", FTC.L("Anchor Buffs"), FTC.L("Anchor buffs to unit frames?"), function() return FTC.vars.AnchorBuffs end , function() FTC.Menu:Toggle( 'AnchorBuffs' , true ) end  )
		LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_EnableLongBuffs", FTC.L("Display Long Buffs"), FTC.L("Track long duration player buffs?"), function() return FTC.vars.EnableLongBuffs end , function() FTC.Menu:Toggle( 'EnableLongBuffs' ) end )
	end
	
	-- Scrolling combat text settings
	if ( FTC.vars.EnableSCT ) then 
		LAM:AddHeader( FTC.Menu.id , "FTC_Settings_SCTHeader", FTC.L("Scrolling Combat Text Settings"))		
		LAM:AddSlider( FTC.Menu.id , "FTC_Settings_SCTSpeed", FTC.L("Combat Text Scroll Speed"), FTC.L("Adjust combat text scroll speed."), 1, 5, 1, function() return FTC.vars.SCTSpeed end, function( value ) FTC.Menu:Update( "SCTSpeed" , value ) end )		
		LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_SCTNames", FTC.L("Display Ability Names"), FTC.L("Display ability names in combat text?"), function() return FTC.vars.SCTNames end , function() FTC.Menu:Toggle( 'SCTNames' ) end , true , "Reloads UI" )		
		LAM:AddDropdown( FTC.Menu.id , "FTC_Settings_SCTPath", FTC.L("Scroll Path Animation"), FTC.L("Choose scroll animation."), { "Arc", "Line" }, function() return FTC.vars.SCTPath end, function( value )  FTC.Menu:Update( "SCTPath" , value ) end )
	end
	
	-- Damage meter settings
	if ( FTC.vars.EnableDamage ) then 
		LAM:AddHeader( FTC.Menu.id , "FTC_Settings_DamageHeader", FTC.L("Damage Tracker Settings") )		
		LAM:AddSlider( FTC.Menu.id , "FTC_Settings_DamageTimeout", FTC.L("Timeout Threshold"), FTC.L("Number of seconds without damage to signal encounter termination."), 5, 60, 5, function() return FTC.vars.DamageTimeout end, function( value ) FTC.Menu:Update( "DamageTimeout" , value ) end )		
	end
	
	-- Reposition elements
	LAM:AddHeader( FTC.Menu.id , "FTC_Settings_PositionHeader", FTC.L("Reposition FTC Elements") )
	LAM:AddCheckbox( FTC.Menu.id , "FTC_Settings_FramesUnlock", FTC.L("Lock Positions"), FTC.L("Modify FTC frame positions?") , function() return not FTC.move end , function() FTC.Menu:MoveFrames() end )
	
	-- Restore defaults
	LAM:AddHeader( FTC.Menu.id , "FTC_Settings_ResetHeader", FTC.L("Reset Settings") )
	LAM:AddButton( FTC.Menu.id , "FTC_Settings_ResetButton", FTC.L("Restore Defaults"), FTC.L("Restore FTC to default settings."), function() FTC.Menu:Reset() end , true , "Reloads UI" )

end