 
 --[[----------------------------------------------------------
	ACTIVE BUFF TRACKER CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the buff tracking component
	* Runs during FTC.Buffs.Initialize()
  ]]--
  
function FTC.Buffs:Controls()

 	-- Player buffs
	local PB = FTC.UI.TopLevelWindow( "FTC_PlayerBuffs" , FTC.Frames.init and FTC_PlayerFrame or ZO_PlayerAttributeHealth , {240,80} , FTC.Frames.init and {TOPLEFT,BOTTOMLEFT,0,5} or {BOTTOMLEFT,TOPLEFT,0,-30} , false )
	
	-- Player debuffs
	local PD = FTC.UI.TopLevelWindow( "FTC_PlayerDebuffs" , FTC.Frames.init and FTC_PlayerFrame or ZO_PlayerAttributeHealth , {240,80} , FTC.Frames.init and {BOTTOMLEFT,TOPLEFT,0,-15} or {BOTTOMLEFT,TOPLEFT,0,-110} , false )	
	
	-- Long buffs
	local LB = FTC.UI.TopLevelWindow( "FTC_LongBuffs" , GuiRoot , {40,400} , {BOTTOMRIGHT,BOTTOMRIGHT,-5,-5} , false )	
	
	-- Target buffs
	local TB = FTC.UI.TopLevelWindow( "FTC_TargetBuffs" , FTC.Frames.init and FTC_TargetFrame or ZO_TargetUnitFramereticleover , {240,80} , FTC.Frames.init and {TOPLEFT,BOTTOMLEFT,0,5} or {TOP,BOTTOM,0,50} , false )
	
	-- Target debuffs
	local TD = FTC.UI.TopLevelWindow( "FTC_TargetDebuffs" , FTC.Frames.init and FTC_TargetFrame or ZO_TargetUnitFramereticleover , {240,80} , FTC.Frames.init and {BOTTOMLEFT,TOPLEFT,0,-15} or {TOP,BOTTOM,0,130} , false )	

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
		local anchorPoint 	= ( v == LB ) and TOP or TOPLEFT
		local anchorTo		= ( v == LB ) and TOP or TOPLEFT

		-- Loop through creating the allowed number of buffs
		for i = 1, FTC.vars.NumBuffs do
			local buff 		= FTC.UI.Control( "FTC_"..k.."_"..i , v , {40,40} , { anchorPoint , anchorTo , 0, 0, anchor } , false )	
			buff.backdrop	= FTC.UI.Backdrop( "FTC_"..k.."_"..i.."_Backdrop" , buff , {36,36} , {CENTER,CENTER,0,0} , {0,0,0,1} , { 0,0,0,1 } , false )
			buff.label 		= FTC.UI.Label( "FTC_"..k.."_"..i.."_Label" , buff , {40,20} , {BOTTOM,BOTTOM,0,0} , "ZoFontWindowSubtitle" , nil , {1,1} , false )
			buff.icon		= FTC.UI.Texture( "FTC_"..k.."_"..i.."_Icon" , buff , {34,34} , {CENTER,CENTER,0,0} , '/esoui/art/icons/icon_missing.dds' , false )
			buff.cooldown	= FTC.UI.Cooldown( "FTC_"..k.."_"..i.."_CD" , buff , {38,38} , {CENTER,CENTER,0,0} , ( v == PD or v == TD ) and {1,0,0,0.5} or {0,1,0,0.5} , false )

			-- Update the anchors			
			if ( v == LB) then
				anchor 		= buff
				anchorPoint	= TOP
				anchorTo	= BOTTOM
			elseif ( i == FTC.vars.NumBuffs / 2 ) then
				anchor 		= _G["FTC_"..k.."_1"]
				anchorPoint	= ( v == PB or v == TB ) and TOPLEFT or BOTTOMLEFT
				anchorTo	= ( v == PB or v == TB ) and BOTTOMLEFT or TOPLEFT
			else
				anchor 		= buff
				anchorPoint	= TOPLEFT
				anchorTo	= TOPRIGHT	
			end
			
			-- Set draw layers
			buff.cooldown:SetDrawLayer(1)
			buff.backdrop:SetDrawLayer(2)
			buff.icon:SetDrawLayer(3)
			buff.label:SetDrawLayer(4)
		end
	end
end