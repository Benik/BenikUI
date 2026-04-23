local BUI, E, L, V, P, G = unpack((select(2, ...)))
local mod = BUI:GetModule('Tooltip')
local TT = E:GetModule('Tooltip')
local S = E:GetModule('Skins')

local _G = _G
local pairs = pairs
local ElvUF = E.oUF
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame
local GameTooltip = _G.GameTooltip
local GameTooltipStatusBar = _G.GameTooltipStatusBar

local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitReaction = UnitReaction

local FACTION_BAR_COLORS = FACTION_BAR_COLORS

local classColor = E:ClassColor(E.myclass, true)

local function StyleTooltip()
	if GameTooltip.style then return end
	GameTooltip:BuiStyle()
	GameTooltip.style:SetClampedToScreen(true)

	GameTooltipStatusBar:OffsetFrameLevel(2, GameTooltip.style)
end

local function StyleCagedBattlePetTooltip(tooltipFrame)
	if not tooltipFrame.style then
		tooltipFrame:BuiStyle()
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
	_G.ElvUI_ConfigTooltip,
	_G.ElvUI_SpellBookTooltip,
	_G.ElvUI_ScanTooltip,
	_G.ElvUI_EasyMenu,
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
	if BUI:IsAddOnEnabled('TipTac') then return end

	if E.private.skins.blizzard.tooltip then
		for _, tt in pairs(tooltips) do
			if tt and not tt.style then
				tt:BuiStyle()

				local CompareHeader = tt.CompareHeader
				if CompareHeader then
					CompareHeader:OffsetFrameLevel(2, tt.style)
				end
			end
		end

		for _, tooltip in pairs(overlayedTooltips) do
			if tooltip then
				tooltipOverlay(tooltip)
			end
		end

		local questScroll = _G.QuestScrollFrame
		questScroll.StoryTooltip:BuiStyle()
		questScroll.CampaignTooltip:BuiStyle()

		local shoppingTooltips = {_G.WorldMapCompareTooltip1, _G.WorldMapCompareTooltip2}
		for _, tooltip in pairs(shoppingTooltips) do
			if not tooltip.style then
				tooltip:BuiStyle()
			end
		end
	end
end
S:AddCallback("BenikUI_StyleBlizzardTooltips", StyleBlizzardTooltips)

function mod:GameTooltip_OnTooltipCleared(tt)
	if tt:IsForbidden() then return end
	tt.buiUpdated = nil
end

function mod:RecolorTooltipStyle(tt)
	if not tt.style then return end
	if not tt.buiUpdated then
		local r, g, b = 0, 0, 0

		if tt.StatusBar:IsShown() then
			local _, tooltipUnit = TT:GetDisplayedUnit(tt)
			if tooltipUnit and E:NotSecretValue(tooltipUnit) then
				if UnitIsPlayer(tooltipUnit) then
					local _, tooltipUnitClass = UnitClass(tooltipUnit)
					local tooltipUnitClassColor = tooltipUnitClass and E:ClassColor(tooltipUnitClass, true)

					if tooltipUnitClassColor then
						r, g, b = tooltipUnitClassColor.r, tooltipUnitClassColor.g, tooltipUnitClassColor.b
					else
						r, g, b = tt.StatusBar:GetStatusBarColor()
					end
				else
					local unitReaction = UnitReaction(tooltipUnit, "player")

					if unitReaction then
						local factionColor = TT.db and TT.db.useCustomFactionColors and TT.db.factionColors
						local color = (factionColor and factionColor[unitReaction]) or (ElvUF.colors.reaction[unitReaction]) or FACTION_BAR_COLORS[unitReaction]

						if color then
							r, g, b = color.r, color.g, color.b
						else
							r, g, b = tt.StatusBar:GetStatusBarColor()
						end
					else
						r, g, b = tt.StatusBar:GetStatusBarColor()
					end
				end
			else
				r, g, b = tt.StatusBar:GetStatusBarColor()
			end
		else
			r, g, b = classColor.r, classColor.g, classColor.b
		end

		if (r and g and b) then
			tt.style:SetBackdropColor(r, g, b, (E.db.benikui.colors.styleAlpha or 1))
		end

		tt.buiUpdated = true
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

	if E.db.benikui.general.shadows then
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
		self:BuiStyle()
	end
end
hooksecurefunc(S, "Ace3_StyleTooltip", mod.StyleAceTooltip)

function mod:Initialize()
	if E.db.benikui.general.benikuiStyle ~= true or E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tooltip ~= true then return end

	if BUI:IsAddOnEnabled('TinyTooltip') or BUI:IsAddOnEnabled('TipTac') then return end

	StyleTooltip()

	mod:SecureHookScript(GameTooltip, 'OnTooltipCleared', 'GameTooltip_OnTooltipCleared')
	mod:SecureHookScript(GameTooltip, 'OnUpdate', 'RecolorTooltipStyle')
	hooksecurefunc(TT, "GameTooltip_SetDefaultAnchor", mod.SetupStyleAndShadow)
	hooksecurefunc("BattlePetTooltipTemplate_SetBattlePet", StyleCagedBattlePetTooltip)
end

BUI:RegisterModule(mod:GetName())
