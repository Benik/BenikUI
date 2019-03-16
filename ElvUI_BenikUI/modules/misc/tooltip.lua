local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local BTT = E:NewModule('BenikUI_Tooltip', 'AceHook-3.0');
local TT = E:GetModule('Tooltip');

local GameTooltip, GameTooltipStatusBar = _G["GameTooltip"], _G["GameTooltipStatusBar"]
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: hooksecurefunc

local function StyleTooltip()
	GameTooltip:Style('Outside')
	GameTooltip.style:SetClampedToScreen(true)

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

local ttr, ttg, ttb = 0, 0, 0
function BTT:CheckTooltipStyleColor()
	local r, g, b = GameTooltip.style.pixelBorders.CENTER:GetVertexColor()
	ttr, ttg, ttb = r, g, b
end

function BTT:RecolorTooltipStyle()
	local r, g, b = 0, 0, 0

	if GameTooltipStatusBar:IsShown() then
		r, g, b = GameTooltipStatusBar:GetStatusBarColor()	
	else
		r, g, b = ttr, ttg, ttb
	end
	if (r and g and b) then
		GameTooltip.style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
	end
end

function BTT:Initialize()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tooltip ~= true then return end
	if E.db.benikui.general.benikuiStyle ~= true then return end

	StyleTooltip()

	BTT:CheckTooltipStyleColor()
	BTT:SecureHookScript(GameTooltip, 'OnUpdate', 'RecolorTooltipStyle')
end

local function InitializeCallback()
	BTT:Initialize()
end

E:RegisterModule(BTT:GetName(), InitializeCallback)