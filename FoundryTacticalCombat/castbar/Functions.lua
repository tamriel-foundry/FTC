 
 --[[----------------------------------------------------------
	CASTBAR FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the castbar component of FTC
	* Runs during FTC:Initialize()
  ]]--
 
FTC.Castbar = {}
function FTC.Castbar:Initialize()

	-- Create UI elements
	FTC.Castbar:Controls()
	
	-- Register init status
	FTC.Castbar.init = true
	
end


--[[----------------------------------------------------------
	ON UPDATE FUNCTIONS
 ]]-----------------------------------------------------------
 
--[[ 
 * Checks for active spellcasting and displays a status bar
 * Runs OnUpdate()
 ]]--
function FTC.Castbar:Update( context )

	-- Get the context
	if ( context == "Target" ) then 
		unitTag = "reticleover"
		default = "ZO_TargetUnitFramereticleover"
	elseif (context == "Player" ) then 
		unitTag = "player"
		default = "ZO_PlayerAttributeHealth"
	end
	
	-- Retrieve the castbar elements
	local parent 	= FTC.Frames.init and _G["FTC_"..context.."Frame"] or _G[default]
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