local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIS = E:GetModule('BuiSkins')
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

-- Calendar Event Class Buttons
local function CalendarEventButtonShadows()
	if E.private.skins.blizzard.calendar ~= true or E.private.skins.blizzard.enable ~= true or E.db.benikui.general.shadows ~= true then return end

	for i = 1, #CLASS_SORT_ORDER do
		local button = _G["CalendarClassButton"..i]
		button.backdrop:CreateSoftShadow()
	end
	CalendarClassTotalsButton.backdrop:CreateSoftShadow()
end
S:AddCallbackForAddon("Blizzard_Calendar", "BenikUI_CalendarEventButtonShadows", CalendarEventButtonShadows)

-- ElvUI tabs
function BUIS:TabShadows(tab)
	if E.db.benikui.general.shadows ~= true then return end
	if not tab then return end
	
	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:CreateSoftShadow()
	end
end

-- AddonSkins tabs
function BUIS:TabShadowsAS(tab)
	if not tab then return end

	if tab.Backdrop then
		tab.Backdrop:CreateSoftShadow()
	end
end

-- AddonSkins WeakAuras
local function WeakAurasShadows()
	local function Skin_WeakAuras(frame, ftype)
		if not frame.Backdrop.shadow then
			frame.Backdrop:CreateSoftShadow()
		end
	end

	local Create_Icon, Modify_Icon = WeakAuras.regionTypes.icon.create, WeakAuras.regionTypes.icon.modify
	local Create_AuraBar, Modify_AuraBar = WeakAuras.regionTypes.aurabar.create, WeakAuras.regionTypes.aurabar.modify

	WeakAuras.regionTypes.icon.create = function(parent, data)
		local region = Create_Icon(parent, data)
		Skin_WeakAuras(region, 'icon')
		return region
	end

	WeakAuras.regionTypes.aurabar.create = function(parent)
		local region = Create_AuraBar(parent)
		Skin_WeakAuras(region, 'aurabar')
		return region
	end

	WeakAuras.regionTypes.icon.modify = function(parent, region, data)
		Modify_Icon(parent, region, data)
		Skin_WeakAuras(region, 'icon')
	end

	WeakAuras.regionTypes.aurabar.modify = function(parent, region, data)
		Modify_AuraBar(parent, region, data)
		Skin_WeakAuras(region, 'aurabar')
	end

	for weakAura, _ in pairs(WeakAuras.regions) do
		if WeakAuras.regions[weakAura].regionType == 'icon' or WeakAuras.regions[weakAura].regionType == 'aurabar' then
			Skin_WeakAuras(WeakAuras.regions[weakAura].region, WeakAuras.regions[weakAura].regionType)
		end
	end
end

function BUIS:Shadows()
	if E.db.benikui.general.shadows ~= true then return end

	raidUtilityShadows()
	mirrorTimersShadows()
	ObjectiveTrackerShadows()

	-- AddonSkins
	if not BUI.AS then return end
	local AS = unpack(AddOnSkins)
	hooksecurefunc(AS, "SkinTab", BUIS.TabShadowsAS)
	if AS:CheckAddOn('WeakAuras') then AS:RegisterSkin('WeakAuras', WeakAurasShadows, 2) end
end
hooksecurefunc(S, "HandleTab", BUIS.TabShadows)