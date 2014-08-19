local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');
local DT = E:GetModule('DataTexts')

DT.SetupTooltipBui = DT.SetupTooltip
function DT:SetupTooltip(panel)
	self:SetupTooltipBui(panel)
	self.tooltip:Style('Outside')
end