 
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
            
            -- Load starting ultimate
            FTC.Player:UpdateUltimate( FTC.Player.ultimate.current , FTC.Player.ultimate.max , FTC.Player.ultimate.max )

            -- Start updating potion CD
            EVENT_MANAGER:RegisterForUpdate( "FTC_PotionCD" , 100 , function() FTC.Hotbar:UpdatePotion() end )
        end
    end

--[[----------------------------------------------------------
    ULTIMATE TRACKING
  ]]----------------------------------------------------------
     
    function FTC.Hotbar:UpdateUltimate( current , cost , pct )
        FTC_UltimateLevel:SetText( current .. "/" .. cost )
        FTC_UltimatePct:SetText( (pct*100) .."%" )
    end 


    function FTC.Hotbar:UltimateBuff( damage )

        -- Bail if it's not a correct trigger
        if ( ( not damage.out ) and damage.result == ACTION_RESULT_BLOCKED_DAMAGE ) or ( damage.out and damage.weapon and ( not FTC:IsCritter('reticleover') ) and (damage.ability ~= GetAbilityName(4858) )) then
            FTC.Hotbar:UltiFade()
        end
    end

--[[----------------------------------------------------------
    POTION TRACKING
  ]]----------------------------------------------------------

    --[[ 
     * Track Potion Cooldown
     * --------------------------------
     * Called by FTC.Hotbar:Initialize()
     * --------------------------------
     ]]--
    function FTC.Hotbar:UpdatePotion()
        local label = _G["FTC_PotionCD"]

        -- Get the potion cooldown
        local remain, duration, global = GetSlotCooldownInfo(GetCurrentQuickslot())

        -- Global cooldown
        if ( global and duration == 1000 ) then return end
 
        -- No cooldown
        if ( remain == 0 ) then 
            label:SetHidden(true)
            return
        end

        -- On cooldown
        label:SetText( FTC.DisplayNumber( remain/1000 , 1 ) )
        label:SetHidden(false)
    end