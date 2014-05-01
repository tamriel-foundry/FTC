 
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

	-- Setup displayed buff tables
	FTC.Buffs.Player = {}
	FTC.Buffs.Target = {}
	
	-- Saved effects
	FTC.Buffs.Saved	= {}
	
	-- Create the controls
	FTC.Buffs:Controls()

	-- Populate buffs for the player
	FTC.Buffs:GetBuffs( 'player' )
	
	-- Get the hotbar loadout
	FTC.Buffs:GetHotbar()
	
	-- Placeholder for last cast spell and potion
	FTC.Buffs.lastCast = 0
	FTC.Buffs.lastPotion = 0
	
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

	-- Get the context
	local context	= ( unitTag == 'player' ) and "Player" or "Target"
	
	-- If we are setting up a target's buffs, get them from saved
	if ( unitTag == 'reticleover' ) then
	
		-- Empty the active buffs table
		FTC.Buffs[context] = {}
	
		-- Retrieve buffs from saved
		local saved = FTC.Buffs.Saved
		for name , buff in pairs( saved ) do
		
			-- Clear anything that has gone negative
			local ms = GetGameTimeMilliseconds()
			if ( buff.ends < ( ms / 1000 ) ) then FTC.Buffs.Saved[name] = nil	

			-- Keep area abilities and abilities specifically directed at the target
			elseif ( buff.target == GetUnitName( 'reticleover' ) or buff.area ) then FTC.Buffs[context][name] = buff
			
			-- Otherwise drop the debuff from the active table
			else FTC.Buffs[context][name] = nil	end
		end
	end
	
	-- Get the number of buffs currently affecting the target
	local nbuffs 	= GetNumBuffs( unitTag )
	
	-- Bail if the target has no buffs
	if ( nbuffs == 0 ) then return end
	
	-- Iterate through buffs, adding them to the active buffs table
	for i = 1 , nbuffs do
	
		-- Get the buff information
		local effectName, beginTime, endTime, effectSlot, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, longTerm = GetUnitBuffInfo( unitTag , i )
		
		-- Run the effect through a filter
		isValid, effectName, effectDuration , beginTime , endTime = FTC:FilterBuffInfo( changeType , unitTag , effectName , abilityType , beginTime , endTime )
		if ( isValid ) then 
		
			-- Otherwise set up a buff object
			local newBuff = {
				["target"]	= GetUnitName( unitTag ),
				["name"]	= effectName,
				["begin"]	= beginTime or 0,
				["ends"]	= endTime or 1000,
				["dur"]		= effectDuration,
				["debuff"]	= effectType == BUFF_EFFECT_TYPE_DEBUFF,
				["stacks"]	= stackCount,
				["tag"]		= unitTag,
				["icon"]	= iconName
			}			
			
			-- Add it to the appropriate table
			FTC.Buffs[context][effectName] = newBuff		
		end
	end
end

--[[ 
 * Remove a single buff if it expires
 * Called by OnEffectChanged()
 ]]--
function FTC.Buffs:Remove( eventCode, changeType,  effectSlot,  effectName,  unitTag,  beginTime,  endTime, stackCount,  iconName,  buffType, effectType, abilityType, statusEffectType )

	-- Get the context
	local context = ( unitTag == 'player' ) and "Player" or "Target"
	
	-- Filter the name
	isValid, effectName, effectDuration , beginTime , endTime = FTC:FilterBuffInfo( changeType , unitTag , effectName , abilityType , beginTime , endTime )
		
	-- Remove the buff
	if ( isValid ) then FTC.Buffs[context][effectName] = nil end
end

--[[ 
 * Wipe all target specific buffs when the target dies
 * Called by OnDeath()
 ]]--
function FTC.Buffs:WipeBuffs( unitTag )
	
	-- Wipe out target buffs/debuffs
	for name , buff in pairs( FTC.Buffs.Saved ) do
		if ( buff.target == GetUnitName( unitTag ) and buff.area == false ) then
			FTC.Buffs.Saved[name] = nil		
			FTC.Buffs.Target[name] = nil		
		end	
	end
	
	-- Wipe out player buffs that are target specific
	for name , buff in pairs( FTC.Buffs.Player ) do
		if ( buff.target == GetUnitName( unitTag ) and buff.area == false ) then
			FTC.Buffs.Player[name] = nil			
		end	
	end
end

--[[ 
 * Check the player's buffs for known damage shields, and purge them
 * Called by OnVisualRemoved()
 ]]--
function FTC.Buffs:RemoveVisuals( unitTag , unitAttributeVisual , powerType )

	-- For now, only do this stuff for the player
	if ( unitTag ~= 'player' ) then return end

	-- Check for damage shields
	if ( unitAttributeVisual == ATTRIBUTE_VISUAL_POWER_SHIELDING ) then
		for name, buff in pairs( FTC.Buffs.Player ) do
			if ( FTC.Buffs:IsDamageShield( name ) ) then 
				FTC.Buffs.Player[name] = nil
			end		
		end		
	end
end

--[[ 
 * Get the player's current and active hotbar loadout
 * Called by OnSlotUpdate()
 ]]--
function FTC.Buffs:GetHotbar()
	
	-- Empty the hotbar
	FTC.Hotbar 					= {}
	FTC.Hotbar[1] 				= {}
	FTC.Hotbar[2] 				= {}

	-- Get the current loadout
	for i = 3, 8 do
		if ( IsSlotUsed(i) ) then
			local name			= GetSlotName(i)
			if ( FTC.language ~= "English" ) then name = FTC.L(name) end			
			local cost, cType 	= GetSlotAbilityCost(i)
			local slot			= {
				["slot"]		= i,
				["name"]		= name,
				["type"]		= cType,
				["cost"]		= cost,
				["tex"]			= GetSlotTexture(i),
				["ground"]		= FTC.Buffs:IsGroundTarget( name ),
				["effects"]		= FTC.Buffs.Effects[name],
			}
			FTC.Hotbar[i] 		= slot
		else
			FTC.Hotbar[i] 		= {
				["slot"]		= i,
				["name"]		= 'unused',
				["type"]		= -999,
				["cost"]		= -999,
			}
		end
	end
end


--[[----------------------------------------------------------
	UPDATING FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Display buffs and debuffs based on context
 * Argument "context" takes {Player,Target}
 * Runs OnUpdate - 10 ms buffer
 ]]--
function FTC.Buffs:Update( context )

	-- Get the buff container
	local parentBuffs 	= _G["FTC_" .. context .. "Buffs"]
	local parentDebuffs	= _G["FTC_" .. context .. "Debuffs"]
		
	-- Hide target buffs if the target frame isn't shown
	if ( context == "Target" and FTC.init.Frames and FTC_TargetFrame:IsHidden() ) then 
		parentBuffs:SetHidden(true) 
	end
	
	-- Get the correct table of buffs
	local buffs = {}
	if ( context == "Target" ) then
		buffs = FTC.Buffs.Target
	elseif ( context == "Player" ) then
		buffs = FTC.Buffs.Player
	end
	
	-- Convert the table to a numeric indexed array
	local buffs = {}
	for k,v in pairs( FTC.Buffs[context] ) do table.insert( buffs , v ) end
	table.sort( buffs , FTC.Buffs.Sort )
	
	-- Hide the element if no buffs are present
	if ( #buffs == 0 ) then
		FTC.Buffs:ClearIcons(context,1,1,1)
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
		
		-- Only show abilities which have started already
		if ( buffs[i].begin <= gameTime ) then 
		
			-- Compute remaining duration of timed abilities
			if ( duration == nil ) then
				duration = math.floor( ( buffs[i].ends - gameTime ) * 10 ) / 10 
				
				-- Clear abilities whose duration has gone negative
				if ( duration <= 0 ) then
					FTC.Buffs.Player[name] = nil
					FTC.Buffs.Target[name] = nil
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
	end

	-- Resize the long buff window
	if ( context == "Player" ) then
		FTC_LongBuffs:SetHeight( 40 * ( longCount - 1 ) )
	end

	-- After looping through buffs, do clear any remaining buff icons
	FTC.Buffs:ClearIcons( context , count , debCount , longCount ) 
end

--[[ 
 * Check for whether a spell is being cast
 * Runs OnUpdate - 100 ms buffer
 ]]--
function FTC.Buffs:CheckCast()

	for i = 3 , 8 do
		local button = _G["ActionButton"..i.."Button"]
		if( button:GetState() == BSTATE_PRESSED ) then
		
			-- Make sure the ability is usable
			if( FTC.Buffs:HasFailure( i ) ) then return end
			
			-- Get the time
			local ms = GetGameTimeMilliseconds()
		
			-- Was this spell already registered?
			if ( ms < FTC.Buffs.lastCast + 250 ) then return end
			
			-- Get the used ability
			local ability = FTC.Hotbar[i]
			
			-- Fire a callback when we know a spell was cast
			CALLBACK_MANAGER:FireCallbacks( "FTC_SpellCast" , ability )
			
			-- Dont process effects immediately for ground-target spells
			if ( ability.ground ) then 
				FTC.Buffs.ground = ability
				return 
			end
			
			-- Otherwise register the effects!
			FTC.Buffs:NewEffects( ability )
			
			-- Clear the ground target queue
			FTC.Buffs.ground = nil
			
			-- Flag the last cast time
			FTC.Buffs.lastCast = ms
		end
	end
end


--[[ 
 * Check for whether a potion has been used
 * Runs OnUpdate - 50 ms buffer
 ]]--
function FTC.Buffs:CheckPotion()

	-- Get the current potion
	local current = GetCurrentQuickslot()

	-- Bail if there is no active potion
	if ( GetSlotName( current ) == "" ) then return end
	
	-- Get the cooldown
	local cd = GetSlotCooldownInfo(current)
	
	-- Trigger an alert if the potion has just become available
	if ( cd == 0 and FTC.Buffs.lastPotion > 0 ) then
		if ( FTC.init.SCT ) then
			local newAlert = {
				["type"]	= 'potionReady',
				["name"]	= 'Potion Ready',
				["value"]	= '',
				["ms"]		= GetGameTimeMilliseconds(),
				["color"]	= 'cffcc00',
				["size"]	= 20
			}
			FTC.SCT:NewStatus( newAlert )
		end
		FTC.Buffs.lastPotion = 0
	end	
	
	-- Bail if the potion isn't freshly used
	if ( cd < 10000 ) then return end

	-- If our cooldown has just increased, it implies a potion usage
	if ( cd > FTC.Buffs.lastPotion ) then
	
		-- Make sure it's a potion
		local name 		= string.lower( GetSlotName(current) )
		local keys		= { "health" , "stamina" , "magicka" , "weapon power" , "weapon critical" , "spell critical" , "spell power" }
		local isPotion 	= false
		for i = 1 , #keys do
			if ( string.find( name , keys[i] ) ) then 
				isPotion = true 
				break
			end
		end
		if ( not isPotion ) then return end
	
		-- Get the current potion
		local potion		= {
			["slot"]		= current,
			["name"]		= name,
			["type"]		= 'potion',
			["cost"]		= 0,
			["tex"]			= GetSlotTexture( current ),
			["effects"]		= {	{ 1 , BUFF_EFFECT_TYPE_BUFF , 10 , false , nil } },
		}
		
		-- Submit the effect
		FTC.Buffs:NewEffects( potion )
	end

	-- Fire a callback when we know a spell was cast
	CALLBACK_MANAGER:FireCallbacks( "FTC_PotionUsed" , potion )
	
	-- Save the potion CD
	FTC.Buffs.lastPotion = cd
end


--[[----------------------------------------------------------
	HELPER FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Sort the buff array to show effects that are expiring soonest first
 * Called by Buffs:Update()
 ]]--
function FTC.Buffs.Sort(x,y)
	if ( x.dur == "P" or x.dur == "T" or x.dur == "S" ) then return false 
	elseif ( y.dur == "P" or y.dur == "T" or y.dur == "S" ) then return true
	else return x.ends < y.ends end
end

--[[ 
 * Clear any remaining unused buff icons
 * Called by Buffs:Update()
 ]]--
function FTC.Buffs:ClearIcons( context , buffCount , debuffCount , longCount )

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
 * Process new ability buff effects
 * Called by Buffs:CheckCast()
 ]]--
function FTC.Buffs:NewEffects( ability )
	
	-- Process new effects
	local effects = ability.effects
	if ( effects ~= nil ) then
		for e = 1 , #effects do
		
			-- Get some data
			local target 		= effects[e][1]
			local effectType 	= effects[e][2]
			local duration		= effects[e][3]
			local reqTarget		= effects[e][4]
			local castTime		= effects[e][5] or 0
			
			-- Get the time
			local ms = GetGameTimeMilliseconds()
		
			-- Construct the buff object
			local newBuff = {
				["target"]	= FTC.Target.name,
				["name"]	= ability.name,
				["area"]	= not reqTarget,
				["begin"]	= ms / 1000 + castTime,
				["ends"]	= ( ms / 1000 ) + castTime + duration,
				["debuff"]	= effectType == BUFF_EFFECT_TYPE_DEBUFF,
				["stacks"]	= 0,
				["icon"]	= ability.tex,
			}
			
			-- Add it to the appropriate table
			local context	= ( target == 1 ) and "Player" or "Target"
			FTC.Buffs[context][ability.name] = newBuff

			-- Saved targetted buffs for later
			if ( target == 2 ) then FTC.Buffs.Saved[ability.name] = newBuff end
		end
	end
end