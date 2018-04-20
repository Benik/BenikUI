local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIP = E:NewModule('BuiProfessionsDashboard', 'AceEvent-3.0', 'AceHook-3.0')
local LSM = LibStub('LibSharedMedia-3.0')
local DT = E:GetModule('DataTexts')

local getn, tinsert, wipe, pairs, ipairs = getn, table.insert, table.wipe, pairs, ipairs

local CreateFrame = CreateFrame
local UIFrameFadeIn, UIFrameFadeOut = UIFrameFadeIn, UIFrameFadeOut
local GetProfessions = GetProfessions
local GetProfessionInfo = GetProfessionInfo
local CastSpellByName = CastSpellByName
local TRADE_SKILLS, PROFESSIONS_FISHING = TRADE_SKILLS, PROFESSIONS_FISHING

-- GLOBALS: hooksecurefunc, proHolder, MMHolder

if E.db.dashboards == nil then E.db.dashboards = {} end
if E.db.dashboards.professions == nil then E.db.dashboards.professions = {} end

local DASH_HEIGHT = 20
local DASH_WIDTH = E.db.dashboards.professions.width or 150
local DASH_SPACING = 3
local SPACING = 1

local classColor = E.myclass == 'PRIEST' and E.PriestColors or (CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[E.myclass] or RAID_CLASS_COLORS[E.myclass])

local BuiProfessions = {}

local function pholderOnFade()
	proHolder:Hide()
end

function BUIP:CreateProHolder()
	local pholder
	local mapholderWidth = E.private.general.minimap.enable and MMHolder:GetWidth() or 150
	if not pholder then
		pholder = CreateFrame('Frame', 'proHolder', E.UIParent)
		pholder:CreateBackdrop('Transparent')
		pholder:Width(mapholderWidth or DASH_WIDTH)
		pholder:SetFrameStrata('BACKGROUND')
		pholder:SetFrameLevel(5)
		if E.private.general.minimap.enable then
			pholder:Point('TOPLEFT', MMHolder, 'BOTTOMLEFT', 0, -5)
		else
			pholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -120)
		end
		pholder.backdrop:Style('Outside')
		pholder:Hide()
	end

	if E.db.dashboards.professions.combat then
		pholder:SetScript('OnEvent',function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				self.fadeInfo.finishedFunc = pholderOnFade
			elseif event == 'PLAYER_REGEN_ENABLED' then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end	
		end)
	end

	self:UpdateProfessions()
	self:UpdatePholderDimensions()
	self:EnableDisableCombat()
	E.FrameLocks['proHolder'] = true;
	E:CreateMover(proHolder, 'ProfessionsMover', TRADE_SKILLS)
end

function BUIP:EnableDisableCombat()
	if E.db.dashboards.professions.combat then
		proHolder:RegisterEvent('PLAYER_REGEN_DISABLED')
		proHolder:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		proHolder:UnregisterEvent('PLAYER_REGEN_DISABLED')
		proHolder:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end

local capRank = 800

function BUIP:UpdateProfessions()
	local db = E.db.dashboards.professions
	if( BuiProfessions[1] ) then
		for i = 1, getn( BuiProfessions ) do
			BuiProfessions[i]:Kill()
		end
		wipe( BuiProfessions )
		proHolder:Hide()
	end

	if db.mouseover then proHolder:SetAlpha(0) else proHolder:SetAlpha(1) end

	proHolder:SetScript('OnEnter', function(self)
		if db.mouseover then
			E:UIFrameFadeIn(proHolder, 0.2, proHolder:GetAlpha(), 1)
		end
	end)

	proHolder:SetScript('OnLeave', function(self)
		if db.mouseover then
			E:UIFrameFadeOut(proHolder, 0.2, proHolder:GetAlpha(), 0)
		end
	end)

	local prof1, prof2, archy, fishing, cooking, firstAid = GetProfessions()
	
	if (prof1 or prof2 or archy or fishing or cooking or firstAid) then
		local proftable = { GetProfessions() }

		for _, id in pairs(proftable) do
			local name, icon, rank, maxRank, _, _, skillLine, rankModifier = GetProfessionInfo(id)

			if name and (rank < capRank or (not db.capped)) then
				if E.private.dashboards.professions.choosePofessions[id] == true then
					proHolder:Show()
					proHolder:Height(((DASH_HEIGHT + (E.PixelMode and 1 or DASH_SPACING)) * (#BuiProfessions + 1)) + DASH_SPACING + (E.PixelMode and 0 or 2))
					if ProfessionsMover then
						ProfessionsMover:Size(proHolder:GetSize())
						proHolder:Point('TOPLEFT', ProfessionsMover, 'TOPLEFT')
					end

					local ProFrame = CreateFrame('Button', nil, proHolder)
					ProFrame:Height(DASH_HEIGHT)
					ProFrame:Width(DASH_WIDTH)
					ProFrame:Point('TOPLEFT', proHolder, 'TOPLEFT', SPACING, -SPACING)

					ProFrame:SetScript('OnEnter', function(self)
						ProFrame.Text:SetFormattedText('%s', name)
						if db.mouseover then
							E:UIFrameFadeIn(proHolder, 0.2, proHolder:GetAlpha(), 1)
						end
					end)

					ProFrame:SetScript('OnLeave', function(self)
						if (rankModifier and rankModifier > 0) then
							ProFrame.Text:SetFormattedText('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank)
						else
							ProFrame.Text:SetFormattedText('%s / %s', rank, maxRank)
						end
						if db.mouseover then
							E:UIFrameFadeOut(proHolder, 0.2, proHolder:GetAlpha(), 0)
						end
					end)

					ProFrame:SetScript('OnClick', function(self)
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

					ProFrame.dummy = CreateFrame('Frame', nil, ProFrame)
					ProFrame.dummy:Point('BOTTOMLEFT', ProFrame, 'BOTTOMLEFT', 2, (E.PixelMode and 2 or 0))
					ProFrame.dummy:Point('BOTTOMRIGHT', ProFrame, 'BOTTOMRIGHT', (E.PixelMode and -24 or -28), 0)
					ProFrame.dummy:Height(E.PixelMode and 3 or 5)

					ProFrame.dummy.dummyStatus = ProFrame.dummy:CreateTexture(nil, 'OVERLAY')
					ProFrame.dummy.dummyStatus:SetInside()
					ProFrame.dummy.dummyStatus:SetTexture(E['media'].BuiFlat)
					ProFrame.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

					ProFrame.Status = CreateFrame('StatusBar', nil, ProFrame.dummy)
					ProFrame.Status:SetStatusBarTexture(E['media'].BuiFlat)

					if (rankModifier and rankModifier > 0) then
						ProFrame.Status:SetMinMaxValues(1, maxRank + rankModifier)
						ProFrame.Status:SetValue(rank + rankModifier)
					else
						ProFrame.Status:SetMinMaxValues(1, maxRank)
						ProFrame.Status:SetValue(rank)
					end

					if E.db.dashboards.barColor == 1 then
						ProFrame.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
					else
						ProFrame.Status:SetStatusBarColor(E.db.dashboards.customBarColor.r, E.db.dashboards.customBarColor.g, E.db.dashboards.customBarColor.b)
					end

					ProFrame.Status:SetInside()

					ProFrame.spark = ProFrame.Status:CreateTexture(nil, 'OVERLAY', nil);
					ProFrame.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
					ProFrame.spark:Size(12, 6);
					ProFrame.spark:SetBlendMode('ADD');
					ProFrame.spark:SetPoint('CENTER', ProFrame.Status:GetStatusBarTexture(), 'RIGHT')

					ProFrame.Text = ProFrame.Status:CreateFontString(nil, 'OVERLAY')
					if E.db.dashboards.dashfont.useDTfont then
						ProFrame.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
					else
						ProFrame.Text:FontTemplate(LSM:Fetch('font', E.db.dashboards.dashfont.dbfont), E.db.dashboards.dashfont.dbfontsize, E.db.dashboards.dashfont.dbfontflags)
					end
					ProFrame.Text:Point('CENTER', ProFrame, 'CENTER', -10, (E.PixelMode and 1 or 3))
					ProFrame.Text:Width(ProFrame:GetWidth() - 20)
					ProFrame.Text:SetWordWrap(false)
					if (rankModifier and rankModifier > 0) then
						ProFrame.Text:SetFormattedText('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank)
					else
						ProFrame.Text:SetFormattedText('%s / %s', rank, maxRank)
					end

					if E.db.dashboards.textColor == 1 then
						ProFrame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						ProFrame.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
					end

					ProFrame.IconBG = CreateFrame('Button', nil, ProFrame)
					ProFrame.IconBG:SetTemplate('Transparent')
					ProFrame.IconBG:Size(E.PixelMode and 18 or 20)
					ProFrame.IconBG:Point('BOTTOMRIGHT', ProFrame, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)

					ProFrame.IconBG:SetScript('OnEnter', function(self)
						ProFrame.Text:SetFormattedText('%s', name)
						if db.mouseover then
							E:UIFrameFadeIn(proHolder, 0.2, proHolder:GetAlpha(), 1)
						end
					end)

					ProFrame.IconBG:SetScript('OnLeave', function(self)
						if (rankModifier and rankModifier > 0) then
							ProFrame.Text:SetFormattedText('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank)
						else
							ProFrame.Text:SetFormattedText('%s / %s', rank, maxRank)
						end
						if db.mouseover then
							E:UIFrameFadeOut(proHolder, 0.2, proHolder:GetAlpha(), 0)
						end
					end)

					ProFrame.IconBG:SetScript('OnClick', function(self)
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

					ProFrame.IconBG.Icon = ProFrame.IconBG:CreateTexture(nil, 'ARTWORK')
					ProFrame.IconBG.Icon:SetInside()
					ProFrame.IconBG.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					ProFrame.IconBG.Icon:SetTexture(icon)

					tinsert(BuiProfessions, ProFrame)
				end
			end
		end
	end

	for key, frame in ipairs(BuiProfessions) do
		frame:ClearAllPoints()
		if(key == 1) then
			frame:Point( 'TOPLEFT', proHolder, 'TOPLEFT', 0, -SPACING -(E.PixelMode and 0 or 4))
		else
			frame:Point('TOP', BuiProfessions[key - 1], 'BOTTOM', 0, -SPACING -(E.PixelMode and 0 or 2))
		end
	end

end

function BUIP:ProEvents()
	self:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateProfessions')
	self:RegisterEvent('SKILL_LINES_CHANGED', 'UpdateProfessions')
	self:RegisterEvent('CHAT_MSG_SKILL', 'UpdateProfessions')
end

function BUIP:UpdatePholderDimensions()
	proHolder:Width(E.db.dashboards.professions.width)

	for _, frame in pairs(BuiProfessions) do
		frame:Width(E.db.dashboards.professions.width)
	end
end

function BUIP:ToggleTransparency()
	local db = E.db.dashboards.professions
	if not db.backdrop then
		proHolder.backdrop:SetTemplate("NoBackdrop")
	elseif db.transparency then
		proHolder.backdrop:SetTemplate("Transparent")
	else
		proHolder.backdrop:SetTemplate("Default", true)
	end
end

function BUIP:ToggleStyle()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	if E.db.dashboards.professions.style then
		proHolder.backdrop.style:Show()
	else
		proHolder.backdrop.style:Hide()
	end
end

function BUIP:ProDefaults()
	if E.db.dashboards.professions.width == nil then E.db.dashboards.professions.width = 172 end
end

function BUIP:Initialize()
	if E.db.dashboards.professions.enableProfessions ~= true then return end
	self:ProDefaults()
	self:CreateProHolder()
	self:ProEvents()
	self:ToggleStyle()
	self:ToggleTransparency()
	hooksecurefunc(DT, 'LoadDataTexts', BUIP.UpdateProfessions)
end

local function InitializeCallback()
	BUIP:Initialize()
end

E:RegisterModule(BUIP:GetName(), InitializeCallback)