 
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

	-- Get data
	local pbAnchor 	= ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {TOP,BOTTOM,0,6,FTC_PlayerFrame} or FTC.Vars.FTC_PlayerBuffs
	local pdAnchor 	= ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {BOTTOM,TOP,0,-6,FTC_PlayerFrame} or FTC.Vars.FTC_PlayerDebuffs
	local lbAnchor 	= FTC.Vars.FTC_LongBuffs
	local tbAnchor 	= ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {TOP,BOTTOM,0,6,FTC_TargetFrame} or FTC.Vars.FTC_TargetBuffs
	local tdAnchor 	= ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and {BOTTOM,TOP,0,-6,FTC_TargetFrame} or FTC.Vars.FTC_TargetDebuffs
	local width 	= ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and FTC.Vars.FrameWidth or 500
	local height	= ( FTC.Vars.BuffText )  and 500 or 50

    -- Define Buff Pool
    FTC.Buffs.Pool  = ZO_ObjectPool:New( FTC.Buffs.CreateBuff , function(object) FTC.Buffs:ReleaseBuff(object) end )
    
    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        PLAYER BUFFS 		         	NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- Player Buffs	
    local pb    	= FTC.UI:Control(	"FTC_PlayerBuffs",                  FTC_UI,     {width,height},             							pbAnchor,       				false )  
    pb.backdrop 	= FTC.UI:Backdrop(  "FTC_PlayerBuffs_BG",               pb,     	"inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
   	pb.label		= FTC.UI:Label( 	"FTC_PlayerBuffs_Label", 			pb, 		"inherit", 												{CENTER,CENTER,0,0}, 			FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Player Buffs" , true )   
    pb.backdrop:SetEdgeTexture("",16,4,4)
    pb:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

	-- Player Debuffs
	local pd 		= FTC.UI:Control( 	"FTC_PlayerDebuffs", 				FTC_UI,   	{width,height},											pdAnchor,       				false )  
    pd.backdrop 	= FTC.UI:Backdrop(  "FTC_PlayerDebuffs_BG",             pd,     	"inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
   	pd.label		= FTC.UI:Label( 	"FTC_PlayerDebuffs_Label", 			pd, 		"inherit", 												{CENTER,CENTER,0,0}, 			FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Player Debuffs" , true )   
    pd.backdrop:SetEdgeTexture("",16,4,4)
    pd:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

	-- Long buffs
	local lb 		= FTC.UI:Control( 	"FTC_LongBuffs", 					FTC_UI,   	{50,500},												lbAnchor,       				false )  
    lb.backdrop 	= FTC.UI:Backdrop(  "FTC_LongBuffs_BG",             	lb,     	"inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
   	lb.label		= FTC.UI:Label( 	"FTC_LongBuffs_Label", 				lb, 		"inherit", 												{CENTER,CENTER,0,0}, 			FTC.UI:Font("trajan",24,true) , nil , {1,1} , "L\no\nn\ng\n\nB\nu\nf\nf\ns" , true )   
	lb:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
  
	--[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		Target BUFFS 		         	NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
	  ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- Target Buffs	
    local tb    	= FTC.UI:Control(	"FTC_TargetBuffs",                  FTC_UI,     {width,height},             							tbAnchor,       				false )  
    tb.backdrop 	= FTC.UI:Backdrop(  "FTC_TargetBuffs_BG",               tb,     	"inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
   	tb.label		= FTC.UI:Label( 	"FTC_TargetBuffs_Label", 			tb, 		"inherit", 												{CENTER,CENTER,0,0}, 			FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Target Buffs" , true )   
    tb.backdrop:SetEdgeTexture("",16,4,4)
    tb:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

	-- Target Debuffs
	local td 		= FTC.UI:Control( 	"FTC_TargetDebuffs", 				FTC_UI,   	{width,height},											tdAnchor,       				false )  
    td.backdrop 	= FTC.UI:Backdrop(  "FTC_TargetDebuffs_BG",             td,     	"inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, true )
   	td.label		= FTC.UI:Label( 	"FTC_TargetDebuffs_Label", 			td, 		"inherit", 												{CENTER,CENTER,0,0}, 			FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Target Debuffs" , true )   
    td.backdrop:SetEdgeTexture("",16,4,4)
    td:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)
end


--[[----------------------------------------------------------
    BUFF POOL FUNCTIONS
  ]]----------------------------------------------------------
function FTC.Buffs:CreateBuff()

	-- Get the pool and counter
	local pool		= FTC.Buffs.Pool
	local counter	= pool:GetTotalObjectCount() + 1

	-- Create buff
	local buff 		= FTC.UI:Control(	"FTC_Buff"..counter,                FTC_UI,  {50,50},  {CENTER,CENTER,0,0},  true )
	buff.frame		= FTC.UI:Texture( 	"FTC_Buff"..counter.."_Frame", 		buff, 	 {44,44},  {CENTER,CENTER,0,0},  '/esoui/art/actionbar/buff_frame.dds', false )
	buff.frame:SetTextureCoords(0.22,0.78,0.22,0.78)
	buff.backdrop	= FTC.UI:Backdrop( 	"FTC_Buff"..counter.."_BG", 		buff, 	 {36,36},  {CENTER,CENTER,0,0},  {0,0,0,1}, {0,0,0,1}, nil, false )
	buff.backdrop:SetDrawLayer(DL_BACKGROUND)
	buff.cooldown	= FTC.UI:Cooldown( 	"FTC_Buff"..counter.."_CD", 		buff, 	 {44,44},  {CENTER,CENTER,0,0},  {0,0,0,0.75}, false )
	buff.cooldown:SetDrawLayer(DL_CONTROLS)
	buff.icon		= FTC.UI:Texture( 	"FTC_Buff"..counter.."_Icon", 		buff, 	 {32,32},  {CENTER,CENTER,0,0},  '/esoui/art/icons/icon_missing.dds', false )
	buff.icon:SetDrawLayer(DL_CONTROLS)	
	buff.label 		= FTC.UI:Label( 	"FTC_Buff"..counter.."_Label", 		buff, 	 {50,20},  {BOTTOM,BOTTOM,-1,-4},  FTC.UI:Font('esobold',20,true) , {0.8,1,1,1}, {1,1}, nil, false )
   
   	-- Return buff to pool
   	d("Buff " .. counter .. " added to pool.")
	return buff
end

function FTC.Buffs:ReleaseBuff(object)
	object:SetHidden(true)
	d("Buff " .. object.id .. " released to pool.")
end


function FTC.Buffs:ReleaseUnusedBuffs()

	-- Iterate over active controls
	for _ , control in pairs( FTC.Buffs.Pool.m_Active ) do
		local isUsed = false5
		
		-- Iterate over active buffs
		for _ , buff in pairs( FTC.JoinTables(FTC.Buffs.Player,FTC.Buffs.Target) ) do
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
