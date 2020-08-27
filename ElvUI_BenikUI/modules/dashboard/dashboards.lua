local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('Dashboards', 'AceEvent-3.0', 'AceHook-3.0')
local LSM = E.LSM

local CreateFrame = CreateFrame

local DASH_HEIGHT = 20
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

-- Dashboards bar frame tables
BUI.SystemDB = {}
BUI.TokensDB = {}
BUI.ProfessionsDB = {}

function mod:EnableDisableCombat(holder, option)
	local db = E.db.dashboards[option]

	if db.combat then
		holder:RegisterEvent('PLAYER_REGEN_DISABLED')
		holder:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		holder:UnregisterEvent('PLAYER_REGEN_DISABLED')
		holder:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end

function mod:UpdateHolderDimensions(holder, option, tableName)
	local db = E.db.dashboards[option]
	holder:SetWidth(db.width)

	for _, frame in pairs(tableName) do
		frame:SetWidth(db.width)
	end
end

function mod:ToggleTransparency(holder, option)
	local db = E.db.dashboards[option]
	if not db.backdrop then
		holder.backdrop:SetTemplate("NoBackdrop")
		if holder.backdrop.shadow then
			holder.backdrop.shadow:Hide()
		end
	elseif db.transparency then
		holder.backdrop:SetTemplate("Transparent")
		if holder.backdrop.shadow then
			holder.backdrop.shadow:Show()
		end
	else
		holder.backdrop:SetTemplate("Default", true)
		if holder.backdrop.shadow then
			holder.backdrop.shadow:Show()
		end
	end
end

function mod:ToggleStyle(holder, option)
	if E.db.benikui.general.benikuiStyle ~= true then return end

	local db = E.db.dashboards[option]
	if db.style then
		holder.backdrop.style:Show()
	else
		holder.backdrop.style:Hide()
	end
end

function mod:FontStyle(tableName)
	for _, frame in pairs(tableName) do
		if E.db.dashboards.dashfont.useDTfont then
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.dashboards.dashfont.dbfont), E.db.dashboards.dashfont.dbfontsize, E.db.dashboards.dashfont.dbfontflags)
		end
	end
end

function mod:FontColor(tableName)
	for _, frame in pairs(tableName) do
		if E.db.dashboards.textColor == 1 then
			frame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
		else
			frame.Text:SetTextColor(BUI:unpackColor(E.db.dashboards.customTextColor))
		end
	end
end

function mod:BarColor(tableName)
	for _, frame in pairs(tableName) do
		if E.db.dashboards.barColor == 1 then
			frame.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		else
			frame.Status:SetStatusBarColor(E.db.dashboards.customBarColor.r, E.db.dashboards.customBarColor.g, E.db.dashboards.customBarColor.b)
		end
	end
end

function mod:CreateDashboardHolder(holderName, option)
	local db = E.db.dashboards[option]

	local holder = CreateFrame('Frame', holderName, E.UIParent)
	holder:CreateBackdrop('Transparent')
	holder:SetFrameStrata('BACKGROUND')
	holder:SetFrameLevel(5)
	holder.backdrop:Style('Outside')
	holder:Hide()

	if db.combat then
		holder:SetScript('OnEvent',function(self, event)
			if event == 'PLAYER_REGEN_DISABLED' then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
				--self.fadeInfo.finishedFunc = mod.holderOnFade
			elseif event == 'PLAYER_REGEN_ENABLED' then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end
		end)
	end
	mod:EnableDisableCombat(holder, option)

	E.FrameLocks[holder] = true;

	return holder
end

function mod:CreateDashboard(name, barHolder, option)
	local bar = CreateFrame('Button', nil, barHolder)
	bar:SetHeight(DASH_HEIGHT)
	bar:SetWidth(E.db.dashboards[option].width or 150)
	bar:SetPoint('TOPLEFT', barHolder, 'TOPLEFT', SPACING, -SPACING)
	bar:EnableMouse(true)

	bar.dummy = CreateFrame('Frame', nil, bar)
	bar.dummy:SetPoint('BOTTOMLEFT', bar, 'BOTTOMLEFT', 2, (E.PixelMode and 2 or 0))
	bar.dummy:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -24 or -28), 0)
	bar.dummy:SetHeight(E.PixelMode and 3 or 5)

	bar.dummy.dummyStatus = bar.dummy:CreateTexture(nil, 'OVERLAY')
	bar.dummy.dummyStatus:SetInside()
	bar.dummy.dummyStatus:SetTexture(E['media'].BuiFlat)
	bar.dummy.dummyStatus:SetVertexColor(1, 1, 1, .2)

	bar.Status = CreateFrame('StatusBar', nil, bar.dummy)
	bar.Status:SetStatusBarTexture(E['media'].BuiFlat)
	bar.Status:SetInside()

	bar.spark = bar.Status:CreateTexture(nil, 'OVERLAY', nil);
	bar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
	bar.spark:SetSize(12, 6);
	bar.spark:SetBlendMode('ADD');
	bar.spark:SetPoint('CENTER', bar.Status:GetStatusBarTexture(), 'RIGHT')

	bar.Text = bar.Status:CreateFontString(nil, 'OVERLAY')
	bar.Text:FontTemplate()
	bar.Text:SetPoint('CENTER', bar, 'CENTER', -10, (E.PixelMode and 1 or 3))
	bar.Text:SetWidth(bar:GetWidth() - 20)
	bar.Text:SetWordWrap(false)

	bar.IconBG = CreateFrame('Button', nil, bar)
	bar.IconBG:SetTemplate('Transparent')
	bar.IconBG:SetSize(E.PixelMode and 18 or 20, E.PixelMode and 18 or 20)
	bar.IconBG:SetPoint('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)

	bar.IconBG.Icon = bar.IconBG:CreateTexture(nil, 'ARTWORK')
	bar.IconBG.Icon:SetInside()
	bar.IconBG.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

	return bar
end

function mod:Initialize()
	mod:LoadSystem()
	mod:LoadProfessions()
	mod:LoadTokens()
end

BUI:RegisterModule(mod:GetName())