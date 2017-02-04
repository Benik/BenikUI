local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadLocationPlusProfile()
	E.db["locplus"]["both"] = false
	E.db["locplus"]["displayOther"] = "NONE"
	E.db["locplus"]["dtheight"] = 16
	E.db["locplus"]["dtwidth"] = 120
	E.db["locplus"]["hidecoords"] = false
	E.db["locplus"]["lpauto"] = false
	E.db["locplus"]["lpfont"] = "Bui Visitor1"
	E.db["locplus"]["lpfontflags"] = "MONOCROMEOUTLINE"
	E.db["locplus"]["lpfontsize"] = 10
	E.db["locplus"]["lpwidth"] = 220
	E.db["locplus"]["trunc"] = true
	E.db["movers"]["LocationMover"] = "TOP,ElvUIParent,TOP,0,-7"
end