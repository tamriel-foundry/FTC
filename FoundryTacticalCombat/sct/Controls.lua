 
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
	local types	= FTC.SCTContexts
	local  maxLabels = FTC.vars.SCTMaxLabels or FTC.defaults.SCTMaxLabels
	for t = 1, #types do
		
		-- Create 10 combat text containers	
		local parent = _G[ "FTC_CombatText"..types[t] ]
		for i = 1 , maxLabels do
		
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
			local sctLabel = FTC.UI.Label( "FTC_SCT"..types[t]..i , parent , { parent:GetWidth() , 30 } , {BOTTOM,BOTTOM,0,offsety} , "ZoFontHeader2", nil , {align,1} , nil , false )					
		end	
	end
	
end