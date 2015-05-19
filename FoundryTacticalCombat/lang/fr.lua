  
--[[----------------------------------------------------------
    French LANGUAGE LOCALIZATION
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Name",               "Foundry Tactical Combat")
ZO_CreateStringId("FTC_ShortInfo",          "Foundry Tactical Combat par Atropos")
ZO_CreateStringId("FTC_LongInfo",           "Vous utilisez la version " .. FTC.version .. " de Foundry Tactical Combat développée par Atropos de Tamriel Foundry.")

--[[----------------------------------------------------------
    KEYBINDINGS
  ]]----------------------------------------------------------
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_COMBAT_LOG", "Activer/Désactiver le Log de Combat")

--[[----------------------------------------------------------
    DAMAGE WORDS
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Falling",            "Chute")
ZO_CreateStringId("FTC_Dead",               "Mort")
ZO_CreateStringId("FTC_Offline",            "Hors-Ligne")

--[[----------------------------------------------------------
    MENU CORE
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_Configure",     "Configurer les composants de l'extension")
ZO_CreateStringId("FTC_Menu_Reload",        "Modifier ce réglage rechargera immédiatement votre IU!")
ZO_CreateStringId("FTC_Menu_NeedReload",    "Les modifications ne prendront effet après que vous ayez rechargé l'IU!")

local default = ( FTC.Defaults.EnableFrames ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Frames",        "Activer les Cadres Unitaires")
ZO_CreateStringId("FTC_Menu_FramesDesc",    "Activer le composant de cadres unitaires customisés? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableBuffs ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Buffs",         "Activer le Suivi de Buffs"
ZO_CreateStringId("FTC_Menu_BuffsDesc",     "Activer le composant de suivi de Buffs et Débuffs? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableLog ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Log",           "Activer la Journalisation du Combat")
ZO_CreateStringId("FTC_Menu_LogDesc",       "Activer le composant de journalisation du combat du chat? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableSCT ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_SCT",           "Activer le Texte de Combat")
ZO_CreateStringId("FTC_Menu_SCTDesc",       "Activer le composant de défilement du texte de combat? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableMeter ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Damage",        "Activer les Statistiques de Dégats")
ZO_CreateStringId("FTC_Menu_DamageDesc",    "Activer le suivi et reporting des statistiques de dégats? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableHotbar ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Hotbar",        "Activer la Barre de Raccourcis Avancée")
ZO_CreateStringId("FTC_Menu_HotbarDesc",    "Activer info-bulles avancées affichées sur la barre de raccourcis par défaut? [Défaut: "..default.."]")

--ZO_CreateStringId("FTC_Menu_Move",          "Unlock Positions")
--ZO_CreateStringId("FTC_Menu_MoveDesc",      "Modify the position of FTC interface elements.")

--[[----------------------------------------------------------
    UNIT FRAMES
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_FHeader",       "Configurer les Paramètres des Cadres Unitaires")

ZO_CreateStringId("FTC_Menu_FWidth",        "Largeur des Cadres")
ZO_CreateStringId("FTC_Menu_FWidthDesc",    "Régler la larger des cadres unitaires de FTC. [Défaut: "..FTC.Defaults.FrameWidth.."]")

ZO_CreateStringId("FTC_Menu_FHeight",       "Hauteur des Cadres")
ZO_CreateStringId("FTC_Menu_FHeightDesc",   "Régler la hauteur des cadres unitaires de FTC. [Défaut: "..FTC.Defaults.FrameHeight.."]")

ZO_CreateStringId("FTC_Menu_FOpacIn",       "Opcaité en Combat")
ZO_CreateStringId("FTC_Menu_FOpacInDesc",   "Ajuster l'opacité des cadres unitaires de FTC pendant le combat. Les valeurs faibles sont plus transparentes. [Défaut: "..FTC.Defaults.FrameOpacityIn.."]")

ZO_CreateStringId("FTC_Menu_FOpacOut",      "Opcacité Hors-Combat")
ZO_CreateStringId("FTC_Menu_FOpacOutDesc",  "Ajuster l'opacité Hord-Combat des cadres unitaires de FTC. Les valeurs faibles sont plus transparents. [Défaut: "..FTC.Defaults.FrameOpacityOut.."]")

ZO_CreateStringId("FTC_Menu_FFont1",        "Police Primaire")
ZO_CreateStringId("FTC_Menu_FFont1Desc",    "Changer la police primaire utilisée dans les cadres unitaires de FTC.[Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.FrameFont1).."]")

ZO_CreateStringId("FTC_Menu_FFont2",        "Police Secondaire")
ZO_CreateStringId("FTC_Menu_FFont2Desc",    "Changer la police secondaire utilisée dans les cadres unitaires de FTC. [Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.FrameFont2).."]")

ZO_CreateStringId("FTC_Menu_FFontS",        "Taille de la Police du Cadre Unitaire") --you can also use "Taille de la Police" which would translate to Font Size
ZO_CreateStringId("FTC_Menu_FFontSDesc",    "Changer l'échelle de base de la police utilisée dans les cadres unitaires de FTC. [Défaut: "..FTC.Defaults.FrameFontSize.."]")

ZO_CreateStringId("FTC_Menu_Exceute",       "Seuil d'Exécution")
ZO_CreateStringId("FTC_Menu_ExecuteDesc",   "Déterminez le pourcentage de santé correspondant au seuil d'exécution pour les cadres et les textes d'alerte. [Défaut: "..FTC.Defaults.ExecuteThreshold.."]")

local default = ( FTC.Defaults.DefaultTargetFrame ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FShowDef",      "Cadre de la Cible par Défaut")
ZO_CreateStringId("FTC_Menu_FShowDefDesc",  "Continuer à afficher le cadre de Cible par défaut de ESO? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableNameplate ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FShowName",     "Montrer la Plaque du Joueur")
ZO_CreateStringId("FTC_Menu_FShowNameDesc", "Montrer la plaque de votre propre personnage au dessus du cadre du joueur de FTC? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableXPBar ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FShowXP",       "Activer la Mini-Barre d'Expérience")
ZO_CreateStringId("FTC_Menu_FShowXPDesc",   "Montrer votre barre d'expérience en dessous du cadre du joueur de FTC? [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameHealthColor[1]*255)..","..math.floor(FTC.Defaults.FrameHealthColor[2]*255)..","..math.floor(FTC.Defaults.FrameHealthColor[3]*255)
ZO_CreateStringId("FTC_Menu_FHealthC",      "Couleur Barre Santé")
ZO_CreateStringId("FTC_Menu_FHealthCDesc",  "Régler la couleur affichée dans les barres de santé du cadre FTC. [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameMagickaColor[1]*255)..","..math.floor(FTC.Defaults.FrameMagickaColor[2]*255)..","..math.floor(FTC.Defaults.FrameMagickaColor[3]*255)
ZO_CreateStringId("FTC_Menu_FMagickaC",     "Couleur Barre Magie")
ZO_CreateStringId("FTC_Menu_FMagickaCDesc", "Régler la couleur affichée dans les barres de magie du cadre FTC. [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameStaminaColor[1]*255)..","..math.floor(FTC.Defaults.FrameStaminaColor[2]*255)..","..math.floor(FTC.Defaults.FrameStaminaColor[3]*255)
ZO_CreateStringId("FTC_Menu_FStaminaC",     "Couleur Barre Vigueur")
ZO_CreateStringId("FTC_Menu_FStaminaCDesc", "Régler la couleur affichée dans les barres de vigueur du cadre FTC. [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameShieldColor[1]*255)..","..math.floor(FTC.Defaults.FrameShieldColor[2]*255)..","..math.floor(FTC.Defaults.FrameShieldColor[3]*255)
ZO_CreateStringId("FTC_Menu_FShieldC",      "Couleur Barre Bouclier")
ZO_CreateStringId("FTC_Menu_FShieldCDesc",  "Régler la couleur affichée dans la barre de bouclier du cadre FTC. [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableGroupFrames ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FGroup",        "Activer Cadre de Petit Groupe")
ZO_CreateStringId("FTC_Menu_FGroupDesc",    "Utiliser le cadre de groupe personnalisé quand vous êtes dans un groupe de 4 ou moins. [Défaut: "..default.."]")

ZO_CreateStringId("FTC_Menu_FGWidth",       "Largeur du Cadre de Groupe")
ZO_CreateStringId("FTC_Menu_FGWidthDesc",   "Régler la larger des cadres de petits groupes de FTC. [Défaut: "..FTC.Defaults.GroupWidth.."]")

ZO_CreateStringId("FTC_Menu_FGHeight",      "Hauteur du Cadre de Groupe")
ZO_CreateStringId("FTC_Menu_FGHeightDesc",  "Régler la hauteur des cadres de petits groupes de FTC. [Défaut: "..FTC.Defaults.GroupHeight.."]")

ZO_CreateStringId("FTC_Menu_FGFontS",       "Taille de Police du Cadre de Groupe")
ZO_CreateStringId("FTC_Menu_FGFontSDesc",   "Changer l'échelle de base de la police utilisée dans les cadres de petits groupes de FTC. [Défaut: "..FTC.Defaults.GroupFontSize.."]")

local default = ( FTC.Defaults.GroupHidePlayer ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FGHideP",       "Cacher le joueur dans le cadre du groupe")
ZO_CreateStringId("FTC_Menu_FGHidePDesc",   "Ne pas montrer votre propre barre de santé dans un cadre de petit groupe? [Défaut: " .. default .."]")

local default = ( FTC.Defaults.ColorRoles ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FColorR",       "Cadres de Couleur par Rôle")
ZO_CreateStringId("FTC_Menu_FColorRDesc",   "utiliser différentes couleurs pour chaque rôle dans les cadres de groupe et raid de FTC? [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameTankColor[1]*255)..","..math.floor(FTC.Defaults.FrameTankColor[2]*255)..","..math.floor(FTC.Defaults.FrameTankColor[3]*255)
ZO_CreateStringId("FTC_Menu_FTankC",        "Couleur du Tank")
ZO_CreateStringId("FTC_Menu_FTankCDesc",    "Régler la couleur affichée pour les tanks dans les cadres de groupe et raid de FTC. [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameHealerColor[1]*255)..","..math.floor(FTC.Defaults.FrameHealerColor[2]*255)..","..math.floor(FTC.Defaults.FrameHealerColor[3]*255)
ZO_CreateStringId("FTC_Menu_FHealerC",      "Couleur du Guérisseur")
ZO_CreateStringId("FTC_Menu_FHealerCDesc",  "Régler la couleur affichée pour les guérisseurs dans les cadres de groupe et raid de FTC. [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameDamageColor[1]*255)..","..math.floor(FTC.Defaults.FrameDamageColor[2]*255)..","..math.floor(FTC.Defaults.FrameDamageColor[3]*255)
ZO_CreateStringId("FTC_Menu_FDamageC",      "Couleur du DPS")
ZO_CreateStringId("FTC_Menu_FDamageCDesc",  "Régler la couleur affichée pour les DPS dans les cadres de groupe et raid de FTC [Défaut: "..default.."]")

ZO_CreateStringId("FTC_Menu_FReset",        "Rénitialiser les Cadres Unitaires")
ZO_CreateStringId("FTC_Menu_FResetDesc",    "Réinitialiser les paramètres originaux pour la composante de cadres unitaires de FTC.")

--[[----------------------------------------------------------
    BUFF TRACKING
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_BHeader",       "Modifier les paramètres de suivi de Buffs")

ZO_CreateStringId("FTC_BuffFormat0",        "Désactivé")
ZO_CreateStringId("FTC_BuffFormat1",        "Tuiles Horizontales")
ZO_CreateStringId("FTC_BuffFormat2",        "Tuiles Verticales")
ZO_CreateStringId("FTC_BuffFormat3",        "Liste Descendante")
ZO_CreateStringId("FTC_BuffFormat4",        "Liste Croissante")

ZO_CreateStringId("FTC_Menu_BPBFormat",     "Format du Buff de joueur")
ZO_CreateStringId("FTC_Menu_BPBFormatDesc", "Choisir le format désiré pour les buffs du joueur. [Défaut:: "..FTC.Menu:GetBuffFormat(FTC.Defaults.PlayerBuffFormat).."]")

ZO_CreateStringId("FTC_Menu_BPDFormat",     "Format du Debuff du joueur")
ZO_CreateStringId("FTC_Menu_BPDFormatDesc", "Choisir le format désiré pour les debuffs du joueur. [Défaut: "..FTC.Menu:GetBuffFormat(FTC.Defaults.PlayerDebuffFormat).."]")

ZO_CreateStringId("FTC_Menu_BLBFormat",     "Format de Long Buff")
ZO_CreateStringId("FTC_Menu_BLBFormatDesc", "Choisir le format désiré pour les longs buffs. [Défaut: "..FTC.Menu:GetBuffFormat(FTC.Defaults.LongBuffFormat).."]")

ZO_CreateStringId("FTC_Menu_BTBFormat",     "Format Buff de Cible")
ZO_CreateStringId("FTC_Menu_BTBFormatDesc", "Choisir le format désiré pour les buffs de la cible. [Défaut: "..FTC.Menu:GetBuffFormat(FTC.Defaults.TargetBuffFormat).."]")

ZO_CreateStringId("FTC_Menu_BTDFormat",     "Format Debuff de Cible")
ZO_CreateStringId("FTC_Menu_BTDFormatDesc", "Choisir le format désiré pour les debuffs de la cible. [Défaut: "..FTC.Menu:GetBuffFormat(FTC.Defaults.TargetDebuffFormat).."]")

ZO_CreateStringId("FTC_Menu_BFont1",        "Police Primaire")
ZO_CreateStringId("FTC_Menu_BFont1Desc",    "Changer la police primaire utilisée pour le suivi des buffs de FTC. [Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.BuffsFont1).."]")

ZO_CreateStringId("FTC_Menu_BFont2",        "Police Secondaire")
ZO_CreateStringId("FTC_Menu_BFont2Desc",    "Changer la police secondaire utilisée pour le suivi des buffs de FTC. [Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.BuffsFont2).."]")

ZO_CreateStringId("FTC_Menu_BFontS",        "Police des Buff")
ZO_CreateStringId("FTC_Menu_BFontSDesc",    "Changer la taille de base des polices utilisées pour le suivi des buffs de FTC. [Défaut: "..FTC.Defaults.BuffsFontSize.."]")

ZO_CreateStringId("FTC_Menu_BReset",        "Rénitialiser le Suivi de Buffs")
ZO_CreateStringId("FTC_Menu_BResetDesc",    "Réinitialiser les paramètres originaux pour la composante de suivi des Buffs de FTC.")

--[[----------------------------------------------------------
    COMBAT LOG
  ]]----------------------------------------------------------
--ZO_CreateStringId("FTC_Menu_LHeader",       "Configure Combat Log Settings")

--local default = FTC.Defaults.AlternateChat and "Enabled" or "Disabled"
--ZO_CreateStringId("FTC_Menu_LAltChat",      "Alternate With Chat")
--ZO_CreateStringId("FTC_Menu_LAltChatDesc",  "Alternate Combat Log visibility with primary chat window? [Default: "..default.."]")

--ZO_CreateStringId("FTC_Menu_LFont",         "Combat Log Font")
--ZO_CreateStringId("FTC_Menu_LFontDesc",     "Change the font used in the FTC combat log. [Default: "..FTC.UI:TranslateFont(FTC.Defaults.LogFont).."]")

--ZO_CreateStringId("FTC_Menu_LFontS",        "Log Font Size")
--ZO_CreateStringId("FTC_Menu_LFontSDesc",    "Change the font size used in the FTC combat log. [Default: "..FTC.Defaults.LogFontSize.."]")

--ZO_CreateStringId("FTC_Menu_LReset",        "Reset Combat Log")
--ZO_CreateStringId("FTC_Menu_LResetDesc",    "Reset original settings for FTC combat log component.")

--[[----------------------------------------------------------
    SCROLLING COMBAT TEXT
  ]]----------------------------------------------------------
--ZO_CreateStringId("FTC_Menu_SHeader",       "Configure Combat Text Settings")

--local default = FTC.Defaults.SCTIcons and "Enabled" or "Disabled"
--ZO_CreateStringId("FTC_Menu_SIcons",        "Display SCT Icons")
--ZO_CreateStringId("FTC_Menu_SIconsDesc",    "Display ability icons beside scrolling combat text? [Default: "..default.."]")

--local default = FTC.Defaults.SCTNames and "Enabled" or "Disabled"
--ZO_CreateStringId("FTC_Menu_SNames",        "Display SCT Names")
--ZO_CreateStringId("FTC_Menu_SNamesDesc",    "Display ability names when possible in scrolling combat text? [Default: "..default.."]")

--ZO_CreateStringId("FTC_Menu_SSpeed",        "SCT Scroll Speed")
--ZO_CreateStringId("FTC_Menu_SSpeedDesc",    "Change speed of combat text scrolling, higher is faster. [Default: "..FTC.Defaults.SCTSpeed.."]")

--ZO_CreateStringId("FTC_Menu_SArc",          "SCT Arc Intensity")
--ZO_CreateStringId("FTC_Menu_SArcDesc",      "Change the curviture of scrolling combat text, higher values generate more arcing. [Default: "..FTC.Defaults.SCTArc.."]")

--ZO_CreateStringId("FTC_Menu_SFont1",        "Primary Font")
--ZO_CreateStringId("FTC_Menu_SFont1Desc",    "Change the primary font used for damage values in scrolling combat text. [Default: "..FTC.UI:TranslateFont(FTC.Defaults.SCTFont1).."]")

--ZO_CreateStringId("FTC_Menu_SFont2",        "Secondary Font")
--ZO_CreateStringId("FTC_Menu_SFont2Desc",    "Change the secondary font used for ability names in scrolling combat text. [Default: "..FTC.UI:TranslateFont(FTC.Defaults.SCTFont2).."]")

--ZO_CreateStringId("FTC_Menu_SFontS",        "SCT Font Size")
--ZO_CreateStringId("FTC_Menu_SFontSDesc",    "Change the font size used in the FTC scrolling combat text. [Default: "..FTC.Defaults.SCTFontSize.."]")

--ZO_CreateStringId("FTC_Menu_SCTReset",      "Reset SCT")
--ZO_CreateStringId("FTC_Menu_SCTResetDesc",  "Reset original settings for FTC scrolling combat text component.")