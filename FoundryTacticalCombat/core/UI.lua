
--[[----------------------------------------------------------
    INITIALIZE UI ASSETS
  ]]----------------------------------------------------------

-- Fonts
FTC.UI.Fonts        = {
    ["meta"]        = "FoundryTacticalCombat/lib/fonts/Metamorphous.otf",
    ["standard"]    = "EsoUi/Common/Fonts/Univers57.otf",
    ["esobold"]     = "EsoUi/Common/Fonts/Univers67.otf",
    ["antique"]     = "EsoUI/Common/Fonts/ProseAntiquePSMT.otf",
    ["handwritten"] = "EsoUI/Common/Fonts/Handwritten_Bold.otf",
    ["trajan"]      = "EsoUI/Common/Fonts/TrajanPro-Regular.otf",
    ["futura"]      = "EsoUI/Common/Fonts/FuturaStd-CondensedLight.otf",
    ["futurabold"]  = "EsoUI/Common/Fonts/FuturaStd-Condensed.otf",
}

-- Textures
FTC.UI.Textures     = {
    ["grainy"]      = 'FoundryTacticalCombat/lib/textures/grainy.dds',
    ["regenLg"]     = 'FoundryTacticalCombat/lib/textures/regen_lg.dds',
    ["regenSm"]     = 'FoundryTacticalCombat/lib/textures/regen_sm.dds',
}

--[[ 
 * Initialize FTC UI Layer
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]-- 
function FTC.UI:Initialize()
    FTC.UI:TopLevelWindow( "FTC_UI" , GuiRoot , {GuiRoot:GetWidth(),GuiRoot:GetHeight()} , {CENTER,CENTER,0,0} , false )
end

--[[----------------------------------------------------------
    FONTS
  ]]----------------------------------------------------------

--[[ 
 * Translate between font name and tag
 * --------------------------------
 * Called by FTC.Menu:Controls()
 * --------------------------------
 ]]-- 
function FTC.UI:TranslateFont( font )

    -- Maintain a translation between tags and names
    local fonts = {
        ['meta']        = "Metamorphous",
        ["standard"]    = "ESO Standard",
        ["esobold"]     = "ESO Bold",
        ["antique"]     = "Prose Antique",
        ["handwritten"] = "Handwritten",
        ["trajan"]      = "Trajan Pro",
        ["futura"]      = "Futura Standard",
        ["futurabold"]  = "Futura Bold",
    }

    -- Iterate through the table matching
    for k,v in pairs(fonts) do
        if ( font == k ) then return v
        elseif ( font == v ) then return k end
    end
end

--[[ 
 * Retrieve requested font, size, and style
 * --------------------------------
 * Called at control creation
 * --------------------------------
 ]]-- 
function FTC.UI:Font( font , size , shadow)
    
    local font = ( FTC.UI.Fonts[font] ~= nil ) and FTC.UI.Fonts[font] or font
    local size = size or 14
    local shadow = shadow and '|soft-shadow-thick' or ''

    -- Return font
    return font..'|'..size..shadow
end

--[[----------------------------------------------------------
    UI CREATION FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Top Level Window
 ]]-- 
function FTC.UI:TopLevelWindow( name , parent , dims , anchor , hidden )
    
    -- Validate arguments
    if ( name == nil or name == "" ) then return end
    parent = ( parent == nil ) and GuiRoot or parent
    if ( #dims ~= 2 ) then return end
    if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
    hidden = ( hidden == nil ) and false or hidden
    
    -- Create the window
    local window = _G[name]
    if ( window == nil ) then window = WINDOW_MANAGER:CreateTopLevelWindow( name ) end

    -- Apply properties
    window = FTC.Chain( window )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
        :SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
        :SetHidden( hidden )
    .__END
    return window
end

--[[ 
 * Control
 ]]-- 
function FTC.UI:Control( name , parent , dims , anchor , hidden )
    
    -- Validate arguments
    if ( name == nil or name == "" ) then return end
    parent = ( parent == nil ) and GuiRoot or parent
    if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
    if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
    hidden = ( hidden == nil ) and false or hidden
    
    -- Create the control
    local control = _G[name]
    if ( control == nil ) then control = WINDOW_MANAGER:CreateControl( name , parent , CT_CONTROL ) end
    
    -- Apply properties
    local control = FTC.Chain( control )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
        :SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
        :SetHidden( hidden )
    .__END
    return control
end

--[[ 
 * Backdrop
 ]]-- 
function FTC.UI:Backdrop( name , parent , dims , anchor , center , edge , tex , hidden )
    
    -- Validate arguments
    if ( name == nil or name == "" ) then return end
    parent = ( parent == nil ) and GuiRoot or parent
    if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
    if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
    center = ( center ~= nil and #center == 4 ) and center or { 0,0,0,0.4 }
    edge = ( edge ~= nil and #edge == 4 ) and edge or { 0,0,0,1 }
    hidden = ( hidden == nil ) and false or hidden

    -- Create the backdrop
    local backdrop = _G[name]
    if ( backdrop == nil ) then backdrop = WINDOW_MANAGER:CreateControl( name , parent , CT_BACKDROP ) end
    
    -- Apply properties
    local backdrop = FTC.Chain( backdrop )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
        :SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
        :SetCenterColor( center[1] , center[2] , center[3] , center[4] )
        :SetEdgeColor( edge[1] , edge[2] , edge[3] , edge[4] )
        :SetEdgeTexture("",8,2,2)
        :SetHidden( hidden )
        :SetCenterTexture( tex )
    .__END
    return backdrop
end

--[[ 
 * Label
 ]]-- 
function FTC.UI:Label( name , parent , dims , anchor , font , color , align , text , hidden )
    
    -- Validate arguments
    if ( name == nil or name == "" ) then return end
    parent = ( parent == nil ) and GuiRoot or parent
    if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
    if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
    font    = ( font == nil ) and "ZoFontGame" or font
    color   = ( color ~= nil and #color == 4 ) and color or { 1 , 1 , 1 , 1 }
    align   = ( align ~= nil and #align == 2 ) and align or { 1 , 1 }
    hidden  = ( hidden == nil ) and false or hidden
    
    -- Create the label
    local label = _G[name]
    if ( label == nil ) then label = WINDOW_MANAGER:CreateControl( name , parent , CT_LABEL ) end

    -- Apply properties
    local label = FTC.Chain( label )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
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
function FTC.UI:Statusbar( name , parent , dims , anchor , color , tex , hidden )
    
    -- Validate arguments
    if ( name == nil or name == "" ) then return end
    parent = ( parent == nil ) and GuiRoot or parent
    if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
    if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
    color = ( color ~= nil and #color == 4 ) and color or { 1 , 1 , 1 , 1 }
    hidden = ( hidden == nil ) and false or hidden
    
    -- Create the status bar
    local bar = _G[name]
    if ( bar == nil ) then bar = WINDOW_MANAGER:CreateControl( name , parent , CT_STATUSBAR ) end

    -- Apply properties
    local bar = FTC.Chain( bar )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
        :SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
        :SetColor( color[1] , color[2] , color[3] , color[4] )
        :SetHidden( hidden )
        :SetTexture(tex)
    .__END
    return bar
end

--[[ 
 * Texture
 ]]-- 
function FTC.UI:Texture( name , parent , dims , anchor , tex , hidden )
    
    -- Validate arguments
    if ( name == nil or name == "" ) then return end
    parent = ( parent == nil ) and GuiRoot or parent
    if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
    if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
    if ( tex == nil ) then tex = '/esoui/art/icons/icon_missing.dds' end
    hidden = ( hidden == nil ) and false or hidden
    
    -- Create the texture
    local texture = _G[name]
    if ( texture == nil ) then texture = WINDOW_MANAGER:CreateControl( name , parent , CT_TEXTURE ) end

    -- Apply properties
    local texture = FTC.Chain( texture )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
        :SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
        :SetTexture(tex)
        :SetHidden( hidden )
    .__END
    return texture
end

--[[ 
 * Cooldown
 ]]-- 
function FTC.UI:Cooldown( name , parent , dims , anchor , color , hidden )
    
    -- Validate arguments
    if ( name == nil or name == "" ) then return end
    parent = ( parent == nil ) and GuiRoot or parent
    if ( dims == "inherit" or #dims ~= 2 ) then dims = { parent:GetWidth() , parent:GetHeight() } end
    if ( #anchor ~= 4 and #anchor ~= 5 ) then return end
    color = ( color ~= nil and #color == 4 ) and color or { 1 , 1 , 1 , 1 }
    hidden = ( hidden == nil ) and false or hidden
    
    -- Create the texture
    local cooldown = _G[name]
    if ( cooldown == nil ) then cooldown = WINDOW_MANAGER:CreateControl( name , parent , CT_COOLDOWN ) end

    -- Apply properties
    local cooldown = FTC.Chain( cooldown )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
        :SetAnchor( anchor[1] , #anchor == 5 and anchor[5] or parent , anchor[2] , anchor[3] , anchor[4] )
        :SetFillColor( color[1] , color[2] , color[3] , color[4] )
    .__END
    return cooldown
end

--[[ 
 * Button
 ]]-- 
function FTC.UI:Button( name , parent , dims , anchor , state , font , align , normal , pressed , mouseover , hidden )
    
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
    
    -- Create the button
    local button = _G[name]
    if ( button == nil ) then button = WINDOW_MANAGER:CreateControl( name , parent , CT_BUTTON ) end

    -- Apply properties
    local button = FTC.Chain( button )
        :SetDimensions( dims[1] , dims[2] )
        :ClearAnchors()
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