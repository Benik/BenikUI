local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');

function BUI:LoadSkadaProfile()
	local font, fontsize
	if E.private.benikui.expressway == true then
		font = "Expressway"
		fontsize = 11
	else
		font = "Bui Prototype"
		fontsize = 10
	end
	SkadaDB['profiles']['BenikUI'] = {
		["windows"] = {
			{
				["barheight"] = 14,
				["classicons"] = false,
				["barslocked"] = true,
				["barfont"] = font,
				["title"] = {
					["font"] = font,
					["fontsize"] = fontsize,
					["height"] = 18,
				},
				["classcolortext"] = true,
				["barcolor"] = {
					["r"] = 1,
					["g"] = 0.5,
					["b"] = 0,
				},
				["mode"] = "Damage",
				["spark"] = false,
				["barwidth"] = 196.000061035156,
				["barfontsize"] = 10,
				["background"] = {
					["height"] = 122,
				},
				["classcolorbars"] = false,
				["bartexture"] = "BuiOnePixel",
				["point"] = "TOPRIGHT",
			}, -- [1]
			{
				["titleset"] = true,
				["barheight"] = 14,
				["classicons"] = false,
				["barslocked"] = true,
				["enabletitle"] = true,
				["wipemode"] = "",
				["set"] = "current",
				["hidden"] = false,
				["barfont"] = font,
				["name"] = "Skada 2",
				["display"] = "bar",
				["barfontflags"] = "",
				["classcolortext"] = true,
				["scale"] = 1,
				["reversegrowth"] = false,
				["returnaftercombat"] = false,
				["roleicons"] = false,
				["barorientation"] = 1,
				["snapto"] = true,
				["version"] = 1,
				["modeincombat"] = "",
				["clickthrough"] = false,
				["spark"] = false,
				["bartexture"] = "BuiOnePixel",
				["barwidth"] = 201.000091552734,
				["barspacing"] = 0,
				["barfontsize"] = 10,
				["title"] = {
					["color"] = {
						["a"] = 0.8,
						["b"] = 0.3,
						["g"] = 0.1,
						["r"] = 0.1,
					},
					["bordertexture"] = "None",
					["font"] = font,
					["borderthickness"] = 2,
					["fontsize"] = fontsize,
					["fontflags"] = "",
					["height"] = 18,
					["margin"] = 0,
					["texture"] = "Aluminium",
				},
				["background"] = {
					["borderthickness"] = 0,
					["height"] = 122,
					["color"] = {
						["a"] = 0.2,
						["b"] = 0.5,
						["g"] = 0,
						["r"] = 0,
					},
					["bordertexture"] = "None",
					["margin"] = 0,
					["texture"] = "Solid",
				},
				["barcolor"] = {
					["a"] = 1,
					["r"] = 1,
					["g"] = 0.5,
					["b"] = 0,
				},
				["barbgcolor"] = {
					["a"] = 0.6,
					["b"] = 0.3,
					["g"] = 0.3,
					["r"] = 0.3,
				},
				["classcolorbars"] = false,
				["buttons"] = {
					["segment"] = true,
					["menu"] = true,
					["mode"] = true,
					["report"] = true,
					["reset"] = true,
				},
				["point"] = "TOPRIGHT",
				["mode"] = "Healing",
			}, -- [2]
		},
	}
	Skada.db:SetProfile("BenikUI") -- set automatically the profile
end