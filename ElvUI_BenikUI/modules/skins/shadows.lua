local E, L, V, P, G = unpack(ElvUI);
local BUIS = E:GetModule('BuiSkins')

local _G = _G
-- GLOBALS: MIRRORTIMER_NUMTIMERS

local function mirrorTimersShadows()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.mirrorTimers ~= true then return end

	for i = 1, MIRRORTIMER_NUMTIMERS do
		local statusBar = _G['MirrorTimer'..i..'StatusBar']
		statusBar.backdrop:CreateSoftShadow()
	end
end

local function raidUtilityShadows()
	if E.private.general.raidUtility == false then return end

	if _G["RaidUtility_ShowButton"] then
		_G["RaidUtility_ShowButton"]:CreateSoftShadow()
	end

	if _G["RaidUtilityPanel"] then
		_G["RaidUtilityPanel"]:CreateSoftShadow()
	end
end

function BUIS:Shadows()
	if E.db.benikui.general.shadows ~= true then return end

	raidUtilityShadows()
	mirrorTimersShadows()
end
