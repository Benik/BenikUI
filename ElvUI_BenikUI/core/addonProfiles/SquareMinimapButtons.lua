local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadSMBProfile()
	_G.SquareMinimapButtons.db['BarEnabled'] = true
	_G.SquareMinimapButtons.db['ButtonsPerRow'] = 6
	_G.SquareMinimapButtons.db['IconSize'] = 22
	_G.SquareMinimapButtons.db['ButtonSpacing'] = 4
	E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-258"
end