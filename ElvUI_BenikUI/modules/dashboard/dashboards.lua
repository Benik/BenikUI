local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Dashboards')
local LSM = E.LSM

local CreateFrame = CreateFrame

local DASH_HEIGHT = 20
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

-- Dashboards bar frame tables
BUI.SystemDB = {}
BUI.TokensDB = {}
BUI.ProfessionsDB = {}
BUI.FactionsDB = {}

function mod:EnableDisableCombat(holder, option)
	local db = E.db.benikui.dashboards[option]

	if db.combat then
		holder:RegisterEvent('PLAYER_REGEN_DISABLED')
		holder:RegisterEvent('PLAYER_REGEN_ENABLED')
	else
		holder:UnregisterEvent('PLAYER_REGEN_DISABLED')
		holder:UnregisterEvent('PLAYER_REGEN_ENABLED')
	end
end

function mod:UpdateHolderDimensions(holder, option, tableName)
	local db = E.db.benikui.dashboards[option]
	holder:Width(db.width)

	for _, frame in pairs(tableName) do
		frame:Width(db.width)
	end
end

function mod:ToggleTransparency(holder, option)
	local db = E.db.benikui.dashboards[option]
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

	local db = E.db.benikui.dashboards[option]
	holder.backdrop.style:SetShown(db.style)
end

function mod:FontStyle(tableName)
	for _, frame in pairs(tableName) do
		if E.db.benikui.dashboards.dashfont.useDTfont then
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			frame.Text:FontTemplate(LSM:Fetch('font', E.db.benikui.dashboards.dashfont.dbfont), E.db.benikui.dashboards.dashfont.dbfontsize, E.db.benikui.dashboards.dashfont.dbfontflags)
		end
	end
end

function mod:FontColor(tableName)
	for _, frame in pairs(tableName) do
		if E.db.benikui.dashboards.textColor == 1 then
			frame.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
		else
			frame.Text:SetTextColor(BUI:unpackColor(E.db.benikui.dashboards.customTextColor))
		end
	end
end

function mod:BarColor(tableName)
	for _, frame in pairs(tableName) do
		if E.db.benikui.dashboards.barColor == 1 then
			frame.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		else
			frame.Status:SetStatusBarColor(E.db.benikui.dashboards.customBarColor.r, E.db.benikui.dashboards.customBarColor.g, E.db.benikui.dashboards.customBarColor.b)
		end
	end
end

function mod:IconPosition(tableName, dashboard)
	for _, bar in pairs(tableName) do
		if not bar.hasIcon then return end

		bar.IconBG:ClearAllPoints()
		bar.dummy:ClearAllPoints()
		if E.db.benikui.dashboards[dashboard].iconPosition == 'LEFT' then
			bar.dummy:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', -2, 0)
			bar.dummy:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', (E.PixelMode and 24 or 28), 0)
			bar.IconBG:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', (E.PixelMode and 2 or 3), -SPACING)
			bar.Text:Point('CENTER', bar, 'CENTER', 10, (E.PixelMode and -1 or -3))
		else
			bar.dummy:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', 2, 0)
			bar.dummy:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -24 or -28), 0)
			bar.IconBG:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)
			bar.Text:Point('CENTER', bar, 'CENTER', -10, (E.PixelMode and 1 or 3))
		end
	end
end

function mod:CreateDashboardHolder(holderName, option)
	local db = E.db.benikui.dashboards[option]

	local holder = CreateFrame('Frame', holderName, E.UIParent)
	holder:CreateBackdrop('Transparent')
	holder:SetFrameStrata('BACKGROUND')
	holder:SetFrameLevel(5)
	holder.backdrop:BuiStyle('Outside')
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

	E.FrameLocks[holder] = { parent = E.UIParent }

	return holder
end

function mod:CreateDashboard(barHolder, option, hasIcon)
	local bar = CreateFrame('Button', nil, barHolder)
	local barIconOffset = (hasIcon and -22) or -2

	bar:Height(DASH_HEIGHT)
	bar:Width(E.db.benikui.dashboards[option].width or 150)
	bar:Point('TOPLEFT', barHolder, 'TOPLEFT', SPACING, -SPACING)
	bar:EnableMouse(true)

	bar.dummy = CreateFrame('Frame', nil, bar, 'BackdropTemplate')
	bar.dummy:SetTemplate('Transparent', nil, true, true)
	bar.dummy:SetBackdropBorderColor(0, 0, 0, 0)
	bar.dummy:SetBackdropColor(1, 1, 1, .2)
	bar.dummy:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', 2, 0)
	bar.dummy:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (hasIcon and (E.PixelMode and -24 or -28) or -2), 0)
	bar.dummy:Height(E.PixelMode and 1 or 3)

	bar.Status = CreateFrame('StatusBar', nil, bar.dummy)
	bar.Status:SetStatusBarTexture(E.Media.Textures.White8x8)
	bar.Status:SetInside()

	bar.spark = bar.Status:CreateTexture(nil, 'OVERLAY', nil);
	bar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]]);
	bar.spark:Size(12, 6);
	bar.spark:SetBlendMode('ADD');
	bar.spark:Point('CENTER', bar.Status:GetStatusBarTexture(), 'RIGHT')

	bar.Text = bar.Status:CreateFontString(nil, 'OVERLAY')
	bar.Text:FontTemplate()
	bar.Text:Point('CENTER', bar, 'CENTER', (hasIcon and -10) or 0, (E.PixelMode and 1 or 3))
	bar.Text:Width(bar:GetWidth() + barIconOffset)
	bar.Text:SetWordWrap(false)

	if hasIcon then
		bar.IconBG = CreateFrame('Button', nil, bar, 'BackdropTemplate')
		bar.IconBG:SetTemplate('Transparent')
		bar.IconBG:Size(E.PixelMode and 18 or 20, E.PixelMode and 18 or 20)
		bar.IconBG:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)

		bar.IconBG.Icon = bar.IconBG:CreateTexture(nil, 'ARTWORK')
		bar.IconBG.Icon:SetInside()
		bar.IconBG.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		bar.hasIcon = hasIcon
	end

	return bar
end

function mod:Initialize()
	mod:LoadSystem()
	mod:LoadProfessions()
	mod:LoadTokens()
	mod:LoadReputations()
end

BUI:RegisterModule(mod:GetName())
