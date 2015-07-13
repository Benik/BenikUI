-- English localization file for enUS
local AceLocale = LibStub:GetLibrary('AceLocale-3.0');
local L = AceLocale:NewLocale('ElvUI', 'enUS');
if not L then return; end

 --core
L[' is loaded. For any issues or suggestions, please visit '] = true

-- General options
L['by Benik (EU-Emerald Dream)'] = true
L["BenikUI is a completely external ElvUI mod. More available options can be found in ElvUI options (e.g. Actionbars, Unitframes, Player and Target Portraits), marked with "] = true
L['light blue color.'] = true
L["Credits:"] = true
L['Force BenikUI fonts'] = true
L['Enables BenikUI fonts overriding the default combat and name fonts. |cffFF0000WARNING: This requires a game restart or re-log for this change to take effect.|r'] = true
L['BenikUI Style'] = true
L['Show/Hide the decorative bars from UI elements'] = true
L['Game Menu Color'] = true
L['ActionBar Style Color'] = true
L['ShiftClick to toggle chat'] = true

-- DataTexts
L['Show/Hide Chat DataTexts. ElvUI chat datatexts must be disabled'] = true
L['Hide Mail Icon'] = true
L['Show/Hide Mail Icon on minimap'] = true
L['Show Garrison Currency'] = true
L['Show/Hide garrison currency on the datatext tooltip'] = true
L['Middle'] = true
L['BenikUI Middle DataText'] = true

-- install
L['Color Theme Set'] = true
L['Actionbars Set'] = true
L['Unitframes Set'] = true
L['- %s profile successfully created!'] = true
L['Addons Set'] = true
L['DataTexts Set'] = true
L['Welcome to BenikUI version %s, for ElvUI %s.'] = true
L["By pressing the Continue button, BenikUI will be applied in your current ElvUI installation.\r|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"] = true
L['BenikUI options are marked with light blue color, inside ElvUI options.'] = true
L['This part of the installation changes the default ElvUI look. This is why you downloaded BenikUI :)'] = true
L['Please click the button below to apply the new layout.'] = true
L['Setup Layout'] = true
L['Color Themes'] = true
L['This part of the installation will apply a Color Theme'] = true
L['Please click a button below to apply a color theme.'] = true
L['ElvUI'] = true
L['Diablo'] = true
L['Mists'] = true
L['Hearthstone'] = true
L['This part of the installation process sets up your chat fonts and colors.'] = true
L['Please click the button below to setup your chat windows.'] = true
L['UnitFrames'] = true
L["This part of the installation process will reposition your Unitframes and will enable the EmptyBars.\r|cffff8000This doesn't touch your current raid/party layout|r"] = true
L['Please click the button below to setup your Unitframes.'] = true
L['Setup Unitframes'] = true
L['This part of the installation process will reposition your Actionbars and will enable backdrops'] = true
L['Please click the button below to setup your actionbars.'] = true
L['Setup ActionBars'] = true
L["This part of the installation process will fill BenikUI datatexts.\r|cffff8000This doesn't touch ElvUI datatexts|r"] = true
L['Please click the button below to setup your datatexts.'] = true
L['This part of the installation process will apply changes to the addons like Recount, DBM and ElvUI plugins'] = true
L['Please click the button below to setup your addons.'] = true
L['Setup Addons'] = true
L['You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org.'] = true
L['Installation'] = true

-- actionbar options
L['Transparent Backdrops'] = true
L['Applies transparency in all actionbar backdrops and actionbar buttons.'] = true
L['Switch Buttons'] = true
L['Show small buttons over Actionbar 1 or 2 decoration, to show/hide Actionbars 3 or 5.'] = true
L['Show in:'] = true
L['Choose Actionbar to show to'] = true
L['Bar 1'] = true
L['Bar 2'] = true
L['Toggle Bar'] = true
L['Request Stop button'] = true

-- Request stop button
L['LeftClick to Request Stop'] = true
L['RightClick to Hide'] = true

-- afk Mode
L["Logout Timer"] = true
L["Random Stats"] = true

-- Dashboards
L['System'] = true
L['Dashboards'] = true
L['Enable the System Dashboard.'] = true
L['Show/Hide System Dashboard when in combat'] = true
L['Change the System Dashboard width.'] = true
L['Enable the Tokens Dashboard.'] = true
L['Show/Hide Tokens Dashboard when in combat'] = true
L['Show zero amount tokens'] = true
L['Show the token, even if the amount is 0'] = true
L['Show/Hide Tooltips'] = true
L['Flash on updates'] = true
L['Select Tokens'] = true
L['Use DataTexts font'] = true
L['Choose font for all dashboards.'] = true
L['Set the font size.'] = true
L['Enable/Disable '] = true
L['Click :'] = true
L['RightClick :'] = true
L['MouseWheel :'] = true
L['Tip: Grayed tokens are not yet discovered'] = true
L['Select Professions'] = true
L['Select System Board'] = true
L['Bar Color'] = true
L['Memory: '] = true
L['ZYGOR_CONFLICT_WARNING'] = "It has been reported that Zygor Guides has issues with Dashboard Memory module.\nClick "..CONTINUE.." to disable the Memory module or 'I understand' to close this popup"

-- DataTexts
L['|cff00ff00New Mail|r'] = true
L['No Mail'] = true

-- Misc Options
L['Show in PlayerBar'] = true
L['Empty Frames must be enabled \n(in UnitFrames options)'] = true
L['Copy Font Style from'] = true
L['Hide PlayerBar text values'] = true
L['Hides health, power and custom text values when mousing over, if their yOffset is'] = true

-- Skins Options
L['AddOns Decor'] = true
L['Choose which addon you wish to be decorated to fit with BenikUI style'] = true
L['ElvUI AddOns'] = true
L['decor.'] = true
L['AddOnSkins'] = true
L['Decursive'] = true

-- Castbar
L['CONFLICT_WARNING'] = 'It would appear you have ElvUI_CastBarPowerOverlay or ElvUI_CastBarSnap loaded. BenikUI Attach Castbar feature has been disabled.'
L['I understand'] = true
L['Hide Emptybar text'] = true
L['Hide any text placed on the Emptybars, while casting.'] = true

-- UnitFrame Options
L['Empty Frames'] = true
L['Enable the Empty frames (Player and Target).'] = true
L['Toggle EmptyBars transparency'] = true
L['Change the Empty frames height (Player and Target).'] = true
L['PowerBar Texture'] = true
L['Power statusbar texture.'] = true
L['Attach on Empty Frames'] = true
L['Attaches Player and Target Castbar on the Empty Frames.'] = true
L['Castbar Text'] = true
L['Show/Hide the Castbar text.'] = true
L['Adjust text Y Offset'] = true
L['Detach Portrait'] = true
L['Apply transparency on the portrait backdrop.'] = true
L['Shadow'] = true
L['Apply shadow under the portrait'] = true
L['Change the detached portrait width'] = true
L['Change the detached portrait height'] = true
L['Player Size'] = true
L['Copy Player portrait width and height'] = true