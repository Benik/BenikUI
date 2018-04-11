local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIS = E:GetModule('BuiSkins')
local S = E:GetModule('Skins');

local _G = _G
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
				end
				icon:Size(18) -- I like this better
			end
			progressBar.hasShadow = true
		end
	end
	hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(WORLD_QUEST_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	hooksecurefunc(SCENARIO_TRACKER_MODULE,"AddProgressBar",ProgressBarsShadows)
	
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

function BUIS:TabShadows(tab)
	if not tab then return end
	
	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:CreateSoftShadow()
	end
end

function BUIS:TabShadowsAS(tab)
	if not tab then return end

	if tab.Backdrop then
		tab.Backdrop:CreateSoftShadow()
	end

end

function BUIS:Shadows()
	if E.db.benikui.general.shadows ~= true then return end

	raidUtilityShadows()
	mirrorTimersShadows()
	ObjectiveTrackerShadows()
	
	hooksecurefunc(S, "HandleTab", BUIS.TabShadows)
	
	-- AddonSkins
	if not BUI.AS then return end
	local AS = unpack(AddOnSkins)
	hooksecurefunc(AS, "SkinTab", BUIS.TabShadowsAS)
end
