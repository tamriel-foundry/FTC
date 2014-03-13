 
 --[[----------------------------------------------------------
	DAMAGE METER CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the damage meter component.
	* Runs during FTC.Damage:Initialize()
  ]]--
  
function FTC.Damage:Controls()
	
	-- Setup DPS meter container
	local DM 	= FTC.UI.TopLevelWindow( "FTC_DamageMeter" 		, GuiRoot , {600,220} , {TOPLEFT,TOPLEFT,10,10} , true )
	DM.backdrop = FTC.UI.Backdrop( "FTC_DamageMeterBackdrop" 	, DM , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
	DM.title 	= FTC.UI.Label( "FTC_DamageMeterTitle" 			, DM , {DM:GetWidth() - 20 , 25} , {TOPLEFT,TOPLEFT,20,10} , "ZoFontWindowSubtitle" , nil , {0,1} , "FTC Damage Meter" , false )

	-- Iterate through damage meter components
	local comps = { "Damage" , "Healing" , "Incoming" }
	local anchor = DM.title
	for i = 1 , #comps , 1 do
		local section 	= FTC.UI.Control( "FTC_DamageMeter_" .. comps[i] , DM , {DM:GetWidth() , 50} , {TOPLEFT,BOTTOMLEFT,0,5,anchor} , false )
		local names 	= FTC.UI.Label( "FTC_DamageMeter_" .. comps[i] .. "Label" , section , { 0.7 * section:GetWidth() , section:GetHeight() } , {TOPLEFT,TOPLEFT,0,0} , "ZoFontGame" , nil , {0,1} , nil , false )
		local values 	= FTC.UI.Label( "FTC_DamageMeter_" .. comps[i] .. "Value" , section , { 0.3 * section:GetWidth() , section:GetHeight() } , {TOPRIGHT,TOPRIGHT,0,0} , "ZoFontWindowSubtitle" , nil , {1,1} , nil , false )
		anchor = section
	end
	
end