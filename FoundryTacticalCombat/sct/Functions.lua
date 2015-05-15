
--[[----------------------------------------------------------
    SCROLLING COMBAT TEXT COMPONENT
  ]]----------------------------------------------------------

    FTC.SCT = {}
    FTC.SCT.Defaults = {

        -- Display Options
        ["SCTIcons"]                = true,
        ["SCTNames"]                = true,
        ["SCTSpeed"]                = 6,
        ["SCTArc"]                  = 6,

        -- Fonts
        ["SCTFont1"]                = 'esobold',
        ["SCTFont2"]                = 'esobold',
        ["SCTFontSize"]             = 24,

        -- Anchors
        ["FTC_SCTOut"]              = {RIGHT,CENTER,-300,-50},
        ["FTC_SCTIn"]               = {LEFT,CENTER,300,-50},

        
        --["FTC_SCTStatus"]         = {TOP,FTC_UI,TOP,0,80},


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
        FTC.SCT.In      = {}
        FTC.SCT.Out     = {}
        FTC.SCT.Status  = {}

        -- Alterante objects
        FTC.SCT.count   = 1
        
        -- Save tiny AP gains
        --FTC.SCT.backAP    = 0
        
        -- Create controls
        FTC.SCT:Controls()
        
        -- Register init status
        FTC.init.SCT = true

        -- Activate updating
        EVENT_MANAGER:RegisterForUpdate( "FTC_SCTOut" , nil , function() FTC.SCT:Update('Out') end )
        EVENT_MANAGER:RegisterForUpdate( "FTC_SCTIn" , nil , function() FTC.SCT:Update('In') end )
    end


--[[----------------------------------------------------------
    EVENT HANDLERS
 ]]-----------------------------------------------------------

    --[[ 
     * Process new SCT damage events
     * --------------------------------
     * Called by FTC.Damage:New()
     * --------------------------------
     ]]--
    function FTC.SCT:Damage( damage )

        -- Bail if nothing was passed
        if ( damage == nil ) then return end

        -- Determine context
        local context = ( damage.out ) and "Out" or "In"
        local container = _G["FTC_SCT"..context]

        -- Otherwise, see if there is an existing event to fold into
        local isNew = true
        if ( #FTC.SCT[context] ~= 0 ) then
            for i = 1, #FTC.SCT[context] do

                -- Identical damage must have the same result, name, heal status, crit status, and approximate timestamp
                local dam = FTC.SCT[context][i]
                if ( ( damage.result == dam.result ) and ( damage.ability == dam.ability ) and ( dam.heal == damage.heal ) and ( dam.crit == damage.crit ) and ( math.abs( dam.ms - damage.ms ) <= 500 ) ) then

                    -- Add the multiplier
                    local mult = FTC.SCT[context][i].mult + 1
                    FTC.SCT[context][i].mult = mult

                    -- Update labels
                    local value = ( damage.value >= 1000 ) and zo_roundToNearest( damage.value / 1000 , 0.1 ) .. "k" or damage.value
                    dam.control.value:SetText(value .. " [x" .. mult .. "]")
                    
                    -- Bail out
                    isNew = false
                    break
                end
            end
        end

        -- Create controls for new damages
        if ( isNew ) then

            -- Assign SCT to control from pool
            local pool = FTC.SCT[context.."Pool"]
            local control, objectKey = pool:AcquireObject()
            control:ClearAnchors()
            control:SetParent(container)
            control.id = objectKey

            -- Compute starting offsets
            local  offsets = {}
            if     ( FTC.SCT.count == 1 )   then offsets = {0,-50} 
            elseif ( FTC.SCT.count == 2 )   then offsets = {100,0}
            elseif ( FTC.SCT.count == 3 )   then offsets = {0,50}
            elseif ( FTC.SCT.count == 4 )   then offsets = {-100,0} end
            control.offsetX , control.offsetY = unpack(offsets)
            control:SetDrawTier( FTC.SCT.count % 2 == 0 and DT_MEDIUM or DT_LOW )
            FTC.SCT.count = ( FTC.SCT.count % 4 == 0 ) and 1 or FTC.SCT.count + 1

            -- Determine labels
            local value = ( damage.value >= 1000 ) and zo_roundToNearest( damage.value / 1000 , 0.1 ) .. "k" or damage.value
            local size  = ( damage.crit ) and FTC.Vars.SCTFontSize + 4 or FTC.Vars.SCTFontSize
            local name  = zo_strformat("<<!aC:1>>",damage.ability)

            -- Determine color
            local color = {206/255,027/255,020/255}
            if ( damage.heal ) then color = {080/255,160/255,065/255}
            elseif ( damage.weapon ) then color = {0.9,0.9,0.9}
            elseif ( damage.out and damage.type ~= DAMAGE_TYPE_PHYSICAL and damage.type ~= DAMAGE_TYPE_GENERIC and damage.type ~= DAMAGE_TYPE_NONE ) then color = {0.2,0.4,0.6}
            elseif ( damage.out ) then color = {0.7,0.5,0.2} end

            -- Override shield absorbs
            if ( damage.result == ACTION_RESULT_DAMAGE_SHIELDED ) then 
                name    = zo_strformat("<<!aC:1>>",GetAbilityName(30869))
                color   = {0.4,0,0.6}
                damage.icon = FTC.UI.Textures[GetAbilityName(30869)]

            -- Override blocks
            elseif ( damage.result == ACTION_RESULT_BLOCKED_DAMAGE ) then
                name    = zo_strformat("<<!aC:1>>",GetAbilityName(2890))
                color   = {0.6,0.1,0}
                damage.icon = FTC.UI.Textures[GetAbilityName(2890)]

            -- Override misses and dodges
            elseif ( damage.result == ACTION_RESULT_DODGED or damage.result == ACTION_RESULT_MISS ) then
                name    = zo_strformat("<<!aC:1>>",GetAbilityName(30934))
                color   = {0.2,0.2,0.8}
                damage.icon = FTC.UI.Textures[GetAbilityName(30934)]
            end

            -- Assign data to the control
            control.value:SetText(value)
            control.value:SetFont(FTC.UI:Font(FTC.Vars.SCTFont1,size+8,true))
            control.value:SetColor(unpack(color))

            -- Maybe display names
            if ( FTC.Vars.SCTNames ) then 
                control.name:SetText(name)
                control.name:SetFont(FTC.UI:Font(FTC.Vars.SCTFont2,size,true))
                control.name:SetColor(unpack(color))
            else control.name:SetText("") end

            -- Maybe display icons
            control.icon:SetTexture(damage.icon)
            control.bg:SetHidden(not FTC.Vars.SCTIcons)
            control.icon:SetHidden(not FTC.Vars.SCTIcons)
            control.frame:SetHidden(not FTC.Vars.SCTIcons)

            -- Display the control, but start faded
            control:SetHidden(false)
            control:SetAlpha(0)

            -- Add the damage to the table
            damage.control = control
            table.insert( FTC.SCT[context] , damage ) 

            -- Start fade animation
            FTC.SCT:Fade(control)
        end
    end

--[[----------------------------------------------------------
    UPDATING FUNCTIONS
 ]]-----------------------------------------------------------

    --[[ 
     * Render Scrolling Combat Text
     * --------------------------------
     * Called by FTC.SCT:Initialize()
     * --------------------------------
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
            local damage    = Damages[i]
            local control   = damage.control

            -- Compute the animation duration ( speed = 10 -> 1.5 seconds, speed = 1 -> 6 seconds )
            local lifespan  = ( ms - damage.ms ) / 1000
            local speed     = ( ( 11 - FTC.Vars.SCTSpeed ) / 2 ) + 1
            local remaining = ( lifespan + (speed * 0.2 )) / speed

            -- Purge expired damages
            if ( lifespan > speed * 0.8 ) then
                table.remove(FTC.SCT[context],i) 
                local pool = FTC.SCT[context.."Pool"]
                pool:ReleaseObject(control.id)

            -- Otherwise go ahead
            else 

                -- Get the starting offsets
                local height    = parent:GetHeight()
                local width     = parent:GetWidth()
                local offsetX   = control.offsetX           
                local offsetY   = control.offsetY + ( -1 * height ) * remaining

                -- Horizontal arcing ( arc = 10 -> 500  arc = 0 -> 0 )
                if ( true ) then
                    local arc       = ( FTC.Vars.SCTArc*50) * ( ( 4 * remaining * remaining ) - ( 4 * remaining ) + 1 ) 
                    offsetX         = ( damage.out ) and offsetX + arc or offsetX - arc
                end

                -- Adjust the position
                control:SetAnchor(BOTTOM,parent,BOTTOM,offsetX,offsetY)
            end
        end
    end