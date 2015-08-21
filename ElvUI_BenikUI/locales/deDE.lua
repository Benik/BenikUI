-- German localization file for deDE
local AceLocale = LibStub:GetLibrary('AceLocale-3.0');
local L = AceLocale:NewLocale('ElvUI', 'deDE');
if not L then return; end

--core
L[' is loaded. For any issues or suggestions, please visit '] = " ist geladen. Für Fehler oder Vorschläge besucht bitte: "

-- General options
L['by Benik (EU-Emerald Dream)'] = "von Benik (EU-Emerald Dream)"
L["BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with "] = "BenikUI ist ein komplett externer ElvUI Mod. Weitere verfügbare Optionen findest Du in den ElvUI Optionen (z.B. Aktionsleisten, Einheitenfenster, Spieler und Ziel Portrait), markiert in "
L['light blue color.'] = "hell blau"
L["Credits:"] = "Danksagung:"
L['Force BenikUI fonts'] = "Erzwinge BenikUI Schriftart"
L['Enables BenikUI fonts overriding the default combat and name fonts. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r'] = "Ermöglicht die BenikUI Schriftart, die vorhandene Kampf- und Namensschriftart zu überschreiben. |cffFF0000WARNUNG: Damit die Änderungen wirksam werden, ist ein Neustart des Spiels oder ein Re-Log erforderlich.|r"
L['BenikUI Style'] = "BenikUI Stil"
L['Show/Hide the decorative bars from UI elements'] = "Dekorative Leisten von den UI Elementen anzeigen/ausblenden"
L['Game Menu Color'] = "Spielmenü Farbe"
L['ActionBar Style Color'] = "Aktionsleiste Stil Farbe"
L['Style Color'] = "Stil Farbe"
L['ShiftClick to toggle chat'] = "ShiftKlick um Chat umzuschalten"

-- DataTexts
L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'] = "Chat Infotexte anzeigen/ausblenden. ElvUI Infotexte müssen dafür deaktiviert sein"
L['Hide Mail Icon'] = "Verstecke das Postsymbol"
L['Show/Hide Mail Icon on minimap'] = "Postsymbol an der Minimap anzeigen/ausblenden"
L['Show Garrison Currency'] = "Zeige Garnisonsresourcen"
L['Show Oil'] = "Zeige Öl"
L['Show/Hide garrison currency on the datatext tooltip'] = "Garnisonsressourcen am Infotext Tooltip anzeigen/ausblenden"
L['Show/Hide oil on the datatext tooltip'] = "Öl am Infotext Tooltip anzeigen/ausbenden"
L['Middle'] = "Mittlerer"
L['BenikUI Middle DataText'] = "BenikUI mittlerer Infotext"
L['Styles the chat datetexts and buttons only if both chat backdrops are set to "Hide Both".'] = "Passt die Chatinfotexte und Tasten an, wenn der Chathintergrund auf 'Verstecke Beide' gesetzt ist."

-- install
L['Color Theme Set'] = "Farbschema setzen"
L['Actionbars Set'] = "Aktionsleisten setzen"
L['Unitframes Set'] = "Einheitenfenster setzen"
L['- %s profile successfully created!'] = "- %s Profil erfolgreich erstellt!"
L['Addons Set'] = "Addons setzen"
L['DataTexts Set'] = "Infotexte setzen"
L['Welcome to BenikUI version %s, for ElvUI %s.'] = "Willkommen zu BenikUI Version %s, für ElvUI %s."
L["By pressing the Continue button, BenikUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = "Durch drücken der Weiter-Taste werden die BenikUI-Änderungen in der vorhandenen ElvUI Installation angewand.\r|cffff8000 TIP: Es wäre gut, wenn Du die Änderungen in einem neuen Profil erstellst. Nur für den Fall dass Du mit den Änderungen nicht zufrieden bist.|r"
L['This part of the installation changes the default ElvUI look. This is why you downloaded BenikUI :)'] = "Dieser Teil der Installation ändert das standard Aussehen von ElvUI. Dieses ist ja auch der Grund warum Du BenikUI heruntergeladen hast :)"
L['Please click the button below to apply the new layout.'] = "Bitte klick die Taste unten um das neue Layout anzuwenden."
L['Setup Layout'] = "Layout einstellen"
L['Color Themes'] = "Farbschema"
L['This part of the installation will apply a Color Theme'] = "Dieser Teil der Installation wendet ein Farbschema an"
L['Please click a button below to apply a color theme.'] = "Bitte klick eine der Tasten unten um ein Farbschema anzuwenden."
L['ElvUI'] = true
L['Diablo'] = true
L['Mists'] = true
L['Hearthstone'] = true
L['This part of the installation process sets up your chat fonts and colors.'] = "Dieser Teil des Installationsprozesses ändert die Chatschrifart und -farbe." 
L['Please click the button below to setup your chat windows.'] = "Bitte klick auf die Taste unten um das Chatfenster einzustellen."
L['UnitFrames'] = "Einheitenfenster"
L["This part of the installation process will reposition your Unitframes and will enable the EmptyBars.\r|cffff8000This doesn't touch your current raid/party layout|r"] = "Dieser Teil des Installationsprozesses wird die Einheitenfenster neu positionieren und die leere Leiste aktivieren.\r|cffff8000Dies ändert nicht die Einstellungen des aktuellen Schlatzug-/Gruppenlayouts|r"
L['Please click the button below to setup your Unitframes.'] = "Bitte klick auf die Taste unten um das Einheitenfenster einzustellen."
L['Setup Unitframes'] = "Einheitenfenster einstellen"
L['This part of the installation process will reposition your Actionbars and will enable backdrops'] = "Dieser Teil des Installationsprozesses wird die Aktionsleisten neu positionieren und wird den Hintergrund einschalten"
L['Please click the button below to setup your actionbars.'] = "Bitte klick auf die Taste unten um die Aktionsleisten einzustellen."
L['Setup ActionBars'] = "Aktionsleisten einstellen"
L["This part of the installation process will fill BenikUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = "Dieser Teil des Installationsprozesses wird die BenikUI Infotexte einstellen.\r|cffff8000Hierbei werden die ElvUI Infotexte nicht verändert|r"
L['Please click the button below to setup your datatexts.'] = "Bitte klick auf die Taste unten um die Infotexte einzustellen."
L['This part of the installation process will apply changes to the addons like Recount, DBM and ElvUI plugins'] = "Dieser Teil des Installationsprozesses wird Änderungen an Addons wie Recount, DBM und andere ElvUI Plugins vornehmen"
L['Please click the button below to setup your addons.'] = "Bitte klick auf die Taste unten um deine Addons einzustellen."
L['Setup Addons'] = "Addons einstellen"
L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'] = "Du hast den Installationsprozess jetzt abgeschlossen. Wenn du technische Unterstützung brauchst besuch uns bitte http://www.tukui.org."
L['Installation'] = true

-- actionbar options
L['Transparent Backdrops'] = "Transparente Hintergründe"
L['Applies transparency in all actionbar backdrops and actionbar buttons.'] = "Aktiviert die Transparenz auf alle Aktionsleisten Hintergründe und Tasten."
L['Switch Buttons'] = "Tasten wechseln"
L['Show small buttons over Actionbar 1 or 2 decoration, to show/hide Actionbars 3 or 5.'] = "Zeigt kleine Tasten über Aktionsleiste 1 oder 2, um Aktionsleiste 3 oder 5 anzuzeigen/auszublenden."
L['Show in:'] = "Zeige in:"
L['Choose Actionbar to show to'] = "Wähle Aktionsleiste zum Anzeigen"
L['Bar 1'] = "Leiste 1"
L['Bar 2'] = "Leiste 2"
L['Toggle Bar'] = "Leiste umschalten"
L['Request Stop button'] = "Haltewunschtaste"

-- Request stop button
L['LeftClick to Request Stop'] = "Links-Klick um am nächsten Flugpunkt zu landen"
L['RightClick to Hide'] = "Rechts-Klick zum verstecken"

-- afk Mode
L["Logout Timer"] = "Auslogzeit"
L["Random Stats"] = "Zufällige Werte"

-- Dashboards
L['System'] = true
L['Dashboards'] = true
L['Enable the System Dashboard.'] = "Aktiviert das System Dashboard."
L['Show/Hide System Dashboard when in combat'] = "Dashboard im Kampf anzeigen/ausblenden"
L['Change the System Dashboard width.'] = "Ändert die Dashboard Breite"
L['Enable the Tokens Dashboard.'] = "Aktivert das Abzeichen Dashboard."
L['Show/Hide Tokens Dashboard when in combat'] = "Abzeichen Dashboard im Kampf anzeigen/ausblenden"
L['Show zero amount tokens'] = "Zeige Abzeichen mit der Anzahl 0"
L['Show the token, even if the amount is 0'] = "Abzeichen anzeigen, auch wenn die Anzahl 0 ist"
L['Show/Hide Tooltips'] = "Tooltip anzeigen/ausblenden"
L['Flash on updates'] = "Beim Updaten blinken"
L['Select Tokens'] = "Abzeichen auswählen"
L['Use DataTexts font'] = "Benutze Infotext Schriftart"
L['Choose font for all dashboards.'] = "Wähle Schriftart für alle Dashboards."
L['Set the font size.'] = "Schriftgröße auswählen."
L['Enable/Disable '] = "Aktivieren/Deaktivieren"
L['Click :'] = "Klick :"
L['RightClick :'] = "Rechtsklick :"
L['MouseWheel :'] = "Mausrad :"
L['Tip: Grayed tokens are not yet discovered'] = "Ausgegraute Abzeichen sind bis jetzt noch nicht entdeckt"
L['Select Professions'] = "Berufe auswählen"
L['Select System Board'] = "Wähle System Board"
L['Bar Color'] = "Leistenfarbe"
L['Memory: '] = "Speicher"
L['ZYGOR_CONFLICT_WARNING'] = "Es wurde berichtet, das Zygor Guides Probleme mit dem Speicher-Dashboard hat.\nKlick "..CONTINUE.." um das Speicher-Modul zu deaktivieren oder 'Ich verstehe' um dieses Popup zu schließen." -- bad translation (need review)

-- DataTexts
L['|cff00ff00New Mail|r'] = "|cff00ff00Neue Post|r"
L['No Mail'] = "Keine Post"

-- Misc Options
L['Show in PlayerBar'] = "Zeige in Spielerleiste"
L['Empty Frames must be enabled \n(in UnitFrames options)'] = "Leerer Rahmen muss aktiviert sein \n(in Einheitenfenster Option)"
L['Copy Font Style from'] = "Kopiere Schriftart von"
L['Hide PlayerBar text values'] = "Verberge Text Werte auf der Spielerleiste"
L['Hides health, power and custom text values when mousing over, if their yOffset is'] = "Blendet Gesundheit, Kraft und angepasste Text Werte aus, wenn der Y-Versatz ist"
L['Show BenikUI decorative bars on the default ElvUI xp/rep bars'] = "Zeigt die BenikUI dekorative Leisten auf den Standard ElvUI Erfahrungs-/Rufleisten"

-- Skins Options
L['AddOns Decor'] = "AddOns Dekor"
L['Choose which addon you wish to be decorated to fit with BenikUI style'] = "Wähle aus, welches Addon du stylen möchtest so dass es am besten zu BenikUI passt"
L['ElvUI AddOns'] = true
L['decor.'] = "Dekor."
L['AddOnSkins'] = true
L['Decursive'] = true

-- Castbar
L['CONFLICT_WARNING'] = 'Es sieht so aus, als würdest du ElvUI_CastBarPowerOverlay oder ElvUI_CastBarSnap aktiviert haben. BenikUI abgetrente Zauberleisten wurden deaktiviert.'
L['I understand'] = "Ich verstehe"
L['Hide Emptybar text'] = "Verstecke Leere Rahmen Text"
L['Hide any text placed on the Emptybars, while casting.'] = "Verstecke jeden Text auf den Leeren Rahmen während des Zauberns."

-- UnitFrame Options
L['Empty Frames'] = "Leerer Rahmen"
L['Enable the Empty frames (Player and Target).'] = "Aktiviere die Leeren Rahmen (Spieler und Ziel)."
L['Toggle EmptyBars transparency'] = "Leere Rahmen Transparenz umschalten"
L['Change the Empty frames height (Player and Target).'] = "Ändere die Leere Rahmen Höhe (Spieler und Ziel)."
L['PowerBar Texture'] = "Kraftleiste Textur"
L['Power statusbar texture.'] = "Kraft Statusleiste Textur."
L['Attach on Empty Frames'] = "Anheften an Leere Rahmen"
L['Attaches Player and Target Castbar on the Empty Frames.'] = "Richtet Spieler- und Zielzauberleiste an den leeren Rahmen aus."
L['Castbar Text'] = "Zauberleisten Text"
L['Show/Hide the Castbar text.'] = "Zauberleisten Text anzeigen/ausblenden"
L['Adjust text Y Offset'] = "Passe Text Y-Versatz an"
L['Detach Portrait'] = "Abgetrenntes Portrait"
L['Apply transparency on the portrait backdrop.'] = "Wende Transparenz auf den Portrait Hintergrund an."
L['Shadow'] = "Schatten"
L['Apply shadow under the portrait'] = "Aktiviere den Schatten unter dem Portrait"
L['Change the detached portrait width'] = "Ändert die Breite des abgetrennten Portrait"
L['Change the detached portrait height'] = "Ändert die Höhe des abgetrennten Portrait"
L['Player Size'] = "Spieler Größe"
L['Copy Player portrait width and height'] = "Kopiere Spieler Portrait Breite und Höhe"

-- Addon friendly names
L['LocationLite'] = true
L['LocationPlus'] = true
L['Shadow & Light'] = true
L['Square Minimap Buttons'] = true
L['ElvUI_Enhanced'] = true
L['Rare Coordinator'] = true
L['Skada'] = true
L['Recount'] = true
L['TinyDPS'] = true
L['AtlasLoot'] = true
L['Altoholic'] = true
L['Zygor Guides'] = true
L['Clique'] = true
L['oRA3'] = true