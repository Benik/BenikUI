local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Shadows')
local S = E:GetModule('Skins')
local M = E:GetModule('Misc')

local _G = _G

local CLASS_SORT_ORDER = CLASS_SORT_ORDER

local function AltPowerBarShadows()
	if E.db.general.altPowerBar.enable ~= true then return end
	local bar = _G.ElvUI_AltPowerBar

	bar.backdrop:CreateSoftShadow()
	if bar.textures then
		bar:StripTextures(true)
	end
end

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

-- ElvUI item buttons
function mod:ItemButtonShadows(button)
	if not BUI.ShadowMode then return end
	if not button then return end

	if button.backdrop then
		button.backdrop:SetTemplate("Transparent")
		button.backdrop:CreateSoftShadow()
	end
end
hooksecurefunc(S, "HandleItemButton", mod.ItemButtonShadows)

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
				holder.backdrop:CreateSoftShadow()
			end
		end
	end
end

-- thanks to Repooc for guidance
local function CharacterFrameShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true then
		return
	end
	local i = 1
	local tab = _G['CharacterFrameTab'..i]
	while tab do
		if not tab then return end

		if tab.backdrop then
			tab.backdrop:SetTemplate("Transparent")
			tab.backdrop:CreateSoftShadow()
		end

		i = i + 1
		tab = _G['CharacterFrameTab'..i]
	end
end

local function SpellBookFrameShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.spellbook ~= true then
		return
	end
	local i = 1
	local tab = _G['SpellBookFrameTabButton'..i]
	while tab do
		if not tab then return end

		if tab.backdrop then
			tab.backdrop:SetTemplate("Transparent")
			tab.backdrop:CreateSoftShadow()
		end

		i = i + 1
		tab = _G['SpellBookFrameTabButton'..i]
	end

	for j = 1, MAX_SKILLLINE_TABS do
		local tab = _G['SpellBookSkillLineTab'..j]
		tab:CreateSoftShadow()
	end

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs",
			function()
				for i = 1, MAX_SKILLLINE_TABS do
					local tab = _G['SpellBookSkillLineTab'..i]
					tab:CreateSoftShadow()
				end
			end)
end

local function PVEFrameShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.lfg ~= true then
		return
	end
	local i = 1
	local tab = _G['PVEFrameTab'..i]
	while tab do
		if not tab then return end

		if tab.backdrop then
			tab.backdrop:SetTemplate("Transparent")
			tab.backdrop:CreateSoftShadow()
		end

		i = i + 1
		tab = _G['PVEFrameTab'..i]
	end
end

local function FriendsFrameShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.friends ~= true then
		return
	end
	local i = 1
	local tab = _G['FriendsFrameTab'..i]
	while tab do
		if not tab then return end

		if tab.backdrop then
			tab.backdrop:SetTemplate("Transparent")
			tab.backdrop:CreateSoftShadow()
		end

		i = i + 1
		tab = _G['FriendsFrameTab'..i]
	end
end

function mod:Initialize()
	if not BUI.ShadowMode then return end

	raidUtilityShadows()
	mirrorTimersShadows()

	miscShadows()
	MicroBarShadows()
	CharacterFrameShadows()
	SpellBookFrameShadows()
	PVEFrameShadows()
	FriendsFrameShadows()
	mod:RegisterEvent('START_TIMER')

	-- AddonSkins
	mod:AddonSkins()

	-- Callbacks
	S:AddCallbackForAddon("Blizzard_Calendar", "BenikUI_CalendarEventButtonShadows", CalendarEventButtonShadows)
	hooksecurefunc(M, "SkinBubble", mod.ChatBubbles)
end

BUI:RegisterModule(mod:GetName())