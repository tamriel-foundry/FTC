 
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
		local player 		= FTC.UI.TopLevelWindow( "FTC_PlayerFrame" , GuiRoot , {275,80} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )	
		player:SetDrawLayer(2)
		player:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)
		player.plate		= FTC.UI.Control( "FTC_PlayerFrame_Plate" , player , {player:GetWidth() ,25} , {BOTTOM,TOP,0,3,parent} , false )	
		player.name 		= FTC.UI.Label( "FTC_PlayerFrame_Name" , player.plate , {player:GetWidth() ,25} , {BOTTOM,BOTTOM,4,-2} , FTC.Fonts.meta(16) , nil , {0,1} , "Player Name (Level)" , false )	
		player.class		= FTC.UI.Texture( "FTC_PlayerFrame_Class" , player.plate , {30,30} , {BOTTOMRIGHT,BOTTOMRIGHT,0,0} , nil , false )
		player.class:SetTexture( "/esoui/art/contacts/social_classicon_" .. FTC.Player.class .. ".dds" )
			
		-- Health
		local health 		= FTC.UI.Backdrop( "FTC_PlayerFrame_Health" , player , {275,34} , {TOP,TOP,0,1,player} , {0.1,0,0,1} , {0,0,0,0} , false )	
		health:SetCenterTexture('FoundryTacticalCombat/lib/textures/grainy.dds')
		health.bar			= FTC.UI.Statusbar( "FTC_PlayerFrame_HealthBar" , health , { health:GetWidth() - 2 , health:GetHeight() - 2 } , {TOPLEFT,TOPLEFT,1,1} , {0.6,0,0,1} , false )	
		health.bar:SetTexture('FoundryTacticalCombat/lib/textures/grainy.dds')
		health.current		= FTC.UI.Label( "FTC_PlayerFrame_HealthCurrent" , health , { health:GetWidth() - 16 , health:GetHeight() } , {CENTER,CENTER,0,0} , FTC.Fonts.meta(14) , nil , {0,1} , 'Health' , false )		
		health.pct			= FTC.UI.Label( "FTC_PlayerFrame_HealthPct" , health , { health:GetWidth() - 16 , health:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontWindowSubtitle" , nil , {2,1} , 'Pct%' , false )
		player.health		= health
		
		-- Magicka
		local magicka 		= FTC.UI.Backdrop( "FTC_PlayerFrame_Magicka" , player , {275,23} , {TOP,BOTTOM,0,0,health} ,{0.05,0.05,0.1,1} , {0,0,0,0} , false )	
		magicka:SetCenterTexture('FoundryTacticalCombat/lib/textures/grainy.dds')
		magicka.bar			= FTC.UI.Statusbar( "FTC_PlayerFrame_MagickaBar" , magicka , { magicka:GetWidth() - 2 , magicka:GetHeight() - 2 } , {TOPLEFT,TOPLEFT,1,1} , {0.4,0.4,0.8,1} , false )
		magicka.bar:SetTexture('FoundryTacticalCombat/lib/textures/grainy.dds')		
		magicka.current		= FTC.UI.Label( "FTC_PlayerFrame_MagickaCurrent" , magicka , { magicka:GetWidth() - 16 , magicka:GetHeight() } , {CENTER,CENTER,0,0} , FTC.Fonts.meta(12) , nil , {0,1} , 'Magicka' , false )
		magicka.pct			= FTC.UI.Label( "FTC_PlayerFrame_MagickaPct" , magicka , { magicka:GetWidth() - 16 , magicka:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {2,1} , 'Pct%' , false )
		player.magicka		= magicka
		
		-- Stamina
		local stamina 		= FTC.UI.Backdrop( "FTC_PlayerFrame_Stamina" , player , {275,23} , {TOP,BOTTOM,0,0,magicka} , {0,0.05,0,1} , {0,0,0,0} , false )	
		stamina:SetCenterTexture('FoundryTacticalCombat/lib/textures/grainy.dds')
		stamina.bar			= FTC.UI.Statusbar( "FTC_PlayerFrame_StaminaBar" , stamina , { stamina:GetWidth() - 2 , stamina:GetHeight() - 2 } , {TOPLEFT,TOPLEFT,1,1} , {0,0.4,0,1} , false )	
		stamina.bar:SetTexture('FoundryTacticalCombat/lib/textures/grainy.dds')
		stamina.current		= FTC.UI.Label( "FTC_PlayerFrame_StaminaCurrent" , stamina , { stamina:GetWidth() - 16 , stamina:GetHeight() } , {CENTER,CENTER,0,0} , FTC.Fonts.meta(12) , nil , {0,1} , 'Stamina' , false )		
		stamina.pct			= FTC.UI.Label( "FTC_PlayerFrame_StaminaPct" , stamina , { stamina:GetWidth() - 16 , stamina:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {2,1} , 'Pct%' , false )
		player.stamina		= stamina
		
		-- Create damage shield bar
		player.shield		= FTC.UI.Statusbar( "FTC_PlayerFrame_Shield" , health , {0,6} , {BOTTOMLEFT,BOTTOMLEFT,1,-1} , {1,0.4,0,1} , false )
		
		-- Experience / Siege / Mount / Werewolf
		local alt			= FTC.UI.Backdrop( "FTC_PlayerFrame_Alt" , player , {250,10} , {TOPRIGHT,BOTTOMRIGHT,0,6} ,{0,0.1,0.1,1} , {0,0,0,1} , false )
		alt.bar				= FTC.UI.Statusbar( "FTC_PlayerFrame_AltBar" , alt , { alt:GetWidth() - 2 , alt:GetHeight() - 3 } , {LEFT,LEFT,1,0} , {0,1,1,1} , false )
		alt.bar:SetTexture('FoundryTacticalCombat/lib/textures/grainy.dds')	
		alt.icon 			= FTC.UI.Texture( "FTC_PlayerFrame_AltIcon" , alt , {25,25} , {TOPLEFT,BOTTOMLEFT,0,0,player} , "/esoui/art/inventory/inventory_tabicon_quest_down.dds" , false )
		alt.context			= 'exp'

		--[[----------------------------------------------------------
			TARGET FRAME
		 ]]-----------------------------------------------------------
		local anchor 		= FTC.vars["FTC_TargetFrame"]
			
		-- Create the unit frame container	
		local target 		= FTC.UI.TopLevelWindow( "FTC_TargetFrame" , GuiRoot , {275,34} , {anchor[1],anchor[2],anchor[3],anchor[4]} , true )
		target:SetDrawLayer(2)
		target:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end)	
		target.name 		= FTC.UI.Label( "FTC_TargetFrame_Name" , target , { target:GetWidth() , 25 } , {BOTTOM,TOP,0,0} , FTC.Fonts.meta(16) , nil , {0,1} , 'Target Name (Level)' , false )		
		target.class		= FTC.UI.Texture( "FTC_TargetFrame_Class" , target , {30,30} , {BOTTOMRIGHT,TOPRIGHT,0,2} , nil , true )
		target.title		= FTC.UI.Label( "FTC_TargetFrame_Title" , target , { target:GetWidth() , 25 } , {TOP,BOTTOM,0,0} , FTC.Fonts.meta(14) , nil , {0,1} , '<Title>' , false )		
		
		-- Create health bar
		local thp 			= FTC.UI.Backdrop( "FTC_TargetFrame_Health" , target , {275,34} , {TOP,TOP,0,0,target} , {0.1,0,0,1} , {0,0,0,0} , false )
		thp:SetCenterTexture('FoundryTacticalCombat/lib/textures/grainy.dds')
		thp.bar				= FTC.UI.Statusbar( "FTC_TargetFrame_HealthBar" , thp , { thp:GetWidth() - 2 , thp:GetHeight() - 2 } , {TOPLEFT,TOPLEFT,1,1} , {0.6,0,0,1} , false )	
		thp.bar:SetTexture('FoundryTacticalCombat/lib/textures/grainy.dds')
		thp.current			= FTC.UI.Label( "FTC_TargetFrame_HealthCurrent" , thp , { thp:GetWidth() - 16 , thp:GetHeight() } , {CENTER,CENTER,0,0} , FTC.Fonts.meta(14) , nil , {2,1} , 'Health' , false )		
		thp.pct				= FTC.UI.Label( "FTC_TargetFrame_HealthPct" , thp , { thp:GetWidth() - 16 , thp:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontWindowSubtitle" , nil , {0,1} , 'Pct%' , false )		
		target.health		= thp
		
		-- Create damage shield bar
		target.shield		= FTC.UI.Statusbar( "FTC_TargetFrame_Shield" , health , {0,6} , {BOTTOMLEFT,BOTTOMLEFT,1,-1} , {1,0.4,0,1} , false )
	end
	
	--[[----------------------------------------------------------
		ULTIMATE TRACKING
	 ]]-----------------------------------------------------------
	if ( FTC.vars.EnableUltimate ) then
		local ultival 		= FTC.UI.Label( "FTC_UltimateLevel" , ActionButton8 , {100,20} , {BOTTOM,TOP,0,-3} , 'ZoFontAnnounceSmall' , nil , {1,2} , nil , false )
		local ultipct 		= FTC.UI.Label( "FTC_UltimatePct" , ActionButton8 , 'inherit' , {CENTER,CENTER,0,0} , 'ZoFontHeader2' , nil , {1,1} , nil , false )
	end
	
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