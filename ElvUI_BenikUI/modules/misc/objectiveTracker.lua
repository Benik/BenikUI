local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Styles')
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local trackers = {
	_G.ScenarioObjectiveTracker,
	_G.UIWidgetObjectiveTracker,
	_G.CampaignQuestObjectiveTracker,
	_G.QuestObjectiveTracker,
	_G.AdventureObjectiveTracker,
	_G.AchievementObjectiveTracker,
	_G.MonthlyActivitiesObjectiveTracker,
	_G.ProfessionsRecipeTracker,
	_G.BonusObjectiveTracker,
	_G.WorldQuestObjectiveTracker,
	_G.InitiativeTasksObjectiveTracker
}

local function HandleTimers(tracker, key)
	local timerBar = tracker.usedTimerBars[key]
	local bar = timerBar and timerBar.Bar

	if bar and bar.backdrop then
		bar.backdrop:CreateSoftShadow()
	end
end

local function AddShadowsQuestIcon(button)
	if not button then return end

	if button.backdrop and not button.hasShadow then
		button.backdrop:CreateSoftShadow()
		button.hasShadow = true
	end
end

local function QuestIconsShadows(_, block)
	AddShadowsQuestIcon(block.ItemButton)

	local frame = block.rightEdgeFrame
	if not frame then
		return
	end

	if frame.template == "QuestObjectiveItemButtonTemplate" then
		if not frame.shadow then
			frame:CreateSoftShadow()
		end
	end
end

local function ProgressBarsShadows(tracker, key)
	local progressBar = tracker.usedProgressBars[key]
	local bar = progressBar and progressBar.Bar

	if bar and not bar.hasShadow then
		bar.backdrop:CreateSoftShadow()

		local icon = bar.Icon
		if icon and icon:IsShown() then
			icon:Point('LEFT', bar, 'RIGHT', E.PixelMode and 5 or 9, 0)
			icon:Size(18, 18) -- I like this better
			icon:CreateBackdrop()
			icon.backdrop:CreateSoftShadow()
		end

		bar.hasShadow = true
	end
end

function mod:InitializeObjectiveTracker()
	if E.private.skins.blizzard.objectiveTracker ~= true or E.private.skins.blizzard.enable ~= true or
		E.db.benikui.general.shadows ~= true
	then
		return
	end

	if BUI:IsAddOnEnabled('!KalielsTracker') then return end

	for _, tracker in pairs(trackers) do
		hooksecurefunc(tracker, 'GetProgressBar', ProgressBarsShadows)
		hooksecurefunc(tracker, 'AddBlock', QuestIconsShadows)
		hooksecurefunc(tracker, 'GetTimerBar', HandleTimers)
	end
end
S:AddCallbackForAddon('Blizzard_ObjectiveTracker', 'BenikUI_ObjectiveTracker', mod.InitializeObjectiveTracker)