local BUI, E, L, V, P, G = unpack(select(2, ...))
local mod = BUI:GetModule('Skins')
local S = E:GetModule('Skins')

local _G = _G
local pairs, unpack = pairs, unpack
local CreateFrame = CreateFrame
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn
local InCombatLockdown = InCombatLockdown

-- GLOBALS: hooksecurefunc


local SPACING = (E.PixelMode and 1 or 3)

-- SpellBook tabs shadow
local function styleSpellbook()
	if E.private.skins.blizzard.enable ~= true or BUI.ShadowMode ~= true or E.private.skins.blizzard.spellbook ~= true then
		return
	end

	hooksecurefunc("SpellBookFrame_UpdateSkillLineTabs",
		function()
			for i = 1, MAX_SKILLLINE_TABS do
				local tab = _G['SpellBookSkillLineTab'..i]
				tab.backdrop:CreateSoftShadow()
			end
		end)
end
S:AddCallback("BenikUI_Spellbook", styleSpellbook)

-- WorldMap
local function styleWorldMap()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.worldmap ~= true then
		return
	end

	local mapFrame = _G.WorldMapFrame
	if not mapFrame.backdrop.style then
		mapFrame.backdrop:Style("Outside")
	end
end



local function StyleDBM_Options()
	if not E.db.benikuiSkins.addonSkins.dbm or not BUI.AS then
		return
	end

	DBM_GUI_OptionsFrame:HookScript(
		"OnShow",
		function()
			DBM_GUI_OptionsFrame:Style("Outside")
		end
	)
end

local function StyleAltPowerBar()
	if E.db.general.altPowerBar.enable ~= true then
		return
	end

	local bar = _G.ElvUI_AltPowerBar
	bar:Style("Outside")
	if bar.textures then
		bar:StripTextures(true)
	end
end

local function StyleInFlight()
	if E.db.benikuiSkins.variousSkins.inflight ~= true or E.db.benikui.misc.flightMode == true then
		return
	end

	local frame = _G.InFlightBar
	if frame then
		if not frame.isStyled then
			frame:CreateBackdrop("Transparent")
			frame.backdrop:Style("Outside")
			frame.isStyled = true
		end
	end
end

local function LoadInFlight()
	local f = CreateFrame("Frame")
	f:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
	f:RegisterEvent("UPDATE_MULTI_CAST_ACTIONBAR")
	f:SetScript(
		"OnEvent",
		function(self, event)
			if event then
				StyleInFlight()
				f:UnregisterEvent(event)
			end
		end
	)
end

local function VehicleExit()
	if E.private.actionbar.enable ~= true then
		return
	end
	local f = _G.MainMenuBarVehicleLeaveButton
	f:SetNormalTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	f:SetPushedTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	f:SetHighlightTexture("Interface\\AddOns\\ElvUI_BenikUI\\media\\textures\\flightMode\\arrow")
	if MasqueGroup and E.private.actionbar.masque.actionbars then return end
	f:GetNormalTexture():SetTexCoord(0, 1, 0, 1)
	f:GetPushedTexture():SetTexCoord(0, 1, 0, 1)
end

function mod:LoD_AddOns(_, addon)
	if addon == "DBM-GUI" then
		StyleDBM_Options()
	end
	if addon == "InFlight" then
		LoadInFlight()
	end
end

function mod:PLAYER_ENTERING_WORLD(...)

	styleWorldMap()

	self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function mod:Initialize()
	VehicleExit()

	if E.db.benikui.general.benikuiStyle ~= true then return end

	mod:SkinDecursive()
	mod:SkinStoryline()

	StyleAltPowerBar()

	self:RegisterEvent("PLAYER_ENTERING_WORLD")
	self:RegisterEvent("ADDON_LOADED", "LoD_AddOns")
end

BUI:RegisterModule(mod:GetName())