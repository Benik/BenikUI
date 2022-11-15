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
local InCombatLockdown = InCombatLockdown
local TRADE_SKILLS = TRADE_SKILLS

-- GLOBALS: hooksecurefunc

local DASH_HEIGHT = 20
local DASH_SPACING = 3
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

local function sortFunction(a, b)
	return a.name < b.name
end

local function OnMouseUp(frame, btn)
	if InCombatLockdown() then return end
	local SetOffset = frame.SetOffset
	local name = frame.name

	if btn == "RightButton" then
		E:ToggleOptions()
		local ACD = E.Libs.AceConfigDialog
		if ACD then ACD:SelectGroup("ElvUI", "benikui") end
	else
		if SetOffset > 0 then
			CastSpell(SetOffset + 1, name)
		end
	end
end

function mod:UpdateProfessions()
	local db = E.db.benikui.dashboards.professions
	local holder = _G.BUI_ProfessionsDashboard

	if(BUI.ProfessionsDB[1]) then
		for i = 1, getn(BUI.ProfessionsDB) do
			BUI.ProfessionsDB[i]:Kill()
		end
		wipe(BUI.ProfessionsDB)
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
					holder:Show()
					holder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BUI.ProfessionsDB + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					if ProfessionsMover then
						ProfessionsMover:Size(holder:GetSize())
						holder:Point('TOPLEFT', ProfessionsMover, 'TOPLEFT')
					end

					local bar = self:CreateDashboard(holder, 'professions', true)

					bar:SetScript('OnEnter', function(self)
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

					bar:SetScript('OnLeave', function(self)
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
						bar.Status:SetMinMaxValues(1, maxRank + rankModifier)
						bar.Status:SetValue(rank + rankModifier)
					else
						bar.Status:SetMinMaxValues(1, maxRank)
						bar.Status:SetValue(rank)
					end

					if E.db.benikui.dashboards.barColor == 1 then
						bar.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
					else
						bar.Status:SetStatusBarColor(E.db.benikui.dashboards.customBarColor.r, E.db.benikui.dashboards.customBarColor.g, E.db.benikui.dashboards.customBarColor.b)
					end

					if (rankModifier and rankModifier > 0) then
						bar.Text:SetFormattedText('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank)
					else
						bar.Text:SetFormattedText('%s / %s', rank, maxRank)
					end

					if E.db.benikui.dashboards.textColor == 1 then
						bar.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						bar.Text:SetTextColor(BUI:unpackColor(E.db.benikui.dashboards.customTextColor))
					end

					bar.IconBG.Icon:SetTexture(icon)

					local SetOffset = offset or 0
					bar.name = name
					bar.SetOffset = SetOffset
					bar.IconBG.SetOffset = SetOffset
					bar.IconBG.name = name
					bar:SetScript('OnMouseUp', OnMouseUp)
					bar.IconBG:SetScript('OnMouseUp', OnMouseUp)

					tinsert(BUI.ProfessionsDB, bar)
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
	mod:IconPosition(BUI.ProfessionsDB, 'professions')
end

function mod:ProfessionsEvents()
	mod:RegisterEvent('SKILL_LINES_CHANGED', 'UpdateProfessions')
	mod:RegisterEvent('CHAT_MSG_SKILL', 'UpdateProfessions')
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

	mod:UpdateProfessions()
	mod:UpdateProfessionSettings()
	mod:UpdateHolderDimensions(holder, 'professions', BUI.ProfessionsDB)
	mod:ToggleStyle(holder, 'professions')
	mod:ToggleTransparency(holder, 'professions')

	holder:SetScript('OnEnter', function()
		if db.mouseover then
			E:UIFrameFadeIn(holder, 0.2, holder:GetAlpha(), 1)
		end
	end)

	holder:SetScript('OnLeave', function(holder)
		if db.mouseover then
			E:UIFrameFadeOut(holder, 0.2, holder:GetAlpha(), 0)
		end
	end)

	E:CreateMover(_G.BUI_ProfessionsDashboard, 'ProfessionsMover', TRADE_SKILLS, nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,dashboards,professions')
end

function mod:LoadProfessions()
	if E.db.benikui.dashboards.professions.enableProfessions ~= true then return end

	mod:CreateProfessionsDashboard()
	mod:ProfessionsEvents()

	hooksecurefunc(DT, 'LoadDataTexts', mod.UpdateProfessionSettings)
end
