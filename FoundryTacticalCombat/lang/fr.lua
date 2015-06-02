  
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
ZO_CreateStringId("SI_BINDING_NAME_DISPLAY_DAMAGE_REPORT",  "Afficher Rapport de Dégats")
ZO_CreateStringId("SI_BINDING_NAME_POST_DAMAGE_RESULTS",    "Poster Résultats des Dégats")

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
ZO_CreateStringId("FTC_Menu_Buffs",         "Activer le Suivi de Buffs")
ZO_CreateStringId("FTC_Menu_BuffsDesc",     "Activer le composant de suivi de Buffs et Débuffs? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableLog ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Log",           "Activer la Journalisation du Combat")
ZO_CreateStringId("FTC_Menu_LogDesc",       "Activer le composant de journalisation du combat du chat? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableSCT ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_SCT",           "Activer le Texte de Combat")
ZO_CreateStringId("FTC_Menu_SCTDesc",       "Activer le composant de défilement du texte de combat? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableMeter ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Damage",        "Activer Statistiques de Dégats")
ZO_CreateStringId("FTC_Menu_DamageDesc",    "Activer le suivi et reporting des statistiques de dégats? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableHotbar ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_Hotbar",        "Activer Barre de Raccourcis Avancée")
ZO_CreateStringId("FTC_Menu_HotbarDesc",    "Activer info-bulles avancées affichées sur la barre de raccourcis par défaut? [Défaut: "..default.."]")

ZO_CreateStringId("FTC_Menu_Move",          "Débloquer Positionnement")
ZO_CreateStringId("FTC_Menu_MoveDesc",      "Modifier la position des éléments d'interface de FTC.")

ZO_CreateStringId("FTC_Menu_Reset",        "Rénitialiser l'extension")
--ZO_CreateStringId("FTC_Menu_ResetDesc",    "Reset the entire FTC addon to its original settings.")

--[[----------------------------------------------------------
    UNIT FRAMES
  ]]----------------------------------------------------------

-- Unit Frames Words
ZO_CreateStringId("FTC_PF_Label",           "Cadre Joueur")
ZO_CreateStringId("FTC_TF_Label",           "Cadre Cible")
ZO_CreateStringId("FTC_GF_Label",           "Cadre Groupe")
ZO_CreateStringId("FTC_RF_Label",           "Cadre Raid")
ZO_CreateStringId("FTC_Dead",               "Mort")
ZO_CreateStringId("FTC_Offline",            "Hors-Ligne")

-- Unit Frames Menu
ZO_CreateStringId("FTC_Menu_FHeader",       "Configurer Paramètres Cadres Unitaires")

ZO_CreateStringId("FTC_Menu_FWidth",        "Largeur des Cadres")
ZO_CreateStringId("FTC_Menu_FWidthDesc",    "Régler la larger des cadres unitaires de FTC. [Défaut: "..FTC.Defaults.FrameWidth.."]")

ZO_CreateStringId("FTC_Menu_FHeight",       "Hauteur des Cadres")
ZO_CreateStringId("FTC_Menu_FHeightDesc",   "Régler la hauteur des cadres unitaires de FTC. [Défaut: "..FTC.Defaults.FrameHeight.."]")

ZO_CreateStringId("FTC_Menu_FOpacIn",       "Opcaité en Combat")
ZO_CreateStringId("FTC_Menu_FOpacInDesc",   "Ajuster l'opacité des cadres unitaires de FTC pendant le combat. Les valeurs faibles sont plus transparentes. [Défaut: "..FTC.Defaults.FrameOpacityIn.."]")

ZO_CreateStringId("FTC_Menu_FOpacOut",      "Opacacité Hors-Combat")
ZO_CreateStringId("FTC_Menu_FOpacOutDesc",  "Ajuster l'opacité Hord-Combat des cadres unitaires de FTC. Les valeurs faibles sont plus transparents. [Défaut: "..FTC.Defaults.FrameOpacityOut.."]")

--local default = ( FTC.Defaults.FrameShowMax ) and "Enabled" or "Disabled"
--ZO_CreateStringId("FTC_Menu_FShowMax",      "Show Maximum Health")
--ZO_CreateStringId("FTC_Menu_FShowMaxDesc",  "Display maximum health values in player, target, and group frames? [Default: "..default.."]")

ZO_CreateStringId("FTC_Menu_FFont1",        "Police Primaire")
ZO_CreateStringId("FTC_Menu_FFont1Desc",    "Changer la police primaire utilisée dans les cadres unitaires de FTC.[Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.FrameFont1).."]")

ZO_CreateStringId("FTC_Menu_FFont2",        "Police Secondaire")
ZO_CreateStringId("FTC_Menu_FFont2Desc",    "Changer la police secondaire utilisée dans les cadres unitaires de FTC. [Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.FrameFont2).."]")

ZO_CreateStringId("FTC_Menu_FFontS",        "Taille de Police du Cadre Unitaire") 
ZO_CreateStringId("FTC_Menu_FFontSDesc",    "Changer l'échelle de base de la police utilisée dans les cadres unitaires de FTC. [Défaut: "..FTC.Defaults.FrameFontSize.."]")

ZO_CreateStringId("FTC_Menu_Exceute",       "Seuil d'Exécution")
ZO_CreateStringId("FTC_Menu_ExecuteDesc",   "Déterminez le pourcentage de santé correspondant au seuil d'exécution pour les cadres et les textes d'alerte. [Défaut: "..FTC.Defaults.ExecuteThreshold.."]")

local default = ( FTC.Defaults.DefaultTargetFrame ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FShowDef",      "Cadre de Cible par Défaut")
ZO_CreateStringId("FTC_Menu_FShowDefDesc",  "Continuer à afficher le cadre de Cible par défaut de ESO? [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableNameplate ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FShowName",     "Montrer Plaque du Joueur")
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
ZO_CreateStringId("FTC_Menu_FGHideP",       "Cacher Joueur dans Cadre de Groupe")
ZO_CreateStringId("FTC_Menu_FGHidePDesc",   "Ne pas montrer votre propre barre de santé dans un cadre de petit groupe? [Défaut: " .. default .."]")

local default = ( FTC.Defaults.ColorRoles ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FColorR",       "Cadres de Couleur par Rôle")
ZO_CreateStringId("FTC_Menu_FColorRDesc",   "Utiliser différentes couleurs pour chaque rôle dans les cadres de groupe et raid de FTC? [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameTankColor[1]*255)..","..math.floor(FTC.Defaults.FrameTankColor[2]*255)..","..math.floor(FTC.Defaults.FrameTankColor[3]*255)
ZO_CreateStringId("FTC_Menu_FTankC",        "Couleur du Tank")
ZO_CreateStringId("FTC_Menu_FTankCDesc",    "Régler la couleur affichée pour les tanks dans les cadres de groupe et raid de FTC. [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameHealerColor[1]*255)..","..math.floor(FTC.Defaults.FrameHealerColor[2]*255)..","..math.floor(FTC.Defaults.FrameHealerColor[3]*255)
ZO_CreateStringId("FTC_Menu_FHealerC",      "Couleur du Guérisseur")
ZO_CreateStringId("FTC_Menu_FHealerCDesc",  "Régler la couleur affichée pour les guérisseurs dans les cadres de groupe et raid de FTC. [Défaut: "..default.."]")

local default = math.floor(FTC.Defaults.FrameDamageColor[1]*255)..","..math.floor(FTC.Defaults.FrameDamageColor[2]*255)..","..math.floor(FTC.Defaults.FrameDamageColor[3]*255)
ZO_CreateStringId("FTC_Menu_FDamageC",      "Couleur du DPS")
ZO_CreateStringId("FTC_Menu_FDamageCDesc",  "Régler la couleur affichée pour les DPS dans les cadres de groupe et raid de FTC [Défaut: "..default.."]")

local default = ( FTC.Defaults.EnableRaidFrames ) and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_FRaid",         "Activer Cadres de Raid")
ZO_CreateStringId("FTC_Menu_FRaidDesc",     "Utiliser les cadres unitaires customisés pour les groupes de quatre ou plus? [Défaut: "..default.."]")

ZO_CreateStringId("FTC_Menu_FRWidth",       "Largeur Cadre de Raid")
ZO_CreateStringId("FTC_Menu_FRWidthDesc",   "Régler la largeur des cadres de raid de FTC. [Défaut: "..FTC.Defaults.RaidWidth.."]")

ZO_CreateStringId("FTC_Menu_FRHeight",      "Hauteur Cadre de Raid")
ZO_CreateStringId("FTC_Menu_FRHeightDesc",  "Régler la hauteur des cadres de raid de FTC. [Défaut: "..FTC.Defaults.RaidHeight.."]")

ZO_CreateStringId("FTC_Menu_FRFontS",       "Taille Police du Cadre de Raid")
ZO_CreateStringId("FTC_Menu_FRFontSDesc",   "Changer la taille des polices utilisées dans le cadre de raid de FTC. [Défaut: "..FTC.Defaults.RaidFontSize.."]")

ZO_CreateStringId("FTC_Menu_FReset",        "Rénitialiser les Cadres Unitaires")
ZO_CreateStringId("FTC_Menu_FResetDesc",    "Réinitialiser les paramètres originaux du composant de cadres unitaires de FTC.")

--[[----------------------------------------------------------
    BUFF TRACKING
  ]]----------------------------------------------------------

-- Buff Tracking UI
ZO_CreateStringId("FTC_PlayerBuff",         "Buff Joueur")
ZO_CreateStringId("FTC_PlayerDebuff",       "Debuff Joueur")
ZO_CreateStringId("FTC_PB_Label",           "Buffs Joueur")
ZO_CreateStringId("FTC_PD_Label",           "Debuffs Joueur")
ZO_CreateStringId("FTC_LB_Label",           "B\nu\nf\nf\ns\n\nL\no\nn\ng\ns") -- "Buffs Longs"
ZO_CreateStringId("FTC_TB_Label",           "Buffs Cible")
ZO_CreateStringId("FTC_TD_Label",           "Debuffs Cible")

-- Buff Tracking Menu
ZO_CreateStringId("FTC_Menu_BHeader",       "Modifier les paramètres de suivi de Buffs")

ZO_CreateStringId("FTC_BuffFormat0",        "Désactivé")
ZO_CreateStringId("FTC_BuffFormat1",        "Tuiles Horizontales")
ZO_CreateStringId("FTC_BuffFormat2",        "Tuiles Verticales")
ZO_CreateStringId("FTC_BuffFormat3",        "Liste Descendante Gauche")
ZO_CreateStringId("FTC_BuffFormat4",        "Liste Croissante Gauche")
ZO_CreateStringId("FTC_BuffFormat5",        "Liste Descendante Droite")
ZO_CreateStringId("FTC_BuffFormat6",        "Liste Croissante Droite")

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

-- Combat Log UI
ZO_CreateStringId("FTC_CL_Label",           "Journal de Combat")

-- Combat Log Menu
ZO_CreateStringId("FTC_Menu_LHeader",       "Configurer Paramètres du JDC")

local default = FTC.Defaults.AlternateChat and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_LAltChat",      "Alterner avec le Chat")
ZO_CreateStringId("FTC_Menu_LAltChatDesc",  "Alterner la visibilité du journal de combat avec la fenêtre de chat par défaut? [Défaut: "..default.."]")

ZO_CreateStringId("FTC_Menu_LFont",         "Police du Journal de Combat")
ZO_CreateStringId("FTC_Menu_LFontDesc",     "Changer la police utilisée dans le journal de combat de FTC. [Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.LogFont).."]")

ZO_CreateStringId("FTC_Menu_LFontS",        "Taille de Police du Journal")
ZO_CreateStringId("FTC_Menu_LFontSDesc",    "Changer la taile de la police utilisée dans le journal de combat de FTC. [Défaut: "..FTC.Defaults.LogFontSize.."]")

ZO_CreateStringId("FTC_Menu_LOpacity",      "Opacité du fond du Journal")
ZO_CreateStringId("FTC_Menu_LOpacityDesc",  "Changer l'opactié du fond du journal de combat de FTC. [Défaut: "..FTC.Defaults.LogOpacity.."]")

ZO_CreateStringId("FTC_Menu_LReset",        "Rénitialiser le Journal de Combat")
ZO_CreateStringId("FTC_Menu_LResetDesc",    "Réinitialiser les paramètres originaux du composant de journalisation de combat de FTC.")

--[[----------------------------------------------------------
    SCROLLING COMBAT TEXT
  ]]----------------------------------------------------------

-- Combat Text UI
ZO_CreateStringId("FTC_OD_Label",           "Dégats Sortants")
ZO_CreateStringId("FTC_ID_Label",           "Dégats Entrants")
ZO_CreateStringId("FTC_CA_Label",           "Alertes de Combat")
ZO_CreateStringId("FTC_LowHealth",          "Santé Basse")
ZO_CreateStringId("FTC_LowMagicka",         "Magie Basse")
ZO_CreateStringId("FTC_LowStamina",         "Vigueur Basse")
ZO_CreateStringId("FTC_Experience",         "Expérience")
ZO_CreateStringId("FTC_AlliancePoints",     "Points d'Alliance")
ZO_CreateStringId("FTC_Stunned",            "Etourdi")
ZO_CreateStringId("FTC_Disoriented",        "Disoriented")
ZO_CreateStringId("FTC_Offbalance",         "Off Balance")
ZO_CreateStringId("FTC_Staggered",          "Stupéfait")
ZO_CreateStringId("FTC_Interrupted",        "Interrompu")
ZO_CreateStringId("FTC_Feared",             "Apeuré")
ZO_CreateStringId("FTC_Silenced",           "Silencié")
ZO_CreateStringId("FTC_Rooted",             "Enraciné")
ZO_CreateStringId("FTC_BreakFree",          "Se Libérer")
ZO_CreateStringId("FTC_Potion",             "Potion Disponible")
ZO_CreateStringId("FTC_Ultimate",           "Ultimate Disponible")
ZO_CreateStringId("FTC_CombatIn",           "Combat Démarré")
ZO_CreateStringId("FTC_CleanseNow",         "Purifier Maintenant")
ZO_CreateStringId("FTC_CombatOut",          "Combat Quitté")
ZO_CreateStringId("FTC_Falling",            "Chute")
ZO_CreateStringId("FTC_FakeDamage",         "Faux Dégat")
ZO_CreateStringId("FTC_FakeHeal",           "Faux Heal")

-- Combat Text Menu
ZO_CreateStringId("FTC_Menu_SHeader",       "Configurer Paramètres Texte de Combat")

local default = FTC.Defaults.SCTIcons and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_SIcons",        "Montrer les Icones du TCD")
ZO_CreateStringId("FTC_Menu_SIconsDesc",    "Afficher les icones des abilités à coté du texte de combat déroulant? [Défaut: "..default.."]")

local default = FTC.Defaults.SCTNames and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_SNames",        "Montrer les Nombres du TCD")
ZO_CreateStringId("FTC_Menu_SNamesDesc",    "Afficher le nom des abilités lorsque possible dans le texte de combat déroulant? [Défaut: "..default.."]")

local default = FTC.Defaults.SCTRound and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_SRound",        "Arrondir Nombres")
ZO_CreateStringId("FTC_Menu_SRoundDesc",    "Arrondir les chiffres des dégats à la centaine proche; par exemple 9,543 deviens 9.5k. [Défaut: "..default.."]")

--local default = FTC.Defaults.SCTAlerts      and "Enabled" or "Disabled"
--ZO_CreateStringId("FTC_Menu_SAlerts",       "Display Alerts")
--ZO_CreateStringId("FTC_Menu_SAlertsDesc",   "Display alerts for significant combat events?  [Default: "..default.."]")

ZO_CreateStringId("FTC_Menu_SSpeed",        "Vitesse de défilement du TCD")
ZO_CreateStringId("FTC_Menu_SSpeedDesc",    "Changer la vitesse du texte de combat déroulant, la valeur haute est plus rapide. [Défaut: "..FTC.Defaults.SCTSpeed.."]")

ZO_CreateStringId("FTC_Menu_SArc",          "Intensité de l'Arc du TCD")
ZO_CreateStringId("FTC_Menu_SArcDesc",      "Changer la courbature du texte de combat déroulant, plus la valeur est élevée, plus l'arc est prononcé. [Défaut: "..FTC.Defaults.SCTArc.."]")

ZO_CreateStringId("FTC_Menu_SFont1",        "Police Primaire")
ZO_CreateStringId("FTC_Menu_SFont1Desc",    "Changer la police de base utilisée pour les valeurs des dégats dans le texte de combat déroulant. [Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.SCTFont1).."]")

ZO_CreateStringId("FTC_Menu_SFont2",        "Police Secondaire")
ZO_CreateStringId("FTC_Menu_SFont2Desc",    "Changer la police secondaire utilisée les noms des abilitéesdans le texte de combat déroulant. [Défaut: "..FTC.UI:TranslateFont(FTC.Defaults.SCTFont2).."]")

ZO_CreateStringId("FTC_Menu_SFontS",        "Taille Police du TCD")
ZO_CreateStringId("FTC_Menu_SFontSDesc",    "Changer la taille de la police utilisée dans le texte de combat déroulant de FTC. [Défaut: "..FTC.Defaults.SCTFontSize.."]")

ZO_CreateStringId("FTC_Menu_SIconS",        "Taille d'Icones du TCD")
ZO_CreateStringId("FTC_Menu_SIconSDesc",    "Changer la taille des icones affichées dans le texte de combat déroulant de FTC. [Défaut: "..FTC.Defaults.SCTIconSize.."]")

ZO_CreateStringId("FTC_Menu_SCTReset",      "Rénitialiser le TCD")
ZO_CreateStringId("FTC_Menu_SCTResetDesc",  "Réinitialiser les paramètres originaux du composant de texte déroulant de combat de FTC")

--[[----------------------------------------------------------
    DAMAGE STATISTICS
  ]]----------------------------------------------------------

-- Damage Report UI
ZO_CreateStringId("FTC_DReport",            "Rapport de Dégats de FTC")
ZO_CreateStringId("FTC_HReport",            "Rapport de Soins de FTC")
ZO_CreateStringId("FTC_NoDamage",           "Pas de dégats à rapporter!")
ZO_CreateStringId("FTC_NoHealing",          "Pas de soins à rapporter!")
ZO_CreateStringId("FTC_AllTargets",         "Toutes les Cibles")
ZO_CreateStringId("FTC_Ability",            "Capacité")
ZO_CreateStringId("FTC_Crit",               "Crit")
ZO_CreateStringId("FTC_Average",            "Moy")
ZO_CreateStringId("FTC_Max",                "Max")
ZO_CreateStringId("FTC_Damage",             "Dégats")
ZO_CreateStringId("FTC_Healing",            "Soins")
ZO_CreateStringId("FTC_DPS",                "DPS")
ZO_CreateStringId("FTC_HPS",                "SPS")

-- Damage Report Menu
ZO_CreateStringId("FTC_Menu_THeader",       "Configure Damage Statistics")

ZO_CreateStringId("FTC_Menu_TTimeout",      "Timeout Threshold")
ZO_CreateStringId("FTC_Menu_TTimeoutDesc",  "Déterminer le nombre de secondes qui doivent s'écouler entre des évènements de dégats avant qu'une nouvelle rencontre soit reconnue. [Défaut: "..FTC.Defaults.DamageTimeout.."]")

local default = FTC.Defaults.StatTriggerHeals and "Activé" or "Désactivé"
ZO_CreateStringId("FTC_Menu_TRHeal",        "Autoriser Soins Déclencheurs")
ZO_CreateStringId("FTC_Menu_TRHealDesc",    "Autoriser le déclenchement d'une nouvelle rencontre par un soin sortant.")

ZO_CreateStringId("FTC_Menu_TReset",        "Rafraîchir Statistiques")
ZO_CreateStringId("FTC_Menu_TResetDesc",    "Réinitialiser les paramètres originaux du composant de statistiques de dégats de FTC.")