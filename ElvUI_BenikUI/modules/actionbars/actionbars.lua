local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('Actionbars', 'AceEvent-3.0');
local AB = E:GetModule('ActionBars');

if E.private.actionbar.enable ~= true then return; end

local _G = _G
local pairs = pairs
local C_TimerAfter = C_Timer.After
local MAX_TOTEMS = MAX_TOTEMS

-- GLOBALS: NUM_PET_ACTION_SLOTS, DisableAddOn
-- GLOBALS: ElvUI_BarPet, ElvUI_StanceBar

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar}

function mod:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, 10 do
		local styleBacks = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(styleBacks) do
			if frame.backdrop then
				frame.backdrop:Style('Outside', nil, true, true)
			end
		end
	end

	-- Other bar backdrops
	for _, frame in pairs(styleOtherBacks) do
		if frame.backdrop then
			frame.backdrop:Style('Outside', nil, true, true)
		end
	end
end

function mod:ToggleStyle()
	-- Actionbar backdrops
	for i = 1, 10 do
		if _G['ElvUI_Bar'..i].backdrop.style then
			if E.db.benikui.actionbars.style['bar'..i] then
				_G['ElvUI_Bar'..i].backdrop.style:Show()
			else
				_G['ElvUI_Bar'..i].backdrop.style:Hide()
			end
		end
	end

	-- Other bar backdrops
	if _G['ElvUI_BarPet'].backdrop.style then
		if E.db.benikui.actionbars.style.petbar then
			_G['ElvUI_BarPet'].backdrop.style:Show()
		else
			_G['ElvUI_BarPet'].backdrop.style:Hide()
		end
	end

	if _G['ElvUI_StanceBar'].backdrop.style then
		if E.db.benikui.actionbars.style.stancebar then
			_G['ElvUI_StanceBar'].backdrop.style:Show()
		else
			_G['ElvUI_StanceBar'].backdrop.style:Hide()
		end
	end
end

local r, g, b = 0, 0, 0

function mod:ColorBackdrops()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	local db = E.db.benikui.colors

	for i = 1, 10 do
		local styleBacks = {_G['ElvUI_Bar'..i].backdrop.style}

		for _, frame in pairs(styleBacks) do
			if db.abStyleColor == 1 then
				r, g, b = classColor.r, classColor.g, classColor.b
			elseif db.abStyleColor == 2 then
				r, g, b = BUI:unpackColor(db.customAbStyleColor)
			elseif db.abStyleColor == 3 then
				r, g, b = BUI:unpackColor(E.db.general.valuecolor)
			else
				r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
			end
			frame:SetBackdropColor(r, g, b, (db.abAlpha or 1))
		end
	end

	for _, frame in pairs(styleOtherBacks) do
		local name = _G[frame:GetName()].backdrop.style

		if db.abStyleColor == 1 then
			r, g, b = classColor.r, classColor.g, classColor.b
		elseif db.abStyleColor == 2 then
			r, g, b = BUI:unpackColor(db.customAbStyleColor)
		elseif db.abStyleColor == 3 then
			r, g, b = BUI:unpackColor(E.db.general.valuecolor)
		else
			r, g, b = BUI:unpackColor(E.db.general.backdropcolor)
		end
		if name then
			name:SetBackdropColor(r, g, b, (db.abAlpha or 1))
		end
	end
end

function mod:PetShadows()
	-- Pet Buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		local petButtons = {_G['PetActionButton'..i]}
		for _, button in pairs(petButtons) do
			if button.backdrop then
				if BUI.ShadowMode then
					if not button.backdrop.shadow then
						button.backdrop:CreateSoftShadow()
					end
				end
			end
		end
	end
end

function mod:TotemShadows()
	if not BUI.ShadowMode then return end

	for i=1, MAX_TOTEMS do
		local button = _G["ElvUI_TotemBarTotem"..i];
		if button then
			if not button.shadow then
				button:CreateSoftShadow()
			end
		end
	end
end

function mod:FlyoutShadows()
	if not BUI.ShadowMode then return end
	for i=1, AB.FlyoutButtons do
		if _G["SpellFlyoutButton"..i] then
			if not _G["SpellFlyoutButton"..i].shadow then
				_G["SpellFlyoutButton"..i]:CreateSoftShadow()
			end
		end
	end
end

function mod:Initialize()
	C_TimerAfter(1, mod.StyleBackdrops)
	C_TimerAfter(1, mod.PetShadows)
	C_TimerAfter(2, mod.ColorBackdrops)
	C_TimerAfter(2, mod.LoadToggleButtons)
	C_TimerAfter(2, mod.ToggleStyle)
	C_TimerAfter(2, mod.TotemShadows)
	self:LoadRequestButton()
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "ColorBackdrops");
	hooksecurefunc(BUI, "SetupColorThemes", mod.ColorBackdrops)

	if not BUI.ShadowMode then return end
	_G.SpellFlyout:HookScript("OnShow", mod.FlyoutShadows)
end

BUI:RegisterModule(mod:GetName())