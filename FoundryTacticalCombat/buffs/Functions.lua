
--[[----------------------------------------------------------
    BUFF TRACKING COMPONENT
  ]]----------------------------------------------------------
FTC.Buffs = {}
FTC.Buffs.Defaults = {

	-- Player Buffs
    ["FTC_PlayerBuffs"]         = {CENTER,CENTER,0,400},
    ["EnableLongBuffs"]         = true,
    ["FTC_LongBuffs"]           = {BOTTOMRIGHT,BOTTOMRIGHT,-5,-5},

	-- Player Debuffs
    ["FTC_PlayerDebuffs"]       = {CENTER,CENTER,0,500},

	-- Target Buffs
    ["FTC_TargetBuffs"]         = {CENTER,CENTER,0,-500},

	-- Target Debuffs
    ["FTC_TargetDebuffs"]       = {CENTER,CENTER,0,-400},

	-- Shared Settings
    ["AnchorBuffs"]             = true,	
    ["MaxBuffs"]                = 10,
}
FTC.JoinTables(FTC.Defaults,FTC.Buffs.Defaults)

--[[----------------------------------------------------------
    BUFF TRACKING FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Initialize Buff Tracking Component
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--
function FTC.Buffs.Initialize()

	-- Setup displayed buff tables
	FTC.Buffs.Player = {}
	FTC.Buffs.Target = {}
	
	-- Saved effects
	FTC.Buffs.Saved	 = {}
	
	-- Create the controls
	FTC.Buffs:Controls()

	-- Populate initial buffs
	FTC.Buffs:GetBuffs('player')

	-- Setup action bar hooks
	FTC.Buffs:SetupActionBar()
	
	-- Setup status flags
	FTC.Buffs.lastCast  = 0
	FTC.Buffs.canPotion = true
	
	-- Register init status
	FTC.init.Buffs = true

	-- Activate uldating
	EVENT_MANAGER:RegisterForUpdate( "FTC_PlayerBuffs" , 5000 , function() FTC.Buffs:Update("Player") end )
	--EVENT_MANAGER:RegisterForUpdate( "FTC_TargetBuffs" , 5000 , function() FTC.Buffs:Update("Target") end )
end

--[[ 
 * Setup Action Bar to Report Casts
 * --------------------------------
 * Called by FTC.Buffs:Initialize()
 * Credit goes to Spellbuilder for the clever idea!
 * --------------------------------
 ]]--
function FTC.Buffs:SetupActionBar()

	-- Store the original action button SetState function
	FTC.Buffs.SetStateOrig = ActionButton3Button.SetState

	-- Replace the SetState method for each action button with my custom function
	for i = 3 , 8 do
		local button 	= _G["ActionButton"..i.."Button"]
		button.SetState = FTC.Buffs.SetStateCustom
	end
end

--[[ 
 * Custom Action Button SetState Function
 * --------------------------------
 * Called by FTC.Buffs:SetupActionBar()
 * --------------------------------
 ]]--
function FTC.Buffs.SetStateCustom( self , state , locked )

	-- Get the original function return
	local retval = FTC.Buffs.SetStateOrig( self , state , locked )

	-- Get the pressed slot
	local slot = self.slotNum

	-- Get the used ability
	local ability = FTC.Player.Abilities[slot]

	-- Bail if the ability is unrecognized
	if ( ability == nil ) then return retval end

	-- The button is being depressed
	if ( state == BSTATE_PRESSED ) then

		-- Store the pressed status
		FTC.Player.Abilities[slot].isPressed = true

		-- Clear any pending ground target
		if ( FTC.Buffs.pendingGT ~= nil and FTC.Buffs.pendingGT.name == ability.name ) then FTC.Buffs.pendingGT = nil end

	-- The button is being released
	elseif ( state == BSTATE_NORMAL ) then

		-- Get the time
		local time = GetGameTimeMilliseconds()

		-- Avoid erroneous detection, skill failure, and spamming
		if ( FTC.Buffs:HasFailure(slot) or ( not FTC.Player.Abilities[slot].isPressed ) or ( time < ( FTC.Player.Abilities[slot].lastCast or 0 ) + 500 ) ) then return retval end

		-- Put ground target abilities into the pending queue
		if ( ability.ground ) then 
			FTC.Buffs.pendingGT = ability
			return retval
		end
		
		-- Fire a callback to hook extensions
		CALLBACK_MANAGER:FireCallbacks( "FTC_SpellCast" , ability )

		-- Register the new effect
		FTC.Buffs:NewEffect( ability )

		-- Flag the last cast time
		FTC.Player.Abilities[slot].lastCast = time	
	end

	-- Return the original function
	return retval
end

--[[----------------------------------------------------------
	EVENT HANDLERS
  ]]----------------------------------------------------------

--[[ 
 * Get Unit Buffs
 * --------------------------------
 * Called by FTC.Buffs:Initialize()
 * Called by FTC.OnTargetChanged()
 * Called by FTC.OnEffectChanged()
 * --------------------------------
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
	local nbuffs = GetNumBuffs( unitTag )
	
	-- Bail if the target has no buffs
	if ( nbuffs == 0 ) then return end
	
	-- Iterate through buffs, adding them to the active buffs table
	for i = 1 , nbuffs do
	
		-- Get the buff information
		local effectName, beginTime, endTime, effectSlot, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, longTerm = GetUnitBuffInfo( unitTag , i )
		
		-- Run the effect through a filter
		isValid, effectName, effectDuration , beginTime , endTime , iconName = FTC:FilterBuffInfo( changeType , unitTag , effectName , abilityType , beginTime , endTime , iconName )
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

	d(FTC.Buffs.Player)
end

--[[ 
 * Register New Buffs
 * --------------------------------
 * Called by FTC.Buffs.SetStateCustom()
 * Called by FTC.OnTargetChanged()
 * Called by FTC.OnEffectChanged()
 * --------------------------------
 ]]--
function FTC.Buffs:NewEffect( ability )

	-- Get the time
	local ms = GetGameTimeMilliseconds()
	
	-- Try manually tracked effects first
	local effects = ability.effects
	if ( effects ~= nil ) then

		-- Get data
		local castTime	= ( ability.cast ~= nil and ability.cast > 0 ) and ability.cast or ( effects[3] or 0 ) * 1000

		-- Register Buffs
		if ( effects[1] > 0 ) then

			-- Setup Buff Object
			local newBuff   = {
				["target"]	= FTC.Target.name,
				["name"]	= ability.name,
				["area"]	= true,
				["begin"]	= ( ms + castTime ) / 1000,
				["ends"]	= ( ( ms + castTime ) / 1000 ) + effects[1],
				["debuff"]	= false,
				["stacks"]	= 0,
				["icon"]	= ability.tex,
			}

			-- Register buff
			FTC.Buffs["Player"][ability.name] = newBuff
		end	

		-- Register Debuffs
		if ( effects[2] > 0 ) then

			-- Setup Buff Object
			local newBuff   = {
				["target"]	= FTC.Target.name,
				["name"]	= ability.name,
				["area"]	= true,
				["begin"]	= ( ms + castTime ) / 1000,
				["ends"]	= ( ( ms + castTime ) / 1000 ) + effects[2],
				["debuff"]	= true,
				["stacks"]	= 0,
				["icon"]	= ability.tex,
			}

			-- Register buff
			FTC.Buffs["Target"][ability.name] = newBuff

			-- Save targetted buffs
			FTC.Buffs.Saved[ability.name] = newBuff
		end	

	-- Next go with API reported player buffs
	elseif ( ability.dur > 0 ) then
		
		-- Construct the buff object
		local newBuff   = {
			["target"]	= FTC.Target.name,
			["name"]	= ability.name,
			["area"]	= true,
			["begin"]	= ( ms + ability.cast ) / 1000,
			["ends"]	= ( ms + ability.cast + ability.dur ) / 1000,
			["debuff"]	= false,
			["stacks"]	= 0,
			["icon"]	= ability.tex,
		}

		-- Add it to the player table
		FTC.Buffs["Player"][ability.name] = newBuff
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
	isValid, effectName, effectDuration , beginTime , endTime , iconName = FTC:FilterBuffInfo( changeType , unitTag , effectName , abilityType , beginTime , endTime )
		
	-- Remove the buff
	if ( isValid ) then FTC.Buffs[context][effectName] = nil end
end





--[[----------------------------------------------------------
    HELPER FUNCTIONS
  ]]----------------------------------------------------------








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



--[[----------------------------------------------------------
    UPDATING FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Display buffs and debuffs based on context
 * Argument "context" takes {Player,Target}
 * Runs OnUpdate - 10 ms buffer
 ]]--
function FTC.Buffs:Update( context )

	-- Get data
	local buffs 		= ( context == "Player" ) and FTC.Buffs.Player or FTC.Buffs.Target
		
	-- Hide target buffs if the target frame isn't shown
	if ( context == "Target" and FTC.init.Frames and FTC_TargetFrame:IsHidden() ) then FTC_TargetBuffs:SetHidden(true) end
	
	-- If no buffs are present, clear icons and bail out
	if ( next(buffs) == nil ) then
		--FTC.Buffs:ClearIcons(context,1,1,1)
		return
	end

	-- Convert the buffs table to an indexed array
	local buffs = {}
	for k,v in pairs( FTC.Buffs[context] ) do table.insert( buffs , v ) end
	table.sort( buffs , FTC.Buffs.Sort )	

	-- Track counters
	local gameTime		= GetGameTimeMilliseconds() / 1000
	local buffCount 	= 1
	local debuffCount	= 1
	local longCount 	= 1

	-- Loop through buffs
	for i = 1 , #buffs do
	
		-- Bail out if we have already rendered the maximum allowable buffs
		local isCapped = ( buffCount > FTC.Vars.MaxBuffs ) and ( debuffCount > FTC.Vars.MaxBuffs ) and ( ( context == "Player" and longCount > FTC.Vars.MaxBuffs ) or context == "Target" )
		if ( isCapped ) then break end
	
		-- Gether data
		local name		= buffs[i].name
		local isLong	= context == "Player" and tonumber(buffs[i].dur) == nil
		local label		= buffs[i].dur
		local render	= true
		local control	= buffs[i].control
		
		-- Flag abilities which have not begun yet
		if ( buffs[i].begin > gameTime ) then render = false end

		-- Compute timed abilities
		if ( buffs[i].dur == nil or tonumber(buffs[i].dur) ~= nil ) then 
			local duration 	= math.floor( ( buffs[i].ends - gameTime ) * 10 ) / 10 

			-- Expire abilities
			if ( duration <= 0 ) then
				FTC.Buffs.Pool:ReleaseObject(control)
				FTC.Buffs[context][name] = nil 
			end

			-- Flag long buffs
			isLong = ( context == "Player" and duration >= 60 ) and true or isLong
				
			-- Duration in hours
			if ( duration > 3600 ) then
				local hours 	= math.floor( duration / 3600 )
				label			= string.format( "%dh" , hours )
			
			-- Duration in minutes
			elseif ( duration > 60 ) then	
				local minutes 	= math.floor( duration / 60 )
				label			= string.format( "%dm" , minutes )
			
			-- Duration in seconds
			else label = string.format( "%.1f" , duration )	end
		end
		
		-- Does the buff already have a control assigned?


		-- If not, acquire a new control from the pool



		-- Target the appropriate container
		local buffType 		= buffs[i].debuff and "Debuffs" or "Buffs"
		local container		= isLong and "LongBuffs" or context .. buffDebuff


		-- Request a control from the pool
		--local buff			= FTC.Buffs.Pool:AcquireObject()
		
		--[[
		-- Get the UI elements
		local buff			= _G["FTC_"..container.."_"..count]
		local newlabel 		= _G["FTC_"..container.."_"..count.."_Label"]
		local newicon		= _G["FTC_"..container.."_"..count.."_Icon"]		
		local cooldown		= _G["FTC_"..container.."_"..count.."_CD"]
			
			-- Update the display
			newlabel:SetText(label)
			newicon:SetTexture(buffs[i].icon)
			cooldown:StartCooldown( ( buffs[i].ends - gameTime ) * 1000 , ( buffs[i].ends - buffs[i].begin ) * 1000 , CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_UNTIL, false )
			buff:SetHidden(false)
				
			-- Update the count
			if isLong then longCount = longCount + 1
			elseif buffs[i].debuff then	debuffCount = debuffCount + 1
			else buffCount = buffCount + 1 end
		end
		]]--
	end

	-- Resize the long buff window
	if ( context == "Player" ) then
		--FTC_LongBuffs:SetHeight( 40 * ( longCount - 1 ) )
	end

	-- After looping through buffs, do clear any remaining buff icons
	--FTC.Buffs:ClearIcons( context , buffCount , debuffCount , longCount ) 
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
	local cd, dur , usable = GetSlotCooldownInfo(current)
	
	-- Trigger an alert if the potion has just become available
	if ( usable and not FTC.Buffs.canPotion ) then
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
	end

	-- If the potion goes on cooldown, display a new alert
	if ( FTC.Buffs.canPotion and cd > 5000 ) then
	
		-- Make sure it's a potion
		local name 		= string.lower( GetSlotName(current) )
		local keys		= { "sip" , "tincture" , "dram" , "potion" , "solution" , "elixir" , "panacea" }
		local isPotion 	= false
		for i = 1 , #keys do
			if ( string.find( name , keys[i] ) ) then 
				isPotion = true 
				break	
			end
		end
		if ( not isPotion ) then return end

		-- Translate the time to seconds
		local time = cd / 1000

		-- Get the current potion
		local potion		= {
			["slot"]		= current,
			["name"]		= name,
			["type"]		= 'potion',
			["tex"]			= GetSlotTexture( current ),
			["effects"]		= { time , 0 , 0 },
		}
		
		-- Submit the effect
		--FTC.Buffs:NewEffects( potion )
	end

	-- Update the potion status
	FTC.Buffs.canPotion = usable

	-- Fire a callback when we know a spell was cast
	CALLBACK_MANAGER:FireCallbacks( "FTC_PotionUsed" , potion )
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
	for i = buffCount, FTC.Vars.MaxBuffs do
		local buff	= _G["FTC_"..context.."Buffs_"..buffCount]
		buff:SetHidden(true)
		buffCount = buffCount + 1
	end
	
	-- Clear the unused debuffs
	for i = debuffCount, FTC.Vars.MaxBuffs do
		local buff	= _G["FTC_"..context.."Debuffs_"..debuffCount]
		buff:SetHidden(true)
		debuffCount = debuffCount + 1
	end
	
	-- Maybe clear long buffs
	if ( context == "Player" ) then
		for i = longCount, FTC.Vars.MaxBuffs do
			local buff	= _G["FTC_LongBuffs_"..longCount]
			buff:SetHidden(true)
			longCount = longCount + 1
		end	
	end
end
