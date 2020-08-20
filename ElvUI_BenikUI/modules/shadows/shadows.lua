local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('Shadows', 'AceHook-3.0', 'AceEvent-3.0');
local S = E:GetModule('Skins');

local _G = _G

local CLASS_SORT_ORDER = CLASS_SORT_ORDER
-- GLOBALS: MIRRORTIMER_NUMTIMERS

local function mirrorTimersShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mirrorTimers ~= true then return end

	for i = 1, MIRRORTIMER_NUMTIMERS do
		local statusBar = _G['MirrorTimer'..i..'StatusBar']
		statusBar.backdrop:CreateSoftShadow()
	end
end

local function raidUtilityShadows()
	if E.private.general.raidUtility == false then return end

	if _G["RaidUtility_ShowButton"] then
		_G["RaidUtility_ShowButton"]:CreateSoftShadow()
	end

	if _G["RaidUtilityPanel"] then
		_G["RaidUtilityPanel"]:CreateSoftShadow()
	end
end

local function ObjectiveTrackerShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true then return end

	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:CreateSoftShadow()
	ObjectiveTrackerFrame.HeaderMenu.MinimizeButton.shadow:SetOutside()

	local function ProgressBarsShadows(self, _, line)
		local progressBar = line and line.ProgressBar
		local bar = progressBar and progressBar.Bar
		if not bar then return end
		local icon = bar.Icon

		if not progressBar.hasShadow then
			bar.backdrop:CreateSoftShadow()

			if icon then
				if not bar.dummy then -- need a frame to apply the shadow
					bar.dummy = CreateFrame('Frame', nil, bar)
					bar.dummy:SetOutside(icon)
					bar.dummy:CreateSoftShadow()
					bar.dummy:SetShown(icon:IsShown())
				end
				icon:Size(18) -- I like this better
			end
			progressBar.hasShadow = true
		end
	end

	local function ItemButtonShadows(self, block)
		local item = block.itemButton
		if item and not item.shadow then
			item:CreateSoftShadow()
		end
	end

	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(SCENARIO_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(QUEST_TRACKER_MODULE,"SetBlockHeader",ItemButtonShadows)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE,"AddObjective",ItemButtonShadows)

	local function FindGroupButtonShadows(block)
		if block.hasGroupFinderButton and block.groupFinderButton then
			if block.groupFinderButton and not block.groupFinderButton.hasShadow then
				block.groupFinderButton:SetTemplate("Transparent")
				block.groupFinderButton:CreateSoftShadow()
				block.groupFinderButton.hasShadow = true
			end
		end
	end
	hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup",FindGroupButtonShadows)
end

-- Calendar Event Class Buttons
local function CalendarEventButtonShadows()
	if E.private.skins.blizzard.calendar ~= true or E.private.skins.blizzard.enable ~= true then return end

	for i = 1, #CLASS_SORT_ORDER do
		local button = _G["CalendarClassButton"..i]
		if button.backdrop then
			button.backdrop:CreateSoftShadow()
		end
	end
	if _G.CalendarClassTotalsButton.backdrop then
		_G.CalendarClassTotalsButton.backdrop:CreateSoftShadow()
	end
end

local function miscShadows()
	if E.private.skins.blizzard.enable ~= true then return end

	local db = E.private.skins.blizzard

	if db.character then
		EquipmentFlyoutFrameButtons:CreateSoftShadow()
	end
end

-- ElvUI tabs
function mod:TabShadows(tab)
	if not BUI.ShadowMode then return end
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:CreateSoftShadow()
	end
end
hooksecurefunc(S, "HandleTab", mod.TabShadows)

-- MicroBar
local function MicroBarShadows()
	for i=1, #MICRO_BUTTONS do
		if _G[MICRO_BUTTONS[i]].backdrop then
			_G[MICRO_BUTTONS[i]].backdrop:CreateSoftShadow()
		end
	end
end

local function TimerShadow(bar)
	bar.backdrop:CreateSoftShadow()
end

function mod:START_TIMER()
	for _, b in pairs(TimerTracker.timerList) do
		if b["bar"] and not b["bar"].hasShadow then
			TimerShadow(b["bar"])
			b["bar"].hasShadow = true
		end
	end
end

function mod:Initialize()
	if not BUI.ShadowMode then return end

	raidUtilityShadows()
	mirrorTimersShadows()
	ObjectiveTrackerShadows()
	miscShadows()
	MicroBarShadows()
	mod:RegisterEvent('START_TIMER')

	-- AddonSkins
	mod:AddonSkins()

	-- Callbacks
	S:AddCallbackForAddon("Blizzard_Calendar", "BenikUI_CalendarEventButtonShadows", CalendarEventButtonShadows)
end

BUI:RegisterModule(mod:GetName())