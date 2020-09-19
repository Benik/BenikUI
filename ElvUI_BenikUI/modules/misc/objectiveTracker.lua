local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins')

local _G = _G

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
				if not bar.dummy then -- need a frame to apply the shadow
					bar.dummy = CreateFrame('Frame', nil, bar)
					bar.dummy:SetOutside(icon)
					bar.dummy:CreateSoftShadow()
					bar.dummy:SetShown(icon:IsShown())
				end
				icon:Size(18, 18) -- I like this better
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
				block.groupFinderButton:SetTemplate("Transparent")
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
	local function QuestNumString()
		local questNum, q, o
		local block = _G.ObjectiveTrackerBlocksFrame
		local frame = _G.ObjectiveTrackerFrame

		if not InCombatLockdown() then
			questNum = select(2, C_QuestLog.GetNumQuestLogEntries())
			if questNum >= (MAX_QUESTS - 5) then -- go red
				q = format("|cffff0000%d/%d|r %s", questNum, MAX_QUESTS, TRACKER_HEADER_QUESTS)
				o = format("|cffff0000%d/%d|r %s", questNum, MAX_QUESTS, OBJECTIVES_TRACKER_LABEL)
			else
				q = format("%d/%d %s", questNum, MAX_QUESTS, TRACKER_HEADER_QUESTS)
				o = format("%d/%d %s", questNum, MAX_QUESTS, OBJECTIVES_TRACKER_LABEL)
			end
			block.QuestHeader.Text:SetText(q)
			frame.HeaderMenu.Title:SetText(o)
		end
	end
	hooksecurefunc("ObjectiveTracker_Update", QuestNumString)
end
S:AddCallback("BenikUI_ObjectiveTracker", ObjectiveTrackerQuests)

function mod:InitializeObjectiveTracker()
	ObjectiveTrackerShadows()
end