 
 --[[----------------------------------------------------------
	UNIT FRAMES CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the unit frames component.
	* Runs during FTC.Frames.Initialize()
  ]]--
  
function FTC.Frames:Controls()

 	-- Create custom frames, regardless of whether or not we are using them
	local frames = { "Player" , "Target" }
	for f = 1 , #frames , 1 do
	
		-- Get the saved frame positions
		local offsetx 	= ( frames[f] == "Player" ) and -400 or 400
		offsetx			= ( FTC.vars[frames[f].."FrameX"] ~= 0 ) and FTC.vars[frames[f].."FrameX"] or offsetx
		local offsety 	= ( FTC.vars[frames[f].."FrameY"] ~= 0 ) and FTC.vars[frames[f].."FrameY"] or 300
		
		-- Create the unit frame container	
		local frame 	= FTC.UI.TopLevelWindow( "FTC_" .. frames[f] .. "Frame" , GuiRoot , {250,75} , {TOP,CENTER,offsetx,offsety} , false )	
		frame.backdrop	= FTC.UI.Backdrop( "FTC_" .. frames[f] .. "FrameBackdrop" , frame , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )	
		frame.name 		= FTC.UI.Label( "FTC_" .. frames[f] .. "FrameName" , frame , { frame:GetWidth() * 0.5 , 20 } , {BOTTOMLEFT,TOPLEFT,0,0} , "ZoFontAnnounceSmall" , nil , {0,1} , false )		
		frame.level 	= FTC.UI.Label( "FTC_" .. frames[f] .. "FrameLevel" , frame , { frame:GetWidth() * 0.5 , 20 } , {BOTTOMRIGHT,TOPRIGHT,0,0} , "ZoFontAnnounceSmall" , nil , {2,1} , false )
		
		-- Create attribute bars
		local parent 	= frame
		local stats 	= { 'Health' , 'Magicka' , 'Stamina' }
		for i = 1 , #stats , 1 do
			
			-- Create each bar
			local stat 		= FTC.UI.Control( "FTC_" .. frames[f] .. "Frame" .. stats[i] , frame , {frame:GetWidth()-8,20} , {TOP,BOTTOM,0,3,parent} , false )	
			local bar		= FTC.UI.Backdrop( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Bar" , stat , "inherit" , {LEFT,LEFT,0,0} , {0.2,0,0,0.6} , {0,0,0,0.8} , false )	
			local current	= FTC.UI.Label( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Min" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontBoss" , nil , {frames[f] == "Player" and 0 or 2,1} , false )		
			local pct		= FTC.UI.Label( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Pct" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {frames[f] == "Player" and 2 or 0,1} , false )	
			
			-- Adjust the positioning of the first bar
			if ( i == 1 ) then stat:SetAnchor(TOP,parent,TOP,0,4) end	
			parent = stat
		end	
	end
	
	-- Create labels for the default frame
	local stats		= { "Health" , "Stamina" , "Magicka" }
	for  i = 1 , #stats , 1 do
		local parent	= _G["ZO_PlayerAttribute"..stats[i]]
		local label		= FTC.UI.Label( "FTC_DefaultPlayer"..stats[i] , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,-1} , "ZoFontAnnounceSmall" , nil , {1,1} , false )
	end
	local parent		= _G["ZO_TargetUnitFramereticleover"]
	local label			= FTC.UI.Label( "FTC_DefaultTargetHealth" , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,-1} , "ZoFontAnnounceSmall" , nil , {1,1} , false )

	-- Create ultimate tracker
	local ultimate = FTC.UI.Label( "FTC_UltimateTracker" , ActionButton8 , 'inherit' , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {1,1} , false )
	
end