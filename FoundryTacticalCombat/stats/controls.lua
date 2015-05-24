 
--[[----------------------------------------------------------
    DAMAGE STATISTICS CONTROLS
  ]]----------------------------------------------------------
  
function FTC.Stats:Controls()
	
	--[[----------------------------------------------------------
		MINI DAMAGE METER
	  ]]----------------------------------------------------------

	local DM 		= FTC.UI:Control(   "FTC_MiniMeter", 					FTC_UI, 	{240,32}, 			FTC.Vars.FTC_MiniMeter, 		false )
    DM.backdrop     = FTC.UI:Backdrop(  "FTC_MiniMeter_BG",               	DM,         "inherit",      	{CENTER,CENTER,0,0},            {0,0,0,0.25}, {0,0,0,0.5}, nil, false )
	DM:SetMouseEnabled( true )
	DM:SetMovable( true )
	DM:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )

	local damage	= FTC.UI:Control(   "FTC_MiniMeter_Dam", 				DM, 		{80,32}, 			{LEFT,LEFT,0,0}, 				false )
	damage.label	= FTC.UI:Label( 	"FTC_MiniMeter_DamLabel", 			damage, 	{48,32}, 			{RIGHT,RIGHT,0,0}, 				FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "0", false )
	damage.icon     = FTC.UI:Texture(   "FTC_MiniMeter_DamIcon",       		damage,     {32,32},  			{LEFT,LEFT,0,-1},  				'/esoui/art/icons/poi/poi_battlefield_complete.dds', false )
	DM.damage		= damage

	local healing	= FTC.UI:Control(   "FTC_MiniMeter_Heal", 				DM, 		{80,32}, 			{LEFT,RIGHT,0,0,damage}, 		false )
	healing.label	= FTC.UI:Label( 	"FTC_MiniMeter_HealLabel", 			healing, 	{48,32}, 			{RIGHT,RIGHT,0,0}, 				FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "0", false )
	healing.icon    = FTC.UI:Texture(   "FTC_MiniMeter_HealIcon",       	healing,    {32,32},  			{LEFT,LEFT,0,-1},  				'/esoui/art/icons/poi/poi_grove_complete.dds', false )
	DM.healing		= healing

	local time		= FTC.UI:Control(   "FTC_MiniMeter_Time", 				DM, 		{80,32}, 			{LEFT,RIGHT,0,0,healing}, 		false )
	time.label		= FTC.UI:Label( 	"FTC_MiniMeter_TimeLabel", 			time, 		{48,32}, 			{RIGHT,RIGHT,0,0}, 				FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "0:00" , false )
	time.icon    	= FTC.UI:Texture(   "FTC_MiniMeter_TimeIcon",       	time,    	{28,28},  			{LEFT,LEFT,2,0},  				'/esoui/art/mounts/timer_icon.dds', false )
	DM.time  		= time
	
	--[[----------------------------------------------------------
		EXPANDED ANALYTICS
	  ]]----------------------------------------------------------
	local FM 		= FTC.UI:TopLevelWindow( "FTC_Report", 					GuiRoot, 	{720,720}, 			{CENTER,CENTER,0,-200}, 		true )
	FM.backdrop 	= FTC.UI:Backdrop( 	"FTC_ReportBackdrop", 				FM, 		"inherit", 			{CENTER,CENTER,0,0}, 			{0,0,0,0.25}, {0,0,0,0.5}, nil, false )
	FM.title 		= FTC.UI:Label( 	"FTC_ReportTitle", 					FM, 		{700,60}, 			{TOPLEFT,TOPLEFT,20,0}, 		"ZoFontWindowTitle", {1,1,1,1}, {0,1}, "FTC Damage Report", false )

	 --[[


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
	  ]]

end