local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Databars');
local DB = E:GetModule('DataBars');
local LSM = E.LSM;

local _G = _G
local floor = floor

local CreateFrame = CreateFrame
local SplitTextIntoHeaderAndNonHeader = SplitTextIntoHeaderAndNonHeader
local C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo = C_UIWidgetManager.GetDiscreteProgressStepsVisualizationInfo
local C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo = C_UIWidgetManager.GetTextureWithAnimationVisualizationInfo
local GameTooltip = GameTooltip
local GARRISON_TIER = GARRISON_TIER

local maxValue = 1000
local function GetMawBarValue()
	local widgetInfo = C_UIWidgetManager_GetDiscreteProgressStepsVisualizationInfo(2885)
	if widgetInfo and widgetInfo.shownState == 1 then
		local value = widgetInfo.progressVal
		return floor(value / maxValue), value % maxValue
	end
end

function mod:MawBar_Update()
	local bar = _G.BUIMawBar
	local tier, value = GetMawBarValue()
	local db = E.db.benikuiDatabars.mawBar
	if not db then return end

	if tier then
		bar:SetSize(db.width, db.height)
		bar:SetStatusBarColor(db.barColor.r, db.barColor.g, db.barColor.b, db.barColor.a)
		bar.text:SetTextColor(db.textColor.r, db.textColor.g, db.textColor.b)
		bar.text:Point('CENTER', 0, db.textYoffset or 0)

		if db.useDTfont then
			bar.text:FontTemplate(LSM:Fetch('font', E.db.datatexts.font), E.db.datatexts.fontSize, E.db.datatexts.fontOutline)
		else
			bar.text:FontTemplate(LSM:Fetch('font', db.font), db.fontsize, db.fontflags)
		end
		
		if db.textFormat == 'PERCENT' then
			if tier == 5 then
				bar.text:SetFormattedText('%s: %s', GARRISON_TIER, tier)
			else
				bar.text:SetFormattedText('%s:  %s - %s%%', GARRISON_TIER, tier, floor(value/maxValue * 100))
			end
		else
			bar.text:SetText('')
		end

		bar:SetValue(value)
		bar:Show()
		_G.UIWidgetTopCenterContainerFrame:Hide()
	else
		bar:Hide()
		_G.UIWidgetTopCenterContainerFrame:Show()
	end
end

function mod:LoadMaw()
	if E.db.benikuiDatabars.mawBar.enable ~= true then return end

	local bar = CreateFrame("StatusBar", "BUIMawBar", E.UIParent)
	bar:SetPoint("TOP", 0, -175)
	bar:SetSize(200, 20)
	bar:SetMinMaxValues(0, maxValue)
	bar:CreateBackdrop('Transparent')
	if BUI.ShadowMode then
		bar.backdrop:CreateSoftShadow()
	end
	
	bar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar)

	bar.text = bar:CreateFontString(nil, 'OVERLAY')
	bar.text:FontTemplate()
	bar.text:Point('CENTER')

	E:CreateMover(bar, "BUIMawBarMover", L["BenikUI Maw Bar"], nil, nil, nil, 'ALL,BENIKUI', nil, 'benikui,benikuiDatabars,mawBar')

	bar:SetScript("OnEnter", function(self)
		local rank = GetMawBarValue()
		local widgetInfo = rank and C_UIWidgetManager_GetTextureWithAnimationVisualizationInfo(2873 + rank)
		if widgetInfo and widgetInfo.shownState == 1 then
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