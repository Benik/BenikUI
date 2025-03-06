local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Dashboards')
local LSM = E.LSM

local CreateFrame = CreateFrame

local DASH_HEIGHT = 20
local SPACING = 1

local classColor = E:ClassColor(E.myclass, true)

-- Dashboards bar frame tables
mod.SystemDB = {}
mod.TokensDB = {}
mod.ProfessionsDB = {}
mod.FactionsDB = {}
mod.ItemsDB = {}

local Dashboards = {
	{'BUI_ReputationsDashboard', 'reputations'},
	{'BUI_SystemDashboard', 'system'},
	{'BUI_ProfessionsDashboard', 'professions'},
	{'BUI_TokensDashboard', 'tokens'},
}

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

function mod:UpdateHolderDimensions(holder, option, tableName, isSystem)
	local db = E.db.benikui.dashboards[option]
	if isSystem and db.orientation == 'RIGHT' then
		holder:Width(db.width * (#mod.SystemDB) + ((#mod.SystemDB -1) *db.spacing))
	else
		holder:Width(db.width)
	end

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
	local db = E.db.benikui.dashboards.dashfont
	for _, bar in pairs(tableName) do
		if E.db.benikui.dashboards.dashfont.useDTfont then
			bar.Text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			bar.Text:FontTemplate(LSM:Fetch('font', db.dbfont), db.dbfontsize, db.dbfontflags)
		end
	end
end

function mod:FontColor(tableName)
	local db = E.db.benikui.dashboards
	for _, bar in pairs(tableName) do
		if db.textColor == 1 then
			bar.Text:SetTextColor(classColor.r, classColor.g, classColor.b)
		else
			bar.Text:SetTextColor(BUI:unpackColor(db.customTextColor))
		end
	end
end

function mod:BarColor(tableName)
	local db = E.db.benikui.dashboards
	for _, bar in pairs(tableName) do
		if db.barColor == 1 then
			bar.Status:SetStatusBarColor(classColor.r, classColor.g, classColor.b)
		else
			bar.Status:SetStatusBarColor(db.customBarColor.r, db.customBarColor.g, db.customBarColor.b)
		end
	end
end

function mod:BarHeight(option, tableName)
	local db = E.db.benikui.dashboards[option]
	for _, bar in pairs(tableName) do
		bar.dummy:Height(db.barHeight)
		bar.spark:Height(5 + db.barHeight)
	end
end

function mod:UpdateVisibility()
	for i, v in ipairs(Dashboards) do
		local holder, option = unpack(v)
		local db = E.db.benikui.dashboards[option]
		local inInstance = IsInInstance()
		local NotinInstance = not (db.instance and inInstance)

		if _G[holder] then
			_G[holder]:SetShown(NotinInstance)
		end
	end
end

function mod:IconPosition(tableName, dashboard)
	for _, bar in pairs(tableName) do
		if not bar.hasIcon then return end

		bar.IconBG:ClearAllPoints()
		bar.dummy:ClearAllPoints()
		if bar.awicon then bar.awicon:ClearAllPoints() end
		if E.db.benikui.dashboards[dashboard].iconPosition == 'LEFT' then
			bar.dummy:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', -2, 0)
			bar.dummy:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', (E.PixelMode and 24 or 28), 0)
			bar.IconBG:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', (E.PixelMode and 2 or 3), -SPACING)
			bar.Text:Point('CENTER', bar, 'CENTER', 10, (E.PixelMode and -1 or -3))
			if bar.awicon then bar.awicon:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING) end
		else
			bar.dummy:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', 2, 0)
			bar.dummy:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -24 or -28), 0)
			bar.IconBG:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)
			bar.Text:Point('CENTER', bar, 'CENTER', -10, (E.PixelMode and 1 or 3))
			if bar.awicon then bar.awicon:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', (E.PixelMode and 2 or 3), -SPACING) end
		end
	end
end

function mod:CheckPositionForTooltip(frame)
	if not frame then return end

	local x = frame:GetCenter()
	if not x then return end

	local position, Xoffset

	if x > (E.screenWidth * 0.5) then
		position = 'ANCHOR_LEFT'
		Xoffset = BUI.ShadowMode and -3 or 0
	else
		position = 'ANCHOR_RIGHT'
		Xoffset = BUI.ShadowMode and 3 or 0
	end

	return position, Xoffset
end

function mod:CreateDashboardHolder(holderName, option)
	local db = E.db.benikui.dashboards[option]

	local holder = CreateFrame('Frame', holderName, E.UIParent)
	holder:CreateBackdrop('Transparent')
	holder:SetFrameStrata('BACKGROUND')
	holder:SetFrameLevel(5)
	holder.backdrop:BuiStyle('Outside')
	holder:Hide()

	holder:SetScript('OnEvent', function(self, event)
		local inInstance = IsInInstance()
		if (db.instance and inInstance) then return end
	
		if db.combat then
			if event == 'PLAYER_REGEN_DISABLED' then
				UIFrameFadeOut(self, 0.2, self:GetAlpha(), 0)
			elseif event == 'PLAYER_REGEN_ENABLED' then
				UIFrameFadeIn(self, 0.2, self:GetAlpha(), 1)
				self:Show()
			end
		end
	end)

	mod:EnableDisableCombat(holder, option)

	E.FrameLocks[holder] = { parent = E.UIParent }

	return holder
end

function mod:CreateDashboard(barHolder, option, hasIcon, isRep, isToken)
	local bar = CreateFrame('Button', nil, barHolder)
	local barIconOffset = (hasIcon and -22) or -2
	local db = E.db.benikui.dashboards[option]

	bar:Height(DASH_HEIGHT)
	bar:Width(db.width or 150)
	bar:Point('TOPLEFT', barHolder, 'TOPLEFT', SPACING, -SPACING)
	bar:EnableMouse(true)

	bar.dummy = CreateFrame('Frame', nil, bar)
	bar.dummy:SetTemplate('Transparent', nil, true, true)
	bar.dummy:SetBackdropBorderColor(0, 0, 0, 0)
	bar.dummy:SetBackdropColor(1, 1, 1, .2)
	bar.dummy:Point('BOTTOMLEFT', bar, 'BOTTOMLEFT', 2, 0)
	bar.dummy:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (hasIcon and (E.PixelMode and -24 or -28) or -2), 0)
	bar.dummy:Height(db.barHeight or (E.PixelMode and 1 or 3))

	bar.Status = CreateFrame('StatusBar', nil, bar.dummy)
	bar.Status:SetStatusBarTexture(E.Media.Textures.White8x8)
	bar.Status:SetAllPoints()

	bar.spark = bar.Status:CreateTexture(nil, 'OVERLAY', nil)
	bar.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
	bar.spark:Size(12, ((db.barHeight + 5) or 6))
	bar.spark:SetBlendMode('ADD')
	bar.spark:Point('CENTER', bar.Status:GetStatusBarTexture(), 'RIGHT')

	bar.Text = bar.Status:CreateFontString(nil, 'OVERLAY')
	bar.Text:FontTemplate()
	bar.Text:Point('CENTER', bar, 'CENTER', (hasIcon and -10) or 0, (E.PixelMode and 1 or 3))
	bar.Text:Width(bar:GetWidth() + barIconOffset)
	bar.Text:SetWordWrap(false)

	if hasIcon then
		bar.IconBG = CreateFrame('Button', nil, bar)
		bar.IconBG:SetTemplate('Transparent')
		bar.IconBG:Size(E.PixelMode and 18 or 20, E.PixelMode and 18 or 20)
		bar.IconBG:Point('BOTTOMRIGHT', bar, 'BOTTOMRIGHT', (E.PixelMode and -2 or -3), SPACING)

		bar.IconBG.Icon = bar.IconBG:CreateTexture(nil, 'ARTWORK')
		bar.IconBG.Icon:SetInside()
		bar.IconBG.Icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		bar.IconBG:EnableMouse(false)
		bar.hasIcon = hasIcon
	end

	if isRep then
		bar.bag = bar:CreateTexture(nil, 'ARTWORK')
		bar.bag:SetAtlas("ParagonReputation_Bag")
		bar.bag:Size(12, 16)
		bar.bag:Point('RIGHT', bar, 'RIGHT', -4, 0)

		bar.bagGlow = bar:CreateTexture(nil, 'BACKGROUND')
		bar.bagGlow:SetAtlas("ParagonReputation_Glow")
		bar.bagGlow:Size(32, 32)
		bar.bagGlow:Point('CENTER', bar.bag, 'CENTER')
		bar.bagGlow:SetAlpha(0.6)
		bar.bagGlow:SetBlendMode('ADD')

		bar.bagCheck = bar:CreateTexture(nil, 'OVERLAY')
		bar.bagCheck:SetAtlas("ParagonReputation_Checkmark", true)
		bar.bagCheck:Point('CENTER', bar.bag, 'CENTER', 5, -4)

		bar.isRep = isRep
	end

	if isToken then
		bar.awicon = bar:CreateTexture(nil, 'ARTWORK')
		bar.awicon:SetAtlas("warbands-transferable-icon")
		bar.awicon:Size(12, 16)
		bar.awicon:Point('RIGHT', bar, 'RIGHT', -4, 0)

		bar.isToken = isToken
	end

	return bar
end

local function ConvertDB()
	if E.db.benikui.dashboards.DashboardDBConverted == nil then
		if E.db.benikui.dashboards.enableSystem ~= nil then
			E.db.benikui.dashboards.system.enable = E.db.benikui.dashboards.enableSystem
			E.db.benikui.dashboards.enableSystem = nil
		end
		if E.db.benikui.dashboards.enableProfessions ~= nil then
			E.db.benikui.dashboards.professions.enable = E.db.benikui.dashboards.enableProfessions
			E.db.benikui.dashboards.enableProfessions = nil
		end
		if E.db.benikui.dashboards.enableTokens ~= nil then
			E.db.benikui.dashboards.tokens.enable = E.db.benikui.dashboards.enableTokens
			E.db.benikui.dashboards.enableTokens = nil
		end
		if E.db.benikui.dashboards.enableReputations ~= nil then
			E.db.benikui.dashboards.reputations.enable = E.db.benikui.dashboards.enableReputations
			E.db.benikui.dashboards.enableReputations = nil
		end
		E.db.benikui.dashboards.DashboardDBConverted = BUI.Version
	end
end

function mod:Initialize()
	ConvertDB()
	mod:LoadSystem()
	mod:LoadProfessions()
	mod:LoadTokens()
	mod:LoadReputations()
	mod:LoadItems()

	mod:RegisterEvent('PLAYER_ENTERING_WORLD', 'UpdateVisibility')
end

BUI:RegisterModule(mod:GetName())