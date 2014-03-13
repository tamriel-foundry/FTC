function FTC.SCT:NewCombat( eventCode , result , isError , abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log )
	
	-- Verify it's a valid result type
	if ( not FTC.FilterSCT( result , abilityName , sourceType , sourceName , targetName , hitValue ) ) then return end
	
	-- Display approved combat events
	if ( FTC.debug.sct ) then
		d( result .. "/" .. abilityName .."/".. sourceName .."/".. targetName .."/".. hitValue .."/" .. abilityActionSlotType .."/" .. powerType .."/" .. damageType )
	end
	
	-- Determine the context
	local context 	= ( sourceType == 0 ) and "In" or "Out"

	-- Modify the name
	abilityName = string.gsub ( abilityName , ' %(.*%)' , "" )

	-- Setup a new SCT object
	local newSCT = {
		["name"]	= abilityName,
		["dam"]		= hitValue,
		["power"]	= powerType,
		["type"]	= damageType,
		["ms"]		= GetGameTimeMilliseconds(),
		["crit"]	= ( result == ACTION_RESULT_CRITICAL_DAMAGE or result == ACTION_RESULT_CRITICAL_HEAL or result == ACTION_RESULT_DOT_TICK_CRITICAL ) and true or false,
		["heal"]	= ( result == ACTION_RESULT_HEAL or result == ACTION_RESULT_HOT_TICK ) and true or false,
		["blocked"]	= ( result == ACTION_RESULT_BLOCKED_DAMAGE ) and true or false,
		["immune"]	= ( result == ACTION_RESULT_IMMUNE ) and true or false,
		["multi"]	= 1
	}
	
	-- Check if the damage entry already exists
	local isNew 	= true
	for i = 1, #FTC["SCT"..context] do
		if ( ( FTC["SCT"..context][i].name == newSCT.name ) and ( math.abs( FTC["SCT"..context][i].ms - newSCT.ms ) < 500 ) ) then
			
			-- If the damage is higher, replace it
			if ( newSCT.dam > FTC["SCT"..context][i].dam ) then 
				FTC["SCT"..context][i] = newSCT
			end
			
			-- Tag a multiplier
			FTC["SCT"..context][i].multi = FTC["SCT"..context][i].multi + 1
			isNew = false
		end
	end

	-- Add the SCT object to the relevant damage table
	if ( isNew ) then table.insert( FTC["SCT"..context] , newSCT) end
	
	-- Update the DPS meter
	FTC.UpdateMeter( context , targetName , newSCT.name , newSCT.dam , newSCT.ms , newSCT.heal )
end