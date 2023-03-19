local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')
local AFK = E:GetModule('AFK')

local _G = _G
local format, join = string.format, string.join

local MAX_QUESTS = 35
local TRACKER_HEADER_QUESTS = TRACKER_HEADER_QUESTS
local OBJECTIVES_TRACKER_LABEL = OBJECTIVES_TRACKER_LABEL

local C_QuestLog_GetInfo = C_QuestLog.GetInfo
local C_QuestLog_GetNumQuestLogEntries = C_QuestLog.GetNumQuestLogEntries

local headers = {
	_G.ObjectiveTrackerBlocksFrame.QuestHeader,
	_G.ObjectiveTrackerBlocksFrame.AchievementHeader,
	_G.ObjectiveTrackerBlocksFrame.ScenarioHeader,
	_G.ObjectiveTrackerBlocksFrame.CampaignQuestHeader,
	_G.BONUS_OBJECTIVE_TRACKER_MODULE.Header,
	_G.WORLD_QUEST_TRACKER_MODULE.Header,
	_G.ObjectiveTrackerFrame.BlocksFrame.UIWidgetsHeader
}

local function ObjectiveTrackerShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or not BUI.ShadowMode then return end

	_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton:CreateSoftShadow()
	_G.ObjectiveTrackerFrame.HeaderMenu.MinimizeButton.shadow:SetOutside()

	local function ProgressBarsShadows(_, _, line)
		local progressBar = line and line.ProgressBar
		local bar = progressBar and progressBar.Bar
		if not bar then return end
		local icon = bar.Icon

		if not progressBar.hasShadow then
			bar.backdrop:CreateSoftShadow()

			if icon then
				icon:ClearAllPoints()
				icon:Point('LEFT', bar, 'RIGHT', E.PixelMode and 6 or 10, 0)
				icon:Size(18, 18) -- I like this better
				icon:CreateBackdrop('Transparent')
				icon.backdrop:CreateSoftShadow()
				local texture = icon:GetNormalTexture():GetTexture()
				if not texture then icon.backdrop:Hide() end
			end
			progressBar.hasShadow = true
		end
	end

	local function ItemButtonShadows(_, block)
		local item = block.itemButton
		if item and not item.shadow then -- this seems that doesn't keep the shadow. Keep an eye
			item:CreateSoftShadow()
		end
	end

	hooksecurefunc(_G.BONUS_OBJECTIVE_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(_G.DEFAULT_OBJECTIVE_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(_G.SCENARIO_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(_G.QUEST_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(_G.QUEST_TRACKER_MODULE,"SetBlockHeader",ItemButtonShadows)
	hooksecurefunc(_G.WORLD_QUEST_TRACKER_MODULE,"AddObjective",ItemButtonShadows)
	hooksecurefunc(_G.CAMPAIGN_QUEST_TRACKER_MODULE,"AddObjective",ItemButtonShadows)

	local function FindGroupButtonShadows(block)
		if block.hasGroupFinderButton and block.groupFinderButton then
			if block.groupFinderButton and not block.groupFinderButton.hasShadow then
				block.groupFinderButton:CreateSoftShadow()
				block.groupFinderButton.hasShadow = true
			end
		end
	end
	hooksecurefunc("QuestObjectiveSetupBlockButton_FindGroup",FindGroupButtonShadows)

	for _, header in pairs(headers) do
		local minimize = header.MinimizeButton
		if minimize then
			minimize:CreateSoftShadow()
			minimize.shadow:SetOutside()
		end
	end
end

local function ObjectiveTrackerQuests()
	if BUI:IsAddOnEnabled('!KalielsTracker') or E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.objectiveTracker ~= true or E.db.benikui.skins.variousSkins.objectiveTracker ~= true then return end
	
	-- Objective Tracker Backdrop
	--[[local tracker = _G.ObjectiveTrackerBlocksFrame
	tracker:CreateBackdrop("Transparent")
	tracker.backdrop:SetOutside(tracker, 30)
	tracker.backdrop:BuiStyle("Outside")]]

	local header = _G.ObjectiveTrackerBlocksFrame.QuestHeader
	header.buibar = CreateFrame('Frame', nil, header)
	header.buibar:SetTemplate('Transparent', nil, true, true)
	header.buibar:SetBackdropBorderColor(0, 0, 0, 0)
	header.buibar:SetBackdropColor(1, 1, 1, .2)
	header.buibar:Point('BOTTOMLEFT', header, 2, -2)
	header.buibar:Size(header:GetWidth() -20, 1)

	header.buibar.status = CreateFrame('StatusBar', nil, header.buibar)
	header.buibar.status:SetStatusBarTexture(E.Media.Textures.White8x8)
	header.buibar.status:SetAllPoints(header.buibar)
	header.buibar.status:SetMinMaxValues(0, MAX_QUESTS)

	header.buibar.status.spark = header.buibar.status:CreateTexture(nil, 'OVERLAY', nil)
	header.buibar.status.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	header.buibar.status.spark:Size(12, 6)
	header.buibar.status.spark:SetBlendMode('ADD')
	header.buibar.status.spark:Point('CENTER', header.buibar.status:GetStatusBarTexture(), 'RIGHT')

	local function QuestNumString()
		local questNum = 0
		local block = _G.ObjectiveTrackerBlocksFrame
		local blockText = block.QuestHeader.Text
		local frame = _G.ObjectiveTrackerFrame
		local frameText = frame.HeaderMenu.Title
		local statusBar = block.QuestHeader.buibar.status
		local TextFormat = '%d/%d %s'

		if not InCombatLockdown() then
			for questLogIndex = 1, C_QuestLog_GetNumQuestLogEntries() do
				local info = C_QuestLog_GetInfo(questLogIndex)
				if info and not info.isHeader and not info.isHidden then
					questNum = questNum + 1
				end
			end

			local colorValue = (MAX_QUESTS > 0 and questNum / MAX_QUESTS) or 0
			local r, g, b = E:ColorGradient(colorValue, 0,0.8,0, 0.8,0.8,0, 0.8,0,0)
			statusBar:SetStatusBarColor(r, g, b)
			statusBar:SetValue(questNum)

			blockText:SetFormattedText(TextFormat, questNum, MAX_QUESTS, TRACKER_HEADER_QUESTS)
			frameText:SetFormattedText(TextFormat, questNum, MAX_QUESTS, OBJECTIVES_TRACKER_LABEL)

			local r1, g2, b2 = statusBar:GetStatusBarColor()
			blockText:SetTextColor(r1, g2, b2)
			blockText:FontTemplate(nil, 14, 'NONE')
			frameText:SetTextColor(r1, g2, b2)
			frameText:FontTemplate(nil, 14, 'NONE')
		end
	end
	
	hooksecurefunc("ObjectiveTracker_Update", QuestNumString)
	hooksecurefunc(AFK, "SetAFK", QuestNumString)
end
S:AddCallback("BenikUI_ObjectiveTracker", ObjectiveTrackerQuests)

function mod:InitializeObjectiveTracker()
	if BUI:IsAddOnEnabled('!KalielsTracker') then return end
	ObjectiveTrackerShadows()
end
