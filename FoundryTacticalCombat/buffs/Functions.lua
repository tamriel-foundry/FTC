 
 --[[----------------------------------------------------------
	ACTIVE BUFF TRACKER FUNCTIONS
	-----------------------------------------------------------
	* Tracks buff and debuff abilities
	* Separates by player/target and by buff/debuff
	* "Long" duration player buffs get their own window
	* Thanks to Lyeos and UnityHUD for some nice ideas
  ]]--
 
FTC.Buffs = {}
function FTC.Buffs.Initialize()

	-- Setup buff tables
	FTC.PlayerBuffs = {}
	FTC.TargetBuffs	= {}
	
	-- Create the controls
	FTC.Buffs:Controls()

	-- Populate buffs for the player
	FTC.Buffs:GetBuffs( 'player' )
	
	-- Register init status
	FTC.init.Buffs = true
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------

 
--[[ 
 * Set up buffs which are currently active on the unit
 * Called by Initialize()
 * Called by OnTargetChanged()
 * Called by OnEffectChanged()
 ]]--
function FTC.Buffs:GetBuffs( unitTag )

	-- Only take action for player and target
	if ( unitTag ~= "player" and unitTag ~= "reticleover" ) then return end

	-- Empty the buffs object
	local context	= ( unitTag == 'player' ) and "Player" or "Target"
	FTC[context.."Buffs"] = {}
	
	-- Get the number of buffs currently affecting the target
	local nbuffs 	= GetNumBuffs( unitTag )
	
	-- Bail if the target has no buffs
	if ( nbuffs == 0 ) then return end
	
	-- Iterate through buffs, adding them to the active buffs table
	for i = 1 , nbuffs do
	
		-- Get the buff information
		local effectName, beginTime, endTime, effectSlot, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, longTerm = GetUnitBuffInfo( unitTag , i )

		-- Debugging all registered abilities
		if ( FTC.debug.buffs ) then
			d( unitTag .. "/" .. effectName .. "/" .. abilityType .. "/" .. beginTime .. "/" .. endTime .. "/" .. effectType)
		end
		
		-- Run the effect through a filter
		isValid, effectName, effectDuration , beginTime , endTime = FTC:FilterBuffInfo( changeType , unitTag , effectName , abilityType , beginTime , endTime )
		if ( isValid ) then 
		
			-- Otherwise set up a buff object
			local newBuff = {
				["slot"]	= effectSlot,
				["name"]	= effectName,
				["type"]	= abilityType,
				["begin"]	= beginTime or 0,
				["ends"]	= endTime or 1000,
				["dur"]		= effectDuration,
				["debuff"]	= ( effectType == 2 ) and true or false,
				["stacks"]	= stackCount,
				["tag"]		= unitTag,
				["icon"]	= iconName
			}
			
			-- Debug approved abilities
			if ( FTC.debug.buffs ) then
				local typename = checkabilitytype( abilityType )
				d( newBuff.name .. "/" .. newBuff.type .. "/" .. typename .. "/" .. newBuff.begin .."/".. newBuff.ends )
			end
			
			-- Add it to the appropriate table
			FTC[context.."Buffs"][effectName] = newBuff		
		end
	end		
end


--[[----------------------------------------------------------
	UPDATING FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Display buffs and debuffs based on context
 * Argument "context" takes {Player,Target}
 * Runs every frame OnUpdate
 ]]--
function FTC.Buffs.UpdateBuffs( context )

	-- Get the buff container
	local parentBuffs 	= _G["FTC_" .. context .. "Buffs"]
	local parentDebuffs	= _G["FTC_" .. context .. "Debuffs"]
		
	-- Hide target buffs if the target frame isn't shown
	if ( context == "Target" and FTC.init.HUD and FTC_TargetFrame:IsHidden() ) then 
		parentBuffs:SetHidden(true) 
		parentDebuffs:SetHidden(true) 
		return
	end
	
	-- Get the correct table of buffs
	local buffs = {}
	if ( context == "Target" ) then
		buffs = FTC.TargetBuffs
	elseif ( context == "Player" ) then
		buffs = FTC.PlayerBuffs
	end
	
	-- Convert the table to a numeric indexed array
	local buffs = {}
	for k,v in pairs( FTC[context .. "Buffs"] ) do table.insert( buffs , v ) end
	table.sort( buffs , FTC.SortBuffs )
	
	-- Hide the element if no buffs are present
	if ( #buffs == 0 ) then
		FTC.ClearBuffIcons(context,1,1,1)
		return
	end
	
	-- Track the current game time and counts
	local gameTime	= GetGameTimeMilliseconds() / 1000
	local count 	= 1
	local debCount	= 1
	local longCount = 1
	
	-- Loop through buffs, updating each effect
	for i = 1 , #buffs do
	
		-- Limit the number of buffs that can be tracked
		if ( count > FTC.vars.NumBuffs ) then break end
		
		-- Setup defaults
		local name		= buffs[i].name
		local duration 	= buffs[i].dur
		local isLong	= context == "Player" and duration ~= nil
		local stacks 	= ""
		local label		= ""
		
		-- Compute remaining duration of timed abilities
		if ( duration == nil ) then
			duration = math.floor( ( buffs[i].ends - gameTime ) * 10 ) / 10 
			
			-- Clear abilities whose duration has gone negative
			if ( duration <= 0 ) then
				FTC.PlayerBuffs[name] = nil
				FTC.TargetBuffs[name] = nil
			end
			
			-- Flag long duration buffs
			isLong = ( context == "Player" and duration >= 75 ) and true or isLong
			
			-- Duration in hours
			if ( duration > 3600 ) then
				local hours 	= math.floor( duration / 3600 )
				label			= string.format( "%dh" , hours )
			
			-- Duration in minutes
			elseif ( duration > 60 ) then	
				local minutes 	= math.floor( duration / 60 )
				label			= string.format( "%dm" , minutes )
			
			-- Duration in seconds
			else
				label = string.format( "%.1f" , duration )
			end
			
		-- Otherwise, grab the forced string label
		else
			label = duration
		end
		
		-- Handle multiple stacks
		if (buffs[i].stacks) ~= 0 then
			stacks = "(" .. buffs[i].stacks .. ")"
		end
		
		-- Buff or debuff?
		local buffDebuff 	= buffs[i].debuff and "Debuffs" or "Buffs"
		local num			= buffs[i].debuff and debCount or count
		
		-- Target the appropriate containers
		local container		= isLong and "LongBuffs" or context .. buffDebuff
		num					= isLong and longCount or num
	
		-- Get the UI elements
		local buff			= _G["FTC_"..container.."_"..num]
		local newlabel 		= _G["FTC_"..container.."_"..num.."_Label"]
		local newicon		= _G["FTC_"..container.."_"..num.."_Icon"]		
		local cooldown		= _G["FTC_"..container.."_"..num.."_CD"]
		
		-- Update the display
		newlabel:SetText(label)
		newicon:SetTexture(buffs[i].icon)
		cooldown:StartCooldown( ( buffs[i].ends - gameTime ) * 1000 , ( buffs[i].ends - buffs[i].begin ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
		buff:SetHidden(false)
			
		-- Update the buff count
		if isLong then
			longCount = longCount + 1
		elseif buffs[i].debuff then
			debCount = debCount + 1
		else
			count = count + 1
		end
	end

	-- Resize the long buff window
	if ( context == "Player" ) then
		FTC_LongBuffs:SetHeight( 40 * ( longCount - 1 ) )
	end

	-- After looping through buffs, do clear any remaining buff icons
	FTC.ClearBuffIcons( context , count , debCount , longCount ) 
end



--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Sort the buff array to show effects that are expiring soonest first
 ]]--
function FTC.SortBuffs(x,y)
	if ( x.dur == "P" or x.dur == "T" or x.dur == "S" ) then return false 
	elseif ( y.dur == "P" or y.dur == "T" or y.dur == "S" ) then return true
	else return x.ends < y.ends end
end

--[[ 
 * Clear any remaining unused buff icons
 ]]--
function FTC.ClearBuffIcons( context , buffCount , debuffCount , longCount )

	-- Clear the unused buffs
	for i = buffCount, FTC.vars.NumBuffs do
		local buff	= _G["FTC_"..context.."Buffs_"..buffCount]
		buff:SetHidden(true)
		buffCount = buffCount + 1
	end
	
	-- Clear the unused debuffs
	for i = debuffCount, FTC.vars.NumBuffs do
		local buff	= _G["FTC_"..context.."Debuffs_"..debuffCount]
		buff:SetHidden(true)
		debuffCount = debuffCount + 1
	end
	
	-- Maybe clear long buffs
	if ( context == "Player" ) then
		for i = longCount, FTC.vars.NumBuffs do
			local buff	= _G["FTC_LongBuffs_"..longCount]
			buff:SetHidden(true)
			longCount = longCount + 1
		end	
	end
	
end

--[[ 
 * Filter abilities to override their displayed names or durations as necessary
 ]]--
function FTC:FilterBuffInfo( changeType , unitTag , name , buffType , beginTime , endTime )
	
	-- Default to no duration
	local duration 	= nil
	local isValid	= true
	
	-- Effects to ignore
	if ( string.match( name , 'TargetingHit' ) or string.match( name , 'Hack' ) or string.match( name , 'dummy' ) ) then
		isValid		= false
		
	-- Untyped Abilities (0)
	elseif ( buffType == ABILITY_TYPE_NONE ) then
	
		-- Summons and Toggles
		local toggles = { 
			"Unstable Familiar",
			"Unstable Clannfear",
			"Volatile Familiar",
			"Winged Twilight",
			"Restoring Twilight",
			"Twilight Matriarch",
			"Siphoning Strikes",
			"Leeching Strikes",
			"Siphoning Attacks",
			"Magelight",
			"Inner Light",
			"Radiant Magelight",
			"Bound Armor",
			"Bound Armaments",
			"Bound Aegis",
			"Inferno",
			"Flames Of Oblivion",
			"Sea Of Flames"
		}
		for i = 1, #toggles do
			if ( name == toggles[i] ) then 
				duration = "T"
				break
			end			
		end
		
	-- "Bonus" Abilities (5)
	elseif ( buffType == ABILITY_TYPE_BONUS ) then
	
		-- Mundus Stones
		if ( string.match( name , "Boon: " ) ) then
			duration = "P"
		
		-- Ignore Cyrodiil Bonuses
		elseif ( string.match( name , "Keep Bonus" ) or string.match( name , "Scroll Bonus" ) or string.match( name , "Emperorship" ) ) then
			isValid		= false
			
		-- Lycanthropy
		elseif ( name == "Lycanthropy" ) then
			duration = "P"
		
		-- Molten Armaments Hack/Fix
		elseif ( name == "Molten Armaments" and endTime - beginTime < 10 ) then
			isValid		= false
		
		-- Siege Shield Timer Fix
		elseif ( name == "Siege Shield" ) then
			if ( changeType == 3 ) then isValid = false
			else endTime = beginTime + 20 end
		end
	
	-- Stunned (9)
	elseif ( buffType == ABILITY_TYPE_STUN ) then
		name		= "Stunned"
		
	-- Power Attack (33)
	elseif ( buffType == ABILITY_TYPE_STAGGER ) then 
		if ( beginTime == 0 ) then
			isValid		= false
		else
			name		= "Staggered"
			endTime		= beginTime + 3
		end
		
	-- Blocking (52)
	elseif ( ( buffType == ABILITY_TYPE_BLOCK ) or ( name == "Brace (Generic)" ) ) then
			name		= "Blocking"
			duration 	= "T"
		
	-- Off-Balance (53)
	elseif ( buffType == ABILITY_TYPE_OFFBALANCE ) then
		endTime		= beginTime + 3
		
	-- Potions
	elseif ( string.match( name , "^.-Potion" ) ) then
		name		= string.match( name , '^.-Potion' )		
	end
		
	return isValid, name, duration , beginTime , endTime
end