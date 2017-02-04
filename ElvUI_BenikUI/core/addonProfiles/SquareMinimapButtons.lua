local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadSMBProfile()
	SquareMinimapButtonOptions['BarEnabled'] = true
	SquareMinimapButtonOptions['ButtonsPerRow'] = 6
	SquareMinimapButtonOptions['IconSize'] = 22
	SquareMinimapButtonOptions['ButtonSpacing'] = 1
	E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-258"
end