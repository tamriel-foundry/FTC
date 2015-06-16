 
--[[----------------------------------------------------------
    UNIT FRAMES CONTROLS
  ]]----------------------------------------------------------

--[[ 
 * Create Unit Frames UI
 * --------------------------------
 * Called by FTC.Frames:Initialize()
 * Called by FTC.Menu:UpdateFrames()
 * --------------------------------
 ]]--
function FTC.Frames:Controls()
    
    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        PLAYER FRAME                    NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
    -- Create the player frame container    
    local player    = FTC.UI:Control(   "FTC_PlayerFrame",                  FTC_UI,     {FTC.Vars.FrameWidth,FTC.Vars.FrameHeight},             FTC.Vars.FTC_PlayerFrame,       false )  
    player.backdrop = FTC.UI:Backdrop(  "FTC_PlayerFrame_BG",               player,     "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
    player.label    = FTC.UI:Label(     "FTC_PlayerFrame_Label",            player,     "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , GetString(FTC_PF_Label) , true )   
    player.backdrop:SetEdgeTexture("",16,4,4)
    player:SetDrawTier(DT_HIGH)
    player:SetAlpha(FTC.Vars.FrameOpacityOut/100)
    player:SetMovable(true)
    player:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

    -- Nameplate
    local plate     = FTC.UI:Control(   "FTC_PlayerFrame_Plate",            player,     {player:GetWidth(),player:GetHeight()/6},               {TOP,TOP,0,0}, false ) 
    plate.name      = FTC.UI:Label(     "FTC_PlayerFrame_PlateName",        plate,      {plate:GetWidth()-42,30},                               {BOTTOMLEFT,BOTTOMLEFT,6,0},    FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.FrameFontSize+2,true), nil, {0,1}, "Player Name (Level)", false )   
    plate.class     = FTC.UI:Texture(   "FTC_PlayerFrame_PlateClass",       plate,      {36,36},                                                {BOTTOMRIGHT,BOTTOMRIGHT,0,2},  GetClassIcon(GetUnitClassId('player')), false )
    player.plate    = plate

    --Health Bar
    local health    = FTC.UI:Backdrop(  "FTC_PlayerFrame_Health",           player,     {player:GetWidth(),player:GetHeight()*2/6},             {TOP,BOTTOM,0,0,player.plate},  {FTC.Vars.FrameHealthColor[1]/5,FTC.Vars.FrameHealthColor[2]/5,FTC.Vars.FrameHealthColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, false ) 
    health.bar      = FTC.UI:Statusbar( "FTC_PlayerFrame_HealthBar",        health,     {health:GetWidth()-4,health:GetHeight()-4},             {TOPLEFT,TOPLEFT,2,2},          {FTC.Vars.FrameHealthColor[1],FTC.Vars.FrameHealthColor[2],FTC.Vars.FrameHealthColor[3],1}, FTC.UI.Textures.grainy, false )   
    health.current  = FTC.UI:Label(     "FTC_PlayerFrame_HealthCurrent",    health,     {health:GetWidth()*2/3,health:GetHeight()},             {LEFT,LEFT,12,-2},              FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.FrameFontSize+2,true), nil, {0,1}, 'Health', false )       
    health.pct      = FTC.UI:Label(     "FTC_PlayerFrame_HealthPct",        health,     {health:GetWidth()*1/3,health:GetHeight()},             {RIGHT,RIGHT,-12,-2},           FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.FrameFontSize+2,true), nil, {2,1}, 'Pct%', false )
    health.hot      = FTC.UI:Texture(   "FTC_PlayerFrame_HealthHoT",        health,     {health.bar:GetWidth()/6,health.bar:GetWidth()/12},     {LEFT,CENTER,6,0},              FTC.UI.Textures.regenLg, true )
    health.dot      = FTC.UI:Texture(   "FTC_PlayerFrame_HealthDoT",        health,     {health.bar:GetWidth()/6,health.bar:GetWidth()/12},     {RIGHT,CENTER,0,0},             FTC.UI.Textures.regenLg, true )
    health.dot:SetTextureRotation(math.pi)
    player.health   = health    

    
    -- Magicka Bar
    local magicka   = FTC.UI:Backdrop(  "FTC_PlayerFrame_Magicka",          player,     {player:GetWidth(),(player:GetHeight()/6)+2},           {TOP,BOTTOM,0,-2,health},       {FTC.Vars.FrameMagickaColor[1]/5,FTC.Vars.FrameMagickaColor[2]/5,FTC.Vars.FrameMagickaColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, false )   
    magicka.bar     = FTC.UI:Statusbar( "FTC_PlayerFrame_MagickaBar",       magicka,    {magicka:GetWidth()-4,magicka:GetHeight()-4},           {TOPLEFT,TOPLEFT,2,2},          {FTC.Vars.FrameMagickaColor[1],FTC.Vars.FrameMagickaColor[2],FTC.Vars.FrameMagickaColor[3],1}, FTC.UI.Textures.grainy, false )
    magicka.current = FTC.UI:Label(     "FTC_PlayerFrame_MagickaCurrent",   magicka,    {magicka:GetWidth()*2/3,magicka:GetHeight()},           {LEFT,LEFT,12,0},               FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.FrameFontSize,true), nil, {0,1}, 'Magicka', false )
    magicka.pct     = FTC.UI:Label(     "FTC_PlayerFrame_MagickaPct",       magicka,    {magicka:GetWidth()*1/3,magicka:GetHeight()},           {RIGHT,RIGHT,-12,0},            FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.FrameFontSize,true), nil, {2,1}, 'Pct%', false )
    magicka.hot     = FTC.UI:Texture(   "FTC_PlayerFrame_MagickaHoT",       magicka,    {magicka.bar:GetWidth()/6,magicka.bar:GetWidth()/12},   {LEFT,CENTER,6,0},              FTC.UI.Textures.regenSm, true )
    magicka.dot     = FTC.UI:Texture(   "FTC_PlayerFrame_MagickaDoT",       magicka,    {magicka.bar:GetWidth()/6,magicka.bar:GetWidth()/12},   {RIGHT,CENTER,0,0},             FTC.UI.Textures.regenSm, true )
    magicka.dot:SetTextureRotation(math.pi)
    player.magicka  = magicka

    -- Stamina Bar
    local stamina   = FTC.UI:Backdrop(  "FTC_PlayerFrame_Stamina",          player,     {player:GetWidth(),(player:GetHeight()/6)+2},           {TOP,BOTTOM,0,-2,magicka},      {FTC.Vars.FrameStaminaColor[1]/5,FTC.Vars.FrameStaminaColor[2]/5,FTC.Vars.FrameStaminaColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, false )   
    stamina.bar     = FTC.UI:Statusbar( "FTC_PlayerFrame_StaminaBar",       stamina,    {stamina:GetWidth()-4,stamina:GetHeight()-4},           {TOPLEFT,TOPLEFT,2,2},          {FTC.Vars.FrameStaminaColor[1],FTC.Vars.FrameStaminaColor[2],FTC.Vars.FrameStaminaColor[3],1}, FTC.UI.Textures.grainy, false )    
    stamina.current = FTC.UI:Label(     "FTC_PlayerFrame_StaminaCurrent",   stamina,    {stamina:GetWidth()*2/3,stamina:GetHeight()},           {LEFT,LEFT,12,0},               FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.FrameFontSize,true), nil, {0,1}, 'Stamina', false )      
    stamina.pct     = FTC.UI:Label(     "FTC_PlayerFrame_StaminaPct",       stamina,    {stamina:GetWidth()*1/3,stamina:GetHeight()},           {RIGHT,RIGHT,-12,0},            FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.FrameFontSize,true), nil, {2,1}, 'Pct%', false )
    stamina.hot     = FTC.UI:Texture(   "FTC_PlayerFrame_StaminaHoT",       stamina,    {stamina.bar:GetWidth()/6,stamina.bar:GetWidth()/12},   {LEFT,CENTER,6,0},              FTC.UI.Textures.regenSm, true )
    stamina.dot     = FTC.UI:Texture(   "FTC_PlayerFrame_StaminaDoT",       stamina,    {stamina.bar:GetWidth()/6,stamina.bar:GetWidth()/12},   {RIGHT,CENTER,0,0},             FTC.UI.Textures.regenSm, true )
    stamina.dot:SetTextureRotation(math.pi)
    player.stamina  = stamina
    
    -- Shield Bar
    local shield    = FTC.UI:Backdrop(  "FTC_PlayerFrame_Shield",           health,     {player:GetWidth(),health:GetHeight()/4},               {BOTTOMLEFT,BOTTOMLEFT,0,0},    {FTC.Vars.FrameShieldColor[1]/5,FTC.Vars.FrameShieldColor[2]/5,FTC.Vars.FrameShieldColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, true )   
    shield.bar      = FTC.UI:Statusbar( "FTC_PlayerFrame_ShieldBar",        shield,     {shield:GetWidth()-4,shield:GetHeight()-4},             {TOPLEFT,TOPLEFT,2,2},          {FTC.Vars.FrameShieldColor[1],FTC.Vars.FrameShieldColor[2],FTC.Vars.FrameShieldColor[3],1}, FTC.UI.Textures.grainy, false )
    player.shield   = shield
    shield:SetDrawLayer(DL_OVERLAY)
      
    -- Alternate Progress Bar
    local alt       = FTC.UI:Control(   "FTC_PlayerFrame_Alt",              player,     {player:GetWidth(),math.min(player:GetHeight()/6,30)},  {TOP,BOTTOM,0,4,stamina},       false ) 
    alt.bg          = FTC.UI:Backdrop(  "FTC_PlayerFrame_AltBG",            alt,        {alt:GetWidth()-36,alt:GetHeight()*(2/3)},              {RIGHT,RIGHT,0,0},              {0,0.1,0.1,1}, {0,0,0,1}, FTC.UI.Textures.grainy, false ) 
    alt.bar         = FTC.UI:Statusbar( "FTC_PlayerFrame_AltBar",           alt.bg,     {alt.bg:GetWidth()-6,alt.bg:GetHeight()-8},             {LEFT,LEFT,3,0},                {0,1,1,1}, FTC.UI.Textures.grainy, false )
    alt.icon        = FTC.UI:Texture(   "FTC_PlayerFrame_AltIcon",          alt,        {30,30},                                                {LEFT,LEFT,0,0},                "/esoui/art/champion/champion_points_magicka_icon-hud-32.dds", false )
    player.alt      = alt
    alt.context     = 'exp'
    shield:SetDrawLayer(1)

    -- Default Player Frames
    local stats     = { "Health" , "Stamina" , "Magicka" }
    for  i = 1 , #stats , 1 do
        local parent    = _G["ZO_PlayerAttribute"..stats[i]]
        local label     = FTC.UI:Label( "FTC_Player"..string.lower(stats[i]) , parent , { parent:GetWidth() , 30 } , {CENTER,CENTER,0,-1} , FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.FrameFontSize,true) , nil , {1,1} , nil , false )      
    end

    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        TARGET FRAME                    NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
    -- Create the target frame container  
    local target    = FTC.UI:Control(   "FTC_TargetFrame",                  FTC_UI,     {FTC.Vars.FrameWidth,FTC.Vars.FrameHeight*(4/6)},       FTC.Vars.FTC_TargetFrame,       true )
    target.backdrop = FTC.UI:Backdrop(  "FTC_TargetFrame_BG",               target,     "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true ) 
    target.label    = FTC.UI:Label(     "FTC_TargetFrame_Label",            target,     "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , GetString(FTC_TF_Label) , true )   
    target.backdrop:SetEdgeTexture("",16,4,4)
    target:SetDrawTier(DT_HIGH)
    target:SetAlpha(FTC.Vars.FrameOpacityOut/100)
    target:SetMovable(true)
    target:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end) 

    -- Nameplate
    local plate     = FTC.UI:Control(   "FTC_TargetFrame_Plate",            target,     {target:GetWidth(),(target:GetHeight()/4)},             {TOP,TOP,0,0}, false ) 
    plate.name      = FTC.UI:Label(     "FTC_TargetFrame_PlateName",        plate ,     {plate:GetWidth()-42,30},                               {BOTTOMLEFT,BOTTOMLEFT,6,0},    FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.FrameFontSize+2,true), nil, {0,1}, "Target Name (Level)", false ) 
    plate.class     = FTC.UI:Texture(   "FTC_TargetFrame_PlateClass",       plate ,     {36,36},                                                {BOTTOMRIGHT,BOTTOMRIGHT,0,2},  "/esoui/art/contacts/social_classicon_" .. FTC.Player.class .. ".dds", false )
    target.plate    = plate

    -- Health Bar
    local health    = FTC.UI:Backdrop(  "FTC_TargetFrame_Health",           target,     {target:GetWidth(),target:GetHeight()/2},               {TOP,BOTTOM,0,0,target.plate},  {FTC.Vars.FrameHealthColor[1]/5,FTC.Vars.FrameHealthColor[2]/5,FTC.Vars.FrameHealthColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, false ) 
    health.bar      = FTC.UI:Statusbar( "FTC_TargetFrame_HealthBar",        health,     {health:GetWidth()-4,health:GetHeight()-4},             {LEFT,LEFT,2,0},                {FTC.Vars.FrameHealthColor[1],FTC.Vars.FrameHealthColor[2],FTC.Vars.FrameHealthColor[3],1}, FTC.UI.Textures.grainy, false )   
    health.current  = FTC.UI:Label(     "FTC_TargetFrame_HealthCurrent",    health,     {health:GetWidth()*2/3,health:GetHeight()},             {LEFT,LEFT,12,-2},              FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.FrameFontSize+2,true), nil, {0,1}, 'Health', false )       
    health.pct      = FTC.UI:Label(     "FTC_TargetFrame_HealthPct",        health,     {health:GetWidth()*1/3,health:GetHeight()},             {RIGHT,RIGHT,-12,-2},           FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.FrameFontSize+2,true), nil, {2,1}, 'Pct%', false )
    health.hot      = FTC.UI:Texture(   "FTC_TargetFrame_HealthHoT",        health,     {health.bar:GetWidth()/6,health.bar:GetWidth()/12},     {LEFT,CENTER,6,0},              FTC.UI.Textures.regenLg, true )
    health.dot      = FTC.UI:Texture(   "FTC_TargetFrame_HealthDoT",        health,     {health.bar:GetWidth()/6,health.bar:GetWidth()/12},     {RIGHT,CENTER,0,0},             FTC.UI.Textures.regenLg, true )
    health.dot:SetTextureRotation(math.pi)
    target.health   = health

    -- Execute Indicator
    local execute   = FTC.UI:Texture(   "FTC_TargetFrame_Execute",          health,     {36,36},                                                {CENTER,CENTER,0,0},            '/esoui/art/icons/mapkey/mapkey_groupboss.dds', true )
    execute:SetDrawLayer(1)
    target.execute  = execute

    -- Titleplate
    local lplate    = FTC.UI:Control(   "FTC_TargetFrame_LPlate",           target,     {target:GetWidth(),(target:GetHeight()/4)},             {TOP,BOTTOM,0,6,target.health}, false ) 
    lplate.title    = FTC.UI:Label(     "FTC_TargetFrame_LPlateTitle",      lplate,     {lplate:GetWidth(),30},                                 {RIGHT,RIGHT,-6,0},             FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.FrameFontSize,true), nil, {2,1}, 'Title', false )
    lplate.rank     = FTC.UI:Texture(   "FTC_TargetFrame_LPlateIcon",       lplate,     {30,30},                                                {LEFT,LEFT,0,0},                "/esoui/art/ava/ava_rankicon_sergeant.dds", false )        
    target.lplate   = lplate    

   -- Shield Bar
    local shield    = FTC.UI:Backdrop(  "FTC_TargetFrame_Shield",           health,     {player:GetWidth(),health:GetHeight()/4},               {BOTTOMLEFT,BOTTOMLEFT,0,0},    {FTC.Vars.FrameShieldColor[1]/5,FTC.Vars.FrameShieldColor[2]/5,FTC.Vars.FrameShieldColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, true )   
    shield.bar      = FTC.UI:Statusbar( "FTC_TargetFrame_ShieldBar",        shield,     {shield:GetWidth()-4,shield:GetHeight()-4},             {TOPLEFT,TOPLEFT,2,2},          {FTC.Vars.FrameShieldColor[1],FTC.Vars.FrameShieldColor[2],FTC.Vars.FrameShieldColor[3],1}, FTC.UI.Textures.grainy, false )
    target.shield   = shield
    shield:SetDrawLayer(1)

    -- Default Target Frame
    local parent        = _G["ZO_TargetUnitFramereticleover"]
    local label         = FTC.UI:Label( "FTC_Targethealth" , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,-1} , FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.FrameFontSize,true) , nil , {1,1} , nil , false )

    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        GROUP FRAME                     NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    -- Create the group frame container  
    local group     = FTC.UI:Control(   "FTC_GroupFrame",                   FTC_UI,     {FTC.Vars.GroupWidth,FTC.Vars.GroupHeight},             FTC.Vars.FTC_GroupFrame,        true )
    group.backdrop  = FTC.UI:Backdrop(  "FTC_GroupFrame_BG",                group,      "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true ) 
    group.label     = FTC.UI:Label(     "FTC_GroupFrame_Label",             group,      "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , GetString(FTC_GF_Label) , true )   
    group.backdrop:SetEdgeTexture("",16,4,4)
    group:SetAlpha(FTC.Vars.FrameOpacityOut/100)
    group:SetDrawTier(DT_HIGH)
    group:SetMovable(true)
    group:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)    

    -- Iterate over four group members
    local anchor    = {TOP,TOP,0,0,group}
    for i = 1 , 4 do
    local member    = FTC.UI:Control(   "FTC_GroupFrame"..i,                group,      {FTC.Vars.GroupWidth,FTC.Vars.GroupHeight/4},           anchor,                         true )
    member:SetAlpha(FTC.Vars.FrameOpacityIn/100)

    -- Nameplate
    local plate     = FTC.UI:Control(   "FTC_GroupFrame"..i.."_Plate",      member,     {member:GetWidth(),member:GetHeight()/3},               {TOP,TOP,0,0},                  false ) 
    plate.icon      = FTC.UI:Texture(   "FTC_GroupFrame"..i.."_Icon",       plate ,     {24,24},                                                {BOTTOMLEFT,BOTTOMLEFT,0,0},    "/esoui/art/lfg/lfg_leader_icon.dds", false )
    plate.name      = FTC.UI:Label(     "FTC_GroupFrame"..i.."_Name",       plate,      {plate:GetWidth()-24,plate:GetHeight()},                {LEFT,RIGHT,6,0,plate.icon},    FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.GroupFontSize,true), nil, {0,1}, "Member "..i, false ) 
    plate.class     = FTC.UI:Texture(   "FTC_GroupFrame"..i.."_Class",      plate ,     {24,24},                                                {BOTTOMRIGHT,BOTTOMRIGHT,0,0},  "/esoui/art/contacts/social_classicon_" .. FTC.Player.class .. ".dds", false )
    member.plate    = plate

    -- Health bar
    local health    = FTC.UI:Backdrop(  "FTC_GroupFrame"..i.."_Health",     member,     {member:GetWidth(),member:GetHeight()/2},               {TOP,BOTTOM,0,0,plate},         {FTC.Vars.FrameHealthColor[1]/5,FTC.Vars.FrameHealthColor[2]/5,FTC.Vars.FrameHealthColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, false ) 
    health.bar      = FTC.UI:Statusbar( "FTC_GroupFrame"..i.."_Bar",        health,     {health:GetWidth()-4,health:GetHeight()-4},             {LEFT,LEFT,2,0},                {FTC.Vars.FrameHealthColor[1],FTC.Vars.FrameHealthColor[2],FTC.Vars.FrameHealthColor[3],1}, FTC.UI.Textures.grainy, false )   
    health.current  = FTC.UI:Label(     "FTC_GroupFrame"..i.."_HealthCurrent", health,  {health:GetWidth()*2/3,health:GetHeight()},             {LEFT,LEFT,12,-2},              FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.GroupFontSize,true), nil, {0,1}, 'Health', false )       
    health.pct      = FTC.UI:Label(     "FTC_GroupFrame"..i.."_HealthPct",  health,     {health:GetWidth()*1/3,health:GetHeight()},             {RIGHT,RIGHT,-12,-2},           FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.GroupFontSize,true), nil, {2,1}, 'Pct%', false )
    member.health   = health

    local shield    = FTC.UI:Backdrop(  "FTC_GroupFrame"..i.."_Shield",     health,     {member:GetWidth(),health:GetHeight()/4},               {BOTTOMLEFT,BOTTOMLEFT,0,0},    {FTC.Vars.FrameShieldColor[1]/5,FTC.Vars.FrameShieldColor[2]/5,FTC.Vars.FrameShieldColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, true )   
    shield.bar      = FTC.UI:Statusbar( "FTC_GroupFrame"..i.."_ShieldBar",  shield,     {shield:GetWidth()-4,shield:GetHeight()-4},             {TOPLEFT,TOPLEFT,2,2},          {FTC.Vars.FrameShieldColor[1],FTC.Vars.FrameShieldColor[2],FTC.Vars.FrameShieldColor[3],1}, FTC.UI.Textures.grainy, false )
    member.shield   = shield
    shield:SetDrawLayer(1)

    -- Extra settings
    group["member"..i] = member
    anchor          = {TOP,BOTTOM,0,0,member}
    end

    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        RAID FRAME                      NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
    -- Create the group frame container 
    local col       = FTC.Vars.RaidColumnSize
    local raid      = FTC.UI:Control(   "FTC_RaidFrame",                    FTC_UI,     {FTC.Vars.RaidWidth*(24/col),FTC.Vars.RaidHeight*(col)},FTC.Vars.FTC_RaidFrame,         false )
    raid.backdrop   = FTC.UI:Backdrop(  "FTC_RaidFrame_BG",                 raid,       "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true ) 
    raid.label      = FTC.UI:Label(     "FTC_RaidFrame_Label",              raid,       "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , GetString(FTC_RF_Label) , true )   
    raid.backdrop:SetEdgeTexture("",16,4,4)
    raid:SetAlpha(FTC.Vars.FrameOpacityOut/100)
    raid:SetDrawTier(DT_HIGH)
    raid:SetMovable(true)
    raid:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)    

    -- Iterate over 24 possible raid members
    local anchor    = {TOPLEFT,TOPLEFT,0,0,raid}
    for i = 1 , 24 do
    local member    = FTC.UI:Control(   "FTC_RaidFrame"..i,                raid,        {FTC.Vars.RaidWidth,FTC.Vars.RaidHeight},               anchor,                         true)
    member:SetAlpha(FTC.Vars.FrameOpacityIn/100)

    -- Nameplate
    local plate     = FTC.UI:Control(   "FTC_RaidFrame"..i.."_Plate",      member,      {member:GetWidth(),member:GetHeight()/2},               {TOPLEFT,TOPLEFT,0,2},          false ) 
    plate.name      = FTC.UI:Label(     "FTC_RaidFrame"..i.."_Name",       plate,       {plate:GetWidth()-16,plate:GetHeight()},                {LEFT,LEFT,8,0},                FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.RaidFontSize,true), nil, {0,1}, "Member "..i, false ) 
    plate.icon      = FTC.UI:Texture(   "FTC_RaidFrame"..i.."_Icon",       plate ,      {24,24},                                                {TOPRIGHT,TOPRIGHT,-4,2,member}, "/esoui/art/lfg/lfg_leader_icon.dds", false )
    plate.icon:SetDrawLayer(DL_CONTROLS)
    member.plate    = plate

    -- Health bar
    local health    = FTC.UI:Backdrop(  "FTC_RaidFrame"..i.."_Health",     member,      {member:GetWidth(),member:GetHeight()},                 {CENTER,CENTER,0,0},            {FTC.Vars.FrameHealthColor[1]/5,FTC.Vars.FrameHealthColor[2]/5,FTC.Vars.FrameHealthColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, false ) 
    health.bar      = FTC.UI:Statusbar( "FTC_RaidFrame"..i.."_Bar",        health,      {health:GetWidth()-4,health:GetHeight()-4},             {LEFT,LEFT,2,0},                {FTC.Vars.FrameHealthColor[1],FTC.Vars.FrameHealthColor[2],FTC.Vars.FrameHealthColor[3],1}, FTC.UI.Textures.grainy, false )   
    health.current  = FTC.UI:Label(     "FTC_RaidFrame"..i.."_HealthCurrent", health,   {health:GetWidth()*2/3,member:GetHeight()/2},           {LEFT,LEFT,8,10},               FTC.UI:Font(FTC.Vars.FrameFont1,FTC.Vars.RaidFontSize,true), nil, {0,1}, 'H.Lk', false )       
    health.pct      = FTC.UI:Label(     "FTC_RaidFrame"..i.."_HealthPct",  health,      {health:GetWidth()*1/3,member:GetHeight()/2},           {RIGHT,RIGHT,-8,10},            FTC.UI:Font(FTC.Vars.FrameFont2,FTC.Vars.RaidFontSize,true), nil, {2,1}, 'Pct%', false )
    member.health   = health

    local shield    = FTC.UI:Backdrop(  "FTC_RaidFrame"..i.."_Shield",     health,      {member:GetWidth()/2,8},                                {BOTTOMLEFT,BOTTOMLEFT,0,0},    {FTC.Vars.FrameShieldColor[1]/5,FTC.Vars.FrameShieldColor[2]/5,FTC.Vars.FrameShieldColor[3]/5,1}, {0,0,0,1}, FTC.UI.Textures.grainy, true )   
    shield.bar      = FTC.UI:Statusbar( "FTC_RaidFrame"..i.."_ShieldBar",  shield,      {shield:GetWidth()-4,shield:GetHeight()-1},             {TOPLEFT,TOPLEFT,2,1},          {FTC.Vars.FrameShieldColor[1],FTC.Vars.FrameShieldColor[2],FTC.Vars.FrameShieldColor[3],1}, FTC.UI.Textures.grainy, false )
    member.shield   = shield
    shield:SetDrawLayer(1)

    -- Extra settings
    raid["member"..i] = member
    anchor          = ( i % col == 0 ) and {TOPLEFT,TOPRIGHT,-2,0,_G["FTC_RaidFrame"..(i-col+1)]} or {TOP,BOTTOM,0,-2,member}
    end
end

--[[----------------------------------------------------------
    UNIT FRAME ANIMATIONS
  ]]----------------------------------------------------------

--[[ 
 * Unit Frame Opacity Fading
 * --------------------------------
 * Called by FTC.Frames:Attribute()
 * --------------------------------
 ]]--
FTC.Frames.resetAnim = false
function FTC.Frames:Fade(unitTag,frame)

        -- Bail for invalid frames
        if ( not FTC.init.Frames or frame == nil or FTC.move ) then return end

        -- Determine display status
        local displayFrame = IsUnitInCombat(unitTag)

        -- Create a fade in animation
        if ( frame.fadeIn == nil or FTC.Frames.resetAnim ) then
            local animIn, timeIn = CreateSimpleAnimation(ANIMATION_ALPHA,frame,0)
            animIn:SetAlphaValues(FTC.Vars.FrameOpacityOut/100,FTC.Vars.FrameOpacityIn/100)
            animIn:SetEasingFunction(ZO_EaseInQuadratic)  
            animIn:SetDuration(500)
            frame.fadeIn = timeIn
        end

        -- Create a fade out animation
        if ( frame.fadeOut == nil or FTC.Frames.resetAnim ) then
            local animOut, timeOut = CreateSimpleAnimation(ANIMATION_ALPHA,frame,0)
            animOut:SetAlphaValues(FTC.Vars.FrameOpacityIn/100,FTC.Vars.FrameOpacityOut/100)
            animOut:SetEasingFunction(ZO_EaseOutQuadratic)  
            animOut:SetDuration(2000)
            frame.fadeOut = timeOut
        end 

        -- Bail if an animation is already playing
        if ( frame.fadeIn:IsPlaying() or frame.fadeOut:IsPlaying() ) then return end

        -- Bail if we are already at the desired alpha
        if ( not displayFrame and ( zo_round(frame:GetAlpha()*100) == FTC.Vars.FrameOpacityOut ) or displayFrame and (  zo_round(frame:GetAlpha()*100) == FTC.Vars.FrameOpacityIn ) ) then return end

        -- Otherwise perform the appropriate animation
        local timeline = displayFrame and frame.fadeIn or frame.fadeOut
        timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
        timeline:PlayFromStart()
end

--[[ 
 * Target Frame Execute Animation
 * --------------------------------
 * Called by FTC.Frames:Attribute()
 * --------------------------------
 ]]--
function FTC.Frames:Execute()

    -- Determine conexect
    local exec = _G["FTC_TargetFrame_Execute"]

    if ( exec.timeline == nil ) then        
        local animation, timeline = CreateSimpleAnimation(ANIMATION_SCALE,exec,0)
        animation:SetScaleValues(1, 1.2)
        animation:SetDuration(500)
        exec.animation = animation
        exec.timeline = timeline
    end

    -- Bail if an animation is already playing
    if ( exec.timeline:IsPlaying() ) then return end

    -- Otherwise perform the appropriate animation
    exec.timeline:SetPlaybackType(ANIMATION_PLAYBACK_PING_PONG,1)
    exec.timeline:PlayFromStart()
end


--[[ 
 * Attribute Regeneration Arrows
 * --------------------------------
 * Called by FTC.OnVisualAdded()
 * Called by FTC.OnVisualUpdate()
 * Called by FTC.OnVisualRemoved()
 * --------------------------------
 ]]--
function FTC.Frames:Regen(unitTag,unitAttributeVisual,powerType,duration)

     -- Declare parameters
    duration        = duration or 2000 
    local context   = nil
    local regenType = nil
    local attrType  = nil
    local distance  = nil

    -- Get the regen type
    if ( unitAttributeVisual == ATTRIBUTE_VISUAL_INCREASED_REGEN_POWER ) then 
        regenType = "HoT"
        distance = 80
    elseif ( unitAttributeVisual == ATTRIBUTE_VISUAL_DECREASED_REGEN_POWER ) then 
        regenType = "DoT" 
        distance = -80
    end

    -- Determine context
    local context = ( unitTag == "player" ) and "Player" or "Target"

    -- Get the attribute name
    if ( powerType == POWERTYPE_HEALTH ) then        attrType = "Health"
    elseif ( powerType == POWERTYPE_STAMINA ) then   attrType = "Stamina"
    elseif ( powerType == POWERTYPE_MAGICKA ) then   attrType = "Magicka" 
    else return end

    -- Get the parent control
    local control = _G["FTC_"..context.."Frame_"..attrType..regenType]
    if ( control == nil ) then return end

    -- Does the animation need to be set up from scratch?
    if ( control.animation == nil ) then
        
        -- Set the draw layer
        control:SetHidden(false)
        control:SetAlpha(0)
        control:SetDrawLayer(1)

        -- Get the position
        local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = control:GetAnchor()

        -- Create an horizontal sliding animation
        local animation, timeline = CreateSimpleAnimation(ANIMATION_TRANSLATE,control,0)
        animation:SetTranslateOffsets(offsetX, offsetY, offsetX + distance, offsetY )
        animation:SetDuration(duration*3/4)

        -- Fade alpha coming in
        local fadeIn = timeline:InsertAnimation(ANIMATION_ALPHA,control,0)
        fadeIn:SetAlphaValues(0,.75)
        fadeIn:SetDuration(duration/4)
        fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)     

        -- Fade alpha going out
        local fadeOut = timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*1/2)
        fadeOut:SetAlphaValues(.75,0)
        fadeOut:SetDuration(duration/4)
        fadeIn:SetEasingFunction(ZO_EaseOutQuadratic)

        -- Add an extra delay at the end
        local fadeOut = timeline:InsertAnimation(ANIMATION_ALPHA,control,duration*3/4)
        fadeOut:SetAlphaValues(0,0)
        fadeOut:SetDuration(duration/4) 

        -- Assign the timeline
        control.animation = animation
        control.timeline = timeline
    end

    -- Maybe stop the animation
    if ( duration == 0 and control.animation:IsPlaying() ) then 
        control.timeline:SetPlaybackLoopsRemaining(1)

    -- Otherwise play it normally with a maximum of 5 loops (10 seconds)
    else
        control.timeline:SetPlaybackType(ANIMATION_PLAYBACK_LOOP, 10)
        control.timeline:PlayFromStart()
    end
end

