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
	 * Handle Special Visibility Neds
	 * --------------------------------
	 * Called by FTC.OnLayerChange()
	 * --------------------------------
	 ]]--  
	function FTC:ToggleVisibility( activeLayerIndex )

		-- We only need to act if it's in move mode
		if not FTC.move then return end

		-- Maybe get action layer
		activeLayerIndex = activeLayerIndex or GetNumActiveActionLayers()

		-- Maybe disable move mode
		if ( activeLayerIndex > 2 ) then FTC.Menu:MoveFrames( false ) end
	end


	 --[[ 
	 * Return Comma Delimited Number
	 * --------------------------------
	 * Called by ... 
	 * --------------------------------
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
