local BUI, E, L, V, P, G = unpack((select(2, ...)))
local LSM = E.LSM

local _G = _G

-- add alpha in shadow color (sa) and moved the r, g, b to the end cause of Blizz auto coloring
-- some fonts like Fancy32Font or Fancy30Font are kinda big so I adjusted their size -2
local function SetFont(obj, font, size, style, sr, sg, sb, sa, sox, soy, r, g, b)
	obj:SetFont(font, size,  '')
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb, sa) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

-- Add some more fonts
function BUI:UpdateBlizzardFonts()
	local NORMAL     = E["media"].normFont
	local SHADOWCOLOR = 0, 0, 0, .4 	-- add alpha for shadows
	local NO_OFFSET = 0, 0
	local NORMALOFFSET = 1.25, -1.25 	-- shadow offset for small fonts
	local BIGOFFSET = 2, -2 			-- shadow offset for large fonts

	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	if E.private.general.replaceBlizzFonts then
		SetFont(_G.Fancy16Font, 						NORMAL, 14);								-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy18Font, 						NORMAL, 16);								-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy20Font, 						NORMAL, 18);								-- Mythic Chest
		SetFont(_G.Fancy27Font, 						NORMAL, 25);								-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy30Font, 						NORMAL, 28);								-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy32Font, 						NORMAL, 30);								-- Allied Races Blizzard tryout font
		SetFont(_G.Game20Font, 							NORMAL, 20);								-- WarboardUI Options
		SetFont(_G.GameFont_Gigantic,					NORMAL, 32, nil, SHADOWCOLOR, BIGOFFSET)	-- Used at the install steps
		SetFont(_G.WhiteNormalNumberFont,				NORMAL, E.db.general.fontSize);				-- Statusbar Numbers on TradeSkill frame
		SetFont(_G.Fancy40Font,							NORMAL, 40);								-- MajorFaction
		SetFont(_G.Fancy48Font,							NORMAL, 42);								-- ExpansionLandingPage, 48 is way too big
	end
end
hooksecurefunc(E, "UpdateBlizzardFonts", BUI.UpdateBlizzardFonts)