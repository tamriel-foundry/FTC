 
 --[[----------------------------------------------------------
	SCROLLING COMBAT TEXT CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the scrolling combat text component
	* Runs during FTC.SCT.Initialize()
  ]]--
  
function FTC.SCT:Controls()

 	-- Get the target frame element
	local parent = _G["ZO_TargetUnitFramereticleover"]	

	-- Create damage meter containers
	local CTO 	= FTC.UI.TopLevelWindow( "FTC_CombatTextOut" 	, GuiRoot , {FTC.vars.SCTNames and 400 or 100,500} , {TOPRIGHT,BOTTOMLEFT,-50,0,parent} , false )	
	local CTI 	= FTC.UI.TopLevelWindow( "FTC_CombatTextIn" 	, GuiRoot , {FTC.vars.SCTNames and 400 or 100,500} , {TOPLEFT,BOTTOMRIGHT,50,0,parent} , false )	
	local CTS 	= FTC.UI.TopLevelWindow( "FTC_CombatTextStat" 	, GuiRoot , {parent:GetWidth() + 100,500} , {TOP,BOTTOM,0,-250,parent} , false )		
	
	-- Iterate over SCT types creating containers
	local types	= { "In" , "Out" , "Stat" }
	for t = 1, #types do
		
		-- Create 10 combat text containers	
		local parent = _G[ "FTC_CombatText"..types[t] ]
		for i = 1 , 10 do
		
			-- Alternate offsets and alignments
			local align = 0
			local offsety = 25
			if ( i % 2 == 0 ) then
				align = 2
				offsety = 0
			end
			if ( i % 3 ) then
				offsety = -25
			end
			align = ( context == "Stat" ) and 1 or align
			
			-- Create the SCT label
			local sctLabel = FTC.UI.Label( "FTC_SCT"..types[t]..i , parent , { parent:GetWidth() , 30 } , {BOTTOM,BOTTOM,0,offsety} , "ZoFontHeader2", nil , {align,1} , false )					
		end	
	end
	
	-- Setup DPS meter container
	local DM 	= FTC.UI.TopLevelWindow( "FTC_DamageMeter" 		, GuiRoot , {600,220} , {TOPLEFT,TOPLEFT,10,10} , true )
	DM.backdrop = FTC.UI.Backdrop( "FTC_DamageMeterBackdrop" 	, DM , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
	DM.title 	= FTC.UI.Label( "FTC_DamageMeterTitle" 			, DM , {DM:GetWidth() - 20 , 25} , {TOPLEFT,TOPLEFT,20,10} , "ZoFontWindowSubtitle" , nil , {0,1} , false )
	DM.title:SetText("FTC Damage Meter")

	-- Iterate through damage meter components
	local comps = { "Damage" , "Healing" , "Incoming" }
	local anchor = DM.title
	for i = 1 , #comps , 1 do
		local section 	= FTC.UI.Control( "FTC_DamageMeter_" .. comps[i] , DM , {DM:GetWidth() , 50} , {TOPLEFT,BOTTOMLEFT,0,5,anchor} , false )
		local names 	= FTC.UI.Label( "FTC_DamageMeter_" .. comps[i] .. "Label" , section , { 0.7 * section:GetWidth() , section:GetHeight() } , {TOPLEFT,TOPLEFT,0,0} , "ZoFontGame" , nil , {0,1} , false )
		local values 	= FTC.UI.Label( "FTC_DamageMeter_" .. comps[i] .. "Value" , section , { 0.3 * section:GetWidth() , section:GetHeight() } , {TOPRIGHT,TOPRIGHT,0,0} , "ZoFontWindowSubtitle" , nil , {1,1} , false )		
		anchor = section
	end
end