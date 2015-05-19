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
function FTC:JoinTables(t1,t2)
	local t1 = t1 or {}
	local t2 = t2 or {}
	for k,v in pairs(t2) do t1[k]=v end
	return t1
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

	-- If we were leaving move mode
	if ( FTC.move and activeLayerIndex > 2 ) then FTC.Menu:MoveFrames() end
	--d(activeLayerIndex)
	
	-- Hide the FTC_UI Layer
	FTC_UI:SetHidden(hidden)
end

--[[ 
 * Returns a formatted number with commas
 ]]--
function CommaValue(number)
	local left,num,right = string.match(number,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

--[[ 
 * Slash Function
 * --------------------------------
 * Triggered by /ftc or /FTC
 * --------------------------------
 ]]--  
function FTC:Slash( text )
    LAM2:OpenToPanel(FTC_Menu)
end
