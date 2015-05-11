 
--[[----------------------------------------------------------
    SCROLLING COMBAT TEXT COMPONENT
  ]]----------------------------------------------------------

FTC.SCT = {}
FTC.SCT.Defaults = {
	["SCTCount"]                = 20,
	["SCTSpeed"]                = 3,
	--["SCTNames"]                = true,
	--["SCTPath"]                 = 'Arc',
	["FTC_SCTOut"]       		= {RIGHT,CENTER,-200,-50},
	--["FTC_SCTIn"]        		= {TOP,FTC_UI,TOP,450,80},
	--["FTC_SCTStatus"]    		= {TOP,FTC_UI,TOP,0,80},
}
FTC:JoinTables(FTC.Defaults,FTC.SCT.Defaults)

--[[----------------------------------------------------------
    SCT FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Initialize SCT Component
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--
function FTC.SCT:Initialize()

	-- Setup tables
	FTC.SCT.In		= {}
	FTC.SCT.Out		= {}
	FTC.SCT.Status	= {}
	
	-- Save tiny AP gains
	--FTC.SCT.backAP	= 0
	
	-- Create controls
	FTC.SCT:Controls()
	
	-- Register init status
	FTC.init.SCT = true

    -- Activate updating
    EVENT_MANAGER:RegisterForUpdate( "FTC_SCTOut" , 10 , function() FTC.SCT:Update('Out') end )
end


--[[----------------------------------------------------------
	EVENT HANDLERS
 ]]-----------------------------------------------------------

--[[ 
 * Process new combat events passed from the combat event handler
 * Called by FTC.Damage:New() if the damage is approved
 ]]--
function FTC.SCT:New( damage )

	-- Bail if nothing was passed
	if ( damage == nil ) then return end

	-- Determine context
	local context = ( damage.out ) and "Out" or "In"
	local container	= _G["FTC_SCT"..context]
	
	-- If the table is empty, go ahead and insert the new entry
	if ( #FTC.SCT[context] == 0 ) then 

		-- Assign SCT to control from pool
        local control, objectKey = FTC.SCT.SCTPool:AcquireObject()
        control:ClearAnchors()
        control:SetParent(container)
        control.id = objectKey

        -- Add the damage to the table
        damage.control = control
		table.insert( FTC.SCT[context] , damage )

	-- Otherwise ALSO insert for now
	else 

		-- Assign SCT to control from pool
        local control, objectKey = FTC.SCT.SCTPool:AcquireObject()
        control:ClearAnchors()
        control:SetParent(container)
        control.id = objectKey

        -- Add the damage to the table
        damage.control = control
		table.insert( FTC.SCT[context] , damage ) 
	end

	--[[
	
	-- Loop through each existing combat entry
	local oldest 	= 1
	local isNew		= true
	for i = 1, #damages do
	
		-- If an identical entry already exists, do a multiplier instead of a new entry
		if ( ( damages[i].name == newSCT.name ) and ( damages[i].heal == newSCT.heal ) and ( math.abs( damages[i].ms - newSCT.ms ) < 500 ) ) then
			
			-- If the damage is higher, replace it
			if ( newSCT.dam > damages[i].dam ) then 
				FTC.SCT[context][i] = newSCT
			end
			
			-- Increment the multiplier, and bail
			FTC.SCT[context][i].multi = FTC.SCT[context][i].multi + 1
			isNew = false
			break
		
		-- Otherwise flag the oldest entry for recycling
		else oldest = FTC.SCT[context][i].ms < FTC.SCT[context][oldest].ms and i or oldest	end
	end
	
	-- Process new damage entries
	if ( isNew ) then
	
		-- If there are fewer than the maximum number of events recorded, insert it directly
		if ( #damages < FTC.vars.SCTCount ) then table.insert( FTC.SCT[context] , newSCT)
		
		-- Otherwise, recycle the oldest entry
		else FTC.SCT[context][oldest] = newSCT end
	end
	
	-- Next, allocate combat entries to controls
	for i = 1, FTC.vars.SCTCount do
		
		-- Add the damage to controls
		local container = _G["FTC_SCT"..context..i]
		if ( FTC.SCT[context][i] ~= nil ) then
			container.damage = FTC.SCT[context][i]
		
		-- Purge unused controls
		else container.damage = {}	end
	end	
	]]--
end


--[[----------------------------------------------------------
	UPDATING FUNCTIONS
 ]]-----------------------------------------------------------

--[[ 
 * Updates Scrolling Combat Text for both incoming and outgoing damage
 * Runs every frame OnUpdate
 ]]--
function FTC.SCT:Update(context)

	-- Get the SCT UI element
	local parent  = _G["FTC_SCT"..context]
	local Damages = FTC.SCT[context]

	-- Bail if no damage is present
	if ( #Damages == 0 ) then return end
	
	-- Get the game time
	local ms = GetGameTimeMilliseconds()
	
	-- Traverse damage table back-to-front
	for i = #Damages,1,-1 do

		-- Get the control and it's damage value
		local damage	= Damages[i]
		local control 	= damage.control

		-- Compute the animation duration ( speed = 10 -> 0.5 second, speed = 1 -> 5 seconds )
		local lifespan	= ( ms - damage.ms ) / 1000
		local duration	= ( 11 - FTC.Vars.SCTSpeed ) / 2

		-- Purge expired damages
		if ( lifespan > duration ) then
            table.remove(FTC.SCT[context],i) 
            FTC.SCT.SCTPool:ReleaseObject(control.id)

        -- Otherwise go ahead
    	else 

			-- Get the starting offsets
			local height	= parent:GetHeight()
			local width		= parent:GetWidth()
			local offsetX 	= 0			
			local offsetY	= ( -1 * height ) * ( lifespan / duration )	

			-- Set the label for now
			control.name:SetText(zo_strformat("<<!aC:1>>",damage.ability))
			control:SetHidden(false)

			-- Adjust the position
			control:SetAnchor(BOTTOM,parent,BOTTOM,offsetX,offsetY)

		
		--[[


			
			-- If the animation has finished, hide the container
			if ( lifespan > duration ) then 
				container:SetHidden( true )
			
			-- Otherwise, we're good to go!
			else
			
				-- Get some values
				local dam	= damage.dam
				local name	= damage.name

				-- Set default appearance
				local font	= FTC.Fonts.meta(16)
				local alpha = 0.8

				-- Flag critical hits
				if ( damage.crit == true ) then
					dam 	= "*" .. dam .. "*"
					font	= FTC.Fonts.meta(18)
					alpha	= 1
				end
				
				-- Flag blocked damage
				if ( damage.result == ACTION_RESULT_BLOCKED_DAMAGE ) then
					dam		= "|c990000(" .. dam .. ")|"
				
				-- Flag damage immunity
				elseif ( damage.result == ACTION_RESULT_IMMUNE ) then
					dam		= "|c990000(Immune)|"
					
				-- Dodges
				elseif ( damage.result == ACTION_RESULT_DODGED ) then
					dam		= "|c990000(Dodge)|"
					
				-- Misses
				elseif ( damage.result == ACTION_RESULT_MISS ) then
					dam		= "|c990000(Miss)|"
				
				-- Flag heals
				elseif( damage.heal == true ) then
					dam = "|c99DD93" .. dam .. "|"
					if string.match( damage.name , "Potion" ) then damage.name = "Health Potion" end
				
				-- Magic damage
				elseif ( damage.type ~= DAMAGE_TYPE_PHYSICAL	) then
					dam = ( context == "Out" ) and "|c336699" .. dam .. "|" or "|c990000" .. dam .. "|"
				
				-- Standard hits
				else
					dam = ( context == "Out" ) and "|cAA9F83" .. dam .. "|" or "|c990000" .. dam .. "|"
				end
				
				-- Maybe add the ability name
				if ( FTC.vars.SCTNames ) then
					dam = dam .. "   " .. name
				end
				
				-- Add the multiplier
				if ( damage.multi and damage.multi > 1 ) then
					dam = dam .. " (x" .. damage.multi .. ")"
				end
				
				-- Update the damage
				container:SetHidden(false)
				container:SetFont( font )
				container:SetAlpha( alpha )
				container:SetText( dam )

				
				-- Horizontal arcing
				if ( FTC.vars.SCTPath == 'Arc' ) then
					local ease		= lifespan / duration
					offsetX			= 100 * ( ( 4 * ease * ease ) - ( 4 * ease ) + 1 )
					offsetX			= ( context == "Out" ) and offsetX or -1 * offsetX
				end
			end
			]]--
		end
	end
end