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

	if not button.hasShadow then
		local icon = button.icon or button.Icon
		if icon and not icon.backdrop then
			icon:CreateBackdrop('Transparent')
			icon.backdrop:CreateSoftShadow()
		end

		button.hasShadow = true
	end
end

local function QuestIconsShadows(_, block)
	AddShadowsQuestIcon(block.ItemButton)
end

local function ProgressBarsShadows(tracker, key)
	local progressBar = tracker.usedProgressBars[key]
	local bar = progressBar and progressBar.Bar
	if not bar then return end
	local icon = bar.Icon

	if not progressBar.hasShadow then
		bar.backdrop:CreateSoftShadow()

		if icon and icon:GetTexture() then
			icon:ClearAllPoints()
			icon:Point('LEFT', bar, 'RIGHT', E.PixelMode and 6 or 10, 0)
			icon:Size(18, 18) -- I like this better
			icon:CreateBackdrop('Transparent')
			icon.backdrop:CreateSoftShadow()
		end
		progressBar.hasShadow = true
	end
end

function mod:InitializeObjectiveTracker()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.objectiveTracker) then return end
	if BUI:IsAddOnEnabled('!KalielsTracker') then return end

	for _, tracker in pairs(trackers) do
		hooksecurefunc(tracker, 'GetProgressBar', ProgressBarsShadows)
		hooksecurefunc(tracker, 'AddBlock', QuestIconsShadows)
		hooksecurefunc(tracker, 'GetTimerBar', HandleTimers)
	end
end
S:AddCallbackForAddon('Blizzard_ObjectiveTracker', 'BenikUI_ObjectiveTracker', mod.InitializeObjectiveTracker)