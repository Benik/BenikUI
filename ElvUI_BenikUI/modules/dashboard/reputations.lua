local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');
local DB = E:GetModule('DataBars');
local LSM = E.LSM;

local _G = _G
local getn = getn
local tinsert, twipe, tsort, tostring = table.insert, table.wipe, table.sort, tostring

local GameTooltip = _G.GameTooltip
local GetFactionInfoByID = GetFactionInfoByID
local GetFactionInfo = GetFactionInfo
local IsPlayerAtEffectiveMaxLevel = IsPlayerAtEffectiveMaxLevel
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local GetFriendshipReputation = GetFriendshipReputation
local InCombatLockdown = InCombatLockdown
local IsShiftKeyDown = IsShiftKeyDown
local BreakUpLargeNumbers = BreakUpLargeNumbers

-- GLOBALS: hooksecurefunc
BUI.ReputationsList = {}

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

local function OnMouseUp(self, btn)
	if InCombatLockdown() then return end
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local factionID = self.factionID
			E.private.benikui.dashboards.reputations.chooseReputations[factionID] = false
			mod:UpdateReputations()
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

function mod:UpdateReputations()
	local db = E.db.benikui.dashboards.reputations
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

	for _, info in ipairs(BUI.ReputationsList) do
		local _, factionID = unpack(info)

		if factionID then
			local name, _, standingID, barMin, barMax, barValue = GetFactionInfoByID(factionID)

			if name then
				if E.private.benikui.dashboards.reputations.chooseReputations[factionID] == true then
					holder:Show()
					holder:SetHeight(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.FactionsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					if reputationHolderMover then
						reputationHolderMover:SetSize(holder:GetSize())
						holder:SetPoint('TOPLEFT', reputationHolderMover, 'TOPLEFT')
					end

					local isFriend, friendText, standingLabel
					local friendshipID = GetFriendshipReputation(factionID)
					local isParagon = C_Reputation_IsFactionParagon(factionID)
					
					if friendshipID then
						local _, friendRep, _, _, _, _, friendTextLevel, friendThreshold, nextFriendThreshold = GetFriendshipReputation(factionID)
						isFriend, standingID, friendText = true, 5, friendTextLevel
						if nextFriendThreshold then
							barMin, barMax, barValue = friendThreshold, nextFriendThreshold, friendRep;
						else
							barMin, barMax, barValue = 0, 1, 1
						end
					elseif isParagon then
						local currentValue, threshold, _, hasRewardPending = C_Reputation_GetFactionParagonInfo(factionID)
						if currentValue and threshold then
							barMin, barMax = 0, threshold
							barValue = currentValue % threshold
							if hasRewardPending then
								barValue = barValue + threshold
							end
						end
					elseif standingID == _G.MAX_REPUTATION_REACTION then
						barMin, barMax, barValue = 0, 1, 1
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

					local bar = self:CreateDashboard(holder, 'reputations')
					bar.Status:SetMinMaxValues(barMin, barMax)
					bar.Status:SetValue(barValue)

					standingLabel = _G['FACTION_STANDING_LABEL'..standingID]
					local color = _G.FACTION_BAR_COLORS[standingID]
					local hexColor = E:RGBToHex(color.r, color.g, color.b)

					if E.db.benikui.dashboards.dashfont.useDTfont then
						bar.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
					else
						bar.Text:FontTemplate(LSM:Fetch('font', E.db.benikui.dashboards.dashfont.dbfont), E.db.benikui.dashboards.dashfont.dbfontsize, E.db.benikui.dashboards.dashfont.dbfontflags)
					end

					if not db.barFactionColors then
						if E.db.benikui.dashboards.barColor == 1 then
							bar.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
						else
							bar.Status:SetStatusBarColor(E.db.benikui.dashboards.customBarColor.r, E.db.benikui.dashboards.customBarColor.g, E.db.benikui.dashboards.customBarColor.b)
						end
					else
						bar.Status:SetStatusBarColor(color.r, color.g, color.b)
					end

					if db.textFactionColors then
						bar.Text:SetFormattedText('%s: %s%d%%|r', name, hexColor, ((barValue - barMin) / (maxMinDiff) * 100))
					else
						bar.Text:SetFormattedText('%s: %d%%|r', name, ((barValue - barMin) / (maxMinDiff) * 100))
					end

					if E.db.benikui.dashboards.textColor == 1 then
						bar.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						bar.Text:SetTextColor(BUI:unpackColor(E.db.benikui.dashboards.customTextColor))
					end

					bar.Text:Point(db.textAlign, bar, db.textAlign, ((db.textAlign == 'LEFT' and 4) or (db.textAlign == 'CENTER' and 0) or (db.textAlign == 'RIGHT' and -2)), (E.PixelMode and 1 or 3))
					bar.Text:SetJustifyH(db.textAlign)

					bar:SetScript('OnEnter', function(self)
						if isParagon then
							standingLabel = L["Paragon"]
						end

						self.Text:SetFormattedText('%s / %s %s(%s)|r', BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(barMax), hexColor, isFriend and friendText or standingLabel)

						if db.mouseover then
							E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
						end

						if db.tooltip then
							_G.GameTooltip:SetOwner(self, 'ANCHOR_RIGHT', 3, 0);
							_G.GameTooltip:AddLine(name)
							_G.GameTooltip:AddLine(' ')
							_G.GameTooltip:AddDoubleLine(STANDING..':', format('%s%s|r', hexColor, isFriend and friendText or standingLabel), 1, 1, 1)

							if standingID ~= _G.MAX_REPUTATION_REACTION or isParagon then
								_G.GameTooltip:AddDoubleLine(REPUTATION..':', format('%d / %d (%d%%)', barValue - barMin, barMax - barMin, (barValue - barMin) / ((barMax - barMin == 0) and barMax or (barMax - barMin)) * 100), 1, 1, 1)
							end

							_G.GameTooltip:AddLine(' ')
							_G.GameTooltip:AddDoubleLine(L['Shift+RightClick to remove'], format('|cffff0000%s |r%s','ID', factionID), 0.7, 0.7, 1)
							_G.GameTooltip:Show()
						end
					end)

					bar:SetScript('OnLeave', function(self)
						if db.textFactionColors then
							self.Text:SetFormattedText('%s: %s%d%%|r', name, hexColor, ((barValue - barMin) / (maxMinDiff) * 100))
						else
							self.Text:SetFormattedText('%s: %d%%|r', name, ((barValue - barMin) / (maxMinDiff) * 100))
						end
						if db.tooltip then _G.GameTooltip:Hide() end

						if db.mouseover then
							E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
						end
					end)
					
					bar:SetScript('OnMouseUp', OnMouseUp)

					bar.factionID = factionID
					bar.name = name

					tinsert(BUI.FactionsDB, bar)
				end
			end
		end
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
	if not E.db.benikui.dashboards.reputations.barFactionColors then
		mod:BarColor(BUI.FactionsDB)
	end
end

function mod:PopulateFactionData()
	local Collapsed = {}
	local numFactions = GetNumFactions()
	local factionIndex = 1
	local headerIndex

	while (factionIndex <= numFactions) do
		local name, _, _, _, _, _, _, _, isHeader, isCollapsed, hasRep, _, isChild, factionID = GetFactionInfo(factionIndex)
		if isHeader and isCollapsed then
			ExpandFactionHeader(factionIndex)
			numFactions = GetNumFactions()
			Collapsed[name] = true
		end

		if isHeader and not (hasRep or isChild) then
			tinsert(BUI.ReputationsList, { name, factionID, factionIndex, isHeader, hasRep, isChild })
			headerIndex = factionIndex
		end

		if not isHeader or not isChild or hasRep then -- hasRep needs to be passed here
			if factionID then
				BUI.ReputationsList[tostring(factionID)] = name
				tinsert(BUI.ReputationsList, { name, factionID, headerIndex, isHeader, hasRep, isChild })
			end
		end

		factionIndex = factionIndex + 1
	end

	for k = 1, numFactions do
		local name, _, _, _, _, _, _, _, isHeader, isCollapsed = GetFactionInfo(k)
		if not name then
			break
		elseif isHeader and not isCollapsed and Collapsed[name] then
			ExpandFactionHeader(k, false)
		end
	end

	wipe(Collapsed)
end

function mod:UPDATE_FACTION(_, factionID)
	if factionID and not BUI.ReputationsList[tostring(factionID)] then
		local name = GetFactionInfoByID(factionID)
		if name then
			mod:PopulateFactionData()
		end
	end
	mod:UpdateReputations()
end

function mod:ReputationEvents()
	self:RegisterEvent('UPDATE_FACTION')
	self:RegisterEvent('QUEST_LOG_UPDATE', 'UpdateReputations')
end

function mod:CreateReputationsDashboard()
	self.reputationHolder = self:CreateDashboardHolder('BUI_ReputationsDashboard', 'reputations')
	self.reputationHolder:SetPoint('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -320)
	self.reputationHolder:SetWidth(E.db.benikui.dashboards.reputations.width or 150)

	mod:PopulateFactionData()
	mod:UpdateReputations()
	mod:UpdateReputationSettings()
	mod:UpdateHolderDimensions(self.reputationHolder, 'reputations', BUI.FactionsDB)
	mod:ToggleStyle(self.reputationHolder, 'reputations')
	mod:ToggleTransparency(self.reputationHolder, 'reputations')

	E:CreateMover(_G.BUI_ReputationsDashboard, 'reputationHolderMover', L['Reputations'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,reputations')
end

function mod:LoadReputations()
	if E.db.benikui.dashboards.reputations.enableReputations ~= true then return end

	mod:CreateReputationsDashboard()
	mod:ReputationEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateReputationSettings)
end
