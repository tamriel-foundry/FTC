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
	if not FTC.buffers[bufferKey] then FTC.buffers[bufferKey] = ct end
	if ( ct - FTC.buffers[bufferKey] >= bufferTime ) then
		FTC.buffers[bufferKey] = ct
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

	-- If we are in "movemode" don't hide windows so the player can drag them
	if( FTC.movemode ) then
		FTC_TargetFrame:SetHidden( false )
		if ( isHidden ) then return end
	end
	
	-- Otherwise, hide FTC windows
	FTC_CharSheet:SetHidden( ( FTC_CharSheet:IsHidden() == true ) and true or isHidden )
	
	if( FTC.Frames.init ) then
		FTC_PlayerFrame:SetHidden( isHidden )
	end
	
	if( FTC.init.SCT) then
		FTC_CombatTextOut:SetHidden( isHidden )
		FTC_CombatTextIn:SetHidden( isHidden )
	end
	
	if( FTC.init.Buffs) then
		FTC_PlayerBuffs:SetHidden( isHidden )
		FTC_TargetBuffs:SetHidden( isHidden )
	end

end

--[[ 
 * Updates the player's target, and initializes several component specific actions.
 * Called by OnTargetChanged()
 ]]--
function FTC:UpdateTarget()

	-- Get the reticle target
	local target = GetUnitName('reticleover')
	
	-- Ignore blank targets
	local ignore = ( target == "" )
	
	-- We also want to ignore critters
	if FTC:IsCritter( target ) then ignore = true end
	
	-- Conditionally display the target frame
	if( FTC.Frames.init ) then 
		FTC_TargetFrame:SetHidden( ignore )
	end
	if( FTC.init.Buffs ) then
		FTC_TargetBuffs:SetHidden( ignore )
		FTC_TargetDebuffs:SetHidden( ignore )
	end
	if ( ignore ) then return end
	
	-- Update the saved target
	FTC.target.name		= target
	FTC.target.class	= GetUnitClass('reticleover')
	FTC.target.level	= GetUnitLevel('reticleover')
	FTC.target.vlevel	= GetUnitVeteranRank('reticleover')	
	
	-- Setup the new target frame
	FTC.Frames.SetupTarget()
	
	-- Get new target buffs
	if ( FTC.vars.EnableBuffs ) then
		FTC.TargetBuffs	= {}
		FTC.ClearBuffIcons(	'Target', 1 , 1 , 1 )
		FTC.Buffs:GetBuffs( 'reticleover' )
	end
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
	}
	
	-- Is the target a critter?
	for i = 1, #critters do
		if ( targetName == critters[i] ) then return true end
	end
	
	-- Otherwise false
	return false
end