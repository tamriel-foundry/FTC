 
 --[[----------------------------------------------------------
	UNIT FRAMES CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the unit frames component.
	* Runs during FTC.Frames:Initialize()
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
		frame.name 		= FTC.UI.Label( "FTC_" .. frames[f] .. "FrameName" , frame , { frame:GetWidth() * 0.5 , 20 } , {BOTTOMLEFT,TOPLEFT,0,0} , "ZoFontAnnounceSmall" , nil , {0,1} , nil , false )		
		frame.level 	= FTC.UI.Label( "FTC_" .. frames[f] .. "FrameLevel" , frame , { frame:GetWidth() * 0.5 , 20 } , {BOTTOMRIGHT,TOPRIGHT,0,0} , "ZoFontAnnounceSmall" , nil , {2,1} , nil , false )
		
		-- Create attribute bars
		local parent 	= frame
		local stats 	= { 'Health' , 'Magicka' , 'Stamina' }
		for i = 1 , #stats , 1 do
			
			-- Create each bar
			local stat 		= FTC.UI.Control( "FTC_" .. frames[f] .. "Frame" .. stats[i] , frame , {frame:GetWidth()-8,20} , {TOP,BOTTOM,0,3,parent} , false )	
			local bar		= FTC.UI.Backdrop( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Bar" , stat , "inherit" , {LEFT,LEFT,0,0} , {0.2,0,0,0.6} , {0,0,0,0.8} , false )	
			local current	= FTC.UI.Label( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Min" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontBoss" , nil , {frames[f] == "Player" and 0 or 2,1} , nil , false )		
			local pct		= FTC.UI.Label( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Pct" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {frames[f] == "Player" and 2 or 0,1} , nil , false )	
			
			-- Adjust the positioning of the first bar
			if ( i == 1 ) then stat:SetAnchor(TOP,parent,TOP,0,4) end	
			parent = stat
		end	
	end
	
	-- Create labels for the default frame
	local stats		= { "Health" , "Stamina" , "Magicka" }
	for  i = 1 , #stats , 1 do
		local parent	= _G["ZO_PlayerAttribute"..stats[i]]
		local label		= FTC.UI.Label( "FTC_DefaultPlayer"..stats[i] , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,-1} , "ZoFontAnnounceSmall" , nil , {1,1} , nil , false )
	end
	local parent		= _G["ZO_TargetUnitFramereticleover"]
	local label			= FTC.UI.Label( "FTC_DefaultTargetHealth" , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,-1} , "ZoFontAnnounceSmall" , nil , {1,1} , nil , false )

	-- Create ultimate tracker
	local ultimate 		= FTC.UI.Label( "FTC_UltimateTracker" , ActionButton8 , 'inherit' , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {1,1} , nil , false )
	
	-- Create the mount stamina bar
	local player		= _G["FTC_PlayerFrame"]
	local mount			= FTC.UI.Control( "FTC_MountFrame" , player , { player:GetWidth() , 20 } , {TOP,BOTTOM,0,0} , true )
	mount.icon 			= FTC.UI.Texture( "FTC_MountFrame_Icon" , mount , {24,24} , {LEFT,LEFT,4,2} , "/esoui/art/mounts/tabicon_mounts_down.dds" , false )
	mount.backdrop		= FTC.UI.Backdrop( "FTC_MountFrame_Backdrop" , mount , { mount:GetWidth() - 30 , 10 } , {RIGHT,RIGHT,0,0} , nil , nil , false )	
	mount.bar			= FTC.UI.Statusbar( "FTC_MountFrame_Bar" , mount.backdrop , { mount.backdrop:GetWidth() - 4 , mount.backdrop:GetHeight() - 4 } , {LEFT,LEFT,2,0} , {1,1,1,1} , false )
	local r1,g1,b1 		= ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_STAMINA][1]:UnpackRGBA()
	local r2,g2,b2 		= ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_STAMINA][2]:UnpackRGBA()
	mount.bar:SetGradientColors(r1, g1, b1, 1, r2, g2, b2, 1)
	
	-- Create target of target
	local target		= _G["FTC_TargetFrame"]
	local tartar		= FTC.UI.Control( "FTC_TarTarFrame" , target , { target:GetWidth() , 20 } , {TOP,BOTTOM,0,0} , false )
	tartar.backdrop		= FTC.UI.Backdrop( "FTC_TarTarFrame_Backdrop" , tartar , { tartar:GetWidth() , 10 } , {RIGHT,RIGHT,0,0} , nil , nil , false )	
	tartar.bar			= FTC.UI.Statusbar( "FTC_TarTarFrame_Bar" , tartar.backdrop , { tartar.backdrop:GetWidth() - 4 , tartar.backdrop:GetHeight() - 4 } , {LEFT,LEFT,2,0} , {1,1,1,1} , false )
	local r1,g1,b1 		= ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_HEALTH][1]:UnpackRGBA()
	local r2,g2,b2 		= ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_HEALTH][2]:UnpackRGBA()
	tartar.bar:SetGradientColors(r1, g1, b1, 1, r2, g2, b2, 1)
	tartar.name			= FTC.UI.Label( "FTC_TarTarFrame_Name" , tartar , { tartar:GetWidth() - 20 , 20 } , {CENTER,CENTER,0,0} , "ZoFontBoss" , nil , {0,1} , "Name" , false )
	tartar.pct			= FTC.UI.Label( "FTC_TarTarFrame_Pct" , tartar , { tartar:GetWidth() - 20 , 20 } , {CENTER,CENTER,0,0} , "ZoFontBoss" , nil , {2,1} , "Pct" , false )
end