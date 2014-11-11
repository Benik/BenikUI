
local benikUIfont = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function()
	DAMAGE_TEXT_FONT = benikUIfont;
	UNIT_NAME_FONT = benikUIfont;
	f:UnregisterEvent("ADDON_LOADED")
end)
