
 --[[----------------------------------------------------------
	MENU FUNCTIONS
	-----------------------------------------------------------
	* Initializes and handles menu actions
	* Runs last in the initialization order
  ]]--

FTC.Menu = {
			["name"] 	= "FTC_SettingsPanel",
			["title"] 	= "FTC Settings",
			}

LAM = LibStub("LibAddonMenu-1.0")		
function FTC.Menu.Initialize()

	-- Register the options panel
	FTC.Menu.id = LAM:CreateControlPanel( FTC.Menu.name , FTC.Menu.title )
	
	-- Setup menu controls
	FTC.Menu:Controls()
	
end


--[[ 
 * Toggles current setting for a variable
 * Called by elements created in FTC.Menu:Controls()
 ]]-- 
function FTC.Menu:Toggle( setting , reload )
	
	-- Update the database
	FTC.vars[setting] = not FTC.vars[setting]
	
	-- Maybe reload
	if reload then ReloadUI() end
end


--[[ 
 * Toggles current setting for a variable
 * Called by elements created in FTC.Menu:Controls()
 ]]-- 
function FTC.Menu:Slider( setting , value )
	FTC.vars[setting] = value
end

--[[ 
 * Toggles movability of unit frames
 * Called by elements created in FTC.Menu:Controls()
 ]]--
function FTC.Menu:MoveFrames()

	-- Get the current move status
	local move = not FTC.Frames.move
	
	-- Display everything
	FTC_PlayerFrame:SetHidden( false )
	FTC_TargetFrame:SetHidden( false )
	
	-- Toggle mousing
	FTC_PlayerFrame:SetMouseEnabled( move )
	FTC_PlayerFrame:SetMovable( move )
	FTC_TargetFrame:SetMouseEnabled( move )
	FTC_TargetFrame:SetMovable( move )

	-- Toggle the move status
	FTC.Frames.move = move
	
	-- Display a message
	local message = move and "Unit frames are now movable, drag them to re-position!" or "Unit frames are now locked!"
end


--[[ 
 * Saves the position of an element to vars
 * Called by OnMouseUp() for various controls
 ]]--
function FTC.Menu:SaveAnchor( control )
	
	-- Get the new position
	local controlX , controlY = control:GetCenter()
	local rootX , rootY = GuiRoot:GetCenter()
	local offsetX = controlX - rootX
	local offsetY = controlY - rootY
	
	-- Save the anchors
	FTC.vars[control:GetName() .. "_X"] = offsetX
	FTC.vars[control:GetName() .. "_Y"] = offsetY
end



--[[ 
 * Saves the position of an element to vars
 * Called by OnMouseUp() for various controls
 ]]--
function FTC.Menu:Reset()
	
	-- Get the defaults
	local defaults = FTC.defaults
	
	-- Reset the vars
	for var , value in pairs( defaults ) do
		FTC.vars[var] = value	
	end
		
	-- Reload UI
	ReloadUI()
end