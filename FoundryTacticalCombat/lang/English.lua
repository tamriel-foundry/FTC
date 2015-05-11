  
--[[----------------------------------------------------------
    ENGLISH LANGUAGE LOCALIZATION
  ]]----------------------------------------------------------

-- General Addon Information
ZO_CreateStringId("FTC_Name",               "Foundry Tactical Combat")
ZO_CreateStringId("FTC_ShortInfo",          "Foundry Tactical Combat by Atropos")
ZO_CreateStringId("FTC_LongInfo",           "You are using Foundry Tactical Combat version " .. FTC.version .. " developed by Atropos of Tamriel Foundry.")

--[[----------------------------------------------------------
    KEYBINDINGS
  ]]----------------------------------------------------------
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_COMBAT_LOG", "Toggle Combat Log")

--[[----------------------------------------------------------
    MENU CORE
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_Configure",     "Configure Addon Components")
ZO_CreateStringId("FTC_Menu_Reload",        "Changing this setting will immediately reload the UI!")
ZO_CreateStringId("FTC_Menu_NeedReload",    "Changes to this setting will not take affect until you reload your UI!")

ZO_CreateStringId("FTC_Menu_Frames",        "Enable Unit Frames")
ZO_CreateStringId("FTC_Menu_FramesDesc",    "Enable custom unit frames component? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_Buffs",         "Enable Buff Tracking")
ZO_CreateStringId("FTC_Menu_BuffsDesc",     "Enable buff and debuff tracking component? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_Log",         	"Enable Combat Log")
ZO_CreateStringId("FTC_Menu_LogDesc",     	"Enable chat-based combat log component? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_Damage",        "Enable Damage Statistics")
ZO_CreateStringId("FTC_Menu_DamageDesc",    "Enable tracking and reporting of damage statistics? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_SCT",           "Enable Combat Text")
ZO_CreateStringId("FTC_Menu_SCTDesc",       "Enable scrolling combat text component? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_Hotbar",        "Enable Advanced Hotbar")
ZO_CreateStringId("FTC_Menu_HotbarDesc",    "Enable advanced tooltips displayed over the default hotbar? [Default: Enabled]")

--[[----------------------------------------------------------
    UNIT FRAMES
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_FHeader",       "Configure Unit Frames Settings")

ZO_CreateStringId("FTC_Menu_FText",         "Default Unit Frames Text")
ZO_CreateStringId("FTC_Menu_FTextDesc",     "Display text data on default unit frames? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_FWidth",        "Unit Frames Width")
ZO_CreateStringId("FTC_Menu_FWidthDesc",    "Set the width of FTC unit frames. [Default: 350]")

ZO_CreateStringId("FTC_Menu_FHeight",       "Unit Frames Height")
ZO_CreateStringId("FTC_Menu_FHeightDesc",   "Set the height of FTC unit frames. [Default: 210]")

ZO_CreateStringId("FTC_Menu_FOpacIn",       "Combat Opacity")
ZO_CreateStringId("FTC_Menu_FOpacInDesc",   "Adjust the in-combat opacity of FTC unit frames. Lower settings are more transparent. [Default: 100]")

ZO_CreateStringId("FTC_Menu_FOpacOut",      "Non-Combat Opacity")
ZO_CreateStringId("FTC_Menu_FOpacOutDesc",  "Adjust the out-of-combat opacity of FTC unit frames. Lower settings are more transparent. [Default: 60]")

ZO_CreateStringId("FTC_Menu_FFont1",        "Primary Font")
ZO_CreateStringId("FTC_Menu_FFont1Desc",    "Change the primary font used in FTC unit frames. [Default: Trajan Pro]")

ZO_CreateStringId("FTC_Menu_FFont2",        "Secondary Font")
ZO_CreateStringId("FTC_Menu_FFont2Desc",    "Change the secondary font used in FTC unit frames. [Default: ESO Bold]")

ZO_CreateStringId("FTC_Menu_FFontS",        "Frame Font Size")
ZO_CreateStringId("FTC_Menu_FFontSDesc",    "Change the base scale of the fonts used in FTC unit frames. [Default: 18]")

ZO_CreateStringId("FTC_Menu_Exceute",       "Execute Threshold")
ZO_CreateStringId("FTC_Menu_ExecuteDesc",   "Set your desired excute threshold health percentage for frames and text alerts. [Default: 25]")

ZO_CreateStringId("FTC_Menu_FShowDef",      "Default Target Frame")
ZO_CreateStringId("FTC_Menu_FShowDefDesc",  "Continue displaying the default ESO target frame? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_FShowName",     "Show Player Nameplate")
ZO_CreateStringId("FTC_Menu_FShowNameDesc", "Display your own characters nameplate above FTC unit frames? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_FShowXP",       "Enable Mini Experience Bar")
ZO_CreateStringId("FTC_Menu_FShowXPDesc",   "Show your experience bar beneath the FTC player frame? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_FHealthC",      "Health Bar Color")
ZO_CreateStringId("FTC_Menu_FHealthCDesc",  "Set the color displayed in FTC unit frame Health bars. [Default: 153,0,0]")

ZO_CreateStringId("FTC_Menu_FMagickaC",     "Magicka Bar Color")
ZO_CreateStringId("FTC_Menu_FMagickaCDesc", "Set the color displayed in the FTC player frame Magicka bar. [Default: 102,102,204]")

ZO_CreateStringId("FTC_Menu_FStaminaC",     "Stamina Bar Color")
ZO_CreateStringId("FTC_Menu_FStaminaCDesc", "Set the color displayed in the FTC player frame Stamina bar. [Default: 0,102,0]")

ZO_CreateStringId("FTC_Menu_FShieldC",      "Shield Bar Color")
ZO_CreateStringId("FTC_Menu_FShieldCDesc",  "Set the color displayed in FTC unit frame Shield bars. [Default: 255,153,0]")

ZO_CreateStringId("FTC_Menu_FReset",        "Reset Unit Frames")
ZO_CreateStringId("FTC_Menu_FResetDesc",    "Reset original settings for FTC unit frames component.")

--[[----------------------------------------------------------
    BUFF TRACKING
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_BHeader",       "Configure Buff Tracker Settings")

ZO_CreateStringId("FTC_Menu_BAnchor",       "Anchor Buffs")
ZO_CreateStringId("FTC_Menu_BAnchorDesc",   "Anchor Buffs to Unit Frames? [Default: Enabled]")

ZO_CreateStringId("FTC_Menu_BLong",       	"Display Long Buffs")
ZO_CreateStringId("FTC_Menu_BLongDesc",   	"Display long duration player buffs? [Default: Enabled]")

ZO_CreateStringId("FTC_BuffFormat0",   		  "Disabled")
ZO_CreateStringId("FTC_BuffFormat1",   		  "Horizontal Tiles")
ZO_CreateStringId("FTC_BuffFormat2",   		  "Vertical Tiles")
ZO_CreateStringId("FTC_BuffFormat3",   		  "Descending List")
ZO_CreateStringId("FTC_BuffFormat4",   		  "Ascending List")

ZO_CreateStringId("FTC_Menu_BPBFormat",   	"Player Buff Format")
ZO_CreateStringId("FTC_Menu_BPBFormatDesc", "Choose desired format for player buffs. [Default: Horizontal Tiles]")

ZO_CreateStringId("FTC_Menu_BPDFormat",   	"Player Debuff Format")
ZO_CreateStringId("FTC_Menu_BPDFormatDesc", "Choose desired format for player debuffs. [Default: Horizontal Tiles]")

ZO_CreateStringId("FTC_Menu_BLBFormat",   	"Long Buff Format")
ZO_CreateStringId("FTC_Menu_BLBFormatDesc", "Choose desired format for long buffs. [Default: Vertical Tiles]")

ZO_CreateStringId("FTC_Menu_BTBFormat",   	"Target Buff Format")
ZO_CreateStringId("FTC_Menu_BTBFormatDesc", "Choose desired format for target buffs. [Default: Horizontal Tiles]")

ZO_CreateStringId("FTC_Menu_BTDFormat",   	"Target Debuff Format")
ZO_CreateStringId("FTC_Menu_BTDFormatDesc", "Choose desired format for target debuffs. [Default: Horizontal Tiles]")

ZO_CreateStringId("FTC_Menu_BFont1",        "Primary Font")
ZO_CreateStringId("FTC_Menu_BFont1Desc",    "Change the primary font used in FTC buff tracking. [Default: ESO Bold]")

ZO_CreateStringId("FTC_Menu_BFont2",        "Secondary Font")
ZO_CreateStringId("FTC_Menu_BFont2Desc",    "Change the secondary font used in FTC buff tracking. [Default: ESO Bold]")

ZO_CreateStringId("FTC_Menu_BFontS",        "Buff Font Size")
ZO_CreateStringId("FTC_Menu_BFontSDesc",    "Change the base scale of the fonts used in FTC buff tracking. [Default: 18]")

ZO_CreateStringId("FTC_Menu_BReset",        "Reset Buff Tracking")
ZO_CreateStringId("FTC_Menu_BResetDesc",    "Reset original settings for FTC buff tracking component.")

--[[----------------------------------------------------------
    COMBAT LOG
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_LHeader",       "Configure Combat Log Settings")

ZO_CreateStringId("FTC_Menu_LAltChat",     	"Alternate With Chat")
ZO_CreateStringId("FTC_Menu_LAltChatDesc", 	"Alternate Combat Log visibility with primary chat window?")

ZO_CreateStringId("FTC_Menu_LFont",         "Combat Log Font")
ZO_CreateStringId("FTC_Menu_LFontDesc",     "Change the font used in the FTC combat log. [Default: ESO Standard]")

ZO_CreateStringId("FTC_Menu_LFontS",        "Log Font Size")
ZO_CreateStringId("FTC_Menu_LFontSDesc",    "Change the font size used in the FTC combat log. [Default: 16]")

ZO_CreateStringId("FTC_Menu_LReset",        "Reset Combat Log")
ZO_CreateStringId("FTC_Menu_LResetDesc",    "Reset original settings for FTC combat log component.")