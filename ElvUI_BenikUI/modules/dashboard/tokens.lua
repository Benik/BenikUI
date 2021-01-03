local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');

local _G = _G
local getn = getn
local tinsert, twipe, tsort = table.insert, table.wipe, table.sort

local GameTooltip = _G.GameTooltip
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local BreakUpLargeNumbers = BreakUpLargeNumbers

-- GLOBALS: hooksecurefunc

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

local function Icon_OnEnter(self)
	local id = self:GetParent().id
	if E.db.dashboards.tokens.tooltip then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 3, 0);
		GameTooltip:SetCurrencyByID(id)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(L['Shift+RightClick to remove'], format('|cffff0000%s |r%s','ID', id), 0.7, 0.7, 1)
		GameTooltip:Show()
	end

	if E.db.dashboards.tokens.mouseover then
		E:UIFrameFadeIn(BUI_TokensDashboard, 0.2, BUI_TokensDashboard:GetAlpha(), 1)
	end
end

local function Icon_OnLeave(self)
	if E.db.dashboards.tokens.mouseover then
		E:UIFrameFadeIn(BUI_TokensDashboard, 0.2, BUI_TokensDashboard:GetAlpha(), 0)
	end
	GameTooltip:Hide()
end

local function Icon_OnMouseUp(self, btn)
	if InCombatLockdown() then return end
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local id = self:GetParent().id
			E.private.dashboards.tokens.chooseTokens[id] = false
			mod:UpdateTokens()
		else
			E:ToggleOptionsUI()
			local ACD = E.Libs.AceConfigDialog
			if ACD then ACD:SelectGroup("ElvUI", "benikui") end
		end
	end
end

local function sortFunction(a, b)
	return a.name < b.name
end

function mod:GetTokenInfo(id)
	local info = C_CurrencyInfo_GetCurrencyInfo(id)
	if info then
		return info.name, info.quantity, info.iconFileID, info.maxWeeklyQuantity, info.maxQuantity, info.discovered
	else
		return
	end
end

function mod:UpdateTokens()
	local db = E.db.dashboards.tokens
	local holder = _G.BUI_TokensDashboard

	if(BUI.TokensDB[1]) then
		for i = 1, getn(BUI.TokensDB) do
			BUI.TokensDB[i]:Kill()
		end
		twipe(BUI.TokensDB)
		holder:Hide()
	end

	if db.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end

	holder:SetScript('OnEnter', function(self)
		if db.mouseover then
			E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
		end
	end)

	holder:SetScript('OnLeave', function(self)
		if db.mouseover then
			E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
		end
	end)

	for _, id in pairs(BUI.Currency) do
		local name, amount, icon, weeklyMax, totalMax, isDiscovered = mod:GetTokenInfo(id)
		if name then
			if isDiscovered == false then E.private.dashboards.tokens.chooseTokens[id] = nil end

			if E.private.dashboards.tokens.chooseTokens[id] == true then
				if db.zeroamount or amount > 0 then
					holder:Show()
					holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.TokensDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					if tokenHolderMover then
						tokenHolderMover:Size(holder:GetSize())
						holder:Point('TOPLEFT', tokenHolderMover, 'TOPLEFT')
					end

					local bar = self:CreateDashboard(holder, 'tokens', true)

					-- cheat for Renown
					if id == 1822 then
						amount = amount + 1
						totalMax = totalMax + 1
					end

					if totalMax == 0 then
						bar.Status:SetMinMaxValues(0, amount)
					else
						if db.weekly and weeklyMax > 0 then
							bar.Status:SetMinMaxValues(0, weeklyMax)
						else
							bar.Status:SetMinMaxValues(0, totalMax)
						end
					end
					bar.Status:SetValue(amount)

					if E.db.dashboards.barColor == 1 then
						bar.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
					else
						bar.Status:SetStatusBarColor(E.db.dashboards.customBarColor.r, E.db.dashboards.customBarColor.g, E.db.dashboards.customBarColor.b)
					end

					if totalMax == 0 then
						bar.Text:SetFormattedText('%s', BreakUpLargeNumbers(amount))
					else
						if db.weekly and weeklyMax > 0 then
							bar.Text:SetFormattedText('%s / %s', BreakUpLargeNumbers(amount), weeklyMax)
						else
							bar.Text:SetFormattedText('%s / %s', BreakUpLargeNumbers(amount), totalMax)
						end
					end

					if E.db.dashboards.textColor == 1 then
						bar.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						bar.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
					end

					bar.IconBG:SetScript('OnMouseUp', Icon_OnMouseUp)
					bar.IconBG:SetScript('OnEnter', Icon_OnEnter)
					bar.IconBG:SetScript('OnLeave', Icon_OnLeave)

					bar.IconBG.Icon:SetTexture(icon)

					bar:SetScript('OnEnter', function(self)
						self.Text:SetFormattedText('%s', name)
						if db.mouseover then
							E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
						end
					end)

					bar:SetScript('OnLeave', function(self)
						if totalMax == 0 then
							self.Text:SetFormattedText('%s', BreakUpLargeNumbers(amount))
						else
							if db.weekly and weeklyMax > 0 then
								self.Text:SetFormattedText('%s / %s', BreakUpLargeNumbers(amount), weeklyMax)
							else
								self.Text:SetFormattedText('%s / %s', BreakUpLargeNumbers(amount), totalMax)
							end
						end
						GameTooltip:Hide()
						if db.mouseover then
							E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
						end
					end)

					bar.id = id
					bar.name = name

					tinsert(BUI.TokensDB, bar)
				else
					holder:Hide()
				end
			end
		end
	end

	tsort(BUI.TokensDB, sortFunction)

	for key, frame in pairs(BUI.TokensDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point('TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:Point('TOP', BUI.TokensDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end
end

function mod:UpdateTokenSettings()
	mod:FontStyle(BUI.TokensDB)
	mod:FontColor(BUI.TokensDB)
	mod:BarColor(BUI.TokensDB)
end

function mod:TokenEvents()
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE', 'UpdateTokens')
end

function mod:CreateTokensDashboard()
	local holder = self:CreateDashboardHolder('BUI_TokensDashboard', 'tokens')
	holder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -123)
	holder:Width(E.db.dashboards.tokens.width or 150)

	mod:UpdateTokens()
	mod:UpdateTokenSettings()
	mod:UpdateHolderDimensions(holder, 'tokens', BUI.TokensDB)
	mod:ToggleStyle(holder, 'tokens')
	mod:ToggleTransparency(holder, 'tokens')

	E:CreateMover(_G.BUI_TokensDashboard, 'tokenHolderMover', L['Tokens'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,tokens')
end

function mod:LoadTokens()
	if E.db.dashboards.tokens.enableTokens ~= true then return end

	mod:CreateTokensDashboard()
	mod:TokenEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateTokenSettings)
end