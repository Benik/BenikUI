local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadPawnProfile()
	-- Disable the tooltip item update coloring, cause it doesn't fit with BenikUI style
	PawnCommon["ColorTooltipBorder"] = false
end