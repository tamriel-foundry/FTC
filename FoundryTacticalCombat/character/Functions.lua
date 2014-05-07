 
 --[[----------------------------------------------------------
	CHARACTER FUNCTIONS
	-----------------------------------------------------------
	* Relevant functions for the player character components of FTC
	* Runs during FTC:Initialize()
  ]]--
 
FTC.Player = {}		
function FTC.Player:Initialize()

	-- Setup initial character information
	FTC.Player.name		= GetUnitName( 'player' )
	FTC.Player.race		= GetUnitRace( 'player' )
	FTC.Player.class	= FTC.L( GetUnitClass( 'player' ) )
	FTC.Player.nicename	= string.gsub( GetUnitName( 'player' ) , "%-", "%%%-")

	-- Get experience level
	FTC.Player:GetLevel()
	
	-- Load starting attributes
	local stats = {
		{ ["name"] = "health" 	, ["id"] = POWERTYPE_HEALTH },
		{ ["name"] = "magicka" 	, ["id"] = POWERTYPE_MAGICKA },
		{ ["name"] = "stamina" 	, ["id"] = POWERTYPE_STAMINA },
		{ ["name"] = "ultimate" , ["id"] = POWERTYPE_ULTIMATE }
	}
	for i = 1 , #stats , 1 do
		local current, maximum, effMax = GetUnitPower( "player" , stats[i].id )
		FTC.Player[stats[i].name] = { ["current"] = current , ["max"] = maximum , ["pct"] = math.floor( ( current / maximum ) * 100 ) }
	end
end

FTC.Target = {}
function FTC.Target:Initialize()

	-- Setup initial target information
	local target 			= {
		["name"] 			= "-999",
		["level"]			= 0,
		["class"]			= "",
		["vlevel"]			= 0,
		["health"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["magicka"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["stamina"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
		["shield"]			= { ["current"] = 0 , ["max"] = 0 , ["pct"] = 100 },
	}	
	
	-- Populate the target object
	for attr , value in pairs( target ) do FTC.Target[attr] = value end
	
	-- Get target data
	FTC.Target:Update()
end

--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------
 
  --[[ 
 * Populates the character level
 * Called by Initialize()
 * Called by OnXPUpdate()
 * Called by OnVPUpdate()
 ]]-- 
function FTC.Player:GetLevel()
	FTC.Player.level	= GetUnitLevel('player')
	FTC.Player.vlevel	= GetUnitVeteranRank('player')
	FTC.Player.alevel	= GetUnitAvARank('player')
	FTC.Player.exp		= GetUnitXP('player')
	FTC.Player.vet		= GetUnitVeteranPoints('player')
end


function FTC.Target:Update()
	
	-- Update the saved target
	FTC.Target.name		= GetUnitName('reticleover')
	FTC.Target.class	= FTC.L( GetUnitClass('reticleover') )
	FTC.Target.level	= GetUnitLevel('reticleover')
	FTC.Target.vlevel	= GetUnitVeteranRank('reticleover')	

end