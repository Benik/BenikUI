local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');

local _G = _G
local getn = getn
local tinsert, twipe, tsort = table.insert, table.wipe, table.sort

local GameTooltip = _G.GameTooltip
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local C_CurrencyInfo_GetCurrencyListSize = C_CurrencyInfo.GetCurrencyListSize
local C_CurrencyInfo_GetCurrencyListInfo = C_CurrencyInfo.GetCurrencyListInfo
local C_CurrencyInfo_GetCurrencyListLink = C_CurrencyInfo.GetCurrencyListLink
local C_CurrencyInfo_GetCurrencyIDFromLink = C_CurrencyInfo.GetCurrencyIDFromLink
local C_CurrencyInfo_ExpandCurrencyList = C_CurrencyInfo.ExpandCurrencyList
local GetExpansionLevel = GetExpansionLevel
local IsShiftKeyDown = IsShiftKeyDown
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local BreakUpLargeNumbers = BreakUpLargeNumbers
local LFG_TYPE_DUNGEON = LFG_TYPE_DUNGEON

-- GLOBALS: hooksecurefunc

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)
local expansion = _G['EXPANSION_NAME'..GetExpansionLevel()]

BUI.CurrencyList = {}

local function Icon_OnEnter(self)
	local id = self:GetParent().id
	if E.db.benikui.dashboards.tokens.tooltip then
		GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 3, 0);
		GameTooltip:SetCurrencyByID(id)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(L['Shift+RightClick to remove'], format('|cffff0000%s |r%s','ID', id), 0.7, 0.7, 1)
		GameTooltip:Show()
	end

	if E.db.benikui.dashboards.tokens.mouseover then
		E:UIFrameFadeIn(BUI_TokensDashboard, 0.2, BUI_TokensDashboard:GetAlpha(), 1)
	end
end

local function Icon_OnLeave(self)
	if E.db.benikui.dashboards.tokens.mouseover then
		E:UIFrameFadeIn(BUI_TokensDashboard, 0.2, BUI_TokensDashboard:GetAlpha(), 0)
	end
	GameTooltip:Hide()
end

local function Icon_OnMouseUp(self, btn)
	if InCombatLockdown() then return end
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local id = self:GetParent().id
			E.private.benikui.dashboards.tokens.chooseTokens[id] = false
			mod:UpdateTokens()
		else
			E:ToggleOptions()
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
	local db = E.db.benikui.dashboards.tokens
	local holder = _G.BUI_TokensDashboard
	local inInstance = IsInInstance()
	local NotinInstance = not (db.instance and inInstance)

	if(BUI.TokensDB[1]) then
		for i = 1, getn(BUI.TokensDB) do
			BUI.TokensDB[i]:Kill()
		end
		twipe(BUI.TokensDB)
		holder:Hide()
	end

	if db.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end

	for _, info in ipairs(BUI.CurrencyList) do
		local _, id = unpack(info)

		if id then
			local name, amount, icon, weeklyMax, totalMax, isDiscovered = mod:GetTokenInfo(id)
			if name then
				if isDiscovered == false then E.private.benikui.dashboards.tokens.chooseTokens[id] = nil end

				if E.private.benikui.dashboards.tokens.chooseTokens[id] == true then
					if db.zeroamount or amount > 0 then
						holder:SetShown(NotinInstance)

						if db.orientation == 'BOTTOM' then
							holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.TokensDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
							holder:Width(db.width)
						else
							holder:Height(DASH_HEIGHT + (DASH_SPACING))
							holder:Width(db.width * (#BUI.TokensDB + 1) + DASH_SPACING*2)
						end

						local bar = self:CreateDashboard(holder, 'tokens', true)

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

						if E.db.benikui.dashboards.barColor == 1 then
							bar.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
						else
							bar.Status:SetStatusBarColor(E.db.benikui.dashboards.customBarColor.r, E.db.benikui.dashboards.customBarColor.g, E.db.benikui.dashboards.customBarColor.b)
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

						if E.db.benikui.dashboards.textColor == 1 then
							bar.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
						else
							bar.Text:SetTextColor(BUI:unpackColor(E.db.benikui.dashboards.customTextColor))
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
					end
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
			if db.orientation == 'BOTTOM' then
				frame:Point('TOP', BUI.TokensDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
			else
				frame:Point('LEFT', BUI.TokensDB[key - 1], 'RIGHT', SPACING +(E.PixelMode and 0 or 2), 0)
			end
		end
	end
end

function mod:UpdateTokenSettings()
	mod:FontStyle(BUI.TokensDB)
	mod:FontColor(BUI.TokensDB)
	mod:BarColor(BUI.TokensDB)
	mod:IconPosition(BUI.TokensDB, 'tokens')
end

function mod:PopulateCurrencyData()
	local Collapsed = {}
	local listSize, i = C_CurrencyInfo_GetCurrencyListSize(), 1

	local headerIndex
	while listSize >= i do
		local info = C_CurrencyInfo_GetCurrencyListInfo(i)
		if info.isHeader and not info.isHeaderExpanded then
			C_CurrencyInfo_ExpandCurrencyList(i, true)
			listSize = C_CurrencyInfo_GetCurrencyListSize()
			Collapsed[info.name] = true
		end

		if info.isHeader then
			BUI.CurrencyList[i] = { info.name, nil, nil, (info.name == expansion or info.name == MISCELLANEOUS) or strfind(info.name, LFG_TYPE_DUNGEON) }
			headerIndex = i
		end

		if not info.isHeader then
			local currencyLink = C_CurrencyInfo_GetCurrencyListLink(i)
			local currencyID = currencyLink and C_CurrencyInfo_GetCurrencyIDFromLink(currencyLink)
			if currencyID then
				BUI.CurrencyList[tostring(currencyID)] = info.name
				BUI.CurrencyList[i] = { info.name, currencyID, headerIndex}
			end
		end
		i = i + 1
	end

	for k = 1, listSize do
		local info = C_CurrencyInfo_GetCurrencyListInfo(k)
		if not info then
			break
		elseif info.isHeader and info.isHeaderExpanded and Collapsed[info.name] then
			C_CurrencyInfo_ExpandCurrencyList(k, false)
		end
	end

	wipe(Collapsed)
end

function mod:CURRENCY_DISPLAY_UPDATE(_, currencyID)
	if currencyID and not BUI.CurrencyList[tostring(currencyID)] then
		local info = C_CurrencyInfo_GetCurrencyInfo(currencyID)
		if info then
			mod:PopulateCurrencyData()
		end
	end
	mod:UpdateTokens()
end

function mod:TokenEvents()
	self:RegisterEvent('CURRENCY_DISPLAY_UPDATE')
end

function mod:CreateTokensDashboard()
	local db = E.db.benikui.dashboards.tokens
	local holder = mod:CreateDashboardHolder('BUI_TokensDashboard', 'tokens')
	holder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -123)
	holder:Width(db.width or 150)

	mod:PopulateCurrencyData()
	mod:UpdateTokens()
	mod:UpdateTokenSettings()
	mod:ToggleStyle(holder, 'tokens')
	mod:ToggleTransparency(holder, 'tokens')

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

	E:CreateMover(_G.BUI_TokensDashboard, 'tokenHolderMover', L['Tokens'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,tokens')
end

function mod:LoadTokens()
	if E.db.benikui.dashboards.tokens.enable ~= true then return end

	mod:CreateTokensDashboard()
	mod:TokenEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateTokenSettings)
	hooksecurefunc('TokenFrame_Update', mod.PopulateCurrencyData)
end
