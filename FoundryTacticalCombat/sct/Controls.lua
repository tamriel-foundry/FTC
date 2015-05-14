 
--[[----------------------------------------------------------
    SCROLLING COMBAT TEXT CONTROLS
  ]]----------------------------------------------------------

	--[[ 
	 * Create Scrolling Combat Text UI
	 * --------------------------------
	 * Called by FTC.SCT:Initialize()
	 * --------------------------------
	 ]]--  
	function FTC.SCT:Controls()

		-- Create outgoing damage container
		local CTO 		= FTC.UI:Control(   "FTC_SCTOut",           FTC_UI,     {400,900},             	FTC.Vars.FTC_SCTOut,       	false )  
	    CTO.backdrop 	= FTC.UI:Backdrop(  "FTC_SCTOut_BG",        CTO,     	"inherit",              {CENTER,CENTER,0,0},      	{0,0,0,0.4}, {0,0,0,1}, nil, true )
	    CTO.backdrop:SetEdgeTexture("",16,4,4)
	    CTO.label       = FTC.UI:Label(     "FTC_SCTOut_Label",     CTO,        "inherit",              {CENTER,CENTER,0,0},       	FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Outgoing Damage" , true )   
	    CTO:SetDrawLayer(DL_BACKGROUND)
	    CTO:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

		-- Create incoming damage container
		local CTI 		= FTC.UI:Control(   "FTC_SCTIn",           FTC_UI,     {400,900},             	FTC.Vars.FTC_SCTIn,       	false )  
	    CTI.backdrop 	= FTC.UI:Backdrop(  "FTC_SCTIn_BG",        CTI,     	"inherit",              {CENTER,CENTER,0,0},      	{0,0,0,0.4}, {0,0,0,1}, nil, true )
	    CTI.backdrop:SetEdgeTexture("",16,4,4)
	    CTI.label       = FTC.UI:Label(     "FTC_SCTIn_Label",     CTI,        "inherit",               {CENTER,CENTER,0,0},       	FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Incoming Damage" , true )   
	    CTI:SetDrawLayer(DL_BACKGROUND)
	    CTI:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

	    -- Define pool for damage events
	    if ( FTC.SCT.OutPool == nil ) then FTC.SCT.OutPool = ZO_ObjectPool:New( FTC.SCT.CreateSCTOut , function(object) FTC.SCT:ReleaseSCT(object) end ) end
	    if ( FTC.SCT.InPool == nil )  then FTC.SCT.InPool  = ZO_ObjectPool:New( FTC.SCT.CreateSCTIn  , function(object) FTC.SCT:ReleaseSCT(object) end ) end

		--[[
		
		-- Create status alerts container
		local name		= "FTC_CombatTextStatus"
		local anchor	= FTC.vars[name]
		local CTS 		= FTC.UI.TopLevelWindow( name , GuiRoot , {500,400} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )
		CTS.backdrop 	= FTC.UI.Backdrop( name.."_Backdrop" , CTS , "inherit" , {CENTER,CENTER,0,0} , nil , nil , true )	
		CTS.label		= FTC.UI.Label( name.."_Label" , CTS , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Status Alerts" , true )
		
		-- Register movement handlers
		CTO:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
		CTI:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
		CTS:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
		]]--
		
	end


	--[[ 
	 * SCT Object Opacity Fading
	 * --------------------------------
	 * Called by FTC.SCT:New()
	 * --------------------------------
	 ]]--
	function FTC.SCT:Fade(control)

	    -- Compute the animation duration
	    local duration = ( ( 11 - FTC.Vars.SCTSpeed ) / 2 ) * 0.8 * 1000

	    -- Start with a fade in
		local animation, timeline = CreateSimpleAnimation(ANIMATION_ALPHA,control,0)
        animation:SetAlphaValues(0,1)
        animation:SetEasingFunction(ZO_EaseInQuadratic)  
        animation:SetDuration(250)
        control.fadeIn = timeline

        -- End with fade out, delayed by the SCT lifespan
        local fadeOut = timeline:InsertAnimation(ANIMATION_ALPHA,control,duration-1250)
        fadeOut:SetAlphaValues(1,0)
        fadeOut:SetEasingFunction(ZO_EaseInQuadratic)
        fadeOut:SetDuration(1000)

	    -- Start performing the complete animation
	    timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
	    timeline:PlayFromStart()
	end

--[[----------------------------------------------------------
    BUFF POOL FUNCTIONS
  ]]----------------------------------------------------------

	--[[ 
	 * Add New Outgoing SCT to Pool
	 * --------------------------------
	 * Called by FTC.Buffs.Pool
	 * --------------------------------
	 ]]--
	function FTC.SCT:CreateSCTOut()

	    -- Get the pool and counter
	    local pool 		= FTC.SCT.OutPool
	    local counter   = pool:GetNextControlId()

	    -- Create buff
	    local control  	= FTC.UI:Control(  "FTC_SCTOut"..counter,            FTC_UI,  	{400,50},  	{CENTER,CENTER,0,0}, 				false )
	    control.value 	= FTC.UI:Label(    "FTC_SCTOut"..counter.."_Value",  control,  	{90,50},  	{LEFT,LEFT,60,0},  					nil , {1,1,1,1}, {0,1}, "Value", false )
	    control.name   	= FTC.UI:Label(    "FTC_SCTOut"..counter.."_Name",   control,  	{250,50},  	{LEFT,RIGHT,10,0,control.value}, 	nil , {1,1,1,1}, {0,1}, "Name", false )
	    control.bg   	= FTC.UI:Backdrop( "FTC_SCTOut"..counter.."_BG",     control,   {48,48},  	{LEFT,LEFT,0,0},  					{0,0,0,0.6}, {0,0,0,0.6}, nil, false )
	    control.icon    = FTC.UI:Texture(  "FTC_SCTOut"..counter.."_Icon",   control,   {40,40},  	{CENTER,CENTER,0,0,control.bg},		'/esoui/art/icons/icon_missing.dds', false )
	    control.frame   = FTC.UI:Texture(  "FTC_SCTOut"..counter.."_Frame",  control,   {44,44},    {CENTER,CENTER,0,0,control.icon}, 	'/esoui/art/actionbar/icon_metal04.dds', false )
	   

	   -- Apply some options
	   control.value:SetResizeToFitDescendents(true)
	   control.name:SetResizeToFitDescendents(true)

	    -- Return buff to pool
	    return control
	end

	--[[ 
	 * Add New Incoming SCT to Pool
	 * --------------------------------
	 * Called by FTC.Buffs.Pool
	 * --------------------------------
	 ]]--
	function FTC.SCT:CreateSCTIn()

	    -- Get the pool and counter
	    local pool 		= FTC.SCT.InPool
	    local counter   = pool:GetNextControlId()

	    -- Create buff
	    local control  	= FTC.UI:Control(  "FTC_SCTIn"..counter,            FTC_UI,  	{400,50},  	{CENTER,CENTER,0,0}, 				false )
	    control.value 	= FTC.UI:Label(    "FTC_SCTIn"..counter.."_Value",  control,  	{90,50},  	{RIGHT,RIGHT,-60,0},  				FTC.UI:Font("antique",FTC.Vars.SCTFontSize+2,true) , {1,1,1,1}, {0,2}, "Value", false )
	    control.name   	= FTC.UI:Label(    "FTC_SCTIn"..counter.."_Name",   control,  	{250,50},  	{RIGHT,LEFT,-10,0,control.value}, 	FTC.UI:Font("antique",FTC.Vars.SCTFontSize,true) , {1,1,1,1}, {0,2}, "Name", false )
	    control.bg   	= FTC.UI:Backdrop( "FTC_SCTIn"..counter.."_BG",     control,   	{48,48},  	{RIGHT,RIGHT,0,0},  				{0,0,0,0.8}, {0,0,0,0.8}, nil, false )
	    control.icon    = FTC.UI:Texture(  "FTC_SCTIn"..counter.."_Icon",   control,   	{40,40},  	{CENTER,CENTER,0,0,control.bg},		'/esoui/art/icons/icon_missing.dds', false )
	    control.frame   = FTC.UI:Texture(  "FTC_SCTIn"..counter.."_Frame",  control,   	{44,44},    {CENTER,CENTER,0,0,control.icon}, 	'/esoui/art/actionbar/icon_metal04.dds', false )
	   
	   -- Apply some options
	   control.value:SetResizeToFitDescendents(true)
	   control.name:SetResizeToFitDescendents(true)

	    -- Return buff to pool
	    return control
	end

	--[[ 
	 * Release Control to Pool Callback
	 * --------------------------------
	 * Called by FTC.Buffs.Pool
	 * --------------------------------
	 ]]--
	function FTC.SCT:ReleaseSCT(object)
	    object:SetHidden(true)
	end