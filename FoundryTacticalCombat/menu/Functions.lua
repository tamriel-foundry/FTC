
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

local LAM = LibStub("LibAddonMenu-1.0")		
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
	
	-- Re-configure some things
	if ( FTC.init.Frames ) then FTC.Frames:SetupPlayer() end
	
	-- Maybe reload
	if reload then ReloadUI() end
end


--[[ 
 * Toggles current setting for a variable
 * Called by elements created in FTC.Menu:Controls()
 ]]-- 
function FTC.Menu:Update( setting , value , reload )
	FTC.vars[setting] = value
	
	-- Maybe reload
	if reload then ReloadUI() end
end

--[[ 
 * Toggles movability of unit frames
 * Called by elements created in FTC.Menu:Controls()
 ]]--
function FTC.Menu:MoveFrames()

	-- Get the current move status
	local move = not FTC.move
	
	-- Display frames
	if ( FTC.init.Frames ) then
		FTC_PlayerFrame:SetHidden( false )
		FTC_PlayerFrame:SetMouseEnabled( move )
		FTC_PlayerFrame:SetMovable( move )
		
		FTC_TargetFrame:SetHidden( not move )
		FTC_TargetFrame:SetMouseEnabled( move )
		FTC_TargetFrame:SetMovable( move )
	end
	
	-- Display buffs
	if ( FTC.init.Buffs ) then
		FTC_PlayerBuffsBackdrop:SetHidden( not move )
		FTC_PlayerBuffsLabel:SetHidden( not move )
		
		FTC_PlayerDebuffsBackdrop:SetHidden( not move )
		FTC_PlayerDebuffsLabel:SetHidden( not move )
	
		FTC_TargetBuffsBackdrop:SetHidden( not move )
		FTC_TargetBuffsLabel:SetHidden( not move )
		
		FTC_TargetDebuffsBackdrop:SetHidden( not move )
		FTC_TargetDebuffsLabel:SetHidden( not move )
	
		FTC_LongBuffs:SetHidden( false )
		FTC_LongBuffs:SetMouseEnabled( move )
		FTC_LongBuffs:SetMovable( move )
		
		if ( not FTC.vars.AnchorBuffs ) then
			FTC_PlayerBuffs:SetMouseEnabled( move )
			FTC_PlayerBuffs:SetMovable( move )		
			FTC_PlayerDebuffs:SetMouseEnabled( move )
			FTC_PlayerDebuffs:SetMovable( move )
		
			FTC_TargetBuffs:SetMouseEnabled( move )
			FTC_TargetBuffs:SetMovable( move )
			FTC_TargetDebuffs:SetMouseEnabled( move )
			FTC_TargetDebuffs:SetMovable( move )
		end
	end
	
	-- Display SCT
	if ( FTC.init.SCT ) then
		FTC_CombatTextOut:SetHidden(false)
		FTC_CombatTextOut:SetMouseEnabled( move )
		FTC_CombatTextOut:SetMovable( move )
		FTC_CombatTextOut_Backdrop:SetHidden( not move )
		FTC_CombatTextOut_Label:SetHidden( not move )

		FTC_CombatTextIn:SetHidden(false)
		FTC_CombatTextIn:SetMouseEnabled( move )
		FTC_CombatTextIn:SetMovable( move )		
		FTC_CombatTextIn_Backdrop:SetHidden( not move )
		FTC_CombatTextIn_Label:SetHidden( not move )	

		FTC_CombatTextStatus:SetHidden(false)		
		FTC_CombatTextStatus:SetMouseEnabled( move )
		FTC_CombatTextStatus:SetMovable( move )
		FTC_CombatTextStatus_Backdrop:SetHidden( not move )
		FTC_CombatTextStatus_Label:SetHidden( not move )	
	end
	
	-- Toggle the move status
	FTC.move = move
	
	-- Display a message
	local message = move and "FTC frames are now movable, drag them to re-position!" or "FTC frames are now locked!"
end

--[[ 
 * Saves the position of an element to vars
 * Called by OnMouseUp() for various controls
 ]]--
function FTC.Menu:SaveAnchor( control )
	
	-- Get the new position
	local isValidAnchor, point, relativeTo, relativePoint, offsetX, offsetY = control:GetAnchor()
	
	-- Save the anchors
	if ( isValidAnchor ) then
		FTC.vars[control:GetName()] = {point,relativePoint,offsetX,offsetY}
	end
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