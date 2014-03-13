--[[----------------------------------------------------------
	HEADS UP DISPLAY COMPONENT
 ]]-----------------------------------------------------------
function FTC.InitializeHUD()

	-- Create custom frames, regardless of whether or not we are using them
	local frames = { "Player" , "Target" }
	for f = 1 , #frames , 1 do
	
		-- Get the saved frame positions
		local offsetx 	= ( frames[f] == "Player" ) and -400 or 400
		offsetx			= ( FTC.vars[frames[f].."FrameX"] ~= 0 ) and FTC.vars[frames[f].."FrameX"] or offsetx
		local offsety 	= ( FTC.vars[frames[f].."FrameY"] ~= 0 ) and FTC.vars[frames[f].."FrameY"] or 300
		
		-- Create the unit frame container	
		local frame 	= FTC.UI.TopLevelWindow( "FTC_" .. frames[f] .. "Frame" , GuiRoot , {250,75} , {TOP,CENTER,offsetx,offsety} , false )	
		frame.backdrop	= FTC.UI.Backdrop( "FTC_" .. frames[f] .. "FrameBackdrop" , frame , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )	
		frame.name 		= FTC.UI.Label( "FTC_" .. frames[f] .. "FrameName" , frame , { frame:GetWidth() * 0.5 , 20 } , {BOTTOMLEFT,TOPLEFT,0,0} , "ZoFontAnnounceSmall" , nil , {0,1} , false )		
		frame.level 	= FTC.UI.Label( "FTC_" .. frames[f] .. "FrameLevel" , frame , { frame:GetWidth() * 0.5 , 20 } , {BOTTOMRIGHT,TOPRIGHT,0,0} , "ZoFontAnnounceSmall" , nil , {2,1} , false )
		
		-- Make the frame useable
		frame:SetMouseEnabled(false)
		frame:SetMovable(true)
		frame:SetHandler( "OnMouseUp" , function(self) FTC.MoveFrame(self) end )
		
		-- Create attribute bars
		local parent 	= frame
		local stats 	= { 'Health' , 'Magicka' , 'Stamina' }
		for i = 1 , #stats , 1 do
			
			-- Create each bar
			local stat 		= FTC.UI.Control( "FTC_" .. frames[f] .. "Frame" .. stats[i] , frame , {frame:GetWidth()-8,20} , {TOP,BOTTOM,0,3,parent} , false )	
			local bar		= FTC.UI.Backdrop( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Bar" , stat , "inherit" , {LEFT,LEFT,0,0} , {0.2,0,0,0.6} , {0,0,0,0.8} , false )	
			local current	= FTC.UI.Label( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Min" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontBoss" , nil , {frames[f] == "Player" and 0 or 2,1} , false )		
			local pct		= FTC.UI.Label( "FTC_" .. frames[f] .. "Frame" .. stats[i] .. "Pct" , stat , { stat:GetWidth() - 10 , stat:GetHeight() } , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {frames[f] == "Player" and 2 or 0,1} , false )	
			
			-- Adjust the positioning of the first bar
			if ( i == 1 ) then stat:SetAnchor(TOP,parent,TOP,0,4) end	
			parent = stat
		end	
	end
	
	-- Create labels for the default frame
	local stats		= { "Health" , "Stamina" , "Magicka" }
	for  i = 1 , #stats , 1 do
		local parent	= _G["ZO_PlayerAttribute"..stats[i]]
		local label		= FTC.UI.Label( "FTC_DefaultPlayer"..stats[i] , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,-1} , "ZoFontAnnounceSmall" , nil , {1,1} , false )
	end
	local parent		= _G["ZO_TargetUnitFramereticleover"]
	local label			= FTC.UI.Label( "FTC_DefaultTargetHealth" , parent , { parent:GetWidth() , 20 } , {CENTER,CENTER,0,-1} , "ZoFontAnnounceSmall" , nil , {1,1} , false )
	
	-- Populate some information to the player frame
	FTC_PlayerFrameName:SetText(FTC.character.name)
	FTC_PlayerFrameLevel:SetText(FTC.character.level < 50 and FTC.character.class .. "  " .. FTC.character.level or FTC.character.class .. "  v" .. FTC.character.vlevel)
	
	-- Hide the target frame
	FTC_TargetFrame:SetHidden(true)
	
	-- Create ultimate tracker
	local ultimate = FTC.UI.Label( "FTC_UltimateTracker" , ActionButton8 , 'inherit' , {CENTER,CENTER,0,0} , "ZoFontAnnounceSmall" , nil , {1,1} , false )
	
	-- Register Event Listeners
	EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_POWER_UPDATE , FTC.UpdateUnitFrame )
		
	-- Populate the unit frames
	FTC.UpdateUnitFrame( nil , 'player', nil, POWERTYPE_HEALTH, FTC.character.health.current, FTC.character.health.max, FTC.character.health.max )
	FTC.UpdateUnitFrame( nil , 'player', nil, POWERTYPE_MAGICKA, FTC.character.magicka.current, FTC.character.magicka.max, FTC.character.magicka.max )
	FTC.UpdateUnitFrame( nil , 'player', nil, POWERTYPE_STAMINA, FTC.character.stamina.current, FTC.character.stamina.max, FTC.character.stamina.max )
	FTC.UpdateUnitFrame( nil , 'player', nil, POWERTYPE_ULTIMATE, 0, 0, 0 )
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]----------------------------------------------------------- 
 function FTC.UpdateUnitFrame( eventCode , unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )

 	-- Get the context
	if ( unitTag == 'player' ) then context = "Player"
	elseif ( unitTag == 'reticleover' ) then context = "Target"
	else return end
	
	-- Pass Health, Stamina, and Magicka to frames
	if ( powerType == POWERTYPE_HEALTH or powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) then
	
		-- If custom frames are disabled, bail if it's target magicka or target stamina
		if ( FTC.vars.enableHUD == false and context == "Target" and ( powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) ) then return end
	
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
		local prior = ( context == "Player" ) and FTC.character[string.lower(attr.name)].pct or FTC.target[string.lower(attr.name)].pct
		if ( FTC.init.SCT and prior > 25 and pct < 25 ) then
			
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
			for i = 1 , #FTC.SCTStat , 1 do
				if ( FTC.SCTStat[i].type == aType ) then ignore = true end
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
				table.insert( FTC.SCTStat, newSCT )	
			end
		end

		-- Update the attribute bar
		local parent	= _G["FTC_" .. context .. "Frame" .. attr.name]
		local bar		= _G["FTC_" .. context .. "Frame" .. attr.name .. "Bar"]
		local minLabel 	= _G["FTC_" .. context .. "Frame" .. attr.name .. "Min"]
		local maxLabel 	= _G["FTC_" .. context .. "Frame" .. attr.name .. "Max"]
		local pctLabel 	= _G["FTC_" .. context .. "Frame" .. attr.name .. "Pct"]
		
		-- Get the default attribute bar
		local default 	= ""
		if ( context == "Player" ) then
			default		= _G["FTC_DefaultPlayer"..attr.name]
		else
			default		= _G["FTC_DefaultTargetHealth"]
		end
			
		-- Update bar
		local red 	= attr.red * ( 5 - ( pct / 25 ) )
		local green = attr.green * ( 5 - ( pct / 25 ) ) 
		local blue	= attr.blue * ( 5 - ( pct / 25 ) ) 
		bar:SetWidth( ( pct / 100 ) * parent:GetWidth() )
		bar:SetCenterColor( red , green , blue , 0.5 )
		
		-- Update labels
		minLabel:SetText( ( powerValue > 10000 ) and math.floor( ( powerValue + 500 ) / 1000 ) .. "k" or powerValue  )
		pctLabel:SetText(pct .. "%")
		default:SetText( powerValue .. " / " .. powerEffectiveMax .. " (" .. pct .. "%)")
		
		-- Toggle opacity
		local isFull = (( powerType == POWERTYPE_HEALTH and pct == 100 )  or ( FTC.character.health.pct == 100 )) and not IsUnitInCombat('player')
		if ( isFull ) then 
			frame:SetAlpha(0.5)
		else 
			frame:SetAlpha(1)
		end
		
		-- Ensure the default unit frames remain hidden
		if ( FTC.vars.EnableHUD ) then
			ZO_PlayerAttribute:SetHidden(true)
		else
			frame:SetHidden(true)
		end
		
		-- Update character data
		FTC.character[string.lower(attr.name)] = { ["current"] = powerValue , ["max"] = powerEffectiveMax , ["pct"] = pct }
		
	
	-- Otherwise track ultimate gain
	elseif ( powerType == POWERTYPE_ULTIMATE ) then
	
		-- Get the ability button
		parent = _G["ActionButton8"]
		
		-- Get the currently slotted ultimate cost
		cost, mechType = GetSlotAbilityCost(8)
		
		-- Calculate the percentage to activation
		local pct = ( cost > 0 ) and math.floor( ( powerValue / cost ) * 100 ) or 0
		
		-- Create a tooltip
		FTC_UltimateTracker:SetText( powerValue .. "\r\n" .. pct .. "%")	
	end
 end
 
 
 function FTC.SetupTargetFrame()
	
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
			FTC.target[stats[i].name] = { ["current"] = current , ["max"] = effectiveMax , ["pct"] = math.floor( current * 100 / effectiveMax ) }
			FTC.UpdateUnitFrame( nil , 'reticleover', nil, stats[i].id, current, maximum, effectiveMax )
		end
	end
	
	-- Resize the unit frame appropriately
	FTC_TargetFrameMagicka:SetHidden( not isPlayer )
	FTC_TargetFrameStamina:SetHidden( not isPlayer )
	FTC_TargetFrame:SetHeight( isPlayer and 75 or 28 )
	FTC_TargetFrameBackdrop:SetHeight( isPlayer and 75 or 28 )
	
	-- Populate the frame nameplate
	local name = FTC.target.name .. " "
	if( not isPlayer ) then 
		local diff = math.max( GetUnitDifficulty('reticleover') - 1 , 0 ) 
		for i = 1 , diff do name = name .. "*" end
		FTC.target.class = ( GetUnitCaption('reticleover') ~= nil ) and GetUnitCaption('reticleover') or ""
	end
	FTC_TargetFrameName:SetText(name)
	FTC_TargetFrameLevel:SetText(FTC.target.vlevel > 0 and FTC.target.class .. "  v" .. FTC.target.vlevel or FTC.target.class .. "  " .. FTC.target.level)
end



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