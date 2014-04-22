--[[----------------------------------------------------------
	FTC UI CREATION
	----------------------------------------------------------
	* Template functions for quickly setting up the UI elements used by FTC.
	* Eeach template accepts the primary arguments needed for the control type.
	* Additional advanced properties must be set manually after creation.
  ]]--

--[[ 
 * Configure custom fonts
 ]]-- 
FTC.Fonts = {}
function FTC.Fonts.meta( size )
	local size = size or 14
	return 'FoundryTacticalCombat/lib/Metamorphous.otf|'..size..'|soft-shadow-thick'
end

FTC.UI = {}

--[[ 
 * Top Level Window
 ]]-- 
function FTC.UI.TopLevelWindow( name , parent , dims , anchor , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( #dims ~= 2 ) then return end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	hidden = ( hidden == nil ) and false or hidden
	
	-- Create the container
	local window = FTC.Chain( WINDOW_MANAGER:CreateTopLevelWindow( name ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetHidden( hidden )
	.__END
	return window
end

--[[ 
 * Generic Control
 ]]-- 
function FTC.UI.Control( name , parent , dims , anchor , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	hidden = ( hidden == nil ) and false or hidden
	
	-- Create the control
	local control = FTC.Chain( WINDOW_MANAGER:CreateControl( name , parent , CT_CONTROL ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetHidden( hidden )
	.__END
	return control
end

--[[ 
 * Backdrop
 ]]-- 
function FTC.UI.Backdrop( name , parent , dims , anchor , center , edge , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	center = ( center ~= nil and #center == 4 ) and center or { 0,0,0,0.4 }
	edge = ( edge ~= nil and #edge == 4 ) and edge or { 0,0,0,0.6 }
	hidden = ( hidden == nil ) and false or hidden
	
	-- Create the backdrop
	local control = FTC.Chain( WINDOW_MANAGER:CreateControl( name , parent , CT_BACKDROP ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetCenterColor( center[1] , center[2] , center[3] , center[4] )
		:SetEdgeColor( edge[1] , edge[2] , edge[3] , edge[4] )
		:SetEdgeTexture("",8,1,2)
		:SetHidden( hidden )
	.__END
	return control
end

--[[ 
 * Label
 ]]-- 
function FTC.UI.Label( name , parent , dims , anchor , font , color , align , text , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	font 	= ( font == nil ) and "ZoFontGame" or font
	color 	= ( color ~= nil and #color == 4 ) and color or { 1 , 1 , 1 , 1 }
	align 	= ( align ~= nil and #align == 2 ) and align or { 1 , 1 }
	hidden 	= ( hidden == nil ) and false or hidden
	
	-- Create the label
	local label = FTC.Chain( WINDOW_MANAGER:CreateControl( name , parent , CT_LABEL ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetFont( font )
		:SetColor( color[1] , color[2] , color[3] , color[4] )
		:SetHorizontalAlignment( align[1] )
		:SetVerticalAlignment( align[2] )
		:SetText( text )
		:SetHidden( hidden )
	.__END
	return label
end

--[[ 
 * Status Bar
 ]]-- 
function FTC.UI.Statusbar( name , parent , dims , anchor , color , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	color = ( color ~= nil and #color == 4 ) and color or { 1 , 1 , 1 , 1 }
	hidden = ( hidden == nil ) and false or hidden
	
	-- Create the backdrop
	local backdrop = FTC.Chain( WINDOW_MANAGER:CreateControl( name , parent , CT_STATUSBAR ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetColor( color[1] , color[2] , color[3] , color[4] )
		:SetHidden( hidden )
	.__END
	return backdrop
end

--[[ 
 * Texture
 ]]-- 
function FTC.UI.Texture( name , parent , dims , anchor , tex , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	if ( tex == nil ) then tex = '/esoui/art/icons/icon_missing.dds' end
	hidden = ( hidden == nil ) and false or hidden
	
	-- Create the backdrop
	local texture = FTC.Chain( WINDOW_MANAGER:CreateControl( name , parent , CT_TEXTURE ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetTexture(tex)
		:SetHidden( hidden )
	.__END
	return texture
end

--[[ 
 * Cooldown
 ]]-- 
function FTC.UI.Cooldown( name , parent , dims , anchor , color , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	color = ( color ~= nil and #color == 4 ) and color or { 1 , 1 , 1 , 1 }
	hidden = ( hidden == nil ) and false or hidden
	
	-- Create the cooldown
	local cooldown = FTC.Chain( WINDOW_MANAGER:CreateControl( name , parent , CT_COOLDOWN ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetFillColor( color[1] , color[2] , color[3] , color[4] )
	.__END
	return cooldown
end

--[[ 
 * Button
 ]]-- 
function FTC.UI.Button( name , parent , dims , anchor , state , font , align , normal , pressed , mouseover , hidden )
	
	-- Validate arguments
	if ( name == nil or name == "" ) then return end
	parent = ( parent == nil ) and GuiRoot or parent
	if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
	if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
	state = ( state ~= nil ) and state or BSTATE_NORMAL
	font = ( font == nil ) and "ZoFontGame" or font
	align = ( align ~= nil and #align == 2 ) and align or { 1 , 1 }
	normal = ( normal ~= nil and #normal == 4 ) and normal or { 1 , 1 , 1 , 1 }
	pressed = ( pressed ~= nil and #pressed == 4 ) and pressed or { 1 , 1 , 1 , 1 }
	mouseover = ( mouseover ~= nil and #mouseover == 4 ) and mouseover or { 1 , 1 , 1 , 1 }
	hidden = ( hidden == nil ) and false or hidden
	
	-- Create the backdrop
	local button = FTC.Chain( WINDOW_MANAGER:CreateControl( name , parent , CT_BUTTON ) )
		:SetDimensions( dims[1] , dims[2] )
		:SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
		:SetState( state )
		:SetFont( font )
		:SetNormalFontColor( normal[1] , normal[2] , normal[3] , normal[4] )
		:SetPressedFontColor( pressed[1] , pressed[2] , pressed[3] , pressed[4] )
		:SetMouseOverFontColor( mouseover[1] , mouseover[2] , mouseover[3] , mouseover[4] )
		:SetHorizontalAlignment( align[1] )
		:SetVerticalAlignment( align[2] )
		:SetHidden( hidden )
	.__END
	return button
end