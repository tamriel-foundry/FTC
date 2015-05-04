    
--[[----------------------------------------------------------
	ADVANCED HOTBAR CONTROLS
  ]]-----------------------------------------------------------  

function FTC.Hotbar:Controls()
    if ( FTC.Vars.EnableHotbar ) then
        local ultival       = FTC.UI:Label( "FTC_UltimateLevel" , ActionButton8 , {100,20} , {BOTTOM,TOP,0,-3} , 'ZoFontAnnounceSmall' , nil , {1,2} , nil , false )
        local ultipct       = FTC.UI:Label( "FTC_UltimatePct" , ActionButton8 , 'inherit' ,  {CENTER,CENTER,0,0} , 'ZoFontHeader2' , nil , {1,1} , nil , false )
	end
end