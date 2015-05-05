 
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
	local width 	= ( FTC.Vars.AnchorBuffs and FTC.init.Frames ) and FTC.Vars.FrameWidth or 400
	local height	= ( FTC.Vars.BuffText )  and 400 or 80

    -- Define Buff Pool
    FTC.Buffs.Pool  = ZO_ObjectPool:New( FTC.Buffs.CreateBuff , function(object) end )
    
    --[[-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        PLAYER BUFFS 		         	NAME                                PARENT      DIMENSIONS                                              ANCHOR                          EXTRAS
      ]]-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -- Player Buffs	
    local pb    	= FTC.UI:Control(	"FTC_PlayerBuffs",                  FTC_UI,     {width,height},             							pbAnchor,       				false )  
    pb.backdrop 	= FTC.UI:Backdrop(  "FTC_PlayerBuffs_BG",               pb,     	"inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, false )
   	pb.label		= FTC.UI:Label( 	"FTC_PlayerBuffs_Label", 			pb, 		"inherit", 												{CENTER,CENTER,0,0}, 			FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Player Buffs" , false )   
    pb.backdrop:SetEdgeTexture("",16,4,4)
    pb:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)

	-- Player Debuffs
	local pd 		= FTC.UI:Control( 	"FTC_PlayerDebuffs", 				FTC_UI,   	{width,height},											pdAnchor,       				false )  
    pd.backdrop 	= FTC.UI:Backdrop(  "FTC_PlayerDebuffs_BG",             pd,     	"inherit",                                              {CENTER,CENTER,0,0},            {0,0,0,0.4}, {0,0,0,1}, nil, false )
   	pd.label		= FTC.UI:Label( 	"FTC_PlayerDebuffs_Label", 			pd, 		"inherit", 												{CENTER,CENTER,0,0}, 			FTC.UI:Font("trajan",24,true) , nil , {1,1} , "Player Debuffs" , false )   
    pd.backdrop:SetEdgeTexture("",16,4,4)
    pd:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)
	
	--[[	
	-- Long buffs
	local anchor 	= FTC.Vars.FTC_LongBuffs
	local LB 		= FTC.UI:TopLevelWindow( "FTC_LongBuffs" , GuiRoot , {40,400} , {anchor[1],anchor[2],anchor[3],anchor[4]} , not FTC.Vars.EnableLongBuffs )	
	LB:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Target buffs
	local anchor 	= FTC.Vars.FTC_TargetBuffs
	local parent	= GuiRoot
	if ( FTC.Vars.AnchorBuffs ) then 
		anchor 		= ( FTC.init.Frames ) and {TOPLEFT,BOTTOMLEFT,0,25} or {TOP,BOTTOM,0,20} 
		parent		= ( FTC.init.Frames ) and FTC_TargetFrame or ZO_TargetUnitFramereticleover
	end
	local TB 		= FTC.UI:TopLevelWindow( "FTC_TargetBuffs" , parent , {320,40} , {anchor[1],anchor[2],anchor[3],anchor[4],parent} , false )
	TB.backdrop		= FTC.UI:Backdrop( "FTC_TargetBuffsBackdrop" , TB , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	TB.label		= FTC.UI:Label( "FTC_TargetBuffsLabel" , TB , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Target Buffs" , true )
	TB:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Target debuffs
	local anchor 	= FTC.Vars.FTC_TargetDebuffs
	local parent	= GuiRoot
	if ( FTC.Vars.AnchorBuffs ) then 
		anchor 		= ( FTC.init.Frames ) and {BOTTOMLEFT,TOPLEFT,0,-28} or {TOP,BOTTOM,0,100}
		parent		= ( FTC.init.Frames ) and FTC_TargetFrame or ZO_TargetUnitFramereticleover
	end
	local TD 		= FTC.UI:TopLevelWindow( "FTC_TargetDebuffs" , parent , {320,40} , {anchor[1],anchor[2],anchor[3],anchor[4],parent} , false )	
	TD.backdrop		= FTC.UI:Backdrop( "FTC_TargetDebuffsBackdrop" , TD , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	TD.label		= FTC.UI:Label( "FTC_TargetDebuffsLabel" , TD , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Target Debuffs" , true )
	TD:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Create the buff icon containers for each buff type
	local types = { 
		["PlayerBuffs"] 	= PB, 
		["PlayerDebuffs"] 	= PD, 
		["TargetBuffs"] 	= TB,
		["TargetDebuffs"] 	= TD,
		["LongBuffs"]		= LB,
	}
	for k,v in pairs(types) do
		local anchor 		= v
		local anchorPoint	= TOPLEFT
		local anchorTo		= TOPLEFT
		local anchorX		= 0
		
		-- Long buffs are different
		if ( v == LB ) then
			anchorPoint 	= TOP
			anchorTo 		= TOP 
		end
		
		-- Loop through creating the allowed number of buffs
		for i = 1, FTC.Vars.NumBuffs do
			local buff 		= FTC.UI:Control( "FTC_"..k.."_"..i , v , {40,40} , { anchorPoint , anchorTo , anchorX, 0, anchor } , false )	
			buff.cooldown	= FTC.UI:Cooldown( "FTC_"..k.."_"..i.."_CD" , buff , {40,40} , {CENTER,CENTER,0,0} , ( v == PD or v == TD ) and {1,0,0,0.75} or {0.2,0.6,0.6,1} , false )
			buff.cooldown:SetDrawLayer(0)
			buff.backdrop	= FTC.UI:Backdrop( "FTC_"..k.."_"..i.."_Backdrop" , buff , {35,35} , {CENTER,CENTER,0,0} , {0,0,0,1} , { 0,0,0,1 } , false )
			buff.icon		= FTC.UI:Texture( "FTC_"..k.."_"..i.."_Icon" , buff , {32,32} , {CENTER,CENTER,0,0} , '/esoui/art/icons/icon_missing.dds' , false )
			buff.label 		= FTC.UI:Label( "FTC_"..k.."_"..i.."_Label" , buff , {40,20} , {BOTTOM,BOTTOM,0,0} , "ZoFontWindowSubtitle" , nil , {1,1} , nil , false )


			-- Update the anchors			
			if ( v == LB) then
				anchor 		= buff
				anchorPoint	= TOP
				anchorTo	= BOTTOM
			else
				anchor 		= buff
				anchorPoint	= TOPLEFT
				anchorTo	= TOPRIGHT
				anchorX		= 3
			end
		end
	end

	--]]
end


--[[----------------------------------------------------------
    BUFF POOL FUNCTIONS
  ]]----------------------------------------------------------
function FTC.Buffs:CreateBuff()

	-- Get the pool and counter
	local pool		= FTC.Buffs.Pool
	local counter	= pool:GetTotalObjectCount() + 1

	-- Create buff
	local buff 		= FTC.UI:Control(	"FTC_Buff"..counter,                FTC_UI,     {40,40},   		{CENTER,CENTER,0,0},    false )
	buff.cooldown	= FTC.UI:Cooldown( 	"FTC_Buff"..counter.."_CD", 		buff, 		{40,40}, 		{CENTER,CENTER,0,0}, 	{1,0,0,1}, false )
	buff.backdrop	= FTC.UI:Backdrop( 	"FTC_Buff"..counter.."_Backdrop", 	buff, 		{35,35}, 		{CENTER,CENTER,0,0}, 	{0,0,0,1}, { 0,0,0,1 }, nil, false )
	buff.icon		= FTC.UI:Texture( 	"FTC_Buff"..counter.."_Icon", 		buff, 		{32,32}, 		{CENTER,CENTER,0,0}, 	'/esoui/art/icons/icon_missing.dds', false )
	buff.label 		= FTC.UI:Label( 	"FTC_Buff"..counter.."_Label", 		buff, 		{40,20}, 		{BOTTOM,BOTTOM,0,0}, 	"ZoFontWindowSubtitle", nil, {1,1}, nil, false )
   
   	-- Return buff to pool
   	d("Buff " .. counter .. " added to pool.")
	return buff
end
