local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local mod = E:GetModule('BuiDashboards');
local DT = E:GetModule('DataTexts');

local getn = getn
local pairs, ipairs = pairs, ipairs
local tinsert, twipe, tsort = table.insert, table.wipe, table.sort

local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local CastSpellByName = CastSpellByName
local TRADE_SKILLS, PROFESSIONS_FISHING = TRADE_SKILLS, PROFESSIONS_FISHING

-- GLOBALS: hooksecurefunc, MMHolder

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local function sortFunction(a, b)
	return a.name < b.name
end

function mod:UpdateProfessions()
	local db = E.db.dashboards.professions
	local holder = BUI_ProfessionsDashboard

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

	local prof1, prof2, archy, fishing, cooking, firstAid = GetProfessions()

	if (prof1 or prof2 or archy or fishing or cooking or firstAid) then
		local proftable = { GetProfessions() }

		for _, id in pairs(proftable) do
			local name, icon, rank, maxRank, _, _, skillLine, rankModifier = GetProfessionInfo(id)

			if name and (rank < maxRank or (not db.capped)) then
				if E.private.dashboards.professions.choosePofessions[id] == true then
					holder:Show()
					holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.ProfessionsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					if ProfessionsMover then
						ProfessionsMover:Size(holder:GetSize())
						holder:Point('TOPLEFT', ProfessionsMover, 'TOPLEFT')
					end

					self.ProFrame = self:CreateDashboard(nil, holder)

					self.ProFrame:SetScript('OnEnter', function(self)
						self.Text:SetFormattedText('%s', name)
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
						if db.mouseover then
							E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
						end
					end)

					self.ProFrame:SetScript('OnClick', function(self)
						if name ~= PROFESSIONS_FISHING then
							if skillLine == 186 then
								CastSpellByID(2656) -- mining skills
							elseif skillLine == 182 then
								CastSpellByID(193290) -- herbalism skills
							elseif skillLine == 393 then
								CastSpellByID(194174) -- skinning skills
							else
								CastSpellByName(name)
							end
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

					self.ProFrame.IconBG:SetScript('OnClick', function(self)
						if name ~= PROFESSIONS_FISHING then
							if skillLine == 186 then
								CastSpellByID(2656) -- mining skills
							elseif skillLine == 182 then
								CastSpellByID(193290) -- herbalism skills
							elseif skillLine == 393 then
								CastSpellByID(194174) -- skinning skills
							else
								CastSpellByName(name)
							end
						end
					end)

					self.ProFrame.IconBG.Icon:SetTexture(icon)

					self.ProFrame.name = name

					tinsert(BUI.ProfessionsDB, self.ProFrame)
				end
			end
		end
	end

	tsort(BUI.ProfessionsDB, sortFunction)

	for key, frame in ipairs(BUI.ProfessionsDB) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point( 'TOPLEFT', holder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:Point('TOP', BUI.ProfessionsDB[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
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
	local mapholderWidth = E.private.general.minimap.enable and MMHolder:GetWidth() or 150
	local DASH_WIDTH = E.db.dashboards.professions.width or 150

	self.proHolder = self:CreateDashboardHolder('BUI_ProfessionsDashboard', 'professions')

	if E.private.general.minimap.enable then
		self.proHolder:Point('TOPLEFT', MMHolder, 'BOTTOMLEFT', 0, -5)
	else
		self.proHolder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -120)
	end
	self.proHolder:Width(mapholderWidth or DASH_WIDTH)

	mod:UpdateProfessions()
	mod:UpdateProfessionSettings()
	mod:UpdateHolderDimensions(self.proHolder, 'professions', BUI.ProfessionsDB)
	mod:ToggleStyle(self.proHolder, 'professions')
	mod:ToggleTransparency(self.proHolder, 'professions')

	E:CreateMover(self.proHolder, 'ProfessionsMover', TRADE_SKILLS)
end

function mod:LoadProfessions()
	if E.db.dashboards.professions.enableProfessions ~= true then return end

	mod:CreateProfessionsDashboard()
	mod:ProfessionsEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateProfessionSettings)
end