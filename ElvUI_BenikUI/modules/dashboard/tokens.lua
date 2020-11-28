local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');

local _G = _G
local getn = getn
local tinsert, twipe, tsort = table.insert, table.wipe, table.sort

local GameTooltip = _G.GameTooltip
local C_CurrencyInfo_GetCurrencyInfo = C_CurrencyInfo.GetCurrencyInfo
local IsShiftKeyDown = IsShiftKeyDown
local BreakUpLargeNumbers = BreakUpLargeNumbers

-- GLOBALS: hooksecurefunc

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

local Currency = {
	-- unused/old
	614,	-- Mote of Darkness
	615,	-- Essence of Corrupted Deathwing
	752,	-- Mogu Rune of Fate

	-- Archaeology
	384,	-- Dwarf Archaeology Fragment
	385,	-- Troll Archaeology Fragment
	393,	-- Fossil Archaeology Fragment
	394,	-- Night Elf Archaeology Fragment
	397,	-- Orc Archaeology Fragment
	398,	-- Draenei Archaeology Fragment
	399,	-- Vrykul Archaeology Fragment
	400,	-- Nerubian Archaeology Fragment
	401,	-- Tol'vir Archaeology Fragment
	676,	-- Pandaren Archaeology Fragment
	677,	-- Mogu Archaeology Fragment
	754,	-- Mantid Archaeology Fragment
	821,	-- Draenor Clans Archaeology Fragment
	828,	-- Ogre Archaeology Fragment
	829,	-- Arakkoa Archaeology Fragment
	1172,	-- Highborne Archaeology Fragment
	1173,	-- Highmountain Tauren Archaeology Fragment
	1174,	-- Demonic Archaeology Fragment
	1534,	-- Zandalari Archaeology Fragment
	1535,	-- Drust Archaeology Fragment

	-- dungeon
	1166, 	-- Timewarped Badge (6.22)

	-- pvp
	391,	-- Tol Barad Commendation
	1602,	-- Conquest
	1792,	-- Honor

	-- secondary
	81,		-- Epicurean's Award
	402,	-- Ironpaw Token
	61,		-- Dalaran Jewelcrafter's Token
	361,	-- Illustrious Jewelcrafter's Token

	-- misc
	241,	-- Champion's Seal
	416,	-- Mark of the World Tree
	515,	-- Darkmoon Prize Ticket
	789,	-- Bloody Coin

	-- MoP
	697,	-- Elder Charm of Good Fortune
	738,	-- Lesser Charm of Good Fortune
	776,	-- Warforged Seal
	777,	-- Timeless Coin

	-- WoD
	824,	-- Garrison Resources
	823,	-- Apexis Crystal (for gear, like the valors)
	994,	-- Seal of Tempered Fate (Raid loot roll)
	980,	-- Dingy Iron Coins (rogue only, from pickpocketing)
	944,	-- Artifact Fragment (PvP)
	1101,	-- Oil
	1129,	-- Seal of Inevitable Fate
	1191, 	-- Valor Points (6.23)

	-- Legion
	1155,	-- Ancient Mana
	1220,	-- Order Resources
	1275,	-- Curious Coin (Buy stuff :P)
	1226,	-- Nethershard (Invasion scenarios)
	1273,	-- Seal of Broken Fate (Raid)
	1154,	-- Shadowy Coins
	1149,	-- Sightless Eye (PvP)
	1268,	-- Timeworn Artifact (Honor Points?)
	1299,	-- Brawler's Gold
	1314,	-- Lingering Soul Fragment (Good luck with this one :D)
	1342,	-- Legionfall War Supplies (Construction at the Broken Shore)
	1355,	-- Felessence (Craft Legentary items)
	1356,	-- Echoes of Battle (PvP Gear)
	1357,	-- Echoes of Domination (Elite PvP Gear)
	1416,	-- Coins of Air
	1508,	-- Veiled Argunite
	1533,	-- Wakening Essence
	
	-- BfA
	1560, 	-- War Resources
	1580,	-- Seal of Wartorn Fate
	1587,	-- War Supplies
	1710,	-- Seafarer's Dubloon
	1716,	-- Honorbound Service Medal (Horde)
	1717,	-- 7th Legion Service Medal (Alliance)
	1718,	-- Titan Residuum
	1719,	-- Corrupted Memento
	1721,	-- Prismatic Manapearl
	1755,	-- Coalescing Visions
	1803,	-- Echoes of Ny'alotha

	-- Shadowlands
	1751,	-- Freed Soul
	1754,	-- Argent Commendation
	1810,	-- Willing Soul
	1813,	-- Reservoir Anima
	1820,	-- Infused Ruby
	1822,	-- Renown
	1828, 	-- Soul Ash
}

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
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local id = self:GetParent().id
			E.private.dashboards.tokens.chooseTokens[id] = false
			mod:UpdateTokens()
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

	for _, id in pairs(Currency) do
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

					self.tokenFrame = self:CreateDashboard(holder, 'tokens', true)

					if totalMax == 0 then
						self.tokenFrame.Status:SetMinMaxValues(0, amount)
					else
						if db.weekly and weeklyMax > 0 then
							self.tokenFrame.Status:SetMinMaxValues(0, weeklyMax)
						else
							self.tokenFrame.Status:SetMinMaxValues(0, totalMax)
						end
					end
					self.tokenFrame.Status:SetValue(amount)

					if E.db.dashboards.barColor == 1 then
						self.tokenFrame.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
					else
						self.tokenFrame.Status:SetStatusBarColor(E.db.dashboards.customBarColor.r, E.db.dashboards.customBarColor.g, E.db.dashboards.customBarColor.b)
					end

					if totalMax == 0 then
						self.tokenFrame.Text:SetFormattedText('%s', BreakUpLargeNumbers(amount))
					else
						if db.weekly and weeklyMax > 0 then
							self.tokenFrame.Text:SetFormattedText('%s / %s', BreakUpLargeNumbers(amount), weeklyMax)
						else
							self.tokenFrame.Text:SetFormattedText('%s / %s', BreakUpLargeNumbers(amount), totalMax)
						end
					end

					if E.db.dashboards.textColor == 1 then
						self.tokenFrame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						self.tokenFrame.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
					end

					self.tokenFrame.IconBG:SetScript('OnMouseUp', Icon_OnMouseUp)
					self.tokenFrame.IconBG:SetScript('OnEnter', Icon_OnEnter)
					self.tokenFrame.IconBG:SetScript('OnLeave', Icon_OnLeave)

					self.tokenFrame.IconBG.Icon:SetTexture(icon)

					self.tokenFrame:SetScript('OnEnter', function(self)
						self.Text:SetFormattedText('%s', name)
						if db.mouseover then
							E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
						end
					end)

					self.tokenFrame:SetScript('OnLeave', function(self)
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

					self.tokenFrame.id = id
					self.tokenFrame.name = name

					tinsert(BUI.TokensDB, self.tokenFrame)
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
	self.tokenHolder = self:CreateDashboardHolder('BUI_TokensDashboard', 'tokens')
	self.tokenHolder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -123)
	self.tokenHolder:Width(E.db.dashboards.tokens.width or 150)

	mod:UpdateTokens()
	mod:UpdateTokenSettings()
	mod:UpdateHolderDimensions(self.tokenHolder, 'tokens', BUI.TokensDB)
	mod:ToggleStyle(self.tokenHolder, 'tokens')
	mod:ToggleTransparency(self.tokenHolder, 'tokens')

	E:CreateMover(_G.BUI_TokensDashboard, 'tokenHolderMover', L['Tokens'], nil, nil, nil, 'ALL,BENIKUI')
end

function mod:LoadTokens()
	if E.db.dashboards.tokens.enableTokens ~= true then return end

	mod:CreateTokensDashboard()
	mod:TokenEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateTokenSettings)
end