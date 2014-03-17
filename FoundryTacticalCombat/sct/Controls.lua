 
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
	local CTO 	= FTC.UI.TopLevelWindow( "FTC_CombatTextOut" 	, GuiRoot , {FTC.vars.SCTNames and 300 or 100,800} , {TOPRIGHT,TOPLEFT,-200,0,parent} , false )
	local CTI 	= FTC.UI.TopLevelWindow( "FTC_CombatTextIn" 	, GuiRoot , {FTC.vars.SCTNames and 300 or 100,800} , {TOPLEFT,TOPRIGHT,200,0,parent} , false )	
	local CTS 	= FTC.UI.TopLevelWindow( "FTC_CombatTextStat" 	, GuiRoot , {parent:GetWidth() + 100,800} , {TOP,BOTTOM,0,-250,parent} , false )		
	
	-- Iterate over SCT types creating containers
	local types	= { "In" , "Out" , "Stat" }
	for t = 1, #types do
		
		-- Create 10 combat text containers	
		local parent = _G[ "FTC_CombatText"..types[t] ]
		for i = 1 , FTC.vars.SCTCount do

			-- Alternate offsets and alignments
			local align 	= ( i % 2 == 0 ) and 2 or 0
			local offsetX 	= ( i % 2 == 0 ) and -50 or 50
			local offsetY 	= ( i % 2 == 0 ) and -25 or 25
			if ( i % 3 == 0 ) then	offsetY = 0	end
			
			-- Create the SCT label
			local sctLabel = FTC.UI.Label( "FTC_SCT"..types[t]..i , parent , { parent:GetWidth() , 30 } , {BOTTOM,BOTTOM,offsetX,offsetY} , nil , nil , {align,1} , nil , false )
			
			-- Record offsets
			sctLabel.offsetX 	= offsetX
			sctLabel.offsetY 	= offsetY
			sctLabel.align		= align
		end	
	end
	
end