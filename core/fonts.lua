local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local BUI = E:GetModule('BenikUI');

function BUI:EnableBuiFonts()
	if E.db.bui.buiFonts then
		EnableAddOn("ElvUI_BenikUI_Fonts")
	else
		DisableAddOn("ElvUI_BenikUI_Fonts")
	end
end
