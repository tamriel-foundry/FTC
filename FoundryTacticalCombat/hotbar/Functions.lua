 
--[[----------------------------------------------------------
    ADVANCED HOTBAR COMPONENT
  ]]----------------------------------------------------------

FTC.Hotbar = {}
FTC.Hotbar.Defaults = {}

--[[----------------------------------------------------------
    ADVANCED HOTBAR FUNCTIONS
  ]]----------------------------------------------------------

--[[ 
 * Initialize Unit Frames Component
 * --------------------------------
 * Called by FTC:Initialize()
 * --------------------------------
 ]]--
function FTC.Hotbar:Initialize()
    if ( FTC.Vars.EnableHotbar ) then 

        -- Create UI elements
        FTC.Hotbar:Controls()
        
        -- Register init status
        FTC.init.Hotbar = true
        
        -- Populate ultimate
        FTC.Hotbar:UpdateUltimate( FTC.Player.ultimate.current  , FTC.Player.ultimate.max , FTC.Player.ultimate.max )
    end
end

--[[----------------------------------------------------------
    ULTIMATE TRACKING
  ]]-----------------------------------------------------------
 
 --[[ 
 * Update Ultimate Meter
 * --------------------------------
 * Called by FTC.OnPowerUpdate()
 * --------------------------------
 ]]--
function FTC.Hotbar:UpdateUltimate( powerValue , powerMax , powerEffectiveMax )
        
    -- Get the ability button
    parent = _G["ActionButton8"]
    
    -- Get the currently slotted ultimate cost
    cost, mechType = GetSlotAbilityCost(8)
    
    -- Calculate the percentage to activation
    local pct = ( cost > 0 ) and math.floor( ( powerValue / cost ) * 100 ) or 0
    
    -- Update the tooltip
    FTC_UltimatePct:SetText( pct .. "%")
    FTC_UltimateLevel:SetText( powerValue .. "/" .. cost )
    
    -- Maybe fire an alert
    if ( FTC.init.SCT ) then
    
        -- Get the former value
        local prior = FTC.Player.ultimate.pct
        
        -- If we just reached full ulti, alert!
        if ( pct >= 100 and prior < 100 ) then
            local newAlert = {
                ["type"]    = 'ulti',
                ["name"]    = 'Ultimate Ready',
                ["value"]   = '',
                ["ms"]      = GetGameTimeMilliseconds(),
                ["color"]   = 'c99FFFF',
                ["size"]    = 20
            }
            FTC.SCT:NewStatus( newAlert )
        end
    end
    
    -- Update the database object
    FTC.Player.ultimate = { ["current"] = powerValue , ["max"] = powerEffectiveMax , ["pct"] = pct }
end
