local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadSMBProfile()
	if BUI.SLE then return end
	if SquareMinimapButtonsDB["profiles"]["BenikUI"] == nil then SquareMinimapButtonsDB["profiles"]["BenikUI"] = {} end
	SquareMinimapButtonsDB["profiles"]["BenikUI"]['BarEnabled'] = true
	SquareMinimapButtonsDB["profiles"]["BenikUI"]['ButtonsPerRow'] = 6
	SquareMinimapButtonsDB["profiles"]["BenikUI"]['IconSize'] = 22
	SquareMinimapButtonsDB["profiles"]["BenikUI"]['ButtonSpacing'] = 4
	E.db["movers"]["SquareMinimapButtonBarMover"] = "TOPRIGHT,ElvUIParent,TOPRIGHT,-4,-258"

	_G.SquareMinimapButtons.data:SetProfile("BenikUI")
end