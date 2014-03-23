local E, L, V, P, G, _ = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore

if not E.db.fbf.forceBuiFonts then return end

BenikFont = CreateFrame("Frame", "BenikFont");
local benikUIfont = "Interface\\AddOns\\ElvUI_BenikUI\\media\\fonts\\PROTOTYPE.TTF"

function BenikFont:ApplySystemFonts()
	DAMAGE_TEXT_FONT = benikUIfont;
	UNIT_NAME_FONT = benikUIfont;
end

BenikFont:SetScript("OnEvent", function() 
	if (event == "ADDON_LOADED") then
		BenikFont:ApplySystemFonts()
	end
end);

BenikFont:RegisterEvent("ADDON_LOADED");
BenikFont:ApplySystemFonts()

