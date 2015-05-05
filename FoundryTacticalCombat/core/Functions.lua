--[[----------------------------------------------------------
	FTC CORE FUNCTIONS
	----------------------------------------------------------
	* A collection of handy functions that are used throughout the addon.
	* These functions are often prerequisite to the working of other components.
  ]]--
  
  
 --[[ 
 * A handy chaining function for quickly setting up UI elements
 * Allows us to reference methods to set properties without calling the specific object
 ]]-- 
function FTC.Chain( object )
	
	-- Setup the metatable
	local T = {}
	setmetatable( T , { __index = function( self , func )
		
		-- Know when to stop chaining
		if func == "__END" then	return object end
		
		-- Otherwise, add the method to the parent object
		return function( self , ... )
			assert( object[func] , func .. " missing in object" )
			object[func]( object , ... )
			return self
		end
	end })
	
	-- Return the metatable
	return T
end

 --[[ 
 * Simple function for appending two tables together
 ]]-- 
function FTC.JoinTables(t1,t2)
	for k,v in pairs(t2) do t1[k]=v end
	return t1
end

 --[[ 
 * A buffering function useful for remembering the last time an OnUpdate script ran
 * Minimizes the number of cycles needed for updating if a refresh is not required every frame
 ]]-- 
FTC.buffers = {}
function FTC:BufferScript( bufferKey , bufferTime )
	
	-- Make sure a function is passed and exists
	if not bufferKey then return end
	
	-- Set a default buffer threshold
	bufferTime = bufferTime or 3
	
	-- Get the current time	
	local currentTime = GetFrameTimeMilliseconds()
	
	-- Check the buffer table to make sure the function is eligible
	if not FTC.buffers[bufferKey] then FTC.buffers[bufferKey] = currentTime end
	if ( currentTime - FTC.buffers[bufferKey] >= bufferTime ) then
		FTC.buffers[bufferKey] = currentTime
		return true
	else
		return false
	end
end


 --[[ 
 * Toggles the visibility of add-on elements
 * Called by OnReticleHidden()
 ]]-- 
function FTC:ToggleVisibility( activeLayerIndex )

	-- Maybe get action layer
	activeLayerIndex = activeLayerIndex or GetNumActiveActionLayers()

	-- Are we in move mode?
	local hidden = activeLayerIndex > 2 and not FTC.move and not FTC.inMenu
	
	-- Hide the FTC_UI Layer
	FTC_UI:SetHidden(hidden)

	-- Hide SCT elements
	if( FTC.init.SCT) then
		FTC_CombatTextOut:SetHidden( isHidden )
		FTC_CombatTextIn:SetHidden( isHidden )
	end
	
	--[[ Hide buff elements
	if( FTC.init.Buffs ) then
		FTC_PlayerBuffs:SetHidden( isHidden )
		FTC_PlayerDebuffs:SetHidden( isHidden )
		FTC_TargetBuffs:SetHidden( isHidden )
		FTC_TargetDebuffs:SetHidden( isHidden )
		if ( FTC.Vars.EnableLongBuffs ) then FTC_LongBuffs:SetHidden( isHidden ) end
	end
	]]--
end

--[[ 
 * Updates the player's target, and initializes several component specific actions.
 * Called by OnTargetChanged()
 ]]--
function FTC:UpdateTarget()
	
	-- Maybe hide the default frame
	if ( FTC.init.Frames and not FTC.Vars.DefaultTargetFrame ) then ZO_TargetUnitFramereticleover:SetHidden(true) end
		
	-- Get the reticle target
	local target = GetUnitName('reticleover')
	
	-- Ignore blank targets
	local ignore = ( target == "" )
	
	-- We also want to ignore critters
	if FTC:IsCritter( target ) then ignore = true end
	
	-- Maybe display the target frames for move mode
	if( FTC.init.Frames and FTC.move ) then ignore = false end
	
	--[[ Update display of target buffs
	if( FTC.init.Buffs ) then 		
		if ( not ignore ) then FTC.Buffs:GetBuffs( 'reticleover' ) end
		FTC_TargetBuffs:SetHidden( ignore )
	end
	]]--
	
	-- Update target data and configure frame
	if ( not ignore ) then 
		FTC.Target:Update() 
		FTC.Frames:SetupTarget()
	end

	-- Toggle frame visibility
	if ( FTC.init.Frames ) then	FTC_TargetFrame:SetHidden( ignore ) end
end


--[[ 
 * Filters valid targets by removing known "critters"
 * Called by UpdateTarget()
 ]]--
function FTC:IsCritter( targetName )

	-- Critters are always level 1
	if ( GetUnitLevel('reticleover') ~= 1 ) then return false end

	-- The list of critters
	local critters = { 
		"Butterfly",
		"Lizard",
		"Rat",
		"Snake",
		"Pony Guar",
		"Frog",
		"Squirrel",
		"Rabbit",
		"Deer",
		"Cat",
		"Pig",
		"Sheep",
		"Antelope",
		"Wasp",
		"Monkey",
		"Fleshflies",
		"Centipede",
		"Chicken",
		"Torchbug",
		"Spider",
		"Scorpion",
		"Goat",
		"Scrib",
		"Scuttler",
		"Fox",
	}
	
	-- Is the target a critter?
	for i = 1, #critters do
		if ( targetName == critters[i] ) then return true end
	end
	
	-- Otherwise false
	return false
end

--[[ 
 * Returns a formatted number with commas
 ]]--
function CommaValue(number)
	local left,num,right = string.match(number,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

--[[ 
 * Sanitizes a localized string, removing characters like ^m
 ]]--
function SanitizeLocalization( localString )
	if ( localString == nil ) then return "" end
	local a,b = string.find( localString , "%^" )
	return ( a ~= nil ) and string.sub( localString , 1 , a - 1 ) or ""
end