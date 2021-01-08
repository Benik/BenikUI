local BUI, E, L, V, P, G = unpack(select(2, ...))

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

BUI.archyTables = {
	-- table, option, name
	{archyClassic, 'classic', EXPANSION_NAME0},
	{archyMop, 'mop', EXPANSION_NAME4},
	{archyWod, 'wod', EXPANSION_NAME5},
	{archyLegion, 'legion', EXPANSION_NAME6},
	{archyBfa, 'bfa', EXPANSION_NAME7},
}