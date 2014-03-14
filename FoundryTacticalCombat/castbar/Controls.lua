 
 --[[----------------------------------------------------------
	CASTBAR CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the castbar component.
	* Runs during FTC.Castbar:Initialize()
  ]]--
  
function FTC.Castbar:Controls()

	-- Create player and target bars
	local bars = { ["Player"] = "ZO_PlayerAttributeHealth" , ["Target"] = "ZO_TargetUnitFramereticleover" }
	for k,v in pairs(bars) do
	
		-- Adjust the bars if the user is running the HUD frames
		local parent = FTC.vars.EnableFrames and _G["FTC_"..k.."Frame"] or _G[v]
		
		-- Create the castbar
		local CB 	= FTC.UI.TopLevelWindow( "FTC_"..k.."Castbar" , parent , {parent:GetWidth(),24} , {BOTTOMLEFT,TOPLEFT,0,-25} , false )	
		CB.backdrop = FTC.UI.Backdrop( "FTC_"..k.."CastbarBackdrop" , CB , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )		
		CB.bar 		= FTC.UI.Statusbar( "FTC_"..k.."CastbarBar" , CB , { CB:GetWidth() - 8 , 16 } , {LEFT,LEFT,4,0} , nil , false )		
		CB.label 	= FTC.UI.Label( "FTC_"..k.."CastbarLabel" , CB , "inherit" , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {1,1} , nil , false )
	end
	
	-- Modify the bar position if HUD isnt enabled
	if ( not FTC.vars.EnableFrames ) then FTC_TargetCastbar:SetAnchor( BOTTOMLEFT, ZO_TargetUnitFramereticleover , TOPLEFT , 0 , -15 ) end
	
end
