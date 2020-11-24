local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Shadows')
local S = E:GetModule('Skins')
local M = E:GetModule('Misc')

local _G = _G

local CLASS_SORT_ORDER = CLASS_SORT_ORDER

local function mirrorTimersShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mirrorTimers ~= true then return end

	for i = 1, _G.MIRRORTIMER_NUMTIMERS do
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
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or BUI.ShadowMode ~= true then return end

	_G.EquipmentFlyoutFrameButtons:CreateSoftShadow()
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

-- SpellBook tabs shadow
local function SpellbookTabShadows()
	if E.private.skins.blizzard.enable ~= true or BUI.ShadowMode ~= true or E.private.skins.blizzard.spellbook ~= true then
		return
	end

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs",
		function()
			for i = 1, MAX_SKILLLINE_TABS do
				local tab = _G['SpellBookSkillLineTab'..i]
				tab.backdrop:CreateSoftShadow()
			end
		end)
end
S:AddCallback("BenikUI_Spellbook", SpellbookTabShadows)

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

function mod:ChatBubbles(frame, holder)
	if E.private.general.chatBubbles == 'backdrop' then
		if holder.backdrop then
			if not holder.backdrop.shadow then
				holder.backdrop:CreateWideShadow()
			end
		end
	end
end

function mod:Initialize()
	if not BUI.ShadowMode then return end

	raidUtilityShadows()
	mirrorTimersShadows()

	miscShadows()
	MicroBarShadows()
	mod:RegisterEvent('START_TIMER')

	-- AddonSkins
	mod:AddonSkins()

	-- Callbacks
	S:AddCallbackForAddon("Blizzard_Calendar", "BenikUI_CalendarEventButtonShadows", CalendarEventButtonShadows)
	hooksecurefunc(M, "SkinBubble", mod.ChatBubbles)
end

BUI:RegisterModule(mod:GetName())