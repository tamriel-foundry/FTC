 
 --[[----------------------------------------------------------
	ACTIVE BUFF TRACKER CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the buff tracking component
	* Runs during FTC.Buffs.Initialize()
  ]]--
  
function FTC.Buffs:Controls()
	
 	-- Player buffs
	local anchor 	= FTC.vars.FTC_PlayerBuffs
	local parent	= GuiRoot
	if ( FTC.vars.AnchorBuffs ) then 
		anchor 		= ( FTC.init.Frames ) and {TOPLEFT,BOTTOMLEFT,0,25} or {BOTTOMLEFT,TOPLEFT,0,0}
		parent		= ( FTC.init.Frames ) and FTC_PlayerFrame or ZO_PlayerAttributeHealth
	end
	local PB 		= FTC.UI.TopLevelWindow( "FTC_PlayerBuffs" , parent , {320,40} , {anchor[1],anchor[2],anchor[3],anchor[4],parent} , false )
	PB.backdrop		= FTC.UI.Backdrop( "FTC_PlayerBuffsBackdrop" , PB , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	PB.label		= FTC.UI.Label( "FTC_PlayerBuffsLabel" , PB , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Player Buffs" , true )
	PB:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Player debuffs
	local anchor 	= FTC.vars.FTC_PlayerDebuffs
	local parent	= GuiRoot
	if ( FTC.vars.AnchorBuffs ) then 
		anchor = ( FTC.init.Frames ) and {BOTTOMLEFT,TOPLEFT,0,-28} or {BOTTOMLEFT,TOPLEFT,0,-110}
		parent		= ( FTC.init.Frames ) and FTC_PlayerFrame or ZO_PlayerAttributeHealth
	end
	local PD 		= FTC.UI.TopLevelWindow( "FTC_PlayerDebuffs" , parent , {320,40} , {anchor[1],anchor[2],anchor[3],anchor[4],parent} , false )	
	PD.backdrop		= FTC.UI.Backdrop( "FTC_PlayerDebuffsBackdrop" , PD , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	PD.label		= FTC.UI.Label( "FTC_PlayerDebuffsLabel" , PD , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Player Debuffs" , true )
	PD:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Long buffs
	local anchor 	= FTC.vars.FTC_LongBuffs
	local LB 		= FTC.UI.TopLevelWindow( "FTC_LongBuffs" , GuiRoot , {40,400} , {anchor[1],anchor[2],anchor[3],anchor[4]} , not FTC.vars.EnableLongBuffs )	
	LB:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Target buffs
	local anchor 	= FTC.vars.FTC_TargetBuffs
	local parent	= GuiRoot
	if ( FTC.vars.AnchorBuffs ) then 
		anchor 		= ( FTC.init.Frames ) and {TOPLEFT,BOTTOMLEFT,0,25} or {TOP,BOTTOM,0,20} 
		parent		= ( FTC.init.Frames ) and FTC_TargetFrame or ZO_TargetUnitFramereticleover
	end
	local TB 		= FTC.UI.TopLevelWindow( "FTC_TargetBuffs" , parent , {320,40} , {anchor[1],anchor[2],anchor[3],anchor[4],parent} , false )
	TB.backdrop		= FTC.UI.Backdrop( "FTC_TargetBuffsBackdrop" , TB , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	TB.label		= FTC.UI.Label( "FTC_TargetBuffsLabel" , TB , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Target Buffs" , true )
	TB:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Target debuffs
	local anchor 	= FTC.vars.FTC_TargetDebuffs
	local parent	= GuiRoot
	if ( FTC.vars.AnchorBuffs ) then 
		anchor 		= ( FTC.init.Frames ) and {BOTTOMLEFT,TOPLEFT,0,-28} or {TOP,BOTTOM,0,100}
		parent		= ( FTC.init.Frames ) and FTC_TargetFrame or ZO_TargetUnitFramereticleover
	end
	local TD 		= FTC.UI.TopLevelWindow( "FTC_TargetDebuffs" , parent , {320,40} , {anchor[1],anchor[2],anchor[3],anchor[4],parent} , false )	
	TD.backdrop		= FTC.UI.Backdrop( "FTC_TargetDebuffsBackdrop" , TD , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	TD.label		= FTC.UI.Label( "FTC_TargetDebuffsLabel" , TD , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Target Debuffs" , true )
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
		for i = 1, FTC.vars.NumBuffs do
			local buff 		= FTC.UI.Control( "FTC_"..k.."_"..i , v , {40,40} , { anchorPoint , anchorTo , anchorX, 0, anchor } , false )	
			buff.cooldown	= FTC.UI.Cooldown( "FTC_"..k.."_"..i.."_CD" , buff , {40,40} , {CENTER,CENTER,0,0} , ( v == PD or v == TD ) and {1,0,0,0.75} or {0.2,0.6,0.6,1} , false )
			buff.cooldown:SetDrawLayer(0)
			buff.backdrop	= FTC.UI.Backdrop( "FTC_"..k.."_"..i.."_Backdrop" , buff , {35,35} , {CENTER,CENTER,0,0} , {0,0,0,1} , { 0,0,0,1 } , false )
			buff.icon		= FTC.UI.Texture( "FTC_"..k.."_"..i.."_Icon" , buff , {32,32} , {CENTER,CENTER,0,0} , '/esoui/art/icons/icon_missing.dds' , false )
			buff.label 		= FTC.UI.Label( "FTC_"..k.."_"..i.."_Label" , buff , {40,20} , {BOTTOM,BOTTOM,0,0} , "ZoFontWindowSubtitle" , nil , {1,1} , nil , false )


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
end