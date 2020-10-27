local BUI, E, _, V, P, G = unpack(select(2, ...))
local L = E.Libs.ACL:GetLocale('ElvUI', E.global.general.locale or 'enUS');
local format, checkTable = format, next
local tinsert, twipe, tsort, tconcat = table.insert, table.wipe, table.sort, table.concat
local _G = _G

local ReloadUI = ReloadUI
local FCF_SetLocked = FCF_SetLocked
local FCF_DockFrame, FCF_UnDockFrame = FCF_DockFrame, FCF_UnDockFrame
local FCF_SavePositionAndDimensions = FCF_SavePositionAndDimensions
local FCF_GetChatWindowInfo = FCF_GetChatWindowInfo
local FCF_StopDragging = FCF_StopDragging
local FCF_SetChatWindowFontSize = FCF_SetChatWindowFontSize
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS
local ADDONS, LOOT, TRADE, TANK, HEALER = ADDONS, LOOT, TRADE, TANK, HEALER
-- GLOBALS: LeftChatToggleButton

local function SetupLayout(layout)
	-- common settings
	E.db["bags"]["sortInverted"] = false
	E.db["bags"]["bagSize"] = 32
	E.db["bags"]["itemLevelCustomColorEnable"] = false
	E.db["bags"]["sortInverted"] = false
	E.db["bags"]["bagWidth"] = 412
	E.db["bags"]["scrapIcon"] = true
	E.db["bags"]["countFontOutline"] = "OUTLINE"
	E.db["bags"]["bankSize"] = 32
	E.db["bags"]["itemLevelFontOutline"] = "OUTLINE"
	E.db["bags"]["bankWidth"] = 412
	E.db["bags"]["transparent"] = true
	E.db["chat"]["panelBackdrop"] = 'SHOWBOTH'
	E.db["chat"]["timeStampFormat"] = "%H:%M "
	E.db["chat"]["panelWidth"] = 412
	E.db["databars"]["statusbar"] = "BuiFlat"
	E.db["databars"]["azerite"]["enable"] = true
	E.db["databars"]["azerite"]["height"] = 150
	E.db["databars"]["azerite"]["orientation"] = 'VERTICAL'
	E.db["databars"]["azerite"]["textFormat"] = 'NONE'
	E.db["databars"]["azerite"]["fontSize"] = 9
	E.db["databars"]["azerite"]["width"] = 8
	E.db["databars"]["experience"]["font"] = "Expressway"
	E.db["databars"]["experience"]["textYoffset"] = 10
	E.db["databars"]["experience"]["textFormat"] = "CURPERC"
	E.db["databars"]["experience"]["height"] = 5
	E.db["databars"]["experience"]["orientation"] = "HORIZONTAL"
	E.db["databars"]["experience"]["fontSize"] = 10
	E.db["databars"]["honor"]["enable"] = true
	E.db["databars"]["honor"]["height"] = 152
	E.db["databars"]["honor"]["textFormat"] = 'NONE'
	E.db["databars"]["honor"]["fontSize"] = 9
	E.db["databars"]["honor"]["width"] = 8
	E.db["databars"]["honor"]["orientation"] = 'VERTICAL'
	E.db["databars"]["reputation"]["enable"] = true
	E.db["databars"]["reputation"]["height"] = 150
	E.db["databars"]["reputation"]["orientation"] = 'VERTICAL'
	E.db["databars"]["reputation"]["textFormat"] = 'NONE'
	E.db["databars"]["reputation"]["fontSize"] = 9
	E.db["databars"]["reputation"]["width"] = 8
	E.db["datatexts"]["panels"]["LeftChatDataPanel"]["enable"] = false
	E.db["datatexts"]["panels"]["RightChatDataPanel"]["enable"] = false
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
	E.db["general"]["altPowerBar"]['enable'] = true
	E.db["general"]["altPowerBar"]['width'] = 250
	E.db["general"]["altPowerBar"]['height'] = 20
	E.db["general"]["altPowerBar"]['fontOutline'] = 'OUTLINE'
	E.db["general"]["altPowerBar"]['statusBar'] = "BuiFlat"
	E.db["general"]["altPowerBar"]['textFormat'] = 'NAMECURMAX'
	E.db["general"]["altPowerBar"]['statusBarColorGradient'] = false
	E.db["general"]["altPowerBar"]['statusBarColor'] = { r = 0.2, g = 0.4, b = 0.8 }
	E.db["general"]["itemLevel"]["displayCharacterInfo"] = false
	E.db["general"]["itemLevel"]["displayInspectInfo"] = true
	E.db["general"]["itemLevel"]["itemLevelFontSize"] = 12
	E.db["general"]["itemLevel"]["itemLevelFontOutline"] = 'OUTLINE'

	E.db["hideTutorial"] = true
	E.private["skins"]["blizzard"]["alertframes"] = true
	E.private["skins"]["blizzard"]["questChoice"] = true
	E.private["skins"]["parchmentRemoverEnable"] = true

	E.db["benikuiDatabars"]["azerite"]["buttonStyle"] = "DEFAULT"
	E.db["benikuiDatabars"]["azerite"]["notifiers"]["position"] = "RIGHT"
	E.db["benikuiDatabars"]["reputation"]["buttonStyle"] = "DEFAULT"
	E.db["benikuiDatabars"]["reputation"]["notifiers"]["position"] = "LEFT"
	E.db["benikuiDatabars"]["honor"]["buttonStyle"] = "TRANSPARENT"
	E.db["benikuiDatabars"]["honor"]["notifiers"]["position"] = "LEFT"
	E.db["benikuiDatabars"]["experience"]["buiStyle"] = false
	E.db["benikui"]["general"]["auras"] = false
	E.db["benikui"]["datatexts"]["chat"]["enable"] = true

	if E.screenheight == 1080 then E.db["general"]["UIScale"] = 0.711 end

	E.private["general"]["normTex"] = "BuiFlat"
	E.private["general"]["glossTex"] = "BuiFlat"
	E.private["general"]["chatBubbles"] = 'backdrop'

	BUI:GetModule('Layout'):CreateMiddlePanel()

	-- common movers
	if E.db["movers"] == nil then E.db["movers"] = {} end
	E.db["movers"]["AlertFrameMover"] = "TOP,ElvUIParent,TOP,0,-140"
	E.db["movers"]["AzeriteBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,415,22"
	E.db["movers"]["BelowMinimapContainerMover"] = "TOP,ElvUIParent,TOP,0,-192"
	E.db["movers"]["BNETMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-156,-200"
	E.db["movers"]["BuiDashboardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-8"
	E.db["movers"]["DigSiteProgressBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,315"
	E.db["movers"]["GMMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-38"
	E.db["movers"]["HonorBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-158,-6"
	E.db["movers"]["LeftChatMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,22"
	E.db["movers"]["LocationMover"] = "TOP,ElvUIParent,TOP,0,-7"
	E.db["movers"]["MicrobarMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,158,-5"
	E.db["movers"]["MinimapMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-6"
	E.db["movers"]["ObjectiveFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-210,-176"
	E.db["movers"]["PlayerNameplate"] = "BOTTOM,ElvUIParent,BOTTOM,0,359"
	E.db["movers"]["ProfessionsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-184"
	E.db["movers"]["ReputationBarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-415,22"
	E.db["movers"]["RightChatMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-2,22"
	E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-5,-303"
	E.db["movers"]["TopCenterContainerMover"] = "TOP,ElvUIParent,TOP,0,-34"
	E.db["movers"]["VehicleSeatMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,155,-81"
	E.db["movers"]["WatchFrameMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-122,-292"
	E.db["movers"]["tokenHolderMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-123"

	if layout == 'classic' then
		E.db["general"]["font"] = "Bui Prototype"
		E.db["general"]["fontSize"] = 10
		E.db["general"]["altPowerBar"]["font"] = "Bui Prototype"
		E.db["general"]["altPowerBar"]["fontSize"] = 10
		E.db["general"]["itemLevel"]["itemLevelFont"] = "Bui Prototype"

		E.db["chat"]["tabFont"] = "Bui Visitor1"
		E.db["chat"]["tabFontSize"] = 10
		E.db["chat"]["tabFontOutline"] = "MONOCROMEOUTLINE"
		E.db["chat"]["font"] = "Bui Prototype"
		E.db["chat"]["panelHeight"] = 150

		E.private["general"]["dmgfont"] = "Bui Prototype"
		E.private["general"]["chatBubbleFont"] = "Bui Prototype"
		E.private["general"]["chatBubbleFontSize"] = 14
		E.private["general"]["namefont"] = "Bui Prototype"

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
		E.db["tooltip"]["healthBar"]["height"] = 6
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

		E.db["benikui"]["general"]["shadows"] = false

		E.private.benikui.expressway = false
	elseif layout == "v3" then
		E.db["general"]["font"] = "Expressway"
		E.db["general"]["fontSize"] = 11
		E.db["general"]["altPowerBar"]["font"] = "Expressway"
		E.db["general"]["altPowerBar"]["fontSize"] = 11
		E.db["general"]["itemLevel"]["itemLevelFont"] = "Expressway"

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

		E.db["nameplates"]["statusbar"] = "BuiFlat"

		E.db["tooltip"]["font"] = "Expressway"
		E.db["tooltip"]["fontSize"] = 10
		E.db["tooltip"]["headerFontSize"] = 11
		E.db["tooltip"]["healthBar"]["font"] = "Expressway"
		E.db["tooltip"]["healthBar"]["fontSize"] = 9
		E.db["tooltip"]["healthBar"]["fontOutline"] = "OUTLINE"
		E.db["tooltip"]["healthBar"]["height"] = 6
		E.db["tooltip"]["smallTextFontSize"] = 11
		E.db["tooltip"]["textFontSize"] = 11

		E.db["benikui"]["misc"]["ilevel"]["font"] = "Expressway"
		E.db["benikui"]["misc"]["ilevel"]["fontsize"] = 10
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] = 417


		E.db["benikui"]["general"]["shadows"] = true

		E.private.benikui.expressway = true
	end

	PluginInstallStepComplete.message = BUI.Title..L['Layout Set']
	PluginInstallStepComplete:Show()

	E:StaggeredUpdateAll(nil, true)
end

function BUI:SetupColorThemes(color)
	-- Colors
	local ca, cr, cg, cb
	if color == 'Diablo' then
		ca = 0.75
		cr = 0.125
		cg = 0.054
		cb = 0.050
	elseif color == 'Hearthstone' then
		ca = 0.75
		cr = 0.086
		cg = 0.109
		cb = 0.149
	elseif color == 'Mists' then
		ca = 0.75
		cr = 0.043
		cg = 0.101
		cb = 0.101
	elseif color == 'Elv' then
		ca = 0.75
		cr = 0.054
		cg = 0.054
		cb = 0.054
	end

	E.db.general.backdropfadecolor.a = ca
	E.db.general.backdropfadecolor.r = cr
	E.db.general.backdropfadecolor.g = cg
	E.db.general.backdropfadecolor.b = cb

	E.db.chat.panelColor.a = ca
	E.db.chat.panelColor.r = cr
	E.db.chat.panelColor.g = cg
	E.db.chat.panelColor.b = cb

	E.db.benikui.colors.colorTheme = color

	E.db.general.backdropcolor.r = 0.025
	E.db.general.backdropcolor.g = 0.025
	E.db.general.backdropcolor.b = 0.025

	E:GetModule('Chat'):Panels_ColorUpdate()

	E:UpdateStart(true, true)
end

local function SetupColors()
	PluginInstallStepComplete.message = BUI.Title..L['Color Theme Set']
	PluginInstallStepComplete:Show()
end

local loot = LOOT:match"^.?[\128-\191]*"
local trade = TRADE:match"^.?[\128-\191]*"

local function SetupChat()
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format('ChatFrame%s', i)]
		local chatFrameId = frame:GetID()
		local chatName = FCF_GetChatWindowInfo(chatFrameId)

		FCF_SetChatWindowFontSize(nil, frame, 11)

		-- move ElvUI default loot frame to the left chat, so that Recount/Skada can go to the right chat.
		if i == 3 and (chatName == (LOOT..' / '..TRADE) or chatName == (loot..' / '..trade)) then
			FCF_UnDockFrame(frame)
			frame:ClearAllPoints()
			frame:Point('BOTTOMLEFT', LeftChatToggleButton, 'TOPLEFT', 1, 3)
			FCF_SetWindowName(frame, loot..' / '..trade)
			FCF_DockFrame(frame)
			FCF_SetLocked(frame, 1)
			frame:Show()
		end
		if frame:GetLeft() then
			FCF_SavePositionAndDimensions(frame)
			FCF_StopDragging(frame)
		end
	end

	PluginInstallStepComplete.message = BUI.Title..L['Chat Set']
	PluginInstallStepComplete:Show()
end

local function SetupActionbars(layout)
	-- Actionbars
	E.db["actionbar"]["lockActionBars"] = true
	E.db["actionbar"]["transparent"] = true
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["benikuiStyle"] = false
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["panelTransparency"] = false
	E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["backdrop"] = true
	E.db["benikui"]["actionbars"]["toggleButtons"]["enable"] = true

	if E.db["movers"] == nil then E.db["movers"] = {} end
	if layout == 'v1' then
		E.db["actionbar"]["font"] = "Bui Visitor1"
		E.db["actionbar"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["actionbar"]["fontSize"] = 10

		E.db["actionbar"]["bar1"]["backdrop"] = false
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["buttons"] = 10
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar3"]["buttonsize"] = 30
		E.db["actionbar"]["bar3"]["buttonspacing"] = 4
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar4"]["backdrop"] = true
		E.db["actionbar"]["bar4"]["buttons"] = 12
		E.db["actionbar"]["bar4"]["buttonsize"] = 26
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar5"]["enabled"] = true
		E.db["actionbar"]["bar5"]["backdrop"] = true
		E.db["actionbar"]["bar5"]["buttons"] = 10
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 5
		E.db["actionbar"]["bar5"]["buttonsize"] = 30
		E.db["actionbar"]["bar5"]["buttonspacing"] = 4
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 6
		E.db["actionbar"]["barPet"]["backdrop"] = false
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["buttonsize"] = 22
		E.db["actionbar"]["barPet"]["buttonspacing"] = 4
		E.db["actionbar"]["stanceBar"]["buttonspacing"] = 2
		E.db["actionbar"]["stanceBar"]["backdrop"] = false
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 24

		E.db["benikui"]["actionbars"]["style"]["bar2"] = true
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] = 414
		E.db["databars"]["experience"]["width"] = 414

		-- movers
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,98"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,58"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,298,58"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,-298,58"
		E.db["movers"]["PetAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,137"
		E.db["movers"]["ShiftAB"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,832,52"
		E.db["movers"]["DTPanelBuiMiddleDTPanelMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-56,346"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,283"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-56,-397"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-3"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-128"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,20"
		E.db["movers"]["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-128"

	elseif layout == 'v2' then
		E.db["actionbar"]["font"] = "Bui Visitor1"
		E.db["actionbar"]["fontOutline"] = "MONOCROMEOUTLINE"
		E.db["actionbar"]["fontSize"] = 10;

		E.db["actionbar"]["bar1"]["backdrop"] = false
		E.db["actionbar"]["bar1"]["buttons"] = 12
		E.db["actionbar"]["bar1"]["buttonsize"] = 30
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar2"]["buttons"] = 12
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["buttonsize"] = 30
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 6
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
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 6
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
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] = 417
		E.db["databars"]["experience"]["width"] = 417

		-- movers
		E.db["movers"]["ArenaHeaderMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-56,346"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,255"
		E.db["movers"]["BossHeaderMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-56,-397"
		E.db["movers"]["BuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-3"
		E.db["movers"]["DTPanelBuiMiddleDTPanelMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["DebuffsMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-181,-128"
		E.db["movers"]["ElvAB_1"] = "BOTTOM,ElvUIParent,BOTTOM,0,60"
		E.db["movers"]["ElvAB_2"] = "BOTTOM,ElvUIParent,BOTTOM,0,22"
		E.db["movers"]["ElvAB_3"] = "BOTTOM,ElvUIParent,BOTTOM,259,2"
		E.db["movers"]["ElvAB_5"] = "BOTTOM,ElvUIParent,BOTTOM,-259,2"
		E.db["movers"]["PetAB"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-150,177"
		E.db["movers"]["ShiftAB"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,832,128"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,100"
		E.db["movers"]["TalkingHeadFrameMover"] = "TOP,ElvUIParent,TOP,0,-128"

	elseif layout == 'v3' then
		E.db["actionbar"]["bar1"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar1"]["buttons"] = 10
		E.db["actionbar"]["bar1"]["buttonsPerRow"] = 10
		E.db["actionbar"]["bar1"]["buttonspacing"] = 4
		E.db["actionbar"]["bar1"]["buttonsize"] = 32
		E.db["actionbar"]["bar2"]["backdrop"] = true
		E.db["actionbar"]["bar2"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar2"]["buttons"] = 10
		E.db["actionbar"]["bar2"]["buttonsPerRow"] = 10
		E.db["actionbar"]["bar2"]["buttonspacing"] = 4
		E.db["actionbar"]["bar2"]["enabled"] = true
		E.db["actionbar"]["bar2"]["heightMult"] = 2
		E.db["actionbar"]["bar2"]["buttonsize"] = 32
		E.db["actionbar"]["bar3"]["backdrop"] = true
		E.db["actionbar"]["bar3"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar3"]["buttons"] = 12
		E.db["actionbar"]["bar3"]["buttonsPerRow"] = 12
		E.db["actionbar"]["bar3"]["buttonsize"] = 30
		E.db["actionbar"]["bar3"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar4"]["buttonsize"] = 26
		E.db["actionbar"]["bar4"]["buttonspacing"] = 4
		E.db["actionbar"]["bar4"]["mouseover"] = true
		E.db["actionbar"]["bar5"]["backdropSpacing"] = 6
		E.db["actionbar"]["bar5"]["buttons"] = 7
		E.db["actionbar"]["bar5"]["buttonsPerRow"] = 7
		E.db["actionbar"]["bar5"]["buttonsize"] = 30
		E.db["actionbar"]["bar5"]["buttonspacing"] = 4
		E.db["actionbar"]["bar5"]["enabled"] = false
		E.db["actionbar"]["bar6"]["buttonsize"] = 18
		E.db["actionbar"]["barPet"]["backdropSpacing"] = 6
		E.db["actionbar"]["barPet"]["buttonsPerRow"] = 10
		E.db["actionbar"]["barPet"]["buttonsize"] = 23
		E.db["actionbar"]["barPet"]["buttonspacing"] = 4
		E.db["actionbar"]["font"] = "Expressway"
		E.db["actionbar"]["fontOutline"] = "OUTLINE"
		E.db["actionbar"]["stanceBar"]["buttonsize"] = 24
		E.db["benikui"]["actionbars"]["style"]["bar2"] = false
		E.global["datatexts"]["customPanels"]["BuiMiddleDTPanel"]["width"] = 417
		E.db["databars"]["experience"]["width"] = 417
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
		E.db["movers"]["ShiftAB"] = "BOTTOM,ElvUIParent,BOTTOM,0,141"
		E.db["movers"]["DTPanelBuiMiddleDTPanelMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,2"
		E.db["movers"]["ExperienceBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,68"
		E.db["movers"]["TalkingHeadFrameMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,116"
	end
	BUI:GetModule('Actionbars'):ToggleStyle()

	PluginInstallStepComplete.message = BUI.Title..L['Actionbars Set']
	PluginInstallStepComplete:Show()

	E:StaggeredUpdateAll(nil, true)
end

local function SetupUnitframes(layout)
	E.db["general"]["decimalLength"] = 2
	if E.db["movers"] == nil then E.db["movers"] = {} end
	if layout == 'v1' then
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFont"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["font"] = "Bui Prototype"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["font"] = "Bui Prototype"

		E.db["benikui"]["unitframes"]["player"]["detachPortrait"] = false
		E.db["benikui"]["unitframes"]["player"]["portraitStyle"] = false
		E.db["benikui"]["unitframes"]["target"]["portraitStyle"] = false
		E.db["benikui"]["unitframes"]["target"]["getPlayerPortraitSize"] = false
		E.db["benikui"]["unitframes"]["target"]["detachPortrait"] = false
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
		E.db["unitframe"]["units"]["player"]["castbar"]["overlayOnFrame"] = "InfoPanel"
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
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 369
		E.db["unitframe"]["units"]["player"]["power"]["detachFromFrame"] = false
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["yOffset"] = 0
		E.db["unitframe"]["units"]["player"]["power"]["position"] = 'RIGHT'
		E.db["unitframe"]["units"]["player"]["power"]["text_format"] = "[powercolor][power:current-percent]"
		E.db["unitframe"]["units"]["player"]["power"]["hideonnpc"] = true
		E.db["unitframe"]["units"]["player"]["power"]["attachTextTo"] = 'InfoPanel'
		E.db["unitframe"]["units"]["player"]["aurabar"]["enable"] = false
		E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 3

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
		E.db["unitframe"]["units"]["target"]["castbar"]["overlayOnFrame"] = "InfoPanel"
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
		E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 3
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
		E.db["unitframe"]["units"]["pet"]["width"] = 130
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 130
		E.db["unitframe"]["units"]["pet"]["castbar"]["height"] = 14

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
		E.db["unitframe"]["units"]["targettarget"]["height"] = 30

		-- party
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = -22
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 19
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 10
		E.db["unitframe"]["units"]["party"]["debuffs"]["fontSize"] = 10
		E.db["unitframe"]["units"]["party"]["debuffs"]["position"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 25
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 19
		E.db["unitframe"]["units"]["party"]['growthDirection'] = 'UP_RIGHT'
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
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 16
		E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -17
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = 'UP_RIGHT'

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
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = 'RIGHT_UP'

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
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,271"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,349"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-392"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,444"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOM,ElvUIParent,BOTTOM,317,150"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,202"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,195"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,210"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,147"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-232,182"
		E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,180"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,180"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,636"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,147"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,232,182"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,-317,150"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,215"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,215"
		E.db["movers"]["TotemBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,425,42"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,317,137"
		E.db["movers"]["ZoneAbility"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,577,273"

	elseif layout == 'v2' then
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFont"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["font"] = "Bui Tukui"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["font"] = "Bui Tukui"

		E.db["benikui"]["unitframes"]["player"]["detachPortrait"] = true
		E.db["benikui"]["unitframes"]["player"]["portraitHeight"] = 47
		E.db["benikui"]["unitframes"]["player"]["portraitStyle"] = true
		E.db["benikui"]["unitframes"]["player"]["portraitStyleHeight"] = 6
		E.db["benikui"]["unitframes"]["player"]["portraitWidth"] = 110
		E.db["benikui"]["unitframes"]["player"]["portraitShadow"] = true
		E.db["benikui"]["unitframes"]["target"]["detachPortrait"] = true
		E.db["benikui"]["unitframes"]["target"]["portraitHeight"] = 47
		E.db["benikui"]["unitframes"]["target"]["portraitStyle"] = true
		E.db["benikui"]["unitframes"]["target"]["portraitStyleHeight"] = 6
		E.db["benikui"]["unitframes"]["target"]["portraitWidth"] = 110
		E.db["benikui"]["unitframes"]["target"]["getPlayerPortraitSize"] = false
		E.db["benikui"]["unitframes"]["target"]["portraitShadow"] = true
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
		E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 3
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["overlayOnFrame"] = "InfoPanel"
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
		E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 3
		E.db["unitframe"]["units"]["target"]["buffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 26
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 1
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["overlayOnFrame"] = "InfoPanel"
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
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 130
		E.db["unitframe"]["units"]["pet"]["height"] = 24
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["overlay"] = true
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["pet"]["power"]["width"] = 'fill'
		E.db["unitframe"]["units"]["pet"]["width"] = 130

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
		E.db["unitframe"]["units"]["targettarget"]["height"] = 36
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["enable"] = false
		E.db["unitframe"]["units"]["targettarget"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["enable"] = true
		E.db["unitframe"]["units"]["targettarget"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["targettarget"]["width"] = 110

		-- Party
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = -10
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["countFontSize"] = 14
		E.db["unitframe"]["units"]["party"]["debuffs"]["fontSize"] = 14
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 23
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 8
		E.db["unitframe"]["units"]["party"]['growthDirection'] = 'UP_RIGHT'
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
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 16
		E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -17
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = 'UP_RIGHT'

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
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = 'RIGHT_UP'

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
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,237"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,300"
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,722"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-526"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-542,108"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-542,125"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,200"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,148"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,159"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-217,140"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-189,163"
		E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,180"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,180"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,664"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,217,140"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,189,163"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,542,125"
		E.db["movers"]["PlayerPortraitMover"] = "BOTTOM,ElvUIParent,BOTTOM,-365,163"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-189,209"
		E.db["movers"]["TargetPortraitMover"] = "BOTTOM,ElvUIParent,BOTTOM,365,163"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,189,209"
		E.db["movers"]["TotemBarMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,425,42"
		E.db["movers"]["ZoneAbility"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,538,233"
	elseif layout == 'v3' then
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["debuffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["castbar"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["level"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["buffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_PLAYER"]["power"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["debuffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["castbar"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["level"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["buffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["FRIENDLY_NPC"]["power"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["debuffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["castbar"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["level"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["buffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_NPC"]["power"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["debuffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["power"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["health"]["text"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["name"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["level"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["countFont"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["buffs"]["font"] = "Expressway"
		E.db["nameplates"]["units"]["ENEMY_PLAYER"]["castbar"]["font"] = "Expressway"

		E.db["auras"]["buffs"]["horizontalSpacing"] = 3
		E.db["auras"]["buffs"]["size"] = 30
		E.db["auras"]["debuffs"]["size"] = 30
		E.db["auras"]["fadeThreshold"] = 10
		E.db["auras"]["font"] = "Expressway"
		E.db["auras"]["fontOutline"] = "OUTLINE"
		E.db["auras"]["timeXOffset"] = -1

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
		E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 3
		E.db["unitframe"]["units"]["player"]["buffs"]["attachTo"] = "FRAME"
		E.db["unitframe"]["units"]["player"]["buffs"]["enable"] = true
		E.db["unitframe"]["units"]["player"]["buffs"]["noDuration"] = false
		E.db["unitframe"]["units"]["player"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["player"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["player"]["castbar"]["height"] = 28
		E.db["unitframe"]["units"]["player"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["player"]["castbar"]["width"] = 258
		E.db["unitframe"]["units"]["player"]["castbar"]["overlayOnFrame"] = "InfoPanel"
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
		E.db["unitframe"]["units"]["player"]["power"]["detachedWidth"] = 369
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
		E.db["unitframe"]["units"]["player"]["aurabar"]["spacing"] = 3
		E.db["unitframe"]["units"]["target"]["aurabar"]["maxDuration"] = 120
		E.db["unitframe"]["units"]["target"]["buffs"]["sizeOverride"] = 30
		E.db["unitframe"]["units"]["target"]["buffs"]["yOffset"] = 2
		E.db["unitframe"]["units"]["target"]["castbar"]["icon"] = false
		E.db["unitframe"]["units"]["target"]["castbar"]["iconPosition"] = "RIGHT"
		E.db["unitframe"]["units"]["target"]["castbar"]["iconXOffset"] = 10
		E.db["unitframe"]["units"]["target"]["castbar"]["width"] = 258
		E.db["unitframe"]["units"]["target"]["castbar"]["overlayOnFrame"] = "InfoPanel"
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
		E.db["unitframe"]["units"]["pet"]["castbar"]["width"] = 130
		E.db["unitframe"]["units"]["pet"]["height"] = 24
		E.db["unitframe"]["units"]["pet"]["infoPanel"]["transparent"] = true
		E.db["unitframe"]["units"]["pet"]["portrait"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["power"]["enable"] = false
		E.db["unitframe"]["units"]["pet"]["power"]["height"] = 5
		E.db["unitframe"]["units"]["pet"]["width"] = 130

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
		E.db["unitframe"]["units"]["targettarget"]["width"] = 130

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
		E.db["unitframe"]["units"]["party"]["buffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["buffs"]["sizeOverride"] = 18
		E.db["unitframe"]["units"]["party"]["buffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["buffs"]["yOffset"] = -20
		E.db["unitframe"]["units"]["party"]["colorOverride"] = "FORCE_ON"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["attachTextTo"] = "Health"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["font"] = "Expressway"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["fontOutline"] = "OUTLINE"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["justifyH"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["size"] = 16
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["text_format"] = "[health:current-percent]"
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["xOffset"] = 0
		E.db["unitframe"]["units"]["party"]["customTexts"]["BenikuiPartyHealth"]["yOffset"] = 0
		E.db["unitframe"]["units"]["party"]["debuffs"]["anchorPoint"] = "RIGHT"
		E.db["unitframe"]["units"]["party"]["debuffs"]["sizeOverride"] = 25
		E.db["unitframe"]["units"]["party"]["debuffs"]["xOffset"] = 2
		E.db["unitframe"]["units"]["party"]["debuffs"]["yOffset"] = 17
		E.db["unitframe"]["units"]["party"]['growthDirection'] = 'UP_RIGHT'
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
		E.db["unitframe"]["units"]["raid"]["debuffs"]["anchorPoint"] = "TOPRIGHT"
		E.db["unitframe"]["units"]["raid"]["debuffs"]["sizeOverride"] = 16
		E.db["unitframe"]["units"]["raid"]["debuffs"]["xOffset"] = 0
		E.db["unitframe"]["units"]["raid"]["debuffs"]["yOffset"] = -17
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
		E.db["unitframe"]["units"]["raid"]["growthDirection"] = 'UP_RIGHT'

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
		E.db["unitframe"]["units"]["raid40"]["growthDirection"] = 'RIGHT_UP'

		-- movers
		E.db["movers"]["ElvUF_AssistMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-392"
		E.db["movers"]["BossButton"] = "BOTTOM,ElvUIParent,BOTTOM,0,391"
		E.db["movers"]["ElvUF_BodyGuardMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,444"
		E.db["movers"]["ElvUF_FocusCastbarMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-518,223"
		E.db["movers"]["ElvUF_FocusMover"] = "BOTTOMRIGHT,ElvUIParent,BOTTOMRIGHT,-518,236"
		E.db["movers"]["ElvUF_PartyMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,4,202"
		E.db["movers"]["ElvUF_PetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,232"
		E.db["movers"]["ElvUF_PetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,241"
		E.db["movers"]["ElvUF_PlayerCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,-231,147"
		E.db["movers"]["ElvUF_PlayerMover"] = "BOTTOM,ElvUIParent,BOTTOM,-314,268"
		E.db["movers"]["ElvUF_Raid40Mover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,180"
		E.db["movers"]["ElvUF_RaidMover"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,2,180"
		E.db["movers"]["ElvUF_RaidpetMover"] = "TOPLEFT,ElvUIParent,BOTTOMLEFT,4,636"
		E.db["movers"]["ElvUF_TankMover"] = "TOPLEFT,ElvUIParent,TOPLEFT,4,-300"
		E.db["movers"]["ElvUF_TargetCastbarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,147"
		E.db["movers"]["ElvUF_TargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,314,268"
		E.db["movers"]["ElvUF_TargetTargetMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,206"
		E.db["movers"]["ClassBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,360"
		E.db["movers"]["AltPowerBarMover"] = "TOP,ElvUIParent,TOP,0,-66"
		E.db["movers"]["PlayerPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,0,350"
		E.db["movers"]["TargetPowerBarMover"] = "BOTTOM,ElvUIParent,BOTTOM,231,215"
		E.db["movers"]["ZoneAbility"] = "BOTTOMLEFT,ElvUIParent,BOTTOMLEFT,552,368"
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

	E:StaggeredUpdateAll(nil, true)
end

local addonNames = {}
local profilesFailed = format('|cff00c0fa%s |r', L["BenikUI didn't find any supported addons for profile creation"])

BUI.isInstallerRunning = false

local function SetupAddons()
	BUI.isInstallerRunning = true -- don't print when applying profile that doesn't exist

	-- BigWigs
	if BUI:IsAddOnEnabled('BigWigs') then
		BUI:LoadBigWigsProfile()
		tinsert(addonNames, 'BigWigs')
	end

	-- DBM
	if BUI:IsAddOnEnabled('DBM-Core') then
		BUI:LoadDBMProfile()
		tinsert(addonNames, 'Deadly Boss Mods')
	end

	-- Details
	if BUI:IsAddOnEnabled('Details') then
		BUI:LoadDetailsProfile()
		tinsert(addonNames, 'Details')
	end

	-- InFlight
	if BUI:IsAddOnEnabled('InFlight_Load') then
		BUI:LoadInFlightProfile(true)
		tinsert(addonNames, 'InFlight')
	end

	-- Location Plus
	if BUI.LP then
		BUI:LoadLocationPlusProfile()
		tinsert(addonNames, 'Location Plus')
	end

	-- MikScrollingBattleText
	if BUI:IsAddOnEnabled('MikScrollingBattleText') then
		BUI:LoadMSBTProfile()
		tinsert(addonNames, "Mik's Scrolling Battle Text")
	end

	-- Pawn
	if BUI:IsAddOnEnabled('Pawn') then
		BUI:LoadPawnProfile()
		tinsert(addonNames, 'Pawn')
	end

	-- Recount
	if BUI:IsAddOnEnabled('Recount') then
		BUI:LoadRecountProfile()
		tinsert(addonNames, 'Recount')
	end

	-- Skada
	if BUI:IsAddOnEnabled('Skada') then
		BUI:LoadSkadaProfile()
		tinsert(addonNames, 'Skada')
	end

	-- Project Azilroka
	if BUI.PA then
		BUI:LoadPAProfile()
		tinsert(addonNames, 'Project Azilroka')
	end

	-- AddOnSkins
	if BUI.AS then
		BUI:LoadAddOnSkinsProfile()
		tinsert(addonNames, 'AddOnSkins')
	end

	if checkTable(addonNames) ~= nil then
		local profileString = format('|cfffff400%s |r', L['BenikUI successfully created and applied profile(s) for:']..'\n')

		tsort(addonNames, function(a, b) return a < b end)
		local names = tconcat(addonNames, ", ")
		profileString = profileString..names

		PluginInstallFrame.Desc4:SetText(profileString..'.')
	else
		PluginInstallFrame.Desc4:SetText(profilesFailed)
	end

	PluginInstallStepComplete.message = BUI.Title..L['Addons Set']
	PluginInstallStepComplete:Show()
	twipe(addonNames)
end

local function SetupDataTexts(role)
	-- Data Texts
	if BUI.LP then
		E.db["datatexts"]["panels"]["LocPlusRightDT"][1] = 'Time'
		E.db["datatexts"]["panels"]["LocPlusLeftDT"][1] = 'Movement Speed'
		E.DataTexts:UpdatePanelInfo('LocPlusRightDT')
		E.DataTexts:UpdatePanelInfo('LocPlusLeftDT')
	end

	if role == 'tank' then
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][1] = 'Avoidance'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][3] = 'Armor'
	elseif role == 'healer' then
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][1] = 'Haste'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][3] = 'Mana Regen'
	elseif role == 'dpsMelee' or 'dpsCaster' then
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][1] = 'Haste'
		E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][3] = 'Crit'
	end

	E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"][1] = 'Primary Stat'
	E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"][2] = 'Missions (BenikUI)'
	E.db["datatexts"]["panels"]["BuiLeftChatDTPanel"][3] = 'BuiMail'

	E.db["datatexts"]["panels"]["BuiRightChatDTPanel"][1] = 'Spec Switch (BenikUI)'
	E.db["datatexts"]["panels"]["BuiRightChatDTPanel"][3] = 'Gold'
	E.db["datatexts"]["panels"]["BuiRightChatDTPanel"][2] = 'Bags'

	E.db["datatexts"]["panels"]["BuiMiddleDTPanel"][2] = 'Mastery'

	E.DataTexts:UpdatePanelInfo('BuiLeftChatDTPanel')
	E.DataTexts:UpdatePanelInfo('BuiRightChatDTPanel')
	E.DataTexts:UpdatePanelInfo("BuiMiddleDTPanel")

	PluginInstallStepComplete.message = BUI.Title..L['DataTexts Set']
	PluginInstallStepComplete:Show()

	E:StaggeredUpdateAll(nil, true)
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
			PluginInstallTutorialImage:Size(384, 96)
			PluginInstallTutorialImage:Point('BOTTOM', 0, 100)
			PluginInstallTutorialImage2:SetTexture(nil)
			PluginInstallTitleFrame.text:SetFont(E["media"].normFont, 16, "OUTLINE")
			PluginInstallFrame.SubTitle:SetFormattedText(L["Welcome to BenikUI version %s, for ElvUI %s."], BUI.Version, E.version)
			PluginInstallFrame.Desc1:SetText(L["By pressing the Continue button, BenikUI will be applied on your current ElvUI installation.\n\n|cffff8000 TIP: It would be nice if you apply the changes in a new profile, just in case you don't like the result.|r"])
			PluginInstallFrame.Desc2:SetText(BUI:cOption(L["BenikUI options are marked with light blue color, inside ElvUI options."], "blue"))
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
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupLayout('v3') end)
			PluginInstallFrame.Option2:SetText(L["v3"])
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
			PluginInstallFrame.Option1:SetScript("OnClick", function() SetupDataTexts("tank") end)
			PluginInstallFrame.Option1:SetText(TANK)
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() SetupDataTexts("healer") end)
			PluginInstallFrame.Option2:SetText(HEALER)
			PluginInstallFrame.Option3:Show()
			PluginInstallFrame.Option3:SetScript("OnClick", function() SetupDataTexts("dpsMelee") end)
			PluginInstallFrame.Option3:SetText(L["Physical DPS"])
			PluginInstallFrame.Option4:Show()
			PluginInstallFrame.Option4:SetScript("OnClick", function() SetupDataTexts("dpsCaster") end)
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
			PluginInstallFrame.Desc1:SetText(L["You are now finished with the installation process. If you are in need of technical support please visit us at https://www.tukui.org."])
			PluginInstallFrame.Desc2:SetText(L["Please click the button below so you can setup variables and ReloadUI."])
			PluginInstallFrame.Option1:Show()
			PluginInstallFrame.Option1:SetScript("OnClick", function() StaticPopup_Show("BENIKUI_CREDITS", nil, nil, "https://discord.gg/8ZDDUem") end)
			PluginInstallFrame.Option1:SetText("Discord")
			PluginInstallFrame.Option2:Show()
			PluginInstallFrame.Option2:SetScript("OnClick", function() InstallComplete() end)
			PluginInstallFrame.Option2:SetText(L["Finished"])
			PluginInstallStepComplete.message = BUI.Title..L['Installed']
			PluginInstallStepComplete:Show()
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
