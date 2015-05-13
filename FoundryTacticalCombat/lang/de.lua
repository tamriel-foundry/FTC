
--[[----------------------------------------------------------
    GERMAN LANGUAGE LOCALIZATION
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Name",               "Foundry Tactical Combat")
ZO_CreateStringId("FTC_ShortInfo",          "Foundry Tactical Combat by Atropos")
ZO_CreateStringId("FTC_LongInfo",           "Du benutzt die Foundry Tactical Combat Version " .. FTC.version .. " entwickelt von Atropos der Tamriel Foundry.")

--[[----------------------------------------------------------
    KEYBINDINGS
  ]]----------------------------------------------------------
ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_COMBAT_LOG", "Aktiviere den Kampflog")
 
--[[----------------------------------------------------------
    MENU CORE
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_Configure",     "Addon Komponenten Einstellungen")
ZO_CreateStringId("FTC_Menu_Reload",        "Durch die Veränderung dieser Einstellung wird das UI neu gelanden")
ZO_CreateStringId("FTC_Menu_NeedReload",    "Veränderungen an dieser Einstellung werden erst aktiv nachdem das UI neu geladen wurde!")
 
ZO_CreateStringId("FTC_Menu_Frames",        "Anzeigeelemente aktivieren")
ZO_CreateStringId("FTC_Menu_FramesDesc",    "Aktiviere die Anzeigeelemente? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_Buffs",         "Buffs aktivieren")
ZO_CreateStringId("FTC_Menu_BuffsDesc",     "Aktiviere die Anzeige der aktiven Buffs? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_Log",           "Kampflog aktivieren")
ZO_CreateStringId("FTC_Menu_LogDesc",       "Aktiviere die Kampflog Anzeige? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_Damage",        "Schadensstatistik aktivieren")
ZO_CreateStringId("FTC_Menu_DamageDesc",    "Aktiviere die Anzeige der Schadensstatistik? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_SCT",           "Schadenswerte aktivieren")
ZO_CreateStringId("FTC_Menu_SCTDesc",       "Aktiviere die Anzeige der Schadenswerte? [Standard: Aktiviert]")
 
--ZO_CreateStringId("FTC_Menu_Hotbar",      "Enable Advanced Hotbar")
--ZO_CreateStringId("FTC_Menu_HotbarDesc",  "Enable advanced tooltips displayed over the default hotbar? [Standard: Aktiviert]")
 
--[[----------------------------------------------------------
    UNIT FRAMES
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_FHeader",       "Anzeigeeinstellungen")
 
ZO_CreateStringId("FTC_Menu_FText",         "Text in Standard Anzeigeelementen anzeigen")
ZO_CreateStringId("FTC_Menu_FTextDesc",     "Attribut-Werte in Standard Anzeigeelementen anzeigen? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_FWidth",        "Anzeigeelemente Breite")
ZO_CreateStringId("FTC_Menu_FWidthDesc",    "Ändert die Breite der Anzeigeelemente. [Standard: 350]")
 
ZO_CreateStringId("FTC_Menu_FHeight",       "Anzeigeelemente Höhe")
ZO_CreateStringId("FTC_Menu_FHeightDesc",   "Ändert die Höhe der Anzeigeelemente. [Standard: 210]")
 
ZO_CreateStringId("FTC_Menu_FOpacIn",       "Deckkraft im Kampf")
ZO_CreateStringId("FTC_Menu_FOpacInDesc",   "Ändert die Deckkraft der Anzeigeelemente während eines Kampfes. [Standard: 100]")
 
ZO_CreateStringId("FTC_Menu_FOpacOut",      "Deckkraft außerhalb eines Kampfes")
ZO_CreateStringId("FTC_Menu_FOpacOutDesc",  "Ändert die Deckkraft der Anzeigeelemente außerhalb eines Kampfes. Je niedriger desto durchsichtiger. [Standard: 60]")
 
ZO_CreateStringId("FTC_Menu_FFont1",        "Primäre Schriftart")
ZO_CreateStringId("FTC_Menu_FFont1Desc",    "Ändert die primäre Schriftart der FTC Anzeigeelemente. [Standard: Trajan Pro]")
 
ZO_CreateStringId("FTC_Menu_FFont2",        "Sekundäre Schriftart")
ZO_CreateStringId("FTC_Menu_FFont2Desc",    "Ändert die sekundäre Schriftart der FTC Anzeigeelemente. [Standard: ESO Bold]")
 
ZO_CreateStringId("FTC_Menu_FFontS",        "Schriftgröße")
ZO_CreateStringId("FTC_Menu_FFontSDesc",    "Ändert die Schriftgröße der FTC Anzeigeelemente. [Standard: 18]")
 
ZO_CreateStringId("FTC_Menu_Exceute",       "Hinrichten Schwelle")
ZO_CreateStringId("FTC_Menu_ExecuteDesc",   "Ändert den Wert der erreicht werden muss damit ein Alarm angezeigt wird. [Standard: 25]")
 
ZO_CreateStringId("FTC_Menu_FShowDef",      "Standard Zielanzeige anzeigen")
ZO_CreateStringId("FTC_Menu_FShowDefDesc",  "Standard ESO Zielanzeige weiterhin anzeigen? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_FShowName",     "Spieler Namen anzeigen")
ZO_CreateStringId("FTC_Menu_FShowNameDesc", "Eigenen Namen über der FTC Anzeigeelemente anzeigen? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_FShowXP",       "Mini Erfahrungsleiste aktivieren")
ZO_CreateStringId("FTC_Menu_FShowXPDesc",   "Zeige eine kleine Erfahrungsleiste unter dem FTC Spielerelement an? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_FHealthC",      "Farbe der Lebensleiste")
ZO_CreateStringId("FTC_Menu_FHealthCDesc",  "Ändert die Farbe der Lebensleiste der FTC Anzeigeelemente. [Standard: 153,0,0]")
 
ZO_CreateStringId("FTC_Menu_FMagickaC",     "Farbe der Magieleiste")
ZO_CreateStringId("FTC_Menu_FMagickaCDesc", "Ändert die Farbe der Magieleiste der FTC Anzeigeelemente. [Standard: 102,102,204]")
 
ZO_CreateStringId("FTC_Menu_FStaminaC",     "Farbe der Ausdauerleiste")
ZO_CreateStringId("FTC_Menu_FStaminaCDesc", "Ändert die Farbe der Ausdauerleiste der FTC Anzeigeelemente. [Standard: 0,102,0]")
 
ZO_CreateStringId("FTC_Menu_FShieldC",      "Farbe der Schildleiste")
ZO_CreateStringId("FTC_Menu_FShieldCDesc",  "Ändert die Farbe der Schildleiste der FTC Anzeigeelemente. [Standard: 255,153,0]")
 
ZO_CreateStringId("FTC_Menu_FReset",        "Zurücksetzen")
ZO_CreateStringId("FTC_Menu_FResetDesc",    "Setzt die FTC Anzeigeelemente zurück auf die Standardwertet.")
 
--[[----------------------------------------------------------
    BUFF TRACKING
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_BHeader",       "Buff-Anzeige Einstellungen")
 
ZO_CreateStringId("FTC_Menu_BAnchor",       "Buff-Anzeige ausrichten")
ZO_CreateStringId("FTC_Menu_BAnchorDesc",   "Richte die Buff-Anzeige an den Anzeigeelementen aus? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_Menu_BLong",         "Lang anhaltende Buffs anzeigen")
ZO_CreateStringId("FTC_Menu_BLongDesc",     "Zeige lang anhaltende Spieler Buffs an? [Standard: Aktiviert]")
 
ZO_CreateStringId("FTC_BuffFormat0",        "Deaktiviert")
ZO_CreateStringId("FTC_BuffFormat1",        "Horizontale Ausrichtung")
ZO_CreateStringId("FTC_BuffFormat2",        "Vertikale Ausrichtung")
ZO_CreateStringId("FTC_BuffFormat3",        "Absteigende Liste")
ZO_CreateStringId("FTC_BuffFormat4",        "Aufsteigende Liste")
 
ZO_CreateStringId("FTC_Menu_BPBFormat",     "Spieler Buff Format")
ZO_CreateStringId("FTC_Menu_BPBFormatDesc", "Wähle das gewünschte Format für Spieler Buffs. [Standard: Horizontale Ausrichtung]")
 
ZO_CreateStringId("FTC_Menu_BPDFormat",     "Spieler Debuff Format")
ZO_CreateStringId("FTC_Menu_BPDFormatDesc", "Wähle das gewünschte Format für Spieler Debuffs. [Standard: Horizontale Ausrichtung]")
 
ZO_CreateStringId("FTC_Menu_BLBFormat",     "Lang anhaltende Buffs Format")
ZO_CreateStringId("FTC_Menu_BLBFormatDesc", "Wähle das gewünschte Format für lang anhaltende Buffs. [Standard: Vertikale Ausrichtung]")
 
ZO_CreateStringId("FTC_Menu_BTBFormat",     "Ziel Buff Format")
ZO_CreateStringId("FTC_Menu_BTBFormatDesc", "Wähle das Format der Ziel Buffs. [Standard: Horizontale Ausrichtung]")
 
ZO_CreateStringId("FTC_Menu_BTDFormat",     "Ziel Debuff Format")
ZO_CreateStringId("FTC_Menu_BTDFormatDesc", "Wähle das Format der Ziel debuffs. [Standard: Horizontale Ausrichtung]")
 
ZO_CreateStringId("FTC_Menu_BFont1",        "Primäre Schriftart")
ZO_CreateStringId("FTC_Menu_BFont1Desc",    "Ändert die primäre Schriftart der FTC Buff Komponente. [Standard: ESO Bold]")
 
ZO_CreateStringId("FTC_Menu_BFont2",        "Sekundäre Schriftart")
ZO_CreateStringId("FTC_Menu_BFont2Desc",    "Ändert die sekundäre Schriftart der FTC Buff Komponente. [Standard: ESO Bold]")
 
ZO_CreateStringId("FTC_Menu_BFontS",        "Schriftgröße")
ZO_CreateStringId("FTC_Menu_BFontSDesc",    "Ändert die Schriftgröße der FTC Buff Komponente. [Standard: 18]")
 
ZO_CreateStringId("FTC_Menu_BReset",        "Zurücksetzen")
ZO_CreateStringId("FTC_Menu_BResetDesc",    "Setzt die FTC Buff Einstellungen zurück auf die Standardwertet.")
 
--[[----------------------------------------------------------
    COMBAT LOG
  ]]----------------------------------------------------------
ZO_CreateStringId("FTC_Menu_LHeader",       "Kampflog Einstellungen")
 
--ZO_CreateStringId("FTC_Menu_LAltChat",    "Alternate With Chat")
ZO_CreateStringId("FTC_Menu_LAltChatDesc",  "Kampflog nur anzeigen wenn der Chat minimiert ist?")
 
ZO_CreateStringId("FTC_Menu_LFont",         "Schriftart")
ZO_CreateStringId("FTC_Menu_LFontDesc",     "Ändert die Schriftart des FTC Kampflogs. [Standard: ESO Standard]")
 
ZO_CreateStringId("FTC_Menu_LFontS",        "Schriftgröße")
ZO_CreateStringId("FTC_Menu_LFontSDesc",    "Ändert die Schriftgröße des FTC Kampflogs. [Standard: 16]")
 
ZO_CreateStringId("FTC_Menu_LReset",        "Zurücksetzen")
ZO_CreateStringId("FTC_Menu_LResetDesc",    "Setzt die FTC Kampflog Einstellungen zurück auf die Standardwertet.")
