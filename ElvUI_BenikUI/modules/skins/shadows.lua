local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Shadows')
local S = E:GetModule('Skins')
local M = E:GetModule('Misc')
local B = E:GetModule('Blizzard')
local AB = E:GetModule('ActionBars')

local _G = _G
local pairs = pairs
local hooksecurefunc = hooksecurefunc

local CLASS_SORT_ORDER = CLASS_SORT_ORDER

local function AltPowerBarShadows()
	if E.db.general.altPowerBar.enable ~= true then return end
	local bar = _G.ElvUI_AltPowerBar

	bar.backdrop:CreateSoftShadow()
	if bar.textures then
		bar:StripTextures(true)
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
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.character ~= true or E.db.benikui.general.shadows ~= true then return end

	_G.EquipmentFlyoutFrameButtons:CreateSoftShadow()
end

-- ElvUI tabs
function mod:TabShadows(tab)
	if not E.db.benikui.general.shadows then return end
	if not tab then return end

	if tab.backdrop then
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:CreateSoftShadow()
	end
end
--hooksecurefunc(S, "HandleTab", mod.TabShadows) -- this errors on BGs

-- ElvUI item buttons
function mod:ItemButtonShadows(button)
	if not E.db.benikui.general.shadows then return end
	if not button then return end
	if Baganator then return end

	if button.backdrop then
		button.backdrop:SetTemplate("Transparent")
		button.backdrop:CreateSoftShadow()
	end
end
hooksecurefunc(S, "HandleItemButton", mod.ItemButtonShadows)

-- MicroBar
local function MicroBarShadows()
	for _, x in pairs(AB.MICRO_BUTTONS) do
		if _G[x] then
			_G[x]:CreateSoftShadow()
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

function mod:ChatBubbles(_, holder)
	if E.private.general.chatBubbles == 'backdrop' then
		if holder then
			if not holder.shadow then
				holder:CreateSoftShadow()
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

local function MerchantFrameShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true then
		return
	end
	local i = 1
	local tab = _G['MerchantFrameTab'..i]
	while tab do
		if not tab then return end

		if tab.backdrop then
			tab.backdrop:SetTemplate("Transparent")
			tab.backdrop:CreateSoftShadow()
		end

		i = i + 1
		tab = _G['MerchantFrameTab'..i]
	end
end

local function MailFrameShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mail ~= true then
		return
	end
	local i = 1
	local tab = _G['MailFrameTab'..i]
	while tab do
		if not tab then return end

		if tab.backdrop then
			tab.backdrop:SetTemplate("Transparent")
			tab.backdrop:CreateSoftShadow()
		end

		i = i + 1
		tab = _G['MailFrameTab'..i]
	end
end

local ignoreWidget = {
	[283] = 3463 -- Cosmic Energy
}

function B:UIWidgetTemplateStatusBarShadows()
	local forbidden = self:IsForbidden()
	local bar = self.Bar

	if forbidden and bar then
		if bar.tooltip then bar.tooltip = nil end -- EmbeddedItemTooltip is tainted just block the tooltip
		return
	elseif forbidden or (self.widgetID == ignoreWidget[self.widgetSetID]) or not bar then
		return -- we don't want to handle these widgets
	end

	if bar and bar.backdrop then
		bar.backdrop:CreateSoftShadow()
	end
end

function mod:Initialize()
	if not E.db.benikui.general.shadows then return end

	AltPowerBarShadows()
	raidUtilityShadows()

	miscShadows()
	MicroBarShadows()
	CharacterFrameShadows()
	SpellBookFrameShadows()
	PVEFrameShadows()
	FriendsFrameShadows()
	MerchantFrameShadows()
	MailFrameShadows()
	mod:RegisterEvent('START_TIMER')

	-- Widgets
	for _, widget in pairs(_G.UIWidgetPowerBarContainerFrame.widgetFrames) do
		B.UIWidgetTemplateStatusBarShadows(widget)
	end
	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, 'Setup', B.UIWidgetTemplateStatusBarShadows)
	hooksecurefunc(_G.UIWidgetTemplateStatusBarMixin, 'Setup', B.UIWidgetTemplateStatusBarShadows)

	-- Callbacks
	S:AddCallbackForAddon("Blizzard_Calendar", "BenikUI_CalendarEventButtonShadows", CalendarEventButtonShadows)
	hooksecurefunc(M, "SkinBubble", mod.ChatBubbles)
end

BUI:RegisterModule(mod:GetName())