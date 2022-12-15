local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards')
local DT = E:GetModule('DataTexts')

local _G = _G
local getn = getn
local pairs, ipairs = pairs, ipairs
local tinsert, tsort = table.insert, table.sort

local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local CastSpell = CastSpell
local InCombatLockdown = InCombatLockdown
local IsInInstance = IsInInstance
local TRADE_SKILLS = TRADE_SKILLS

-- GLOBALS: hooksecurefunc

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1
local professionsDB = BUI.ProfessionsDB

local classColor = E:ClassColor(E.myclass, true)

local function sortFunction(a, b)
	return a.name < b.name
end

local function OnMouseUp(self, btn)
	if InCombatLockdown() then return end

	if btn == "RightButton" then
		E:ToggleOptions()
		local ACD = E.Libs.AceConfigDialog
		if ACD then ACD:SelectGroup("ElvUI", "benikui", "dashboards", "professions") end
	else
		if self.SetOffset > 0 then
			CastSpell(self.SetOffset + 1, self.name)
		end
	end
end

local function OnEnter(self)
	local db = E.db.benikui.dashboards.professions
	local holder = self:GetParent()

	self.Text:SetFormattedText('%s', self.name)

	if db.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function OnLeave(self)
	local db = E.db.benikui.dashboards.professions
	local holder = self:GetParent()

	if (self.rankModifier and self.rankModifier > 0) then
		self.Text:SetFormattedText('%s |cFF6b8df4+%s|r / %s', self.rank, self.rankModifier, self.maxRank)
	else
		self.Text:SetFormattedText('%s / %s', self.rank, self.maxRank)
	end

	GameTooltip:Hide()

	if db.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
end

function mod:UpdateProfessions()
	local db = E.db.benikui.dashboards.professions
	local dbd = E.db.benikui.dashboards
	local holder = _G.BUI_ProfessionsDashboard

	if not db.enable then holder:Hide() return end

	local inInstance = IsInInstance()
	local NotinInstance = not (db.instance and inInstance)

	if(professionsDB[1]) then
		for i = 1, getn(professionsDB) do
			professionsDB[i]:Kill()
		end
		wipe(professionsDB)
		holder:Hide()
	end

	if db.mouseover then holder:SetAlpha(0) else holder:SetAlpha(1) end

	local prof1, prof2, archy, fishing, cooking = GetProfessions()

	if (prof1 or prof2 or archy or fishing or cooking) then
		local proftable = { GetProfessions() }

		for _, id in pairs(proftable) do
			local name, icon, rank, maxRank, _, offset, _, rankModifier, _, _, skillLineName = GetProfessionInfo(id)

			if name and (rank < maxRank or (not db.capped)) then
				if E.private.benikui.dashboards.professions.choosePofessions[id] == true then
					holder:SetShown(NotinInstance)
					
					if db.orientation == 'BOTTOM' then
						holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#professionsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
						holder:Width(db.width)
					else
						holder:Height(DASH_HEIGHT + (DASH_SPACING))
						holder:Width(db.width * (#professionsDB + 1) + ((#professionsDB) *db.spacing))
					end

					local bar = mod:CreateDashboard(holder, 'professions', true)

					bar:SetScript('OnEnter', OnEnter)
					bar:SetScript('OnLeave', OnLeave)
					bar:SetScript('OnMouseUp', OnMouseUp)

					local RankModifier = (rankModifier and rankModifier > 0)
					local MinMaxValue = (RankModifier and (maxRank + rankModifier)) or maxRank
					local StatusBarValue = (RankModifier and (rank + rankModifier)) or rank
					local BarColor = (dbd.barColor == 1 and classColor) or dbd.customBarColor
					local TextColor = (dbd.textColor == 1 and classColor) or dbd.customTextColor
					local SetOffset = offset or 0
					local displayString = ''

					bar.Status:SetMinMaxValues(1, MinMaxValue)
					bar.Status:SetValue(StatusBarValue)
					bar.Status:SetStatusBarColor(BarColor.r, BarColor.g, BarColor.b)

					if RankModifier then
						displayString = format('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank)
					else
						displayString = format('%s / %s', rank, maxRank)
					end

					bar.Text:SetText(displayString)
					bar.Text:SetTextColor(TextColor.r, TextColor.g, TextColor.b)
					bar.IconBG.Icon:SetTexture(icon)

					bar.db = db
					bar.name = name
					bar.SetOffset = SetOffset
					bar.IconBG.SetOffset = SetOffset
					bar.rank = rank
					bar.maxRank = maxRank
					bar.rankModifier = rankModifier
					bar.IconBG.name = name

					tinsert(professionsDB, bar)
				end
			end
		end
	end

	tsort(professionsDB, sortFunction)

	for key, frame in pairs(professionsDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point('TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			if db.orientation == 'BOTTOM' then
				frame:Point('TOP', professionsDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
			else
				frame:Point('LEFT', professionsDB[key - 1], 'RIGHT', db.spacing +(E.PixelMode and 0 or 2), 0)
			end
		end
	end

	mod:FontStyle(professionsDB)
	mod:FontColor(professionsDB)
	mod:BarColor(professionsDB)
	mod:IconPosition(professionsDB, 'professions')
end

local function holderOnEnter(self)
	local db = E.db.benikui.dashboards.professions
	local holder = _G.BUI_ProfessionsDashboard

	if db.mouseover then
		E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
	end
end

local function holderOnLeave(self)
	local db = E.db.benikui.dashboards.professions
	local holder = _G.BUI_ProfessionsDashboard

	if db.mouseover then
		E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
	end
end

function mod:ToggleProfessions()
	local db = E.db.benikui.dashboards.professions
	local holder = _G.BUI_ProfessionsDashboard

	if db.enable then
		E:EnableMover(holder.mover.name)
		mod:RegisterEvent('SKILL_LINES_CHANGED', 'UpdateProfessions')
		mod:RegisterEvent('CHAT_MSG_SKILL', 'UpdateProfessions')

		mod:ToggleStyle(holder, 'professions')
		mod:ToggleTransparency(holder, 'professions')
	
		holder:SetScript('OnEnter', holderOnEnter)
		holder:SetScript('OnLeave', holderOnLeave)
	else
		E:DisableMover(holder.mover.name)
		mod:UnregisterEvent('SKILL_LINES_CHANGED')
		mod:UnregisterEvent('CHAT_MSG_SKILL')

		holder:SetScript('OnEnter', nil)
		holder:SetScript('OnLeave', nil)
	end
	mod:UpdateProfessions()
end

function mod:CreateProfessionsDashboard()
	local db = E.db.benikui.dashboards.professions
	local mapholderWidth = E.private.general.minimap.enable and _G.ElvUI_MinimapClusterHolder:GetWidth() or 150
	local DASH_WIDTH = db.width or 150

	local holder = mod:CreateDashboardHolder('BUI_ProfessionsDashboard', 'professions')

	if E.private.general.minimap.enable then
		holder:Point('TOPLEFT', _G.ElvUI_MinimapClusterHolder, 'BOTTOMLEFT', 0, -5)
	else
		holder:Point('TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -184)
	end

	holder:Width(mapholderWidth or DASH_WIDTH)

	E:CreateMover(holder, 'ProfessionsMover', TRADE_SKILLS, nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,professions')
	mod:ToggleProfessions()
end

function mod:LoadProfessions()
	mod:CreateProfessionsDashboard()
	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateProfessions)
end