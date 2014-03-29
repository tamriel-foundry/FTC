 
 --[[----------------------------------------------------------
	ACTIVE BUFF TRACKER CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the buff tracking component
	* Runs during FTC.Buffs.Initialize()
  ]]--
  
function FTC.Buffs:Controls()

 	-- Player buffs
	local PB 		= FTC.UI.TopLevelWindow( "FTC_PlayerBuffs" , FTC.init.Frames and FTC_PlayerFrame or ZO_PlayerAttributeHealth , {240,80} , FTC.init.Frames and {TOP,BOTTOM,0,20} or {BOTTOMLEFT,TOPLEFT,0,0} , false )
	PB.backdrop		= FTC.UI.Backdrop( "FTC_PlayerBuffsBackdrop" , PB , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	PB.label		= FTC.UI.Label( "FTC_PlayerBuffsLabel" , PB , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Player Buffs" , true )
	
	-- Player debuffs
	local PD 		= FTC.UI.TopLevelWindow( "FTC_PlayerDebuffs" , FTC.init.Frames and FTC_PlayerFrame or ZO_PlayerAttributeHealth , {240,80} , FTC.init.Frames and {BOTTOM,TOP,0,-25} or {BOTTOMLEFT,TOPLEFT,0,-110} , false )	
	PD.backdrop		= FTC.UI.Backdrop( "FTC_PlayerDebuffsBackdrop" , PD , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	PD.label		= FTC.UI.Label( "FTC_PlayerDebuffsLabel" , PD , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Player Debuffs" , true )
	
	-- Long buffs
	local anchor 	= FTC.vars.FTC_LongBuffs
	local LB 		= FTC.UI.TopLevelWindow( "FTC_LongBuffs" , GuiRoot , {40,400} , {anchor[1],anchor[2],anchor[3],anchor[4]} , not FTC.vars.EnableLongBuffs )	
	LB:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Target buffs
	local TB 		= FTC.UI.TopLevelWindow( "FTC_TargetBuffs" , FTC.init.Frames and FTC_TargetFrame or ZO_TargetUnitFramereticleover , {240,80} , FTC.init.Frames and {TOP,BOTTOM,0,5} or {TOP,BOTTOM,0,20} , false )
	TB.backdrop		= FTC.UI.Backdrop( "FTC_TargetBuffsBackdrop" , TB , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	TB.label		= FTC.UI.Label( "FTC_TargetBuffsLabel" , TB , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Target Buffs" , true )
	
	-- Target debuffs
	local TD 		= FTC.UI.TopLevelWindow( "FTC_TargetDebuffs" , FTC.init.Frames and FTC_TargetFrame or ZO_TargetUnitFramereticleover , {240,80} , FTC.init.Frames and {BOTTOM,TOP,0,-25} or {TOP,BOTTOM,0,100} , false )	
	TD.backdrop		= FTC.UI.Backdrop( "FTC_TargetDebuffsBackdrop" , TD , 'inherit' , {CENTER,CENTER,0,0} , nil , nil , true )
	TD.label		= FTC.UI.Label( "FTC_TargetDebuffsLabel" , TD , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Target Debuffs" , true )
	
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
			buff.cooldown	= FTC.UI.Cooldown( "FTC_"..k.."_"..i.."_CD" , buff , {40,40} , {CENTER,CENTER,0,0} , ( v == PD or v == TD ) and {1,0,0,0.5} or {0,1,0,0.5} , false )
			buff.cooldown:SetDrawLayer(0)
			buff.backdrop	= FTC.UI.Backdrop( "FTC_"..k.."_"..i.."_Backdrop" , buff , {35,35} , {CENTER,CENTER,0,0} , {0,0,0,1} , { 0,0,0,1 } , false )
			buff.icon		= FTC.UI.Texture( "FTC_"..k.."_"..i.."_Icon" , buff , {32,32} , {CENTER,CENTER,0,0} , '/esoui/art/icons/icon_missing.dds' , false )
			buff.label 		= FTC.UI.Label( "FTC_"..k.."_"..i.."_Label" , buff , {40,20} , {BOTTOM,BOTTOM,0,0} , "ZoFontWindowSubtitle" , nil , {1,1} , nil , false )


			-- Update the anchors			
			if ( v == LB) then
				anchor 		= buff
				anchorPoint	= TOP
				anchorTo	= BOTTOM
			elseif ( i == FTC.vars.NumBuffs / 2 ) then
				anchor 		= _G["FTC_"..k.."_1"]
				anchorPoint	= ( v == PB or v == TB ) and TOPLEFT or BOTTOMLEFT
				anchorTo	= ( v == PB or v == TB ) and BOTTOMLEFT or TOPLEFT
				anchorX		= 0
			else
				anchor 		= buff
				anchorPoint	= TOPLEFT
				anchorTo	= TOPRIGHT
				anchorX		= 3
			end
		end
	end
end