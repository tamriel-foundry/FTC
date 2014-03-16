--[[----------------------------------------------------------
	SETTINGS COMPONENT
 ]]-----------------------------------------------------------	
function FTC.InitializeSettings()

	-- Initialize the settings
	FTC.settings 	= {
		['Buffs'] = {
			["name"]	= "Active Buff Tracking",
			["status"]	= FTC.vars.EnableBuffs },
		['Castbar'] = {
			["name"]	= "Enemy Cast-Bar",
			["status"]	= FTC.vars.EnableCastbar },
		['SCT'] = {
			["name"]	= "Scrolling Combat Text",
			["status"]	= FTC.vars.EnableSCT,
			["settings"] = {
				["SCTSpeed"]	= { 
					["name"]	= "Scroll Speed",
					["status"]	= FTC.vars.SCTSpeed },
				["SCTMaxLabels"]= {
					["name"]	= "Max Label",
					["status"]	= FTC.vars.SCTMaxLabels },
				["SCTMaxLifespan"] = {
					["name"]	= "Max Label Lifespan",
					["status"]	= FTC.vars.SCTMaxLifespan },
				["SCTNames"]	= { 
					["name"]	= "Display Ability Names",
					["status"]	= FTC.vars.SCTNames },
				["SCTContextsEnabled"] = {
					["name"]	= "Show Damage Types",
					["status"]	= FTC.vars.SCTContextsEnabled },
				["SCTAnimation"] = {
					["name"]	= "Animation",
					["status"]	= FTC.vars.SCTAnimation }
				}
			},
		['HUD'] = {
			["name"]		= "Heads Up Display",
			["status"]		= FTC.vars.EnableFrames
		}
	}
	
	-- Create settings container
	local SW 	= FTC.UI.TopLevelWindow( "FTC_Settings" 	, GuiRoot , {500,800} , {CENTER,CENTER,0,0} , true )	
	SW.backdrop = FTC.UI.Backdrop( "FTC_SettingsBackdrop" 	, SW , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
	SW.title 	= FTC.UI.Label( "FTC_SettingsTitle" 		, SW , {SW:GetWidth() - 100 , 25} , {TOP,TOP,0,10} , "ZoFontWindowTitle" , nil , {1,0} , "FTC Version " .. string.format( "%.2f" , FTC.version ) , false )
	
	--[[----------------------------------------------------------
		Mod Components Section
	]]------------------------------------------------------------
	SW.components 			= FTC.UI.Control( "FTC_Settings_Components" , SW , {SW:GetWidth() - 100 , 160} , {TOPLEFT,BOTTOMLEFT,0,20,SW.title} , false )
	SW.components.header 	= FTC.UI.Label( "FTC_Settings_ComponentsHeader" , SW.components , {SW.components:GetWidth() , 30} , {TOP,TOP,0,0} , "ZoFontHeader2" , nil , {0,1} , "Enable/Disable Components" , false )
	
	-- Component labels
	SW.components.labels = {}
	local anchor = SW.components.header
	for k,v in pairs(FTC.settings) do
		SW.components.labels[k]	= FTC.UI.Label( "FTC_Settings_Component"..k	, SW.components , {SW.components:GetWidth() * 0.6 , 30 } , {TOPLEFT,BOTTOMLEFT,0,0,anchor} , "ZoFontGame" , nil , {0,1} , v['name'] , false )
		anchor = SW.components.labels[k]
	end
	
	-- Component buttons
	local offset = 1
	SW.components.buttons = {}
	local anchor = SW.components.header
	for k,v in pairs(FTC.settings) do
		SW.components.buttons[k] = FTC.UI.Button( "FTC_Settings_Toggle"..k , SW.components , {SW.components:GetWidth()*0.4,30} , {TOPRIGHT,BOTTOMRIGHT,0,0,anchor} , BSTATE_NORMAL , "ZoFontGame" , {2,1} , {0.6,0,0,1} , {0,0.6,0,1} , {0.8,0.4,0,1} , false )
		SW.components.buttons[k]:SetHandler("OnClicked",function(self) FTC.ToggleComponent(self,k) end )
		SW.components.buttons[k]:SetText("Disabled")
				
		-- Retrieve the component status
		if ( FTC.vars["Enable"..k] ) then
			SW.components.buttons[k]:SetText( 'Enabled' )
			SW.components.buttons[k]:SetState( BSTATE_PRESSED )
		end
		
		-- Reset the parent
		anchor = SW.components.buttons[k]
	end
	
	--[[----------------------------------------------------------
		Scrolling Combat Text Section
	]]-----------------------------------------------------------
	SW.SCT = FTC.UI.Control( "FTC_Settings_SCT" , SW , {SW:GetWidth() - 100 , FTC.SCT.init and 250 or 0} , {TOPLEFT,BOTTOMLEFT,0,10,SW.components} , false )
	if ( FTC.SCT.init ) then
		SW.SCT.header 	= FTC.UI.Label( "FTC_Settings_SCTHeader" , SW.SCT , {SW.SCT:GetWidth() , 30} , {TOP,TOP,0,0} , "ZoFontHeader2" , nil , {0,0} , "Scrolling Combat Text Settings" , false )
		
		-- Scroll Speed
		local tex = "/esoui/art/miscellaneous/scrollbox_elevator.dds"
		SW.SCT.speed = FTC.Chain( WINDOW_MANAGER:CreateControl( "FTC_Settings_SCT_Speed" , SW.SCT , CT_SLIDER ) )
			:SetMouseEnabled(true)
			:SetDimensions( 200 , 30 )
			:SetThumbTexture(tex,tex,tex,10,20,1,1,0,0)
			:SetMinMax(1,10)
			:SetValue(FTC.vars.SCTSpeed)
			:SetValueStep(1)
			:SetOrientation(1)
			:SetAnchor(TOPRIGHT,SW.SCT.header,BOTTOMRIGHT,0,0)
			:SetHandler( "OnValueChanged" , function(self,value,eventReason) 
				FTC.UpdateSlider( "SCT" , self , value , "FTC_Settings_SCT_SpeedLabel" , "SCTSpeed" ) 
			end)
		.__END
		SW.SCT.speed.bg 		= FTC.UI.Backdrop( "FTC_Settings_SCT_SpeedBG" , SW.SCT.speed , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
		SW.SCT.speed.label		= FTC.UI.Label( "FTC_Settings_SCT_SpeedLabel" , SW.SCT.speed , {SW.SCT:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,0,0,SW.SCT.header} , "ZoFontGame" , nil , {0,1} , "Scroll Speed ["..FTC.vars.SCTSpeed.."]" , false )
		
		-- Max Labels Shown
		SW.SCT.maxLabels = FTC.Chain( WINDOW_MANAGER:CreateControl( "FTC_Settings_SCT_MaxLabels" , SW.SCT , CT_SLIDER ) )
			:SetMouseEnabled(true)
			:SetDimensions( 200 , 30 )
			:SetThumbTexture(tex,tex,tex,10,20,1,1,0,0)
			:SetMinMax(5,30)
			:SetValue(FTC.vars.SCTMaxLabels)
			:SetValueStep(1)
			:SetOrientation(1)
			:SetAnchor(TOPRIGHT,SW.SCT.speed,BOTTOMRIGHT,0,0)
			:SetHandler( "OnValueChanged" , function(self,value,eventReason) 
				FTC.UpdateSlider( "SCT" , self , value , "FTC_Settings_SCT_MaxLabelsLabel" , "SCTMaxLabels" ) 
			end)
		.__END
		SW.SCT.maxLabels.bg 	= FTC.UI.Backdrop( "FTC_Settings_SCT_MaxLabelsBG" , SW.SCT.maxLabels , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
		SW.SCT.maxLabels.label	= FTC.UI.Label( "FTC_Settings_SCT_MaxLabelsLabel" , SW.SCT.maxLabels , {SW.SCT:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,0,0,SW.SCT.speed.label} , "ZoFontGame" , nil , {0,1} , "Max Labels ["..FTC.vars.SCTMaxLabels.."]" , false )

		-- Max Lifespan
		SW.SCT.maxLifespan = FTC.Chain( WINDOW_MANAGER:CreateControl( "FTC_Settings_SCT_MaxLifespan" , SW.SCT , CT_SLIDER ) )
			:SetMouseEnabled(true)
			:SetDimensions( 200 , 30 )
			:SetThumbTexture(tex,tex,tex,10,20,1,1,0,0)
			:SetMinMax(1,10)
			:SetValue(FTC.vars.SCTMaxLifespan)
			:SetValueStep(1)
			:SetOrientation(1)
			:SetAnchor(TOPRIGHT,SW.SCT.maxLabels,BOTTOMRIGHT,0,0)
			:SetHandler( "OnValueChanged" , function(self,value,eventReason) 
				FTC.UpdateSlider( "SCT" , self , value , "FTC_Settings_SCT_MaxLifespanLabel" , "SCTMaxLifespan" ) 
			end)
		.__END
		SW.SCT.maxLifespan.bg 	= FTC.UI.Backdrop( "FTC_Settings_SCT_MaxLifespanBG" , SW.SCT.maxLifespan , "inherit" , {CENTER,CENTER,0,0} , nil , nil , false )
		SW.SCT.maxLifespan.label	= FTC.UI.Label( "FTC_Settings_SCT_MaxLifespanLabel" , SW.SCT.maxLifespan , {SW.SCT:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,0,0,SW.SCT.maxLabels.label} , "ZoFontGame" , nil , {0,1} , "Max Lifespan ["..FTC.vars.SCTMaxLifespan.."]" , false )

		-- Ability Names
		SW.SCT.names = {}
		SW.SCT.names.label 		= FTC.UI.Label( "FTC_Settings_SCT_NamesLabel" , SW.SCT , {SW.SCT:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,0,0,SW.SCT.maxLifespan.label} , "ZoFontGame" , nil , {0,1} , "Display Ability Names" , false )
		
		SW.SCT.names.toggle 	= FTC.UI.Button( "FTC_Settings_SCT_NamesToggle" , SW.SCT , {SW.SCT:GetWidth()*0.4,30} , {TOPRIGHT,BOTTOMRIGHT,0,0,SW.SCT.maxLifespan} ,  BSTATE_NORMAL , "ZoFontGame" , {2,1} , {0.6,0,0,1} , {0,0.6,0,1} , {0.8,0.4,0,1} , false )
		SW.SCT.names.toggle:SetHandler( "OnClicked" , function(self) FTC.ToggleComponent( self,'SCT','SCTNames' ) end )
		SW.SCT.names.toggle:SetText( FTC.vars.SCTNames and "Enabled" or "Disabled" )
		if ( FTC.vars.SCTNames ) then SW.SCT.names.toggle:SetState( BSTATE_PRESSED ) end

		-- Contexts
		SW.SCT.ContextsEnabled = {}
		local settingTable = FTC.settings.SCT.settings.SCTContextsEnabled

		SW.SCT.ContextsEnabled.label = FTC.UI.Label( "FTC_Settings_SCT_ContextsEnabledLabel" , SW.SCT , {SW.SCT:GetWidth(),30} , {TOPLEFT,BOTTOMLEFT,0,0,SW.SCT.names.label} , "ZoFontGame" , nil , {0,1} , settingTable.name , false )

		SW.SCT.ContextsEnabled.togglelabel = {}
		SW.SCT.ContextsEnabled.toggle = {}
		for i =1, #FTC.SCTContexts do
			local context = FTC.SCTContexts[i]
			local vAnchorOffset = i*20 - 20
			SW.SCT.ContextsEnabled.togglelabel[context]	= FTC.UI.Label( "FTC_Settings_SCT_ContextToggleLabel"..context , SW.SCT , {SW.SCT:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,30,vAnchorOffset,SW.SCT.ContextsEnabled.label	} , "ZoFontGame" , nil , {0,1} , context , false )
			SW.SCT.ContextsEnabled.toggle[context] 	= FTC.UI.Button( "FTC_Settings_SCT_ContextToggle"..context , SW.SCT , {SW.SCT:GetWidth()*0.4,30} , {TOPRIGHT,BOTTOMRIGHT,0,vAnchorOffset+30,SW.SCT.names.toggle} ,  BSTATE_NORMAL , "ZoFontGame" , {2,1} , {0.6,0,0,1} , {0,0.6,0,1} , {0.8,0.4,0,1} , false )
			SW.SCT.ContextsEnabled.toggle[context]:SetHandler( "OnClicked" , function(self)
				--get setting
				local currLabelControl = self:GetLabelControl()
				local currContextsEnabled = settingTable.status
				-- look in the list
				local currContextIndex = FTC.CheckTable(currContextsEnabled, context)
				--get current state !!! this doesn't work the way I thought it did i guess, doesn't stick or something
				--currState = self:GetState()
				if( currLabelControl:GetText() == 'Disabled' ) then
					--it shouldn't be in the list, but double check
					if(currContextIndex == nil) then
						table.insert(currContextsEnabled, context)	
					end
					currLabelControl:SetText("Enabled")
					self:SetState(BSTATE_PRESSED)
--d('clicked '..context..', state was '..tostring(currState)..", text was "..currLabelControl:GetText()..", set to Pressed("..BSTATE_PRESSED.."), tableLen:".. #currContextsEnabled)
				else
					--we want to disable, check if in list and remove if it is
					if(currContextIndex) then
						table.remove(currContextsEnabled, currContextIndex)
					end
					currLabelControl:SetText("Disabled")
					self:SetState(BSTATE_NORMAL)
--d('clicked '..context..', state was '..tostring(currState)..", text was "..currLabelControl:GetText()..", set to Normal("..BSTATE_NORMAL.."), tableLen:".. #currContextsEnabled )
				end
			end )

			--set initial text state
			if( FTC.CheckTable(settingTable.status, context) ) then
				SW.SCT.ContextsEnabled.toggle[context]:SetText("Enabled")
				SW.SCT.ContextsEnabled.toggle[context]:SetState( BSTATE_PRESSED )
			else
				SW.SCT.ContextsEnabled.toggle[context]:SetText("Disabled")
				SW.SCT.ContextsEnabled.toggle[context]:SetState( BSTATE_NORMAL )
			end
		end

		-- Animation
		SW.SCT.Animation = {}
		SW.SCT.Animation.label = FTC.UI.Label( "FTC_Settings_SCT_AnimationLabel" , SW.SCT , {SW.SCT:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,0,70, SW.SCT.ContextsEnabled.label} , "ZoFontGame" , nil , {0,1} , FTC.settings.SCT.settings.SCTAnimation.name , false )
--		SW.SCT.Animation.buttonlabel = {}
		SW.SCT.Animation.button = {}
		--SW.SCT.Animation.buttonlabel = FTC.UI.Label( "FTC_Settings_SCT_AnimationButtonLabel" , SW.SCT , {SW.SCT:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,0,0,SW.SCT.Animation.label	} , "ZoFontGame" , nil , {0,1} , "Anim: "..FTC.settings.SCT.settings.SCTAnimation.status , false )
		SW.SCT.Animation.button 	 = FTC.UI.Button( "FTC_Settings_SCT_AnimationButton" , SW.SCT , {SW.SCT:GetWidth()*0.4,30} , {TOPRIGHT,BOTTOMRIGHT,0,70,SW.SCT.ContextsEnabled.label} ,  BSTATE_NORMAL , "ZoFontGame" , {2,1} , {0.9,0.9,0.7,1} , {0.7,0.7,0.3,1} , {0.8,0.4,0,1} , false )
		SW.SCT.Animation.button:SetHandler( "OnClicked" , function(self)
			local currAnimNum = FTC.CheckTable( FTC.SCTAnimations, FTC.settings.SCT.settings.SCTAnimation.status )
			currAnimNum = currAnimNum + 1
			if(currAnimNum > #FTC.SCTAnimations) then
				currAnimNum = 1
			end

			FTC.settings.SCT.settings.SCTAnimation.status = FTC.SCTAnimations[currAnimNum]
			--I want the change to happen right away, without saving
			FTC.vars.SCTAnimation = FTC.settings.SCT.settings.SCTAnimation.status
			self:SetText( FTC.settings.SCT.settings.SCTAnimation.status  )
			
		end)
		SW.SCT.Animation.button:SetText( FTC.settings.SCT.settings.SCTAnimation.status or "N/A" )
	end
	
	--[[----------------------------------------------------------
		Unit Frames Section
	]]-----------------------------------------------------------
	SW.frames = FTC.UI.Control( "FTC_Settings_Frames" , SW , {SW:GetWidth() - 100 , FTC.Frames.init and 100 or 0} , {TOPLEFT,BOTTOMLEFT,0,10,SW.SCT} , false )
	if ( FTC.Frames.init ) then
		SW.frames.header 		= FTC.UI.Label( "FTC_Settings_FramesHeader" , SW.frames , {SW.frames:GetWidth() , 30} , {TOP,TOP,0,0} , "ZoFontHeader2" , nil , {0,0} , "Unit Frames Settings" , false )
		
		-- Move Frames
		SW.frames.move = {}
		SW.frames.move.label 	= FTC.UI.Label( "FTC_Settings_Frames_MoveLabel" , SW.frames , {SW.frames:GetWidth()*0.6,30} , {TOPLEFT,BOTTOMLEFT,0,0,SW.frames.header} , "ZoFontGame" , nil , {0,1} , "Adjust Frame Position" , false )
		SW.frames.move.toggle 	= FTC.UI.Button( "FTC_Settings_Frames_MoveToggle" , SW.frames , {SW.frames:GetWidth()*0.4,30} , {TOPRIGHT,BOTTOMRIGHT,0,0,SW.frames.header} ,  BSTATE_PRESSED , "ZoFontGame" , {2,1} , {0.6,0,0,1} , {0,0.6,0,1} , {0.8,0.4,0,1} , false )
		SW.frames.move.toggle:SetHandler( "OnClicked" , function(self) FTC.MoveFrames(self) end )
		SW.frames.move.toggle:SetText( "Unlock Positions" )
	end
	
	--[[----------------------------------------------------------
		Create Buttons
	]]-----------------------------------------------------------
	SW.close = FTC.UI.Button( "FTC_Settings_Close" , SW , {25,25} , {TOPRIGHT,TOPRIGHT,-5,5} , BSTATE_NORMAL , "ZoFontGame" , {1,1} , {1,1,1,1} , nil , {0.8,0.4,0,1} , false )
	SW.close:SetHandler( "OnClicked" , function(self) FTC.DisplaySettings() end )
	SW.close:SetText( "[X]" )
	
	SW.close = FTC.UI.Button( "FTC_Settings_Save" , SW , {200,50} , {BOTTOMRIGHT,BOTTOMRIGHT,-50,-10} , BSTATE_NORMAL , "ZoFontGame" , {2,1} , {1,1,1,1} , nil , {0.8,0.4,0,1} , false )
	SW.close:SetHandler( "OnClicked" , function(self) FTC.SaveSettings(self) end )
	SW.close:SetText('Save Settings')

	SW.close = FTC.UI.Button( "FTC_Settings_Restore" , SW , {200,50} , {BOTTOMLEFT,BOTTOMLEFT,50,-10} , BSTATE_NORMAL , "ZoFontGame" , {0,1} , {1,1,1,1} , nil , {0.8,0.4,0,1} , false )
	SW.close:SetHandler( "OnClicked" , function(self) FTC.RestoreDefaults(self) end )
	SW.close:SetText('Restore Defaults')
end

 --[[ 
  * Toggle display of the settings menu
  * Runs on the /FTC slash command.
 ]]--
function FTC.ToggleComponent( button , component , setting , reset )

	-- Switch the context
	local label = button:GetLabelControl()
	local status = true
	if ( label:GetText() == "Disabled" or reset == true ) then
		button:SetState( BSTATE_PRESSED )
		label:SetText( "Enabled" )
	else
		button:SetState( BSTATE_NORMAL )
		label:SetText( "Disabled" )
		status = false
	end
	
	-- Either set the base component status, or a secondary setting
	if ( setting == nil ) then
		FTC.settings[component]['status'] = status
	else
		FTC.settings[component]['settings'][setting]['status'] = status
	end
end

--[[
  * Look Through a list and see if value exists 
	Returns the index it was found at or nil if not found
]]--
function FTC.CheckTable( table, value )
	local foundIndex = nil
	for i=1, #table do
		if(table[i] == value ) then
			foundIndex = i
		end
	end
	return foundIndex
end

 --[[ 
  * Update a slider element when it is moved
 ]]--
function FTC.UpdateSlider( component,slider,value,label,variable )
	
	-- Save the setting
	FTC.settings[component]['settings'][variable]['status'] = value
	
	-- Re-save the slider values
	slider:SetValue(value)
	
	-- Get the current text label	
	local label = _G[label]
	local text	= SplitString( "[" , label:GetText() ) .. "[" .. value .. "]"
	
	-- Update the label
	label:SetText(text)
end

 --[[ 
  * Toggle the "Move Mode"
 ]]--
function FTC.MoveFrames(self)
	
	-- Toggle the button state
	local label 	= self:GetLabelControl()
	local canMove 	= label:GetText() == 'Unlock Positions'
	if ( canMove ) then
		label:SetText( 'Lock Positions' )
		self:SetState( BSTATE_NORMAL )
	else
		label:SetText( 'Unlock Positions' )
		self:SetState( BSTATE_PRESSED )
	end
	
	-- Allow the frames to be dragged
	FTC_PlayerFrame:SetMouseEnabled(canMove)
	FTC_TargetFrame:SetMouseEnabled(canMove)

	-- Toggle the movemode
	FTC.movemode = not FTC.movemode
end

 --[[ 
  * Restore all settings to the default values
 ]]--
function FTC.RestoreDefaults()
	
	-- Reset component toggles
	for k,v in pairs(FTC.settings) do
		local button = _G["FTC_Settings_Toggle"..k]
		local label	= button:GetLabelControl()
		label:SetText("Enabled")
		button:SetState( BSTATE_PRESSED )
		FTC.settings[k]['status'] = FTC.defaults["Enable"..k]
	end
	
	-- Reset SCT settings
	FTC.ToggleComponent( FTC_Settings_SCT_NamesToggle , 'SCT' , "SCTNames" , FTC.defaults.SCTNames )	
	FTC.UpdateSlider( "SCT" , FTC_Settings_SCT_Speed , FTC.defaults.SCTSpeed , "FTC_Settings_SCT_SpeedLabel" , "SCTSpeed" ) 
	
	-- I think this is hacky, might want to change it
	FTC.vars.SCTContextsEnabled = FTC.defaults.SCTContextsEnabled
	FTC.settings.SCT.settings.SCTContextsEnabled.status = FTC.defaults.SCTContextsEnabled


	-- Reset frame positions
	FTC.vars.PlayerFrameX = 0
	FTC.vars.PlayerFrameY = 0
	FTC.vars.TargetFrameX = 0
	FTC.vars.TargetFrameY = 0
end

 --[[ 
  * Save FTC settings to the stored variables
 ]]--
function FTC.SaveSettings()

	-- Iterate through component statuses, saving the settings
	for k,v in pairs( FTC.settings ) do
		FTC.vars["Enable"..k] = FTC.settings[k]['status']
		
		-- If the component has subsidiary settings, save them too
		if ( FTC.settings[k]['settings'] ~= nil ) then
			for sk,sv in pairs( FTC.settings[k]['settings'] ) do
				FTC.vars[sk] = sv['status']
			end
		end
	end

	-- Display an update
	d( "FTC settings updated, /reloadui to enact these changes!" )
end


 --[[ 
  * Toggle display of the settings menu
  * Runs on the /FTC slash command.
 ]]--
function FTC.DisplaySettings()

	-- Get the window
	local Settings = _G['FTC_Settings']

	-- Free the mouse
	SetGameCameraUIMode( Settings:IsHidden() )
	
	-- Toggle display
	Settings:SetHidden( not Settings:IsHidden() )
end