local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BTT = E:NewModule('BenikUI_Tooltip');
local TT = E:GetModule('Tooltip');

local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: hooksecurefunc

local ttr, ttg, ttb = 0, 0, 0

local function StyleTooltip()
	GameTooltip:Style('Outside')
	GameTooltip.style:SetClampedToScreen(true)

	-- Grab the style color
	local r, g, b = GameTooltip.style:GetBackdropColor()
	ttr, ttg, ttb = r, g, b

	GameTooltipStatusBar:SetFrameLevel(GameTooltip.style:GetFrameLevel() +2)

	-- FreebTip support
	if IsAddOnLoaded('FreebTip') then
		GameTooltip.style:ClearAllPoints()
		GameTooltip.style:Point('TOPLEFT', GameTooltip, 'TOPLEFT', (E.PixelMode and 1 or 0), (E.PixelMode and -1 or 7))
		GameTooltip.style:Point('BOTTOMRIGHT', GameTooltip, 'TOPRIGHT', (E.PixelMode and -1 or 0), (E.PixelMode and -6 or 1))
	end

	if not BUI.ShadowMode then return end

	if not GameTooltipStatusBar.backdrop.shadow then
		GameTooltipStatusBar.backdrop:CreateSoftShadow()
	end
end

local function RecolorTooltipStyle()
	local r, g, b = 0, 0, 0

	if GameTooltipStatusBar:IsShown() then
		r, g, b = GameTooltipStatusBar:GetStatusBarColor()	
	else
		r, g, b = ttr, ttg, ttb
	end
	GameTooltip.style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
end

function BTT:Initialize()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tooltip ~= true then return end
	if E.db.benikui.general.benikuiStyle ~= true then return end
	StyleTooltip()
	hooksecurefunc(TT, "SetUnitAura", RecolorTooltipStyle)
	hooksecurefunc(TT, "GameTooltip_OnTooltipSetSpell", RecolorTooltipStyle)
	hooksecurefunc(TT, "GameTooltip_OnTooltipCleared", RecolorTooltipStyle)
	hooksecurefunc(TT, "GameTooltip_OnTooltipSetItem", RecolorTooltipStyle)
	hooksecurefunc(TT, "GameTooltip_OnTooltipSetUnit", RecolorTooltipStyle)
	hooksecurefunc(TT, "GameTooltipStatusBar_OnValueChanged", RecolorTooltipStyle)
end

local function InitializeCallback()
	BTT:Initialize()
end

E:RegisterModule(BTT:GetName(), InitializeCallback)