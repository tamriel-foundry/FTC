 
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
	
	-- Register init status
	if ( FTC.vars.EnableFrames ) then FTC.Frames.init = true end
	
	-- Populate some information to the player frame
	FTC_PlayerFrameName:SetText(FTC.Player.name)
	FTC_PlayerFrameLevel:SetText(FTC.Player.level < 50 and FTC.Player.class .. "  " .. FTC.Player.level or FTC.Player.class .. "  v" .. FTC.Player.vlevel)

	-- Populate the unit frames
	FTC.Frames:UpdateFrame( 'player', POWERTYPE_HEALTH	, FTC.Player.health.current		, FTC.Player.health.max		, FTC.Player.health.max )
	FTC.Frames:UpdateFrame( 'player', POWERTYPE_MAGICKA	, FTC.Player.magicka.current	, FTC.Player.magicka.max	, FTC.Player.magicka.max )
	FTC.Frames:UpdateFrame( 'player', POWERTYPE_STAMINA	, FTC.Player.stamina.current	, FTC.Player.stamina.max	, FTC.Player.stamina.max )
	FTC.Frames:UpdateUltimate( POWERTYPE_ULTIMATE , 0 , 0 , 0 )
	
	-- Hide the target frame
	FTC_TargetFrame:SetHidden(true)
	
	-- Allow the frames to be moved?
	FTC.Frames.move = false
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

	-- Bail if it's target magicka or target stamina
	if ( not FTC.Frames.init and context == "Target" and ( powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) ) then return end

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
	
	-- Maybe trigger an alert
	local prior = FTC[context][string.lower(attr.name)].pct
	if ( FTC.vars.EnableSCT and prior > 25 and pct < 25 ) then
		
		-- Get the alert name and type
		local ignore = false
		if ( context == "Player" ) then
			name = "Low " .. attr.name .. "!"
			aType = 1000 + powerType
		elseif ( context == "Target" ) then
			name = "Target Low " .. attr.name .. "!"
			aType = 1001 + powerType
		end
		
		-- Check if there's already an active alert
		for i = 1 , #FTC.SCT.Stat , 1 do
			if ( FTC.SCT.Stat[i].type == aType ) then ignore = true end
		end
		
		-- Setup a new SCT object
		if not ignore then
			local newSCT = {
				["name"]	= '',
				["dam"]		= name,
				["power"]	= 0,
				["type"]	= aType,
				["ms"]		= GetGameTimeMilliseconds(),
				["crit"]	= false,
				["heal"]	= false,
				["blocked"]	= false,
				["immune"]	= false
			}
			table.insert( FTC.SCT.Stat, newSCT )	
		end
	end

	-- Update the attribute bar
	local parent	= _G["FTC_" .. context .. "Frame" .. attr.name]
	local bar		= _G["FTC_" .. context .. "Frame" .. attr.name .. "Bar"]
	local minLabel 	= _G["FTC_" .. context .. "Frame" .. attr.name .. "Min"]
	local pctLabel 	= _G["FTC_" .. context .. "Frame" .. attr.name .. "Pct"]
	
	-- Get the default attribute bar
	local default 	= ( context == "Player" ) and _G["FTC_DefaultPlayer"..attr.name] or _G["FTC_DefaultTargetHealth"]
		
	-- Update bar
	local red 	= attr.red * ( 5 - ( pct / 25 ) )
	local green = attr.green * ( 5 - ( pct / 25 ) ) 
	local blue	= attr.blue * ( 5 - ( pct / 25 ) ) 
	bar:SetWidth( ( pct / 100 ) * parent:GetWidth() )
	bar:SetCenterColor( red , green , blue , 0.5 )
	
	-- Update labels
	minLabel:SetText( ( powerValue > 10000 ) and math.floor( ( powerValue + 500 ) / 1000 ) .. "k" or powerValue )
	pctLabel:SetText(pct .. "%")
	default:SetText( powerValue .. " / " .. powerEffectiveMax .. " (" .. pct .. "%)")
	
	-- Toggle opacity
	local isFull = (( powerType == POWERTYPE_HEALTH and pct == 100 )  or ( FTC.Player.health.pct == 100 )) and not IsUnitInCombat('player')
	if ( isFull ) then 
		frame:SetAlpha(0.5)
	else 
		frame:SetAlpha(1)
	end
	
	-- Ensure the default unit frames remain hidden
	ZO_PlayerAttribute:SetHidden( FTC.Frames.init )
	frame:SetHidden( not FTC.Frames.init )
	
	-- Update data
	FTC[context][string.lower(attr.name)] = { ["current"] = powerValue , ["max"] = powerEffectiveMax , ["pct"] = pct }
	
 end
 
 
 --[[ 
 * Update the ultimate gain tracker.
 * Called by OnPowerUpdate
 ]]--
function FTC.Frames:UpdateUltimate( unitTag , powerValue , powerMax , powerEffectiveMax )
		
	-- Get the ability button
	parent = _G["ActionButton8"]
	
	-- Get the currently slotted ultimate cost
	cost, mechType = GetSlotAbilityCost(8)
	
	-- Get the current available ultimate (don't trust the values returned by the event)
	powerValue, powerMax, powerEffectiveMax = GetUnitPower( 'reticleovertarget' , POWERTYPE_ULTIMATE )
	
	-- Calculate the percentage to activation
	local pct = ( cost > 0 ) and math.min( math.floor( ( powerValue / cost ) * 100 ) , 100 ) or 0
	
	-- Create a tooltip
	FTC_UltimateTracker:SetText( powerValue .. "\r\n" .. pct .. "%")	
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
 * Called by OnPowerUpdate
 ]]--
function FTC.Frames:UpdateTarTar( powerValue , powerMax , powerEffectiveMax )
			
	-- Get the target of target frame
	local parent 	= _G["FTC_TarTarFrame"]
	
	-- Change the bar width
	local backdrop 	= _G["FTC_TarTarFrame_Backdrop"]
	local bar 		= _G["FTC_TarTarFrame_Bar"]
	bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( backdrop:GetWidth() - 4 ) )
	
	-- Set the label
	FTC_TarTarFrame_Name:SetText( GetUnitName('reticleovertarget') )
	
	-- Set the percent
	local pct = math.floor( ( powerValue / powerEffectiveMax ) * 100 )
	FTC_TarTarFrame_Pct:SetText( pct .. "%" )

	-- Display the frame
	parent:SetHidden( false )
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
	
	-- Update the FTC object
	FTC[context].shield = { ["current"] = value , ["max"] = maxValue , ["pct"] = math.floor( ( value / maxValue ) * 100 ) }
	
	-- Get the shield bar
	local health	= _G["FTC_" .. context .. "FrameHealth"]
	local bar 		= _G["FTC_" .. context .. "Frame_Shield"]
	
	-- Change the bar width
	bar:SetWidth( math.min( ( value / maxHealth ) , 1 ) * ( health:GetWidth() - 4 ) )
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
	
	-- Populate the target object
	local stats = {
		{ ["name"] = "health",  ["id"] = POWERTYPE_HEALTH, 	["display"] = true },
		{ ["name"] = "magicka", ["id"] = POWERTYPE_MAGICKA, ["display"] = isPlayer },
		{ ["name"] = "stamina", ["id"] = POWERTYPE_STAMINA, ["display"] = isPlayer }
	}
	for i = 1 , #stats , 1 do
		if ( stats[i].display ) then
			local current, maximum, effectiveMax = GetUnitPower( 'reticleover' , stats[i].id )
			FTC.Target[stats[i].name] = { ["current"] = current , ["max"] = effectiveMax , ["pct"] = math.floor( current * 100 / effectiveMax ) }
			FTC.Frames:UpdateFrame( 'reticleover', stats[i].id, current, maximum, effectiveMax )
		end
	end
	
	-- Resize the unit frame appropriately
	FTC_TargetFrameMagicka:SetHidden( not isPlayer )
	FTC_TargetFrameStamina:SetHidden( not isPlayer )
	FTC_TargetFrame:SetHeight( isPlayer and 75 or 28 )
	FTC_TargetFrameBackdrop:SetHeight( isPlayer and 75 or 28 )
	
	-- Populate the frame nameplate
	local name = FTC.Target.name .. " "
	if( not isPlayer ) then 
		local diff = math.max( GetUnitDifficulty('reticleover') - 1 , 0 ) 
		for i = 1 , diff do name = name .. "*" end
		FTC.Target.class = ( GetUnitCaption('reticleover') ~= nil ) and GetUnitCaption('reticleover') or ""
	end
	FTC_TargetFrameName:SetText(name)
	FTC_TargetFrameLevel:SetText(FTC.Target.vlevel > 0 and FTC.Target.class .. "  v" .. FTC.Target.vlevel or FTC.Target.class .. "  " .. FTC.Target.level)
	
	-- Does a target-target exist?
	local tartar = ( GetUnitName('reticleovertarget') ~= "" )
	FTC_TarTarFrame:SetHidden( not tartar )
	if tartar then 
		FTC.Frames:UpdateTarTar( GetUnitPower( 'reticleovertarget' , POWERTYPE_HEALTH ) )
		FTC_TarTarFrame_Name:SetText( GetUnitName('reticleovertarget') )
	end
	
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
 * Toggles display of the mount stamina bar
 * Called by OnMount()
 ]]--
function FTC.Frames:DisplayMount( eventCode , isMounted )

	-- Toggle display of the mount bar
	FTC_MountFrame:SetHidden( not isMounted )
	
	-- Fetch the current mount stamina level
	local current, maximum, effectiveMax = GetUnitPower( 'player' , POWERTYPE_MOUNT_STAMINA )
	FTC_MountFrame_Bar:SetWidth( ( current / effectiveMax ) * FTC_MountFrame_Backdrop:GetWidth() - 4 )
end


--[[ 
 * Allows the frames to be made movable
 * Called by ___()
 ]]--
function FTC.MoveFrame( self ) 

	-- Get the element
	local frame = self == FTC_PlayerFrame and "Player" or "Target"

	-- Get window positions relative to screen center
	local X = self:GetLeft() - ( GuiRoot:GetWidth() / 2 ) + ( self:GetWidth() / 2 )
	local Y = self:GetTop() - ( GuiRoot:GetHeight() / 2 ) + ( self:GetHeight() / 2 )
	
	-- Save the variable
	FTC.vars[frame.."FrameX"] = X
	FTC.vars[frame.."FrameY"] = Y
end
