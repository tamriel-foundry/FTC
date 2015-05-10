 
--[[----------------------------------------------------------
    BUFF TRACKING CONTROLS
  ]]----------------------------------------------------------

--[[ 
 * Create Buff Tracking UI
 * --------------------------------
 * Called by FTC.Frames:Initialize()
 * --------------------------------
 ]]--
function FTC.Buffs:Controls()

    -- Maybe Define Buff Pool
    if ( FTC.Buffs.Pool == nil ) then FTC.Buffs.Pool  = ZO_ObjectPool:New( FTC.Buffs.CreateBuff , function(object) FTC.Buffs:ReleaseBuff(object) end ) end
    
    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        PLAYER BUFFS                    NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- Player Buffs 
    local pbAnchor  = ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {TOPLEFT,BOTTOMLEFT,0,6,FTC_PlayerFrame} or FTC.Vars.FTC_PlayerBuffs
    local pbheight  = ( string.match(FTC.Vars.PlayerBuffFormat,"list") ~= nil ) and ( FTC.Vars.MaxBuffs * 50 ) or 50
    local pbwidth   = ( FTC.Vars.PlayerBuffFormat == "vtiles" ) and 50 or ( FTC.Vars.MaxBuffs * 50 )
    local pb        = FTC.UI:Control(   "FTC_PlayerBuffs",                  FTC_UI,     {pbwidth,pbheight},                                     pbAnchor,                       false )  
    pb.backdrop     = FTC.UI:Backdrop(  "FTC_PlayerBuffs_BG",               pb,         "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
    pb.label        = FTC.UI:Label(     "FTC_PlayerBuffs_Label",            pb,         "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Player Buffs" , true )   
    pb.backdrop:SetEdgeTexture("",16,4,4)
    pb:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

    -- Player Debuffs
    local pdAnchor  = ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {BOTTOMLEFT,TOPLEFT,0,-6,FTC_PlayerFrame} or FTC.Vars.FTC_PlayerDebuffs
    local pdheight  = ( string.match(FTC.Vars.PlayerDebuffFormat,"list") ~= nil ) and ( FTC.Vars.MaxBuffs * 50 ) or 50
    local pdwidth   = ( FTC.Vars.PlayerDebuffFormat == "vtiles" ) and 50 or ( FTC.Vars.MaxBuffs * 50 )
    local pd        = FTC.UI:Control(   "FTC_PlayerDebuffs",                FTC_UI,     {pdwidth,pdheight},                                     pdAnchor,                       false )  
    pd.backdrop     = FTC.UI:Backdrop(  "FTC_PlayerDebuffs_BG",             pd,         "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
    pd.label        = FTC.UI:Label(     "FTC_PlayerDebuffs_Label",          pd,         "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Player Debuffs" , true )   
    pd.backdrop:SetEdgeTexture("",16,4,4)
    pd:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

    -- Long buffs
    local lbAnchor  = FTC.Vars.FTC_LongBuffs
    local lbheight  = ( string.match(FTC.Vars.LongBuffFormat,"list") ~= nil ) and ( FTC.Vars.MaxBuffs * 50 ) or 50
    local lbwidth   = ( FTC.Vars.LongBuffFormat == "vtiles" ) and 50 or ( FTC.Vars.MaxBuffs * 50 )
    local lb        = FTC.UI:Control(   "FTC_LongBuffs",                    FTC_UI,     {lbwidth,lbheight},                                     lbAnchor,                       false )  
    lb.backdrop     = FTC.UI:Backdrop(  "FTC_LongBuffs_BG",                 lb,         "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
    lb.label        = FTC.UI:Label(     "FTC_LongBuffs_Label",              lb,         "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , "L\no\nn\ng\n\nB\nu\nf\nf\ns" , true )   
    lb:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
    lb:SetDrawTier(DT_MEDIUM)
  
    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        TARGET BUFFS                    NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- Target Buffs 
    local tbAnchor  = ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {TOPLEFT,BOTTOMLEFT,0,6 - FTC_TargetFrame:GetHeight()*(2/6),FTC_TargetFrame} or FTC.Vars.FTC_TargetBuffs
    local tbheight  = ( string.match(FTC.Vars.TargetBuffFormat,"list") ~= nil ) and ( FTC.Vars.MaxBuffs * 50 ) or 50
    local tbwidth   = ( FTC.Vars.TargetBuffFormat == "vtiles" ) and 50 or ( FTC.Vars.MaxBuffs * 50 )
    local tb        = FTC.UI:Control(   "FTC_TargetBuffs",                  FTC_UI,     {tbwidth,tbheight},                                     tbAnchor,                       false )  
    tb.backdrop     = FTC.UI:Backdrop(  "FTC_TargetBuffs_BG",               tb,         "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
    tb.label        = FTC.UI:Label(     "FTC_TargetBuffs_Label",            tb,         "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Target Buffs" , true )   
    tb.backdrop:SetEdgeTexture("",16,4,4)
    tb:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

    -- Target Debuffs
    local tdAnchor  = ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {BOTTOMLEFT,TOPLEFT,0,-6,FTC_TargetFrame} or FTC.Vars.FTC_TargetDebuffs
    local tdheight  = ( string.match(FTC.Vars.TargetDebuffFormat,"list") ~= nil ) and ( FTC.Vars.MaxBuffs * 50 ) or 50
    local tdwidth   = ( FTC.Vars.TargetDebuffFormat == "vtiles" ) and 50 or ( FTC.Vars.MaxBuffs * 50 )
    local td        = FTC.UI:Control(   "FTC_TargetDebuffs",                FTC_UI,     {tdwidth,tdheight},                                     tdAnchor,                       false )  
    td.backdrop     = FTC.UI:Backdrop(  "FTC_TargetDebuffs_BG",             td,         "inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
    td.label        = FTC.UI:Label(     "FTC_TargetDebuffs_Label",          td,         "inherit",                                              {CENTER,CENTER,0,0},            FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Target Debuffs" , true )   
    td.backdrop:SetEdgeTexture("",16,4,4)
    td:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)
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
function FTC.Buffs:CreateBuff()

    -- Get the pool and counter
    local pool      = FTC.Buffs.Pool
    local counter   = pool:GetNextControlId()

    -- Create buff
    local buff      = FTC.UI:Control(   "FTC_Buff"..counter,                FTC_UI,  {50,50},  {CENTER,CENTER,0,0},  true )
    buff.frame      = FTC.UI:Texture(   "FTC_Buff"..counter.."_Frame",      buff,    {44,44},  {CENTER,CENTER,0,0},  '/esoui/art/actionbar/buff_frame.dds', false )
    buff.frame:SetTextureCoords(0.22,0.78,0.22,0.78)
    buff.backdrop   = FTC.UI:Backdrop(  "FTC_Buff"..counter.."_BG",         buff,    {36,36},  {CENTER,CENTER,0,0},  {0,0,0,1}, {0,0,0,1}, nil, false )
    buff.cooldown   = FTC.UI:Cooldown(  "FTC_Buff"..counter.."_CD",         buff,    {44,44},  {CENTER,CENTER,0,0},  {0,0,0,0.75}, false )
    buff.icon       = FTC.UI:Texture(   "FTC_Buff"..counter.."_Icon",       buff,    {32,32},  {CENTER,CENTER,0,0},  '/esoui/art/icons/icon_missing.dds', false )
    buff.label      = FTC.UI:Label(     "FTC_Buff"..counter.."_Label",      buff,    {50,20},  {CENTER,BOTTOM,-1,-12},  FTC.UI:Font(FTC.Vars.BuffsFont1,FTC.Vars.BuffsFontSize,true) , {0.8,1,1,1}, {1,1}, nil, false )
    buff.name       = FTC.UI:Label(     "FTC_Buff"..counter.."_Name",       buff,    {450,20}, {LEFT,RIGHT,10,0},     FTC.UI:Font(FTC.Vars.BuffsFont2,FTC.Vars.BuffsFontSize,true) , {1,1,1,1}, {0,1}, "Buff Name", true )
   
    -- Return buff to pool
    return buff
end

--[[ 
 * Release Control to Pool Callback
 * --------------------------------
 * Called by FTC.Buffs.Pool
 * --------------------------------
 ]]--
function FTC.Buffs:ReleaseBuff(object)
    object:SetParent(FTC_UI)
    object:SetHidden(true)
end

--[[ 
 * Release All Unused Buff Controls
 * --------------------------------
 * Called by FTC.Buffs:EffectChanged()
 * Called by FTC.Buffs:NewEffect()
 * --------------------------------
 ]]--
function FTC.Buffs:ReleaseUnusedBuffs()

    -- Iterate over active controls
    for _ , control in pairs( FTC.Buffs.Pool.m_Active ) do
        local isUsed = false
        
        -- Iterate over player buffs
        for _ , buff in pairs( FTC.Buffs.Player ) do
            if (buff.control == control ) then
                isUsed = true
                break
            end
        end

        -- Next try target buffs
        for _ , buff in pairs( FTC.Buffs.Target ) do
            if (buff.control == control ) then
                isUsed = true
                break
            end
        end

        -- Release the control if its unused
        if ( not isUsed ) then 
            FTC.Buffs.Pool:ReleaseObject(control.id) 
        end
    end
end
