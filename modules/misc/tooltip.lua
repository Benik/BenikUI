local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

function BUI:StyleTooltip()
	GameTooltip:StyleOnFrame('GameTooltipDecor')
	GameTooltipDecor:SetClampedToScreen(true)
end