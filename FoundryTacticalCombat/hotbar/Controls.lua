    
--[[----------------------------------------------------------
	ADVANCED HOTBAR CONTROLS
  ]]-----------------------------------------------------------  

	function FTC.Hotbar:Controls()

		-- Ultimate tracker	
	    local ultival  = FTC.UI:Label( 		"FTC_UltimateLevel", 	ActionButton8, 	{120,20}, 	{BOTTOM,TOP,0,-3}, 		FTC.UI:Font("esobold",16,true),	nil, {1,2}, "0/0", false )
	    local ultipct  = FTC.UI:Label( 		"FTC_UltimatePct", 		ActionButton8, 	'inherit',  {CENTER,CENTER,0,0}, 	FTC.UI:Font("esobold",20,true), nil, {1,1}, "100%", false )
	    local ultibuff = FTC.UI:Texture( 	"FTC_UltimateBuff", 	ActionButton8,  {160,160},  {CENTER,CENTER,0,0},  	'/esoui/art/crafting/white_burst.dds', false )
	    ultibuff:SetAlpha(0)
	    ultibuff:SetDrawLayer(DL_BACKGROUND)

	    -- Potion cooldown
	    local potioncd = FTC.UI:Label( 		"FTC_PotionCD", 		ActionButton9, 	{120,20}, 	{BOTTOM,TOP,0,-2}, 		FTC.UI:Font("esobold",16,true),	nil, {1,2}, "45s", false )
	end

	--[[ 
	 * SCT Object Opacity Fading
	 * --------------------------------
	 * Called by FTC.SCT:New()
	 * --------------------------------
	 ]]--
	function FTC.Hotbar:UltiFade()
		
		-- Bail out if we're already full
		if ( FTC.Player.ultimate.current == FTC.Player.ultimate.max ) then return end

		-- Maybe set up the animations
		local icon = _G["FTC_UltimateBuff"]
		if ( icon.fadeIn == nil ) then

		    -- Fade in
			local animation, timeline = CreateSimpleAnimation(ANIMATION_ALPHA,icon,0)
		    animation:SetAlphaValues(0,1)
		    animation:SetEasingFunction(ZO_EaseInQuadratic)  
		    animation:SetDuration(500)

		    -- Add to icon
		    timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
		    icon.fadeIn = timeline
		end
		if ( icon.fadeOut == nil ) then
		    local animation, timeline = CreateSimpleAnimation(ANIMATION_ALPHA,icon,8500)
		    animation:SetAlphaValues(1,0)
		    animation:SetEasingFunction(ZO_EaseInQuadratic)
		    animation:SetDuration(1000)
		    
		    -- Add to icon
		    timeline:SetPlaybackType(ANIMATION_PLAYBACK_ONE_SHOT,1)
		    icon.fadeOut = timeline
		end

		-- Stop fading out
		icon.fadeOut:Stop()

		-- If the icon is currently hidden
		if ( icon:GetAlpha() < 1 ) then icon.fadeIn:PlayFromStart() end

		-- Schedule fade out
		icon.fadeOut:PlayFromStart() 
	end