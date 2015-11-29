local E, L, V, P, G = unpack(ElvUI);
local BUI = E:GetModule('BenikUI');
local LSM = LibStub('LibSharedMedia-3.0')

function BUI:EnableBuiFonts()
	if E.db.bui.buiFonts then
		EnableAddOn('ElvUI_BenikUI_Fonts')
	else
		DisableAddOn('ElvUI_BenikUI_Fonts')
	end
end

-- add alpha in shadow color (sa) and moved the r, g, b to the end cause of Blizz auto coloring
local function SetFont(obj, font, size, style, sr, sg, sb, sa, sox, soy, r, g, b)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb, sa) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b)
	elseif r then obj:SetAlpha(r) end
end

-- Add some more fonts
E.UpdateBlizzardFontsBui = E.UpdateBlizzardFonts
function E:UpdateBlizzardFonts()
	self:UpdateBlizzardFontsBui()
	local NORMAL     = self["media"].normFont
	local COMBAT     = LSM:Fetch('font', self.private.general.dmgfont)
	local NUMBER     = self["media"].normFont
	local NAMEFONT		 = LSM:Fetch('font', self.private.general.namefont)
	local MONOCHROME = ''
	local SHADOWCOLOR = 0, 0, 0, .4 	-- add alpha for shadows
	local NO_OFFSET = 0, 0
	local NORMALOFFSET = 1.25, -1.25 	-- shadow offset for small fonts
	local BIGOFFSET = 2, -2 			-- shadow offset for large fonts

	CHAT_FONT_HEIGHTS = {10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
	
	if self.private.general.replaceBlizzFonts then
		-- Base fonts
		--SetFont(NumberFontNormal,					LSM:Fetch('font', 'ElvUI Pixel'), 10, 'MONOCHROMEOUTLINE', 1, 1, 1, 0, 0, 0)
		SetFont(GameTooltipHeader,                  NORMAL, self.db.general.fontSize)
		SetFont(NumberFont_OutlineThick_Mono_Small, NUMBER, self.db.general.fontSize, "OUTLINE")
		SetFont(SystemFont_Shadow_Large_Outline,	NUMBER, 20, "OUTLINE")
		SetFont(NumberFont_Outline_Huge,            NUMBER, 28, MONOCHROME.."THICKOUTLINE", 28)
		SetFont(NumberFont_Outline_Large,           NUMBER, 15, MONOCHROME.."OUTLINE")
		SetFont(NumberFont_Outline_Med,             NUMBER, self.db.general.fontSize*1.1, "OUTLINE")
		SetFont(NumberFont_Shadow_Med,              NORMAL, self.db.general.fontSize) --chat editbox uses this
		SetFont(NumberFont_Shadow_Small,            NORMAL, self.db.general.fontSize)
		SetFont(QuestFont,                          NORMAL, self.db.general.fontSize)
		SetFont(QuestFont_Large,                    NORMAL, 14)
		SetFont(SystemFont_Large,                   NORMAL, 15)
		SetFont(GameFontNormalMed3,					NORMAL, 15)
		SetFont(SystemFont_Shadow_Huge1,			NORMAL, 20, MONOCHROME.."OUTLINE") -- Raid Warning, Boss emote frame too
		SetFont(SystemFont_Med1,                    NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Med3,                    NORMAL, self.db.general.fontSize*1.1)
		SetFont(SystemFont_OutlineThick_Huge2,      NORMAL, 20, MONOCHROME.."THICKOUTLINE")
		SetFont(SystemFont_Outline_Small,           NUMBER, self.db.general.fontSize, "OUTLINE")
		SetFont(SystemFont_Shadow_Large,            NORMAL, 15)
		SetFont(SystemFont_Shadow_Med1,             NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Shadow_Med3,             NORMAL, self.db.general.fontSize*1.1)
		SetFont(SystemFont_Shadow_Outline_Huge2,    NORMAL, 20, MONOCHROME.."OUTLINE")
		SetFont(SystemFont_Shadow_Small,            NORMAL, self.db.general.fontSize*0.9)
		SetFont(SystemFont_Small,                   NORMAL, self.db.general.fontSize)
		SetFont(SystemFont_Tiny,                    NORMAL, self.db.general.fontSize)
		SetFont(Tooltip_Med,                        NORMAL, self.db.general.fontSize)
		SetFont(Tooltip_Small,                      NORMAL, self.db.general.fontSize)
		SetFont(ZoneTextString,						NORMAL, 32, MONOCHROME.."OUTLINE")
		SetFont(SubZoneTextString,					NORMAL, 25, MONOCHROME.."OUTLINE")
		SetFont(PVPInfoTextString,					NORMAL, 22, MONOCHROME.."OUTLINE")
		SetFont(PVPArenaTextString,					NORMAL, 22, MONOCHROME.."OUTLINE")
		SetFont(CombatTextFont,                     COMBAT, 200, "OUTLINE") -- number here just increase the font quality.
		SetFont(FriendsFont_Normal, NORMAL, self.db.general.fontSize)
		SetFont(FriendsFont_Small, NORMAL, self.db.general.fontSize)
		SetFont(FriendsFont_Large, NORMAL, self.db.general.fontSize)
		SetFont(FriendsFont_UserText, NORMAL, self.db.general.fontSize)
		
		-- new fonts subs
		SetFont(QuestFont_Shadow_Huge, 				NORMAL, 15, nil, SHADOWCOLOR, NORMALOFFSET); -- Quest Title
		SetFont(QuestFont_Shadow_Small, 			NORMAL, 14, nil, SHADOWCOLOR, NORMALOFFSET);
		SetFont(SystemFont_Outline, 				NORMAL, 13, MONOCHROME.."OUTLINE");			 -- Pet level on World map
		SetFont(SystemFont_OutlineThick_WTF,		NORMAL, 32, MONOCHROME.."OUTLINE");			 -- World Map
		SetFont(SubZoneTextFont,					NORMAL, 24, MONOCHROME.."OUTLINE");			 -- World Map(SubZone)
		SetFont(QuestFont_Super_Huge,				NORMAL, 22, nil, SHADOWCOLOR, BIGOFFSET);
		SetFont(QuestFont_Huge,						NORMAL, 15, nil, SHADOWCOLOR, BIGOFFSET);	 -- Quest rewards title(Rewards)
		SetFont(CoreAbilityFont,					NORMAL, 26);								 -- Core abilities(title)
		SetFont(MailFont_Large,						NORMAL, 14);								 -- mail
		SetFont(InvoiceFont_Med,					NORMAL, 12);								 -- mail
		SetFont(InvoiceFont_Small,					NORMAL, self.db.general.fontSize);			 -- mail
		SetFont(AchievementFont_Small,				NORMAL, self.db.general.fontSize);			 -- Achiev dates
		SetFont(ReputationDetailFont,				NORMAL, self.db.general.fontSize);			 -- Rep Desc when clicking a rep
		SetFont(GameFontNormalMed2,					NORMAL, self.db.general.fontSize*1.1);		 -- Quest tracker
		SetFont(BossEmoteNormalHuge,				NORMAL, 24);								 -- Talent Title
		SetFont(GameFontHighlightMedium,			NORMAL, 15);								 -- Fix QuestLog Title mouseover
		SetFont(GameFontNormalLarge2,				NORMAL, 15); 								 -- Garrison Follower Names
		SetFont(QuestFont_Enormous, 				NORMAL, 24, nil, SHADOWCOLOR, NORMALOFFSET); -- Garrison Titles
		SetFont(DestinyFontHuge,					NORMAL, 20, nil, SHADOWCOLOR, BIGOFFSET);	 -- Garrison Mission Report
		SetFont(Game24Font, 						NORMAL, 24);								 -- Garrison Mission level (in detail frame)		
		SetFont(SystemFont_Huge1, 					NORMAL, 20);								 -- Garrison Mission XP
		SetFont(SystemFont_Huge1_Outline, 			NORMAL, 18, MONOCHROME.."OUTLINE");			 -- Garrison Mission Chance
		--SetFont(GameFontHighlightMed2, 				NORMAL, self.db.general.fontSize*1.1);		
		--SetFont(GameFontNormalSmall, 				NORMAL, 10);
		--SetFont(GameFontHighlightSmall, 			NORMAL, 10);
		--SetFont(GameFontHighlight, 					NORMAL, self.db.general.fontSize);
		--SetFont(GameFontHighlightLarge,				NORMAL, 15);
		--SetFont(GameFontNormalHuge,					NORMAL, 16);		
		
		--SetFont(SystemFont_InverseShadow_Small, 	NORMAL, 10);


		--SetFont(SystemFont_OutlineThick_Huge4,		NORMAL, 26);
		--SetFont(QuestTitleFont,						NORMAL, 16);
		--SetFont(GameFont_Gigantic,					NORMAL, 32, nil, SHADOWCOLOR, BIGOFFSET);
		--SetFont(GameFontHighlightLarge2,			NORMAL, 14);

		--SetFont(DestinyFontLarge,					NORMAL, 14);
	end
end