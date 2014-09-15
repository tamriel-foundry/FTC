 
 --[[----------------------------------------------------------
	MENU CONTROLS
	-----------------------------------------------------------
	* Set up controls for the menu component of FTC
	* Uses ZeniMax own virtual controls to create elements
	* Modifies addon saved variables
  ]]--

function FTC.Menu:Controls()

	--[[----------------------------------------------------------
		TOGGLE COMPONENTS
	  ]]----------------------------------------------------------
	FTC.Menu.options = {

		-- Components Header
		{ 
			type 		= "header", 
			name 		= FTC.L("Configure Components"), 
			width 		= "full" 
		},

		-- Enable/Disable Unit Frames
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Enable Frames"), 
			tooltip 	= FTC.L("Enable custom unit frames component?"), 
			getFunc 	= function() return FTC.vars.EnableFrames end, 
			setFunc 	= function() FTC.Menu:Toggle( 'EnableFrames' , true ) end, 
			default 	= FTC.defaults.EnableFrames, 
			warning 	= FTC.L("Reloads UI") 
		},

		-- Enable/Disable Buff Tracking
		{
			type 		= "checkbox",
			name 		= FTC.L("Enable Buffs"),
			tooltip 	= FTC.L("Enable active buff tracking component?"),
			getFunc 	=  function() return FTC.vars.EnableBuffs end,
			setFunc 	= function() FTC.Menu:Toggle( 'EnableBuffs' , true ) end,
			default 	= FTC.defaults.EnableBuffs, 
			warning 	= FTC.L("Reloads UI") 
		},

		-- Enable/Disable Damage Meter
		{ 
			type 		= "checkbox",
			name 		= FTC.L("Enable Damage Statistics"),
			tooltip 	= FTC.L("Enable damage statistics?"),
			getFunc 	= function() return FTC.vars.EnableDamage end, 
			setFunc 	= function() FTC.Menu:Toggle( 'EnableDamage' , true ) end, 
			default 	= FTC.defaults.EnableDamage, 
			warning 	= FTC.L("Reloads UI") 
		},

		-- Enable/Disable Scrolling Combat Text
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Enable Combat Text"), 
			tooltip 	= FTC.L("Enable scrolling combat text component?"),
			getFunc		= function() return FTC.vars.EnableSCT end, 
			setFunc 	= function() FTC.Menu:Toggle( 'EnableSCT' , true ) end, 
			default 	= FTC.defaults.EnableSCT, 
			warning 	= FTC.L("Reloads UI") 
		},

		-- Enable/Disable Ultimate Tracking
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Track Ultimate"), 
			tooltip 	= FTC.L("Track ultimate ability resource level?"),
			getFunc 	= function() return FTC.vars.EnableUltimate end, 
			setFunc 	= function() FTC.Menu:Toggle( 'EnableUltimate' , true ) end, 
			default 	= FTC.defaults.EnableUltimate, 
			warning 	= FTC.L("Reloads UI") 
		}
	}


	--[[----------------------------------------------------------
		UNIT FRAMES
	  ]]----------------------------------------------------------
	local Core = {
		
		-- Unit Frames Header
		{ 
			type 		= "header", 
			name 		= FTC.L("Unit Frames Settings"), 
			width		= "full" 
		},
	
		-- Augment Default Frames?
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Default Unit Frames Text"), 
			tooltip 	= FTC.L("Display text attribute values on default unit frames?"), 
			getFunc 	=  function() return FTC.vars.FrameText end, 
			setFunc 	= function() FTC.Menu:Toggle( 'FrameText' ) end,
			default 	= FTC.defaults.FrameText
		}, 
	}
	for i = 1 , #Core do table.insert( FTC.Menu.options , Core[i] ) end

	-- Conditional Unit Frames Settings
	local Extras = {
		
		-- Show Default Frames?
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Show Default Target Frame"),
			tooltip 	= FTC.L("Show the default ESO target unit frame?"), 
			getFunc 	=  function() return FTC.vars.TargetFrame end, 
			setFunc 	= function() FTC.Menu:Toggle( 'TargetFrame' ) end,
			default 	= FTC.defaults.TargetFrame
		},

		-- Display Nameplate?
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Show Player Nameplate"), 
			tooltip 	= FTC.L("Show your own character's nameplate?"), 
			getFunc 	= function() return FTC.vars.EnableNameplate end, 
			setFunc 	= function() FTC.Menu:Toggle( 'EnableNameplate' ) end,
			default 	= FTC.defaults.EnableNameplate
		},

		-- Display Experience Bar?
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Enable Mini Experience Bar"), 
			tooltip 	= FTC.L("Show a small experience bar on the player frame?"), 
			getFunc 	= function() return FTC.vars.EnableXPBar end, 
			setFunc 	= function() FTC.Menu:Toggle( 'EnableXPBar' ) end,
			default 	= FTC.defaults.EnableXPBar
		},

		-- In-Combat Opacity
		{ 
			type 		= "slider", 
			name 		= FTC.L("In Combat Opacity"), 
			tooltip 	= FTC.L("Adjust the in-combat transparency of unit frames."), 
			min 		= 0, 
			max 		= 100, 
			step 		= 10, 
			getFunc 	= function() return FTC.vars.OpacityIn end, 
			setFunc 	= function( value ) FTC.Menu:Update( "OpacityIn" , value ) end, 
			default 	= FTC.defaults.OpacityIn
		},
	       
		-- Non-Combat Opacity
		{ 
			type 		= "slider", 
			name 		= FTC.L("Non-Combat Opacity"), 
			tooltip 	= FTC.L("Adjust the out-of-combat transparency of unit frames."), 
			min 		= 0, 
			max 		= 100, 
			step 		= 10,
			getFunc 	= function() return FTC.vars.OpacityOut end, 
			setFunc 	= function( value ) FTC.Menu:Update( "OpacityOut" , value ) end, 
			default 	= FTC.defaults.OpacityOut
		},
	}
	if FTC.vars.EnableFrames then
		for i = 1 , #Extras do table.insert( FTC.Menu.options , Extras[i] ) end
	end



	--[[----------------------------------------------------------
		BUFF TRACKING
	  ]]----------------------------------------------------------
	local Extras = {

		-- Buffs Header
		{ 
			type 		= "header", 
			name 		= FTC.L("Buff Tracker Settings"), 
			width 		= "full"
		},

		-- Anchor Buffs?
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Anchor Buffs"), 
			tooltip 	= FTC.L("Anchor buffs to unit frames?"), 
			getFunc 	= function() return FTC.vars.AnchorBuffs end, 
			setFunc 	= function() FTC.Menu:Toggle( 'AnchorBuffs' , true ) end, 
			default 	= FTC.defaults.AnchorBuffs
		},
		
		-- Display Long Buffs?
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Display Long Buffs"), 
			tooltip 	= FTC.L("Track long duration player buffs?"), 
			getFunc 	= function() return FTC.vars.EnableLongBuffs end, 
			setFunc 	= function() FTC.Menu:Toggle( 'EnableLongBuffs' ) end, 
			default 	= FTC.defaults.EnableLongBuffs
		},
	}
	if FTC.vars.EnableBuffs then
		for i = 1 , #Extras do table.insert( FTC.Menu.options , Extras[i] ) end
	end

	--[[----------------------------------------------------------
		SCROLLING COMBAT TEXT
	  ]]----------------------------------------------------------
	local Extras = {

		-- SCT Header
		{ 
			type 		= "header", 
			name 		= FTC.L("Scrolling Combat Text Settings"), 
			width 		= "full", 
		},
		
		-- SCT Scroll Speed?
		{ 
			type 		= "slider",
			name 		= FTC.L("Combat Text Scroll Speed"), 
			tooltip 	= FTC.L("Adjust combat text scroll speed."), 
			min 		= 1, 
			max 		= 5, 
			step 		= 1, 
			getFunc 	= function() return FTC.vars.SCTSpeed end, 
			setFunc 	= function( value ) FTC.Menu:Update( "SCTSpeed" , value ) end, 
			default 	= FTC.defaults.SCTSpeed,
		},
		
		-- Display Ability Names?
		{ 
			type 		= "checkbox", 
			name 		= FTC.L("Display Ability Names"), 
			tooltip 	= FTC.L("Display ability names in combat text?"), 
			getFunc 	= function() return FTC.vars.SCTNames end, 
			setFunc 	= function() FTC.Menu:Toggle( 'SCTNames' , true ) end, 
			warning 	= FTC.L("Reloads UI"), 
			default 	= FTC.defaults.SCTNames,
		},

		-- Select Scroll Animation?
		{ 
			type 		= "dropdown", 
			name 		= FTC.L("Scroll Path Animation"), 
			tooltip 	= FTC.L("Choose scroll animation."), 
			choices 	= { "Arc", "Line" }, 
			getFunc 	= function() return FTC.vars.SCTPath end, 
			setFunc 	= function( value ) FTC.Menu:Update( "SCTPath" , value ) end,
			default 	= FTC.defaults.SCTPath, 
		},
	}
	if FTC.vars.EnableSCT then
		for i = 1 , #Extras do table.insert( FTC.Menu.options , Extras[i] ) end
	end

	--[[----------------------------------------------------------
		DAMAGE METER
	  ]]----------------------------------------------------------
	local Extras = {
		
		-- Damage Tracker Header
		{ 
			type 		= "header", 
			name 		= FTC.L("Damage Tracker Settings"), 
			width 		= "full"
		},

		-- Damage Tracker Threshold
		{ 
			type 		= "slider", 
			name 		= FTC.L("Timeout Threshold"), 
			tooltip 	= FTC.L("Number of seconds without damage to signal encounter termination."), 
			min 		= 5, 
			max 		= 60, 
			step 		= 5, 
			getFunc 	= function() return FTC.vars.DamageTimeout end, 
			setFunc 	= function( value ) FTC.Menu:Update( "DamageTimeout" , value ) end,
			default 	= FTC.defaults.DamageTimeout,
		}
	}
	if FTC.vars.EnableDamage then
		for i = 1 , #Extras do table.insert( FTC.Menu.options , Extras[i] ) end
	end

	--[[----------------------------------------------------------
		REPOSITION ELEMENTS
	  ]]----------------------------------------------------------
	local Core = {
		
		-- Reposition Header
		{ 
			type 		= "header", 
			name 		= FTC.L("Reposition FTC Elements"),
			width		= "full" 
		},
	
		-- Augment Default Frames?
		{ 
			type 		= "button", 
			name 		= FTC.L("Lock Positions"),
			tooltip 	= FTC.L("Modify FTC frame positions?"), 
			func 		= function() FTC.Menu:MoveFrames() end,
		}, 

		-- Restore Defaults?
		{ 
			type 		= "header", 
			name 		= FTC.L("Reset Settings"),
			width		= "full" 
		},

		{ 
			type 		= "button", 
			name 		= FTC.L("Restore Defaults"),
			tooltip 	= FTC.L("Restore FTC to default settings."),
			func 		= function() FTC.Menu:Reset() end,
			warning 	= FTC.L("Reloads UI")
		}, 
	}
	for i = 1 , #Core do table.insert( FTC.Menu.options , Core[i] ) end

end
