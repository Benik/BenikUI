local BUI, E, L, V, P, G = unpack(select(2, ...))
local LSM = E.LSM

local _G = _G

-- add alpha in shadow color (sa) and moved the r, g, b to the end cause of Blizz auto coloring
-- some fonts like Fancy32Font or Fancy30Font are kinda big so I adjusted their size -2
local function SetFont(obj, font, size, style, sr, sg, sb, sa, sox, soy, r, g, b)
	if not obj then return end
	obj:SetFont(font, size, style)

	if sr and sg and sb then
		obj:SetShadowColor(sr, sg, sb, sa)
	end

	if sox and soy then
		obj:SetShadowOffset(sox, soy)
	end

	if r and g and b then
		obj:SetTextColor(r, g, b)
	elseif r then
		obj:SetAlpha(r)
	end
end

-- Add some more fonts
function BUI:UpdateBlizzardFonts()
	local SHADOWCOLOR = 0, 0, 0, .4 	-- add alpha for shadows
	local NO_OFFSET = 0, 0
	local NORMALOFFSET = 1.25, -1.25 	-- shadow offset for small fonts
	local BIGOFFSET = 2, -2 			-- shadow offset for large fonts
	local NORMAL		= E.media.normFont
	local NUMBER		= E.media.normFont
	local COMBAT		= LSM:Fetch('font', E.private.general.dmgfont)
	local NAMEFONT		= LSM:Fetch('font', E.private.general.namefont)
	local BUBBLE		= LSM:Fetch('font', E.private.general.chatBubbleFont)

	local mono			= strmatch(E.db.general.fontStyle, 'MONOCHROME') and 'MONOCHROME' or ''
	local thick			= mono..'THICKOUTLINE'
	local outline		= mono..'OUTLINE'

	CHAT_FONT_HEIGHTS = {8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	if E.private.general.replaceBlizzFonts then
		SetFont(_G.AchievementFont_Small,				NORMAL, 10)									-- Achiev dates
		SetFont(_G.BossEmoteNormalHuge,					NORMAL, 25)									-- Talent Title
		SetFont(_G.ChatBubbleFont,						BUBBLE, E.private.general.chatBubbleFontSize, E.private.general.chatBubbleFontOutline)
		SetFont(_G.CoreAbilityFont,						NORMAL, 28)		-- 32						-- Core abilities(title)
		SetFont(_G.DestinyFontHuge,						NORMAL, 28)									-- Garrison Mission Report
		SetFont(_G.DestinyFontMed,						NORMAL, 14)									-- Added in 7.3.5 used for ?
		SetFont(_G.Fancy12Font,							NORMAL, 12)									-- Added in 7.3.5 used for ?
		SetFont(_G.Fancy14Font,							NORMAL, 14)									-- Added in 7.3.5 used for ?
		SetFont(_G.Fancy16Font, 						NORMAL, 14)									-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy18Font, 						NORMAL, 16)									-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy20Font, 						NORMAL, 18)									-- Mythic Chest
		SetFont(_G.Fancy22Font,							NORMAL, 22)									-- Talking frame Title font
		SetFont(_G.Fancy24Font,							NORMAL, 24)									-- Artifact frame - weapon name
		SetFont(_G.Fancy27Font, 						NORMAL, 25)									-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy30Font, 						NORMAL, 28)									-- Allied Races Blizzard tryout font
		SetFont(_G.Fancy32Font, 						NORMAL, 30)									-- Allied Races Blizzard tryout font
		SetFont(_G.FriendsFont_11,						NORMAL, 11)
		SetFont(_G.FriendsFont_Large,					NORMAL, 14)
		SetFont(_G.FriendsFont_Normal,					NORMAL, 12)
		SetFont(_G.FriendsFont_Small,					NORMAL, 10)
		SetFont(_G.FriendsFont_UserText,				NORMAL, 11)
		SetFont(_G.Game10Font_o1,						NORMAL, 10, 'OUTLINE')
		SetFont(_G.Game120Font,							NORMAL, 120)
		SetFont(_G.Game12Font,							NORMAL, 12)									-- PVP Stuff
		SetFont(_G.Game13FontShadow,					NORMAL, 13)									-- InspectPvpFrame
		SetFont(_G.Game15Font_o1,						NORMAL, 15)									-- CharacterStatsPane (ItemLevelFrame)
		SetFont(_G.Game16Font,							NORMAL, 16)									-- Added in 7.3.5 used for ?
		SetFont(_G.Game18Font,							NORMAL, 18)									-- MissionUI Bonus Chance
		SetFont(_G.Game20Font, 							NORMAL, 20);								-- WarboardUI Options
		SetFont(_G.Game24Font,							NORMAL, 24)									-- Garrison Mission level (in detail frame)
		SetFont(_G.Game30Font,							NORMAL, 30)									-- Mission Level
		SetFont(_G.Game40Font,							NORMAL, 40)
		SetFont(_G.Game42Font,							NORMAL, 42)									-- PVP Stuff
		SetFont(_G.Game46Font,							NORMAL, 46)									-- Added in 7.3.5 used for ?
		SetFont(_G.Game48Font,							NORMAL, 48)
		SetFont(_G.Game48FontShadow,					NORMAL, 48)
		SetFont(_G.Game60Font,							NORMAL, 60)
		SetFont(_G.Game72Font,							NORMAL, 72)
		SetFont(_G.GameFontHighlightMedium,				NORMAL, 14)									-- Fix QuestLog Title mouseover
		SetFont(_G.GameFontHighlightSmall2,				NORMAL, 11)									-- Skill or Recipe description on TradeSkill frame
		SetFont(_G.GameFontNormalHuge2,					NORMAL, 24)									-- Mythic weekly best dungeon name
		SetFont(_G.GameFontNormalLarge,					NORMAL, 16)
		SetFont(_G.GameFontNormalLarge2,				NORMAL, 18) 								-- Garrison Follower Names
		SetFont(_G.GameFontNormalMed1,					NORMAL, 13)									-- WoW Token Info
		SetFont(_G.GameFontNormalMed2,					NORMAL, 14)									-- Quest tracker
		SetFont(_G.GameFontNormalMed3,					NORMAL, 14)
		SetFont(_G.GameFontNormalSmall2,				NORMAL, 11)									-- MissionUI Followers names
		SetFont(_G.GameFont_Gigantic,					NORMAL, 32)									-- Used at the install steps
		SetFont(_G.GameFont_Gigantic,					NORMAL, 32, nil, SHADOWCOLOR, BIGOFFSET)	-- Used at the install steps
		SetFont(_G.GameTooltipHeader,					NORMAL, E.db.general.fontSize)	-- 14
		SetFont(_G.InvoiceFont_Med,						NORMAL, 12)									-- Mail
		SetFont(_G.InvoiceFont_Small,					NORMAL, 10)									-- Mail
		SetFont(_G.MailFont_Large,						NORMAL, 14)									-- Mail
		SetFont(_G.Number11Font,						NORMAL, 11)
		SetFont(_G.Number11Font,						NUMBER, 11)
		SetFont(_G.Number12Font,						NORMAL, 12)
		SetFont(_G.Number12Font_o1,						NUMBER, 12, 'OUTLINE')
		SetFont(_G.Number13Font,						NUMBER, 13)
		SetFont(_G.Number13FontGray,					NUMBER, 13)
		SetFont(_G.Number13FontWhite,					NUMBER, 13)
		SetFont(_G.Number13FontYellow,					NUMBER, 13)
		SetFont(_G.Number14FontGray,					NUMBER, 14)
		SetFont(_G.Number14FontWhite,					NUMBER, 14)
		SetFont(_G.Number15Font,						NORMAL, 15)
		SetFont(_G.Number18Font,						NUMBER, 18)
		SetFont(_G.Number18FontWhite,					NUMBER, 18)
		SetFont(_G.NumberFontNormalSmall,				NORMAL, 12, 'OUTLINE')						-- Calendar, EncounterJournal
		SetFont(_G.NumberFont_OutlineThick_Mono_Small,	NUMBER, 12, 'OUTLINE')
		SetFont(_G.NumberFont_Outline_Huge,				NUMBER, 30, thick)
		SetFont(_G.NumberFont_Outline_Large,			NUMBER, 16, outline)
		SetFont(_G.NumberFont_Outline_Med,				NUMBER, 14, 'OUTLINE')
		SetFont(_G.NumberFont_Shadow_Med,				NORMAL, 14)									-- Chat EditBox
		SetFont(_G.NumberFont_Shadow_Small,				NORMAL, 12)
		SetFont(_G.PVPArenaTextString,					NORMAL, 22, outline)
		SetFont(_G.PVPInfoTextString,					NORMAL, 22, outline)
		SetFont(_G.PriceFont,							NORMAL, 14)
		SetFont(_G.QuestFont,							NORMAL, E.db.general.fontSize)	-- 13
		SetFont(_G.QuestFont_Enormous, 					NORMAL, 30) 								-- Garrison Titles
		SetFont(_G.QuestFont_Huge,						NORMAL, 18)									-- Quest rewards title(Rewards)
		SetFont(_G.QuestFont_Large,						NORMAL, 14)
		SetFont(_G.QuestFont_Shadow_Huge,				NORMAL, 18) 								-- Quest Title
		SetFont(_G.QuestFont_Shadow_Small,				NORMAL, 14)
		SetFont(_G.QuestFont_Super_Huge,				NORMAL, 24)
		SetFont(_G.ReputationDetailFont,				NORMAL, E.db.general.fontSize)	-- 10		-- Rep Desc when clicking a rep
		SetFont(_G.SpellFont_Small,						NORMAL, 10)
		SetFont(_G.SubSpellFont,						NORMAL, 10)									-- Spellbook Sub Names
		SetFont(_G.SubZoneTextFont,						NORMAL, 24, outline)			-- 26		-- World Map(SubZone)
		SetFont(_G.SubZoneTextString,					NORMAL, 25, outline)			-- 26
		SetFont(_G.SystemFont_Huge1, 					NORMAL, 20)									-- Garrison Mission XP
		SetFont(_G.SystemFont_Huge1_Outline,			NORMAL, 18, outline)			-- 20		-- Garrison Mission Chance
		SetFont(_G.SystemFont_Large,					NORMAL, 16)
		SetFont(_G.SystemFont_Med1,						NORMAL, 12)
		SetFont(_G.SystemFont_Med3,						NORMAL, 14)
		SetFont(_G.SystemFont_Outline,					NORMAL, 13, outline)						-- Pet level on World map
		SetFont(_G.SystemFont_OutlineThick_Huge2,		NORMAL, 22, thick)
		SetFont(_G.SystemFont_OutlineThick_WTF,			NORMAL, 32, outline)						-- World Map
		SetFont(_G.SystemFont_Outline_Small,			NUMBER, 10, 'OUTLINE')
		SetFont(_G.SystemFont_Shadow_Huge1,				NORMAL, 20, outline)						-- Raid Warning, Boss emote frame too
		SetFont(_G.SystemFont_Shadow_Huge3,				NORMAL, 25)									-- FlightMap
		SetFont(_G.SystemFont_Shadow_Huge4,				NORMAL, 27, nil, nil, nil, nil, nil, 1, -1)
		SetFont(_G.SystemFont_Shadow_Large,				NORMAL, 16)
		SetFont(_G.SystemFont_Shadow_Large2,			NORMAL, 18)									-- Auction House ItemDisplay
		SetFont(_G.SystemFont_Shadow_Large_Outline,		NUMBER, 16, 'OUTLINE')
		SetFont(_G.SystemFont_Shadow_Med1,				NORMAL, E.db.general.fontSize)	-- 12
		SetFont(_G.SystemFont_Shadow_Med2,				NORMAL, 14)									-- Shows Order resourses on OrderHallTalentFrame
		SetFont(_G.SystemFont_Shadow_Med3,				NORMAL, 14)
		SetFont(_G.SystemFont_Shadow_Small,				NORMAL, 10)
		SetFont(_G.SystemFont_Small,					NORMAL, 10)
		SetFont(_G.SystemFont_Tiny,						NORMAL, 9)
		SetFont(_G.Tooltip_Med,							NORMAL, E.db.general.fontSize)
		SetFont(_G.Tooltip_Small,						NORMAL, E.db.general.fontSize * 0.9)
		SetFont(_G.WhiteNormalNumberFont,				NORMAL, E.db.general.fontSize);				-- Statusbar Numbers on TradeSkill frame
		SetFont(_G.ZoneTextString,						NORMAL, 32, outline)
	end
end
hooksecurefunc(E, "UpdateBlizzardFonts", BUI.UpdateBlizzardFonts)