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
local tokensDB = mod.TokensDB

local position, Xoffset

local classColor = E:ClassColor(E.myclass, true)
local expansion = _G['EXPANSION_NAME'..GetExpansionLevel()]

mod.CurrencyList = {}

local function OnMouseUp(self, btn)
	if InCombatLockdown() then return end
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local id = self.id
			E.private.benikui.dashboards.tokens.chooseTokens[id] = false
			mod:UpdateTokens()
		else
			E:ToggleOptions()
			local ACD = E.Libs.AceConfigDialog
			if ACD then ACD:SelectGroup("ElvUI", "benikui", "dashboards", "tokens") end
		end
	end
end

local function OnEnter(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_TokensDashboard
	local id = self.id

	if db.tokens.tooltip then
		GameTooltip:SetOwner(self, position, Xoffset, 0);
		GameTooltip:SetCurrencyByID(id)
		GameTooltip:AddLine(' ')
		GameTooltip:AddDoubleLine(L['Shift+RightClick to remove'], format('|cffff0000%s |r%s','ID', id), 0.7, 0.7, 1)
		GameTooltip:Show()
	end

	self.Text:SetFormattedText('%s', self.name)
	if db.tokens.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function OnLeave(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_TokensDashboard
	local BreakAmount = BreakUpLargeNumbers(self.amount)

	if self.totalMax == 0 then
		self.Text:SetFormattedText('%s', BreakAmount)
	else
		if db.tokens.weekly and self.weeklyMax > 0 then
			self.Text:SetFormattedText('%s / %s', BreakAmount, self.weeklyMax)
		else
			self.Text:SetFormattedText('%s / %s', BreakAmount, self.totalMax)
		end
	end

	GameTooltip:Hide()

	if db.tokens.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
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
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_TokensDashboard

	if not db.tokens.enable then holder:Hide() return end

	local inInstance = IsInInstance()
	local NotinInstance = not (db.tokens.instance and inInstance)

	if(tokensDB[1]) then
		for i = 1, getn(tokensDB) do
			tokensDB[i]:Kill()
		end
		twipe(tokensDB)
		holder:Hide()
	end

	if db.tokens.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end

	for _, info in ipairs(mod.CurrencyList) do
		local _, id = unpack(info)

		if id then
			local name, amount, icon, weeklyMax, totalMax, isDiscovered = mod:GetTokenInfo(id)
			if name then
				if isDiscovered == false then E.private.benikui.dashboards.tokens.chooseTokens[id] = nil end

				if E.private.benikui.dashboards.tokens.chooseTokens[id] == true then
					if db.tokens.zeroamount or amount > 0 then
						holder:SetShown(NotinInstance)

						if db.tokens.orientation == 'BOTTOM' then
							holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#tokensDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
							holder:Width(db.tokens.width)
						else
							holder:Height(DASH_HEIGHT + (DASH_SPACING))
							holder:Width(db.tokens.width * (#tokensDB + 1) + ((#tokensDB) *db.tokens.spacing))
						end

						local bar = mod:CreateDashboard(holder, 'tokens', true)
						local BarColor = (db.barColor == 1 and classColor) or db.customBarColor
						local TextColor = (db.textColor == 1 and classColor) or db.customTextColor
						local BarMaxValue = (totalMax == 0 and amount) or ((db.tokens.weekly and weeklyMax > 0 and weeklyMax) or totalMax)
						local TextMaxValue = 0
						local BreakAmount = BreakUpLargeNumbers(amount)
						local displayString = ''

						if totalMax == 0 then
							displayString = format('%s', BreakAmount)
						else
							if db.tokens.weekly and weeklyMax > 0 then
								TextMaxValue = weeklyMax
							else
								TextMaxValue = totalMax
							end
							displayString = format('%s / %s', BreakAmount, TextMaxValue)
						end

						bar.Status:SetMinMaxValues(0, BarMaxValue)
						bar.Status:SetValue(amount)
						bar.Status:SetStatusBarColor(BarColor.r, BarColor.g, BarColor.b)

						bar.Text:SetText(displayString)
						bar.Text:SetTextColor(TextColor.r, TextColor.g, TextColor.b)
						bar.IconBG.Icon:SetTexture(icon)

						bar:SetScript('OnEnter', OnEnter)
						bar:SetScript('OnLeave', OnLeave)
						bar:SetScript('OnMouseUp', OnMouseUp)

						bar.id = id
						bar.name = name
						bar.totalMax = totalMax
						bar.amount = amount
						bar.weeklyMax = weeklyMax

						tinsert(tokensDB, bar)
					end
				end
			end
		end
	end

	tsort(tokensDB, sortFunction)

	for key, frame in pairs(tokensDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point('TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			if db.tokens.orientation == 'BOTTOM' then
				frame:Point('TOP', tokensDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
			else
				frame:Point('LEFT', tokensDB[key - 1], 'RIGHT', db.tokens.spacing +(E.PixelMode and 0 or 2), 0)
			end
		end
	end

	mod:FontStyle(tokensDB)
	mod:FontColor(tokensDB)
	mod:BarColor(tokensDB)
	mod:IconPosition(tokensDB, 'tokens')
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
			mod.CurrencyList[i] = { info.name, nil, nil, (info.name == expansion or info.name == MISCELLANEOUS) or strfind(info.name, LFG_TYPE_DUNGEON) }
			headerIndex = i
		end

		if not info.isHeader then
			local currencyLink = C_CurrencyInfo_GetCurrencyListLink(i)
			local currencyID = currencyLink and C_CurrencyInfo_GetCurrencyIDFromLink(currencyLink)
			if currencyID then
				mod.CurrencyList[tostring(currencyID)] = info.name
				mod.CurrencyList[i] = { info.name, currencyID, headerIndex}
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
	if currencyID and not mod.CurrencyList[tostring(currencyID)] then
		local info = C_CurrencyInfo_GetCurrencyInfo(currencyID)
		if info then
			mod:PopulateCurrencyData()
		end
	end
	mod:UpdateTokens()
end

local function holderOnEnter(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_TokensDashboard

	if db.tokens.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function holderOnLeave(self)
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_TokensDashboard

	if db.tokens.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
end

local function CheckTokensPosition()
	if E.db.benikui.dashboards.tokens.enable ~= true then return end

	position, Xoffset = mod:CheckPositionForTooltip(_G.BUI_TokensDashboard)
end

function mod:ToggleTokens()
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_TokensDashboard

	if db.tokens.enable then
		E:EnableMover(holder.mover.name)
		mod:RegisterEvent('CURRENCY_DISPLAY_UPDATE')

		mod:PopulateCurrencyData()
		mod:ToggleStyle(holder, 'tokens')
		mod:ToggleTransparency(holder, 'tokens')
		
		holder:SetScript('OnEnter', holderOnEnter)
		holder:SetScript('OnLeave', holderOnLeave)
	else
		E:DisableMover(holder.mover.name)
		mod:UnregisterEvent('CURRENCY_DISPLAY_UPDATE')

		holder:SetScript('OnEnter', nil)
		holder:SetScript('OnLeave', nil)
	end

	mod:UpdateTokens()
	CheckTokensPosition()
end

function mod:CreateTokensDashboard()
	local db = E.db.benikui.dashboards
	local holder = mod:CreateDashboardHolder('BUI_TokensDashboard', 'tokens')
	holder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -123)
	holder:Width(db.tokens.width or 150)

	E:CreateMover(holder, 'tokenHolderMover', L['Tokens'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,tokens')
	mod:ToggleTokens()
end

function mod:LoadTokens()
	mod:CreateTokensDashboard()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateTokens)
	hooksecurefunc('TokenFrame_Update', mod.PopulateCurrencyData)
	hooksecurefunc(E, 'ToggleMoveMode', CheckTokensPosition)
end
