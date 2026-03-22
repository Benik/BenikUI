local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Widgetbars')
local LSM = E.LSM
local _G = _G

local ipairs = ipairs

local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local GameTooltip_Hide = GameTooltip_Hide

local C_UIWidgetManager_GetPowerBarWidgetSetID = C_UIWidgetManager.GetPowerBarWidgetSetID
local C_UIWidgetManager_GetAllWidgetsBySetID = C_UIWidgetManager.GetAllWidgetsBySetID
local C_UIWidgetManager_GetPreyHuntProgressWidgetVisualizationInfo = C_UIWidgetManager.GetPreyHuntProgressWidgetVisualizationInfo

local PreyStateColor = {
	[Enum.PreyHuntProgressState.Cold] = {0.4,  0.75, 1.0 },
	[Enum.PreyHuntProgressState.Warm] = {1.0,  0.85, 0.1 },
	[Enum.PreyHuntProgressState.Hot] = {1.0,  0.45, 0.0 },
	[Enum.PreyHuntProgressState.Final] = {1.0,  0.0,  0.0 },
}

local PreyStateLabel = {
	[Enum.PreyHuntProgressState.Cold] = 'Cold',
	[Enum.PreyHuntProgressState.Warm] = 'Warm',
	[Enum.PreyHuntProgressState.Hot] = 'Hot',
	[Enum.PreyHuntProgressState.Final] = 'Final',
}

local PreyStateStep = {
	[Enum.PreyHuntProgressState.Cold] = 1,
	[Enum.PreyHuntProgressState.Warm] = 2,
	[Enum.PreyHuntProgressState.Hot] = 3,
	[Enum.PreyHuntProgressState.Final] = 4,
}

local PREY_MAX_VALUE = 4
local activePreyWidgetID = nil

local function ScanForPreyWidget()
	local setID = C_UIWidgetManager_GetPowerBarWidgetSetID and C_UIWidgetManager_GetPowerBarWidgetSetID()
	if not setID then return end

	local widgets = C_UIWidgetManager_GetAllWidgetsBySetID(setID)
	if not widgets then return end

	local targetType = Enum.UIWidgetVisualizationType.PreyHuntProgress
	for _, widgetInfo in ipairs(widgets) do
		if widgetInfo.widgetType == targetType then
			activePreyWidgetID = widgetInfo.widgetID
			return true
		end
	end
end

-- this will grab the Prey widget (.progressState) to hide/show.
-- should add a similar thingy in the Maw bar
local function FindBlizzardPreyFrame()
	local container = _G.UIWidgetPowerBarContainerFrame
	if not container then return end

	for _, child in ipairs({container:GetChildren()}) do
		if child.progressState ~= nil then
			return child
		end
	end
end

local function GetPreyBarState()
	if not activePreyWidgetID then return end

	local widgetInfo = C_UIWidgetManager_GetPreyHuntProgressWidgetVisualizationInfo(activePreyWidgetID)
	if widgetInfo and widgetInfo.shownState ~= Enum.WidgetShownState.Hidden then
		return widgetInfo.progressState, widgetInfo.tooltip
	end
end

function mod:PreyBar_Update()
	local bar = _G.BUIPreyBar
	if not bar then return end

	local db = E.db.benikui.widgetbars.preyBar
	if not db then return end

	local blizzFrame = FindBlizzardPreyFrame()

	local state = GetPreyBarState()

	if state then
		bar:SetSize(db.width, db.height)

		local color = PreyStateColor[state] or {0.5, 0.5, 0.5}
		bar:SetStatusBarColor(unpack(color))

		bar.text:SetTextColor(1, 1, 1)
		bar.text:Point('CENTER', 0, db.textYoffset or 0)

		if db.useDTfont then
			bar.text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			bar.text:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
		end

		bar.text:SetFormattedText('Prey: %s', PreyStateLabel[state] or '')

		bar:SetValue(PreyStateStep[state] or 0)

		if blizzFrame then blizzFrame:Hide() end
		bar:Show()
	else
		if blizzFrame then blizzFrame:Show() end
		bar:Hide()
	end
end

function mod:LoadPrey()
	local db = E.db.benikui.widgetbars.preyBar
	if not db then return end
	if db.enable ~= true then return end

	local bar = CreateFrame("StatusBar", "BUIPreyBar", E.UIParent)
	bar:Point("TOP", 0, -150)
	bar:Size(db.width or 200, db.height or 20)
	bar:SetMinMaxValues(0, PREY_MAX_VALUE)
	bar:CreateBackdrop('Transparent')

	if E.db.benikui.general.shadows then
		bar.backdrop:CreateSoftShadow()
	end

	bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar)

	bar.text = bar:CreateFontString(nil, 'OVERLAY')
	bar.text:FontTemplate()
	bar.text:Point('CENTER', 0, db.textYoffset or 0)

	E:CreateMover(bar, "BUIPreyBarMover", L['BenikUI Prey Bar'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,widgetbars,preyBar')

	bar:SetScript("OnEnter", function(self)
		local state, tooltipText = GetPreyBarState()
		if state and tooltipText and tooltipText ~= '' then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -10)
			GameTooltip:AddLine(tooltipText, 1, 1, 1, true)
			GameTooltip:Show()
		end
	end)

	bar:SetScript("OnLeave", GameTooltip_Hide)

	-- needed to grab the widget
	local eventFrame = CreateFrame("Frame")
	eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	eventFrame:RegisterEvent("UPDATE_UI_WIDGET")
	eventFrame:RegisterEvent("UPDATE_ALL_UI_WIDGETS")

	eventFrame:SetScript("OnEvent", function(_, event, info)
		if event == "PLAYER_ENTERING_WORLD" then
			activePreyWidgetID = nil
			ScanForPreyWidget()
			mod:PreyBar_Update()
		elseif event == "UPDATE_ALL_UI_WIDGETS" then
			ScanForPreyWidget()
			mod:PreyBar_Update()
		elseif event == "UPDATE_UI_WIDGET" then
			if not activePreyWidgetID then
				ScanForPreyWidget()
			end
			mod:PreyBar_Update()
		end
	end)

	ScanForPreyWidget()
	mod:PreyBar_Update()
end