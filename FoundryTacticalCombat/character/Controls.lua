 
 --[[----------------------------------------------------------
	CHARACTER SHEET CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the character tracking component.
	* Runs during FTC.Character:Initialize()
  ]]--
  
function FTC.Character:Controls()

	-- Setup mini character sheet
	local CS 	= FTC.UI.TopLevelWindow( "FTC_CharSheet" , GuiRoot , {600,170} , {TOPLEFT,TOPLEFT,5,5} , true )
	CS.backdrop = FTC.UI.Backdrop( "FTC_CharSheetBackdrop" , CS , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
		
	-- Loop through character sheet sections, setting them up iteratively
	local comps 	= { "Attributes" , "Offense" , "Defense" , "Resists" };
	local anchor	= CS
	for i = 1 , #comps , 1 do
	
		-- Set up the character sheet section
		local section 	= FTC.UI.Control( "FTC_CharSheet_"..comps[i] , CS , {CS:GetWidth()/4,CS:GetHeight()} , {TOPLEFT,TOPRIGHT,0,0,anchor} , false )		
		local title		= FTC.UI.Label( "FTC_CharSheet_"..comps[i].."Title" , section , {section:GetWidth(),16} , {TOP,TOP,0,5} , "ZoFontAnnounceSmall" , nil , {1,0} , "--- "..comps[i].." ---" , false )
		local names 	= FTC.UI.Label( "FTC_CharSheet_"..comps[i].."Names" , section , {.75*section:GetWidth(),section:GetHeight()-20} , {TOPLEFT,BOTTOMLEFT,10,5,title} , "ZoFontBoss" , nil , {0,0} , nil , false )	
		local values 	= FTC.UI.Label( "FTC_CharSheet_"..comps[i].."Values" , section , {.25*section:GetWidth(),section:GetHeight()-20} , {TOPRIGHT,BOTTOMRIGHT,-10,5,title} , "ZoFontBoss" , nil , {2,0} , nil , false )
		
		-- Adjust the position of the first section
		if i == 1 then section:SetAnchor(TOPLEFT,anchor,TOPLEFT,0,0) end
		
		-- Hook the next section to the previous parent
		anchor = section
	end
	
	-- Experience Bar
	if ( FTC.character.vlevel < 10 ) then 		
		CS.exp 		= FTC.UI.Backdrop( "FTC_CharSheet_Exp" , CS , { CS:GetWidth() - 20 , 20 } , {BOTTOM,BOTTOM,0,-5} , {0,0.2,0.4,1} , {0,0,0,1} , false )
		CS.bar 		= FTC.UI.Statusbar( "FTC_CharSheet_ExpBar" , CS , { CS.exp:GetWidth() - 4 , 14 } , {LEFT,LEFT,2,0,CS.exp} , {0.4,0.6,0.8,1} , false )	
		CS.exp.label = FTC.UI.Label( "FTC_CharSheet_ExpLabel" , CS.exp , "inherit" , {CENTER,CENTER,0,-1,CS.exp} , "ZoFontAnnounceSmall" , nil , {1,1} , nil , false )
	end
	
end