local E, L, V, P, G, _ = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BUIP = E:NewModule('BuiProfessionsDashboard', 'AceEvent-3.0', 'AceHook-3.0')
local LSM = LibStub('LibSharedMedia-3.0')
local DT = E:GetModule('DataTexts')

if E.db.dashboards == nil then E.db.dashboards = {} end
if E.db.dashboards.professions == nil then E.db.dashboards.professions = {} end

local DASH_HEIGHT = 20
local DASH_WIDTH = E.db.dashboards.professions.width or 172
local SPACING = (E.PixelMode and 1 or 5)

local classColor = RAID_CLASS_COLORS[E.myclass]

local color = { r = 1, g = 1, b = 1 }
local function unpackColor(color)
	return color.r, color.g, color.b
end

local BuiProfessions = {}

local function pholderOnFade()
	proHolder:Hide()
end

function BUIP:CreateProHolder()
	local pholder
	local mapholderWidth = E.private.general.minimap.enable and MMHolder:GetWidth() or 172
	if not pholder then
		pholder = CreateFrame('Frame', 'proHolder', E.UIParent)
		pholder:CreateBackdrop('Transparent')
		pholder:Width(mapholderWidth or DASH_WIDTH)
		pholder:SetFrameStrata('LOW')
		if E.private.general.minimap.enable then
			pholder:Point('TOPLEFT', MMHolder, 'BOTTOMLEFT', 0, -5)
		else
			pholder:Point('TOPLEFT', E.UIParent, 'TOPLEFT', 2, -120)
		end
		pholder.backdrop:Style('Outside')
		pholder.backdrop:Hide()
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

function BUIP:UpdateProfessions()
	local db = E.db.dashboards.professions
	if( BuiProfessions[1] ) then
		for i = 1, getn( BuiProfessions ) do
			BuiProfessions[i]:Kill()
		end
		wipe( BuiProfessions )
		proHolder.backdrop:Hide()
	end
	
	local capRank = 700
	local prof1, prof2, archy, fishing, cooking, firstAid = GetProfessions()
	
	if (prof1 or prof2 or archy or fishing or cooking or firstAid) then
		local proftable = { GetProfessions() }

		for _, id in pairs(proftable) do
			local name, icon, rank, maxRank, _, _, _, rankModifier = GetProfessionInfo(id)

			if name and (rank < capRank or (not db.capped)) then
				if db.choosePofessions[name] == true then
					proHolder.backdrop:Show()
					proHolder:Height(((DASH_HEIGHT + SPACING) * (#BuiProfessions + 1)) + SPACING + (E.PixelMode and 0 or 2))

					local ProFrame = CreateFrame('Frame', 'Profession' .. id, proHolder)
					ProFrame:Height(DASH_HEIGHT)
					ProFrame:Width(DASH_WIDTH)
					ProFrame:Point('TOPLEFT', proHolder, 'TOPLEFT', SPACING, -SPACING)
					ProFrame:EnableMouse(true)
					
					ProFrame.dummy = CreateFrame('Frame', 'ProDummy' .. id, ProFrame)
					ProFrame.dummy:Point('BOTTOMLEFT', ProFrame, 'BOTTOMLEFT', 2, 2)
					ProFrame.dummy:Point('BOTTOMRIGHT', ProFrame, 'BOTTOMRIGHT', (E.PixelMode and -24 or -28), 0)
					ProFrame.dummy:Height(E.PixelMode and 3 or 5)

					ProFrame.dummy.dummyStatus = ProFrame.dummy:CreateTexture(nil, 'OVERLAY')
					ProFrame.dummy.dummyStatus:SetInside()
					ProFrame.dummy.dummyStatus:SetTexture(E['media'].BuiFlat)
					ProFrame.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)
					
					ProFrame.Status = CreateFrame('StatusBar', 'ProStatus' .. id, ProFrame.dummy)
					ProFrame.Status:SetStatusBarTexture(E['media'].BuiFlat)
					
					if (rankModifier and rankModifier > 0) then
						ProFrame.Status:SetMinMaxValues(1, maxRank + rankModifier)
						ProFrame.Status:SetValue(rank + rankModifier)
					else
						ProFrame.Status:SetMinMaxValues(1, maxRank)
						ProFrame.Status:SetValue(rank)
					end
					ProFrame.Status:SetStatusBarColor(E.db.dashboards.barColor.r, E.db.dashboards.barColor.g, E.db.dashboards.barColor.b)
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
						ProFrame.Text:SetText(format('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank))
					else
						ProFrame.Text:SetText(format('%s / %s', rank, maxRank))
					end
					
					if E.db.dashboards.textColor == 1 then
						ProFrame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
					else
						ProFrame.Text:SetTextColor(unpackColor(E.db.dashboards.customTextColor))
					end

					ProFrame.IconBG = CreateFrame('Button', 'ProIconBG' .. id, ProFrame)
					ProFrame.IconBG:SetTemplate('Transparent')
					ProFrame.IconBG:Size(E.PixelMode and 18 or 20)
					ProFrame.IconBG:Point('BOTTOMRIGHT', ProFrame, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)
					ProFrame.IconBG:SetScript('OnClick', function(self)
						if name ~= PROFESSIONS_FISHING then
							CastSpellByName(name)
						end
					end)

					ProFrame.IconBG.Icon = ProFrame.IconBG:CreateTexture(nil, 'ARTWORK')
					ProFrame.IconBG.Icon:SetInside()
					ProFrame.IconBG.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
					ProFrame.IconBG.Icon:SetTexture(icon)

					ProFrame:SetScript('OnEnter', function(self)
						ProFrame.Text:SetText(format('%s', name))
					end)
			
					ProFrame:SetScript('OnLeave', function(self)
						if (rankModifier and rankModifier > 0) then
							ProFrame.Text:SetText(format('%s |cFF6b8df4+%s|r / %s', rank, rankModifier, maxRank))
						else
							ProFrame.Text:SetText(format('%s / %s', rank, maxRank))
						end			
					end)
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
	self:RegisterEvent('TRADE_SKILL_UPDATE', 'UpdateProfessions')
	self:RegisterEvent('SKILL_LINES_CHANGED', 'UpdateProfessions')
	self:RegisterEvent('CHAT_MSG_SKILL', 'UpdateProfessions')
end

function BUIP:UpdatePholderDimensions()
	proHolder:Width(E.db.dashboards.professions.width)

	for _, frame in pairs(BuiProfessions) do
		frame:Width(E.db.dashboards.professions.width)
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
	hooksecurefunc(DT, 'LoadDataTexts', BUIP.UpdateProfessions)
end

E:RegisterModule(BUIP:GetName())
