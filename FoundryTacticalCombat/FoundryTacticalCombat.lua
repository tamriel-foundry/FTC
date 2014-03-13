
--[[----------------------------------------------------------
	FOUNDRY TACTICAL COMBAT
	----------------------------------------------------------
	* A robust addon designed to overhaul the Elder Scrolls Online interface to provide 
	* useful and time-sensitive information about combat events. The add-on features
	* several components:
	* (1) Enhanced Heads-Up-Display
	* (2) Active Buff Tracking
	* (3) Enemy Cast-Bar
	* (4) Scrolling Combat Text and Damage Meter
	* 
	* Version 0.15
	* atropos@tamrielfoundry.com
	* 3-13-2014
  ]]--

--[[----------------------------------------------------------
	INITIALIZATION
  ]]----------------------------------------------------------
FTC 					= {}
FTC.name				= "FoundryTacticalCombat"
FTC.command				= "/ftc"
FTC.version				= 0.15

-- Default Saved Variables
FTC.defaults			= {
	["EnableBuffs"] 	= false,
	["EnableCastbar"] 	= false,
	["EnableSCT"] 		= false,
	["EnableFrames"] 	= false,
	["SCTSpeed"]		= 3,
	["SCTNames"]		= true,
	["NumBuffs"]		= 12,
	["PlayerFrameX"]	= 0,
	["PlayerFrameY"]	= 0,
	["TargetFrameX"]	= 0,
	["TargetFrameY"]	= 0,
	}

-- Component Management
FTC.init 				= {}
FTC.movemode			= false;
FTC.debug				= {
	["buffs"]			= false,
	["castbar"]			= false,
	["sct"]				= false,
	["hud"]				= false
	}
	
--[[ 
 * Initialization function
 * Runs once, when the add-on is fully loaded
 ]]-- 
function FTC.Initialize( eventCode, addOnName )

	-- Only set up for FTC
	if ( addOnName ~= FTC.name ) then return end
	
	-- Load saved variables
	FTC.vars = ZO_SavedVars:New( "FTCvars" , math.floor( FTC.version * 100 ) , nil , FTC.defaults , nil )
	
	-- Setup Character Information
	FTC.Character:Initialize()
	
	-- Unit Frames Component
	FTC.Frames:Initialize()
	
	-- Castbar Component
	if ( FTC.vars.EnableCastbar ) then FTC.Castbar:Initialize()	end
	
	-- Active Buffs Component
	if ( FTC.vars.EnableBuffs ) then FTC.Buffs:Initialize() end
	
	-- Scrolling Combat Text Component
	if ( FTC.vars.EnableSCT ) then FTC.SCT:Initialize()	end
	
	-- Setup settings component
	FTC.InitializeSettings()
	FTC.Menu.Initialize()
	
	-- Register event listeners
	FTC:RegisterEvents()
	
	-- Register the slash command handler
	SLASH_COMMANDS[FTC.command] = FTC.Slash
	
	-- Fire a callback after setup
	CALLBACK_MANAGER:FireCallbacks("FTC_Ready")
	
	-- We don't need the event listener anymore
	EVENT_MANAGER:UnregisterForEvent(EVENT_ADD_ON_LOADED)
end

-- Hook initialization onto the EVENT_ADD_ON_LOADED listener
EVENT_MANAGER:RegisterForEvent( "FTC" , EVENT_ADD_ON_LOADED , FTC.Initialize )


--[[----------------------------------------------------------
	UPDATING
  ]]----------------------------------------------------------
  
--[[ 
 * Updatating function
 * Runs every frame, delegates updating responsibilities to various active components
 ]]-- 
function FTC.Update()

	-- Active Buffs Component
	if ( FTC.Buffs.init ) then
		FTC.Buffs:UpdateBuffs('Player')
		FTC.Buffs:UpdateBuffs('Target')
	end
	
	-- Castbar Component
	if ( FTC.Castbar.init ) then
		FTC.Castbar:Update('Player')
		FTC.Castbar:Update('Target')
	end
	
	-- Scrolling Combat Text Component
	if ( FTC.init.SCT ) then
		FTC.UpdateSCT('In')
		FTC.UpdateSCT('Out')
		FTC.UpdateSCT('Stat')
	end
end

--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------
 --[[ 
 * The slash command handler
 ]]-- 
function FTC.Slash( text )

	-- Bail if there is no text
	if ( text == "" ) then 
		FTC.DisplaySettings()
		return
	end
	
	-- Enter "movemode"
	if ( text == "move" ) then
		FTC.movemode = not FTC.movemode
		return
	end
	
	-- Otherwise, check what parameters were passed
	local param , data = SplitString( " " , text )
	d( 'Requesting FTC parameter ' .. param )	
end

--[[----------------------------------------------------------
	DEBUGGING
 ]]-----------------------------------------------------------
function checkabilitytype( id )
	local types = {
		'ABILITY_TYPE_ACTIONLIST',
		'ABILITY_TYPE_AREAEFFECT',
		'ABILITY_TYPE_AREATELEPORT',
		'ABILITY_TYPE_ATTACKERINTERCEPT',
		'ABILITY_TYPE_ATTACKERREFLECT',
		'ABILITY_TYPE_AVOIDDEATH',
		'ABILITY_TYPE_BLADETURN',
		'ABILITY_TYPE_BLINK',
		'ABILITY_TYPE_BLOCK',
		'ABILITY_TYPE_BONUS',
		'ABILITY_TYPE_CHANGEAPPEARANCE',
		'ABILITY_TYPE_CHARGE',
		'ABILITY_TYPE_CHARM',
		'ABILITY_TYPE_CLAIRVOYANCE',
		'ABILITY_TYPE_CLIENTFX',
		'ABILITY_TYPE_COMBATRESOURCE',
		'ABILITY_TYPE_CREATEINTERACTABLE',
		'ABILITY_TYPE_CREATEINVENTORYITEM',
		'ABILITY_TYPE_DAMAGE',
		'ABILITY_TYPE_DAMAGELIMIT',
		'ABILITY_TYPE_DAMAGESHIELD',
		'ABILITY_TYPE_DEFEND',
		'ABILITY_TYPE_DESPAWNOVERRIDE',
		'ABILITY_TYPE_DISARM',
		'ABILITY_TYPE_DISORIENT',
		'ABILITY_TYPE_DISPEL',
		'ABILITY_TYPE_DODGE',
		'ABILITY_TYPE_DOUBLEFIRE',
		'ABILITY_TYPE_EXHAUSTED',
		'ABILITY_TYPE_FEAR',
		'ABILITY_TYPE_FILLSOULGEM',
		'ABILITY_TYPE_FIREPROC',
		'ABILITY_TYPE_FLIGHT',
		'ABILITY_TYPE_FREECAST',
		'ABILITY_TYPE_FREEINTERACT',
		'ABILITY_TYPE_GRANTABILITY',
		'ABILITY_TYPE_HEAL',
		'ABILITY_TYPE_HIDE',
		'ABILITY_TYPE_IMMUNITY',
		'ABILITY_TYPE_INTERCEPT',
		'ABILITY_TYPE_INTERRUPT',
		'ABILITY_TYPE_JUMP',
		'ABILITY_TYPE_KNOCKBACK',
		'ABILITY_TYPE_LEAP',
		'ABILITY_TYPE_LEVITATE',
		'ABILITY_TYPE_MISDIRECT',
		'ABILITY_TYPE_MODIFYCOOLDOWN',
		'ABILITY_TYPE_MODIFYDURATION',
		'ABILITY_TYPE_MOUNT',
		'ABILITY_TYPE_MOVEPOSITION',
		'ABILITY_TYPE_NOAGGRO',
		'ABILITY_TYPE_NOKILL',
		'ABILITY_TYPE_NOLOCKPICK',
		'ABILITY_TYPE_NONEXISTENT',
		'ABILITY_TYPE_NONE',
		'ABILITY_TYPE_OFFBALANCE',
		'ABILITY_TYPE_PACIFY',
		'ABILITY_TYPE_PARRY',
		'ABILITY_TYPE_PATHLINE',
		'ABILITY_TYPE_RECALL',
		'ABILITY_TYPE_REFLECTION',
		'ABILITY_TYPE_REGISTERTRIGGER',
		'ABILITY_TYPE_REMOVETYPE',
		'ABILITY_TYPE_RESURRECT',
		'ABILITY_TYPE_REVEAL',
		'ABILITY_TYPE_SEESTEALTH',
		'ABILITY_TYPE_SETCOOLDOWN',
		'ABILITY_TYPE_SETHOTBAR',
		'ABILITY_TYPE_SETTARGET',
		'ABILITY_TYPE_SHOWNON',
		'ABILITY_TYPE_SIEGEAREAEFFECT',
		'ABILITY_TYPE_SIEGECREATE',
		'ABILITY_TYPE_SIEGEPACKUP',
		'ABILITY_TYPE_SILENCE',
		'ABILITY_TYPE_SLOWFALL',
		'ABILITY_TYPE_SNARE',
		'ABILITY_TYPE_SOULGEMRESURRECT',
		'ABILITY_TYPE_SPELLSTEAL',
		'ABILITY_TYPE_STAGGER',
		'ABILITY_TYPE_STEALTH',
		'ABILITY_TYPE_STUN',
		'ABILITY_TYPE_SUMMON',
		'ABILITY_TYPE_THREAT',
		'ABILITY_TYPE_TRAUMA',
		'ABILITY_TYPE_UPDATEDEATHDIALOG',
		'ABILITY_TYPE_VAMPIRE',
		'ABILITY_TYPE_WIND'
	}
	
	-- If no type was passed, display everything
	if ( id == nil ) then
		for k,v in pairs(types) do
			d(v .. ' - ' .. _G[v])
		end
	
	
	-- If a type was passed, return the string
	else
		for k,v in pairs(types) do
			if ( id == _G[v] ) then 
				return v
			end
		end
	end
end


