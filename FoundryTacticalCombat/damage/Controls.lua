 
 --[[----------------------------------------------------------
	DAMAGE METER CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the damage meter component.
	* Runs during FTC.Damage:Initialize()
  ]]--
  
function FTC.Damage:Controls()
	
	-- Setup DPS meter container
	local FM 	= FTC.UI.TopLevelWindow( "FTC_DamageMeter" 		, GuiRoot , {600,220} , {TOPLEFT,TOPLEFT,10,10} , true )
	FM.backdrop = FTC.UI.Backdrop( "FTC_DamageMeterBackdrop" 	, FM , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
	FM.title 	= FTC.UI.Label( "FTC_DamageMeterTitle" 			, FM , {FM:GetWidth() - 20 , 25} , {TOPLEFT,TOPLEFT,20,10} , "ZoFontWindowSubtitle" , nil , {0,1} , "FTC Damage Meter" , false )

	-- Iterate through damage meter components
	local comps = { "Damage" , "Healing" , "Incoming" }
	local anchor = FM.title
	for i = 1 , #comps , 1 do
		local section 	= FTC.UI.Control( "FTC_DamageMeter_" .. comps[i] , FM , {FM:GetWidth() , 50} , {TOPLEFT,BOTTOMLEFT,0,5,anchor} , false )
		local names 	= FTC.UI.Label( "FTC_DamageMeter_" .. comps[i] .. "Label" , section , { 0.7 * section:GetWidth() , section:GetHeight() } , {TOPLEFT,TOPLEFT,0,0} , "ZoFontGame" , nil , {0,1} , nil , false )
		local values 	= FTC.UI.Label( "FTC_DamageMeter_" .. comps[i] .. "Value" , section , { 0.3 * section:GetWidth() , section:GetHeight() } , {TOPRIGHT,TOPRIGHT,0,0} , "ZoFontWindowSubtitle" , nil , {1,1} , nil , false )
		anchor = section
	end
	
	-- Set up the mini meter
	local DM 		= FTC.UI.TopLevelWindow( "FTC_MiniMeter" 		, GuiRoot , {210,30} , {TOPLEFT,TOPLEFT,10,10} , false )
	DM.backdrop 	= FTC.UI.Backdrop( "FTC_MiniMeterBackdrop"		, DM , "inherit" , {CENTER,CENTER,0,0} , { 0,0,0,0.2 } , { 0,0,0,0.1 } , false )
	
	DM.dam			= FTC.UI.Control( "FTC_MiniMeter_Damage" 		, DM , {70,30} , {LEFT,LEFT,0,0} , false )
	DM.dam.label	= FTC.UI.Label( "FTC_MiniMeter_DamageLabel" 	, DM.dam , {46,30} , {LEFT,LEFT,24,0} , FTC.Fonts.meta(14) , nil , {0,1} , "dam" , false )
	DM.dam.icon		= FTC.UI.Texture( "FTC_MiniMeter_DamageIcon" 	, DM.dam , {20,20} , {LEFT,LEFT,1,0} , nil , false )
	DM.dam.icon:SetTexture( "/esoui/art/lfg/lfg_dps_up.dds" )
	
	DM.heal			= FTC.UI.Control( "FTC_MiniMeter_Heal" 			, DM , {70,30} , {LEFT,RIGHT,0,0,DM.dam} , false )
	DM.heal.label	= FTC.UI.Label( "FTC_MiniMeter_HealLabel" 		, DM.heal , {46,30} , {LEFT,LEFT,24,0} , FTC.Fonts.meta(14) , nil , {0,1} , "heal" , false )
	DM.heal.icon	= FTC.UI.Texture( "FTC_MiniMeter_HealIcon" 		, DM.heal , {20,20} , {LEFT,LEFT,1,1} , nil , false )
	DM.heal.icon:SetTexture( "/esoui/art/lfg/lfg_healer_up.dds" )
	
	DM.inc			= FTC.UI.Control( "FTC_MiniMeter_Inc" 			, DM , {70,30} , {LEFT,RIGHT,0,0,DM.heal} , false )
	DM.inc.label	= FTC.UI.Label( "FTC_MiniMeter_IncLabel" 		, DM.inc , {46,30} , {LEFT,LEFT,24,0} , FTC.Fonts.meta(14) , nil , {0,1} , "inc" , false )
	DM.inc.icon		= FTC.UI.Texture( "FTC_MiniMeter_IncIcon" 		, DM.inc , {20,20} , {LEFT,LEFT,1,0} , nil , false )
	DM.inc.icon:SetTexture( "/esoui/art/lfg/lfg_tank_up.dds" )
	
end