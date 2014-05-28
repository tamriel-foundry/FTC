 
 --[[----------------------------------------------------------
	DAMAGE METER CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the damage meter component.
	* Runs during FTC.Damage:Initialize()
  ]]--
  
function FTC.Damage:Controls()
	
	--[[----------------------------------------------------------
		MINI DAMAGE METER
	  ]]----------------------------------------------------------
	local anchor 	= FTC.vars.FTC_MiniMeter
	local DM 		= FTC.UI.TopLevelWindow( "FTC_MiniMeter" 		, GuiRoot , {210,30} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )
	DM:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	DM:SetMouseEnabled( true )
	DM:SetMovable( true )
	
	DM.backdrop 	= FTC.UI.Backdrop( "FTC_MiniMeterBackdrop"		, DM , "inherit" , {CENTER,CENTER,0,0} , { 0,0,0,0.2 } , { 0,0,0,0.1 } , false )
	
	DM.dam			= FTC.UI.Control( "FTC_MiniMeter_Damage" 		, DM , {70,30} , {TOPLEFT,TOPLEFT,0,0} , false )
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
	
	--[[----------------------------------------------------------
		EXPANDED DAMAGE ANALYTICS
	  ]]----------------------------------------------------------
	local FM 		= FTC.UI.TopLevelWindow( "FTC_Meter" 			, FoundryTacticalCombat , {720,720} , {CENTER,CENTER,0,-250} , true )
	FM.backdrop 	= FTC.UI.Backdrop( "FTC_MeterBackdrop" 			, FM , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
	FM.title 		= FTC.UI.Label( "FTC_MeterTitle"				, FM , {FM:GetWidth() - 40 , 60} , {TOP,TOP,0,0} , "ZoFontWindowTitle" , nil , {0,1} , "FTC Damage Meter" , false )

	-- Outgoing damage component
	FM.dam			= FTC.UI.Control( "FTC_MeterDamage" 			, FM , {FM:GetWidth() - 40 , 280} , {TOP,TOP,0,50} , false )
	FM.dam.title 	= FTC.UI.Label( "FTC_MeterDamage_Title"			, FM.dam , {FM.dam:GetWidth() , 40} , {TOP,TOP,0,0} , "ZoFontWindowSubtitle" , nil , {0,1} , "Outgoing Damage" , false )
	local anchor	= FM.dam.title
	for i = 1 , 10 do
		FM.dam[i]			= FTC.UI.Control( "FTC_MeterDamage_"..i			, FM.dam , {FM.dam:GetWidth() , 24} , {TOP,BOTTOM,0,0,anchor} , false )
		FM.dam[i].left		= FTC.UI.Label( "FTC_MeterDamage_"..i.."Left" 	, FM.dam[i] , {FM.dam:GetWidth(),24} , {LEFT,LEFT,0,0} , 'ZoFontGame' , nil , {0,1} , "Damage " .. i .. " Left"	, false )
		FM.dam[i].right		= FTC.UI.Label( "FTC_MeterDamage_"..i.."Right" 	, FM.dam[i] , {FM.dam:GetWidth(),24} , {RIGHT,RIGHT,0,0} , 'ZoFontGame' , nil , {2,1} , "Damage " .. i .. " Right" , false )
		anchor				= FM.dam[i]
	end
	
	-- Outgoing healing component
	FM.heal			= FTC.UI.Control( "FTC_MeterHealing" 			, FM , {FM:GetWidth() - 40 , 280} , {TOP,BOTTOM,0,10,FM.dam} , false )
	FM.heal.title 	= FTC.UI.Label( "FTC_MeterHealing_Title"		, FM.heal , {FM.heal:GetWidth() , 40} , {TOP,TOP,0,0} , "ZoFontWindowSubtitle" , nil , {0,1} , "Outgoing Healing" , false )
	local anchor	= FM.heal.title
	for i = 1 , 10 do
		FM.heal[i]			= FTC.UI.Control( "FTC_MeterHealing_"..i		, FM.heal , {FM.heal:GetWidth() , 24} , {TOP,BOTTOM,0,0,anchor} , false )
		FM.heal[i].left		= FTC.UI.Label( "FTC_MeterHealing_"..i.."Left" 	, FM.heal[i] , {FM.heal:GetWidth(),24} , {LEFT,LEFT,0,0} , 'ZoFontGame' , nil , {0,1} , "Healing " .. i .. " Left"	, false )
		FM.heal[i].right	= FTC.UI.Label( "FTC_MeterHealing_"..i.."Right" , FM.heal[i] , {FM.heal:GetWidth(),24} , {RIGHT,RIGHT,0,0} , 'ZoFontGame' , nil , {2,1} , "Healing " .. i .. " Right" , false )
		anchor				= FM.heal[i]
	end
	
	-- Incoming damage component
	FM.inc			= FTC.UI.Control( "FTC_MeterIncoming" 			, FM , {FM:GetWidth() - 40 , 240} , {TOP,BOTTOM,0,10,FM.heal} , false )
	FM.inc.title 	= FTC.UI.Label( "FTC_MeterIncoming_Title"		, FM.inc , {FM.inc:GetWidth() , 40} , {TOP,TOP,0,0} , "ZoFontWindowSubtitle" , nil , {0,1} , "Incoming Damage" , false )
end