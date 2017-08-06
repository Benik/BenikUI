local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadRecountProfile()
	local font
	if E.private.benikui.expressway == true then
		font = "Expressway"
	else
		font = "Bui Prototype"
	end

	RecountDB['profiles']['BenikUI'] = {
		['Colors'] = {
			['Other Windows'] = {
				['Title Text'] = {
					['g'] = 0.5,
					['b'] = 0,
				},
			},
			['Window'] = {
				['Title Text'] = {
					['g'] = 0.5,
					['b'] = 0,
				},
			},
			['Bar'] = {
				['Bar Text'] = {
					['a'] = 1,
				},
				['Total Bar'] = {
					['a'] = 1,
				},
			},
		},
		['DetailWindowY'] = 0,
		['DetailWindowX'] = 0,
		['GraphWindowX'] = 0,
		['Locked'] = true,
		['FrameStrata'] = '2-LOW',
		['BarTextColorSwap'] = true,
		['BarTexture'] = 'BuiEmpty',
		['CurDataSet'] = 'OverallData',
		['ClampToScreen'] = true,
		['Font'] = font,
	}
	Recount.db:SetProfile("BenikUI")
end