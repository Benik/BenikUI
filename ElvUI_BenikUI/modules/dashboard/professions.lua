local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards');
local DT = E:GetModule('DataTexts');

local _G = _G
local getn = getn
local pairs, ipairs = pairs, ipairs
local tinsert, tsort = table.insert, table.sort

local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local CastSpell = CastSpell
local TRADE_SKILLS = TRADE_SKILLS

-- GLOBALS: hooksecurefunc, MMHolder

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

local function sortFunction(a, b)
	return a.name < b.name
end

local function OnClick(frame)
	local SetOffset = frame.SetOffset
	local name = frame.name

	if SetOffset > 0 then
		CastSpell(SetOffset + 1, name)
	end
end

function mod:UpdateProfessions()
	local db = E.db.dashboards.professions
	local holder = _G.BUI_ProfessionsDashboard

	if(BUI.ProfessionsDB[1]) then
		for i = 1, getn(BUI.ProfessionsDB) do
			BUI.ProfessionsDB[i]:Kill()
		end
		wipe(BUI.ProfessionsDB)
		holder:Hide()
	end

	if db.mouseover then
		holder:SetAlpha(0)
	else
		holder:SetAlpha(1)
	end

	holder:SetScript('OnEnter', function(self)
		if db.mouseover then
			E:UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
		end
	end)

	holder:SetScript('OnLeave', function(self)
		if db.mouseover then
			E:UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
		end
	end)

	local prof1, prof2, archy, fishing, cooking = GetProfessions()

	if (prof1 or prof2 or archy or fishing or cooking) then
		local proftable = { GetProfessions() }

		for _, id in pairs(proftable) do
			local name, icon, rank, maxRank, _, offset, _, rankModifier, _, _, skillLineName = GetProfessionInfo(id)

			if name and (rank < maxRank or (not db.capped)) then
				if E.private.dashboards.professions.choosePofessions[id] == true then
					holder:Show()
					holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.ProfessionsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					if ProfessionsMover then
						ProfessionsMover:Size(holder:GetSize())
						holder:SetPoint('TOPLEFT', ProfessionsMover, 'TOPLEFT')
					end

					self.ProFrame = self:CreateDashboard(nil, holder, 'professions')

					self.ProFrame:SetScript('OnEnter', function(self)
						self.Text:SetFormattedText('%s', name)
						if skillLineName then
							GameTooltip:SetOwner(self, 'ANCHOR_CURSOR');
							GameTooltip:AddLine(format('%s', skillLineName), 0.7, 0.7, 1)
							GameTooltip:Show()
						end
						if db.mouseover then
							E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
						end
					end)

					self.ProFrame:SetScript('OnLeave', function(self)
						if (rankModifier and rankModifier > 0) then
							self.Text:SetFormattedText('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank)
						else
							self.Text:SetFormattedText('%s / %s', rank, maxRank)
						end
						GameTooltip:Hide()
						if db.mouseover then
							E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
						end
					end)

					if (rankModifier and rankModifier > 0) then
						self.ProFrame.Status:SetMinMaxValues(1, maxRank + rankModifier)
						self.ProFrame.Status:SetValue(rank + rankModifier)
					else
						self.ProFrame.Status:SetMinMaxValues(1, maxRank)
						self.ProFrame.Status:SetValue(rank)
					end

					if E.db.dashboards.barColor == 1 then
						self.ProFrame.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
					else
						self.ProFrame.Status:SetStatusBarColor(E.db.dashboards.customBarColor.r, E.db.dashboards.customBarColor.g, E.db.dashboards.customBarColor.b)
					end

					if (rankModifier and rankModifier > 0) then
						self.ProFrame.Text:SetFormattedText('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank)
					else
						self.ProFrame.Text:SetFormattedText('%s / %s', rank, maxRank)
					end

					if E.db.dashboards.textColor == 1 then
						self.ProFrame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						self.ProFrame.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
					end

					self.ProFrame.IconBG.Icon:SetTexture(icon)

					local SetOffset = offset or 0
					self.ProFrame.name = name
					self.ProFrame.SetOffset = SetOffset
					self.ProFrame.IconBG.SetOffset = SetOffset
					self.ProFrame.IconBG.name = name
					self.ProFrame:SetScript('OnClick', OnClick)
					self.ProFrame.IconBG:SetScript('OnClick', OnClick)

					tinsert(BUI.ProfessionsDB, self.ProFrame)
				end
			end
		end
	end

	tsort(BUI.ProfessionsDB, sortFunction)

	for key, frame in ipairs(BUI.ProfessionsDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:SetPoint( 'TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:SetPoint('TOP', BUI.ProfessionsDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end
end

function mod:UpdateProfessionSettings()
	mod:FontStyle(BUI.ProfessionsDB)
	mod:FontColor(BUI.ProfessionsDB)
	mod:BarColor(BUI.ProfessionsDB)
end

function mod:ProfessionsEvents()
	self:RegisterEvent('SKILL_LINES_CHANGED', 'UpdateProfessions')
	self:RegisterEvent('CHAT_MSG_SKILL', 'UpdateProfessions')
end

function mod:CreateProfessionsDashboard()
	local mapholderWidth = E.private.general.minimap.enable and _G.MMHolder:GetWidth() or 150
	local DASH_WIDTH = E.db.dashboards.professions.width or 150

	self.proHolder = self:CreateDashboardHolder('BUI_ProfessionsDashboard', 'professions')

	if E.private.general.minimap.enable then
		self.proHolder:SetPoint('TOPLEFT', _G.MMHolder, 'BOTTOMLEFT', 0, -5)
	else
		self.proHolder:SetPoint('TOPRIGHT', E.UIParent, 'TOPRIGHT', -5, -184)
	end
	self.proHolder:Width(mapholderWidth or DASH_WIDTH)

	mod:UpdateProfessions()
	mod:UpdateProfessionSettings()
	mod:UpdateHolderDimensions(self.proHolder, 'professions', BUI.ProfessionsDB)
	mod:ToggleStyle(self.proHolder, 'professions')
	mod:ToggleTransparency(self.proHolder, 'professions')

	E:CreateMover(_G.BUI_ProfessionsDashboard, 'ProfessionsMover', TRADE_SKILLS, nil, nil, nil, 'ALL,BENIKUI')
end

function mod:LoadProfessions()
	if E.db.dashboards.professions.enableProfessions ~= true then return end

	mod:CreateProfessionsDashboard()
	mod:ProfessionsEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateProfessionSettings)
end