local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Dashboards')
local DT = E:GetModule('DataTexts')
local DB = E:GetModule('DataBars')
local LSM = E.LSM

local _G = _G
local getn = getn
local tinsert, twipe, tsort, tostring = table.insert, table.wipe, table.sort, tostring

local GameTooltip = _G.GameTooltip
local GetFactionInfoByID = C_Reputation.GetFactionDataByID
local GetFactionInfo = C_Reputation.GetFactionDataByIndex
local GetNumFactions = C_Reputation.GetNumFactions
local ExpandFactionHeader = C_Reputation.ExpandFactionHeader
local C_Reputation_GetFactionParagonInfo = C_Reputation.GetFactionParagonInfo
local C_Reputation_IsFactionParagon = C_Reputation.IsFactionParagon
local C_GossipInfo_GetFriendshipReputation = C_GossipInfo.GetFriendshipReputation
local C_Reputation_IsMajorFaction = C_Reputation.IsMajorFaction
local C_MajorFactions_GetMajorFactionData = C_MajorFactions.GetMajorFactionData
local C_MajorFactions_HasMaximumRenown = C_MajorFactions.HasMaximumRenown
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local IsShiftKeyDown = IsShiftKeyDown
local BreakUpLargeNumbers = BreakUpLargeNumbers

local BLUE_FONT_COLOR = BLUE_FONT_COLOR
local RENOWN_LEVEL_LABEL = RENOWN_LEVEL_LABEL
local REPUTATION = REPUTATION
local STANDING = STANDING
local UNKNOWN = UNKNOWN

local BLUE_COLOR_HEX = E:RGBToHex(BLUE_FONT_COLOR.r, BLUE_FONT_COLOR.g, BLUE_FONT_COLOR.b)

-- GLOBALS: hooksecurefunc

local position, Xoffset

mod.ReputationsList = {}

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local factionsDB = mod.FactionsDB

local classColor = E:ClassColor(E.myclass, true)

local function OnMouseUp(self, btn)
	if InCombatLockdown() then return end
	if btn == "RightButton" then
		if IsShiftKeyDown() then
			local factionID = self.factionID
			E.private.benikui.dashboards.reputations.chooseReputations[factionID] = false
			mod:UpdateReputations()
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

function mod:UpdateReputations()
	local db = E.db.benikui.dashboards.reputations
	local holder = _G.BUI_ReputationsDashboard

	if not db.enable then
		holder:Hide()
		twipe(mod.ReputationsList)
		return
	end

	local inInstance = IsInInstance()
	local NotinInstance = not (db.instance and inInstance)

	if(factionsDB[1]) then
		for i = 1, getn(factionsDB) do
			factionsDB[i]:Kill()
		end
		twipe(factionsDB)
		holder:Hide()
	end

	if db.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end

	for _, info in ipairs(mod.ReputationsList) do
		local _, factionID = unpack(info)

		if factionID then
			local factionInfo = GetFactionInfoByID(factionID)
			if factionInfo then
				local name = factionInfo.name

				if E.private.benikui.dashboards.reputations.chooseReputations[factionID] == true then
					holder:SetShown(NotinInstance)

					if db.orientation == 'BOTTOM' then
						holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#factionsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
						holder:Width(db.width)
					else
						holder:Height(DASH_HEIGHT + (DASH_SPACING))
						holder:Width(db.width * (#factionsDB + 1) + ((#factionsDB) *db.spacing))
					end

					local isFriend, friendText, standingLabel, majorStandingLabel, renownLevel
					local isParagon = C_Reputation_IsFactionParagon(factionID)
					local isMajorFaction = factionID and C_Reputation_IsMajorFaction(factionID)
					local repInfo = factionID and C_GossipInfo_GetFriendshipReputation(factionID)
					local currentValue, threshold, hasRewardPending, tooLowLevelForParagon
					local standingID = factionInfo.reaction
					local barMin = factionInfo.currentReactionThreshold
					local barMax = factionInfo.nextReactionThreshold
					local barValue = factionInfo.currentStanding

					if repInfo and repInfo.friendshipFactionID > 0 then
						standingLabel, barMin, barMax, barValue = repInfo.reaction, repInfo.reactionThreshold or 0, repInfo.nextThreshold or 1, repInfo.standing or 1
					elseif isMajorFaction then
						local majorFactionData = C_MajorFactions_GetMajorFactionData(factionID)
			
						standingID, barMin, barMax = 10, 0, majorFactionData.renownLevelThreshold
						barValue = C_MajorFactions_HasMaximumRenown(factionID) and majorFactionData.renownLevelThreshold or majorFactionData.renownReputationEarned or 0
						majorStandingLabel = format('%s%s %s|r', BLUE_COLOR_HEX, RENOWN_LEVEL_LABEL, majorFactionData.renownLevel)
						renownLevel = majorFactionData.renownLevel
					else
						standingLabel = _G['FACTION_STANDING_LABEL'..standingID]
					end

					if isParagon then
						currentValue, threshold, _, hasRewardPending, tooLowLevelForParagon = C_Reputation_GetFactionParagonInfo(factionID)
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

					if not standingLabel then
						standingLabel = _G['FACTION_STANDING_LABEL'..standingID] or UNKNOWN
					end

					local bar = mod:CreateDashboard(holder, 'reputations', false, true)
					bar.Status:SetMinMaxValues(barMin, barMax)
					bar.Status:SetValue(barValue)

					local customColors = E.db.databars.colors.useCustomFactionColors
					local customReaction = standingID == 9 or standingID == 10 -- 9 is paragon, 10 is renown
					local color = (customColors or customReaction) and E.db.databars.colors.factionColors[standingID] or _G.FACTION_BAR_COLORS[standingID]
					local hexColor = E:RGBToHex(color.r, color.g, color.b)

					-- cut down Artisan's Consortium name
					if factionID == 2544 then name = E:ShortenString(name, 20) end

					name = isMajorFaction and format('%s%s (%s)|r', name, BLUE_COLOR_HEX, renownLevel) or name

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

					bar.Text:Point(db.textAlign, bar, db.textAlign, ((db.textAlign == 'LEFT' and 4) or (db.textAlign == 'CENTER' and 0) or (db.textAlign == 'RIGHT' and -2)), (E.PixelMode and 1 or 3))
					bar.Text:SetJustifyH(db.textAlign)

					bar.bag:SetShown(isParagon)
					bar.bagGlow:SetShown(not tooLowLevelForParagon and hasRewardPending)
					bar.bagCheck:SetShown(not tooLowLevelForParagon and hasRewardPending)

					if isParagon then
						bar.bag:ClearAllPoints()
						if db.textAlign == 'LEFT' or db.textAlign == 'CENTER' then
							bar.bag:Point('RIGHT', bar, 'RIGHT', -4, 0)
						elseif db.textAlign == 'RIGHT' then
							bar.bag:Point('LEFT', bar, 'LEFT', 4, 0)
						end
					end

					bar:SetScript('OnEnter', function(self)
						standingLabel = isParagon and L["Paragon"] or isMajorFaction and majorStandingLabel or standingLabel

						self.Text:SetFormattedText('%s / %s %s(%s)|r', BreakUpLargeNumbers(barValue), BreakUpLargeNumbers(barMax), hexColor, isFriend and friendText or standingLabel)

						if db.mouseover then
							E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
						end

						if db.tooltip then
							GameTooltip:SetOwner(self, position, Xoffset, 0)
							GameTooltip:AddLine(name)
							GameTooltip:AddLine(' ')

							if isParagon then
								GameTooltip:AddLine(format(PARAGON_REPUTATION_TOOLTIP_TEXT, '\n'..name), selectioncolor)
								GameTooltip:AddLine(' ')
							end

							if isMajorFaction then
								GameTooltip:AddLine(format('%s%s|r', hexColor, isFriend and friendText or standingLabel), 1, 1, 1)
							else
								GameTooltip:AddDoubleLine(STANDING..':', format('%s%s|r', hexColor, isFriend and friendText or standingLabel), 1, 1, 1)
							end

							if standingID ~= _G.MAX_REPUTATION_REACTION or isParagon then
								GameTooltip:AddDoubleLine(REPUTATION..':', format('%d / %d (%d%%)', barValue - barMin, barMax - barMin, (barValue - barMin) / ((barMax - barMin == 0) and barMax or (barMax - barMin)) * 100), 1, 1, 1)
							end

							GameTooltip:AddLine(' ')
							GameTooltip:AddDoubleLine(L['Shift+RightClick to remove'], format('|cffff0000%s |r%s','ID', factionID), 0.7, 0.7, 1)
							GameTooltip:Show()
						end
					end)

					bar:SetScript('OnLeave', function(self)
						if db.textFactionColors then
							self.Text:SetFormattedText('%s: %s%d%%|r', name, hexColor, ((barValue - barMin) / (maxMinDiff) * 100))
						else
							self.Text:SetFormattedText('%s: %d%%|r', name, ((barValue - barMin) / (maxMinDiff) * 100))
						end
						if db.tooltip then GameTooltip:Hide() end

						if db.mouseover then
							E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
						end
					end)
					
					bar:SetScript('OnMouseUp', OnMouseUp)

					bar.factionID = factionID
					bar.name = name

					tinsert(factionsDB, bar)
				end
			end
		end
	end

	tsort(factionsDB, sortFunction)

	for key, frame in pairs(factionsDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point('TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			if db.orientation == 'BOTTOM' then
				frame:Point('TOP', factionsDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
			else
				frame:Point('LEFT', factionsDB[key - 1], 'RIGHT', db.spacing +(E.PixelMode and 0 or 2), 0)
			end
		end
	end

	mod:FontStyle(factionsDB)
	mod:FontColor(factionsDB)
end

function mod:PopulateFactionData()
	local Collapsed = {}
	local numFactions = GetNumFactions()
	local factionIndex = 1
	local headerIndex

	while (factionIndex <= numFactions) do
		local info = GetFactionInfo(factionIndex)
		if info then
			if info.isHeader and info.isCollapsed then
				ExpandFactionHeader(factionIndex)
				numFactions = GetNumFactions()
				Collapsed[info.name] = true
			end

			if info.isHeader and not (info.hasRep or info.isChild) then
				tinsert(mod.ReputationsList, { info.name, info.factionID, factionIndex, info.isHeader, info.hasRep, info.isChild })
				headerIndex = factionIndex
			end

			if not info.isHeader or not info.isChild or info.hasRep then -- hasRep needs to be passed here
				if info.factionID then
					mod.ReputationsList[tostring(info.factionID)] = info.name
					tinsert(mod.ReputationsList, { info.name, info.factionID, headerIndex, info.isHeader, info.hasRep, info.isChild })
				end
			end

			factionIndex = factionIndex + 1
		else
			break
		end
	end

	for k = 1, numFactions do
		local info = GetFactionInfo(k)
		if not info.name then
			break
		elseif info.isHeader and not info.isCollapsed and Collapsed[info.name] then
			ExpandFactionHeader(k, false)
		end
	end

	wipe(Collapsed)
end

function mod:UPDATE_FACTION(_, factionID)
	if factionID and not mod.ReputationsList[tostring(factionID)] then
		local info = GetFactionInfoByID(factionID)
		if info and info.name then
			mod:PopulateFactionData()
		end
	end
	mod:UpdateReputations()
end

local function holderOnEnter()
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ReputationsDashboard

	if db.professions.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function holderOnLeave()
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ReputationsDashboard

	if db.professions.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
end

local function CheckReputationsPosition()
	if E.db.benikui.dashboards.reputations.enable ~= true then return end

	position, Xoffset = mod:CheckPositionForTooltip(_G.BUI_ReputationsDashboard)
end

function mod:ToggleReputations()
	local db = E.db.benikui.dashboards
	local holder = _G.BUI_ReputationsDashboard

	if db.reputations.enable then
		E:EnableMover(holder.mover.name)
		mod:RegisterEvent('UPDATE_FACTION')
		mod:RegisterEvent('QUEST_LOG_UPDATE', 'UpdateReputations')
		mod:RegisterEvent('MAJOR_FACTION_RENOWN_LEVEL_CHANGED', 'UpdateReputations')
		mod:RegisterEvent('MAJOR_FACTION_UNLOCKED', 'UpdateReputations')

		mod:ToggleStyle(holder, 'reputations')
		mod:ToggleTransparency(holder, 'reputations')

		holder:SetScript('OnEnter', holderOnEnter)
		holder:SetScript('OnLeave', holderOnLeave)

		mod:PopulateFactionData()
	else
		E:DisableMover(holder.mover.name)
		mod:UnregisterEvent('UPDATE_FACTION')
		mod:UnregisterEvent('QUEST_LOG_UPDATE')
		mod:UnregisterEvent('MAJOR_FACTION_RENOWN_LEVEL_CHANGED')
		mod:UnregisterEvent('MAJOR_FACTION_UNLOCKED')

		holder:SetScript('OnEnter', nil)
		holder:SetScript('OnLeave', nil)
	end

	mod:UpdateReputations()
	CheckReputationsPosition()
end

function mod:CreateReputationsDashboard()
	local db = E.db.benikui.dashboards.reputations

	local holder = mod:CreateDashboardHolder('BUI_ReputationsDashboard', 'reputations')
	holder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 4, -320)
	holder:Width(db.width or 150)

	E:CreateMover(holder, 'reputationHolderMover', L['Reputations'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,reputations')
	mod:ToggleReputations()
end

function mod:LoadReputations()
	mod:CreateReputationsDashboard()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateReputations)
	hooksecurefunc(DB, 'ReputationBar_Update', mod.UpdateReputations)
	hooksecurefunc(E, 'ToggleMoveMode', CheckReputationsPosition)
end