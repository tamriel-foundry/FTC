 
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
    CTO.backdrop 	= FTC.UI:Backdrop(  "FTC_SCTOut_BG",        CTO,     	"inherit",              {CENTER,CENTER,0,0},      	{0,0,0,0.4}, {0,0,0,1}, nil, false )
    CTO.backdrop:SetEdgeTexture("",16,4,4)
    CTO.label       = FTC.UI:Label(     "FTC_SCTOut_Label",     CTO,        "inherit",              {CENTER,CENTER,0,0},       	FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Outgoing Damage" , false )   
    CTO:SetDrawLayer(2)
    CTO:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

    -- Define pool for outgoing damage events
    if ( FTC.SCT.SCTPool == nil ) then FTC.SCT.SCTPool  = ZO_ObjectPool:New( FTC.SCT.CreateSCT , function(object) FTC.SCT:ReleaseSCT(object) end ) end

	--[[
	
	-- Create incoming damage container
	local name		= "FTC_CombatTextIn"
	local anchor	= FTC.vars[name]
	local CTI 		= FTC.UI.TopLevelWindow( name , GuiRoot , {FTC.vars.SCTNames and 400 or 150,750} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )
	CTI.backdrop 	= FTC.UI.Backdrop( name.."_Backdrop" , CTI , "inherit" , {CENTER,CENTER,0,0} , nil , nil , true )	
	CTI.label		= FTC.UI.Label( name.."_Label" , CTI , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Incoming Damage" , true )
	
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
	
	-- Iterate over SCT types creating containers
	local types	= { "In" , "Out" , "Status" }
	for t = 1, #types do
		
		-- Create 10 combat text containers	
		local parent = _G[ "FTC_CombatText"..types[t] ]
		for i = 1 , FTC.vars.SCTCount do

			-- Alternate offsets and alignments
			local align 	= ( i % 2 == 0 ) and 2 or 0
			local offsetX 	= ( i % 2 == 0 ) and -100 or 100
			local offsetY 	= ( i % 2 == 0 ) and -25 or 25
			if ( i % 3 == 0 ) then	offsetY = 0	end
			
			-- Status effects are always center aligned
			if ( types[t] == "Status" ) then
				align = 1
				offsetX = 0
			end
			
			-- Create the SCT label
			local sctLabel = FTC.UI.Label( "FTC_SCT"..types[t]..i , parent , { parent:GetWidth() , 30 } , {BOTTOM,BOTTOM,offsetX,offsetY} , nil , nil , {align,1} , nil , false )
			
			-- Record offsets
			sctLabel.offsetX 	= offsetX
			sctLabel.offsetY 	= offsetY
			sctLabel.align		= align
		end	
	end
	]]--
	
end


--[[----------------------------------------------------------
    BUFF POOL FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Add New Buff Control to Pool
 * --------------------------------
 * Called by FTC.Buffs.Pool
 * --------------------------------
 ]]--
function FTC.SCT:CreateSCT()

    -- Get the pool and counter
    local pool      = FTC.SCT.SCTPool
    local counter   = pool:GetNextControlId()

    -- Create buff
    local control  	= FTC.UI:Control(  "FTC_SCTOut"..counter,            FTC_UI,  	{400,50},  	{CENTER,CENTER,0,0}, 				false )
    control.value 	= FTC.UI:Label(    "FTC_SCTOut"..counter.."_Value",  control,  	{90,50},  	{LEFT,LEFT,60,0},  					FTC.UI:Font("esobold",FTC.Vars.SCTFontSize,true) , {1,1,1,1}, {0,1}, "Value", false )
    control.name   	= FTC.UI:Label(    "FTC_SCTOut"..counter.."_Name",   control,  	{250,50},  	{RIGHT,RIGHT,0,0},  				FTC.UI:Font("esobold",FTC.Vars.SCTFontSize,true) , {1,1,1,1}, {0,1}, "Name", false )
    control.bg   	= FTC.UI:Backdrop( "FTC_SCTOut"..counter.."_BG",     control,   {48,48},  	{LEFT,LEFT,0,0},  					{0,0,0,0.8}, {0,0,0,0.8}, nil, false )
    control.icon    = FTC.UI:Texture(  "FTC_SCTOut"..counter.."_Icon",   control,   {40,40},  	{CENTER,CENTER,0,0,control.bg},		'/esoui/art/icons/icon_missing.dds', false )
    control.frame   = FTC.UI:Texture(  "FTC_SCTOut"..counter.."_Frame",  control,   {44,44},    {CENTER,CENTER,0,0,control.icon}, 	'/esoui/art/actionbar/icon_metal04.dds', false )
   
    -- Return buff to pool
    return control
end

-- test /script FTC.SCT.SCTPool:AcquireObject()

--[[ 
 * Release Control to Pool Callback
 * --------------------------------
 * Called by FTC.Buffs.Pool
 * --------------------------------
 ]]--
function FTC.SCT:ReleaseSCT(object)
    object:SetHidden(true)
end