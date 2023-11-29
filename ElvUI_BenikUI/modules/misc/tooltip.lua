local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Tooltip')
local TT = E:GetModule('Tooltip')
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs
local GameTooltip, GameTooltipStatusBar = _G.GameTooltip, _G.GameTooltipStatusBar
local IsAddOnLoaded = IsAddOnLoaded

local function StyleTooltip()
	if GameTooltip.style then return end
	GameTooltip:BuiStyle('Outside')
	GameTooltip.style:SetClampedToScreen(true)

	GameTooltipStatusBar:SetFrameLevel(GameTooltip.style:GetFrameLevel() +2)

	-- FreebTip support
	if BUI:IsAddOnEnabled('FreebTip') then
		GameTooltip.style:ClearAllPoints()
		GameTooltip.style:Point('TOPLEFT', GameTooltip, 'TOPLEFT', (E.PixelMode and 1 or 0), (E.PixelMode and -1 or 7))
		GameTooltip.style:Point('BOTTOMRIGHT', GameTooltip, 'TOPRIGHT', (E.PixelMode and -1 or 0), (E.PixelMode and -6 or 1))
	end
end

local function StyleCagedBattlePetTooltip(tooltipFrame)
	if not tooltipFrame.style then
		tooltipFrame:BuiStyle("Outside")
	end
end

local tooltips = {
	_G.EmbeddedItemTooltip,
	_G.FriendsTooltip,
	_G.ItemRefTooltip,
	_G.ShoppingTooltip1,
	_G.ShoppingTooltip2,
	_G.ShoppingTooltip3,
	_G.FloatingBattlePetTooltip,
	_G.FloatingPetBattleAbilityTooltip,
	_G.FloatingGarrisonFollowerAbilityTooltip,
	_G.WarCampaignTooltip,
	_G.GameTooltip,
	_G.ElvUIConfigTooltip,
	_G.ElvUISpellBookTooltip,
	_G.SettingsTooltip,
}

local overlayedTooltips = {
	_G.GameTooltip,
	_G.ShoppingTooltip1,
	_G.ShoppingTooltip2,
	_G.ShoppingTooltip3
}

local function tooltipOverlay(tt) -- Create a blank frame to position the GameTooltip.TopOverlay texture
	if not tt.style then
		return
	end

	if tt.style.blank then
		return
	end

	tt.style.blank = CreateFrame("Frame", nil, tt.style)
	tt.style.blank:Size(6, 6)
	tt.style.blank:Point("BOTTOM", tt.style, "TOP")

	if tt.TopOverlay then
		tt.TopOverlay:SetParent(tt.style.blank)
		tt.TopOverlay:ClearAllPoints()
		tt.TopOverlay:Point("CENTER", tt.style.blank, "CENTER")
	end
end

local function StyleBlizzardTooltips()
	if E.db.benikui.general.benikuiStyle ~= true then return end
	if E.private.skins.blizzard.tooltip then
		for _, tt in pairs(tooltips) do
			if tt and not tt.style then
				tt:BuiStyle("Outside")
			end
		end

		for _, tooltip in pairs(overlayedTooltips) do
			if tooltip then
				tooltipOverlay(tooltip)
			end
		end

		_G.QuestMapFrame.QuestsFrame.StoryTooltip:BuiStyle("Outside")
		_G.QuestScrollFrame.StoryTooltip:BuiStyle("Outside")
		_G.QuestScrollFrame.CampaignTooltip:BuiStyle("Outside")

		local shoppingTooltips = {_G.WorldMapCompareTooltip1, _G.WorldMapCompareTooltip2}
		for _, tooltip in pairs(shoppingTooltips) do
			if not tooltip.style then
				tooltip:BuiStyle("Outside")
			end
		end
	end
end
S:AddCallback("BenikUI_StyleBlizzardTooltips", StyleBlizzardTooltips)

local ttr, ttg, ttb = 0, 0, 0
function mod:CheckTooltipStyleColor()
	if not GameTooltip.style then return end

	local r, g, b = GameTooltip.style:GetBackdropColor()
	ttr, ttg, ttb = r, g, b
end

function mod:GameTooltip_OnTooltipCleared(tt)
	if tt:IsForbidden() then return end
	tt.buiUpdated = nil
end

function mod:RecolorTooltipStyle()
	if not GameTooltip.style then return end
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
	if not tt.StatusBar then return end

	if tt.style then
		if tt.StatusBar.anchoredToTop or E.db.benikui.general.hideStyle then
			tt.style:Hide()
		else
			tt.style:Show()
		end
	end

	if BUI.ShadowMode then
		if tt.StatusBar.backdrop and not tt.StatusBar.backdrop.shadow then
			tt.StatusBar.backdrop:CreateSoftShadow()
		end
		if TT.db.healthBar.statusPosition == 'BOTTOM' then
			tt.StatusBar:ClearAllPoints()
			tt.StatusBar:Point('TOPLEFT', tt, 'BOTTOMLEFT', E.Border, -(E.Spacing * 3)-3)
			tt.StatusBar:Point('TOPRIGHT', tt, 'BOTTOMRIGHT', -E.Border, -(E.Spacing * 3)-3)
		end
	end
end

function mod:StyleAceTooltip()
	if not self.style then
		self:BuiStyle('Outside')
	end
end
hooksecurefunc(S, "Ace3_StyleTooltip", mod.StyleAceTooltip)

function mod:Initialize()
	if E.db.benikui.general.benikuiStyle ~= true or E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tooltip ~= true then return end

	if BUI:IsAddOnEnabled('TinyTooltip') or BUI:IsAddOnEnabled('TipTac') then return end

	StyleTooltip()

	mod:CheckTooltipStyleColor()
	mod:SecureHookScript(GameTooltip, 'OnTooltipCleared', 'GameTooltip_OnTooltipCleared')
	mod:SecureHookScript(GameTooltip, 'OnUpdate', 'RecolorTooltipStyle')
	hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", mod.SetupStyleAndShadow)
	hooksecurefunc("BattlePetTooltipTemplate_SetBattlePet", StyleCagedBattlePetTooltip)
end

BUI:RegisterModule(mod:GetName())
