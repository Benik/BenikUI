local E, L, V, P, G, _ = unpack(ElvUI);
local BAB = E:NewModule('BuiActionbars', 'AceEvent-3.0');
local BUI = E:GetModule('BenikUI');

if E.private.actionbar.enable ~= true then return; end

local _G = _G
local pairs = pairs
local IsAddOnLoaded = IsAddOnLoaded
local C_TimerAfter = C_Timer.After
local MAX_TOTEMS = MAX_TOTEMS

-- GLOBALS: NUM_PET_ACTION_SLOTS, DisableAddOn
-- GLOBALS: ElvUI_BarPet, ElvUI_StanceBar

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])
local availableActionbars = availableActionbars or 6

local styleOtherBacks = {ElvUI_BarPet, ElvUI_StanceBar}

local function CheckExtraAB()
	if IsAddOnLoaded('ElvUI_ExtraActionBars') then
		availableActionbars = 10
	else
		availableActionbars = 6
	end
end

function BAB:StyleBackdrops()
	-- Actionbar backdrops
	for i = 1, availableActionbars do
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

function BAB:ToggleStyle()
	-- Actionbar backdrops
	for i = 1, availableActionbars do
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

function BAB:ColorBackdrops()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	local db = E.db.benikui.colors

	for i = 1, availableActionbars do
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

-- from ElvUI_TrasparentBackdrops plugin
function BAB:TransparentBackdrops()
	-- Actionbar backdrops
	local db = E.db.benikui.actionbars
	for i = 1, availableActionbars do
		local transBars = {_G['ElvUI_Bar'..i]}
		for _, frame in pairs(transBars) do
			if frame.backdrop then
				if db.transparent then
					frame.backdrop:SetTemplate('Transparent')
				else
					frame.backdrop:SetTemplate('Default')
				end
			end
		end

		-- Buttons
		for k = 1, 12 do
			local buttonBars = {_G['ElvUI_Bar'..i..'Button'..k]}
			for _, button in pairs(buttonBars) do
				if button.backdrop then
					if BUI.ShadowMode then
						if not button.backdrop.shadow then
							button.backdrop:CreateSoftShadow()
						end
					end

					if db.transparent then
						button.backdrop:SetTemplate('Transparent')
					else
						button.backdrop:SetTemplate('Default', true)
					end
				end
			end
		end
	end

	-- Other bar backdrops
	for _, frame in pairs(styleOtherBacks) do
		if frame.backdrop then
			if db.transparent then
				frame.backdrop:SetTemplate('Transparent')
			else
				frame.backdrop:SetTemplate('Default')
			end
		end
	end

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

				if db.transparent then
					button.backdrop:SetTemplate('Transparent')
				else
					button.backdrop:SetTemplate('Default', true)
				end
			end
		end
	end
end

function BAB:TotemShadows()
	if not BUI.ShadowMode then return end
	local button

	for i=1, MAX_TOTEMS do
		button = _G["ElvUI_TotemBarTotem"..i];
		if not button.shadow then
			button:CreateSoftShadow()
		end
	end
end

function BAB:Initialize()
	CheckExtraAB()
	C_TimerAfter(1, BAB.StyleBackdrops)
	C_TimerAfter(1, BAB.TransparentBackdrops)
	C_TimerAfter(2, BAB.ColorBackdrops)
	C_TimerAfter(2, BAB.LoadToggleButtons)
	C_TimerAfter(2, BAB.ToggleStyle)
	C_TimerAfter(2, BAB.TotemShadows)
	self:LoadRequestButton()
	self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED", "ColorBackdrops");
	if IsAddOnLoaded('ElvUI_TB') then DisableAddOn('ElvUI_TB') end
end

local function InitializeCallback()
	BAB:Initialize()
end

E:RegisterModule(BAB:GetName(), InitializeCallback)