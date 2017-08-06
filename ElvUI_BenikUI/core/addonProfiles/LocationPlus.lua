local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadLocationPlusProfile()
	if E.db.locplus == nil then E.db.locplus = {} end
	E.db["locplus"]["both"] = false
	E.db["locplus"]["displayOther"] = "NONE"
	E.db["locplus"]["dtwidth"] = 120
	E.db["locplus"]["hidecoords"] = false
	E.db["locplus"]["lpauto"] = false
	E.db["locplus"]["lpwidth"] = 220
	E.db["locplus"]["trunc"] = true
	E.db["movers"]["LocationMover"] = "TOP,ElvUIParent,TOP,0,-7"
	if E.private.benikui.expressway == true then
		E.db["locplus"]["dtheight"] = 18
		E.db["locplus"]["lpfont"] = "Expressway"
		E.db["locplus"]["lpfontflags"] = "NONE"
		E.db["locplus"]["lpfontsize"] = 11
	else
		E.db["locplus"]["dtheight"] = 16
		E.db["locplus"]["lpfont"] = "Bui Visitor1"
		E.db["locplus"]["lpfontflags"] = "MONOCROMEOUTLINE"
		E.db["locplus"]["lpfontsize"] = 10	
	end
end