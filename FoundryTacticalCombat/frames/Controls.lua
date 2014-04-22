 
 --[[----------------------------------------------------------
	UNIT FRAMES CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the unit frames component.
	* Runs during FTC.Frames:Initialize()
  ]]--
  
function FTC.Frames:Controls()

	-- Create custom frames
	if ( FTC.vars.EnableFrames ) then
	
		--[[----------------------------------------------------------
			PLAYER FRAME
		 ]]-----------------------------------------------------------
		local anchor = FTC.vars["FTC_PlayerFrame"]
			
		-- Create the unit frame container	
		local player 		= FTC.UI.TopLevelWindow( "FTC_PlayerFrame" , GuiRoot , {250,75} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )	
		player:SetDrawLayer(2)
		player:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)
		player.backdrop		= FTC.UI.Backdrop( "FTC_PlayerFrameBackdrop" , player , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )	
		player.plate		= FTC.UI.Control( "FTC_PlayerFramePlate" , player , {player:GetWidth() ,24} , {BOTTOM,TOP,0,3,parent} , false )	
		player.name 		= FTC.UI.Label( "FTC_PlayerFrameName" , player.plate , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(14) , nil , {0,2} , nil , false )	
		player.class		= FTC.UI.Texture( "FTC_PlayerFrameClass" , player.plate , {24,24} , {BOTTOMRIGHT,BOTTOMRIGHT,0,2} , nil , false )
		player.class:SetTexture( "/esoui/art/contacts/social_classicon_" .. FTC.Player.class .. ".dds" )
		
		-- Create attribute bars
		local parent 		= player
		local stats 		= { 'Health' , 'Magicka' , 'Stamina' }
		for i = 1 , #stats , 1 do
			
			-- Create each bar
			local stat 		= FTC.UI.Control( "FTC_PlayerFrame" .. stats[i] , player , {player:GetWidth()-8,20} , {TOP,BOTTOM,0,3,parent} , false )	
			local bar		= FTC.UI.Backdrop( "FTC_PlayerFrame" .. stats[i] .. "Bar" , stat , "inherit" , {LEFT,LEFT,0,0} , {0.2,0,0,0.6} , {0,0,0,0.8} , false )	
			local current	= FTC.UI.Label( "FTC_PlayerFrame" .. stats[i] .. "Min" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,0} , FTC.Fonts.meta(12) , nil , {0,1} , nil , false )		
			local pct		= FTC.UI.Label( "FTC_PlayerFrame" .. stats[i] .. "Pct" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,-1} , "ZoFontAnnounceSmall" , nil , {2,1} , nil , false )	
			
			-- Adjust the positioning of the first bar
			if ( i == 1 ) then stat:SetAnchor(TOP,parent,TOP,0,4) end	
			parent = stat
		end
		
		-- Create damage shield bar
		local health		= _G["FTC_PlayerFrameHealth"]
		local shield		= FTC.UI.Statusbar( "FTC_PlayerFrame_Shield" , health , { 0 , 4 } , {BOTTOMLEFT,BOTTOMLEFT,1,-3} , {1,0.4,0,1} , false )

		-- Create the mount stamina bar
		local mount			= FTC.UI.Control( "FTC_MountFrame" , player , { player:GetWidth() , 20 } , {TOP,BOTTOM,0,0} , true )
		mount.icon 			= FTC.UI.Texture( "FTC_MountFrame_Icon" , mount , {24,24} , {LEFT,LEFT,4,2} , "/esoui/art/mounts/tabicon_mounts_down.dds" , false )
		mount.backdrop		= FTC.UI.Backdrop( "FTC_MountFrame_Backdrop" , mount , { mount:GetWidth() - 30 , 10 } , {RIGHT,RIGHT,0,0} , nil , nil , false )	
		mount.bar			= FTC.UI.Statusbar( "FTC_MountFrame_Bar" , mount.backdrop , { mount.backdrop:GetWidth() - 4 , mount.backdrop:GetHeight() - 4 } , {LEFT,LEFT,2,0} , {1,1,1,1} , false )
		local r1,g1,b1 		= ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_STAMINA][1]:UnpackRGBA()
		local r2,g2,b2 		= ZO_POWER_BAR_GRADIENT_COLORS[POWERTYPE_STAMINA][2]:UnpackRGBA()
		mount.bar:SetGradientColors( 0 , 0.4 , 0 , 1, 0 , 0.8 , 0 , 1)
		
		-- Create the mini experience bar
		local xpbar			= FTC.UI.Control( "FTC_XPBar" , player , { player:GetWidth() , 20 } , {TOP,BOTTOM,0,0} , false )
		xpbar.backdrop		= FTC.UI.Backdrop( "FTC_XPBar_Backdrop" , xpbar , { xpbar:GetWidth() , 10 } , {RIGHT,RIGHT,0,0} , nil , nil , false )	
		xpbar.bar			= FTC.UI.Statusbar( "FTC_XPBar_Bar" , xpbar.backdrop , { xpbar.backdrop:GetWidth() - 4 , xpbar.backdrop:GetHeight() - 4 } , {LEFT,LEFT,2,0} , {1,1,1,1} , false )
		xpbar.bar:SetGradientColors(0.2, 0.6 , 0.6, 1, 0.2, 1, 1, 1)

		--[[----------------------------------------------------------
			TARGET FRAME
		 ]]-----------------------------------------------------------
		local anchor 		= FTC.vars["FTC_TargetFrame"]
			
		-- Create the unit frame container	
		local target 		= FTC.UI.TopLevelWindow( "FTC_TargetFrame" , GuiRoot , {250,26} , {anchor[1],anchor[2],anchor[3],anchor[4]} , true )
		target:SetDrawLayer(2)
		target:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)	
		target.backdrop		= FTC.UI.Backdrop( "FTC_TargetFrameBackdrop" , target , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )	
		target.name 		= FTC.UI.Label( "FTC_TargetFrameName" , target , { target:GetWidth() , 20 } , {BOTTOMLEFT,TOPLEFT,0,0} , FTC.Fonts.meta(14) , nil , {0,1} , nil , false )		
		target.class		= FTC.UI.Texture( "FTC_TargetFrameClass" , target , {24,24} , {BOTTOMRIGHT,TOPRIGHT,0,2} , nil , true )
		
		-- Create health bar
		local health 		= FTC.UI.Control( "FTC_TargetFrameHealth" , target , {target:GetWidth()-8,20} , {CENTER,CENTER,0,0} , false )	
		local bar			= FTC.UI.Backdrop( "FTC_TargetFrameHealthBar" , health , "inherit" , {LEFT,LEFT,0,0} , {0.2,0,0,0.6} , {0,0,0,0.8} , false )	
		local current		= FTC.UI.Label( "FTC_TargetFrameHealthMin" , health , { health:GetWidth() - 10 , health:GetHeight() } , {CENTER,CENTER,0,0} , FTC.Fonts.meta(12) , nil , {2,1} , nil , false )		
		local pct			= FTC.UI.Label( "FTC_TargetFrameHealthPct" , health , { health:GetWidth() - 10 , health:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {0,1} , nil , false )	
		
		-- Create damage shield bar
		local shield		= FTC.UI.Statusbar( "FTC_TargetFrame_Shield" , health , { 0 , 4 } , {BOTTOMLEFT,BOTTOMLEFT,1,-3} , {1,0.4,0,1} , false )
	end
	
	--[[----------------------------------------------------------
		ULTIMATE TRACKING
	 ]]-----------------------------------------------------------
	local ultival 		= FTC.UI.Label( "FTC_UltimateLevel" , ActionButton8 , {50,20} , {BOTTOM,TOP,0,-3} , 'ZoFontAnnounceSmall' , nil , {1,2} , nil , false )
	local ultipct 		= FTC.UI.Label( "FTC_UltimatePct" , ActionButton8 , 'inherit' , {CENTER,CENTER,0,0} , 'ZoFontHeader2' , nil , {1,1} , nil , false )
	
	--[[----------------------------------------------------------
		DEFAULT FRAMES
	 ]]-----------------------------------------------------------
	local stats		= { "Health" , "Stamina" , "Magicka" }
	for  i = 1 , #stats , 1 do
		local parent	= _G["ZO_PlayerAttribute"..stats[i]]
		local label		= FTC.UI.Label( "FTC_DefaultPlayer"..stats[i] , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {1,1} , nil , false )
	end
	local parent		= _G["ZO_TargetUnitFramereticleover"]
	local label			= FTC.UI.Label( "FTC_DefaultTargetHealth" , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {1,1} , nil , false )
end