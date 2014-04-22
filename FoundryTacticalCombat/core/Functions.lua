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
 * A buffering function useful for remembering the last time an OnUpdate script ran
 * Minimizes the number of cycles needed for updating if a refresh is not required every frame
 ]]-- 
FTC.buffers = {}
function FTC.BufferScript( bufferKey , bufferTime )
	
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
function FTC:ToggleVisibility( eventCode , isHidden )

	-- Are we in move mode?
	if( FTC.move ) then isHidden = false end
	
	-- Hide unit frames
	if( FTC.init.Frames ) then		
		FTC_PlayerFrame:SetHidden( isHidden )
		if ( isHidden ) then FTC_TargetFrame:SetHidden( true ) end
	end
	
	-- Hide SCT elements
	if( FTC.init.SCT) then
		FTC_CombatTextOut:SetHidden( isHidden )
		FTC_CombatTextIn:SetHidden( isHidden )
	end
	
	-- Hide buff elements
	if( FTC.init.Buffs ) then
		FTC_PlayerBuffs:SetHidden( isHidden )
		FTC_PlayerDebuffs:SetHidden( isHidden )
		FTC_TargetBuffs:SetHidden( isHidden )
		FTC_TargetDebuffs:SetHidden( isHidden )
		if ( FTC.vars.EnableLongBuffs ) then FTC_LongBuffs:SetHidden( isHidden ) end
	end
	
	-- Hide damage elements
	if ( FTC.init.Damage ) then
		FTC_MiniMeter:SetHidden( isHidden )
		FTC_Meter:SetHidden( true )
	end
end

--[[ 
 * Updates the player's target, and initializes several component specific actions.
 * Called by OnTargetChanged()
 ]]--
function FTC:UpdateTarget()

	-- Maybe hide the default frame
	if ( FTC.init.Frames and FTC.vars.DisableTargetFrame ) then
		ZO_TargetUnitFramereticleover:SetHidden(true)
	end
		
	-- Get the reticle target
	local target = GetUnitName('reticleover')
	
	-- Ignore blank targets
	local ignore = ( target == "" )
	
	-- We also want to ignore critters
	if FTC:IsCritter( target ) then ignore = true end
	
	-- Maybe display the target frames for move mode
	if( FTC.init.Frames and FTC.move ) then ignore = false end
	
	-- Update display of target buffs
	if( FTC.init.Buffs ) then 		
	
		-- Update target buffs
		if ( not ignore ) then FTC.Buffs:GetBuffs( 'reticleover' ) end
		
		-- Toggle visibility of target buffs
		FTC_TargetBuffs:SetHidden( ignore )
	end
	
	-- Update target data and configure frame
	if ( not ignore ) then 
		FTC.Target:Update() 
		FTC.Frames.SetupTarget()
	end

	-- Toggle visibility
	if ( FTC.init.Frames ) then	FTC_TargetFrame:SetHidden( ignore ) end
	FTC_DefaultTargetHealth:SetHidden(ignore)
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