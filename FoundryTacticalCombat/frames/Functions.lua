 
 --[[----------------------------------------------------------
	UNIT FRAMES FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the unit frames component of FTC
	* Runs during FTC:Initialize()
  ]]--
 
FTC.Frames = {}
function FTC.Frames:Initialize()

	-- Unregister events for default frames
	if ( FTC.vars.EnableFrames ) then
		local frames = { 'Health' , 'Stamina' , 'Magicka' , 'MountStamina' , 'SiegeHealth' }
		for i = 1 , #frames do
			local frame = _G["ZO_PlayerAttribute"..frames[i]]
			frame:UnregisterForEvent(EVENT_POWER_UPDATE)
			frame:UnregisterForEvent(EVENT_INTERFACE_SETTING_CHANGED)
			frame:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
			EVENT_MANAGER:UnregisterForUpdate("ZO_PlayerAttribute"..frames[i].."FadeUpdate")
			frame:SetHidden(true)		
		end
	end
	
	-- Hide the default target frame
	if ( FTC.vars.EnableFrames and not FTC.vars.TargetFrame ) then
		ZO_TargetUnitFramereticleover:SetHidden(true)
	end

	-- Create UI elements
	FTC.Frames:Controls()

	-- Register init status
	if ( FTC.vars.EnableFrames ) then FTC.init.Frames = true end
	if ( FTC.vars.EnableUltimate ) then FTC.init.Ultimate = true end

	-- Populate some information to the player frame
	FTC.Frames:SetupPlayer()
end


--[[----------------------------------------------------------
	ATTRIBUTES
 ]]-----------------------------------------------------------
 
 --[[ 
 * Process updates to character attributes
 * Called by OnPowerUpdate()
 ]]--
 function FTC.Frames:UpdateAttribute( unitTag , powerType ,  powerValue , powerMax , powerEffectiveMax )
 
 	-- Get the context
	local context = ( unitTag == 'player' ) and "Player" or "Target"
	
	-- Get the attribute
	local attrs = {	[POWERTYPE_HEALTH] = "Health", [POWERTYPE_MAGICKA] = "Magicka", [POWERTYPE_STAMINA] = "Stamina"	}
	local name	= attrs[powerType]
	
	-- Get the percentage
	local pct = math.floor( ( powerValue / powerMax ) * 100 )
	
	-- Update custom frames
	if ( FTC.init.Frames ) then
	
		-- Get the unit frame container
		local frame = _G["FTC_" .. context .. "Frame"]
	
		-- Get the attribute bar
		local parent	= _G["FTC_" .. context .. "Frame_" .. name]
		local bar		= _G["FTC_" .. context .. "Frame_" .. name .. "Bar"]
		local curLabel 	= _G["FTC_" .. context .. "Frame_" .. name .. "Current"]
		local pctLabel 	= _G["FTC_" .. context .. "Frame_" .. name .. "Pct"]
		
		-- Update bar
		bar:SetWidth( ( pct / 100 ) * ( parent:GetWidth() - 2 ) )	
		curLabel:SetText( ( powerValue > 10000 ) and math.floor( ( powerValue + 500 ) / 1000 ) .. "k" or powerValue )
		pctLabel:SetText(pct .. "%")
		
		-- Configure visibility
		frame:SetHidden( IsReticleHidden() and not FTC.move )	
		local alpha = ((( powerType == POWERTYPE_HEALTH and pct == 100 )  or ( FTC.Player.health.pct == 100 )) and not IsUnitInCombat('player')) and ( FTC.vars.OpacityOut / 100 ) or ( FTC.vars.OpacityIn / 100 )
		frame:SetAlpha(alpha)
	end
	
	-- Update the default attribute bar
	if ( FTC.vars.FrameText ) then
		local default 	= ( context == "Player" ) and _G["FTC_DefaultPlayer"..name] or _G["FTC_DefaultTargetHealth"]
		default:SetText( powerValue .. " / " .. powerMax .. " (" .. pct .. "%)")
	end
	
	-- Update the database object
	FTC[context][string.lower(name)] = { ["current"] = powerValue , ["max"] = powerMax , ["pct"] = pct }
 end
 
 
--[[----------------------------------------------------------
	SHIELDS
 ]]-----------------------------------------------------------

 --[[ 
 * Update shield bars
 * Called by OnVisualAdded
 * Called by OnVisualUpdate
 * Called by OnVisualRemoved
 ]]--
function FTC.Frames:UpdateShield( unitTag , value , maxValue )

	-- Get the context
	local context 	= ( unitTag == 'player' ) and "Player" or "Target"
	local frame		= _G['FTC_'..context..'Frame']
	
	-- Get the unit's maximum health
	local maxHealth = ( unitTag == 'player' ) and FTC.Player.health.max or FTC.Target.health.max
	
	-- Get the shield bar
	local health	= frame.health
	local bar 		= frame.shield
	
	-- Change the bar width
	bar:SetWidth( math.min( ( value / maxHealth ) , 1 ) * ( health:GetWidth() - 4 ) )
	
	-- Update the database object
	FTC[context].shield = { ["current"] = value , ["max"] = maxValue , ["pct"] = math.floor( ( value / maxValue ) * 100 ) }
end


--[[----------------------------------------------------------
	EXPERIENCE
 ]]-----------------------------------------------------------

 --[[ 
 * Sets up and updates the mini experience bar
 * Called by SetupPlayer()
 ]]--
function FTC.Frames:SetupXP()

	-- Only update if the XP bar is shown
	local parent 	= _G["FTC_PlayerFrame_Alt"]
	if ( parent.context	~= "exp" ) then return end
	
	if ( FTC.vars.EnableXPBar and FTC.Player.vlevel < 14 ) then 

		-- Change the icon and color
		parent.icon:SetTexture("/esoui/art/inventory/inventory_tabicon_quest_down.dds")
		parent:SetCenterColor(0,0.1,0.1,1)
		parent.bar:SetColor(0,1,1,1)
	
		-- Get experience values
		local maxExp	= ( FTC.Player.level == 50 ) and GetUnitVeteranPointsMax('player') or GetUnitXPMax('player')
		local currExp	= ( FTC.Player.level == 50 ) and FTC.Player.vet or FTC.Player.exp
		local pct		= math.floor( 100 * ( currExp / maxExp ) )
		
		-- Setup the bar
		parent.bar:SetWidth( ( pct / 100 ) * ( parent:GetWidth() - 2 ) )
	end

	-- Maybe display the bar
	parent:SetHidden( not ( FTC.vars.EnableXPBar and FTC.Player.vlevel < 14 ) )		
end


--[[----------------------------------------------------------
	MOUNTS
 ]]-----------------------------------------------------------

--[[ 
 * Toggles display of the mount stamina bar
 * Called by OnMount()
 ]]--
function FTC.Frames:SetupMount( eventCode , mounted )
	
	-- Switch context to mount
	local parent 	= _G["FTC_PlayerFrame_Alt"]
	parent.context	= mounted and "mount" or "exp"
	
	-- If mounted, setup
	if mounted then 
	
		-- Change the icon and color
		parent.icon:SetTexture("/esoui/art/mounts/tabicon_mounts_down.dds")
		parent:SetCenterColor(0,0.1,0,1)
		parent.bar:SetColor(0,0.8,0,1)

		-- Fetch the current mount stamina level
		local current, maximum, effectiveMax = GetUnitPower( 'player' , POWERTYPE_MOUNT_STAMINA )
		parent.bar:SetWidth( ( current / effectiveMax ) * parent:GetWidth() - 2 )
	
		-- Ensure visibility
		parent:SetHidden(false)
	
	-- Otherwise show experience
	else
		FTC.Frames:SetupXP()
	end
end 
 
 --[[ 
 * Update the player's mount stamina bar
 * Called by OnPowerUpdate()
 ]]--
function FTC.Frames:UpdateMount( powerValue , powerMax , powerEffectiveMax )

	-- Get the alternate bar
	local parent 	= _G["FTC_PlayerFrame_Alt"]
	local bar		= parent.bar
	
	-- Bail if the bar is currently used for something else
	if ( parent.context ~= "mount" ) then return end
	
	-- Change the bar width
	bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( parent:GetWidth() - 2 ) )
end

--[[----------------------------------------------------------
	SIEGE
 ]]-----------------------------------------------------------
 function FTC.Frames:SetupSiege()

	-- Switch context to siege
	local parent 	= _G["FTC_PlayerFrame_Alt"]
	local isSiege	= ( IsPlayerControllingSiegeWeapon() or IsPlayerEscortingRam() )
	parent.context	= isSiege and "siege" or "exp"
	
	-- If sieging, setup
	if isSiege then 
	
		-- Change the icon and color
		parent.icon:SetTexture("/esoui/art/worldmap/map_ava_tabicon_resourcedefense_down.dds")
		parent:SetCenterColor(0.2,0,0,1)
		parent.bar:SetColor(0.8,0,0,1)

		-- Fetch the current mount stamina level
		local current, maximum, effectiveMax = GetUnitPower( 'controlledsiege' , POWERTYPE_HEALTH )
		parent.bar:SetWidth( ( current / effectiveMax ) * parent:GetWidth() - 2 )
	
		-- Ensure visibility
		parent:SetHidden(false)
	
	-- Otherwise show experience
	else
		FTC.Frames:SetupXP()
	end
	
 end
 
 function FTC.Frames:UpdateSiege( powerValue , powerMax , powerEffectiveMax )
 
	-- Get the alternate bar
	local parent 	= _G["FTC_PlayerFrame_Alt"]
	local bar		= parent.bar
	
	-- Bail if the bar is currently used for something else
	if ( parent.context ~= "siege" ) then return end
	
	-- Change the bar width
	bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( parent:GetWidth() - 2 ) )
end
 
 
 --[[----------------------------------------------------------
	WEREWOLF
 ]]-----------------------------------------------------------
 
 --[[ 
 * Toggles display of the mount stamina bar
 * Called by OnMount()
 ]]--
function FTC.Frames:SetupWerewolf( eventCode , isWerewolf )
	
	-- Switch context to mount
	local parent 	= _G["FTC_PlayerFrame_Alt"]
	parent.context	= isWerewolf and "werewolf" or "exp"
	
	-- If mounted, setup
	if isWerewolf then 
	
		-- Change the icon and color
		parent.icon:SetTexture("/esoui/art/inventory/inventory_tabicon_weapons_down.dds")
		parent:SetCenterColor(0.2,0,0,1)
		parent.bar:SetColor(0.8,0,0,1)

		-- Fetch the current mount stamina level
		local current, maximum, effectiveMax = GetUnitPower( 'player' , POWERTYPE_WEREWOLF )
		parent.bar:SetWidth( ( current / effectiveMax ) * parent:GetWidth() - 2 )
	
		-- Ensure visibility
		parent:SetHidden(false)
	
	-- Otherwise show experience
	else
		FTC.Frames:SetupXP()
	end
end 
 
 --[[ 
 * Update the player's mount stamina bar
 * Called by OnPowerUpdate()
 ]]--
function FTC.Frames:UpdateWerewolf( powerValue , powerMax , powerEffectiveMax )

	-- Get the alternate bar
	local parent 	= _G["FTC_PlayerFrame_Alt"]
	local bar		= parent.bar
	
	-- Bail if the bar is currently used for something else
	if ( parent.context ~= "werewolf" ) then return end
	
	-- Change the bar width
	bar:SetWidth( ( powerValue / powerEffectiveMax ) * ( parent:GetWidth() - 2 ) )
end
 

--[[----------------------------------------------------------
	ULTIMATE
 ]]-----------------------------------------------------------
 
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
	FTC_UltimateLevel:SetText( powerValue .. "/" .. cost )
	
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





--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------
 
 --[[ 
 * Set up the target frame every time the target changes.
 * Called by FTC:UpdateTarget()
 ]]--
 function FTC.Frames:SetupTarget()
					
	-- Load the target's health	
	local current, maximum, effectiveMax = GetUnitPower( 'reticleover' , POWERTYPE_HEALTH )
	FTC.Target.health = { ["current"] = current , ["max"] = maximum , ["pct"] = math.floor( current * 100 / maximum ) }
	FTC.Frames:UpdateAttribute( 'reticleover', POWERTYPE_HEALTH , current, maximum, effectiveMax )
	
	-- Populate custom frames
	if ( FTC.init.Frames ) then 
	
		-- Get the frame
		local frame		= _G['FTC_TargetFrame']
	
		-- Populate nameplate
		local name 		= FTC.Target.name
		local level 	= FTC.Target.vlevel > 0 and "v" .. FTC.Target.vlevel or FTC.Target.level
		frame.name:SetText( name .. " (" .. level .. ")" )
		local isPlayer	= IsUnitPlayer('reticleover')
		
		-- Populate the class icon
		local showIcon = isPlayer or ( GetUnitDifficulty('reticleover') > 1 )
		if ( IsUnitPlayer('reticleover') ) then frame.class:SetTexture( "/esoui/art/contacts/social_classicon_" .. FTC.Target.class .. ".dds" )
		elseif ( GetUnitDifficulty('reticleover') == 2) then frame.class:SetTexture( "/esoui/art/unitframes/target_veteranrank_icon.dds" ) 
		elseif ( GetUnitDifficulty('reticleover') >= 3 ) then frame.class:SetTexture( "/esoui/art/lfg/lfg_veterandungeon_down.dds" ) end
		frame.class:SetHidden( not showIcon )
		
		-- Populate title
		local title		= GetUnitCaption( 'reticleover' )
		if ( isPlayer ) then
			title		= GetUnitTitle( 'reticleover' ) == "" and GetAvARankName( GetUnitGender('reticleover') , GetUnitAvARank('reticleover') ) or GetUnitTitle( 'reticleover' )
		end
		if ( title ~= nil ) then title = SanitizeLocalization(title) end
		frame.title:SetText(title)
		
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
end

 --[[ 
 * Set up the player frame, loading the name and level
 * Called by Initialize()
 * Called by OnXPUpdate()
 * Called by OnVPUpdate()
 ]]--
function FTC.Frames:SetupPlayer()

	-- Setup custom frames
	if ( FTC.init.Frames ) then
	
		-- Reset the player name/level
		if ( FTC.vars.EnableNameplate ) then
			local name 		= FTC.Player.name
			local level 	= FTC.Player.vlevel > 0 and "v" .. FTC.Player.vlevel or FTC.Player.level
			FTC_PlayerFrame_Name:SetText( name .. " (" .. level .. ")" )
		end
		FTC_PlayerFrame_Plate:SetHidden( not FTC.vars.EnableNameplate )
		
		-- Mini experience bar
		FTC.Frames:SetupXP()
	end
	
	-- Populate attribute levels
	FTC.Frames:UpdateAttribute( 'player', POWERTYPE_HEALTH,		FTC.Player.health.current, 	FTC.Player.health.max,	FTC.Player.health.max )
	FTC.Frames:UpdateAttribute( 'player', POWERTYPE_MAGICKA, 	FTC.Player.magicka.current, FTC.Player.magicka.max, FTC.Player.magicka.max )
	FTC.Frames:UpdateAttribute( 'player', POWERTYPE_STAMINA, 	FTC.Player.stamina.current, FTC.Player.stamina.max, FTC.Player.stamina.max )
	
	-- Populate ultimate level
	if ( FTC.init.Ultimate ) then
		FTC.Frames:UpdateUltimate( FTC.Player.ultimate.current	, FTC.Player.ultimate.max , FTC.Player.ultimate.max )
	end
end




