local BUI, E, L, V, P, G = unpack(select(2, ...))

BUI.Currency = {}

local SECONDARY_SKILLS = SECONDARY_SKILLS
local GROUP_FINDER, PLAYER_V_PLAYER, MISCELLANEOUS = GROUP_FINDER, PLAYER_V_PLAYER, MISCELLANEOUS
local EXPANSION_NAME8 = EXPANSION_NAME8
local EXPANSION_NAME7 = EXPANSION_NAME7
local EXPANSION_NAME6 = EXPANSION_NAME6
local EXPANSION_NAME5 = EXPANSION_NAME5
local EXPANSION_NAME4 = EXPANSION_NAME4
local EXPANSION_NAME0 = EXPANSION_NAME0

local secondaryTokensName = SECONDARY_SKILLS:gsub(':', '')

local dungeonTokens = {
	1166, 	-- Timewarped Badge (6.22)
}

local pvpTokens = {
	391,	-- Tol Barad Commendation
	1602,	-- Conquest
	1792,	-- Honor
}

local secondaryTokens = {
	81,		-- Epicurean's Award
	402,	-- Ironpaw Token
	61,		-- Dalaran Jewelcrafter's Token
	361,	-- Illustrious Jewelcrafter's Token
}

local miscTokens = {
	241,	-- Champion's Seal
	416,	-- Mark of the World Tree
	515,	-- Darkmoon Prize Ticket
	789,	-- Bloody Coin
}

local mopTokens = {
	697,	-- Elder Charm of Good Fortune
	738,	-- Lesser Charm of Good Fortune
	776,	-- Warforged Seal
	777,	-- Timeless Coin
}

local wodTokens = {
	824,	-- Garrison Resources
	823,	-- Apexis Crystal (for gear, like the valors)
	994,	-- Seal of Tempered Fate (Raid loot roll)
	980,	-- Dingy Iron Coins (rogue only, from pickpocketing)
	944,	-- Artifact Fragment (PvP)
	1101,	-- Oil
	1129,	-- Seal of Inevitable Fate
	1191, 	-- Valor Points (6.23)
}

local legionTokens = {
	1155,	-- Ancient Mana
	1220,	-- Order Resources
	1275,	-- Curious Coin (Buy stuff :P)
	1226,	-- Nethershard (Invasion scenarios)
	1273,	-- Seal of Broken Fate (Raid)
	1154,	-- Shadowy Coins
	1149,	-- Sightless Eye (PvP)
	1268,	-- Timeworn Artifact (Honor Points?)
	1299,	-- Brawler's Gold
	1314,	-- Lingering Soul Fragment (Good luck with this one :D)
	1342,	-- Legionfall War Supplies (Construction at the Broken Shore)
	1355,	-- Felessence (Craft Legentary items)
	1356,	-- Echoes of Battle (PvP Gear)
	1357,	-- Echoes of Domination (Elite PvP Gear)
	1416,	-- Coins of Air
	1508,	-- Veiled Argunite
	1533,	-- Wakening Essence
}

local bfaTokens = {
	1560, -- War Resources
	1580,	-- Seal of Wartorn Fate
	1587,	-- War Supplies
	1710,	-- Seafarer's Dubloon
	1718,	-- Titan Residuum
	1719,	-- Corrupted Memento
	1721,	-- Prismatic Manapearl
	1755,	-- Coalescing Visions
	1803,	-- Echoes of Ny'alotha
}

local slTokens = {
	1751,	-- Freed Soul
	1754,	-- Argent Commendation
	1767,   -- Stygia
	1810,	-- Willing Soul
	1813,	-- Reservoir Anima
	1816,   -- Sinstone Fragments
	1820,	-- Infused Ruby
	1822,	-- Renown
	1828, 	-- Soul Ash
	1885,   -- Grateful Offering
}

-- Archaeology tokens
local archyClassic = {
	384,	-- Dwarf Archaeology Fragment
	385,	-- Troll Archaeology Fragment
	393,	-- Fossil Archaeology Fragment
	394,	-- Night Elf Archaeology Fragment
	397,	-- Orc Archaeology Fragment
	398,	-- Draenei Archaeology Fragment
	399,	-- Vrykul Archaeology Fragment
	400,	-- Nerubian Archaeology Fragment
	401,	-- Tol'vir Archaeology Fragment
}

local archyMop = {
	676,	-- Pandaren Archaeology Fragment
	677,	-- Mogu Archaeology Fragment
	754,	-- Mantid Archaeology Fragment
}

local archyWod = {
	821,	-- Draenor Clans Archaeology Fragment
	828,	-- Ogre Archaeology Fragment
	829,	-- Arakkoa Archaeology Fragment
}

local archyLegion = {
	1172,	-- Highborne Archaeology Fragment
	1173,	-- Highmountain Tauren Archaeology Fragment
	1174,	-- Demonic Archaeology Fragment
}

local archyBfa = {
	1534,	-- Zandalari Archaeology Fragment
	1535,	-- Drust Archaeology Fragment
}

do
	if E.myfaction == 'Alliance' then
		tinsert(bfaTokens, 1717) -- 7th Legion Service Medal (Alliance)
	elseif E.myfaction == 'Horde' then
		tinsert(bfaTokens, 1716) -- Honorbound Service Medal (Horde)
	end
end

BUI.currencyTables = {
	-- table, option, name
	{dungeonTokens, 'dungeonTokens', GROUP_FINDER},
	{pvpTokens, 'pvpTokens', PLAYER_V_PLAYER},
	{slTokens, 'slTokens', EXPANSION_NAME8},
	{bfaTokens, 'bfaTokens', EXPANSION_NAME7},
	{legionTokens, 'legionTokens', EXPANSION_NAME6},
	{wodTokens, 'wodTokens', EXPANSION_NAME5},
	{mopTokens, 'mopTokens', EXPANSION_NAME4},
	{secondaryTokens, 'secondaryTokens', secondaryTokensName},
	{miscTokens, 'miscTokens', MISCELLANEOUS},
}

BUI.archyTables = {
	-- table, option, name
	{archyClassic, 'classic', EXPANSION_NAME0},
	{archyMop, 'mop', EXPANSION_NAME4},
	{archyWod, 'wod', EXPANSION_NAME5},
	{archyLegion, 'legion', EXPANSION_NAME6},
	{archyBfa, 'bfa', EXPANSION_NAME7},
}

for _, v in ipairs(BUI.currencyTables) do
	local tableName = unpack(v)
	for _, id in ipairs(tableName) do
		tinsert(BUI.Currency, id)
	end
end

for _, v in ipairs(BUI.archyTables) do
	local tableName = unpack(v)
	for _, id in ipairs(tableName) do
		tinsert(BUI.Currency, id)
	end
end