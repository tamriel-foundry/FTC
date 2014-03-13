--[[----------------------------------------------------------
	CASTBAR DISPLAY COMPONENT
 ]]-----------------------------------------------------------
 function FTC.InitializeCastbar()
	
	-- Create player and target bars
	local bars = { ["Player"] = "ZO_PlayerAttributeHealth" , ["Target"] = "ZO_TargetUnitFramereticleover" }
	for k,v in pairs(bars) do
	
		-- Adjust the bars if the user is running the HUD frames
		local parent = FTC.init.HUD and _G["FTC_"..k.."Frame"] or _G[v]
		
		-- Create the castbar
		local CB 	= FTC.UI.TopLevelWindow( "FTC_"..k.."Castbar" , parent , {parent:GetWidth(),24} , {BOTTOMLEFT,TOPLEFT,0,-25} , false )	
		CB.backdrop = FTC.UI.Backdrop( "FTC_"..k.."CastbarBackdrop" , CB , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )		
		CB.bar 		= FTC.UI.Statusbar( "FTC_"..k.."CastbarBar" , CB , { CB:GetWidth() - 8 , 16 } , {LEFT,LEFT,4,0} , nil , false )		
		CB.label 	= FTC.UI.Label( "FTC_"..k.."CastbarLabel" , CB , "inherit" , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {1,1} , false )
	end
	
	-- Modify the bar position if HUD isnt enabled
	if ( not FTC.init.HUD ) then FTC_TargetCastbar:SetAnchor( BOTTOMLEFT, ZO_TargetUnitFramereticleover , TOPLEFT , 0 , -15 ) end
end


--[[----------------------------------------------------------
	ON UPDATE FUNCTIONS
 ]]-----------------------------------------------------------
 
 --[[ 
 * Generates a cast bar for enemies in combat.
 * The cast-bar hints what is the appropriate reaction to enemy spells.
 * Runs every frame OnUpdate.
 ]]--
function FTC.UpdateCastBar( context )

	-- Get the context
	if ( context == "Target" ) then 
		unitTag = "reticleover"
		default = "ZO_TargetUnitFramereticleover"
	elseif (context == "Player" ) then 
		unitTag = "player"
		default = "ZO_PlayerAttributeHealth"
	end
	
	-- Retrieve the castbar elements
	local parent 	= FTC.init.HUD and _G["FTC_"..context.."Frame"] or _G[default]
	local container	= _G["FTC_"..context.."Castbar"]
	local label		= _G["FTC_"..context.."CastbarLabel"]
	local castbar	= _G["FTC_"..context.."CastbarBar"]

	-- Bail if the unitTag is not in combat
	if( context == "Target" and not IsUnitInCombat(unitTag) ) or ( context == "Player" and IsUnitDead(unitTag) ) then
		container:SetHidden(true) 
		return
	end
	
	-- Otherwise get the target's casting status
	local actionName, timeStarted, timeEnding, isChannel, barType, canBlock, canInterrupt, isChargeUp, hideBar = GetUnitCastingInfo(unitTag)
	
	-- Bail for no spell
	if ( actionName == "" ) then 
		container:SetHidden(true)
		return
	end
	
	-- Customize the bar
	local prompt = ""
	if ( context == "Player" ) then 
		if ( isChargeUp ) then
			castbar:SetColor(0.8,0.4,0,0.9)
		else
			castbar:SetColor(0.2,0.2,0.6,0.9)
		end

	else
		if ( canInterrupt ) then
			prompt = "- Interrupt!"
			castbar:SetColor(0.2,0.2,0.6,0.9)
		elseif ( canBlock ) then
			prompt = "- Block!"
			castbar:SetColor(0.8,0.4,0,0.9)
		else
			prompt = "- Dodge!"
			castbar:SetColor(0.4,0,0,0.9)
		end
	end

	
	-- Determine the duration
	local gameTime = GetGameTimeMilliseconds() / 1000
	local castTime = ( timeEnding - gameTime ) / ( timeEnding - timeStarted )
	castbar:SetWidth( castTime * ( parent:GetWidth() - 8 ) )
	
	-- Hide the castbar when the duration reaches zero
	if ( timeEnding - gameTime <= 0 ) then 
		container:SetHidden(true)
		return
	
	-- Otherwise display the tooltip
	else
		container:SetHidden(false) 
		label:SetText(actionName .. prompt)
	end
end