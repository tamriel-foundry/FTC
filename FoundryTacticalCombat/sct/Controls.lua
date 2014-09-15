 
 --[[----------------------------------------------------------
	SCROLLING COMBAT TEXT CONTROLS
	-----------------------------------------------------------
	* Creates UI controls for the scrolling combat text component
	* Runs during FTC.SCT.Initialize()
  ]]--
  
function FTC.SCT:Controls()

	-- Create outgoing damage container
	local name		= "FTC_CombatTextOut"
	local anchor	= FTC.vars[name]
	local CTO 		= FTC.UI.TopLevelWindow( name , GuiRoot , {FTC.vars.SCTNames and 400 or 150,750} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )
	CTO.backdrop 	= FTC.UI.Backdrop( name.."_Backdrop" , CTO , "inherit" , {CENTER,CENTER,0,0} , nil , nil , true )	
	CTO.label		= FTC.UI.Label( name.."_Label" , CTO , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Outgoing Damage" , true )
	
	-- Create incoming damage container
	local name		= "FTC_CombatTextIn"
	local anchor	= FTC.vars[name]
	local CTI 		= FTC.UI.TopLevelWindow( name , GuiRoot , {FTC.vars.SCTNames and 400 or 150,750} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )
	CTI.backdrop 	= FTC.UI.Backdrop( name.."_Backdrop" , CTI , "inherit" , {CENTER,CENTER,0,0} , nil , nil , true )	
	CTI.label		= FTC.UI.Label( name.."_Label" , CTI , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Incoming Damage" , true )
	
	-- Create status alerts container
	local name		= "FTC_CombatTextStatus"
	local anchor	= FTC.vars[name]
	local CTS 		= FTC.UI.TopLevelWindow( name , GuiRoot , {500,400} , {anchor[1],anchor[2],anchor[3],anchor[4]} , false )
	CTS.backdrop 	= FTC.UI.Backdrop( name.."_Backdrop" , CTS , "inherit" , {CENTER,CENTER,0,0} , nil , nil , true )	
	CTS.label		= FTC.UI.Label( name.."_Label" , CTS , 'inherit' , {CENTER,CENTER,0,0} , FTC.Fonts.meta(16) , nil , {1,1} , "Status Alerts" , true )
	
	-- Register movement handlers
	CTO:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	CTI:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	CTS:SetHandler( "OnMouseUp", function( self ) FTC.Menu:SaveAnchor( self ) end )
	
	-- Iterate over SCT types creating containers
	local types	= { "In" , "Out" , "Status" }
	for t = 1, #types do
		
		-- Create 10 combat text containers	
		local parent = _G[ "FTC_CombatText"..types[t] ]
		for i = 1 , FTC.vars.SCTCount do

			-- Alternate offsets and alignments
			local align 	= ( i % 2 == 0 ) and 2 or 0
			local offsetX 	= ( i % 2 == 0 ) and -100 or 100
			local offsetY 	= ( i % 2 == 0 ) and -25 or 25
			if ( i % 3 == 0 ) then	offsetY = 0	end
			
			-- Status effects are always center aligned
			if ( types[t] == "Status" ) then
				align = 1
				offsetX = 0
			end
			
			-- Create the SCT label
			local sctLabel = FTC.UI.Label( "FTC_SCT"..types[t]..i , parent , { parent:GetWidth() , 30 } , {BOTTOM,BOTTOM,offsetX,offsetY} , nil , nil , {align,1} , nil , false )
			
			-- Record offsets
			sctLabel.offsetX 	= offsetX
			sctLabel.offsetY 	= offsetY
			sctLabel.align		= align
		end	
	end
	
end