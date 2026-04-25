local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Widgetbars')
local LSM = E.LSM;

local _G = _G
local floor = floor
local unpack = unpack
local ipairs = ipairs

local CreateFrame = CreateFrame
local GameTooltip_Hide = GameTooltip_Hide
local SplitTextIntoHeaderAndNonHeader = SplitTextIntoHeaderAndNonHeader
local C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo
local C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo = C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo
local GameTooltip = GameTooltip
local GARRISON_TIER = GARRISON_TIER

local maxValue = 1000
local function GetMawBarValue()
	local widgetInfo = C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo(2885)
	if widgetInfo and widgetInfo.shownState ~= 0 then
		local value = widgetInfo.progressVal
		return floor(value / maxValue), value % maxValue
	end
end

local MawTierColor = {
	[0] = {.6, .8, 1},
	[1] = {0, .7, .3},
	[2] = {0, 1, 0},
	[3] = {1, .8, 0},
	[4] = {1, .5, 0},
	[5] = {1, 0, 0}
}

local function FindBlizzardMawFrame()
	local container = _G.UIWidgetTopCenterContainerFrame
	if not container then return end
	for _, child in ipairs({container:GetChildren()}) do
		if child.widgetID == 2885 then
			return child
		end
	end
end

mod.mawPreviewActive = false

function mod:MawBar_Preview()
	local bar = _G.BUIMawBar
	if not bar then return end

	mod.mawPreviewActive = not mod.mawPreviewActive

	if mod.mawPreviewActive then
		bar:SetValue(250)
		bar:SetStatusBarColor(unpack(MawTierColor[3]))
		bar.text:SetFormattedText('%s:  %s - %s%%', GARRISON_TIER, 3, 25)
		bar:Show()
	else
		mod.mawPreviewActive = false
	end
	mod:MawBar_Update()
end

function mod:MawBar_Update()
	local bar = _G.BUIMawBar
	if not bar then return end

	local db = E.db.benikui.widgetbars.mawBar
	if not db then return end

	local blizzFrame = FindBlizzardMawFrame()
	local tier, value = GetMawBarValue()
	local displayState = tier or (mod.mawPreviewActive and 3)

	if displayState then
		bar:Size(db.width, db.height)

		if db.barAutoColor then
			bar:SetStatusBarColor(unpack(MawTierColor[displayState]))
		else
			bar:SetStatusBarColor(db.barColor.r, db.barColor.g, db.barColor.b, db.barColor.a)
		end

		bar.text:SetTextColor(db.textColor.r, db.textColor.g, db.textColor.b)
		bar.text:Point('CENTER', 0, db.textYoffset or 0)
		bar.text:FontTemplate(LSM:Fetch('font', db.useDTfont and E.db.datatexts.font or db.font), db.useDTfont and E.db.datatexts.fontSize or db.fontsize, db.useDTfont and E.db.datatexts.fontOutline or db.fontflags)

		if db.textFormat == 'PERCENT' then
			if displayState == 5 then
				bar.text:SetFormattedText('%s: %s', GARRISON_TIER, displayState)
			else
				bar.text:SetFormattedText('%s:  %s - %s%%', GARRISON_TIER, displayState, floor((value or 0) / maxValue * 100))
			end
		else
			bar.text:SetText('')
		end

		bar:SetValue(displayState == 5 and maxValue or (value or floor(displayState / 5 * maxValue)))
		bar:Show()

		if blizzFrame and blizzFrame:IsShown() then blizzFrame:Hide() end
	else
		bar:Hide()
	end
end

function mod:LoadMaw()
	if E.db.benikui.widgetbars.mawBar.enable ~= true then return end

	local bar = CreateFrame("StatusBar", "BUIMawBar", E.UIParent)
	bar:SetPoint("TOP", 0, -175)
	bar:SetSize(200, 20)
	bar:SetMinMaxValues(0, maxValue)
	bar:CreateBackdrop('Transparent')

	if E.db.benikui.general.shadows then
		bar.backdrop:CreateSoftShadow()
	end

	bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar)

	bar.text = bar:CreateFontString(nil, 'OVERLAY')
	bar.text:FontTemplate()
	bar.text:Point('CENTER')

	E:CreateMover(bar, "BUIMawBarMover", L['BenikUI Maw Bar'], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,widgetbars,mawBar')

	bar:SetScript("OnEnter", function(self)
		local rank = GetMawBarValue()
		local widgetInfo = rank and C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo(2873 + rank)
		if widgetInfo and widgetInfo.shownState ~= 0 then
			GameTooltip:SetOwner(self, "ANCHOR_BOTTOM", 0, -10)
			local header, nonHeader = SplitTextIntoHeaderAndNonHeader(widgetInfo.tooltip)
			if header then
				GameTooltip:AddLine(header, nil, nil, nil, 1)
			end
			if nonHeader then
				GameTooltip:AddLine(nonHeader, nil, nil, nil, 1)
			end
			GameTooltip:Show()
		end
	end)

	bar:SetScript("OnLeave", GameTooltip_Hide)

	mod:MawBar_Update()
	mod:RegisterEvent("PLAYER_ENTERING_WORLD", mod.MawBar_Update)
	mod:RegisterEvent("UPDATE_UI_WIDGET", mod.MawBar_Update)
end
