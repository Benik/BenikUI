local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

local ceil, format, checkTable = ceil, format, next
local tinsert, twipe, tsort, tconcat = table.insert, table.wipe, table.sort, table.concat
local _G = _G

local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local PlaySoundFile = PlaySoundFile
local ReloadUI = ReloadUI
local UIFrameFadeOut = UIFrameFadeOut
local FCF_SetLocked = FCF_SetLocked
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_StopDragging = FCF_StopDragging
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local CONTINUE, PREVIOUS, ADDONS = CONTINUE, PREVIOUS, ADDONS
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local LOOT, TRADE = LOOT, TRADE
local TANK, HEALER = TANK, HEALER

local CreateAnimationGroup = CreateAnimationGroup

-- GLOBALS: BUIInstallFrame, BUITitleFrame, InstallStepComplete, InstallStatus, InstallNextButton, InstallPrevButton
-- GLOBALS: InstallOption1Button, InstallOption2Button, InstallOption3Button, InstallOption4Button, LeftChatToggleButton
-- GLOBALS: RecountDB, SkadaDB, DBM, DBM_AllSavedOptions, DBT_AllPersistentOptions, MSBTProfiles_SavedVars, MikSBT

local CURRENT_PAGE = 0
local MAX_PAGE = 9

local titleText = {}

local function SetupLayout(layout)
	-- common settings
	E.db["bags"]["sortInverted"] = false
	E.db["chat"]["panelBackdrop"] = 'SHOWBOTH'
	E.db["chat"]["timeStampFormat"] = "%H:%M "
	E.db["databars"]["artifact"]["enable"] = true
	E.db["databars"]["artifact"]["height"] = 150
	E.db["databars"]["artifact"]["orientation"] = 'VERTICAL'
	E.db["databars"]["artifact"]["textFormat"] = 'NONE'
	E.db["databars"]["artifact"]["textSize"] = 9
	E.db["databars"]["artifact"]["width"] = 8
	E.db["databars"]["experience"]["font"] = "Expressway"
	E.db["databars"]["experience"]["textYoffset"] = 10
	E.db["databars"]["experience"]["textFormat"] = "CURPERC"
	E.db["databars"]["experience"]["height"] = 6
	E.db["databars"]["experience"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["experience"]["textSize"] = 10
	E.db["databars"]["honor"]["enable"] = true
	E.db["databars"]["honor"]["height"] = 152
	E.db["databars"]["honor"]["textFormat"] = 'NONE'
	E.db["databars"]["honor"]["textSize"] = 9
	E.db["databars"]["honor"]["width"] = 8	
	E.db["databars"]["reputation"]["enable"] = true
	E.db["databars"]["reputation"]["height"] = 150
	E.db["databars"]["reputation"]["orientation"] = 'VERTICAL'
	E.db["databars"]["reputation"]["textFormat"] = 'NONE'
	E.db["databars"]["reputation"]["textSize"] = 9
	E.db["databars"]["reputation"]["width"] = 8
	E.db["datatexts"]["leftChatPanel"] = false
	E.db["datatexts"]["panelTransparency"] = true
	E.db["datatexts"]["rightChatPanel"] = false
	E.db["general"]["backdropcolor"]["b"] = 0.025
	E.db["general"]["backdropcolor"]["g"] = 0.025
	E.db["general"]["backdropcolor"]["r"] = 0.025
	E.db["general"]["backdropfadecolor"]["b"] = 0.054
	E.db["general"]["backdropfadecolor"]["g"] = 0.054
	E.db["general"]["backdropfadecolor"]["r"] = 0.054
	E.db["general"]["bordercolor"]["b"] = 0
	E.db["general"]["bordercolor"]["g"] = 0
	E.db["general"]["bordercolor"]["r"] = 0
	E.db["general"]["bottomPanel"] = false
	E.db["general"]["minimap"]["locationText"] = "HIDE"
	E.db["general"]["minimap"]["size"] = 150
	E.db["general"]["objectiveFrameHeight"] = 750
	E.db["general"]["stickyFrames"] = true
	E.db["general"]["topPanel"] = false
	E.db["general"]["valuecolor"]["a"] = 1
	E.db["general"]["valuecolor"]["b"] = 0
	E.db["general"]["valuecolor"]["g"] = 0.5
	E.db["general"]["valuecolor"]["r"] = 1
	E.db["hideTutorial"] = true
	
	E.db["benikuiDatabars"]["artifact"]["buttonStyle"] = "DEFAULT"
	E.db["benikuiDatabars"]["artifact"]["notifiers"]["position"] = "RIGHT"
	E.db["benikuiDatabars"]["reputation"]["buttonStyle"] = "DEFAULT"
	E.db["benikuiDatabars"]["reputation"]["notifiers"]["position"] = "LEFT"
	E.db["benikuiDatabars"]["honor"]["buttonStyle"] = "TRANSPARENT"
	E.db["benikuiDatabars"]["honor"]["notifiers"]["position"] = "LEFT"
	E.db["benikuiDatabars"]["experience"]["buiStyle"] = false
	
	E.private["general"]["normTex"] = "BuiFlat"
	E.private["general"]["glossTex"] = "BuiFlat"
	E.private["general"]["chatBubbles"] = 'backdrop'
	
	if layout == 'classic' then
		E.db["general"]["font"] = "Bui Prototype"
		E.db["general"]["fontSize"] = 10

		E.db["chat"]["tabFont"] = "Bui Visitor1"
		E.db["chat"]["tabFontSize"] = 10
		E.db["chat"]["tabFontOutline"] = "MONOCROMEOUTLINE"
		E.db["chat"]["font"] = "Bui Prototype"
		E.db["chat"]["panelHeight"] = 150
		E.db["chat"]["panelWidth"] = 412
		
		E.private["general"]["dmgfont"] = "Bui Prototype"
		E.private["general"]["chatBubbleFont"] = "Bui Prototype"
		E.private["general"]["chatBubbleFontSize"] = 14
		E.private["general"]["namefont"] = "Bui Prototype"
		
		E.private["skins"]["blizzard"]["alertframes"] = true
		E.private["skins"]["blizzard"]["questChoice"] = true

		E.db["datatexts"]["font"] = "Bui Visitor1"
		E.db["datatexts"]["fontSize"] = 10
		E.db["datatexts"]["fontOutline"] = "MONOCROMEOUTLINE"

		E.db["bags"]["itemLevelFont"] = "Bui Prototype"
		E.db["bags"]["itemLevelFontSize"] = 10
		E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
		E.db["bags"]["countFont"] = "Bui Prototype"
		E.db["bags"]["countFontSize"] = 10
		E.db["bags"]["countFontOutline"] = "OUTLINE"

		E.db["tooltip"]["healthBar"]["font"] = "Bui Prototype"
		E.db["tooltip"]["healthBar"]["fontSize"] = 9
		E.db["tooltip"]["healthBar"]["fontOutline"] = "OUTLINE"
		E.db["tooltip"]["font"] = "Bui Prototype"
		E.db["tooltip"]["fontOutline"] = 'NONE'
		E.db["tooltip"]["headerFontSize"] = 10
		E.db["tooltip"]["textFontSize"] = 10
		E.db["tooltip"]["smallTextFontSize"] = 10

		E.db["nameplates"]["font"] = "Bui Visitor1"
		E.db["nameplates"]["fontSize"] = 10
		E.db["nameplates"]["fontOutline"] = 'MONOCHROMEOUTLINE'
		E.db["nameplates"]["statusbar"] = "BuiFlat"

		E.db["benikui"]["misc"]["ilevel"]["font"] = "Bui Prototype"
		E.db["benikui"]["misc"]["ilevel"]["fontsize"] = 9

		-- Movers
		E.db["movers"]["AlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-140"
		E.db["movers"]["BNETMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-182"
		E.db["movers"]["BuiDashboardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-8"
		E.db["movers"]["DigSiteProgressBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,315"
		E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-38"
		E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,22"
		E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-5"
		E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-6"
		E.db["movers"]["ProfessionsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-184"
		E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-415,22"
		E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-2,22"
		E.db["movers"]["VehicleSeatMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,155,-81"
		E.db["movers"]["WatchFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-122,-292"
		E.db["movers"]["tokenHolderMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-123"
		E.db["movers"]["ArtifactBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,415,22"
		E.db["movers"]["HonorBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-157,-6"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-207,-260"
		
		E.private.benikui.expressway = false
	elseif layout == "expressway" then
		E.db["general"]["font"] = "Expressway"
		E.db["general"]["fontSize"] = 11
		
		E.db["datatexts"]["font"] = "Expressway"
		E.db["datatexts"]["fontSize"] = 11
		E.db["datatexts"]["fontOutline"] = "OUTLINE"
	
		E.private["general"]["dmgfont"] = "Expressway"
		E.private["general"]["chatBubbleFont"] = "Expressway"
		E.private["general"]["chatBubbleFontSize"] = 12
		E.private["general"]["namefont"] = "Expressway"

		E.db["bags"]["countFont"] = "Expressway"
		E.db["bags"]["countFontOutline"] = "OUTLINE"
		E.db["bags"]["itemLevelFont"] = "Expressway"
		E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
		
		E.db["chat"]["font"] = "Expressway"
		E.db["chat"]["fontSize"] = 10
		E.db["chat"]["panelHeight"] = 150
		E.db["chat"]["tabFont"] = "Expressway"
		E.db["chat"]["tabFontOutline"] = "OUTLINE"
		E.db["chat"]["tabFontSize"] = 11
		
		E.db["nameplates"]["displayStyle"] = "BLIZZARD"
		E.db["nameplates"]["font"] = "Expressway"
		E.db["nameplates"]["fontSize"] = 10
		E.db["nameplates"]["statusbar"] = "BuiFlat"
		E.db["nameplates"]["fontOutline"] = 'OUTLINE'
		E.db["nameplates"]["units"]["ENEMY_NPC"]["eliteIcon"]["enable"] = true
		E.db["nameplates"]["units"]["PLAYER"]["alwaysShow"] = true
		E.db["nameplates"]["units"]["PLAYER"]["healthbar"]["height"] = 4
		E.db["nameplates"]["units"]["PLAYER"]["healthbar"]["width"] = 158
		E.db["nameplates"]["units"]["PLAYER"]["powerbar"]["text"]["enable"] = true

		E.db["tooltip"]["font"] = "Expressway"
		E.db["tooltip"]["fontSize"] = 10
		E.db["tooltip"]["headerFontSize"] = 11
		E.db["tooltip"]["healthBar"]["font"] = "Expressway"
		E.db["tooltip"]["healthBar"]["fontSize"] = 9
		E.db["tooltip"]["smallTextFontSize"] = 11
		E.db["tooltip"]["textFontSize"] = 11
		
		E.db["benikui"]["misc"]["ilevel"]["font"] = "Expressway"
		E.db["benikui"]["misc"]["ilevel"]["fontsize"] = 10
		E.db["benikui"]["datatexts"]["middle"]["width"] = 414
		E:GetModule('BuiLayout'):MiddleDatatextDimensions()
		
		-- movers
		E.db["movers"]["AlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-140"
		E.db["movers"]["ArtifactBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,415,22"
		E.db["movers"]["BNETMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-156,-200"
		E.db["movers"]["BuiDashboardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-8"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,61"
		E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-38"
		E.db["movers"]["HonorBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-157,-6"
		E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,22"
		E.db["movers"]["LocationLiteMover"] = "TOP,ElvUIParent,TOP,0,-7"
		E.db["movers"]["LocationMover"] = "TOP,ElvUIParent,TOP,0,-7"
		E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-5"
		E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-6"
		E.db["movers"]["ObjectiveFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-210,-176"
		E.db["movers"]["PlayerNameplate"] = "BOTTOM,ElvUIParent,BOTTOM,0,359"
		E.db["movers"]["ProfessionsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-184"
		E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-415,22"
		E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-2,22"
		E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-280"
		E.db["movers"]["TalkingHeadFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,116"
		E.db["movers"]["VehicleSeatMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,155,-81"
		E.db["movers"]["WatchFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-122,-292"
		E.db["movers"]["ZoneAbility"] = "BOTTOM,ElvUIParent,BOTTOM,0,378"
		E.db["movers"]["tokenHolderMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-123"
		
		E.private.benikui.expressway = true
	end

	PluginInstallStepComplete.message = BUI.Title..L['Layout Set']
	PluginInstallStepComplete:Show()

	E:UpdateAll(true)
end

function BUI:SetupColorThemes(color)
	-- Colors
	if color == 'Diablo' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.125
		E.db.general.backdropfadecolor.g = 0.054
		E.db.general.backdropfadecolor.b = 0.050
		E.db.benikui.colors.colorTheme = 'Diablo'
	elseif color == 'Hearthstone' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.086
		E.db.general.backdropfadecolor.g = 0.109
		E.db.general.backdropfadecolor.b = 0.149
		E.db.benikui.colors.colorTheme = 'Hearthstone'
	elseif color == 'Mists' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.043
		E.db.general.backdropfadecolor.g = 0.101
		E.db.general.backdropfadecolor.b = 0.101
		E.db.benikui.colors.colorTheme = 'Mists'
	elseif color == 'Elv' then
		E.db.general.backdropfadecolor.a = 0.75
		E.db.general.backdropfadecolor.r = 0.054
		E.db.general.backdropfadecolor.g = 0.054
		E.db.general.backdropfadecolor.b = 0.054
		E.db.benikui.colors.colorTheme = 'Elv'
	end
	E.db.general.backdropcolor.r = 0.025
	E.db.general.backdropcolor.g = 0.025
	E.db.general.backdropcolor.b = 0.025

	E:UpdateMedia()
	E:UpdateBackdropColors()
end

local function SetupColors()
	PluginInstallStepComplete.message = BUI.Title..L['Color Theme Set']
	PluginInstallStepComplete:Show()
end

local function SetupChat()

	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format('ChatFrame%s', i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)

		FCF_SetChatWindowFontSize(nil, frame, 11)

		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if i == 3 and chatName == LOOT..' / '..TRADE then
			FCF_UnDockFrame(frame)
			frame:ClearAllPoints()
			frame:Point('BOTTOMLEFT', LeftChatToggleButton, 'TOPLEFT', 1, 3)
			FCF_DockFrame(frame)
			FCF_SetLocked(frame, 1)
			frame:Show()
		end
		FCF_SavePositionAndDimensions(frame)
		FCF_StopDragging(frame)
	end

	PluginInstallStepComplete.message = BUI.Title..L['Chat Set']
	PluginInstallStepComplete:Show()
	E:UpdateAll(true)
end

local function SetupActionbars(layout)
	-- Actionbars
	E.db["actionbar"]["lockActionBars"] = true

	E.db["benikui"]["datatexts"]["middle"]["styled"] = false
	E.db["benikui"]["datatexts"]["middle"]["transparent"] = false

	E.db["benikui"]["datatexts"]["middle"]["backdrop"] = true
	E:GetModule('BuiLayout'):MiddleDatatextLayout()
	E.db["benikui"]["actionbars"]["toggleButtons"]["enable"] = true

	if layout == 'v1' then
		E.db["actionbar"]["font"] = "Bui Visitor1"
		E.db["actionbar"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["actionbar"]["fontSize"] = 10

		E.db["actionbar"]["bar1"]["backdrop"] = false
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["buttons"] = 10
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar3"]["buttonsize"] = 30
		E.db["actionbar"]["bar3"]["buttonspacing"] = 4
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar4"]["backdrop"] = true
		E.db["actionbar"]["bar4"]["buttons"] = 12
		E.db["actionbar"]["bar4"]["buttonsize"] = 26
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar5"]["enabled"] = true
		E.db["actionbar"]["bar5"]["backdrop"] = true
		E.db["actionbar"]["bar5"]["buttons"] = 10
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar5"]["buttonsize"] = 30
		E.db["actionbar"]["bar5"]["buttonspacing"] = 4
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 4
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["buttonsize"] = 22
		E.db["actionbar"]["barPet"]["buttonspacing"] = 4
		E.db["actionbar"]["stanceBar"]["buttonspacing"] = 2
		E.db["actionbar"]["stanceBar"]["backdrop"] = false
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 24
		
		E.db["benikui"]["actionbars"]["style"]["bar2"] = true
		E.db["benikui"]["datatexts"]["middle"]["width"] = 414
		E.db["databars"]["experience"]["width"] = 414

		-- movers
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,97"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,58"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,296,58"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,-296,58"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,29"
		E.db["movers"]["ShiftAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,165"
		E.db["movers"]["BuiMiddleDtMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-56,346"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,283"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-56,-397"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-3"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-128"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,20"

	elseif layout == 'v2' then
		E.db["actionbar"]["font"] = "Bui Visitor1"
		E.db["actionbar"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["actionbar"]["fontSize"] = 10;

		E.db["actionbar"]["bar1"]["backdrop"] = false
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 3
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar3"]["backdrop"] = false
		E.db["actionbar"]["bar3"]["buttons"] = 5
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar3"]["buttonsize"] = 19
		E.db["actionbar"]["bar3"]["buttonspacing"] = 1
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 1
		E.db["actionbar"]["bar4"]["backdrop"] = true
		E.db["actionbar"]["bar4"]["buttons"] = 12
		E.db["actionbar"]["bar4"]["buttonsize"] = 26
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar5"]["enabled"] = true
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar5"]["backdrop"] = false
		E.db["actionbar"]["bar5"]["buttons"] = 5
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar5"]["buttonsize"] = 19
		E.db["actionbar"]["bar5"]["buttonspacing"] = 1
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 1

		E.db["actionbar"]["barPet"]["buttonspacing"] = 4
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsize"] = 22

		E.db["actionbar"]["stanceBar"]["buttonspacing"] = 2
		E.db["actionbar"]["stanceBar"]["backdrop"] = false
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 24
		
		E.db["benikui"]["actionbars"]["style"]["bar2"] = true
		E.db["benikui"]["datatexts"]["middle"]["width"] = 412
		E.db["databars"]["experience"]["width"] = 412

		-- movers
		E.db["movers"]["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-56,346"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,290"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-56,-397"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-3"
		E.db["movers"]["BuiMiddleDtMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-128"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,60"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,22"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,257,2"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,-256,2"
		E.db["movers"]["PetAB"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-150,177"
		E.db["movers"]["ShiftAB"] = "TOP,ElvUIParent,BOTTOM,0,141"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,97"
	elseif layout == 'v3' then
		E.db["actionbar"]["backdropSpacingConverted"] = true
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar1"]["buttons"] = 8
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 8
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["buttonsize"] = 32
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar2"]["buttons"] = 8
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 8
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["buttonsize"] = 32
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar3"]["buttonsize"] = 30
		E.db["actionbar"]["bar3"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar4"]["buttonsize"] = 26
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 4
		E.db["actionbar"]["bar5"]["buttons"] = 7
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 7
		E.db["actionbar"]["bar5"]["buttonsize"] = 30
		E.db["actionbar"]["bar5"]["buttonspacing"] = 4
		E.db["actionbar"]["bar5"]["enabled"] = false
		E.db["actionbar"]["bar6"]["buttonsize"] = 18
		E.db["actionbar"]["barPet"]["backdropSpacing"] = 4
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["buttonsize"] = 23
		E.db["actionbar"]["barPet"]["buttonspacing"] = 4
		E.db["actionbar"]["font"] = "Expressway"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 24
		E.db["benikui"]["actionbars"]["style"]["bar2"] = false
		E.db["benikui"]["datatexts"]["middle"]["width"] = 414
		E.db["databars"]["experience"]["width"] = 414
		-- movers
		E.db["movers"]["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-56,346"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,362"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-56,-397"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-3"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-128"
		E.db["movers"]["DigSiteProgressBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,315"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,309"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,268"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,0,22"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,0,236"
		E.db["movers"]["ElvAB_6"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-288,290"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,85"
		E.db["movers"]["ShiftAB"] = "TOP,ElvUIParent,BOTTOM,0,141"
		E.db["movers"]["BuiMiddleDtMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,65"
	end
	E:GetModule('BuiActionbars'):ToggleStyle()
	E:GetModule('BuiLayout'):MiddleDatatextDimensions()

	PluginInstallStepComplete.message = BUI.Title..L['Actionbars Set']
	PluginInstallStepComplete:Show()
	E:UpdateAll(true)
end

local function SetupUnitframes(layout)

	if layout == 'v1' then
		E.db["benikui"]["unitframes"]["player"]["detachPortrait"] = false
		E.db["benikui"]["unitframes"]["player"]["portraitStyle"] = false
		E.db["benikui"]["unitframes"]["target"]["portraitStyle"] = false
		E.db["benikui"]["unitframes"]["target"]["getPlayerPortraitSize"] = false
		E.db["benikui"]["unitframes"]["target"]["detachPortrait"] = false
		E.db["benikui"]["unitframes"]["castbar"]["text"]["player"]["yOffset"] = -16
		E.db["benikui"]["unitframes"]["castbar"]["text"]["target"]["yOffset"] = -16
		E.db["benikui"]["colors"]["styleAlpha"] = 1
		E.db["benikui"]["colors"]["abAlpha"] = 1

		-- Auras
		E.db["auras"]["timeXOffset"] = -1
		E.db["auras"]["font"] = "Bui Visitor1"
		E.db["auras"]["fontSize"] = 10
		E.db["auras"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["auras"]["fadeThreshold"] = 10
		E.db["auras"]["buffs"]["horizontalSpacing"] = 3
		E.db["auras"]["buffs"]["size"] = 30
		E.db["auras"]["debuffs"]["size"] = 30

		-- Units
		-- general
		E.db["unitframe"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["fontSize"] = 10
		E.db["unitframe"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["unitframe"]["colors"]["transparentAurabars"] = true
		E.db["unitframe"]["colors"]["transparentCastbar"] = false
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["transparentPower"] = false
		E.db["unitframe"]["colors"]["transparentHealth"] = true
		E.db["unitframe"]["smoothbars"] = true
		E.db["unitframe"]["colors"]["health"]["b"] = 0.1
		E.db["unitframe"]["colors"]["health"]["g"] = 0.1
		E.db["unitframe"]["colors"]["health"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["healthclass"] = false
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.1
		E.db["unitframe"]["statusbar"] = "BuiFlat"

		-- player
		E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 300
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 140
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["player"]["width"] = 300
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 4
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = '[healthcolor][health:current-percent]'
		E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 16
		E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["player"]["height"] = 37
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["buffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["player"]["threatStyle"] = 'GLOW'
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["player"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 300
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["position"] = 'RIGHT'
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false

		if not E.db.unitframe.units.player.customTexts then E.db.unitframe.units.player.customTexts = {} end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] then
			E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] = nil
		end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] then
			E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] = nil
		end

		-- target
		E.db["unitframe"]["units"]["target"]["buffs"]["anchorPoint"] = 'TOPRIGHT'
		E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 300
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["target"]["orientation"] = "LEFT"		
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = 'TOPRIGHT'
		E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = '[healthcolor][health:current-percent]'
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = -2
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["target"]["height"] = 37
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = '[namecolor][name:medium] [difficultycolor][smartlevel] [shortclassification]'
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["name"]["attachTextTo"] = 'Health'
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["target"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 300
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["target"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 4
		E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["power"]["threatStyle"] = 'GLOW'
		E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["target"]["width"] = 300
		E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 16
		E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["target"]["smartAuraDisplay"] = "DISABLED"
		E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["aurabar"]["maxDuration"] = 120
		E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"

		if not E.db.unitframe.units.target.customTexts then E.db.unitframe.units.target.customTexts = {} end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] then
			E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] = nil
		end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] then
			E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] = nil
		end

		-- pet
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["height"] = 24
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["pet"]["power"]["width"] = 'fill'

		-- focus
		E.db["unitframe"]["units"]["focus"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["focus"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["focus"]["width"] = 130
		E.db["unitframe"]["units"]["focus"]["height"] = 30
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 14
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 130
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["focus"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["focus"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 26
		E.db["unitframe"]["units"]["focus"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["height"] = 12
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = false

		-- targettarget	
		E.db["unitframe"]["units"]["targettarget"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["targettarget"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["height"] = 12
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["threatStyle"] = "GLOW"
		E.db["unitframe"]["units"]["targettarget"]["width"] = 130
		E.db["unitframe"]["units"]["targettarget"]["height"] = 24

		-- party
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 10
		E.db["unitframe"]["units"]["party"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 19
		E.db["unitframe"]["units"]["party"]["debuffs"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 25
		E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["height"] = 45
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["party"]["portrait"]["rotation"] = 0
		E.db["unitframe"]["units"]["party"]["portrait"]["style"] = '3D'
		E.db["unitframe"]["units"]["party"]["portrait"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["portrait"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["portrait"]["width"] = 45
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["party"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 70
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["yOffset"] = -14
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 4
		E.db["unitframe"]["units"]["party"]["width"] = 120
		E.db["unitframe"]["units"]["party"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["party"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["infoPanel"]["transparent"] = true

		if not E.db.unitframe.units.party.customTexts then E.db.unitframe.units.party.customTexts = {} end
		if E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] then
			E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] = nil
		end

		-- raid
		E.db["unitframe"]["units"]["raid"]["height"] = 40
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 3
		E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 16
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true

		-- raid 40
		E.db["unitframe"]["units"]["raid40"]["height"] = 27
		E.db["unitframe"]["units"]["raid40"]["width"] = 80
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "TOP"
		E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["name"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid40"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["raid40"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["health"]["yOffset"] = 1
		E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["damager"] = false
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 4
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontOutline"] = "OUTLINE"

		-- Boss
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 24
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = -1
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconXOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["width"] = 210
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 1
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["boss"]["height"] = 50
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "HEALTH"
		E.db["unitframe"]["units"]["boss"]["power"]["height"] = 5

		-- Movers
		E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-66"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,349"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-392"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,444"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-442,205"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,202"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,169"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,184"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,147"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-232,182"
		E.db["movers"]["ElvUF_Raid40Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,439"
		E.db["movers"]["ElvUF_RaidMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,480"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,636"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,147"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,232,182"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,211"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,215"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,215"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-442,190"

	elseif layout == 'v2' then
		E.db["benikui"]["unitframes"]["player"]["detachPortrait"] = true
		E.db["benikui"]["unitframes"]["player"]["portraitHeight"] = 47
		E.db["benikui"]["unitframes"]["player"]["portraitStyle"] = true
		E.db["benikui"]["unitframes"]["player"]["portraitStyleHeight"] = 6
		E.db["benikui"]["unitframes"]["player"]["portraitWidth"] = 110
		E.db["benikui"]["unitframes"]["player"]["portraitShadow"] = false
		E.db["benikui"]["unitframes"]["target"]["detachPortrait"] = true
		E.db["benikui"]["unitframes"]["target"]["portraitHeight"] = 47
		E.db["benikui"]["unitframes"]["target"]["portraitStyle"] = true
		E.db["benikui"]["unitframes"]["target"]["portraitStyleHeight"] = 6
		E.db["benikui"]["unitframes"]["target"]["portraitWidth"] = 110
		E.db["benikui"]["unitframes"]["target"]["getPlayerPortraitSize"] = false
		E.db["benikui"]["unitframes"]["target"]["portraitShadow"] = false
		E.db["benikui"]["unitframes"]["castbar"]["text"]["player"]["yOffset"] = -18
		E.db["benikui"]["unitframes"]["castbar"]["text"]["target"]["yOffset"] = -18
		E.db["benikui"]["colors"]["styleAlpha"] = 1
		E.db["benikui"]["colors"]["abAlpha"] = 1

		-- Auras
		E.db["auras"]["buffs"]["horizontalSpacing"] = 3
		E.db["auras"]["buffs"]["size"] = 30
		E.db["auras"]["debuffs"]["size"] = 30
		E.db["auras"]["fadeThreshold"] = 10
		E.db["auras"]["font"] = "Bui Visitor1"
		E.db["auras"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["auras"]["fontSize"] = 10
		E.db["auras"]["timeXOffset"] = -1

		-- Units
		-- general
		E.db["unitframe"]["font"] = "Bui Tukui"
		E.db["unitframe"]["fontSize"] = 15
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.1
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["castReactionColor"] = true
		E.db["unitframe"]["colors"]["powerclass"] = true
		E.db["unitframe"]["colors"]["healthclass"] = false
		E.db["unitframe"]["colors"]["power"]["MANA"]["r"] = 1
		E.db["unitframe"]["colors"]["power"]["MANA"]["g"] = 0.5
		E.db["unitframe"]["colors"]["power"]["MANA"]["b"] = 0
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.1
		E.db["unitframe"]["colors"]["transparentCastbar"] = false
		E.db["unitframe"]["colors"]["health"]["r"] = 0.1
		E.db["unitframe"]["colors"]["health"]["g"] = 0.1
		E.db["unitframe"]["colors"]["health"]["b"] = 0.1
		E.db["unitframe"]["colors"]["transparentHealth"] = true
		E.db["unitframe"]["colors"]["transparentAurabars"] = true
		E.db["unitframe"]["colors"]["transparentPower"] = false
		E.db["unitframe"]["smoothbars"] = true
		E.db["unitframe"]["statusbar"] = "BuiFlat"

		-- player
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 240
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 140
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"

		if not E.db.unitframe.units.player.customTexts then E.db.unitframe.units.player.customTexts = {} end

		if E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] == nil then
			E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] = {}
		end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] == nil then
			E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] = {}
		end
		-- convert the old custom text name
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] ~= nil then 
			E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]
		end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] ~= nil then
			E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]
		end

		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["size"] = 20
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["xOffset"] = 0
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["yOffset"] = -2
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["size"] = 20
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["text_format"] = "[name]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["yOffset"] = -2
		E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["player"]["debuffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["health"]["yOffset"] = -25
		E.db["unitframe"]["units"]["player"]["height"] = 34
		E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["overlay"] = false
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 240
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["player"]["power"]["position"] = 'RIGHT'
		E.db["unitframe"]["units"]["player"]["width"] = 'fill'
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["player"]["threatStyle"] = 'GLOW'
		E.db["unitframe"]["units"]["player"]["width"] = 240

		-- target
		E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["insideInfoPanel"] = true
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 240

		if not E.db.unitframe.units.target.customTexts then E.db.unitframe.units.target.customTexts = {} end

		if E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] == nil then
			E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] = {}
		end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] == nil then
			E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] = {}
		end
		-- convert the old custom text name
		if E.db["unitframe"]["units"]["target"]["customTexts"]["PlayerName"] ~= nil then 
			E.db["unitframe"]["units"]["target"]["customTexts"]["PlayerName"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]
		end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["PlayerBigHealth"] ~= nil then
			E.db["unitframe"]["units"]["target"]["customTexts"]["PlayerBigHealth"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]
		end
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["size"] = 20
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["xOffset"] = 2
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["yOffset"] = -2
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["font"] = "Bui Tukui"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["size"] = 20
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["text_format"] = "[namecolor][name:medium] [difficultycolor][smartlevel] [shortclassification]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["xOffset"] = 0
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["yOffset"] = -2
		E.db["unitframe"]["units"]["target"]["debuffs"]["anchorPoint"] = 'TOPRIGHT'
		E.db["unitframe"]["units"]["target"]["debuffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = -40
		E.db["unitframe"]["units"]["target"]["health"]["yOffset"] = -25
		E.db["unitframe"]["units"]["target"]["height"] = 34
		E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["name"]["yOffset"] = -25
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["portrait"]["overlay"] = false
		E.db["unitframe"]["units"]["target"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["power"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 240
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 4
		E.db["unitframe"]["units"]["target"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["power"]["position"] = 'LEFT'
		E.db["unitframe"]["units"]["target"]["smartAuraDisplay"] = "DISABLED"
		E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["target"]["width"] = 240
		E.db["unitframe"]["units"]["target"]["threatStyle"] = 'GLOW'

		-- pet
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 10
		E.db["unitframe"]["units"]["pet"]["height"] = 24
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["pet"]["power"]["width"] = 'fill'

		-- focus
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 16
		E.db["unitframe"]["units"]["focus"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 110
		E.db["unitframe"]["units"]["focus"]["height"] = 36
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["focus"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["focus"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["focus"]["width"] = 110

		-- targettarget
		E.db["unitframe"]["units"]["targettarget"]["height"] = 30
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["targettarget"]["width"] = 130

		-- Party
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 14
		E.db["unitframe"]["units"]["party"]["debuffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 23
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 8
		E.db["unitframe"]["units"]["party"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0		
		E.db["unitframe"]["units"]["party"]["height"] = 40
		E.db["unitframe"]["units"]["party"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "TOPLEFT"
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 16
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 18
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["party"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["height"] = 15
		E.db["unitframe"]["units"]["party"]["portrait"]["overlay"] = false
		E.db["unitframe"]["units"]["party"]["portrait"]["style"] = '3D'
		E.db["unitframe"]["units"]["party"]["portrait"]["transparent"] = true
		E.db["unitframe"]["units"]["party"]["portrait"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["power"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 8
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = 2	
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["party"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 15
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 70
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["yOffset"] = -12
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 30
		E.db["unitframe"]["units"]["party"]["width"] = 220
		if not E.db.unitframe.units.party.customTexts then E.db.unitframe.units.party.customTexts = {} end
		if E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] then
			E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] = nil
		end

		-- raid
		E.db["unitframe"]["units"]["raid"]["height"] = 40
		E.db["unitframe"]["units"]["raid"]["width"] = 78
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 5
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 5
		E.db["unitframe"]["units"]["raid"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["raid"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["tank"] = true
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true

		-- raid 40
		E.db["unitframe"]["units"]["raid40"]["height"] = 35
		E.db["unitframe"]["units"]["raid40"]["width"] = 78
		E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 5
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 5
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["name"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["name"]["yOffset"] = -1
		E.db["unitframe"]["units"]["raid40"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid40"]["health"]["position"] = "BOTTOM"
		E.db["unitframe"]["units"]["raid40"]["health"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["raid40"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["health"]["yOffset"] = 1
		E.db["unitframe"]["units"]["raid40"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["damager"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["healer"] = true
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Bui Visitor1"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 4
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["transparent"] = true

		-- Boss
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 24
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = -1
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconXOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["width"] = 210
		E.db["unitframe"]["units"]["boss"]["height"] = 58
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "HEALTH"
		E.db["unitframe"]["units"]["boss"]["power"]["height"] = 5

		-- Movers
		E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-66"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,349"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,722"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-526"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-553,223"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-553,236"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,200"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,148"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,159"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-217,140"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-189,163"
		E.db["movers"]["ElvUF_Raid40Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,520"
		E.db["movers"]["ElvUF_RaidMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,3,490"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,664"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,217,140"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,189,163"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,185"
		E.db["movers"]["PlayerPortraitMover"] = "BOTTOM,ElvUIParent,BOTTOM,-365,163"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-189,209"
		E.db["movers"]["TargetPortraitMover"] = "BOTTOM,ElvUIParent,BOTTOM,365,163"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,189,209"
	elseif layout == 'v3' then
		E.db["auras"]["buffs"]["horizontalSpacing"] = 3
		E.db["auras"]["buffs"]["size"] = 30
		E.db["auras"]["debuffs"]["size"] = 30
		E.db["auras"]["fadeThreshold"] = 10
		E.db["auras"]["font"] = "Expressway"
		E.db["auras"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["timeXOffset"] = -1
		
		E.db["benikui"]["unitframes"]["castbar"]["text"]["ShowInfoText"] = false
		E.db["benikui"]["unitframes"]["castbar"]["text"]["yOffset"] = 0
		E.db["benikui"]["colors"]["styleAlpha"] = 0.7
		E.db["benikui"]["colors"]["abAlpha"] = 0.7
	
		E.db["unitframe"]["colors"]["auraBarBuff"]["b"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["g"] = 0.1
		E.db["unitframe"]["colors"]["auraBarBuff"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castClassColor"] = true
		E.db["unitframe"]["colors"]["transparentCastbar"] = false
		E.db["unitframe"]["colors"]["castColor"]["b"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["g"] = 0.1
		E.db["unitframe"]["colors"]["castColor"]["r"] = 0.1
		E.db["unitframe"]["colors"]["castReactionColor"] = true
		E.db["unitframe"]["colors"]["colorhealthbyvalue"] = false
		E.db["unitframe"]["colors"]["health"]["b"] = 0.1
		E.db["unitframe"]["colors"]["health"]["g"] = 0.1
		E.db["unitframe"]["colors"]["health"]["r"] = 0.1
		E.db["unitframe"]["colors"]["health_backdrop_dead"]["b"] = 0.003921568627451
		E.db["unitframe"]["colors"]["health_backdrop_dead"]["g"] = 0.003921568627451
		E.db["unitframe"]["colors"]["health_backdrop_dead"]["r"] = 0.14901960784314
		E.db["unitframe"]["colors"]["healthclass"] = true
		E.db["unitframe"]["colors"]["power"]["MANA"]["b"] = 0
		E.db["unitframe"]["colors"]["power"]["MANA"]["g"] = 0.5
		E.db["unitframe"]["colors"]["power"]["MANA"]["r"] = 1
		E.db["unitframe"]["colors"]["powerclass"] = true
		E.db["unitframe"]["colors"]["transparentAurabars"] = true
		E.db["unitframe"]["colors"]["transparentHealth"] = true
		E.db["unitframe"]["colors"]["transparentPower"] = true
		E.db["unitframe"]["colors"]["useDeadBackdrop"] = true
		E.db["unitframe"]["font"] = "Expressway"
		E.db["unitframe"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["fontSize"] = 11
		E.db["unitframe"]["smoothbars"] = true
		E.db["unitframe"]["statusbar"] = "BuiFlat"
		E.db["benikui"]["unitframes"]["player"]["detachPortrait"] = false
		E.db["benikui"]["unitframes"]["target"]["detachPortrait"] = false
		
		-- player
		if not E.db.unitframe.units.player.customTexts then E.db.unitframe.units.player.customTexts = {} end

		if E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] == nil then
			E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"] = {}
		end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] == nil then
			E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"] = {}
		end
		-- convert the old custom text name
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] ~= nil then 
			E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerName"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]
		end
		if E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] ~= nil then
			E.db["unitframe"]["units"]["player"]["customTexts"]["PlayerBigHealth"] = E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]
		end
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 28
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 258
		E.db["unitframe"]["units"]["player"]["classbar"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["classbar"]["detachedWidth"] = 140
		E.db["unitframe"]["units"]["player"]["classbar"]["fill"] = "spaced"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["fontOutline"] = "NONE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["size"] = 22
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["xOffset"] = -8
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerHealth"]["yOffset"] = -1
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["fontOutline"] = "NONE"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["size"] = 11
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["text_format"] = "[name]"
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["xOffset"] = -8
		E.db["unitframe"]["units"]["player"]["customTexts"]["BenikuiPlayerName"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["debuffs"]["attachTo"] = "BUFFS"
		E.db["unitframe"]["units"]["player"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["player"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["player"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["player"]["health"]["xOffset"] = 4
		E.db["unitframe"]["units"]["player"]["height"] = 40
		E.db["unitframe"]["units"]["player"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["infoPanel"]["height"] = 22
		E.db["unitframe"]["units"]["player"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["player"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["player"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = "Power"
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = true
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 294
		E.db["unitframe"]["units"]["player"]["power"]["height"] = 7
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["player"]["power"]["strataAndLevel"]["frameLevel"] = 2
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[power:current-percent]"
		E.db["unitframe"]["units"]["player"]["power"]["xOffset"] = 2
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 4
		E.db["unitframe"]["units"]["player"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["player"]["width"] = 258

		-- target
		if not E.db.unitframe.units.target.customTexts then E.db.unitframe.units.target.customTexts = {} end

		if E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] == nil then
			E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"] = {}
		end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] == nil then
			E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"] = {}
		end
		-- convert the old custom text name
		if E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"] ~= nil then 
			E.db["unitframe"]["units"]["target"]["customTexts"]["TargetName"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]
		end
		if E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"] ~= nil then
			E.db["unitframe"]["units"]["target"]["customTexts"]["TargetBigHealth"] = E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]
		end
		E.db["unitframe"]["units"]["target"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["aurabar"]["maxDuration"] = 120
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["castbar"]["iconXOffset"] = 10
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 258
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["fontOutline"] = "NONE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["size"] = 22
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetHealth"]["yOffset"] = -1
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["fontOutline"] = "NONE"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["justifyH"] = "LEFT"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["size"] = 11
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["text_format"] = "[name:medium] [difficultycolor][smartlevel] [shortclassification]"
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["customTexts"]["BenikuiTargetName"]["yOffset"] = 0
		E.db["unitframe"]["units"]["target"]["debuffs"]["sizeOverride"] = 32
		E.db["unitframe"]["units"]["target"]["debuffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["health"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["target"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["health"]["xOffset"] = 4
		E.db["unitframe"]["units"]["target"]["height"] = 40
		E.db["unitframe"]["units"]["target"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["target"]["infoPanel"]["height"] = 22
		E.db["unitframe"]["units"]["target"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["target"]["name"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["name"]["text_format"] = ""
		E.db["unitframe"]["units"]["target"]["name"]["xOffset"] = 8
		E.db["unitframe"]["units"]["target"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["target"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["power"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["target"]["power"]["detachedWidth"] = 300
		E.db["unitframe"]["units"]["target"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["target"]["power"]["height"] = 7
		E.db["unitframe"]["units"]["target"]["power"]["hideonnpc"] = false
		E.db["unitframe"]["units"]["target"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["target"]["power"]["threatStyle"] = "GLOW"
		E.db["unitframe"]["units"]["target"]["power"]["xOffset"] = 4
		E.db["unitframe"]["units"]["target"]["smartAuraDisplay"] = "DISABLED"
		E.db["unitframe"]["units"]["target"]["smartAuraPosition"] = "DEBUFFS_ON_BUFFS"
		E.db["unitframe"]["units"]["target"]["width"] = 258
		
		-- pet
		E.db["unitframe"]["units"]["pet"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["pet"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 10
		E.db["unitframe"]["units"]["pet"]["height"] = 24
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5
		
		-- focus
		E.db["unitframe"]["units"]["focus"]["castbar"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["castbar"]["height"] = 14
		E.db["unitframe"]["units"]["focus"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["focus"]["castbar"]["iconSize"] = 26
		E.db["unitframe"]["units"]["focus"]["castbar"]["width"] = 130
		E.db["unitframe"]["units"]["focus"]["debuffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["focus"]["debuffs"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["height"] = 30
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["height"] = 12
		E.db["unitframe"]["units"]["focus"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["focus"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["focus"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["focus"]["width"] = 130

		-- targettarget
		E.db["unitframe"]["units"]["targettarget"]["height"] = 25
		E.db["unitframe"]["units"]["targettarget"]["name"]["text_format"] = "[name:medium]"
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["targettarget"]["portrait"]["enable"] = false
		
		-- boss
		E.db["unitframe"]["units"]["boss"]["buffs"]["anchorPoint"] = "CENTER"
		E.db["unitframe"]["units"]["boss"]["buffs"]["attachTo"] = "HEALTH"
		E.db["unitframe"]["units"]["boss"]["buffs"]["xOffset"] = 16
		E.db["unitframe"]["units"]["boss"]["buffs"]["yOffset"] = 0
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconAttached"] = false
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["boss"]["castbar"]["iconXOffset"] = 2
		E.db["unitframe"]["units"]["boss"]["debuffs"]["sizeOverride"] = 24
		E.db["unitframe"]["units"]["boss"]["debuffs"]["xOffset"] = -1
		E.db["unitframe"]["units"]["boss"]["debuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["boss"]["height"] = 50
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["height"] = 14
		E.db["unitframe"]["units"]["boss"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["boss"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["boss"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["boss"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["boss"]["name"]["yOffset"] = 1
		E.db["unitframe"]["units"]["boss"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["boss"]["width"] = 210

		-- party
		if not E.db.unitframe.units.party.customTexts then E.db.unitframe.units.party.customTexts = {} end

		if E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] == nil then
			E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"] = {}
		end
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["size"] = 16
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["debuffs"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 25
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 19
		E.db["unitframe"]["units"]["party"]["health"]["position"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["party"]["health"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["health"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["health"]["yOffset"] = -2
		E.db["unitframe"]["units"]["party"]["height"] = 40
		E.db["unitframe"]["units"]["party"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["party"]["infoPanel"]["height"] = 20
		E.db["unitframe"]["units"]["party"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["party"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["party"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["name"]["text_format"] = "[name:medium] [difficultycolor][smartlevel]"
		E.db["unitframe"]["units"]["party"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["party"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["petsGroup"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["party"]["petsGroup"]["width"] = 60
		E.db["unitframe"]["units"]["party"]["petsGroup"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["petsGroup"]["yOffset"] = -1
		E.db["unitframe"]["units"]["party"]["portrait"]["camDistanceScale"] = 1
		E.db["unitframe"]["units"]["party"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["party"]["power"]["height"] = 6
		E.db["unitframe"]["units"]["party"]["power"]["position"] = "BOTTOMRIGHT"
		E.db["unitframe"]["units"]["party"]["power"]["text_format"] = ""
		E.db["unitframe"]["units"]["party"]["power"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["power"]["yOffset"] = 2
		E.db["unitframe"]["units"]["party"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["party"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["party"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["height"] = 16
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["width"] = 70
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["xOffset"] = 1
		E.db["unitframe"]["units"]["party"]["targetsGroup"]["yOffset"] = -14
		E.db["unitframe"]["units"]["party"]["verticalSpacing"] = 4
		E.db["unitframe"]["units"]["party"]["width"] = 120

		-- raid
		E.db["unitframe"]["units"]["raid"]["health"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid"]["health"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["height"] = 40
		E.db["unitframe"]["units"]["raid"]["horizontalSpacing"] = 5
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["enable"] = true
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["height"] = 18
		E.db["unitframe"]["units"]["raid"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["raid"]["name"]["attachTextTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["name"]["position"] = "LEFT"
		E.db["unitframe"]["units"]["raid"]["name"]["xOffset"] = 4
		E.db["unitframe"]["units"]["raid"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["raid"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["raid"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid"]["rdebuffs"]["yOffset"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["attachTo"] = "InfoPanel"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["size"] = 12
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["verticalSpacing"] = 5
		E.db["unitframe"]["units"]["raid"]["width"] = 78
		
		--raid 40
		E.db["unitframe"]["units"]["raid40"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["raid40"]["health"]["yOffset"] = 1
		E.db["unitframe"]["units"]["raid40"]["horizontalSpacing"] = 5
		E.db["unitframe"]["units"]["raid40"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["name"]["position"] = "CENTER"
		E.db["unitframe"]["units"]["raid40"]["name"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["size"] = 20
		E.db["unitframe"]["units"]["raid40"]["rdebuffs"]["yOffset"] = 4
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["damager"] = false
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["enable"] = true
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["size"] = 10
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["xOffset"] = -2
		E.db["unitframe"]["units"]["raid40"]["roleIcon"]["yOffset"] = 0
		E.db["unitframe"]["units"]["raid40"]["verticalSpacing"] = 5

		-- movers
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-392"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,444"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-494,158"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-494,174"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,202"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,232"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,241"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,147"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-278,268"
		E.db["movers"]["ElvUF_Raid40Mover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,503"
		E.db["movers"]["ElvUF_RaidMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,2,491"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,636"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,147"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,278,268"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,206"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,360"
		E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-66"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,345"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,215"
	end

	if E.db.benikui.unitframes.player.detachPortrait == true then
		E.db.unitframe.units.player.portrait.width = 0
	else
		E.db.unitframe.units.player.portrait.width = 45
	end

	if E.db.benikui.unitframes.target.detachPortrait == true then
		E.db.unitframe.units.target.portrait.width = 0
	else
		E.db.unitframe.units.target.portrait.width = 45
	end

	PluginInstallStepComplete.message = BUI.Title..L['Unitframes Set']
	PluginInstallStepComplete:Show()
	E:UpdateAll(true)
end

local addonNames = {}
local profilesFailed = format('|cff00c0fa%s |r', L["BenikUI didn't find any supported addons for profile creation"])

local function SetupAddons()

	-- DBM
	if IsAddOnLoaded('DBM-Core') then
		BUI:LoadDBMProfile()
		tinsert(addonNames, 'Deadly Boss Mods')
	end

	-- Details
	if IsAddOnLoaded('Details') then
		BUI:LoadDetailsProfile()
		tinsert(addonNames, 'Details')
	end

	-- Location Lite
	if IsAddOnLoaded('ElvUI_LocLite') then
		BUI:LoadLocationLiteProfile()
		tinsert(addonNames, 'Location Lite')
	end

	-- Location Plus
	if IsAddOnLoaded('ElvUI_LocPlus') then
		BUI:LoadLocationPlusProfile()
		tinsert(addonNames, 'Location Plus')
	end

	-- MikScrollingBattleText
	if IsAddOnLoaded('MikScrollingBattleText') then
		BUI:LoadMSBTProfile()
		tinsert(addonNames, "Mik's Scrolling Battle Text")
	end

	-- Pawn
	if IsAddOnLoaded('Pawn') then
		BUI:LoadPawnProfile()
		tinsert(addonNames, 'Pawn')
	end

	-- Recount
	if IsAddOnLoaded('Recount') then
		BUI:LoadRecountProfile()
		tinsert(addonNames, 'Recount')
	end

	-- Skada
	if IsAddOnLoaded('Skada') then
		BUI:LoadSkadaProfile()
		tinsert(addonNames, 'Skada')
	end

	-- SquareMinimapButtons
	if IsAddOnLoaded('SquareMinimapButtons') then
		BUI:LoadSMBProfile()
		tinsert(addonNames, 'Square Minimap Buttons')
	end

	-- ElvUI_VisualAuraTimers
	if IsAddOnLoaded('ElvUI_VisualAuraTimers') then
		BUI:LoadVATProfile()
		tinsert(addonNames, 'ElvUI VisualAuraTimers')
	end

	-- AddOnSkins
	if IsAddOnLoaded('AddOnSkins') then
		BUI:LoadAddOnSkinsProfile()
		tinsert(addonNames, 'AddOnSkins')
	end

	if checkTable(addonNames) ~= nil then
		local profileString = format('|cfffff400%s |r', L['BenikUI successfully created and applied profile(s) for:']..'\n')

		tsort(addonNames, function(a, b) return a < b end)
		local names = tconcat(addonNames, ", ")
		profileString = profileString..names

		-- BUIInstallFrame.Desc4:SetText(profileString..'.')
		PluginInstallFrame.Desc4:SetText(profileString..'.')
	else
		-- BUIInstallFrame.Desc4:SetText(profilesFailed)
		PluginInstallFrame.Desc4:SetText(profilesFailed)
	end

	PluginInstallStepComplete.message = BUI.Title..L['Addons Set']
	PluginInstallStepComplete:Show()
	twipe(addonNames)
	E:UpdateAll(true)
end

local function SetupDataTexts(role)
	-- Data Texts
	E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["right"] = 'BuiMail'
	if IsAddOnLoaded('ElvUI_LocPlus') then
		E.db["datatexts"]["panels"]["RightCoordDtPanel"] = 'Time'
		E.db["datatexts"]["panels"]["LeftCoordDtPanel"] = 'Spec Switch (BenikUI)'
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["left"] = 'Versatility'
	else
		E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["left"] = 'Spec Switch (BenikUI)'
	end
	if role == 'tank' then
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["left"] = 'Attack Power'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["left"] = 'Avoidance'
	elseif role == 'dpsMelee' then
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["left"] = 'Attack Power'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["left"] = 'Haste'
	elseif role == 'healer' or 'dpsCaster' then
		E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["left"] = 'Spell/Heal Power'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["left"] = 'Haste'
	end
	E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"]["middle"] = 'Orderhall (BenikUI)'

	E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["right"] = 'Gold'
	E.db["datatexts"]["panels"]["BuiRightChatDTPanel"]["middle"] = 'Bags'

	E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["right"] = 'Crit Chance'
	E.db["datatexts"]["panels"]["BuiMiddleDTPanel"]["middle"] = 'Mastery'

	PluginInstallStepComplete.message = BUI.Title..L['DataTexts Set']
	PluginInstallStepComplete:Show()
	E:UpdateAll(true)
end

local function InstallComplete()
	E.private.install_complete = E.version
	E.db.benikui.installed = true
	E.private.benikui.install_complete = BUI.Version

	ReloadUI()
end

-- ElvUI PlugIn installer
BUI.installTable = {
	["Name"] = "|cff00c0faBenikUI|r",
	["Title"] = L["|cff00c0faBenikUI|r Installation"],
	["tutorialImage"] = [[Interface\AddOns\ElvUI_BenikUI\media\textures\logo_benikui.tga]],
	["Pages"] = {
		[1] = function()
			PluginInstallFrame:Style('Outside')
			PluginInstallTitleFrame:Style('Outside')
			PluginInstallFrame.SubTitle:SetFormattedText(L["Welcome to BenikUI version %s, for ElvUI %s."], BUI.Version, E.version)
			PluginInstallFrame.Desc1:SetText(L["By pressing the Continue button, BenikUI will be applied on your current ElvUI installation.\n\n|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
			PluginInstallFrame.Desc2:SetText(BUI:cOption(L["BenikUI options are marked with light blue color, inside ElvUI options."]))
			PluginInstallFrame.Desc3:SetText(L["Please press the continue button to go onto the next step."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			PluginInstallFrame.Option1:SetText(L["Skip Process"])
		end,
		[2] = function()
			PluginInstallFrame.SubTitle:SetText(L["Layout"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation will change the default ElvUI look."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to apply the new layout."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupLayout('classic') end)
			PluginInstallFrame.Option1:SetText(L["Classic"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupLayout('expressway') end)
			PluginInstallFrame.Option2:SetText(L["Expressway"])
		end,
		[3] = function()
			PluginInstallFrame.SubTitle:SetText(L["Color Themes"])
			PluginInstallFrame.Desc1:SetFormattedText(L["This part of the installation will apply a Color Theme"])
			PluginInstallFrame.Desc2:SetText(L["Please click a button below to apply a color theme."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupColors(); BUI:SetupColorThemes("Elv"); end)
			PluginInstallFrame.Option1:SetText(L["ElvUI"])
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupColors(); BUI:SetupColorThemes("Diablo"); end)
			PluginInstallFrame.Option2:SetText(L["Diablo"])
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() SetupColors(); BUI:SetupColorThemes("Mists"); end)
			PluginInstallFrame.Option3:SetText(L["Mists"])
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript("OnClick", function() SetupColors(); BUI:SetupColorThemes("Hearthstone"); end)
			PluginInstallFrame.Option4:SetText(L["Hearthstone"])
		end,
		[4] = function()
			PluginInstallFrame.SubTitle:SetText(L["Chat"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process sets up your chat fonts and colors."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your chat windows."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupChat() end)
			PluginInstallFrame.Option1:SetText(L["Setup Chat"])
		end,
		[5] = function()
			PluginInstallFrame.SubTitle:SetText(L["UnitFrames"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will reposition your Unitframes."])
			PluginInstallFrame.Desc2:SetText(L["Please click a button below to setup your Unitframes."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupUnitframes("v1") end)
			PluginInstallFrame.Option1:SetText(L["Unitframes"].." v1")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupUnitframes("v2") end)
			PluginInstallFrame.Option2:SetText(L["Unitframes"].." v2")
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() SetupUnitframes("v3") end)
			PluginInstallFrame.Option3:SetText(L["Unitframes"].." v3")
		end,
		[6] = function()
			PluginInstallFrame.SubTitle:SetText(L["ActionBars"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will reposition your Actionbars and will enable backdrops"])
			PluginInstallFrame.Desc2:SetText(L["Please click a button below to setup your actionbars."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cff07D400High|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupActionbars("v1") end)
			PluginInstallFrame.Option1:SetText(L["ActionBars"].." v1")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupActionbars("v2") end)
			PluginInstallFrame.Option2:SetText(L["ActionBars"].." v2")
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() SetupActionbars("v3") end)
			PluginInstallFrame.Option3:SetText(L["ActionBars"].." v3")
		end,
		[7] = function()
			PluginInstallFrame.SubTitle:SetText(L["DataTexts"])
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will fill BenikUI datatexts.\n\n|cffff8000This doesn't touch ElvUI datatexts|r"])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your datatexts."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; SetupDataTexts("tank") end)
			PluginInstallFrame.Option1:SetText(TANK)
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; SetupDataTexts("healer") end)
			PluginInstallFrame.Option2:SetText(HEALER)
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; SetupDataTexts("dpsMelee") end)
			PluginInstallFrame.Option3:SetText(L["Physical DPS"])
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript("OnClick", function() E.db.datatexts.panels.BuiLeftChatDTPanel.left = nil; E.db.datatexts.panels.BuiLeftChatDTPanel.middle = nil; SetupDataTexts("dpsCaster") end)
			PluginInstallFrame.Option4:SetText(L["Caster DPS"])
		end,
		[8] = function()
			PluginInstallFrame.SubTitle:SetFormattedText("%s", ADDONS)
			PluginInstallFrame.Desc1:SetText(L["This part of the installation process will create and apply profiles for addons like Recount, DBM, ElvUI plugins, etc"])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below to setup your addons."])
			PluginInstallFrame.Desc3:SetText(L["Importance: |cffD3CF00Medium|r"])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupAddons(); end)
			PluginInstallFrame.Option1:SetText(L["Setup Addons"])
		end,
		[9] = function()
			PluginInstallFrame.SubTitle:SetText(L["Installation Complete"])
			PluginInstallFrame.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() InstallComplete() end)
			PluginInstallFrame.Option1:SetText(L["Finished"])
			if InstallStepComplete then
				InstallStepComplete.message = BUI.Title..L["Installed"]
				InstallStepComplete:Show()
			end
		end,
	},

	["StepTitles"] = {
		[1] = START,
		[2] = L["Layout"],
		[3] = L["Color Themes"],
		[4] = L["Chat"],
		[5] = L["UnitFrames"],
		[6] = L["ActionBars"],
		[7] = L["DataTexts"],
		[8] = ADDONS,
		[9] = L["Installation Complete"],
	},
	StepTitlesColor = {1, 1, 1},
	StepTitlesColorSelected = {0, 192/255, 250},
	StepTitleWidth = 200,
	StepTitleButtonWidth = 200,
	StepTitleTextJustification = "CENTER",
}