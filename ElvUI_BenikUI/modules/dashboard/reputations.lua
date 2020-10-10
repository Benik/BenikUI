local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars')

local _G = _G
local getn = getn
local tinsert, twipe, tsort, tostring = table.insert, table.wipe, table.sort, tostring

local GameTooltip = _G.GameTooltip
local GetNumFactions, GetFactionInfo = GetNumFactions, GetFactionInfo
local IsPlayerAtEffectiveMaxLevel = IsPlayerAtEffectiveMaxLevel
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local GetFriendshipReputation = GetFriendshipReputation
local IsShiftKeyDown = IsShiftKeyDown
local BreakUpLargeNumbers = BreakUpLargeNumbers

-- GLOBALS: hooksecurefunc

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

local function OnMouseUp(self, btn)
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local id = self.id
			E.private.dashboards.reputations.chooseReputations[id] = false
			mod:UpdateReputations()
		end
	end
end

local function sortFunction(a, b)
	return a.name < b.name
end

function mod:UpdateReputations()
	local db = E.db.dashboards.reputations
	local holder = _G.BUI_ReputationsDashboard

	if(BUI.FactionsDB[1]) then
		for i = 1, getn(BUI.FactionsDB) do
			BUI.FactionsDB[i]:Kill()
		end
		twipe(BUI.FactionsDB)
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

	local numFactions = GetNumFactions()
	local factionIndex = 1

	while (factionIndex <= numFactions) do
		local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader,
			isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)

		if isHeader and isCollapsed then
			ExpandFactionHeader(factionIndex)
			numFactions = GetNumFactions()
		end

		if hasRep or not isHeader then
			local id = tostring(factionID)
			if E.private.dashboards.reputations.chooseReputations[id] == true then
				holder:Show()
				holder:SetHeight(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.FactionsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
				if reputationHolderMover then
					reputationHolderMover:SetSize(holder:GetSize())
					holder:SetPoint('TOPLEFT', reputationHolderMover, 'TOPLEFT')
				end

				local isCapped, isFriend, friendText
				local friendshipID = GetFriendshipReputation(factionID)
				local standingLabel = _G['FACTION_STANDING_LABEL'..standingID]
				
				if friendshipID then
					local _, friendRep, _, _, _, _, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
					isFriend, reaction, friendText = true, 5, friendTextLevel
					if nextFriendThreshold then
						barMin, barMax, barValue = friendThreshold, nextFriendThreshold, friendRep;
					else
						barMin, barMax, barValue = 0, 1, 1
						isCapped = true
					end
				elseif C_Reputation_IsFactionParagon(factionID) then
					local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
					if currentValue and threshold then
						barMin, barMax = 0, threshold
						barValue = currentValue % threshold
						if hasRewardPending then
							barValue = barValue + threshold
						end
					end
				elseif reaction == _G.MAX_REPUTATION_REACTION then
					barMin, barMax, barValue = 0, 1, 1
					isCapped = true
				end

				--Normalize Values
				barMax = barMax - barMin
				barValue = barValue - barMin
				barMin = 0

				--Prevent a division by zero
				local maxMinDiff = barMax - barMin
				if maxMinDiff == 0 then
					maxMinDiff = 1
				end

				self.reputationFrame = self:CreateDashboard(holder, 'reputations')
				self.reputationFrame.Status:SetMinMaxValues(barMin, barMax)
				self.reputationFrame.Status:SetValue(barValue)

				if db.factionColors then
					local color = _G.FACTION_BAR_COLORS[standingID]
					self.reputationFrame.Status:SetStatusBarColor(color.r, color.g, color.b)
				else
					if E.db.dashboards.barColor == 1 then
						self.reputationFrame.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
					else
						self.reputationFrame.Status:SetStatusBarColor(E.db.dashboards.customBarColor.r, E.db.dashboards.customBarColor.g, E.db.dashboards.customBarColor.b)
					end
				end

				self.reputationFrame.Text:SetFormattedText('%s: %d%%', name, ((barValue - barMin) / (maxMinDiff) * 100))

				if E.db.dashboards.textColor == 1 then
					self.reputationFrame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
				else
					self.reputationFrame.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
				end

				self.reputationFrame:SetScript('OnEnter', function(self)
					self.Text:SetFormattedText('%s / %s (%s)', BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(barMax), standingLabel)
					if db.mouseover then
						E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
					end

					_G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 3, 0);
					_G.GameTooltip:AddLine(name)
					_G.GameTooltip:AddLine(' ')
					_G.GameTooltip:AddLine('Add something usefull')
					_G.GameTooltip:AddDoubleLine(L['Shift+RightClick to remove'], format('|cffff0000%s |r%s','ID', id), 0.7, 0.7, 1)
					_G.GameTooltip:Show()
				end)

				self.reputationFrame:SetScript('OnLeave', function(self)
					self.Text:SetFormattedText('%s: %d%%', name, ((barValue - barMin) / (maxMinDiff) * 100))
					_G.GameTooltip:Hide()
					if db.mouseover then
						E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
					end
				end)
				
				self.reputationFrame:SetScript('OnMouseUp', OnMouseUp)

				self.reputationFrame.id = id
				self.reputationFrame.name = name

				tinsert(BUI.FactionsDB, self.reputationFrame)
			end
		end
		factionIndex = factionIndex + 1
	end

	tsort(BUI.FactionsDB, sortFunction)

	for key, frame in pairs(BUI.FactionsDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:SetPoint('TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:SetPoint('TOP', BUI.FactionsDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end
end

function mod:UpdateReputationSettings()
	mod:FontStyle(BUI.FactionsDB)
	mod:FontColor(BUI.FactionsDB)
	if not E.db.dashboards.reputations.factionColors then
		mod:BarColor(BUI.FactionsDB)
	end
end

function mod:ReputationEvents()
	self:RegisterEvent('UPDATE_FACTION', 'UpdateReputations')
	self:RegisterEvent('QUEST_LOG_UPDATE', 'UpdateReputations')
end

function mod:CreateReputationsDashboard()
	self.reputationHolder = self:CreateDashboardHolder('BUI_ReputationsDashboard', 'reputations')
	self.reputationHolder:SetPoint('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -320)
	self.reputationHolder:SetWidth(E.db.dashboards.reputations.width or 150)

	mod:UpdateReputations()
	mod:UpdateReputationSettings()
	mod:UpdateHolderDimensions(self.reputationHolder, 'reputations', BUI.FactionsDB)
	mod:ToggleStyle(self.reputationHolder, 'reputations')
	mod:ToggleTransparency(self.reputationHolder, 'reputations')

	E:CreateMover(_G.BUI_ReputationsDashboard, 'reputationHolderMover', L['Reputations'], nil, nil, nil, 'ALL,BENIKUI')
end

function mod:LoadReputations()
	if E.db.dashboards.reputations.enableReputations ~= true then return end

	mod:CreateReputationsDashboard()
	mod:ReputationEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateReputationSettings)
end