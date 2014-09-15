
--[[----------------------------------------------------------
	LOCALIZATION
  ]]----------------------------------------------------------

 --[[ 
 * Initializes localization options
 * Runs once during FTC.Initialize()
 ]]-- 
function FTC.Localize()
	local errorString = GetErrorString(16)
	if ( errorString == "Ziel aus dem Gleichgewicht" ) then FTC.language = "German"
	elseif ( errorString == "Cible \195\169tourdie" ) then FTC.language = "French" end
end 
 
 --[[ 
 * Takes charge of translating strings into their local language
 ]]-- 
function FTC.L( engString )

	-- If french or german, use the relevant lookup table
	if ( FTC.language == "French" or FTC.language == "German" ) then
	
		-- Get the translation
		local translation = FTC[FTC.language][engString]
		
		-- Return the translation if present, otherwise give the English string
		if ( translation ~= nil and translation ~= "" ) then return translation
		else return engString end
	
	-- If english, return the string directly
	elseif ( FTC.language == "English" ) then return engString end
end