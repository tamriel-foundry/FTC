 
 --[[----------------------------------------------------------
	UNIT FRAMES FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the unit frames component of FTC
	* Runs during FTC:Initialize()
  ]]--
 
FTC.Frames = {}
function FTC.Frames:Initialize()

	-- Create UI elements
	FTC.Frames:Controls()
	
	-- Populate the unit frames
	FTC.Frames:UpdateFrame( 'player', POWERTYPE_HEALTH	, FTC.Player.health.current		, FTC.Player.health.max		, FTC.Player.health.max )
	FTC.Frames:UpdateFrame( 'player', POWERTYPE_MAGICKA	, FTC.Player.magicka.current	, FTC.Player.magicka.max	, FTC.Player.magicka.max )
	FTC.Frames:UpdateFrame( 'player', POWERTYPE_STAMINA	, FTC.Player.stamina.current	, FTC.Player.stamina.max	, FTC.Player.stamina.max )
	
	-- Populate the ultimate
	FTC.Frames:UpdateUltimate( POWERTYPE_ULTIMATE , FTC.Player.ultimate.current	, FTC.Player.ultimate.max , FTC.Player.ultimate.max )
	
	-- Configure custom unit frames
	if ( FTC.vars.EnableFrames ) then

		-- Populate some information to the player frame
		FTC.Frames:SetupPlayer()

		-- Register init status
		FTC.init.Frames = true 
	end
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------
 
 --[[ 
 * Process updates to character attributes
 * Called by OnPowerUpdate()
 ]]--
 function FTC.Frames:UpdateFrame( unitTag , powerType ,  powerValue , powerMax , powerEffectiveMax )
 
 	-- Get the context
	local context = ( unitTag == 'player' ) and "Player" or "Target"

	-- Get the unit frame container
	local frame = _G["FTC_" .. context .. "Frame"]
	if ( frame == nil ) then return end
	
	-- Get the attribute
	local attr = ""
	if ( powerType == POWERTYPE_HEALTH ) 		then attr = { ["name"] = "Health",  ["red"] = 0.2, ["green"] = 0, ["blue"] = 0 }
	elseif ( powerType == POWERTYPE_MAGICKA ) 	then attr = { ["name"] = "Magicka", ["red"] = 0.1, ["green"] = 0.1, ["blue"] = 0.3 }
	elseif ( powerType == POWERTYPE_STAMINA ) 	then attr = { ["name"] = "Stamina", ["red"] = 0, ["green"] = 0.2, ["blue"] = 0 }
	else return end
	
	-- Get the percentage
	local pct = math.floor( ( powerValue / powerEffectiveMax ) * 100 )
	
	-- Get the attribute bar
	local parent	= _G["FTC_" .. context .. "Frame" .. attr.name]
	local bar		= _G["FTC_" .. context .. "Frame" .. attr.name .. "Bar"]
	local minLabel 	= _G["FTC_" .. context .. "Frame" .. attr.name .. "Min"]
	local pctLabel 	= _G["FTC_" .. context .. "Frame" .. attr.name .. "Pct"]
	
	-- Update bar
	local red 	= attr.red * ( 5 - ( pct / 25 ) )
	local green = attr.green * ( 5 - ( pct / 25 ) ) 
	local blue	= attr.blue * ( 5 - ( pct / 25 ) ) 
	bar:SetWidth( ( pct / 100 ) * parent:GetWidth() )
	bar:SetCenterColor( red , green , blue , 0.5 )	
	minLabel:SetText( ( powerValue > 10000 ) and math.floor( ( powerValue + 500 ) / 1000 ) .. "k" or powerValue )
	pctLabel:SetText(pct .. "%")
	
	-- Ensure visibility
	frame:SetHidden( not FTC.init.Frames )	
	
	-- Update the default attribute bar
	local default 	= ( context == "Player" ) and _G["FTC_DefaultPlayer"..attr.name] or _G["FTC_DefaultTargetHealth"]	
  local defaultText = ""
  local showPercentage = true
  if ( FTC.vars.EnableDefaultCurrentMax ) then defaultText = powerValue .. " / " .. powerEffectiveMax end
  if ( FTC.vars.EnableDefaultPercentage ) then 
    if ( FTC.vars.EnableDefaultCurrentMax ) then defaultText = defaultText .. " (" .. pct .. "%)"
    else defaultText = defaultText .. pct .. "%" end
  end
	default:SetText( defaultText )
	
	-- Toggle opacity
	local alpha = ((( powerType == POWERTYPE_HEALTH and pct == 100 )  or ( FTC.Player.health.pct == 100 )) and not IsUnitInCombat('player')) and 0.5 or 1
	frame:SetAlpha(alpha)

	-- Ensure the default unit frames remain hidden
	ZO_PlayerAttribute:SetHidden( FTC.init.Frames )
	
	-- Update the database object
	FTC[context][string.lower(attr.name)] = { ["current"] = powerValue , ["max"] = powerEffectiveMax , ["pct"] = pct }
	
 end
 
 
 --[[ 
 * Update the ultimate gain tracker.
 * Called by OnPowerUpdate
 ]]--
function FTC.Frames:UpdateUltimate( powerValue , powerMax , powerEffectiveMax )
		
	-- Get the ability button
	parent = _G["ActionButton8"]
	
	-- Get the currently slotted ultimate cost
	cost, mechType = GetSlotAbilityCost(8)
	
	-- Calculate the percentage to activation
	local pct = ( cost > 0 ) and math.floor( ( powerValue / cost ) * 100 ) or 0
	
	-- Update the tooltip
	FTC_UltimatePct:SetText( pct .. "%")
	FTC_UltimateLevel:SetText( powerValue )
	
	-- Maybe fire an alert
	if ( FTC.init.SCT ) then
	
		-- Get the former value
		local prior = FTC.Player.ultimate.pct
		
		-- If we just reached full ulti, alert!
		if ( pct >= 100 and prior < 100 ) then
			local newAlert = {
				["type"]	= 'ulti',
				["name"]	= 'Ultimate Ready',
				["value"]	= '',
				["ms"]		= GetGameTimeMilliseconds(),
				["color"]	= 'c99FFFF',
				["size"]	= 20
			}
			FTC.SCT:NewStatus( newAlert )
		end
	end
	
	-- Update the database object
	FTC.Player.ultimate = { ["current"] = powerValue , ["max"] = powerEffectiveMax , ["pct"] = pct }
end

 --[[ 
 * Update the player's mount stamina bar
 * Called by OnPowerUpdate
 ]]--
function FTC.Frames:UpdateMount( powerValue , powerMax , powerEffectiveMax )
			
	-- Get the mount stamina bar
	local parent = _G["FTC_MountFrame"]
	
	-- Bail if the bar isn't being shown
	if ( parent:IsHidden() ) then return end
	
	-- Change the bar width
	local backdrop = _G["FTC_MountFrame_Backdrop"]
	local bar = _G["FTC_MountFrame_Bar"]
	bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( backdrop:GetWidth() - 4 ) )
end

 --[[ 
 * Update the reticle target-of-target
 * Called by OnVisualAdded
 * Called by OnVisualUpdate
 * Called by OnVisualRemoved
 ]]--
function FTC.Frames:UpdateShield( unitTag , value , maxValue )

	-- Get the context
	local context 	= ( unitTag == 'player' ) and "Player" or "Target"
	
	-- Get the unit's maximum health
	local maxHealth = ( unitTag == 'player' ) and FTC.Player.health.max or FTC.Target.health.max
	
	-- Get the shield bar
	local health	= _G["FTC_" .. context .. "FrameHealth"]
	local bar 		= _G["FTC_" .. context .. "Frame_Shield"]
	
	-- Change the bar width
	bar:SetWidth( math.min( ( value / maxHealth ) , 1 ) * ( health:GetWidth() - 4 ) )
	
	-- Update the database object
	FTC[context].shield = { ["current"] = value , ["max"] = maxValue , ["pct"] = math.floor( ( value / maxValue ) * 100 ) }
end
  

--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------
 
 --[[ 
 * Set up the target frame every time the target changes.
 * Called by FTC:UpdateTarget()
 ]]--
 function FTC.Frames:SetupTarget()
	
	-- Check target context
	local isPlayer = IsUnitPlayer('reticleover')
					
	-- Load the target's health	
	local current, maximum, effectiveMax = GetUnitPower( 'reticleover' , POWERTYPE_HEALTH )
	FTC.Target.health = { ["current"] = current , ["max"] = effectiveMax , ["pct"] = math.floor( current * 100 / effectiveMax ) }
	FTC.Frames:UpdateFrame( 'reticleover', POWERTYPE_HEALTH , current, maximum, effectiveMax )
	
	-- Populate the frame nameplate
	local name 		= FTC.Target.name
	local level 	= FTC.Target.vlevel > 0 and "v" .. FTC.Target.vlevel or FTC.Target.level
	if( not isPlayer ) then 
		local diff = math.max( GetUnitDifficulty('reticleover') - 1 , 0 ) 
		for i = 1 , diff do name = name .. "^" end
		FTC.Target.class = ( GetUnitCaption('reticleover') ~= nil ) and GetUnitCaption('reticleover') or ""
	end
	FTC_TargetFrameName:SetText( name .. " (" .. level .. ")" )
	
	-- Populate the class icon
	if ( isPlayer ) then FTC_TargetFrameClass:SetTexture( "/esoui/art/contacts/social_classicon_" .. FTC.Target.class .. ".dds" ) end
	FTC_TargetFrameClass:SetHidden( not isPlayer )
	
	-- Does the target have a shield?
	local unitAttributeVisual, statType, attributeType, powerType, value, maxValue = GetAllUnitAttributeVisualizerEffectInfo("reticleover")
	if ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING and powerType == POWERTYPE_HEALTH ) then
		FTC.Frames:UpdateShield( 'reticleover' , value , FTC.Target.health.max )
		FTC.Target.shield = { ["current"] = value , ["max"] = maxValue , ["pct"] = math.floor( ( value / maxValue ) * 100 ) }
	else
		FTC.Frames:UpdateShield( 'reticleover' , 0 , 999 )
		FTC.Target.shield = { ["current"] = 0 , ["max"] = 0 , ["pct"] = 0 }
	end
end

 --[[ 
 * Set up the player frame, loading the name and level
 * Called by Initialize()
 * Called by OnXPUpdate()
 * Called by OnVPUpdate()
 ]]--
function FTC.Frames:SetupPlayer()
	
	-- Reset the player name/level
	if ( FTC.vars.EnableNameplate ) then
		local name 		= FTC.Player.name
		local level 	= FTC.Player.vlevel > 0 and "v" .. FTC.Player.vlevel or FTC.Player.level
		FTC_PlayerFrameName:SetText( name .. " (" .. level .. ")" )
	end
	FTC_PlayerFramePlate:SetHidden( not FTC.vars.EnableNameplate )
	
	-- Set the experience bar
	if ( FTC.vars.EnableXPBar and FTC.Player.vlevel < 10 ) then 
		local maxExp	= ( FTC.Player.level == 50 ) and GetUnitVeteranPointsMax('player') or GetUnitXPMax('player')
		local currExp	= ( FTC.Player.level == 50 ) and FTC.Player.vet or FTC.Player.exp
		local pct		= math.floor( 100 * ( currExp / maxExp ) )
		FTC_XPBar_Bar:SetWidth( ( pct / 100 ) * ( FTC_XPBar:GetWidth() - 4 ) )
	end
	FTC_XPBar:SetHidden( not ( FTC.vars.EnableXPBar and FTC.Player.vlevel < 10 ) )
end

--[[ 
 * Toggles display of the mount stamina bar
 * Called by OnMount()
 ]]--
function FTC.Frames:DisplayMount( eventCode , isMounted )
	
	-- Toggle display of the experience bar
	if ( FTC.vars.EnableXPBar and FTC.Player.vlevel < 10 ) then FTC_XPBar:SetHidden( isMounted ) end

	-- Toggle display of the mount bar
	FTC_MountFrame:SetHidden( not isMounted )
	
	-- Fetch the current mount stamina level
	local current, maximum, effectiveMax = GetUnitPower( 'player' , POWERTYPE_MOUNT_STAMINA )
	FTC_MountFrame_Bar:SetWidth( ( current / effectiveMax ) * FTC_MountFrame_Backdrop:GetWidth() - 4 )
end