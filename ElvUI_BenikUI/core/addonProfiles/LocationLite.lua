local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadLocationLiteProfile()
	if E.db.loclite == nil then E.db.loclite = {} end
	E.db["loclite"]["dtheight"] = 16
	E.db["loclite"]["lpfontsize"] = 10
	E.db["loclite"]["trunc"] = true
	E.db["loclite"]["lpwidth"] = 220
	E.db["loclite"]["lpfontflags"] = "MONOCROMEOUTLINE"
	E.db["loclite"]["lpauto"] = false
	E.db["loclite"]["lpfont"] = "Bui Visitor1"
	E.db["movers"]["LocationLiteMover"] = "TOP,ElvUIParent,TOP,0,-7"
end