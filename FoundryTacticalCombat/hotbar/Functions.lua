 
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
 
