 
--[[----------------------------------------------------------
    DAMAGE STATISTICS CONTROLS
  ]]----------------------------------------------------------
  
function FTC.Stats:Controls()
	
	--[[----------------------------------------------------------
		MINI DAMAGE METER
	  ]]----------------------------------------------------------

	local DM 		= FTC.UI:Control(   "FTC_MiniMeter", 					FTC_UI, 	{240,32}, 				FTC.Vars.FTC_MiniMeter, 		false )
    DM.backdrop     = FTC.UI:Backdrop(  "FTC_MiniMeter_BG",               	DM,         "inherit",      		{CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,0.5}, nil, false )
	DM:SetMovable( true )
	DM:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	DM:SetHandler( "OnMouseDoubleClick", function() FTC.Stats:Toggle() end )

	local damage	= FTC.UI:Control(   "FTC_MiniMeter_Dam", 				DM, 		{80,32}, 				{LEFT,LEFT,0,0}, 				false )
	damage.label	= FTC.UI:Label( 	"FTC_MiniMeter_DamLabel", 			damage, 	{48,32}, 				{RIGHT,RIGHT,0,0}, 				FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "0", false )
	damage.icon     = FTC.UI:Texture(   "FTC_MiniMeter_DamIcon",       		damage,     {32,32},  				{LEFT,LEFT,0,-1},  				'/esoui/art/icons/poi/poi_battlefield_complete.dds', false )
	DM.damage		= damage

	local healing	= FTC.UI:Control(   "FTC_MiniMeter_Heal", 				DM, 		{80,32}, 				{LEFT,RIGHT,0,0,damage}, 		false )
	healing.label	= FTC.UI:Label( 	"FTC_MiniMeter_HealLabel", 			healing, 	{48,32}, 				{RIGHT,RIGHT,0,0}, 				FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "0", false )
	healing.icon    = FTC.UI:Texture(   "FTC_MiniMeter_HealIcon",       	healing,    {26,26},  				{LEFT,LEFT,3,0},  				'/esoui/art/buttons/gamepad/pointsplus_up.dds', false )
	DM.healing		= healing

	local time		= FTC.UI:Control(   "FTC_MiniMeter_Time", 				DM, 		{80,32}, 				{LEFT,RIGHT,0,0,healing}, 		false )
	time.label		= FTC.UI:Label( 	"FTC_MiniMeter_TimeLabel", 			time, 		{48,32}, 				{RIGHT,RIGHT,0,0}, 				FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "0:00" , false )
	time.icon    	= FTC.UI:Texture(   "FTC_MiniMeter_TimeIcon",       	time,    	{28,28},  				{LEFT,LEFT,2,0},  				'/esoui/art/mounts/timer_icon.dds', false )
	DM.time  		= time

	--[[----------------------------------------------------------
		GROUP DPS REPORT
	  ]]----------------------------------------------------------
	local GDPS 		= FTC.UI:Control(   "FTC_GroupDPS", 					FTC_UI, 	{400,200}, 				FTC.Vars.FTC_GroupDPS, 			false )
    GDPS.backdrop   = FTC.UI:Backdrop(  "FTC_GroupDPS_BG",               	GDPS,       "inherit",      		{CENTER,CENTER,0,0},            {0,0,0,0.25}, {0,0,0,0}, nil, false )
    GDPS:SetAlpha(0)
	GDPS:SetMouseEnabled( true )
	GDPS:SetMovable( true )
	GDPS:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )

	-- Headers
	GDPS.namesH		= FTC.UI:Label( 	"FTC_GroupDPS_NamesHeader", 		GDPS, 		{140,25}, 				{TOPLEFT,TOPLEFT,10,5}, 		FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "Player"	, false )
	GDPS.timeH		= FTC.UI:Label( 	"FTC_GroupDPS_TimeHeader", 			GDPS, 		{75,25}, 				{LEFT,RIGHT,0,0,GDPS.namesH}, 	FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "Time"	, false )
	GDPS.damageH	= FTC.UI:Label( 	"FTC_GroupDPS_DamageHeader", 		GDPS, 		{100,25}, 				{LEFT,RIGHT,0,0,GDPS.timeH}, 	FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "Damage"	, false )
	GDPS.dpsH		= FTC.UI:Label( 	"FTC_GroupDPS_DPSHeader", 			GDPS, 		{75,25}, 				{LEFT,RIGHT,0,0,GDPS.damageH}, 	FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,1}, "DPS"	, false )

	-- Divider
	GDPS.divider 	= FTC.UI:Texture( 	"FTC_GroupDPS_NamesIcon",  			GDPS,   	{360,8},    			{TOPLEFT,TOPLEFT,20,32}, 		'EsoUI/Art/Miscellaneous/horizontalDivider.dds', false )
	GDPS.divider:SetTextureCoords(0.181640625, 0.818359375, 0, 1)
	GDPS:SetDrawLayer(DL_OVERLAY)

	-- List
	GDPS.names		= FTC.UI:Label( 	"FTC_GroupDPS_Names", 				GDPS, 		{140,600}, 				{TOPLEFT,TOPLEFT,10,40}, 		FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,0}, "names"	, false )
	GDPS.time		= FTC.UI:Label( 	"FTC_GroupDPS_Time", 				GDPS, 		{75,600}, 				{LEFT,RIGHT,0,0,GDPS.names}, 	FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,0}, "time"	, false )
	GDPS.damage		= FTC.UI:Label( 	"FTC_GroupDPS_Damage", 				GDPS, 		{100,600}, 				{LEFT,RIGHT,0,0,GDPS.time}, 	FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,0}, "damage"	, false )
	GDPS.dps		= FTC.UI:Label( 	"FTC_GroupDPS_DPS", 				GDPS, 		{75,600}, 				{LEFT,RIGHT,0,0,GDPS.damage}, 	FTC.UI:Font("standard",16,true), {1,1,1,1}, {0,0}, "dps"	, false )

	--[[----------------------------------------------------------
		EXPANDED ANALYTICS
	  ]]----------------------------------------------------------
	local FM 		= FTC.UI:TopLevelWindow( "FTC_Report", 					GuiRoot, 	{1000,math.min(1000,GuiRoot:GetHeight()*0.8)}, 			{TOP,TOP,0,100}, true )
	FM.backdrop 	= FTC.UI:Backdrop( 	"FTC_Report_Backdrop", 				FM, 		"inherit", 				{CENTER,CENTER,0,0}, 			{0,0,0,0.6}, {0,0,0,0.9}, nil, false )
	FM.dtitle 		= FTC.UI:Label( 	"FTC_Report_DamageTitle", 			FM, 		{950,50}, 				{TOPLEFT,TOPLEFT,25,25}, 		"ZoFontWindowTitle", {1,1,1,1}, {0,1}, GetString(FTC_DReport), false )
	FM.htitle		= FTC.UI:Label( 	"FTC_Report_HealingTitle", 			FM, 		{950,50}, 				{BOTTOMLEFT,BOTTOMLEFT,25,25}, 	"ZoFontWindowTitle", {1,1,1,1}, {0,1}, GetString(FTC_HReport), false )
	FM.close		= FTC.UI:Button(   	"FTC_Report_Close" ,    			FM,    		{48,48}, 				{TOPRIGHT,TOPRIGHT,-10,20},		BSTATE_NORMAL, nil, nil, nil, nil, nil, false )
	FM.close:SetNormalTexture('/esoui/art/buttons/closebutton_up.dds')
	FM.close:SetMouseOverTexture('/esoui/art/buttons/closebutton_mouseover.dds')
	FM.close:SetHandler("OnClicked", FTC.Stats.Toggle )
	FM:SetMouseEnabled( true )
	FM:SetMovable( true )

	-- Abilities Detail
	local abilities	= FTC.UI:Control(  "FTC_Report_Ability",   				FM,			{FM:GetWidth()-50,200}, {TOP,TOP,0,0}, 					true )
    local header  	= FTC.UI:Control(  "FTC_Report_Ability_Header",			abilities,	{FM:GetWidth()-50,50}, 	{TOP,TOP,0,0}, 					false )
    header.name   	= FTC.UI:Label(    "FTC_Report_Ability_Name",   		header,  	{225,50},  				{LEFT,LEFT,100,0}, 				FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, GetString(FTC_Ability), false )
    header.count 	= FTC.UI:Label(    "FTC_Report_Ability_Count",  		header,  	{50,50},  				{LEFT,RIGHT,0,0,header.name},  	FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, "#", false )
    header.total 	= FTC.UI:Label(    "FTC_Report_Ability_Total",  		header,  	{150,50},  				{LEFT,RIGHT,0,0,header.count},  FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, GetString(FTC_Damage), false )
    header.dps 		= FTC.UI:Label(    "FTC_Report_Ability_DPS",  			header,  	{100,50},  				{LEFT,RIGHT,0,0,header.total},  FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, GetString(FTC_DPS), false )
    header.crit 	= FTC.UI:Label(    "FTC_Report_Ability_Crit",   		header,  	{100,50},  				{LEFT,RIGHT,0,0,header.dps},  	FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, GetString(FTC_Crit), false )
    header.avg		= FTC.UI:Label(    "FTC_Report_Ability_Avg",   			header,  	{100,50},  				{LEFT,RIGHT,0,0,header.crit},  	FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, GetString(FTC_Average), false )
    header.max 		= FTC.UI:Label(    "FTC_Report_Ability_Max",   			header,  	{100,50},  				{LEFT,RIGHT,0,0,header.avg},  	FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, GetString(FTC_Max), false )
    abilities.header= header
    FM.abilities	= abilities

    -- Setup Target Pool
    if ( FTC.Stats.TargetPool == nil ) then FTC.Stats.TargetPool = ZO_ObjectPool:New( FTC.Stats.CreateTarget , function(object) FTC.Stats:Release(object) end ) end

    -- Setup Ability Pool
    if ( FTC.Stats.AbilityPool == nil ) then FTC.Stats.AbilityPool = ZO_ObjectPool:New( FTC.Stats.CreateAbility , function(object) FTC.Stats:Release(object) end ) end
end


--[[----------------------------------------------------------
    POOL FUNCTIONS
  ]]----------------------------------------------------------


	--[[ 
	 * Add New Target to Report Pool
	 * --------------------------------
	 * Called by FTC.Stats.TargetPool
	 * --------------------------------
	 ]]--
	function FTC.Stats.CreateTarget()

	    -- Get the pool and counter
	    local pool 		= FTC.Stats.TargetPool
	    local counter   = pool:GetNextControlId()
	    local parent	= FTC_Report

	    -- Create target
	    local control  	= FTC.UI:Control(  "FTC_Report_Target"..counter,     			parent,		{parent:GetWidth()-50,50},  {CENTER,CENTER,0,0}, 					false )
        control.backdrop= FTC.UI:Backdrop( "FTC_Report_Target"..counter.."_BG",         control,    "inherit",      			{TOP,TOP,0,0},            				{0,0,0,0.6}, {0,0,0,1}, FTC.UI.Textures["grainy"] , false )
	    control.name   	= FTC.UI:Label(    "FTC_Report_Target"..counter.."_Name",   	control,  	{350,50},  					{LEFT,LEFT,25,0,control.backdrop}, 		FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, "Target Name", false )
	    control.total 	= FTC.UI:Label(    "FTC_Report_Target"..counter.."_Total",  	control,  	{400,50},  					{LEFT,RIGHT,0,0,control.name},  		FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, "Total Damage", false )
	    control.dps 	= FTC.UI:Label(    "FTC_Report_Target"..counter.."_DPS",  		control,  	{200,50},  					{RIGHT,RIGHT,-25,0,control.backdrop},  	FTC.UI:Font("esobold",20,true), {1,1,1,1}, {0,1}, "DPS", false )

	    -- Expand button
		control.expand	= FTC.UI:Button(   "FTC_Report_Target"..counter.."_Expand" ,    control,    {32,32}, 					{RIGHT,RIGHT,-25,0,control.backdrop},	BSTATE_NORMAL, nil, nil, nil, nil, nil, false )
		control.expand:SetNormalTexture('/esoui/art/buttons/pointsplus_up.dds')
		control.expand:SetMouseOverTexture('/esoui/art/buttons/pointsplus_over.dds')
		control.expand:SetPressedTexture('/esoui/art/buttons/pointsminus_up.dds')
		control.expand:SetPressedMouseOverTexture('/esoui/art/buttons/pointsminus_over.dds')
		control.expand:SetDisabledTexture('/esoui/art/buttons/pointsplus_disabled.dds')
		control.expand:SetDisabledPressedTexture('/esoui/art/buttons/pointsminus_disabled.dds')
		control.expand:SetHandler("OnClicked", FTC.Stats.ExpandTarget )

		-- Post button
		control.post	= FTC.UI:Button(   	"FTC_Report_Target"..counter.."_Post" ,   	control,    {48,48}, 					{RIGHT,LEFT,-5,0,control.expand},		BSTATE_NORMAL, nil, nil, nil, nil, nil, false )
		control.post:SetNormalTexture('/esoui/art/chatwindow/chat_notification_up.dds')
		control.post:SetMouseOverTexture('/esoui/art/chatwindow/chat_notification_over.dds')
		control.post:SetDisabledTexture('/esoui/art/chatwindow/chat_notification_disabled.dds')
		control.post:SetHandler("OnClicked", FTC.Stats.Post )

		-- Store some data
		control.state	= "collapsed"

	    -- Return target to pool
	    return control
	end

	--[[ 
	 * Add New Ability to Report Pool
	 * --------------------------------
	 * Called by FTC.Stats.AbilityPool
	 * --------------------------------
	 ]]--
	function FTC.Stats.CreateAbility()

	    -- Get the pool and counter
	    local pool 		= FTC.Stats.AbilityPool
	    local counter   = pool:GetNextControlId()
	    local parent	= FTC_Report_Ability

	    -- Create ability
	    local control  	= FTC.UI:Control(  "FTC_Report_Ability"..counter,     			parent,		{parent:GetWidth()-50,50}, 	{CENTER,CENTER,0,0}, 				false )
	    control.icon    = FTC.UI:Texture(  "FTC_Report_Ability"..counter.."_Icon",   	control,   	{48,48},  					{LEFT,LEFT,0,0},					'/esoui/art/icons/icon_missing.dds', false )
	    control.frame   = FTC.UI:Texture(  "FTC_Report_Ability"..counter.."_Frame",  	control,   	{50,50},    				{CENTER,CENTER,0,0,control.icon}, 	'/esoui/art/actionbar/icon_metal04.dds', false )
	    control.name   	= FTC.UI:Label(    "FTC_Report_Ability"..counter.."_Name",   	control,  	{225,50},  					{LEFT,RIGHT,25,0,control.frame}, 	FTC.UI:Font("standard",20,true), {1,1,1,1}, {0,1}, "Ability Name", false )
	    control.count 	= FTC.UI:Label(    "FTC_Report_Ability"..counter.."_Count",  	control,  	{50,50},  					{LEFT,RIGHT,0,0,control.name},  	FTC.UI:Font("standard",20,true), {1,1,1,1}, {0,1}, "Count", false )
	    control.total 	= FTC.UI:Label(    "FTC_Report_Ability"..counter.."_Total",  	control,  	{150,50},  					{LEFT,RIGHT,0,0,control.count},  	FTC.UI:Font("standard",20,true), {1,1,1,1}, {0,1}, "Total", false )
	    control.dps 	= FTC.UI:Label(    "FTC_Report_Ability"..counter.."_DPS",  		control,  	{100,50},  					{LEFT,RIGHT,0,0,control.total},  	FTC.UI:Font("standard",20,true), {1,1,1,1}, {0,1}, "DPS", false )
	    control.crit 	= FTC.UI:Label(    "FTC_Report_Ability"..counter.."_Crit",   	control,  	{100,50},  					{LEFT,RIGHT,0,0,control.dps},  		FTC.UI:Font("standard",20,true), {1,1,1,1}, {0,1}, "Crit", false )
	    control.avg 	= FTC.UI:Label(    "FTC_Report_Ability"..counter.."_Avg",   	control,  	{100,50},  					{LEFT,RIGHT,0,0,control.crit},  	FTC.UI:Font("standard",20,true), {1,1,1,1}, {0,1}, "Avg", false )
	    control.max 	= FTC.UI:Label(    "FTC_Report_Ability"..counter.."_Max",   	control,  	{100,50},  					{LEFT,RIGHT,0,0,control.avg},  		FTC.UI:Font("standard",20,true), {1,1,1,1}, {0,1}, "Max", false )
	    control.frame:SetDrawLayer(DL_OVERLAY)

	    -- Return ability to pool
	    return control
	end

	--[[ 
	 * Release Control to Pool Callback
	 * --------------------------------
	 * Called by FTC.Stats.TargetPool
	 * Called by FTC.Stats.AbilityPool
	 * --------------------------------
	 ]]--
	function FTC.Stats:Release(object)
	    object:SetHidden(true)
	end

	--[[ 
	 * Group DPS Fading
	 * --------------------------------
	 * Called by FTC.Stats:DisplayGroupDPS()
	 * --------------------------------
	 ]]--
	function FTC.Stats:DPSFade()

		-- Get data
		local control = FTC_GroupDPS

		-- Fade in
		if ( control.fadeIn == nil ) then

			local animation, timeline = CreateSimpleAnimation(ANIMATION_ALPHA,control,0)
		    animation:SetAlphaValues(0,1)
		    animation:SetEasingFunction(ZO_EaseInQuadratic)  
		    animation:SetDuration(500)

		    -- Add to icon
		    timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
		    control.fadeIn = timeline
		end

		-- Fade Out 
		if ( control.fadeOut == nil ) then
		    local animation, timeline = CreateSimpleAnimation(ANIMATION_ALPHA,control,15000)
		    animation:SetAlphaValues(1,0)
		    animation:SetEasingFunction(ZO_EaseInQuadratic)
		    animation:SetDuration(1000)
		    
		    -- Add to icon
		    timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
		    control.fadeOut = timeline
		end

		-- Stop fading out
		control.fadeOut:Stop()

		-- If the control is currently hidden
		if ( control:GetAlpha() < 1 ) then control.fadeIn:PlayFromStart() end

		-- Schedule fade out
		control.fadeOut:PlayFromStart() 
	end