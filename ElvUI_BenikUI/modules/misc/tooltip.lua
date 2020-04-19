local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:NewModule('Tooltip', 'AceHook-3.0');
local TT = E:GetModule('Tooltip')

local _G = _G
local GameTooltip, GameTooltipStatusBar = _G.GameTooltip, _G.GameTooltipStatusBar
local IsAddOnLoaded = IsAddOnLoaded

-- GLOBALS: hooksecurefunc

local function StyleTooltip()
	if GameTooltip.style then return end
	GameTooltip:Style('Outside')
	GameTooltip.style:SetClampedToScreen(true)

	GameTooltipStatusBar:SetFrameLevel(GameTooltip.style:GetFrameLevel() +2)

	-- FreebTip support
	if IsAddOnLoaded('FreebTip') then
		GameTooltip.style:ClearAllPoints()
		GameTooltip.style:Point('TOPLEFT', GameTooltip, 'TOPLEFT', (E.PixelMode and 1 or 0), (E.PixelMode and -1 or 7))
		GameTooltip.style:Point('BOTTOMRIGHT', GameTooltip, 'TOPRIGHT', (E.PixelMode and -1 or 0), (E.PixelMode and -6 or 1))
	end
end

local ttr, ttg, ttb = 0, 0, 0
function mod:CheckTooltipStyleColor()
	local r, g, b = GameTooltip.style.pixelBorders.CENTER:GetVertexColor()
	ttr, ttg, ttb = r, g, b
end

function mod:GameTooltip_OnTooltipCleared(tt)
	if tt:IsForbidden() then return end
	tt.buiUpdated = nil
end

function mod:RecolorTooltipStyle()
	if not GameTooltip.buiUpdated then
		local r, g, b = 0, 0, 0

		if GameTooltipStatusBar:IsShown() then
			r, g, b = GameTooltipStatusBar:GetStatusBarColor()	
		else
			r, g, b = ttr, ttg, ttb
		end

		if (r and g and b) then
			GameTooltip.style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
		end

		GameTooltip.buiUpdated = true
	end
end

function mod:SetupStyleAndShadow(tt)
	if tt.style then
		if tt.StatusBar.anchoredToTop or E.db.benikui.general.hideStyle then
			tt.style:Hide()
		else
			tt.style:Show()
		end
	end

	if BUI.ShadowMode then
		if not tt.StatusBar.backdrop.shadow then
			tt.StatusBar.backdrop:CreateSoftShadow()
		end
	end
end

function mod:Initialize()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tooltip ~= true then return end
	if E.db.benikui.general.benikuiStyle ~= true then return end
	if BUI:IsAddOnEnabled('TinyTooltip') then return end

	StyleTooltip()

	mod:CheckTooltipStyleColor()
	mod:SecureHookScript(GameTooltip, 'OnTooltipCleared', 'GameTooltip_OnTooltipCleared')
	mod:SecureHookScript(GameTooltip, 'OnUpdate', 'RecolorTooltipStyle')
	hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", mod.SetupStyleAndShadow)
end

BUI:RegisterModule(mod:GetName())