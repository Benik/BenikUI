local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadLocationLiteProfile()
	if E.db.loclite == nil then E.db.loclite = {} end
	E.db["loclite"]["trunc"] = true
	E.db["loclite"]["lpwidth"] = 220
	E.db["loclite"]["lpauto"] = false
	E.db["movers"]["LocationLiteMover"] = "TOP,ElvUIParent,TOP,0,-7"
	if E.private.benikui.expressway == true then
		E.db["loclite"]["dtheight"] = 18
		E.db["loclite"]["lpfont"] = "Expressway"
		E.db["loclite"]["lpfontflags"] = "NONE"
		E.db["loclite"]["lpfontsize"] = 11
	else
		E.db["loclite"]["dtheight"] = 16
		E.db["loclite"]["lpfont"] = "Bui Visitor1"
		E.db["loclite"]["lpfontflags"] = "MONOCROMEOUTLINE"
		E.db["loclite"]["lpfontsize"] = 10
	end
end