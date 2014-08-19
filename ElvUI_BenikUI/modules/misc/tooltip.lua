local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

function BUI:StyleTooltip()
	GameTooltip:Style('Outside', 'GameTooltipDecor')
	GameTooltipDecor:SetClampedToScreen(true)
	GameTooltipStatusBar:SetStatusBarTexture(E["media"].BuiFlat)
end